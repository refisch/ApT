apt.pred.DataPredictors = apt.data(1).predName;
apt.pred.ExpCond = length(apt.data) > 1; % true or false
% apt.pred.ExpCond = false;
apt.pred.Length = true; % true or false
apt.pred.LengthTail = 'all'; % explicit forms in cell array, empty ({}) or 'all' -- count number of same nucleobases at the end.
apt.pred.Singles = 'all'; % explicit forms, empty ({}) or 'all'
apt.pred.Dimers = 'all'; % explicit forms, empty ({}) or 'all'
apt.pred.Codons = 'all'; % explicit forms, empty ({}) or 'all'
apt.pred.NMers = '';%{'TATA'}; % explicit forms or empty
apt.pred.RegExp = {'GG[ACT]{1}GG','GG[ACT]{2}GG','GG[ACT]{3}GG','GG[ACT]{4}GG'};


apt.pred.CertainPosFeatures.position = 1:15; % this is not done dynamically, because in validation sequences length might differ.
apt.pred.CertainPosFeatures.pattern = {'G','G','T','T','G','G','T','G','T','G','G','T','T','G','G'};

apt.pred.SimplifiedSequence = true; % true or false
apt.pred.symmetry = true; % true or false

apt.pred.InteractionTerms = '';%{'Single_G*Single_C'};



