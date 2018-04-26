function aptGenerateValiSequence
%APTGENERATESEQUENCE generates numberSequences new sequences mimicking the
%input sequences given.
%   mode of generating new sequences is stored in apt.modeToGenerateNewSequences
%   'numberSequences' is amount of new sequences generated

global apt

if ~isfield(apt,'sequence')
    error('this function requires some input sequences that will be mimicked.')
end

if ~isfield(apt.vali,'mode')
    apt.vali.mode = 'random';
elseif ~(strcmp(apt.vali.mode,'random') || strcmp(apt.vali.mode,'mutated') || strcmp(apt.vali.mode,'best_seq'))
    error('I do not know this mode of creating new sequences.')
end

% For this task only use 95% of longest sequences thus having longer test
% sequences with almost same amount of information.

lowerBound = floor(quantile(cellfun(@length,apt.sequence),0.05));
apt.vali.sequence95pc = apt.sequence(cellfun(@length,apt.sequence)>lowerBound);

[W,figh] = seqlogo(apt.vali.sequence95pc);
close(figh)

switch apt.vali.mode
    case 'mutated' % This mode first looks for most prominent sequence and than mutates randomly some positions only
        
        % Start with mean Sequence
        minLen = min(cellfun(@length,apt.vali.sequence95pc));
        minSeq = char(zeros(1,minLen));
        for iPos = 1:minLen
            [~,idxmax] = max(W{2}(:,iPos));
            minSeq(iPos) = W{1}(idxmax);
        end
        totDist = aptCalcStringDistance(minSeq,apt.vali.sequence95pc);
        
        % Aim: Find sequence that minimizes distance to other sequences by random perturbations.
        for iPerm = 1:5000 % 10000 perturbations = 20s
            PertSeq = minSeq;
            PertSeq(ceil(rand(1)*minLen)) = W{1}(ceil(rand(1)*4));
            currDist = aptCalcStringDistance(PertSeq,apt.vali.sequence95pc);
            [totDist, minidx] = min([totDist currDist]);
            if minidx == 2
                minSeq = PertSeq;
            end
        end
        
        % Now perturb optimal sequence to obtain new candidate sequences.
        generatedSequence = cell(1,apt.vali.number);
        generatedSequence(:) ={minSeq};
        Pert = poissrnd(minLen/5,1,apt.vali.number);% Poissonian random numbers.
        
        for iSeq = 1:apt.vali.number
            idxShuffle = randperm(minLen);
            generatedSequence{iSeq}(idxShuffle(1:Pert(iSeq))) = W{1}(ceil(rand(1,Pert(iSeq))*4));
        end
        
    case 'random' % This mode draws random numbers from the underlying distribution in original aptamere sequences
        
        cmW = cumsum(W{2});
        cmW = cmW./cmW(end,:);
        maxLen = max(cellfun(@length,apt.sequence));
        minLen = min(cellfun(@length,apt.sequence));
        
        lengths = floor((maxLen-minLen).*rand(apt.vali.number,1) + minLen);
        
        generatedSequence = cell(1,apt.vali.number);
        for iSeq = 1:apt.vali.number
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
        
        case 'best_seq' % This mode randomly alters best performing sequences
            nMax = 10; % number of best performer for each observable
            generatedSequence = cell(1,apt.vali.number);
            numIter = floor(apt.vali.number /(nMax * length(apt.Y)));
            iterCounter = 0;
            for ivar = 1:length(apt.Y)
                [~,idxMax] = maxk(apt.Yfit1SE{ivar},nMax);
                for iSeq = 1:length(idxMax)
                    posSeq = ((numIter*(iterCounter)):(numIter*(iterCounter+1)))+1;
                    for iPos = 1:length(posSeq)
                        generatedSequence{posSeq(iPos)} = apt.sequence{idxMax(iSeq)};
                    end
                    iterCounter = iterCounter+1;
                end
            end
        
        for iSeq = 1:apt.vali.number
            Pert = poissrnd(length(generatedSequence{iSeq})/5,1,1);% Poissonian random number. - number of alterations
            idxShuffle = randperm(length(generatedSequence{iSeq}));
            generatedSequence{iSeq}(idxShuffle(1:Pert)) = W{1}(ceil(rand(1,Pert)*4)); % completely random AGCT
        end
        idxEmpty = cellfun(@isempty,generatedSequence);
        generatedSequence = generatedSequence(~idxEmpty);
end
apt.vali.generatedSequence = generatedSequence;
end

