function aptReadSequenceData(filename, observables,predictors)
%APTREADSEQUENCEDATA reads in data from filename.
% filename is 'str'

global apt

if ~exist('observables','var')
    observables = {'MaxIncrease'};
end

if ~exist('observables','var')
    predictors = {};
end

if ~isfield(apt,'data')
    id = 1;
else
    id = length(apt.data) + 1;
end

[header, data, dataCell] = aptReadCSVHeaderFile(filename, ',', true);
isSequence = strcmp(header,{'Sequence'});

apt.data(id).sequence = strrep(dataCell(:,isSequence),'_x000D_','');

for iObs = 1:length(observables)
    idxObs = find(strcmp(header,observables(iObs)));
    apt.data(id).obsName{iObs} = observables{iObs};
    if isempty(idxObs)
        apt.data(id).Y{iObs} = nan(size(apt.data(id).sequence));
        continue
    end
    apt.data(id).Y{iObs} = data(:,idxObs);
end


for iPred = 1:length(predictors)
    idxPred = find(strcmp(header,predictors(iPred)));
    apt.data(id).predName{iPred} = predictors{iPred};
    if isempty(idxPred)
        apt.data(id).X{iPred} = nan(size(apt.data(id).sequence));
        continue
    end
    apt.data(id).X{iPred} = data(:,idxPred);
end

% Remove nan data?
if isfield(apt.config,'RemoveNaNData') && apt.config.RemoveNaNData
    idxnan = false(size(apt.data(id).Y{1}));
    for iY = 1:length(apt.data(id).Y)
        idxnan = idxnan | isnan(apt.data(id).Y{iY});
    end
    for iY = 1:length(observables)
        apt.data(id).Y{iY} = apt.data(id).Y{iY}(~idxnan);
    end
    for iPred = 1:length(predictors)
        apt.data(id).X{iPred} = apt.data(id).X{iPred}(~idxnan);
    end
    apt.data(id).sequence = apt.data(id).sequence(~idxnan);
end


apt.data(id).array = id; % default behavior
apt.data(id).conc = nan;
apt.data(id).filename = filename;

end

