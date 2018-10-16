function[toa,extras] = fcn_20181008_01_est_toa(ir,fs,in_params)


params.win_dur_list = 0.001:0.0001:0.002;

if nargin > 2 && ~isempty(in_params)
    params = override_valid_fields(params,in_params);
end

irSize = size(ir);
if length(irSize)>2, error('ir should be arranged as [nSamples nChannels]'),end
nSamples = irSize(1);
nChans = irSize(2);


est_delay_samples = zeros(length(params.win_dur_list),nChans);
for ichan = 1:nChans
    for iwin = 1:length(params.win_dur_list)
        gd = ewgrpdel(ir(:,ichan),round(params.win_dur_list(iwin) * fs));
        [~,peak] = max(gd);
        nzcs = zerocros(gd,'n');
        ifound = find(nzcs>peak,1,'first');
        if isempty(ifound)
            est_delay_samples(iwin,ichan) = nan;
        else
            est_delay_samples(iwin,ichan) = nzcs(ifound);
        end
    end
end
[est_delay_samples_final,imin] = min(est_delay_samples,[],1);
toa = est_delay_samples_final./fs;
extras.group_delay_window_duration = params.win_dur_list(imin);
