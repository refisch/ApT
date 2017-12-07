function [predX,predNames] = aptIncludeCertainPosFeatures(predCertainPosFeatures,sequence,predX,predNames)
%APTINCLUDECERTAINPOSFEATURES Looks for a distinct Pattern at a certain
%Position and extends design matrix.
%

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predCertainPosFeatures)
    return
end

position = predCertainPosFeatures.position;
pattern = predCertainPosFeatures.pattern;

if length(pattern) ~= length(position)
    error('patterns have to start at position. they need the same length!')
end

Xcpf = zeros(length(sequence), length(position));

for iseq = 1:length(sequence)
    for iPattern = 1:length(pattern)
        [startIndex,~] = regexp(sequence{iseq},pattern{iPattern});
        if sum(startIndex == position(iPattern)) == 1
            Xcpf(iseq,iPattern) = 1;
        end
    end
end

for iPattern = 1:length(pattern)
    predNames{end+1} = ['Pattern_' pattern{iPattern} '_atPosition_' int2str(position(iPattern))];
end

predX = [predX; Xcpf'];
end

