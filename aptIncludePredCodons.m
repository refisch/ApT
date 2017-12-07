function [predX,predNames] = aptIncludePredCodons(predCodons,sequence,predX,predNames)
%aptIncludePredCodons will alter the predictor's matrix and names
%vector in such a way, that number of codon counts are accounted for.
% predCodons is cell array of codons AAA,AAC,AAG,AAT,ACA... Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predCodons)
    return
end

if predCodons == 'all'
    structBC = codoncount('A');
    predCodons = fieldnames(structBC);
end

for iseq = 1:length(sequence)
    structBC = codoncount(sequence{iseq});
    for iLetter = 1:length(predCodons)
        XbasecountSeq(iseq,iLetter) = structBC.(predCodons{iLetter});
    end
end
for i = 1:length(predCodons)
    predNames{end+1} = ['Count_Codon_' predCodons{i}];
end

predX = [predX; XbasecountSeq'];
end

