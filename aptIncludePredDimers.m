function [predX,predNames] = aptIncludePredDimers(predDimers,sequence,predX,predNames)
%aptIncludePredDimers Will alter the predictor's matrix and names
%vector in such a way, that number of dimer counts are accounted for.
% predSingles is cell array of dimers AA,AC,AG,AT,CA... Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predDimers)
    return
end

if predDimers == 'all'
    structBC = dimercount('A');
    predDimers = fieldnames(structBC);
end

for iseq = 1:length(sequence)
    structBC = dimercount(sequence{iseq});
    for iLetter = 1:length(predDimers)
        XbasecountSeq(iseq,iLetter) = structBC.(predDimers{iLetter});
    end
end
for i = 1:length(predDimers)
    predNames{end+1} = ['Count_Dimer_' predDimers{i}];
end

predX = [predX; XbasecountSeq'];
end

