function aptRefinePredictors(validationMode)
%APTREFINEPREDICTORS Summary of this function goes here
%   Detailed explanation goes here
% Eliminate those predictors where there is no information
global apt;

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
    predXvali = zeros(length(apt.vali.truePredNames),size(apt.predX,2)); % is this correct procedure??
    for itrue = 1:length(apt.vali.truePredNames)
        idxmatch = find(strcmp(apt.predNames,apt.vali.truePredNames(itrue)));
        if ~isempty(idxmatch)
            if isfield(apt.config,'doScaleModel') && apt.config.doScaleModel
                predXvali(itrue,:) = apt.predX(idxmatch,:)./apt.NormalizeModel(itrue);
            else
                predXvali(itrue,:) = apt.predX(idxmatch,:);
            end
        end
    end
    apt.vali.predNames = apt.predNames;
    apt.vali.predX = predXvali;
    
    apt.predNames = apt.vali.truePredNames;
    apt.predX = apt.vali.truePredX;

end
end

