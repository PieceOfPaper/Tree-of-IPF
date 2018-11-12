-- lib_rankreset.lua

function IS_RANKRESET_ITEM(itemClassName)
    if  itemClassName == 'Premium_RankReset' or itemClassName == '1706Event_RankReset' or itemClassName == 'Premium_RankReset_14d' or itemClassName == 'Premium_RankReset_60d' or itemClassName == 'Premium_RankReset_1d' or itemClassName == 'Premium_RankReset_30d' then
       return 1; 
    end
    return 0;
end

function IS_RANKROLLBACK_ITEM(itemClassName)
    if  itemClassName == 'Premium_RankRollback' then
       return 1; 
    end
    return 0;
end

function GET_MAX_WEEKLY_CLASS_RESET_POINT_EXP()
    return 1000;
end

function GET_MAX_CLASS_RESET_POINT_EXP()
    return 3000;
end

function SCR_RANK_ROLLBACK_PRECHECK_Elementalist(pc)    
    -- 테스트용. 엘리멘탈리스트는 음양사 전직 조건이기 때문에, 음양사가 트리에 있으면 초기화 못하게 함
    local onmyojiCls = GetClass('Job', 'Char2_20');
    local elementalistCls = GetClass('Job', 'Char2_11');
    local jobList = GetJobHistoryList(pc);
    for i = 1, #jobList do
        if jobList[i] == onmyojiCls.ClassID then
            if IsServerObj(pc) == 1 then
                SendSysMsg(pc, 'ClassResetFailOtherClass', 0, 'TARGET', elementalistCls.Name, 'JOB', onmyojiCls.Name);
            end
            return false;
        end
    end
    return true;
end