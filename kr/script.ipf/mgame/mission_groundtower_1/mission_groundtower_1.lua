function G_TOWER_GO(self)
    MoveZone(self, 'mission_groundtower_1', 3213, 267, -6184)
end

--function G_TOWER_1_START(self)
--    RunMGame(self, "G_TOWER_1")
--end
--
--function G_TOWER_2_START(self)
--    RunMGame(self, "G_TOWER_2")
--end
--
--function G_TOWER_1_STAGE(self, num)
--    StartMGameStage(self, 'Stage'..num)
--end




function SCR_G_TOWER_WARP_TO_1_ENTER(self, pc)
    local stage = 1
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 3121, 146, -4792, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_2_ENTER(self, pc)
    local stage = 2
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 3278, 146, -2520, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_3_ENTER(self, pc)
    local stage = 3
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 3195, 147, -277, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_4_ENTER(self, pc)
    local stage = 4
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1',  3182, 146, 1733, 0, stage, 5) 
end

function SCR_G_TOWER_WARP_TO_5_ENTER(self, pc)
    local stage = 5
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 3069, 146, 3573, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_6_ENTER(self, pc)
    local stage = 6
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 437, 150, -4930, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_7_ENTER(self, pc)
    local stage = 7
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 380, 146, -2655, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_8_ENTER(self, pc)
    local stage = 8
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 377, 146, -349, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_9_ENTER(self, pc)
    local stage = 9
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 495, 146, 1662, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_10_ENTER(self, pc)
    local stage = 10
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 466, 146, 3611, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_11_ENTER(self, pc)
    local stage = 11
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2342, 147, -5097, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_12_ENTER(self, pc)
    local stage = 12
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2345, 147, -2594, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_13_ENTER(self, pc)
    local stage = 13
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2474, 147, -371, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_14_ENTER(self, pc)
    local stage = 14
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2299, 147, 1615, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_15_ENTER(self, pc)
    local stage = 15
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2111, 147, 3579, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_16_ENTER(self, pc)
    local stage = 16
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4913, 147, -4887, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_17_ENTER(self, pc)
    local stage = 17
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4990, 147, -2641, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_18_ENTER(self, pc)
    local stage = 18
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4567, 147, -384, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_19_ENTER(self, pc)
    local stage = 19
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4656, 147, 1606, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_20_ENTER(self, pc)
    local stage = 20
    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4536, 147, 3603, 0, stage, 5)
end

function SCR_G_TOWER_WARP_TO_SECOND_ENTER(self, pc)
    if IS_GT_PARTYLEADER(pc) ~= 1 then
        local isclear = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_20', 'GT20_CLEAR_1')
        if isclear == 1 then
            REQ_MOVE_TO_INDUN(pc, "M_GTOWER_2", 1);
        end
--        print("Not Leader")
        return
    end

    
    local select = ShowSelDlg(pc, 0, 'INSTANCE_GT_GROUNDTOWER_2', ScpArgMsg('INSTANCE_DUNGEON_MSG01'), ScpArgMsg('INSTANCE_DUNGEON_MSG02'))
    if select == 1 then
        SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_20', 'GT20_CLEAR_1', 1)
        local pc_list, pc_cnt = GetLayerPCList(self)
        if pc_cnt > 0 then
            local i
            for i = 1, pc_cnt do
                if IsSameActor(pc, pc_list[i]) == 'NO' then
                    SendAddOnMsg(pc_list[i], "NOTICE_Dm_move_to_point", ScpArgMsg("GT1_GT2_FOLLOW_LEADER_CLEAR"), 8);
                end
            end
        end
        REQ_MOVE_TO_INDUN(pc, "M_GTOWER_2", select);
    else
        return
    end
end

--function SCR_G_TOWER_WARP_TO_LOBBY2_ENTER(self, pc)
--    local stage = 1
--    SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 3213, 267, -6184)
--end







function GT_STAGE_7_PAD(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, 0, 'Neutral', 1, GT_STAGE_7_PAD_RUN)
    AddScpObjectList(self, 'GT_STAGE_7_PAD_OBJ', mon)
    AddScpObjectList(mon, 'GT_STAGE_7_PAD_OBJ', self)
    HoverAroundAccurately(mon, self, 200, 1, 0.05, 1)
end

