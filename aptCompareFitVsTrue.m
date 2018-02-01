function aptCompareFitVsTrue(doPlot)
%COMPAREFITVSTRUE Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~exist('doPlot', 'var')
    doPlot = 1;
end

for iY = 1:length(apt.Y)
    ktrue = apt.Y{iY};
    apt.Yfit{iY} = apt.stats(iY).Intercept(apt.stats(iY).Index1SE)+apt.predX'*apt.stats(iY).beta(:,apt.stats(iY).Index1SE);
    if doPlot
        if apt.config.doLog10
            figure
            s1 = subplot(2,1,1);
            scatter(ktrue,apt.Yfit{iY},'r');
            hold on
            plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'r--');
            hold off
            
            s2 = subplot(2,1,2);
            scatter(10.^ktrue,10.^apt.Yfit{iY},'b');
            hold on
            plot(min(10.^ktrue):max(10.^ktrue),min(10.^ktrue):max(10.^ktrue),'b--');
            hold off
            title(s1, 'on log10 scale')
            title(s2, 'backtransformed to lin scale')
            xlabel(s1,'true')
            ylabel(s1,'fitted')
            xlabel(s2,'true')
            ylabel(s2,'fitted')
            suptitle([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
        else
            figure
            scatter(ktrue,apt.Yfit{iY},'b');
            hold on
            plot(min(ktrue):max(ktrue),min(ktrue):max(ktrue),'b--');
        end
    end
end
end