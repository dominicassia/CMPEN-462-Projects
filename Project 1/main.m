%% Project 1
clc;
clear all;
close all;
%%    

%src_str_1 = '010101110110100101110010011001010110110001100101011100110111001101000011011011110110110101101101011101010110111001101001011000110110000101110100011010010110111101101110010100110111100101110011011101000110010101101101011100110110000101101110011001000101001101100101011000110111010101110010011010010111010001111001010001010110110001101001011000010111001101001011011010000110000101101101011010010111001101111001';

str = 'WirelessCommunicationSystemsandSecurityEliasKhamisy';
% Convert to 8-bit ascii
str_ascii = dec2bin(double(str), 8);
% Convert to single horz. string
src_str = '';
for str_idx=1:length(str_ascii)
    src_str = strcat(src_str, str_ascii(str_idx, :));
end

% Repeat src_str so we have 1 sub-frame worth of symbols. (1) Input Stream
% BPSK
bpsk_input_str = repmat(src_str, 1, ceil( (2048*14*1)/(length(str)*8) ));
% QPSK
qpsk_input_str = repmat(src_str, 1, ceil( (2048*14*2)/(length(str)*8) ));
% 16 QAM
qam16_input_str = repmat(src_str, 1, ceil( (2048*14*4)/(length(str)*8) ));
% 64 QAM
qam64_input_str = repmat(src_str, 1, ceil( (2048*14*6)/(length(str)*8) ));

% Split input_str into equal size strings
% BPSK
bpsk_vec = reshape(bpsk_input_str, 1, []);
bpsk_vec = transpose(bpsk_vec);
bpsk_vec = cellstr(bpsk_vec);
% QPSK
qpsk_vec = reshape(qpsk_input_str, 2, []);
qpsk_vec = transpose(qpsk_vec);
qpsk_vec = cellstr(qpsk_vec);
% 16 QAM
qam16_vec = reshape(qam16_input_str, 4, []);
qam16_vec = transpose(qam16_vec);
qam16_vec = cellstr(qam16_vec);
% 64 QAM
qam64_vec = reshape(qam64_input_str, 6, []);
qam64_vec = transpose(qam64_vec);
qam64_vec = cellstr(qam64_vec);

% Trim vectors to fit 1 subframe
bpsk_vec  = bpsk_vec(1:2048*14); 
qpsk_vec  = qpsk_vec(1:2048*14); 
qam16_vec = qam16_vec(1:2048*14); 
qam64_vec = qam64_vec(1:2048*14); 

% Perform bits to symbol mapping
bpsk_dec_vec = bin2dec(bpsk_vec);   % convert from binary string to decimal
bpsk_dec_vec = transpose(bpsk_dec_vec);

qpsk_dec_vec = bin2dec(qpsk_vec);   % convert from binary string to decimal
qpsk_dec_vec = transpose(qpsk_dec_vec);

qam16_dec_vec = bin2dec(qam16_vec); % convert from binary string to decimal
qam16_dec_vec = transpose(qam16_dec_vec);

qam64_dec_vec = bin2dec(qam64_vec); % convert from binary string to decimal
qam64_dec_vec = transpose(qam64_dec_vec);

% Constellations
% Init some constants
a = 1/sqrt(2);
b = 1/sqrt(10);
c = 3/sqrt(10);
d = 1/sqrt(42);
e = 3/sqrt(42);
f = 5/sqrt(42);
g = 7/sqrt(42);

% BPSK
bpsk_key = 0:1:1;
bpsk = [a+a*i, -a-a*i];
bpsk_mod = dictionary(bpsk_key, bpsk); % map key to value

% QPSK
qpsk_key = 0:1:3;
qpsk = [a+a*i, a-a*i, -a+a*i, -a-a*i];
qpsk_mod = dictionary(qpsk_key, qpsk); % map key to value

% 16 QAM
qam_16_key = 0:1:15;
qam_16 = [...
     b+b*i,  b+c*i,  c+b*i,  c+c*i,...
     b-b*i,  b-c*i,  c-b*i,  c-c*i,...
    -b+b*i, -b+c*i, -c+b*i, -c+c*i,...
    -b-b*i, -b-c*i, -c-b*i, -c-c*i ...
];
qam_16_mod = dictionary(qam_16_key, qam_16); % map key to value

