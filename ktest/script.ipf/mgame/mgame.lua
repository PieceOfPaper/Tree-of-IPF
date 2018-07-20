-- simpleai.lua

function MGAME_OPEN_UI(self, objType, uiName)

	if objType ~= 0 and GetObjType(self) ~= objType then
		return;
	end

	UIOpenToPC(self, uiName, 1);
end

function MGAME_INIT_SOBJ(cmd, sObjName)
	SetLayerSObjName(cmd:GetZoneInstID(), cmd:GetLayer(), sObjName);
end

function MGAME_SET_TIMER(cmd, curStage, eventInst, obj, key, sec, uiMsg)
	local startTimeKey = key .. "_START";
	cmd:SetUserValueSend(key);
	cmd:SetUserValueSend(startTimeKey);
	
	cmd:SetUserValue(key, sec);
	cmd:SetUserValue(startTimeKey, imcTime.GetAppTime());
	if uiMsg == nil or uiMsg == "None" then
		return;
	end

	if key ~= "ToEndBattle" then
		cmd:AddGameEnterFunc("MGAME_OPEN_TIMER_UI", uiMsg .. "#" .. key);
	else
		cmd:AddGameEnterFunc("MGAME_OPEN_GUILDBATTLE_TIMER_UI", key);
	end
end

function MGAME_OPEN_TIMER_UI(pc, key)

	local stringScp = string.format("OPEN_MGAME_TIMER(\"%s\")", key);
	ExecClientScp(pc, stringScp);

end

function MGAME_OPEN_GUILDBATTLE_TIMER_UI(pc, key)
	if key ~= "ToEndBattle" then
		return;
	end

	ExecClientScp(pc, 'GUILDBATTLE_BATTLE_START_C()');
end

function MGAME_INIT_BUY(cmd, coinPropName, propName, priceBase, priceMultiPly, addPropName, addPropValue)
	local worldInstID = cmd:GetZoneInstID();
	local zoneObj = GetLayerObject(worldInstID, 0);
	SetExProp(zoneObj, "PROP_BUY_" .. propName, 1);
	SetExProp_Str(zoneObj, "PROP_COIN_" .. propName, coinPropName);
	SetExProp(zoneObj, "PROP_BASE" .. propName, priceBase);
	SetExProp(zoneObj, "PROP_ADD" .. propName, priceMultiPly);
	SetExProp_Str(zoneObj, "PROP_ADDPROP" .. propName, addPropName);
	SetExProp(zoneObj, "PROP_ADDPROPVALUE" .. propName, addPropValue);
	SetWorldEnterFunc(worldInstID, "UPDATE_PROP_BUY_PRICE");
end

function MGAME_INIT_CHANGE_VIEW(cmd, viewRange)
	local worldInstID = cmd:GetZoneInstID();
	SetWorldViewRange(worldInstID, viewRange);
end

function MGAME_DISABLE_DEAD_DURABILITY(cmd)
	local worldInstID = cmd:GetZoneInstID();
	EnableDeadDurabilityConsume(worldInstID, 0);
end

function MGAME_ENABLE_INSTANT_PARTY(cmd)
	cmd:EnableInstantParty();
end

function MGAME_VALUE_SEND(cmd, propName)
	cmd:SetUserValueSend(propName);
end

function MGAME_ENABLE_PCCOUNT_TO_USERVALUE(cmd)
	cmd:SetUserValueSend("PCCount_1");
	cmd:SetUserValueSend("PCCount_2");
	cmd:SetUserValueSend("AlivePCCount_1");
	cmd:SetUserValueSend("AlivePCCount_2");
	cmd:EnableSavePCCountAsUserValue(true);
end

function MGAME_TEMPLATE_EQUIP(cmd, templateName)
	local worldInstID = cmd:GetZoneInstID();
	SetPCTemplateEquip(worldInstID, templateName);
end

function MGAME_RECALL(cmd, x, y, z)
	--cmd:RecallPlayers(x, y, z);
end

function GET_PROP_BUY_PRICE(self, sObj, buyPropName)

	local zoneObj = GetLayerObject(self);
	local curValue = sObj[buyPropName];
	local baseValue = GetExProp(zoneObj, "PROP_BASE".. buyPropName);
	local addValue = GetExProp(zoneObj, "PROP_ADD".. buyPropName);
	return baseValue + addValue * curValue;

end

function UPDATE_PROP_BUY_PRICE(self)
	
	if GetObjType(self) ~= OT_PC then
		return;
	end
	
	local zoneObj = GetLayerObject(self);
	local propList = GetExPropList(zoneObj);
	
	local sObj = GET_MISSION_SOBJ(self)

	for i = 1 , #propList do
		local exPropName = propList[i];
		if string.find(exPropName, "PROP_BUY_") ~= nil then
			local buyPropName = string.sub(exPropName, string.len("PROP_BUY_") + 1, string.len(exPropName));
			local curPrice = GET_PROP_BUY_PRICE(self, sObj, buyPropName);
			sObj[buyPropName .. "_Price"] = curPrice;
		end
	end
	
	SendUpdateSessionObject(self);
	
end

function SCR_MCY_BUY_ITEM(pc, arg)

	local sObj = GET_MISSION_SOBJ(pc);
	if sObj == nil then
		return;
	end

	local zoneObj = GetLayerObject(pc);

	local propName = "Buy" .. arg;
	local curPrice = sObj[propName .. "_Price"];
	local coinPropName = GetExProp_Str(zoneObj, "PROP_COIN_" .. propName);
	local addPropName = GetExProp_Str(zoneObj, "PROP_ADDPROP" .. propName);
	local addPropValue = GetExProp(zoneObj, "PROP_ADDPROPVALUE" .. propName);

	local curPrice = GET_PROP_BUY_PRICE(pc, sObj, propName);
	local curCoin = sObj[coinPropName];

	if curCoin < curPrice then
		SendSysMsg(pc, "NotEnoughMoney");	
 		return;
	end


	sObj[coinPropName] = curCoin - curPrice;
	sObj[propName] = sObj[propName] + 1;

	local nextPrice  = GET_PROP_BUY_PRICE(pc, sObj, propName);
	sObj[propName.. "_Price"] = nextPrice ;

	SendUpdateSessionObject(pc);	
	pc[addPropName] = pc[addPropName] + addPropValue;	

	-- PlayUIForce(tgt, self, forceName, image, imgSize, addon, child);

	InvalidateStates(pc);

end

function MGAME_GET_SMALLER_TEAM(self)

	local list, cnt = GetLayerPCList(self);
	
	local cnt1 = 0;
	local cnt2 = 0;
	for i = 1 , cnt do
		local pc = list[i];
		if "YES" ~= IsSameActor(pc, self) then
			if GetTeamID(pc) == 2 then
				cnt2 = cnt2 + 1;
			elseif GetTeamID(pc) == 1 then
				cnt1 = cnt1 + 1;
			end
		end
	end
	

	if cnt1 > cnt2 then
		return 2;
	end
	
	return 1;
	

end

function SET_MGAME_TEAM(self, teamID)
	SetTeamID(self, teamID);
	if teamID == 0 then
		SetCurrentFaction(self, "Law");
	else
		SetCurrentFaction(self, "Team_" .. teamID);
	end

end


---- Stage_enter_func_list
function MGAME_ENT_START_STAGE(cmd, curStage, stageName)
	cmd:StageStart(stageName);
end

function MGAME_ENT_DISABLE(cmd, curStage, stageName)
	cmd:StageDisable(stageName);
end

function MGAME_ENT_CLEAR_STAGE(cmd, curStage, stageName)
	cmd:StageClear(stageName);
end

function MGAME_ENT_DESTROY_STAGE(cmd, curStage, stageName)
	cmd:StageDestroy(stageName);
end



---- Stage Func List

function MGAME_QUEST_MON(cmd, curStage, monClsName, cnt)
	worldMGame.QuestMonSet(cmd, curStage, monClsName, cnt);
end

function MGAME_SET_QUEST_NAME(cmd, curStage, questName)
	cmd:SetQuestName(curStage, questName);
end

function MGAME_SET_TIMEOUT(cmd, curStage, sec)
	worldMGame.QuestTimeOutSet(cmd, curStage, sec);
end

function MGAME_START_STAGE(cmd, curStage, stageName)
	cmd:StageStart(stageName);
end

function MGAME_DISABLE(cmd, curStage, stageName)
	cmd:StageDisable(stageName);
end

function MGAME_CLEAR_STAGE(cmd, curStage, stageName)
	cmd:StageClear(stageName);
end

function MGAME_DESTROY_STAGE(cmd, curStage, stageName)
	cmd:StageDestroy(stageName);
end

function MGAME_DELETE_SEL_MON(cmd, curStage, objList)
	for i = 1 , #objList do
		Dead(objList[i]);
	end
end

function MGAME_RUN_SEL_MON(cmd, curStage, objList, script)
	for i = 1 , #objList do
        RunScript(script, objList[i])
	end
end

function MGAME_C_SET_MVALUE(cmd, curStage, valName, val)
	cmd:SetUserValue(valName, val);
end

function MGAME_C_SET_MVALUE_ADD(cmd, curStage, valName, val)
	local curVal = cmd:GetUserValue(valName);
	curVal = curVal + val;
	cmd:SetUserValue(valName, curVal);
end

--[[
function MGAME_SET_MVALUE_ADD(cmd, curStage, item_classname, count)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
        local itemType = GetClass("Item", item_classname).ClassID;
        local item_cnt = GetInvItemCountByType(pc, itemType);
		if count > 0 then
            RunScript('TAKE_ITEM_TX', pc, item_classname, count, "Quest")
        elseif count == 0 then
            return;
        elseif count < 0 then
            RunScript('TAKE_ITEM_TX', pc, item_classname, item_cnt, "Quest")
        end
	end
end
]]

function MGAME_START_KILLMON(cmd, curStage, objList)
    Kill(objList)
end


function MGAME_START_CHANGE_BGM(cmd, curStage, classname)
    if classname == 'None' or classname == nil then
        return
    end

    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
        local i
        for i = 1, cnt  do
            PlayMusicQueueLocal(list[i], classname)
        end
    end
end



--function MGAME_START_SETPOS(cmd, curStage, obj, x, y, z)
--	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
--	for i = 1 , cnt do
--		local pc = list[i];
--		print(pc.ClassName, x, y, z)
--		--if GetDistFromPos(pc, x, y, z) >= range then
--			SetPos(pc, x, y, z);
--		--end
--	end
--end


--- triggerFuncList
function MGAME_TRG_START_STAGE(cmd, curStage, obj, stageName)
	cmd:StageStart(stageName);
end

function MGAME_TRG_DESTROY_STAGE(cmd, curStage, obj, stageName)
	cmd:StageDestroy(stageName);
end

function MGAME_TRG_DISABLE(cmd, curStage, obj, stageName)
	cmd:StageDisable(stageName);
end

function MGAME_TRG_DELETE_SEL_MON(cmd, curStage, obj, objList)
	for i = 1 , #objList do
		Dead(objList[i]);
	end
end

function MGAME_TRG_SEND_TO_PC(cmd, curStage, obj, script)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		RunScript(script, pc)
	end
end


function MGAME_TRG_EL_OBJ(cmd, curStage, obj, script)
    RunScript(script, obj);
end

function MGAME_TRG_COND_VALUE(cmd, curStage, obj, valName, operator, val)
	return SCR_MGAME_VALUE_CHECK(cmd, valName, operator, val);
end



function MGAME_TRG_CK_MGAME_VALUE(cmd, curStage, obj, stageName, mgame_value, value)
    if obj.ClassName == 'PC' then
        local val = GetMGameValue(obj, mgame_value);
        if val == value then
            cmd:StageStart(stageName);
        end
    end
end


