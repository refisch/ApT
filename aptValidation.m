function [vali] = aptValidation(sequence, predNames, stats, numberSamples)
%APTVALIDATION Summary of this function goes here
%   Detailed explanation goes here

if nargin ~= 4
    error('function needs 3 inputs')
end

validationIndex = stats.Index1SE;

vali.number = numberSamples;
vali.beta = stats.beta(:,validationIndex);
vali.intercept = stats.Intercept(validationIndex);
vali.PredictorNames = stats.PredictorNames;

vali.sequence = aptGenerateSequence(sequence,vali.number,'random');

[X, valiNames] = aptPredictors(vali.sequence);

if sum(cellfun(@strcmp,valiNames, predNames)) ~= length(valiNames)
    error('validation predictors do not match calibrated predictors!')
end

vali.EstRates = vali.intercept + X'*vali.beta;


end

