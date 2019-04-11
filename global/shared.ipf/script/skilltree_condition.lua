SKL_VAN_DIABLE = 1;
SKL_VAN_ENABLE = 2;
SKL_VAN_HAVE = 3;
SKL_VAN_LOCKED = 4;

function SCR_SKL_HAVE_GROUP(pc, group)
	
	local isHave = IsHaveSkillMapGroup(pc, group);
	if isHave == 1 then
		return SKL_VAN_HAVE;
	end
	
	return SKL_VAN_DIABLE;	
end

function SCR_SKL_CHECK_PROP(pc, cls)

	--- local cls = GET_MY_SPHERE_CLASS(pc, row, col, group);
	
	local propName = cls.StrArg;
	local needValue = cls.NumArg1;
	
	if pc[propName] <= needValue then
		return SKL_VAN_LOCKED;
	end
	
	return SCR_CHECK_CROSS(pc, cls);

end

function SCR_CHECK_CROSS(pc, cls)

	local row = cls.Row;
	local col = cls.Col;
	local group = cls.Group;
	
	if 1 == CHECK_SLOT_ENABLE(pc, row - 1, col, group) then
		return SKL_VAN_ENABLE;
	elseif 1 == CHECK_SLOT_ENABLE(pc, row + 1, col, group) then
		return SKL_VAN_ENABLE;
	elseif 1 == CHECK_SLOT_ENABLE(pc, row, col - 1, group) then
		return SKL_VAN_ENABLE;
	elseif 1 == CHECK_SLOT_ENABLE(pc, row, col + 1, group) then
		return SKL_VAN_ENABLE;
	end

	return SKL_VAN_DIABLE;
end

function SCR_CHECK_QUEST(pc, cls, skillname)
    local skill = GetVirtualSkill(pc, skillname)
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    local skilllv = 1
    
    if sObj == nil then
        return SKL_VAN_DIABLE
    end
    
    if skill ~= nil then
        skilllv = skilllv + skill.Level
    end
    
    local skill_quest_prop = GetPropType(sObj, skillname..skilllv)
    if skill_quest_prop == nil then
        return SKL_VAN_ENABLE;
    else
--        local quest_list = SCR_GET_XML_IES('QuestProgressCheck','QuestPropertyName',skillname..skilllv)
--        if quest_list == nil then
--            return SKL_VAN_DIABLE;
--        end
        
        if sObj[skillname..skilllv] == 300 then
            return SKL_VAN_ENABLE;
        end
    end
    
    local quest_list = SCR_GET_XML_IES('QuestProgressCheck','QuestPropertyName',skillname..skilllv)
    
    if quest_list ~= nil and #quest_list > 0 then
        return SKL_VAN_DIABLE, quest_list[1]
    else
        return SKL_VAN_DIABLE;
    end
end

function SCR_SKL_CHECK_COMMON(pc, cls)

	local row = cls.Row;
	local col = cls.Col;
	local group = cls.Group;

	if 1 == HAVE_SKILL_MAP(pc, row, col, group) then
		return SKL_VAN_HAVE;
	end

	if cls.Start == 1 then
		return SKL_VAN_ENABLE;
	end

	return 0;

end


function GET_MY_SPHERE_CLASS(pc, row, col, group)

	return GetSphereClass(pc, row, col, group);

end


function HAVE_SKILL_MAP(pc, row, col, group)

	return IsHaveSkillMap(pc, row, col, group);

end

function CHECK_SLOT_ENABLE(pc, row, col, group)

	local cls = GET_MY_SPHERE_CLASS(pc, row, col, group);
	if cls ~= nil and 1 == HAVE_SKILL_MAP(pc, row, col, group) then
		return 1;
	end

	return 0;
end


function GET_GROUP_START_CLASS(group, jobName)

	local clslist = GetClassList("SkillVan");

	local index = 1;
	while 1 do

		local name = jobName .. "_" .. index;

		local cls = GetClassByNameFromList(clslist, name);
		if cls == nil then
			break;
		end

		if cls.Start == 1 and cls.Group == group then
			return cls;
		end

		index = index + 1;
	end

	return nil;

