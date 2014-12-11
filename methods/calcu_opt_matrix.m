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
%    This code has been compiled and tested using matlab 6.5  and matlab    7.0

%==========================================================================



% the code is optimized via Shiming Xiang in  Sep., 2008.
function M = calcu_opt_matrix(X, nb, dst_dim)
% X:         the source point in sample space. Each column is a data point
% nb:        the neighboring relationship
% dst_dinm:  the lower dimensionality to be reduced

%return:     A sparse matrix


[K, N] = size(nb);

nMax = K * K * N; 
M   =   spalloc(N, N, nMax);

for i = 1 : N
    ind = nb(:, i);
    
    % now perfrom the local PCA and obtaine the local error matrix:
    thisx = X(:, ind);                        % get the local patch
    V = local_pca(thisx, dst_dim);                 % claculate the local coordinates
                                                   % assume that the order is  preserving
                                                   % each column is a data point which is reducted
                                                   % here we need to do SVD decomposition, it is fast since K is a small nummber 
    ipl = calcu_spline_matrix(V); 
    
    M(ind, ind) = M(ind, ind) + ipl; 
end
