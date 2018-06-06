function SCR_DCAPITAL_20_6_BRONE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_REDA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_10_ENT_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_30_ENT_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_60_ENT_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_80_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_40_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_25_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_80_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_6_SQ_80')
    if result == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'DCAPITAL_20_6_SQ_80')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("DCAPITAL_20_6_SQ_80_DTA"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'DCAPITAL_20_6_SQ_80')
        if result2 == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_80', nil, nil, nil, 'F_DCAPITAL_20_6_SQ_80_ITEM/1')
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("DCAPITAL_20_6_SQ_80"), 7)
            ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
            Kill(self)
        end
    end
end

function SCR_DCAPITAL_20_6_SQ_100_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_6_SQ_100')
    if result == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'DCAPITAL_20_6_SQ_100')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("DCAPITAL_20_6_SQ_100_DTA"), 'SITABSORB', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'DCAPITAL_20_6_SQ_100')
        if result2 == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_100', nil, nil, nil, 'F_DCAPITAL_20_6_SQ_100_ITEM/1')
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("DCAPITAL_20_6_SQ_100"), 3)
            PlayEffect(self, 'F_blood005_green', 0.5)
            Kill(self)
        end
    end
end

function SET_DCAPITAL_20_6_SQ_100(mon)
    mon.Dialog = "DCAPITAL_20_6_SQ_100_MON"
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.SimpleAI = 'DCAPITAL_20_6_SQ_100_AI2'
	mon.MaxDialog = 1;
end

function DCAPITAL_20_6_SQ_100_MON_HPLCOK(self)
    local hp_lock = self.MHP*0.05
    AddBuff(self, self, 'HPLock', hp_lock, 0, 0, 1)
end

function DCAPITAL_20_6_SQ_100_MON(self, from)
    if from.ClassName == 'PC' then
        local result = SCR_QUEST_CHECK(from, "F_DCAPITAL_20_6_SQ_100")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'DCAPITAL_20_6_SQ_100_BUFF') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'DCAPITAL_20_6_SQ_100_BUFF', 1, 0, 0, 1)
                    RunScript('DCAPITAL_20_6_SQ_100_MON2', self, self.ClassName)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    else
        local owner = GetOwner(from)
        local result = SCR_QUEST_CHECK(owner, "F_DCAPITAL_20_6_SQ_100")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'DCAPITAL_20_6_SQ_100_BUFF') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'DCAPITAL_20_6_SQ_100_BUFF', 1, 0, 0, 1)
                    RunScript('DCAPITAL_20_6_SQ_100_MON2', self, self.ClassName)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    end
end

function DCAPITAL_20_6_SQ_100_MON2(self, monname)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, monname, x, y, z, GetDirectionByAngle(self), 'Neutral', nil, SET_DCAPITAL_20_6_SQ_100)
    AddBuff(self, mon, 'Stun', 1, 0, 12000, 1);
    SetDialogRotate(mon, 0)
    SetLifeTime(mon, 12, 1)
    Kill(self)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, num)
    local result1 = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_6_SQ_110')
    if result1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_F_DCAPITAL_20_6_SQ_110')

        local moncount = 0
        local i = 0
        local list, cnt = SelectObject(self, 100, 'ALL')

        if cnt ~= 0 then
            for i = 1, cnt do
                if GetCurrentFaction(list[i]) == 'Monster' then
                    moncount = moncount + 1
                end
            end
        else
            return;
        end

        if moncount == 0 then
            if sObj['Step'..num] < 1 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'DCAPITAL_20_6_SQ_110')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("DCAPITAL_20_6_SQ_110_DTA"), 'BURY', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'DCAPITAL_20_6_SQ_110')
                if result2  == 1 then
                    if sObj ~= nil then
                        PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
                        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                        sObj['Step'..num] = sObj['Step'..num] + 1
                        RunScript('TAKE_ITEM_TX', pc, "F_DCAPITAL_20_6_SQ_110_ITEM", 1, "F_DCAPITAL_20_6_SQ_110")
                        SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg("DCAPITAL_20_6_SQ_110_MSG1"), 7)
                        
                        if isHideNPC(pc, 'DCAPITAL_20_6_SQ_110_'..num) == 'NO' then
                            HideNPC(pc, 'DCAPITAL_20_6_SQ_110_'..num)
                        end
                        if isHideNPC(pc, 'DCAPITAL_20_6_SQ_110_RUN_'..num) == 'YES' then
                            UnHideNPC(pc, 'DCAPITAL_20_6_SQ_110_RUN_'..num)
                        end
                    end
                end
            end
        else
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg("DCAPITAL_20_6_SQ_110_MSG2"), 7)
        end
    end
end

function SCR_DCAPITAL_20_6_SQ_110_1_DIALOG(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, 1)
end

function SCR_DCAPITAL_20_6_SQ_110_2_DIALOG(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, 2)
end