function MGAME_TRG_CK_MGAME_DIRECT(cmd, curStage, obj, mgame_value, value, script)
    local val = GetMGameValue(obj, mgame_value);
    if val == value then
        RunScript(script, obj, mgame_value, value)
    end
end


function MGAME_TRG_MVALUE_SETTING(cmd, curStage, obj, mgame_value, value)
    SetMGameValue(obj, mgame_value, value);
end



function MGAME_TRG_MVALUE_ADD(cmd, curStage, obj, mgame_value, value, script)
    local val = GetMGameValue(obj, mgame_value);
    SetMGameValue(obj, mgame_value, val + value);
end


--STAGE_COND

function GAME_ST_EVT_COND_ADD_VALUE(cmd, curStage, eventInst, obj, valName, val)
	local curVal = cmd:GetUserValue(valName);
	curVal = curVal + val;
	cmd:SetUserValue(valName, curVal);
end

function GAME_ST_EVT_COND_STAGE_START(cmd, curStage, eventInst, obj, stageName)
	cmd:StageStart(stageName);
end

function GAME_ST_EVT_COND_STAGE_RESTART(cmd, curStage, eventInst, obj, stageName)
	cmd:StageRestart(stageName);
end

function GAME_ST_EVT_COND_STAGE_DESTROY(cmd, curStage, eventInst, obj, stageName)
	cmd:StageDestroy(stageName);
end

function GAME_ST_EVT_COND_STAGE_CLEAR(cmd, curStage, eventInst, obj, stageName)
	cmd:StageClear(stageName);
end

function GAME_ST_EVT_COND_STAGE_DISABLE(cmd, curStage, eventInst, obj, stageName)
	cmd:StageDisable(stageName);
end

function GAME_ST_EVT_COND_VALUE_RANDOM(cmd, curStage, eventInst, obj, valCount, valName, ranRangeMin, ranRangeMax)
	local ranValList = {}
	for i = 1, valCount do
	    if i == 1 then
	        ranValList[i] = IMCRandom(ranRangeMin, ranRangeMax)
	    else
	        while 1 do
	            local ranValTemp = IMCRandom(ranRangeMin, ranRangeMax)
	            local flag = 0
	            for y = 1, i - 1 do
	                if ranValList[y] == ranValTemp then
	                    flag = 1
	                    break
	                end
	            end
	            
	            if flag == 0 then
	                ranValList[i] = ranValTemp
	                break
	            end
	        end
	    end
	end
	
	if #ranValList == valCount then
	    for i = 1, valCount do
	        cmd:SetUserValue(valName..i, ranValList[i]);
--	        print('AAA',ranValList[i],cmd:GetUserValue(valName..i))
	    end
	end
end

-- stageEvent function List

function GAME_ST_EVT_COND_TIMECHECK(cmd, curStage, eventInst, obj, sec)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	local lastExecSec = eventInst:GetUserValue("TIME");
	if lastExecSec == 0.0 then
		eventInst:SetUserValue("TIME", imcTime.GetAppTime());
		return 0;
	end

	local curTime = imcTime.GetAppTime();
	if curTime > lastExecSec + sec then
		eventInst:SetUserValue("TIME", curTime);
		return 1;
	end

	return 0;
end

function GAME_ST_EVT_COND_TIMECHECK_START(cmd, curStage, eventInst, obj, sec)
--    print('BBBBBBBBBBBBBBB',cmd, curStage, eventInst, sec)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	local lastExecSec = eventInst:GetUserValue("TIME");
	if lastExecSec == 0.0 then
--	    print('!!!!!!!!!!!!!!!',lastExecSec,imcTime.GetAppTime())
		eventInst:SetUserValue("TIME", imcTime.GetAppTime());
		return 1;
	end

	local curTime = imcTime.GetAppTime();
	if curTime > lastExecSec + sec then
		eventInst:SetUserValue("TIME", curTime);
		return 1;
	end

	return 0;
end

function GAME_ST_EVT_COND_STAGE_TIME_CHECK(cmd, curStage, eventInst, obj, sec)
    
	local stageTime = cmd:GetStageTime(curStage);
	if stageTime > sec then
		return 1;
	end

	return 0;

end

function GAME_EVT_RESET_TIME(cmd, curStage, eventInst, obj)
	--print("111111111111111111111111111111111111111", imcTime.GetAppTime())
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	eventInst:SetUserValue("TIME", 0.0);
	--print("222222222222222222222222222222222222222", imcTime.GetAppTime())
end

function GAME_EVT_ON_BYNAME(cmd, curStage, eventInst, obj, eventName)
	cmd:EnableEvent(curStage, eventName, 1);
end

function GAME_EVT_OFF_BYNAME(cmd, curStage, eventInst, obj, eventName)
	cmd:EnableEvent(curStage, eventName, 0);
end

function GAME_EVT_OFF(cmd, curStage, eventInst, obj)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	eventInst:Enable(0);
end

function GAME_ST_EVT_COND_VALUE(cmd, curStage, eventInst, obj, valName, operator, val)
	return SCR_MGAME_VALUE_CHECK(cmd, valName, operator, val);
	
end

function SCR_MGAME_VALUE_CHECK(cmd, valName, operator, val)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] SCR_MGAME_VALUE_CHECK CheckFlag5: cnt['..cnt..'], round['..round..']');
		end
		cmd:SetUserValue('CHECK_FLAG5', 1);
	end
        
	local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG5'));
	if checkFlag == 0 then
		return 0;
	end

	local curValue = cmd:GetUserValue(valName);
    
	if operator == "UNDER" then
		if curValue <= val then            
            if cmd:GetMGameName() == 'battlefield' then
			    local round = cmd:GetUserValue('Round');
			    IMC_LOG('INFO_NORMAL', '[TBL_LOG] SCR_MGAME_VALUE_CHECK UNDER: cnt['..cnt..'], round['..round..'], cur['..curValue..'], val['..val..']');
		    end

			return 1;
		else
			return 0;
		end
	elseif operator == "OVER" then
		if curValue >= val then            
            if cmd:GetMGameName() == 'battlefield' then
			    local round = cmd:GetUserValue('Round');
			    IMC_LOG('INFO_NORMAL', '[TBL_LOG] SCR_MGAME_VALUE_CHECK OVER: cnt['..cnt..'], round['..round..'], cur['..curValue..'], val['..val..']');
		    end

			return 1;
		else
			return 0;
		end
	elseif operator == "DIF" then
		if curValue ~= val then
			return 1;
		else
			return 0;
		end
	else
		if curValue == val then
			return 1;
		end
	end
	
	return 0;
end


function SCR_MGAME_VALUE_CHECK_2(cmd, curStage, eventInst, obj, valName, operator, val)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
        local curValue
        local i
        for i = 1, cnt do
            curValue = GetMGameValue(list[i], valName)
            break
        end
    	if operator == "UNDER" then
    		if curValue <= val then
    			return 1;
    		else
    			return 0;
    		end
    	elseif operator == "OVER" then
    		if curValue >= val then
    			return 1;
    		else
    			return 0;
    		end
    	else
    		if curValue == val then
    			return 1;
    		end
    	end
	end
	return 0;
end


function GAME_ST_EVT_COND_VALUE_COMPARE(cmd, curStage, eventInst, obj, valName, operator, valName2)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] GAME_ST_EVT_COND_VALUE_COMPARE_ CheckFlag4: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		cmd:SetUserValue('CHECK_FLAG4', 1);
	end

    local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG4'));
	if checkFlag == 0 then
		return 0;
	end

	local val1 = cmd:GetUserValue(valName);
	local val2 = cmd:GetUserValue(valName2);
	if operator == "under" then
		if val1 < val2 then            
			return 1;
		else
			return 0;
		end
	elseif operator == "over" then
		if val1 > val2 then
			return 1;
		else
			return 0;
		end
	else
		if val1 == val2 then            
            if cmd:GetMGameName() == 'battlefield' then
	            local round = cmd:GetUserValue('Round');
	            IMC_LOG('INFO_NORMAL', '[TBL_LOG] GAME_ST_EVT_COND_VALUE_COMPARE: stage['..curStage..'], cnt['..cnt..'], round['..round..'], val1['..val1..'], val2['..val2..']');
            end
			return 1;
		end
	end
	
	return 0;
end

--MINIGAME_END
function MGAME_END(cmd, curStage, eventInst, obj, removeInstanceNow)
	if removeInstanceNow == nil then
		removeInstanceNow = 0;
	end
	
	cmd:EndGame(removeInstanceNow);
end


function GAME_ST_EVT_EXEC_VALUE(cmd, curStage, eventInst, obj, valName, val)
	cmd:SetUserValue(valName, val);
end

function GAME_ST_EVT_ADD_VALUE(cmd, curStage, eventInst, obj, valName, val)
	local curVal = cmd:GetUserValue(valName);
	curVal = curVal + val;
	cmd:SetUserValue(valName, curVal);
end

function GAME_ST_EVT_EXEC_STAGE_START(cmd, curStage, eventInst, obj, stageName)
	cmd:StageStart(stageName);
end

function GAME_ST_EVT_EXEC_STAGE_RESTART(cmd, curStage, eventInst, obj, stageName)
	cmd:StageRestart(stageName);
end

function GAME_ST_EVT_EXEC_STAGE_DESTROY(cmd, curStage, eventInst, obj, stageName)
	cmd:StageDestroy(stageName);
end

function GAME_ST_EVT_EXEC_STAGE_CLEAR(cmd, curStage, eventInst, obj, stageName)
	cmd:StageClear(stageName);
end

function GAME_ST_EVT_EXEC_STAGE_DISABLE(cmd, curStage, eventInst, obj, stageName)
	cmd:StageDisable(stageName);	
end

function MGAME_APPLY_TEAM(cmd, teamID, func, ...)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		if GetTeamID(pc) == teamID then
			func(pc, ...);
		end
	end
end

--function MGAME_LIST_MON(cmd, curStage, eventInst, obj, 

function _MGAME_REWARD(pc, r1, r2, r3)
	GivePickReward(pc, r1, 0.15, 0.3,  r2, 0.40, 0.5, r3, 0.55, 0.2 ); 
end

function MGAME_TEAM_REWARD(cmd, curStage, eventInst, obj, teamID, r1, r2, r3)
	MGAME_APPLY_TEAM(cmd, teamID, _MGAME_REWARD, r1, r2, r3);
end

function MGAME_TEAM_FACTION(cmd, curStage, eventInst, obj, teamID, faction)
	MGAME_APPLY_TEAM(cmd, teamID, SetCurrentFaction, faction);
end

function MGAME_EXEC_SETPOS_TEAM(cmd, curStage, eventInst, obj, teamID, x, y, z)
	MGAME_APPLY_TEAM(cmd, teamID, SetPos, x, y, z);
end

function MGAME_EXEC_SETPOS(cmd, curStage, eventInst, obj, x, y, z)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		--if GetDistFromPos(pc, x, y, z) >= range then
			SetPos(pc, x, y, z);
		--end
	end
end

function GET_RANDOM_INDEX_LIST(listCnt, getCnt)
	local newList = {};
	for i = 1 , listCnt do
		newList[i] = i;
	end

	local ret = {};
	while 1 do
		local curListCnt = #newList;
		local randIndex = IMCRandom(1, curListCnt);
		ret[#ret+1] = newList[randIndex];
		newList[randIndex] = newList[#newList];
		newList[#newList] = nil;

		if #ret >= getCnt then
			return ret;
		end
	end
end

function MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, monList, genCnt, randCnt)
	
	local selMonCnt = #monList / 2;
	if randCnt == 0 or randCnt >=  selMonCnt then
		for i = 1 , selMonCnt do
			local stageIndex = monList[2 * i - 1];
			local monIndex = monList[2 * i];
			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
		end 		
	else
		local list = GET_RANDOM_INDEX_LIST(selMonCnt, randCnt);
		for i = 1 , #list do
			local randIndex = list[i];
			local stageIndex = monList[2 * randIndex - 1];
			local monIndex = monList[2 * randIndex];
			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
		end
	end

end

function MGAME_EVT_COND_MONCNT_CREMON(cmd, curStage, eventInst, obj, check_monList, cre_monList, valName)
    local curVal = cmd:GetUserValue(valName);
    if curVal >= 4 then
        genCnt = 5
        randCnt = 0
        MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, cre_monList, genCnt, randCnt)
    elseif curVal >= 3 then
        genCnt = 3
        randCnt = 0
        MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, cre_monList, genCnt, randCnt)
    elseif curVal >= 2 then
        genCnt = 2
        randCnt = 0
        MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, cre_monList, genCnt, randCnt)
    elseif curVal >= 1 then
		genCnt = 2
		randCnt = 0
		MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, cre_monList, genCnt, randCnt)
    elseif curVal >= 0 then
        genCnt = 2
        randCnt = 0
        MGAME_EVT_EXEC_CREMON(cmd, curStage, eventInst, obj, cre_monList, genCnt, randCnt)
	end
