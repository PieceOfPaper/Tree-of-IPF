function SCR_JOB_SHADOWMASTER_Q1_OBJECT_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_JOB_SHADOWMASTER_Q1_OBJECT_AI(self)
    local list, cnt = GetWorldObjectList(self, "MON", 60)
    if cnt ~= nil then
        for i = 1, cnt do
            if list[i].ClassName == 'Hiddennpc_move' then
                if IsDead(list[i]) == 0 then
                local owner = GetExArgObject(list[i], "SHADOW_TARGET")
                    if owner ~= nil then
                        local point = GetMGameValue(owner, 'SHADOW_POINT')
                        local isEnabled1, isStarted1, isCompleted1 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '1ST')
                        local isEnabled2, isStarted2, isCompleted2 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '2ND')
                        local isEnabled3, isStarted3, isCompleted3 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '3RD')
                        if isStarted3 == 1 then
                            point = point +3
                        elseif isStarted2 == 1 then
                            point = point +2
                        elseif isStarted1 == 1 then
                            point = point +1
                        end
                        SetMGameValue(owner, 'SHADOW_POINT', point)
                        SendAddOnMsg(owner, 'NOTICE_Dm_Clear', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG1"), 3)
                        ChatLocal(self, owner, "POINT : "..point, 3)
                        ClearExArgObject(list[i], "SHADOW_TARGET")
                        Kill(list[i])
                        PlayEffect(list[i], 'F_wizard_countdown_shot_spread_out', 1.5, 0, "MID", 1)
                    end
                end
            end
        end
    end
end


function SCR_JOB_SHADOWMANCER_Q1_CUBE_AI(self)
    local list, cnt = GetWorldObjectList(self, "PC", 1000)
    local owner = GetExArgObject(self, "TARGET")
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
    end
    local time = self.NumArg2
    if time < 4 then
        self.NumArg2 = self.NumArg2 +1
    elseif time >= 4 then
        self.NumArg2 = self.NumArg2 +1
        if owner ~= nil then
            MoveToTarget(self, owner, 1)
            local isEnabled2, isStarted2, isCompleted2 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '2ND')
            local isEnabled3, isStarted3, isCompleted3 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '3RD')
            if isStarted3 == 1 then
                local speed = GetMGameValue(self, '3RD_SPEED')
                if self.MSPD == 50 then
                    if owner.MSPD_BM > 0 then
                        self.MSPD = speed + owner.MSPD_BM + 1
                        self.MSPD_BM = speed + owner.MSPD_BM +1
                        speed = speed +2
                        SetMGameValue(self, '3RD_SPEED', speed)
                    elseif owner.MSPD_BM <= 0 then
                        self.MSPD = speed + owner.MSPD_BM
                        self.MSPD_BM = speed + owner.MSPD_BM
                        speed = speed +2
                        SetMGameValue(self, '3RD_SPEED', speed)
                    end
                end
            elseif isStarted2 == 1 then
                local speed = GetMGameValue(self, '2ND_SPEED')
                if self.MSPD == 50 then
                    if owner.MSPD_BM > 0 then
                        self.MSPD = speed + owner.MSPD_BM + 1
                        self.MSPD_BM = speed + owner.MSPD_BM +1
                        speed = speed +1
                        SetMGameValue(self, '2ND_SPEED', speed)
                    elseif owner.MSPD_BM <= 0 then
                        self.MSPD = speed + owner.MSPD_BM
                        self.MSPD_BM = speed + owner.MSPD_BM
                        speed = speed +1
                        SetMGameValue(self, '2ND_SPEED', speed)
                    end
                end
            end
        elseif owner == nil then
            if cnt ~= 0 then
                for i = 1, cnt do
                    if GetLayer(self) == GetLayer(list[i]) then
                        if GetZoneName(self) == 'f_pilgrimroad_41_3' then
                            SetExArgObject(self, "TARGET", list[i])
                        end
                    end
                end
            elseif cnt == 0 then
                return
            end
        end
        if self.NumArg2 > 20 then
            Kill(self)
            PlayEffect(self, 'F_burstup005_dark', 3, 0, "BOT", 1)
        end
    end
end