% 64 QAM
qam_64_key = 0:1:63;
qam_64 = [...
     e+e*i,  e+d*i,  d+e*i,  d+d*i,  e+f*i,  e+g*i,  d+f*i,  d+g*i,...
     f+e*i,  f+d*i,  g+e*i,  g+d*i,  f+f*i,  f+g*i,  g+f*i,  g+g*i,...
     e-e*i,  e-d*i,  d-e*i,  d-d*i,  e-f*i,  e-g*i,  d-f*i,  d-g*i,...
     f-e*i,  f-d*i,  g-e*i,  g-d*i,  f-f*i,  f-g*i,  g-f*i,  g-g*i,...
    -e+e*i, -e+d*i, -d+e*i, -d+d*i, -e+f*i, -e+g*i, -d+f*i, -d+g*i,...
    -f+e*i, -f+d*i, -g+e*i, -g+d*i, -f+f*i, -f+g*i, -g+f*i, -g+g*i,...
    -e-e*i, -e-d*i, -d-e*i, -d-d*i, -e-f*i, -e-g*i, -d-f*i, -d-g*i,...
    -f-e*i, -f-d*i, -g-e*i, -g-d*i, -f-f*i, -f-g*i, -g-f*i, -g-g*i ...
];
qam_64_mod = dictionary(qam_64_key ,qam_64); % map key to value

% Modulate
bpsk_sym_vec  = bpsk_mod(bpsk_dec_vec);    
qpsk_sym_vec  = qpsk_mod(qpsk_dec_vec);    
qam16_sym_vec = qam_16_mod(qam16_dec_vec); 
qam64_sym_vec = qam_64_mod(qam64_dec_vec); 

% Serial to parallel conversion - Create OFDM vectors of 2048 symbols each (3) Serial to Parallel
bpsk_sym_sf  = reshape(bpsk_sym_vec, 2048, []); 
qpsk_sym_sf  = reshape(qpsk_sym_vec, 2048, []); 
qam16_sym_sf = reshape(qam16_sym_vec, 2048, []); 
qam64_sym_sf = reshape(qam64_sym_vec, 2048, []); % organize as 2048x14 subframe. 

% Compute IFFT on the subframe (5)
bpsk_sf_ifft  = ifft(bpsk_sym_sf);
qpsk_sf_ifft  = ifft(qpsk_sym_sf);
qam16_sf_ifft = ifft(qam16_sym_sf);
qam64_sf_ifft = ifft(qam64_sym_sf);

% Add source input bitstreams to the .mat file
save ofdm_tx_sym_bpsk.mat  bpsk_input_str
save ofdm_tx_sym_qpsk.mat  qpsk_input_str
save ofdm_tx_sym_qam16.mat qam16_input_str
save ofdm_tx_sym_qam64.mat qam64_input_str

% Perform Cyclic Prefix Insertion and write the CP+OFDM symbols into a file
% 1st
col = qam64_sf_ifft(:,1); % pick first column of 2048 symbols: 2048x1
col = transpose(col);
col_last160 = col(2048-160+1:2048);
qam64_tx_sym_1 = [col_last160, col];
save ofdm_tx_sym.mat qam64_tx_sym_1;

% 2nd
col = qam64_sf_ifft(:,2);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_2 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_2;

% add cyclic check to the remaining 5 symbols
for idx_1=3:7
    col = qam64_sf_ifft(:,idx_1);
    col = transpose(col);
    col_last144 = col(2048-144+1:2048);
    qam64_tx_sym = [col_last144, col];
    save ofdm_tx_sym.mat qam64_tx_sym;
end

% 8th
col = qam64_sf_ifft(:,8);
col = transpose(col);
col_last160 = col(2048-160+1:2048);
qam64_tx_sym_8 = [col_last160, col];
save ofdm_tx_sym.mat qam64_tx_sym_8;

% add cyclic check to the remaining 6 symbols
for idx_1=9:14
    col = qam64_sf_ifft(:,idx_1);
    col = transpose(col);
    col_last144 = col(2048-144+1:2048);
    qam64_tx_sym = [col_last144, col];
    save ofdm_tx_sym.mat qam64_tx_sym;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate time scaled plot of OFDM transmit symbols sym_1 and sym_2
% First we create a time vector with Ts=1/fs, with length equal to the sum
% of the two symbol lengths
fs = 30.72e6; % 30.72MHz frequency
dt = 1 / fs;
T = (0 : 2048+160+2048+144-1) * dt;
symbol = [qam64_tx_sym_1, qam64_tx_sym_2];
% symbol = reshape(repmat(symbol(:).',10,1),1,[]);
figure
subplot(2,1,1)
plot(T, abs(symbol))
title('Amplitude')
subplot(2,1,2)
plot(T, angle(symbol))
title('Phase')