function [x,y] = MyActiveContour(I,x0,y0,N,SIGMA)
%MYACTIVECONTOUR performs simple contour extraction
%   [ x, y ] = MyActiveContour( I, x0, y0, N, sigma ) extracts the boundary
%   of a object. I is a intensity image. x0 and y0 are column vectors
%   containing the coordinates of the initial curves vertices. The last
%   vertex has to equal the first one. N defines the number of iteration. A
%   gaussian blur with variance sigma is applied on the image first.

%% Smooth the intensity image I using a gaussian blur
smoothImg = imgaussfilt(I,SIGMA);
%  Calculate the magnitude of gradient of the smoothed image using the Sobel
fop_grx = [-1 0 1;-2 0 2;-1 0 1];           % with Sobel
fop_gry = [1 2 1;0 0 0;-1 -2 -1];                       
fimCorr_grx = myCorrelation(smoothImg,fop_grx); % Calculate both parts of the gradient image
fimCorr_gry = myCorrelation(smoothImg,fop_gry);
% Calculate the magnitude of gradient
MoG = sqrt(fimCorr_grx.^2 + fimCorr_gry.^2);
% Determine the energy component Eima
E_ima = zeros(size(MoG,1),size(MoG,2));
for i=1:size(MoG,1)       
    for j=1:size(MoG,2)
        E_ima(i,j) = MoG(i,j)^-1;
        if E_ima(i,j) == Inf
            E_ima(i,j) = 10000;
        else
        end
    end
end
% Determine the number of vertices in the initial curve. Keep in mind, that the last vertex is just a repetition of the 1st one.
num_vertices = size(x0,1) - 1;
% determine the coordinates of the initial curve
numOfCorners = size(x0,1) - 1;
numPoints = zeros(1,numOfCorners);  
ii = 1;
aa = 0;
for m = 1:numOfCorners
    numPoints (m,1) = sqrt((x0(ii+1,1)-x0(ii,1))^2 + (y0(ii+1,1)-y0(ii,1))^2);
    x_lin = linspace(x0(ii,1),x0(ii+1,1),numPoints(m,1));
    x_lin = (x_lin'); % round
    y_lin = linspace(y0(ii,1),y0(ii+1,1),numPoints(m,1));
    y_lin = (y_lin'); % round
    XX(aa+1:aa + size(x_lin,1), 1:size(x_lin,2))= x_lin;    % to store the curve points x coord
    YY(aa+1:aa + size(y_lin,1), 1:size(y_lin,2))= y_lin;    % to store the curve points y coord
    aa = aa + size(x_lin,1); % or size(y_lin,1) which is the same
    ii = ii +1;
end
CC = contourc(E_ima,1);
CC = CC';
numOfCurvePoints = length(XX);
% Initialize the output variables with the coordinates of the initial curve
x = XX;
y = YY;
% Implement Shrinking Method

for mm=1:N 
    for n=1:numOfCurvePoints-1 % 10  
        cp(1,1) = x(n,1);
        cp(1,2) = y(n,1);
        currentPoint = [cp(1,1),cp(1,2)];
        %compute Euclidean distances:
        distances = sqrt(sum(bsxfun(@minus, CC, currentPoint).^2,2));
        %find the smallest distance and use that as an index into B:
        closest = CC(find(distances==min(distances)),:);
        u(1,1) = closest(1,1) - currentPoint(1,1);
        u(1,2) = closest(1,2) - currentPoint(1,2);
        xC = sign(u(1,1));
        yC = sign(u(1,2));
        np(1,1) = cp(1,1)+xC; 
        np(1,2) = cp(1,2)+yC; 
        currE = E_ima(round(cp(1,2)),round(cp(1,1))); 
        neigE = E_ima(round(np(1,2)),round(np(1,1)));
        if neigE <= currE
            x(n,1) = np(1,1);
            y(n,1) = np(1,2);
        else
        end
    end
    cpl(1,1) = x(end,1);
    cpl(1,2) = y(end,1);
    ul(1,1) = x(1,1) - x(end,1);
    ul(1,2) = y(1,1) - y(end,1);
    xCl = sign(ul(1,1));
    yCl = sign(ul(1,2));
    npl(1,1) = cpl(1,1)+xCl; 
    npl(1,2) = cpl(1,2)+yCl; 
    currEl = E_ima(round(cpl(1,2)),round(cpl(1,1))); 
    neigEl = E_ima(round(npl(1,2)),round(npl(1,1)));
    if neigEl <= currEl
        x(end,1) = npl(1,1);
        y(end,1) = npl(1,2);
    else
    end
end
