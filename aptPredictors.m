function [predX,predNames] = aptPredictors(sequence)
%APTPREDICTORS generates design matrix predX of sequence.
%  'sequence' ist cell array of aptamers.
%  Predictors are defined in first section. Subfunctions will then generate
%  predX and predNames

%% Define Predictors
predLength = true; % true or false
predLengthTail = 'all'; % explicit forms in cell array, empty ({}) or 'all' -- count number of same nucleobases at the end.
predSingles = 'all'; % explicit forms, empty ({}) or 'all'
predDimers = 'all';%'all'; % explicit forms, empty ({}) or 'all'
predCodons = 'all';%'all'; % explicit forms, empty ({}) or 'all'
predNMers = '';%{'TATA'}; % explicit forms or empty
predRegExp = {'GG[ACT]{1}GG','GG[ACT]{2}GG','GG[ACT]{3}GG','GG[ACT]{4}GG'};
predInteractionTerms = '';%{'Single_G*Single_C'};

predCertainPosFeatures.position = 1:15; % this is not done dynamically, because in validation sequences length might differ.
predCertainPosFeatures.pattern = {'G','G','T','T','G','G','T','G','T','G','G','T','T','G','G'};

% Symmetrien, Spiegelungen,.... G->C
% nmercount, look up symmetric one from the other side.

%% Calculate design matrix X
predNames = {};
predX = [];

[predX,predNames] = aptIncludePredLength(predLength,sequence,predX,predNames);
[predX,predNames] = aptIncludePredLengthTail(predLengthTail,sequence,predX,predNames);
[predX,predNames] = aptIncludePredSingles(predSingles,sequence,predX,predNames);
[predX,predNames] = aptIncludePredDimers(predDimers,sequence,predX,predNames);
[predX,predNames] = aptIncludePredCodons(predCodons,sequence,predX,predNames);
[predX,predNames] = aptIncludePredNMers(predNMers,sequence,predX,predNames);
[predX,predNames] = aptIncludePredInteractionTerms(predInteractionTerms,sequence,predX,predNames);
[predX,predNames] = aptIncludeRegExp(predRegExp,sequence,predX,predNames);
[predX,predNames] = aptIncludeCertainPosFeatures(predCertainPosFeatures,sequence,predX,predNames);


end

