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
predNMers = {'TATA'}; % explicit forms or empty
predRegExp = {'GG[ACT]{2}GG','GG[ACT]{3}GG'};
predInteractionTerms = {'Single_G*Single_C'};

predCertainPosFeatures.pattern = {'G','T','G','T','G','G','T','T'};
predCertainPosFeatures.position = [1,2,6,7,8,14,19,20];

% Symmetrien, Spiegelungen,.... G->C
% nmercount, look up symmteric one from the other side.
% Muster wie GG-GG-----GG-GG ??

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

