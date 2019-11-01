function [nBps, M] = set_modulator(modulation)
%函数的功能：根据给定了调制方式计算调制符号比特数和调制阶数
%函数的描述：（详细）
%函数的使用：[nBps, M] = set_modulator(modulation)
%输入：
%     modulation: 调制方式
%输出：
%     nBps: 每个调制符号的比特数
%     M   : 调制阶数
%例子：[nBps, M]=set_modulator('16QAM');

%作者:             zhangcheng
%创建日期:          2019-10-28
%最后更新日期:       2019-10-28
global symbolIndexBpsk;
global mapBpsk;
global symbolIndexQpsk;
global mapQpsk;
global symbolIndexQam16;
global mapQam16;
global symbolIndexQam64;
global mapQam64;
global symbolIndexQam256;
global mapQam256;
global symbolIndexQam1024;
global mapQam1024;

switch(modulation)
    case 'BPSK'
        nBps = 1;
        M = 2;
        indexGrayBpsk = csvread('../inputData/BPSK.csv');
        symbolIndexBpsk = indexGrayBpsk(:,1);
        mapBpsk = indexGrayBpsk(:,2);
    case 'QPSK'
        nBps = 2;
        M = 4;
        indexGrayQpsk = csvread('../inputData/QPSK.csv');
        symbolIndexQpsk = indexGrayQpsk(:,1);
        mapQpsk = indexGrayQpsk(:,2);
    case '16QAM'
        nBps = 4;
        M = 16;
        indexGrayQam16 = csvread('../inputData/QAM16.csv');
        symbolIndexQam16 = indexGrayQam16(:,1);
        mapQam16 = indexGrayQam16(:,2);
    case '64QAM'
        nBps = 6;
        M = 64;
        indexGrayQam64 = csvread('../inputData/QAM64.csv');
        symbolIndexQam64 = indexGrayQam64(:,1);
        mapQam64 = indexGrayQam64(:,2);
    case '256QAM'
        nBps = 8;
        M = 256;
        indexGrayQam256 = csvread('../inputData/QAM256.csv');
        symbolIndexQam256 = indexGrayQam256(:,1);
        mapQam256 = indexGrayQam256(:,2);
    case '1024QAM'
        nBps = 10;
        M = 1024;
        indexGrayQam1024 = csvread('../inputData/QAM1024.csv');
        symbolIndexQam1024 = indexGrayQam1024(:,1);
        mapQam1024 = indexGrayQam1024(:,2);
    otherwise
        error('Unimplemented modulation');
end
end