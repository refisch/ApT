function aptGenerateSequence(numberSequences)
%APTGENERATESEQUENCE generates numberSequences new sequences mimicking the
%input sequences given.
%   mode of generating new sequences is stored in apt.modeToGenerateNewSequences
%   'numberSequences' is amount of new sequences generated

global apt

if~isfield(apt,'sequence')
    error('this function requires some input sequences that will be mimicked.')
end

if(~exist('numberSequences','var') || isempty(numberSequences))
    numberSequences = 100;
end

if ~isfield(apt,'modeToGenerateNewSequences')
    apt.modeToGenerateNewSequences = 'random';
elseif ~(strcmp(apt.modeToGenerateNewSequences,'random') || strcmp(apt.modeToGenerateNewSequences,'mutated'))
    error('I do not know this mode of creating new sequences.')
end

% For this task only use 95% of longest sequences thus having longer test
% sequences with almost same amount of information.

lowerBound = floor(quantile(cellfun(@length,apt.sequence),0.05));
apt.sequence95pc = apt.sequence(cellfun(@length,apt.sequence)>lowerBound);

[W,figh] = seqlogo(apt.sequence95pc);
close(figh)

switch apt.modeToGenerateNewSequences
    case 'mutated' % This mode first looks for most prominent sequence and than mutates randomly some positions only
        
        % Start with mean Sequence
        minLen = min(cellfun(@length,apt.sequence95pc));
        meanSeq = char(zeros(1,minLen));
        for iPos = 1:minLen
            [~,idxmax] = max(W{2}(:,iPos));
            meanSeq(iPos) = W{1}(idxmax);
        end
        totDist = aptCalcStringDistance(meanSeq,apt.sequence95pc);
        minSeq = meanSeq;
        
        % Aim: Find sequence that minimizes distance to other sequences by random perturbations.
        for iPerm = 1:5000 % 10000 perturbations = 20s
            PertSeq = minSeq;
            PertSeq(ceil(rand(1)*minLen)) = W{1}(ceil(rand(1)*4));
            currDist = aptCalcStringDistance(PertSeq,apt.sequence95pc);
            [totDist, minidx] = min([totDist currDist]);
            if minidx == 2
                minSeq = PertSeq;
            end
        end
        
        % Now perturb optimal sequence to obtain new candidate sequences.
        generatedSequence = cell(numberSequences,1);
        generatedSequence(:) ={minSeq};
        Pert = poissrnd(minLen/5,1,numberSequences);% Poissonian random number.
        
        for iSeq = 1:numberSequences
            idxShuffle = randperm(minLen);
            generatedSequence{iSeq}(idxShuffle(1:Pert(iSeq))) = W{1}(ceil(rand(1,Pert(iSeq))*4));
        end
        
    case 'random' % This mode draws random numbers from the underlying distribution in original aptamere sequences
        
        cmW = cumsum(W{2});
        cmW = cmW./cmW(end,:);
        maxLen = max(cellfun(@length,apt.sequence));
        minLen = min(cellfun(@length,apt.sequence));
        
        lengths = floor((maxLen-minLen).*rand(numberSequences,1) + minLen);
        
        generatedSequence = cell(numberSequences,1);
        for iSeq = 1:numberSequences
            for iPos = 1:lengths(iSeq)
                rN = rand(1);
                for iBase = 1:length(W{1})
                    if rN<cmW(iBase,iPos)
                        rBase = W{1}(iBase);
                        break
                    end
                end
                generatedSequence{iSeq}(iPos) = rBase;
            end
        end
end
apt.generatedSequence = generatedSequence;
end

