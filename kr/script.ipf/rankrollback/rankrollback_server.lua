--rank_rollback.lua


function RANK_ROLLBACK_PRECHECK(pc)
    local lastJobID = GetLastJobID(pc);  
    local commonCls = GetClass("Rank_Rollback", "Common");
    if commonCls == nil then
        IMC_LOG('ERROR_RANK_RESET', 'RANK_ROLLBACK_PRECHECK: Rank_Rollback Comon Class not exist');
        return false;
    end
    
    if commonCls.PreCheckScp ~= "None" then
        local commonScp = _G[commonCls.PreCheckScp];    
        local ret = commonScp(pc);
        if ret ~= true then
            IMC_LOG('ERROR_RANK_RESET', 'RANK_ROLLBACK_PRECHECK: precheck scp fail- scp['..commonCls.PreCheckScp..']');
            return false;
        end
    end

    local jobCls = GetClassByType("Job", lastJobID);
    local lastJobCls = GetClass("Rank_Rollback", jobCls.ClassName);
    if lastJobCls ~= nil then
        if lastJobCls.PreCheckScp ~= "None" then
            local jobPreScp = _G[lastJobCls.PreCheckScp];    
            local ret = jobPreScp(pc);
            if ret ~= true then
                IMC_LOG('ERROR_RANK_RESET', 'RANK_ROLLBACK_PRECHECK: job precheck scp fail- scp['..lastJobCls.PreCheckScp..']');
                return false;
            end
        end
    end

    return true;
end

function SCR_RANK_ROLLBACK_PRECHECK_COMMON(pc)
    --월드에서만 사용가능
    if IsIndun(pc) == 1 or IsPVPServer(pc) == 1 then
        --사용할 수 없는 지역        
        SendSysMsg(pc, 'PopUpBook_MSG3');
        return false;
    end
    --마을에서만 사용 가능
    local curMap = GetZoneName(pc);
    local mapCls = GetClass("Map", curMap);
    if mapCls.MapType ~= 'City' then
        SendSysMsg(pc, 'AllowedInTown');
        return false;
    end
    --파티에 가입하지 않은 상태에서만 가능
    local partyObj = GetPartyObj(pc)
    if partyObj ~= nil then
        SendSysMsg(pc, 'CannotUseInParty');
        return false;
    end
    --전투 상태에서 롤백 불가
    if IsBattleState(pc) == 1 then
        SendSysMsg(pc, 'CanNotBattleState');
        return false;
    end
    --친선대결 도중 롤백 불가
    if IsMyPCFriendlyFighting(pc) == 1 then
        SendSysMsg(pc, 'Card_Summon_check_PVP');
        return false;
    end

    --자동매칭중 불가
    if IsAutoMatchingState(pc) == 1 then
        SendSysMsg(pc, 'CannotUseForAutoMatching');
        return false;
    end

    --카드대전 도중 롤백 불가
    --카드대전인지 알 수 없음

    --상점 개설중인 PC 불가
    if IsAutoSellerState(pc) == 1 then
        SendSysMsg(pc, 'StateOpenAutoSeller');
        return false;
    end

    --컴패니언 동행 상태
    if GetSummonedPet(pc) ~= nil then
        SendSysMsg(pc, 'HaveToPutPetAtBarrack');        
        return false;
    end

    --장비 전부 착용 해제 후 롤백 가능
    if IsItemEquipState(pc) == 1 then        
        return false;
    end

    --변신중일 때 불가
    if IsTransformState(pc) == 1 then
        SendSysMsg(pc, 'TransfromState');
        return false;
    end
    
    --타임 액션중에 불가(제작등..)
    if IsTimeActionState(pc) == 1 then
        SendSysMsg(pc, 'CannotInCurrentState');
        return false;
    end

    --배우고 있는 도중인 특성이 있으면 롤백 불가
    if IsLearnAbilityState(pc) == 1 then
        SendSysMsg(pc, 'YouareLearningAbil');
        return false;
    end

    --제작 도중 사용 불가

    --착용중인 보스카드 (카드슬롯)은 (구)랭초와는 다르게 돌려주지 않고 유지

    --랭크 제한 있는 특성들은 전체 검사해서 내려간 랭크에서 배울 수 없는 상태인 경우 삭제 후 포인트 환원

    --롤백된 클래스의 스킬은 전부 초기화
    --롤백된 클래스의 특성은 전부 특성 포인트로 환원
    return true;
