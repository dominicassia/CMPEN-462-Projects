% SSRG, f(x) = x^11 + x^2 + 1
% GF(2048) = GF(2^11)
n = 11;

% 15kHz frequency
f = 15e3;

% 44.1kHz sample rate
fs = 44.1e3;

% Time vector
t = 0 : 1/fs : (1/fs)*(2^n)-(1/fs);

% Shift register, loading vector
shift_reg = zeros(1,2^n);
shift_reg(1) = 1;

% Output sequence
pn_sequence = zeros(1,2^n);

% Generate
for i = 1:2^n
    % Store output
    pn_sequence(i) = shift_reg(n);
    % Shift remaining
    for j = 1:n-1
        shift_reg(n-j+1) = shift_reg(n-j);
    end
    % Compute feedback
    shift_reg(1) = xor(pn_sequence(i), shift_reg(2));
end

% Create waveform
carrier = cos(2*pi*f*t);
waveform = carrier .* pn_sequence;

% Plot PN Sequence
subplot(5,1,1);
plot(t, pn_sequence);
% Plot carrier
subplot(5,1,2);
plot(t, carrier);
% Plot waveform
subplot(5,1,3);
plot(t, waveform);
% Plot carrier spectrum
subplot(5,1,4);
plot(t, fft(carrier));
% Plot waveform spectrum
subplot(5,1,5);
plot(t, fft(waveform));

% Play waveform
sound(waveform, fs);