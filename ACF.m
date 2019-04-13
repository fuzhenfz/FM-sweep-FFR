function [PS,Pitch] = ACF(StimulusStd,fs)
frerange(1) = 100;%130
frerange(2) = 200;%150

% pitch strength (not framing)
[ACF_sig,lagsNo] = xcorr(StimulusStd,'coeff');
lagsTime = 1/fs*lagsNo*1000;%(ms)
lagRange = find(lagsTime<(1./frerange(1)*1000) & lagsTime>(1./frerange(2)*1000));


[peak,PitchLagPos] = max(ACF_sig(:,lagRange));
PitchLagPos = PitchLagPos+min(lagRange)-1;
for i=PitchLagPos:(min(lagRange)+length(lagRange)-1)
    if ACF_sig(i+1)>ACF_sig(i)
        trough = ACF_sig(i);
        break
    else
        trough =  ACF_sig(i);
    end   
end

PS = peak-trough;

% pitch (framing)
WinLen = 0.05*fs;% 50 ms
WinSlide = 0.001*fs;% 1 ms
sigframes = vec2frames(StimulusStd,WinLen,WinSlide);
ACorFrameNum = size(sigframes,2);
for i1 = 1:ACorFrameNum
    CurFrame = sigframes(:,i1);
    [ACF_Frame,lagsNo] = xcorr(CurFrame);
    lagsTime = 1/fs*lagsNo*1000;%(ms)
    lagRange = find(lagsTime<(1./frerange(1)*1000) & lagsTime>(1./frerange(2)*1000));
    [~,PitchLagPos] = max(ACF_Frame(lagRange,:));
    PitchLagPos = PitchLagPos+min(lagRange)-1;
    
    PitchLag = lagsNo(PitchLagPos)/fs;
    Pitch(i1) = 1./PitchLag;    
end
