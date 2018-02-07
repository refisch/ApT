function aptCompareFitVsTrue(doPlot)
%COMPAREFITVSTRUE Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~exist('doPlot', 'var') || isempty(doPlot)
    doPlot = 1;
end

for iY = 1:length(apt.Y)
    ktrue = apt.Y{iY};
    apt.Yfit1SE{iY} = apt.stats(iY).Intercept(apt.stats(iY).Index1SE)+apt.predX'*apt.stats(iY).beta(:,apt.stats(iY).Index1SE);
    if doPlot
        aptPlotYs(iY,apt.Yfit1SE{iY})
    end
end
end