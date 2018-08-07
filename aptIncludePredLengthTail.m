function [predX,predNames] = aptIncludePredLengthTail
%aptIncludePredLengthTail Will alter the predictor's matrix and names
%vector in such a way, that number of repititions of last sequence letter
%are accounted for.
% predLengthTail is cell array of letters A,C,G, and/or T.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if ~isfield(apt.pred,'LengthTail')
    return
end

if apt.pred.LengthTail == 'all'
    structBC = basecount('A');
    predLengthTail = fieldnames(structBC);
    % else??
end

XlengthSeq = zeros(length(apt.sequence),length(predLengthTail));
for iseq = 1:length(apt.sequence)
    if isfield(apt,'spacer')
        if isempty(apt.spacer{iseq})
            XlengthSeq(iseq,:) = zeros(size(whichNC));
        else
            whichNC = strcmp(predLengthTail,apt.spacer{iseq}(1));
            XlengthSeq(iseq,:) = length(apt.spacer{iseq})* whichNC;
        end
    else
        for iLetter = 1:length(predLengthTail)
            idxNotLastLetter = regexp(apt.sequence{iseq},['[^' predLengthTail{iLetter} ']']);
            XlengthSeq(iseq,iLetter) = length(apt.sequence{iseq}) - max(idxNotLastLetter);
        end
    end
end
for i = 1:length(predLengthTail)
    apt.predNames{end+1} = ['Length_Spacer_' predLengthTail{i}];
end

apt.predX = [apt.predX; XlengthSeq'];

end

