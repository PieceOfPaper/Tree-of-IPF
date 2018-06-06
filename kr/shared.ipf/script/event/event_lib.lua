function SCR_NPCSTATE_CHANGE(pc, npc, value)
    local tx = TxBegin(pc);

	TxChangeNPCState(tx, GetGenType(npc), value);

	local ret = TxCommit(tx);
end

function PARSE_COND_SEMANTIC(pEvent, condList, seman)

	if condList == nil then
		return;
	end

	local tbCount = #condList;
	
	if tbCount == 3 then
		local isAnd = nil;
		if condList[2] == "AND" then
			isAnd = 1;			
		elseif condList[2] == "OR" then
			isAnd = 0;
		end
	
		if isAnd ~= nil then
			local left, right = CreateSemantic(seman, isAnd);
			PARSE_COND_SEMANTIC(pEvent, condList[1], left);
			PARSE_COND_SEMANTIC(pEvent, condList[3], right);
			return;
		end
	end
	
	local semanType = condList[1];
	if type(condList[1]) == "table" then
		semanType = condList[1][1];
	end
	
	if type(semanType) == "string" then
		ParseSemantic(pEvent, seman, semanType);
		return;
	end
	
end

function PARSE_BG_EVENT(valName, pEvent)

  	local eventTable = _G["g_table_" .. valName];
	if eventTable == nil then
		return;
	end
	
	local coorList = eventTable[1];
	
	for i = 1 , #coorList do
		local coor = coorList[i];
		AddCoord(pEvent, coor[1], coor[2], coor[3]);
	end
	
	local npcList = eventTable[3];
	if #npcList > 0 then
		SetBGEventNPC(pEvent, npcList[1], npcList[2], npcList[3], npcList[4], npcList[5]);
		local index = 6;
		while true do
			if index > #npcList then
				break;
			end

			local propName = npcList[index];			
			local propValue = npcList[index + 1];
			AddBGEventNPCProp(pEvent, propName, propValue);
			
			index = index + 2;
		end
	end
	
	local propList = eventTable[4];
	if propList ~= nil and #propList > 0 then
		local index = 1;
		while true do
			if index > #propList then
				break;
			end

			local propName = propList[index];			
			local propValue = propList[index + 1];
			AddBGEventProp(pEvent, propName, propValue);
			index = index + 2;
		end
	end
	
	local condList = eventTable[2];
	PARSE_COND_SEMANTIC(pEvent, condList, GetSemantic(pEvent));
	EndParseBGEvent(pEvent);
	
end


function CHANGE_CLASS_VALUE(sobj, quest, questAuto, propName, propValue)

	ChangeClassValue(sobj, propName, propValue);
	ChangeClassValue(quest, propName, propValue);
	ChangeClassValue(questAuto, propName, propValue);

end



function TxAddSObjProp(pc, tx, sObjName, propName, addValue)

	local sObj = GetSessionObject(pc, sObjName);
	if sObj == nil then
		TxRollBack(tx);
		return;
	end
	
	TxSetIESProp(tx, sObj, propName, sObj[propName] + addValue);

end

function TxSetSObjProp(pc, tx, sObjName, propName, propValue)

	local sObj = GetSessionObject(pc, sObjName);
	if sObj == nil then
		TxRollBack(tx);
		return;
	end
	
	TxSetIESProp(tx, sObj, propName, propValue);

end

function TxStartQuest(pc, tx, questName)

	local mainSObj = GetSessionObject(pc, "ssn_klapeda");
	if mainSObj == nil then
		TxRollBack(tx);
		return;
	end

	local questSObj = GetClass("QuestProgressCheck", questName);
	if questSObj == nil then
		TxRollBack(tx);
		return;
	end
	
	local propName = questSObj.QuestPropertyName;
	TxSetIESProp(tx, mainSObj, propName, CON_QUESTPROPERTY_MIN);


end

function IS_QUEST_STATE(pc, questName, state)

	--	'PROGRESS'		'SUCCESS'		'COMPLETE'		'POSSIBLE'
	
	local result = SCR_QUEST_CHECK(pc,questName);
	if state == result then
		return true;
	end
	
	return false;

end

