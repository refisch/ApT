function aptLassoPlot
%APTLASSOPLOT Summary of this function goes here
%   Detailed explanation goes here

global apt

hold on
if isfield(apt.stats,'Index1SE')
    [axh] = lassoPlot(apt.stats.beta,apt.stats,'PlotType','CV');
else
    [axh] = lassoPlot(apt.stats.beta,apt.stats);
end
if isfield(apt,'MSEreg')
    plot(axh,apt.stats.Lambda, ones(1,length(apt.stats.Lambda))*apt.MSEreg,'r--');
end
hold off
end

