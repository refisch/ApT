function [predX,predNames] = aptIncludePredInteractionTerms(predInteraction,sequence,predX,predNames)
%APTINCLUDEPREDINTERACTIONTERMS Summary of this function goes here
%   Detailed explanation goes here


if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predInteraction)
    return
end

for iInteraction = 1:length(predInteraction)
    intTerms = strsplit(predInteraction{iInteraction},'*');
    idx1 = find(~cellfun(@isempty,regexp(predNames,['\_' intTerms{1} '$'])));
    idx2 = find(~cellfun(@isempty,regexp(predNames,['\_' intTerms{2} '$'])));
    if length(idx1)~= 1 || length(idx2)~= 1
        error('Interaction terms are ambiguous!')
    end
    XInteraction(:,iInteraction) = predX(idx1,:).*predX(idx2,:);
end

for iInteraction = 1:length(predInteraction)
    predNames{end+1} = ['Interaction_' predInteraction{iInteraction}];
end

predX = [predX; XInteraction'];


end

