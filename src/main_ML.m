% main_ML.m
% 功能：实现MIMO信号的ML算法检测仿真
% 描述：
% 作者:             zhangcheng
% 创建日期:          2019-10-31
% 最后更新日期:       2019-10-31
clc;
clear;
close all;

tic;

% 参数设置
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 1000;                    % 每个帧的符号个数
packetNumber = 10;                     % 分组个数
targetNeb = 500;                        % 目标错误比特数
targetBer = 1e-5;                       % 目标BER
modulation = '64QAM';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1022QAM
nT = 4;                                 % 发送天线数目
nR = 4;                                 % 

% 不同检测算法下的误码率
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % 不同信噪比下ML算法的BER
marker = ['-*'];                        % 不同算法下BER曲线的标记
nMarker = length(marker);               % 算法的种类数目

% 计算BER
nTotalBits = zeros(1, nEbNo);           % 不同EbNo所有分组的发送比特总数
nErrorBits_ML = zeros(1, nEbNo);        % 不同EbNo所有分组ML检测错误比特总数

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
        for iframeLength = 1:frameLength
            rxSymbol_ML(:,iframeLength) = ML_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength), M);
        end
        
        % MIMO星座点解映射
        rxBits_ML = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ML(iNT, :) = demodulating(rxSymbol_ML(iNT, :), modulation);
        end
        nErrorBitsFrame_ML = sum(sum(rxBits_ML~=txBits));                 % ML检测一帧的错误比特数
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ML(iEbNo) = nErrorBits_ML(iEbNo) + nErrorBitsFrame_ML;
        if(nErrorBits_ML(iEbNo) > targetNeb)
            break;
        end
    end
    ber_ML(iEbNo) =  nErrorBits_ML(iEbNo)/nTotalBits(iEbNo);
%     if(ber_ML(iEbNo) < targetBer)                         % parfor不能用
%         break;
%     end 
end

% 保存所有的数据
save(['..\outputData\','ML_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);
timeML = toc
%% BER曲线
% modulation = 'BPSK';                    % 调制方式:BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
% nT = 8;                                 % 发送天线数目
% nR = 8;                                 % 接收天线数目

load(['..\outputData\','ML_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ML, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
legend(['ML','(',num2str(nT),'x',num2str(nR),')']);