end

function MGAME_EVT_EXEC_CREMON_BY_SCRIPT(cmd, curStage, eventInst, obj, monList, countScript, postBornScript, getMonsterTypeScript)
	
	local countFunc = _G[countScript];
	--	local worldInstID = cmd:GetZoneInstID();
	-- local zoneObj = GetLayerObject(worldInstID, 0);

	local count = countFunc(cmd);
	getMonsterTypeScript = _G[getMonsterTypeScript];

	local selMonCnt = #monList / 2;
	for i = 1 , selMonCnt do
		local stageIndex = monList[2 * i - 1];
		local monIndex = monList[2 * i];
		local genIndex = 0;
		for j = 1 , count do
			local monName = getMonsterTypeScript(cmd, genIndex);
			local monType = GetClass("Monster", monName).ClassID;
			cmd:GenMonsterByKey(stageIndex, monIndex, 1, monType, postBornScript);
			genIndex = genIndex + 1;
		end
	end 		

end

function MGAME_EVT_EXEC_DELMON(cmd, curStage, eventList, obj, objListPtr)
	cmd:DelMonsterByPtr(objListPtr);
end

function MGAME_EVT_EXEC_CREMON_PCCOUNT(cmd, curStage, eventInst, obj,monList, varPCCount, randCnt)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local livePCCnt = 0
    local genCnt = 0
    if cnt > 0 then
    	for i = 1 , cnt do
    		local pc = list[i];
    		if IsDead(pc) ~= 1 then
    	        livePCCnt = livePCCnt + 1
    	    end
    	end
    	
    	genCnt = math.floor(livePCCnt * varPCCount)
    	
    	if genCnt < 1 then
    	    genCnt = 1
    	end
    	
    	local selMonCnt = #monList / 2;
    	if randCnt == 0 or randCnt >=  selMonCnt then
    		for i = 1 , selMonCnt do
    			local stageIndex = monList[2 * i - 1];
    			local monIndex = monList[2 * i];
    			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
    		end 		
    	else
    		local list = GET_RANDOM_INDEX_LIST(selMonCnt, randCnt);
    		for i = 1 , #list do
    			local randIndex = list[i];
    			local stageIndex = monList[2 * randIndex - 1];
    			local monIndex = monList[2 * randIndex];
    			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
    		end
    	end
    end
end

function MGAME_EVT_EXEC_CREMON_PCCOUNT_2(cmd, curStage, eventInst, obj,monList, basicMonCount, varPCCount, randCnt)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local livePCCnt = 0
    local genCnt = basicMonCount
    if cnt > 0 then
    	for i = 1 , cnt do
    		local pc = list[i];
    		if IsDead(pc) ~= 1 then
    	        livePCCnt = livePCCnt + 1
    	    end
    	end
    	
    	genCnt = genCnt + math.floor(livePCCnt * varPCCount)
    	
    	if genCnt < 1 then
    	    genCnt = 1
    	end
    	
    	local selMonCnt = #monList / 2;
    	if randCnt == 0 or randCnt >=  selMonCnt then
    		for i = 1 , selMonCnt do
    			local stageIndex = monList[2 * i - 1];
    			local monIndex = monList[2 * i];
    			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
    		end 		
    	else
    		local list = GET_RANDOM_INDEX_LIST(selMonCnt, randCnt);
    		for i = 1 , #list do
    			local randIndex = list[i];
    			local stageIndex = monList[2 * randIndex - 1];
    			local monIndex = monList[2 * randIndex];
    			cmd:GenMonsterByKey(stageIndex, monIndex, genCnt);
    		end
    	end
    end
end

function MGAME_EVT_SCP_TO_MON(cmd, curStage, eventInst, obj, monList, scpName)
    if monList ~= nil then
    
    	for i = 1 , #monList do
    		RunScript(scpName, monList[i]);
    	end
    end

end

--function MGAME_EVT_TARGET_CAMERA(cmd, curStage, eventInst, obj, select_mon, watchTime, speed, accelation)
--    print("AAAAAAAAAAAAAA")
--    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
--	for i = 1 , cnt do
--	    if IsDead(list[i]) ~= 1 then
--	        RunScript('MGAME_EVT_TARGET_CAMERA_RUN', list[i], select_mon, watchTime, speed, accelation)
--	    end
--	end
--end
--
--function MGAME_EVT_TARGET_CAMERA_RUN(pc, select_mon, watchTime, speed, accelation)
--    TargetCamera(pc, select_mon, speed, accelation)
--    sleep(watchTime)
--    ChangeCamera(pc, 0);
--end


function MGAME_EVT_EXEC_DIRECTION(cmd, curStage, eventInst, obj, directionName)
	cmd:PlayDirection(directionName);
end

function MGAME_EVT_EXEC_DIRECTION_EACH(cmd, curStage, eventInst, obj, directionName)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
        local i
        for i = 1, cnt  do
            PlayDirection(list[i], directionName)
        end
    end
end


function MGAME_EVT_EXEC_CHANGE_BGM(cmd, curStage, eventInst, obj, classname)
    if classname == 'None' or classname == nil then
        return
    end
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
        local i
        for i = 1, cnt  do
            PlayMusicQueueLocal(list[i], classname)
        end
    end
end

function MGAME_EVT_EXEC_DIRECTION_REGMON(cmd, curStage, eventInst, obj, directionName, objList)
	cmd:PlayDirectionAsMGameMonster(directionName, objList[1], objList[2]);
end

function MGAME_EVT_COND_MONCNT(cmd, curStage, eventInst, obj, monList, limitCnt)
	if #monList <= limitCnt then
		return 1;
	end

	return 0;
end

function MGAME_EVT_COND_MONCNT_OVER(cmd, curStage, eventInst, obj, monList, limitCnt)
	if #monList >= limitCnt then
		return 1;
	end

	return 0;
end

function MGAME_EVT_COND_MONHP(cmd, curStage, eventInst, obj, monList, perValue, perOperator, monCount, monOperator)
    local flag = 0
    local result = 0
    for i = 1, #monList do
        if perOperator == 'EQ' then
            if math.floor(monList[i].HP/monList[i].MHP * 100) == perValue then
                flag = flag + 1
            end
        elseif perOperator == 'OVER' then
            if math.floor(monList[i].HP/monList[i].MHP * 100) >= perValue then
                flag = flag + 1
            end
        elseif perOperator == 'UNDER' then
            if math.floor(monList[i].HP/monList[i].MHP * 100) <= perValue then
                flag = flag + 1
            end
        end
    end
    
    if monOperator == 'EQ' then
        if flag == monCount then
            result = 1
        end
    elseif monOperator == 'OVER' then
        if flag >= monCount then
            result = 1
        end
    elseif monOperator == 'UNDER' then
        if flag <= monCount then
            result = 1
        end
    end
    
    return result
end

function MGAME_EVT_COND_PCCNT(cmd, curStage, eventInst, obj, limitCnt)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local limitTime = math.floor(cmd:GetUserValue('LIMIT_TIME'));
	if limitTime == 0 then
		limitTime = math.floor(imcTime.GetAppTime() + 60);
		cmd:SetUserValue('LIMIT_TIME', limitTime);

		if cnt == 0 and cmd:GetMGameName() == 'MISSION_CASTLE_01' then
			IMC_LOG('INFO_MINIGAME_CONDITION', '3. MGAME_EVT_COND_PCCNT: cnt=0 but contScp called!-- curStage['..curStage..']');
		end

		return 0;
	elseif imcTime.GetAppTime() < limitTime then		
		return 0;
	end

    
    local livePCCnt = 0
	for i = 1 , cnt do
	    if IsDead(list[i]) ~= 1 then
	        livePCCnt = livePCCnt + 1
	    end
	end
	if livePCCnt <= limitCnt then
        return 1
    end
    
	return 0;
end

function MGAME_EVT_COND_PCCNT_FACTION(cmd, curStage, eventInst, obj, faction, limitCnt)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local livePCCnt = 0
	for i = 1 , cnt do
		local pc = list[i];
	    if GetCurrentFaction(pc) == faction and IsDead(pc) ~= 1 then
	        livePCCnt = livePCCnt + 1
	    end
	end

	if livePCCnt <= limitCnt then
        return 1
    end
    
	return 0;
end

function MGAME_EVT_NO_CONNECTED_PC(cmd, curStaage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt == 0 then
		return 1;
	end

	return 0;
end

function MGAME_EVT_COND_PCCNT_PROPERTY(cmd, curStaage, eventInst, obj, propName, propValue, checkCount)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local livePCCnt = 0
	for i = 1 , cnt do
		local pc = list[i];

		local etcObj = GetETCObject(pc);
	    if etcObj[propName] == propValue and IsDead(pc) ~= 1 then
	        livePCCnt = livePCCnt + 1
	    end
	end

	if livePCCnt <= checkCount then
        return 1
    end
    
	return 0;

end

function MGAME_EVT_COND_PC_CON_TEAM(cmd, curStage, eventInst, obj, teamID, limitCnt)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
		if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] 1. MGAME_EVT_COND_PC_CON_TEAM_check flag: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end

		cmd:SetUserValue('CHECK_FLAG', 1);
	end

	local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG'));
	if checkFlag == 0 then
		return 0;
	end
	
    local livePCCnt = 0
	for i = 1 , cnt do
		local pc = list[i];

	    if GetTeamID(pc) == teamID and IsDead(pc) ~= 1 then
	        livePCCnt = livePCCnt + 1
	    end
	end

	if livePCCnt <= limitCnt then
		if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] 2. MGAME_EVT_COND_PC_CON_TEAM: stage['..curStage..'], teamID['..teamID..'], round['..round..']');
		end

        return 1
    end
    
	return 0;
end

function MGAME_EVT_COND_PC_CON_FACTION(cmd, curStage, eventInst, obj, faction, limitCnt)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] MGAME_EVT_COND_PC_CON_FACTION_check flag2: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		cmd:SetUserValue('CHECK_FLAG2', 1);
	end

	local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG2'));
	if checkFlag == 0 then
		return 0;
	end
	

    local livePCCnt = 0
	for i = 1 , cnt do
		local pc = list[i];
	    if faction == "All" or GetCurrentFaction(pc) == faction  then
	        livePCCnt = livePCCnt + 1
	    end
	end

	if livePCCnt <= limitCnt then
		if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] MGAME_EVT_COND_PC_CON_FACTION: stage['..curStage..'], faction['..faction..'], round['..round..']');
		end

        return 1
    end
    
	return 0;

end

