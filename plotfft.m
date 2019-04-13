function spec = plotfft(sig,fs,freRange,scale)
spec = abs(fft(sig));
if strcmp(scale,'dB')
    spec = spec / (sum(spec));
    spec = 20 * log(spec) / log(10);
end
% spec = spec / (sum(spec));
if strcmp(class(spec),'double')==0
    spec = double(spec);
end
spec = resample(spec,fs,length(spec));
if nargout==0
    % figure;
    plot(0:length(spec)-1,spec);
    xlabel('Frequency (Hz)','fontsize',16)
    ylabel('Amplitude (dB)','fontsize',16)
    xlim(freRange)
    ylim([-200 max(spec)*1.2])
end