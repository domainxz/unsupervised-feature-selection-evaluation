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



function Y = LSE(X, K, d)

% X:  the input matrix, each column is a data point;
% K:  the k-nn parameter, including itself
% d:  the dimensionality of the manifold


% the first step: construct the neighbor:

[D, N] = size(X);

fprintf(1,'LSE running on %d points in %d dimensions\n', N, D);

% STEP1: Compute pairwise distance and find neighbors 
fprintf(1,'-->Finding %d nearest neighbours.\n', K);

%
X2 = sum(X.^2, 1);
distance = repmat(X2, N, 1) + repmat(X2', 1, N) - 2 * X' * X;
[sorted,index] = sort(distance);
nb = index(1: K, :);                                  % size of matrix neighborhood is K * N. note that we include the center point  

% STEP2: Construct the global error matrix
fprintf(1,'-->Constructing the global error matrix.\n');

M = calcu_opt_matrix(X, nb, d);

% STEP3: Computing embedding
fprintf(1,'-->Computing embedding.\n');

options.disp = 0; options.isreal = 1; options.issym = 1; 
[Y, eigenvals] = eigs(M, d + 1, 0, options);                    % Note that, it has been reported that eigs may output incorrect results in some versions of MATLAB settings. 
                                                                                     % We only tested the codes in MATLAB 6.5 and 7.0. 
                                                                                     %  If so, please try to use the following four sentenses (i.e., replace the above one sentence):
                                                                                     % [Y, eigenvals] = eig(full(M));  TT = diag(eigenvals); [YY, II] = sort(TT); Y = Y(:, II);     

%  % % % TT = diag(eigenvals); [YY, II] = sort(TT); Y = Y(:, II);

Y = Y(:, 2:d + 1)' * sqrt(N);                          

return

