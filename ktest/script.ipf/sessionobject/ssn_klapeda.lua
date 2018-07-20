-- ssn_klapeda.lua

function SCR_CREATE_SSN_KLAPEDA(self, sObj)
    
	SCR_REENTER_SSN_KLAPEDA(self, sObj)

end

function SCR_REENTER_SSN_KLAPEDA(self, sObj)
	RegisterHookMsg(self, sObj, "ZoneEnter", "SCR_SSN_KLAPEDA_ZoneEner", "YES");
	RegisterHookMsg(self, sObj, "GetItem", "SCR_SSN_KLAPEDA_GetItem", "YES");
	RegisterHookMsg(self, sObj, "KillMonster", "SCR_SSN_KLAPEDA_KillMonster", "YES");
	RegisterHookMsg(self, sObj, "KillMonster_PARTY", "SCR_SSN_KLAPEDA_KillMonster_PARTY", "YES");
	RegisterHookMsg(self, sObj, "AttackMonster", "SCR_BASIC_AttackMonster", "YES");
	RegisterHookMsg(self, sObj, "TakeDamage", "SCR_BASIC_TakeDamage", "YES");
	RegisterHookMsg(self, sObj, "OverKill", "SCR_BASIC_OverKill", "YES");
	RegisterHookMsg(self, sObj, "Dead", "SCR_BASIC_Dead", "YES");
--    RegisterHookMsg(self, sObj, "Logout", "SCR_SSN_KLAPEDA_Logout", "NO");
    RegisterHookMsg(self, sObj, "SetLayer", "SCR_SSN_KLAPEDA_SetLayer", "YES");
    if IsPVPServer(self) ~= 1 then
        SetTimeSessionObject(self, sObj, 1, 30000, 'SCR_SSN_KLAPEDA_SETTIME_1')
    end
    
    -- EVENT_1804_ARBOR
    RegisterHookMsg(self, sObj, "EnterTrigger", "EVENT_1804_ARBOR_NPCEnter", "YES");

    --EVENT_1712_SECOND
--    SetTimeSessionObject(self, sObj, 2, 60000, 'SCR_SSN_KLAPEDA_EVENT_1712_SECOND','YES')

    --EVENT_1712_XMAS
--    SetTimeSessionObject(self, sObj, 3, 60000, 'SCR_SSN_KLAPEDA_EVENT_1712_XMAS','YES')
    
    
    --EVENT_1705_CORSAIR
--    SetTimeSessionObject(self, sObj, 1, 60000, 'SCR_EVENT_1705_CORSAIR_ALARM','YES')
    
	RegisterHookMsg(self, sObj, "PartyMemberOut", "SCR_BASIC_PartyMemberOut", "YES");
	RegisterHookMsg(self, sObj, "PartyJoin", "SCR_SSN_PARTY_JOIN", "YES");
	RegisterHookMsg(self, sObj, "PartyCreate", "SCR_SSN_PARTY_CREATE", "YES");
--    SetTimeSessionObject(self, sObj, 2, 10000, 'SCR_SSN_KLAPEDA_CITYATTACK_BOSS')

--    if IsPVPServer(self) ~= 1 then
--        SetTimeSessionObject(self, sObj, 3, 60000, 'SCR_SSN_KLAPEDA_PLAYTIMEEVENT')
--    end

--    if IsPVPServer(self) ~= 1 then
--        SetTimeSessionObject(self, sObj, 2, 60000, 'SCR_SSN_KLAPEDA_DAYCHECK_EVENT')
--    end
    if IsPVPServer(self) ~= 1 then
        RegisterHookMsg(self, sObj, "LevelUp", "SCR_SSN_KLAPEDA_LevelUp", "YES");
    end
    
    -- CHUSEOK_EVENT
--    sObj.CHUSEOK_MON_NOKILL_TIEM = 0
--    sObj.CHUSEOK_MON_KILL_TIEM = 0
--	if IS_BASIC_FIELD_DUNGEON(self) == 'YES' then
--        SetTimeSessionObject(self, sObj, 2, 3000, "SCR_CHUSEOK_EVENT_TIMER")
--        SetTimeSessionObject(self, sObj, 3, 10000, "SCR_CHUSEOK_EVENT_BATTLE_CHECK")
--    end
    if GetZoneName(self) ~= 'd_castle_agario' then
        local itemCount = GetInvItemCount(self, "AGARIO_CANDY_DUNGEON"); 
        if itemCount > 0 then
            RunScript('TAKE_ITEM_TX', self, 'AGARIO_CANDY_DUNGEON', itemCount, "AGARIO_OUT_ITEM_TAKE")
        end
    else
	    local list, cnt = GetLayerMonList(GetZoneInstID(self), GetLayer(self));
	    local i
	    local agario_trigger
        for i = 1, cnt do
            if list[i].SimpleAI == 'AGARIO_TRIGGER' then
                agario_trigger = list[i]
                SetExArgObject(self, 'AGARIO_AI', list[i])
                break
            end
        end
        
        if agario_trigger == nil then
--            SCR_PRINT_FUNC(self, 'NOT FIND TRIGGER NPC')
            MoveZone(self, 'c_Klaipe', -574, 241, 492);
        else
            local agario_start = GetExProp(agario_trigger, 'AGARIO_START')
            local aObj = GetAccountObj(self)
            local now_time = os.date('*t')
            local year = now_time['year']
            local month = now_time['month']
            local day = now_time['day']
            local hour = now_time['hour']
            local min = now_time['min']
            local nowDay = year..'/'..month..'/'..day
            local nowHour = year..'/'..month..'/'..day..'/'..hour
            local itemCount = GetInvItemCount(self, "AGARIO_CANDY_DUNGEON"); 
            local partyObj = GetPartyObj(self)
            local basicGiveCount = 10
            if AGARIO_ITEMCHECK(self) == 0 and partyObj == nil then
                if agario_start == 1 then
                    if nowDay ~= aObj.AGARIO_DAY_CHECK then -- 오늘 최초 입장(리셋)
                        local tx = TxBegin(self)
                        TxSetIESProp(tx, aObj, 'AGARIO_DAY_CHECK', nowDay); -- 입장 날짜 등록
                        TxSetIESProp(tx, aObj, 'AGARIO_COUNT', 1); --입장 횟수 초기화
                        TxSetIESProp(tx, aObj, 'AGARIO_HOUR_CHECK', nowHour); -- 입장 시간 등록
                        TxSetIESProp(tx, aObj, 'AGARIO_CHANGE_COUNT', 0); --교환 횟수 초기화
                        TxSetIESProp(tx, aObj, 'AGARIO_NAME_CHECK', GetPcCIDStr(self)); --입장 캐릭터 등록
                        TxSetIESProp(tx, aObj, 'AGARIO_HOUR_ENTER_COUNT', 1)
                        TxGiveItem(tx, 'AGARIO_CANDY_DUNGEON', basicGiveCount, 'AGARIO_ENTER');
                        local ret = TxCommit(tx)
                        if ret == "SUCCESS" then
                            AddBuff(self, self, 'AGARIO_BUFF', 1, 0, 0, 1);
                        else
--                            SCR_PRINT_FUNC(self, 'ZONE ENTER TX FAILE TYPE 1')
                            MoveZone(self, 'c_Klaipe', -574, 241, 492);
                        end
                    else
                        if nowHour == aObj.AGARIO_HOUR_CHECK then -- 재입장이면
                            if aObj.AGARIO_HOUR_ENTER_COUNT < 3 then
                                local tx = TxBegin(self)
                                TxSetIESProp(tx, aObj, 'AGARIO_NAME_CHECK', GetPcCIDStr(self)); --입장 캐릭터 등록
                                TxSetIESProp(tx, aObj, 'AGARIO_HOUR_ENTER_COUNT', aObj.AGARIO_HOUR_ENTER_COUNT + 1)
                                TxGiveItem(tx, 'AGARIO_CANDY_DUNGEON', basicGiveCount, 'AGARIO_ENTER');
                                local ret = TxCommit(tx)
                                if ret == "SUCCESS" then
                                    AddBuff(self, self, 'AGARIO_BUFF', 1, 0, 0, 1);
                                else
--                                    SCR_PRINT_FUNC(self, 'ZONE ENTER TX FAILE TYPE 2')
                                    MoveZone(self, 'c_Klaipe', -574, 241, 492);
                                end
                            else
--                                    SCR_PRINT_FUNC(self, 'ZONE ENTER SAME HOUR MAX COUNT OVER')
                                MoveZone(self, 'c_Klaipe', -574, 241, 492);
                            end
                        else
                            if aObj.AGARIO_COUNT < 3 then -- 정규입장(카운트 증가)
--                            if aObj.AGARIO_COUNT < 9999 then -- 정규입장(카운트 증가)
                                local tx = TxBegin(self)
                                TxSetIESProp(tx, aObj, 'AGARIO_COUNT', aObj.AGARIO_COUNT + 1); --입장 횟수 증가
                                TxSetIESProp(tx, aObj, 'AGARIO_HOUR_CHECK', nowHour); -- 입장 시간 등록
                                TxSetIESProp(tx, aObj, 'AGARIO_CHANGE_COUNT', 0); --교환 횟수 초기화
                                TxSetIESProp(tx, aObj, 'AGARIO_NAME_CHECK', GetPcCIDStr(self)); --입장 캐릭터 등록
                                TxSetIESProp(tx, aObj, 'AGARIO_HOUR_ENTER_COUNT', 1)
                                TxGiveItem(tx, 'AGARIO_CANDY_DUNGEON', basicGiveCount, 'AGARIO_ENTER');
                                local ret = TxCommit(tx)
                                if ret == "SUCCESS" then
                                    AddBuff(self, self, 'AGARIO_BUFF', 1, 0, 0, 1);
                                else
--                                    SCR_PRINT_FUNC(self, 'ZONE ENTER TX FAILE TYPE 3')
                                    MoveZone(self, 'c_Klaipe', -574, 241, 492);
                                end
                            else
--                                SCR_PRINT_FUNC(self, 'ZONE ENTER COUNT OVER COUNT :'..aObj.AGARIO_COUNT..' LAST HOUR :'..aObj.AGARIO_HOUR_CHECK)
                                MoveZone(self, 'c_Klaipe', -574, 241, 492);
                            end
                        end
                    end
                else
--                    SCR_PRINT_FUNC(self, 'ZONE ENTER MINIGAMES NOT START')
                    MoveZone(self, 'c_Klaipe', -574, 241, 492);
                end
            else
--                SCR_PRINT_FUNC(self, 'ZONE ENTER EQUIPITEM :'..AGARIO_ITEMCHECK(self)..' PARTYOBJ :'..partyObj)
                MoveZone(self, 'c_Klaipe', -574, 241, 492);
            end
        end
    end

    SCR_PVP_MINE_GETBUFF(self)
end

function SCR_DESTROY_SSN_KLAPEDA(self, sObj)
	
end

--function SCR_CHUSEOK_EVENT_MONKILL(self, sObj, msg, argObj, argStr, argNum)
--       local monFaction = GetCurrentFaction(argObj)
--       if GetLayer(self) ~= 0 then
--        return
--    end
--    if monFaction ~= 'Monster' and monFaction ~= 'Monster_Chaos1' and monFaction ~= 'Monster_Chaos2' and monFaction ~= 'Monster_Chaos3' and monFaction ~= 'Monster_Chaos4' then
--        return
--    end
--    
--    sObj.CHUSEOK_MON_TIME = sObj.CHUSEOK_MON_TIME - 0.1
--    sObj.CHUSEOK_MON_KILL = sObj.CHUSEOK_MON_KILL + 1
--end

--function SCR_CHUSEOK_EVENT_BATTLE_CHECK(self, sObj, remainTime)
--    if sObj.CHUSEOK_MON_KILL > 0 then
--        sObj.CHUSEOK_MON_KILL_TIEM = sObj.CHUSEOK_MON_KILL_TIEM + 1
--    else
--        sObj.CHUSEOK_MON_NOKILL_TIEM = sObj.CHUSEOK_MON_NOKILL_TIEM + 1
--    end
--    sObj.CHUSEOK_MON_KILL = 0
--end
--
--function SCR_CHUSEOK_EVENT_TIMER(self, sObj, remainTime)
--    if GetLayer(self) ~= 0 then
--        return
--    end
--    
--    local countTimeBasic = GetClassNumber('SessionObject', sObj.ClassName, 'CHUSEOK_MON_TIME')
--    
--    if sObj.CHUSEOK_CURRENTZONE ~= GetZoneName(self) then
--        sObj.CHUSEOK_MON_TIME = countTimeBasic
--        sObj.CHUSEOK_CURRENTZONE = GetZoneName(self)
--    end
--    
--    local timeMin = 2100
--    local timeMax = 2500
----    local timeMin = 15
----    local timeMax = 25
--    
--    if countTimeBasic >= sObj.CHUSEOK_MON_TIME then
--        sObj.CHUSEOK_MON_TIME = IMCRandom(timeMin, timeMax)
--    end
--    
--    --time counting
--    if IsBattleState(self) == 1 then
--        sObj.CHUSEOK_MON_TIME  = sObj.CHUSEOK_MON_TIME - 3
--    end
--    
--    if sObj.CHUSEOK_MON_TIME > countTimeBasic and sObj.CHUSEOK_MON_TIME <= 0 then
--        --create summon trigger
--        if sObj.CHUSEOK_MON_KILL_TIEM/(sObj.CHUSEOK_MON_KILL_TIEM + sObj.CHUSEOK_MON_NOKILL_TIEM) < 0.2 then
--            sObj.CHUSEOK_MON_TIME = math.floor(IMCRandom(timeMin, timeMax)/2)
--            sObj.CHUSEOK_MON_KILL_TIEM = 0
--            sObj.CHUSEOK_MON_NOKILL_TIEM = 0
--        else
--            local pos_list = SCR_CELLGENPOS_LIST(self, 'Front1', 0)
--            local mon = CREATE_MONSTER(self, 'Treasure_Goblin', pos_list[1][1], pos_list[1][2], pos_list[1][3], nil, nil, 0, 1, nil, ScpArgMsg('CHUSEOK_EVENT_MON_NAME'), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 5)
--            if mon ~= nil then
--                sObj.CHUSEOK_MON_TIME = countTimeBasic
--                sObj.CHUSEOK_MON_KILL_TIEM = 0
--                sObj.CHUSEOK_MON_NOKILL_TIEM = 0
--            end
--        end
--    end
--end

function SCR_SSN_KLAPEDA_LevelUp(self, sObj, msg, argObj, argStr, lv)
    RunScript('SCR_SSN_KLAPEDA_LevelUp_Sub',self, sObj, msg, argObj, argStr, lv)
end

function SCR_SSN_KLAPEDA_LevelUp_Sub(self, sObj, msg, argObj, argStr, lv)
    local giveItemList = {}
    local sObjInfo_set = {}
    local itemText = ''
    
    
