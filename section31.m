%% Section 3.1 
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

%% Plot VGRF (in Newtons) vs. time (in seconds) for left feet and right feet in time domain
% Obtain number of samples for 5s time segment
samplingFreq = 120; %Hz
range30to35 = (1 + 30*samplingFreq) : (1 + 35*samplingFreq);

%plot
figure(1)
hold on
plot(time(range30to35),VGRF_Left(range30to35),'b');
plot(time(range30to35),VGRF_Right(range30to35),'r');
title("VGRF(N) vs time(s) for left feet and right feet")
ylabel("VGRF(N)")
xlabel("Time(s)")
legend("VGRF of Left Feet","VGRF of Right Feet",'Location',"southoutside");

%% Plot VGRF (in Newtons) vs. time (in seconds) for left feet and right feet in frequency domain
N = length(VGRF_Left);
VGRF_LeftFreq = fft(VGRF_Left);
VGRF_RightFreq = fft(VGRF_Right);
omega = (-floor(N/2):(N-1-floor(N/2)))*(samplingFreq/N);

%plot
figure(2);
subplot(2,1,1)
plot(omega, fftshift(abs(VGRF_LeftFreq)),'r');
title("VGRF(N) for left feet in frequency domain")
ylabel("VGRF(N)")
xlabel("Frequency(Hz)")

subplot(2,1,2)
plot(omega, fftshift(abs(VGRF_RightFreq)),'b');
title("VGRF(N) for right feet in frequency domain")
ylabel("VGRF(N)")
xlabel("Frequency(Hz)")
