function [sequence,Y,weightsY] = aptPreprocessData(sequence,Y,doLog10)
%APTPREPROCESSDATA Does the preprocessing of the sequence data.
%   Often multiple measurements to one sequence are performed. Her mean and
%   weights calculation for regression model.

[uniSequence,~,idxSeq] = unique(sequence);
yPP = zeros(1,length(uniSequence));
stdyPP = yPP;
if doLog10
    if min(Y)<0
        Y = Y+abs(min(Y))+1;
    end
    for iGroups = 1:length(uniSequence)
        yPP(iGroups) = mean(log10(Y(idxSeq==iGroups)));
        stdyPP(iGroups) = std(log10(Y(idxSeq==iGroups)));
    end
else
    for iGroups = 1:length(uniSequence)
        yPP(iGroups) = mean(Y(idxSeq==iGroups));
        stdyPP(iGroups) = std(Y(idxSeq==iGroups));
    end
end

sequence = uniSequence;
Y = yPP;
weightsY = 1./stdyPP;

end