function MGAME_EVT_COND_PCCNT_OVER(cmd, curStage, eventInst, obj, limitCnt)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local livePCCnt = 0
	for i = 1 , cnt do
	    if IsDead(list[i]) ~= 1 then
	        livePCCnt = livePCCnt + 1
	    end
	end
	
    if livePCCnt >= limitCnt then
        return 1
	end

	return 0;
end

function MGAME_EVT_COND_ITEM_CNT(cmd, curStage, eventInst, obj, itemName, perOperator, itemCnt)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local totalCount = 0

	local itemType = GetClass("Item", itemName).ClassID;
	for i = 1 , cnt do
		local pc = list[i];
		local cnt = GetInvItemCountByType(pc, itemType);
		totalCount = totalCount + cnt;	    
	end
    if perOperator == 'EQ' then
   
        if totalCount == itemCnt then
            return 1
    	end
    elseif perOperator == 'OVER' then
        if totalCount >= itemCnt then
            return 1
    	end
    elseif perOperator == 'UNDER' then
        if totalCount <= itemCnt then
            return 1
    	end
    end
	return 0;

end

function MGAME_EVT_COND_SCRIPT(cmd, curStage, eventInst, obj, scpName)

	local fun = _G[scpName];
	return fun(cmd, curStage, eventInst, obj);

end

function CHECK_TEAM2_HP_MORE(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] CHECK_TEAM2_HP_MORE CheckFlag6: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		cmd:SetUserValue('CHECK_FLAG6', 1);
	end
        
	local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG6'));
	if checkFlag == 0 then
		return 0;
	end

	local team1HP = 0;
	local team2HP = 0;

	--local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1 , cnt do
		local pc = list[i];
		local teamID = GetTeamID(pc);
		if teamID == 1 then
			team1HP = team1HP + GetHpPercent(pc);
		else
			team2HP = team2HP + GetHpPercent(pc);
		end
	end

	if team2HP > team1HP then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] CHECK_TEAM2_HP_MORE: stage['..curStage..'], cnt['..cnt..'], round['..round..'], team2['..team2HP..'], team1['..team1HP..']');
		end
		return 1;
	end

	return 0;

end

function CHECK_TEAM1_HP_MORE(cmd, curStage, eventInst, obj)
	local team1HP = 0;
	local team2HP = 0;
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
		if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] CHECK_TEAM1_HP_MORE_ check flag3: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end

		cmd:SetUserValue('CHECK_FLAG3', 1);
	end

	local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG3'));
	if checkFlag == 0 then
		return 0;
	end

    for i = 1 , cnt do
		local pc = list[i];
		local teamID = GetTeamID(pc);
		if teamID == 1 then
			team1HP = team1HP + GetHpPercent(pc);
		else
			team2HP = team2HP + GetHpPercent(pc);
		end
	end

	if team1HP > team2HP then
		if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] 5. CHECK_TEAM1_HP_MORE: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		return 1;
	end

	return 0;

end

function MGAME_EVT_TAKE_ITEM(cmd, curStage, eventInst, obj, itemName)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    local totalCount = 0

	local itemType = GetClass("Item", itemName).ClassID;
	for i = 1 , cnt do
		local pc = list[i];
		local item_cnt = GetInvItemCountByType(pc, itemType);
    	if item_cnt > 0 then
    		RunScript('TAKE_ITEM_TX', pc, itemName, item_cnt, "Quest")
    	end
	end
	
end



function MGAME_EVT_GIVE_ITEM(cmd, curStage, eventInst, obj, itemName, giveway)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], itemName, nil, nil, nil,giveway, nil)
	end
end

function MGAME_EVT_TAKE_ITEM_LIST(cmd, curStage, eventInst, obj, itemName, takeway)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], nil, itemName, nil, nil,takeway, nil)
	end
end

function MGAME_EXEC_PRECHECK_GIVE_TAKE_SOBJ_ACHIEVE_TX(cmd, curStage, eventInst, obj, preCheck, giveList, takeList, setList, addList, giveway, dungeoncount, tokenBonus)
    local func
    if preCheck ~= 'None' then
        func = _G[preCheck]
    end
    if giveList == 'None' then
        giveList = nil
    end
    if takeList == 'None' then
        takeList = nil
    end
    if setList == 'None' then
        setList = nil
    end
    if addList == 'None' then
        addList = nil
    end
    
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
	    local result
	    if func ~= nil then
	        result = func(list[i])
	    end
	    if result ~= 'NO' then
    		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], giveList, takeList, addList, nil,giveway, setList, nil, nil, dungeoncount, tokenBonus)
    	end
	end
end

function MGAME_EXEC_GIVE_TAKE_SOBJ_ACHIEVE_TX(cmd, curStage, eventInst, obj, giveList, takeList, setList, addList, giveway, dungeoncount, tokenBonus)
    if giveList == 'None' then
        giveList = nil
    end
    if takeList == 'None' then
        takeList = nil
    end
    if setList == 'None' then
        setList = nil
    end
    if addList == 'None' then
        addList = nil
    end
    
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], giveList, takeList, addList, nil,giveway, setList, nil, nil, dungeoncount, tokenBonus)
	end
end

function MGAME_EXEC_GIVE_TAKE_SOBJ_ACHIEVE2_TX(cmd, curStage, eventInst, obj, giveList, takeList, setList, addList, AchieveList, giveway, dungeoncount, tokenBonus, mGameName)
    if giveList == 'None' then
        giveList = nil
    end
    if takeList == 'None' then
        takeList = nil
    end
    if setList == 'None' then
        setList = nil
    end
    if addList == 'None' then
        addList = nil
    end
    if AchieveList == 'None' then
        AchieveList = nil
    end
    
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], giveList, takeList, addList, AchieveList,giveway, setList, nil, nil, dungeoncount, tokenBonus, mGameName)
	end
end

function MGAME_EVT_BROADCAST_PCNAME(cmd, curStage, eventInst, obj, itemName, sec)
    
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local itemType = GetClass("Item", itemName).ClassID;
	local NameID = GetClass("Item", itemName).Name;
	
	
	for i = 1 , cnt do
		local pc = list[i];
		local item_cnt = GetInvItemCountByType(pc, itemType);
		if item_cnt > 0 then
    		AddoOnMsgToZone(pc, "NOTICE_Dm_Clear", pc.Name..ScpArgMsg("Auto_Nimi_[_")..NameID..ScpArgMsg("Auto__]eul_KaJiKo_issSeupNiDa!"), sec);
    	end
    	
	end

end


function MGAME_RETURN(cmd, curStage, eventInst, obj, x, y, z)
	cmd:ReturnPlayers();
end

function MGAME_COUNTDOWN(zoneID, layer, curStage, eventInst, obj, sec)
	local startSec = imcTime.GetAppTime();
	local lastSec = -1;
	while 1 do
		local elap = math.floor(imcTime.GetAppTime() - startSec);
		if elap >= lastSec then
			lastSec = elap;
			RunClientScriptToWorld(zoneID, "SHOW_SIMPLE_MSG", "{@st55_a}" .. (sec - elap));
			if elap >= sec then
				return;
			end			
		end

		sleep(10);
	end
end
  
function MGAME_EXEC_RAIDSSN_MODIFY(cmd, curStage, eventInst, obj, propName, customValue, fixedVale)
    if propName ~= nil and propName ~= 'None' then
        local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    	for i = 1 , cnt do
    	    RunScript("MGAME_EXEC_RAIDSSN_MODIFY_RUNSCP", list[i], propName, customValue, fixedVale);
    	end
    end
end

function MGAME_EXEC_RAIDSSN_MODIFY_RUNSCP(pc, propName, customValue, fixedVale)
    local raid_sObj = GetSessionObject(pc, 'ssn_raid')
    if raid_sObj == nil then
        CreateSessionObject(pc, 'ssn_raid', 1)
        raid_sObj = GetSessionObject(pc, 'ssn_raid')
    end
    if GetPropType(raid_sObj, propName) ~= nil then
	    if fixedVale ~= nil and tonumber(fixedVale) ~= nil and fixedVale ~= 0 then
            raid_sObj[propName] = fixedVale
        elseif customValue ~= nil and tonumber(customValue) ~= nil and customValue ~= 0 then
            raid_sObj[propName] = raid_sObj[propName] + customValue
        end
        
        SaveSessionObject(pc, raid_sObj)
    end
end




function MGAME_EXEC_RAIDSSN_STARTTIME(cmd, curStage, eventInst, obj, propName)
    if propName ~= nil and propName ~= 'None' then
        local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    	for i = 1 , cnt do
            
    	    local raid_sObj = GetSessionObject(list[i], 'ssn_raid')
            if raid_sObj == nil then
                CreateSessionObject(list[i], 'ssn_raid', 1)
                raid_sObj = GetSessionObject(list[i], 'ssn_raid')
            end
            if GetPropType(raid_sObj, propName) ~= nil then
        	    local now_time = os.date('*t')
                local now_time_min = now_time['yday'] * 60 * 24 + now_time['hour'] * 60 + now_time['min']
                
                raid_sObj[propName] = now_time_min
                SaveSessionObject(list[i], raid_sObj)
            end
    	end
    end
end


--function MGAME_DIRECT_FUC_RUN(cmd, curStage, eventInst, obj, script)
--	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
--	for i = 1 , cnt do
--		local pc = list[i];
--	    RunScript(script, pc)
--	    break
--	end
--end

--function MGAME_EXEC_RAIDSSN_STARTTIME_RUNSCP(pc, propName)
--    local raid_sObj = GetSessionObject(pc, 'ssn_raid')
--    if raid_sObj == nil then
--        CreateSessionObject(pc, 'ssn_raid', 1)
--        raid_sObj = GetSessionObject(pc, 'ssn_raid')
--    end
--    if GetPropType(raid_sObj, propName) ~= nil then
--	    if fixedVale ~= nil and tonumber(fixedVale) ~= nil and fixedVale ~= 0 then
--            raid_sObj[propName] = fixedVale
--        elseif customValue ~= nil and tonumber(customValue) ~= nil and customValue ~= 0 then
--            raid_sObj[propName] = raid_sObj[propName] + customValue
--        end
--        
--        SaveSessionObject(pc, raid_sObj)
--    end
--end




function MGAME_EXEC_SSN_ADD(cmd, curStage, evetInst, dontknow, sObjName, propName, addValue)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		local sObj = GetSessionObject(pc, sObjName)
		if sObj ~= nil then
			sObj[propName] = sObj[propName] + addValue;
		end
    end
end

function MG_EVT_REWARD_START(cmd, curStage, eventInst, obj, sObjName, propName, scpName, reward1, reward2, reward3)
	local zoneObj = GetMGameLayerObj(cmd);
	-- SetWorldEnterFunc(worldInstID, "UPDATE_PROP_BUY_PRICE");
end

function GT_SELECT_REWARD(cmd, curStage, eventInst, obj, MgameName)


	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = nil;
	local sendPartyLeader = false;
	if cnt > 0 then
		for i = 1, cnt do
			pc = list[i]
			SetExProp_Str(pc, "NEXT_GT_MGAME_NAME", cmd:GetMGameName());

			if IsPartyLeaderPc(GetPartyObj(pc), pc) == 1 then
				--PROGRESS_REWARD
				sendPartyLeader = true;
				SendAddOnMsg(pc, "EARTH_TOWER_POPUP", MgameName, 1);
			else
				--SendAddOnMsg(pc, "EARTH_TOWER_POPUP", MgameName, 0);
			end
		end
	end

	
	if sendPartyLeader == false then
		if cnt > 0 then
			for i = 1, cnt do
				pc = list[i]

				if IsPartyLeaderPc(GetPartyObj(pc), pc) == 1 then
				else
					SendAddOnMsg(pc, "EARTH_TOWER_POPUP", MgameName, 1);
					break;
				end
			end
		end
	end
end	



