clc;
clear all;
close all;

n = 11;
shift_reg = zeros(1,n);
shift_reg(1) = 1;

% Generate
for i = 1:2^n
    % Output
    pn_sequence(i) = shift_reg(n);
    % Shift
    for j = 1:n-1
        shift_reg(n-j+1) = shift_reg(n-j);
    end
    % Feedback
    shift_reg(1) = xor(pn_sequence(i), shift_reg(2)); % n=6
end

% Plot
% figure;
% stairs(0:length(pn_sequence)-1, pn_sequence);
% ylim([-0.25, 1.25]);
% title("Pn Sequence");

fc = 15e3;        % bit rate      (bps)
fs = 2 * fc;   % sample rate   
samples_per_bit = fs / fc;
t = 0 : 1/fs : length(pn_sequence)*(1/fc) - 1/fs;

% Modulate
for i = 1:length(pn_sequence)
    idx = (i-1)*samples_per_bit + 1;
    % Samples
    for j = idx:idx+samples_per_bit-1
        signal(j) = cos(2*pi*fc*t(j) + pi*pn_sequence(i));
    end
end

% Plot
% figure;
% plot(t, cos(2*pi*fc*t));
% ylim([-1.25, 1.25]);
% title("Carrier");

% Plot
% figure;
% plot(t, fft(cos(2*pi*fc*t)));
% ylim([-1.25, 1.25]);
% title("Carrier Spectrum");

% Plot
% figure;
% plot(t, signal);
% ylim([-1.25, 1.25]);
% title("Tx Signal");

% Plot
figure;
plot(t, real(fft(signal)));
title("Tx Signal Spectrum");

% Play
sound(signal, fs);

% Save
audiowrite("waveform.wav", signal, fs);


pause;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



duration = 2;
t = 0 : 1/fs : duration;
recorder = audiorecorder(fs,8,1);
