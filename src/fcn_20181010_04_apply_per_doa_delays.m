function[ir_aligned] = fcn_20181010_04_apply_per_doa_delays(ir,d)

nDOA = length(d);
if numel(d)~=nDOA,error('d must be a vector'),end
[nSamples,nMics,must_equal_nDOA] = size(ir);
if nDOA~=must_equal_nDOA,error('size of ir and d are inconsistent'),end

% convert measured delay into positive samples to add
excess_whole_samples_delay = max(0,ceil(max(-d)));
d_pos = d + excess_whole_samples_delay;

ir_aligned = zeros(size(ir,1)+ceil(max(d_pos)),nMics,nDOA);
for idoa = 1:nDOA
    tmp = fcn_20180412_01_fft_delay(ir(:,:,idoa),d_pos(idoa),1);
    ir_aligned(1:length(tmp),:,idoa) = tmp;
end
% remove the excess delay
ir_aligned(1:excess_whole_samples_delay,:,:) = [];