function RAID_END_REWARD(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());

	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt);
	if pc ~= nil then
		ChangePartyProp(pc, PARTY_GUILD, "RewardBidState", 1)
		RunScript('CREATE_REWARD_BID_ITEM', pc)
	else
		ErrorLog("RAID_END_REWARD() can not find guild member.");
	end
end	


function RAID_END_REWARD_CHECK(cmd, curStage, eventInst, obj)
	local mGameName = cmd:GetMGameName();
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	
	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt);
	if pc ~= nil then
		local guildObj = GetGuildObj(pc);
		if guildObj.RewardBidState == 1 then
			return 0;
		else
			return 1;
		end
	end
end	



function MGAME_EXEC_MON_PC_MSG(cmd, curStage, eventInst, obj, monName, msgText)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		local han = GET_FOLLOW_BY_NAME(pc, monName);
		if han ~= nil then
			CHARICON_MSG(pc, msgText);
		end
	end
end

function BROAD_POINT_ADD_MSG(pc, propName, addValue)

	local msg = ScpArgMsg("{Name}Get{Point}BecauseHave{MonName}LastTime", "Name", GetTeamName(pc), "Point", addValue, "MonName", GetClass("Monster", "Hanaming_Flag").Name);
	RunClientScriptToWorld(pc, "SHOW_SIMPLE_MSG", "{@st55_a}" .. msg);

end

function MGAME_EXEC_SSN_ADD_MON(cmd, curStage, eventInst, obj, monName, sObjName, propName, addValue, funcName)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		local han = GET_FOLLOW_BY_NAME(pc, monName);
		if han ~= nil then
			local sObj = GetSessionObject(pc, sObjName)
			if sObj ~= nil then
				sObj[propName] = sObj[propName] + addValue;

				if funcName ~= "None" then
					local func = _G[funcName];
					if func ~= nil then
						func(pc, propName, addValue);
					end
				end
			end
		end
    end
end

function MGAME_EXEC_REVIVE(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		ResurrectPc(pc, "MGAME_EXEC_REVIVE", 0, 100);
	end
end

function MGAME_EXEC_ACTORSCP(cmd, curStage, eventInst, obj, actorScp)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		RunActorScp(pc, actorScp);
	end
end

function MGAME_EXEC_ACTORSCP_MAIN(cmd, curStage, eventInst, obj, actorScp)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer())
   	for i = 1 , cnt do
        local pc = list[i]
    	if actorScp ~= "None" then
    		local func = _G[actorScp]
    		if func ~= nil then
    			func(pc)
    		end
    	end
	end
end

function MGAME_EXEC_ACTORSCP_LEADER(cmd, curStage, eventInst, obj, actorScp)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
        local party_obj = GetPartyObj(pc)
        if IsPartyLeaderPc(party_obj, pc) == 1 then
    		RunActorScp(pc, actorScp);
    		return
    	end
	end
	
end

function MGAME_EXEC_SCP_LEADER(cmd, curStage, eventInst, obj, script)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
        local party_obj = GetPartyObj(pc)
        if IsPartyLeaderPc(party_obj, pc) == 1 then
    		RunActorScp(pc, script);
    		return
    	end
	end
end



function MGAME_EXEC_FREEZEZONE(cmd, curStage, eventInst, obj, isFreeze)
	local instID = cmd:GetZoneInstID();
	local layer = cmd:GetLayer();
	if isFreeze == 1 then
		FreezeLayer(instID, layer);
	else
		UnfreezeLayer(instID, layer);
	end
end

function MGAME_LIMIT_MGAME(cmd, curStage, eventInst, obj, limitTime)

	limitTime = 15;

	local mGameName = cmd:GetMGameName();
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
   	for i = 1 , cnt do
        local pc = list[i];
		RunScript("_MGAME_LIMIT_TIME", pc, mGameName, limitTime);
	end
end

function MGAME_EXEC_SOBJ_QUEST(cmd, curStage, questName, sobjName, propName, destValue, title, scp, broadMsg, autoStart, firstOnlyQuest, nextQuest)
	cmd:SObjQuestSet(curStage, questName, sobjName, propName, destValue, title, scp, broadMsg, autoStart, firstOnlyQuest, nextQuest);
end

function CHARICON_MSG(self, msgText)
	local teamID = GetTeamID(self);
	local nameText = msgText .. "\\" ..  self.Job ..  "\\" .. self.Gender .. "\\" .. self.Name .. "\\";
	AddoOnMsgToZone(self, "MCY_KILL_NOTICE", nameText, teamID);
end


function GAME_ST_EVT_EXEC_VALUE_RANDOM(cmd, curStage, eventInst, obj, valCount, valName, ranRangeMin, ranRangeMax)
	local ranValList = {}
	for i = 1, valCount do
	    if i == 1 then
	        ranValList[i] = IMCRandom(ranRangeMin, ranRangeMax)
	    else
	        while 1 do
	            local ranValTemp = IMCRandom(ranRangeMin, ranRangeMax)
	            local flag = 0
	            for y = 1, i - 1 do
	                if ranValList[y] == ranValTemp then
	                    flag = 1
	                    break
	                end
	            end
	            
	            if flag == 0 then
	                ranValList[i] = ranValTemp
	                break
	            end
	        end
	    end
	end
	
	if #ranValList == valCount then
	    for i = 1, valCount do
	        cmd:SetUserValue(valName..i, ranValList[i]);
	    end
	end
end

function GAME_EVT_ON_BYNAME_RAND(cmd, curStage, eventInst, obj, eventCount, eventName, ranRangeMax)
    local ranValList = {}
	for i = 1, eventCount do
	    if i == 1 then
	        ranValList[i] = IMCRandom(1, ranRangeMax)
	    else
	        while 1 do
	            local ranValTemp = IMCRandom(1, ranRangeMax)
	            local flag = 0
	            for y = 1, i - 1 do
	                if ranValList[y] == ranValTemp then
	                    flag = 1
	                    break
	                end
	            end
	            
	            if flag == 0 then
	                ranValList[i] = ranValTemp
	                break
	            end
	        end
	    end
	end
	if #ranValList == eventCount then
	    for i = 1, eventCount do
	        cmd:EnableEvent(curStage, eventName..ranValList[i], 1)
--	        print('AAA',eventName..ranValList[i])
	    end
	end
end




function MGAME_EVT_SCP_FACTION(cmd, curStage, eventInst, obj, monList, faction)
    if monList ~= nil then
        for i = 1, #monList do
        	SetCurrentFaction(monList[i], faction);

        end
    end
end


function MGAME_EVT_SCP_BTREE(cmd, curStage, eventInst, obj, monList, btree)
    if btree ~= nil then
        for i = 1, #monList do
            local tobt = CreateBTree(btree)
            SetBTree(monList[i], tobt)
        end
    end
end

function MGAME_EVT_SCP_ANIM(cmd, curStage, eventInst, obj, monList, animName)
    if monList ~= nil then
    	for i = 1 , #monList do
    		PlayAnim(monList[i], animName)
    	end
    end
end

function MGAME_EVT_SCP_FIXANIM(cmd, curStage, eventInst, obj, monList, animName)
    if monList ~= nil then
    	for i = 1 , #monList do
    		SetFixAnim(monList[i], animName);
    	end
    end
end


function MGAME_SET_DM_ICON(cmd, curStage, msgStr, icon,  sec)
    local msg_int = "NOTICE_Dm_"..icon;
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		SendAddOnMsg(pc, msg_int, msgStr, sec);
	end
end


-- Mongo Log Custom
function MGAME_CUSTOM_LOG(cmd, curStage, contents, stage, type)
    if contents == nil or contents == 'None'  then
        return
    end
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		CustomMongoLog(pc, contents, "FileName", cmd:GetMGameName(), "Stage", stage, "Type", type)
	end
end

-- MGAME_MSG_LIVE_MON_COUNT
function MGAME_MSG_LIVE_MON_COUNT(cmd, curStage, contents, stage, monList)
    local monCount = 0
    if #monList > 0 then
        for i = 1, #monList do
            if IsDead(monList[i]) == 0 then
                monCount = monCount + 1
            end
        end
        local list, cnt = GetCmdPCList(cmd:GetThisPointer());
        if cnt > 0 then
        	for i = 1 , cnt do
        		local pc = list[i];
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg('MGAME_MSG_LIVE_MON_COUNT','COUNT', monCount) , 5)
            end
    	end
    end
    
end

-- MGAME_MSG_VALUE
function MGAME_MSG_VALUE(cmd, curStage, contents, stage, MgameClassName, valuecnt, txt, icon, time)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
    	for i = 1 , cnt do
    		local pc = list[i];

            if time <= 0 then
                time = 1
            end

            if MgameClassName == 'None' or MgameClassName == nil then
                print('Cant find MgameClassName')
                return
            end
            
            local msg_int = "NOTICE_Dm_"..icon;
        
            if MgameClassName == 'DIRECT' then
                SendAddOnMsg(pc, msg_int, txt, time)
            end

            local curVal = cmd:GetUserValue(MgameClassName);
            if curVal <= 0 then
                return
            end
            if curVal >= valuecnt then
                return
            end
            
            SendAddOnMsg(pc, msg_int, txt..'{nl}( '..curVal..' / '..valuecnt..' )', time)
        end
	end
end

function MGAME_SET_RAID_ICON(cmd, curStage, msgStr, icon,  sec)
    local msg_int = "NOTICE_Dm_"..icon;
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		SendAddOnMsg(pc, msg_int, msgStr, sec);
	end
end

function MGAME_EARTH_TOWER_LOG(cmd, curStage, type)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		EarthTowerStateMongoLogo(pc, type, cmd:GetMGameName())
	end
end

function MGAME_CUSTOM_START_FUNC(cmd, curStage, funcName)
	if funcName ~= 'None' then
		local func = _G[funcName];
		func(cmd, curStage);
	end
end

function MGAME_CUSTOM_END_FUNC(cmd, curStage, funcName)
	if funcName ~= 'None' then
		local func = _G[funcName];
		func(cmd, curStage);
	end
end

--
--
--function MGAME_EVT_COND_PCSSN(cmd, curStage, eventInst, obj, limitCnt)
--
--    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
--    local livePCCnt = 0
--	for i = 1 , cnt do
--	    if IsDead(list[i]) ~= 1 then
--	        livePCCnt = livePCCnt + 1
--	    end
--	end
--	if livePCCnt <= limitCnt then
--        return 1
--    end
--    
--	return 0;
--end


function MGAME_INIT_TOTAL_LIMIT_TIME(cmd, hour, min, sec)

	local limitTime = sec + min * 60 + hour * 60 * 60;
	cmd:SetMGameLimitTime(limitTime);
end

function MGAME_ARG_POS_SET(cmd, argName, x, y, z)

	cmd:SetArgPos(argName, x, y, z);

end

function MGAME_INIT_RUN_SCRIPT(cmd, funcName)

	local func = _G[funcName];
	func(cmd);

end

function SCR_CALC_MGAME_TOTAL_SCORE(cmd, mgameName)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt <= 0 then
		return 0;
	end

	local pc = list[1];


	local attackDamage = GetMGameScoreValue(pc, 'ATTACK_DAMAGE');
	local attackedDamage = GetMGameScoreValue(pc, 'ATTACKED_DAMAGE');
	local killCount = GetMGameScoreValue(pc, 'KILL_MON');
	local deadCount = GetMGameScoreValue(pc, 'DEAD_PC');
	local bonusScore = GetMGameScoreValue(pc, 'MGAME_BONUS_SCORE');
	
	local totalScore = 0;

	if mgameName == 'G_TOWER_1' then
		totalScore = CALC_G_TOWER_SCROE(cmd, attackDamage, attackedDamage, killCount, deadCount, bonusScore);	
	end

	return totalScore;
