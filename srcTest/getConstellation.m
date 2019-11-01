function [constellation, averagePower] = getConstellation(M)
%函数的功能：根据给定的调制阶数输出归一化QAM星座点
%函数的描述：(1) M必须需为2^nBps, 其中nBps必须为1或者大于等于2的偶数
%          (2) 生成归一化星座点映射表
%函数的使用：constellation = getConstellation(M)
%输入：
%     M             : QAM调制阶数

%输出：
%     constellation : MQAM对应的星座点表
%例子：constellation = getConstellation(16)

%作者:             zhangcheng
%创建日期:          2019-10-29
%最后更新日期:       2019-10-30

if M ==2
    constellation = exp(1j*[-pi, 0]);
    averagePower = ( (5*M/4) - 1 ) * 2/3;
else
    sqrtM = sqrt(M);                                                        % 方形QAM对应的每行或者每列的点数
    constellation = zeros(M,1);                                             % 星座点表
    xPoints = -(sqrtM-1) : 2 : (sqrtM-1);                                   % 星座点I路坐标
    yPoints = (sqrtM-1) : -2 : -(sqrtM-1);                                  % 星座点Q路坐标
    x = repmat(xPoints, sqrtM, 1);
    y = repmat(yPoints.', sqrtM, 1);
    constellation(:) = complex(x(:), y);                                    % QPSK的归一化星座点(先上->下，再从左->右)
    averagePower = (M - 1) * 2/3;
end