--solo_dungeon_lib.lua

function GET_SOLO_DUNGEON_ATTENDANCE_REWARD_LIST(stage)
    local rewardCnt = stage * 2
    return { {"Vernike_Drug_HPSP", rewardCnt} } ; --memo solo_dungeon
end

function GET_SOLO_DUNGEON_RANKING_REWARD_NAME(myPrevRanking, prevYear, prevWeekNumber)
    if prevYear == 2018 and prevWeekNumber == 23 then
        return "First_Grade_Buff_Stone";
    end

    if myPrevRanking ~= nil and myPrevRanking ~= 0 then
        if myPrevRanking >= 1 and myPrevRanking <= SOLO_DUNGEON_MAX_RANK then
            return "First_Grade_Buff_Stone"; --memo solo_dungeon
        end
    end
    return nil;
end

function GIVE_SOLO_DUNGEON_REWARD(pc, prevYear, prevWeekNumber)    
    local accObj = GetAccountObj(pc);
    if accObj == nil then
        return;
    end

    if prevYear == 0 or prevWeekNumber == 0 then
        SendSysMsg(pc, "SoloDungeonRewardAlready");
        return;
    end

    if accObj.SOLO_DUNGEON_YEAR == prevYear and accObj.SOLO_DUNGEON_WEEK_NUMBER == prevWeekNumber then
        SendSysMsg(pc, "SoloDungeonRewardAlready");
        return;
    end

    local myPrevRanking = GetSoloDungeonPrevRankForReward(pc);
    if myPrevRanking == nil then
        SendSysMsg(pc, "SoloDungeonRewardError");
        return;
    end
    
    local myPrevScore, myPrevStage, myPrevKillCount = GetPrevSoloDungeonInfo(pc, "All");
    myPrevScore, myPrevStage = GetSoloDungeonPrevScoreForReward(pc);

    local attendanceRewardList = GET_SOLO_DUNGEON_ATTENDANCE_REWARD_LIST(myPrevStage);
    local rankingRewardName = GET_SOLO_DUNGEON_RANKING_REWARD_NAME(myPrevRanking, prevYear, prevWeekNumber);

    if myPrevStage <= 0 then
        SendSysMsg(pc, "SoloDungeonRewardNone");
        return;
    end

    if attendanceRewardList == nil or #attendanceRewardList <= 0 then
        if rankingRewardName == nil then
            SendSysMsg(pc, "SoloDungeonRewardNone");
            return;
        end
    end

    local tx = TxBegin(pc);
    TxSetIESProp(tx, accObj, "SOLO_DUNGEON_YEAR", prevYear);
    TxSetIESProp(tx, accObj, "SOLO_DUNGEON_WEEK_NUMBER", prevWeekNumber);

    if attendanceRewardList ~= nil then
        for i = 1, #attendanceRewardList do
            local rewardPair = attendanceRewardList[i];
            local rewardName = rewardPair[1];
            local rewardCount = rewardPair[2];
            TxGiveItem(tx, rewardName, rewardCount, "SoloDungeon_StageReward");
        end
    end
    
    local rankingRewardCnt = 1;
    if rankingRewardName ~= nil then
        TxGiveItem(tx, rankingRewardName, rankingRewardCnt, "SoloDungeon_RankingReward");
    end

    local ret = TxCommit(tx);
    if ret == "SUCCESS" then

        if attendanceRewardList ~= nil and #attendanceRewardList > 0 then
            local rewardNameList = {};
            local rewardCntList = {};
            for i = 1, #attendanceRewardList do
                local rewardPair = attendanceRewardList[i];
                rewardNameList[#rewardNameList + 1] = rewardPair[1];
                rewardCntList[#rewardCntList + 1] = rewardPair[2];
            end
            SoloDungeonRewardMongoLog(pc, prevYear, prevWeekNumber, "StageReward", myPrevStage, myPrevKillCount, myPrevScore, rewardNameList, rewardCntList);
        end
        SoloDungeonRewardMongoLog(pc, prevYear, prevWeekNumber, "RankingReward", myPrevStage, myPrevKillCount, myPrevScore, {rankingRewardName}, {rankingRewardCnt});

        SendSysMsg(pc, "SoloDungeonRewardGive");
    end
end