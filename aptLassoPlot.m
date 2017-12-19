function aptLassoPlot(stats,MSEreg)
%APTLASSOPLOT Summary of this function goes here
%   Detailed explanation goes here
hold on
if isfield(stats,'Index1SE')
    [axh] = lassoPlot(stats.beta,stats,'PlotType','CV');
else
    [axh] = lassoPlot(stats.beta,stats);
end
if exist('MSEreg','var')
    plot(axh,stats.Lambda, ones(1,length(stats.Lambda))*MSEreg,'r--');
end
hold off
end

