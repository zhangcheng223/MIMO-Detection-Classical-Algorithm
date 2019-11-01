function xHat = ML_detection(y, H, M)
%函数的功能：使用ML检测方法输出长度为nT的发送信号向量
%函数的描述：(1) 根据需要遍历的发送向量情况数找到所有情况下的发送向量
%          (2) 根据实际接收向量与假定发送向量对应的接收向量之间的2-范数最小找到发送向量
%函数的使用：xHat = ML_detection(y, H)
%输入：
%     y     :  接收信号向量
%     H     :  nR x nT 的信道矩阵
%     M     :  调制阶数

%输出：
%     xHat  :  ML检测的发送信号向量估计
%例子：xHat = ML_detection(y, H, M)

%作者:             zhangcheng
%创建日期:          2019-10-30
%最后更新日期:       2019-10-30

% 生成ML检测的状态表
nT = size(H,2);                                 % 接收天线数
nCondition = M^nT;                              % 发送信号向量所有情况个数
index = [0:nCondition-1].';                     % 发送向量的index
conditionIndex = dec2pAry(index, nT, M).';      % 转换为nT x M^nT的矩阵, 每个元素都是一个M进制的数
[constellation, averagePower] = getConstellation(M);
modTable = constellation./sqrt(averagePower);   % BPSK星座点表
idealTxSymbol = modTable(conditionIndex+1);     % 根据每个元素得到对应的星座点

% 遍历发送向量
distanceSuare = zeros(nCondition, 1);
for iCondition = 1:nCondition
    distanceSuare(iCondition) = sum((y - H*idealTxSymbol(:, iCondition)).*conj(y - H*idealTxSymbol(:, iCondition)));
end
[~, minIndex] = min(distanceSuare);             % 找到distanceSuare的最小值的位置
xHat = idealTxSymbol(:, minIndex);
end