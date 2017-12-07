function generatedSequence = aptGenerateSequence(sequence,numberSequences,mode)
%APTGENERATESEQUENCE generates numberSequences new sequences mimicking the
%input sequences given.
%   'sequence'  is cell array of template sequences
%   'numberSequences' is amount of new sequences generated
%   'mode'      is the a string describing the way of generating new sequences. choice between 'random'
%               and 'mutated'

if(~exist('sequence','var') || isempty(sequence))
    error('this function requires some input sequences that will be mimicked.')
end

if(~exist('numberSequences','var') || isempty(numberSequences))
    numberSequences = 100;
end

if(~exist('mode','var') || isempty(mode))
    mode = 'random';
end

switch mode
    case 'mutated'
        
    case 'random'
        [W,figh] = seqlogo(sequence);
        close(figh)
        
        cmW = cumsum(W{2});
        cmW = cmW./cmW(end,:);
        maxLen = max(cellfun(@length,sequence));
        minLen = min(cellfun(@length,sequence));
        
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

end