--    if IsPremiumState(self, NEXON_PC) == 1 then
--        if GetPropType(sObj, 'NEXON_PC_REWARD_HISTORY') ~= nil then
--            local lvUpEventItemList = {{40,{"Moru_Silver",1}},
--                                        {75,{"Moru_Silver",1}},
--                                        {120,{"Moru_Silver",2}},
--                                        {170,{"Moru_Silver",3}}
--                                        }
--            for i = 1, #lvUpEventItemList do
--                if self.BeforeLv < lvUpEventItemList[i][1] and lvUpEventItemList[i][1] <= lv then
--                    local historyList = SCR_STRING_CUT(sObj.NEXON_PC_REWARD_HISTORY)
--                    if table.find(historyList, tostring(lv)) == 0 then
--                        for i2 = 2, #lvUpEventItemList[i] do
--                            giveItemList[#giveItemList + 1] = lvUpEventItemList[i][i2]
--                            local msgClassName = 'LVUP_REWARD_MSG1'
--                            
--                            local itemKor = GetClassString('Item', lvUpEventItemList[i][i2][1], 'Name')
--                            if itemText == '' then
--                                itemText = ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", lvUpEventItemList[i][i2][2])
--                            else
--                                itemText = itemText.."{nl}"..ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", lvUpEventItemList[i][i2][2])
--                            end
--                        end
--                    end
--                end
--            end
--            
--            if #giveItemList > 0 then
--                if sObj.NEXON_PC_REWARD_HISTORY == 'None' then
--                    sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","NEXON_PC_REWARD_HISTORY",tostring(lv)}
--                else
--                    sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","NEXON_PC_REWARD_HISTORY",sObj.NEXON_PC_REWARD_HISTORY.."/"..lv}
--                end
--            end
--        end
--    end
    
--    if IS_SEASON_SERVER(self) == 'NO' then
--        if GetPropType(sObj, 'LVUP_EVENT_REWARD_HISTORY') ~= nil then
--            local lvUpEventItemList = {{15,{"expCard2",10}, {"Event_Weaponbox01", 1}},
--                                        {30,{"expCard5",10}},
--                                        {45,{"expCard5",10}},
--                                        {60,{"expCard6",20}},
--                                        {75,{"expCard7",20}},
--                                        {100,{"expCard8",10},{"NECK99_101",1}},
--                                        {120,{"expCard8",20}},
--                                        {140,{"expCard9",10}},
--                                        {150,{"expCard9",20},{"Vis",500000},{"Event_160714_poporion", 1}}
--                                        }
--            for i = 1, #lvUpEventItemList do
--                if self.BeforeLv < lvUpEventItemList[i][1] and lvUpEventItemList[i][1] <= lv then
--                    local historyList = SCR_STRING_CUT(sObj.LVUP_EVENT_REWARD_HISTORY)
--                    if table.find(historyList, tostring(lv)) == 0 then
--                        for i2 = 2, #lvUpEventItemList[i] do
--                            giveItemList[#giveItemList + 1] = lvUpEventItemList[i][i2]
--                            local msgClassName = 'LVUP_REWARD_MSG1'
--                            if lvUpEventItemList[i][i2][1] == 'Vis' then
--                                msgClassName = 'LVUP_REWARD_MSG2'
--                            end
--                            
--                            local itemKor = GetClassString('Item', lvUpEventItemList[i][i2][1], 'Name')
--                            if itemText == '' then
--                                itemText = ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", lvUpEventItemList[i][i2][2])
--                            else
--                                itemText = itemText.."{nl}"..ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", lvUpEventItemList[i][i2][2])
--                            end
--                        end
--                    end
--                end
--            end
--            
--            if #giveItemList > 0 then
--                if sObj.LVUP_EVENT_REWARD_HISTORY == 'None' then
--                    sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","LVUP_EVENT_REWARD_HISTORY",tostring(lv)}
--                else
--                    sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","LVUP_EVENT_REWARD_HISTORY",sObj.LVUP_EVENT_REWARD_HISTORY.."/"..lv}
--                end
--            end
--        end
--    end
    
    if IS_SEASON_SERVER(self) == 'YES' then
        local seasonItemList = {{20,{"TOP02_123",1},{"LEG02_123",1},{"FOOT02_123",1},{"HAND02_123",1},{"ABAND01_113",1}},
                                    {50,{"Premium_boostToken02_event01",1}},
                                    {70,{"Premium_boostToken02_event01",2}},
                                    {100,{"Premium_indunReset_14d",3},{"Premium_boostToken02_event01",2}},
                                    {120,{"Premium_indunReset_14d",3},{"Premium_boostToken03_event01",1}},
                                    --{150,{"Premium_itemUpgradeStone_Weapon",1},{"Premium_itemUpgradeStone_Armor",1},{"Premium_itemUpgradeStone_Acc", 1},{"Premium_indunReset_14d",3},{"Premium_boostToken03_event01",2}},
                                    {200,{"Hat_628094",1},{"Vis",1000000},{"Premium_indunReset_14d",5},{"Premium_boostToken03_event01",2}},
                                    {250,{"Premium_StatReset14",1}}
                                    }
        for i = 1, #seasonItemList do
            if self.BeforeLv < seasonItemList[i][1] and seasonItemList[i][1] <= lv then
                local historyList = SCR_STRING_CUT(sObj.SEASON_SERVER_REWARD_HISTORY)
                if table.find(historyList, tostring(lv)) == 0 then
                    local lvCheck = 1
                    if self.BeforeLv < 20 and 20 <= lv then
                        local aobj = GetAccountObj(self);
                        if aobj.SEASON_SERVER_LV20 ~= 0 then
                            lvCheck = 0
                        end
                    end
                    
                    if lvCheck == 1 then
                        for i2 = 2, #seasonItemList[i] do
                            giveItemList[#giveItemList + 1] = seasonItemList[i][i2]
                            local msgClassName = 'LVUP_REWARD_MSG1'
                            if seasonItemList[i][i2][1] == 'Vis' then
                                msgClassName = 'LVUP_REWARD_MSG2'
                            end
                            
                            local itemKor = GetClassString('Item', seasonItemList[i][i2][1], 'Name')
                            if itemText == '' then
                                itemText = ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", seasonItemList[i][i2][2])
                            else
                                itemText = itemText.."{nl}"..ScpArgMsg(msgClassName, "ITEM", itemKor, "COUNT", seasonItemList[i][i2][2])
                            end
                        end
                    end
                end
            end
        end
        
        if #giveItemList > 0 then
            if sObj.SEASON_SERVER_REWARD_HISTORY == 'None' then
                sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","SEASON_SERVER_REWARD_HISTORY",tostring(lv)}
            else
                sObjInfo_set[#sObjInfo_set + 1] = {"ssn_klapeda","SEASON_SERVER_REWARD_HISTORY",sObj.SEASON_SERVER_REWARD_HISTORY.."/"..lv}
            end
            
            if lv == 20 then
                sObjInfo_set[#sObjInfo_set + 1] = {"ACCOUNT","SEASON_SERVER_LV20",300}
            end
        end
    end
    
    if #giveItemList > 0 then
        local ret = GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(self, giveItemList, nil, nil, nil, "SSN_KLAPEDA_LVUP", sObjInfo_set)
        if ret == 'SUCCESS' and itemText ~= '' then
            SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("LVUP_REWARD_MSG_SEND", "LV", lv, "TEXT", itemText), 10);
        end
    end
end

function SCR_QUEST_TRACK_OWNER_OUT_PRE(self, beforeLayer)
    local obj = GetLayerObject(GetZoneInstID(self), beforeLayer);
    if obj ~= nil then
        if obj.EventNextTrack == 'None' then
            if obj.EventOwner == self.Name then
                if obj.EventName ~= nil and obj.EventName ~= "None" then
                    local questIES_Auto = GetClass('QuestProgressCheck_Auto', obj.EventName);
                    if questIES_Auto ~= nil and questIES_Auto.Track1 ~= 'None' then
                        SCR_QUEST_TRACK_OWNER_OUT(self, obj.EventName, questIES_Auto.Track1, 'Success', beforeLayer)
                    end
                end
            end
        end
    end
end

function SCR_BASIC_PartyMemberOut(self, sObj, msg, argObj, argStr, argNum)
    RunZombieScript('SCR_BASIC_PartyMemberOut_TX',self, sObj)
end

function SCR_SSN_PARTY_JOIN(self, sObj, msg, argObj, argStr, argNum)

end

function SCR_SSN_PARTY_CREATE(self, sObj, msg, argObj, argStr, argNum)

end

function SCR_BASIC_PartyMemberOut_TX(self, sObj)
    local cnt = GetClassCount('QuestProgressCheck')
    local systemCancelList = {}
    local initializationList = {}
	for i = 0, cnt - 1 do
		local questIES = GetClassByIndex('QuestProgressCheck', i);
		if questIES ~= nil and questIES.QuestMode == 'PARTY' then
		    if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_END then
		        systemCancelList[#systemCancelList + 1] = questIES.QuestPropertyName
		    elseif sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_END or sObj[questIES.QuestPropertyName] < 0 then
		        initializationList[#initializationList + 1] = questIES.QuestPropertyName
		    end
		end
	end
	
	if #systemCancelList > 0 then
        for i = 1, #systemCancelList do
            ABANDON_Q_BY_NAME(self, systemCancelList[i], 'SYSTEMCANCEL')
        end
    end
    if #initializationList > 0 then
        local tx = TxBegin(self);
        for i = 1, #initializationList do
            TxSetIESProp(tx, sObj, initializationList[i], 0)
    		QuestStateMongoLog(self, 'None', initializationList[i], "StateChange", "State", 0);
        end
    	local ret = TxCommit(tx);
    	if ret == 'FAIL' then
    	    print('SCR_BASIC_PartyMemberOut_TX Transaction FAIL',itemname,itemcount)
    	end
    end
end

function SCR_PartyPropertyCheck_TX(self, sObj, partyObj)
    local cnt = GetClassCount('QuestProgressCheck')
    local systemCancelList = {}
    local initializationList = {}
	for i = 0, cnt - 1 do
		local questIES = GetClassByIndex('QuestProgressCheck', i);
		if questIES ~= nil and questIES.QuestMode == 'PARTY' then
	        if questIES.Check_PartyPropCount > 0 then
	            for x = 1, questIES.Check_PartyPropCount do
	                if questIES['PartyPropCount'..x] > partyObj[questIES['PartyPropName'..x]] then
--            		    if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_END then
--    	                    systemCancelList[#systemCancelList + 1] = questIES.QuestPropertyName
--    	                    break
--    	                else
    	                if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_END or sObj[questIES.QuestPropertyName] < 0 then
    	                    initializationList[#initializationList + 1] = questIES.QuestPropertyName
    	                    break
    	                end
	                end
	            end
		    end
		end
	end
	
--    if #systemCancelList > 0 then
--        for i = 1, #systemCancelList do
--            ABANDON_Q_BY_NAME(self, systemCancelList[i], 'SYSTEMCANCEL')
--        end
--    end
    
    if #initializationList > 0 then
        local tx = TxBegin(self);
        for i = 1, #initializationList do
            TxSetIESProp(tx, sObj, initializationList[i], 0)
    		QuestStateMongoLog(self, 'None', initializationList[i], "StateChange", "State", 0);
        end
    	local ret = TxCommit(tx);
    	if ret == 'FAIL' then
    	    print('SCR_BASIC_PartyMemberOut_TX Transaction FAIL',itemname,itemcount)
    	end
    end
end

function SCR_SSN_KLAPEDA_SetLayer(self, sObj, msg, argObj, argStr, beforeLayer)
    
	if IS_PC(self) then

		if beforeLayer == 0 and GetLayer(self) > 0 then
			SetExProp(self, "SetLayerTime", imcTime.GetAppTime())
		end
		
		if beforeLayer > 0 and GetLayer(self) == 0 then			
			local beforeTime = GetExProp(self, "SetLayerTime");
			if beforeTime > 0 then
				-- ????????5??????? ???????????? 
				local checkTime = imcTime.GetAppTime() - beforeTime;
				if checkTime < 5 then
					-- ????? SetLayer???ε?????? ???????? ?α?? ?????
					local funcName = GetExProp_Str(self, "SET_LAYER_FUNC");
					local eventName = GetExProp_Str(self, "LayerEventName");
					QuestStateMongoLog(self, 'None', eventName, "TRACE", "Func", funcName, "ElapsedTime", tostring(checkTime));
				end

				SetExProp_Str(self, "SET_LAYER_FUNC", "None");
				SetExProp(self, "SetLayerTime", 0);
			end
		end
	end

    if GetLayer(self) == 0 then
        if IsInScrollLockBox(self) == 1 then
            ResetScrollLockBox(self)
        end
    end
    
    if beforeLayer > 0 then
        SCR_QUEST_TRACK_OWNER_OUT_PRE(self, beforeLayer)
    end
end

--function SCR_SSN_KLAPEDA_Logout(self, sObj, msg, argObj, argStr, argNum)
--    local layer = GetLayer(self)
--    if layer > 0 then
--        print('HHHHHHHHH')
--        SCR_QUEST_TRACK_OWNER_OUT_PRE(self, layer)
--    end
--end

function SCR_BASIC_Dead(self, sObj, msg, argObj, argStr, argNum)
    AddHelpByName(self, 'TUTO_RESURRECTION')
    TUTO_PIP_CLOSE_QUEST(self)
end

function SCR_BASIC_OverKill(self, sObj, msg, argObj, argStr, argNum)
--    AddHelpByName(self, 'TUTO_OVERKILL')
end
function SCR_SSN_KLAPEDA_ZoneEner(self, sObj, msg, argObj, argStr, argNum)
    sObj.TRACK_QUEST_NAME = 'None'
    
    local drop_sObj = GetSessionObject(self, 'ssn_drop')
	if drop_sObj == nil then
	    CreateSessionObject(self,'ssn_drop')
	end
	
    sObj.PRESENT_ZONEID = GetClassNumber('Map', argStr, 'ClassID');

    if sObj.QUESTSAVE ~= 0 then
        local questIES = GetClass('QuestProgressCheck', SCR_SEARCH_CLASSIDIES('QuestProgressCheck', sObj.QUESTSAVE))
        local questsave_point = {}

        if questIES ~= nil then
            local questsave_gentype = GetClassCount('GenType_'..questIES.StartMap)
            local i, gentype, search_range
            for i = 0 , questsave_gentype -1 do
                if GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Dialog') == questIES.StartNPC or GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Enter') == questIES.StartNPC or GetClassStringByIndex('GenType_'..questIES.StartMap,i,'Leave') == questIES.StartNPC then
                    gentype = GetClassNumberByIndex('GenType_'..questIES.StartMap,i,'GenType');
                    search_range = GetClassNumberByIndex('GenType_'..questIES.StartMap,i,'Range');
                    break
                end
            end

            local questsave_anchor = GetClassCount('Anchor_'..questIES.StartMap)

            for i = 0 , questsave_anchor -1 do
                if GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'GenType') == gentype then
                    questsave_point[1] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosX');
                    questsave_point[2] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosY');
                    questsave_point[3] = GetClassNumberByIndex('Anchor_'..questIES.StartMap,i,'PosZ');
                    break
                end
            end

            if questsave_point[1] ~= nil and questsave_point[2] ~= nil and questsave_point[3] ~= nil then
--                UIOpenToPC(self,'fullblack',1)
                local self_posx, self_posy, self_posz = GetPos(self)
                if GetZoneName(self) == questIES.StartMap  and SCR_POINT_DISTANCE(questsave_point[1], questsave_point[3], self_posx, self_posz) > search_range then
                    MoveZone(self, questIES.StartMap, questsave_point[1], questsave_point[2], questsave_point[3])
                    sObj.QUESTSAVE = 0
                    SaveSessionObject(self,sObj)
--                    UIOpenToPC(self,'fullblack',0)
                end
            end
        end
    end
    
    if argStr == 'd_firetower_41' then
        FTOWER41_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_42' then
        FTOWER42_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_43' then
        FTOWER43_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_firetower_44' then
        FTOWER44_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_cmine_01' then
        AddHelpByName(self, 'TUTO_DUNGEON')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'd_prison_62_1' then
        AddHelpByName(self, 'TUTO_DUNGEON')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'f_remains_38' then
        REMAIN38_SQ05_MON_CREATE(self)
    elseif argStr == 'd_underfortress_59_1' then
        UNDERF591_TYPED_GET_ITEM(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_underfortress_59_2' then
        UNDERF592_TYPEB_GATE_BUFF(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_1' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_2' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_velniasprison_51_4' then
        HAUBERK_HOVER_VPRISON(self, sObj, msg, argObj, argStr, argNum)
--    elseif argStr == 'd_firetower_61_1' then
--        SCR_INI_SSN_FD_FTOWER611(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_thorn_39_2' then
        SCR_THORN392_MQ_05_COMPANION_REGET(self, sObj, msg, argObj, argStr, argNum)
        SCR_THORN392_FRIAR_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_thorn_39_1' then
        SCR_THORN391_SQ_01_COMPANION_REGET(self, sObj, msg, argObj, argStr, argNum)
        SCR_THORN391_FRIAR_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_abbey_39_4' then
        SCR_ABBEY394_HUNTER_HIDE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'c_Klaipe' then
        if sObj.TUTO_SOCIAL == 0 then
            sObj.TUTO_SOCIAL = 300
            AddHelpByName(self, 'TUTO_SOCIAL')
        end
        if self.Lv >= 100 then
            if sObj.TUTO_REQUEST == 0 then
                sObj.TUTO_REQUEST = 300
                AddHelpByName(self, 'TUTO_REQUEST')
            end
        end
        local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ06_PART3')
        if result == 'COMPLETE' then
            if sObj.TUTO_ITEM_AWAKENING == 0 then
                sObj.TUTO_ITEM_AWAKENING = 300
                AddHelpByName(self, 'TUTO_ITEM_AWAKENING')
            end
        end
    elseif argStr == 'c_orsha' then
        if sObj.TUTO_SOCIAL == 0 then
            sObj.TUTO_SOCIAL = 300
            AddHelpByName(self, 'TUTO_SOCIAL')
        end
        local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL54_MQ06_PART3')
        if result == 'COMPLETE' then
            if sObj.TUTO_ITEM_AWAKENING == 0 then
                sObj.TUTO_ITEM_AWAKENING = 300
                AddHelpByName(self, 'TUTO_ITEM_AWAKENING')
            end
        end
    elseif argStr == 'c_fedimian' then
        if sObj.TUTO_REQUEST == 0 then
--            sObj.TUTO_REQUEST = 300
--            AddHelpByName(self, 'TUTO_REQUEST')
        end
        local result = SCR_QUEST_CHECK(self, 'FTOWER45_MQ_06')
        if result == 'COMPLETE' then
            if sObj.TUTO_GEM_ROASTING == 0 then
                sObj.TUTO_GEM_ROASTING = 300
                AddHelpByName(self, 'TUTO_GEM_ROASTING')
            end
        end
    elseif argStr == 'f_pilgrimroad_31_2' then
        PILGRIM312_SQ_04_01_ADD(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_63_1' then
        BRACKEN631_MQ3_DOG01_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_63_2' then
        BRACKEN632_ROZE01_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_castle_65_3' then
        SCR_CASTLE653_MQ_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_katyn_45_3' then
        SCR_KATYN_45_3_BUFF(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_42_1' then
        SCR_BRACKEN421_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_42_2' then
        SCR_BRACKEN422_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'mission_groundtower_2' then
        SendAddOnMsg(self, "NOTICE_Dm_move_to_point", ScpArgMsg('GT2_LOBBY_ENTER_1'), 10);
--        SCR_GROUNDTOWER_ENTER_EVT(self)
    elseif argStr == 'd_limestonecave_52_1' then
        LIMESTONE_52_1_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_2' then
        LIMESTONE_52_2_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_3' then
        LIMESTONE_52_3_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_limestonecave_52_4' then
        LIMESTONE_52_4_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_flash_64' then
        local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_19')
        if hidden_Prop >= 5 then
            local master_Hide_Check = isHideNPC(self, 'ZEALOT_MASTER')
            if master_Hide_Check == 'YES' then
                UnHideNPC(self, "ZEALOT_MASTER")
            end
        end
    elseif argStr == 'd_limestonecave_52_5' then
        LIMESTONE_52_5_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_bracken_43_1' then
        BRACKEN431_SUBQ3_AI_CREATE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_pilgrimroad_41_3' then
        SCR_PILGRIM413_FOLLOWER_RE(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'f_whitetrees_23_3' then
        SCR_WHITETREES233_SQ_07_RF(self)
    elseif argStr == 'f_whitetrees_23_1' then
        SCR_WHITETREES231_SQ_07_RF(self)
    elseif argStr == 'f_maple_23_2' then
        SCR_MAPLE232_SQ_10_FR(self)
--    elseif argStr == 'mission_groundtower_1' then
--        SCR_GROUNDTOWER_ENTER_EVT(self)
      elseif argStr == "d_prison_62_3" then
        --this logic is hidden quest [PRISON62_2_HQ1] problerom solve
        SCR_PRISON622_HQ1_CHANGE_STATE(self)
    elseif argStr == "d_cathedral_56" then
        --this logic is nexon japan CHATHEDRAL56_SQ01 quest problerom solve logic
        SCR_CHATHEDRAL56_SQ1_NPC_HIDE(self)
    elseif argStr == 'd_chapel_57_5' then
        AddHelpByName(self, 'TUTO_PENALTY')
        TUTO_PIP_CLOSE_QUEST(self)
    elseif argStr == 'f_farm_49_3' then
        FARM49_3_SQ06_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    elseif argStr == 'd_startower_76_2' then
        SCR_D_STARTOWER_GIMMICK_REENTER(self) 
    end

    
    local userLevelCheck = self.Lv
    if userLevelCheck >= 330 then
        if sObj.TUTO_REGEND_CARD == 0 then
            AddHelpByName(self, 'TUTO_REGEND_CARD')
            sObj.TUTO_REGEND_CARD = 1
        end
    end
    
    if userLevelCheck >= 350 then
        if sObj.TUTO_RESOURCE_BATTLE == 0 then
            AddHelpByName(self, 'TUTO_RESOURCE_BATTLE')
            sObj.TUTO_RESOURCE_BATTLE = 1
        end
    end
    
    local partyObj = GetPartyObj(self)
    if partyObj == nil then
        RunZombieScript('SCR_BASIC_PartyMemberOut_TX',self, sObj)
    else
        RunZombieScript('SCR_PartyPropertyCheck_TX',self, sObj, partyObj)
    end

    local _weight = math.floor(self.NowWeight/self.MaxWeight*100)
    if _weight >= 60 then
        AddHelpByName(self, 'TUTO_STORAGE')
    end
    
    local itemCount1 = GetInvItemCount(self, 'MISSION_UPHILL_GIMMICK_ITEM1')
    if itemCount1 > 0 then
        TAKE_ITEM_TX(self, 'MISSION_UPHILL_GIMMICK_ITEM1', itemCount1, 'MISSION_UPHILL_ZONELELEAVE')
    end
    local jobCircle1 = GetJobGradeByName(self, 'Char4_19')
    if jobCircle1 > 0 then
        if isHideNPC(self, 'ZEALOT_MASTER') == 'YES' then
            UnHideNPC(self, 'ZEALOT_MASTER')
        end
    end
    local jobCircle2 = GetJobGradeByName(self, 'Char2_19')
    if jobCircle2 > 0 then
        if isHideNPC(self, 'JOB_SHADOWMANCER_MASTER') == 'YES' then
            UnHideNPC(self, 'JOB_SHADOWMANCER_MASTER')
        end
    end
    local jobCircle3 = GetJobGradeByName(self, 'Char1_19')
    if jobCircle3 > 0 then
        if isHideNPC(self, 'MATADOR_MASTER') == 'YES' then
            UnHideNPC(self, 'MATADOR_MASTER')
        end
    end
    local jobCircle4 = GetJobGradeByName(self, 'Char3_18')
    if jobCircle4 > 0 then
        if isHideNPC(self, 'BULLETMARKER_MASTER') == 'YES' then
            UnHideNPC(self, 'BULLETMARKER_MASTER')
        end
    end
    if IS_KOR_TEST_SERVER() then
        if argStr == 'c_fedimian' then
            if isHideNPC(self, 'FEDIMIAN_APPRAISER') == 'NO' then
                HideNPC(self, 'FEDIMIAN_APPRAISER')
            end
            if isHideNPC(self, 'FEDIMIAN_APPRAISER_NPC') == 'YES' then
                UnHideNPC(self, 'FEDIMIAN_APPRAISER_NPC')
            end
        elseif argStr == 'f_tableland_28_1' then
            if isHideNPC(self, 'SHINOBI_MASTER') == 'YES' then
                UnHideNPC(self, 'SHINOBI_MASTER')
            end
        elseif argStr == 'f_remains_38' then
            if isHideNPC(self, 'RUNECASTER_MASTER') == 'YES' then
                UnHideNPC(self, 'RUNECASTER_MASTER')
            end
        elseif argStr == 'd_thorn_22' then
            if isHideNPC(self, 'CHAPLAIN_MASTER') == 'YES' then
                UnHideNPC(self, 'CHAPLAIN_MASTER')
            end
        elseif argStr == 'p_cathedral_1' then
            if isHideNPC(self, 'MIKO_MASTER') == 'YES' then
                UnHideNPC(self, 'MIKO_MASTER')
            end
        elseif argStr == 'f_flash_64' then
            if isHideNPC(self, 'ZEALOT_MASTER') == 'YES' then
                UnHideNPC(self, 'ZEALOT_MASTER')
            end
        elseif argStr == 'f_pilgrimroad_41_3' then
            if isHideNPC(self, 'JOB_SHADOWMANCER_MASTER') == 'YES' then
                UnHideNPC(self, 'JOB_SHADOWMANCER_MASTER')
            end
        elseif argStr == 'c_fedimian' then
            if isHideNPC(self, 'MATADOR_MASTER') == 'YES' then
                UnHideNPC(self, 'MATADOR_MASTER')
            end
        elseif argStr == 'f_farm_49_1' then
            if isHideNPC(self, 'BULLETMARKER_MASTER') == 'YES' then
                UnHideNPC(self, 'BULLETMARKER_MASTER')
            end
        elseif argStr == 'f_gele_57_4' then
            if isHideNPC(self, 'CHAR120_MASTER') == 'YES' then
                UnHideNPC(self, 'CHAR120_MASTER')
            end
        end
        
    end
     if GetAchieveCount(self) > 0 then
        AddBuff(self, self, "Achieve_Possession_Buff", 1, 0, 0, 1)
    end
   
    if IsJoinColonyWarMap(self) == 1 then
        RunScript("SCR_GUILD_COLONY_MUSIC_PLAY", self)
        local state = GetColonyWarState()
        if state == 3 then
            SCR_GUILD_COLONY_ALREADY_END_MSG(self)
        end
    end
    
    -- Change Job Quest Fail
    local pcetc = GetETCObject(self)
    if pcetc ~= nil and pcetc.JobChanging > 0 then
        SCR_CHANGEJOB_QUEST_FAIL(self, pcetc)
    end
    
    -- EVENT_1706_FISHING_BALLOON
--    RunScript('SCR_EVENT_1706_FISHING_BALLOON_ITEM_REMOVE',self)
    
--    if IsPVPServer(self) ~= 1 and GetServerNation() == 'KOR' then
--        RunZombieScript('SCR_EV161215_HOTTIME',self, sObj)
--    end
    
    -- EVENT_1710_HOLIDAY
--    SCR_EVENT_1710_HOLIDAY(self)
    
    -- 2017.12.02 ~ 2017.12.03 LootingChance + 2000 Event --
--    SCR_EVENT_171202_171203_LOOTINGCHANCE(self)

--    SCR_SSN_KLAPEDA_CITYATTACK_BOSS(self, sObj)
    WORLDPVP_TIME_CHECK(self)
--    SCR_QUEST_BUG_TEMP(self,sObj)

    --reward_property achieve reward check
    local list, listCnt = GetClassList("reward_property");
    for i = 0, listCnt -1 do
        local cls = GetClassByIndexFromList(list, i);
        if cls ~= nil and TryGetProp(cls, "Property") == "AchievePoint" then
            local quest_auto = GetClass('QuestProgressCheck_Auto', cls.ClassName);
            if quest_auto ~= nil then
                if quest_auto.Success_HonorPoint ~= 'None' then
                    local honor_name, point_value = string.match(quest_auto.Success_HonorPoint,'(.+)[/](.+)')
                    if honor_name ~= nil then
                        if GetAchievePoint(self, honor_name) < 1 then
                            local result = SCR_QUEST_CHECK(self, cls.ClassName)
                            if result == 'COMPLETE' then
                                local tx = TxBegin(self);
                                TxEnableInIntegrate(tx)
                                TxAddAchievePoint(tx, honor_name, tonumber(point_value))
                                local ret = TxCommit(tx);
                            end
                        end
                    end
                end
            end
        end
    end

    -- EVENT_1804_WEEKEND
    EVENT_1804_WEEKEND(self)
    
    if argStr == 'c_firemage_event' then
        self.FIXMSPD_BM = 25
        Invalidate(self, 'MSPD');
    end
    
end

--function SCR_QUEST_BUG_TEMP(self,sObj)
--    local result = SCR_QUEST_CHECK(self, 'JOB_SAPPER3_2')
--    if result == 'PROGRESS' and sObj.JOB_SAPPER3_2 ~= 200 then
--		local sObject = GetSessionObject(self, 'SSN_JOB_SAPPER3_2')
--		print(sObject)
--		if sObject ~= nil then
--			sObject.QuestInfoValue1 = 3
--		end
--    end
--end


function SCR_CHANGEJOB_QUEST_FAIL(self, pcetc)
    local jobQuestList = {
                            {1001, 'JOB_WARRIOR2_1', 'Char1_1'},
                            {1001, 'JOB_WARRIOR3_1', 'Char1_1'},
                            {1001, 'JOB_SWORDMAN1', 'Char1_1'},
                            {1001, 'JOB_SWORDMAN4_1', 'Char1_1'},
                            {1001, 'JOB_SWORDMAN5_1', 'Char1_1'},
                            {1001, 'JOB_2_SWORDMAN2', 'Char1_1'},
                            {1001, 'JOB_2_SWORDMAN3', 'Char1_1'},
                            {1002, 'JOB_HIGHLANDER2_1', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER2_2', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER3_1', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER4_1', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER4_2', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER4_3', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER4_4', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER1', 'Char1_2'},
                            {1002, 'JOB_HIGHLANDER5_1', 'Char1_2'},
                            {1002, 'JOB_2_HIGHLANDER2_1', 'Char1_2'},
                            {1002, 'JOB_2_HIGHLANDER2_2', 'Char1_2'},
                            {1002, 'JOB_2_HIGHLANDER3', 'Char1_2'},
                            {1002, 'JOB_2_HIGHLANDER4', 'Char1_2'},
                            {1003, 'JOB_PELTASTA2_1', 'Char1_3'},
                            {1003, 'JOB_PELTASTA2_2', 'Char1_3'},
                            {1003, 'JOB_PELTASTA3_1', 'Char1_3'},
                            {1003, 'JOB_PELTASTA4_1', 'Char1_3'},
                            {1003, 'JOB_PELTASTA4_2', 'Char1_3'},
                            {1003, 'JOB_PELTASTA4_3', 'Char1_3'},
                            {1003, 'JOB_PELTASTA4_4', 'Char1_3'},
                            {1003, 'JOB_PELTASTA1', 'Char1_3'},
                            {1003, 'JOB_PELTASTA5_1', 'Char1_3'},
                            {1003, 'JOB_2_PELTASTA2', 'Char1_3'},
                            {1003, 'JOB_2_PELTASTA3', 'Char1_3'},
                            {1003, 'JOB_2_PELTASTA4', 'Char1_3'},
                            {1004, 'JOB_HOPLITE2', 'Char1_4'},
                            {1004, 'JOB_HOPLITE3_1', 'Char1_4'},
                            {1004, 'JOB_HOPLITE4_1', 'Char1_4'},
                            {1004, 'JOB_HOPLITE5_1', 'Char1_4'},
                            {1004, 'JOB_2_HOPLITE3', 'Char1_4'},
                            {1004, 'JOB_2_HOPLITE4', 'Char1_4'},
                            {1004, 'JOB_2_HOPLITE5', 'Char1_4'},
                            {1005, 'JOB_CENTURION3_1', 'Char1_5'},
                            {1005, 'JOB_CENTURION5_1', 'Char1_5'},
                            {1005, 'JOB_CENTURION_6_1', 'Char1_5'},
                            {1006, 'JOB_BARBARIAN2', 'Char1_6'},
                            {1006, 'JOB_BARBARIAN3_1', 'Char1_6'},
                            {1006, 'JOB_BARBARIAN4_1', 'Char1_6'},
                            {1006, 'JOB_BARBARIAN5_1', 'Char1_6'},
                            {1006, 'JOB_2_BARBARIAN3', 'Char1_6'},
                            {1006, 'JOB_2_BARBARIAN4', 'Char1_6'},
                            {1006, 'JOB_2_BARBARIAN5', 'Char1_6'},
                            {1007, 'JOB_CATAPHRACT3_1', 'Char1_7'},
                            {1007, 'JOB_CATAPHRACT4_1', 'Char1_7'},
                            {1007, 'JOB_CATAPHRACT5_1', 'Char1_7'},
                            {1007, 'JOB_2_CATAPHRACT4', 'Char1_7'},
                            {1007, 'JOB_2_CATAPHRACT5', 'Char1_7'},
                            {1007, 'JOB_2_CATAPHRACT6', 'Char1_7'},
                            {1008, 'JOB_CORSAIR4_1', 'Char1_8'},
                            {1008, 'JOB_CORSAIR5_1', 'Char1_8'},
                            {1008, 'JOB_CORSAIR_6_1', 'Char1_8'},
                            {1009, 'JOB_DOPPELSOELDNER5_1', 'Char1_9'},
                            {1009, 'JOB_DOPPELSOELDNER_6_1', 'Char1_9'},
                            {1009, 'JOB_DOPPELSOELDNER_8_1', 'Char1_9'},
                            {1010, 'JOB_RODELERO3_1', 'Char1_10'},
                            {1010, 'JOB_RODELERO4_1', 'Char1_10'},
                            {1010, 'JOB_RODELERO5_1', 'Char1_10'},
                            {1010, 'JOB_2_RODELERO4', 'Char1_10'},
                            {1010, 'JOB_2_RODELERO5', 'Char1_10'},
                            {1010, 'JOB_2_RODELERO6', 'Char1_10'},
                            {1011, 'JOB_SQUIRE3_1', 'Char1_11'},
                            {1011, 'JOB_SQUIRE4_1', 'Char1_11'},
                            {1011, 'JOB_SQUIRE5_1', 'Char1_11'},
                            {1011, 'JOB_SQUIRE_6_1', 'Char1_11'},
                            {1012, 'JOB_MURMILLO_8_1', 'Char1_12'},
                            {1013, 'JOB_SHINOBI_7_1', 'Char1_13'},
                            {1014, 'JOB_FENCER_5_1', 'Char1_14'},
                            {1014, 'JOB_FENCER_7_1', 'Char1_14'},
                            {1014, 'JOB_FENCER_8_1', 'Char1_14'},
                            {1015, 'JOB_DRAGOON_7_1', 'Char1_15'},
                            {1015, 'JOB_DRAGOON_8_1', 'Char1_15'},
                            {1016, 'JOB_TEMPLAR_7_1', 'Char1_16'},
                            {1016, 'JOB_TEMPLAR_8_1', 'Char1_16'},
                            {1017, 'JOB_LANCER_8_1', 'Char1_17'},
                            {2001, 'JOB_WIZARD2_1', 'Char2_1'},
                            {2001, 'JOB_WIZARD2_2', 'Char2_1'},
                            {2001, 'JOB_WIZARD3_1', 'Char2_1'},
                            {2001, 'JOB_WIZARD3_2', 'Char2_1'},
                            {2001, 'JOB_WIZARD1', 'Char2_1'},
                            {2001, 'JOB_WIZARD4_1', 'Char2_1'},
                            {2001, 'JOB_WIZARD5_1', 'Char2_1'},
                            {2001, 'JOB_2_WIZARD_2_1', 'Char2_1'},
                            {2001, 'JOB_2_WIZARD_3_1', 'Char2_1'},
                            {2002, 'JOB_PYROMANCER2_1', 'Char2_2'},
                            {2002, 'JOB_PYROMANCER3_1', 'Char2_2'},
                            {2002, 'JOB_PYROMANCER3_2', 'Char2_2'},
                            {2002, 'JOB_FIREMAGE1', 'Char2_2'},
                            {2002, 'JOB_PYROMANCER4_1', 'Char2_2'},
                            {2002, 'JOB_PYROMANCER5_1', 'Char2_2'},
                            {2002, 'JOB_2_PYROMANCER_2_1', 'Char2_2'},
                            {2002, 'JOB_2_PYROMANCER_3_1', 'Char2_2'},
                            {2002, 'JOB_2_PYROMANCER_4_1', 'Char2_2'},
                            {2003, 'JOB_CRYOMANCER2_1', 'Char2_3'},
                            {2003, 'JOB_CRYOMANCER2_2', 'Char2_3'},
                            {2003, 'JOB_CRYOMANCER3_1', 'Char2_3'},
                            {2003, 'JOB_ICEMAGE1', 'Char2_3'},
                            {2003, 'JOB_CRYOMANCER4_1', 'Char2_3'},
                            {2003, 'JOB_CRYOMANCER5_1', 'Char2_3'},
                            {2003, 'JOB_2_CRYOMANCER_2_1', 'Char2_3'},
                            {2003, 'JOB_2_CRYOMANCER_3_1', 'Char2_3'},
                            {2003, 'JOB_2_CRYOMANCER_4_1', 'Char2_3'},
                            {2004, 'JOB_PSYCHOKINESIST2_1', 'Char2_4'},
                            {2004, 'JOB_PSYCHOKINESIST3_1', 'Char2_4'},
                            {2004, 'JOB_PSYCHOKINESIST4_1', 'Char2_4'},
                            {2004, 'JOB_PSYCHOKINESIST5_1', 'Char2_4'},
                            {2004, 'JOB_2_PSYCHOKINO_3_1', 'Char2_4'},
                            {2004, 'JOB_2_PSYCHOKINO_4_1', 'Char2_4'},
                            {2004, 'JOB_2_PSYCHOKINO_5_1', 'Char2_4'},
                            {2005, 'JOB_ALCHEMIST5_1', 'Char2_5'},
                            {2005, 'JOB_ALCHEMIST_6_1', 'Char2_5'},
                            {2005, 'JOB_ALCHEMIST7_1', 'Char2_5'},
                            {2006, 'JOB_SORCERER3_1', 'Char2_6'},
                            {2006, 'JOB_SORCERER4_1', 'Char2_6'},
                            {2006, 'JOB_SORCERER5_1', 'Char2_6'},
                            {2006, 'JOB_SORCERER_6_1', 'Char2_6'},
                            {2007, 'JOB_LINKER2_1', 'Char2_7'},
                            {2007, 'JOB_LINKER2_2', 'Char2_7'},
                            {2007, 'JOB_LINKER3_1', 'Char2_7'},
                            {2007, 'JOB_LINKER4_1', 'Char2_7'},
                            {2007, 'JOB_LINKER5_1', 'Char2_7'},
                            {2007, 'JOB_2_LINKER_3_1', 'Char2_7'},
                            {2007, 'JOB_2_LINKER_4_1', 'Char2_7'},
                            {2007, 'JOB_2_LINKER_5_1', 'Char2_7'},
                            {2008, 'JOB_CHRONO4_1', 'Char2_8'},
                            {2008, 'JOB_CHRONO5_1', 'Char2_8'},
                            {2008, 'JOB_CHRONO_6_1', 'Char2_8'},
                            {2009, 'JOB_NECROMANCER3_1', 'Char2_9'},
                            {2009, 'JOB_NECROMANCER5_1', 'Char2_9'},
                            {2009, 'JOB_NECROMANCER_6_1', 'Char2_9'},
                            {2009, 'JOB_NECROMANCER7_1', 'Char2_9'},
                            {2010, 'JOB_THAUMATURGE3_1', 'Char2_10'},
                            {2010, 'JOB_THAUMATURGE4_1', 'Char2_10'},
                            {2010, 'JOB_THAUMATURGE5_1', 'Char2_10'},
                            {2010, 'JOB_2_THAUMATURGE_4_1', 'Char2_10'},
                            {2010, 'JOB_2_THAUMATURGE_5_1', 'Char2_10'},
                            {2010, 'JOB_2_THAUMATURGE_6_1', 'Char2_10'},
                            {2011, 'JOB_WARLOCK3_1', 'Char2_11'},
                            {2011, 'JOB_WARLOCK4_1', 'Char2_11'},
                            {2011, 'JOB_WARLOCK5_1', 'Char2_11'},
                            {2011, 'JOB_2_ELEMENTALIST_4_1', 'Char2_11'},
                            {2011, 'JOB_2_ELEMENTALIST_5_1', 'Char2_11'},
                            {2011, 'JOB_2_ELEMENTALIST_6_1', 'Char2_11'},
                            {2014, 'JOB_SAGE_8_1', 'Char2_14'},
                            {2015, 'JOB_WARLOCK_7_1', 'Char2_15'},
                            {2015, 'JOB_WARLOCK_8_1', 'Char2_15'},
                            {2016, 'JOB_FEATHERFOOT_7_1', 'Char2_16'},
                            {2016, 'JOB_FEATHERFOOT_8_1', 'Char2_16'},
                            {2017, 'JOB_RUNECASTER_6_1', 'Char2_17'},
                            {2018, 'JOB_ENCHANTER_8_1', 'Char2_18'},
                            {3001, 'JOB_ARCHER2_1', 'Char3_1'},
                            {3001, 'JOB_ARCHER2_2', 'Char3_1'},
                            {3001, 'JOB_ARCHER2_3', 'Char3_1'},
                            {3001, 'JOB_ARCHER2_4', 'Char3_1'},
                            {3001, 'JOB_ARCHER3_1', 'Char3_1'},
                            {3001, 'JOB_ARCHER3_2', 'Char3_1'},
                            {3001, 'JOB_ARCHER3_3', 'Char3_1'},
                            {3001, 'JOB_ARCHER1', 'Char3_1'},
                            {3001, 'JOB_ARCHER4_1', 'Char3_1'},
                            {3001, 'JOB_ARCHER4_2', 'Char3_1'},
                            {3001, 'JOB_ARCHER4_3', 'Char3_1'},
                            {3001, 'JOB_ARCHER5_1', 'Char3_1'},
                            {3001, 'JOB_2_ARCHER_2_1', 'Char3_1'},
                            {3001, 'JOB_2_ARCHER_3_1', 'Char3_1'},
                            {3002, 'JOB_HUNTER2_1', 'Char3_2'},
                            {3002, 'JOB_HUNTER2_2', 'Char3_2'},
                            {3002, 'JOB_HUNTER2_3', 'Char3_2'},
                            {3002, 'JOB_HUNTER2_4', 'Char3_2'},
                            {3002, 'JOB_HUNTER3_1', 'Char3_2'},
                            {3002, 'JOB_HUNTER4_1', 'Char3_2'},
                            {3002, 'JOB_HUNTER5_1', 'Char3_2'},
                            {3002, 'JOB_2_HUNTER_3_1', 'Char3_2'},
                            {3002, 'JOB_2_HUNTER_4_1', 'Char3_2'},
                            {3002, 'JOB_2_HUNTER_5_1', 'Char3_2'},
                            {3003, 'JOB_QUARREL2_1', 'Char3_3'},
                            {3003, 'JOB_QUARREL2_2', 'Char3_3'},
                            {3003, 'JOB_QUARREL2_3', 'Char3_3'},
                            {3003, 'JOB_QUARREL2_4', 'Char3_3'},
                            {3003, 'JOB_QUARREL3_1', 'Char3_3'},
                            {3003, 'JOB_QUARREL3_2', 'Char3_3'},
                            {3003, 'JOB_QUARREL4_1', 'Char3_3'},
                            {3003, 'JOB_QUARREL5_1', 'Char3_3'},
                            {3003, 'JOB_QUARRELSHOOTER1', 'Char3_3'},
                            {3003, 'JOB_2_QUARRELSHOOTER_2_1', 'Char3_3'},
                            {3003, 'JOB_2_QUARRELSHOOTER_3_1', 'Char3_3'},
                            {3003, 'JOB_2_QUARRELSHOOTER_4_1', 'Char3_3'},
                            {3004, 'JOB_RANGER2_1', 'Char3_4'},
                            {3004, 'JOB_RANGER2_2', 'Char3_4'},
                            {3004, 'JOB_RANGER2_3', 'Char3_4'},
                            {3004, 'JOB_RANGER2_4', 'Char3_4'},
                            {3004, 'JOB_RANGER2_5', 'Char3_4'},
                            {3004, 'JOB_RANGER3_1', 'Char3_4'},
                            {3004, 'JOB_RANGER3_2', 'Char3_4'},
                            {3004, 'JOB_RANGER4_1', 'Char3_4'},
                            {3004, 'JOB_RANGER5_1', 'Char3_4'},
                            {3004, 'JOB_HUNTER1', 'Char3_4'},
                            {3004, 'JOB_2_RANGER_2_1', 'Char3_4'},
                            {3004, 'JOB_2_RANGER_3_1', 'Char3_4'},
                            {3004, 'JOB_2_RANGER_4_1', 'Char3_4'},
                            {3005, 'JOB_SAPPER2_1', 'Char3_5'},
                            {3005, 'JOB_SAPPER2_2', 'Char3_5'},
                            {3005, 'JOB_SAPPER2_3', 'Char3_5'},
                            {3005, 'JOB_SAPPER2_4', 'Char3_5'},
                            {3005, 'JOB_SAPPER3_1', 'Char3_5'},
                            {3005, 'JOB_SAPPER3_2', 'Char3_5'},
                            {3005, 'JOB_SAPPER4_1', 'Char3_5'},
                            {3005, 'JOB_SAPPER5_1', 'Char3_5'},
                            {3005, 'JOB_2_SAPPER_3_1', 'Char3_5'},
                            {3005, 'JOB_2_SAPPER_4_1', 'Char3_5'},
                            {3005, 'JOB_2_SAPPER_5_1', 'Char3_5'},
                            {3006, 'JOB_WUGU3_1', 'Char3_6'},
                            {3006, 'JOB_WUGU4_1', 'Char3_6'},
                            {3006, 'JOB_WUGU5_1', 'Char3_6'},
                            {3006, 'JOB_2_WUGUSHI_4_1', 'Char3_6'},
                            {3006, 'JOB_2_WUGUSHI_5_1', 'Char3_6'},
                            {3006, 'JOB_2_WUGUSHI_6_1', 'Char3_6'},
                            {3007, 'JOB_HACKAPELL5_1', 'Char3_7'},
                            {3007, 'JOB_HACKAPELL_8_1', 'Char3_7'},
                            {3008, 'JOB_SCOUT3_1', 'Char3_8'},
                            {3008, 'JOB_SCOUT4_1', 'Char3_8'},
                            {3008, 'JOB_SCOUT5_1', 'Char3_8'},
                            {3008, 'JOB_2_SCOUT_4_1', 'Char3_8'},
                            {3008, 'JOB_2_SCOUT_5_1', 'Char3_8'},
                            {3008, 'JOB_2_SCOUT_6_1', 'Char3_8'},
                            {3009, 'JOB_ROGUE4_1', 'Char3_9'},
                            {3009, 'JOB_ROGUE5_1', 'Char3_9'},
                            {3009, 'JOB_ROGUE_6_1', 'Char3_9'},
                            {3010, 'JOB_SCHWARZEREITER5_1', 'Char3_10'},
                            {3010, 'JOB_SCHWARZEREITER_6_1', 'Char3_10'},
                            {3010, 'JOB_SCHWARZEREITER_8_1', 'Char3_10'},
                            {3011, 'JOB_FLETCHER4_1', 'Char3_11'},
                            {3011, 'JOB_FLETCHER5_1', 'Char3_11'},
                            {3011, 'JOB_FLETCHER_6_1', 'Char3_11'},
                            {3013, 'JOB_APPRAISER5_1', 'Char3_13'},
                            {3013, 'JOB_APPRAISER5_2', 'Char3_13'},
                            {3014, 'JOB_FALCONER5_1', 'Char3_14'},
                            {3014, 'JOB_FALCONER_6_1', 'Char3_14'},
                            {3014, 'JOB_FALCONER_8_1', 'Char3_14'},
                            {3015, 'JOB_CANNONEER_7_1', 'Char3_15'},
                            {3015, 'JOB_CANNONEER_8_1', 'Char3_15'},
                            {3016, 'JOB_MUSKETEER_7_1', 'Char3_16'},
                            {3016, 'JOB_MUSKETEER_8_1', 'Char3_16'},
                            {3017, 'JOB_MERGEN_8_1', 'Char3_17'},
                            {4001, 'JOB_CLERIC2_1', 'Char4_1'},
                            {4001, 'JOB_CLERIC2_2', 'Char4_1'},
                            {4001, 'JOB_CLERIC3_1', 'Char4_1'},
                            {4001, 'JOB_CLERIC1', 'Char4_1'},
                            {4001, 'JOB_CLERIC5_1', 'Char4_1'},
                            {4001, 'JOB_CLERIC4_1', 'Char4_1'},
                            {4001, 'JOB_CLERIC4_2', 'Char4_1'},
                            {4001, 'JOB_CLERIC4_3', 'Char4_1'},
                            {4001, 'JOB_2_CLERIC2', 'Char4_1'},
                            {4001, 'JOB_2_CLERIC3', 'Char4_1'},
                            {4002, 'JOB_PRIEST2_1', 'Char4_2'},
                            {4002, 'JOB_PRIEST3_1', 'Char4_2'},
                            {4002, 'JOB_PRIEST1', 'Char4_2'},
                            {4002, 'JOB_PRIEST5_1', 'Char4_2'},
                            {4002, 'JOB_PRIEST4_1', 'Char4_2'},
                            {4002, 'JOB_2_PRIEST2', 'Char4_2'},
                            {4002, 'JOB_2_PRIEST3', 'Char4_2'},
                            {4002, 'JOB_2_PRIEST4', 'Char4_2'},
                            {4003, 'JOB_KRIVI2_1', 'Char4_3'},
                            {4003, 'JOB_KRIVI3_1', 'Char4_3'},
                            {4003, 'JOB_KRIWI1', 'Char4_3'},
                            {4003, 'JOB_KRIWI1_1', 'Char4_3'},
                            {4003, 'JOB_KRIVI5_1', 'Char4_3'},
                            {4003, 'JOB_KRIVI4_1', 'Char4_3'},
                            {4003, 'JOB_KRIVI4_2', 'Char4_3'},
                            {4003, 'JOB_KRIVI4_3', 'Char4_3'},
                            {4003, 'JOB_2_KRIVIS2', 'Char4_3'},
                            {4003, 'JOB_2_KRIVIS3', 'Char4_3'},
                            {4003, 'JOB_2_KRIVIS4', 'Char4_3'},
                            {4004, 'JOB_BOKOR3_1', 'Char4_4'},
                            {4004, 'JOB_BOCOR5_1', 'Char4_4'},
                            {4004, 'JOB_BOCORS1', 'Char4_4'},
                            {4004, 'JOB_BOCOR4_1', 'Char4_4'},
                            {4004, 'JOB_BOCOR4_2', 'Char4_4'},
                            {4004, 'JOB_BOCOR4_3', 'Char4_4'},
                            {4004, 'JOB_BOCOR4_4', 'Char4_4'},
                            {4004, 'JOB_2_BOKOR3', 'Char4_4'},
                            {4004, 'JOB_2_BOKOR4', 'Char4_4'},
                            {4004, 'JOB_2_BOKOR5', 'Char4_4'},
                            {4005, 'JOB_DRUID5_1', 'Char4_5'},
                            {4005, 'JOB_DRUID_6_1', 'Char4_5'},
                            {4005, 'JOB_DRUID_7_1', 'Char4_5'},
                            {4006, 'JOB_SADU3_1', 'Char4_6'},
                            {4006, 'JOB_SADU5_1', 'Char4_6'},
                            {4006, 'JOB_SADU4_1', 'Char4_6'},
                            {4006, 'JOB_2_SADHU4', 'Char4_6'},
                            {4006, 'JOB_2_SADHU5', 'Char4_6'},
                            {4006, 'JOB_2_SADHU6', 'Char4_6'},
                            {4007, 'JOB_DIEVDIRBYS2', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS3_1', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS3_2', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS3_3', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS5_1', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS4_1', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS4_2', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS4_3', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS4_4', 'Char4_7'},
                            {4007, 'JOB_DIEVDIRBYS4_5', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS3_1', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS3_2', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS3_3', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS4', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS5_1', 'Char4_7'},
                            {4007, 'JOB_2_DIEVDIRBYS5_2', 'Char4_7'},
                            {4008, 'JOB_ORACLE5_1', 'Char4_8'},
                            {4008, 'JOB_ORACLE_6_1', 'Char4_8'},
                            {4008, 'JOB_ORACLE_7_1', 'Char4_8'},
                            {4009, 'JOB_MONK5_1', 'Char4_9'},
                            {4009, 'JOB_MONK4_1', 'Char4_9'},
                            {4009, 'JOB_MONK_6_1', 'Char4_9'},
                            {4010, 'JOB_PARDONER5_1', 'Char4_10'},
                            {4010, 'JOB_PARDONER4_1', 'Char4_10'},
                            {4010, 'JOB_PARDONER4_2', 'Char4_10'},
                            {4010, 'JOB_PARDONER4_3', 'Char4_10'},
                            {4010, 'JOB_PARDONER_6_1', 'Char4_10'},
                            {4011, 'JOB_PALADIN3_1', 'Char4_11'},
                            {4011, 'JOB_PALADIN5_1', 'Char4_11'},
                            {4011, 'JOB_PALADIN4_1', 'Char4_11'},
                            {4011, 'JOB_2_PALADIN4', 'Char4_11'},
                            {4011, 'JOB_2_PALADIN5', 'Char4_11'},
                            {4011, 'JOB_2_PALADIN6', 'Char4_11'},
                            {4012, 'JOB_CHAPLAIN_5_1', 'Char4_12'},
                            {4014, 'JOB_PLAGUEDOCTOR_7_1', 'Char4_14'},
                            {4014, 'JOB_PLAGUEDOCTOR_8_1', 'Char4_14'},
                            {4015, 'JOB_KABBALIST_7_1', 'Char4_15'},
                            {4015, 'JOB_KABBALIST_8_1', 'Char4_15'},
                            {4016, 'JOB_INQUGITOR_8_1', 'Char4_16'},
                            {4017, 'JOB_DAOSHI_8_1', 'Char4_17'},
                            {4018, 'JOB_MIKO_6_1', 'Char4_18'}
                            }
    for i = 1, #jobQuestList do
        if pcetc.JobChanging == jobQuestList[i][1] then
            local result = SCR_QUEST_CHECK(self, jobQuestList[i][2])
            if result == 'PROGRESS' or result == 'SUCCESS' then
                ABANDON_Q_BY_NAME(self, jobQuestList[i][2], 'SYSTEMCANCEL')
            end
        end
    end
    local tx = TxBegin(self);
    TxSetIESProp(tx, pcetc, 'JobChanging', 0)
    local ret = TxCommit(tx);
end

--function SCR_EVENT_1706_FISHING_BALLOON_ITEM_REMOVE(pc)
--    local balloonList = {'E_Balloon_1','E_Balloon_2','E_Balloon_3','E_Balloon_4','E_Balloon_5','E_Balloon_6','E_Balloon_7','E_Balloon_8','E_Balloon_9','E_Balloon_10'}
--    if #balloonList > 0 then
--        local tx = TxBegin(pc);
--        for i = 1, #balloonList do
--            local invItemCount = GetInvItemCount(pc,balloonList[i])
--            if invItemCount > 0 then
--                TxTakeItem(tx, balloonList[i], invItemCount, 'EVENT_1706_FISHING_BALLOON')
--            end
--        end
--    	local ret = TxCommit(tx);
--    end
--end

function SCR_SSN_KLAPEDA_GetItem(self, sObj, msg, argObj, giveWay, itemType, itemCount, hookInfo)
    local itemname = GetClassString('Item', itemType, 'ClassName');
    local itemIES = GetClass('Item',itemname)
    local queststart_func = _G['SCR_'..itemname..'_QUEST_STARTITEM'];
    if queststart_func ~= nil then
        queststart_func(self, itemname);
    end
    

  	PC_WIKI_GETITEM(self, itemType, giveWay, itemCount);
  	
  	local warpscrolllistcls = GetClass("warpscrolllist", itemname);
	
  	if sObj.WARPSCROLL_GET == 0 and warpscrolllistcls ~= nil then
  	    sObj.WARPSCROLL_GET = 300
  	    AddHelpByName(self, 'TUTO_CAMPWARP')
  	end
  	
  	local tempstr = string.find(itemIES.ClassName,'Moru_')

  	if sObj.MORU_GET == 0 and tempstr ~= nil then
  	    SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_JangBi_KangHwayong_MoLuLeul_HoegDeugHayeossSeupNiDa"), 5);
  	    sObj.MORU_GET = 300
  	    AddHelpByName(self, 'TUTO_REIN')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
  	if sObj.HELP_GEM == 0 and itemIES.GroupName == 'Gem' then
  	    sObj.HELP_GEM = 300
  	    AddHelpByName(self, 'TUTO_GEM_EQUIP')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
  	if sObj.TUTO_SUBWEAPON == 0 and itemIES.GroupName == 'SubWeapon' then
  	    sObj.TUTO_SUBWEAPON = 300
  	    AddHelpByName(self, 'TUTO_SUBWEAPON')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
  	if sObj.HELP_COLLECTION == 0 and itemIES.GroupName == 'Collection' then
  	    sObj.HELP_COLLECTION = 300
  	    AddHelpByName(self, 'TUTO_COLLECTION')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
--  	if sObj.TUTO_CARDBATTLE == 0 and itemIES.GroupName == 'Card' then
--  	    sObj.TUTO_CARDBATTLE = 300
--  	    AddHelpByName(self, 'TUTO_CARDBATTLE')
--  	end
  	
  	if sObj.TUTO_MAGIC_AMULET == 0 and itemIES.GroupName == 'MagicAmulet' then
  	    sObj.TUTO_MAGIC_AMULET = 300
  	    AddHelpByName(self, 'TUTO_MAGIC_AMULET')
  	end
  	
  	local token = string.find(itemIES.ClassName,'PremiumToken')
  	
  	if sObj.TUTO_TOKEN == 0 and token ~= nil then
  	    sObj.TUTO_TOKEN = 300
  	    AddHelpByName(self, 'TUTO_TOKEN')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
  	if sObj.HELP_RECI == 0 then
  	local WikiIES = GetClass('Wiki',itemname)
  	    if WikiIES ~= nil then
      	    if WikiIES.Category == 'Recipe' then
          	    sObj.HELP_RECI = 300
          	    AddHelpByName(self, 'TUTO_CRAFT')
          	    TUTO_PIP_CLOSE_QUEST(self)
      	    end
      	end
  	end

  	if sObj.TUTO_MONSTER_CARD == 0 and itemIES.GroupName == 'Card' then
  	    sObj.TUTO_MONSTER_CARD = 300
  	    AddHelpByName(self, 'TUTO_MONSTER_CARD')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
  	local transcendence = string.find(itemIES.ClassName,'misc_BlessedStone')
  	
  	if sObj.TUTO_TRANSCENDENCE == 0 and transcendence ~= nil then 	
   	    sObj.TUTO_TRANSCENDENCE = 300
  	    AddHelpByName(self, 'TUTO_TRANSCENDENCE')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end

   	local stone1 = string.find(itemIES.ClassName,'Premium_itemDissassembleStone') 	

  	if sObj.TUTO_EXTRACTION_STONE == 0 and stone1 ~= nil then 	
  	    sObj.TUTO_EXTRACTION_STONE = 300
  	    AddHelpByName(self, 'TUTO_EXTRACTION_STONE')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end
  	
   	local stone2 = string.find(itemIES.ClassName,'Premium_deleteTranscendStone') 	

  	if sObj.TUTO_EXTRACTION_ITEM == 0 and stone2 ~= nil then 	
  	    sObj.TUTO_EXTRACTION_ITEM = 300
  	    AddHelpByName(self, 'TUTO_EXTRACTION_ITEM')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end

  	local hairacc = string.find(itemIES.ClassName,'Hat_')

  	if sObj.TUTO_ITEM_ENCHANT == 0 and hairacc ~= nil then
  	    sObj.TUTO_ITEM_ENCHANT = 300
  	    AddHelpByName(self, 'TUTO_ITEM_ENCHANT')
  	    TUTO_PIP_CLOSE_QUEST(self)
  	end

        local isNeedAppraisal = TryGetProp(itemIES, "NeedAppraisal");
        if isNeedAppraisal ~= nil and isNeedAppraisal == 1  then
      	    if sObj.TUTO_ITEM_APPRAISE == 0 then
                sObj.TUTO_ITEM_APPRAISE = 300
                AddHelpByName(self, 'TUTO_ITEM_APPRAISE')
                TUTO_PIP_CLOSE_QUEST(self)
            end
        end
  	  	
end

function SCR_SSN_KLAPEDA_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if SHARE_QUEST_PROP(self, party_pc) == true then
        if GetLayer(self) ~= 0 then
            if GetLayer(self) == GetLayer(party_pc) then
                SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
            end
        else
            SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
        end
    end
    
    
---- EVENT_1706_MONK
--    SCR_SSN_EVENT_1706_MONK_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    
----WHITEDAY EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_EVENT_WHITEDAY(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end    

-- ALPHABET_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end

-- CHUSEOK_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_CHUSEOK_EVENT(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	CHECK_CHALLENGE_MODE(self, argObj);

	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
----WHITEDAY EVENT	
--	SCR_EVENT_WHITEDAY(self, sObj, msg, argObj, argStr, argNum)

---- ALPHABET_EVENT
--	SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum)

-- CHUSEOK_EVENT
--	SCR_CHUSEOK_EVENT(self, sObj, msg, argObj, argStr, argNum)
  
---- EVENT_1706_MONK
--    SCR_SSN_EVENT_1706_MONK_KillMonster(self, sObj, msg, argObj, argStr, argNum)

---- Event_1709_NewField
--	SCR_EVENT_1709_NEWFIELD(self, sObj, msg, argObj, argStr, argNum)
	
---- ID_WHITETREES1
    if GetZoneName(self) == 'id_whitetrees1' then
        if argObj.ClassName == 'ID_umblet' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_01', 1, 'INDUN_330')
            end
        elseif argObj.ClassName == 'ID_kucarry_Tot' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_02', 1, 'INDUN_330')
            end
        elseif argObj.ClassName == 'ID_kucarry_lioni' then
            if IMCRandom(1, 10000) < 601 then
                RunScript('GIVE_ITEM_TX', self, 'misc_id_330_gimmick_03', 1, 'INDUN_330')
            end
        end
    end
end

function SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    if argObj ~= nil then
        local quest_mondrop = GetClass('QuestProgressCheck_QuestItem',argObj.ClassName)
        if quest_mondrop ~= nil then
            for i = 1, 6 do
                if quest_mondrop['DropItemQuestName'..i] ~= 'None' then
                    if sObj[quest_mondrop['DropItemQuestName'..i]] < CON_QUESTPROPERTY_MIN then
                        local monBTree = GetBTreeName(argObj)
                        if quest_mondrop['DropItemBTree'..i] == 'None' or (monBTree ~= nil and quest_mondrop['DropItemBTree'..i] == monBTree) then
                            local monSimpleAI = GetSimpleAIName(argObj)
                            if quest_mondrop['DropItemSimpleAI'..i] == 'None' or (monSimpleAI ~= nil and quest_mondrop['DropItemSimpleAI'..i] == monSimpleAI) then
                                if IMCRandom(1, 10000) < quest_mondrop['DropItemPersent'..i] then
                                    local questIES = GetClass('QuestProgressCheck', quest_mondrop['DropItemQuestName'..i])
                                    local needCount = questIES['InvItemCount'..quest_mondrop['DropItemQuetInvItemNUM'..i]]
                                    if questIES ~= nil then
                                        local count = quest_mondrop['DropItemCount'..i]
                                        if string.find(count, '/') ~= nil then
                                            local list = SCR_STRING_CUT(count)
                                            local rand = IMCRandom(1,#list)
                                            count = tonumber(list[rand])
                                        end
                                        if count == 0 then
                                            count = needCount
                                        end
                                        count = math.floor(count)
                                        local invCount = GetInvItemCount(self,questIES['InvItemName'..quest_mondrop['DropItemQuetInvItemNUM'..i]])
                                        
                                        if invCount < needCount then
                                            if invCount + count >  needCount then
                                                count = needCount - invCount
                                            end
                                            
                                            RunZombieScript('SCR_SSN_KLAPEDA_KillMonster_TX',self, questIES['InvItemName'..quest_mondrop['DropItemQuetInvItemNUM'..i]], count)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
--        -- EVENT_1804_ARBOR
        SCR_EVENT_1804_ARBOR_DROP(self, sObj, msg, argObj, argStr, argNum) 

--        -- EVENT
--        SCR_EVENTITEM_DROP_BLUEORB(self, sObj, msg, argObj, argStr, argNum) 
        
        
--        -- EVENT_1802_NEWYEAR
--        RunScript('SCR_EVENT_1802_NEWYEAR_MONKILL',self, sObj, msg, argObj, argStr, argNum)
    else
        print(ScpArgMsg("Auto_Jugin_MonSeuTeoui_obj_Ka_eopSeupNiDa."))
    end
end

function SCR_SSN_KLAPEDA_KillMonster_TX(self, itemname, itemcount)
    local tx = TxBegin(self);
	TxGiveItem(tx, itemname, itemcount, "Quest");
	local ret = TxCommit(tx);
	if ret == 'FAIL' then
	    print('SCR_SSN_KLAPEDA_KillMonster_TX Transaction FAIL',itemname,itemcount)
	    return;
	end
end

--function SCR_EV161215_HOTTIME(self, sObj)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    
--    local ev161124_daycheck = {{{2016,12,15},{2016,12,21}}}
--    local flag = 0
--    for i = 1, #ev161124_daycheck do
--        if SCR_DATE_TO_YDAY_BASIC_2000(ev161124_daycheck[i][1][1],ev161124_daycheck[i][1][2],ev161124_daycheck[i][1][3]) <= SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) and SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) <= SCR_DATE_TO_YDAY_BASIC_2000(ev161124_daycheck[i][2][1],ev161124_daycheck[i][2][2],ev161124_daycheck[i][2][3]) then
--            flag = 1
--            break
--        end
--    end
--    
--    if flag == 1 then
--        if year..'/'..month..'/'..day ~= sObj.EV161215_HOTTIME_DATE then
--            local tx = TxBegin(self);
--        	TxGiveItem(tx, 'Artefact_900201', 5, "EV161215_HOTTIME")
--        	TxSetIESProp(tx, sObj, 'EV161215_HOTTIME_DATE', year..'/'..month..'/'..day)
--        	local ret = TxCommit(tx)
--        	if ret == 'SUCCESS' then
--        	    local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\')", 'GetItem', 'Artefact_900201', 0);
--            	ExecClientScp(self, sucScp);
--        	end
--        end
--    end
--end

--function SCR_CHUSEOK_EVENT(self, sObj, msg, argObj, argStr, argNum, partyFlag)
--    -- Event Monster
--    SCR_CHUSEOK_EVENT_MONKILL(self, sObj, msg, argObj, argStr, argNum, partyFlag)
--    
--    if argObj ~= nil and argObj.ClassName ~= 'PC' then
--        local monIES = GetClass('Monster', argObj.ClassName)
--        if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 20 <= argObj.Lv then
--            local monLv = argObj.Lv
--            local zoneInst = GetZoneInstID(self);
--        	local isMission = IsMissionInst(zoneInst);
--            if (argObj.DropItemList ~= 'None' and monIES.DropItemList ~= 'None') or isMission == 1 then
--                local pcLayer = GetLayer(self)
--                
--                if pcLayer > 0 then
--                    local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
--                    local flag = 'NO'
--                    if obj ~= nil then
--                        if obj.EventName ~= nil and obj.EventName ~= "None" then
--                            local etc = GetETCObject(self)
--        				    if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
--        				        local trackInitCount = etc[obj.EventName..'_TRACK']
--        				        if trackInitCount <= 1 then
--        				            flag = 'YES'
--        				        end
--        				    end
--                        end
--                    end
--       			    if flag == 'NO' then
--       			        return
--       			    end
--                end
--                
--                local randMax = 1000000
----                local randMax = 10000
--                local partyRandMax = 1
--                local lowLvRand = 1
--                
----                local eliteRandAdd = 2
----                local bossRandAdd = 5
--                
--                local itemInfoList = {{'R_Event_160908_6',600},{'Event_160908_1',3000},{'Event_160908_2',3000},{'Event_160908_3',3000},{'Event_160908_4',3000}}
----                local alphabetText = {'T','R','E','O','F','S','A','V','I'}
--
----                if monLv >= 100 then
----                    if monLv <= 140 then
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1000},{'event_alphabet_E',1500},{'event_alphabet_O',0},{'event_alphabet_F',0},{'event_alphabet_S',0},{'event_alphabet_A',0},{'event_alphabet_V',0},{'event_alphabet_I',0}}
----                    elseif monLv <= 180 then
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1500},{'event_alphabet_E',1500},{'event_alphabet_O',1000},{'event_alphabet_F',0},{'event_alphabet_S',1000},{'event_alphabet_A',1000},{'event_alphabet_V',1000},{'event_alphabet_I',1000}}
----                    else
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1500},{'event_alphabet_E',1500},{'event_alphabet_O',1500},{'event_alphabet_F',100},{'event_alphabet_S',1000},{'event_alphabet_A',1000},{'event_alphabet_V',1000},{'event_alphabet_I',1000}}
----                    end
----                end
--                
--                if itemInfoList == nil then
--                    return
--                end
--                
--                if partyFlag == 'YES' then
--                    partyRandMax = 10
--                end
--                if monLv <= 50 then
--                    lowLvRand = 10
--                end
--                
--                randMax = randMax * partyRandMax * lowLvRand
--                
----                if argObj.MonRank == "Elite" then
----                    randMax = math.floor(randMax / eliteRandAdd)
----                elseif argObj.MonRank == "Boss" then
----                    randMax = math.floor(randMax / bossRandAdd)
----                end
--                
--                local rewardItem = ''
--                local rewardTxt = ''
--                for i = 1, #itemInfoList do
--                    if itemInfoList[i][2] > 0 then
--                        local rand = IMCRandom(1, randMax)
--                        if rand <= itemInfoList[i][2] then
--                            rewardItem = rewardItem..itemInfoList[i][1]..'/1/'
--                            rewardTxt = rewardTxt.."'"..GetClassString('Item',itemInfoList[i][1],'Name').."', "
--                        end
--                    end
--                end
--                if rewardItem ~= '' then
--                    rewardItem = string.sub(rewardItem,1,string.len(rewardItem)-1)
--                    rewardTxt = string.sub(rewardTxt,1,string.len(rewardTxt)-2)
--                    RunScript('GIVE_TAKE_ITEM_TX',self, rewardItem, nil, 'CHUSEOK_EVENT')
--                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem',ScpArgMsg('ALPHABET_EVENT_NOTICE1', "TEXT", rewardTxt), 8)
--                end
--            end
--        end
--    end
--end



--function SCR_EVENT_1709_NEWFIELD(self, sObj, msg, argObj, argStr, argNum, partyFlag)
--    local zoneList = {'f_3cmlake_26_1','f_3cmlake_26_2','f_coral_44_1','f_coral_44_2','f_coral_44_3','d_fantasylibrary_48_1','d_fantasylibrary_48_2','d_fantasylibrary_48_3','d_fantasylibrary_48_4','d_fantasylibrary_48_5','f_whitetrees_22_1','f_whitetrees_22_2','f_whitetrees_22_3','d_abbey_22_4','d_abbey_22_5','d_startower_76_2'}
--    if table.find(zoneList, GetZoneName(self)) == 0 then
--        return
--    end
--    
--    if argObj ~= nil and argObj.ClassName ~= 'PC' then
--        local monIES = GetClass('Monster', argObj.ClassName)
--        if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 10 <= argObj.Lv and self.Lv + 50 >= argObj.Lv then
--            local monLv = argObj.Lv
--            local zoneInst = GetZoneInstID(self);
--            if argObj.DropItemList ~= 'None' and monIES.DropItemList ~= 'None' then
--                local pcLayer = GetLayer(self)
--                
--                if pcLayer > 0 then
--                    local obj = GetLayerObject(zoneInst, pcLayer);
--                    local flag = 'NO'
--                    if obj ~= nil then
--                        if obj.EventName ~= nil and obj.EventName ~= "None" then
--                            local etc = GetETCObject(self)
--        				    if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
--        				        local trackInitCount = etc[obj.EventName..'_TRACK']
--        				        if trackInitCount <= 1 then
--        				            flag = 'YES'
--        				        end
--        				    end
--                        end
--                    end
--       			    if flag == 'NO' then
--       			        return
--       			    end
--                end
--                
--                local randMax = 1000000
----                local randMax = 10000
----                local partyRandMax = 10
--                
----                local eliteRandAdd = 2
----                local bossRandAdd = 5
--                
--                local itemInfoList = {{'Event_1709_NewField_Coupon',30000}}
----                local alphabetText = {'T','R','E','O','F','S','A','V','I'}
--
--                if itemInfoList == nil then
--                    return
--                end
--                
----                if partyFlag == 'YES' then
----                    randMax = randMax * partyRandMax
----                end
--                
--                local rewardItem = ''
--                local rewardTxt = ''
--                
--                for i = 1, #itemInfoList do
--                    if itemInfoList[i][2] > 0 then
--                        local rand = IMCRandom(1, randMax)
--                        if rand <= itemInfoList[i][2] then
--                            rewardItem = rewardItem..itemInfoList[i][1]..'/1/'
--                            rewardTxt = rewardTxt.."'"..GetClassString('Item',itemInfoList[i][1],'Name').."', "
--                        end
--                    end
--                end
--                if rewardItem ~= '' then
--                    rewardItem = string.sub(rewardItem,1,string.len(rewardItem)-1)
--                    rewardTxt = string.sub(rewardTxt,1,string.len(rewardTxt)-3)
--                    if IS_PARTY_EXIST(self) == 1 then
--                        local list, cnt = GET_PARTY_ACTOR(self, 0)
--                        for i = 1, cnt do
--                    		local partyPC = list[i];
--                            if GetLayer(self) == GetLayer(partyPC) then
--                                RunZombieScript('GIVE_TAKE_ITEM_NPCSTATE_STAT_TX',partyPC, rewardItem, nil, 'EVENT_1709_NEWFIELD')
--                                SendAddOnMsg(partyPC, 'NOTICE_Dm_GetItem',ScpArgMsg('ALPHABET_EVENT_NOTICE1', "TEXT", rewardTxt), 8)
--                            end
--                        end
--                    else
--                        RunZombieScript('GIVE_TAKE_ITEM_NPCSTATE_STAT_TX',self, rewardItem, nil, 'EVENT_1709_NEWFIELD')
--                        SendAddOnMsg(self, 'NOTICE_Dm_GetItem',ScpArgMsg('ALPHABET_EVENT_NOTICE1', "TEXT", rewardTxt), 8)
--                    end
--                end
--            end
--        end
--    end
--end


--function SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum, partyFlag)
--    if argObj ~= nil and argObj.ClassName ~= 'PC' then
--        local monIES = GetClass('Monster', argObj.ClassName)
--        if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 30 <= argObj.Lv then
--            local monLv = argObj.Lv
--            local zoneInst = GetZoneInstID(self);
--        	local isMission = IsMissionInst(zoneInst);
--            if (argObj.DropItemList ~= 'None' and monIES.DropItemList ~= 'None') or isMission == 1 then
--                local pcLayer = GetLayer(self)
--                
--                if pcLayer > 0 then
--                    local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
--                    local flag = 'NO'
--                    if obj ~= nil then
--                        if obj.EventName ~= nil and obj.EventName ~= "None" then
--                            local etc = GetETCObject(self)
--        				    if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
--        				        local trackInitCount = etc[obj.EventName..'_TRACK']
--        				        if trackInitCount <= 1 then
--        				            flag = 'YES'
--        				        end
--        				    end
--                        end
--                    end
--       			    if flag == 'NO' then
--       			        return
--       			    end
--                end
--                
--                local randMax = 1000000
----                local randMax = 10000
--                local partyRandMax = 10
--                
----                local eliteRandAdd = 2
----                local bossRandAdd = 5
--                
--                local itemInfoList = {{'Event_160818_1',3000},{'Event_160818_2',3000},{'Event_160818_3',3000},{'Event_160818_4',3000},{'Event_160818_5',3000},{'Event_160818_6',3000},{'Event_160818_7',3000},{'Event_160818_8',3000}}
----                local alphabetText = {'T','R','E','O','F','S','A','V','I'}
--
----                if monLv >= 100 then
----                    if monLv <= 140 then
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1000},{'event_alphabet_E',1500},{'event_alphabet_O',0},{'event_alphabet_F',0},{'event_alphabet_S',0},{'event_alphabet_A',0},{'event_alphabet_V',0},{'event_alphabet_I',0}}
----                    elseif monLv <= 180 then
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1500},{'event_alphabet_E',1500},{'event_alphabet_O',1000},{'event_alphabet_F',0},{'event_alphabet_S',1000},{'event_alphabet_A',1000},{'event_alphabet_V',1000},{'event_alphabet_I',1000}}
----                    else
----                        itemInfoList = {{'event_alphabet_T',1000},{'event_alphabet_R',1500},{'event_alphabet_E',1500},{'event_alphabet_O',1500},{'event_alphabet_F',100},{'event_alphabet_S',1000},{'event_alphabet_A',1000},{'event_alphabet_V',1000},{'event_alphabet_I',1000}}
----                    end
----                end
--                
--                if itemInfoList == nil then
--                    return
--                end
--                
--                if partyFlag == 'YES' then
--                    randMax = randMax * partyRandMax
--                end
----                if argObj.MonRank == "Elite" then
----                    randMax = math.floor(randMax / eliteRandAdd)
----                elseif argObj.MonRank == "Boss" then
----                    randMax = math.floor(randMax / bossRandAdd)
----                end
--                
--                local rewardItem = ''
--                local rewardTxt = ''
--                
--                for i = 1, #itemInfoList do
--                    if itemInfoList[i][2] > 0 then
--                        local rand = IMCRandom(1, randMax)
--                        if rand <= itemInfoList[i][2] then
--                            rewardItem = rewardItem..itemInfoList[i][1]..'/1/'
--                            rewardTxt = rewardTxt.."'"..GetClassString('Item',itemInfoList[i][1],'Name').."', "
--                        end
--                    end
--                end
--                if rewardItem ~= '' then
--                    rewardItem = string.sub(rewardItem,1,string.len(rewardItem)-1)
--                    rewardTxt = string.sub(rewardTxt,1,string.len(rewardTxt)-3)
--                    RunScript('GIVE_TAKE_ITEM_TX',self, rewardItem, nil, 'HANGEUL_EVENT')
--                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem',ScpArgMsg('ALPHABET_EVENT_NOTICE1', "TEXT", rewardTxt), 8)
--                end
--            end
--        end
--    end
--end


function SCR_BASIC_AttackMonster(self, sObj, msg, monster, sklName, realDamage, damage, skillResult)
	PC_CONSUME_ENCHANT(self, sObj, damage, skillResult);
    SCR_CITYATTACK_BOSS_EVENT_ATTACK_CHECK(self, sObj, msg, monster, sklName, realDamage, damage, skillResult)
end

function SCR_BASIC_TakeDamage(self, sObj, msg, monster, sklName, damage)
	
end

function SCR_CITYATTACK_BOSS_EVENT_ATTACK_CHECK(self, sObj, msg, monster, sklName, realDamage, damage, skillResult)
    if monster.StrArg1 == 'CITYATTACK_BOSS' then
        if monster.NumArg1 == sObj.CITYATTACK_BOSS_GENINDEX then
            sObj.CITYATTACK_BOSS_ATTACKCOUNT = sObj.CITYATTACK_BOSS_ATTACKCOUNT + 1
        else
            sObj.CITYATTACK_BOSS_GENINDEX = monster.NumArg1
            sObj.CITYATTACK_BOSS_ATTACKCOUNT = 1
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CITYATTACK_BOSS_ATTACK1"), 10);
        end
        
        SaveSessionObject(self, sObj)
    end
end

function PC_CONSUME_ENCHANT(self, sObj, damage, skillResult)

	if skillResult == nil then
		return;
	end

	local invalidate = 0;

	local RH = GetEquipItem(self, 'RH');
	if RH ~= nil then
		local sendProp = 0;

		for i = 0, OPT_COUNT - 1 do
			local optValue = RH["Option_" .. i];
			if optValue == 0 then
				break;
			end

			local dur = RH["OpDur_" .. i];
			if dur > 0 then
				local opt, val, cls = GET_OPT(RH, i);
				local consume = _G[cls.Consume](val, skillResult);
				if consume > 0 then
					if consume >= dur then
						RH["OpDur_" .. i] = 0;
						InvalidateItem(RH);
						invalidate = 1;
					else
						RH["OpDur_" .. i] = dur - consume;
					end

					sendProp = 1;
				end
			end
		end

		if sendProp == 1 then
			SendProperty(self, RH);
		end
	end

	if invalidate == 1 then
		InvalidateStates(self);
	end

end

function QUEST_SOBJ_CHECK_SERV(self, questID, checkType)

	local questIES = GetClassByType("QuestProgressCheck", questID);
	local sObj = GetSessionObject(self, 'ssn_klapeda')
	if questIES == nil or sObj == nil then
		return;
	end

	if checkType == 0 then
        if questIES.Quest_SSN ~= 'None' and sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_END then
            local sObj2 = GetSessionObject(self, questIES.Quest_SSN);
            if sObj2 == nil then
                CreateSessionObject(self,questIES.Quest_SSN, 1);
            end
        end
	elseif checkType == 1 then
        if questIES.QuestStartMode == 'SYSTEM' then
            if sObj[questIES.QuestPropertyName] == 0 then
                if 0 == GetQuestCheckState(self, questIES.ClassName) then
                    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
                    if result == 'POSSIBLE' then
                        RunZombieScript('SCR_QUEST_POSSIBLE_AGREE',self, questIES.ClassName)
                    end
                end
            end
        end
	elseif checkType == 2 then
        if isHideNPC(self, questIES.StartNPC) == 'YES' then
            UnHideNPC(self, questIES.StartNPC)
        end
	elseif checkType == 3 then
		if isHideNPC(self, questIES.EndNPC) == 'YES' then
            UnHideNPC(self, questIES.EndNPC)
        end
    elseif checkType == 4 then
        

        local flag = false
        
        if sObj[questIES.QuestPropertyName] ~= 200 and SCR_QUEST_CHECK(self, questIES.ClassName) ~= 'SUCCESS' then
            flag = true
        end
        
        if flag == false then
            if 0 == GetQuestCheckState(self, questIES.ClassName) then
        		RunZombieScript('SCR_QUEST_SUCCESS',self, questIES.ClassName)
        	end
    	end
    elseif checkType == 5 then
        if questIES.QuestMode == 'MAIN' and questIES.StartMap ~= 'None' then
            local result = SCR_QUEST_CHECK(self, questIES.ClassName)
            if result == 'POSSIBLE' then
				local accObj = GetAccountObj(self);
                local mapclass = GetClass('Map', questIES.StartMap)
                if mapclass ~= nil and mapclass.WorldMapPreOpen == 'YES' then
                	if accObj['HadVisited_' .. mapclass.ClassID] ~= 1  then
						SetIESProp(accObj, 'HadVisited_' .. mapclass.ClassID, 1);
						SendUpdateWorldMap(self);
                	end
                end
            end
        end
    elseif checkType == 6 then
        if questIES.QuestMode ~= 'MAIN' then
            local result = SCR_QUEST_CHECK(self, questIES.ClassName)
            
            if result == 'POSSIBLE' then
                if questIES.StartMap ~= 'None' and questIES.StartNPC ~= 'None' and GetZoneName(self) == questIES.StartMap then
                	local genDlgIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Dialog', questIES.StartNPC)
                	local genEntIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Enter', questIES.StartNPC)
                	local genLevIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Leave', questIES.StartNPC)
                	
                	if #genDlgIESList > 0 or #genEntIESList > 0 or #genLevIESList > 0 then
                	    local genType
                	    local genIES
                	    if #genDlgIESList > 0 then
                	        genIES = genDlgIESList[1]
                	        genType = genDlgIESList[1].GenType
                	    elseif  #genEntIESList > 0 then
                	        genIES = genEntIESList[1]
                	        genType = genEntIESList[1].GenType
               	        elseif  #genLevIESList > 0 then
                	        genIES = genLevIESList[1]
                	        genType = genLevIESList[1].GenType
               	        end
               	        
               	        if genType ~= nil and ( genIES.Minimap == 1 or genIES.Minimap == 3) and string.find(genIES.ArgStr1, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr2, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr3, 'NPCStateLocal/') == nil then
               	            local curState = GetMapNPCState(self, genType)
               	            if curState ~= 1 then
                   	            RunZombieScript('SCR_NPCSTATECHEANG',self, genType, 1)
                   	        end
               	        end
                	end
                end
            end
        end
	elseif checkType == 7 then
	    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
	    if result == 'POSSIBLE' then
    	    if GetPropType(questIES, 'PossibleUnHideNPC') ~= nil and questIES.PossibleUnHideNPC ~= 'None' then
			    local npcList = SCR_STRING_CUT(questIES.PossibleUnHideNPC)
			    if #npcList > 0 then
			        for index = 1, #npcList do
                        if isHideNPC(self, npcList[index]) == 'YES' then
                            UnHideNPC(self, npcList[index])
                        end
                    end
                end
			end
	    end
	elseif checkType == 8 then
	    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
	    if result == 'PROGRESS' then
    	    if GetPropType(questIES, 'ProgressUnHideNPC') ~= nil and questIES.ProgressUnHideNPC ~= 'None' then
			    local npcList = SCR_STRING_CUT(questIES.ProgressUnHideNPC)
			    if #npcList > 0 then
			        for index = 1, #npcList do
                        if isHideNPC(self, npcList[index]) == 'YES' then
                            UnHideNPC(self, npcList[index])
                        end
                    end
                end
			end
	    end
	elseif checkType == 9 then
	    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
	    if result == 'SUCCESS' then
    	    if GetPropType(questIES, 'SuccessUnHideNPC') ~= nil and questIES.SuccessUnHideNPC ~= 'None' then
			    local npcList = SCR_STRING_CUT(questIES.SuccessUnHideNPC)
			    if #npcList > 0 then
			        for index = 1, #npcList do
                        if isHideNPC(self, npcList[index]) == 'YES' then
                            UnHideNPC(self, npcList[index])
                        end
                    end
                end
			end
	    end
	elseif checkType == 10 then
	    local obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
	    if obj ~= nil then
    	    if obj.EventName == questIES.ClassName then
    	        if IsDummyPC(self) == 0 and 0 == IsPlayingDirection(self) then
                    if GetLayer(self) > 0 and questIES.QuestEndMode ~= 'SYSTEM' then
                        local questIES_auto = GetClass('QuestProgressCheck_Auto', questIES.ClassName)
                        if questIES_auto.Track1 ~= 'None' and questIES_auto.Track_Auto_Complete ~= 'NO' then
                    	    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
                    	    if result == 'SUCCESS' then
                                RunZombieScript('SCR_TRACK_END',self, questIES.ClassName, questIES_auto.Track1, 'Success')
                            end
                        end
                    end
                end
        	end
        end
	end
end

function GET_SUPER_DROP_GROUP(pc)

	local lv = pc.Lv;
	return "SuperDrop_" .. (math.floor((lv - 1)/ 5) + 1);
	
end

function CHECK_SUPER_DROP(pc)
	if IMCRandom(1, 10000) == 1 then
		RunZombieScript("MAKE_SUPER_DROP_MON", pc, groupName, 1000, 2000);
	end
end

function MAKE_SUPER_DROP_MON(pc, groupName, minTime, maxTime)

	local sleepTime = IMCRandom(minTime, maxTime);
	sleep( sleepTime );
	local mo = CreateNearMonGen(pc);
	if mo ~= nil then
		AddBuff(mo, mo, "SuperDrop", 10, 5);
		--SaveRedisPropVlaue(pc, 'monster', 'super_drop_mon', mo.Name, 1, 1);
		--SaveRedisPropVlaue(pc, 'monster', 'super_drop_map', GetZoneName(mo), 1, 1);
	end

end

--function SCR_SSN_KLAPEDA_CITYATTACK_BOSS(self, sObj, remainTime)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    local min = now_time['min']
--    
--    local flag = 0
--    for i = 1, #CITYATTACK_BOSS_EVENT_TIME_TABLE do
--        local dataYday = SCR_MONTH_TO_YDAY(CITYATTACK_BOSS_EVENT_TIME_TABLE[i][1], CITYATTACK_BOSS_EVENT_TIME_TABLE[i][2], CITYATTACK_BOSS_EVENT_TIME_TABLE[i][3])
--        local addHour = SCR_DATE_TO_HOUR(year, yday, hour)
--        local addDataHour = SCR_DATE_TO_HOUR(year, dataYday, CITYATTACK_BOSS_EVENT_TIME_TABLE[i][4])
--        local checkMin = (addDataHour - addHour) * 60 - min
--        local minTime = -30
--        local maxTime = -90
--        if checkMin <= minTime and checkMin > maxTime then
--            flag = 1
--            if IsBuffApplied(self,'CITYATTACK_BOSS_SERVER_REWARD') == 'NO' then
--                AddBuff(self,self,'CITYATTACK_BOSS_SERVER_REWARD',0,0,0,1)
--                break
--            end
--        end
--    end
--    
--    if flag == 0 then
--        if IsBuffApplied(self,'CITYATTACK_BOSS_SERVER_REWARD') == 'YES' then
--            RemoveBuff(self, 'CITYATTACK_BOSS_SERVER_REWARD')
--        end
--    end
--end


--function SCR_SSN_KLAPEDA_DAYCHECK_EVENT(self, sObj, remainTime)
--    RunScript("SCR_DAYCHECK_EVENT_COUNTTING", self, sObj, remainTime)
--end
--
--function SCR_DAYCHECK_EVENT_COUNTTING(self, sObj, remainTime)
--    local aObj = GetAccountObj(self);
--    if aObj == nil then
--        return
--    end
--    
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    
--    local seid = 0
--    
--    for i = 1, #DAYCHECK_EVENT_TIME do
--        if SCR_DATE_TO_YDAY_BASIC_2000(DAYCHECK_EVENT_TIME[i][1][1],DAYCHECK_EVENT_TIME[i][1][2],DAYCHECK_EVENT_TIME[i][1][3]) <= SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) and SCR_DATE_TO_YDAY_BASIC_2000(year,month,day) <= SCR_DATE_TO_YDAY_BASIC_2000(DAYCHECK_EVENT_TIME[i][2][1],DAYCHECK_EVENT_TIME[i][2][2],DAYCHECK_EVENT_TIME[i][2][3]) then
--            seid = i
--            break
--        end
--    end
--    
--    if seid == 0 then
--        return
--    end
--    if aObj['DAYCHECK_EVENT_REWARD_COUNT'..seid] >= 10 then
--        return
--    end
--    
--    local lastDate = aObj.DAYCHECK_EVENT_LAST_DATE
--    
--    if lastDate ~= year..'/'..yday then
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_PLAYMIN", 0)
--	    TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_LAST_DATE", year..'/'..yday);
--    	local ret = TxCommit(tx);
--    	if ret == 'SUCCESS' then
--        	CustomMongoLog(self, "DAYCHECK_EVENT","Type","DayRefresh", "DAYCHECK_EVENT_PLAYMIN", aObj.DAYCHECK_EVENT_PLAYMIN, "DAYCHECK_EVENT_LAST_DATE", aObj.DAYCHECK_EVENT_LAST_DATE);
--        end
--    end
--    
--    if aObj.DAYCHECK_EVENT_PLAYMIN < DAYCHECK_EVENT_REWARD_HOUR - 1 then
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_PLAYMIN", aObj.DAYCHECK_EVENT_PLAYMIN + 1)
--	    TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_LAST_DATE", year..'/'..yday);
--    	local ret = TxCommit(tx);
--    	if ret == 'SUCCESS' then
--        	CustomMongoLog(self, "DAYCHECK_EVENT","Type","MinCount", "DAYCHECK_EVENT_PLAYMIN", aObj.DAYCHECK_EVENT_PLAYMIN, "DAYCHECK_EVENT_LAST_DATE", aObj.DAYCHECK_EVENT_LAST_DATE);
--        end
--    elseif aObj.DAYCHECK_EVENT_REWARD_DATE ~= year..'/'..yday then
--        local rewardCount = aObj['DAYCHECK_EVENT_REWARD_COUNT'..seid]
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_PLAYMIN", aObj.DAYCHECK_EVENT_PLAYMIN + 1)
--	    TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_LAST_DATE", year..'/'..yday);
--	    TxSetIESProp(tx, aObj, "DAYCHECK_EVENT_REWARD_DATE", year..'/'..yday);
--	    TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_REWARD_COUNT'..seid, rewardCount + 1);
--	    TxGiveItem(tx,DAYCHECK_EVENT_REWARD_ITEM[seid][rewardCount+1][1], DAYCHECK_EVENT_REWARD_ITEM[seid][rewardCount+1][2], "DAYCHECK_EVENT")
--    	local ret = TxCommit(tx);
--    	if ret == 'SUCCESS' then
--    	    local itemName = GetClassString('Item', DAYCHECK_EVENT_REWARD_ITEM[seid][rewardCount+1][1], 'Name')
--        	CustomMongoLog(self, "DAYCHECK_EVENT","Type","DayReward", "DAYCHECK_EVENT_PLAYMIN", aObj.DAYCHECK_EVENT_PLAYMIN, "DAYCHECK_EVENT_LAST_DATE", aObj.DAYCHECK_EVENT_LAST_DATE);
----        	SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("DAYCHECK_EVENT_GETITEM","SEASON",seid,"COUNT", rewardCount + 1,"ITEMNAME", itemName,"ITEMCOUNT", DAYCHECK_EVENT_REWARD_ITEM[seid][rewardCount+1][2]),10)
--        	SysMsg(self, "Instant", ScpArgMsg("DAYCHECK_EVENT_GETITEM","SEASON",seid,"COUNT", rewardCount + 1,"ITEMNAME", itemName,"ITEMCOUNT", DAYCHECK_EVENT_REWARD_ITEM[seid][rewardCount+1][2]))
--        end
--    end
--end

--function SCR_SSN_KLAPEDA_EVENT_1712_XMAS(self, sObj, remainTime)
--    RunScript("SCR_EVENT_1712_XMAS_COUNTTING", self, sObj, remainTime)
--end
--
--function SCR_EVENT_1712_XMAS_COUNTTING(self, sObj, remainTime)
--    sleep(5000)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    local nowDay = year..'/'..month..'/'..day
--
--    local aObj = GetAccountObj(self)
--    local rewardTime = {1,30,60}
--    local rewardCount = {1,1,1}
--    local giveItem = 'EVENT_1712_XMAS_FIRE'
--    
--    if aObj.EVENT_1712_XMAS_DATE == nowDay and aObj.EVENT_1712_XMAS_MIN_ITEM_GIVE >= #rewardTime then
--        return
--    else
--        local giveItemFlag = 0 
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	
--    	local nowMinTime = aObj.EVENT_1712_XMAS_MIN + 1
--    	local nowItemTime = aObj.EVENT_1712_XMAS_MIN_ITEM_GIVE + 1
--    	if aObj.EVENT_1712_XMAS_DATE ~= nowDay then
--    	    TxSetIESProp(tx, aObj, "EVENT_1712_XMAS_DATE", nowDay)
--	        nowItemTime = 1
--	        nowMinTime = 1
--	    end
--        TxSetIESProp(tx, aObj, "EVENT_1712_XMAS_MIN", nowMinTime)
--    	if nowMinTime >= rewardTime[nowItemTime] then
--        	TxSetIESProp(tx, aObj, "EVENT_1712_XMAS_MIN_ITEM_GIVE", nowItemTime)
--    	    TxGiveItem(tx, giveItem, rewardCount[nowItemTime], "EVENT_1712_XMAS_MIN_ITEM_"..nowItemTime)
--    	    giveItemFlag = 1
--    	end
--    	local ret = TxCommit(tx);
--    	if ret == 'SUCCESS' and giveItemFlag == 1 then
--    	    local itemKorName = GetClassString('Item', giveItem, 'Name')
--        	SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("EVENT_1712_XMAS_MSG1","ITEM",itemKorName,"COUNT",rewardCount[nowItemTime]), 10)
--    	end
--    end
--end


