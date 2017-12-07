function [sequence,Y,weightsY] = aptPreprocessData(sequence,Y)
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

sequence = uniSequence;
Y = yPP;
weightsY = 1./stdyPP;

end

