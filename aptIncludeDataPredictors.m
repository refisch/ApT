function aptIncludeDataPredictors
%APTINCLUDEDATAPREDICTORS Summary of this function goes here
%   Detailed explanation goes here

global apt;
if isfield(apt.pred,'DataPredictors') && ~isempty(apt.pred.DataPredictors)
    if apt.config.fitReplicates
        warning('You try to include specific info of individual data points, but you want to fit replicates. I am going to skip this predictor')
        return
    else
        predNames = intersect(apt.pred.DataPredictors,apt.data(1).predName);
        for iX = 1:length(predNames)
            idxX = find(~cellfun(@isempty,strfind(apt.data(1).predName,predNames{iX})));
            dataPred = [];
            for id = 1:length(apt.data)
                dataPred = [dataPred; apt.data(id).X{idxX}];
            end
        apt.predNames{end+1} = ['Data_' predNames{iX}];
        apt.predX = [apt.predX; dataPred'];
        end
        
    end
else
    return
end


end

