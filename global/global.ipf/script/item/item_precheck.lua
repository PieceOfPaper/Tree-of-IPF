function SCR_PRECHECK_CONSUME_SUMMONORB(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    
    if mapCls.MapType == 'City' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NotAllowedInTown"), 3);
        return 0;
    end
    
    if mapCls.ClassName == 'c_firemage_event' then -- steam event
        return 0;
    end
    
    if IsJoinColonyWarMap(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ThisLocalUseNot"), 3);
        return 0;
    end
    
    return 1;
end

function SCR_PRECHECK_CONSUME_ZOMBIECAPSUL(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    if mapCls.MapType == 'City' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NotAllowedInTown"), 3);
        return 0;
    end
    
    if mapCls.ClassName == 'c_firemage_event' or mapCls.ClassName == 'id_catacomb_04_event' then -- steam event
        return 0;
    end
    
    local skl = GetSkill(self, "Bokor_Zombify");
    if skl == nil then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NoHaveZombiefySkill"), 3);
        return 0;
    end
    
    local list, cnt = GetZombieSummonList(self)
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(self, skl.Level);
    if cnt >= maxZombieCount then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsMaxCountZombie"), 3);
        return 0;
    end
    
    return 1;
end

function SCR_PRE_CS_IndunReset_Mission10(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_500 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_Mission10_MSG2"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end

function SCR_PRE_CS_IndunReset_M_Past_FantasyLibrary_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_800 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_M_Past_FantasyLibrary_1_MSG2"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end

function SCR_PRECHECK_HALOWEEN_2017_ACHIEVE1(self)
    if OnKnockDown(self) == 'NO' then
        local achieve_Point = GetAchievePoint(self, "2017_Halloween2_AP");
        if achieve_Point == 0 then
            return 1;
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("AGARIO_ACHIEVE"), 5)
            return 0;
        end
    end
    return 0;
end

function SCR_PRECHECK_HALOWEEN_2017_ACHIEVE2(self)
    if OnKnockDown(self) == 'NO' then
        local achieve_Point = GetAchievePoint(self, "2017_Halloween1_AP");
        if achieve_Point == 0 then
            return 1;
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("AGARIO_ACHIEVE"), 5)
            return 0;
        end
    end
    return 0;
end

function SCR_PRE_CS_IndunReset_GTower_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_400 > 0 or pcetc.IndunWeeklyEnteredCount_400 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG2"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end