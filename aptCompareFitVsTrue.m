function kfit = aptCompareFitVsTrue(sequence, stats,doPlot)
%COMPAREFITVSTRUE Summary of this function goes here
%   Detailed explanation goes here


ktrue = stats.Y;
predX = aptPredictors(sequence);
kfit = stats.Intercept(stats.Index1SE)+predX'*stats.beta(:,stats.Index1SE);
if doPlot
    if stats.doLog10
        figure
        s1 = subplot(2,1,1);
        scatter(ktrue,kfit,'r');
        hold on
        plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'r--');
        hold off
        
        s2 = subplot(2,1,2);
        scatter(10.^ktrue,10.^kfit,'b');
        hold on
        plot(min(10.^ktrue):max(10.^ktrue),min(10.^ktrue):max(10.^ktrue),'b--');
        hold off
        title(s1, 'on log10 scale')
        title(s2, 'backtransformed to lin scale')
        xlabel(s1,'true')
        ylabel(s1,'fitted')
        xlabel(s2,'true')
        ylabel(s2,'fitted')
    else
        figure
        scatter(ktrue,kfit,'b');
        hold on
        plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'b--');
    end
end
end