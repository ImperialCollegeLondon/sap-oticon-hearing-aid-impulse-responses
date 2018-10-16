function[cal_energy_left,cal_energy_right] = fcn_20181008_05_aweighted_microphone_calibration_power(db_root,post_toa_hold_off_duration)

DEBUG = 1;
if nargin==0 || isempty(db_root)
    db_root = '/Volumes/Samsung_T5/zenodo_staging/00_raw';
end
if nargin < 2 || isempty(post_toa_hold_off_duration)
    post_toa_hold_off_duration = 0.5;
    DEBUG = 0;
end
if isequal(post_toa_hold_off_duration,-1)
    post_toa_hold_off_duration = 0.001 * [2 4 6 8 10 15 20 50 100 500];
end

fs = 44100;
nSubjects = 46;
nDoa = 29;
nMicPerHa = 3;
nWin = length(post_toa_hold_off_duration);

% makes some aweighted noise
[awb,awa] = stdspectrum(2,'z',fs);
aw_noise = filter(awb,awa,randn(fs,1));
aw_noise = aw_noise./sqrt(var(aw_noise));


cal_count = 0;
cal_energy_left = [];
cal_energy_right = [];
for isubject = 1:nSubjects
    load(fullfile(db_root,'mat',sprintf('subject_%02d.mat',isubject)),'calibration');
    this_left_ha = calibration.left_ha; % [nSamples,nChans=3, nDoa=29]
    this_right_ha = calibration.right_ha; % [nSamples,nChans=3, nDoa=29]

    if isubject==1 ||  ~isequal(this_left_ha,prev_left_ha) || ~isequal(this_right_ha,prev_right_ha)
        cal_count = cal_count+1
        prev_left_ha = this_left_ha;
        prev_right_ha = this_right_ha;
        
        % extract 4...502 ms of window of ir
        % convolve with aweighted noise
        % save power
        for iside = 1:2
            switch iside
                case 1
                    this_ha = this_left_ha;
                case 2
                    this_ha = this_right_ha;
            end
            tmp_cal_energy = zeros(1,nMicPerHa,nDoa,nWin);
            for idoa = 1:nDoa
                this_ir = this_ha(:,:,idoa);
        
                toa = fcn_20181008_01_est_toa(this_ir,fs);
                for iwin = 1:nWin
                    params.post_toa_hold_off_duration = post_toa_hold_off_duration(iwin);
                    win_ir = fcn_20181008_02_multichannel_window_wrt_toa(this_ir,fs,toa,params);
                    win_ir = fcn_20181008_03_top_and_tail(win_ir);
                    tmp_cal_energy(1,:,idoa,iwin) = sum(fftfilt(win_ir,[aw_noise;zeros(size(win_ir,1)-1,1)]).^2,1);
                end
            end
            switch iside
                case 1
                    cal_energy_left = cat(1,cal_energy_left,tmp_cal_energy);
                case 2
                    cal_energy_right = cat(1,cal_energy_right,tmp_cal_energy);
            end
        end
    end
end

