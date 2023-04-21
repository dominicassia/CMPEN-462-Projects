clc;
clear all;
close all;

n=2;

shift_reg = zeros(1,n);
shift_reg(1) = 1;
pn_sequence = zeros(1,2^n);

% Generate
for i = 1:2^n
    pn_sequence(i) = shift_reg(n);
    for j = 1:n-1
        shift_reg(n-j+1) = shift_reg(n-j);
    end
    shift_reg(1) = xor(pn_sequence(i), shift_reg(1)); % n=6
end

pn_sequence = [0, 1, 0, 1];

pn_sequence = 2*pn_sequence - 1;

% figure;
% % Plot PN Sequence
% stairs(0:length(pn_sequence)-1, pn_sequence);
% ylim([-2, 2]);
% title('PN Sequence');

fc = 10;
sample_factor = 20;
fs = sample_factor * fc;

res = 0.08374023;
Tc = res/343.0;
%Tc = 1/fs;
samples_per_chip = fs*Tc;
duration = 1;
total_chips = ceil(duration*(1/Tc));

t = 0 : 1/fs : (total_chips*Tc)-(1/fs);

carrier = cos(2*pi*fc*t);

for i = 1:length(carrier)
    idx = floor(i/samples_per_chip);
    tx_signal(i) = carrier(i) * pn_sequence(idx+1 - floor(idx/n)*n);
end

figure;
% Plot Carrier
plot(t, carrier);
title('Carrier');
ylim([-2, 2]);

figure;
% Plot tx
plot(t, tx_signal);
title('Tx');
ylim([-2, 2]);

