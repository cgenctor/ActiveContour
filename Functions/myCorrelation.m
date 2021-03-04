function [ fimCorr ] = myCorrelation( fim, fop )
%MYCORRELATION calculation 2D correlation for CRV
%   fimCorr = myCorrelation(fim,fop) calculates the correlation of the
%   image function fim and the operator function fop as introduced in the
%   CRV lecture. Both fim and fop have to be matrices. fop has to be
%   smaller than fim and of odd size. fimCorr is of the same size as fim.
%   The outer pixels, where the correlation can not be calculated
%   sufficiently, are set to zero.
dim_fim = ndims(fim);
dim_fop = ndims(fop);

if ( ismatrix(fim) && ismatrix(fop) && ( dim_fim == dim_fop ))
    fprintf('Dimension check is done. Both have same dimensions. \n');
else
    msg1 = 'Error occurred. One of the imputs is not two dimensional.';
    error(msg1)
end
[numRows_fop,numCols_fop] = size(fop);  % Determine the size of the operator pattern fop. 
r_fop = mod(numRows_fop,2);
c_fop = mod(numCols_fop,2);

if ( r_fop && c_fop ) % both dimensions of fop should be odd
    fprintf('Operator pattern fop is of odd size. \n');
else
    msg2 = 'Error occurred. At least one dimension of fop is even.';
    error(msg2)
end

[numRows_fim,numCols_fim] = size(fim);
% fop has to fit in fimm at least at one position
if ( numRows_fop <= numRows_fim && numCols_fop <= numCols_fim ) 
    fprintf('Operator pattern fop fits in the fim. fimCorr will be calculated. \n');
else
    msg3 = 'Error occurred. fop does not fit in fim.';
    error(msg3)
end
% Convert both inputs to floating point numbers with double precision
fim_double = double(fim);
fop_double = double(fop);
% Calculate the half side lengths h1 and h2 of the operator pattern.
h1 = (numRows_fop - 1)/2;
h2 = (numCols_fop - 1)/2;
% Implement the correlation
fimCorr= zeros([size(fim,1) size(fim,2)]);
if numRows_fop == numCols_fop
    for i = 1:size(fim, 1) - 2 
        for j = 1:size(fim, 2) - 2 
            fimCorr(i+1,j+1) = sum(sum(fop.*fim(i:i+2, j:j+2))); 
        end
    end
elseif numRows_fop < numCols_fop
    for i = 1:size(fim,1)
        for j = 1:size(fim,2)-2
            Temp = fim(i,j:j+2).*fop;
            fimCorr(i,j+1) = sum(Temp(:));
        end
    end
elseif numRows_fop > numCols_fop
    for i = 1:size(fim,1)-2
        for j = 1:size(fim,2)
            Temp = fim(i:i+2,j).*fop;
            fimCorr(i+1,j) = sum(Temp(:));
        end
    end
else
    msg4 = 'Error occurred. Something wrong with size of fop.';
    error(msg4)
end
   
end

% websites used 
% https://www.geeksforgeeks.org/matlab-image-edge-detection-using-prewitt-operator-from-scratch/
% https://www2.cs.duke.edu/courses/fall15/compsci527/notes/convolution-filtering.pdf
% https://www.imageeprocessing.com/2015/11/convolution-in-matlab.html