end

function CALC_G_TOWER_SCROE(cmd, attackDamage, attackedDamage, killCount, deadCount, bonusScore)

	return attackDamage - ( attackedDamage * (1 + 0.1 * deadCount) ) + bonusScore;
end


-- gtower
function test_gtower(pc)
	print('adsf')
end

function MGAME_EXEC_BONUS_SCORE_RESETTIME(cmd, curStage, eventInst, obj)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	eventInst:SetUserValue("BONUS_TIME", imcTime.GetAppTime());
	return 1;
end

function MGAME_EXEC_BONUS_SCORE_TIMECHECK(cmd, curStage, eventInst, obj, sec, bonusScore)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	local lastExecSec = eventInst:GetUserValue("BONUS_TIME");
	if lastExecSec == 0 then
		return 0;
	end

	local curTime = imcTime.GetAppTime();
	if curTime < lastExecSec + sec then
		local list, cnt = GetCmdPCList(cmd:GetThisPointer());
		if cnt > 0 then
			local pc = list[1];
			AddMGameScoreValue(pc, "MGAME_BONUS_SCORE", bonusScore);
		end
		return 1;
	end

	return 0;
end

function MGAME_EXEC_BONUS_SCORE(cmd, curStage, eventInst, obj, bonusScore)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        local pc = list[1];		
		AddMGameScoreValue(pc, "MGAME_BONUS_SCORE", bonusScore);
	end
end

function MGAME_EVT_SCRIPT(cmd, curStage, eventInst, obj, funcName)
	local fun = _G[funcName];
	if fun == nil then
		ErrorLog(funcName .. " is not funcName");
	else
		fun(cmd, curStage, eventInst, obj);
	end
end

function MGAME_EVT_SCRIPT_ARG(cmd, curStage, eventInst, obj, funcName, strArg, numArg)
	local fun = _G[funcName];
	if fun == nil then
		ErrorLog(funcName .. " is not funcName");
	else
		fun(cmd, curStage, eventInst, obj, strArg, numArg);
	end
end

function MGAME_GUILD_RAID_STAGE_CLEAR(cmd, curStage, eventInst, obj, stage)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt);

	if pc ~= nil then
		local pcGuildID = GetGuildID(pc);
		local pcGuildObj = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);
		if pcGuildObj == nil then
			ErrorLog("MGAME_GUILD_RAID_STAGE_CLEAR() can not find guild object.");
			return;
		end
		local stageValue = pcGuildObj.GuildRaidStage
		if pcGuildObj.GuildRaidStage + 1 == stage + 1 then
			local cls = GetClassByType("GuildEvent", pcGuildObj["GuildRaidSelectInfo"])
			if cls["StageLoc_"..stage + 1] ~= "None" then
				ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStage", stage + 1)
				ChangePartyProp(pc, PARTY_GUILD, "GuildEventEntered", 0)
			else
				ChangePartyProp(pc, PARTY_GUILD, "GuildRaidFlag", 0)
				ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStartMapID", 0)
				ChangePartyProp(pc, PARTY_GUILD, "GuildRaidSelectInfo", 0)
				ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStage", 0)
			end
		end
		
		local isLeader = IsPartyLeaderPc(pcGuildObj, pc);
		if isLeader == 1 then
			RunGuildEventAssembleCheck(pc)
		else
			BroadCastGuildEventAssembleCheck(pcGuildObj);
		end
	end

	local nowZoneName = GetZoneName(pc)
	local mapCls = GetClass("Map", nowZoneName)

	for i = 1 , cnt do
		local pc = list[i];
		PlayMusicQueueLocal(pc, mapCls.BgmPlayList)
		SetLayer(pc, 0)
	end
	
end


function MGAME_GUILD_RAID_STAGE_FAIL(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	
	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt);
	if pc ~= nil then
		ChangePartyProp(pc, PARTY_GUILD, "GuildRaidFlag", 0)
		ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStartMapID", 0)
		ChangePartyProp(pc, PARTY_GUILD, "GuildRaidSelectInfo", 0)
		ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStage", 0)
	end

	for i = 1 , cnt do
		SetLayer(list[i], 0)
	end
end

function MGAME_GUILD_INDUN_EXIT(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt);

	if pc ~= nil then
		local pcGuildID = GetGuildID(pc);
		local pcGuildObj = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);

        GUILD_EVENT_PROPERTY_RESET(pc, GuildObj)

		local cls = GetClassByType("GuildEvent", pcGuildObj["GuildInDunSelectInfo"])
		local list, cnt = GetPartyMemberList(pc, PARTY_GUILD);
			
		for i = 1, cnt do
			if list[i].ClassName == "PC" then
				if cls ~= nil then
					if isHideNPC(list[i], cls.StarWarp) == "NO" then
                        HideNPC(list[i], cls.StarWarp);
					end
				end
			end
		end
	end
end

function MGAME_EXEC_RUNMGAME(cmd, curStage, eventInst, obj, classname)
    if classname ~= 'None' or classname ~= nil then
    	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    	for i = 1 , cnt do
    		local pc = list[i];
    		RunMGame(pc, classname);
    		return
    	end
    else
        print('Mission Init fail')
    end
end

function MGAME_GUILD_REWARD(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_GUILD, partyID)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt)
    RunScript('SCR_GUILD_EVENT_REWARD_CHECK_MONGOLOG',guildObj, pc);

	if pc ~= nil then
		RunScript('TAKE_GUILD_EVENT_REWARD', pc);
		return 1;
	end
	return 0;
end

function MGAME_EVT_COND_RANDOM(cmd, curStage, eventInst, obj, max, x)
    if max < 1 or x < 1 then
        return 0
    end
    
    local rand = IMCRandom(1, max)
    
    if rand <= x then
        return 1
    end
    
    return 0
end

function MGAME_EXEC_CUSTOMLOG_ALLPC(cmd, curStage, eventInst, obj, collectionName, logArg)
    if collectionName ~= nil and collectionName ~= '' and collectionName ~= 'None' and logArg ~= nil and logArg ~= '' and logArg ~= 'None' then
        local logMsgList = SCR_STRING_CUT(logArg)
        if #logMsgList % 2 == 0 then
            local list, cnt = GetCmdPCList(cmd:GetThisPointer());
        	for i = 1 , cnt do
        		local pc = list[i];
        		if pc.ClassName == 'PC' then
        		    if #logMsgList == 20 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10], logMsgList[11], logMsgList[12], logMsgList[13], logMsgList[14], logMsgList[15], logMsgList[16], logMsgList[17], logMsgList[18], logMsgList[19], logMsgList[20])
        		    elseif #logMsgList == 18 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10], logMsgList[11], logMsgList[12], logMsgList[13], logMsgList[14], logMsgList[15], logMsgList[16], logMsgList[17], logMsgList[18])
        		    elseif #logMsgList == 16 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10], logMsgList[11], logMsgList[12], logMsgList[13], logMsgList[14], logMsgList[15], logMsgList[16])
        		    elseif #logMsgList == 14 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10], logMsgList[11], logMsgList[12], logMsgList[13], logMsgList[14])
        		    elseif #logMsgList == 12 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10], logMsgList[11], logMsgList[12])
        		    elseif #logMsgList == 10 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8], logMsgList[9], logMsgList[10])
        		    elseif #logMsgList == 8 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6], logMsgList[7], logMsgList[8])
        		    elseif #logMsgList == 6 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4], logMsgList[5], logMsgList[6])
        		    elseif #logMsgList == 4 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2], logMsgList[3], logMsgList[4])
        		    elseif #logMsgList == 2 then
        		        CustomMongoLog(pc, collectionName, logMsgList[1], logMsgList[2])
        		    end
            	end
        	end
        end
    end
end

function MGAME_EXEC_SOUND_ALLPC(cmd, curStage, eventInst, obj, soundName)
    if soundName ~= nil and soundName ~= '' and soundName ~= 'None' then
        local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    	for i = 1 , cnt do
    		local pc = list[i];
    		if pc.ClassName == 'PC' then
    		    PlaySound(pc, soundName)
    		end
    	end
    end
end



function GAME_ST_EVT_FAIL(cmd, curStage, eventInst, obj, tip1, tip2)

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = nil;
	if cnt > 0 then
		for i = 1, cnt do
			pc = list[i];
			local clientScp = string.format("MINIGAME_OVER_FRAME_OPEN(\'%s\', \'%s\')", tip1, tip2);
			ExecClientScp(pc, clientScp);	
		end
	end
end;

function SCR_SET_SAVE_POINT_RESURRECT(cmd, curStage, eventInst, obj, flag)
	local boolean = false;	
	if flag == 1 then
		boolean = true;
	elseif flag == 0 then
		boolean = false;
	end
	cmd:SetnableSavePointResurrect(boolean)	
end


function SCR_GIVE_UP_HILL_RANK_POINT(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local step = cmd:GetUserValue("UphillStep") - 1
	local point = 0

	if step ~= nil and step > 0 then
	    if step <= 9 then
	        point = step
	    elseif step <= 19 then
	        point = math.floor(step * 1.3)
	    elseif step <= 29 then
	        point = math.floor(step * 1.6)
	    elseif step <= 30 then
	        point = math.floor(step * 2)
	    end
	end

	local timeBonus = cmd:GetUserValue("RANKING_BONUS")
	if timeBonus ~= 0 and timeBonus ~= nil then
	    point = point + timeBonus
	end

    local bossKillBonus = cmd:GetUserValue("bossKillBonus")
    if bossKillBonus ~= 0 and bossKillBonus ~= nil then
        point = point + bossKillBonus
    end
    if point > 0 then
    	local pc = nil;
    	if cnt > 0 then
    		for i = 1, cnt do
    			pc = list[i];
    			if pc ~= nil then
    				GiveUpHillRankPoint(pc, point);
    				CustomMongoLog(pc, "UPHillDeffense", "State","RankPointGive","Value",point)
    			end
    		end
    	end
    end
end


function CHOOSE_ACTOR_TO_CHANGE_PARTY_PROPERTY(list, cnt)
	local actor = nil;

	for i = 1, cnt do
		local pc = list[i];
		local pcGuildID = GetGuildID(pc);
		local pcGuildObj = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);
		
		if pcGuildObj ~= nil then
			local isLeader = IsPartyLeaderPc(pcGuildObj, pc);
			if isLeader == 1 then
				return list[i];
			end

			if actor == nil then
				actor = list[i];
			end
		end
	end

	return actor;
end

function MGAME_GIVE_ADVENTURE_BOOK_CLEAR_POINT(cmd, curStage, indunClsName)
	cmd:GiveAdventureBookClearPointToAllPlayers(indunClsName);
end

function MGAME_GIVE_ACHIEVE(cmd, curStage, eventInst, obj, MgameName, Achieve, GivePoint, MaxPoint)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = list[1];
	local partyObj = GetPartyObj(pc); 
	local sendRewardPacket = false;

	if partyObj == nil then
		IMC_LOG("INFO_NORMAL", "VELCOFFER_RAID_PARTY_OBJECT_NIL - What??????????");
	end

	local sendPartyLeader = false;
	if cnt > 0 then
		for i = 1, cnt do
			pc = list[i]

			if IsPartyLeaderPc(partyObj, pc) == 1 then
				--PROGRESS_REWARD
				sendPartyLeader = true;
				local tx = TxBegin(pc);
				TxAddAchievePoint(tx, Achieve, GivePoint)
    	        local ret = TxCommit(tx);
    	        
				sendRewardPacket = true;
				break;
			end
		end
	end

	if sendPartyLeader == false then
		if cnt > 0 then
			for i = 1, cnt do
				pc = list[i]

				if IsPartyLeaderPc(GetPartyObj(pc), pc) == 1 then
				else
					RunScript('TX_REWARD_EARTH_TOWER', pc, MgameName)
					sendRewardPacket = true;
					break;
				end
			end
		end
	end

	if sendRewardPacket == false then
		local isParty = 0;
		if partyObj ~= nil then
			isParty = 1
		end
		IMC_LOG("INFO_NORMAL", "EARTH_TOWER_REWARD_NO_NO - isParty : "..isParty);
	end
