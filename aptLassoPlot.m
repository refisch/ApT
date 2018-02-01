function aptLassoPlot
%APTLASSOPLOT Summary of this function goes here
%   Detailed explanation goes here

global apt

for iY = 1:length(apt.Y)
    hold on
    if isfield(apt.stats(iY),'Index1SE')
        [axh] = lassoPlot(apt.stats(iY).beta,apt.stats(iY),'PlotType','CV');
    else
        [axh] = lassoPlot(apt.stats(iY).beta,apt.stats(iY));
    end
    if isfield(apt.stats(iY),'MSEreg')
        plot(axh,apt.stats(iY).Lambda, ones(1,length(apt.stats(iY).Lambda))*apt.stats(iY).MSEreg,'r--');
    end
    title(['Cross-validated MSE of Lasso fit for observable ' apt.data(1).obsName{iY}])
    hold off
end
end

