function aptLassoRegression
%APTLASSOREGRESSION Summary of this function goes here
%   Detailed explanation goes here
global apt
nfoldCV = 10;
tic
if apt.doPreprocessing
    [beta, stats] = lasso(apt.predX',apt.Y,'PredictorNames',apt.predNames,'Weights',apt.weightsY,'CV',nfoldCV);
else
    [beta, stats] = lasso(apt.predX',apt.Y,'PredictorNames',apt.predNames);
end
stats.runtime = toc;
stats.beta = beta;
stats.doLog10 = apt.doLog10;
stats.Y = apt.Y;
stats.weightsY = apt.weightsY;
stats.name = 'LassoRegression';
stats.nfoldCV = nfoldCV;

apt.stats = stats;

end

