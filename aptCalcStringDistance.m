function [totDist] = aptCalcStringDistance(oneseq,sequence)
%APTCALCSTRINGDISTANCE Summary of this function goes here
%   'oneseq' is the sequence that is compared to all the sequences in 'sequence'
%   'sequence' is cell array of sequence to whom distance is calculated.

minLen = min(cellfun(@length,sequence));
totDist = 0;
for iSeq = 1:length(sequence)
    seqDist = 0;
    for iPos = 1:minLen
        seqDist = seqDist + (~strcmp(oneseq(iPos),sequence{iSeq}(iPos)));
        totDist = totDist + seqDist^2;
    end
end

end

