%------------------------------------------------------------------------------
%
%Module Name:					FFT_2_DIF.m
%Department:					Xidian University
%Function Description:	        基2的点频率抽取FFT变化实现
%
%------------------------------------------------------------------------------
%
%Version 	Design		Coding		Simulata	  Review	Rel data
%V1.0		Verdvana	Verdvana                            2019-11-9
%
%-----------------------------------------------------------------------------------

clc;
clear all;
close all;



N = 16;
n = 1:1:N;

%16点抽取序列
 x = [12,49,2,48,70,13,5,6,0,0,0,0,0,0,0,0];



%结果输出

subplot(4,1,1);
plot(x,'b');
grid;
title('x');
xlabel('n');
ylabel('x');

subplot(4,1,2);
plot(real(fft(x)));
grid;
title('Matlab自带FFT函数计算结果实数部分');
xlabel('频率f(Hz)');
ylabel('幅值');

subplot(4,1,3);
plot(imag(fft(x)));
grid;
title('Matlab自带FFT函数计算结果虚数部分');
xlabel('频率f(Hz)');
ylabel('幅值');

subplot(4,1,4);
plot(abs(fft(x)));
grid;
title('Matlab自带FFT函数计算结果取模');
xlabel('频率f(Hz)');
ylabel('幅值');

