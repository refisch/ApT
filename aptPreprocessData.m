function [sequence,Y,weightsY,doLog10] = aptPreprocessData(sequence,Y)
%APTPREPROCESSDATA Does the preprocessing of the sequence data.
%   Often multiple measurements to one sequence are performed. Her mean and
%   weights calculation for regression model.

[uniSequence,~,idxSeq] = unique(sequence);
yPP = zeros(1,length(uniSequence));
stdyPP = yPP;

for iGroups = 1:length(uniSequence)
    yPP(iGroups) = mean(Y(idxSeq==iGroups));
    stdyPP(iGroups) = std(Y(idxSeq==iGroups));
end

doLog10 = false;
[~,pVal] = corr(yPP',stdyPP');
if pVal < 0.01
    doLog10 = true;
end

if doLog10
    if min(Y)<0
        Y = Y+abs(min(Y))+1;
    end
    for iGroups = 1:length(uniSequence)
        yPP(iGroups) = mean(log10(Y(idxSeq==iGroups)));
        stdyPP(iGroups) = std(log10(Y(idxSeq==iGroups)));
    end
    [Rho,pVal] = corr(yPP',stdyPP');
    if pVal<0.01
        warning('Parson-Test suggests that errors are not log-normal distributed!:')
        fprintf('Suggested correlation between mean (log10) and variance (log10) is %f with pvalue: %f',Rho,pVal)
    end
end

sequence = uniSequence;
Y = yPP;
weightsY = 1./stdyPP;

end

