function [SNR_Std] = calSNR(StdBP_,fs)
% function [SNR_Std,Std_N_SNR,JND_P_SNR,JND_N_SNR,max_value_StdBP_P,max_value_StdBP_N,max_value_JNDBP_P,max_value_JNDBP_N] = calSNR(StdBP_,JNDBP_,fs)
% seperate into frames to calculate SNR

StdBP_ = addwindow(StdBP_,fs);
spec_StdBP = plotfft(StdBP_,fs,[1 1000],'dB');
TargetFreRange = 20;% 130-170
NoiseFreRange = 50;% 80-130, 170-220
[max_value,max_pos] = max(spec_StdBP(130:170));
max_pos = max_pos + 130-1;
SigAmp_StdBP = sum(spec_StdBP((max_pos-TargetFreRange):(max_pos+TargetFreRange)));
NoiseAmp_StdBP = sum(spec_StdBP((max_pos-TargetFreRange-NoiseFreRange):(max_pos+TargetFreRange+NoiseFreRange)))-SigAmp_StdBP;
SigAmp_StdBP = SigAmp_StdBP/(2*TargetFreRange+1);
NoiseAmp_StdBP = NoiseAmp_StdBP/(2*NoiseFreRange);
SNR_Std = SigAmp_StdBP-NoiseAmp_StdBP;
% SNR_Std = log10(SigAmp_StdBP/NoiseAmp_StdBP);

% spec_JNDBP = plotfft(JNDBP_,fs,[1 1000]);
% SigAmp_JNDBP = sum(spec_JNDBP((150-TargetFreRange):(150+TargetFreRange)));
% NoiseAmp_JNDBP = sum(spec_JNDBP((150-TargetFreRange-NoiseFreRange):(150+TargetFreRange+NoiseFreRange)))-SigAmp_JNDBP;
% SigAmp_JNDBP = SigAmp_JNDBP/41;
% NoiseAmp_JNDBP = NoiseAmp_JNDBP/60;
% SNR_JND = SigAmp_JNDBP/NoiseAmp_JNDBP;


% WinLen = 0.02*fs;% 20 ms
% WinSlide = 0.001*fs;% 1 ms
% TargetFreRange = 2;
% NoiseFreRange = 20;
%     
% StdBP_P_frames = vec2frames(StdBP_,WinLen,WinSlide);
% StdBP_N_frames = vec2frames(StdBP_N,WinLen,WinSlide);
% JNDBP_P_frames = vec2frames(JNDBP_,WinLen,WinSlide);
% JNDBP_N_frames = vec2frames(JNDBP_N,WinLen,WinSlide);
% FrameNum = size(StdBP_P_frames,2);
% 
% for i1 = 1:FrameNum
%     StdBP_P_frame = StdBP_P_frames(:,i1);
%     StdBP_N_frame = StdBP_N_frames(:,i1);
%     JNDBP_P_frame = JNDBP_P_frames(:,i1);
%     JNDBP_N_frame = JNDBP_N_frames(:,i1);
%     
%     spec_StdBP = plotfft(StdBP_P_frame,fs,[1 1000]);
%     spec_JNDBP = plotfft(StdBP_N_frame,fs,[1 1000]);
%     spec_JNDBP_P = plotfft(JNDBP_P_frame,fs,[1 1000]);
%     spec_JNDBP = plotfft(JNDBP_N_frame,fs,[1 1000]);
%     
%     [max_value_StdBP_P(i1),max_pos_StdBP_P] = max(spec_StdBP(1:1000));
%     [max_value_StdBP_N(i1),max_pos_StdBP_N] = max(spec_JNDBP(1:1000));
%     [max_value_JNDBP_P(i1),max_pos_JNDBP_P] = max(spec_JNDBP_P(1:1000));
%     [max_value_JNDBP_N(i1),max_pos_JNDBP_N] = max(spec_JNDBP(1:1000));
%     
% 
%     SigAmp_StdBP = mean(spec_StdBP((max_pos_StdBP_P-TargetFreRange/2):(max_pos_StdBP_P+TargetFreRange/2)));
%     SigAmp_StdBP_N = mean(spec_JNDBP((max_pos_StdBP_N-TargetFreRange/2):(max_pos_StdBP_N+TargetFreRange/2)));
%     SigAmp_JNDBP_P = mean(spec_JNDBP_P((max_pos_JNDBP_P-TargetFreRange/2):(max_pos_JNDBP_P+TargetFreRange/2)));
%     SigAmp_JNDBP_N = mean(spec_JNDBP((max_pos_JNDBP_N-TargetFreRange/2):(max_pos_JNDBP_N+TargetFreRange/2)));
%     NoiseAmp_StdBP = mean(spec_StdBP((max_pos_StdBP_P-NoiseFreRange/2):(max_pos_StdBP_P+NoiseFreRange/2)))-SigAmp_StdBP;
%     NoiseAmp_StdBP_N = mean(spec_JNDBP((max_pos_StdBP_N-NoiseFreRange/2):(max_pos_StdBP_N+NoiseFreRange/2)))-SigAmp_StdBP_N;
%     NoiseAmp_JNDBP_P = mean(spec_JNDBP_P((max_pos_JNDBP_P-NoiseFreRange/2):(max_pos_JNDBP_P+NoiseFreRange/2)))-SigAmp_JNDBP_P;
%     NoiseAmp_JNDBP_N = mean(spec_JNDBP((max_pos_JNDBP_N-NoiseFreRange/2):(max_pos_JNDBP_N+NoiseFreRange/2)))-SigAmp_JNDBP_N;
%     
%     SNR_Std(i1) = SigAmp_StdBP/NoiseAmp_StdBP;
%     Std_N_SNR(i1) = SigAmp_StdBP_N/NoiseAmp_StdBP_N;
%     JND_P_SNR(i1) = SigAmp_JNDBP_P/NoiseAmp_JNDBP_P;
%     JND_N_SNR(i1) = SigAmp_JNDBP_N/NoiseAmp_JNDBP_N;
%     
% end

% figure
% subplot(411)
% plot(Std_P_SNR);figure(gcf);
% text(150,max(Std_P_SNR),num2str(mean(Std_P_SNR)))
% subplot(412)
% plot(Std_N_SNR);figure(gcf);
% text(150,max(Std_N_SNR),num2str(mean(Std_N_SNR)))
% subplot(413)
% plot(JND_P_SNR);figure(gcf);
% text(150,max(JND_P_SNR),num2str(mean(JND_P_SNR)))
% subplot(414)
% plot(JND_N_SNR);figure(gcf);
% text(150,max(JND_N_SNR),num2str(mean(JND_N_SNR)))

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