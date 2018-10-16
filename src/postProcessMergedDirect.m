function[] = postProcessMergedDirect(in_dir,out_dir)
% function to create calibration-compensated database of direct-path
% hearing aid head related impulse responses
%
% Usage:
%  postProcessMergedDirect(in_dir,out_dir)
%
% Inputs:
%   in_dir: path where the 'calibrated' database is located
%  out_dir: path where the 'merged direct path' database should be saved
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
chair_rot_deg = [0,-15,-30];

fieldnames_to_copy = {'fs','refChanLeft','refChanRight',...
    'channelsLeft','channelsRight',...
    'channelsFront','channelsBack','channelsInEar'};


% define the crop points and window lengths
crop.start_time = 0; %seconds
crop.fade_in_duration = 0.001;%
crop.end_time = 0.0107; % seconds
crop.fade_out_duration = 0.001;

% to merge the data into a single dataset first concatenate the matrices
% then reorder the doas. Sort order is predetermined
[idc_map, doa_az_deg, doa_el_deg] = fcn_20181011_04_doa_merge_map(doa_az_deg,doa_el_deg,chair_rot_deg);

save_data.doa_az_deg = doa_az_deg;
save_data.doa_el_deg = doa_el_deg;

save_data.doa_unit_vec = [...
    cosd(doa_az_deg).*cosd(doa_el_deg);...
    sind(doa_az_deg).*cosd(doa_el_deg);...
    sind(doa_el_deg)];


if params.do_plots
    figh = figure();setFigureSize(figh,[25 22],'centimeters')
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
    fs = indata.fs;
    
    for ifield = 1:length(fieldnames_to_copy)
        save_data.(fieldnames_to_copy{ifield}) = indata.(fieldnames_to_copy{ifield});
    end
    
    
    % concatenate over doas
    this_ir = cat(3,...
        indata.ha_rir_0,...
        indata.ha_rir_n15,...
        indata.ha_rir_n30);
    
    % prune and reorder
    this_ir = this_ir(:,:,idc_map);
    
    
    if params.do_plots
        figure(figh);
        set(figh,'name',sprintf('%s',T.subj_id(isubject)))
        tmax = 0.05;
        tscale = (1:size(this_ir,1)) ./fs;
        idc = 1:sum(tscale<tmax);
        imic = 1;
        for idoa = 1:length(idc_map)
            plot3(tscale(idc),(idoa-1)*ones(length(idc),1),envelope(this_ir(idc,imic,idoa)),...
                'DisplayName',sprintf('az %3.1f el %3.1f',...
                save_data.doa_az_deg(idoa),...
                save_data.doa_el_deg(idoa)))
            hold all;
        end        
        plot3(repmat(0.0108,2,1),[0 length(idc_map)+1],[0 0],'k-','linewidth',2)
        view(-14,36)
        xlim([0.004 0.012])
        ylim([0 length(idc_map)+1])
        zlim([0 0.08])
        xlabel('Time [s]')
        zlabel('HA-HRIR')
        ylabel('DOA id')
        ahm_print_to_pdf(figh,...
            fullfile(out_dir,'graphics',...
            sprintf('hrir_vs_az_subject_%02d.pdf',T.subj_id(isubject))));
        clf(figh);
    end
    
    % crop
    this_ir = fcn_20181016_01_crop_ir(this_ir,fs,crop);

    % deal with invalid in-ear signals
    if ~T.in_ear_valid(isubject)
        this_ir(:,save_data.channelsInEar,:) = nan;
    end
    
    % copy the final ir into the save struct
    save_data.ha_hrir = this_ir;
    
    % save
    outpath = fullfile(out_dir,'mat',sprintf('subject_%02d.mat',T.subj_id(isubject)));
    save(outpath,'-struct','save_data');
end