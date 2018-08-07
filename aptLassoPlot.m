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
    Xreg = [ones(size(apt.Y{iY})), apt.predX'];
    betareg = regress(apt.Y{iY}(~isnan(apt.Y{iY})), Xreg((~isnan(apt.Y{iY})),:));
    MSEreg = 1 / sum(~isnan(apt.Y{iY})) * sum((apt.Y{iY}(~isnan(apt.Y{iY}))-Xreg(~isnan(apt.Y{iY}),:)*betareg).^2);
    plot(axh,apt.stats(iY).Lambda, ones(1,length(apt.stats(iY).Lambda))*MSEreg,'r--');
    title(['Cross-validated MSE of Lasso fit for observable ' apt.data(1).obsName{iY}])
    hold off
    
    linReg.X = Xreg;
    linReg.beta = betareg;
    linReg.MSE = MSEreg;
    apt.linReg(iY) = linReg;
end
end

