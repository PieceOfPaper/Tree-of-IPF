function FD_UNDERF591_TYPEB_LIB(self)
    
end

function UNDERF592_TYPEA_BOSS(self)

end

function SCR_FD_UNDERF592_TYPEA_ALTER_DIALOG(self, pc)
    local zoneID = GetZoneInstID(pc)
    local zon_Obj = GetLayerObject(zoneID, 0);
    local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEA_ALTER_1"), 'WORSHIP', 2)
    if result2 == 1 then
        if zon_Obj ~= nil then
            if IsBuffApplied(pc, 'FD_UNDERF592_TYPEA_MONKILL') == "YES" then
                SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('UNDERF592_TYPEA_ALTER_MSG_3'), 3)
                RemoveBuff(pc, 'FD_UNDERF592_TYPEA_MONKILL')
                if IsBuffApplied(pc, 'FD_UNDERF592_TYPEA_BUFF') == "NO" then
                    AddBuff(self, pc, 'FD_UNDERF592_TYPEA_BUFF', 1, 0, 6000, 1)
                    SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('UNDERF592_TYPEA_ALTER_MSG_1'), 3)
                end
            else
                SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('UNDERF592_TYPEA_ALTER_MSG_2'), 3)
            end
        end
    end
end

--function FD_UNDERF591_TYPEA_ALTER_AI(self)
--    local zoneID = GetZoneInstID(self)
--    local zon_Obj = GetLayerObject(zoneID, 0);
--    local TypeA_01 = GetExProp(zon_Obj, 'UNDER592_TYPE_A')
--    if TypeA_01 == 1 then
--        if self.NumArg4 < 650 then
--            self.NumArg4 = self.NumArg4 + 1
--        else
--            SetExProp(zon_Obj, 'UNDER592_TYPE_A', 0)
--        end
--    end
--end

--function FD_UNDERF592_TYPEA_MONKILL_AI(self, Killer)
--    if IsBuffApplied(Killer, 'FD_UNDERF592_TYPEA_MONKILL') == "NO" then
--        AddBuff(self, Killer, 'FD_UNDERF592_TYPEA_MONKILL', 1, 0, 30000, 1)
--    end
--end


function FD_UNDERF592_TYPEC_CONTROL_AI(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    local TypeC_01 = GetExProp(zon_Obj, 'UNDER592_TYPE_C_1')
    local TypeC_02 = GetExProp(zon_Obj, 'UNDER592_TYPE_C_2')
    if TypeC_01 >= 1 and TypeC_02 >= 1 then
        if self.NumArg4 == 0 then
            self.NumArg4 = 1
            if self.NumArg3 == 0 then
                self.NumArg3 = 1
                SCR_DUNGEON_NOTICE(self, 'Clear', 'FD_UNDERF592_TYPEC_CONTROL_AI', 5)
                local mon1 = CREATE_MONSTER_EX(self, 'HiddenControl', 1124, 1, 180, 0, 'Neutral', 1, FD_UNDERF592_TYPEC_CONTROL_1_RUN)
            elseif self.NumArg3 >= 1 and self.NumArg3 < 300 then
                self.NumArg3 = self.NumArg3 + 1
            else
                self.NumArg3 = 0
                self.NumArg4 = 0
                SetExProp(zon_Obj, 'UNDER592_TYPE_C_1', 0)
                SetExProp(zon_Obj, 'UNDER592_TYPE_C_2', 0)
            end
        end
    end
end

function FD_UNDERF592_TYPEC_CONTROL_1_RUN(mon)
    mon.SimpleAI = 'FD_UNDERF592_TYPEC_CONTROL_1'
end


function SCR_UNDERF592_TYPEC_DEFENCE_1_DIALOG(self, pc)
    local zone_Obj = GetLayerObject(self)
    local TypeC_01 = GetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE')
    if TypeC_01 == 0 then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF592_TYPEC_DO"), 'MAKING', 2)
        if result2 == 1 then
            SetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE', 1)
        end
    else
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('UNDERF592_TYPEC_1'), 3)
    end
end

