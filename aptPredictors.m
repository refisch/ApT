function aptPredictors(validationMode)
%APTPREDICTORS generates design matrix predX of sequence.
%  'sequence' ist cell array of aptamers.
%  Predictors are defined in first section. Subfunctions will then generate
%  predX and predNames

global apt

if ~exist('validationMode','var')
    validationMode = false;
end

%% Define Predictors
% call one script that has all the necessary commands
aptSetPredsFullAnalysis
% aptSetPredsMutation_Spacer


%% Calculate design matrix X
if validationMode
    truePredNames = apt.predNames;
    truePredX = apt.predX;
end

apt.predNames = {};
apt.predX = [];

aptIncludeExperimentalConditions(validationMode);
aptIncludePredLength;
aptIncludeDataPredictors;
aptIncludePredLengthTail;
aptIncludePredSingles;
aptIncludePredDimers;
aptIncludePredCodons;
aptIncludePredNMers;
aptIncludeRegExp;
aptIncludeCertainPosFeatures;
aptIncludePredInteractionTerms;
aptIncludeSymmetry;
aptIncludeSimplifiedSequence;

% Zscore on predictor level -- What about validation mode???
if isfield(apt.config,'doZscoreModel') && apt.config.doZscoreModel
    [apt.predX, apt.zscore.XMu, apt.zscore.XStd] = zscore(apt.predX');
    apt.predX = apt.predX'; apt.zscore.XMu = apt.zscore.XMu'; apt.zscore.XStd = apt.zscore.XStd';
end

% Eliminate those predictors where there is no information
removePreds = sum(abs(apt.predX),2) == 0;
apt.predX = apt.predX(~removePreds,:);
apt.predNames = apt.predNames(~removePreds);

if validationMode
    apt.vali.predNames = apt.predNames;
    apt.vali.predX = apt.predX;
    apt.predNames = truePredNames;
    apt.predX = truePredX;
end

end

