function [predX,predNames] = aptIncludePredDimers
%aptIncludePredDimers Will alter the predictor's matrix and names
%vector in such a way, that number of dimer counts are accounted for.
% predSingles is cell array of dimers AA,AC,AG,AT,CA... Alternative is 'all'
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if ~isfield(apt.pred,'Dimers') || isempty(apt.pred.Dimers)
    return
end

if apt.pred.Dimers == 'all'
    structBC = dimercount('A');
    apt.pred.Dimers = fieldnames(structBC);
end

for iseq = 1:length(apt.sequence)
    structBC = dimercount(apt.sequence{iseq});
    for iLetter = 1:length(apt.pred.Dimers)
        XbasecountSeq(iseq,iLetter) = structBC.(apt.pred.Dimers{iLetter});
    end
end
for i = 1:length(apt.pred.Dimers)
    apt.predNames{end+1} = ['Count_Dimer_' apt.pred.Dimers{i}];
end

apt.predX = [apt.predX; XbasecountSeq'];
end