function GT_STAGE_7_PAD_RUN(mon)
    mon.Name = 'UnvisibleName'
    mon.SimpleAI = 'GT_STAGE_7_PAD_AI'
end


function GT_STAGE_7_PAD_CNT(self)
    local owner = GetScpObjectList(self, 'GT_STAGE_7_PAD_OBJ')
    if #owner == 0 then
        Kill(self)
    end
    local value = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_7', 'GT_STAGE_7_PAD')
    if value >= 150 then
        Kill(self)
    end
    local list, cnt = SelectObjectByFaction(self, 100, 'Law')
    if cnt == 0 then
        --Chat(self, value+1, 2)
        SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_7', 'GT_STAGE_7_PAD', value + 1)
    elseif cnt > 0 then
        --Chat(self, value+cnt, 2)
        SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_7', 'GT_STAGE_7_PAD', value + cnt)
    end
end




function GT_STAGE_4_PAD_REVERSI(self)

    if GetHpPercent(self) < 0.5 then
        return 0
    end
	local x, y, z = GetPos(self)
	local list = SelectPad(self, 'ALL', x, y, z, 400);
	if #list > 0 then
	    local pad1 = list[1];
	    if IsSameObject(GetPadOwner(pad1), self) ~= 1 and GetRelation(self, GetPadOwner(pad1)) == "ENEMY" then 
    	    local x1, y1, z1 = GetPadPos(pad1)
    	    if SCR_POINT_DISTANCE(x, z, x1, z1) > 100 then
    	        CancelMonsterSkill(self)
    	        MoveEx(self, x1, y, z1, 10)
    	        return 1
    	    else
            	for i = 1 , #list do
            		local pad = list[i];
        			SetPadParent(pad, self, 1)
            	end
            end
        else
            return 0
        end
    else
        return 0
    end
	return 1
end



function GT_STAGE_8_KNOCKBACK(self)
    local list = GetScpObjectList(self, 'GT_STAGE_8_PC')
    if #list > 0 then
        local dist = GetDistance(list[1], self)
        if dist > 15 then
            MoveToTarget(self, list[1], 5)
        else
            GT_STAGE_8_KNOCKBACK_RUN(self)
        end
    else
        local list, cnt = SelectObjectByClassName(self, 500, 'PC')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                AddScpObjectList(self, 'GT_STAGE_8_PC', list[i])
                break
            end
        end
    end
end


function GT_STAGE_8_KNOCKBACK_RUN(self)
    local list, cnt = SelectObjectByFaction(self, 100, 'Law')
    if cnt > 0  then
        local i
        for i = 1, cnt do
            PlayEffect(self, 'F_spread_out028_dark_violet', 1)
            KnockDown(list[i], self, 150, GetAngleTo(self, list[i]), 45, 1)
        end
        if self.NumArg4 < 10 then
            self.NumArg4 = self.NumArg4 + 1
        elseif self.NumArg4 >= 10 then
            Kill(self)
        end
    end
end



function GT_STAGE_9_GROUND(self)
    local list, cnt = SelectObjectByFaction(self, 135, 'Law')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            TakeDamage(self, list[i], "None", list[i].MHP*0.05, "Poison", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
        end
    end
end


function SCR_GT_STAGE_9_GROUND_T_ENTER(self, pc)
    if self.NumArg4 == 0 then
        self.NumArg4 = 1
        if pc.ClassName == 'PC' then
            local list, cnt = GetLayerPCList(self)
            if cnt > 0 then
                local i
                for i = 1, cnt do
                    RunScript('GT_STAGE_9_GROUND_T_RUN', list[i])
                end
                Kill(self)
            end
        end
    end
end

function GT_STAGE_9_GROUND_T_RUN(pc)
    AttachEffect(pc, 'F_pc_warp_circle', 1)
    sleep(1000)
    SetPos(pc, 176, 245, 1991)
end




function GT_STAGE_12_MISSILE(self)
    local isclear = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_12', 'CLEAR_12')
    if isclear == 1 then
        Kill(self)
        return
    end
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, GT_STAGE_12_MISSILE_SET);
end

function GT_STAGE_12_MISSILE_SET(mon)
    mon.SimpleAI = 'GT_STAGE_12_MISSILE'
    mon.Name = 'UnvisibleName'
end

