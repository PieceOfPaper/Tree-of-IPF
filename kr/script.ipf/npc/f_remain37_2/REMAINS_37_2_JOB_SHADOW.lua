-- Shadowmancer's Object in field


function SCR_REMAINS_37_2_JOB_SHADOW_OBJECT_BORN_AI(self)
end


function SCR_REMAINS_37_2_JOB_SHADOW_OBJECT_UPDATE_AI(self)
    local pc_List, pc_Cnt = GetWorldObjectList(self, "PC", 200)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(self)
    if pc_Cnt ~= nil then
        for i = 1, pc_Cnt do
            local sObj = GetSessionObject(pc_List[i], "SSN_JOB_SHADOWMANCER_UNLOCK")
            local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc_List[i], 'Char2_19')
            if hidden_Prop == 4 then
                if sObj.Step8 == 0 then
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


function SCR_REMAINS_37_2_JOB_SHADOW_OBJECT_LEAVE_AI(self)
end


function SCR_REMAINS_37_2_JOB_SHADOW_OBJECT_DIALOG(self,pc)
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step8 == 0 then -- if you don't take object in this zone
            if inv == 0 then -- if you don't take shadow's trace in this zone
                local today = tonumber(day)
                local nowtime = tonumber(time)
                local lastday = tonumber(sObj.String2)
                local lasttime = tonumber(sObj.String3)
                if lasttime == nil then
                    UIOpenToPC(pc, 'fullblack', 1)
                    PlayDirection(pc, "SHADOWMANCER_UNLOCK_REMAINS_37_2")
                    sleep(500)
                    UIOpenToPC(pc, 'fullblack', 0)
                    sObj.String2 = day
                    sObj.String3 = time
                    SaveSessionObject(pc, sObj)
                elseif lasttime ~= nil then
                    if today == lastday then
                        if nowtime - lasttime >= 5 then -- if time is available
                            UIOpenToPC(pc, 'fullblack', 1)
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_REMAINS_37_2")
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
                            PlayDirection(pc, "SHADOWMANCER_UNLOCK_REMAINS_37_2")
                            sleep(500)
                            UIOpenToPC(pc, 'fullblack', 0)
                            sObj.String2 = day
                            sObj.String3 = time
                            SaveSessionObject(pc, sObj)
                        else -- if time isn't available
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_NOT_AVAILABLE"), 5)
                        end
                    end
                end
            elseif inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "REMAINS_37_2_JOB_SHADOW_OBJECT")
                sObj.Step8 = 1 -- you take object in this zone
                SaveSessionObject(pc, sObj)
            end
        elseif sObj.Step8 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
        end
    end
end


-- Shadowmancer's Object in layer


function SCR_REMAINS_37_2_JOB_SHADOW_INLAYER_OBJECT_ENTER_AI(self)
end


function SCR_REMAINS_37_2_JOB_SHADOW_INLAYER_OBJECT_UPDATE_AI(self) -- playing effect and summon shadow
    PlayEffect(self, "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
    local shadow1 = GetScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_SHADOW")
    local shadow2 = GetScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_A")
    local shadow3 = GetScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_B")
    if #shadow1 < 5 then
        self.NumArg1 = self.NumArg1+1
        if self.NumArg1 == 3 then
            local x, y, z = GetPos(self)
            local mon1 = CREATE_MONSTER_EX(self, 'Minos', x+IMCRandom(-140,140), y, z+IMCRandom(-140,140), nil, 'Neutral', nil, SCR_REMAINS_37_2_JOB_SHADOWMANCER_SHADOW)
            AddScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_SHADOW", mon1)
            self.NumArg1 = 0
        end
    end
    if #shadow2 < 1 then
        self.NumArg2 = self.NumArg2+1
        if self.NumArg2 >= 45 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Lizardman_mage', x+IMCRandom(-140,140), y, z+IMCRandom(-140,140), nil, 'Neutral', nil, SCR_REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW)
            AddScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_A", mon)
            self.NumArg2 = 0
        end
    end
    if #shadow3 < 1 then
        self.NumArg3 = self.NumArg3+1
        if self.NumArg3 >= 45 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Lizardman_mage', x+IMCRandom(-140,140), y, z+IMCRandom(-140,140), nil, 'Neutral', nil, SCR_REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW)
            AddScpObjectList(self, "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_B", mon)
            self.NumArg3 = 0
        end
    end
end


function SCR_REMAINS_37_2_JOB_SHADOW_INLAYER_OBJECT_LEAVE_AI(self)
end


function SCR_REMAINS_37_2_JOB_SHADOW_INLAYER_OBJECT_DIALOG(self, pc) -- inlayer object dialog
    local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_SHADOWMANCER_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local inv = GetInvItemCount(pc, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
    if hidden_Prop == 4 then -- now doing unlock for shadowmancer class
        if sObj.Step8 == 0 then -- if you don't take object in this zone
            if inv >= 1 then -- if you take shadow's trace in this zone
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_OBJECT"), 5)
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_OBJECT', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                HideNPC(pc, "REMAINS_37_2_JOB_SHADOW_OBJECT")
                sObj.Step8 = 1 -- you take object in this zone
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
                    ShowOkDlg(pc, "JOB_SHADOWMANCER_UNLOCK_REMAINS_37")
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
        elseif sObj.Step8 == 1 then -- if you take object in this zone
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_YOU_TAKE_THIS_OBJECT"), 5)
            SetLayer(pc, 0)
            DestroyLayer(self)
        end
    end
end


-- Shadow monster


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_SHADOW_ENTER(self,pc)
    local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
    local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
    if result == 4 then
        if invcheck == 0 then
            sObj.Goal4 = sObj.Goal4 +1
            if sObj.Goal4 >= 100 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'JOB_SHADOWMANCER_REMAINS_37_2_TRACE', 1, "JOB_SHADOWMANCER_UNLOCK")
                local ret = TxCommit(tx)
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_SHADOWMANCER_GET_SHADOW"), 5)
            elseif sObj.Goal4 >= 67 then
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_100_POINT"), 5)
            elseif sObj.Goal4 >= 33 then
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_50_POINT"), 5)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JOB_SHADOWMANCER_STEP_ON_SHADOW"), 5)
            end
            local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
            sObj.String2 = day
            sObj.String3 = time
            SaveSessionObject(pc, sObj)
            Kill(self)
            PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
            PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
            PlayEffect(self,"F_burstup007_dark", 1.2, 1, "BOT")
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_ALREADY_TAKE"), 5)
        end
    end
