function aptLassoRegression
%APTLASSOREGRESSION Summary of this function goes here
%   Detailed explanation goes here
global apt
nfoldCV = 10;
for iY = 1:length(apt.data(1).obsName)
    tic
    if apt.config.fitReplicates
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',nfoldCV);
    else
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'CV',nfoldCV);
    end
    stats.runtime = toc;
    stats.beta = beta;
    stats.name = 'LassoRegression';
    stats.nfoldCV = nfoldCV;
    apt.stats(iY) = stats;
    clear stats;
    
    tic
    apt.normalizedPredX = zscore(apt.predX')';
    if apt.config.fitReplicates
        [beta, stats] = lasso(apt.normalizedPredX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',nfoldCV);
    else
        [beta, stats] = lasso(apt.normalizedPredX',apt.Y{iY},'PredictorNames',apt.predNames,'CV',nfoldCV);
    end
    stats.runtime = toc;
    stats.beta = beta;
    stats.name = 'LassoRegression_Normalized_Predictors';
    stats.nfoldCV = nfoldCV;
    apt.rankstats(iY) = stats; 
end
end

