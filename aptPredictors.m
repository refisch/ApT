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
    apt.vali.truePredNames = apt.predNames;
    apt.vali.truePredX = apt.predX;
    apt.sequence = apt.vali.generatedSequence;
    apt.spacer = apt.vali.generatedSpacer;
end

apt.predNames = {};
apt.predX = [];

aptIncludeExperimentalConditions(validationMode);
aptIncludePredLength;
aptIncludeDataPredictors(validationMode);
aptIncludePredLengthTail;
aptIncludePredSingles;
aptIncludePredDimers;
aptIncludePredCodons;
aptIncludePredNMers;
aptIncludeRegExp;
aptIncludeCertainPosFeatures;
aptIncludeSymmetry;
aptIncludeSimplifiedSequence;
aptIncludePredInteractionTerms;

aptRefinePredictors(validationMode)


end

