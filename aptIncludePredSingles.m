function [predX,predNames] = aptIncludePredSingles(predSingles,sequence,predX,predNames)
%aptIncludePredSingles Will alter the predictor's matrix and names
%vector in such a way, that number of basecounts are accounted for.
% predSingles is cell array of letters A,C,G, and/or T. Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

if nargin ~= 4
    error('function needs 4 input arguments')
end

if isempty(predSingles)
    return
end


if predSingles == 'all'
    structBC = basecount('A');
    predSingles = fieldnames(structBC);
end

for iseq = 1:length(sequence)
    structBC = basecount(sequence{iseq});
    for iLetter = 1:length(predSingles)
        XbasecountSeq(iseq,iLetter) = structBC.(predSingles{iLetter});
    end
end
for i = 1:length(predSingles)
    predNames{end+1} = ['Count_Single_' predSingles{i}];
end

predX = [predX; XbasecountSeq'];
end

