function aptPlotSummaryResults(stats,Y,sequence,weightsY)
%APTPLOTSUMMARYRESULTS Summary of this function goes here
%   Detailed explanation goes here
close all

if isfield(stats,'Index1SE')
    lassoPlot(stats.beta,stats,'PlotType','CV')
else
    lassoPlot(stats.beta,stats)
end

seqlogo(sequence)

if stats.doLog10
    figure
    subplot(2,1,1)
    histogram(Y)
    title('Histogram of log10 of means of MaxIncrease')
    
    subplot(2,1,2)
    histogram(1./weightsY)
    title('Histogram of standard errors (log10) calculated from replicates')
else
    figure
    subplot(2,1,1)
    histogram(Y,0:50:1100)
    title('Histogram of means of MaxIncrease')
    
    subplot(2,1,2)
    histogram(1./weightsY,0:20:300)
    title('Histogram of standard errors calculated from replicates')
end

end

