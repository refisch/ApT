function aptIncludeSymmetry
%APTINCLUDESYMMETRY Summary of this function goes here
%   Detailed explanation goes here

global apt

if ~isfield(apt.pred,'symmetry') || (~apt.pred.symmetry)
    return
end

swScore = zeros(size(apt.sequence));
nwScore = zeros(size(apt.sequence));

for iseq = 1:length(apt.sequence)
    swScoreTmp = zeros(size(apt.sequence{iseq}));
    nwScoreTmp = zeros(size(apt.sequence{iseq}));
    for ilen = 2:(length(apt.sequence{iseq})-2)
        C = mat2cell(apt.sequence{iseq},1,[ilen,length(apt.sequence{iseq})-ilen]);
        C{2} = reverse(C{2});
        antiSeq = strrep(strrep(strrep(strrep(strrep(strrep(C{1},'T','Z'),'A','T'),'Z','A'),'G','B'),'C','G'),'B','C');
        swScoreTmp(ilen) = swalign(antiSeq(1:end-1),C{2}(1:end-1),'ALPHABET','NT');
        nwScoreTmp(ilen) = nwalign(antiSeq(1:end-1),C{2}(1:end-1),'ALPHABET','NT');
    end
    swScore(iseq) = max(swScoreTmp);
    nwScore(iseq) = max(nwScoreTmp);
end

apt.predNames{end+1} = 'SymmetryScoreSW';
apt.predNames{end+1} = 'SymmetryScoreNW';

apt.predX = [apt.predX; swScore; nwScore];

end