function SCR_DCAPITAL_20_6_SQ_110_3_DIALOG(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, 3)
end

function SCR_DCAPITAL_20_6_SQ_110_4_DIALOG(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, 4)
end

function SCR_DCAPITAL_20_6_SQ_110_5_DIALOG(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN(self, pc, 5)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
    if pc.ClassName ~= 'PC' then
        if pc.Faction == 'Monster' then
            PlayEffect(self, 'I_light010', 1, nil, 'BOT')
        end
    end
end

function SCR_DCAPITAL_20_6_SQ_110_RUN_1_ENTER(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN_2_ENTER(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN_3_ENTER(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN_4_ENTER(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
end

function SCR_DCAPITAL_20_6_SQ_110_RUN_5_ENTER(self, pc)
    SCR_DCAPITAL_20_6_SQ_110_RUN2(self, pc)
end

function DCAPITAL_20_6_SQ_60_MON_HPLCOK(self)
    local hp_lock = self.MHP*0.10
    AddBuff(self, self, 'HPLock', hp_lock, 0, 0, 1)
end

function DCAPITAL_20_6_SQ_60_MON(self, argObj)
    if GetHpPercent(self) < 0.11 then
        if self.NumArg4 == 0 then
            SkillCancel(self);
        	local list, cnt = GET_PARTY_ACTOR(argObj, 0)
            
            ObjectColorBlend(self, 0, 0, 0, 0, 1, 0)
            SetPos(self, 412, 16, 972)
            
            local obj = GetLayerObject(GetZoneInstID(argObj), GetLayer(argObj))
            obj.EventNextTrack = 'DCAPITAL_20_6_SQ_60_MON'
            
            PlayDirection(argObj, 'F_DCAPITAL_20_6_SQ_70_TRACK')
            local i
            for i = 1, cnt do
                if IsSameActor(list[i], argObj) == 'NO' then
                    if GetLayer(self) == GetLayer(list[i]) then
                        AddDirectionPC(argObj, list[i])
                        ReadyDirectionPC(argObj, list[i]);
                    end
    end
end
            StartDirection(argObj)
            return 1
        else
            return 1
        end
    end
    return 0
end

function SCR_DCAPITAL_20_6_SQ_110_FAIL(self, tx)
    local i
    for i = 1, 5 do
        if isHideNPC(self, 'DCAPITAL_20_6_SQ_110_RUN_'..i) == 'NO' then
            HideNPC(self, 'DCAPITAL_20_6_SQ_110_RUN_'..i)
        end
    end
end

function DCAPITAL_20_6_SQ_25_TIMER(self)
    local list, cnt = SelectObject(self, 20, 'ALL', 1)
    local i
    local _pc_check = 0
    
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                if self.NumArg4 == 4 then
                    _pc_check = 1
                    local sObj = GetSessionObject(list[i], 'SSN_F_DCAPITAL_20_6_SQ_25')
                    if sObj ~= nil then
                        if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                            SendAddOnMsg(list[i], 'NOTICE_Dm_scroll', ScpArgMsg("DCAPITAL_20_6_SQ_25_MSG"), 7)
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                        end
                    end
                else
                    _pc_check = 1
                end
            end
        end
        if _pc_check >= 1 then
            PlayEffect(self, 'F_light018_yellow', 1.0, nil, 'BOT')
            self.NumArg4 = self.NumArg4 + 1
        end
        if self.NumArg4 >= 5 then
            PlayEffect(self, 'F_ground052_green', 1.0, nil, 'BOT')
            Kill(self)
        end
    end
end

function SCR_DCAPITAL_20_6_SQ_55_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'F_DCAPITAL_20_6_SQ_55')
    if result == 'PROGRESS' then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'DCAPITAL_20_6_SQ_55')
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("F_DCAPITAL_20_6_SQ_55_MSG01"), '#SITGROPESET2', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'DCAPITAL_20_6_SQ_55')
        if result2 == 1 then
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'MID')
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_55', nil, nil, nil, 'F_DCAPITAL_20_6_SQ_55_ITEM2/1')
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("DCAPITAL_20_6_SQ_55_MSG"), 7)
            ObjectColorBlend(self, 50, 50, 50, 0, 1, 1)
            Kill(self)
        end
    end
end

function SCR_DCAPITAL_20_6_SQ_60_TRACK1(pc)
    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_60', nil, nil, nil, 'F_DCAPITAL_20_5_SQ_ITEM2/1')
    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_60', nil, nil, nil, 'F_DCAPITAL_20_5_SQ_ITEM4/1')
    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_60', nil, nil, nil, 'F_DCAPITAL_20_5_SQ_ITEM5/1')
end

function SCR_DCAPITAL_20_6_SQ_60_TRACK2(pc)
    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_F_DCAPITAL_20_6_SQ_60', 'QuestInfoValue1', 1)
end

function SCR_DCAPITAL_20_6_SQ_60_FAIL(self, tx)
    SetLayer(self, 0)
end