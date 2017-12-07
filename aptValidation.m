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

W = seqlogo(sequence);
cmW = cumsum(W{2});
cmW = cmW./cmW(end,:);
maxLen = max(cellfun(@length,sequence));
minLen = min(cellfun(@length,sequence));

vali.lengths = floor((maxLen-minLen).*rand(vali.number,1) + minLen);


TrialSeq = cell(vali.number,1);
for iSeq = 1:vali.number
    for iPos = 1:vali.lengths(iSeq)
        rN = rand(1);
        for iBase = 1:length(W{1})
            if rN<cmW(iBase,iPos)
                rBase = W{1}(iBase);
                break
            end
        end
        TrialSeq{iSeq}(iPos) = rBase;
    end
end
vali.sequence = TrialSeq;

[X, valiNames] = aptPredictors(vali.sequence);

if sum(cellfun(@strcmp,valiNames, predNames)) ~= length(valiNames)
    error('validation predictors do not match calibrated predictors!')
end

vali.EstRates = vali.intercept + X'*vali.beta;


end

