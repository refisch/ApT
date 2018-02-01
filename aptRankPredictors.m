function aptRankPredictors
% Rank analysis for multiple response variables.

global apt

totRank = zeros(size(apt.stats(1).beta(:,1)));
for iY = 1:length(apt.Y)
    absBetas = abs(apt.stats(iY).beta(:,apt.stats(iY).Index1SE));
    [~,rank{iY}]  = ismember(absBetas,flip(unique(absBetas)));
    rank{iY}(rank{iY} == max(rank{iY})) = floor(mean([length(totRank),length(totRank)-sum(absBetas == 0)]));
    totRank = totRank + rank{iY};
end
[RankScore,idxTotSort] = sort(totRank,'ascend');

apt.rank.predNamesRanked = apt.predNames(idxTotSort);
apt.rank.RankScores = RankScore;
apt.rank.ranks = rank;

fID = fopen('Results.txt','a+');
fprintf(fID,'\n Top 10 predictors for all the above observables:\n');
idx = 1:10;
for i = idx
    fprintf(fID, 'Predictor\t %s \t with cumulative rank \t %d \n', apt.rank.predNamesRanked{i},RankScore(i));
end

end

