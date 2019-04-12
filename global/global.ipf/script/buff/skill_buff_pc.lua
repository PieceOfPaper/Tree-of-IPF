-- error reward
function SCR_BUFF_ENTER_TeamBattle_GoldRanker_Error(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TeamBattle_GoldRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
    return 1;
end

function SCR_BUFF_LEAVE_TeamBattle_GoldRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
end

function SCR_BUFF_ENTER_TeamBattle_SilverRanker_Error(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TeamBattle_SilverRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
    return 1;
end

function SCR_BUFF_LEAVE_TeamBattle_SilverRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
end

function SCR_BUFF_ENTER_TeamBattle_BronzeRanker_Error(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TeamBattle_BronzeRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
    return 1;
end

function SCR_BUFF_LEAVE_TeamBattle_BronzeRanker_Error(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("_REMOVE_WORLDPVP_REWARD_ACHIEVE", self);
    end
end