function [ O ] = ParCovMat( I )
% Explanation of input structure, I
% I.DataMatrix    : Data matrix. Each column of the matrix corresponds to a
%                   variable while each row of the matrix corresponds to a
%                   data point. This matrix is composed of selected columns
%                   of I.X by I.DataColNums.
% I.DataColNums   : List of selected variables from original input file
%                   I.X. 
% I.RetainList    : List of columns that will be retained for partial
%                   covariance calculation from original input file
%                   I.X.
%
% Explanation of output structure, O
% O.V          : Calculated partial covariance matrix of omitted variables
%                given retained variables. 
% O.Trace      : Trace of partial covariance matrix i.e. remiaining
%                variance of omitted variables after conditioning on the
%                retained variables.
% O.InfoRatio  : Ratio of contained information by retain list variables.

% Re-arrange data matrix according to omitted variables. Omitted variables
% are placed at last columns.
ColX = size(I.DataMatrix, 2);
X = [I.DataMatrix(:, ~ismember(I.DataColNums, I.RetainList)) ...
    I.DataMatrix(:, ismember(I.DataColNums, I.RetainList))];
% Calculate covariance of new data matrix.
CovX = cov(X);
% Find partial covariance matrix. Omitting correlated variables, p.6
NumOfRetained = length(I.RetainList);
NumOfOmitted = ColX - NumOfRetained;
VCell = mat2cell(CovX, [NumOfOmitted, NumOfRetained], ...
    [NumOfOmitted, NumOfRetained]);
V = VCell{1, 1} - VCell{1, 2} * (VCell{2, 2} \ VCell{2, 1});
%% output structure
O.V = V;
O.Trace = trace(V);
O.InfoRatio = 100 * (trace(CovX) - trace(V)) / trace(CovX);

end

