function y = SISO(x,snr)
% SISO.m
% 功能：实现SISO接收
% 输入：
%  x    :   发射数据
%  snr  :   信噪比（非对数值）
% 输出：
%  y    :   接收数据

%作者：      zhang cheng
%创建日期：   2019-10-01
%最后更新日期：2019-10-06

frameLength = length(x);

%**************************************************************************
%                                 有问题
% % 瑞利信道和加性噪声
% H = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(2);
% noise = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(snr)/sqrt(2);
% 
% % 接收信号
% r = H.*x + noise;
%**************************************************************************

% 瑞利信道和加性噪声
H = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(2);         % 瑞利信道
s = H.*x;                                                           % 信号部分
averagePower = mean(abs(s).^2);                                     % 所有接收天线的平均功率
noisePower = averagePower/snr;                                      % 噪声功率
noise = sqrt(noisePower)*(randn(frameLength,1)+...                  % 噪声部分
    1j*randn(frameLength,1))/sqrt(2);

% 接收部分
% noise = zeros(frameLength,1);                                       % 测试使用
r = s + noise;

% 输出用于判决的信号
y_H = conj(H).*r;

% 除以信道增益
Habs = sum(abs(H).^2,2);
y = y_H./Habs;
end