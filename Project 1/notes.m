
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constellations

% Init some constants
a = 1/sqrt(2);
b = 1/sqrt(10);
c = 3/sqrt(10);
d = 1/sqrt(42);
e = 3/sqrt(42);
f = 5/sqrt(42);
g = 7/sqrt(42);

% Init constellations
bpsk_key = 0:1:1;
bpsk = [a+a, -a-a];
qpsk_key = 0:1:3;
qpsk = [a+a, a-a, -a+a, -a-a];
qam_16_key = 0:1:15;
qam_16 = [...
    b+b, b+c, c+b, c+c,...
    b-b, b-c, c-b, c-c,...
    -b+b, -b+c, -c+b, -c+c,...
    -b-b, -b-c, -c-b, -c-c];
qam_64_key = 0:1:63;
qam_64 = [...
    e+e, e+d, d+e, d+d, e+f, e+g, d+f, d+g,...
    f+e, f+d, g+e, g+d, f+f, f+g, g+f, g+g,...
    e-e, e-d, d-e, d-d, e-f, e-g, d-f, d-g,...
    f-e, f-d, g-e, g-d, f-f, f-g, g-f, g-g,...
    -e+e, -e+d -d+e, -d+d, -e+f,-e+g, -d+f, -d+g,...
    -f+e, -f+d, -g+e, -g+d, -f+f, -f+g, -g+f, -g+g,...
    -e-e, -e-d, -d-e, -d-d,-e-f, -e-g, -d-f, -d-g,...
    -f-e, -f-d, -g-e, -g-d,-f-f, -f-g, -g-f, -g-g];
bpsk_mod = dictionary(bpsk_key, bpsk);
qpsk_mod = dictionary(qpsk_key, qpsk);
qam_16_mod = dictionary(qam_16_key, qam_16);
qam_64_mod = dictionary(qam_64_key, qam_64);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2048 OFDM sub-carriers
% WirelessCommunicationSystemsandSecurityEliasKhamisy repeated n times
% Covert to 1msec worth of data:
% •	51 characters, each is 8bits for total of 51*8=408bits in the string
% •	001101000011011011110110110101101101011101010110111001101001011000110110000101110100011010010110111101101110010100110111100101110011011101000110010101101101011100110110000101101110011001000101001101100101011000110111010101110010011010010111010001111001010001010110110001101001011000010111001101001011011010000110000101101101011010010111001101111001
% •	1msec worth of data is 1 sub-frame which is 2 slots
% •	The data is striped over 2048 sub-carriers over a period of 14 symbols. That is, the first 2048 symbols are sent first, then the next 2048 symbols, until the 14th 2048 symbols
% •	One sub-frame is: 2048 * 14 symbols
% •	The string above must be repeated 2048*14*6/ 408 = 421.6 times. We round it to 422 times
% •	Create a vector of size 422 of the above binary string
% •	Using the Matlab reshape() function create a matrix of 7x2048 from the vector, with each element being a string of 6bits (for 64QAM)
% •	Convert the 6bit string into decimal number using bin2dec() function
% •	Now we have a matric of 7x2048 of the numbers we want to convert to 64QAM symbols
% •	Use the function y = qammod(x,64) to create the 64QAM symbols. Divide by sqrt(42) to match the table in the word doc. Now you got I and Q vectors
% •	Pass the vector through IFFT using the Matlab IFFT command
% •	To add the Cyclic Prefix we follow this calculation:
    % o	After IFFT we serialize the OFDM symbols. There are total of 2048 symbols coming out of IFFT
    % o	Since each OFDM symbol is at 15KHz, when we serialize the bandwidth is 2048x15KHz = 30.72MHz
    % o	The time slot corresponding to 30.72MHz is 1/30.72MHz = 0.032552083usec (How much time each symbol takes to send after serialized)
    % o	Hence, for 5.2usec we get 5.2/0.032552083 = 159.744. We round up to 160
    % o	And, 4.7usec we get 144.384. We round down to 144
% •	To add Cyclic Prefix we do the following in each slot of 7 by 2048
    % o	For the first 2048 symbols in a slot we add 160 symbols equal to the symbols 2047-160+1 to 2047
    % o	For the rest of the 6 2048 symbols in a slot we add 144 symbols equal to the symbols 2047-144+1 to 2047