end

function GET_MGAME_CLASS_BY_MGAMENAME(mGameName)
	local clsList, cnt = GetClassList("Indun");
	if clsList ~= nil then
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			if cls ~= nil then
				local clsMGameName = TryGet_Str(cls, "MGame");
				if mGameName == clsMGameName then
					return cls;
				end
			end
		end
	end
end

function MGAME_MON_KILL_COUNT_CALC(cmd)
	if cmd == nil then
	-- 미니게임 ??못받??옴 ??러 --
	-- ??러로그 추??????--
		return;
	end
   
	local pcList, pcCount = GetCmdPCList(cmd:GetThisPointer());
	if pcList ~= nil and pcCount > 0 then
		-- ??스??용 ??시 구현 --
		-- ???? ??따??로 ??이????????????--
		local zoneInst = GetZoneInstID(pcList[1]);
		local layer = GetLayer(pcList[1]);

		local aliveMonList, aliveMonCount = GetLayerAliveMonListWithExProp(zoneInst, layer, "IsIncludeRate", 1);
		local maxMonsterCount = cmd:GetUserValue('MaxMonsterCount');
		if maxMonsterCount == nil then
			maxMonsterCount = 0;
		end

		if maxMonsterCount < aliveMonCount then
			maxMonsterCount = aliveMonCount;

			local totalMonExp = 0;
			local totalMonJobExp = 0;
			for i = 1, aliveMonCount do
				local mon = aliveMonList[i];

				if aliveMonList[i].MonRank ~= "Boss" then
					totalMonExp = totalMonExp + SCR_GET_MON_EXP(mon);
					totalMonJobExp = totalMonJobExp + SCR_GET_MON_JOBEXP(mon);
				end
			end

			cmd:SetUserValue("TotalMonExp", totalMonExp);
			cmd:SetUserValue("TotalMonJobExp", totalMonJobExp);

			cmd:SetUserValue('MaxMonsterCount', maxMonsterCount);
		end

		local killMonCount = maxMonsterCount - aliveMonCount;
       
		local monKillpercent = math.floor(killMonCount / maxMonsterCount * 100);
		-- ??기까?? ??시 구현 --
		
        -- 미니맵에 몬스터 표시(95% 이상)
        if monKillpercent >= 95 and cmd:GetUserValue("MonRevealMiniMap") == 0 then
            cmd:SetUserValue("MonRevealMiniMap", 1)
            for i = 1, #aliveMonList do
                EnableMonMinimap(aliveMonList[i], 1)
            end
        end
        
		cmd:SetUserValue("MonKillPercent", monKillpercent);
       
		local isEnableRecordMonKillPercent = false;
		local lastRecordMonKillPercent = cmd:GetUserValue("Log_LastRecordMonKillPercent");
		if math.fmod(monKillpercent, 5) == 0 and monKillpercent > lastRecordMonKillPercent then
			cmd:SetUserValue("Log_LastRecordMonKillPercent", monKillpercent);
			
			isEnableRecordMonKillPercent = true;
		end
       
		local clsIndun = nil;
		local indunClassID = cmd:GetUserValue("IndunClassID");
		if indunClassID == 0 then
			local mGameName = cmd:GetMGameName();
			clsIndun = GET_MGAME_CLASS_BY_MGAMENAME(mGameName);
			if clsIndun ~= nil then
				indunClassID = clsIndun.ClassID;

				cmd:SetUserValue("IndunClassID", indunClassID);
			end
		else
			clsIndun = GetClassByType("Indun", indunClassID);
		end

		local rewardContribution = 20;
		if clsIndun ~= nil then
			rewardContribution = TryGet(clsIndun, "Reward_Contribution");
		end

		local curLevel = math.floor(monKillpercent / rewardContribution);
		local achievementLevel = cmd:GetUserValue("AchievementLevel");
	   
		if curLevel > achievementLevel then
			local rewardSilverCount = 0;
			local rewardExpRate = 0;
			local rewardItemCount = 0;
			if clsIndun ~= nil then
				rewardSilverCount = TryGet(clsIndun, "Reward_Silver");
				rewardSilverCount = rewardSilverCount * (rewardContribution * 0.01);
				rewardExpRate = TryGet(clsIndun, "Reward_Exp");
			end

			rewardSilverCount = rewardSilverCount + cmd:GetUserValue("RewardSilverCount");
			rewardExpRate = rewardExpRate + cmd:GetUserValue("RewardExpRate");
			rewardItemCount = 1 + cmd:GetUserValue("RewardItemCount");

			cmd:SetUserValue("RewardSilverCount", rewardSilverCount);
			cmd:SetUserValue("RewardExpRate", rewardExpRate);
			cmd:SetUserValue("RewardItemCount", rewardItemCount);

			cmd:SetUserValue("AchievementLevel", curLevel);
		end

		for i = 1, pcCount do
			local pc = pcList[i];

			if isEnableRecordMonKillPercent == true then
				CustomMongoLog(pc, "IndunContribution", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "MissionRoomName", cmd:GetMGameName(), "MissionRoomID", tostring(GetZoneInstID(pc)), "IndunClsID", tostring(indunClassID), "Type", "RecordContribution", "IndunContributionRate", tostring(monKillpercent));
			end
			
			if cmd:GetUserValue("IsFinished") == 0 then
				if IsBuffApplied(pc, "CantTakeExperience") == "NO" then
					AddBuff(pc, pc, "CantTakeExperience");
				end
			end
			SEND_INDUN_REWARD_PERTAGE(pc, monKillpercent)
		end
	end
end

function SCR_INDUN_CONTRIBUTION_REWARD(bossMon)
    if bossMon == nil then
        return;
    end

    local cmd = GetMGameCmd(bossMon);
    if cmd == nil then
        return;
    end

	MGAME_MON_KILL_COUNT_CALC(cmd);
	
	local mGameName = cmd:GetMGameName();
	local clsIndun = GET_MGAME_CLASS_BY_MGAMENAME(mGameName);
	if clsIndun == nil then
		return;
	end

	-- 모험일지 포인트도 보스 잡을 때 준다
	cmd:GiveAdventureBookClearPointToAllPlayers(clsIndun.ClassName);

	cmd:SetUserValue("IsFinished", 1);

	local rewardSilver = cmd:GetUserValue("RewardSilverCount");
	local rewardExpRate = cmd:GetUserValue("RewardExpRate");
	local rewardItemCount = cmd:GetUserValue("RewardItemCount");
	local rewardItemName = "None";

	rewardItemName = TryGet_Str(clsIndun, "Reward_Item");
	
	local totalMonExp = cmd:GetUserValue("TotalMonExp");
	local totalMonJobExp = cmd:GetUserValue("TotalMonJobExp");
	local monKillPercent = cmd:GetUserValue("MonKillPercent");
	
	local rewardContribution = 20;
	rewardContribution = TryGet(clsIndun, "Reward_Contribution");
	
	local pcList, pcCount = GetCmdPCList(cmd:GetThisPointer());
	
	local bonusRate = NORMAL_PARTY_EXP_BOUNS_RATE(pcCount);
	
	local indunLevel = TryGet(clsIndun, "Level");
	
	for i = 1, pcCount do
		local pc = pcList[i];
		
		local levelRatio = GET_EXP_RATIO(pc.Lv, indunLevel, 0, nil);
		local siverlRatio = GET_INDUN_SILVER_RATIO(pc.Lv, indunLevel);
		if IsIndun(pc) == 1 then
			bonusRate = INDUN_AUTO_MATCHING_PARTY_EXP_BOUNS_RATE(pcCount);
		end
		local mySilver = rewardSilver * siverlRatio
		local myExp = totalMonExp * (rewardExpRate * 0.01);	-- Indun Clear rate Calc
		myExp = myExp * bonusRate;	-- Party EXP Bonus Calc
		myExp = myExp * levelRatio;	-- Level difference Exp rate Calc
		myExp = myExp / pcCount;	-- EXP Per Party member
		
		local myJobExp = totalMonJobExp * (rewardExpRate * 0.01);	-- Indun Clear rate Calc
		myJobExp = myJobExp * bonusRate;	-- Party EXP Bonus Calc
		myJobExp = myJobExp * levelRatio;	-- Level difference Exp rate Calc
		myJobExp = myJobExp / pcCount;	-- EXP Per Party member

        local pcetc = GetETCObject(pc);
		local silverCount = (pcetc.IndunMultipleRate + 1) * rewardSilver;
		local itemCount = (pcetc.IndunMultipleRate + 1) * rewardItemCount;

		RemoveBuff(pc, "CantTakeExperience");
		
		local contribution = monKillPercent;
		local silver = silverCount;
		local cube = itemCount;
		local multipleRate = pcetc.IndunMultipleRate;
		local rank = math.ceil((100 - monKillPercent) / rewardContribution);
        
        --보스 몬스터 위치 받아와서 해당 위치로 PC이동
        if IsBuffApplied(pc, 'indunTheEndSafe') == 'NO' then
            local x, y, z = GetPos(bossMon)
            SetPos(pc, x, y, z);
        end

		RunScript("_SCR_INDUN_CONTRIBUTION_REWARD", pc, mySilver, myExp, myJobExp, rewardItemName, rewardItemCount, contribution, multipleRate, rank, clsIndun.ClassID, pcetc.IndunMultipleRate, mGameName);
	end
end