function SCR_JOB_SHADOW_Q1_CUBE_ENTER(self, pc)
    if self.NumArg2 < 4 then
        return
    elseif self.NumArg2 >= 4 then
        local owner = GetExArgObject(self, "TARGET")
        if owner ~= nil then
            if IsDead(self) == 0 then
                if owner.Name == pc.Name then
                    if GetZoneName(self) == 'f_pilgrimroad_41_3' then
                        if GetLayer(self) == GetLayer(pc) then
                            Kill(self)
                            local point = GetMGameValue(pc, 'SHADOW_POINT')
                            local sObj_main = GetSessionObject(owner, 'ssn_klapeda')
                            local failcount = sObj_main['JOB_SHADOWMANCER_Q1_FC']
                            local isEnabled1, isStarted1, isCompleted1 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '1ST')
                            local isEnabled2, isStarted2, isCompleted2 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '2ND')
                            local isEnabled3, isStarted3, isCompleted3 = GetStateMGameStage(self, 'JOB_SHADOWMANCER_Q1', '3RD')
                            if isStarted3 == 1 then
                                if failcount >= 180 then
                                    point = point -1
                                elseif failcount > 120 then
                                    point = point -2
                                elseif failcount > 90 then
                                    point = point -3
                                elseif failcount > 30 then
                                    point = point -4
                                else
                                    point = point -5
                                end
                            elseif isStarted2 == 1 then
                                if failcount > 150 then
                                    point = point -1
                                elseif failcount > 60 then
                                    point = point -2
                                else
                                    point = point -3
                                end
                            elseif isStarted1 == 1 then
                                point = point -1
                            end
                            if point <= 0 then
                                point = 0
                            end
                            SetMGameValue(pc, 'SHADOW_POINT', point)
                            SendAddOnMsg(owner, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG2"), 3)
                            ClearExArgObject(self, "TARGET")
                            PlayEffect(self, 'F_burstup005_dark', 3, 0, "BOT", 1)
                        end
                    end
                end
            end
        else
            return
        end
    end
end


function SCR_JOB_SHADOWMANCER_Q1_ROCK_BORN(self)
    PlayEffect(self, 'I_smoke027_spread_out', 4, 0, "BOT", 0)
end

function SCR_JOB_SHADOWMANCER_Q1_CHASER_BORN(self)
    ObjectColorBlend(self, 30, 30, 30, 255, 10)
end


function SCR_JOB_SHA_Q1_SHADOW_ENTER(self, pc)
    local check = GetExProp(self, "DIALOG")
    if check == nil or check == 0 then
        local result = SCR_QUEST_CHECK(pc, 'JOB_SHADOWMANCER_Q1')
        if result == 'PROGRESS' then
            if GetZoneName(self) == 'f_pilgrimroad_41_3' then
                if GetLayer(self) == GetLayer(pc) then
                    SetExArgObject(self, "SHADOW_TARGET", pc)
                    SetExArgObject(self, "SAVE", pc)
                    SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG3"), 3)
                    SetExProp(self, "DIALOG", 1)
                end
            end
        end
    end
end


function SCR_JOB_SHA_Q1_OBJECT_DIALOG(self, pc)
    local score = GetMGameValue(self, "SHADOW_POINT")
    ChatLocal(self, pc, "POINT : "..score, 3)
end


function SCR_JOB_SHADOWMANCER_Q1_SHADOW_AI(self)
    PlayEffect(self, 'I_smoke012_dark2', 1.5, 0, "MID", 1)
    local owner = GetExArgObject(self, "SHADOW_TARGET")
    if owner ~= nil then
        local result = SCR_QUEST_CHECK(owner, 'JOB_SHADOWMANCER_Q1')
        if result == 'PROGRESS' then
            MoveToTarget(self, owner, 1)
            local speed = GetExProp(self, "SHADOW_SPEED")
            if speed == 0 then
                SetExProp(self, "SHADOW_SPEED", 1)
            end
        end
    end
end


function SCR_JOB_SHADOWMANCER_Q1_PC_BUFF(self)
    SkillCancel(self)
    AddBuff(self, self, "JOB_SHADOWMANCER_Q1_BUFF", 1, 0, 0, 1)
end


function SCR_JOB_SHADOWMANCER_Q1_SAVE_POINT(self)
    local point = GetMGameValue(self, 'SHADOW_POINT')
    local sObj = GetSessionObject(self, 'SSN_JOB_SHADOWMANCER_Q1')
    local inv1 = GetInvItemCount(self, 'costume_Char2_19_03')
    local inv2 = GetInvItemCount(self, 'costume_Char2_19_02')
    local inv3 = GetInvItemCount(self, 'SpecialCostume_ShadowMancer')
    local equip = GetEquipItem(self, 'OUTER')
    local Eitem = equip.ClassName
    if sObj ~= nil then
        if point <= 60 then
            RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
        else
            if inv1 == 0 and inv2 == 0 and inv3 == 0 then
                SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                sObj.Goal1 = point
                sObj.QuestInfoValue1 = 1
                SaveSessionObject(self, sObj)
            elseif (inv3 == 1 or Eitem == 'SpecialCostume_ShadowMancer') then
                if (inv1 == 1 or Eitem == 'costume_Char2_19_03') and (inv2 == 0 and Eitem ~= 'costume_Char2_19_02') then
                    if point <= 75 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                else
                    if point <= 60 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                end
            elseif (inv2 == 1 or Eitem == 'costume_Char2_19_02') then
                if (inv1 == 1 or Eitem == 'costume_Char2_19_03') and (inv3 == 0 and Eitem ~= 'SpecialCostume_ShadowMancer') then
                    if point <= 90 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                else
                    if point <= 60 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                end
            elseif (inv1 == 1 or Eitem == 'costume_Char2_19_03') then
                if (inv2 == 1 or Eitem == 'costume_Char2_19_02') and (inv3 == 0 and Eitem ~= 'SpecialCostume_ShadowMancer') then
                    if point <= 90 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                else
                    if point <= 75 then
                        RunScript('ABANDON_Q_BY_NAME', self, sObj.QuestName, 'FAIL')
                        SendAddOnMsg(self, 'NOTICE_Dm_scroll', ScpArgMsg("JOB_SHADOWMANCER_Q1_MSG4"), 3)
                    else
                        SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
                        sObj.Goal1 = point
                        sObj.QuestInfoValue1 = 1
                        SaveSessionObject(self, sObj)
                    end
                end
            end
        end
    end
end


function SCR_RECORDING_LOG_SHADOWMANCER_Q1(self)
    local point = GetMGameValue(self, 'SHADOW_POINT')
    local sObj = GetSessionObject(self, 'SSN_JOB_SHADOWMANCER_Q1')
    if point > 90 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
    elseif point > 75 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
    elseif point > 60 then
        CustomMongoLog(self, "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
    end
end


function SHA_SCORE_SIX(self)
    SetMGameValue(self, "SHADOW_POINT", 65)
end

function SHA_SCORE_SEVEN(self)
    SetMGameValue(self, "SHADOW_POINT", 80)
end

function SHA_SCORE_EIGHT(self)
    SetMGameValue(self, "SHADOW_POINT", 95)
end
