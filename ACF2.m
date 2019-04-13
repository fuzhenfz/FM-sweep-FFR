function [PS,Pitch] = ACF2(FFR,fs,FrameLen,FrameSlide)
% seperate into frames to calculate pitch strength (peak to trough)
% pre-determined frequency region to search the F0
frerange(1) = 100;%130
frerange(2) = 200;%150
% FrameLen = 0.02*fs;% 10 ms
% FrameSlide = 0.001*fs;% 1 ms
sigframes = vec2frames(FFR,FrameLen*fs,FrameSlide*fs);
ACorFrameNum = size(sigframes,2);


% pitch strength
for i1 = 1:ACorFrameNum
    CurFrame = sigframes(:,i1);
    [ACF_Frame,lagsNo] = xcorr(CurFrame,'coeff');
    lagsTime = 1/fs*lagsNo*1000;%(ms)
    lagRange = find(lagsTime<(1./frerange(1)*1000) & lagsTime>(1./frerange(2)*1000));
    [peak,PitchLagPos] = max(ACF_Frame(lagRange,:));
    PitchLagPos = PitchLagPos+min(lagRange)-1;
    
    for i = PitchLagPos:length(ACF_Frame)
        if i==length(ACF_Frame)
            trough = ACF_Frame(i);
        elseif ACF_Frame(i)<=ACF_Frame(i+1)
            trough = ACF_Frame(i);
            break;
        end
    end
    PSs(i1) = peak-trough;
end
PS = mean(PSs);

% calculatee pitch (framing)
for i2 = 1:ACorFrameNum
    CurFrame = sigframes(:,i2);
    [ACF_Frame,lagsNo] = xcorr(CurFrame);
    lagsTime = 1/fs*lagsNo*1000;%(ms)
    lagRange = find(lagsTime<(1./frerange(1)*1000) & lagsTime>(1./frerange(2)*1000));
    [~,PitchLagPos] = max(ACF_Frame(lagRange,:));
    PitchLagPos = PitchLagPos+min(lagRange)-1;    
    PitchLag = lagsNo(PitchLagPos)/fs;
    Pitch(i2) = 1./PitchLag;    
end

% figure
% plot(PSs)

