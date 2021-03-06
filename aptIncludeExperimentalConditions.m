function aptIncludeExperimentalConditions(validationMode)
%aptIncludeExperimentalConditions Summary of this function goes here
%   Detailed explanation goes here

if ~exist('validationMode','var')
    validationMode = false;
end

global apt

% This does not work (yet) when removing nans from data.

if isfield(apt.pred,'ExpCond') && apt.pred.ExpCond
    conc = [];
    arrayData = [];
    if ~validationMode
        for id = 1:length(apt.data)
            if apt.config.fitReplicates
                conc = [conc apt.data(id).conc*ones(1,length(unique(apt.data(id).sequence)))];
                arrayData = [arrayData apt.data(id).array*ones(1,length(unique(apt.data(id).sequence)))];
            else
                conc = [conc apt.data(id).conc*ones(1,length(apt.data(id).sequence))];
                arrayData = [arrayData apt.data(id).array*ones(1,length(apt.data(id).sequence))];
            end
        end
    else
        for id = 1:length(apt.data)
            if apt.config.fitReplicates
                expConc(id) = apt.data(id).conc;
                arrayData = [arrayData apt.data(id).array*ones(1,length(unique(apt.data(id).sequence)))];
            else
                expConc(id) = apt.data(id).conc;
                arrayData = [arrayData apt.data(id).array*ones(1,length(apt.data(id).sequence))];
            end
        end
        expConc = mean(expConc);
        conc = expConc*ones(1,length(apt.sequence));
        arraySimu = zeros(1,length(apt.sequence));
    end
    if length(isnan(conc)) < length(conc)
        apt.predNames{end+1} = 'Concentration';
        apt.predX = [apt.predX; conc];
    end
    
    uniArray = unique(arrayData);
    if length(uniArray)>1
        for ia = 2:length(uniArray)
            apt.predNames{end+1} = ['Array#' num2str(uniArray(ia))];
            if ~validationMode
                apt.predX = [apt.predX; arrayData == uniArray(ia)];
            else
                apt.predX = [apt.predX; arraySimu];
            end
        end
    end
end


end

