function [ O ] = OmitVariable( I )
% Explanation of input structure, I
% I.X             : Input data to be analyzed. Input data can be a text
%                   file, which contains a data set while the first line
%                   should contain comma separated variable names.
% I.DataColNums   : Selects the data columns from the input file that are
%                   going to be used in the analysis.
% I.StdType       : Determines which data standardization technique will be
%                   used. 'Mean' uses mean and standard deviation, 'Median'
%                   uses median for mean, and MADN for scale.
% I.OmitMethod    : 'BEST' for selecting best variables to be omitted
%                   automatically. 'FIXED' for omitting user selected
%                   variables.
% I.RetainNum     : Number of variables to be retained for selecting best
%                   variables. I.OmitMethod shoul be selected as 'BEST'.
% I.RetainList    : Vector of variables to be retained. I.OmitMethod shoul
%                   be selected as 'FIXED'.
%
% Explanation of output structure, O
% O.V          : Calculated partial covariance matrix of omitted variables
%                given retained variables. 
% O.Trace      : Trace of partial covariance matrix i.e. remiaining
%                variance of omitted variables after conditioning on the
%                retained variables.
% O.InfoRatio  : Ratio of contained information by retain list variables.

%% Process input I.X
FileI.X = I.X;
FileO = ProcessFile(FileI);
% select data columns
DataMatrix = FileO.DataMatrix(:,I.DataColNums);
% select variable names of the selected data columns
VarNames = FileO.VarNames(I.DataColNums);
%% Standardization
StandDataI.DataMatrix = DataMatrix;
StandDataI.StdType = I.StdType;
StandDataO = StandData(StandDataI);
%% Select omit method
if (strcmp(I.OmitMethod, 'FIXED'))
    ParCovMatI.DataMatrix = StandDataO.StandardData;
    ParCovMatI.DataColNums = I.DataColNums;
    ParCovMatI.RetainList = I.RetainList;
    ParCovMatO = ParCovMat(ParCovMatI);
    V = ParCovMatO.V;
    Trace = ParCovMatO.Trace;
    InfoRatio = ParCovMatO.InfoRatio;
end
if (strcmp(I.OmitMethod, 'BEST'))
    ParCovMatI.DataMatrix = StandDataO.StandardData;
    ParCovMatI.DataColNums = I.DataColNums;
    % Create all possible subsets for retain variables.
    AllSubset = nchoosek(I.DataColNums, I.RetainNum);
    % Initialize loop variables.
    InfoRatio = 0;
    for SubsetNum = 1 : size(AllSubset, 1)
        ParCovMatI.RetainList = AllSubset(SubsetNum, :);
        ParCovMatO = ParCovMat(ParCovMatI);
        % Check max info ratio.
        if (ParCovMatO.InfoRatio > InfoRatio)
            V = ParCovMatO.V;
            Trace = ParCovMatO.Trace;
            InfoRatio = ParCovMatO.InfoRatio;
            BestVarList = AllSubset(SubsetNum, :);
            BestVarNames = VarNames(ismember(I.DataColNums, ...
                ParCovMatI.RetainList));
            OmitVarNames = VarNames(~ismember(I.DataColNums, ...
                ParCovMatI.RetainList));
        end
    end
    O.BestVarList = BestVarList;
    O.BestVarNames = BestVarNames;
    O.OmitVarNames = OmitVarNames;
end
%% Output structure
O.V = V;
O.Trace = Trace;
O.InfoRatio = InfoRatio;

end

