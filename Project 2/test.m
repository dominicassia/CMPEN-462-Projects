% SSRG, f(x) = x^9 + x^4 + 1
% GF(512) = GF(2^9)
n = 9;

% 44.1kHz sample rate
fs = 44.1e3;

% Shift register, loading vector
shift_reg = zeros(1,2^n);
shift_reg(1) = 1;

% Output sequence
pn_sequence = zeros(1,2^n);

number_bits = 2^n;
modulation_order = 4;   % QPSK
number_symbols = number_bits/log2(modulation_order);

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
    bit_sequence(i) = bin2dec( strcat(A, B));
end


fc = 1e3;

duration = number_bits / fc;  % Total modulated duration
bit_period = 1 / fc;          % Duration of one bit
sample_rate = bit_period / 4;      % Must be at least twice the operating frequency or half the period

amplitude = 1;

% Create constellation mapping (symbol to phase)
symbols = [3 1 0 2];
phases = [pi/4 3*pi/4 5*pi/4 7*pi/4];
qpsk_modulation = dictionary(symbols, phases);

% Create time vector
t = 0 : sample_rate : duration;

sample_index = (duration/(sample_rate*number_symbols));

% Create signal
for index = 1 : number_symbols
    phase = qpsk_modulation(bit_sequence(index));
    for interval = (index-1)*sample_index: index*sample_index
        signal(interval+1) = amplitude * sin(2*pi*fc*t(interval+1) + phase);
    end
end

% Plot the signal
figure;
plot(t, signal);
title('Q3: QPSK');
ylim([-2, 2]);
xlabel('Time');
ylabel('Amplitude');

% Play waveform
sound(signal, fs);
