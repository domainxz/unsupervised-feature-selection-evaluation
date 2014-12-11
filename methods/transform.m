% CORRESPONDENCE INFORMATION
%    This code is written by Shiming Xiang
% 
%    Address:    FIT Building 3-120 Room
%                     Tsinghua Univeristy, Beijing, China, 100084
%    Email:        smxiang@gmail.com

%    COPYRIGHT NOTICE
%    LSE code -- (c) 2005-2007 Shiming Xiang, Feiping Nie, Changshui Zhang  and Chunxia Zhang
%
%    This software can be used freely for research purposes.
%    Published reports of research  using this code (or a modified version) should cite the 
%    article that describes the algorithm: 
%
%    Shiming Xiang, Feiping Nie, Changshui Zhang and Chunxia Zhang. 
%    Nonlinear Dimensionality Reduction with Local Spline Embedding. 
%    IEEE Transactions on Knowledge and Data Engineering(TKDE), Volume 21, Issue 9, Pages 1285-1298, 2009. 

%    Comments and bug reports are welcome.  Email to smxiang@gmail.com. 
%    I would also appreciate hearing about how you used this code, 
%    and the improvements that you have made to it, or translations into other languages.    

%   WORK SETTING:
%    This code has been compiled and tested using matlab 6.5  and matlab     7.0

%==========================================================================



function Y = transform(W, Yd, Ys)

% transform Ys according to Yd. Ys are to be transformed: Y = f(Ys)  

%W:    the coefficient matrix
%Yd:   the targets points, which are sued as reference points
%Ys:   the points to be transformed, each column is a data point

%return
%Y:     the coordinate of the transformed data point

[d, Nd] = size(Yd);
[d, Ns] = size(Ys);

Yd2 = sum(Yd.^2, 1);  % a row vector
Ys2 = sum(Ys.^2, 1);  % a row vector

distance = repmat(Yd2, Ns, 1) + repmat(Ys2', 1, Nd) - 2 * Ys' * Yd;

distance = distance .* log(distance + 0.00001);



P = ones(1, Ns);
P = [P; Ys];           % add the rows;

P = [distance, P'];


Y = W * P';


return