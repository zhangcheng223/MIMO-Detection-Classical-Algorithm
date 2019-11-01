function xHat = MMSE_detection(y, H, noisePower)
%函数的功能：使用MMSE检测方法输出长度为nT的发送信号向量
%函数的描述：(1) 先求H的MMSE滤波矩阵得到W_ZF
%          (2) 接收向量y左乘W_ZF
%函数的使用：xHat = ZF_detection(y, H)
%输入：
%     y         :  接收信号向量
%     H         :  nR x nT 的信道矩阵
%     noisePower:  接收信号噪声的平均功率
%输出：
%     xHat      :  MMSE检测的发送信号向量估计
%例子：xHat = MMSE_detection(y, H, noisePower)

%作者:             zhangcheng
%创建日期:          2019-10-31
%最后更新日期:       2019-10-31

nT = size(H,2);                                 % 接收天线数
W_MMSE = inv(H'*H+noisePower*eye(nT))*H';    
xHat = W_MMSE*y;

end