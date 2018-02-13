function [sequence,Y,weightsY,doLog10] = aptPreprocessData(offset_logScale)
%APTPREPROCESSDATA Does the preprocessing of the sequence data.
%   Often multiple measurements to one sequence are performed. Her mean and
%   weights calculation for regression model.

global apt

if ~exist('offset_logScale','var')
    offset_logScale = 8;
end

if ~isfield(apt,'sequence')
    apt.sequence = {};
    apt.Y = cell(size(apt.data(1).obsName));
    if apt.config.fitReplicates
        apt.weightsY = cell(size(apt.data(1).obsName));
    end
else
    error('apt.sequence exists already. But the purpose of this function is to translate entries of apt.data(id).sequence to apt.sequence')
end

% Log scale?
if isfield(apt, 'config') && isfield(apt.config, 'doLog10Extern')
    apt.config.doLog10 = apt.config.doLog10Extern;
else
    apt.config.doLog10 = false;
end

% construct fields apt.sequemce, apt.Y and .apt.weightsY carrying all information
for id = 1:length(apt.data)
    if isempty(apt.data(id).sequence)
        continue
    end
    if apt.config.fitReplicates
        [uniSequence,~,idxSeq] = unique(apt.data(id).sequence);
        for iY = 1:length(apt.data(id).Y)
            Y = apt.data(id).Y{iY};
            yPP = zeros(size(uniSequence));
            stdyPP = zeros(size(uniSequence));
            
            if apt.config.doLog10
                if min(Y)<0
                    Y = Y+abs(min(Y))+offset_logScale;
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
            apt.Y{iY} = [apt.Y{iY};yPP];
            apt.weightsY{iY} = [apt.weightsY{iY};1./stdyPP];
            apt.weightsY{iY}(isnan(apt.weightsY{iY})) = 0;
        end
        apt.sequence = {apt.sequence{:},uniSequence{:}};
    else
        for iY = 1:length(apt.data(id).Y)
            Y = apt.data(id).Y{iY};
            if apt.config.doLog10
                if min(Y)<0
                    Y = Y+abs(min(Y))+offset_logScale;
                end
                Y = log10(Y);
            end
            apt.Y{iY} = [apt.Y{iY};Y];
        end
        apt.sequence = {apt.sequence{:},apt.data(id).sequence{:}};
    end
end

% Do test about log10-distributed errors
if isfield(apt, 'weightsY')
    for iY = 1:length(apt.Y)
        if apt.config.doLog10
            [Rho,pVal] = corr(apt.Y{iY}',1./apt.weightsY{iY}');
            if pVal<0.01
                warning('Parson-Test suggests that errors are not log-normal distributed!:')
                fprintf('Obsevable %d %s: Suggested correlation between mean (log10) and variance (log10) is %f with pvalue: %f',iY,apt.data(1).obsName{iY},Rho,pVal)
            end
        end
    end
end
end