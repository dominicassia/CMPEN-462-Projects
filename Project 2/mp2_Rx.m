% 44.1kHz sample rate
fs = 44.1e3;

% Time vector
t = 0 : 1/fs : 2;

% Create recorder
recorder = audiorecorder(fs,8,1);

% Record audio
recordblocking(recorder, 2);
stop(recorder);
rx_waveform = getaudiodata(recorder);

% Plot waveform
subplot(2,1,1);
plot(t, rx_waveform);
% Plot waveform spectrum
subplot(2,1,2);
plot(t, fft(rx_waveform));