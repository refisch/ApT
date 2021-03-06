function aptRankPredictors
% Rank analysis for multiple response variables.

global apt

if isfield(apt,'rankstats')
    rankstats = apt.rankstats;
else
    if apt.config.doZscoreData && apt.config.doZscoreModel
        rankstats = apt.stats;
    else
        fID = fopen('Results.txt','a+');
        fprintf(fID,'\n No ranking of predictors as no zscore calculation was done \n');
        return
    end
end

totRank = zeros(size(rankstats(1).beta(:,1)));
isNegativeAll = true(size(rankstats(1).beta(:,1)));
for iY = 1:length(apt.Y)
    absBetas = abs(rankstats(iY).beta(:,rankstats(iY).Index1SE));
    isNegativeAll = isNegativeAll & rankstats(iY).beta(:,rankstats(iY).Index1SE)<0;
    [~,rank{iY}]  = ismember(absBetas,flip(unique(absBetas)));
    rank{iY}(rank{iY} == max(rank{iY})) = floor(mean([length(totRank),length(totRank)-sum(absBetas == 0)]));
    totRank = totRank + rank{iY};
end
[RankScore,idxTotSort] = sort(totRank,'ascend');

apt.rank.isNegative = isNegativeAll(idxTotSort);
apt.rank.predNamesRanked = apt.predNames(idxTotSort);
apt.rank.RankScores = RankScore;
apt.rank.ranks = rank;

effectSign = cell(size(apt.rank.isNegative));
effectSign(apt.rank.isNegative) = {'-'};
effectSign(~apt.rank.isNegative) = {'+'};

fID = fopen('Results.txt','a+');
fprintf(fID,'\n Top 10 predictors for all the above observables:\n');
idx = 1:10;
for i = idx
    fprintf(fID, 'Predictor\t %s \t with cumulative rank \t %d  (%s) \n', apt.rank.predNamesRanked{i},RankScore(i),effectSign{i});
end

end

