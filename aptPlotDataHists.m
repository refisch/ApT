function aptPlotDataHists
%APTPLOTSUMMARYRESULTS Summary of this function goes here
%   Detailed explanation goes here
global apt

numBins = 12;
% minVal = [];
% maxVal = [];
for iY = 1:length(apt.Y)
%     for id = 1:length(apt.data)
%         minVal = min([minVal;apt.data(id).Y{iY}]);
%         maxVal = max([maxVal;apt.data(id).Y{iY}]);
%     end
    figure
    for id = 1:length(apt.data)
        subplot(length(apt.data),1,id)
        histogram(apt.data(id).Y{iY},numBins)
        title(strrep(strrep(strrep(apt.data(id).filename,'_','\_'),'.csv',''),'Data/',''))
        suptitle([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
    end
    
    if apt.config.doLog10(iY)
        figure
        subplot(2,1,1)
        histogram(apt.Y{iY},numBins)
        title(['Histogram of log10 of means - ' apt.data(1).obsName{iY}])
        
        subplot(2,1,2)
        if isfield(apt.config,'fitReplicates') && apt.config.fitReplicates
        histogram(1./apt.weightsY{iY},numBins)
        title('Histogram of standard errors (log10) calculated from replicates')
        suptitle([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
        end
    else
        figure
        subplot(2,1,1)
        histogram(apt.Y{iY},numBins)
        title(['Histogram of means of ' apt.data(1).obsName{iY}])
        
        subplot(2,1,2)
        if isfield(apt.config,'fitReplicates') && apt.config.fitReplicates
            histogram(1./apt.weightsY{iY},numBins)
            title('Histogram of standard errors calculated from replicates')
            suptitle([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
        end
    end
    
end
end

