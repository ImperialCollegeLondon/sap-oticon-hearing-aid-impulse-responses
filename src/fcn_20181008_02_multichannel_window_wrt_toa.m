function[ir] = fcn_20181008_02_multichannel_window_wrt_toa(ir,fs,toa,in_params)

params.ref_time_fcn = @min;
params.fade_out_duration = 0.001;
params.fade_in_duration = 0.001;
params.pre_toa_hold_off_duration = 0.002;
params.post_toa_hold_off_duration = 0.002;
params.do_plots = 0;

if nargin > 3 && ~isempty(in_params)
    params = override_valid_fields(params,in_params);
end

irSize = size(ir);
if length(irSize)>2, error('ir should be arranged as [nSamples nChannels]'),end
nSamples = irSize(1);
nChans = irSize(2);
nToas = length(toa);
if numel(toa)~=nToas, error('toa must be a scalar or a vector'),end

fade_out_len = params.fade_out_duration*fs;
fade_in_len = params.fade_in_duration*fs;

win = ones(nSamples,nToas);

if params.do_plots
    figh = figure;
    ax = gca;
    set(ax,'NextPlot','add')
end

for itoa = 1:nToas
    % fade out
    tend_sample = toa(itoa)*fs + params.post_toa_hold_off_duration*fs;
    fade_out = fractional_falling_cosine((1:nSamples)-tend_sample,fade_out_len);
    
    % fade in
    tstart_sample = toa(itoa)*fs - params.pre_toa_hold_off_duration*fs;
    fade_in = fractional_rising_cosine((1:nSamples)-tstart_sample,fade_in_len);
    
    win(:,itoa) = fade_out .* fade_in;
    if params.do_plots
        plot(toa([itoa itoa]).*fs,[0 1],':k','DisplayName',sprintf('%d: TOA',itoa));
        plot(1:nSamples,fade_in,'DisplayName',sprintf('%d: fade in',itoa));
        plot(1:nSamples,fade_out,'DisplayName',sprintf('%d: fade out',itoa));
        plot(1:nSamples,win(:,itoa),'DisplayName',sprintf('%d: window',itoa));
        plot(1:nSamples,win(:,itoa) .* ir(:,itoa),'DisplayName',sprintf('%d: windowed',itoa));
    end
end

if nChans ~= nToas
    if nToas == 1
        win = repmat(win,1,nChans);
    else
        error('size of toas must match ir, or be 1')
    end
end

ir = ir .* win;


function[win] = fractional_falling_cosine(idc,N)
idc_lim = min(max(0,idc),N+1);
win = (1+cos(idc_lim'/(N+1)*pi))/2;

function[win] = fractional_rising_cosine(idc,N)
idc_lim = max(min(0,idc),-(N+1));
win = (1+cos(idc_lim'/(N+1)*pi))/2;