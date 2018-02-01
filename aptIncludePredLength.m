function aptIncludePredLength
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global apt

if isfield(apt.pred,'Length')
    if apt.pred.Length
        lengthSeq = [];
        for i = 1:length(apt.sequence)
            lengthSeq(i) = length(apt.sequence{i});
        end
        apt.predNames{end+1} = 'length';
        apt.predX = [apt.predX; lengthSeq];
    end
end
end
