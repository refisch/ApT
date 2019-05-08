function aptLassoRegression
%APTLASSOREGRESSION Summary of this function goes here
%   Detailed explanation goes here
global apt

nfoldCV = 10;
CVIdx = aptGetCVIndices(nfoldCV); % find CV blocks respecting data structure (replicates!)

%% Problem when there is nans in weigths and data!!

%% Individual fit
for iY = 1:length(apt.data(1).obsName)
    tic
    if apt.config.fitReplicates
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',CVIdx);
    else
        [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'CV',CVIdx);
    end
    stats.runtime = toc;
    stats.beta = beta;
    stats.name = 'LassoRegression';
    stats.nfoldCV = nfoldCV;
    apt.stats(iY) = stats;
    
%     tic
%     zscor_xnan = @(x) bsxfun(@rdivide, bsxfun(@minus, x, mean(x,'omitnan')), std(x, 'omitnan')); %NaN handling
%     apt.normalizedPredX = zscor_xnan(apt.predX')';
%     apt.normalizedPredX(all(isnan(apt.normalizedPredX),2),:) = 0;
%     if apt.config.fitReplicates
%         [beta, stats] = lasso(apt.normalizedPredX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',nfoldCV);
%     else
%         [beta, stats] = lasso(apt.normalizedPredX',apt.Y{iY},'PredictorNames',apt.predNames,'CV',nfoldCV);
%     end
%     stats.runtime = toc;
%     stats.beta = beta;
%     stats.name = 'LassoRegression_Normalized_Predictors';
%     stats.nfoldCV = nfoldCV;
%     apt.rankstats(iY) = stats; 
end

%% Joint fit
% % makes sense if all observables have same scaling
% if isfield(apt.config,'doZscoreData') && apt.config.doZscoreData && apt.config.doZscoreModel
%     tic
%     if apt.config.fitReplicates
%         [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'Weights',apt.weightsY{iY},'CV',nfoldCV);
%     else
%         [beta, stats] = lasso(apt.predX',apt.Y{iY},'PredictorNames',apt.predNames,'CV',nfoldCV);
%     end
%     stats.runtime = toc;
%     stats.beta = beta;
%     stats.name = 'LassoRegression';
%     stats.nfoldCV = nfoldCV;
%     apt.stats(iY) = stats;
%     clear stats;
% end
end

