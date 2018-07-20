---- hardskill_oracle.lua

function TGT_SUMMON_TO_POS(self, skl, x, y, z, randomRange, eft, eftScale, summonSec, addCount)

    local tgtList = GetHardSkillTargetList(self);
    
    if #tgtList < 1 + skl.Level * 2 then
        SendSysMsg(self, "MonsterFightAlready");
    end
    
    for i = 1 , #tgtList do
        local tgt = tgtList[i];
        local rx, ry, rz = GetRandomPos(self, x, y, z, randomRange);
        RunScript("_TGT_SUMMON_TO_POS", self, tgt, rx, ry, rz, eft, eftScale, summonSec);
    end
    
    if addCount < 1 then
        return ;
    else
        for i = 1 , addCount do
            local rx, ry, rz = GetRandomPos(self, x, y, z, randomRange);
            RunScript("TGT_SUMMON_PASTE", self, tgtList[IMCRandom(1, #tgtList)], rx, ry, rz, eft, eftScale, summonSec);
        end
    end
end

function _TGT_SUMMON_TO_POS(self, obj, rx, ry, rz, eft, eftScale, summonSec)
    local x, y, z = GetPos(obj);
    PlayEffectToGround(self, eft, rx, ry, rz, eftScale);
    PlayEffectToGround(obj, eft, x, y, z, eftScale);
    
    local sleepCount = summonSec * 10;
    HoldMonScp(obj);
    StopMove(obj);
    for i = 1 , sleepCount do
        sleep(100);

        if GetLastAttacker(obj) ~= nil then
            UnHoldMonScp(obj);
            return;
        end
    end

    UnHoldMonScp(obj);

    SetPos(obj, rx, ry, rz);
    MON_CREATEPOS_RESET(obj);

    local Oracle2_abil = GetAbility(self, "Oracle2");
    if Oracle2_abil == nil then 
        InsertHate(obj, self, 1);
    end
end

function TGT_SUMMON_PASTE(self, obj, rx, ry, rz, eft, eftScale, summonSec)

    PlayEffectToGround(self, eft, rx, ry, rz, eftScale);
    
    sleep(summonSec*1000)
    if obj ~= nil then
        local mon = CREATE_MONSTER_EX(self, obj.ClassName, rx, ry, rz, GetDirectionByAngle(obj), GetCurrentFaction(obj), obj.Lv);
        
        local Oracle2_abil = GetAbility(self, "Oracle2");
        if Oracle2_abil == nil then
            InsertHate(mon, self, 1);
        end
    end
end



function TGT_SHOW_DROP_ITEM(self, obj)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local tgt = tgtList[i];

        if tgt.MonRank ~= 'Boss' then
            ClearItemBalloon(tgt);
            if GetExProp(tgt, "DROP_CREATED") == 0 then
                PRECREATE_DROP_LIST(tgt, self, 0);
            end

            local count = GetExProp(tgt, "PRE_ITEM_COUNT");
            if count == 0 then
                ShowItemBalloon(tgt, "{@st43}", "Item", "", nil, 10, 0, "reward_itembox");
            else
                for i = 1 , count do
                    local clsName = GetExProp_Str(tgt, "PRE_ITEM_" .. i .. "_NAME");
                    if string.find(clsName, "Moneybag") ~= nil then
                        clsName = "Vis";
                    end
                    local itemObj = GetClass("Item", clsName);              
                    ShowItemBalloon(tgt, "{@st43}", "Item", "", itemObj, 10, 0, "reward_itembox");
                end
            end

            SetExProp(tgt, 'SHOW_DROP_ITEM_BALLOON', imcTime.GetAppTime());
        else
            SendSysMsg(self, "NotEnoughTarget");
        end
    end
end

function TGT_CHANGE_DROP_ITEM(self, obj)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local tgt = tgtList[i];
        if tgt.MonRank ~= 'Boss' then       
            PRECREATE_DROP_LIST(tgt, self, 1);

            -- 드랍템 미리 보는 중이였으면 변경된 리스트로 다시 보여주기
            local showItemTime = GetExProp(tgt, 'SHOW_DROP_ITEM_BALLOON');
            if showItemTime + 10 > imcTime.GetAppTime() then
                TGT_SHOW_DROP_ITEM(self, obj);
            end
        else
            SendSysMsg(self, "NotEnoughTarget");
        end
    end
end

-- 오라클 체인지 스킬로 변경할 몬스터리스트 랜덤 돌리는 부분
function GET_ORACLE_CHANGE_MON_LIST(self, obj)

    local monID = GetOracleRandomMonID(self);
    if monID == 0 then
        return 'None';
    end

    local monCls = GetClassByType("Monster", monID);
    if monCls ~= nil then       
        return monCls.ClassName
    end

    return 'None';
end

function TGT_REBORN_CUSTOM(self, obj, levelRange, scrName)

    local func = _G[scrName];
    if func ~= nil then
        local monName = func(self, obj);
        if monName ~= 'None' then
            TGT_REBORN(self, obj, levelRange, monName);
        end
    end
end

function TGT_REBORN(self, obj, levelRange, monName)
    local tgtList = GetHardSkillTargetList(self);
    for i = 1 , #tgtList do
        local tgt = tgtList[i];
        local x, y, z = GetPos(tgt);
        if IS_PC(tgt) == true or tgt.MonRank ~= "Normal" then
            return ;
        end

        local levelAdjust = IMCRandom(-levelRange, levelRange);
        local beforeLevel = tgt.Lv;
        local randomLevel = beforeLevel + levelAdjust;
        randomLevel = math.max(1, randomLevel);
        local mon = CREATE_MONSTER_EX(self, monName, x, y, z, GetDirectionByAngle(tgt), GetCurrentFaction(tgt), randomLevel);
        if mon ~= nil then
            CopyMonsterInfo(tgt, mon);
			SetExProp(mon, "DROP_CREATED", 0);
            if randomLevel <= beforeLevel then
                SetExProp(mon, "LEVEL_FOR_EXP", beforeLevel);               
                if GetExProp(tgt, "DROP_CREATED") == 0 then
                    PRECREATE_DROP_LIST(mon, self, 0);
                end
            end
            
            local abil = GetAbility(self, "Oracle4")
            if abil ~= nil then
                if IMCRandom(1,9999) < abil.Level * 5 then
                    AddBuff(mon, mon, "SuperDrop", 33, 0);
                end
            end
            SetExProp_Str(mon, "CHANGE_MON", tgt.ClassName)         
            SetZombie(tgt);
        end
        
    end
end

function SCR_BUFF_ENTER_Forecast_Buff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        EnablePreviewSkillRange(self, 1);
    end
    
    local addDR = 100;
    
    self.DR_BM = self.DR_BM + addDR;
    
    SetExProp(buff, 'ADD_DR', addDR);
end

function SCR_BUFF_LEAVE_Forecast_Buff(self, buff, arg1, arg2, over, isLastEnd)
    if IS_PC(self) == true then
        EnablePreviewSkillRange(self, 0);
    end
    
    local addDR = GetExProp(buff, 'ADD_DR');
    self.DR_BM = self.DR_BM - addDR;
    
end