end


function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Squire(pc, tx)
    RemoveCamp(pc)
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Bokor(pc, tx)
    local pcetc = GetETCObject(pc)
    for i = 1, BOKOR_MAX_ZOMBIE_COUNT do
        local monID = etcObj['ZombiebyMonID_'..i];
        if monID ~= 0 then
            TxSetIESProp(tx, pcetc, "ZombiebyMonID_"..i, 0);
            TxSetIESProp(tx, pcetc, "ZombiebyMonLv_"..i, 0);
            TxSetIESProp(tx, pcetc, "ZombiebyMonType_"..i, 0);
        end
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Druid(pc, tx)
    local pcetc = GetETCObject(pc)
    if pcetc.Druid_Transform_MonID ~= 0 then
        TxSetIESProp(tx, pcetc, "Druid_Transform_MonID", 0);
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Wugushi(pc, tx)
    local pcetc = GetETCObject(pc)
    if pcetc.Wugushi_PoisonAmount ~= 0 then
        TxSetIESProp(tx, pcetc, "Wugushi_PoisonAmount", 0);
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Alchemist(pc, tx)
    local pcetc = GetETCObject(pc)
    if pcetc.alchemist_Homunculus ~= "None" then
        TxSetIESProp(tx, pcetc, "alchemist_Homunculus", "None");
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Sorcerer(pc, tx)
    local pcetc = GetETCObject(pc)
    for i = 1, 2 do
        local propName1 = "Sorcerer_bosscardName"..i;
        if pcetc[propName1] ~= "None" then
            TxSetIESProp(tx, pcetc, propName1, "None");
        end

        local propName2 = "Sorcerer_bosscardGUID"..i;
        if pcetc[propName1] ~= "None" then
            TxSetIESProp(tx, pcetc, propName1, "None");
        end

        local propName3 = "Sorcerer_bosscard"..i;
        if pcetc[propName1] ~= 0 then
            TxSetIESProp(tx, pcetc, propName1, 0);
        end
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Necromancer(pc, tx)
    --보스 카드
    local pcetc = GetETCObject(pc)
    if pcetc.Necro_bosscardName ~= "None" then
        TxSetIESProp(tx, pcetc, "Necro_bosscardName", "None");
    end
    for i = 1, 4 do
        local propName1 = "Necro_bosscard"..i;
        if pcetc[propName1] ~= "None" then
            TxSetIESProp(tx, pcetc, propName1, "None");
        end
        local propName2 = "Necro_bosscardGUID"..i;
        if pcetc[propName2] ~= "None" then
            TxSetIESProp(tx, pcetc, propName2, "None");
        end

    end

    --데드 파츠
    if pcetc.Necro_DeadPartsCnt ~= 0 then
        TxSetIESProp(tx, pcetc, "Necro_DeadPartsCnt", 0);
    end

    for i = 1, 1000 do
        local name = "NecroDParts_"..i;
        if pcetc[name] ~= 0 then
            TxSetIESProp(tx, pcetc, name, 0);
        end
    end
end

function SCR_RANK_ROLLBACK_ROLLBACK_EXEC_Sage(pc, tx)
    local pcetc = GetETCObject(pc)
    local maxCount = SAGE_PORTAL_BASE_CNT;
    local abil = GetAbility(pc, "Sage1")
    if abil ~= nil then
        maxCount = maxCount + abil.Level;
    end

    for i = 1, maxCount do
        local propName = "Sage_Portal_"..i;
        if pcetc[propName] ~= "None" then
            TxSetIESProp(tx, pcetc, propName, "None");
        end
    end
end

function TEST_RESET_LAST_ROLLBACK_INDEX(pc) -- 이전에 랭크 롤백한 데이타 지우는 용도
    local tx = TxBegin(pc);
    if tx == nil then
        print('tx is nil');
    end

    TxSetIESProp(tx, pc, 'LastRankRollbackIndex', 0);
    local ret = TxCommit(tx);

    Chat(pc, 'Reset LastRollBackIndex End: ret['..ret..']');
end