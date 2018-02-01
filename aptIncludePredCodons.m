function [predX,predNames] = aptIncludePredCodons
%aptIncludePredCodons will alter the predictor's matrix and names
%vector in such a way, that number of codon counts are accounted for.
% predCodons is cell array of codons AAA,AAC,AAG,AAT,ACA... Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if ~isfield(apt.pred,'Codons')
    return
end

if apt.pred.Codons == 'all'
    structBC = codoncount('A');
    apt.pred.Codons = fieldnames(structBC);
end

for iseq = 1:length(apt.sequence)
    structBC = codoncount(apt.sequence{iseq});
    for iLetter = 1:length(apt.pred.Codons)
        XbasecountSeq(iseq,iLetter) = structBC.(apt.pred.Codons{iLetter});
    end
end
for i = 1:length(apt.pred.Codons)
    apt.predNames{end+1} = ['Count_Codon_' apt.pred.Codons{i}];
end

apt.predX = [apt.predX; XbasecountSeq'];
end

