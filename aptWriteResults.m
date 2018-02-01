function aptWriteResults(filename)
%APTWRITERESULTS Writes key information to file 'Results'
%   Detailed explanation goes here

if(~exist('filename','var') || isempty(filename))
    filename = 'Results';
end

global apt

if apt.config.doLog10
    digits = '5';
else
    digits = '1';
end
fid = fopen([filename '.txt'],'w');
for iY = 1:length(apt.Y)
    [beta_sorted,idxA] = sort(apt.stats(iY).beta(:,apt.stats(iY).Index1SE),'descend');
    predNames_sorted = apt.predNames(idxA);
    idxPred = find(beta_sorted);
    fprintf(fid,'RootMeanSquaredError = %s\n\n', sqrt(apt.stats(iY).MSE(apt.stats(iY).Index1SE)));
    fprintf(fid,['Intercept:\t\t\t\t%.' digits 'f\n'],apt.stats(iY).Intercept(apt.stats(iY).Index1SE));
    fprintf(fid,'The %d contributing predictors, sorted with respect to effect size: \n \t\tPredictor\t Value\n',length(idxPred));
    
    for i = 1:length(idxPred)
        fprintf(fid,['%23s\t\t\t%.' digits 'f\n'],predNames_sorted{idxPred(i)},beta_sorted(idxPred(i)));
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