function DROP_BGEVENT(pc, evt, itemName, itemCount)

	local range = 10;
	local pos = evt:Pos();
	local itemType = ItemNameToType(itemName);
	CRE_ITEM(pc, pos.x, pos.y, pos.z, itemType, itemCount, range)
	
end

function DROP_XACEVENT(pc, x, y, z, itemName, itemCount)

	local range = 20;
	local itemType = ItemNameToType(itemName);
	CRE_ITEM(pc, x, y, z, itemType, itemCount, range)
	
end

function CRE_EVENT_MONSTER(pc, evt, clsName, dx, dy, dz, angle, propList)

	local obj = CreateGCIES('Monster', clsName);
	if obj == nil then
		return nil;
	end

	ApplyPropToken(obj, propList, "@");
	local range = 1;
	local pos = evt:Pos();
	local mon1 = CreateMonster(pc, obj, pos.x + dx, pos.y + dy, pos.z + dz, angle, range);	
	if mon1 == nil then
	    
		return nil;
	end
	InsertHate(mon1, pc, 1)
	return mon1;

end








-- 단발/XAC이벤트 중복 보상 처리되는 버그 수정(임시/꼼수)

function SCR_CREATE_SSN_EV_STOP(self, sObj)
    sObj.Goal1 = 0
    SetTimeSessionObject(self, sObj, 1, 1000, 'SCR_SSN_STOP_EV')
end

function SCR_REENTER_SSN_EV_STOP(self, sObj)
    DestroySessionObject(self, sObj)
end

function SCR_DESTROY_SSN_EV_STOP(self, sObj)
end


function SCR_SSN_STOP_EV(self, sObj)
    if sObj.Goal1 >= 0 and sObj.Goal1 < 1 then
        SetTimeSessionObject(self, sObj, 2, sObj.Step1, 'SCR_SSN_STOP_EV_RUN')
        SCR_SSN_STOP_EV_RUN(self, sObj)
        sObj.Goal1 =  sObj.Goal1 + 1
    end
end

function SCR_SSN_STOP_EV_RUN(self, sObj)
    if sObj.Goal1 >= 1 then
        DestroySessionObject(self, sObj)
    end
end


function TRAP_BOX(self, pc, classname, lv, mon_cnt, range)
    
    local mon = {}
    local i
    local x, y, z = GetPos(self)
    for i = 1, mon_cnt do
        mon[i] = CREATE_MONSTER_MOD(self, classname, x, y, z, 0, range, 'Neutral', lv, MOD_BOX)
        PlayAnim(mon[i], 'STD')
        LookAt(mon[i], pc)
        AddScpObjectList(self, "TRAPBOX_MON", mon[i]);
        PlayEffect(mon[i], 'magic1', 1)
        ObjectColorBlend(mon[i], 255, 255, 255, 255, 1, 10, 0, 1)
    end
end

function MOD_BOX(mon)
    mon.SimpleAI = 'TRAPBOX_MON'
end


-- 소환된 몬스터들이 있는지 없는지 확인하여 없으면 상자 복구
function MOD_BOX_TESS(self)
    local list = GetScpObjectList(self, "TRAPBOX_MON");
    if #list == 0 then
        ObjectColorBlend(self, 255, 255, 255, 255, 1, 1, 0, 1)
        self.NumArg2 = 2
        return 0
    end
    return 1
end

-- 소환된 몬스터가 없음에도 PC가 상자를 복구하지 않았을때
function MOD_BOX_RUN(self)
    if self.NumArg3 <= 20 then
        self.NumArg3 = self.NumArg3 + 1
        return 1
    else
        self.NumArg3 = 0
        self.NumArg2 = 0
        return 0
    end
    return 0
end

function MOD_BOX_ENTER(self)
    ObjectColorBlend(self, 0, 227, 216, 80, 1, 3, 0, 1)
    return 0
end


function MOD_BOX_MON(self)
    if self.NumArg1 <= 15 then
        self.NumArg1 = self.NumArg1 + 1
        return 1
    elseif self.NumArg1 == 16 then
        SetCurrentFaction(self, 'Monster')
        SetTendency(self, 'Attack');
        self.NumArg1 = 17
    elseif self.NumArg1 >= 17 then 
        return 0
    end
end