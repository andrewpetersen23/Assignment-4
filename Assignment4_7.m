%% 
% Author: Andrew Petersen
% Assignment: 4-7 (envelopes)
% Last modified: 10/27/17
%%

clc; clear; clear all;

I = imread('envelope3.jpg');
% imshow(I);
Imed = medfilt2(I,[100 100]);
Ifinal = Imed-I;
BW = Ifinal>50;
% imshow(BW)

[H, theta, rho] = hough(BW);
P = houghpeaks(H,1,'threshold', 500);
lines = houghlines(BW,theta,rho,P);
imshow(BW)
hold on;
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',3,'color','g');
end
hold off

angle = (lines.theta)+90;
Irot = imrotate(BW,angle,'crop');
imshow(Irot)
new = Irot(725:end, 1:725);
% imshow(new)

SE1 = strel('disk',4, 8);
erode = imerode(new,SE1);
restore = imdilate(erode, SE1);


[labels, number] = bwlabel(restore,8);
Istats = regionprops(labels,'basic');
num = length(Istats);
Ibox = floor([Istats.BoundingBox]);
Ibox = reshape(Ibox,[4 num]);
Ibox(4,:) = Ibox(4,:) + 125;
imshow(restore)
hold on


for k = 1:num
    if k ~= 2
    rectangle('position', Ibox(:,k), 'edgecolor', 'r', 'LineWidth', 3);
    end
end