end


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_ENTER(self,pc)
    local result = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    local sObj = GetSessionObject(pc, 'SSN_JOB_SHADOWMANCER_UNLOCK')
    local invcheck = GetInvItemCount(pc, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
    if result == 4 then
        if invcheck == 0 then
            if sObj.Goal4 > 0 then
                sObj.Goal4 = sObj.Goal4 -5
                if sObj.Goal4 < 0 then
                    sObj.Goal4 = 0
                end
                local day, time = SCR_JOB_SHADOWMANCER_TIME_CHECK(pc)
                sObj.String2 = day
                sObj.String3 = time
                SaveSessionObject(pc, sObj)
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_SHADOWMANCER_LOSE_POINT"), 5)
                Kill(self)
                PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
                PlayEffect(self,"F_smoke144_dark2", 0.6, 1, "BOT")
                PlayEffect(self,"F_burstup007_dark", 1.2, 1, "BOT")
            end
        end
    end
end


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_SHADOW(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "REMAINS_37_2_JOB_SHADOWMANCER_SHADOW"
    mon.Enter = "REMAINS_37_2_JOB_SHADOWMANCER_SHADOW"
    mon.Range = 10
end


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW(mon)
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW"
    mon.Enter = "REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW"
    mon.WlkMSPD = 60
    mon.Range = 10
    mon.Scale = 0.75
end


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_PACKMAN_SHADOW_TARGET_AI(self)
    local list, cnt = GetWorldObjectList(self, "PC",400)
    local owner = GetExArgObject(self, "SHADOW_TARGET")
    if owner ~= nil then
        local invcheck = GetInvItemCount(owner, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
        if invcheck == 0 then
            MoveToTarget(self, owner, 5)
        else
            owner = nil
        end
    else
        local PC_list = {}
        local i
        local j = 1
        for i = 1, cnt do
            if  IS_PC(list[i]) == true then
            PC_list[j] = list[i]
                j = j + 1
            end
            if #PC_list ~= nil then
                local rnd = IMCRandom(1, j-1)
                local target = PC_list[rnd]
                local result = SCR_GET_HIDDEN_JOB_PROP(target, 'Char2_19')
                local result2 = GetSessionObject(PC_list[rnd], "SSN_JOB_SHADOWMANCER_UNLOCK")
                local invcheck = GetInvItemCount(target, "JOB_SHADOWMANCER_REMAINS_37_2_TRACE")
                if result == 4 then
                    if result2.Goal4 >= 1 then
                        if invcheck == 0 then
                            if GetZoneInstID(self) == GetZoneInstID(target) then
                                if GetLayer(self) == GetLayer(target) then
                                    if GetDistance(self, target) <= 400 then
                                        SetExArgObject(self, "SHADOW_TARGET", target)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


function SCR_REMAINS_37_2_JOB_SHADOWMANCER_SHADOW_TIME_COUNT(self)
    self.NumArg4 = self.NumArg4 +1
    if self.NumArg4 == 45 then
        PlayEffect(self,"F_cleric_smite_cast_black", 0.15, 1, "BOT")
        Kill(self)
    end
end