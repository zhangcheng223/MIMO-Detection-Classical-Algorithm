clc;
clear;
close all;

% BPSK
mBpsk = 2;
bpsBpsk = log2(mBpsk);
sqrtBpsk = sqrt(mBpsk);
xBpsk = [0:1:mBpsk-1].';
[yBpsk, mapBpsk] = bin2gray(xBpsk, 'psk' , mBpsk);
symbolIndexBpsk = zeros(mBpsk,1);
symbolIndexBpsk(mapBpsk+1) = [0:mBpsk-1]; 
zBpsk = gray2bin(yBpsk, 'psk' , mBpsk);
symBpsk = qammod(xBpsk,mBpsk);
symBpskPower = mean(abs(symBpsk).^2);
scatterplot(symBpsk,1,0,'b*');
for k = 1:mBpsk
    text(real(symBpsk(k))-0.3,imag(symBpsk(k))+0.3,...
        dec2base(mapBpsk(k),2,bpsBpsk));
    
    text(real(symBpsk(k))-0.3,imag(symBpsk(k))-0.3,...
        dec2base(zBpsk(k),2,bpsBpsk),'Color',[1 0 0]);
end
axis([-sqrtBpsk sqrtBpsk -sqrtBpsk sqrtBpsk])
title('BPSK');
save(['..\inputData\', 'BPSK.mat',], 'symbolIndexBpsk','mapBpsk');
csvwrite(['..\inputData\', 'BPSK.csv'], [symbolIndexBpsk, mapBpsk]);

% QPSK
mQpsk = 4;
bpsQpsk = log2(mQpsk);
sqrtQpsk = sqrt(mQpsk);
xQpsk = [0:1:mQpsk-1].';
[yQpsk, mapQpsk] = bin2gray(xQpsk, 'psk' , mQpsk);
symbolIndexQpsk = zeros(mQpsk,1);
symbolIndexQpsk(mapQpsk+1) = [0:mQpsk-1]; 
zQpsk = gray2bin(yQpsk, 'psk' , mQpsk);
symQpsk = qammod(xQpsk,mQpsk);
symQpskPower = mean(abs(symQpsk).^2);
scatterplot(symQpsk,1,0,'b*');
for k = 1:mQpsk
    text(real(symQpsk(k))-0.3,imag(symQpsk(k))+0.3,...
        dec2base(mapQpsk(k),2,bpsQpsk));
    
    text(real(symQpsk(k))-0.3,imag(symQpsk(k))-0.3,...
        dec2base(zQpsk(k),2,bpsQpsk),'Color',[1 0 0]);
end
axis([-sqrtQpsk sqrtQpsk -sqrtQpsk sqrtQpsk])
title('QPSK');
save('..\inputData\QPSK.mat', 'symbolIndexQpsk','mapQpsk');
csvwrite('..\inputData\QPSK.csv', [symbolIndexQpsk, mapQpsk]);

% 16QAM
mQam16= 16;
bpsQam16 = log2(mQam16);
sqrtQam16 = sqrt(mQam16);
xQam16 = [0:1:mQam16-1].';
[yQam16, mapQam16] = bin2gray(xQam16, 'qam' , mQam16);
symbolIndexQam16 = zeros(mQam16,1);
symbolIndexQam16(mapQam16+1) = [0:mQam16-1]; 
[zQam16, gray2binQam16] = gray2bin(yQam16, 'qam' , mQam16);
symQam16= qammod(xQam16,mQam16);
symQam16Power = mean(abs(symQam16).^2);
scatterplot(symQam16,1,0,'b*');
for k = 1:mQam16
    text(real(symQam16(k))-0.3,imag(symQam16(k))+0.3,...
        dec2base(mapQam16(k),2,bpsQam16));
    
    text(real(symQam16(k))-0.3,imag(symQam16(k))-0.3,...
        dec2base(zQam16(k),2,bpsQam16),'Color',[1 0 0]);
end
axis([-sqrtQam16 sqrtQam16 -sqrtQam16 sqrtQam16])
title('16-QAM');
save('..\inputData\QAM16.mat', 'symbolIndexQam16','mapQam16');
csvwrite('..\inputData\QAM16.csv', [symbolIndexQam16, mapQam16]);

% 64QAM
mQam64= 64;
bpsQam64 = log2(mQam64);
sqrtQam64 = sqrt(mQam64);
xQam64 = [0:1:mQam64-1].';
[yQam64, mapQam64] = bin2gray(xQam64, 'qam' , mQam64);
symbolIndexQam64 = zeros(mQam64,1);
symbolIndexQam64(mapQam64+1) = [0:mQam64-1]; 
zQam64 = gray2bin(yQam64, 'qam' , mQam64);
symQam64 = qammod(xQam64,mQam64);
symQam64Power = mean(abs(symQam64).^2);
scatterplot(symQam64,1,0,'b*');
for k = 1:mQam64
    text(real(symQam64(k))-0.3,imag(symQam64(k))+0.3,...
        dec2base(mapQam64(k),2,bpsQam64));
    
    text(real(symQam64(k))-0.3,imag(symQam64(k))-0.3,...
        dec2base(zQam64(k),2,bpsQam64),'Color',[1 0 0]);
end
axis([-sqrtQam64 sqrtQam64 -sqrtQam64 sqrtQam64])
title('64-QAM');
save('..\inputData\QAM64.mat', 'symbolIndexQam64','mapQam64');
csvwrite('..\inputData\QAM64.csv', [symbolIndexQam64, mapQam64]);

% 256QAM
mQam256= 256;
bpsQam256 = log2(mQam256);
sqrtQam256 = sqrt(mQam256);
xQam256 = [0:1:mQam256-1].';
[yQam256, mapQam256] = bin2gray(xQam256, 'qam' , mQam256);
symbolIndexQam256 = zeros(mQam256,1);
symbolIndexQam256(mapQam256+1) = [0:mQam256-1]; 
zQam256 = gray2bin(yQam256, 'qam' , mQam256);
symQam256 = qammod(xQam256,mQam256);
symQam256Power = mean(abs(symQam256).^2);
scatterplot(symQam256,1,0,'b*');
for k = 1:mQam256
    text(real(symQam256(k))-0.3,imag(symQam256(k))+0.3,...
        dec2base(mapQam256(k),2,bpsQam256));
    
    text(real(symQam256(k))-0.3,imag(symQam256(k))-0.3,...
        dec2base(zQam256(k),2,bpsQam256),'Color',[1 0 0]);
end
axis([-sqrtQam256 sqrtQam256 -sqrtQam256 sqrtQam256])
title('256-QAM');
save('..\inputData\QAM256.mat', 'symbolIndexQam256','mapQam256');
csvwrite('..\inputData\QAM256.csv', [symbolIndexQam256, mapQam256]);

% 1024QAM
mQam1024= 1024;
bpsQam1024 = log2(mQam1024);
sqrtQam1024 = sqrt(mQam1024);
xQam1024 = [0:1:mQam1024-1].';
[yQam1024, mapQam1024] = bin2gray(xQam1024, 'qam' , mQam1024);
symbolIndexQam1024 = zeros(mQam1024,1);
symbolIndexQam1024(mapQam1024+1) = [0:mQam1024-1]; 
[zQam1024, mapQam1024_2] = gray2bin(yQam1024, 'qam' , mQam1024);
symQam1024 = qammod(xQam1024, mQam1024);

yQam1024_2 = xQam1024(symbolIndexQam1024+ 1);
symQam1024Gray = qammod(gray2bin(xQam1024, 'qam' , mQam1024),mQam1024);
symQam1024Power = mean(abs(symQam1024).^2);
scatterplot(symQam1024,1,0,'b*');
for k = 1:mQam1024
    text(real(symQam1024(k))-0.3,imag(symQam1024(k))+0.3,...
        dec2base(mapQam1024(k),2,bpsQam1024));
    
    text(real(symQam1024(k))-0.3,imag(symQam1024(k))-0.3,...
        dec2base(zQam1024(k),2,bpsQam1024),'Color',[1 0 0]);
end
axis([-sqrtQam1024 sqrtQam1024 -sqrtQam1024 sqrtQam1024])
title('1024-QAM');
save('..\inputData\QAM1024.mat', 'symbolIndexQam1024','mapQam1024');
csvwrite('..\inputData\QAM1024.csv', [symbolIndexQam1024, mapQam1024]);