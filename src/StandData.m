function [ O ] = StandData( I )
% Explanation of input structure, I
% I.DataMatrix    : Data matrix. Each column of the matrix corresponds to a
%                   variable while each row of the matrix corresponds to a
%                   data point.
% I.StdType       : Determines which data standardization technique will be
%                   used. 'Mean' uses mean and standard deviation, 'Median'
%                   uses median for mean, and MADN for scale.
%
% Explanation of output structure, O
% O.StandardData        : Standardized data matrix.

% standardize the data matrix
if strcmp(I.StdType,'Mean')
    DataMean = mean(I.DataMatrix);
    DataMean = repmat(DataMean,size(I.DataMatrix,1),1);
    DataStd = std(I.DataMatrix);
    DataStd = repmat(DataStd,size(I.DataMatrix,1),1);
elseif strcmp(I.StdType,'Median')
    DataMean = median(I.DataMatrix);
    DataMean = repmat(DataMean,size(I.DataMatrix,1),1);
    DataStd = 1.4826*median(abs(I.DataMatrix-DataMean));
    DataStd = repmat(DataStd,size(I.DataMatrix,1),1);
end
StandardData = (I.DataMatrix-DataMean)./DataStd;
%% output structure
O.StandardData = StandardData;

end

