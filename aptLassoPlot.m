function aptLassoPlot
%APTLASSOPLOT Summary of this function goes here
%   Detailed explanation goes here

global apt


for iY = 1:length(apt.Y)
    if isfield(apt.stats(iY),'Index1SE')
        [axh] = lassoPlot(apt.stats(iY).beta,apt.stats(iY),'PlotType','CV');
    else
        [axh] = lassoPlot(apt.stats(iY).beta,apt.stats(iY));
    end
    hold on
    % Standard regression -- take care of NaNs in apt.Y!! 
    Xreg = [ones(size(apt.Y{iY})), apt.predX'];
    betareg{iY} = regress(apt.Y{iY}, Xreg);
    MSEreg{iY} = 1 / length(apt.Y{iY}) * sum((apt.Y{iY}-Xreg*betareg{iY}).^2);
    plot(axh,apt.stats(iY).Lambda, ones(1,length(apt.stats(iY).Lambda))*MSEreg{iY},'r--');
    title(['Cross-validated MSE of Lasso fit for observable ' apt.data(1).obsName{iY}])
    hold off
end
end