--function SCR_SSN_KLAPEDA_EVENT_1712_SECOND(self, sObj, remainTime)
--    RunScript("SCR_EVENT_1712_SECOND_COUNTTING", self, sObj, remainTime)
--end
--
--function SCR_EVENT_1712_SECOND_COUNTTING(self, sObj, remainTime)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    local nowDay = year..'/'..month..'/'..day
--
--    local aObj = GetAccountObj(self)
--    local rewardTime = {1,10,20,30,40,50,60}
--    local rewardCount = {100,25,25,25,25,25,25}
--    local giveItem = 'EVENT_1712_SECOND_MIN_ITEM'
--    
--    
--    if aObj.EVENT_1712_SECOND_DATE == nowDay and aObj.EVENT_1712_SECOND_MIN_ITEM_GIVE >= #rewardTime then
--        return
--    else
--        local giveItemFlag = 0 
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	local nowMinTime = aObj.EVENT_1712_SECOND_MIN + 1
--    	local nowItemTime = aObj.EVENT_1712_SECOND_MIN_ITEM_GIVE + 1
--    	if aObj.EVENT_1712_SECOND_DATE ~= nowDay then
--    	    TxSetIESProp(tx, aObj, "EVENT_1712_SECOND_DATE", nowDay)
--	        nowItemTime = 1
--	        nowMinTime = 1
--    	end
--    	
--    	TxSetIESProp(tx, aObj, "EVENT_1712_SECOND_MIN", nowMinTime)
--    	
--    	if nowMinTime >= rewardTime[nowItemTime] then
--        	TxSetIESProp(tx, aObj, "EVENT_1712_SECOND_MIN_ITEM_GIVE", nowItemTime)
--    	    TxGiveItem(tx, giveItem, rewardCount[nowItemTime], "EVENT_1712_SECOND_MIN_ITEM_"..nowItemTime)
--    	    giveItemFlag = 1
--    	end
--    	local ret = TxCommit(tx);
--    	if ret == 'SUCCESS' and giveItemFlag == 1 then
--    	    local itemKorName = GetClassString('Item', giveItem, 'Name')
--        	SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("EVENT_1712_SECOND_MSG1","ITEM",itemKorName,"COUNT",rewardCount[nowItemTime]), 10)
--    	end
--    end
--end

