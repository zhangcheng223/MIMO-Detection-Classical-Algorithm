function y = dec2pAry(x, n, p)
%函数的功能：将十进制数转化为n位p进制数
%函数的描述：(1) x是非负整数数的标量或向量
%          (2) 输出y是矩阵，其中行对应x的长度，列对应n位p进制数, 并且是left-msb格式
%函数的使用：function y = dec2pAry(x, n, p)
%输入：
%     x          :  输入非负整数的标量或向量
%     n          :  输出y有列
%     p          :  p进制
%输出：
%     y          :  如果x是标量，y是列向量；如果x是向量量，y是矩阵，其中行对应x的长度，列对应n位p进制数
%例子：function y = dec2pAry(x, 4, 2)

%作者:             zhangcheng
%创建日期:          2019-10-28
%最后更新日期:       2019-10-29
if isrow(x)
    x = x.';
end
powOfp = p.^([-n+1:0]);
y = rem(floor(x*powOfp), p);
end