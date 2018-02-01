function aptLassoRegression
%APTLASSOREGRESSION Summary of this function goes here
%   Detailed explanation goes here
global apt
nfoldCV = 10;
for iY = 1:length(apt.data(1).obsName)
    tic
    if apt.config.doPreprocessing
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',nfoldCV);
    else
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames);
    end
    stats.runtime = toc;
    stats.beta = beta;
    stats.Y = apt.Y;
    stats.weightsY = apt.weightsY;
    stats.name = 'LassoRegression';
    stats.nfoldCV = nfoldCV;
    apt.stats(iY) = stats;
end
end

