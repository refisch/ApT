function [predX,predNames] = aptIncludeRegExp(predRegExp,sequence,predX,predNames)
%APTINCLUDEREGEXP Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predRegExp)
    return
end

Xregexp = zeros(length(sequence), length(predRegExp));

for iseq = 1:length(sequence)
    for iPattern = 1:length(predRegExp)
        startIndex = regexp(sequence{iseq},predRegExp{iPattern});
        if ~isempty(startIndex)
            Xregexp(iseq,iPattern) = length(startIndex);
        end
    end
end

for iPattern = 1:length(predRegExp)
    predNames{end+1} = ['RegExp_' predRegExp{iPattern}];
end

predX = [predX; Xregexp'];
end

