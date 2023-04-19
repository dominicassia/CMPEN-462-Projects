clc;
clear all;
close all;

%%%%%%%%%%%%%%%  Init.  %%%%%%%%%%%%%%%  

% SSRG, f(x) = x^11 + x^2 + 1
% GF(2048) = GF(2^11)
%n = 11;

% SSRG, f(x) = x^9 + x^4 + 1
% GF(512) = GF(2^9)
n = 9;

% 1kHz frequency
f = 1e3;

% 44.1kHz sample rate
fs = 44.1e3;

% Time vector
t = 0 : 1/fs : (1/fs)*(2^n)/2-(1/fs);

% Shift register, loading vector
shift_reg = zeros(1,2^n);
shift_reg(1) = 1;

% Output sequence
pn_sequence = zeros(1,2^n);

% Reference carrier
carrier = cos(2*pi*f*t);

%%%%%%%%%%%%%%%  Start  %%%%%%%%%%%%%%%  

% Generate
for i = 1:2^n
    % Store output
    pn_sequence(i) = shift_reg(n);
    % Shift remaining
    for j = 1:n-1
        shift_reg(n-j+1) = shift_reg(n-j);
    end
    % Compute feedback
    %shift_reg(1) = xor(pn_sequence(i), shift_reg(2)); % n=11
    shift_reg(1) = xor(pn_sequence(i), shift_reg(4)); % n=9
end

% Reshape (make str pairs for qpsk)
qpsk_vec = transpose( reshape(pn_sequence, 2, []));
for i = 1 : (2^n)/2
    A = num2str(qpsk_vec(i,1));
    B = num2str(qpsk_vec(i,2));
    % Convert to dec for qpsk
    qpsk_dec_vec(i) = bin2dec( strcat(A, B));
end

% Modulate (method 1)
waveform = pskmod(qpsk_dec_vec', 4);

% Modulate (method 2)
a = sqrt(2)/2;
qpsk_key = 0 : 1 : 3;
qpsk = [1*a, 3*a, 5*a, 7*a];
qpsk_mod = dictionary(qpsk_key, qpsk); % map key to value
phase = qpsk_mod(qpsk_dec_vec);
%waveform = cos(2*pi*f*t + phase);

%%%%%%%%%%%%%%%  Plot  %%%%%%%%%%%%%%%
figure;

% Plot carrier
subplot(2, 2, 1);
plot(t, carrier);
title('Carrier');

% Plot waveform
subplot(2, 2, 2);
plot(t, waveform);
title('Modulated Waveform / PN Sequence');

% Plot carrier spectrum
subplot(2, 2, 3);
plot(t, fft(carrier));
title('Carrier Spectrum');

% Plot waveform spectrum
subplot(2, 2, 4);
plot(t, fft(waveform));
title('Waveform Spectrum');

figure;
% Plot PN sequence
stairs(t, pn_sequence(1:256));
ylim([-2, 2]);
title('PN Sequence');

%%%%%%%%%%%%%%%  Play, Save  %%%%%%%%%%%%%%%

% Play waveform
sound(real(waveform), fs);

% Save waveform
audiowrite("waveform.wav", real(waveform), fs);