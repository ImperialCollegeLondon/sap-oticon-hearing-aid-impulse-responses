function[cal_energy,cal_toa] = fcn_20181011_02_aweighted_speaker_calibration(db_root,in_params)


fs = 44100;
nSubjects = 46;
nDoa = 29;

params.post_toa_hold_off_duration = 0.5; % set to -1 to experiment with different ir lengths
params.do_plots = 0;

if nargin>1 && ~isempty(in_params)
    params = override_valid_fields(params,in_params);
end


if isequal(params.post_toa_hold_off_duration,-1)
    post_toa_hold_off_duration = 0.001 * [2 4 6 8 10 15 20 50 100 500];
    params.do_plots = 1;
else
    post_toa_hold_off_duration = params.post_toa_hold_off_duration;
end

nWin = length(post_toa_hold_off_duration);

% makes some aweighted noise
[awb,awa] = stdspectrum(2,'z',fs);
aw_noise = filter(awb,awa,randn(fs,1));
aw_noise = aw_noise./sqrt(var(aw_noise));

if params.do_plots
	vis_params.figh = figure;
	vis_params.chanlist = 1;
    vis_params.label = 'omni';
end

cal_count = 0;
for isubject = 1:nSubjects
    load(fullfile(db_root,'mat',sprintf('subject_%02d.mat',isubject)),'calibration');
    this_omni = calibration.omni_reference; % [nSamples 1 nDoa=29]
    this_omni = permute(this_omni,[1,3,2]); % [nSamples, nDoa=29];
    if isubject==1 ||  ~isequal(this_omni,prev_omni)
        cal_count = cal_count+1;
        prev_omni = this_omni;
        
        % extract 4...502 ms of omni response
        % convolve with aweighted noise
        % save power
        
        %% extract 4 ms of omni response
        cal_toa(cal_count,:) = fcn_20181008_01_est_toa(this_omni,fs);
        
        if params.do_plots
            fcn_20181011_01_visualise_toas(permute(this_omni,[1 3 2]),vis_params)
            drawnow
        end
        
        
        for iwin = 1:nWin
            params.post_toa_hold_off_duration = post_toa_hold_off_duration(iwin);
            win_ir = fcn_20181008_02_multichannel_window_wrt_toa(this_omni,fs,cal_toa(cal_count,:),params);
            win_ir = fcn_20181008_03_top_and_tail(win_ir);
            cal_energy(cal_count,:,iwin) = sum(fftfilt(win_ir,[aw_noise;zeros(size(win_ir,1)-1,1)]).^2,1);
        end
    end
end

if params.do_plots
    for iwin = 1:size(cal_energy,3)
        figure;
        set(gcf,'windowstyle','docked');
        plot(squeeze(cal_energy(:,:,iwin)).');
        ylim([1000 2600]);
        title(num2str(iwin));
    end
end
    



