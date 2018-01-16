function [predX,predNames] = aptIncludePredDimers
%aptIncludePredDimers Will alter the predictor's matrix and names
%vector in such a way, that number of dimer counts are accounted for.
% predSingles is cell array of dimers AA,AC,AG,AT,CA... Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if ~isfield(apt,'predDimers')
    return
end

if apt.predDimers == 'all'
    structBC = dimercount('A');
    apt.predDimers = fieldnames(structBC);
end

for iseq = 1:length(apt.sequence)
    structBC = dimercount(apt.sequence{iseq});
    for iLetter = 1:length(apt.predDimers)
        XbasecountSeq(iseq,iLetter) = structBC.(apt.predDimers{iLetter});
    end
end
for i = 1:length(apt.predDimers)
    apt.predNames{end+1} = ['Count_Dimer_' apt.predDimers{i}];
end

apt.predX = [apt.predX; XbasecountSeq'];
end

