function [sequence,Y,weightsY,doLog10] = aptPreprocessData
%APTPREPROCESSDATA Does the preprocessing of the sequence data.
%   Often multiple measurements to one sequence are performed. Her mean and
%   weights calculation for regression model.

global apt

[uniSequence,~,idxSeq] = unique(apt.sequence);
yPP = zeros(1,length(uniSequence));
stdyPP = zeros(1,length(uniSequence));

for iGroups = 1:length(uniSequence)
    yPP(iGroups) = mean(apt.Y(idxSeq==iGroups));
    stdyPP(iGroups) = std(apt.Y(idxSeq==iGroups));
end

if isfield(apt, 'doLog10Extern')
    apt.doLog10 = apt.doLog10Extern;
else
    apt.doLog10 = false;
    [~,pVal] = corr(yPP',stdyPP');
    if pVal < 0.01
        apt.doLog10 = true;
    end
end

if apt.doLog10
    if min(apt.Y)<0
        apt.Y = apt.Y+abs(min(apt.Y))+1;
    end
    for iGroups = 1:length(uniSequence)
        yPP(iGroups) = mean(log10(apt.Y(idxSeq==iGroups)));
        stdyPP(iGroups) = std(log10(apt.Y(idxSeq==iGroups)));
    end
    [Rho,pVal] = corr(yPP',stdyPP');
    if pVal<0.01
        warning('Parson-Test suggests that errors are not log-normal distributed!:')
        fprintf('Suggested correlation between mean (log10) and variance (log10) is %f with pvalue: %f',Rho,pVal)
    end
end

apt.sequence = uniSequence;
apt.Y = yPP;
apt.weightsY = 1./stdyPP;

end

