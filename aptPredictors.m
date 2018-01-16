function aptPredictors
%APTPREDICTORS generates design matrix predX of sequence.
%  'sequence' ist cell array of aptamers.
%  Predictors are defined in first section. Subfunctions will then generate
%  predX and predNames

global apt

%% Define Predictors
apt.predExpCond = true;
apt.predLength = true; % true or false
apt.predLengthTail = 'all'; % explicit forms in cell array, empty ({}) or 'all' -- count number of same nucleobases at the end.
apt.predSingles = 'all'; % explicit forms, empty ({}) or 'all'
apt.predDimers = 'all';%'all'; % explicit forms, empty ({}) or 'all'
apt.predCodons = 'all';%'all'; % explicit forms, empty ({}) or 'all'
apt.predNMers = '';%{'TATA'}; % explicit forms or empty
apt.predRegExp = {'GG[ACT]{1}GG','GG[ACT]{2}GG','GG[ACT]{3}GG','GG[ACT]{4}GG'};
apt.predInteractionTerms = '';%{'Single_G*Single_C'};

apt.predCertainPosFeatures.position = 1:15; % this is not done dynamically, because in validation sequences length might differ.
apt.predCertainPosFeatures.pattern = {'G','G','T','T','G','G','T','G','T','G','G','T','T','G','G'};

% Symmetrien, Spiegelungen,.... G->C
% nmercount, look up symmetric one from the other side.

%% Calculate design matrix X
apt.predNames = {};
apt.predX = [];

aptIncludeExperimentalConditions;
aptIncludePredLength;
aptIncludePredLengthTail;
aptIncludePredSingles;
aptIncludePredDimers;
aptIncludePredCodons;
aptIncludePredNMers;
aptIncludeRegExp;
aptIncludeCertainPosFeatures;
aptIncludePredInteractionTerms;

end

