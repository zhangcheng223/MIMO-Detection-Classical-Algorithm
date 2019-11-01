function [modSymbol, modTable] = modulating(bitSequence, modulation)
%函数的功能：对比特序列按给定的调制方式进行星座点映射
%函数的描述：(1) 识别调制方式modulation
%          (2) 生成归一化星座点映射表
%          (3) 以每个符号的比特数为单元进行星座点映射
%函数的使用：[modSymbol, modTable] = modulator(bitSequence, modulation)
%输入：
%     bitSequence: 二进制列向量bit序列
%     modulation : 调制方式：BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
%输出：
%     modSymbol: 调制后的符号
%     modTable : 星座点映射表
%例子：[modSymbol, modTable] = modulator(bitSequence, '16QAM')

%作者:             zhangcheng
%创建日期:          2019-10-28
%最后更新日期:       2019-10-29

global symbolIndexBpsk;
global symbolIndexQpsk;
global symbolIndexQam16;
global symbolIndexQam64;
global symbolIndexQam256;
global symbolIndexQam1024;

nBitSequence = length(bitSequence);

% BPSK
if strcmp(modulation, 'BPSK')
    nBps = 1;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % BPSK星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = inp;                                                        % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexBpsk(binNumber+1);                              % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
    modSymbol = modSymbol(:);                                               % 转化为列向量
    
    % QPSK
elseif strcmp(modulation, 'QPSK')   
    nBps = 2;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % QPSK星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = [2 1]*inp;                                                  % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexQpsk(binNumber+1);                              % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
    
    % 16QAM
elseif strcmp(modulation, '16QAM')
    nBps = 4;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 16星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = [8 4 2 1]*inp;                                              % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexQam16(binNumber+1);                             % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
    
    % 64QAM
elseif strcmp(modulation, '64QAM')
    nBps = 6;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 64星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = [32 16 8 4 2 1]*inp;                                        % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexQam64(binNumber+1);                             % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
    
    % 256QAM
elseif strcmp(modulation, '256QAM')
    nBps = 8;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 256星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = [128 64 32 16 8 4 2 1]*inp;                                 % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexQam256(binNumber+1);                            % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
    
    % 1024QAM
elseif strcmp(modulation, '1024QAM')
    nBps = 10;                                                              % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 1024星座点表
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % 原始列向量转化为nBps x (nBitSequence/nBps)的矩阵，其中列向量表示一个星座点
    binNumber = [512 256 128 64 32 16 8 4 2 1]*inp;                         % nBps个比特二进制映射对应的十进制数
    grayNumber = symbolIndexQam1024(binNumber+1);                           % nBps个比特格雷码映射对应的十进制数
    modSymbol = modTable(grayNumber+1);                                     % nBps个比特格雷码映射对应的星座点
else
    error('Unimplemented modulation');
end
end