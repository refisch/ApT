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

% find minimum over all data sets and correct for negative values
if apt.config.doLog10
    minY = zeros(1,length(apt.data(1).Y));
    for iY = 1:length(apt.data(1).Y)
        minYtmp = 0;
        for id = 1:length(apt.data)
            minYtmp = min([minYtmp apt.data(id).Y{iY}']);
        end
        minY(iY) = minYtmp;
    end
    minY(minY<0) = abs(minY(minY<0)) + offset_logScale;
end
% construct fields apt.sequence, apt.Y and apt.weightsY carrying all information
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
                Y = Y+minY(iY);
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
                Y = Y+minY(iY);
                Y = log10(Y);
            end
            apt.Y{iY} = [apt.Y{iY};Y];
        end
        apt.sequence = {apt.sequence{:},apt.data(id).sequence{:}};
    end
end

% Zscore on data level?
if isfield(apt.config,'doZscoreData') && apt.config.doZscoreData
    for id = 1:length(apt.Y)
        [apt.Y{id}(~isnan(apt.Y{id})),apt.zscore.YMu(id),apt.zscore.YStd(id)] = zscore(apt.Y{id}(~isnan(apt.Y{id})));
        % weights?
    end
end

% Shall we split spacer??
if isfield(apt.config,'splitSequence') && apt.config.splitSequence
    for iseq = 1:length(apt.sequence)
        tmpseq = flip(apt.sequence{iseq});
        idxLL = regexp(tmpseq,tmpseq(1));
        splitHere = find(idxLL ~= 1:length(idxLL));
        if isempty(splitHere)
            splitHere = length(idxLL)+1;
        end
        splitHere = splitHere(1);
        if splitHere > 3
            apt.sequence{iseq} = flip(tmpseq(splitHere:length(tmpseq)));
            apt.spacer{iseq} = flip(tmpseq(1:(splitHere-1)));
        else
            apt.spacer{iseq} = '';
        end
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