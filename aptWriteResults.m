function aptWriteResults(filename)
%APTWRITERESULTS Writes key information to file 'Results'
%   Detailed explanation goes here

if(~exist('filename','var') || isempty(filename))
    filename = 'Results';
end

global apt

fid = fopen([filename '.txt'],'w');
totDataPoints = 0;
for iY = 1:length(apt.Y)
    totDataPoints = totDataPoints+length(apt.Y{iY});
end

apt.info.totalNumberDataPoints = totDataPoints;
apt.info.uniqueSequences = length(unique(apt.sequence));
apt.info.totalNumberPredictors = length(apt.predNames);

fprintf(fid,'Lasso Regression analysis \n with %d predictors of %d observables with %d unique sequences and a total of %d datapoints\n\n',apt.info.totalNumberPredictors,length(apt.Y),apt.info.uniqueSequences,apt.info.totalNumberDataPoints);

if isfield(apt.config,'useLassoFit') && strcmp(apt.config.useLassoFit,'best')
    fprintf(fid,'Lasso Fit with Least MSE is used\n');
else
    fprintf(fid,'Lasso Fit with one standard error deviance from Least MSE model is used\n');
end

for iY = 1:length(apt.Y)
    if apt.config.doLog10(iY)
        digits = '6';
    else
        digits = '3';
    end
    fprintf(fid,'\n---------------------------------------\n');
    fprintf(fid,'Observable %d: %s\n\n',iY,apt.data(1).obsName{iY});
    if isfield(apt,'rankstats')
        if isfield(apt.config,'useLassoFit') && strcmp(apt.config.useLassoFit,'best')
            idxMSE = apt.rankstats(iY).IndexMinMSE;
        else
            idxMSE = apt.rankstats(iY).Index1SE;
        end
        [beta_sorted,idxA] = sort(apt.rankstats(iY).beta(:,idxMSE),'descend');
        predNames_sorted = apt.predNames(idxA);
        idxPred = find(beta_sorted);
        fprintf(fid,'RootMeanSquaredError = %s\n', sqrt(apt.rankstats(iY).MSE(idxMSE)));
        fprintf(fid,['Intercept:\t\t\t\t%.' digits 'f\n'],apt.rankstats(iY).Intercept(idxMSE));
        fprintf(fid,'The %d contributing predictors according to L1 penalization, sorted with respect to effect size: \n %35s \t Value\n',length(idxPred),'Predictor');
        for i = 1:length(idxPred)
            fprintf(fid,['%35s\t%.' digits 'f\n'],predNames_sorted{idxPred(i)},beta_sorted(idxPred(i)));
        end
    else
        if isfield(apt.config,'useLassoFit') && strcmp(apt.config.useLassoFit,'best')
            idxMSE = apt.stats(iY).IndexMinMSE;
        else
            idxMSE = apt.stats(iY).Index1SE;
        end
        [beta_sorted,idxA] = sort(apt.stats(iY).beta(:,idxMSE),'descend');
        predNames_sorted = apt.predNames(idxA);
        idxPred = find(beta_sorted);
        fprintf(fid,'RootMeanSquaredError = %s\n\n', sqrt(apt.stats(iY).MSE(idxMSE)));
        fprintf(fid,['Intercept:\t\t\t\t%.' digits 'f\n'],apt.stats(iY).Intercept(idxMSE));
        fprintf(fid,'The %d contributing predictors, sorted with respect to effect size: \n \t\tPredictor\t Value\n',length(idxPred));
        
        for i = 1:length(idxPred)
            fprintf(fid,['%23s\t\t\t%.' digits 'f\n'],predNames_sorted{idxPred(i)},beta_sorted(idxPred(i)));
        end
        
    end
    fprintf(fid,'\n---------------------------------------\n');
    
end

fprintf(fid,'\n---------------------------------------\n');
fprintf(fid,'\n\n All Predictors were:\n');
for i = 1:length(apt.predNames)
    fprintf(fid,'%23s\n',apt.predNames{i});
end

status = fclose(fid);

if status ~=0
    warning('During writing of file something went wrong!')
end
end

