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
    sequenceTrue = apt.sequence;
    spacerTrue = apt.spacer;
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

% Eliminate those predictors where there is no information
removePreds = sum(abs(apt.predX),2) == 0;
apt.predX = apt.predX(~removePreds,:);
apt.predNames = apt.predNames(~removePreds);

% Zscore on predictor level -- What about validation mode???
if isfield(apt.config,'doZscoreModel') && apt.config.doZscoreModel
    [apt.predX, apt.zscore.XMu, apt.zscore.XStd] = zscore(apt.predX');
    apt.predX = apt.predX'; apt.zscore.XMu = apt.zscore.XMu'; apt.zscore.XStd = apt.zscore.XStd';
end

% Scale Model?
if ~validationMode
    if isfield(apt.config,'doScaleModel') && apt.config.doScaleModel
        for i = 1:size(apt.predX,1)
            apt.NormalizeModel(i) = max(apt.predX(i,:));
            apt.predX(i,:) = apt.predX(i,:) / apt.NormalizeModel(i);
        end
    end
else % shrink and reset predX if in validation mode.
    predXvali = zeros(size(truePredX,1),size(apt.predX,2)); % is this correct procedure??
    for i = 1:length(truePredNames)
        idxmatch = find(strcmp(apt.predNames,truePredNames(i)));
        if ~isempty(idxmatch)
            if isfield(apt.config,'doScaleModel') && apt.config.doScaleModel
                predXvali(i,:) = apt.predX(idxmatch,:)/apt.NormalizeModel(i);
            else
                predXvali(i,:) = apt.predX(idxmatch,:);
            end
        end
    end
    apt.vali.predNames = apt.predNames;
    apt.vali.predX = predXvali;
    
    apt.predNames = truePredNames;
    apt.predX = truePredX;
    apt.sequence = sequenceTrue;
    apt.spacer = spacerTrue;
    
end

end

