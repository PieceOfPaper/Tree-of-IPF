function SCR_EVENT_1806_PENALTY_NPC_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1806_PENALTY_DLG2', ScpArgMsg('EVENT_1806_PENALTY_MSG8'), ScpArgMsg('MONSTER_PAIR_AGREE'), ScpArgMsg('No'))
    if select == 1 then
        local season, ranklist = SCR_SEASON_TIME_CHECK()
        SEND_REDIS_RANKING_INFO(pc, ScpArgMsg('EVENT_1806_PENALTY_MSG8'), 'EventFootBall', ranklist, 1, 10, 0);
    elseif select == 2 then
        if pc.Lv < 50 then
            ShowOkDlg(pc, 'EVENT_1806_PENALTY_DLG2\\'..ScpArgMsg('EVENT_1801_ORB_MSG8','LV',50), 1)
            return
        end
        
        local zoneInst = GetZoneInstID(pc);
        local layer = GetNewLayerByZoneID(zoneInst)
        SetLayer(pc, layer, 0)
        SCR_USE_PENALTY_SHOOT(self,pc)
    end
end

function SCR_USE_PENALTY_SHOOT(self, pc)
--    AddBuff(pc, pc, 'EVENT_1806_PENALTY_BUFF', 1, 0, 600000, 1);

--    local x, y, z = GetFrontPos(pc, 200);

	
    local keeper = CREATE_NPC(pc, "npc_keeper_event", -644, 241, 599, 0, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil, "KEEPER_NPC");
	if keeper == nil then
		return 1;
    else
        SetExArgObject(pc, 'PENALTY_KEEPER', keeper)
        SetDirectionByAngle(pc, 90)
        --SetLifeTime(keeper, 60);
	end

    local end_npc = CREATE_NPC(pc, "HiddenTrigger", -644, 241, 599, 135, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil, "PENALTY_END");
    if end_npc ~= nil then
        SetExArgObject(end_npc, 'PENALTY_PC', pc)
    end
    
    local soccer_goals = CREATE_NPC(pc, "playground_goalpost", -703.4, 246, 614.4, -45, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil)
	if soccer_goals == nil then
		return 1;
    else
        SetExArgObject(soccer_goals, 'PENALTY_PC', pc)
        CreateSessionObject(soccer_goals, 'SSN_PENALTY_GOALPOST')
        local wall1 = CREATE_NPC(pc, "npc_soccer_goals_event", -726, 241, 640, 135, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil)
        local wall2 = CREATE_NPC(pc, "npc_soccer_goals_wall1", -729, 241, 586, 225, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil)
        local wall3 = CREATE_NPC(pc, "npc_soccer_goals_wall1", -676, 241, 639, 225, "Neutral", GetLayer(pc), nil, nil, nil, 0, 1, nil)
	end
	
    local ball = CREATE_NPC(pc, "npc_soccer_ball", -601, 241, 506, 135, "Neutral", GetLayer(pc), nil, "GOAL_KICK", nil, 0, 1, nil);
    if ball ~= nil then
        SetExArgObject(pc, 'PENALTY_BALL', ball)
        ball.StrArg1 = 'BallNPC'
    end
    
    local board = CREATE_NPC(pc, "Board1", -634, 241, 437, 325, "Neutral", GetLayer(pc), ScpArgMsg('EVENT_1806_PENALTY_MSG7'), "PENALTY_SHOOT_END", nil, 0, 1, nil);
    
    local zoneInst = GetZoneInstID(pc);
    local layer = GetLayer(pc);
    local layerObj = GetLayerObject(zoneInst, layer);

    SetExProp(layerObj, "1806_PENALTY_END", 0);
    SetExProp(layerObj, "GOAL_COUNT", 0);
    SetExProp(layerObj, "Ball_Count", 0);
    
    
    AddInstSkill(pc, "Event_Kick_Weak")
    AddLimitationSkillList(pc, "Event_Kick_Weak")
    SendSkillQuickSlot(pc, 1, 'Event_Kick_Weak')
    
    SetPos(pc, -593, 241, 496)
end

-- keeper
function SCR_KEEPER_NPC_TS_BORN_ENTER(self)
    AddHitScript(self, "FIREBALL_MON_HIT");
    AddBuff(self, self, 'MoveSpeed', 0.5)
    SetDirectionByAngle(self, 90)
end

