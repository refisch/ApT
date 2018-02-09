function aptValidation
%APTVALIDATION estimates new candidates (which are generated by
%aptGenerateSequence) for given stats model.
%   'numberSamples' is number of newly generated candidates
%   'apt.modeToGenerateNewSequences' is mode used for randomly generating new candidates.

global apt

if (~isfield(apt,'vali') || ~isfield(apt.vali,'number'))
    apt.vali.number = 1000;
end

if ~isfield(apt.vali,'mode')
    apt.vali.mode = 'random';
end

aptGenerateValiSequence;
sequenceTrue = apt.sequence;
apt.sequence = apt.vali.generatedSequence;
aptPredictors(true);
apt.sequence = sequenceTrue;

if ~all(strcmp(apt.vali.predNames, apt.predNames))
    error('Something went wrong!')
end

for iY = 1:length(apt.Y)
    apt.vali.estResponse{iY} = apt.stats(iY).Intercept(apt.stats(iY).Index1SE) + apt.vali.predX'*apt.stats(iY).beta(:,apt.stats(iY).Index1SE);
end


end

