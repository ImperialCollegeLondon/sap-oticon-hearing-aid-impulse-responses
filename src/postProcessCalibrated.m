function[] = postProcessCalibrated(in_dir,out_dir,in_params)
% function to create calibration-compensated database of full HA-RIRs
%
% Usage:
%  postProcessCalibrated(in_dir,out_dir)
%
% Inputs:
%   in_dir: path where the 'raw' database is located
%  out_dir: path where the 'calibrated' database should be saved
%
% Outputs:
%   [none]
%
% N.B. Microphone channel ordering is changed compared
% to raw database to make auditioning binaural/stereo material easier

check_input_dir_exists(in_dir,true);
check_output_dir_exists(fullfile(out_dir,'mat'));

params.do_plots = 1;

if nargin >2 && ~isempty(in_params)
    params = override_valid_fields(params,in_params);
end

% define the crop points and window lengths
crop.start_time = 0; %seconds
crop.fade_in_duration = 0;%
crop.end_time = 0.290; % seconds
crop.fade_out_duration = 0.01;

hrirnames = {'ha_hrir_0','ha_hrir_n15','ha_hrir_n30'};
chair_rot_deg = [0,-15,-30];
rirnames = {'ha_rir_0','ha_rir_n15','ha_rir_n30'};
fs = 44100;
nSamplesRaw =  32133;

doa_az_deg = [...
    [0:15].*(360/16),...
    [(0:5) .* (360/6)]+30,...
    [(0:5) .* (360/6)]+30,...
    0,...
    ];
doa_el_deg = [...
    zeros(1,16),...
    -45 * ones(1,6),...
     45 * ones(1,6),...
    90,...
    ];
nDoa = length(doa_az_deg); %29

load('saved_calibration.mat',...
    'per_doa_gain','per_doa_delay_comp_s',...
    'per_mic_gain_left_ha',...
    'per_mic_gain_right_ha',...
    'per_subject_head_pos_s');

per_mic_gain = [per_mic_gain_left_ha(:); per_mic_gain_right_ha(:)];

% to arrange microphones in matched pairs with order [front, back, in-ear]
mic_chan_map = [1 4 2 5 3 6];
nMicOut = length(mic_chan_map);




%% this metadata is the same for all subjects
save_data.fs = fs;
save_data.refChanLeft = 1;
save_data.refChanRight = 2;
save_data.channelsLeft = [1 3 5];
save_data.channelsRight = [2 4 6];
save_data.channelsFront = [1 2];
save_data.channelsBack = [3 4];
save_data.channelsInEar = [5 6];


save_data.doa_az_deg = doa_az_deg;
save_data.doa_el_deg = doa_el_deg;
save_data.doa_unit_vec = [...
    cosd(doa_az_deg).*cosd(doa_el_deg);...
    sind(doa_az_deg).*cosd(doa_el_deg);...
    sind(doa_el_deg)]; % [3,nDoa=29]


%%

if params.do_plots
    orig_fig = figure();setFigureSize(orig_fig,[25 22],'centimeters')
    comp_fig = figure();setFigureSize(comp_fig,[25 22],'centimeters')
end  

copyfile(fullfile(in_dir,'mat','metadata.csv'),...
    fullfile(out_dir,'mat','metadata.csv'));
T = readtable(fullfile(in_dir,'mat','metadata.csv'),...
    'Delimiter',',');
nSubject = length(T.subj_id);

reverseStr = '';
for isubject = 1:nSubject
    % loop monitoting
    msg = sprintf('Processing %02d of %02d', isubject,nSubject);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));

    % load in the file in its raw form     
    indata = load(fullfile(in_dir,'mat',sprintf('subject_%02d.mat',T.subj_id(isubject))));
 
    for irot = 1:length(chair_rot_deg)
        
        % copy to local variable
        this_ir = indata.(hrirnames{irot}); % [nSamples,nChans=6, nDoa=29]
        
        % calculate required delay compensation
        this_delay_s =  fcn_20181010_03_time_compensation_per_doa(...
            per_subject_head_pos_s(T.subj_id(isubject),:),...
            chair_rot_deg(irot),... % chair rotation
            doa_az_deg, doa_el_deg);
        this_delay_s = this_delay_s(:) + per_doa_delay_comp_s(:);

        % compensate for...
        %   sensivity of each microphone
        %   power output by each loudspeaker (i.e. per doa)
        %   delays due to each loudspeaker and alignment of subject with 
        %    respect to origin (middle of sphere)
        this_ir = bsxfun(@times,this_ir,per_mic_gain.');       
        this_ir = bsxfun(@times,this_ir,permute(per_doa_gain(:),[2 3 1]));       
        this_ir = fcn_20181010_04_apply_per_doa_delays(this_ir,this_delay_s.*fs);

        % plot the original and compensated irs on horizontal plane
        if params.do_plots
            toa_vis_params.chair_rot_deg = chair_rot_deg(irot);

            toa_vis_params.figh = orig_fig;
            toa_vis_params.label = sprintf('%d - orig',T.subj_id(isubject));
            fcn_20181011_01_visualise_toas(indata.(hrirnames{irot}),toa_vis_params);
    
            toa_vis_params.figh = comp_fig;
            toa_vis_params.label = sprintf('%d - comp',T.subj_id(isubject));
            fcn_20181011_01_visualise_toas(this_ir,toa_vis_params)
        end
        
        % reorder the microphones
        this_ir = this_ir(:,mic_chan_map,:);
        
        % crop
        this_ir = fcn_20181016_01_crop_ir(this_ir,fs,crop);
        
        % deal with invalid in-ear signals
        if ~T.in_ear_valid(isubject)
            this_ir(:,save_data.channelsInEar,:) = nan;
        end
       
        % copy the full compensated response to rir struct
        save_data.(rirnames{irot}) = zeros(nSamplesRaw,nMicOut,nDoa);
        idc = 1:min(nSamplesRaw,size(this_ir,1));
        save_data.(rirnames{irot})(idc,:,:) = this_ir(idc,:,:);
    end
    
    if params.do_plots
        ahm_print_to_pdf(orig_fig,...
            fullfile(out_dir,'graphics',...
                sprintf('toa_vs_az_subject_%02d_a_orig.pdf',T.subj_id(isubject))));
        ahm_print_to_pdf(comp_fig,...
            fullfile(out_dir,'graphics',...
                sprintf('toa_vs_az_subject_%02d_b_comp.pdf',T.subj_id(isubject))));
            
        clf(orig_fig);
        clf(comp_fig);
    end

    %% save the results
    outpath = fullfile(out_dir,'mat',sprintf('subject_%02d.mat',T.subj_id(isubject)));
    save(outpath,'-struct','save_data');

end
fprintf('\nDone.\n');



    