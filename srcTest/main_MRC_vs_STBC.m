% main.m
% 功能：比较siso，1x2MRC，1x4MRC，2x1Alamouti和2x2Alamouti下的BER性能

clc;
clear;
close all;

% 参数设置
EbN0Total = [0:2:20].';             % Eb/N0
frameLength = 1000;                 % 每个帧的符号个数
packetNumber = 1000;                 % 分组个数
marker = ['-*';'-d';'-s';'->';'-o'];% 不同情况下BER曲线的标记
targetNeb = 500;
modulation = '1024QAM';                 % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM

% 计算调制比特数和调制阶数
[nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK、2--QPSK、4--16QAM、6--64QAM、8--256QAM、10--1024QAM
% M   : 调制阶数

% 不同的条件下的BER
nEbN0 = length(EbN0Total);          % Eb/N0个数
nMarker = length(marker);           % nMarker种情况

% 系统调制解调函数
ber_SISO = zeros(nEbN0,1);          % siso的BER
ber_MRC12 = zeros(nEbN0,1);         % MRC12的BER
ber_MRC14 = zeros(nEbN0,1);         % MRC14的BER
ber_Alamouti21 = zeros(nEbN0,1);    % Alamouti21的BER
ber_Alamouti22 = zeros(nEbN0,1);    % Alamouti22的BER

% 自定义调制解调函数
ber_SISO_custom = zeros(nEbN0,1);          % siso的BER
ber_MRC12_custom = zeros(nEbN0,1);         % MRC12的BER
ber_MRC14_custom = zeros(nEbN0,1);         % MRC14的BER
ber_Alamouti21_custom = zeros(nEbN0,1);    % Alamouti21的BER
ber_Alamouti22_custom = zeros(nEbN0,1);    % Alamouti22的BER

ber_AWGN_theoretical = zeros(nEbN0,1);  % 理论的AWGN信道的BER
ber_SISO_theoretical = zeros(nEbN0,1);  % 理论的瑞利衰落SISO的BER
ber_MRC12_theoretical = zeros(nEbN0,1); % 理论的瑞利衰落MRC12的BER
ber_MRC14_theoretical = zeros(nEbN0,1); % 理论的瑞利衰落MRC14的BER

% 计算BER
for iEbN0 = 1:nEbN0
    EbN0 = EbN0Total(iEbN0);
    nErrorBits = zeros(1,length(marker));
    nTotalBits = zeros(1,length(marker));
    
    nErrorBits_custom = zeros(1,length(marker));
    nTotalBits_custom = zeros(1,length(marker));
    for iCase = 1:nMarker
        for iPacket = 1:packetNumber
            txNumber = randi([0,1],frameLength*nBps,1);
            txNumber_custom = txNumber;
            if contains(modulation, 'PSK')
                txSymbol = pskmod(txNumber, M, 0, 'gray');
                txSymbol_custom = modulator(txNumber_custom, modulation);
            elseif contains(modulation, 'QAM')
                txSymbol = qammod(txNumber, M, 'InputType', 'bit', 'UnitAveragePower', true);
                txSymbol_custom = modulating(txNumber, modulation);
            end
            snr_dB = 10*log10(nBps)+EbN0;
            snr_linear = 10^(snr_dB/10);
            
            if iCase == 1
                nT = 1;             % 发射天线数
                nR = 1;             % 接收天线数
                rxSymbol = SISO(txSymbol, snr_linear);
                rxSymbol_custom = SISO(txSymbol_custom, snr_linear);
            elseif iCase == 2
                nT = 1;             % 发射天线数
                nR = 2;             % 接收天线数
                rxSymbol = MRC(txSymbol, snr_linear,nR);
                rxSymbol_custom = MRC(txSymbol_custom, snr_linear,nR);
            elseif iCase == 3
                nT = 1;             % 发射天线数
                nR = 4;             % 接收天线数
                rxSymbol = MRC(txSymbol, snr_linear,nR);
                rxSymbol_custom = MRC(txSymbol_custom, snr_linear,nR);
            elseif iCase == 4
                nT = 2;             % 发射天线数
                nR = 1;             % 接收天线数
                rxSymbol = Alamouti(txSymbol, snr_linear,nT,nR);
                rxSymbol_custom = Alamouti(txSymbol_custom, snr_linear,nT,nR);
            else
                nT = 2;             % 发射天线数
                nR = 2;             % 接收天线数
                rxSymbol = Alamouti(txSymbol, snr_linear,nT,nR);
                rxSymbol_custom = Alamouti(txSymbol_custom, snr_linear,nT,nR);
            end
            % 解调
            if contains(modulation, 'PSK')
                rxNumber = pskdemod(rxSymbol, M, 0, 'gray');
                rxNumber_custom = demodulator(rxSymbol_custom, modulation);
            elseif contains(modulation, 'QAM')
                rxNumber = qamdemod(rxSymbol, M, 'OutputType', 'bit','UnitAveragePower', true);
                rxNumber_custom = demodulating(rxSymbol_custom, modulation);
            end
            
            % 计算一帧的错误比特数
            txBit = de2bi(txNumber, nBps);
            rxBit = de2bi(rxNumber, nBps);
            nErrorBitsFrame = sum(sum(txBit~=rxBit));
            nErrorBits(iCase) = nErrorBits(iCase)+nErrorBitsFrame;
            nTotalBits(iCase) = nTotalBits(iCase) + frameLength*nBps;
            
            txBit_custom = de2bi(txNumber_custom, nBps);
            rxBit_custom = de2bi(rxNumber_custom, nBps);
            nErrorBitsFrame_custom = sum(sum(txBit_custom~=rxBit_custom));
            nErrorBits_custom(iCase) = nErrorBits_custom(iCase)+nErrorBitsFrame_custom;
            nTotalBits_custom(iCase) = nTotalBits_custom(iCase) + frameLength*nBps;
            if(nErrorBits(iCase) > targetNeb)
                break;
            end
        end
    end
    ber_SISO(iEbN0) = nErrorBits(1)/nTotalBits(1);
    ber_MRC12(iEbN0) = nErrorBits(2)/nTotalBits(2);
    ber_MRC14(iEbN0) = nErrorBits(3)/nTotalBits(3);
    ber_Alamouti21(iEbN0) = nErrorBits(4)/nTotalBits(4);
    ber_Alamouti22(iEbN0) = nErrorBits(5)/nTotalBits(5);
    
    ber_SISO_custom(iEbN0) = nErrorBits_custom(1)/nTotalBits_custom(1);
    ber_MRC12_custom(iEbN0) = nErrorBits_custom(2)/nTotalBits_custom(2);
    ber_MRC14_custom(iEbN0) = nErrorBits_custom(3)/nTotalBits_custom(3);
    ber_Alamouti21_custom(iEbN0) = nErrorBits_custom(4)/nTotalBits_custom(4);
    ber_Alamouti22_custom(iEbN0) = nErrorBits_custom(5)/nTotalBits_custom(5);
end
%% BER曲线
% MRC
figure;
semilogy(EbN0Total, ber_SISO_custom, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12_custom, marker(2,:));
semilogy(EbN0Total, ber_MRC14_custom, marker(3,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)');
% MRC vs Alamouti
figure;
semilogy(EbN0Total, ber_SISO_custom, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12_custom, marker(2,:));
semilogy(EbN0Total, ber_MRC14_custom, marker(3,:));
semilogy(EbN0Total, ber_Alamouti21_custom, marker(4,:));
semilogy(EbN0Total, ber_Alamouti22_custom, marker(5,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)');

% MRC
figure;
semilogy(EbN0Total, ber_SISO, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12, marker(2,:));
semilogy(EbN0Total, ber_MRC14, marker(3,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)');
% MRC vs Alamouti
figure;
semilogy(EbN0Total, ber_SISO, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12, marker(2,:));
semilogy(EbN0Total, ber_MRC14, marker(3,:));
semilogy(EbN0Total, ber_Alamouti21, marker(4,:));
semilogy(EbN0Total, ber_Alamouti22, marker(5,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)');

% if modulation == 'PSK'
%     ber_AWGN_theoretical = berawgn(EbN0Total, 'psk', M);
%     ber_SISO_theoretical = berawgn(EbN0Total, 'psk', 1);
%     ber_MRC12_theoretical = berfading(EbN0Total, 'psk', M, 2);
%     ber_MRC14_theoretical = berfading(EbN0Total, 'psk', M, 4);
% elseif modulation == 'QAM'
%     ber_AWGN_theoretical = berawgn(EbN0Total, 'qam', M);
%     ber_SISO_theoretical = berfading(EbN0Total, 'qam', M, 1);
%     ber_MRC12_theoretical = berfading(EbN0Total, 'qam', M, 2);
%     ber_MRC14_theoretical = berfading(EbN0Total, 'qam', M, 4);
% end
% semilogy(EbN0Total, ber_AWGN_theoretical, '-^');
% semilogy(EbN0Total, ber_SISO_theoretical, '-v');
% semilogy(EbN0Total, ber_MRC12_theoretical, '-p');
% semilogy(EbN0Total, ber_MRC14_theoretical, '-h');
% legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)','AWGN theoretical','SISO theoretical', 'MRC12 theoretical', 'MRC14 theoretical','Location','best');