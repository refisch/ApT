function CVIdx = aptGetCVIndices(nfoldCV)

global apt;

if ~exist('nfoldCV','var')
    nfoldCV = 10;
end

if ~contains(version,'2017b')
    error('Manual blocks for coross validation are currently only supported for 2017b. Also, the following changes need to be done: https://de.mathworks.com/matlabcentral/answers/203155-how-to-manually-construct-or-modify-a-cross-validation-object-in-matlab ')
end

if apt.config.splitSequence
    fullsequence = cell(size(apt.sequence));
    for i = 1:length(apt.sequence)
        fullsequence{i} = [apt.sequence{i} apt.spacer{i}];
    end
else
    fullsequence = apt.sequence;
end

[~,ia,ib] = unique(fullsequence,'stable');

CVIdx = cvpartition(length(ib),'k',nfoldCV);
rnd_ia = randperm(length(ia));
cvo_small = cvpartition(rnd_ia,'k',nfoldCV);

myIdx = nan(size(ib));

for icv = 1:nfoldCV
    idxsel = find(cvo_small.Impl.indices == icv);
	myIdx(ismember(ib, idxsel)) = icv;
end

if any(isnan(myIdx))
    error('NANs found')
end

CVIdx.Impl.indices = myIdx;

end

