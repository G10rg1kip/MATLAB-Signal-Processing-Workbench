clear;
clc;
close all;

%% Sampling settings
Fs = 1000;
duration = 2;
t = 0:1/Fs:duration-1/Fs;

%% Generate clean signal
signal1 = 1.0 * sin(2*pi*50*t);
signal2 = 0.5 * sin(2*pi*120*t);
signal3 = 0.3 * sin(2*pi*250*t);
cleanSignal = signal1 + signal2 + signal3;

%% Generate Gaussian noise
noiseAmplitude = 0.5;
noise = noiseAmplitude * randn(size(t));

%% Add noise to signal
noisySignal = cleanSignal + noise;

%% Time-domain comparison
figure;
subplot(2,1,1);
plot(t, cleanSignal);
xlim([0 0.1]);
xlabel('Time [s]');
ylabel('Amplitude');
title('Clean Signal');
grid on;

subplot(2,1,2);
plot(t, noisySignal);
xlim([0 0.1]);
xlabel('Time [s]');
ylabel('Amplitude');
title('Signal + Gaussian Noise');
grid on;


%% Frequency-domain analysis

N = length(cleanSignal);

% Convert both signals to frequency domain
X_clean = fft(cleanSignal);
X_noisy = fft(noisySignal);

% Two-sided magnitude spectra
P2_clean = abs(X_clean / N);
P2_noisy = abs(X_noisy / N);

% One-sided magnitude spectra
P1_clean = P2_clean(1:floor(N/2)+1);
P1_noisy = P2_noisy(1:floor(N/2)+1);

% Correct amplitudes after removing negative-frequency half
P1_clean(2:end-1) = 2 * P1_clean(2:end-1);
P1_noisy(2:end-1) = 2 * P1_noisy(2:end-1);

% Frequency axis from 0 Hz to Fs/2
f = Fs * (0:floor(N/2)) / N;

%% Compare frequency domains
figure;
subplot(2,1,1);
plot(f, P1_clean);
xlim([0 Fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Clean Signal - Frequency Domain');
grid on;

subplot(2,1,2);
plot(f, P1_noisy);
xlim([0 Fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Noisy Signal - Frequency Domain');
grid on;
%% Band-pass filter

filterOrder = 4;

lowCutoff = 30;
highCutoff = 280;

normalizedCutoff =[lowCutoff highCutoff] / (Fs/2);

[b, a] = butter(filterOrder,normalizedCutoff,'bandpass');

filteredSignal = filtfilt(b, a, noisySignal);
%% Compare signals
figure;

subplot(3,1,1);
plot(t, cleanSignal);
xlim([0 0.1]);
xlabel('Time [s]');
ylabel('Amplitude');
title('Clean Signal');
grid on;

subplot(3,1,2);
plot(t, noisySignal);
xlim([0 0.1]);
xlabel('Time [s]');
ylabel('Amplitude');
title('Noisy Signal');
grid on;

subplot(3,1,3);
plot(t, filteredSignal);
xlim([0 0.1]);
xlabel('Time [s]');
ylabel('Amplitude');
title('Filtered Signal - Band-pass 30-280 Hz');
grid on;
%% Frequency-domain analysis of filtered signal

X_filtered = fft(filteredSignal);

P2_filtered = abs(X_filtered / N);

P1_filtered = P2_filtered(1:N/2+1);

P1_filtered(2:end-1) = 2 * P1_filtered(2:end-1);

%% Compare clean, noisy, and filtered spectra

figure;

subplot(3,1,1);
plot(f, P1_clean);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Clean Signal - Frequency Domain');
xlim([0 Fs/2]);
grid on;

subplot(3,1,2);
plot(f, P1_noisy);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Noisy Signal - Frequency Domain');
xlim([0 Fs/2]);
grid on;

subplot(3,1,3);
plot(f, P1_filtered);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Filtered Signal - Frequency Domain');
xlim([0 Fs/2]);
grid on;

%% Final filtered signal in time domain

figure;

plot(t, filteredSignal);
xlim([0 0.1]);

xlabel('Time [s]');
ylabel('Amplitude');
title('Filtered Signal in Time Domain');
grid on;



%% Frequency-domain analysis of filtered signal

X_filtered = fft(filteredSignal);

P2_filtered = abs(X_filtered / N);

P1_filtered = P2_filtered(1:floor(N/2)+1);

P1_filtered(2:end-1) = 2 * P1_filtered(2:end-1);


%% Compare clean, noisy and filtered spectra

figure;

subplot(3,1,1);
plot(f, P1_clean);
xlim([0 Fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Clean Signal Spectrum');
grid on;

subplot(3,1,2);
plot(f, P1_noisy);
xlim([0 Fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Noisy Signal Spectrum');
grid on;

subplot(3,1,3);
plot(f, P1_filtered);
xlim([0 Fs/2]);
xlabel('Frequency [Hz]');
ylabel('Magnitude');
title('Filtered Signal Spectrum');
grid on;