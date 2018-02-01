function aptReadSequenceData(filename, observables)
%APTREADSEQUENCEDATA reads in data from filename.
% filename is 'str'

global apt

if ~exist('observables','var')
    observables = {'MaxIncrease'};
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

apt.data(id).array = id; % default behavior
apt.data(id).conc = nan;
apt.data(id).filename = filename;

end