function UNDERF592_TYPEC_DEFENCE_1_AI(self)
    local zone_Obj = GetLayerObject(self);
    local TypeC_01 = GetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE')
    local TypeC_CNT = GetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE_CNT')
    local TypeC_BFF = GetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE_BFF')
    if TypeC_01 == 0 then
        return
    elseif TypeC_01 == 1 then
        if GetCurrentFaction(self) == 'Neutral' then
            SetCurrentFaction(self, 'Our_Forces')
            AttachEffect(self, 'F_magic_prison_line_yellow', 1)
        elseif GetCurrentFaction(self) == 'Our_Forces' then
            local list, cnt = SelectObjectByFaction(self, 300, 'Monster')
            local i
            for i = 1, cnt do
                if i > 5 then
                    break
                end
                InsertHate(list[i], self, 1)
            end
        end
        local mon1 = CREATE_MONSTER_EX(self, 'HiddenTrigger6', 1003, 5, -788, 0, 'Neutral', 1, UNDERF592_TYPEC_DEFENCE_1_AI_MON_RUN)
        if mon1 ~= nil then
            AddScpObjectList(mon1, 'TYPEC_DEFENCE_TAG', self)
            SetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE', 2)
            SCR_DUNGEON_NOTICE(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_DO', 10)
        end
    elseif TypeC_01 == 2 then
        if TypeC_CNT < 300 then
            SetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE_CNT', TypeC_CNT + 1)
            local remainT = 300 - TypeC_CNT
            if TypeC_CNT == 50 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 100 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 150 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 200 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 250 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 275 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 5)
            elseif TypeC_CNT == 293 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 294 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 295 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 296 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 297 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 298 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            elseif TypeC_CNT == 299 then
                SCR_DUNGEON_NOTICE_COMB(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_1', remainT, 'UNDERF592_TYPEC_TIMMER_2', 1)
            end
        else
            SetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE', 3)
        end
    elseif TypeC_01 == 3 then
        if GetCurrentFaction(self) == 'Our_Forces' then
            SCR_DUNGEON_NOTICE(self, 'scroll', 'UNDERF592_TYPEC_TIMMER_SUCC', 10)
            SetCurrentFaction(self, 'Neutral')
            AttachEffect(self, 'F_magic_prison_line_yellow', 3)
        end
        if TypeC_BFF < 300 then
            SetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE_BFF', TypeC_BFF + 1)
            SCR_DUNGEON_ALL_BUFF(self, 'UNDERF592_TYPEC_DEFENCE', 1, 60)
        elseif TypeC_BFF == 300 then
            Kill(self)
        end
    end
    
end

function UNDERF592_TYPEC_DEFENCE_1_AI_MON_RUN(mon)
    mon.SimpleAI = 'UNDERF592_TYPEC_DEFENCE_1_AI_MON'
end


function UNDERF592_TYPEC_DEFENCE_1_AI_MON(self)
    local trg = GetScpObjectList(self, 'TYPEC_DEFENCE_TAG')
    local zone_Obj = GetLayerObject(self)
    local zoneID = GetZoneInstID(self)
    
    if #trg == 0 then
        Kill(self)
    else
        local TypeC_01 = GetExProp(zone_Obj, 'UNDERF592_TYPEC_DEFENCE')
        if TypeC_01 == 2 then
            local child_mon = GetScpObjectList(self, 'TYPEC_DEFENCE_CHILD')
            self.NumArg3 = self.NumArg3 +1
            if #child_mon == 0 then
                if self.NumArg3 >= 6 then
                    local i
                    local x = 1
                    local y = 2
                    local z = 3
                    
                    for i = 1, IMCRandom(10, 14) do
                        local mon = {}
                        local list = GetCellCoord(self, 'Siege3', 0)
                        if IsValidPos(zoneID, list[x], list[y], list[z]) == 'YES' then
                            mon[i] = CREATE_MONSTER_EX(self, 'FD_Spector_gh_purple_gimic', list[x], list[y], list[z], 0, 'Monster', 0, UNDERF592_TYPEC_DEFENCE_1_AI_RUN);
                            if mon[i] ~= nil then
                                AddScpObjectList(self, 'TYPEC_DEFENCE_CHILD', mon[i])
                                SetLifeTime(mon[i], 300, 1)
                                self.NumArg3 = 0
                            end
                        end
                    end
                    x = x + 3
                    y = y + 3
                    z = z + 3
                end
            end
        elseif TypeC_01 == 3 then
            Kill(self)
        end
        
    end
end


function UNDERF592_TYPEC_DEFENCE_1_AI_RUN(mon)
    mon.SimpleAI = 'UNDERF592_TYPEC_DEFENCE_1_AI_RUN'
    mon.WlkMSPD = 65
end



function UNDERF592_TYPEG_PILLAR_AI(self)
    Chat(self, GetFlyHeight(self), 1)
    if GetFlyHeight(self) == 100 then
        FlyMath(self, 1, 4, 5)
    elseif GetFlyHeight(self) <= 1 then
        FlyMath(self, 100, 8, 8)
    end
end


function FD_UNDERF592_TYPEC_CONTROL_1(self)
    local i
    local list, cnt = SelectObjectBySquare(self, 190, 180, "ENEMY")
    for i = 1, cnt do
        if list[i].Faction == 'Monster' then
            if list[i].HP > (list[i].MHP)*0.5 then
                TakeDamage(self, list[i], "None", 30, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
            else
                if IsBuffApplied(list[i], 'FD_UNDERF592_TYPEC_DEBUFF') == "NO" then
                    AddBuff(self, list[i], 'FD_UNDERF592_TYPEC_DEBUFF', 1, 0, 60000, 1)
                end
            end
        end
    end
end



function UNDERF592_TYPEC_OBJ_TIMMER(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    local TypeC_01 = GetExProp(zon_Obj, 'UNDER592_TYPE_C_1')
    if TypeC_01 >= 1 and TypeC_01 < 60 then
        SetExProp(zon_Obj, 'UNDER592_TYPE_C_1', TypeC_01 + 1)
    else
        SetExProp(zon_Obj, 'UNDER592_TYPE_C_1', 0)
        SetFixAnim(self, 'OFF')
    end
end


function UNDERF592_TYPEC_OBJ_TIMMER_1(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    local TypeC_02 = GetExProp(zon_Obj, 'UNDER592_TYPE_C_2')
    if TypeC_02 >= 1 and TypeC_02 < 60 then
        SetExProp(zon_Obj, 'UNDER592_TYPE_C_2', TypeC_02 + 1)
    else
        SetExProp(zon_Obj, 'UNDER592_TYPE_C_2', 0)
        SetFixAnim(self, 'OFF')
    end
end


function FD_UNDERF592_TYPEC_MONKILL(self, Killer)
    if IsBuffApplied(Killer, 'FD_UNDERF592_TYPEC_FIRE_BUFF') == "NO" then
        AddBuff(self, Killer, 'FD_UNDERF592_TYPEC_FIRE_BUFF', 1, 0, 30000, 1)
    end
end

function SCR_SSN_UNDERF592_TYPEB_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, 'KillMonster', 'UNDERF592_TYPEB_KILLMON', 'NO')
	RegisterHookMsg(self, sObj, 'Chat', 'UNDERF592_TYPEB_RUN', 'NO')
	SetTimeSessionObject(self, sObj, 1, 5000, 'UNDERF592_TYPEB_KILLMON_DEST')
end
function SCR_CREATE_SSN_UNDERF592_TYPEB(self, sObj)
	SCR_SSN_UNDERF592_TYPEB_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_UNDERF592_TYPEB(self, sObj)
	SCR_SSN_UNDERF592_TYPEB_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_UNDERF592_TYPEB(self, sObj)
end

function UNDERF592_TYPEB_KILLMON_DEST(self, sObj)
    if GetZoneName(self) ~= 'd_underfortress_59_2' then
        DestroySessionObject(self, sObj)
    end
end

function UNDERF592_TYPEB_KILLMON(self, sObj, msg, argObj, argStr, argNum)
    if IsBuffApplied(argObj, 'UNDERF592_TYPEB_KILLMON') == 'YES' then
        local rnd = IMCRandom(1, 5)
        if rnd >= 2 then
            local list, cnt = GetInvItemByName(self, 'UNDERF592_TYPEB_POTION')
            if cnt < 1 then
                if sObj.Goal1 == 0 then
                    RunScript('GIVE_ITEM_TX', self, 'UNDERF592_TYPEB_POTION', 1, "Quest")
                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', ScpArgMsg('UNDERF592_TYPEB_KILLMON'), 3)
                    sObj.Goal1 = 1
                end
            end
        end
    end
end

function UNDERF592_TYPEB_RUN(self, sObj, msg, argObj, argStr, argNum)
    if GetZoneName(self) == 'd_underfortress_59_2' then
        if GetLayer(self) == 0 then
            if IsBuffApplied(self, 'UNDERF592_TYPEB_OTP') == 'YES' then
                local buff = GetBuffByName(self, 'UNDERF592_TYPEB_OTP')
                local lv, arg2 = GetBuffArg(buff)
                if arg2 == tonumber(argStr) then
                    local list, cnt = SelectObjectByClassName(self, 150, 'velniasp_block')
                    local i
                    if cnt > 0 then
                        for i = 1 , cnt do
                            Dead(list[i])
                            if IsBuffApplied(self, 'UNDERF592_TYPEB_OTP') == 'YES' then
                                RemoveBuff(self, 'UNDERF592_TYPEB_OTP')
                            end
                            if IsBuffApplied(self, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
                                RemoveBuff(self, 'UNDERF592_TYPEB_KINGVOICE')
                            end
                            return
                        end
                    end
                end
            end
        end
    else
        DestroySessionObject(self, sObj)
    end
end

function UNDERF592_TYPEB_GATE_DEAD_BASIC(self)
    local list, cnt = SelectObjectByClassName(self, 295, 'holly_sphere_chapel_01')
    local i
    local mon = {}
    local zonstID = GetZoneInstID(self);
    if cnt > 0 then
        for i = 1, 5 do
            local x, y, z = GetPos(list[1])
            local rnd = IMCRandom(-25, 25)
            if IsValidPos(zonstID, x+rnd, y, z+rnd) == 'YES' then
                mon[i] = CREATE_MONSTER_EX(self, 'FD_Spector_gh_purple', x+rnd, y+ 1, z+rnd, 0, 'Monster', 0, UNDERF592_TYPEB_GATE_DEAD_RUN_1);
            end
        end
    end
end

function UNDERF592_TYPEB_GATE_DEAD_RUN_1(mon)
    mon.SimpleAI = 'UNDERF592_TYPEB_GATE_DEAD_RUN_1'
--    mon.Lv = 77
end


function SCR_UNDERF592_TYPEB_GATE_1_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
--            ShowBalloonText(pc, ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS")..'       '..pass, 10)
        end
    end
end

function SCR_UNDERF592_TYPEB_GATE_2_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
        end
    end
end

function SCR_UNDERF592_TYPEB_GATE_3_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
        end
    end
end

function SCR_UNDERF592_TYPEB_GATE_4_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
        end
    end
end

function SCR_UNDERF592_TYPEB_GATE_5_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
        end
    end
end

function SCR_UNDERF592_TYPEB_GATE_6_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        if IsBuffApplied(pc, 'UNDERF592_TYPEB_KINGVOICE') == 'YES' then
            local pass = IMCRandom(1111, 9999)
			local buff = GetBuffByName(pc, 'UNDERF592_TYPEB_OTP');
            SetBuffArg(pc, buff, 1, pass)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("UNDERF592_TYPEB_HEAD_SEL_PASS", "PASS", pass), 10)
        end
    end
end


function FE_UNDERF592_TYPEB_GATE_UPDATE(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_CONTROL >= 1 then
        return 1
    else
        local i
        local list, cnt = SelectObjectBySquare(self, 230, 210, "ALL")
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                RunScript('SCR_DUNGEON_WARP_NEAR', list[i], -952, 0, 328)
            end
        end
    end
end


function SCR_UNDERF592_ZEMINA_STATUE_DIALOG(self, pc)
    ZEMINA_STATUE_DIALOG(self, pc)
end


function SCR_UNDERF592_ZEMINA_STATUE_ENTER(self, pc)
    ZEMINA_STATUE_ENTER(self, pc)
end

function SCR_UNDERF592_ZEMINA_STATUE_LEAVE(self, pc)
    ZEMINA_STATUE_LEAVE(self, pc)
end



function UNDERF592_TYPEB_GATE_DEAD(self)
--    local zoneObj = GetLayerObject(self);
--    local pos = {}
--            pos[1] = {-1085.0679, 0.377, 601.87927}
--            pos[2] = {-1100.3621, 0.377, 705.6416}
--            pos[3] = {-1069.657, 0.377,	831.99274}
--            pos[4] = {-940.58087, 0.377, 604.30212}
--            pos[5] = {-818.21277, 0.377, 585.45801}
--            pos[6] = {-877.25952, 0.377, 809.68475}
--    local mon ={}
--    local i
--    for i = 1, 6 do
--        mon[i] = CREATE_MONSTER_EX(self, 'maggotegg_yellow', pos[i][1], pos[i][2], pos[i][3], 0, 'Monster', 0, UNDERF592_TYPEB_GATE_DEAD_RUN);
--    end
end

function UNDERF592_TYPEB_GATE_DEAD_RUN(mon)
    mon.Name = ScpArgMsg('UNDERF592_TYPEB_GATE_DEAD_RUN')
    mon.SimpleAI = 'UNDERF592_TYPEB_GATE_DEAD_RUN'
    mon.HPCount = 25
end


function UNDERF592_TYPEB_GATE_DEAD_RUN_AI(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_CONTROL == 0 then
        return 0
    end
    return 1
end

function UNDERF592_TYPEB_GATE_BUFF(self, sObj, msg, argObj, argStr, argNum)
    AddBuff(self, self, 'SSN_UNDERF592_TYPEB_BUFF', 1, 0, 0, 1)
    local ssn = GetSessionObject(self, 'SSN_UNDERF592_TYPEB')
    if ssn == nil then
        CreateSessionObject(self, 'SSN_UNDERF592_TYPEB', 1)
    end
end


function UNDERF592_TYPEB_GATE_CONTROL_AFTER(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_1 > 1 and zoneObj.UNDERF592_TYPEB_GATE_2 > 1 and zoneObj.UNDERF592_TYPEB_GATE_3 > 1 and zoneObj.UNDERF592_TYPEB_GATE_4 > 1 and zoneObj.UNDERF592_TYPEB_GATE_5 > 1 and zoneObj.UNDERF592_TYPEB_GATE_6 > 1 then
        local pos = {}
                pos[1] = {-954, 1, -928, 0}
                pos[2] = {-1059, 1, -692, 90}
                pos[3] = {-1058, 1, -239, 90}
                pos[4] = {-1059, 1, 187, 90}
                pos[5] = {-847, 1, 168, 90}
                pos[6] = {-838, 1, -698, 90}
        local mon ={}
        local i
        
        for i = 1, 6 do
            if zoneObj["UNDERF592_TYPEB_GATE_"..i] == 2 then
                mon[i] = CREATE_MONSTER_EX(self, 'Hiddennpc_move', pos[i][1], pos[i][2], pos[i][3], pos[i][4], 'Neutral', 1, UNDERF592_TYPEB_GATE_CONTROL_AFTER_MON, i);
                zoneObj["UNDERF592_TYPEB_GATE_"..i] = 3
            end
        end
    end
end

function UNDERF592_TYPEB_GATE_CONTROL_SPD(self)
	self.FIXMSPD_BM = 60
	InvalidateStates(self);
end

function UNDERF592_TYPEB_GATE_CONTROL_KILL_END(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_COUNT < 7 then
        zoneObj.UNDERF592_TYPEB_GATE_COUNT = zoneObj.UNDERF592_TYPEB_GATE_COUNT + 1
        Kill(self)
    end
end

function UNDERF592_TYPEB_GATE_CONTROL_AFTER_MON(mon, i)
    if i == 1 or i == 2 or i == 6 then
        mon.SimpleAI = 'UNDERF592_TYPEB_GATE_AFTER_1'
    elseif i == 3 then
        mon.SimpleAI = 'UNDERF592_TYPEB_GATE_AFTER_2'
    elseif i == 4 or i == 5 then
        mon.SimpleAI = 'UNDERF592_TYPEB_GATE_AFTER_3'
    end
    mon.Name = 'UnvisibleName'
end

function UNDERF592_TYPEB_GATE_FINAL(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_1 >= 1 and zoneObj.UNDERF592_TYPEB_GATE_2 >= 1 and zoneObj.UNDERF592_TYPEB_GATE_3 >= 1 and zoneObj.UNDERF592_TYPEB_GATE_4 >= 1 and zoneObj.UNDERF592_TYPEB_GATE_5 >= 1 and zoneObj.UNDERF592_TYPEB_GATE_6 >= 1 then
        if zoneObj.UNDERF592_TYPEB_GATE_COUNT >= 6 then
            local list, cnt = SelectObjectByClassName(self, 100, 'velniasp_block')
            local i
            for i = 1, cnt do
                Dead(list[i])
                zoneObj.UNDERF592_TYPEB_GATE_CONTROL = 1
                return
            end
        end
    end
end


function UNDERF592_TYPEB_GATE_CONTROL_AI(self)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_1 == 1 and zoneObj.UNDERF592_TYPEB_GATE_2 == 1 and zoneObj.UNDERF592_TYPEB_GATE_3 == 1 and zoneObj.UNDERF592_TYPEB_GATE_4 == 1 and zoneObj.UNDERF592_TYPEB_GATE_5 == 1 and zoneObj.UNDERF592_TYPEB_GATE_6 == 1 then
        return 1
    else
        local pos = {}
                pos[1] = {-954, 1, -928, 0}
                pos[2] = {-1059, 1, -692, 90}
                pos[3] = {-1058, 1, -239, 90}
                pos[4] = {-1059, 1, 187, 90}
                pos[5] = {-847, 1, 168, 90}
                pos[6] = {-838, 1, -698, 90}
        local mon ={}
        local i
        for i = 1, 6 do
            if zoneObj["UNDERF592_TYPEB_GATE_"..i] == 0 then
                mon[i] = CREATE_MONSTER_EX(self, 'velniasp_block', pos[i][1], pos[i][2], pos[i][3], pos[i][4], 'Neutral', 1, UNDERF592_TYPEB_GATE_i_RUN, i);
                zoneObj["UNDERF592_TYPEB_GATE_"..i] = zoneObj["UNDERF592_TYPEB_GATE_"..i] + 1
                
            end
        end
    end
end

function UNDERF592_TYPEB_GATE_i_RUN(mon, i)
    mon.SimpleAI = 'UNDERF592_TYPEB_GATE_BORN'
    mon.Enter = 'UNDERF592_TYPEB_GATE_'..i
    mon.Range = 80
end

function SCR_UNDERF592_TYPEB_ALTER_1_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_1 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_1 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end

function SCR_UNDERF592_TYPEB_ALTER_2_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_2 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_2 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end

function SCR_UNDERF592_TYPEB_ALTER_3_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_3 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_3 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end

function SCR_UNDERF592_TYPEB_ALTER_4_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_4 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_4 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end

function SCR_UNDERF592_TYPEB_ALTER_5_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_5 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_5 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end

function SCR_UNDERF592_TYPEB_ALTER_6_DIALOG(self, pc)
    local zoneObj = GetLayerObject(self);
    if zoneObj.UNDERF592_TYPEB_GATE_6 == 1 then
        PlayAnim(self, 'READY', 1)
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("UNDERF591_TYPEC_OBJ_1"), 'MAKING', 4)
        if result2 == 1 then
            zoneObj.UNDERF592_TYPEB_GATE_6 = 2
            SetFixAnim(self, 'EVENT_LOOP')
            return
        else
            SetFixAnim(self, 'OFF')
        end
        SetFixAnim(self, 'OFF')
    end
end








function UNDERF592_TYPEC_BOSS_GEN(self)
    local bossCnt = GetScpObjectList(self, 'UNDERF592_TYPEC_BOSS_GEN')
    if #bossCnt == 0 then
        local zon_Obj = GetLayerObject(self);
        if zon_Obj ~= nil then
            local BossGen = GetExProp(zon_Obj, 'UNDERF592_TYPEC_BOSS_GEN')
            if BossGen >= 0 and BossGen < 240 then
                SetExProp(zon_Obj, 'UNDERF592_TYPEC_BOSS_GEN', BossGen + 1)
            elseif BossGen == 240 then
                local boss
                local rnd_gen = IMCRandom(1, 4)
                if rnd_gen == 1 then
                    boss = CREATE_MONSTER_EX(self, 'FD_boss_Canceril', 39, 83, 1081, -135, 'Monster', 0, UNDERF592_TYPEC_BOSS_GEN_RUN)
                elseif rnd_gen == 2 then
                    boss = CREATE_MONSTER_EX(self, 'FD_boss_Canceril', 133, 0, 120, -135, 'Monster', 0, UNDERF592_TYPEC_BOSS_GEN_RUN)
                elseif rnd_gen == 3 then
                    boss = CREATE_MONSTER_EX(self, 'FD_boss_Canceril', -136, 0, -772, -135, 'Monster', 0, UNDERF592_TYPEC_BOSS_GEN_RUN)
                elseif rnd_gen == 4 then
                    boss = CREATE_MONSTER_EX(self, 'FD_boss_Canceril', 481, 0, -746, -135, 'Monster', 0, UNDERF592_TYPEC_BOSS_GEN_RUN)
                end
--                local boss = CREATE_MONSTER_EX(self, 'FD_boss_Canceril', 813, 87, 1170, -135, 'Monster', 0, UNDERF592_TYPEC_BOSS_GEN_RUN)
                AddScpObjectList(self, 'UNDERF592_TYPEC_BOSS_GEN', boss)
                EnableAIOutOfPC(boss)
            end
        end
    end
end


function UNDERF592_TYPEC_BOSS_GEN_RUN(mon)
    mon.SimpleAI = 'UNDERF592_TYPEA_BOSS'
end


function UNDERF592_TYPEC_BOSS_RESET(self)
    local zon_Obj = GetLayerObject(self);
    if zon_Obj ~= nil then
        SetExProp(zon_Obj, 'UNDERF592_TYPEC_BOSS_GEN', 0)
    end
end