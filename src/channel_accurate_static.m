function [y, H, noisePower] = channel_accurate_static(x, nT, nR, snr)
%函数的功能：根据输入信号和发送和接收天线数，并将信号通过MIMO信道输出
%函数的描述：(1) 信道是独立同分布的准静态瑞利衰落信道，发射天线互不相干和接收天线互不相关
%函数的使用：y = channel(x)
%输入：
%     x       : 输入信号
%     nT      : 发送天线数目
%     nR      : 接收天线数目
%     snr     : 线性信噪比
%输出：
%     y       : 通过信道后的输出信号
%     H       : 一帧下所有的信道矩阵    
%例子：[y, H] = channel_accurate_static(x, 4, 4, 10)

%作者:             zhangcheng
%创建日期:          2019-10-30
%最后更新日期:       2019-10-30

nFrameLength = size(x, 2);

% 独立同分布瑞利信道
Hw = (randn(nR, nT, nFrameLength)+1j*randn(nR, nT, nFrameLength))./sqrt(2); 

% % 发射端和接收端空间相关阵参数
% rhoTx = 0.2;
% rhoRx = 0.6;
% theta = pi/2;
% Rtx = zeros(nT, nT);
% Rrx = zeros(nR, nR);
% 
% % 发射端的空间相关矩阵
% for iNT = 1:nT
%     for jNT = 1:nT
%         if iNT <= jNT
%             Rtx(iNT, jNT) = (rhoTx*exp(1j*theta))^(jNT-iNT);
%         else
%             Rtx(iNT, jNT) = conj((rhoTx*exp(1j*theta))^(iNT-jNT));
%         end
%     end
% end
% 
% % 接收端的空间相关矩阵
% for iNR = 1:nR
%     for jNR = 1:nR
%         if iNR <= jNR
%             Rrx(iNR, jNR) = (rhoRx*exp(1j*theta))^(jNR-iNR);
%         else
%             Rrx(iNR, jNR) = conj((rhoRx*exp(1j*theta))^(iNR-jNR));
%         end
%     end
% end
% H = zeros(nR, nT, nFrameLength);
% for iFrameLength = 1:nFrameLength
%     % 注意矩阵求平方根用sqrtm, 对每个元素求平方根用sqrt
%     H(:,:,iFrameLength) = sqrtm(Rrx)*Hw(:,:,iFrameLength)*sqrtm(Rtx);   
% end

H = Hw;             % 准静态信道

% 生成接收信号
r = zeros(nR, nFrameLength);
for iFrameLength = 1:nFrameLength
    r(:,iFrameLength) = H(:,:,iFrameLength)*x(:,iFrameLength);
end

% 加性高斯白噪声
rxAveragePower = mean(mean(abs(r).^2));
noisePower = rxAveragePower/snr;
noise = sqrt(noisePower)*(randn(nR, nFrameLength)+1j*randn(nR, nFrameLength))./sqrt(2);

% 输出信号
y = r+noise;
end