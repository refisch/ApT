function aptSave(folderName,saveFigures)
%APTSAVE saves apt variable to workspace. Also saves figures if flag is set.

global apt

if ~exist('folderName','var')
    prompt = 'Please enter the name of the savefolder:\n';
    folderName = input(prompt,'s');
end

if ~exist('saveFigures','var')
    saveFigures = false;
end
wd = pwd;
pathtofolder = [wd '/Results/' folderName];
cd Results
if ~isdir(folderName)
    mkdir(folderName);
end
cd(wd)
apt.savepath = pathtofolder;
save([pathtofolder '/workspace.mat'],'apt')

copyfile('Results.txt', pathtofolder)

% save figures
if saveFigures
    FolderName = pathtofolder;   % Your destination folder
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
        FigHandle = FigList(iFig);
        FigName   = get(FigHandle, 'Name');
        if isempty(FigName)
            FigName = ['Figure' num2str(iFig)];
        end
        savefig(FigHandle, fullfile(FolderName, [FigName, '.fig']));
        print(FigHandle,fullfile(FolderName, FigName),'-dpng','-r300')
    end
end

end

