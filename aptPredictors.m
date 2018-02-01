function aptPredictors
%APTPREDICTORS generates design matrix predX of sequence.
%  'sequence' ist cell array of aptamers.
%  Predictors are defined in first section. Subfunctions will then generate
%  predX and predNames

global apt

%% Define Predictors
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

