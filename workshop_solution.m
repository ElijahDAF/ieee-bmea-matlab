%% =====================================================================
%  BUILD A HEART RATE MONITOR  --  SOLUTION
%  Biomed Design Club MATLAB Workshop
%  Base MATLAB only (R2018b or newer). No toolboxes needed.
%  Run one section at a time: click inside it, then Ctrl+Enter (Cmd+Enter on Mac).
%% =====================================================================

%% Section 0: Start fresh
clear; clc; close all;


%% Section 1: Vectors and plotting  (warm-up, ~8 min)
% You already know matrices from linear algebra. A vector is just a
% matrix with one row. The colon makes evenly spaced numbers:
%   start : step : stop
t = 0:0.01:5;              % 0, 0.01, 0.02, ... 5  (time in seconds)
y = sin(2*pi*1*t);         % a 1 Hz wave (one full cycle per second)

figure;
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('My first plot: a 1 Hz sine wave');
% CHECKPOINT: 5 smooth waves between 0 and 5 seconds.

% GOTCHA from linear algebra:  *  is matrix multiplication.
% For "multiply each element", use  .*   (and ./ for division, .^ for powers)
y2 = t .* y;               % works: element by element
% y2 = t * y;              % ERROR: inner matrix dimensions must agree


%% Section 2: Load and plot the ECG  (~15 min)
load('ecg_data.mat');      % gives you two variables: ecg and fs
fs                         % no semicolon -> prints the value (250)

% fs = 250 means 250 numbers were recorded every second.
% Sample number n happened at time (n-1)/fs seconds.
N = length(ecg);           % how many samples in total
t = (0:N-1) / fs;          % time of every sample, in seconds
duration = N / fs          % 30 seconds

figure;
plot(t, ecg);
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('Raw ECG');
% CHECKPOINT: a 30 s signal, tall spikes about once per second,
% and the whole thing slowly drifts up and down.


%% Section 3: Zoom in and take basic stats  (~15 min)
% Indexing: ecg(5) is the 5th sample. ecg(1:10) is the first ten.
% MATLAB counts from 1, not 0!
idx = 1 : 5*fs;            % the first 5 seconds = first 1250 samples

figure;
plot(t(idx), ecg(idx));
xlabel('Time (s)');
ylabel('Voltage (mV)');
title('First 5 seconds');
% CHECKPOINT: you can now see individual heartbeats.
% Each beat: small bump (P), tall spike (R), wider bump (T).

biggest  = max(ecg)
smallest = min(ecg)
average  = mean(ecg)
% Question for the room: the mean is not zero. Why? (Answer: the drift.)


%% ---------------------- BREAK (5 min) ----------------------


%% Section 4: Clean the signal  (~15 min)
% Step A: find the slow drift by averaging over 1 second (fs samples).
% Heartbeats average out; the slow wander is what's left.
baseline = movmean(ecg, fs);

figure;
plot(t, ecg); hold on;
plot(t, baseline, 'r', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Voltage (mV)');
legend('Raw ECG', 'Baseline (1 s average)');
title('Finding the drift');
% CHECKPOINT: the red line follows the slow wander of the blue signal.

% Step B: subtract the drift so the signal sits flat around zero.
ecg_flat = ecg - baseline;

% Step C: a SHORT average (5 samples = 0.02 s) removes fuzz but keeps
% the spikes sharp. Try 50 instead of 5 and see what happens to the peaks!
ecg_clean = movmean(ecg_flat, 5);

figure;
plot(t(idx), ecg(idx)); hold on;
plot(t(idx), ecg_clean(idx), 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Voltage (mV)');
legend('Raw', 'Cleaned');
title('Before vs after cleaning');
% CHECKPOINT: orange signal is flat around 0, R-peaks still sharp.


%% Section 5: Find the heartbeats  (~20 min)
% An R-peak is a point that is:
%   (1) a local maximum (higher than its neighbours), AND
%   (2) tall (above a threshold), AND
%   (3) not too close to another peak (heart can't beat twice in 0.3 s)
threshold = 0.5 * max(ecg_clean);          % half of the tallest point

isPeak = islocalmax(ecg_clean, 'MinSeparation', round(0.3*fs)) ...
         & (ecg_clean > threshold);
% isPeak is a list of true/false, one per sample. true = "a beat is here".

peak_times   = t(isPeak);                   % WHEN each beat happened (s)
peak_heights = ecg_clean(isPeak);           % HOW TALL each beat was

num_beats = sum(isPeak)                     % true counts as 1

figure;
plot(t, ecg_clean); hold on;
plot(peak_times, peak_heights, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
yline(threshold, '--k', 'threshold');
xlabel('Time (s)'); ylabel('Voltage (mV)');
title(sprintf('Detected %d heartbeats', num_beats));
% CHECKPOINT: a red circle on top of every tall spike, none on the T waves.
% About 35 beats in 30 s.


%% Section 6: Calculate heart rate  (~15 min)
% diff gives the gap between neighbours: diff([1 3 6]) = [2 3]
rr = diff(peak_times);          % seconds between beats ("RR intervals")

avg_bpm = 60 / mean(rr)         % beats per minute
% CHECKPOINT: about 72 bpm.

% Heart rate for EVERY beat. Note the ./  (element-wise division!)
hr = 60 ./ rr;

figure;
plot(peak_times(2:end), hr, '-o');
xlabel('Time (s)'); ylabel('Heart rate (bpm)');
ylim([40 120]);
title(sprintf('Heart rate over time (average %.0f bpm)', avg_bpm));
% CHECKPOINT: wiggles between roughly 65 and 80 bpm.
% That small beat-to-beat variation is real biology: heart rate variability.


%% Section 7: Challenge -- a messier signal  (~10 min)
% Go back to Section 2, change 'ecg_data.mat' to 'ecg_noisy.mat',
% and re-run Sections 2 to 6. Then answer:
%
% Q1. What BPM do you get now? Is that possible for a living person?
%     -> About 5 bpm, with only 2 beats found. Not possible.
%
% Q2. Look at the raw plot. What is different? Why did that break Section 5?
%     -> Two huge spikes (motion artifacts, e.g. a patient bumping a lead).
%        threshold = 0.5*max(...) is now based on the ARTIFACT, so it sits
%        above every real heartbeat.
%
% Q3. Change ONE line to fix it.
%     -> Look at the cleaned plot and pick a value by eye:
%            threshold = 0.5;
%        Now ~36 beats, ~74 bpm. Close! (Lesson: always look at your data.)
%
% Q4 (bonus). The heart-rate plot has a weird jump to ~160 bpm. Why?
%     How could you make avg_bpm ignore it?
%     -> One artifact was counted as an extra "beat". Use the median,
%        which ignores a few outliers:
%            avg_bpm = 60 / median(rr)      % ~72 bpm again


%% Stretch goal (take-home): make it reusable with a function
% The function is defined at the very bottom of this file.
load('ecg_data.mat');
bpm_from_function = estimateHR(ecg, fs, 0.5)


%% ------------------------------------------------------------------
%  Local functions must go at the END of a script file.
function bpm = estimateHR(ecg, fs, threshold)
% estimateHR  Estimate average heart rate (bpm) from a raw ECG signal.
%   bpm = estimateHR(ecg, fs, threshold)
    baseline  = movmean(ecg, fs);
    ecg_clean = movmean(ecg - baseline, 5);
    isPeak    = islocalmax(ecg_clean, 'MinSeparation', round(0.3*fs)) ...
                & (ecg_clean > threshold);
    t   = (0:length(ecg)-1) / fs;
    rr  = diff(t(isPeak));
    bpm = 60 / median(rr);
end
