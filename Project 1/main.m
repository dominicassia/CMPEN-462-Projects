%% Project 1
clc;
clear all;
close all;
%%    

% FIXME
% Given a string e.g "WirelessCommunicationSystemsandSecurityEliasKhamisy"
% make src_str = str of bits
%  e.g src_str = '010101110110100101110010011001010110110001100101011100110111001101000011011011110110110101101101011101010110111001101001011000110110000101110100011010010110111101101110010100110111100101110011011101000110010101101101011100110110000101101110011001000101001101100101011000110111010101110010011010010111010001111001010001010110110001101001011000010111001101001011011010000110000101101101011010010111001101111001';

% the string is: "WirelessCommunicationSystemsandSecurityEliasKhamisy"
% Covert to binary we get
src_str = '010101110110100101110010011001010110110001100101011100110111001101000011011011110110110101101101011101010110111001101001011000110110000101110100011010010110111101101110010100110111100101110011011101000110010101101101011100110110000101101110011001000101001101100101011000110111010101110010011010010111010001111001010001010110110001101001011000010111001101001011011010000110000101101101011010010111001101111001';

% 1 sub-frame worth of 64QAM symbols has the src_str repeated 422 time
input_str = repmat(src_str,1,422); % (1) Input stream
% split input_str into equal size strings of size 6 for 64QAM
qam64_vec = reshape(input_str, 6, []);
qam64_vec = transpose(qam64_vec);
qam64_vec = cellstr(qam64_vec);
qam64_vec = qam64_vec(1:2048*14); % trim vector to fit 1 subframe
% Perform bits to symbol mapping for 64QAM
qam64_dec_vec = bin2dec(qam64_vec); % convert from binary string to decimal
qam64_dec_vec = transpose(qam64_dec_vec);


% FIXME - map with out constellation
qam64_sym_vec = qammod(qam64_dec_vec,64);

qam64_sym_vec = qam64_sym_vec / sqrt(42); % based on table 7.1.4-1. (2) bits to symbols 64QAM
% Serial to parallel conversion to create OFDM vectors of 2048 symbols each
qam64_sym_sf = reshape(qam64_sym_vec, 2048, []); % organize as 2048x14 subframe. (3) Serial to Parallel
% Compute IFFT on the subframe
qam64_sf_ifft = ifft(qam64_sym_sf); % (5) IFFT
% Add source input bit stream to the .mat file
save ofdm_tx_sym.mat input_str


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIXME - make less tedious 

% Perform Cyclic Prefix Insertion and write the CP+OFDM symbols into a file
col = qam64_sf_ifft(:,1); % pick first column of 2048 symbols: 2048x1
col = transpose(col);
col_last160 = col(2048-160+1:2048);
qam64_tx_sym_1 = [col_last160, col];
save ofdm_tx_sym.mat qam64_tx_sym_1;
% add cyclic check to the remaining 6 symbols
% 2nd
col = qam64_sf_ifft(:,2);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_2 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_2;
% 3rd
col = qam64_sf_ifft(:,3);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_3 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_3;
% 4th
col = qam64_sf_ifft(:,4);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_4 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_4;
% 5th
col = qam64_sf_ifft(:,5);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_5 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_5;
% 6th
col = qam64_sf_ifft(:,6);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_6 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_6;
% 7th
col = qam64_sf_ifft(:,7);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_7 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_7;
% 8th
col = qam64_sf_ifft(:,8);
col = transpose(col);
col_last160 = col(2048-160+1:2048);
qam64_tx_sym_8 = [col_last160, col];
save ofdm_tx_sym.mat qam64_tx_sym_8;
% add cyclic check to the remaining 6 symbols
% 9th
col = qam64_sf_ifft(:,9);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_9 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_9;
% 10th
col = qam64_sf_ifft(:,10);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_10 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_10;
% 11th
col = qam64_sf_ifft(:,11);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_11 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_11;
% 12th
col = qam64_sf_ifft(:,12);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_12 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_12;
% 13th
col = qam64_sf_ifft(:,13);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_13 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_13;
% 14th
col = qam64_sf_ifft(:,14);
col = transpose(col);
col_last144 = col(2048-144+1:2048);
qam64_tx_sym_14 = [col_last144, col];
save ofdm_tx_sym.mat qam64_tx_sym_14;

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