function aptIncludeDataPredictors(validationMode)
%APTINCLUDEDATAPREDICTORS Summary of this function goes here
%   Detailed explanation goes here

if ~exist('validationMode','var')
    validationMode = false;
end

global apt;

if isfield(apt.pred,'DataPredictors') && ~isempty(apt.pred.DataPredictors)
    if apt.config.fitReplicates
        warning('You try to include specific info of individual data points, but you want to fit replicates. I am going to skip these predictors including:')
        disp(apt.pred.DataPredictors)
        return
    else
        predNames = intersect(apt.pred.DataPredictors,apt.data(1).predName);
        if validationMode
            dataPred = [];
            for id = 1:length(apt.data)
                dataPred = [dataPred; 1];
            end
        else
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
        
    end
else
    return
end


end

