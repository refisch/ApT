function [predX,predNames] = aptIncludeSimplifiedSequence
%aptIncludeSimplifiedSequence will alter the predictor's matrix and names
%vector in such a way, that seq1, seq2, seq1_mutated, seq2_mutated are
%added
% SimplifiedSequence is logical. If used, a set of parent-sequences is used
% to compare against.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

% specify paternal sequences
ref.seq{1} = 'AGTCCGTGGTAGGGCAGGTTGGGGTGACT';
ref.name{1} = 'b6';
ref.seq{2} = 'GGTTGGTGTGGTTGG';
ref.name{2} = 'a13';

global apt

if ~isfield(apt.pred,'SimplifiedSequence') || apt.pred.SimplifiedSequence == false
    return
end

predX_simple = zeros(length(apt.sequence),2*length(ref.seq));
for iseq = 1:length(apt.sequence)
    idxref = find(strcmp(ref.seq,apt.sequence{iseq}));
    if ~isempty(idxref)
        predX_simple(iseq,2*idxref-1) = 1;
    else
        for iref = 1:length(ref.seq)
            nwscore(iref) = nwalign(ref.seq{iref},apt.sequence{iseq},'ALPHABET','NT');
        end
        [~,idxmax] = max(nwscore);
        predX_simple(iseq,2*idxmax) = 1;
    end
end

predNames_simple = {};
for j = 1:(2*length(ref.name))
    if mod(j,2) == 1
        predNames_simple{j} = ref.name{(j+1)/2};
    else
        predNames_simple{j} = [ref.name{j/2} '_mutated'];
    end
end

apt.predNames = [apt.predNames, predNames_simple];
apt.predX = [apt.predX; predX_simple'];
end