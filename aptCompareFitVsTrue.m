function aptCompareFitVsTrue(doPlot)
%COMPAREFITVSTRUE Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~exist('doPlot', 'var')
    doPlot = 1;
end

ktrue = apt.stats.Y;
apt.Yfit = apt.stats.Intercept(apt.stats.Index1SE)+apt.predX'*apt.stats.beta(:,apt.stats.Index1SE);
if doPlot
    if apt.stats.doLog10
        figure
        s1 = subplot(2,1,1);
        scatter(ktrue,apt.Yfit,'r');
        hold on
        plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'r--');
        hold off
        
        s2 = subplot(2,1,2);
        scatter(10.^ktrue,10.^apt.Yfit,'b');
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
        scatter(ktrue,apt.Yfit,'b');
        hold on
        plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'b--');
    end
end
end