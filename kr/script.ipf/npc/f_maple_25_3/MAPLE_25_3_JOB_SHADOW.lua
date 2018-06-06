-- Shadowmancer's Object in field


function SCR_MAPLE_25_3_JOB_SHADOW_OBJECT_BORN_AI(self)
end


function SCR_MAPLE_25_3_JOB_SHADOW_OBJECT_UPDATE_AI(self)
    local pc_List, pc_Cnt = GetWorldObjectList(self, "PC", 200)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(self)
    if pc_Cnt ~= nil then
        for i = 1, pc_Cnt do
            local sObj = GetSessionObject(pc_List[i], "SSN_JOB_SHADOWMANCER_UNLOCK")
            local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc_List[i], 'Char2_19')
            if hidden_Prop == 4 then
                if sObj.Step7 == 0 then
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


function SCR_MAPLE_25_3_JOB_SHADOW_OBJECT_LEAVE_AI(self)
end


function SCR_MAPLE_25_3_JOB_SHADOW_OBJECT_DIALOG(self,pc)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step7 == 0 then -- if you don't take object in this zone
            if inv == 0 then -- if you don't take shadow's trace in this zone
                local today = tonumber(day)
                local nowtime = tonumber(time)
                local lastday = tonumber(sObj.String2)
                local lasttime = tonumber(sObj.String3)
                if lasttime == nil then
                    UIOpenToPC(pc, 'fullblack', 1)
                    PlayDirection(pc, "SHADOWMANCER_UNLOCK_MAPLE_25_3")
                    sleep(500)
                    UIOpenToPC(pc, 'fullblack', 0)
                    sObj.String2 = day
                    sObj.String3 = time
                    SaveSessionObject(pc, sObj)
                elseif lasttime ~= nil then
                    if today == lastday then
                        if nowtime - lasttime >= 5 then -- if time is available
                            UIOpenToPC(pc, 'fullblack', 1)
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_MAPLE_25_3")
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
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_MAPLE_25_3")
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
                HideNPC(pc, "MAPLE_25_3_JOB_SHADOW_OBJECT")
                sObj.Step7 = 1 -- you take object in this zone
                SaveSessionObject(pc, sObj)
            end
        elseif sObj.Step7 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
        end
    end
end


-- Shadowmancer's Object in layer


function SCR_MAPLE_25_3_JOB_SHADOW_INLAYER_OBJECT_ENTER_AI(self)
end


function SCR_MAPLE_25_3_JOB_SHADOW_INLAYER_OBJECT_UPDATE_AI(self) -- playing effect and summon shadow
    PlayEffect(self, "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1) 
    local shadow1 = GetScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_A")
    local shadow2 = GetScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_B")
    local shadow3 = GetScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_C")
    if #shadow1 < 5 then
        self.NumArg1 = self.NumArg1 + 1
        if self.NumArg1 == 5 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'rodeyokel', x+IMCRandom(-150,150), y, z+IMCRandom(-150,150), nil, 'Monster', nil, SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_A)
            AddScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_A", mon)
            self.NumArg1 = 0
        end
    end
    if #shadow2 < 5 then
        self.NumArg2 = self.NumArg2 + 1
        if self.NumArg2 == 5 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'rodeyokel', x+IMCRandom(-150,150), y, z+IMCRandom(-150,150), nil, 'Monster', nil, SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_B)
            AddScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_B", mon)
            self.NumArg2 = 0
        end
    end
    if #shadow3 < 5 then
        self.NumArg3 = self.NumArg3 + 1
        if self.NumArg3 == 5 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'rodeyokel', x+IMCRandom(-150,150), y, z+IMCRandom(-150,150), nil, 'Monster', nil, SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_C)
            AddScpObjectList(self, "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_C", mon)
            self.NumArg3 = 0
        end
    end
end


function SCR_MAPLE_25_3_JOB_SHADOW_INLAYER_OBJECT_LEAVE_AI(self)
end


function SCR_MAPLE_25_3_JOB_SHADOW_INLAYER_OBJECT_DIALOG(self, pc) -- inlayer object dialog
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step7 == 0 then -- if you don't take object in this zone
            if inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "MAPLE_25_3_JOB_SHADOW_OBJECT")
                sObj.Step7 = 1 -- you take object in this zone
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
                    ShowOkDlg(pc, "JOB_SHADOWMANCER_UNLOCK_MAPLE_25")
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
        elseif sObj.Step7 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
            SetLayer(pc, 0)
            DestroyLayer(self)
        end
    end
end


-- Shadow monster


function SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_A(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_A"
    mon.Range = 1
    mon.HPCount = 2
    mon.Journal = "None"
    mon.ShowBaseInfoUI = 1
    mon.DropItemList = "None"
end


function SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_B(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_B"
    mon.Range = 1
    mon.HPCount = 2
    mon.Journal = "None"
    mon.ShowBaseInfoUI = 1
    mon.DropItemList = "None"
end


function SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_C(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_C"
    mon.Range = 1
    mon.HPCount = 2
    mon.Journal = "None"
    mon.ShowBaseInfoUI = 1
    mon.DropItemList = "None"
end


function SCR_MAPLE_25_3_JOB_SHADOWMANCER_SHADOW_TIME_COUNT(self)
    self.NumArg4 = self.NumArg4 +1
    if self.NumArg4 == 45 then
        PlayEffect(self,"F_cleric_smite_cast_black", 0.15, 1, "BOT")
        Kill(self)
    end
end


function MAPLE_25_3_SHADOW_A_LEAVE_AI(self)
    local killer = GetExArgObject(self, "KILLER")
    if killer ~= nil then
        if killer.ClassName == "PC" then
            local result = SCR_GET_HIDDEN_JOB_PROP(killer, 'Char2_19')
            local sObj = GetSessionObject(killer, 'SSN_JOB_SHADOWMANCER_UNLOCK')
            local invcheck = GetInvItemCount(killer, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
            if result == 4 then
                if invcheck == 0 then
                    if sObj.Goal6 >= 0 then
                        if sObj.Goal7 > 0 or sObj.Goal8 > 0 then
                            SendAddOnMsg(killer, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_POINT_DOWN"), 3)
                            if sObj.Goal7 > 0 then
                                sObj.Goal7 = sObj.Goal7-1
                                if sObj.Goal7 < 0 then
                                    sObj.Goal7 = 0
                                end
                            end
                            if sObj.Goal8 > 0 then
                                sObj.Goal8 = sObj.Goal8 -1
                                if sObj.Goal8 < 0 then
                                    sObj.Goal8 = 0
                                end
                            end
                        end
                        if sObj.Goal7 == 0 and sObj.Goal8 == 0 then
                            sObj.Goal6 = sObj.Goal6 +1
                            if sObj.Goal6 >= 80 then
                                local tx = TxBegin(killer)
                                TxGiveItem(tx, 'JOB_SHADOWMANCER_MAPLE_25_3_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                                local ret = TxCommit(tx)
                                SendAddOnMsg(killer, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
                            elseif sObj.Goal6 >= 55 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
                            elseif sObj.Goal6 >= 26 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
                            else
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_POINT_UP"), 5)
                            end
                            local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(killer)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(killer, sObj)
                        end
                    end
                end
            end
        end
    end
    PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
    PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
    PlayEffect(self,"F_burstup007_dark", 1, 1, "BOT")
    Kill(self)
end


function MAPLE_25_3_SHADOW_B_LEAVE_AI(self)
    local killer = GetExArgObject(self, "KILLER")
    if killer ~= nil then
        if killer.ClassName == "PC" then
            local result = SCR_GET_HIDDEN_JOB_PROP(killer, 'Char2_19')
            local sObj = GetSessionObject(killer, 'SSN_JOB_SHADOWMANCER_UNLOCK')
            local invcheck = GetInvItemCount(killer, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
            if result == 4 then
                if invcheck == 0 then
                    if sObj.Goal7 >= 0 then
                        if sObj.Goal6 > 0 or sObj.Goal8 > 0 then
                            SendAddOnMsg(killer, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_POINT_DOWN"), 3)
                            if sObj.Goal6 > 0 then
                                sObj.Goal6 = sObj.Goal6-1
                                if sObj.Goal6 < 0 then
                                    sObj.Goal6 = 0
                                end
                            end
                            if sObj.Goal8 > 0 then
                                sObj.Goal8 = sObj.Goal8 -1
                                if sObj.Goal8 < 0 then
                                    sObj.Goal8 = 0
                                end
                            end
                        end
                        if sObj.Goal6 == 0 and sObj.Goal8 == 0 then
                            sObj.Goal7 = sObj.Goal7 +1
                            if sObj.Goal7 >= 80 then
                                local tx = TxBegin(killer)
                                TxGiveItem(tx, 'JOB_SHADOWMANCER_MAPLE_25_3_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                                local ret = TxCommit(tx)
                                SendAddOnMsg(killer, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
                            elseif sObj.Goal7 >= 55 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
                            elseif sObj.Goal7 >= 26 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
                            else
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_POINT_UP"), 5)
                            end
                            local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(killer)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(killer, sObj)
                        end
                    end
                end
            end
        end
    end
    PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
    PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
    PlayEffect(self,"F_burstup007_dark", 1, 1, "BOT")
    Kill(self)
end


function MAPLE_25_3_SHADOW_C_LEAVE_AI(self)
    local killer = GetExArgObject(self, "KILLER")
    if killer ~= nil then
        if killer.ClassName == "PC" then
            local result = SCR_GET_HIDDEN_JOB_PROP(killer, 'Char2_19')
            local sObj = GetSessionObject(killer, 'SSN_JOB_SHADOWMANCER_UNLOCK')
            local invcheck = GetInvItemCount(killer, "JOB_SHADOWMANCER_MAPLE_25_3_TRACE")
            if result == 4 then
                if invcheck == 0 then
                    if sObj.Goal8 >= 0 then
                        if sObj.Goal6 > 0 or sObj.Goal7 > 0 then
                            SendAddOnMsg(killer, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_POINT_DOWN"), 3)
                            if sObj.Goal6 > 0 then
                                sObj.Goal6 = sObj.Goal6-1
                                if sObj.Goal6 < 0 then
                                    sObj.Goal6 = 0
                                end
                            end
                            if sObj.Goal7 > 0 then
                                sObj.Goal7 = sObj.Goal7 -1
                                if sObj.Goal7 < 0 then
                                    sObj.Goal7 = 0
                                end
                            end
                        end
                        if sObj.Goal6 == 0 and sObj.Goal7 == 0 then
                            sObj.Goal8 = sObj.Goal8 +1
                            if sObj.Goal8 >= 80 then
                                local tx = TxBegin(killer)
                                TxGiveItem(tx, 'JOB_SHADOWMANCER_MAPLE_25_3_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                                local ret = TxCommit(tx)
                                SendAddOnMsg(killer, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
                            elseif sObj.Goal8 >= 55 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
                            elseif sObj.Goal8 >= 26 then
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
                            else
                                SendAddOnMsg(killer, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_POINT_UP"), 5)
                            end
                            local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(killer)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(killer, sObj)
                        end
                    end
                end
            end
        end
    end
    PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
    PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
    PlayEffect(self,"F_burstup007_dark", 1, 1, "BOT")
    Kill(self)
end