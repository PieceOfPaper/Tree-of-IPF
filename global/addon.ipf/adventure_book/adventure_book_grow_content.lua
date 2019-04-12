
ADVENTURE_BOOK_GROW_CONTENT = {};

function ADVENTURE_BOOK_GROW_CONTENT.CHAR_NAME_LIST()
    local list = GetAdventureBookStringList(ABT_CHARACTER);
	return list;
end
function ADVENTURE_BOOK_GROW_CONTENT.CHAR_INFO(charName)
	local charData = GetAdventureBookInstByString(ABT_CHARACTER, charName);
	local jobList, level, lastJobID = GetJobListFromAdventureBookCharData(charName);
	local lastJobCls = GetClassByType("Job", lastJobID);
	local lastJobIcon = TryGetProp(lastJobCls, "Icon");
	
	charData = tolua.cast(charData, "ADVENTURE_BOOK_CHARACTER_DATA");
	local retTable = {};

	if charData ~= nil then
		retTable['name'] = charData.name
		retTable['icon'] = lastJobIcon
		retTable['level'] = level
	end
	return retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.HAS_JOB(jobClsID)
	local retJobList = ADVENTURE_BOOK_GROW_CONTENT.ACCOUNT_JOB_HASH()
	if retJobList[jobClsID] == 1 then
		return 1;
	else
		return 0;
	end
end

function ADVENTURE_BOOK_GROW_CONTENT.ACCOUNT_JOB_HASH()
	local charNameList = GetAdventureBookStringList(ABT_CHARACTER);
	local retJobList={};

	for cn = 1, #charNameList do
		local charName = charNameList[cn];	
		local jobList = GetJobListFromAdventureBookCharData(charName);
		for j = 1, #jobList do
			local jobName = jobList[j];
			retJobList[jobName] = 1;
		end
	end

	return retJobList
end

function ADVENTURE_BOOK_GROW_CONTENT.ACCOUNT_JOB_LIST()
	local retJobList = ADVENTURE_BOOK_GROW_CONTENT.ACCOUNT_JOB_HASH()

	local retTable = {};
    for jobClsID, isExist in pairs(retJobList) do
       	retTable[#retTable + 1]=jobClsID;
	end
	table.sort(retTable);
	return retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.ACCOUNT_JOB_LIST_BY_TYPE(ctrlType)

	local list = ADVENTURE_BOOK_GROW_CONTENT["ACCOUNT_JOB_LIST"]();
	local retTable={};

	for i=1,#list do
		local job = GetClassByType("Job", list[i]);
		local jobCtrlType = TryGetProp(job, "CtrlType")
		if ctrlType == jobCtrlType then
			retTable[#retTable+1] = list[i];
		end
	end
	return  retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.JOB_INFO(jobClsID)
	local job = GetClassByType("Job", jobClsID);
	
	local retTable = {};
	retTable['name'] = TryGetProp(job, "Name");
	retTable['rank'] = TryGetProp(job, "Rank");
	retTable['ctrl_type'] = TryGetProp(job, "CtrlType");
	retTable['type'] = TryGetProp(job, "ControlType");
	retTable['difficulty'] = TryGetProp(job, "ControlDifficulty");
	retTable['desc'] = TryGetProp(job, "Caption1");

	local type = '';
	if retTable['ctrl_type'] == 'Warrior' then
		type = ScpArgMsg('Char1');
	elseif retTable['ctrl_type'] == 'Wizard' then
		type = ScpArgMsg('Char2');
	elseif retTable['ctrl_type'] == 'Archer' then
		type = ScpArgMsg('Char3');
	elseif retTable['ctrl_type'] == 'Cleric' then
		type = ScpArgMsg('Char4');	
	elseif retTable['ctrl_type'] == 'Scout' then
		type = ScpArgMsg('EVENT_1811_CTRLTYPE_RESET_MSG5');
	end

	retTable['ctrltype_and_rank'] = ScpArgMsg("{CtrlType}Type", "CtrlType", type);
	
	retTable['icon'] = TryGetProp(job, "Icon");
	retTable['has_job'] = ADVENTURE_BOOK_GROW_CONTENT.HAS_JOB(jobClsID)
	return retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.IS_VISIBLE_JOB(cls)
	if cls == nil then
		return 0;
	end
	
	local clsID = TryGetProp(cls, "ClassID");
	if clsID == nil then
		return 0;
	end

	if cls.Rank > 2 then
		return 0;
	end
	
	local hasJob = ADVENTURE_BOOK_GROW_CONTENT.HAS_JOB(clsID);
	if hasJob == 1 then
		return 1;
	end

	if cls.HiddenJob ~= 'YES' or cls.PreFunction == 'None' then
		return 1;
	end

	return 0;
end

function ADVENTURE_BOOK_GROW_CONTENT.JOB_LIST_BY_TYPE(ctrlType)
	local retTable = {};
	local list, cnt = GetClassList("Job");
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(list,i);
		local clsID = TryGetProp(cls, "ClassID");
		local info = ADVENTURE_BOOK_GROW_CONTENT.JOB_INFO(clsID)
		if TryGetProp(cls, "CtrlType") == ctrlType then
			if ADVENTURE_BOOK_GROW_CONTENT.IS_VISIBLE_JOB(cls) == 1 then
				retTable[#retTable+1] = clsID;
			end
		end
	end
	retTable = ADVENTURE_BOOK_GROW_CONTENT.SORT_LIST(retTable)
	return  retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.TOOLTIP_JOB(ctrlType)
	local retTable = {};
	local list, cnt = GetClassList("Job");
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(list,i);
		if TryGetProp(cls, "CtrlType") == ctrlType then
			local clsID = TryGetProp(cls, "ClassID");
			retTable[#retTable+1] = clsID;
		end
	end
	return  retTable;
end

function ADVENTURE_BOOK_GROW_CONTENT.SORT_BY_RANK(a, b)
	local clsA = GetClassByType('Job', a)
	local clsB = GetClassByType('Job', b)

	local rankA = TryGetProp(clsA, 'Rank')
	local rankB = TryGetProp(clsB, 'Rank')

	local nameA = TryGetProp(clsA, 'Name')
	local nameB = TryGetProp(clsB, 'Name')

	if rankA ~= rankB then
		return rankA < rankB
	end
--	return nameA < nameB
	return a < b
end

function ADVENTURE_BOOK_GROW_CONTENT.SORT_LIST(list)
	table.sort(list, ADVENTURE_BOOK_GROW_CONTENT['SORT_BY_RANK']);
	return list;
end
