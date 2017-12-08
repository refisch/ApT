function [Y,sequence,header] = aptReadSequenceData(filename)
%APTREADSEQUENCEDATA reads in data from filename.
% filename is 'str'
[header, data, dataCell] = aptReadCSVHeaderFile(filename, ',', true);
sequence = strrep(dataCell(:,1),'_x000D_','');
Y = data(:,2);

end

