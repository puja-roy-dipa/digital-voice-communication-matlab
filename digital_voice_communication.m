%% Digital Voice Communication: PCM, Manchester, QPSK and TDM
% Author: Puja Roy Dipa | ECE 3207, RUET
% Transcribed from the original assignment's code screenshots (pages 4-5).
% Requires Communications Toolbox. See README for known model limitations.
clear; clc; close all;

%% 1. Input signal
fs = 4000;                      % Sampling rate (Hz)
bits = 8;                       % Quantization bits
duration = 0.01;                % 10 ms for visualization
t = 0:1/fs:duration;
f_voice = 1000;                 % Example tone within the stated voice band
voice = 0.7*sin(2*pi*f_voice*t);
figure;
plot(t, voice); title('Original Voice Signal (4kHz BW)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

%% 2. A/D conversion: sampling and quantization
quantized = round((voice+1)/2 * (2^bits-1));
recon = 2*quantized/(2^bits-1) - 1;
figure;
stairs(t,recon); title('Quantized Signal (8-bit)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

%% 3. Manchester line coding
bin_data = de2bi(quantized,bits, 'left-msb')';
bin_data = bin_data(:)';
man = zeros(1,2*length(bin_data));
for i=1:length(bin_data)
    if bin_data(i)==1
        man(2*i-1:2*i) = [1 0];
    else
        man(2*i-1:2*i) = [0 1];
    end
end
t_man = linspace(0, t(end), length(man));
figure;
plot(t_man, man); title('Manchester Line Coded Signal');
xlabel('Time (s)'); ylabel('Level'); grid on;

%% 4. QPSK modulation
M = 4;
dataSym = reshape(man,2,[])';
dataSym = bi2de(dataSym);
qpskMod = pskmod(dataSym, M, pi/4, 'gray');
t_mod = linspace(0, t(end), length(qpskMod));
figure;
plot(t_mod, real(qpskMod)); title('QPSK Modulated Signal (I-channel)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

%% 5. TDM multiplexing: two duplicated channels
tdm = reshape([real(qpskMod); real(qpskMod)],1,[]);
t_tdm = linspace(0, t(end), length(tdm));
figure;
plot(t_tdm, tdm); title('TDM Multiplexed Signal (2 Channels)');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;

%% 6. Demultiplexing
tdm_rx1 = tdm(1:2:end);
tdm_rx2 = tdm(2:2:end);

%% 7. QPSK demodulation: channel 1
qpskDemod = pskdemod(tdm_rx1, M, pi/4, 'gray');
bin_rx = de2bi(qpskDemod,2, 'left-msb')';
bin_rx = bin_rx(:)';

%% 8. Manchester decoding
man_rx = zeros(1, length(bin_rx)/2);
for i=1:length(man_rx)
    if isequal(bin_rx(2*i-1:2*i), [1 0])
        man_rx(i) = 1;
    else
        man_rx(i) = 0;
    end
end

%% 9. Reconstruct quantized samples
quantized_rx = zeros(1, length(man_rx)/bits);
for i=1:length(quantized_rx)
    bits_rx = man_rx((i-1)*bits+1:i*bits);
    quantized_rx(i) = bi2de(bits_rx, 'left-msb');
end
recon_rx = 2*quantized_rx/(2^bits-1) - 1;

%% 10. Compare reconstructed and original signals
figure;
plot(linspace(0, t(end), length(recon_rx)), recon_rx, 'r', 'LineWidth', 1.5);
hold on;
plot(t, voice, 'b--');
title('Reconstructed Voice Signal after Demodulation');
xlabel('Time (s)'); ylabel('Amplitude');
legend('Reconstructed','Original'); grid on;
