function[head_pos_s] = fcn_20181010_01_estimate_time_offset(db_root,in_params)
% estimate toa of horizonal plane doa's in original chair rotation
% solve for offset

fs = 44100;
nSubjects = 46;
nDoa = 29;
nMicPerHa = 3;

idoa_front = 1;
idoa_back = 9;
idoa_left = 5;
idoa_right = 13;

params.left_ha_per_mic_gain = ones(nMicPerHa,1);
params.right_ha_per_mic_gain = ones(nMicPerHa,1);
params.per_doa_gain = ones(nDoa,1);
params.per_doa_delay_comp_s = zeros(nDoa,1);

params = override_valid_fields(params,in_params);

per_mic_gain = [params.left_ha_per_mic_gain(:);params.right_ha_per_mic_gain(:)];

head_pos_s = zeros(nSubjects,3);
for isubject = nSubjects:-1:1
    load(fullfile(db_root,'mat',sprintf('subject_%02d.mat',isubject)),'ha_hrir_0');
    this_ir = ha_hrir_0; % [nSamples,nChans=6, nDoa=29]
    this_ir = bsxfun(@times,this_ir,per_mic_gain.');
    this_ir = bsxfun(@times,this_ir,permute(params.per_doa_gain(:),[2 3 1]));
    this_ir = fcn_20181010_04_apply_per_doa_delays(this_ir,params.per_doa_delay_comp_s*fs);
    %fcn_20181010_02_visualise_ir_propagation(this_ir,fs)
        
    toa_from_front = fcn_20181008_01_est_toa(this_ir(:,:,idoa_front),fs);
    toa_from_back = fcn_20181008_01_est_toa(this_ir(:,:,idoa_back),fs);
    toa_from_left = fcn_20181008_01_est_toa(this_ir(:,:,idoa_left),fs);
    toa_from_right = fcn_20181008_01_est_toa(this_ir(:,:,idoa_right),fs);
       
    
    x_head = (mean(toa_from_back([1 4]))-mean(toa_from_front([1 4])))/2;
    y_head = mean([(toa_from_right(4)-toa_from_left(1))/2, (toa_from_right(1)-toa_from_left(4))/2]);
    head_pos_s(isubject,:) = [x_head,y_head,0];
end
