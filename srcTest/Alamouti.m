function y = Alamouti(x,snr,nT,nR)
% Alamouti.m
% 功能：实现Alamouti接收
% 输入：
%  x    :   发射数据
%  snr  :   信噪比（非对数值）
%  nT   :   发送天线数
%  nR   :   接收天线数
% 输出：
%  y    :   接收数据

%作者：      zhang cheng
%创建日期：   2019-10-01
%最后更新日期：2019-10-06

% 参数
frameLength = length(x);
rate= 1;
interval = nT/rate;
repFactor = interval;

% 变量预设
x_Alamouti = zeros(frameLength,nT);         % 经过Alamouti编码的发射信号
H = zeros(frameLength, nT, nR);             % 信道
s = zeros(frameLength, nR);                 % 接收的有用信号
z = zeros(frameLength, nR);                 % Alamouti解码后信号

% Alamouti编码
x1 = x(1:interval:end);
x2 = x(2:interval:end);
x_Alamouti(1:interval:end,:) = [x1,x2];
x_Alamouti(2:interval:end,:) = [-conj(x2),conj(x1)];

%****************************************************************************
%                                  有问题
% % 瑞利信道和加性噪声
% H(1:interval:end,:,:) = (randn(frameLength/rate/repFactor, nT, nR)+...
%                         1j*randn(frameLength/rate/repFactor, nT, nR))/sqrt(2);
% H(2:interval:end,:,:) = H(1:interval:end,:,:);
% noise = (randn(frameLength,nR)+1j*randn(frameLength,nR))/snr/sqrt(2);
% 
% % 接收信号
% for iNr = 1:nR
%     r(:,iNr) = sum(H(:,:,iNr).*x_Alamouti,2)/sqrt(nT) + noise(:,iNr);
% end
%****************************************************************************

% 瑞利信道和加性噪声
H(1:interval:end,:,:) = (randn(frameLength/rate/repFactor, nT, nR)+...
                        1j*randn(frameLength/rate/repFactor, nT, nR))/sqrt(2);
H(2:interval:end,:,:) = H(1:interval:end,:,:);
for iNr = 1:nR
    s(:,iNr) = sum(H(:,:,iNr).*x_Alamouti,2);
end
averagePower = mean(mean(abs(s).^2));                               % 所有接收天线的平均功率
noisePower = averagePower/snr;                                      % 噪声功率
noise = sqrt(noisePower)*(randn(frameLength,nR)+...                 % 噪声部分
    1j*randn(frameLength,nR))/sqrt(2);
% noise = zeros(frameLength,nR);                                    % 用于测试
r = s + noise;                                                      % 接收信号

% Alamouti解码
for iNr = 1:nR
    z(1:interval:end,iNr) = conj(H(1:interval:end,1,iNr)).*r(1:interval:end,iNr)+...
        H(1:interval:end,2,iNr).*conj(r(2:interval:end,iNr));
    z(2:interval:end,iNr) = conj(H(1:interval:end,2,iNr)).*r(1:interval:end,iNr)-...
        H(1:interval:end,1,iNr).*conj(r(2:interval:end,iNr));
end

% 输出用于判决的信号
Habs = sum(sum(abs(H).^2,2),3);
y = sum(z,2)./Habs;
end