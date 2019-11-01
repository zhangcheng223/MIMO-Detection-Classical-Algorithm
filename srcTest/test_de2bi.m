clc;
clear;

d = (1:6)';
t = de2bi(d,[],3,'left-msb');

a = [47,72,1,2,7,2,7,3,7,9];
[minValue, minIndex] = min(a);
