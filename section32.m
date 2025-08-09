%% Section 3.2 
%% Written by: Lim Yi Woeh 33354715
%% Import data
clear all; close all; clc
data = importdata("Project_Data.mat");
% 1. Time (in seconds)
% 2. Total force under the left foot (in Newtons)
% 3. Total force under the right foot (in Newtons)
time = data(:,1);
VGRF_Left = data(:,2);
VGRF_Right = data(:,3);

%% Spectogram
% Obtain data for 5s time segment
samplingFreq = 120; %Hz
thirtySec = 30*samplingFreq;
VGRF_Left_30sec = VGRF_Left(1 + 30*samplingFreq:1 + 60*samplingFreq);

% Number of overlap for each window length, use half overlap
% window length = 50
figure(1)
subplot(3,1,1)
spectrogram(VGRF_Left_30sec,50,[],[],samplingFreq,'yaxis')
title("Spectrogram for Left VGRM")
subtitle("Window lengths = 50")
colormap jet;
clim([-45 55])
% determine stance and swing phase by inspection
timeStanceStart = [5.60 5.60];
timeStanceEnd = [6.30 6.30];
timeSwingStart = [17.2 17.2];
timeSwingEnd = [17.6 17.6];
line(timeStanceStart,ylim,'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeStanceEnd,ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeSwingStart, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
line(timeSwingEnd, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
legend('Stance Phase','','Swing Phase');

% window length = 20
subplot(3,1,2)
spectrogram(VGRF_Left_30sec,20,[],[],samplingFreq,'yaxis')
title("Spectrogram for Left VGRM")
subtitle("Window lengths = 20")
colormap jet;
clim([-45 55])
% determine stance and swing phase by inspection
timeStanceStart = [5.60 5.60];
timeStanceEnd = [6.30 6.30];
timeSwingStart = [17.2 17.2];
timeSwingEnd = [17.6 17.6];
line(timeStanceStart,ylim,'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeStanceEnd,ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeSwingStart, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
line(timeSwingEnd, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
legend('Stance Phase','','Swing Phase');

% window length = 10
subplot(3,1,3)
spectrogram(VGRF_Left_30sec,10,[],[],samplingFreq,'yaxis')
title("Spectrogram for Left VGRM")
subtitle("Window lengths = 10")
colormap jet;
clim([-45 55])
% determine stance and swing phase by inspection
timeStanceStart = [5.60 5.60];
timeStanceEnd = [6.30 6.30];
timeSwingStart = [17.2 17.2];
timeSwingEnd = [17.6 17.6];
line(timeStanceStart,ylim,'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeStanceEnd,ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '-');
line(timeSwingStart, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
line(timeSwingEnd, ylim, 'Color', 'black', 'LineWidth', 2, 'LineStyle', '--');
legend('Stance Phase','','Swing Phase');
