function [predX,predNames] = aptIncludeRegExp
%APTINCLUDEREGEXP Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~isfield(apt,'predRegExp')
    return
end

Xregexp = zeros(length(apt.sequence), length(apt.predRegExp));

for iseq = 1:length(apt.sequence)
    for iPattern = 1:length(apt.predRegExp)
        startIndex = regexp(apt.sequence{iseq},apt.predRegExp{iPattern});
        if ~isempty(startIndex)
            Xregexp(iseq,iPattern) = length(startIndex);
        end
    end
end

for iPattern = 1:length(apt.predRegExp)
    apt.predNames{end+1} = ['RegExp_' apt.predRegExp{iPattern}];
end

apt.predX = [apt.predX; Xregexp'];
end

