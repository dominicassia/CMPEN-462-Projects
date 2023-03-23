%% Project 1
clc;
clear all;
close all;

str = 'WirelessCommunicationSystemsandSecurityDominicAssiaEliasKhamisy';
str_ascii = dec2bin(double(str), 8); % Convert to 8-bit ascii
% Convert to single horz. string
src_str = '';
for str_idx=1:length(str_ascii)
src_str = strcat(src_str, str_ascii(str_idx, :));
end

%% (1) Input Stream
% Repeat src_str so we have 1 sub-frame worth of symbols. 
bpsk_input_str = repmat(src_str, 1, ceil( (2048*14*1)/(length(str)*8) )); % BPSK 28728
qpsk_input_str = repmat(src_str, 1, ceil( (2048*14*2)/(length(str)*8) )); % QPSK 57456
qam16_input_str = repmat(src_str, 1, ceil( (2048*14*4)/(length(str)*8) )); % 16 QAM
qam64_input_str = repmat(src_str, 1, ceil( (2048*14*6)/(length(str)*8) )); % 64 QAM

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constellations
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
bpsk = [a+a*1i, -a-a*1i];
bpsk_mod = dictionary(bpsk_key, bpsk); % map key to value

% QPSK
qpsk_key = 0:1:3;
qpsk = [a+a*1i, a-a*1i, -a+a*1i, -a-a*1i];
qpsk_mod = dictionary(qpsk_key, qpsk); % map key to value

% 16 QAM
qam_16_key = 0:1:15;
qam_16 = [...
     b+b*1i,  b+c*1i,  c+b*1i,  c+c*1i,...
     b-b*1i,  b-c*1i,  c-b*1i,  c-c*1i,...
    -b+b*1i, -b+c*1i, -c+b*1i, -c+c*1i,...
    -b-b*1i, -b-c*1i, -c-b*1i, -c-c*11i ...
];
qam_16_mod = dictionary(qam_16_key, qam_16); % map key to value

% 64 QAM
qam_64_key = 0:1:63;
qam_64 = [...
     e+e*1i,  e+d*1i,  d+e*1i,  d+d*1i,  e+f*1i,  e+g*1i,  d+f*1i,  d+g*1i,...
     f+e*1i,  f+d*1i,  g+e*1i,  g+d*1i,  f+f*1i,  f+g*1i,  g+f*1i,  g+g*1i,...
     e-e*1i,  e-d*1i,  d-e*1i,  d-d*1i,  e-f*1i,  e-g*1i,  d-f*1i,  d-g*1i,...
     f-e*1i,  f-d*1i,  g-e*1i,  g-d*1i,  f-f*1i,  f-g*1i,  g-f*1i,  g-g*1i,...
    -e+e*1i, -e+d*1i, -d+e*1i, -d+d*1i, -e+f*1i, -e+g*1i, -d+f*1i, -d+g*1i,...
    -f+e*1i, -f+d*1i, -g+e*1i, -g+d*1i, -f+f*1i, -f+g*1i, -g+f*1i, -g+g*1i,...
    -e-e*1i, -e-d*1i, -d-e*1i, -d-d*1i, -e-f*1i, -e-g*1i, -d-f*1i, -d-g*1i,...
    -f-e*1i, -f-d*1i, -g-e*1i, -g-d*1i, -f-f*1i, -f-g*1i, -g-f*1i, -g-g*1i ...
];
qam_64_mod = dictionary(qam_64_key, qam_64); % map key to value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Perform Cyclic Prefix Insertion and write the CP+OFDM symbols into a file

%% Calculation for CP size
%   Given: sample rate of fs = 30.72MHz and sub-carrier bandwidth of 15kHz
%   To add the Cyclic Prefix we follow this calculation:
    %   After IFFT we serialize the OFDM symbols. 
    %   There are total of 2048 symbols coming out of IFFT
    %   Since each OFDM symbol is at 15KHz,
    %       when we serialize the bandwidth is 2048x15KHz = 30.72MHz
    %   The time slot corresponding to 30.72MHz is 
    %       1/30.72MHz = 0.032552083usec 
    %   This is how much time each symbol takes to send after serialized
    %   Hence, for 5.2usec we get 5.2/0.032552083 = 159.744 -> 160
    %   And, 4.7usec we get 144.384 -> 144
