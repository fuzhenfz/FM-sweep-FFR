function RA = plotRA(signal,fs,freRange)
% calculate relative amplitude for a certain frequency
Nfft = fs;
f_signal = abs(fft(signal,Nfft));
f_signal = f_signal(1:Nfft/2);
f_signal = [f_signal(2:end) 0];
% set the frequency range as the noise floor, and the frequency range as the target
width = 500;
inside = 5;
a = floor(inside/2);
n = length(f_signal);
RA = zeros(n,1);

if width >= n/2
    disp('Too long to make!');
    return;
else
    for i = 1:n
        if i <= width
            RA(i) = f_signal(i)/sum(f_signal(i+1:i+width))*width;
        elseif i >= n - width
            RA(i) = f_signal(i)/sum(f_signal(i-width:i-1))*width;
        else
            RA(i) = (sum(f_signal(i-a:i+a))/inside)/...
                ((sum(f_signal(i-width:i-a-1))+sum(f_signal(i+a+1:i+width)))/(2*width-inside));
        end
    end    
end

if strcmp(class(RA),'double')==0
    RA = double(RA);
end
% RA = 20*log10(RA);
for i2=1:length(signal)
    if f_signal(i2)<1e-2
        RA(i2)=0;
    end
end
if nargout==0
    % figure;
    plot(RA);
    xlabel('Frequency (Hz)','fontsize',12)
    ylabel('Relative Amplitude (dB)','fontsize',12)
    xlim(freRange)
end

