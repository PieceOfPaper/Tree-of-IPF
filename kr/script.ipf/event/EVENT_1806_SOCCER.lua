function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_BORN_ENTER(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_BORN_UPDATE(self)
    local nowSec = math.floor(os.clock())
    local x,y,z = GetPos(self)
    
    if self.NumArg2 >= 10 and y >= 10 then
        local strarg1 = TryGetProp(self, 'StrArg1')
        if strarg1 == 'ball1' or strarg1 == 'ball2' then
            SetCurrentFaction(self, 'Peaceful')
            RunScript('EVENT_1806_SOCCER_BALL_HOLD',self)
            if strarg1 == 'ball1' then
                SetPos(self, -70, 0, 70)
            elseif strarg1 == 'ball2' then
                SetPos(self, 70, 0, -70)
            end
        end
    end
    if self.NumArg1 ~= nowSec then
        self.NumArg1 = nowSec
        self.NumArg2 = self.NumArg2 + 1
    end
end

function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_BALL_TS_DEAD_LEAVE(self)
end



function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_BORN_ENTER(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_BORN_UPDATE(self)
    local channel = GetChannelID(self)
    if channel == 1 then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        local sec = now_time['sec']
        
        local msgTime = GetExProp(self, 'ALLMSG_TIME')
        if hour == 19 and min == 50 and sec >= 30 then
            if msgTime ~= 50 then
                SetExProp(self, 'ALLMSG_TIME', 50)
                ToAll(ScpArgMsg('EVENT_1806_SOCCER_MSG11'))
            end
        elseif hour == 19 and min == 55 and sec >= 30 then
            if msgTime ~= 55 then
                SetExProp(self, 'ALLMSG_TIME', 55)
                ToAll(ScpArgMsg('EVENT_1806_SOCCER_MSG12'))
            end
        elseif hour == 20 and min == 0 and sec >= 30 then
            if msgTime ~= 60 then
                SetExProp(self, 'ALLMSG_TIME', 60)
                ToAll(ScpArgMsg('EVENT_1806_SOCCER_MSG13'))
            end
        end
    end
end

function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1806_NUMBER_GAMES_NPC_TS_DEAD_LEAVE(self)
end

function SCR_EVENT_1806_SOCCER_NPC_RANK(self, pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    
    local typeName = 'SOCCER_MISSION_S1'
    if SCR_DATE_TO_YHOUR_BASIC_2000(year, month, day, hour) >= SCR_DATE_TO_YHOUR_BASIC_2000(2018, 6, 28, 6) then
        typeName = 'SOCCER_MISSION_S2'
    end
    
    SEND_REDIS_RANKING_INFO(pc, ScpArgMsg('EVENT_1806_SOCCER_MSG8'), 'EVENT_1806_SOCCER', typeName, 1, 10, 0);
end

function SCR_EVENT_1806_SOCCER_NPC_START(self, pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    
    local partyObj = GetPartyObj(pc)
    if partyObj ~= nil then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('CannotUseInParty'), 5);
        return
    end
    
    local lv = 50
    if pc.Lv < lv then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('EVENT_1806_SOCCER_MSG10','LV',lv), 5);
        return
    end
    
    local pet = GetSummonedPet(pc);
    if pet == nil or pet == "None" then 
    else 
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('EVENT_1806_SOCCER_MSG14'), 5);
        return
    end
    
    if hour < 20 or hour > 21 then
        ShowOkDlg(pc, 'EVENT_1806_NUMBER_GAMES_DLG1\\'..ScpArgMsg("EVENT_1806_SOCCER_MSG7"), 1)
        return
    end
    
    INDUN_ENTER_DIALOG_AND_UI(pc, nil, 'EVENT_1806_SOCCER', 1, 0, 0, 0)
end

function SCR_BUFF_ENTER_EVENT_1806_SOCCER_SETTING_BUFF(self, buff, arg1, arg2, over)
    AddInstSkill(self, "Event_Kick_Weak")
    AddInstSkill(self, "Event_Kick_Normal")
    AddInstSkill(self, "Event_Kick_powerful")
    AddLimitationSkillList(self, "Event_Kick_Weak")
    AddLimitationSkillList(self, "Event_Kick_Normal")
    AddLimitationSkillList(self, "Event_Kick_powerful")
    EnableItemUse(self, 0)
    SendSkillQuickSlot(self, 1, 'Event_Kick_Weak', 'Event_Kick_Normal', 'Event_Kick_powerful')
--    SendSkillQuickSlot(self, 1, 'Normal_Attack', 'Hammer_Attack', 'Normal_Attack_TH')
    EnablePreviewSkillRange(self, 1)
    
    self.FIXMSPD_BM = 50
    Invalidate(self, 'MSPD');
end

function SCR_BUFF_UPDATE_EVENT_1806_SOCCER_SETTING_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1806_SOCCER_SETTING_BUFF(self, buff, arg1, arg2, over)
    SendSkillQuickSlot(self, 0)
    ClearLimitationSkillList(self);
    EnableItemUse(self, 1)
    EnablePreviewSkillRange(self, 0);
    self.FIXMSPD_BM = 0
    Invalidate(self, 'MSPD');
end

function EVENT_1806_MISSION_INIT(zoneObj, mGame, pcList)
    if #pcList > 0 then
        for i = 1, #pcList do
            local pc = pcList[i]
            local faction = GetCurrentFaction(pc)
            local aid = GetPcAIDStr(pc)
            if faction ~= 'Team_1_Soccer' and faction ~= 'Team_2_Soccer' then
                local flag = 0
                for i2 = 1, 3 do
                    local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                    local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                    if team1Aid == aid then
                        SetCurrentFaction(pc, 'Team_1_Soccer')
                        AddBuff(pc,pc,'EVENT_1806_SOCCER_SETTING_BUFF')
                        AttachEffect(pc, 'F_pc_football_ground_red_triangle', 2, "BOT")
                        flag = 1
                        break
                    elseif team2Aid == aid then
                        SetCurrentFaction(pc, 'Team_2_Soccer')
                        AddBuff(pc,pc,'EVENT_1806_SOCCER_SETTING_BUFF')
                        AttachEffect(pc, 'F_pc_football_ground_blue', 2, "BOT")
                        flag = 1
                        break
                    end
                end
                
                if flag == 0 then
                    for i2 = 1, 3 do
                        local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                        local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                        if team1Aid == nil or team1Aid == 'None' then
                            SetExProp_Str(zoneObj, "Team_1_"..i2, aid)
                            SetCurrentFaction(pc, 'Team_1_Soccer')
                            AddBuff(pc,pc,'EVENT_1806_SOCCER_SETTING_BUFF')
                            AttachEffect(pc, 'F_pc_football_ground_red_triangle', 2, "BOT")
                            break
                        elseif team2Aid == nil or team2Aid == 'None' then
                            SetExProp_Str(zoneObj, "Team_2_"..i2, aid)
                            SetCurrentFaction(pc, 'Team_2_Soccer')
                            AddBuff(pc,pc,'EVENT_1806_SOCCER_SETTING_BUFF')
                            AttachEffect(pc, 'F_pc_football_ground_blue', 2, "BOT")
                            break
                        end
                    end
                end
            end
        end
    end
end




function EVENT_1806_SOCCER_BALL_HOLD(self)
    sleep(3000)
    SetCurrentFaction(self, 'Monster')
end

function SCR_EVENT_1806_SOCCER_START_POS_SET(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local team1PosList = {{-180,0,40},{-70,0,-70},{40,0,-180}}
    local team2PosList = {{-40,0,180},{70,0,70},{180,0,-40}}
    local zoneObj
    for i = 1 , cnt do
        local pc = list[i];
        local aid = GetPcAIDStr(pc)
        if zoneObj == nil then
            zoneObj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc))
        end
	    if zoneObj ~= nil then
    	    for i2 = 1, 3 do
                local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                if team1Aid == aid then
                    SetPos(pc, team1PosList[i2][1],team1PosList[i2][2],team1PosList[i2][3])
                    break
                elseif team2Aid == aid then
                    SetPos(pc, team2PosList[i2][1],team2PosList[i2][2],team2PosList[i2][3])
                    break
                end
            end
        end
    end
