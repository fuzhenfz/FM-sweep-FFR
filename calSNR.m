function SNR = calSNR(FFR,fs)

FFR = addwindow(FFR,fs);
spec_FFR = plotfft(FFR,fs,[1 1000],'dB');
% frequency region of the F0
TargetFreRange = 20;% 130-170
NoiseFreRange = 50;% 80-130, 170-220
[max_value,max_pos] = max(spec_FFR(130:170));
max_pos = max_pos + 130-1;
SigAmp_FFR = sum(spec_FFR((max_pos-TargetFreRange):(max_pos+TargetFreRange)));
NoiseAmp_FFR = sum(spec_FFR((max_pos-TargetFreRange-NoiseFreRange):(max_pos+TargetFreRange+NoiseFreRange)))-SigAmp_FFR;
SigAmp_FFR = SigAmp_FFR/(2*TargetFreRange+1);
NoiseAmp_FFR = NoiseAmp_FFR/(2*NoiseFreRange);
SNR = SigAmp_FFR-NoiseAmp_FFR;

function w = addwindow(sig,fs)
Rise_Time = 0.005;% s
% Fall_Time = 0.02;
for i=1:Rise_Time*fs
    sig(i) = sig(i)*sin(pi*i/(2*Rise_Time*fs));
    sig(length(sig)-i+1) = sig(length(sig)-i+1)*sin(pi*i/(2*Rise_Time*fs));
end
w = sig;
end
end
