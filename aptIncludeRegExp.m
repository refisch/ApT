function [predX,predNames] = aptIncludeRegExp
%APTINCLUDEREGEXP Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~isfield(apt.pred,'RegExp')
    return
end

Xregexp = zeros(length(apt.sequence), length(apt.pred.RegExp));

for iseq = 1:length(apt.sequence)
    for iPattern = 1:length(apt.pred.RegExp)
        startIndex = regexp(apt.sequence{iseq},apt.pred.RegExp{iPattern});
        if ~isempty(startIndex)
            Xregexp(iseq,iPattern) = length(startIndex);
        end
    end
end

for iPattern = 1:length(apt.pred.RegExp)
    apt.predNames{end+1} = ['RegExp_' apt.pred.RegExp{iPattern}];
end

apt.predX = [apt.predX; Xregexp'];
end

