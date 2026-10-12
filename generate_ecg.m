%% generate_ecg.m  --  INSTRUCTOR ONLY
% Run this ONCE before the workshop. It creates two files to hand out:
%   ecg_data.mat   - 30 s synthetic ECG, ~72 bpm, mild drift + noise
%   ecg_noisy.mat  - same heartbeats, plus big drift, 60 Hz hum, extra
%                    noise and two "motion artifact" spikes (final challenge)
% Both files contain the same two variables: ecg (the signal) and fs
% (sampling rate in Hz), so students only change the file name to switch.
%
% Uses base MATLAB only (no toolboxes).

clear; clc; close all;
rng(42);                         % same "random" signal every time

fs  = 250;                       % samples per second
dur = 30;                        % seconds
t   = (0:dur*fs-1) / fs;         % time axis in seconds

% One heartbeat = 5 bumps (P, Q, R, S, T), each a Gaussian:
%            amplitude  offset from R (s)  width (s)
waves = [     0.15        -0.20             0.025 ;   % P wave
             -0.15        -0.05             0.010 ;   % Q
              1.00         0.00             0.012 ;   % R (the tall spike)
             -0.25         0.04             0.012 ;   % S
              0.30         0.25             0.040 ];  % T wave

heart = zeros(size(t));
tBeat  = 0.5;                    % time of first R-peak
nBeats = 0;
while tBeat < dur - 0.5
    for k = 1:size(waves, 1)
        a = waves(k,1);  mu = waves(k,2);  s = waves(k,3);
        heart = heart + a * exp(-(t - tBeat - mu).^2 / (2*s^2));
    end
    nBeats = nBeats + 1;
    tBeat  = tBeat + 60/72 + 0.03*randn;   % ~72 bpm with a little natural variation
end

% ---- Workshop signal: mild baseline drift (breathing) + small noise ----
drift = 0.3*sin(2*pi*0.2*t) + 0.1*sin(2*pi*0.05*t);
ecg   = heart + drift + 0.04*randn(size(t));
save('ecg_data.mat', 'ecg', 'fs');
ecg_main = ecg;

% ---- Challenge signal: much messier ----
ecg = heart + drift ...
    + 0.6*sin(2*pi*0.3*t) ...          % bigger wander
    + 0.12*sin(2*pi*60*t) ...          % 60 Hz power-line hum
    + 0.12*randn(size(t));             % more random noise
for c = [8.3 19.7]                      % two motion-artifact spikes, taller than any heartbeat
    ecg = ecg + 3.0*exp(-(t - c).^2 / (2*0.03^2));
end
save('ecg_noisy.mat', 'ecg', 'fs');

fprintf('Saved ecg_data.mat and ecg_noisy.mat (%d true beats in %d s)\n', nBeats, dur);

% Quick look so you can check the files are sensible
figure;
subplot(2,1,1); plot(t, ecg_main); title('ecg\_data.mat');  xlabel('Time (s)'); xlim([0 10]);
subplot(2,1,2); plot(t, ecg);      title('ecg\_noisy.mat'); xlabel('Time (s)'); xlim([0 10]);
