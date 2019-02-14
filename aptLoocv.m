function  aptLoocv(doPlot)
%APTLOOCV Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~exist('doPlot', 'var') || isempty(doPlot)
    doPlot = true;
end

for iY = 1:length(apt.data(1).obsName)
    YMeasured = zeros(size(apt.Y{iY}));
    YPredicted = zeros(size(apt.Y{iY}));
    h = waitbar(0,sprintf('Performing CrossValidation...%d / %d',iY,length(apt.data(1).obsName)));
    for iSample = 1:length(apt.Y{iY})
        waitbar(iSample / length(apt.Y{iY}))
        %Split into Training set and LeaveOneOut
        idxV = zeros(size(apt.Y{iY}));
        idxV(iSample) = 1;
        idxV = logical(idxV);
        
        cvPredX = apt.predX(:,~idxV)';
        cvY = apt.Y{iY}(~idxV);
       
        
        looY = apt.Y{iY}(idxV);
        looPredX = apt.predX(:,idxV)';
        
        if apt.config.fitReplicates
            cvWeightsY = apt.weightsY{iY}(~idxV);
            [beta, stats] = lasso(cvPredX,cvY,'PredictorNames',apt.predNames,'Weights',cvWeightsY);
        else
            [beta, stats] = lasso(cvPredX,cvY,'PredictorNames',apt.predNames);
        end
        YMeasured(iSample) = looY;
        YPredicted(iSample) = looPredX*beta(:,stats.MSE==min(stats.MSE))+stats.Intercept(stats.MSE==min(stats.MSE));
    end
    close(h)
    apt.LOOCV(iY).YMeasured = YMeasured;
    apt.LOOCV(iY).YPredicted = YPredicted;
    if doPlot
        aptPlotYs(iY,YPredicted)
    end
end
end

