% main.m
% 功能：实现经典的MIMO信号检测仿真
% 描述：主要包括ML算法、ZF算法、MMSE算法、ZF-SNR-OSIC算法和MMSE-SINR-OSIC算法
% 作者:             zhangcheng
% 创建日期:          2019-10-27
% 最后更新日期:       2019-10-31
clc;
clear;
close all;

tic;

% 参数设置
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 1000;                       % 每个帧的符号个数
packetNumber = 10;                    % 分组个数
targetNeb = 500;                        % 目标错误比特数
modulation = 'BPSK';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
nT = 8;                                 % 发送天线数目
nR = 8;                                 % 接收天线数目

% 不同检测算法下的误码率
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % 不同信噪比下ML算法的BER
ber_ZF = zeros(nEbNo,1);                % 不同信噪比下ZF算法的BER
ber_MMSE = zeros(nEbNo,1);              % 不同信噪比下MMSEL算法的BER
ber_ZF_SNR_OSIC = zeros(nEbNo,1);       % 不同信噪比下ZF-SNR-OSIC算法的BER
ber_MMSE_SINR_OSIC = zeros(nEbNo,1);    % 不同信噪比下MMSE-SINR-OSIC算法的BER
marker = ['-*';'-d';'-s';'->';'-o'];    % 不同算法下BER曲线的标记
nMarker = length(marker);               % 算法的种类数目

% 计算BER
nTotalBits = zeros(1, nEbNo);           % 不同EbNo所有分组的发送比特总数
nErrorBits_ML = zeros(1, nEbNo);        % 不同EbNo所有分组ML检测错误比特总数
nErrorBits_ZF = zeros(1, nEbNo);        % 不同EbNo所有分组ZF检测错误比特总数
nErrorBits_MMSE = zeros(1, nEbNo);      % 不同EbNo所有分组MMSE检测错误比特总数

parfor iEbNo = 1 : nEbNo
    % 计算调制比特数和调制阶数
    [nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK、2--QPSK、4--16QAM、6--64QAM、8--256QAM、10--1024QAM
    % M   : 调制阶数
    EbNo = EbNoTotal(iEbNo);
    snrdB = EbNo + 10*log10(nBps);
    snrLiner = 10^(snrdB/10);
    
    % 按帧进行发送和接收
    for iPacket = 1:packetNumber
        % MIMO星座点映射
        txBits = randi([0,1], nT, frameLength*nBps);                       % 根据nBps和帧长产生二进制序列
        txSymbol = zeros(nT, frameLength);                                 % 调制后的每帧符号
        for iNT = 1:nT
            txSymbol(iNT,:) = modulating(txBits(iNT, :), modulation);
        end
        [rxSymbol, H, noisePower] = channel(txSymbol, nT, nR, snrLiner);
        
        % MIMO信号检测
        rxSymbol_ML = zeros(nT, frameLength);                             % ML检测后的信号
        rxSymbol_ZF = zeros(nT, frameLength);                             % ZF检测后的信号
        rxSymbol_MMSE = zeros(nT, frameLength);                           % MMSE检测后的信号
        for iframeLength = 1:frameLength
            rxSymbol_ML(:,iframeLength) = ML_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength), M);
            rxSymbol_ZF(:,iframeLength) = ZF_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength));
            rxSymbol_MMSE(:,iframeLength) = MMSE_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength),noisePower);
        end
        
        % MIMO星座点解映射
        rxBits_ML = zeros(nT, frameLength*nBps);
        rxBits_ZF = zeros(nT, frameLength*nBps);
        rxBits_MMSE = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ML(iNT, :) = demodulating(rxSymbol_ML(iNT, :), modulation);
            rxBits_ZF(iNT, :) = demodulating(rxSymbol_ZF(iNT, :), modulation);
            rxBits_MMSE(iNT, :) = demodulating(rxSymbol_MMSE(iNT, :), modulation);
        end
        nErrorBitsFrame_ML = sum(sum(rxBits_ML~=txBits));               % ML检测一帧的错误比特数
        nErrorBitsFrame_ZF = sum(sum(rxBits_ZF~=txBits));               % ZF检测一帧的错误比特数
        nErrorBitsFrame_MMSE = sum(sum(rxBits_MMSE~=txBits));           % MMSE检测一帧的错误比特数
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ML(iEbNo) = nErrorBits_ML(iEbNo) + nErrorBitsFrame_ML;
        nErrorBits_ZF(iEbNo) = nErrorBits_ZF(iEbNo) + nErrorBitsFrame_ZF;
        nErrorBits_MMSE(iEbNo) = nErrorBits_MMSE(iEbNo) + nErrorBitsFrame_MMSE;
    end
    ber_ML(iEbNo) =  nErrorBits_ML(iEbNo)/nTotalBits(iEbNo);
    ber_ZF(iEbNo) =  nErrorBits_ZF(iEbNo)/nTotalBits(iEbNo);
    ber_MMSE(iEbNo) =  nErrorBits_MMSE(iEbNo)/nTotalBits(iEbNo);
end

% 保存所有的数据
save(['detection_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);

toc;
%% BER曲线
modulation = 'BPSK';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
nT = 8;                                 % 发送天线数目
nR = 8;                                 % 接收天线数目

load(['detection_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ML, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
hold on;
semilogy(EbNoTotal, ber_ZF, marker(2,:));
grid on;
semilogy(EbNoTotal, ber_MMSE, marker(3,:));
grid on;
legend(['ML','(',num2str(nT),'x',num2str(nR),')'], ['ZF','(',num2str(nT),'x',num2str(nR),')'],['MMSE','(',num2str(nT),'x',num2str(nR),')']);