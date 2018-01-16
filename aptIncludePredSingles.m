function [predX,predNames] = aptIncludePredSingles
%aptIncludePredSingles Will alter the predictor's matrix and names
%vector in such a way, that number of basecounts are accounted for.
% predSingles is cell array of letters A,C,G, and/or T. Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names
global apt

if ~isfield(apt,'predSingles')
    return
end

if apt.predSingles == 'all'
    structBC = basecount('A');
    apt.predSingles = fieldnames(structBC);
end

for iseq = 1:length(apt.sequence)
    structBC = basecount(apt.sequence{iseq});
    for iLetter = 1:length(apt.predSingles)
        XbasecountSeq(iseq,iLetter) = structBC.(apt.predSingles{iLetter});
    end
end
for i = 1:length(apt.predSingles)
    apt.predNames{end+1} = ['Count_Single_' apt.predSingles{i}];
end

apt.predX = [apt.predX; XbasecountSeq'];
end

