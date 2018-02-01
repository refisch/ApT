function aptPlotDataHists
%APTPLOTSUMMARYRESULTS Summary of this function goes here
%   Detailed explanation goes here
global apt

minVal = [];
maxVal = [];
for iY = 1:length(apt.Y)
    for id = 1:length(apt.data)
        minVal = min([minVal;apt.data(id).Y{iY}]);
        maxVal = max([maxVal;apt.data(id).Y{iY}]);
    end
    myEdges = minVal:(maxVal-minVal)/20:maxVal;
    figure
    for id = 1:length(apt.data)
        subplot(length(apt.data),1,id)
        histogram(apt.data(id).Y{iY},'BinEdges',myEdges)
        title(strrep(apt.data(id).filename,'_','\_'))
    end
    
    if apt.config.doLog10
        figure
        subplot(2,1,1)
        histogram(apt.Y{iY})
        title(['Histogram of log10 of means - ' apt.data(1).obsName{iY}])
        
        subplot(2,1,2)
        histogram(1./apt.weightsY{iY})
        title('Histogram of standard errors (log10) calculated from replicates')
    else
        figure
        subplot(2,1,1)
        histogram(apt.Y{iY},0:50:1100)
        title(['Histogram of means of ' apt.data(1).obsName{iY}])
        
        subplot(2,1,2)
        histogram(1./apt.weightsY{iY},0:20:300)
        title('Histogram of standard errors calculated from replicates')
    end
    
end
end

