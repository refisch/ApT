function aptIncludeExperimentalConditions
%aptIncludeExperimentalConditions Summary of this function goes here
%   Detailed explanation goes here

global apt

if isfield(apt,'predExpCond')
    if apt.predExpCond
        conc = [];
        array = [];
        for id = 1:length(apt.data)
            conc = [conc apt.data(id).conc*ones(1,length(unique(apt.data(id).sequence)))];
            array = [array apt.data(id).array*ones(1,length(unique(apt.data(id).sequence)))];
        end
        apt.predNames{end+1} = 'Concentration';
        apt.predX = [apt.predX; conc];
        uniArray = unique(array);
        if length(uniArray)>1
            for ia = 2:length(uniArray)
                apt.predNames{end+1} = ['Array#' num2str(uniArray(ia))];
                apt.predX = [apt.predX; array == uniArray(ia)];
            end
        end
        
    end
end


end

