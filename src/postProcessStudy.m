function[] = postProcessStudy(in_dir,out_dir)
% function to perform windowing and extraction of required sections of
% raw database as used in SI test
%
% Usage:
%  postProcessStudy(in_dir,out_dir)
%
% Inputs:
%   in_dir: path where the 'raw' database is located
%  out_dir: path where the 'study' database should be saved
%
% Outputs:
%   [none]
%
% N.B. only the horizontal ring of loudspeakers, original chair position
% and BTE microphones are retained. Also microphone channel ordering is changed compared
% to raw database to make auditioning binaural/stereo material easier

check_input_dir_exists(in_dir,true);
check_output_dir_exists(fullfile(out_dir,'mat'));

fs = 44100;

% define the crop points and window lengths
crop_types = {'direct','full'};
direct.start_time = 0;  %seconds
direct.fade_in_duration = 0.01;%
direct.end_time = 0.0107; % seconds
direct.fade_out_duration = 0.001;

full.start_time = 0;    %seconds
full.fade_in_duration = 0.01;
full.end_time = 0.29;
full.fade_out_duration = 0.01;

% metadata to be saved is the same for all subjects
save_data.fs = fs;
save_data.doa_az_deg = [0:15].*(360/16);
save_data.doa_el_deg = zeros(1,16);
save_data.doa_unit_vec = [...
    cosd(save_data.doa_az_deg).*cosd(save_data.doa_el_deg) ;...
    sind(save_data.doa_az_deg).*cosd(save_data.doa_el_deg);...
    sind(save_data.doa_el_deg)];
save_data.refChanLeft = 1;
save_data.refChanRight = 2;
save_data.channelsLeft = [1 3];
save_data.channelsRight = [2 4];

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

    % remove the unneeded in-ear channels and rearrange to make left and right
    % reference channels appear on 1 and 2. This makes auditioning multichannel
    % wav files as stereo much easier
    % channel order for indata.ha_hrir_0 is
    %  [FrontLeft BackLeft InEarLeft FrontRight BackRight InEarRight]
    % channel order for the hrir to be saved is
    %  [FrontLeft  FrontRight BackLeft BackRight]
    % only retain the horizontal plane responses
    
    hrir = indata.ha_hrir_0(:,[1 4 2 5],1:16);
    
    for icrop = 1:length(crop_types)
        switch crop_types{icrop}
            case 'direct'
                crop = direct;
            case 'full'
                crop = full;
        end
        save_data.hrir = fcn_20181016_01_crop_ir(hrir,fs,crop);
        
        % save the results
        outpath = fullfile(out_dir,'mat',sprintf('subject_%02d_%s.mat',T.subj_id(isubject),crop_types{icrop}));
        save(outpath,'-struct','save_data');
    end
    
end
fprintf('\nDone.\n');

    