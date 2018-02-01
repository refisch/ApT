function aptIncludeSymmetry
%APTINCLUDESYMMETRY Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~isfield(apt.pred,'symmetry') || (~apt.pred.symmetry)
    return
end

swScore = zeros(size(apt.sequence));
antiSwScore = zeros(size(apt.sequence));
nwScore = zeros(size(apt.sequence));
antiNwScore = zeros(size(apt.sequence));

for iseq = 1:length(apt.sequence)
    swScoreTmp = zeros(size(apt.sequence{iseq}));
    antiswScoreTmp = zeros(size(apt.sequence{iseq}));
    nwScoreTmp = zeros(size(apt.sequence{iseq}));
    antinwScoreTmp = zeros(size(apt.sequence{iseq}));
    for ilen = 1:(length(apt.sequence{iseq})-1)
        C = mat2cell(apt.sequence{iseq},1,[ilen,length(apt.sequence{iseq})-ilen]);
        antiSeq = strrep(strrep(strrep(strrep(strrep(strrep(C{1},'T','Z'),'A','T'),'Z','A'),'G','B'),'C','G'),'B','C');
        swScoreTmp(ilen) = swalign(C{1},C{2});
        antiswScoreTmp(ilen) = swalign(antiSeq,C{2});
        nwScoreTmp(ilen) = nwalign(C{1},C{2});
        antinwScoreTmp(ilen) = nwalign(antiSeq,C{2});
    end
    swScore(iseq) = max(swScoreTmp);
    antiSwScore(iseq) = max(antiswScoreTmp);
    nwScore(iseq) = max(nwScoreTmp);
    antiNwScore(iseq) = max(antinwScoreTmp);
end

apt.predNames{end+1} = 'SymmetryScoreSW';
apt.predNames{end+1} = 'AntiSymmetryScoreSW';
apt.predNames{end+1} = 'SymmetryScoreNW';
apt.predNames{end+1} = 'AntiSymmetryScoreNW';

apt.predX = [apt.predX; swScore; antiSwScore; nwScore; antiNwScore];

end

