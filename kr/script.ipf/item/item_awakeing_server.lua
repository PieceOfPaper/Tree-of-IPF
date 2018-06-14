-- item_awakening_server.lua

function SCP_ENTER_ALCHEMIST_MISSION(pc)
	local etc = GetETCObject(pc);
	if 0 >= etc.Alchemist_Ability then
		return;
	end

	AddBuff(pc, pc, "ItemAwakening_ATK_Buff", etc.Alchemist_Ability, 0, 1800000, 1)
	RunScript('RUN_ABIL_BUFF_END', pc)
end

function RUN_ABIL_BUFF_END(pc)
	local etc = GetETCObject(pc);
	local tx = TxBegin(pc);	
	TxSetIESProp(tx, etc, "Alchemist_Ability", 0);
	local ret = TxCommit(tx);
end

function MOVE_ITEM_AWAKENING(pc, missionID)		
	SendSysMsg(pc, "AutoMoveToDungeon");

	sleep(5000);

	ReqMoveToMission(pc, missionID);
end

function SCR_GET_HIDDEN_PROP_AND_VALUE(invitem)
	local clsList, cnt = GetClassList("ItemawakeningProp");
	local randomList = {};
	local index = 1;
	for i = 0, cnt -1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.GroupName == invitem.GroupName then
			randomList[index] = cls;
			index = index + 1;
		end
	end
	local propRandom = IMCRandom(1, #randomList);
	local cls = randomList[propRandom];
	local maxFunc = cls.MaxPropValue;
	local value = 1;
	local scp = _G[maxFunc];
	if nil ~= scp then
		value = scp(invitem);
	end

	--local valueRandom = IMCRandom(1, maxValue);
	return cls.Prop, value;
end