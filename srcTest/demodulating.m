function outBits = demodulating(inDataNormal, modulation)
%函数的功能：对输入数据按格雷码解映射输出对应比特数据
%函数的描述：(1) 识别调制方式modulation
%          (2) 对输入inData解归一化
%          (3) 将inData从星座点上找到对应的格雷码
%          (4) 将格雷码转换为二进制码并同时将矩阵列向量化得到outBits
%函数的使用：outBits = demodulator(inData, modulation, modTable)
%输入：
%     inData:       输入符号数据向量
%     modulation :  调制方式：BPSK、QPSK、16QAM、64QAM、256QAM、1024QAM
%     modTable:     与modulation对应的星座点表
%输出：
%     outBits: 解映射之后的比特数据，是列向量
%例子：[modSymbol, modTable] = modulator(inData, '4QAM', [-1+i; -1])

%作者:             zhangcheng
%创建日期:          2019-10-28
%最后更新日期:       2019-10-29

% BPSK
global mapQpsk;
global mapQam16;
global mapQam64;
global mapQam256;
global mapQam1024;

nInDataNormal = length(inDataNormal);           % 输入数据的长度

if strcmp(modulation, 'BPSK')
    nBps = 1;                                                               % 每个符号的比特数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    outBits(real(inDataNormal)<0 ) = 0;
    outBits(real(inDataNormal)>0 ) = 1;
    
    % QPSK
elseif strcmp(modulation, 'QPSK')
    nBps = 2;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    inData = inDataNormal*sqrt(2);                                          % 归一化符号数据转化为理想星座点数据
    inNumber = computeHardInt(inData, M);                                   % inDataNormal对应的格雷码的十进制数
    outNumber = mapQpsk(inNumber+1);                                        % inDataNormal对应的二进制码的十进制数
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % 转化为列向量
    
    % 16QAM
elseif strcmp(modulation, '16QAM')
    nBps = 4;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    inData = inDataNormal*sqrt(10);                                         % 归一化符号数据转化为理想星座点数据
    inNumber = computeHardInt(inData, M);                                   % inDataNormal对应的格雷码的十进制数
    outNumber = mapQam16(inNumber+1);                                       % inDataNormal对应的二进制码的十进制数
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % 转化为列向量
    
    % 64QAM
elseif strcmp(modulation, '64QAM')
    nBps = 6;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    inData = inDataNormal*sqrt(42);                                         % 归一化符号数据转化为理想星座点数据
    inNumber = computeHardInt(inData, M);                                   % inDataNormal对应的格雷码的十进制数
    outNumber = mapQam64(inNumber+1);                                       % inDataNormal对应的二进制码的十进制数
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % 转化为列向量
    
    % 256QAM
elseif strcmp(modulation, '256QAM')
    nBps = 8;                                                               % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    inData = inDataNormal*sqrt(170);                                        % 归一化符号数据转化为理想星座点数据
    inNumber = computeHardInt(inData, M);                                   % inDataNormal对应的格雷码的十进制数
    outNumber = mapQam256(inNumber+1);                                      % inDataNormal对应的二进制码的十进制数
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % 转化为列向量
    
    % 1024QAM
elseif strcmp(modulation, '1024QAM')
    nBps = 10;                                                              % 每个符号的比特数
    M = 2^nBps;                                                             % 调制阶数
    outBits = zeros(nInDataNormal*nBps, 1);                                 % 输出bit
    inData = inDataNormal*sqrt(682);                                        % 归一化符号数据转化为理想星座点数据
    inNumber = computeHardInt(inData, M);                                   % inDataNormal对应的格雷码的十进制数
    outNumber = mapQam1024(inNumber+1);                                     % inDataNormal对应的二进制码的十进制数
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % 转化为列向量
else
    error('Unimplemented modulation');
end
end