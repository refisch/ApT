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
        apt.predNames{end+1} = 'length_sequence';
        apt.predX = [apt.predX; lengthSeq];
        if isfield(apt,'spacer')
            lengthSpacer = [];
            for i = 1:length(apt.spacer)
                lengthSpacer(i) = length(apt.spacer{i});
            end
            apt.predNames{end+1} = 'length_spacer';
            apt.predX = [apt.predX; lengthSpacer];
        end
    end
end
end
