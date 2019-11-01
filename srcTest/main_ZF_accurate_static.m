% main_ZF.m
% 功能：实现MIMO信号的ZF算法检测仿真
% 描述：
% 作者:             zhangcheng
% 创建日期:          2019-10-21
% 最后更新日期:       2019-10-31
clc;
clear;
close all;

tic;

% 参数设置
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 10000;                       % 每个帧的符号个数
packetNumber = 100;                    % 分组个数
targetNeb = 1000;                        % 目标错误比特数
targetBer = 1e-5;                       % 目标BER
modulation = 'QPSK';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
nT = 4;                                 % 发送天线数目
nR = 4;                                 % 接收天线数目

% 不同检测算法下的误码率
nEbNo = length(EbNoTotal);
ber_ZF = zeros(nEbNo,1);                % 不同信噪比下ZF算法的BER
marker = ['-*'];                        % 不同算法下BER曲线的标记
nMarker = length(marker);               % 算法的种类数目

% 计算BER
nTotalBits = zeros(1, nEbNo);           % 不同EbNo所有分组的发送比特总数
nErrorBits_ZF = zeros(1, nEbNo);        % 不同EbNo所有分组ZF检测错误比特总数

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
        [rxSymbol, H, noisePower] = channel_accurate_static(txSymbol, nT, nR, snrLiner);
        
        % MIMO信号检测
        rxSymbol_ZF = zeros(nT, frameLength);                             % ZF检测后的信号
        for iframeLength = 1:frameLength
            rxSymbol_ZF(:,iframeLength) = ZF_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength));
        end
        
        % MIMO星座点解映射
        rxBits_ZF = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ZF(iNT, :) = demodulating(rxSymbol_ZF(iNT, :), modulation);
        end
        nErrorBitsFrame_ZF = sum(sum(rxBits_ZF~=txBits));                 % ZF检测一帧的错误比特数
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ZF(iEbNo) = nErrorBits_ZF(iEbNo) + nErrorBitsFrame_ZF;
        if(nErrorBits_ZF(iEbNo) > targetNeb)
            break;
        end
    end
    ber_ZF(iEbNo) =  nErrorBits_ZF(iEbNo)/nTotalBits(iEbNo);
%     if(ber_ZF(iEbNo) < targetBer)                         % parfor不能用
%         break;
%     end
end

% 保存所有的数据
save(['..\outputDataTest\accurateStaticChannel\','ZF_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);
toc;
%% BER曲线
% modulation = 'BPSK';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
% nT = 2;                                 % 发送天线数目
% nR = 2;                                 % 接收天线数目

load(['..\outputDataTest\accurateStaticChannel\','ZF_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ZF, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
legend(['ZF','(',num2str(nT),'x',num2str(nR),')']);