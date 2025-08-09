%% Section 3.3
%% Written by: Lim Yi Woeh 33354715
%% estimateGait
function [STl,STr,SWl,SWr,Sl,Sr] = estimateGait(VGRF)
    %% truncate VGRF matrix to obtain the following vectors:
    % time, left feet VGRF, right feet VGRF
    time = VGRF(:,1);
    VGRF_Left = VGRF(:,2);
    VGRF_Right = VGRF(:,3);
    
    %% filter VGRF for both feet
    filterOrder = 150;
    h = firpm(filterOrder,[0,0.1667,0.2,1],[1,1,0,0]);
    VGRF_Left_filtered = conv(VGRF_Left,h);
    VGRF_Left_filtered = VGRF_Left_filtered(ceil(filterOrder/2+1):end-floor(filterOrder/2));
    VGRF_Right_filtered = conv(VGRF_Right,h);
    VGRF_Right_filtered = VGRF_Right_filtered(ceil(filterOrder/2+1):end-floor(filterOrder/2));

    % to remove noise/small spikes during swing phase
    swingThreshold = 30;
    for i = 1:length(VGRF_Left_filtered)
        if (VGRF_Left_filtered(i) < swingThreshold)
            VGRF_Left_filtered(i) = 0;
        end
    end
    for i = 1:length(VGRF_Right_filtered)
        if (VGRF_Right_filtered(i) < swingThreshold)
            VGRF_Right_filtered(i) = 0;
        end
    end
    %% Identify swing and stance phase for left feet
    % finding swing and stance index for left feet
    indexLeftSwingStart = islocalmin(VGRF_Left_filtered,'FlatSelection','first');
    indexLeftSwingStart = indexLeftSwingStart & (VGRF_Left_filtered == 0);

    % islocalmin will not work if the last phase is swing
    % thus manual search is required in that case
    if VGRF_Left_filtered(end) == 0
        for i = length(VGRF_Left_filtered):-1:1
            if VGRF_Left_filtered(i) ~= 0
                indexLeftSwingStart(i+1) = 1; 
            end
        end
    end
    indexLeftSwingEnd = islocalmin(VGRF_Left_filtered,'FlatSelection','last');
    indexLeftSwingEnd = indexLeftSwingEnd & (VGRF_Left_filtered == 0);
    
    indexLeftStanceStart = [false;indexLeftSwingEnd(1:end - 1)];%shift right
    indexLeftStanceEnd = [indexLeftSwingStart(2:end);false];%shift left
    
    % determine if the first index start with stance or swing for left feet
    if VGRF_Left_filtered(1) == 0
        indexLeftSwingStart(1) = true;
    else
        indexLeftStanceStart(1) = true; 
    end

    % determine if the last index end with stance or swing for right feet
    if VGRF_Left_filtered(end) == 0 
        indexLeftSwingEnd(end) = true;
    else
        indexLeftStanceEnd(end) = true; 
    end

    %% Calculate duration of stance and swing for left feet
    samplingFreq = 120;
    % Swing
    SWl = time(indexLeftSwingEnd) - time(indexLeftSwingStart) + 1/samplingFreq; % time of starting index is also considered
    SWl = SWl(2:end); % first cycle is start from midstance, thus it will not be considered
    % Stance
    STl = time(indexLeftStanceEnd) - time(indexLeftStanceStart) + 1/samplingFreq; % time of starting index is also considered
    STl = STl(2:end); % first cycle is start from midstance, thus it will not be considered
    % Stride
    if length(SWl) == length(STl)
        SWl = SWl(1:end-1); % remove swing of last cycle as it might be incomplete
        STl = STl(1:end-1); % remove stance last cycle as swing phase might be incomplete
        Sl = SWl + STl;
    elseif (length(STl) > length(SWl))
        STl = STl(1:end-1); % remove last stance if cycle is not completed
        Sl = SWl + STl; 
    end

    %% Identify swing and stance phase for right feet
    % finding swing and stance index for right feet
    indexRightSwingStart = islocalmin(VGRF_Right_filtered,'FlatSelection','first');
    indexRightSwingStart = indexRightSwingStart & (VGRF_Right_filtered == 0);
    
    % islocalmin will not work if the last phase is swing
    % thus manual search is required in that case
    if VGRF_Right_filtered(end) == 0
        for i = length(VGRF_Right_filtered):-1:1
            if VGRF_Right_filtered(i) ~= 0
                indexRightSwingStart(i+1) = 1; 
                break
            end
        end
    end

    indexRightSwingEnd = islocalmin(VGRF_Right_filtered,'FlatSelection','last');
    indexRightSwingEnd = indexRightSwingEnd & (VGRF_Right_filtered == 0);
    
    indexRightStanceStart = [false;indexRightSwingEnd(1:end - 1)];
    indexRightStanceEnd = [indexRightSwingStart(2:end);false];
    
    % determine if the first index start with stance or swing for left feet
    if VGRF_Right_filtered(1) == 0
        indexRightSwingStart(1) = true;
    else
        indexRightStanceStart(1) = true; 
    end

    % determine if the last index end with stance or swing for right feet
    if VGRF_Right_filtered(end) == 0 
        indexRightSwingEnd(end) = true;
    else
        indexRightStanceEnd(end) = true; 
    end

    %% Calculate duration of stance and swing for right feet
    % Swing
    SWr = time(indexRightSwingEnd) - time(indexRightSwingStart) + 1/samplingFreq; % time of starting index is also considered
    SWr = SWr(2:end); % first cycle is start from midstance, thus it will not be considered
    % Stance
    STr = time(indexRightStanceEnd) - time(indexRightStanceStart) + 1/samplingFreq; % time of starting index is also considered
    STr = STr(2:end); % first cycle is start from midstance, thus it will not be considered
    % Stride
    if length(SWr) == length(STr)
        SWr = SWr(1:end-1); % remove swing of last cycle as it might be incomplete
        STr = STr(1:end-1); % remove stance last cycle as swing phase might be incomplete
        Sr = SWr + STr;
    elseif (length(STr) > length(SWr))
        STr = STr(1:end-1); % remove last stance as the cycle has not completed
        Sr = STr + SWr;
    end

    %% Plot
    % plot filtered VGRF from 30s to 35s
    range30to35 = (1 + 30*120) : (1 + 30*120 + 5*120);
    time_5s = time(range30to35);
    VGRF_Left_filtered_5s = VGRF_Left_filtered(range30to35);
    VGRF_Right_filtered_5s = VGRF_Right_filtered(range30to35);

    figure(1)
    plot(time_5s,VGRF_Left_filtered_5s,'k',LineWidth=1);
    hold on
    plot(time_5s,VGRF_Right_filtered_5s,'b',LineWidth=1);
    title("Filtered VGRF(N) vs time(s) for left feet and right feet")
    ylabel("VGRF(N)")
    xlabel("Time(s)")
    xlim([time(1 + 30*120) time(1 + 30*120 + 5*120)])
    ylim([0 1000])

    % mark swing and stance onset time
    indexLeftStanceStart_5s = indexLeftSwingEnd(range30to35);
    indexLeftSwingStart_5s = indexLeftSwingStart(range30to35);
    indexRightStanceStart_5s = indexRightSwingEnd(range30to35);
    indexRightSwingStart_5s = indexRightSwingStart(range30to35);

    % left feet stance start time
    plot(time_5s(indexLeftStanceStart_5s),VGRF_Left_filtered_5s(indexLeftStanceStart_5s),'c.',MarkerSize = 26);
    % left feet swing start time
    plot(time_5s(indexLeftSwingStart_5s),VGRF_Left_filtered_5s(indexLeftSwingStart_5s),'co',MarkerSize = 9,LineWidth=1.5);
    % right feet stance start time
    plot(time_5s(indexRightStanceStart_5s),VGRF_Right_filtered_5s(indexRightStanceStart_5s),'m.',MarkerSize = 26);
    % right feet swing start tim
    plot(time_5s(indexRightSwingStart_5s),VGRF_Right_filtered_5s(indexRightSwingStart_5s),'mo',MarkerSize = 9,LineWidth=1.5);
    hold off
    legend("Filtered VGRF of Left Feet","Filtered VGRF of Right Feet", ...
        "Start of Left Feet Stance","Start of Left Feet Swing", ...
        "Start of Right Feet Stance","Start of Right Feet Swing", ...
        'Location',"northeast");

    % plot filtered VGRF in frequency domain
    samplingFreq = 120;
    N = length(VGRF_Left_filtered);
    VGRF_LeftFreq_filtered = fft(VGRF_Left_filtered);
    VGRF_RightFreq_filtered = fft(VGRF_Right_filtered);
    omega = (-floor(N/2):(N-1-floor(N/2)))*(samplingFreq/N);

    figure(2)
    subplot(2,1,1)
    plot(omega, fftshift(abs(VGRF_LeftFreq_filtered)),'r');
    title("Filtered VGRF(N) for left feet in frequency domain")
    ylabel("VGRF(N)")
    xlabel("Frequency(Hz)")

    subplot(2,1,2)
    plot(omega, fftshift(abs(VGRF_RightFreq_filtered)),'b');
    title("Filtered VGRF(N) for right feet in frequency domain")
    ylabel("VGRF(N)")
    xlabel("Frequency(Hz)")

    % plot stride duration, stance duration, and swing duration against
    % gait cycle for both feet
    figure(3)
    sgtitle("Gait Parameters against Gait Cycle for Left Feet")
    subplot(3,1,1)
    stem(Sl)
    ylim([0 2])
    xlim([0 95])
    subtitle("Sl against gait cycle")
    ylabel("Stride time(s)")
    xlabel("Gait cycle")

    subplot(3,1,2)
    stem(STl)
    ylim([0 2])
    xlim([0 95])
    subtitle("STl against gait cycle")
    ylabel("Stance time(s)")
    xlabel("Gait cycle")
    
    subplot(3,1,3)
    stem(SWl)
    ylim([0 2])
    xlim([0 95])
    subtitle("SWl against gait cycle")
    ylabel("Swing time(s)")
    xlabel("Gait cycle")
    
    figure(4)
    sgtitle("Gait Parameters against Gait Cycle for Right Feet")
    subplot(3,1,1)
    stem(Sr)
    ylim([0 2])
    xlim([0 95])
    subtitle("Sr against gait cycle")
    ylabel("Stride time(s)")
    xlabel("Gait cycle")
    
    subplot(3,1,2)
    stem(STr)
    ylim([0 2])
    xlim([0 95])
    subtitle("STr against gait cycle")
    ylabel("Stance time(s)")
    xlabel("Gait cycle")
    
    subplot(3,1,3)
    stem(SWr)
    ylim([0 2])
    xlim([0 95])
    subtitle("SWr against gait cycle")
    ylabel("Swing time(s)")
    xlabel("Gait cycle")
    leftGaitAvg = mean(Sl)
    rightGaitAvg = mean(Sr)
end