--function SCR_SSN_KLAPEDA_PLAYTIMEEVENT(self, sObj, remainTime)
--    RunScript("SCR_PLAYTIMEEVENT_COUNTTING", self, sObj, remainTime)
--end
--
--function SCR_PLAYTIMEEVENT_COUNTTING(self, sObj, remainTime)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local yday = now_time['yday']
--    local wday = now_time['wday']
--    local day = now_time['day']
--    local hour = now_time['hour']
--    
--    local sObj = GetSessionObject(self, 'ssn_klapeda')
--    
--    local rewardItemList = {}
--    
--    if sObj.GOLDKEY_EVENT_LASTREWARD ~= "None" then
--        local lastCounting = SCR_STRING_CUT(sObj.GOLDKEY_EVENT_LASTREWARD)
--        if #lastCounting == 3 and  ((SCR_DATE_TO_HOUR(lastCounting[1], lastCounting[2], lastCounting[3]) < SCR_DATE_TO_HOUR(year, yday - 1, PLAYTIMEEVENT_REFLASH_HOUR)) or(PLAYTIMEEVENT_REFLASH_HOUR <= hour and SCR_DATE_TO_HOUR(lastCounting[1], lastCounting[2], lastCounting[3]) < SCR_DATE_TO_HOUR(year, yday, PLAYTIMEEVENT_REFLASH_HOUR))) then
--            local tx = TxBegin(self);
--        	TxEnableInIntegrate(tx);
--        	TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_PLAYMIN", 0)
--        	TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_REWARDCOUNT", 0);
--    	    TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_LASTREWARD", year..'/'..yday..'/'..hour);
--        	local ret = TxCommit(tx);
--        	CustomMongoLog(self, "GOLDKEYEVENT","Type","DayRefresh", "GOLDKEY_EVENT_PLAYMIN", sObj.GOLDKEY_EVENT_PLAYMIN, "GOLDKEY_EVENT_REWARDCOUNT", sObj.GOLDKEY_EVENT_REWARDCOUNT, "GOLDKEY_EVENT_LASTREWARD", sObj.GOLDKEY_EVENT_LASTREWARD);
----        	print('XXXXXXXXXXXX','PLAYTIMEEVENT_DAYREFLASH',sObj.GOLDKEY_EVENT_PLAYMIN,sObj.GOLDKEY_EVENT_REWARDCOUNT,sObj.GOLDKEY_EVENT_LASTREWARD)
--        end
--    end
--    
--    local playMin = sObj.GOLDKEY_EVENT_PLAYMIN + 1
--    local dayRewardCount = sObj.GOLDKEY_EVENT_REWARDCOUNT
--    local rewardIndex
--    if dayRewardCount < #PLAYTIMEEVENT_REWARD_TIME then
--        rewardIndex = dayRewardCount + 1
--    end
--    
--    if rewardIndex ~= nil then
--	    local accCount = sObj.GOLDKEY_EVENT_ACCCOUNT
--	    local accRewardFlag  = 0
--        local tx = TxBegin(self);
--    	TxEnableInIntegrate(tx);
--    	TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_PLAYMIN", playMin);
--	    TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_LASTREWARD", year..'/'..yday..'/'..hour);
--    	
--    	if PLAYTIMEEVENT_REWARD_TIME[rewardIndex] <= playMin then
--    	    TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_REWARDCOUNT", rewardIndex);
--    	    if IsPremiumState(self, NEXON_PC) == 1 then
--    	        for i = 1, #PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex] do
--    	            TxGiveItem(tx, PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][1], PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][2], "GOLDKEYEVENT_"..rewardIndex.."_PREMIUM")
--    	            rewardItemList[#rewardItemList + 1] = {}
--    	            rewardItemList[#rewardItemList][1] = PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][1]
--    	            rewardItemList[#rewardItemList][2] = PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][2]
--    	            if PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][1] == 'Event_160609' then
--    	                accCount = accCount + PLAYTIMEEVENT_REWARD_PREMIUM[rewardIndex][i][2]
--    	            end
--    	        end
--    	    else
--    	        for i = 1, #PLAYTIMEEVENT_REWARD_BASIC[rewardIndex] do
--    	            TxGiveItem(tx, PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][1], PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][2], "GOLDKEYEVENT_"..rewardIndex.."_BASIC")
--    	            rewardItemList[#rewardItemList + 1] = {}
--    	            rewardItemList[#rewardItemList][1] = PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][1]
--    	            rewardItemList[#rewardItemList][2] = PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][2]
--    	            if PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][1] == 'Event_160609' then
--    	                accCount = accCount + PLAYTIMEEVENT_REWARD_BASIC[rewardIndex][i][2]
--    	            end
--    	        end
--    	    end
--    	    
--    	    if sObj.GOLDKEY_EVENT_ACCCOUNT < accCount then
--    	        TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_ACCCOUNT", accCount);
--    	        local accIndex = sObj.GOLDKEY_EVENT_ACCINDEX + 1
--    	        if PLAYTIMEEVENT_REWARD_ACC_TIME ~= nil then
--        	        if accIndex <= #PLAYTIMEEVENT_REWARD_ACC_TIME and PLAYTIMEEVENT_REWARD_ACC_TIME[accIndex] <= accCount then
--        	            accRewardFlag = 1
--        	            TxSetIESProp(tx, sObj, "GOLDKEY_EVENT_ACCINDEX", accIndex);
--        	            for i = 1, #PLAYTIMEEVENT_REWARD_ACC[accIndex] do
--            	            TxGiveItem(tx, PLAYTIMEEVENT_REWARD_ACC[accIndex][i][1], PLAYTIMEEVENT_REWARD_ACC[accIndex][i][2], "GOLDKEYEVENT_"..accIndex.."_ACC")
--            	            rewardItemList[#rewardItemList + 1] = {}
--            	            rewardItemList[#rewardItemList][1] = PLAYTIMEEVENT_REWARD_ACC[accIndex][i][1]
--            	            rewardItemList[#rewardItemList][2] = PLAYTIMEEVENT_REWARD_ACC[accIndex][i][2]
--            	        end
--        	        end
--        	    end
--    	    end
--    	end
--        local ret = TxCommit(tx);
--    	CustomMongoLog(self, "GOLDKEYEVENT","Type","MinCheck", "GOLDKEY_EVENT_PLAYMIN", sObj.GOLDKEY_EVENT_PLAYMIN, "GOLDKEY_EVENT_LASTREWARD", sObj.GOLDKEY_EVENT_LASTREWARD)
----    	print('QQQQQQ',"PLAYTIMEEVENT_MIN",sObj.GOLDKEY_EVENT_PLAYMIN, "GOLDKEY_EVENT_LASTREWARD", sObj.GOLDKEY_EVENT_LASTREWARD)
--    	if PLAYTIMEEVENT_REWARD_TIME[rewardIndex] <= playMin then
--    	    local premiumState = "NO"
--    	    if IsPremiumState(self, NEXON_PC) == 1 then
--    	        premiumState = "Premium"
--    	    else
--    	        premiumState = "NO"
--    	    end
--        	CustomMongoLog(self, "GOLDKEYEVENT","Type","KeyReward", "GOLDKEY_EVENT_REWARDCOUNT", sObj.GOLDKEY_EVENT_REWARDCOUNT, "GOLDKEY_EVENT_ACCCOUNT", sObj.GOLDKEY_EVENT_ACCCOUNT, "PremiumPC", premiumState)
----        	print('WWWWWW',"PLAYTIMEEVENT_REWARD",sObj.GOLDKEY_EVENT_REWARDCOUNT,sObj.GOLDKEY_EVENT_ACCCOUNT, premiumState)
--        end
--        if accRewardFlag ~= 0 then
--            CustomMongoLog(self, "GOLDKEYEVENT", "Type", "ACCReward", "GOLDKEY_EVENT_ACCCOUNT", sObj.GOLDKEY_EVENT_ACCCOUNT, "GOLDKEY_EVENT_ACCINDEX", sObj.GOLDKEY_EVENT_ACCINDEX)
----            print('RRRRR',"PLAYTIMEEVENT_REWARD_ACC",sObj.GOLDKEY_EVENT_ACCCOUNT,sObj.GOLDKEY_EVENT_ACCINDEX)
--        end
--        if rewardItemList ~= nil and #rewardItemList > 0 then
--            local msg
--            for i = 1, #rewardItemList do
--                local itemName = GetClassString('Item', rewardItemList[i][1], "Name")
--                if itemName ~= nil then
--                    if msg == nil then
--                        msg = itemName.." : "..rewardItemList[i][2]
--                    else
--                        msg = msg..'{nl}'..itemName.." : "..rewardItemList[i][2]
--                    end
--                end
--            end
--            if msg ~= nil then
--                SendAddOnMsg(self, "NOTICE_Dm_GetItem", ScpArgMsg("PLAYTIME_NOTICEMSG1","ITEM",msg,"ACC",sObj.GOLDKEY_EVENT_ACCCOUNT), 10);
--            end
--        end
--    end
--end

function SCR_SSN_KLAPEDA_SETTIME_1(self, sObj, remainTime)
    RunZombieScript("SCR_PERIOD_INITIALIZATION", self, sObj)
    SCR_JOURNAL_REWARD_MAPFOG_PRENOTICE(self, sObj)
    
    -- EVENT_1710_HOLIDAY
--    SCR_EVENT_1710_HOLIDAY(self)

--    -- 2017.12.02 ~ 2017.12.03 LootingChance + 2000 Event --
--    SCR_EVENT_171202_171203_LOOTINGCHANCE(self)
    
    --EVENT_1804_WEEKEND
    EVENT_1804_WEEKEND_BUFF_REMOVE(self)
end

--function SCR_EVENT_1710_HOLIDAY(self)
--    if IsBuffApplied(self, 'Event_1710_Holiday') == 'YES' then
--        if IS_BASIC_FIELD_DUNGEON(self) ~= 'YES' or IS_DAY_EVENT_1710_HOLIDAY(self) ~= 'YES' then
--            RemoveBuff(self, 'Event_1710_Holiday')
--        end
--    else
--        if IS_BASIC_FIELD_DUNGEON(self) == 'YES' and IS_DAY_EVENT_1710_HOLIDAY(self) == 'YES' then
--            AddBuff(self, self, 'Event_1710_Holiday')
--        end
--    end
--end

function IS_DAY_EVENT_1710_HOLIDAY(self)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']
    
--    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--    
--    if nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2017, 9, 30) or nowbasicyday > SCR_DATE_TO_YDAY_BASIC_2000(2017, 10, 31) then
--        return 'NO'
--    end
    if wday == 1 or wday == 7 or (month == 10 and day <= 9) then
        return 'YES'
    end
    
    return 'NO'
end



function IS_DAY_EVENT_171202_171203_LOOTINGCHANCE(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
	
    if year == 2017 and month == 12 and (day >= 2 and day <= 3) then
        return 'YES'
    end
	
    return 'NO'
end
-- 2017.12.02 ~ 2017.12.03 LootingChance + 2000 Event (End Line) --



--function SCR_EVENT_1705_CORSAIR_ALARM(pc, sObj, remainTime)
--    RunScript("SCR_EVENT_1705_CORSAIR_ALARM_SUB", pc, sObj, remainTime)
--end

--function SCR_EVENT_1705_CORSAIR_ALARM_SUB(pc, sObj, remainTime)
--    local aObj = GetAccountObj(pc);
--    if aObj.EVENT_1705_CORSAIR_DIR == 300 then
--        local now_time = os.date('*t')
--        local year = now_time['year']
--        local month = now_time['month']
--        local day = now_time['day']
--        local hour = now_time['hour']
--        local min = now_time['min']
--        local nowday = year..'/'..month..'/'..day
--        
--        local rewardDate = aObj.EVENT_1705_CORSAIR_REWARD_DATE
--        
--        if rewardDate ~= nowday then
--            local lastDate = aObj.EVENT_1705_CORSAIR_DATE
--            local lastDateList = SCR_STRING_CUT(lastDate)
--            if lastDate ~= 'None' then
--                local lastDateYMIN = SCR_DATE_TO_YMIN_BASIC_2000(lastDateList[1], lastDateList[2], lastDateList[3], lastDateList[4], lastDateList[5])
--                local nowYMIN = SCR_DATE_TO_YMIN_BASIC_2000(year, month, day, hour, min)
--                if nowYMIN - lastDateYMIN >= 0 then
--                    local tx = TxBegin(pc);
--                    TxSetIESProp(tx, aObj, 'EVENT_1705_CORSAIR_MIN_COUNT' , aObj.EVENT_1705_CORSAIR_MIN_COUNT + 1)
--                	local ret = TxCommit(tx, 1);
--                end
--                if aObj.EVENT_1705_CORSAIR_MIN_COUNT == 1 or aObj.EVENT_1705_CORSAIR_MIN_COUNT == 30 or aObj.EVENT_1705_CORSAIR_MIN_COUNT == 60 then
--                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('EVENT_1705_CORSAIR_MSG3','MIN', aObj.EVENT_1705_CORSAIR_MIN_COUNT), 7)
--                end
--            end
--        end
--    end
--end

function SCR_JOURNAL_REWARD_MAPFOG_PRENOTICE(self, sObj)
    local journalMapFogRewardAll = GetExProp(self, 'JournalMapFogRewardAll')
    if journalMapFogRewardAll ~= 300 then
        local jIES = GetClass('Map', GetZoneName(self));
    	if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
    	    local mapClassName = jIES.ClassName
    	    local property = 'Reward_'..mapClassName
            local pcetc = GetETCObject(self)
    	    if GetPropType(pcetc, property) ~= nil then
    	        if pcetc[property] == 0 then
                    local mapFog = GetMapFogSearchRate(self, mapClassName)
                    
                    if self.Lv <= 50 and mapFog >= 70 then
            	        local noticeFlag = 0
                        local now_time = os.date('*t')
            	        local year = now_time['year']
            	        local yday = now_time['yday']
            	        if sObj.JournalMapFogPreNoticeDate == year..'/'..yday then
            	            for i = 1, 3 do
            	                if sObj['JournalMapFogPreNotice'..i] == mapClassName then
            	                    break
            	                elseif sObj['JournalMapFogPreNotice'..i] == 'None' then
            	                    sObj['JournalMapFogPreNotice'..i] = mapClassName
            	                    noticeFlag = 1
            	                    break
            	                end
            	            end
            	        elseif sObj.JournalMapFogPreNoticeDate ~= year..'/'..yday then
            	            sObj.JournalMapFogPreNoticeDate = year..'/'..yday
                            noticeFlag = 1
            	            for i = 1, 3 do
            	                if i == 1 then
            	                    sObj['JournalMapFogPreNotice'..i] = mapClassName
            	                else
            	                    sObj['JournalMapFogPreNotice'..i] = 'None'
            	                end
            	            end
            	        end
            	        
            	        if noticeFlag == 1 then
							local fogRevealRate = math.floor((100 - mapFog) * 10) / 10;
                            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("JournalMapFogPreReward","ZONE",jIES.Name, "PERCENT", fogRevealRate), 10);
            	        end
            	    end
            	    
                    if mapFog >= 100 then
                        SetExProp(self,'JournalMapFogRewardAll',300)
                        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("JournalMapFogRewardAll","ZONE",jIES.Name), 10);
                    end
    	        end
    	    end
    	end
    end
end

function SCR_PERIOD_INITIALIZATION(self, sObj)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    local clslist, cnt  = GetClassList("QuestProgressCheck");
	if nil == clslist or cnt == 0 then
		IMC_LOG("ERROR_IES_COULDNT_FIND_IDSPACE","idspace : QuestProgressCheck " .. "cnt : ".. cnt);
		return;
	end

    local questList = {}
    
    for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);

		if cls == nil then
			IMC_LOG("ERROR_IES_COULDNT_FIND_CLASS","idspace : QuestProgressCheck " .. "i : ".. i);
			return;
		end
		
		if cls.PeriodInitialization ~= 'None' then
            if GetPropType(sObj, cls.QuestPropertyName..'_PI') ~= nil and sObj[cls.QuestPropertyName..'_PI'] <= SCR_DATE_TO_HOUR(year, yday, hour)  then
                local flag = 0
                local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(self, cls.ClassName)
                if result1 == 'NO' or #result2 > 0 then
                    local inputTime = SCR_PERIOD_INITIALIZATION_NEXT_HOUR(cls.PeriodInitialization)
                    
                    if inputTime > 0 then
                        questList[#questList + 1] = {}
                        questList[#questList][1] = cls.ClassName
                        questList[#questList][2] = inputTime
                    end
                end
            end
        end
	end
	if #questList >= 1 then
        local tx = TxBegin(self);
    	for i = 1 , #questList do
    		local cls = GetClass("QuestProgressCheck", questList[i][1]);
    		inputTime = questList[i][2]
            if sObj[cls.QuestPropertyName..'_PI'] == 0 then
            elseif sObj[cls.QuestPropertyName..'_PI'] < inputTime then
                SCR_PERIOD_INITIALIZATION_PROPERTY(tx, self, sObj, cls.QuestPropertyName, cls)
            end
            TxSetIESProp(tx, sObj, cls.QuestPropertyName..'_PI', inputTime)
            
            local quest_auto = GetClass("QuestProgressCheck_Auto", questList[i][1]);
            
            if TryGetProp(quest_auto , 'StepRewardList1') ~= nil and TryGetProp(quest_auto , 'StepRewardList1') ~= 'None' then
                local duplicate = TryGetProp(quest_auto, 'StepRewardDuplicatePayments')
                if duplicate == 'NODUPLICATE' then
                    local refreshRewardList = TryGetProp(quest_auto, 'StepRewardPeriodRefresh')
                    if refreshRewardList ~= nil and refreshRewardList == 'YES' then
                        local lastRewardList = TryGetProp(sObj, cls.QuestPropertyName..'_SRL')
                        if lastRewardList ~= nil then
                            TxSetIESProp(tx, sObj, cls.QuestPropertyName..'_SRL', 'None')
                        end
                    end
                end
            end
    	end
    	local ret = TxCommit(tx, 1);
    end
end

function SCR_PERIOD_INITIALIZATION_NEXT_HOUR(periodInfo)
    local periodList = SCR_STRING_CUT(periodInfo)
    local inputTime = -1
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    local periodType = periodList[1]
    table.remove(periodList, 1)
    for i = 1,  #periodList do
        periodList[i] = tonumber(periodList[i])
    end
    
    if periodType == 'DAY' then
        local value = -1
        local nextdate = false
        for i = 1,  #periodList do
            if hour < periodList[i] then
                if value == -1 then
                    value = periodList[i]
                elseif value > periodList[i] then
                    value = periodList[i]
                end
            end
        end
        
        if value == -1 then
            nextdate = true
            value = periodList[1]
            for i = 1, #periodList do
                if value > periodList[i] then
                    value = periodList[i]
                end
            end
        end
        
        if nextdate == false then
            inputTime = SCR_DATE_TO_HOUR(year, yday, value)
        else
            inputTime = SCR_DATE_TO_HOUR(year, yday + 1, value)
        end
    elseif periodType == 'WDAY' then
        local value = -1
        local nextdate = false
        local i = 1
        while 1 do
            if i > #periodList then
                break
            end
            
            if SCR_WDAY_TO_HOUR(wday, hour) < SCR_WDAY_TO_HOUR(periodList[i], periodList[i+1]) then
                if value == -1 then
                    value = i
                elseif SCR_WDAY_TO_HOUR(periodList[value], periodList[value+1]) > SCR_WDAY_TO_HOUR(periodList[i], periodList[i+1]) then
                    value = i
                end
            end
            
            i = i + 2
        end
        
        
        if value == -1 then
            nextdate = true
            value = 1
            local i = 1
            while 1 do
                if i > #periodList then
                    break
                end
                
                if SCR_WDAY_TO_HOUR(periodList[value], periodList[value+1]) > SCR_WDAY_TO_HOUR(periodList[i], periodList[i+1]) then
                    value = i
                end
                
                i = i + 2
            end
        end
        
        
        if nextdate == false then
            inputTime =SCR_DATE_TO_HOUR(year, yday + periodList[value] - wday, periodList[value + 1]) 
        else
            inputTime =SCR_DATE_TO_HOUR(year, yday + periodList[value] + (7 - wday), periodList[value + 1])
        end
    elseif periodType == 'MONTH' then
        local value = -1
        local nextdate = false
        local i = 1
        while 1 do
            if i > #periodList then
                break
            end
            if SCR_DAY_TO_HOUR(day, hour) < SCR_DAY_TO_HOUR(periodList[i], periodList[i+1]) then
                if value == -1 then
                    value = i
                elseif SCR_DAY_TO_HOUR(periodList[value], periodList[value+1]) > SCR_DAY_TO_HOUR(periodList[i], periodList[i+1]) then
                    value = i
                end
            end
            i = i + 2
        end
        
        if value == -1 then
            nextdate = true
            value = 1
            local i = 1
            while 1 do
                if i > #periodList then
                    break
                end
                if SCR_DAY_TO_HOUR(periodList[value], periodList[value+1]) > SCR_DAY_TO_HOUR(periodList[i], periodList[i+1]) then
                    value = i
                end
                i = i + 2
            end
        end
        
        
        if nextdate == false then
            inputTime =SCR_DATE_TO_HOUR(year, SCR_MONTH_TO_YDAY(year,month,periodList[value]), periodList[value + 1]) 
        else
            inputTime =SCR_DATE_TO_HOUR(year, SCR_MONTH_TO_YDAY(year,month + 1,periodList[value]), periodList[value + 1])
        end
    elseif periodType == 'YEAR' then
        local value = -1
        local nextdate = false
        local i = 1
        while 1 do
            if i > #periodList then
                break
            end
            if SCR_MONTH_TO_HOUR(year,month,day,hour) < SCR_MONTH_TO_HOUR(year,periodList[i],periodList[i+1],periodList[i+2]) then
                if value == -1 then
                    value = i
                elseif SCR_MONTH_TO_HOUR(year,periodList[value],periodList[value+1],periodList[value+2]) > SCR_MONTH_TO_HOUR(year,periodList[i],periodList[i+1],periodList[i+2]) then
                    value = i
                end
            end
            i = i + 3
        end
        
        if value == -1 then
            nextdate = true
            value = 1
            local i = 1
            while 1 do
                if i > #periodList then
                    break
                end
                if SCR_MONTH_TO_HOUR(year,periodList[value],periodList[value+1],periodList[value+2]) > SCR_MONTH_TO_HOUR(year,periodList[i],periodList[i+1],periodList[i+2]) then
                    value = i
                end
                i = i + 3
            end
        end
        
        
        if nextdate == false then
            inputTime =SCR_DATE_TO_HOUR(year, SCR_MONTH_TO_YDAY(year,periodList[value],periodList[value+1]), periodList[value+2]) 
        else
            inputTime =SCR_DATE_TO_HOUR(year + 1, SCR_MONTH_TO_YDAY(year+1,periodList[value],periodList[value+1]), periodList[value+2]) 
        end
    end
    
    return inputTime
end

function SCR_PERIOD_INITIALIZATION_PROPERTY(tx, pc, sObj, questname, questIES)
    if questIES.QuestMode == 'REPEAT' and GetPropType(sObj, questIES.QuestPropertyName..'_R') ~= nil and sObj[questIES.QuestPropertyName..'_R'] > 0 then
        TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_R', 0)
    end
    if sObj[questIES.QuestPropertyName] == CON_QUESTPROPERTY_END then
        TxSetIESProp(tx, sObj, questIES.QuestPropertyName, 0)
    end
    if GetPropType(sObj, questIES.QuestPropertyName..'_TRL') ~= nil then
        TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_TRL', 'None')
    end
    if (sObj[questIES.QuestPropertyName] <= 0 or sObj[questIES.QuestPropertyName] >= 300) and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= 'None' then
        TxSetIESProp(tx, sObj, questIES.QuestPropertyName..'_RR', 'None')
    end
end

function SCR_GIMMICKCOUNTREFLASH(self)
    local sObj = GetSessionObject(self, "ssn_klapeda");
	if sObj ~= nil then
	    local cnt = GetClassCount('GimmickCountReflash')
    	local flag = 'NO'
        local tx = TxBegin(self);
    	for i = 0, cnt - 1 do
    		local reflashIES = GetClassByIndex('GimmickCountReflash', i);
    		local reflashHour = reflashIES.DayReflashHour
    		if reflashHour >= 0 and reflashIES.PropTimeInfo ~= 'None' and GetPropType(sObj, reflashIES.PropTimeInfo) ~= nil then
            	if sObj[reflashIES.PropTimeInfo] ~= 'None' then
                    local lTimeInfo = SCR_STRING_CUT(sObj[reflashIES.PropTimeInfo])
                    if #lTimeInfo == 3 then
                        local now_time = os.date('*t')
                        local year = now_time['year']
                        local yday = now_time['yday']
                        local hour = now_time['hour']
                        
                        local lyear = lTimeInfo[1]
                        local lyday = lTimeInfo[2]
                        local lhour = lTimeInfo[3]
                        
                        local laddday = SCR_YEARYDAY_TO_DAY(lyear, lyday)
                        local addday = SCR_YEARYDAY_TO_DAY(year, yday)
                        local flag = 'NO'
                        
                        if (laddday - 1)*24 + lhour < (addday - 2)*24 + reflashHour then
                            flag = 'YES'
                        elseif (laddday - 1)*24 + lhour < (addday - 1)*24 + reflashHour and hour >= reflashHour then
                            flag = 'YES'
                        end
                        
                        if flag == 'YES' then
                            if sObj[reflashIES.PropTimeInfo] ~= year..'/'..yday..'/'..hour then
                                TxSetIESProp(tx, sObj, reflashIES.PropTimeInfo, year..'/'..yday..'/'..hour)
                                CustomMongoLog(self, "FieldGimmickDayCount", "Type", "DayReflash", "PartyPropName", reflashIES.PropTimeInfo, "TryValue", year..'/'..yday..'/'..hour);
                            end
                            if sObj[reflashIES.PropDayCount] ~= 0 then
                                TxSetIESProp(tx, sObj, reflashIES.PropDayCount, 0)
                                CustomMongoLog(self, "FieldGimmickDayCount", "Type", "DayReflash", "PartyPropName", reflashIES.PropDayCount, "TryValue", 0);
                            end
                            if reflashIES.PropWithReflash ~= 'None' then
                                local withList = SCR_STRING_CUT(reflashIES.PropWithReflash)
                                if withList ~= nil and #withList > 0 and withList[1] ~= '' and withList[1] ~= 'None' then
                                    for x = 1, #withList do
                                        local mainObjIES = GetClass('SessionObject','ssn_klapeda')
                                        if GetPropType(mainObjIES, withList[x]) ~= nil and sObj[withList[x]] ~= mainObjIES[withList[x]] then
                                            TxSetIESProp(tx, sObj, withList[x], mainObjIES[withList[x]])
                                        end
                                    end
                                end
                            end
                            
                            if reflashIES.PropWithReflashTxFunc ~= 'None' then
                                local funcInfo = SCR_STRING_CUT(reflashIES.PropWithReflashTxFunc)
                                local func = _G[funcInfo[1]]
                                if func ~= nil then
                                    func(self, tx, funcInfo, reflashIES.ClassName)
                                end
                            end
                            
                        end
                    end
                elseif sObj[reflashIES.PropTimeInfo] == 'None' and GetPropType(sObj, reflashIES.PropDayCount) ~= nil and sObj[reflashIES.PropDayCount] > 0  then
                    local now_time = os.date('*t')
                    local year = now_time['year']
                    local yday = now_time['yday']
                    local hour = now_time['hour']
                    TxSetIESProp(tx, sObj, reflashIES.PropTimeInfo, year..'/'..yday..'/'..hour)
                    CustomMongoLog(self, "FieldGimmickDayCount", "Type", "ErrorModify", "PartyPropName", reflashIES.PropTimeInfo, "BeforeValue", sObj[reflashIES.PropTimeInfo], "TryValue", year..'/'..yday..'/'..hour, "PropDayCount", reflashIES.PropDayCount, "PropDayCountValue", sObj[reflashIES.PropDayCount]);
            	end
            end
        end
    	local ret = TxCommit(tx, 1);
    end
end

function SCR_PARTYQUEST_REFRESH(self)
    local sObj = GetSessionObject(self, "ssn_klapeda");
	if sObj ~= nil then
    	if sObj.PARTY_Q_TIME1 ~= 'None' and sObj.PARTY_Q_COUNT1 > 0 then
            local lTimeInfo = SCR_STRING_CUT(sObj.PARTY_Q_TIME1)
            if #lTimeInfo == 3 then
                local now_time = os.date('*t')
                local year = now_time['year']
                local yday = now_time['yday']
                local hour = now_time['hour']
                
                local lyear = lTimeInfo[1]
                local lyday = lTimeInfo[2]
                local lhour = lTimeInfo[3]
                
                local laddday = SCR_YEARYDAY_TO_DAY(lyear, lyday)
                local addday = SCR_YEARYDAY_TO_DAY(year, yday)
                local flag = 'NO'
                
                if (laddday - 1)*24 + lhour < (addday - 2)*24 + CON_PARTYQUEST_REFLASH_HOUR1 then
                    flag = 'YES'
                elseif (laddday - 1)*24 + lhour < (addday - 1)*24 + CON_PARTYQUEST_REFLASH_HOUR1 and hour >= CON_PARTYQUEST_REFLASH_HOUR1 then
                    flag = 'YES'
                end
                
                if flag == 'YES' then
                    local beforeValue1 = sObj.PARTY_Q_TIME1
                    local beforeValue2 = sObj.PARTY_Q_COUNT1
                    local tx = TxBegin(self);
                    TxSetIESProp(tx, sObj, 'PARTY_Q_TIME1', year..'/'..yday..'/'..hour)
                    TxSetIESProp(tx, sObj, 'PARTY_Q_COUNT1', 0)
                	local ret = TxCommit(tx, 1);
                    QuestStateMongoLog(self, 'None', 'PARTY_Q_TIME1', "PartyQuestRefresh", "BeforeValue", beforeValue1, "AfterValue", sObj.PARTY_Q_TIME1);
                    QuestStateMongoLog(self, 'None', 'PARTY_Q_COUNT1', "PartyQuestRefresh", "BeforeValue", beforeValue2, "AfterValue", sObj.PARTY_Q_COUNT1);
                end
            end
        elseif sObj.PARTY_Q_TIME1 == 'None' and sObj.PARTY_Q_COUNT1 > 0 then
            local now_time = os.date('*t')
            local year = now_time['year']
            local yday = now_time['yday']
            local hour = now_time['hour']
            local beforeValue1 = sObj.PARTY_Q_TIME1
            local tx = TxBegin(self);
            TxSetIESProp(tx, sObj, 'PARTY_Q_TIME1', year..'/'..yday..'/'..hour)
        	local ret = TxCommit(tx, 1);
            QuestStateMongoLog(self, 'None', 'PARTY_Q_TIME1', "ErrorModify", "BeforeValue", beforeValue1, "AfterValue", sObj.PARTY_Q_TIME1);
    	end
    end
end
