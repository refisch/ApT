function aptReadSequenceData(filename)
%APTREADSEQUENCEDATA reads in data from filename.
% filename is 'str'

global apt

[apt.header, data, dataCell] = aptReadCSVHeaderFile(filename, ',', true);
apt.sequence = strrep(dataCell(:,1),'_x000D_','');
apt.Y = data(:,2);


end

