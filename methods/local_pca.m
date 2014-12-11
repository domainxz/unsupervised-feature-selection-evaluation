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
%    This code has been compiled and tested using matlab 6.5  and matlab   7.0

%==========================================================================




function V = local_pca(X, d) 

% X: each colmun is a data point
% d: the dimensioanlity of low-dimensioanl space

% return
%V:   the local coordinate after performing local PCA, each coulmn is a data point

[D, K] = size(X);

X = X + 0.0001 * randn(D, K);         % you can consider to add some noise, if some neighbors are exactly equal to each other   

thisx = X - repmat(mean(X')',1, K) ;   %  centerized

%compute local coordinates
% normal SVD

% fast  
if D <= K
    [U, DD, Vpr] = svd(thisx);            % Vpr: each column is a eigenvector
    V = Vpr(:, 1:d)' * 10;                % each row is a selected eigenvector, here scale it for computation  
    
%slow
else
    
    CC = thisx' * thisx;
    options.disp = 0; options.isreal = 1; options.issym = 1;
    [U, DD] = eigs(CC, d);
    s = sqrt(K);
    V = U' * s;
end