%   To add Cyclic Prefix we do the following in each slot of 7 by 2048
    %   For the first 2048 symbols in a slot we add 160 symbols equal
    %       to the symbols 2047-160+1 to 2047
    %   For the rest of the 6 2048 symbols in a slot we add 144 symbols
    %       equal to the symbols 2047-144+1 to 2047

for idx=1:14
    bpsk_col = bpsk_sf_ifft(:,idx);
    bpsk_col = transpose(bpsk_col);

    qpsk_col = qpsk_sf_ifft(:,idx);
    qpsk_col = transpose(qpsk_col);

    qam16_col = qam16_sf_ifft(:,idx);
    qam16_col = transpose(qam16_col);
    
    qam64_col = qam64_sf_ifft(:,idx);
    qam64_col = transpose(qam64_col);

    if idx == 1 || idx == 8
        eval(sprintf('bpsk_tx_sym_%d = [bpsk_col(2048-160+1:2048),bpsk_col];', idx)); % BPSK
        eval(sprintf('qpsk_tx_sym_%d = [qpsk_col(2048-160+1:2048),qpsk_col];', idx)); % QPSK
        eval(sprintf('qam16_tx_sym_%d = [qam16_col(2048-160+1:2048),qam16_col];', idx)); % 16QAM
        eval(sprintf('qam64_tx_sym_%d = [qam64_col(2048-160+1:2048),qam64_col];', idx)); % 64QAM
    else
        eval(sprintf('bpsk_tx_sym_%d = [bpsk_col(2048-144+1:2048),bpsk_col];', idx)); % BPSK
        eval(sprintf('qpsk_tx_sym_%d = [qpsk_col(2048-144+1:2048),qpsk_col];', idx)); % QPSK
        eval(sprintf('qam16_tx_sym_%d = [qam16_col(2048-144+1:2048),qam16_col];', idx)); % 16QAM
        eval(sprintf('qam64_tx_sym_%d = [qam64_col(2048-144+1:2048),qam64_col];', idx)); % 64QAM

    end
    % Save
    eval(sprintf('save ofdm_tx_sym.mat bpsk_tx_sym_%d;', idx)); % BPSK
    eval(sprintf('save ofdm_tx_sym.mat qpsk_tx_sym_%d;', idx)); % QPSK
    eval(sprintf('save ofdm_tx_sym.mat qam16_tx_sym_%d;', idx)); % 16QAM
    eval(sprintf('save ofdm_tx_sym.mat qam64_tx_sym_%d;', idx)); % 64QAM
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
% Generate time scaled plot of OFDM transmit symbols sym_1 and sym_2
% First we create a time vector with Ts=1/fs, with length equal to the sum
% of the two symbol lengths
fs = 30.72e6; % 30.72MHz frequency
dt = 1 / fs;
T = (0 : 2048+160+2048+144-1) * dt;

bpsk_symbol = [bpsk_tx_sym_1, bpsk_tx_sym_2];
qpsk_symbol = [qpsk_tx_sym_1, qpsk_tx_sym_2];
qam16_symbol = [qam16_tx_sym_1, qam16_tx_sym_2];
qam64_symbol = [qam64_tx_sym_1, qam64_tx_sym_2];

figure
subplot(4,2,1)
plot(T,real(qam64_symbol));
title('64QAM I(t)');
subplot(4,2,2)
plot(T,imag(qam64_symbol));
title('64QAM Q(t)');

subplot(4,2,3)
plot(T,real(qam16_symbol));
title('16QAM I(t)');
subplot(4,2,4)
plot(T,imag(qam16_symbol));
title('16QAM Q(t)');

subplot(4,2,5)
plot(T,real(qpsk_symbol));
title('QPSK I(t)');
subplot(4,2,6)
plot(T,imag(qpsk_symbol));
title('QPSK Q(t)');

subplot(4,2,7)
plot(T,real(bpsk_symbol));
title('BPSK I(t)');
subplot(4,2,8)
plot(T,imag(bpsk_symbol));
title('BPSK Q(t)');

sgtitle("Two Transmit OFDM Symbols")
