function[out] = fcn_20180412_01_fft_delay(in,delay,Fs)
%
%applies a linear delay by adding phase to the fft spectrum. The length of
%the output is increased by the necessary number of samples
if numel(delay)~=1 || delay<0
    error('delay must be a non-negative scalar')
end

nExtraSamples = ceil(delay*Fs);
[nSamples, nChannels] = size(in);
nFFT = nSamples+nExtraSamples;
fft_in = fft(in,nFFT);

if mod(nFFT,2)
    %odd
    mag_delayed = abs(fft_in(1:(nFFT+1)/2,:));
    phase_delayed = angle(fft_in(1:(nFFT+1)/2,:));
else
    %even
    mag_delayed = abs(fft_in(1:(nFFT/2 +1),:));
    phase_delayed = angle(fft_in(1:(nFFT/2 +1),:));
end

%group_delay = - dPhase/dOmega
dOmega = 2*pi*Fs/nFFT; 
extra_phase = -delay * dOmega * [0:length(phase_delayed)-1].';

phase_delayed = phase_delayed + repmat(extra_phase,1,nChannels);

if mod(nFFT,2)
    %odd
    mag_delayed = [mag_delayed; flipud(mag_delayed(2:end,:))];
    phase_delayed = [phase_delayed; -flipud(phase_delayed(2:end,:))];
else
    %even
    mag_delayed = [mag_delayed; flipud(mag_delayed(2:end-1,:))];
    phase_delayed = [phase_delayed; -flipud(phase_delayed(2:end-1,:))];
end

%reconstruct and convert back to time domain
fft_delayed = mag_delayed .* exp(1i*phase_delayed);
out = real(ifft(fft_delayed));