end



function SCR_ALWAYS_ABLE(pc, treecls, totallv, treelist, ignoremaxlevel)

	if ignoremaxlevel ~= 1 and totallv >= treecls.MaxLevel then
		return 0;
	end
	
	return 1;
	
end

function SCR_CHECK_JOBLV(pc, treecls, totallv, treelist, ignoremaxlevel)
	local jobLv = GetJobLv(pc);
	
	if jobLv >= treecls.NumArg3 then
		return 1;	
	end	
	
	return 0;
end

function SCR_CHECK_ROW(pc, treecls, totallv, treelist, ignoremaxlevel)

	local cnt = #treelist;
	
	if ignoremaxlevel ~= 1 and totallv >= treecls.MaxLevel then
		return 0;
	end
	
	local clsID = treecls.ClassID;
	
	local needpoint = treecls.NumArg1;
	local CheckRow = treecls.Row - 1;
	local accumpoint = 0;
	
	for i = 1 , cnt do
		local info = treelist[i];
		local cls = info["class"];
		local obj = info["obj"];
		local lv = info["lv"] + info["statlv"];
		
		if clsID ~= cls.ClassID and cls.Row <= CheckRow and lv > 0 then
			accumpoint = accumpoint + lv;
			
			if accumpoint >= needpoint then
				return 1;
			end
			
		end
	
	end

	return 0;
end

function SCR_CHECK_STEP(pc, treecls, totallv, treelist, ignoremaxlevel)

	if SCR_CHECK_ROW(pc, treecls, totallv, treelist, ignoremaxlevel) == 0 then
		return 0;
	end
	
	local NeedStepName = treecls.StrArg;
	local NeedStepLevel = treecls.NumArg2;	
	
	local NeedLevel = NeedStepLevel;
	local NeedLevelList = {};	
	local needLvCount = 1;	
	while 1 do
		local needStart, needEnd = string.find(NeedLevel, ",");		
		if needStart == nil then		
			local needLvTemp = string.sub(NeedLevel, 1);
			
			NeedLevelList[needLvCount] = tonumber(needLvTemp);
			break;
		end
		
		local needLvTemp = string.sub(NeedLevel, 1, needStart - 1);
		NeedLevel = string.sub(NeedLevel, needEnd + 1);
		
		NeedLevelList[needLvCount] = tonumber(needLvTemp);		
		needLvCount = needLvCount + 1;
	end
	
	local NeedTreeNameTemp = NeedStepName;
	local NeedSkillNameList = {};	
	local needNameCount = 1;
	while 1 do
		local needStart, needEnd = string.find(NeedTreeNameTemp, " ");
		
		if needStart == nil then
			local NeedTree = string.sub(NeedTreeNameTemp, 1);
			NeedSkillNameList[needNameCount] = NeedTree;
			break;
		end
		
		local NeedTree = string.sub(NeedTreeNameTemp, 1, needStart - 1);
		NeedTreeNameTemp = string.sub(NeedTreeNameTemp, needEnd + 1);
		
		NeedSkillNameList[needNameCount] = NeedTree;		
		needNameCount = needNameCount + 1;
	end
	
	local findSkillCount = 0;
	local cnt = #treelist;	
	for i = 1 , cnt do
		local info = treelist[i];
		local cls = info["class"];
		
		for k = 1, needNameCount do			
			if cls.SkillName == NeedSkillNameList[k] then
				local lv = info["lv"] + info["statlv"];
				if lv >= NeedLevelList[k] then
					findSkillCount = findSkillCount + 1;
				else
					return 0;
				end
			end			
		end		
	end
	
	if findSkillCount >= needNameCount then
		return 1;
	end

	return 0;
end

function GET_SKILLTREE_MAXLV(pc, jobName, cls)
	local classLv = GetJobGradeByName(pc, jobName);
	local ret = (classLv - cls.UnlockGrade + 1) * cls.LevelPerGrade;
	if ret > cls.MaxLevel then
		ret = cls.MaxLevel;
	end

	return ret;
end