function SCR_KEEPER_NPC_TS_BORN_UPDATE(self)
    local pos = {
        {-693, 241, 550},
        {-644, 241, 599}
    }
    
    local zoneInst = GetZoneInstID(self);
    local layer = GetLayer(self);
    local layerObj = GetLayerObject(zoneInst, layer);
    
    local Goal_Count = GetExProp(layerObj, "GOAL_COUNT");
    if math.floor(Goal_Count/5) >= 3 then
        pos[#pos + 1] = {-674, 241, 578}
    end
    if math.floor(Goal_Count/5) >= 7 then
        pos[#pos + 1] = {-657, 241, 589}
        pos[#pos + 1] = {-669, 241, 551}
        pos[#pos + 1] = {-665, 241, 547}
        pos[#pos + 1] = {-650, 241, 552}
    end
    if math.floor(Goal_Count/5) >= 12 then
        pos[#pos + 1] = {-655, 241, 566}
        pos[#pos + 1] = {-648, 241, 572}
        pos[#pos + 1] = {-643, 241, 577}
        pos[#pos + 1] = {-652, 241, 567}
    end

    local move = IMCRandom(1, 30)

    if IsMoving(self) == 0 or move == 1 then
        local rand = IMCRandom(1, #pos)
        MoveEx(self, pos[rand][1], pos[rand][2], pos[rand][3], 1);
    end

    
    if GetExProp(layerObj, "1806_PENALTY_END") == 1 then
        Kill(self)
    end
end

function SCR_KEEPER_NPC_TS_BORN_LEAVE(self)
end

function SCR_KEEPER_NPC_TS_DEAD_ENTER(self)
end

function SCR_KEEPER_NPC_TS_DEAD_UPDATE(self)
end

function SCR_KEEPER_NPC_TS_DEAD_LEAVE(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_BORN_ENTER(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_BORN_UPDATE(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_BORN_LEAVE(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_DEAD_ENTER(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_DEAD_UPDATE(self)
end

function SCR_Event_1806_Soccer_Ball_Item_TS_DEAD_LEAVE(self)
end

function SCR_SOCCER_ZONE_TS_BORN_LEAVE(self)
end

function SCR_SOCCER_ZONE_TS_DEAD_ENTER(self)
end

function SCR_SOCCER_ZONE_TS_DEAD_UPDATE(self)
end

function SCR_SOCCER_ZONE_TS_DEAD_LEAVE(self)
end

-- end
function SCR_PENALTY_END_TS_BORN_ENTER(self)
end

function SCR_PENALTY_END_TS_BORN_UPDATE(self)
    local nowSec = math.floor(os.clock())
    if self.NumArg4 == nowSec then
        return
    else
        self.NumArg4 = math.floor(os.clock())
    end
    
    local zoneInst = GetZoneInstID(self);
    local layer = GetLayer(self);
    local layerObj = GetLayerObject(zoneInst, layer);
    local Ball_Count = GetExProp(layerObj, "Ball_Count");
    local list, cnt = GetLayerPCList(zoneInst, layer);
    
    if (Ball_Count ~= 0) and self.NumArg1 >= 3 then
        
        for i = 1, cnt do
            if list[i] ~= nil then
                PENALTY_SHOOT_END_FUNC(list[i])
                
                break;
            end
        end
        
        Kill(self)
        self.NumArg1 = 0
    elseif Ball_Count ~= 0 then
        self.NumArg1 = self.NumArg1 + 1
        self.NumArg3 = 0
    elseif Ball_Count == 0 then
        self.NumArg1 = 0
        self.NumArg3 = self.NumArg3 + 1
        local pc = GetExArgObject(self, 'PENALTY_PC')
        if pc ~= nil then
            local ball = GetExArgObject(pc, 'PENALTY_BALL')
            if ball == nil then
                local ball = CREATE_NPC(self, "npc_soccer_ball", -601, 241, 506, 135, "Neutral", GetLayer(self), nil, "GOAL_KICK", nil, 0, 1, nil);
                if ball ~= nil then
                    SetExArgObject(pc, 'PENALTY_BALL', ball)
                    ball.StrArg1 = 'BallNPC'
                end
            end
        end

        if self.NumArg3 >= 60 then
            for j = 1, cnt do
                PENALTY_SHOOT_END_FUNC(list[j])
                break
            end
        end
    end
end

function SCR_PENALTY_END_TS_BORN_LEAVE(self)
end

function SCR_PENALTY_END_TS_DEAD_ENTER(self)
end

function SCR_PENALTY_END_TS_DEAD_UPDATE(self)
end

function SCR_PENALTY_END_TS_DEAD_LEAVE(self)
end

function PENALTY_SHOOT_END_FUNC(pc)
    local zoneInst = GetZoneInstID(pc);
    local layer = GetLayer(pc);
    local layerObj = GetLayerObject(zoneInst, layer);
    
    local season, ranklist = SCR_SEASON_TIME_CHECK()
    local Goal_Count = GetExProp(layerObj, "GOAL_COUNT");
    if Goal_Count >= 3 then
        local aObj = GetAccountObj(pc)
        local now_time = os.date('*t')
        local yday = now_time['yday'] 

        if aObj.EV1806_PENALTY_REWARD ~= yday then
            RunScript("SCR_FOOTBALL_PENALTY_REWARD", pc, season, aObj, yday)
        end
    end
    local aid = GetPcAIDStr(pc)
    SaveRedisPropValue(pc, 'EventFootBall', ranklist, aid, Goal_Count, 0, 1)
    CustomMongoLog(pc, "EVENT_1806_PENALTY_GOAL", "GOAL_COUNT", Goal_Count)
    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('EVENT_1806_PENALTY_MSG3', "GOAL", Goal_Count), 5)
    PlaySoundLocal(pc, 'sys_confirm')
    SetExProp(layerObj, "1806_PENALTY_END", 1);
--                RemoveBuff(list[i], 'EVENT_1806_PENALTY_BUFF')
    SendSkillQuickSlot(pc, 0)
    ClearLimitationSkillList(pc);
    SetLayer(pc, 0)
end

function SCR_PENALTY_SHOOT_END_DIALOG(self,pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1806_PENALTY_DLG1', ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select == 1 then
        PENALTY_SHOOT_END_FUNC(pc)
    end
end

-- reward
function SCR_FOOTBALL_PENALTY_REWARD(pc, season, aObj, yday)
    
    local rewardList = {{{'Mic',3,750},
                        {'Drug_MSPD2_1h_NR',2,500},
                        {'Ability_Point_Stone_500',1,1000},
                        {'Drug_RedApple20',5,1000},
                        {'Drug_BlueApple20',5,1000},
                        {'Moru_Silver',2,750},
                        {'Drug_Event_Looting_Potion_14d',2,1300},
                        {'misc_gemExpStone_randomQuest4_14d',1,1000},
                        {'Get_Wet_Card_Book_14d',1,1200},
                        {'legend_reinforce_card_lv1',1,500},
                        {'EventFootBall_350Arm_1',1,500},
                        {'EventFootBall_350Arm_2',1,250},
                        {'artefact_trophy_soccer', 1, 250}
                    },
                    {{'Mic',3,750},
                        {'Ability_Point_Stone_500',1,1000},
                        {'EVENT_1712_SECOND_CHALLENG_14d',1,1250},
                        {'Premium_dungeoncount_Event',1,1000},
                        {'food_022',2,1250},
                        {'Premium_indunReset_1add_14d',1,1000},
                        {'misc_gemExpStone_randomQuest4_14d',1,750},
                        {'Get_Wet_Card_Book_14d',1,750},
                        {'Event_Goddess_Statue',1,1250},
                        {'EventFootBall_350Wep_1',1,500},
                        {'EventFootBall_350Wep_2',1,250},
                        {'artefact_trophy_soccer', 1, 250}
                    }}
    local itemList = rewardList[season]
    local maxRate = 0
    for i = 1, #itemList do
        maxRate = maxRate + itemList[i][3]
    end
    
    local rand = IMCRandom(1, maxRate)
    local targetIndex = 0
    local accRate = 0
    
    for i = 1, #itemList do
        accRate = accRate + itemList[i][3]
        if rand <= accRate then
            targetIndex = i
            break
        end
    end
    local tx = TxBegin(pc);
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], '1806_FOOTBALL_PENALTY');
    TxSetIESProp(tx, aObj, 'EV1806_PENALTY_REWARD', yday)
	local ret = TxCommit(tx);
	
--	if ret == 'SUCCESS' then
--        SCR_SEND_NOTIFY_REWARD(pc, ScpArgMsg('EVENT_1806_PENALTY_MSG6'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
--	end
end

-- season time
function SCR_SEASON_TIME_CHECK()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    
    local typeName = 'Penalty_Goal_1'
    local season = 1
    if SCR_DATE_TO_YHOUR_BASIC_2000(year, month, day, hour) >= SCR_DATE_TO_YHOUR_BASIC_2000(2018, 6, 28, 6) then
        season = 2
        typeName = 'Penalty_Goal_2'
    end
    return season, typeName
end 


-- goal kick
function SCR_GOAL_KICK_DIALOG(self, pc)
    if GetExProp(self, "KICK_FLAG") ~= 1 then
        SetPos(pc, -593, 241, 496)
        SetDirectionByAngle(pc, 135)
    
        local startSec = 0
        local ball_direction = 1
        while 1 do
            startSec = math.floor(os.clock() * 10)
            ball_direction = DOTIMEACTION_R(pc, ScpArgMsg("EVENT_1806_PENALTY_MSG2"), 'ASTD', 2)
            if ball_direction ~= 1 then
                break
            end
        end
        
        local ball_direction_value = math.floor(os.clock() * 10) - startSec
    
        knockdownAngle = 170 - math.floor(ball_direction_value * 3)
        
        PlaySoundLocal(pc, 'event_soccer_kick_cri')
        KnockDown(self, pc , 350, knockdownAngle, 25, 1)
        SetExProp(self, "KICK_FLAG", 1);
        
        local zoneInst = GetZoneInstID(pc);
        local layer = GetLayer(pc);
        local layerObj = GetLayerObject(zoneInst, layer);
        SetExProp(layerObj, "Ball_Count", 1);
    end
end


function SCR_SSN_PENALTY_GOALPOST_HOOK(self, sObj)
	SetTimeSessionObject(self, sObj, 1, 200, 'SCR_SSN_PENALTY_GOALPOST_SETTIME')
end
function SCR_CREATE_SSN_PENALTY_GOALPOST(self, sObj)
	SCR_SSN_PENALTY_GOALPOST_HOOK(self, sObj)
end

function SCR_REENTER_SSN_PENALTY_GOALPOST(self, sObj)
	SCR_SSN_PENALTY_GOALPOST_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_PENALTY_GOALPOST(self, sObj)
end

function SCR_SSN_PENALTY_GOALPOST_SETTIME(self, sObj, remainTime)
    local objList, objCount = SelectObjectBySquareCoor(self, "ALL", -734, 241, 602, -687, 241, 646, 30, 1000, nil, 0, 1);
    local zoneInst = GetZoneInstID(self);
    local layer = GetLayer(self);
    local layerObj = GetLayerObject(zoneInst, layer);

    for i = 1, objCount do
--        if objList[i].ClassName == 'npc_soccer_ball' then
        if objList[i].ClassName ~= 'PC' and TryGetProp(objList[i], 'StrArg1', 'None') == 'BallNPC' then
            local Goal_Count = GetExProp(layerObj, "GOAL_COUNT");

            SetExProp(layerObj, "GOAL_COUNT", Goal_Count + 1);
            SetExProp(layerObj, "Ball_Count", 0);
            PlayEffect(self, "F_fireworks001", 1)
            PlayEffect(self, "F_fireworks002", 1)
            
            
            local pc = GetExArgObject(self, 'PENALTY_PC')
            if pc ~= nil then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('EVENT_1806_PENALTY_MSG4', "GOAL", GetExProp(layerObj, "GOAL_COUNT")), 5)
                PlaySoundLocal(pc, 'quest_success_3')
                local keeper = GetExArgObject(pc, 'PENALTY_KEEPER')
                if keeper ~= nil then
                    local tarSpeed = math.floor(Goal_Count*5)/100 + 0.5
                    if tarSpeed > 1.2 then
                        tarSpeed = 1.2
                    end
                    local speed = GetExProp(keeper,'KEEPER_SPEED')
                    if tarSpeed >= speed then
                        RemoveBuff(keeper, 'MoveSpeed')
                        AddBuff(keeper, keeper, 'MoveSpeed', tarSpeed)
                        SetExProp(keeper,'KEEPER_SPEED',tarSpeed)
                    end
                end
            end
            
            Kill(objList[i])
        end
    end

    if GetExProp(layerObj, "1806_PENALTY_END") == 1 then
        Kill(self)
    end
end