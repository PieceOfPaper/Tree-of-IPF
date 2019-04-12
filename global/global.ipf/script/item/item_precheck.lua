
function SCR_PRECHECK_CONSUME_ZOMBIECAPSUL(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    if mapCls.MapType == 'City' and mapCls.ClassName ~= 'pvp_Mine' then
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

function SCR_PRECHECK_CONSUME_Steam_Popo_Point(self, strArg, argnum1, arg2, itemClassID)
    if ENABLE_USE_PCBANG_POINT_SHOP_EVERYBODY ~= 1 then -- 열려 있지 않으면 return -- -- 현재 포포샵이 열려 있는지 (1이면 열림 0이면 닫힘) --
        SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("EVENT_STEAM_POPOSHOP_POINT_RETURN_1"), 5) -- 포포샵 이벤트 기간 중에만 사용 가능합니다. --
        return 0
    end
    RunScript('SCR_USE_Event_Steam_Popo_Point', self, strArg, argnum1, arg2, itemClassID)
end