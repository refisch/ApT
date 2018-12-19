function aptPlotYs(iYs,Yfit)
%APTPLOTYS Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~exist('iYs', 'var') || isempty(iYs)
    iYs = 1:length(apt.Y);
end

if ~exist('Yfit', 'var') || isempty(Yfit)
    loocv = true;
else 
    loocv = false;
end

for iY = iYs
    if loocv 
        Yfit = apt.LOOCV(iY).YPredicted;
    end
    if apt.config.doLog10(iY)
        figure
        s1 = subplot(2,1,1);
        scatter(apt.Y{iY},Yfit,'r');
        hold on
        plot([min(apt.Y{iY}),max(apt.Y{iY})],[min(apt.Y{iY}),max(apt.Y{iY})],'r--');
        hold off
        
        s2 = subplot(2,1,2);
        scatter(10.^apt.Y{iY},10.^Yfit,'b');
        hold on
        plot([min(10.^apt.Y{iY}),max(10.^apt.Y{iY})],[min(10.^apt.Y{iY}),max(10.^apt.Y{iY})],'b--');
        hold off
        title(s1, 'on log10 scale')
        title(s2, 'backtransformed to lin scale')
        xlabel(s1,'measured')
        xlabel(s2,'measured')
        if isfield(apt,'LOOCV') && all(Yfit == apt.LOOCV(iY).YPredicted)
            myYLab = 'predicted';
        else
            myYLab = 'fitted';
        end
        ylabel(s1,myYLab)
        ylabel(s2,myYLab)
        suptitle([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
    else
        figure
        scatter(apt.Y{iY},Yfit,'b');
        hold on
        plot([min(apt.Y{iY}),max(apt.Y{iY})],[min(apt.Y{iY}),max(apt.Y{iY})],'b--');
        xlabel('measured')
        ylabel('fitted')
        title([apt.data(1).obsName{iY} '; n = ' num2str(sum(~isnan(apt.Y{iY})))])
    end
end
end

