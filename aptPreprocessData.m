function [sequence,Y,weightsY,doLog10] = aptPreprocessData
%APTPREPROCESSDATA Does the preprocessing of the sequence data.
%   Often multiple measurements to one sequence are performed. Her mean and
%   weights calculation for regression model.

global apt

if ~isfield(apt,'sequence')
    apt.sequence = {};
    apt.Y = [];
    apt.weightsY = [];
else
    error('apt.sequence exists already. But the purpose of this function is to translate entries of apt.data(id).sequence to apt.sequemnce')
end

for id = 1:length(apt.data)
    [uniSequence,~,idxSeq] = unique(apt.data(id).sequence);
    Y = apt.data(id).Y;
    yPP = zeros(1,length(uniSequence));
    stdyPP = zeros(1,length(uniSequence));
    
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
    
    % construct one field in apt carrying all information
    if isempty(apt.sequence)
        apt.sequence = uniSequence;
    else
        apt.sequence = {apt.sequence{:},uniSequence{:}};
    end
    apt.Y = [apt.Y,yPP];
    apt.weightsY = [apt.weightsY,1./stdyPP];
end

% Do test about log10-distributed errors
if apt.doLog10
    [Rho,pVal] = corr(apt.Y',1./apt.weightsY');
    if pVal<0.01
        warning('Parson-Test suggests that errors are not log-normal distributed!:')
        fprintf('Suggested correlation between mean (log10) and variance (log10) is %f with pvalue: %f',Rho,pVal)
    end
end

end

