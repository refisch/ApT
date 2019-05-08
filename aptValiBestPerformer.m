function aptValiBestPerformer(Nbest)

global apt

if ~isfield(apt,'vali')
    error('this function requires some input sequences that will be mimicked.')
end

if ~exist('Nbest','var') || isempty(Nbest)
    Nbest = 20;
end

fID = fopen('Predicted_Best_Performer.txt','w+');

for iY = 1:length(apt.Y)
    fprintf(fID,'%50s',sprintf('Top %d performer for observable %s \n',Nbest,apt.data(1).obsName{iY}));
    header;
    [maxVal, maxIdx]= maxk(apt.vali.estResponse{iY},Nbest);
    for i = 1:length(maxVal)
        
        fprintf(fID,'%50s',apt.vali.generatedSequence{maxIdx(i)});
        if isfield(apt.vali,'generatedSpacer')
            fprintf(fID,'\t%50s',apt.vali.generatedSpacer{maxIdx(i)});
        end
        for iObs = 1:length(apt.data(1).obsName)
            fprintf(fID,'\t');
            fprintf(fID,sprintf('%f',apt.vali.estResponse{iObs}(maxIdx(i))));
        end
        fprintf(fID,'\n');
    end
    
end

if length(apt.Y)>1
    fprintf(fID,'%50s',sprintf('Top %d performer for sum of observables \n',Nbest));
    header
    totalresponse = apt.vali.estResponse{1};
    for iN = 2:length(apt.vali.estResponse)
        totalresponse = totalresponse + apt.vali.estResponse{iN};
    end
    [~, maxIdx]= maxk(totalresponse,Nbest);
    for i = 1:length(maxVal)
        fprintf(fID,'%50s',apt.vali.generatedSequence{maxIdx(i)});
        for iObs = 1:length(apt.data(1).obsName)
            fprintf(fID,'\t');
            fprintf(fID,sprintf('%f',apt.vali.estResponse{iObs}(maxIdx(i))));
        end
        fprintf(fID,'\n');
        
    end
end
    function header
        fprintf(fID,'%50s','Sequence');
        for iObs = 1:length(apt.data(1).obsName)
            fprintf(fID,apt.data(1).obsName{iObs});
            fprintf(fID,'\t');
        end
        fprintf(fID,'\n');
    end
end