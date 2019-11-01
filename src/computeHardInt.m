function z = computeHardInt(y, M)
%函数的功能：根据调制阶数给出输入符号对应的格雷码的十进制数
%函数的描述：
%函数的使用：z = computeHardInt(y, M)
%输入：
%     y : 数据符号向量
%     M : 调制阶数
%输出：
%     z : 解映射后的格雷码对应的十进制数

%例子：z = computeHardInt(y, 16)

%作者:             zhangcheng
%创建日期:          2019-10-29
%最后更新日期:       2019-10-29

sqrtM = sqrt(M);
z = zeros(size(y));

% 将y的实部映射到[0, sqrtM-1]
rIndex = round((real(y)+(sqrtM-1))./2);
rIndex(rIndex < 0) = 0;
rIndex(rIndex > (sqrtM-1)) = sqrtM-1;

% 将y的虚部映射到[0, sqrtM-1]
iIndex = round((imag(y)+(sqrtM-1))./2);
iIndex(iIndex < 0) = 0;
iIndex(iIndex > (sqrtM-1)) = sqrtM-1;

% 根据理想星座点输出对应的格雷码的十进制数
z(:) = sqrtM*rIndex + sqrtM-iIndex-1;
end