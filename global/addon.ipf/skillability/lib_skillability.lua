
function SKILLABILITY_GET_JOB_ID_LIST()
    local mySession = session.GetMySession();
    local jobhistory = mySession:GetPCJobInfo();
    local joblist = {}
    local hash = {}
    for i=0, jobhistory:GetJobCount()-1 do
        local jobinfo = jobhistory:GetJobInfoByIndex(i);
        if hash[jobinfo.jobID] == nil then
            hash[jobinfo.jobID] = true;
            joblist[#joblist+1] = jobinfo.jobID;
        end
    end    
    
    return joblist;
end

function SKILLABILITY_GET_JOB_TAB_INFO_LIST()
    local textstyle = "{@st66b}";

    local joblist = SKILLABILITY_GET_JOB_ID_LIST();
    
    local gender = GETMYPCGENDER();
    local clslist, cnt = GetClassList("Job");
    local list = {}
    for i=1, #joblist do
        local jobid = joblist[i];
        local jobcls = GetClassByTypeFromList(clslist, jobid);
        local jobName = GET_JOB_NAME(jobcls, gender);
        list[#list + 1] = UI_LIB_TAB_GET_ADD_TAB_INFO("tab_"..jobid, "gb_"..jobid, textstyle..jobName, jobcls.ClassName, false);
    end
    
	local commonSkillCount = session.skill.GetCommonSkillCount();	
	if commonSkillCount > 0 then		
        list[#list + 1] = UI_LIB_TAB_GET_ADD_TAB_INFO("tab_"..0, "gb_"..0, textstyle..ClMsg("Common"), "Common", false);
	end

    return list;
end

function SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName)--Ability_Peltasta
    local abilGroupName = "Ability_"..jobEngName;
    return abilGroupName;
end

function SKILLABILITY_GET_ABILITY_NAME_LIST(jobClsName, jobEngName)
    local retList = {}
    local jobCls = GetClass("Job", jobClsName);
    
    if jobCls.DefHaveAbil ~= "None" then
	    local sList = StringSplit(jobCls.DefHaveAbil, "#");
        for i=1, #sList do
            retList[#retList+1] = sList[i];
        end
    end

    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local list, cnt = GetClassList(abilGroupName);
    
    for i = 0, cnt-1 do
        local groupClass = GetClassByIndexFromList(list, i);
        if groupClass ~= nil then
            local abilClass = GetClass("Ability", groupClass.ClassName);
            if abilClass ~= nil then
                retList[#retList+1] = groupClass.ClassName;
            end
        end
    end

     return retList;
end

function GET_ABILITY_CONDITION_UNLOCK(abilIES, groupClass)
    if groupClass == nil then
        return nil;
    end

	local unlockFuncName = groupClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local ret = scp(GetMyPCObject(), groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
        return ret;
    end
    return nil;
end

function SKILLABILITY_GET_ABILITY_CONDITION(abilIES, groupClass, isMax)
    local ret = GET_ABILITY_CONDITION_UNLOCK(abilIES, groupClass);

    local condition = '';
	if ret ~= nil then
		if ret ~= 'UNLOCK' then
            if ret == 'LOCK_GRADE' then
                condition = groupClass.UnlockDesc;
            elseif ret == 'LOCK_LV' then
                condition = ScpArgMsg('NeedMorePcLevel');
            end
        elseif isMax == 1 then
            condition = ScpArgMsg('Auto_{@st}_ChoeKo_LeBel_MaSeuTeo!')
		end
    end
    return condition;
end

function IS_ABILITY_MAX(pc, groupClass, abilClass)
    if groupClass == nil then
        return nil;
    end

	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local curLv = 0;
	if abilIES ~= nil then
		curLv = abilIES.Level;
	end	

	local isMax = 0;	
	local maxLevel = tonumber(groupClass.MaxLevel)
	if curLv >= maxLevel then
		isMax = 1;
	end

	return isMax;
end

function GET_TREE_INFO_BY_CLS(cls, skillList)
    local maxLv = GET_SKILLTREE_MAXLV(nil, nil, cls);
    if 0 >= maxLv then
        return;
    end

    local info = {};
    info["class"] = cls;

    local lv = 0;
    local obj = nil;
    local dbLv = 0;
    local skl = skillList:GetSkillByName(cls.SkillName)
    if skl ~= nil then
        obj = GetIES(skl:GetObject());
        lv = obj.Level;
        dbLv = obj.LevelByDB;
    end
    
    info["skillname"] = cls.SkillName;
    info["obj"] = obj;
    info["lv"] = lv;
    info["DBLv"] = dbLv;
    info["statlv"] = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
    info["unlockLv"] = cls.UnlockClassLevel;

    return info;
end

function GET_TREE_INFO_BY_CLSNAME(name)
    local mySession = session.GetMySession();
	local skillList = mySession:GetSkillList();
    local cls = GetClass("SkillTree", name);
    if cls == nil then
        return;
    end
    return GET_TREE_INFO_BY_CLS(cls, skillList);
end

function GET_COMMON_SKILL_INFO_BY_CLSNAME(sklClsName)
    local info = {}
    info["class"] = nil;
    info["obj"] = nil;
	info["lv"] = 1;
	info["statlv"] = 0;
    info["skillname"] = sklClsName;
    return info;
end

function GET_SKILL_INFO_BY_JOB_CLSNAME(jobClsName, sklTreeClsName, sklClsName)
    if jobClsName == "Common" then
        return GET_COMMON_SKILL_INFO_BY_CLSNAME(sklClsName)
    end
    return GET_TREE_INFO_BY_CLSNAME(sklTreeClsName);
end

function GET_TREE_INFO_VEC(jobName)
    local treelist = {};
    
    local mySession = session.GetMySession();
	local skillList = mySession:GetSkillList();
	
    local clslist, cnt  = GetClassList("SkillTree");
    local index = 1;
	while 1 do
		local name = jobName .. "_" ..index;
		local cls = GetClassByNameFromList(clslist, name);
		if cls == nil then
			break;
        end
        treelist[#treelist+1] = GET_TREE_INFO_BY_CLS(cls, skillList);
		index = index + 1;	
    end

    return treelist;
end

function GET_TREE_UNLOCK_LEVEL_LIST(treeInfoList)
    local levelHash = {}

    for _, info in pairs(treeInfoList) do
        local unlockLv = info["unlockLv"];
        if levelHash[unlockLv] == nil then
            levelHash[unlockLv] = {};
        end
        local cls = info["class"];
        levelHash[unlockLv][#levelHash[unlockLv]+1] = cls.ClassName;
    end
    return levelHash;
end

function MAKE_SKILLTREE_CTRLSET_ICON(ctrlset, skillCls, sklObj)
	local skillSlot = GET_CHILD(ctrlset, "slot");
	local icon = CreateIcon(skillSlot);
    local iconname = "icon_"..skillCls.Icon;
	icon:SetImage(iconname);
	icon:SetTooltipType('skill');
	icon:SetTooltipStrArg(skillCls.ClassName);
	icon:SetTooltipNumArg(skillCls.ClassID);
    icon:SetTooltipIESID(GetIESGuid(sklObj));
    icon:SetTooltipOverlap(1);
	icon:Set(iconname, "Skill", skillCls.ClassID, 1);	
    icon:SetDropFinallyScp("DROP_FINALLY_SKILL_ICON");

	return skillSlot, icon;
end

function LIFT_SKILL_ICON(parent, ctrl)
	local FromFrame = ctrl:GetTopParentFrame();
    if FromFrame ~= nil then
        local layer = tonumber(FromFrame:GetUserConfig("LAYER_LEVEL_DRAG_ON"));
        FromFrame:SetLayerLevel(layer)
    end

    local skillName = parent:GetUserValue("SkillClsName");
    if skillName ~= "None" then
        local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(FromFrame);
        local skilltree_gb = GET_CHILD_RECURSIVELY(gb, "skilltree_gb");
        local ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..skillName);
        if ctrlset ~= nil then
            SKILLABILITY_SELECT_SKILL(skilltree_gb, ctrlset);
        end
    end
end

function DROP_FINALLY_SKILL_ICON(frame, object, argStr, argNum)	
    AUTO_CAST(object);
	local FromFrame = object:GetTopParentFrame();
    local layer = tonumber(FromFrame:GetUserConfig("LAYER_LEVEL_DRAG_OFF"));
	FromFrame:SetLayerLevel(layer)
end

function LIFT_ABILITY_ICON(parent, ctrl)
    local FromFrame = ctrl:GetTopParentFrame();
    if FromFrame ~= nil then
        local layer = tonumber(FromFrame:GetUserConfig("LAYER_LEVEL_DRAG_ON"));
        FromFrame:SetLayerLevel(layer)
    end
end
 
function DROP_FINALLY_ABILITY_ICON(frame, object, argStr, argNum)	
    AUTO_CAST(object);
    local FromFrame = object:GetTopParentFrame();
    local layer = tonumber(FromFrame:GetUserConfig("LAYER_LEVEL_DRAG_OFF"));
    FromFrame:SetLayerLevel(layer)
end

function SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame)
    local job_tab = GET_CHILD(frame, "job_tab");
    if job_tab == nil or job_tab:GetItemCount() <=0 then
        return;
    end

    local tabName = job_tab:GetSelectItemName();
    local jobIDStr = string.sub(tabName, 5, string.len(tabName));
    
    local gb = GET_CHILD_RECURSIVELY(frame, "gb_"..jobIDStr);
    return gb;
end


function GET_ABILITYLIST_BY_SKILL_NAME(skillName, jobEngNameList)
    local abilList, abilCnt = GetClassList('Ability')
    local retList = {}
    local index = 0
    local dummyCls = GetClassByIndexFromList(abilList, 0) -- for check exception

    -- exception handle
    if abilList == nil then
        return nil
    end
    if abilCnt < 1 or dummyCls == nil then
        return nil
    end
    if TryGetProp(dummyCls, 'SkillCategory') == nil then
        return nil
    end

    -- get list
    for i = 0, abilCnt do
        local abilCls = GetClassByIndexFromList(abilList, i - 1)
        if abilCls ~= nil then
            local abilGroupCls = GET_ABILITY_GROUP_CLASS_BY_JOB_ENG_LIST(jobEngNameList, abilCls.ClassName)
            local abilClsSkillList = SCR_STRING_CUT_SEMICOLON(abilCls.SkillCategory);
            if abilGroupCls ~= nil and abilClsSkillList ~= nil and #abilClsSkillList ~= 0 then
                for j = 1, #abilClsSkillList do
                    local abilClsSkillName = abilClsSkillList[j];
                    if abilClsSkillName == skillName then
                        retList[index] = abilCls
                        index = index + 1
                    end
                end
            end
        end
    end

    return retList, index -- return list and count
end

function GET_ABILITY_GROUP_CLASS_BY_JOB_ENG_LIST(jobEngNameList, abilClsName)
    local abilGroupNameList = {}
    for i=1, #jobEngNameList do
        local jobEngName = jobEngNameList[i]
        local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName)
        abilGroupNameList[#abilGroupNameList + 1] = abilGroupName
    end
    for i=1, #abilGroupNameList do
        local abilGroupName = abilGroupNameList[i]
        local abilGroupCls = GetClass(abilGroupName, abilClsName)
        if abilGroupCls ~= nil then
            return abilGroupCls
        end
    end
    return nil
end

function GET_REMAIN_SKILLTREE_POINT(jobClsName)
    if jobClsName == "Common" then
        return 0;
    end
    local list = GET_TREE_INFO_VEC(jobClsName)
    local pc = GetMyPCObject();
    local jobCls = GetClass("Job", jobClsName);
	local bonusstat = GetRemainSkillPts(pc, jobCls.ClassID);
	local totaluse = 0;
	for _, info in pairs(list) do
		local uselevel = info["statlv"];
		if uselevel > 0 then
			totaluse = totaluse + uselevel;
		end
	end

	return bonusstat - totaluse;
end

function CLEAR_SKILLABILITY_POINT(jobClsName)
    if jobClsName == "Common" then
        return false;
    end

    local list = GET_TREE_INFO_VEC(jobClsName)
    local changed = false;
    -- for all skill
    for _, info in pairs(list) do
        local cls = info["class"];
        local set = session.SetUserConfig("SKLUP_" .. cls.SkillName, 0);
        if set == 1 then
            changed = true;
        end
    end
    return changed;
end

function IS_CHANGED_SKILLABILITY_SKILL(jobClsName)
    local list = GET_TREE_INFO_VEC(jobClsName)
    local changed = false;
    -- for all skill
    for _, info in pairs(list) do
        local cls = info["class"];
        local usedpts = session.GetUserConfig("SKLUP_" .. cls.SkillName);
        if usedpts > 0 then
            return true;
        end
    end
    return false;
end

function COMMIT_SKILLABILITY_SKILL(jobClsName)
    local jobCls = GetClass("Job", jobClsName);
    local ArgStr = string.format("%d", jobCls.ClassID);
    
    local list = GET_TREE_INFO_VEC(jobClsName);
	local isReq = false;
    for _, info in pairs(list) do
        local cls = info["class"];
		local usedpts = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
		if usedpts > 0 then
			isReq = true;
		end
		ArgStr = string.format("%s %d", ArgStr, usedpts);
		session.SetUserConfig("SKLUP_" .. cls.SkillName, 0);
	end

    if isReq then
		pc.ReqExecuteTx_NumArgs("SCR_TX_SKILL_UP", ArgStr);
	end

    return isReq;
end

function GET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClsName)
    local val = ability_gb:GetUserValue(abilClsName)
    if val == "None" then
        return 0;
    end

    return tonumber(val);
end

function SET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClsName, value)
    ability_gb:SetUserValue(abilClsName, value);
end

function CLEAR_SKILLABILITY_LEARN_COUNT_BY_JOB(ability_gb, jobClsName)
    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local list = SKILLABILITY_GET_ABILITY_NAME_LIST(jobClsName, jobEngName)--Ability_Peltasta

    for i=1, #list do
        local abilClass = GetClass("Ability", list[i]);
        SET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClass.ClassName, "None")
    end
end

function GET_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
    local abilClsIDList = {}
    local abilCountList = {}
    
    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local list = SKILLABILITY_GET_ABILITY_NAME_LIST(jobClsName, jobEngName)--Ability_Peltasta
    
    for i=1, #list do
        local clsName = list[i];
        local cls = GetClass(abilGroupName, clsName);
        local abilCount = GET_SKILLABILITY_LEARN_COUNT(ability_gb, clsName)
        if cls ~= nil and abilCount > 0 then
            abilClsIDList[#abilClsIDList+1] = cls.ClassID;
            abilCountList[#abilCountList+1] = abilCount;
        end
    end
    return abilClsIDList, abilCountList; 
end

function IS_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
    local abilClsIDList, abilCountList = GET_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
    return #abilClsIDList > 0 and #abilClsIDList == #abilCountList;
end

function COMMIT_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
    if IS_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName) then
        local abilClsIDList, abilCountList = GET_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
        RequestLearnAbility(abilGroupName, abilClsIDList, abilCountList);
    end
end

function GET_ABILITY_LEARN_COST(pc, groupClass, abilClass, destLv)

	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local curLv = 0;
	if abilIES ~= nil then
		curLv = abilIES.Level;
	end	
	local funcName = groupClass.ScrCalcPrice;

	local price = 0;
	local totalTime = 0;
	local tempPrice = 0;
	local tempTotalTime = 0;

	if funcName ~= 'None' then
		for abilLv = curLv+1, destLv, 1 do
			local scp = _G[funcName];
			tempPrice, tempTotalTime = scp(pc, abilClass.ClassName, abilLv, groupClass.MaxLevel);

			tempPrice = GET_ABILITY_PRICE(tempPrice, groupClass, abilClass, abilLv)
			price = price + tempPrice;			
			tempTotalTime = math.floor(tempTotalTime);
			totalTime = totalTime + tempTotalTime;
		end
	else
		for abilLv = curLv+1, destLv, 1 do
			tempPrice = groupClass["Price" .. abilLv];
			tempTotalTime = groupClass["Time" .. abilLv];
			tempPrice = GET_ABILITY_PRICE(tempPrice, groupClass, abilClass, abilLv)
			price = price + tempPrice;			
			tempTotalTime = math.floor(tempTotalTime);
			totalTime = totalTime + tempTotalTime;	
		end
	end
				
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		totalTime = 0;
	end
	
	return price, totalTime
end

function GET_ABILITY_PRICE(price, groupClass, abilClass, abilLv)
	if IS_SEASON_SERVER(nil) == "YES" then
		price = price - (price * 0.4)
--	else
--	    price = price - (price * 0.2)
	end
  
	price = math.floor(price);
	
	return price;
end

function GET_SKILLABILITY_COMMON_SKILL_LIST()
    local skillLvHash = {}
    skillLvHash[1] = {}
    local skillIDList = skillLvHash[1];
	local commonSkillCount = session.skill.GetCommonSkillCount();	
    for i=0,commonSkillCount-1 do
		local skillID = session.skill.GetCommonSkillIDByIndex(i);
        local sklCls = GetClassByType("Skill", skillID);
        skillIDList[#skillIDList+1] = sklCls.ClassName;
    end
    return skillLvHash;
end

function HAS_ABILITY_SKILL(abilName)
	local category_list = GET_ABILITY_SKILL_CATEGORY_LIST(abilName)
    if #category_list <= 0 then
        return true -- nothing to have.
    end
    for i=1, #category_list do
        local sklName = category_list[i]
        local sklObj = GetSkill(GetMyPCObject(), sklName)
        if sklObj ~= nil then
            return true;
        end
    end
    return false;
end

function GET_SKILL_OVERHEAT_COUNT(sklObj)
    local overHeat = 0;
    if sklObj ~= nil then
        overHeat = TryGetProp(sklObj, 'SklUseOverHeat', 0);
    end
    if overHeat == 0 then
        overHeat = 1
    end
    return overHeat;
end
