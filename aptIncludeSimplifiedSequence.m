function [predX,predNames] = aptIncludeSimplifiedSequence
%aptIncludeSimplifiedSequence will alter the predictor's matrix and names
%vector in such a way, that seq1, seq2, seq1_mutated, seq2_mutated are
%added
% SimplifiedSequence is logical. If used, a set of parent-sequences is used
% to compare against.
% sequence is cell array of analysed sequences.
% predX is predictor matrix X
% predNames is cell array of predictor names

global apt

if ~isfield(apt.pred,'SimplifiedSequence') || apt.pred.SimplifiedSequence == false
    return
end

if ~isfield(apt.config,'knownSequences') % specify paternal sequences
    warning('You try to use prior information about sequences! I do not have this kind of information. Please specify the field apt.config.knownSequences!! ')
    return
elseif length(apt.config.knownSequences) ~= 2 
    error('This currently only works for EXACTLY two paternal sequences!')
end


allRefSequences = {apt.config.knownSequences{1},apt.config.knownSequences{2},...
    [apt.config.knownSequences{1},apt.config.knownSequences{2}],[apt.config.knownSequences{2},apt.config.knownSequences{1}]};
predNames_simple = {apt.config.knownSequencesNames{1},apt.config.knownSequencesNames{2},...
    [apt.config.knownSequencesNames{1},apt.config.knownSequencesNames{2}],[apt.config.knownSequencesNames{2},apt.config.knownSequencesNames{1}]};
idxa13 = find(~cellfun(@isempty,strfind(apt.config.knownSequences,'GGTTGGTGTGGTTGG')));
if ~isempty(idxa13)
    allRefSequences{end+1} = [apt.config.knownSequences{idxa13},strrep(strrep(apt.config.knownSequences{idxa13},'G','C'),'T','A')];
    predNames_simple{end+1} = 'a13_mirrored';
    allRefSequences{end+1} = [apt.config.knownSequences{idxa13},'AGTCCGTGGTAGG'];
    predNames_simple{end+1} = 'a13_b6half';
end

% 5 VergleichsSequenzen, 7 Kategorien (durch *_mutated)

predX_simple = zeros(length(apt.sequence),length(allRefSequences)+length(apt.config.knownSequences));

for iseq = 1:length(apt.sequence)
    for iref = 1:length(allRefSequences)
        nwscore(iref) = nwalign(allRefSequences{iref},apt.sequence{iseq},'ALPHABET','NT');
    end
    [~,idxmax] = max(nwscore);
    if idxmax <= length(apt.config.knownSequences)
        if isempty(find(strcmp(apt.config.knownSequences,apt.sequence{iseq})))
            idxmax = idxmax + length(predNames_simple);
        end
    end
    predX_simple(iseq,idxmax) = 1;
end

predNames_simple{end+1} = [apt.config.knownSequencesNames{1} '_mutated'];
predNames_simple{end+1} = [apt.config.knownSequencesNames{2} '_mutated'];
apt.predNames = [apt.predNames, predNames_simple];
apt.predX = [apt.predX; predX_simple'];
end