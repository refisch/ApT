function [predX,predNames] = aptIncludePredInteractionTerms
% apt.predInteraction contains a string of TERM1*TERM2 with TERM1 and TERM2
% existing predictors.

global apt

if ~isfield(apt.pred,'InteractionTerms')
    return
end

if isfield(apt.config,'knownSequences')
    idxCategories = find(~(cellfun(@isempty,strfind(apt.predNames,'a13'))&cellfun(@isempty,strfind(apt.predNames,'b6'))));
    idxSeqSpec = find(~(cellfun(@isempty,strfind(apt.predNames,'G'))&cellfun(@isempty,strfind(apt.predNames,'T')) ...
        &cellfun(@isempty,strfind(apt.predNames,'C'))&cellfun(@isempty,strfind(apt.predNames,'A'))));
    idxSeqSpec = setdiff(idxSeqSpec,find(~cellfun(@isempty,strfind(apt.predNames,'Array'))));
    moreInteractions = cell(length(idxCategories)*length(idxSeqSpec),1);
    counter = 1;
    for iC = 1:length(idxCategories)
        for iS = 1:length(idxSeqSpec)
            moreInteractions{counter} = [apt.predNames{idxCategories(iC)} '*' apt.predNames{idxSeqSpec(iS)}];
            counter = counter + 1;
        end
    end
    
    if isempty(apt.pred.InteractionTerms)
        apt.pred.InteractionTerms = moreInteractions;
    else
        apt.pred.InteractionTerms = [apt.pred.InteractionTerms;moreInteractions];
    end
end

for iInteraction = 1:length(apt.pred.InteractionTerms)
    intTerms = strsplit(apt.pred.InteractionTerms{iInteraction},'*');
    idx1 = find(strcmp(apt.predNames,intTerms{1}));
    idx2 = find(strcmp(apt.predNames,intTerms{2}));
    if length(idx1)~= 1 || length(idx2)~= 1
        error('Interaction terms are ambiguous!')
    end
    XInteraction(:,iInteraction) = apt.predX(idx1,:).*apt.predX(idx2,:);
end

for iInteraction = 1:length(apt.pred.InteractionTerms)
    apt.predNames{end+1} = ['Int_' apt.pred.InteractionTerms{iInteraction}];
end

apt.predX = [apt.predX; XInteraction'];


end

