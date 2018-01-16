function [predX,predNames] = aptIncludePredNMers
%aptIncludePredNMers will alter the predictor's matrix and names
%vector in such a way, that number of n-mer counts are accounted for.
% predNMers is cell array of n-mers ATATA,GCGCGT,... Length can vary.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if (~isfield(apt,'predNMers')||isempty(apt.predNMers))
    return
end

for iseq = 1:length(apt.sequence)
    for iLetter = 1:length(apt.predNMers)
        FindNMer = regexp(apt.sequence{iseq},apt.predNMers{iLetter});
        XbasecountSeq(iseq,iLetter) = length(FindNMer) - sum(diff(FindNMer)<length(apt.predNMers{iLetter}));
    end
end
for i = 1:length(apt.predNMers)
    apt.predNames{end+1} = ['Count_NMer_' apt.predNMers{i}];
end

apt.predX = [apt.predX; XbasecountSeq'];
end

