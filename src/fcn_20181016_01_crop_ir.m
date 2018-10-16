function[ir] = fcn_20181016_01_crop_ir(ir,fs,in_params)

params.start_time = 0;  %seconds
params.fade_in_duration = 0;%
params.end_time = []; % seconds
params.fade_out_duration = 0;

% define the fade window
params.falling_win_fcn = @(n)(1+cos([1:n]'/(n+1)*pi))/2;

params = override_valid_fields(params,in_params);

if ~isequal(numel(size(ir)),3)
    error('Dimensions of ir should be 3')
end


% crop
predelay_samples_to_remove = floor(params.start_time * fs);
ir(1:predelay_samples_to_remove,:,:) = [];

last_sample = round((params.end_time-predelay_samples_to_remove/fs)*fs);
ir(last_sample+1:end,:,:) = [];

% fade in/out
fade_in_samples = round(fs * params.fade_in_duration);
ir(1:fade_in_samples,:,:) = bsxfun(@times,...
    ir(1:fade_in_samples,:,:),...
    flipud(params.falling_win_fcn(fade_in_samples)));

fade_out_samples = round(params.fade_out_duration * fs);
ir(end-fade_out_samples+[1:fade_out_samples],:,:) = bsxfun(@times,...
    ir(end-fade_out_samples+[1:fade_out_samples],:,:),...
    params.falling_win_fcn(fade_out_samples));
