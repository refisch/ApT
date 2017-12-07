function [predX,predNames] = aptIncludePredNMers(predNMers,sequence,predX,predNames)
%aptIncludePredNMers will alter the predictor's matrix and names
%vector in such a way, that number of n-mer counts are accounted for.
% predNMers is cell array of n-mers ATATA,GCGCGT,... Length can vary.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predNMers)
    return
end

for iseq = 1:length(sequence)
    for iLetter = 1:length(predNMers)
        FindNMer = regexp(sequence{iseq},predNMers{iLetter});
        XbasecountSeq(iseq,iLetter) = length(FindNMer) - sum(diff(FindNMer)<length(predNMers{iLetter}));
    end
end
for i = 1:length(predNMers)
    predNames{end+1} = ['Count_NMer_' predNMers{i}];
end

predX = [predX; XbasecountSeq'];
end

