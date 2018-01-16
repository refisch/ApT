function [predX,predNames] = aptIncludeCertainPosFeatures
%APTINCLUDECERTAINPOSFEATURES Looks for a distinct Pattern at a certain
%Position and extends design matrix.
%

global apt

if ~isfield(apt,'predCertainPosFeatures')
    return
end

position = apt.predCertainPosFeatures.position;
pattern = apt.predCertainPosFeatures.pattern;

if length(pattern) ~= length(position)
    error('patterns have to start at position. they need the same length!')
end

Xcpf = zeros(length(apt.sequence), length(position));

for iseq = 1:length(apt.sequence)
    for iPattern = 1:length(pattern)
        [startIndex,~] = regexp(apt.sequence{iseq},pattern{iPattern});
        if sum(startIndex == position(iPattern)) == 1
            Xcpf(iseq,iPattern) = 1;
        end
    end
end

for iPattern = 1:length(pattern)
    apt.predNames{end+1} = ['Pattern_' pattern{iPattern} '_atPosition_' int2str(position(iPattern))];
end

apt.predX = [apt.predX; Xcpf'];
end

