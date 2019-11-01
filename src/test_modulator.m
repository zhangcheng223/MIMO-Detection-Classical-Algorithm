% test_modulator.m
% 功能：测试modulator和demodulator的正确性
% 描述：
% 作者:             zhangcheng
% 创建日期:          2019-10-29
% 最后更新日期:       2019-10-29
clc;
clear;
close all;

% 参数设置
EbNoTotal = [0:2:20].';                 % Eb/N0
frameLength = 1000;                     % 每个帧的符号个数
packetNumber = 10;                      % 分组个数
targetNeb = 500;                        % 目标错误比特数
modulation = 'BPSK';                   % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
nT = 4;                                 % 发送天线数目
nR = 4;                                 % 接收天线数目

% 不同检测算法下的误码率
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % 不同信噪比下ML算法的BER
ber_ZF = zeros(nEbNo,1);                % 不同信噪比下ZF算法的BER
ber_MMSE = zeros(nEbNo,1);              % 不同信噪比下MMSEL算法的BER
ber_ZF_SNR_OSIC = zeros(nEbNo,1);       % 不同信噪比下ZF-SNR-OSIC算法的BER
ber_MMSE_SINR_OSIC = zeros(nEbNo,1);    % 不同信噪比下MMSE-SINR-OSIC算法的BER
marker = ['-*';'-d';'-s';'->';'-o'];    % 不同算法下BER曲线的标记
nMarker = length(marker);               % 算法的种类数目

% 计算调制比特数和调制阶数
[nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK、2--QPSK、4--16QAM、6--64QAM、8--256QAM、10--1024QAM
% M   : 调制阶数
% 计算BER
nErrorBitsSystem = zeros(1, nEbNo);
nErrorBits = zeros(1, nEbNo);
nTotalBits = zeros(1, nEbNo);
for iEbNo = 1 : nEbNo
    EbNo = EbNoTotal(iEbNo);
    
    snr_dB = EbNo + 10*log10(nBps);
    
    for iPacket = 1:packetNumber
        txBits = randi([0,1], nT, frameLength*nBps);                       % 根据nBps和帧长产生二进制序列
        rxBitSystem = zeros(size(txBits));
        txSymbol = zeros(nT, frameLength);                                 % 调制后的每帧符号
        txSymbolSystem = zeros(nT, frameLength);                          % qammod函数产生的符号
        for iNT = 1:nT
            txSymbolSystem(iNT,:) = qammod(txBits(iNT, :).', M, 'InputType', 'bit', 'UnitAveragePower',true);
            txSymbol(iNT,:) = modulator(txBits(iNT, :), modulation);
        end
        sumError = sum(sum(abs(txSymbol-txSymbolSystem).^2));
        if sumError<0.001
            fprintf('%f: modulator is good.\n', sumError);
        else
            fprintf('%f: modulator is bad.\', sumError);
        end
        
        rxSymbol = txSymbol;                                    % 不加噪声
        rxSymbolSystem = txSymbolSystem;                        % 不加噪声
        rxBits = zeros(nT, size(rxSymbol,2)*nBps);              % 解映射后的bit
        rxBitsSystem = zeros(nT, size(rxSymbol,2)*nBps);        % 系统函数解映射后的bit
        for iNT = 1:nT
            rxBitsSystemArray = qamdemod(rxSymbolSystem(iNT,:), M, 'OutputType', 'bit', 'UnitAveragePower',true);
            rxBitsSystem(iNT,:) = rxBitsSystemArray(:);
            
            rxBits(iNT,:) = demodulator(rxSymbol(iNT,:), modulation);
        end
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps;
        nErrorBitsFrameSystem = sum(sum(txBits~=rxBitsSystem));
        nErrorBitsSystem(iEbNo) = nErrorBitsSystem(iEbNo) + nErrorBitsFrameSystem;
        
        nErrorBitsFrame = sum(sum(txBits~=rxBits));
        nErrorBits(iEbNo) = nErrorBits(iEbNo) + nErrorBitsFrame;
    end
end