function _SCR_INDUN_CONTRIBUTION_REWARD(pc, silver, exp, jobExp, itemName, itemCount, contribution, multipleRate, rank, indunClassID, pcIndunMultipleRate, mGameName)
	local tx = TxBegin(pc);
	if tx ~= nil then
		local etcObj = GetETCObject(pc);
		if nil == etcObj then
			return;
		end
		
		TxEnableInIntegrate(tx);

		local multipleError = false;
		if etcObj.IndunFreeTime == 'None' then
			local isIndunMultipleValue = IsIndunMultiple(pc);
			if isIndunMultipleValue == 1 and etcObj.IndunMultipleRate > 0 then 
				local pcInvList = GetInvItemList(pc);
				local isLockItem = false;
				local isTakeItem = false;
				local successTakeCnt = 0;
				if pcInvList ~= nil and #pcInvList > 0 then
					--기간제 아이템 카운트(논스택이기 때문에 하나씩 꺼내서 처리)
					local takeCnt = etcObj.IndunMultipleRate;
					local dungeonCountItemList = { };
					for i = 1 , #pcInvList do
						local invItem = pcInvList[i];
						if invItem ~= nil and invItem.ClassName == "Premium_dungeoncount_Event" and invItem.LifeTime > 0 and invItem.ItemLifeTimeOver < 1 then
							--락이면 제외 시킴.
							if IsFixedItem(invItem) ~= 1 then
								dungeonCountItemList[#dungeonCountItemList + 1] = invItem;
							end
						end
					end

					--아이템 갯수 체크(인벤토리에 있는 것과, 락이 걸려있지 않은 기간제 배수권)
					local multipleItemCount = GET_INDUN_MULTIPLE_ITEM_COUNT(pc);
					if takeCnt <= multipleItemCount then
						-- 기간제 토큰을 먼저 차감      
						if #dungeonCountItemList >= 1 then
							local _temp = nil;
							for j = 1, #dungeonCountItemList - 1 do
								for k = j + 1, #dungeonCountItemList do
									local firstLifeTimeDiff = GetTimeDiff(dungeonCountItemList[j].ItemLifeTime);
									local SecondLifeTimeDiff = GetTimeDiff(dungeonCountItemList[k].ItemLifeTime);
									if firstLifeTimeDiff < SecondLifeTimeDiff then
										_temp = dungeonCountItemList[j];
										dungeonCountItemList[j] = dungeonCountItemList[k];
										dungeonCountItemList[k] = _temp;
									end
								end
							end

							for l = 1, #dungeonCountItemList do
								local dungeonCountItem = dungeonCountItemList[l];
								TxTakeItemByObject(tx, dungeonCountItem, 1, "IndunMultipleUse");
								successTakeCnt = successTakeCnt + 1;
								takeCnt = takeCnt - 1;
								if takeCnt < 1 then
									break;
								end
							end
						end

						-- 기간제를 제외한 남은 개수만큼 차감: 모험일지 전용 토큰 먼저. 아 정말 이러고 싶지 않다. 이거 어떡하냐 진짜
						if takeCnt > 0 then
							local item, itemCnt  = GetInvItemByName(pc, "Adventure_dungeoncount_01");
							if item ~= nil then
								if IsFixedItem(item) == 1 then
									isLockItem = true;
								end
								local _takeCnt = math.min(itemCnt, takeCnt);
								if isLockItem == false then
									TxTakeItem(tx, "Adventure_dungeoncount_01", _takeCnt, "IndunMultipleUse");
									successTakeCnt = successTakeCnt + _takeCnt;
								end
								isTakeItem = true;
								takeCnt = takeCnt - _takeCnt;
							end
						else
							isTakeItem = true;
						end

						-- 기간제를 제외한 남은 개수만큼 차감
						if takeCnt > 0 then
							local item, itemCnt  = GetInvItemByName(pc, "Premium_dungeoncount_01");
							if item ~= nil then
								if IsFixedItem(item) == 1 then
									isLockItem = true;
								end

								if isLockItem == false then
									TxTakeItem(tx, "Premium_dungeoncount_01", takeCnt, "IndunMultipleUse");									
									successTakeCnt = successTakeCnt + takeCnt;
								end
								isTakeItem = true;
							end
						else
							isTakeItem = true;
						end
					end
				end

				if successTakeCnt ~= etcObj.IndunMultipleRate then
					multipleError = true;
				end

				--아이템 락걸려있는 상태로 넘어오면 다 리셋 시켜준다.
				if isLockItem == true or isTakeItem == false then
					etcObj.IndunMultipleZoneID = 0;
					etcObj.IndunMultipleMGameName = "None"; 
					etcObj.IndunMultipleIndunType = 0;
					etcObj.IndunMultipleRate = 0;
					etcObj.IndunMultipleRate_Reserve = 0;
				end
			end
		end

        if IsIndunMultiple(pc) == 0 then
            multipleError = true;
            multipleRate = 0;
        end

        if silver > 0 then
        	if multipleError == false then
        		silver = silver * (etcObj.IndunMultipleRate + 1);
        	end
            TxGiveItem(tx, "Vis", silver, "INDUN_CONTRIBUTION_REWARD");
        end

        if itemCount > 0 then
			-- 보스 몬스터가 기본으로 드랍하는 큐브 개수, 1
			local payItemCount = 1;
        	if multipleError == false then
        		itemCount = itemCount * (etcObj.IndunMultipleRate + 1);
				itemCount = itemCount + (payItemCount * (etcObj.IndunMultipleRate + 1));
        	end
            TxGiveItem(tx, itemName, itemCount, "INDUN_CONTRIBUTION_REWARD");
        end

		local indunCount = 0;
		local indunCls = GetClassByType("Indun", indunClassID);
		if indunCls ~= nil then
			local indunResetType = TryGet(indunCls, "PlayPerResetType");
			local pcetcProp = "InDunRewardCountType_" .. tostring(indunResetType);

			if etcObj ~= nil then
				indunCount = 1;
        		if multipleError == false then
        			indunCount = indunCount * (etcObj.IndunMultipleRate + 1) + etcObj[pcetcProp];
				end

				TxSetIESProp(tx, etcObj, pcetcProp, indunCount);

				if string.find(pcetcProp,'InDunRewardCountType_') ~= nil then
					local initProp = 'InDunCountType_'..string.gsub(pcetcProp, 'InDunRewardCountType_', '')
					if etcObj[initProp] ~= indunCount then
						TxSetIESProp(tx, etcObj, initProp, indunCount);
					end
				end
			end
		end

		local ret = TxCommit(tx);
		if ret == "SUCCESS" then
			local calcExp, calcJExp = GiveExp(pc, exp, jobExp, "INDUN_CONTRIBUTION_REWARD");
			
            IndunJoinCountMongoLog(pc, mGameName, indunCount, "IndunComplete");

			CustomMongoLog(pc, "IndunContribution", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "MissionRoomName", mGameName, "MissionRoomID", tostring(GetZoneInstID(pc)), "IndunClsID", tostring(indunClassID), "Type", "RewardSuccessed", "IndunRewardRate", tostring(contribution), "IndunMultipleRate", tostring(pcIndunMultipleRate), "RewardCubeName", itemName, "RewardCubeCnt", tostring(itemCount), "RewardVisCnt", tostring(silver), "RewardExpCnt", tostring(calcExp), "RewardJobExpCnt", tostring(calcJExp));
			SendAddOnMsg(pc, "INDUN_REWARD_RESULT", string.format("%d#%d#%d#%s#%s#%d#%d#", contribution, silver, itemCount, tostring(calcExp), tostring(calcJExp), multipleRate, rank));
		else
			CustomMongoLog(pc, "IndunContribution", "PartyID", tostring(GetPartyID(pc)), "Channel", tostring(GetChannelID(pc)), "MissionRoomName", mGameName, "MissionRoomID", tostring(GetZoneInstID(pc)), "IndunClsID", tostring(indunClassID), "Type", "RewardFailed", "IndunRewardRate", tostring(contribution), "IndunMultipleRate", tostring(pcIndunMultipleRate), "RewardCubeName", itemName, "RewardCubeCnt", tostring(itemCount), "RewardVisCnt", tostring(silver), "RewardExpCnt", tostring(calcExp), "RewardJobExpCnt", tostring(calcJExp));
			IMC_LOG('ERROR_TX_FAIL', 'INDUN_CONTRIBUTION_REWARD: aid['..GetPcAIDStr(pc)..']');

            etcObj.IndunMultipleZoneID = 0;
            etcObj.IndunMultipleMGameName = "None"; 
            etcObj.IndunMultipleIndunType = 0;
            etcObj.IndunMultipleRate = 0;
            etcObj.IndunMultipleRate_Reserve = 0;
		end
	end
end

function MGAME_GUILD_MINIGAME_EXIT(cmd, curStage, eventInst, obj)
    local partyID = cmd:GetPartyIDStr()
    local guildObj = GetPartyObjByIESID(PARTY_GUILD, partyID)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt ~= nil and cnt > 0 then
	    for i = 1, cnt do
	        local pc = list[i];
            RunScript('SCR_GUILD_EVENT_STAYED_MONGOLOG', pc, guildObj)
        end
    end
	if guildObj ~= nil then
	    RunScript('SCR_GUILD_EVENT_FAIL_MONGOLOG', guildObj)
    	return 1;
	end
	return 0;
end

function MGAME_PCLIST_LAYER_CHANGE(cmd, curStage, eventInst, obj, layer)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if list == nil then
        return;
    end
    
    if cnt > 0 then
        local i
        for i = 1, cnt  do
            SetLayer(list[i], layer, 0)
        end
    end
end

function TEST_MGAME_CRASH(pc)
	local pcGuildID = GetGuildID(nil);
	local pcGuildObj = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);
end

function GAME_ST_EVT_EXEC_SOUL_CRISTAL_LIMIT(cmd, curStage, eventInst, obj, flag, count)
	if flag == 1 then
		cmd:SetSoulCristalLimit(true);
	else
		cmd:SetSoulCristalLimit(false);
	end
	cmd:SetSoulCristalLimitCount(count);

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    if cnt > 0 then
        local i
        for i = 1, cnt  do
			SendAddOnMsg(list[i], "SHOW_SOUL_CRISTAL", "", count);
        end
    end
end


function SCR_UPHILL_BOSS_GEN_CHECK(cmd, curStage, eventInst, obj) -- checking boss gen timing
    local blockingScriptWork = cmd:GetUserValue("BossGenEventCheck")
    if blockingScriptWork ~= 0 then
        return 0
    elseif blockingScriptWork == 0 then
        cmd:SetUserValue("BossGenEventCheck", 1)
        local stepCheck = cmd:GetUserValue("UphillStep");
        if stepCheck <= 9 then
            local bossSummonCheck = cmd:GetUserValue("BOSS1")
            if bossSummonCheck == 0 then
                if stepCheck == 9 then
                    return 1 
                elseif stepCheck < 9 then
                    local summonableCheck = IMCRandom(1,5)
                    if summonableCheck == 3 then
                        return 1
                    end
                end
            end
        elseif stepCheck <= 18 then
            local bossSummonCheck = cmd:GetUserValue("BOSS2")
            if bossSummonCheck == 0 then
                if stepCheck == 18 then
                    return 1 
                elseif stepCheck < 18 then
                    local summonableCheck = IMCRandom(1,5)
                    if summonableCheck == 3 then
                        return 1
                    end
                end
            end
        elseif stepCheck <= 27 then
            local bossSummonCheck = cmd:GetUserValue("BOSS3")
            if bossSummonCheck == 0 then
                if stepCheck == 27 then
                    return 1 
                elseif stepCheck < 27 then
                    local summonableCheck = IMCRandom(1,5)
                    if summonableCheck == 3 then
                        return 1
                    end
                end
            end
        end
    end
end


function SCR_UPHILL_ADD_RANKING_POINT_TIME(cmd, curStage, eventInst, obj)  -- add bonus ranking point of uphill deffense
    local stageTime = cmd:GetStageTime(curStage); -- check now stage's time
    local stepCheck = cmd:GetUserValue("UphillStep") -- check now stage's step

    if stepCheck == 10 or stepCheck == 20 then -- if now stage's step is 10 or 20 then
        local bonusPoint = cmd:GetUserValue("RANKING_BONUS") -- get bonus point about clear speedy stage
        local timeCount = cmd:GetUserValue("RP_TIME"); -- get ranking point time of now stage
        timeCount = 60 - math.floor(stageTime) -- get remaining time of now stage
        if timeCount ~= 0 and timeCount ~= nil then
            bonusPoint = bonusPoint + math.floor(timeCount * 0.7) -- add bonus point
            cmd:SetUserValue("RANKING_BONUS", bonusPoint) -- setting bonus point about clear speedy stage
            cmd:SetUserValue("RP_TIME", 0) -- reset ranking point time of now stage
        end

    elseif stepCheck == 30 then
        local bonusPoint = cmd:GetUserValue("RANKING_BONUS")
        local timeCount = cmd:GetUserValue("RP_TIME");
        timeCount = 120 - math.floor(stageTime)
        if timeCount ~= 0 and timeCount ~= nil then
            bonusPoint = bonusPoint + math.floor(timeCount * 0.9)
            cmd:SetUserValue("RANKING_BONUS", bonusPoint)
            cmd:SetUserValue("RP_TIME", 0)
        end

    else
        local bonusPoint = cmd:GetUserValue("RANKING_BONUS")
        local timeCount = cmd:GetUserValue("RP_TIME");
        timeCount = 40 - math.floor(stageTime)
        if timeCount ~= 0 and timeCount ~= nil then
            bonusPoint = bonusPoint + math.floor(timeCount * 0.5)
            cmd:SetUserValue("RANKING_BONUS", bonusPoint)
            cmd:SetUserValue("RP_TIME", 0)
        end
    end
end