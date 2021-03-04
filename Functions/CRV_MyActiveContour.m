%% CRV_10_MyActiveContour 
% name : Candas Genctor
%% clean up 
clear;
close all;
clc;
%% Test
Img = imread('TestImages\Test1.png');
%Img = imread('TestImages\Test2.png');
%Img = imread('TestImages\Test3.png');
I = double(Img); 
N=50;   % N defines the number of iteration
SIGMA = 1;  %  gaussian blur with variance sigma is applied on the image
[BW,x0,y0] = roipoly(Img);  % user input, the initial curve
[x,y] = MyActiveContour(I,x0,y0,N,SIGMA);   % snake algorithm 
% create a figure
figure
subplot(1,2,1);
imshow(I)
hold on
plot(x0,y0,'r','Linewidth',3);
title('Subplot 1: Initial Curve')
subplot(1,2,2); 
imshow(I)
hold on
plot(x,y,'g','Linewidth',3);
title('Subplot 2: Final Curve')
