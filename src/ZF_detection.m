function xHat = ZF_detection(y, H)
%函数的功能：使用ZF检测方法输出长度为nT的发送信号向量
%函数的描述：(1) 先求H的ZF滤波矩阵得到W_ZF
%          (2) 接收向量y左乘W_ZF
%函数的使用：xHat = ZF_detection(y, H)
%输入：
%     y     :  接收信号向量
%     H     :  nR x nT 的信道矩阵
%输出：
%     xHat  :  ZF检测的发送信号向量估计
%例子：xHat = ZF_detection(y, H)

%作者:             zhangcheng
%创建日期:          2019-10-30
%最后更新日期:       2019-10-30

W_ZF = inv(H'*H)*H';  
xHat = W_ZF*y;

end