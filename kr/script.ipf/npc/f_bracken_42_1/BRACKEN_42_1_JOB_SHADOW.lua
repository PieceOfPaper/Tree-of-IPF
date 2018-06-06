-- Shadowmancer's Object in field


function SCR_BRACKEN_42_1_JOB_SHADOW_OBJECT_BORN_AI(self)
end


function SCR_BRACKEN_42_1_JOB_SHADOW_OBJECT_UPDATE_AI(self)
    local pc_List, pc_Cnt = GetWorldObjectList(self, "PC", 200)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(self)
    if pc_Cnt ~= nil then
        for i = 1, pc_Cnt do
            local sObj = GetSessionObject(pc_List[i], "SSN_JOB_SHADOWMANCER_UNLOCK")
            local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc_List[i], 'Char2_19')
            if hidden_Prop == 4 then
                if sObj.Step6 == 0 then
                    local today = tonumber(day)
                    local nowtime = tonumber(time)
                    local lastday = tonumber(sObj.String2)
                    local lasttime = tonumber(sObj.String3)
                    if lasttime == nil then
                        PlayEffectLocal(self, pc_List[i], "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
                    elseif lasttime ~= nil then
                        if today == lastday then
                            if nowtime - lasttime >= 5 then
                                PlayEffectLocal(self, pc_List[i], "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
                            end
                        elseif today ~= lastday then
                            if (nowtime +1440) - lasttime >= 5 then
                                PlayEffectLocal(self, pc_List[i], "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
                            end
                        end
                    end
                end
            end
        end
    end
end


function SCR_BRACKEN_42_1_JOB_SHADOW_OBJECT_LEAVE_AI(self)
end


function SCR_BRACKEN_42_1_JOB_SHADOW_OBJECT_DIALOG(self,pc)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step6 == 0 then -- if you don't take object in this zone
            if inv == 0 then -- if you don't take shadow's trace in this zone
                local today = tonumber(day)
                local nowtime = tonumber(time)
                local lastday = tonumber(sObj.String2)
                local lasttime = tonumber(sObj.String3)
                if lasttime == nil then
                    UIOpenToPC(pc, 'fullblack', 1)
                    PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_42_1")
                    sleep(500)
                    UIOpenToPC(pc, 'fullblack', 0)
                    sObj.String2 = day
                    sObj.String3 = time
                    SaveSessionObject(pc, sObj)
                elseif lasttime ~= nil then
                    if today == lastday then
                        if nowtime - lasttime >= 5 then -- if time is available
                            UIOpenToPC(pc, 'fullblack', 1)
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_42_1")
                            sleep(500)
                            UIOpenToPC(pc, 'fullblack', 0)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(pc, sObj)
                        else -- if time isn't available
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_NOT_AVAILABLE"), 5)
                        end
                    elseif today ~= lastday then
                        if (nowtime +1440) - lasttime >= 5 then -- if time is available
                            UIOpenToPC(pc, 'fullblack', 1)
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_42_1")
                            sleep(500)
                            UIOpenToPC(pc, 'fullblack', 0)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(pc, sObj)
                        else -- if time isn;t available
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_NOT_AVAILABLE"), 5)
                        end
                    end
                end
            elseif inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "BRACKEN_42_1_JOB_SHADOW_OBJECT")
                sObj.Step6 = 1 -- you take object in this zone
                SaveSessionObject(pc, sObj)
            end
        elseif sObj.Step6 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
        end
    end
end


-- Shadowmancer's Object in layer


function SCR_BRACKEN_42_1_JOB_SHADOW_INLAYER_OBJECT_ENTER_AI(self)
end


function SCR_BRACKEN_42_1_JOB_SHADOW_INLAYER_OBJECT_UPDATE_AI(self) -- playing effect
    PlayEffect(self, "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1) 
    local device = GetScpObjectList(self, "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE")
    if #device < 1 then
        local x, y, z = GetPos(self)
        local npc = CREATE_MONSTER_EX(self, 'npc_circle_trigger', x-25, y, z+31, nil, 'Neutral', 0, SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE)
        AddScpObjectList(self, "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE", npc)
        PlayEffect(npc, "F_ground012_light", 1.5, 1, 'BOT', 1)
    end
end


function SCR_BRACKEN_42_1_JOB_SHADOW_INLAYER_OBJECT_LEAVE_AI(self)
end


function SCR_BRACKEN_42_1_JOB_SHADOW_INLAYER_SUMMON_AI(self) -- summon monster
    local shadow = GetScpObjectList(self, "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW")
    if #shadow < 5 then
        self.NumArg1 = self.NumArg1 +1
        if self.NumArg1 == 3 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Gosaru_blue', x+IMCRandom(-130,130), y, z+IMCRandom(-130,130), nil, 'Neutral', nil, SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW)
            AddScpObjectList(self, "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW", mon)
            self.NumArg1 = 0
        end
    end
end


function SCR_BRACKEN_42_1_JOB_SHADOW_INLAYER_OBJECT_DIALOG(self, pc) -- inlayer object dialog
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step6 == 0 then -- if you don't take object in this zone
            if inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "BRACKEN_42_1_JOB_SHADOW_OBJECT")
                sObj.Step6 = 1 -- you take object in this zone
                sObj.String2 = day
                sObj.String3 = time
                SaveSessionObject(pc, sObj)
                UIOpenToPC(pc, 'fullblack', 1)
                SetLayer(pc, 0)
                DestroyLayer(self)
                sleep(500)
                UIOpenToPC(pc, 'fullblack', 0)
            elseif inv == 0 then -- if you don't take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_CHECK_ITEM"), 5)
                local sel1 = ShowSelDlg(pc, 0, 'JOB_SHADOWMANCER_UNLOCK_EXIT_CHECK', ScpArgMsg('No'), ScpArgMsg('JOB_SHADOWMANCER_UNLOCK_EXPLAIN'), ScpArgMsg('Yes'))
                if sel1 == 1 then
                    return
                elseif sel1 == 2 then
                    ShowOkDlg(pc, "JOB_SHADOWMANCER_UNLOCK_BRACKEN_42")
                elseif sel1 == 3 then
                    sObj.String2 = day
                    sObj.String3 = time
                    SaveSessionObject(pc, sObj)
                    UIOpenToPC(pc, 'fullblack', 1)
                    SetLayer(pc, 0)
                    DestroyLayer(self)
                    sleep(500)
                    UIOpenToPC(pc, 'fullblack', 0)
                end
            end
        elseif sObj.Step6 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
            SetLayer(pc, 0)
            DestroyLayer(self)
        end
    end
end


-- Shadow Monster


function SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_DIALOG(self, pc)
    local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
    local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
    local buffcheck = IsBuffApplied(pc, "JOB_SHADOWMANCER_CHANGE_SHADOW")
    if buffcheck == "YES" then
        if result == 4 then
            if invcheck == 0 then
                Kill(self)
                PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
                PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
                PlayEffect(self,"F_burstup007_dark", 1.2, 1, "BOT")
                sObj.Goal9 = sObj.Goal9 +1
                if sObj.Goal9 >= 80 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'JOB_SHADOWMANCER_BRACKEN_42_1_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                    local ret = TxCommit(tx)
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
                elseif sObj.Goal9 >= 55 then
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
                elseif sObj.Goal9 >= 26 then
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_CATCH_SHADOW"), 5)
                end
                local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
                sObj.String2 = day
                sObj.String3 = time
                SaveSessionObject(pc, sObj)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_ALREADY_TAKE"), 5)
            end
        end
    end
end


function SCR_BRACKEN_42_1_JOB_SHADOWMACER_SHADOW_ENTER(self, pc)
    local buffcheck = IsBuffApplied(pc, "JOB_SHADOWMANCER_CHANGE_SHADOW")
    if buffcheck == "NO" then
        RunAwayFrom(self, pc, 100)
        PlayEffect(self,"I_exclamation_dark", 1, 1, "TOP")
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_SHADOW_RUNAWAY"), 5)
    end
end


function SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW"
    mon.Dialog = "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW"
    mon.Enter = "BRACKEN_42_1_JOB_SHADOWMACER_SHADOW"
    mon.Range = 30
    mon.WlkMSPD = 40
end


function SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_TIME_COUNT(self)
    self.NumArg4 = self.NumArg4 +1
    if self.NumArg4 == 45 then
        PlayEffect(self,"F_cleric_smite_cast_black", 0.15, 1, "BOT")
        Kill(self)
    end
end


-- Changing Shadow Form Device


function SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE(npc)
    npc.Name = ScpArgMsg("JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE")
    npc.Dialog = "BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE"
end


function SCR_BRACKEN_42_1_JOB_SHADOWMANCER_SHADOW_CHANGE_DEVICE_DIALOG(self, pc)
    local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
    local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_42_1_TRACE")
    if result == 4 then
        if sObj.QuestInfoValue2 == 0 then
            if invcheck == 0 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 1, 'JOB_SHADOWMANCER_UNLOCK')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_SHADOWMANCER_Q_SHADOW_POOL"), 'ABSORB', animTime)
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_SHADOWMANCER_UNLOCK')
                if result2 == 1 then
                    PlayEffect(pc, 'F_wizard_ShadowPool_cast', 1, 1, "BOT")
                    AddBuff(self, pc, "JOB_SHADOWMANCER_CHANGE_SHADOW", 1, 0, 30000, 1)
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_CHANGE_SHADOW"), 5)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_ALREADY_TAKE"), 5)
            end
        end
    else
        return
    end
end