end

function SCR_EVENT_1806_SOCCER_END_MSG(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local goal1 = cmd:GetUserValue("TeamGoal1")
    local goal2 = cmd:GetUserValue("TeamGoal2")
    if cnt > 0 then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local nowday = year..':'..month..':'..day
        
        local addMsg = ''
        if goal1 > goal2 then
            addMsg = ScpArgMsg("EVENT_1806_SOCCER_MSG3")
        elseif goal1 < goal2 then
            addMsg = ScpArgMsg("EVENT_1806_SOCCER_MSG4")
        elseif goal1 == goal2 then
            addMsg = ScpArgMsg("EVENT_1806_SOCCER_MSG5")
        end
        local zoneObj
        for i = 1 , cnt do
            local pc = list[i];
            
            local aObj = GetAccountObj(pc)
            if aObj ~= nil then
                if aObj.EVENT_1806_SOCCER_REWARD_DATE ~= nowday then
                    RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', pc, 'Point_Stone_100/2', nil, nil, nil,'EVENT_1806_SOCCER', 'ACCOUNT/EVENT_1806_SOCCER_REWARD_DATE/'..nowday)
                end
            end
            
            local aid = GetPcAIDStr(pc)
            local value = 0
            if zoneObj == nil then
                zoneObj = GetLayerObject(GetZoneInstID(pc), GetLayer(pc))
            end
    	    if zoneObj ~= nil then
        	    for i2 = 1, 3 do
                    local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                    local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                    if team1Aid == aid then
                        value = GetExProp(zoneObj, "Team_1_Goal_"..i2)
                    elseif team2Aid == aid then
                        value = GetExProp(zoneObj, "Team_2_Goal_"..i2)
                    end
                    if value == nil then
                        value = 0
                    end
                end
            end
            if value > 0 then
                local typeName = 'SOCCER_MISSION_S1'
                if SCR_DATE_TO_YHOUR_BASIC_2000(year, month, day, hour) >= SCR_DATE_TO_YHOUR_BASIC_2000(2018, 6, 28, 6) then
                    typeName = 'SOCCER_MISSION_S2'
                end
                SaveRedisPropValue(pc, 'EVENT_1806_SOCCER', typeName, aid, value, 1, 1)
                SCR_EVENT_1806_SOCCER_GOAL_LOG('GAMEEND',cmd,aid,typeName,value)
            end
--            RemoveBuff(pc,'EVENT_1806_SOCCER_SETTING_BUFF')
            PlaySoundLocal(pc, 'sys_confirm')
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_SOCCER_MSG2",'PCGOAL',value,'TEAM1GOAL',goal1,'TEAM2GOAL',goal2)..addMsg, 10);
            
        end
    end
end

function SCR_EVENT_1806_SOCCER_GOAL_MSG(cmd, curStage, eventInst, obj, goalPC)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local goal1 = cmd:GetUserValue("TeamGoal1")
    local goal2 = cmd:GetUserValue("TeamGoal2")
    local addMsg = ''
    if goalPC ~= nil and goalPC ~= '' then
        addMsg = ScpArgMsg("EVENT_1806_SOCCER_MSG9",'PCNAME',goalPC)
    end
    if cnt > 0 then
        for i = 1 , cnt do
            local pc = list[i];
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_SOCCER_MSG1",'TEAM1GOAL',goal1,'TEAM2GOAL',goal2)..addMsg, 10);
        end
    end
end


function SCR_EVENT_1806_SOCCER_GOAL1_TS_BORN_ENTER(self)
end

function SCR_EVENT_1806_SOCCER_GOAL1_TS_BORN_UPDATE(self)
    local objList, objCount = SelectObjectBySquareCoor(self, "ALL", -328, 0, -280, -278, 0, -327, 27, 75, nil, 0, 1);
    local cmd = GetMGameCmd(self)
    local checkEnd = cmd:GetUserValue("GoalCheckEnd")
    if checkEnd ~= 1 then
        for i = 1, objCount do
            local npc = objList[i]
            local strarg1 = TryGetProp(npc, 'StrArg1')
            if strarg1 == 'ball1' or strarg1 == 'ball2' then
                local objList, objCnt = GetWorldObjectList(self, 'PC', 200)
                if objCnt > 0 then
                    PlaySound(objList[1], 'quest_success_3')
                end
                
                SetCurrentFaction(npc, 'Peaceful')
                RunScript('EVENT_1806_SOCCER_BALL_HOLD',npc)
                if strarg1 == 'ball1' then
                    SetPos(npc, -70, 0, 70)
                elseif strarg1 == 'ball2' then
                    SetPos(npc, 70, 0, -70)
                end
            	local goal2Value = cmd:GetUserValue("TeamGoal2")
            	cmd:SetUserValue("TeamGoal2", goal2Value + 1)
            	
            	local attackAid = GetExProp_Str(npc, "LastAttacker")
            	local attackName = GetExProp_Str(npc, "LastAttackerTeamName")
            	
            	if attackAid ~= nil and attackAid ~= 'None' then
            	    local zoneObj = GetLayerObject(GetZoneInstID(npc), GetLayer(npc))
            	    if zoneObj ~= nil then
                	    for i2 = 1, 3 do
                            local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                            local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                            if team1Aid == attackAid then
                                break
                            elseif team2Aid == attackAid then
                                local value = GetExProp(zoneObj, "Team_2_Goal_"..i2)
                                SetExProp(zoneObj, "Team_2_Goal_"..i2, value + 1)
                                SCR_EVENT_1806_SOCCER_GOAL_LOG('ADD',cmd,attackAid)
                            	SCR_EVENT_1806_SOCCER_GOAL_MSG(cmd, nil,nil,nil,attackName)
                                break
                            end
                        end
                    end
            	end
            end
        end
    end
end

function SCR_EVENT_1806_SOCCER_GOAL1_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1806_SOCCER_GOAL1_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1806_SOCCER_GOAL1_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1806_SOCCER_GOAL1_TS_DEAD_LEAVE(self)
end


function SCR_EVENT_1806_SOCCER_GOAL2_TS_BORN_ENTER(self)
end

function SCR_EVENT_1806_SOCCER_GOAL2_TS_BORN_UPDATE(self)
    local objList, objCount = SelectObjectBySquareCoor(self, "ALL", 281, 0, 330, 329, 0, 280, 27, 75, nil, 0, 1);
    local cmd = GetMGameCmd(self)
    local checkEnd = cmd:GetUserValue("GoalCheckEnd")
    if checkEnd ~= 1 then
        for i = 1, objCount do
            local npc = objList[i]
            local strarg1 = TryGetProp(npc, 'StrArg1')
            if strarg1 == 'ball1' or strarg1 == 'ball2' then
                local objList, objCnt = GetWorldObjectList(self, 'PC', 200)
                if objCnt > 0 then
                    PlaySound(objList[1], 'quest_success_3')
                end
                
                SetCurrentFaction(npc, 'Peaceful')
                RunScript('EVENT_1806_SOCCER_BALL_HOLD',npc)
                if strarg1 == 'ball1' then
                    SetPos(npc, -70, 0, 70)
                elseif strarg1 == 'ball2' then
                    SetPos(npc, 70, 0, -70)
                end
            	local goal1Value = cmd:GetUserValue("TeamGoal1")
            	cmd:SetUserValue("TeamGoal1", goal1Value + 1)
            	
            	local attackAid = GetExProp_Str(npc, "LastAttacker")
            	local attackName = GetExProp_Str(npc, "LastAttackerTeamName")
            	if attackAid ~= nil and attackAid ~= 'None' then
            	    local zoneObj = GetLayerObject(GetZoneInstID(npc), GetLayer(npc))
            	    if zoneObj ~= nil then
                	    for i2 = 1, 3 do
                            local team1Aid = GetExProp_Str(zoneObj, "Team_1_"..i2)
                            local team2Aid = GetExProp_Str(zoneObj, "Team_2_"..i2)
                            if team1Aid == attackAid then
                                local value = GetExProp(zoneObj, "Team_1_Goal_"..i2)
                                SetExProp(zoneObj, "Team_1_Goal_"..i2, value + 1)
                                SCR_EVENT_1806_SOCCER_GOAL_LOG('ADD',cmd,attackAid)
                            	SCR_EVENT_1806_SOCCER_GOAL_MSG(cmd, nil,nil,nil,attackName)
                                break
                            elseif team2Aid == attackAid then
                                break
                            end
                        end
                    end
            	end
            end
        end
    end
end

function SCR_EVENT_1806_SOCCER_GOAL2_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1806_SOCCER_GOAL2_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1806_SOCCER_GOAL2_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1806_SOCCER_GOAL2_TS_DEAD_LEAVE(self)
end


function SCR_EVENT_1806_SOCCER_GOAL_LOG(inputType,cmd,targetAid,rankType,value)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1 , cnt do
        local pc = list[i]
        local pcAid = GetPcAIDStr(pc)
        if pcAid == targetAid then
            if inputType == 'ADD' then
                CustomMongoLog(pc, "EVENT_1806_SOCCER", "Type", "AddGoal", "GoalValue", 1);
            elseif inputType == 'GAMEEND' then
                CustomMongoLog(pc, "EVENT_1806_SOCCER", "Type", "GameEnd","RankType",rankType, "GoalValue", value);
            end
            break
        end
    end
end

function SCR_EVENT_1806_SOCCER_ATTACKMONSTER(self, sObj, monster, sklName)
    if GetZoneName(self) == 'f_playground' then
        if monster ~= nil then
            local strarg1 = TryGetProp(monster, 'StrArg1')
            if strarg1 == 'ball1' or strarg1 == 'ball2' then
                Heal(monster,1,0)
                local aid = GetPcAIDStr(self)
                SetExProp_Str(monster, "LastAttacker", aid)
                SetExProp_Str(monster, "LastAttackerTeamName", GetTeamName(self))
                monster.NumArg2 = 0
                local angle = GetAngleTo(self,monster);
                if sklName == 'Event_Kick_Weak' then
                    PlaySound(self, 'event_soccer_kick')
                    KnockDown(monster, self, 30, angle, 25, 1)
                elseif sklName == 'Event_Kick_Normal' then
                    PlaySound(self, 'event_soccer_kick')
                    KnockDown(monster, self, 180, angle, 35, 1)
                elseif sklName == 'Event_Kick_powerful' then
                    PlaySound(self, 'event_soccer_kick_cri')
                    KnockDown(monster, self, 250, angle, 35, 1)
                end
            end
        end
    end
end
