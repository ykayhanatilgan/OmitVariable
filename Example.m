%%
clear all;
close all;
clc;
%%
InStrct.X = './data/ChineseCities.csv';      % input file
InStrct.DataColNums = [2:7];         % data to be analyzed
InStrct.ColorColumn = 8;             % color column
InStrct.ColorValues = [1 2 3];       % color values
InStrct.DisSimDist = 'Cityblock';     % distance function
InStrct.InitMethod = 'PCA';           % principal component analysis
InStrct.StdType = 'Mean';             % mean-variance standardization
InStrct.MDSMethod = 'NMDS';           % non-metric MDS
InStrct.DrawGraph = 'MDS';            % MDS graph
% OutStrct = RobustCoPlot(InStrct)     % run analysis
%%
InStrct.OmitMethod = 'FIXED';
InStrct.RetainList = [3 5];
OutStrct = OmitVariable(InStrct);
%% 
% Omitting correlated variables, p.10 example
InStrct.X = './data/p10example.csv';
InStrct.DataColNums = [2:4];
InStrct.OmitMethod = 'FIXED';
InStrct.RetainList = [4];
OutStrct = OmitVariable(InStrct)
%% 
% A multivariate statistical approach to reducing the number of variables
% in data envelopment analysis, Table 1, Hotel data.
InStrct.X = './data/HotelData.csv';
InStrct.DataColNums = [2:7];
InStrct.OmitMethod = 'FIXED';
InStrct.RetainList = [2 4];
OutStrct = OmitVariable(InStrct)

InStrct.OmitMethod = 'BEST';
InStrct.RetainNum = 5;
OutStrct = OmitVariable(InStrct)
