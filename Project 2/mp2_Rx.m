%%%%%%%%%%%%%%%  Init.  %%%%%%%%%%%%%%%  

% 44.1kHz sample rate
fs = 44.1e3;

% Recording duration
duration = 2;

% Time vector
t = 0 : 1/fs : duration;

% Create recorder
recorder = audiorecorder(fs,8,1);

% Demodulation (QPSK)
a = pi/4;
qpsk_key = 0 : 1 : 3;
qpsk = [a, 3*a, 5*a, 7*a];
qpsk_mod = dictionary(qpsk_key, qpsk); % map key to value

%%%%%%%%%%%%%%%  Start  %%%%%%%%%%%%%%%  

% Record audio
recordblocking(recorder, duration);
stop(recorder);
rx_waveform = getaudiodata(recorder);

% Demodulate


% Plot waveform
subplot(2,1,1);
plot(t, rx_waveform);
% Plot waveform spectrum
subplot(2,1,2);
plot(t, fft(rx_waveform));


