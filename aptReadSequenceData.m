function aptReadSequenceData(filename)
%APTREADSEQUENCEDATA reads in data from filename.
% filename is 'str'

global apt

if ~isfield(apt,'data')
    id = 1;
else
    id = length(apt.data) + 1;
end

[header, data, dataCell] = aptReadCSVHeaderFile(filename, ',', true);
isSequence = strcmp(header,{'Sequence'});
isMaxIncrease = strcmp(header,{'MaxIncrease'});

apt.data(id).sequence = strrep(dataCell(:,isSequence),'_x000D_','');
apt.data(id).Y = data(:,isMaxIncrease);
apt.data(id).array = id; % default behavior
apt.data(id).conc = nan;
apt.data(id).filename = filename;

end

