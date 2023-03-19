% Data string, 63 characters
data = 'WirelessCommunicationSystemsandSecurityDominicAssiaEliasKhamisy';

% Convert to 8-bit ascii
bitstream = dec2bin(double(data), 8);

% Create 1ms source bitstream, 64QAM
bitstream_duration = 1e-3;
bits_per_symbol = 6;

fs = 30.72e6;   % Sample frequency
f = 15e3;       % 15KHz, subcarrier bandwidth
T = 1/f;        % 60us

% Repeat bitstream until its duration is 1ms
for index=bitstream_duration/T
    bitstream = cat(1, bitstream, bitstream);
end

% Init some constants
a = 1/sqrt(2);
b = 1/sqrt(10);
c = 3/sqrt(10);
d = 1/sqrt(42);
e = 3/sqrt(42);
f = 5/sqrt(42);
g = 7/sqrt(42);

% Init constellations
bpsk = [a+a, -a-a];
qpsk = [a+a, a-a, -a+a, -a-a];
qam_16 = [...
    b+b, b+c, c+b, c+c,...
    b-b, b-c, c-b, c-c,...
    -b+b, -b+c, -c+b, -c+c,...
    -b-b, -b-c, -c-b, -c-c];
qam_64 = [...
    e+e, e+d, d+e, d+d, e+f, e+g, d+f, d+g,...
    f+e, f+d, g+e, g+d, f+f, f+g, g+f, g+g,...
    e-e, e-d, d-e, d-d, e-f, e-g, d-f, d-g,...
    f-e, f-d, g-e, g-d, f-f, f-g, g-f, g-g,...
    -e+e, -e+d -d+e, -d+d, -e+f,-e+g, -d+f, -d+g,...
    -f+e, -f+d, -g+e, -g+d, -f+f, -f+g, -g+f, -g+g,...
    -e-e, -e-d, -d-e, -d-d,-e-f, -e-g, -d-f, -d-g,...
    -f-e, -f-d, -g-e, -g-d,-f-f, -f-g, -g-f, -g-g];




