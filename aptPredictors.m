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
apt.pred.DataPredictors = apt.data(1).predName;
apt.pred.ExpCond = length(apt.data) > 1;
apt.pred.Length = true; % true or false
apt.pred.LengthTail = 'all'; % explicit forms in cell array, empty ({}) or 'all' -- count number of same nucleobases at the end.
apt.pred.Singles = 'all'; % explicit forms, empty ({}) or 'all'
apt.pred.Dimers = 'all';%'all'; % explicit forms, empty ({}) or 'all'
apt.pred.Codons = 'all';%'all'; % explicit forms, empty ({}) or 'all'
apt.pred.NMers = '';%{'TATA'}; % explicit forms or empty
apt.pred.RegExp = {'GG[ACT]{1}GG','GG[ACT]{2}GG','GG[ACT]{3}GG','GG[ACT]{4}GG'};
apt.pred.InteractionTerms = '';%{'Single_G*Single_C'};

apt.pred.CertainPosFeatures.position = 1:15; % this is not done dynamically, because in validation sequences length might differ.
apt.pred.CertainPosFeatures.pattern = {'G','G','T','T','G','G','T','G','T','G','G','T','T','G','G'};

apt.pred.symmetry = true;
% Symmetrien, Spiegelungen,.... G->C
% nmercount, look up symmetric one from the other side.

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

