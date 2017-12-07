function [predX,predNames] = aptIncludePredLengthTail(predLengthTail,sequence,predX,predNames)
%aptIncludePredLengthTail Will alter the predictor's matrix and names
%vector in such a way, that number of repititions of last sequence letter
%are accounted for.
% predLengthTail is cell array of letters A,C,G, and/or T.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predLengthTail)
    return
end

if predLengthTail == 'all'
    structBC = basecount('A');
    predLengthTail = fieldnames(structBC);
end

for iseq = 1:length(sequence)
    for iLetter = 1:length(predLengthTail)
        idxNotLastLetter = regexp(sequence{iseq},['[^' predLengthTail{iLetter} ']']);
        XlengthSeq(iseq,iLetter) = length(sequence{iseq}) - max(idxNotLastLetter);
    end
end
for i = 1:length(predLengthTail)
    predNames{end+1} = ['Length_Tail_' predLengthTail{i}];
end

predX = [predX; XlengthSeq'];

end