function GT_STAGE_12_MISSILE_AI_1(self)

    local isclear = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_12', 'CLEAR_12')
    if isclear == 1 then
        Kill(self)
        return
    end
    if self.NumArg4 == 0 then
        local list, cnt = SelectObjectByClassName(self, 100, 'star_sphere_01')
        if cnt > 0 then
            if list[1] ~= nil then
                local i
--                for i = 1 , 2 do
--                    if list[1] ~= nil and IsDead(list[1]) == 0 then
                        TakeDamage(self, list[1], "None", 1, "Melee", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
--                    end
--                end
                self.NumArg4 = 1
                Kill(self)
            end
        else
            Kill(self)
        end
    else
        Kill(self)
    end
end


function GT_STAGE_13_DAMAGE(self, from, skill, damage, ret)
	if skill.ClassName == "Wizard_ReflectShield" then
		ret.Damage = 0
		return
	end
    if IsBuffApplied(from, 'GT_STAGE_13_DAMAGE_BUFF') == 'NO' then		
		TakeTrueDamage(self, from, "None", 7000, HIT_POISON, HITRESULT_BLOW);
        if from.ClassName == 'PC' then
            SendAddOnMsg(from, "NOTICE_Dm_!", ScpArgMsg("GT_STAGE_13_DAMAGE"), 5);
        end
    end
end



function GT_STAGE_14_PAD_1(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_0', 'None', x, y, z, 90, 1)
end

function GT_STAGE_14_PAD_2(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_45', 'None', x, y, z, 135, 1)
end

function GT_STAGE_14_PAD_3(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_90', 'None', x, y, z, 180, 1)
end

function GT_STAGE_14_PAD_4(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_135', 'None', x, y, z, -135, 1)
end

function GT_STAGE_14_PAD_5(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_180', 'None', x, y, z, -90, 1)
end

function GT_STAGE_14_PAD_6(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_225', 'None', x, y, z, -45, 1)
end

function GT_STAGE_14_PAD_7(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_270', 'None', x, y, z, 0, 1)
end

function GT_STAGE_14_PAD_8(self)
    local x, y, z = GetPos(self)
    RunPad(self, 'GPAD_GT_GTAGE13_315', 'None', x, y, z, 45, 1)
end



function GT_STAGE_17_CREATE_MON(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, GT_STAGE_17_CREATE_MON_RUN);
end

function GT_STAGE_17_CREATE_MON_RUN(mon)
    mon.SimpleAI = 'GT_STAGE_17_CREATE_MON_AI'
    mon.Name = 'UnvisibleName'
end

function GT_STAGE_17_CREATE_MON_AI_1(self)
    
    local obj = GetScpObjectList(self, 'GT_STAGE_17_OBJ')
    
    if #obj == 0 then
        
        local list, cnt = SelectObjectByFaction(self, 600, 'Law')
        
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    AddScpObjectList(self, 'GT_STAGE_17_OBJ', list[i])
                    return 1
                end
            end
            for i = 1, cnt do
                if list[i].ClassName == 'PC' then
                
                    AddScpObjectList(self, 'GT_STAGE_17_OBJ', list[i])
                    return 1
                end
            end
        end
    else
        return 0
    end
end


function GT_STAGE_17_CREATE_MON_AI_2(self)
    local obj = GetScpObjectList(self, 'GT_STAGE_17_OBJ')
    if #obj > 0 then
        if GetHpPercent(obj[1]) > 0.3 then
            MoveToTarget(self, obj[1], 1)
        else
            ClearScpObjectList(self, 'GT_STAGE_17_OBJ')
        end
    end
    
    local list, cnt = SelectObject(self, 50, 'ALL')
    
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                TakeDamage(self, list[i], "None", list[i].MHP*0.01, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
            end
        end
    end
end


function SCR_GT_STAGE_19_SPDRAIN_ENTER(self, pc)
    if pc.ClassName == 'PC' then
        AddBuff(self, pc, 'GT_STAGE_19_SPDRAIN_DEF', 1, 0, 15000, 1)
        Kill(self)
    end
end

function GT_STAGE_19_SPDRAIN(self)
    if self.NumArg4 < 12 then
        self.NumArg4 = self.NumArg4 + 1
        return 0
    elseif self.NumArg4 >= 12 then
        self.NumArg4 = 0
        local list, cnt = GetLayerPCList(self)
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if IsBuffApplied(list[i], 'GT_STAGE_19_SPDRAIN_DEF') == 'YES' then
                    local over_stack = GetBuffOver(list[i], 'GT_STAGE_19_SPDRAIN_DEF') 
                    local stack = 10 - over_stack
                    PlayEffect(list[i], 'F_lineup022_violet', 1)
                    AddSP(list[i], -(list[i].MSP*0.02*stack))
                else
                    PlayEffect(list[i], 'F_lineup022_violet', 1)
                    AddSP(list[i], -(list[i].MSP*0.2))
                end
            end
        end
    end
    return 0
end


--function GT_STAGE_18_RUMBLE(self)
--    local list, cnt = GetLayerPCList(self)
--    if cnt > 0 then
--        
--    end
--    local list, cnt = SelectObjectByClassName(self, 800, 'ET_spell_suppressors')
--    local obj = {}
--    if cnt > 0 then
--        local i
--        for i = 1, cnt do
--            if IsSameObject(self, list[i]) == 0 then
--                obj[i] = list[i]
--            end
--        end
--    end
--    if #obj > 1 then
--        local select_ball = IMCRandom(1, #obj)
--        local x, y, z = GetPos(self)
--        local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, GT_STAGE_18_RUMBLE_RUN);
--        AddScpObjectList(mon, 'GT_STAGE_18_RUMBLE', obj[select_ball])
--    end
--end



function GT_STAGE_18_RUMBLE_RUN_MON(self)
    local list = GetScpObjectList(self, 'GT_STAGE_18_FOLLOWER')
    if #list > 0 then
        local x, y, z = GetPos(self)
        if GetDistance(self, list[1]) > 15 then
            MoveToTarget(self, list[1], 1)
        else
            Kill(self)
        end
    else
        Kill(self)
    end
end




function GT_STAGE_18_FOLLOWER(self)
    local list = GetScpObjectList(self, 'GT_STAGE_18_FOLLOWER')
    if #list > 0 then
        return 0
    end
    if self.NumArg4 < 60 then
        self.NumArg4 = self.NumArg4 + 1
        return 0
    else
        self.NumArg4 = 0 
        local list, cnt = SelectObjectByClassName(self, 800, 'ET_spell_suppressors')
        if cnt > 0 then
            local i
            local mon = {}
            local x
            local y
            local z
            for i = 1, cnt do
                x, y, z = GetPos(list[i])
                mon[i] = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, GT_STAGE_18_FOLLOWER_RUN);
                AddScpObjectList(self, 'GT_STAGE_18_FOLLOWER', mon[i])
                AddScpObjectList(mon[i], 'GT_STAGE_18_FOLLOWER', self)
            end
            return 0
        end
    end
end

function GT_STAGE_18_FOLLOWER_1(self)
    local list = GetScpObjectList(self, 'GT_STAGE_18_FOLLOWER')
    if #list == 0 then
        self.NumArg3 = 0
        return 0
    end    
    if self.NumArg3 == 0 then
        self.NumArg3 = 1
        PlayEffect(self, 'F_spread_out028_dark_fire', 1)
        local list, cnt = SelectObjectByFaction(self, 150, 'Law')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                PlayEffect(list[i], 'F_burstup029_smoke_dark2', 1)
                TakeDamage(self, list[i], "None", 1000, "Dark", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
            end
        end
    elseif self.NumArg3 > 0 and self.NumArg3 < 10 then
        self.NumArg3 = self.NumArg3 + 1
    elseif self.NumArg3 >= 10 then
        self.NumArg3 = 0
    end
    return 0
end


function GT_STAGE_18_FOLLOWER_RUN(mon)
    mon.SimpleAI = 'GT_STAGE_18_RUMBLE_AI'
    mon.Name = ScpArgMsg("GT_STAGE_18_RUMBLE")
end




function GT_STAGE_4_POINT_PLUS(self)

    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4')
--    local list, cnt = SelectObjectByClassName(self, 500, 'PC')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if GetDistance(self, pc_list[i]) < 420 then
                if IsDead(pc_list[i]) == 0 then
                    result1 = result1 + 1
                end
            end
        end
    end
    local final_result = result1
--    local final_result = 5
    
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4', value1 + final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4')
    

    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_scroll", ScpArgMsg("GT_STAGE_4_POINT_PLUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end

function GT_STAGE_4_POINT_MINUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 5 - pc_cnt
    local result2 = 0
--    local list, cnt = SelectObjectByClassName(self, 500, 'PC')
    if pc_cnt > 0 then
        for i = 1 , pc_cnt do
            if IsDead(pc_list[i]) == 1 or GetDistance(self, pc_list[i]) > 420 then
                result2 = result2 + 1
            end
        end
    end
    local final_result = result1*5 + result2*3
    if final_result == 0 then
        return
    end
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4', value1 - final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_4', 'GT_STAGE_POINT_4')
    if value2 <= 0 then
        value2 = 0
    end
    if pc_cnt > 0 then
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_!", ScpArgMsg("GT_STAGE_4_POINT_MINUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end



function GT_STAGE_9_POINT_PLUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if GetDistance(self, pc_list[i]) < 420 then
                if IsDead(pc_list[i]) == 0 then
                    result1 = result1 + 1
                end
            end
        end
    end
    local final_result = result1
--    local final_result = 5
    
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9', value1 + final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9')
    

    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_scroll", ScpArgMsg("GT_STAGE_9_POINT_PLUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end

function GT_STAGE_9_POINT_MINUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 5 - pc_cnt
    local result2 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if IsDead(pc_list[i]) == 1 or GetDistance(self, pc_list[i]) > 420 then
                result2 = result2 + 1
            end
        end
    end
    local final_result = result1*5 + result2*3
    if final_result == 0 then
        return
    end
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9', value1 - final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_9', 'GT_STAGE_POINT_9')
    if value2 <= 0 then
        value2 = 0
    end
    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_!", ScpArgMsg("GT_STAGE_9_POINT_MINUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end




function GT_STAGE_14_POINT_PLUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if GetDistance(self, pc_list[i]) < 420 then
                if IsDead(pc_list[i]) == 0 then
                    result1 = result1 + 1
                end
            end
        end
    end
    local final_result = result1
--    local final_result = 5
    
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14', value1 + final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14')
    

    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_scroll", ScpArgMsg("GT_STAGE_14_POINT_PLUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end

function GT_STAGE_14_POINT_MINUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 5 - pc_cnt
    local result2 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if IsDead(pc_list[i]) == 1 or GetDistance(self, pc_list[i]) > 420 then
                result2 = result2 + 1
            end
        end
    end
    local final_result = result1*5 + result2*3
    if final_result == 0 then
        return
    end
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14', value1 - final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_14', 'GT_STAGE_POINT_14')
    if value2 <= 0 then
        value2 = 0
    end
    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_!", ScpArgMsg("GT_STAGE_14_POINT_MINUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end



function GT_STAGE_19_POINT_PLUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if GetDistance(self, pc_list[i]) < 420 then
                if IsDead(pc_list[i]) == 0 then
                    result1 = result1 + 1
                end
            end
        end
    end
    local final_result = result1
--    local final_result = 5
    
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19', value1 + final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19')
    

    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_scroll", ScpArgMsg("GT_STAGE_19_POINT_PLUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end

function GT_STAGE_19_POINT_MINUS(self)
    local value1 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19')
    local pc_list, pc_cnt = GetLayerPCList(self)
    local result1 = 5 - pc_cnt
    local result2 = 0
    if pc_cnt > 0 then
        local i
        for i = 1 , pc_cnt do
            if IsDead(pc_list[i]) == 1 or GetDistance(self, pc_list[i]) > 420 then
                result2 = result2 + 1
            end
        end
    end
    local final_result = result1*5 + result2*3
    if final_result == 0 then
        return
    end
    SetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19', value1 - final_result)
    local value2 = GetMGameValueByMGameName(self, 'M_GTOWER_STAGE_19', 'GT_STAGE_POINT_19')
    if value2 <= 0 then
        value2 = 0
    end
    if pc_cnt > 0 then
        local j
        for j = 1, pc_cnt do
            SendAddOnMsg(pc_list[j], "NOTICE_Dm_!", ScpArgMsg("GT_STAGE_19_POINT_MINUS_1").."{nl}( "..value2.." )", 6);
        end
    end
end


function GT_STAGE_16_DISPELL(self)
    local list, cnt = SelectObjectByFaction(self, 100, 'Monster')
    if cnt > 0 then
        if self.NumArg4 < 10 then
            self.NumArg4 = self.NumArg4 + 1
            return 0
        else
            self.NumArg4 = 0
            local i
            AttachEffect(self, 'F_spread_out028_dark_violet', 4, 'MID')
            for i = 1, cnt do
                PlayEffect(list[i], 'F_buff_basic030_mint_line', 0.4)
                RemoveAllDeBuffList(list[i])
            end
        end
    else
        return 0
    end
end


--function GT_STAGE20_TOLL_GIVE_CK(self)
--    local ishavetoll = GetInvItemCount(self, 'misc_earthTower20_toll')
--    if ishavetoll == 0 then
--        RunScript('GIVE_TAKE_ITEM_TX', self, 'misc_earthTower20_toll/1', nil, 'GroundTower_1')
--    else
--        return
--    end
--end


function GT_INCOUNT_COMPARE_RUN(self)

    local P_list, P_cnt = GET_PARTY_ACTOR(self, 0)
    local add = 0
    if P_cnt > 0 then
        local i
        for i = 1, P_cnt do
        	local etcObj = GetETCObject(P_list[i]);
        	if etcObj == nil then
        		return
        	end
        	local Pc_Class = GetClassByStrProp("Indun", "ClassName", "M_GTOWER_1")
        	local GroundTower_Limit_Count = Pc_Class.PlayPerReset
        	if IsPremiumState(P_list[i], ITEM_TOKEN) == 1 then
                GroundTower_Limit_Count = Pc_Class.PlayPerReset + Pc_Class.PlayPerReset_Token
            end
        	local GroundTower_CurrentCount = etcObj.InDunCountType_400
        	local Compare_Count = GroundTower_Limit_Count - GroundTower_CurrentCount
        	if Compare_Count <= 0 then
                add = add + 1
        	end
	    end
        if add > 0 then
            i = 1
            for i = 1, P_cnt do
                SendAddOnMsg(P_list[i], "NOTICE_Dm_!", ScpArgMsg("GT_INCOUNT_COMPARE_1"), 6);
            end
        else
            return
        end
    end
end

function GT_INCOUNT_COMPARE_COND_OUT(cmd, curStage, eventInst, obj)
    
    local P_list, P_cnt = GetCmdPCList(cmd:GetThisPointer());
    local add = 0
    if P_cnt > 0 then
        local i
        for i = 1, P_cnt do
        	local etcObj = GetETCObject(P_list[i]);
        	if etcObj == nil then
        		return 0;
        	end
        	local Pc_Class = GetClassByStrProp("Indun", "ClassName", "M_GTOWER_1")
        	local GroundTower_Limit_Count = Pc_Class.PlayPerReset
        	if IsPremiumState(P_list[i], ITEM_TOKEN) == 1 then
                GroundTower_Limit_Count = Pc_Class.PlayPerReset + Pc_Class.PlayPerReset_Token
            end
        	local GroundTower_CurrentCount = etcObj.InDunCountType_400
        	local Compare_Count = GroundTower_Limit_Count - GroundTower_CurrentCount
        	if Compare_Count <= 0 then
        	    add = add + 1
        	end
	    end
        if add > 0 then
            return 1
        else
            return 0
        end
        return 0
    end
end


function GT_INCOUNT_COMPARE_COND_CHECK(cmd, curStage, eventInst, obj)
    local P_list, P_cnt = GetCmdPCList(cmd:GetThisPointer());
    local add = 0
    if P_cnt > 0 then
        local i
        for i = 1, P_cnt do
        	local etcObj = GetETCObject(P_list[i]);
        	if etcObj == nil then
        		return 0;
        	end
        	local Pc_Class = GetClassByStrProp("Indun", "ClassName", "M_GTOWER_1")
        	local GroundTower_Limit_Count = Pc_Class.PlayPerReset
        	if IsPremiumState(P_list[i], ITEM_TOKEN) == 1 then
                GroundTower_Limit_Count = Pc_Class.PlayPerReset + Pc_Class.PlayPerReset_Token
            end
        	local GroundTower_CurrentCount = etcObj.InDunCountType_400
        	local Compare_Count = GroundTower_Limit_Count - GroundTower_CurrentCount
        	if Compare_Count <= 0 then
        	    add = add + 1
        	end
	    end
        if add > 0 then
            return 0
        else
            return 1
        end
        return 1
    end
end