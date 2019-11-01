function y = MRC(x,snr,nR)
% MRC.m
% 功能：实现MRC接收
% 输入：
%  x    :   发射数据
%  snr  :   信噪比（非对数值）
%  nR   :   接收天线数
% 输出：
%  y    :   接收数据

%作者：      zhang cheng
%创建日期：   2019-10-01
%最后更新日期：2019-10-06

% 参数
frameLength = length(x);

%***********************************************************************
%                           加噪声存在问题
% % 瑞利信道和加性噪声
% H = (randn(frameLength,nR)+1j*randn(frameLength,nR))/sqrt(2);
% noise = (randn(frameLength,nR)+1j*randn(frameLength,nR))/snr/sqrt(2);  %
% 
% % 接收
% r = zeros(frameLength, nR);         
% for iNr = 1:nR
%     r(:,iNr) = H(:,iNr).*x + noise;
% end
%***********************************************************************

% 发送部分
x_M = repmat(x, [1, nR]);

% 瑞利信道和加性噪声
H = (randn(frameLength,nR)+1j*randn(frameLength,nR))/sqrt(2);       % 瑞利信道
s = H.*x_M;                                                         % 信号部分
averagePower = mean(mean(abs(s).^2));                               % 所有接收天线的平均功率
noisePower = averagePower/snr;                                      % 噪声功率
noise = sqrt(noisePower)*(randn(frameLength,nR)+...                 % 噪声部分
    1j*randn(frameLength,nR))/sqrt(2);
% 
% noise = zeros(frameLength,nR);                                      % 用于测试
% 接收部分
r = s + noise;

% 除以信道增益
Habs = sum(abs(H).^2,2);
y = sum(r.*conj(H),2)./Habs;
% y = sum(r.*conj(H),2)
end