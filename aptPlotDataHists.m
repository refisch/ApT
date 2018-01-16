function aptPlotDataHists
%APTPLOTSUMMARYRESULTS Summary of this function goes here
%   Detailed explanation goes here
global apt

if apt.stats.doLog10
    figure
    subplot(2,1,1)
    histogram(apt.stats.Y)
    title('Histogram of log10 of means of MaxIncrease')
    
    subplot(2,1,2)
    histogram(1./apt.stats.weightsY)
    title('Histogram of standard errors (log10) calculated from replicates')
else
    figure
    subplot(2,1,1)
    histogram(apt.stats.Y,0:50:1100)
    title('Histogram of means of MaxIncrease')
    
    subplot(2,1,2)
    histogram(1./apt.stats.weightsY,0:20:300)
    title('Histogram of standard errors calculated from replicates')
end

end

