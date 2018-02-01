function [predX,predNames] = aptIncludePredInteractionTerms
% apt.predInteraction contains a string of TERM1*TERM2 with TERM1 and TERM2
% existing predictors.

global apt

if ~isfield(apt.pred,'Interaction')
    return
end

for iInteraction = 1:length(apt.pred.Interaction)
    intTerms = strsplit(apt.pred.Interaction{iInteraction},'*');
    idx1 = find(~cellfun(@isempty,regexp(apt.predNames,['\_' intTerms{1} '$'])));
    idx2 = find(~cellfun(@isempty,regexp(apt.predNames,['\_' intTerms{2} '$'])));
    if length(idx1)~= 1 || length(idx2)~= 1
        error('Interaction terms are ambiguous!')
    end
    XInteraction(:,iInteraction) = apt.predX(idx1,:).*apt.predX(idx2,:);
end

for iInteraction = 1:length(apt.predInteraction)
    apt.predNames{end+1} = ['Interaction_' apt.pred.Interaction{iInteraction}];
end

apt.predX = [apt.predX; XInteraction'];


end

