apt.pred.DataPredictors = apt.data(1).predName;
apt.pred.ExpCond = true; % true or false
apt.pred.Length = false; % true or false
apt.pred.LengthTail = 'all'; % explicit forms in cell array, empty ({}) or 'all' -- count number of same nucleobases at the end.
apt.pred.Singles = {}; % explicit forms, empty ({}) or 'all'
apt.pred.Dimers = {};%'all'; % explicit forms, empty ({}) or 'all'
apt.pred.Codons = {};%'all'; % explicit forms, empty ({}) or 'all'
apt.pred.NMers = '';%{'TATA'}; % explicit forms or empty
apt.pred.RegExp = {};
apt.pred.InteractionTerms = '';%{'Single_G*Single_C'};

apt.pred.CertainPosFeatures.position = []; % array of numbers. This is not done dynamically, because in validation sequences length might differ.
apt.pred.CertainPosFeatures.pattern = {}; % cell array of letters.

apt.pred.SimplifiedSequence = true;% true or false
apt.pred.symmetry = false; % true or false
