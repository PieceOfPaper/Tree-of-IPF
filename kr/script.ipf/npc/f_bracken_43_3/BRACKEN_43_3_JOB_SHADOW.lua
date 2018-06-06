-- Shadowmancer's Object in field


function SCR_BRACKEN_43_3_JOB_SHADOW_OBJECT_BORN_AI(self)
end


function SCR_BRACKEN_43_3_JOB_SHADOW_OBJECT_UPDATE_AI(self)
    local pc_List, pc_Cnt = GetWorldObjectList(self, "PC", 200)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(self)
    if pc_Cnt ~= nil then
        for i = 1, pc_Cnt do
            local sObj = GetSessionObject(pc_List[i], "SSN_JOB_SHADOWMANCER_UNLOCK")
            local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc_List[i], 'Char2_19')
            if hidden_Prop == 4 then
                if sObj.Step5 == 0 then
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


function SCR_BRACKEN_43_3_JOB_SHADOW_OBJECT_LEAVE_AI(self)
end


function SCR_BRACKEN_43_3_JOB_SHADOW_OBJECT_DIALOG(self,pc)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step5 == 0 then -- if you don't take object in this zone
            if inv == 0 then -- if you don't take shadow's trace in this zone
                local today = tonumber(day)
                local nowtime = tonumber(time)
                local lastday = tonumber(sObj.String2)
                local lasttime = tonumber(sObj.String3)
                if lasttime == nil then
                    UIOpenToPC(pc, 'fullblack', 1)
                    PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_43_3")
                    sleep(500)
                    UIOpenToPC(pc, 'fullblack', 0)
                    sObj.String2 = day
                    sObj.String3 = time
                    SaveSessionObject(pc, sObj)
                elseif lasttime ~= nil then
                    if today == lastday then
                        if nowtime - lasttime >= 5 then -- if time is available
                            UIOpenToPC(pc, 'fullblack', 1)
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_43_3")
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
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_BRACKEN_43_3")
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
                HideNPC(pc, "BRACKEN_43_3_JOB_SHADOW_OBJECT")
                sObj.Step5 = 1 -- you take object in this zone
                SaveSessionObject(pc, sObj)
            end
        elseif sObj.Step5 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
        end
    end
end


-- Shadowmancer's Object in layer


function SCR_BRACKEN_43_3_JOB_SHADOW_INLAYER_OBJECT_ENTER_AI(self)
end


function SCR_BRACKEN_43_3_JOB_SHADOW_INLAYER_OBJECT_UPDATE_AI(self) -- playing effect and summon shadow
    PlayEffect(self, "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
    local shadow1 = GetScpObjectList(self, "BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW")
    local shadow2 = GetScpObjectList(self, "BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW")
    if #shadow1 < 6 then
        self.NumArg1 = self.NumArg1 +1
        if self.NumArg1 == 3 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'vilkas_soldier', x+IMCRandom(-120,90), y, z+IMCRandom(-120,170), nil, 'Neutral', nil, SCR_BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW)
            AddScpObjectList(self, "BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW", mon)
            self.NumArg1 = 0
        end
    end
    if #shadow2 < 5 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'vilkas_soldier', x+IMCRandom(-150,90), y, z+IMCRandom(-120,150), nil, 'Neutral', nil, SCR_BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW)
        AddScpObjectList(self, "BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW", mon)
    end
end


function SCR_BRACKEN_43_3_JOB_SHADOW_INLAYER_OBJECT_LEAVE_AI(self)
end


function SCR_BRACKEN_43_3_JOB_SHADOW_INLAYER_OBJECT_DIALOG(self, pc) -- inlayer object dialog
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step5 == 0 then -- if you don't take object in this zone
            if inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "BRACKEN_43_3_JOB_SHADOW_OBJECT")
                sObj.Step5 = 1 -- you take object in this zone
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
                    ShowOkDlg(pc, "JOB_SHADOWMANCER_UNLOCK_BRACKEN_43")
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
        elseif sObj.Step5 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
            SetLayer(pc, 0)
            DestroyLayer(self)
        end
    end
end


-- Shadow monster


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW_DIALOG(self,pc)
    if IsDead(self) == 0 then
        local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
        local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
        local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
        if result == 4 then
            if invcheck == 0 then
                PlayAnim(pc, "BUTTON")
                PlayAnim(self, "hit")
                PlayEffect(self,"I_light013_spark_blue_2", 2, 1, "MID")
                PlayEffect(self,"I_exclamation_dark", 1, 1, "TOP")
                sObj.Goal5 = sObj.Goal5 +1
                if sObj.Goal5 >= 100 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'JOB_SHADOWMANCER_BRACKEN_43_3_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                    local ret = TxCommit(tx)
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
                elseif sObj.Goal5 >= 67 then
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
                elseif sObj.Goal5 >= 33 then
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_SURPRISE"), 5)
                end
                local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
                sObj.String2 = day
                sObj.String3 = time
                SaveSessionObject(pc, sObj)
                Kill(self)
                PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
                PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
                PlayEffect(self,"F_burstup007_dark", 1, 1, "BOT")
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_ALREADY_TAKE"), 5)
            end
        end
    end
end


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW_ENTER(self,pc)
    local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
    local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_BRACKEN_43_3_TRACE")
    if result == 4 then
        if invcheck == 0 then
            if sObj.Goal5 > 0 then
                PlayEffect(pc,"I_exclamation_dark", 1, 1, "TOP")
                PlayEffect(pc,"F_burstup029_smoke_dark", 1, 1, "BOT")
                sObj.Goal5 = sObj.Goal5 - 3
                if sObj.Goal5 < 0 then
                    sObj.Goal5 = 0
                end
                local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
                sObj.String2 = day
                sObj.String3 = time
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_TRAP"), 5)
                AddBuff(self, pc, "JOB_SHADOWMANCER_SHADOW_TRAP", 1, 0, 2000, 1)
                Kill(self)
            end
            SaveSessionObject(pc, sObj)
        end
    end
end


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW_BORN_AI(self)
    ObjectColorBlend(self, 10, 10, 10, 0)
end


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW"
    mon.Dialog = "BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW"
    mon.HPCount = 1
    mon.Range = 10
end


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW"
    mon.Enter = "BRACKEN_43_3_JOB_SHADOWMANCER_TRAP_SHADOW"
    mon.Range = 10
end


function SCR_BRACKEN_43_3_JOB_SHADOWMANCER_SHADOW_TIME_COUNT(self)
    self.NumArg4 = self.NumArg4 +1
    if self.NumArg4 == 45 then
        PlayEffect(self,"F_cleric_smite_cast_black", 0.15, 1, "BOT")
        Kill(self)
    end
end