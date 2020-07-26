function SKILLABILITY_ON_INIT(addon, frame)
    addon:RegisterOpenOnlyMsg('SUCCESS_BUY_ABILITY_POINT', 'ON_SKILLABILITY_BUY_ABILITY_POINT');
    addon:RegisterOpenOnlyMsg('SUCCESS_LEARN_ABILITY', 'ON_SKILLABILITY_LEARN_ABILITY');
    addon:RegisterOpenOnlyMsg('PC_PROPERTY_UPDATE', 'ON_SKILLABILITY_UPDATE_PROPERTY');
    addon:RegisterOpenOnlyMsg('UPDATE_ABILITY_POINT', 'ON_SKILLABILITY_UPDATE_ABILITY_POINT');
    addon:RegisterOpenOnlyMsg('RESET_ABILITY_ACTIVE', 'ON_SKILLABILITY_TOGGLE_SKILL_ACTIVE');

    --moved
    addon:RegisterOpenOnlyMsg('RESET_SKL_UP', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('JOB_CHANGE', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('UPDATE_SKILLMAP', 'SKILLABILITY_ON_FULL_UPDATE');
    addon:RegisterOpenOnlyMsg('SKILL_LIST_GET_RESET_SKILL', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('ABILITY_LIST_GET', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('RESET_ABILITY_UP', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('UPDATE_COMMON_SKILL_LIST', 'ON_UPDATE_COMMON_SKILL_LIST');
    addon:RegisterOpenOnlyMsg('POPULAR_SKILL_INFO', 'ON_POPULAR_SKILL_INFO');
    
    addon:RegisterMsg('SKILL_LIST_GET', 'SKILLABILITY_ON_FULL_UPDATE');
    addon:RegisterMsg('DELETE_QUICK_SKILL', 'SKILLABILITY_ON_FULL_UPDATE');
    addon:RegisterMsg("SPECIFIC_SKILL_GET", "SKILLABILITY_ADD_SPECIFIC_SKILL");
    addon:RegisterMsg('DELETE_SPECIFIC_SKILL', 'SKILLABILITY_REMOVE_SPECIFIC_SKILL');
end

function UPDATE_SKILL_BY_SKILLMAKECOSTUME(resStr)
    local datas = StringSplit(resStr, ":");
    local msg = datas[1];
    local skillName = datas[2];
    local frame = ui.GetFrame("skillability");
    if frame ~= nil then
        local ctrlSet = GET_CHILD_RECURSIVELY(frame, "SKILL_"..skillName);
        if ctrlSet ~= nil then
            if msg == "create_skill" then
                ctrlSet:SetVisible(1);
            elseif msg == "remove_skill" then
                ctrlSet:SetVisible(0);
                frame:RemoveChild(ctrlSet:GetName());
                local commonSkillCount = session.skill.GetCommonSkillCount();
                local job_tab = GET_CHILD_RECURSIVELY(frame, "job_tab");
                if job_tab ~= nil and commonSkillCount <= 0 then
                    local tabIndex = job_tab:GetIndexByName("tab_"..0);
                    job_tab:DeleteTab(tabIndex);
                end
            end
        end

        session.skill.ReqCommonSkillList();
        frame:Invalidate();
    end
end

function SKILLABILITY_COMMON_LEGENDITEMSKILL_UPDATE(frame, msg, skillID, argNum)
    if frame == nil then return; end
    local skillability_job = GET_CHILD_RECURSIVELY(frame, "skillability_job_Common");
    if skillability_job == nil then return end
    local skilltree_gb = GET_CHILD_RECURSIVELY(skillability_job, "skilltree_gb");
    if skilltree_gb == nil then return end

    -- check child skillID
    local gb_ChildCnt = skilltree_gb:GetChildCount();
    local exist_trans_skill = HAS_SKILLTREEGB_IN_COMMON_TRANSSKILL_BY_CHILD(skilltree_gb, gb_ChildCnt);
    if exist_trans_skill == nil then return; end

    -- check msg skillID
    local skillInfo = session.GetSkill(tonumber(skillID));
    if skillInfo ~= nil then
        local sklObj = GetIES(skillInfo:GetObject());
        if sklObj == nil then return end
        if HAS_SKILLTREEGB_IN_COMMON_TRANSSKILL_BY_SKILL_OBJ(sklObj) == false then
            exist_trans_skill = false;
        end
    end

    if exist_trans_skill == true or argNum == 1 then
        local commSkillCnt = session.skill.GetCommonSkillCount();
        if commSkillCnt <= 0 then
            local job_tab = GET_CHILD_RECURSIVELY(frame, "job_tab");
            if job_tab ~= nil then
                local tabIndex = job_tab:GetIndexByName("tab_0");
                job_tab:DeleteTab(tabIndex);
            end
            return;
        end

        if msg == "DELETE_SPECIFIC_SKILL" and argNum == 1 then
            if gb_ChildCnt <= 0 then return; end
            for i = 0, gb_ChildCnt - 1 do
                local gb_Child = skilltree_gb:GetChildByIndex(i);
                if gb_Child == nil then break end

                if string.find(gb_Child:GetName(), "SKILL_") ~= nil and HAS_SKILLTREEGB_IN_COMMON_TRANSSKILL_BY_CHILDNAME(gb_Child:GetName()) == false then
                    local ctrlSet = GET_CHILD_RECURSIVELY(skilltree_gb, gb_Child:GetName());
                    if skillInfo == nil then
                        ctrlSet:SetVisible(0);
                        frame:RemoveChild(ctrlSet:GetName());
                    end
                end
            end
        elseif msg == "SPECIFIC_SKILL_GET" and argnum == 1 then
            if skillInfo == nil then return; end
            local sklObj = GetIES(skillInfo:GetObject());
            if sklObj == nil then return end

            local visibleSkillName = "SKILL_"..sklObj.ClassName;
            local ctrlSet = GET_CHILD_RECURSIVELY(skilltree_gb, visibleSkillName);
            if ctrlSet ~= nil then
                ctrlSet:SetVisible(1);
            end
        end
    else
        if skillInfo == nil then return end
        local sklObj = GetIES(skillInfo:GetObject());
        if sklObj == nil then return end

        local visibleSkillName = "SKILL_"..sklObj.ClassName;
        local ctrlSet = GET_CHILD_RECURSIVELY(skilltree_gb, visibleSkillName);
        if ctrlSet ~= nil then
            ctrlSet:SetVisible(1);
        end
    end

    session.skill.ReqCommonSkillList();
    skillability_job:Invalidate();
end

function SKILLABILITY_ADD_SPECIFIC_SKILL(frame, msg, skillID, argNum)
    if skillID ~= nil then
        SKILLABILITY_COMMON_LEGENDITEMSKILL_UPDATE(frame, msg, skillID, argNum);
        frame:Invalidate();
    end
end

function SKILLABILITY_REMOVE_SPECIFIC_SKILL(frame, msg, skillID, argNum)
    if skillID ~= nil then
        SKILLABILITY_COMMON_LEGENDITEMSKILL_UPDATE(frame, msg, skillID, argNum);
        frame:Invalidate();
    end
end

function SKILLABILITY_ON_FULL_UPDATE(frame, msg, skillID, argNum)
    local oldgb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = nil;
    if oldgb ~= nil then
        jobClsName = oldgb:GetUserValue("JobClsName");
    end

    SKILLABILITY_MAKE_JOB_TAB(frame);
    local job_tab = GET_CHILD(frame, "job_tab");
    if jobClsName ~= nil and jobClsName ~= "Common" then
        local jobCls = GetClass("Job", jobClsName)
        local tabIndex = job_tab:GetIndexByName("tab_"..jobCls.ClassID);
        job_tab:SelectTab(tabIndex);
    elseif jobClsName == "Common" then
        local tabIndex = job_tab:GetIndexByName("tab_"..0);
        job_tab:SelectTab(tabIndex);
    end

    if skillID ~= nil then
        SKILLABILITY_COMMON_LEGENDITEMSKILL_UPDATE(frame, msg, skillID, argNum);
    end

    frame:Invalidate();
end

function SKILLABILITY_MAKE_JOB_TAB(frame)
    local job_tab = GET_CHILD(frame, "job_tab");

    local job_tab_width = frame:GetUserConfig("JOB_TAB_WIDTH");
    local job_tab_height = frame:GetUserConfig("JOB_TAB_HEIGHT");
    local job_tab_x = frame:GetUserConfig("JOB_TAB_X");
    local job_tab_y = frame:GetUserConfig("JOB_TAB_Y");
    local tab_width = frame:GetUserConfig("TAB_WIDTH");

    local addTabInfoList = SKILLABILITY_GET_JOB_TAB_INFO_LIST();
    local gblist = UI_LIB_TAB_ADD_TAB_LIST(frame, job_tab, addTabInfoList, job_tab_width, job_tab_height, ui.CENTER_HORZ, ui.TOP, job_tab_x, job_tab_y, "job_tab_box", "true", tab_width, "JobClsName");
    
    for i = 1, #gblist do
    local gb = gblist[i];
        gb:SetTabChangeScp("SKILLABILITY_ON_CHANGE_TAB");
    end
    SKILLABILITY_ON_CHANGE_TAB(frame);
    frame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", imcTime.GetAppTime());
end

function SKILLABILITY_ON_OPEN(frame)
    SKILLABILITY_MAKE_JOB_TAB(frame);
    session.skill.ReqCommonSkillList();
    
    local jobObj = info.GetJob(session.GetMyHandle());
	local jobCtrlTypeName = GetClassString('Job', jobObj, 'CtrlType');
    ui.ReqRedisSkillPoint(jobCtrlTypeName);
    ui.UpdateKeyboardSelectChildByFrameName("skillability");
end

function SKILLABILITY_ON_CHANGE_TAB(frame)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    CLEAR_SKILLABILITY_POINT(jobClsName)
    
    local skillability_job = gb:CreateOrGetControlSet("skillability_job", "skillability_job_"..jobClsName, 0, 0);
    SKILLABILITY_FILL_JOB_GB(skillability_job, jobClsName)
end

function SKILLABILITY_FILL_JOB_GB(skillability_job, jobClsName)
    local skill_gb = GET_CHILD(skillability_job, "skill_gb");
    local ability_gb = GET_CHILD(skillability_job, "ability_gb");
    local skilltree_gb = GET_CHILD_RECURSIVELY(skill_gb, "skilltree_gb");
    SKILLABILITY_FILL_SKILL_GB(skillability_job, skill_gb, jobClsName);
    SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName);
    local skillinfo_gb = GET_CHILD_RECURSIVELY(skill_gb, "skillinfo_gb");

    local ctrlset = nil
    local infoctrl = skillinfo_gb:GetControlSet("skillability_skillinfo", "skillability_skillinfo");
    if infoctrl ~= nil then
        local skillName = infoctrl:GetUserValue("SkillClsName")
        ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..skillName);
    end

    if ctrlset == nil then
        local mySession = session.GetMySession();
        local treelist = GET_TREE_INFO_VEC(jobClsName)
        local unlockLvHash = GET_TREE_UNLOCK_LEVEL_LIST(treelist);
        if unlockLvHash[1] ~= nil then
            local width = ui.GetControlSetAttribute("skillability_skillset", "width");            
            local skillTreeClsName = unlockLvHash[1][1];
            local cls = GetClass("SkillTree", skillTreeClsName)
            ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..cls.SkillName);
        end
    end

    if ctrlset == nil then
        return;
    end

    SKILLABILITY_SELECT_SKILL(skilltree_gb, ctrlset)
end

function SKILLABILITY_FILL_SKILL_GB(skillability_job, skill_gb, jobClsName)
    local frame = skillability_job:GetTopParentFrame();
    AUTO_CAST(skillability_job)
    local SKILL_LV_HEIGHT = tonumber(skillability_job:GetUserConfig("SKILL_LV_HEIGHT"));
    local SKILL_LV_MARGIN = tonumber(skillability_job:GetUserConfig("SKILL_LV_MARGIN"));
    local SKILL_LV_DIST = tonumber(skillability_job:GetUserConfig("SKILL_LV_DIST"));
    local SKILL_COL_COUNT = tonumber(skillability_job:GetUserConfig("SKILL_COL_COUNT"));
    local SKILL_LINE_BREAK_COUNT = tonumber(skillability_job:GetUserConfig("SKILL_LINE_BREAK_COUNT"));
    
    local skilltree_gb = GET_CHILD_RECURSIVELY(skill_gb, "skilltree_gb");
    
    local unlockLvHash = {};
    if jobClsName == "Common" then
        unlockLvHash = GET_SKILLABILITY_COMMON_SKILL_LIST();
    else
        local treelist = GET_TREE_INFO_VEC(jobClsName)
        unlockLvHash = GET_TREE_UNLOCK_LEVEL_LIST(treelist);
    end
    SKILLABILITY_DEPLOY_JOB_SKILL(skilltree_gb, jobClsName, unlockLvHash, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT, SKILL_LV_HEIGHT, SKILL_LV_MARGIN, SKILL_LV_DIST)

    SKILLABILITY_DEPLOY_LABEL_LINE(skilltree_gb, unlockLvHash, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT, SKILL_LV_HEIGHT)

    ON_UPDATE_SKILLABILITY_SKILL_POINT(skill_gb, jobClsName);
    ON_POPULAR_SKILL_INFO(frame);
end

function ON_UPDATE_SKILLABILITY_SKILL_POINT(parent, jobClsName)
    if jobClsName == "Common" then
        return;
    end
    local pc = GetMyPCObject();
    local jobCls = GetClass("Job", jobClsName);
    local bonusstat = GetRemainSkillPts(pc, jobCls.ClassID);
    local skillpoint_text = GET_CHILD_RECURSIVELY(parent, "skillpoint_text");
    local point = GET_REMAIN_SKILLTREE_POINT(jobClsName)
    skillpoint_text:SetTextByKey("cur", point);
    skillpoint_text:SetTextByKey("max", bonusstat);
end

local function CHECK_ENABLE_GET_SKILL_C(skillClsName, totallv, maxlv)
	local pc = GetMyPCObject();
	local ret, reason = SCR_ENABLE_GET_SKILL_COMMON(pc, skillClsName, totallv + 1);
	if ret == false then
		return false, reason;
	end
	return true;
end

function SKILLABILITY_FILL_SKILL_CTRLSET(ctrlset, info, jobClsName)
    local IMG_LOCK = ctrlset:GetUserConfig("IMG_LOCK");
    local IMG_MAX = ctrlset:GetUserConfig("IMG_MAX");
    local ENABLED_COLOR = ctrlset:GetUserConfig("ENABLED_COLOR");
    local DISABLED_COLOR = ctrlset:GetUserConfig("DISABLED_COLOR");
    local cls = info["class"];
    local obj = info["obj"];
	local dbLv = info["DBLv"];
	local statlv = info["statlv"];
    local sklClsName = info["skillname"];
	local sklCls = GetClass("Skill", sklClsName);
    MAKE_SKILLTREE_CTRLSET_ICON(ctrlset, sklCls, obj)

    if cls ~= nil then
        ctrlset:SetUserValue("SkillTreeClsName", cls.ClassName);
    end
    ctrlset:SetUserValue("SkillClsName", sklClsName);

    local slot_bg = GET_CHILD(ctrlset, "slot_bg");
    local slot = GET_CHILD(ctrlset, "slot");
    if cls ~= nil then
        slot_bg:SetEventScript(ui.LBUTTONUP, "ON_CLICK_SKILLABILITY_SKILL_CTRLSET");
        slot_bg:SetEventScriptArgString(ui.LBUTTONUP, sklClsName);
        slot:SetEventScript(ui.LBUTTONUP, "ON_CLICK_SKILLABILITY_SKILL_CTRLSET");
        slot:SetEventScriptArgString(ui.LBUTTONUP, sklClsName);
    end
    
    local level_txt = GET_CHILD(ctrlset, "level_txt");
    
    if cls ~= nil then
        level_txt:SetTextByKey("value", dbLv);
    else
        level_txt:SetTextByKey("value", 1);
    end

    local upbtn = GET_CHILD(ctrlset, "upbtn");
    if cls ~= nil then
        upbtn:SetEventScript(ui.LBUTTONUP, "ON_CLICK_SKILLABILITY_SKILL_CTRLSET_UP_BTN");
        upbtn:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassID);
        upbtn:SetEventScriptArgNumber(ui.LBUTTONUP, dbLv);
        upbtn:SetClickSound("button_click_skill_up");
    end
    
    local lockbtn = GET_CHILD(ctrlset, 'lockbtn');
	lockbtn:ShowWindow(0);
    local totallv = 0;
    if cls ~= nil then
        totallv = dbLv + statlv;
        if statlv > 0 then
            level_txt:SetTextByKey("value", "{#FF0000}"..totallv);
        end
    end

    local result, reason = false, "";    
	result, reason = CHECK_ENABLE_GET_SKILL_C(sklClsName, totallv, maxlv);
    if result == false then
        if reason == ScpArgMsg('MaxSkillLevel') then
            lockbtn:SetImage(IMG_MAX)
            lockbtn:SetColorTone(ENABLED_COLOR);
        else
            lockbtn:SetImage(IMG_LOCK)
            lockbtn:SetColorTone(DISABLED_COLOR);
        end
		lockbtn:SetTextTooltip(reason);
		lockbtn:ShowWindow(1);
		upbtn:ShowWindow(0);
	else
		upbtn:SetTextTooltip(ScpArgMsg('SkillLevelUp'));
    end
    
    local remainstat = GET_REMAIN_SKILLTREE_POINT(jobClsName)
	if remainstat <= 0 then
		upbtn:ShowWindow(0);		
	else
		upbtn:ShowWindow(1);
	end

    local isEnable = obj ~= nil or jobClsName == "Common";
    SKILLABILITY_ENABLE_SKILL_CTRLSET(ctrlset, isEnable)
end

function SKILLABILITY_ENABLE_SKILL_CTRLSET(ctrlset, isEnable)
    local ENABLED_COLOR = ctrlset:GetUserConfig("ENABLED_COLOR");
    local DISABLED_COLOR = ctrlset:GetUserConfig("DISABLED_COLOR");
    local slot_bg = GET_CHILD_RECURSIVELY(ctrlset, "slot_bg");
    local slot = GET_CHILD_RECURSIVELY(ctrlset, "slot");
    local icon = CreateIcon(slot);
    
    if isEnable then
        slot:EnablePop(1);
        icon:SetColorTone(ENABLED_COLOR)
        slot_bg:SetColorTone(ENABLED_COLOR)
    else
        slot:EnablePop(0);
        icon:SetColorTone(DISABLED_COLOR)
        slot_bg:SetColorTone(DISABLED_COLOR)
    end
end

function SKILLABILITY_SELECT_SKILL(parent, ctrlset)
    local frame = parent:GetTopParentFrame();
    local linkabil_offset_x = frame:GetUserConfig("LINKABIL_OFFSET_X");
    local linkabil_offset_y = frame:GetUserConfig("LINKABIL_OFFSET_Y");
    local height = ui.GetControlSetAttribute("skillability_linkabil", "height");
    
    local sklTreeClsName = ctrlset:GetUserValue("SkillTreeClsName");
    local sklClsName = ctrlset:GetUserValue("SkillClsName");

    local tab_gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = tab_gb:GetUserValue("JobClsName");
    local jobCls = GetClass("Job", jobClsName)
    local jobEngName = nil;
    if jobCls ~= nil then
        jobEngName = jobCls.EngName
    end
    
    local skillinfo_gb = GET_CHILD_RECURSIVELY(tab_gb, "skillinfo_gb");
    local infoctrl = skillinfo_gb:CreateOrGetControlSet("skillability_skillinfo", "skillability_skillinfo", 0, 0);
    AUTO_CAST(infoctrl)
    infoctrl:SetUserValue("SkillClsName", sklClsName)

    local info = GET_SKILL_INFO_BY_JOB_CLSNAME(jobClsName, sklTreeClsName, sklClsName);
    SKILLABILITY_FILL_SKILL_INFO(infoctrl, info)
    
    local linkabil_gb = GET_CHILD_RECURSIVELY(tab_gb, "linkabil_gb");
	DESTROY_CHILD_BYNAME(linkabil_gb, 'skillability_linkabil_');

    if sklTreeClsName ~= "None" then
    --from. UPDATE_SKILL_TOOLTIP. 
        local skillTreeCls = GetClass("SkillTree", sklTreeClsName);

        local jobEngNameList = {}
        jobEngNameList[#jobEngNameList+1] = jobEngName
        
        local abilList, abilCnt = GET_ABILITYLIST_BY_SKILL_NAME(skillTreeCls.SkillName, jobEngNameList);
        for i=0, abilCnt-1 do 
            local abilCls = abilList[i];
            local abilCtrl = linkabil_gb:CreateOrGetControlSet("skillability_linkabil", "skillability_linkabil_"..abilCls.ClassName, linkabil_offset_x, linkabil_offset_y + i*height);
            AUTO_CAST(abilCtrl);
            SKILLABILITY_FILL_LINKABIL_CTRLSET(abilCtrl, abilCls)
        end
    end
end

function SKILLABILITY_FILL_LINKABIL_CTRLSET(classCtrl, abilClass)
    local slot = GET_CHILD(classCtrl, "slot");
    local nameText = GET_CHILD(classCtrl, "nameText");
    local abilLevelText = GET_CHILD(classCtrl, "abilLevelText");
    local linkGB = GET_CHILD(classCtrl, "linkGB");
    local toggle = GET_CHILD(classCtrl, "toggle");
    --from MAKE_ABILITYSHOP_ICON

	-- icon.
	local icon = CreateIcon(slot);	
    icon:SetImage(abilClass.Icon);
	icon:SetTooltipType('ability');
    icon:SetDropFinallyScp("DROP_FINALLY_ABILITY_ICON");
	icon:Set(abilClass.Icon, "Ability", abilClass.ClassID, 1);
    icon:SetTooltipOverlap(1);
    icon:SetTooltipStrArg(abilClass.Name);
    icon:SetTooltipNumArg(abilClass.ClassID);
    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
    icon:SetTooltipIESID(GetIESGuid(abilIES));

    local isEnablePop = 0;
    if abilIES ~= nil and abilClass.AlwaysActive == "NO" then
        isEnablePop = 1;
    end
    slot:EnablePop(isEnablePop);
    
    -- toggle.
    local isActive = TryGetProp(abilIES, "ActiveState");
    if isActive == nil then
        isActive = abilClass.ActiveState;
    end
    classCtrl:SetUserValue("ClsName", abilClass.ClassName);
    SKILLABILITY_INIT_TOGGLE_ABILITY(classCtrl, toggle, abilClass, isActive)

	-- name.
    nameText:SetTextByKey("value", abilClass.Name);
    
    --from. UPDATE_SKILL_TOOLTIP. 
    -- level.
    if abilIES ~= nil then
        abilLevelText:SetTextByKey("value", abilIES.Level);
    end

    linkGB:RemoveAllChild();
    local linkList = GetAbilityNameListByActiveGroup(abilClass.ActiveGroup)
    
    local active_group_dist_x = classCtrl:GetUserConfig("ACTIVE_GROUP_DIST_X");
    local active_group_width = classCtrl:GetUserConfig("ACTIVE_GROUP_WIDTH");
    local active_group_height = classCtrl:GetUserConfig("ACTIVE_GROUP_HEIGHT");
    local link_left_margin = classCtrl:GetUserConfig("LINK_LEFT_MARGIN");
    
    if linkList ~= nil then
        local linkPic = linkGB:CreateControl("picture", "link_"..0, active_group_width, active_group_height, ui.LEFT, ui.CENTER_VERT, link_left_margin, 0, 0, 0);
        AUTO_CAST(linkPic);
        linkPic:SetImage("skill_abill_link_pic");

        table.remove(linkList, table.find(linkList, abilClass.ClassName));
        for i=1, #linkList do
            local linkAbilName = linkList[i];
            local linkAbilCls = GetClass("Ability", linkAbilName);
            
            local pic = linkGB:CreateControl("picture", "link_"..i, i*(active_group_width+active_group_dist_x), 0, active_group_width, active_group_height);
            AUTO_CAST(pic);
            pic:SetEnableStretch(1);
            pic:SetImage(linkAbilCls.Icon);
        end
        linkGB:Resize((active_group_width+active_group_dist_x)*(#linkList+1), linkGB:GetOriginalHeight())
    end
    
end

function SKILLABILITY_FILL_SKILL_INFO(infoctrl, info)
    --from MAKE_SKILLTREE_ICON;
    local cls = info["class"];
    local obj = info["obj"];
    local sklClsName = info["skillname"];
	local sklCls = GetClass("Skill", sklClsName);

    MAKE_SKILLTREE_CTRLSET_ICON(infoctrl, sklCls, obj)
    
    local name_txt = GET_CHILD(infoctrl, "name_txt");
    name_txt:SetTextByKey("value", sklCls.Name)

    local lv = info["lv"];
    local sp = 0;
    local overHeat = 0;
    local coolDown = 0;
    if cls == nil then
        lv = 1
    end

    local sklProp = geSkillTable.Get(sklClsName);
    if sklProp ~= nil then
        overHeat = sklProp:GetOverHeatCnt();
    end

    if obj ~= nil then
        sp = GET_SPENDSP_BY_LEVEL(obj, lv);
        coolDown = obj.CoolDown / 1000;
        if overHeat == 0 then
            overHeat = GET_SKILL_OVERHEAT_COUNT(obj);
        end
    else
        local tempObj = CreateGCIESByID("Skill", sklCls.ClassID);
        tempObj.Level = lv;
        sp = GET_SPENDSP_BY_LEVEL(tempObj, lv);
        coolDown = tempObj.CoolDown / 1000;
        if overHeat == 0 then
            overHeat = GET_SKILL_OVERHEAT_COUNT(tempObj);
        end
    end
    
    lv = ScpArgMsg("level{value}", "value", lv);
    sp = tostring(sp);
    overHeat = ScpArgMsg("count{value}", "value", overHeat);
    coolDown = ScpArgMsg("second{value}", "value", coolDown);

    local level_txt = GET_CHILD(infoctrl, "level_txt");
    local sp_txt = GET_CHILD(infoctrl, "sp_txt");
    local overheat_txt = GET_CHILD(infoctrl, "overheat_txt");
    local cooldown_txt = GET_CHILD(infoctrl, "cooldown_txt");

    level_txt:SetTextByKey("before", lv)
    sp_txt:SetTextByKey("value", sp)
    overheat_txt:SetTextByKey("value", overHeat)
    cooldown_txt:SetTextByKey("value", coolDown)
    local AFTER_ARROW = "";
    if info["statlv"] > 0 then
        AFTER_ARROW = infoctrl:GetUserConfig("AFTER_ARROW");
    end
    level_txt:SetTextByKey("arrow", AFTER_ARROW)

    local afterLv = "";    
    if cls ~= nil then
        local dummyObj = CreateGCIES("Skill", sklClsName);
        dummyObj.Level = info["lv"]+info["statlv"];
        dummyObj.LevelByDB = info["lv"]+info["statlv"];

        if info["statlv"] > 0 then
            afterLv = dummyObj.Level;
            afterLv = ScpArgMsg("level{value}", "value", afterLv);
        end
    end
    level_txt:SetTextByKey("after", afterLv)

    local weapon_gb = GET_CHILD(infoctrl, "weapon_gb");
    weapon_gb:RemoveAllChild();
    local skillCls = GetClass("Skill", sklClsName);
    local iconCount, companionIconCount = MAKE_STANCE_ICON(weapon_gb, skillCls.ReqStance, skillCls.EnableCompanion, 0, 0);
    local weaponWidth = iconCount * 20 + companionIconCount * 20;
    if iconCount == 0 then
        weaponWidth = weaponWidth + 28;
    end
    weapon_gb:Resize(weaponWidth, weapon_gb:GetOriginalHeight());
end

function SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName)
    if jobClsName == "Common" then
        return;
    end
    local frame = skillability_job:GetTopParentFrame();

    local abilitytop_gb = GET_CHILD(ability_gb, "abilitytop_gb");
    local height = ui.GetControlSetAttribute("skillability_ability", "height");

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local list = SKILLABILITY_GET_ABILITY_NAME_LIST(jobClsName, jobEngName)--Ability_Peltasta

    local clsSortList = {};
    for i=1, #list do
        local abilClass = GetClass("Ability", list[i]);
        clsSortList[#clsSortList+1] = {}
        clsSortList[#clsSortList]["cls"] = abilClass;
        clsSortList[#clsSortList]["isDefaultAbil"] = IS_ABILITY_KEYWORD(abilClass, "DEFAULT_ABIL");
    end

    -- sort them. 
    table.sort(clsSortList, function(lhs, rhs)
        if lhs["isDefaultAbil"] == rhs["isDefaultAbil"] then
            return false
        elseif lhs["isDefaultAbil"] then
            return false
        elseif rhs["isDefaultAbil"] then
            return true
        end
        return lhs["cls"].ActiveGroup < rhs["cls"].ActiveGroup;
    end);

    local clsList = {};
    for i=1, #clsSortList do
        clsList[#clsList+1] = clsSortList[i]["cls"]
    end

    CLEAR_SKILLABILITY_LEARN_COUNT_BY_JOB(ability_gb, jobClsName);

    local abilitylist_gb = GET_CHILD(ability_gb, "abilitylist_gb");
    abilitylist_gb:RemoveAllChild()
    for i=1, #clsList do
        local abilClass = clsList[i];
        local abilClsName = abilClass.ClassName;
        local ctrlset = abilitylist_gb:CreateOrGetControlSet("skillability_ability", "skillability_ability_"..abilClsName, 30, (i-1)*height);
        AUTO_CAST(ctrlset);
        local groupClass = GetClass(abilGroupName, abilClsName);
        SKILLABILITY_FILL_ABILITY_CTRLSET(ability_gb, ctrlset, abilClass, groupClass);
    end

    SKILLABILITY_MAKE_GROUP_BY_ACTIVE_GROUP(abilitylist_gb, clsList, height);

    --cancel btn
    local cancel_btn = GET_CHILD_RECURSIVELY(skillability_job, "cancel_btn");
	cancel_btn:SetEventScript(ui.LBUTTONUP, "ON_CANCEL_SKILLABILITY");

    --confirm btn
    local confirm_btn = GET_CHILD_RECURSIVELY(skillability_job, "confirm_btn");
	confirm_btn:SetEventScript(ui.LBUTTONUP, "ON_COMMIT_SKILLABILITY");
    SKILLABILITY_UPDATE_CONFIRM_BTN(skillability_job)

    --point
    local abilitypoint_text = GET_CHILD_RECURSIVELY(skillability_job, "abilitypoint_text");
    local pointAmount = session.ability.GetAbilityPoint();
    abilitypoint_text:SetTextByKey("value", GetCommaedText(pointAmount));
end

function SKILLABILITY_UPDATE_CONFIRM_BTN(parent)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    local confirm_btn = GET_CHILD_RECURSIVELY(gb, "confirm_btn");
    if jobClsName == "Common" then
        confirm_btn:SetEnable(0);
        return;
    end

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);

    local isReqSkill = IS_CHANGED_SKILLABILITY_SKILL(jobClsName)
    local isReqAbil = IS_CHANGED_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)
    
    if isReqSkill or isReqAbil then
        confirm_btn:SetEnable(1);
    else
        confirm_btn:SetEnable(0);
    end
end

function SKILLABILITY_MAKE_GROUP_BY_ACTIVE_GROUP(abilitylist_gb, clsList, height)
    local frame = abilitylist_gb:GetTopParentFrame();
    local ONE_ACTIVE_GROUP_HEIGHT = tonumber(frame:GetUserConfig("ONE_ACTIVE_GROUP_HEIGHT"));
    local ACTIVE_GROUP_X = tonumber(frame:GetUserConfig("ACTIVE_GROUP_X"));
    local ACTIVE_GROUP_WIDTH = frame:GetUserConfig("ACTIVE_GROUP_WIDTH");
    local ACTIVE_GROUP_SKIN = frame:GetUserConfig("ACTIVE_GROUP_SKIN");
    local ACTIVE_GROUP_CENTER_IMAGE_X = tonumber(frame:GetUserConfig("ACTIVE_GROUP_CENTER_IMAGE_X"));
    local ACTIVE_GROUP_CENTER_ON_IMAGE = frame:GetUserConfig("ACTIVE_GROUP_CENTER_ON_IMAGE");
    local ACTIVE_GROUP_CENTER_OFF_IMAGE = frame:GetUserConfig("ACTIVE_GROUP_CENTER_OFF_IMAGE");
    local ACTIVE_GROUP_CENTER_IMAGE_SIZE = frame:GetUserConfig("ACTIVE_GROUP_CENTER_IMAGE_SIZE");

    local lastActiveGroup = 'None'
    local top = 0;
    local count = 0;
    local noneCount = 0;
    for i=1, #clsList + 1 do
        local abilClass = clsList[i];
        count = count + 1;
        if i > #clsList or abilClass.ActiveGroup ~= lastActiveGroup or lastActiveGroup == "None" then
            local surfix = lastActiveGroup;
            if surfix == "None" then
                noneCount = noneCount + 1;
                surfix = surfix .. "_" .. noneCount;
            end
            local centerImg = ACTIVE_GROUP_CENTER_OFF_IMAGE;
            local bottom = (i-1)*height
            local gbHeight = bottom - top;
            local picY = top+((gbHeight)/2) - ACTIVE_GROUP_CENTER_IMAGE_SIZE/2
            if gbHeight <= height then
                gbHeight = ONE_ACTIVE_GROUP_HEIGHT;
                top = top+((height)/2)-gbHeight/2
                picY = top + ACTIVE_GROUP_CENTER_IMAGE_SIZE/2;
            end
            if lastActiveGroup ~= 'None' then
                if count > 1 then
                    centerImg = ACTIVE_GROUP_CENTER_ON_IMAGE;
                end
                local activegroup_gb = abilitylist_gb:CreateControl('groupbox', 'active_group_'..surfix, ACTIVE_GROUP_X, top, ACTIVE_GROUP_WIDTH, gbHeight);
                AUTO_CAST(activegroup_gb);
                activegroup_gb:SetSkinName(ACTIVE_GROUP_SKIN);
            end
            local activegroup_pic = abilitylist_gb:CreateControl('picture', 'center_active_group_'..surfix, ACTIVE_GROUP_CENTER_IMAGE_X, picY, ACTIVE_GROUP_CENTER_IMAGE_SIZE, ACTIVE_GROUP_CENTER_IMAGE_SIZE);
            AUTO_CAST(activegroup_pic);
            activegroup_pic:SetImage(centerImg);
            activegroup_pic:SetEnableStretch(1);

            if i <= #clsList then
                lastActiveGroup = abilClass.ActiveGroup;
                top = (i-1)*height
                count = 0;
            end
        end
    end
end

function SKILLABILITY_FILL_ABILITY_CTRLSET(ability_gb, classCtrl, abilClass, groupClass)
    local AFTER_ARROW = classCtrl:GetUserConfig("AFTER_ARROW");

    local SKIN_LOCK = classCtrl:GetUserConfig("SKIN_LOCK");
    local SKIN_UNLOCK = classCtrl:GetUserConfig("SKIN_UNLOCK");
    local SKIN_LEVEL_ZERO = classCtrl:GetUserConfig("SKIN_LEVEL_ZERO");
    local SKIN_LEVEL_MAX = classCtrl:GetUserConfig("SKIN_LEVEL_MAX");

    local slot = GET_CHILD(classCtrl, "slot");
    local nameText = GET_CHILD(classCtrl, "nameText");
    local abilLevelText = GET_CHILD(classCtrl, "abilLevelText");
    local abilConditionText = GET_CHILD(classCtrl, "abilConditionText");
    local abilLevelMaxText = GET_CHILD(classCtrl, "abilLevelMaxText");
    local descGB = GET_CHILD_RECURSIVELY(classCtrl, "descGB");
    local descText = GET_CHILD_RECURSIVELY(classCtrl, "descText");
    local abilMasterPic = GET_CHILD(classCtrl, "abilMasterPic");
    local toggle = GET_CHILD(classCtrl, "toggle");
        
    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
    local abilLv = 0;
    local maxLevel = 0;
    local isMax = 0;
    if groupClass ~= nil then
        maxLevel = tonumber(groupClass.MaxLevel)
        isMax = IS_ABILITY_MAX(GetMyPCObject(), groupClass, abilClass);
    else
        maxLevel = 1;
        isMax = 1;
    end

    if isMax == 1 then
        abilLv = maxLevel;
    elseif abilIES ~= nil then
        abilLv = abilIES.Level;
    end
    
    if maxLevel < abilLv then
        abilLv = maxLevel;
    end
    
    local learnCount = GET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClass.ClassName)
    
	-- icon.
	local icon = CreateIcon(slot);	
    icon:SetImage(abilClass.Icon);
    icon:SetTooltipType('ability');
    icon:SetDropFinallyScp("DROP_FINALLY_ABILITY_ICON");
	icon:Set(abilClass.Icon, "Ability", abilClass.ClassID, 1);
    icon:SetTooltipOverlap(1);
    icon:SetTooltipStrArg(abilClass.Name);
    icon:SetTooltipNumArg(abilClass.ClassID);
    icon:SetTooltipIESID(GetIESGuid(abilIES));
    local isEnablePop = 0;
    if abilIES ~= nil and abilClass.AlwaysActive == "NO" then
        isEnablePop = 1;
    end
    slot:EnablePop(isEnablePop);
    
    -- toggle.
    local isActive = TryGetProp(abilIES, "ActiveState");
    if isActive == nil then
        isActive = abilClass.ActiveState;
    end
    classCtrl:SetUserValue("ClsName", abilClass.ClassName);
    SKILLABILITY_INIT_TOGGLE_ABILITY(classCtrl, toggle, abilClass, isActive)

	-- name.
	nameText:SetTextByKey("value", abilClass.Name);

    -- desc.
	descText:SetTextByKey("value", abilClass.Desc);
    
    -- level.
    if learnCount > 0 then
        local before = ScpArgMsg("level{value}", "value", abilLv);
        local after = ScpArgMsg("level{value}", "value", abilLv+learnCount);
        abilLevelText:SetTextByKey("before", before);
        abilLevelText:SetTextByKey("arrow", AFTER_ARROW);
        abilLevelText:SetTextByKey("after", after);
    elseif abilIES ~= nil then
        local before = ScpArgMsg("level{value}", "value", abilLv);
        abilLevelText:SetTextByKey("before", before);
        abilLevelText:SetTextByKey("arrow", "");
        abilLevelText:SetTextByKey("after", "");
    else
        abilLevelText:SetTextByKey("before", ClMsg("NotLearnedYet"));
        abilLevelText:SetTextByKey("arrow", "");
        abilLevelText:SetTextByKey("after", "");
    end
    if maxLevel ~= nil then
        abilLevelMaxText:SetTextByKey("value", "Lv."..maxLevel);
    end

    -- condition.
    local condition = SKILLABILITY_GET_ABILITY_CONDITION(abilIES, groupClass, isMax);
    abilConditionText:SetTextByKey("value", condition);
    abilConditionText:SetTextTooltip(condition);

    -- master.
    abilMasterPic:SetVisible(isMax);

    local abilPointGB = GET_CHILD(classCtrl, "abilPointGB");
    if isMax == 1 then
        abilPointGB:SetVisible(0);
    else
        abilPointGB:SetVisible(1);
    end

    -- skin
    local unlockScpRet = GET_ABILITY_CONDITION_UNLOCK(abilIES, groupClass);
    local isLock = (unlockScpRet ~= nil and unlockScpRet ~= 'UNLOCK');
    if abilLv + learnCount <= 0 then
        classCtrl:SetSkinName(SKIN_LEVEL_ZERO);
    elseif isLock then
        classCtrl:SetSkinName(SKIN_LOCK);
	elseif isMax ~= 1 then
        classCtrl:SetSkinName(SKIN_UNLOCK);
    else
        classCtrl:SetSkinName(SKIN_LEVEL_MAX);
    end

    -- price
    -- 아츠는 다음 단계에 필요한 어빌리티 포인트를 표기해준다. KS.001
    local abilPrice = GET_CHILD_RECURSIVELY(classCtrl, "abilPrice");
    local cost = 0;
    if learnCount > 0 then
        cost = GET_ABILITY_LEARN_COST(GetMyPCObject(), groupClass, abilClass, abilLv + learnCount);
    elseif TryGetProp(abilIES, "Hidden") == 1 then
        cost = GET_ABILITY_LEARN_COST(GetMyPCObject(), groupClass, abilClass, abilLv + 1);
    end
    abilPrice:SetTextByKey("value", cost);

    -- 아츠는 레벨 버튼을 활성화하지 않는다. KS.001
    local btnEnabled = 1;
    if isLock or TryGetProp(abilIES, "Hidden") == 1 then
        btnEnabled = 0;
    end

    local addBtn = GET_CHILD_RECURSIVELY(classCtrl, "abilAdd");
    addBtn:SetEventScript(ui.LBUTTONUP, "ON_ADD_ABILITY_COUNT");
    addBtn:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
    addBtn:SetEventScriptArgNumber(ui.LBUTTONUP, 1);
    addBtn:SetOverSound('button_over');
    addBtn:SetClickSound('button_click_big');

    addBtn:SetEventScript(ui.RBUTTONUP, "ON_ADD_ABILITY_COUNT");
    addBtn:SetEventScriptArgString(ui.RBUTTONUP, abilClass.ClassName);
    addBtn:SetEventScriptArgNumber(ui.RBUTTONUP, 10);
    addBtn:SetEnable(btnEnabled);

    local revBtn = GET_CHILD_RECURSIVELY(classCtrl, "abilRevert");
    revBtn:SetEventScript(ui.LBUTTONUP, "ON_REVERT_ABILITY_COUNT");
    revBtn:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
    revBtn:SetOverSound('button_over');
    revBtn:SetClickSound('button_click_big');
    revBtn:SetEnable(btnEnabled);
end

function ON_ADD_ABILITY_COUNT(parent, btn, abilClsName, count)
    parent = parent:GetParent();
    parent = parent:GetParent();
    AUTO_CAST(parent);
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");

    local abilClass = GetClass("Ability", abilClsName);
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local groupClass = GetClass(abilGroupName, abilClsName);
	local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClsName);

    local unlockScpRet = GET_ABILITY_CONDITION_UNLOCK(abilIES, groupClass);
	if unlockScpRet ~= nil and unlockScpRet ~= 'UNLOCK' then
		return;
    end
    
    --어빌 맥스 레벨보다 높게 못올린다.
    count = count + GET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClsName);
	local curLevel = 0;
	local destLevel = count;
	if abilIES ~= nil then
		curLevel = abilIES.Level;
		destLevel = count + curLevel;
	end
	if destLevel > groupClass.MaxLevel then
		count = groupClass.MaxLevel - curLevel;
    end
    SET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClsName, count);
    SKILLABILITY_FILL_ABILITY_CTRLSET(ability_gb, parent, abilClass, groupClass);    
    SKILLABILITY_UPDATE_CONFIRM_BTN(ability_gb)
end

function ON_REVERT_ABILITY_COUNT(parent, btn, abilClsName, argnum)
    parent = parent:GetParent();
    parent = parent:GetParent();
    AUTO_CAST(parent);
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");

    SET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClsName, "None");
    
    local abilClass = GetClass("Ability", abilClsName);
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local groupClass = GetClass(abilGroupName, abilClsName);
    SKILLABILITY_FILL_ABILITY_CTRLSET(ability_gb, parent, abilClass, groupClass);
    SKILLABILITY_UPDATE_CONFIRM_BTN(ability_gb)
end

function ON_CLOSE_SKILLABILITY(parent, btn, argstr, argnum)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    if gb == nil then
        return;
    end
    local selectedJobClsName = gb:GetUserValue("JobClsName");
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    local skillability_job = GET_CHILD_RECURSIVELY(gb, "skillability_job_"..selectedJobClsName);

    local changed = false;
    local joblist = SKILLABILITY_GET_JOB_ID_LIST();
    -- for all job (except Common)
    for i=1, #joblist do
        local job = joblist[i];
        local jobCls = GetClassByType("Job", job);
        local jobClsName = jobCls.ClassName;

        changed = CLEAR_SKILLABILITY_POINT(jobClsName) or changed;
    end

    if frame:IsVisible() == 1 then
        if changed then
            SKILLABILITY_ON_CHANGE_TAB(frame);
        end
        CLEAR_SKILLABILITY_LEARN_COUNT_BY_JOB(ability_gb, jobClsName);
        SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName)
    end
end

function ON_CANCEL_SKILLABILITY(parent, btn)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    local skillability_job = GET_CHILD_RECURSIVELY(gb, "skillability_job_"..jobClsName);
    
    local changed = CLEAR_SKILLABILITY_POINT(jobClsName)
    if changed then
        SKILLABILITY_ON_CHANGE_TAB(frame)
    else
        CLEAR_SKILLABILITY_LEARN_COUNT_BY_JOB(ability_gb, jobClsName);
        SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName)
        SKILLABILITY_UPDATE_CONFIRM_BTN(skillability_job)
    end
end

function ON_CLICK_SKILLABILITY_SKILL_CTRLSET_UP_BTN(parent, control, clsID, level)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

	local pc = GetMyPCObject();
    local remain = GET_REMAIN_SKILLTREE_POINT(jobClsName);
	if remain == 0 then
		return;
	end

	local cls = GetClassByType("SkillTree", clsID);
	local curpts = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
	local skl = session.GetSkillByName(cls.SkillName)
	if skl ~= nil then
		obj = GetIES(skl:GetObject());	
		if obj.LevelByDB ~= obj.Level then 
			level = obj.LevelByDB;
		end
	end

	local maxlv = GET_SKILLTREE_MAXLV(nil, nil, cls);
	if maxlv <= curpts + level then
		return;
	end

	session.SetUserConfig("SKLUP_" .. cls.SkillName, curpts + 1);    
    AUTO_CAST(parent);
    if remain - 1 <= 0 then
        local skillability_job = GET_CHILD_RECURSIVELY(gb, "skillability_job_"..jobClsName);
        local skill_gb = GET_CHILD_RECURSIVELY(gb, "skill_gb")
        SKILLABILITY_FILL_SKILL_GB(skillability_job, skill_gb, jobClsName)
        SKILLABILITY_UPDATE_CONFIRM_BTN(gb)
        return;
    end

    local info = GET_TREE_INFO_BY_CLSNAME(cls.ClassName)
    SKILLABILITY_FILL_SKILL_CTRLSET(parent, info, jobClsName)

    local skillinfo_gb = GET_CHILD_RECURSIVELY(gb, "skillinfo_gb");
    local sklTreeClsName = nil;
    if cls ~= nil then
        sklTreeClsName = cls.ClassName;
    end

    local skilltree_gb = GET_CHILD_RECURSIVELY(gb, "skilltree_gb");
    SKILLABILITY_SELECT_SKILL(skilltree_gb, parent);
    
    ON_UPDATE_SKILLABILITY_SKILL_POINT(gb, jobClsName);
    SKILLABILITY_UPDATE_CONFIRM_BTN(gb)
end

function ON_CLICK_SKILLABILITY_SKILL_CTRLSET(parent, control, skillName, level)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local skilltree_gb = GET_CHILD_RECURSIVELY(gb, "skilltree_gb");
    local ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..skillName);

    if ctrlset == nil then
        return;
    end
    SKILLABILITY_SELECT_SKILL(skilltree_gb, ctrlset);
end

function ON_COMMIT_SKILLABILITY(parent, btn)
    local frame = parent:GetTopParentFrame();
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local isReqSkill = COMMIT_SKILLABILITY_SKILL(jobClsName)

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    COMMIT_SKILLABILITY_ABILITY(ability_gb, abilGroupName, jobClsName)

    if isReqSkill then
        --imcSound.PlaySoundItem('statsup');
		--frame:ShowWindow(0);
    end
end

function ON_SKILLABILITY_BUY_ABILITY_POINT(frame, msg, argmsg, argnum)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local abilitypoint_text = GET_CHILD_RECURSIVELY(gb, "abilitypoint_text");
    local pointAmount = session.ability.GetAbilityPoint();
    abilitypoint_text:SetTextByKey("value", GetCommaedText(pointAmount));
end

function ON_SKILLABILITY_UPDATE_PROPERTY(frame, msg, argstr, argnum)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    if gb == nil then
        return;
    end

    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local skillability_job = GET_CHILD_RECURSIVELY(gb, "skillability_job_"..jobClsName);
    SKILLABILITY_FILL_JOB_GB(skillability_job, jobClsName)

    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName);
end

function ON_SKILLABILITY_LEARN_ABILITY(frame, msg, abilName)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local abilClass = GetClass("Ability", abilName);
    local groupClass = GetClass(abilGroupName, abilName);
    local abilitylist_gb = GET_CHILD_RECURSIVELY(gb, "abilitylist_gb");
    local ability_gb = GET_CHILD_RECURSIVELY(gb, "ability_gb");
    local skillability_job = GET_CHILD_RECURSIVELY(gb, "skillability_job_"..jobClsName);

    SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName)
    
    local abilitylist_gb = GET_CHILD_RECURSIVELY(gb, "abilitylist_gb");
    local abilCtrl = abilitylist_gb:GetControlSet("skillability_ability", "skillability_ability_"..abilName);
    SKILLABILITY_FILL_ABILITY_CTRLSET(ability_gb, abilCtrl, abilClass, groupClass);
end

function ON_SKILLABILITY_UPDATE_ABILITY_POINT(frame, msg, argStr, argNum)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local abilitypoint_text = GET_CHILD_RECURSIVELY(gb, "abilitypoint_text");
    local pointAmount = session.ability.GetAbilityPoint();
    abilitypoint_text:SetTextByKey("value", GetCommaedText(pointAmount));
end

function SKILLABILITY_TOGGLE_ABILITY(parent, ctrl)
    local abilName = parent:GetUserValue("ClsName");
    local abilClass = GetClass("Ability", abilName);
    if abilClass == nil then
        return;
    end

    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilName);
    local isActive = TryGetProp(abilIES, "ActiveState");
    if isActive == nil then
        isActive = abilClass.ActiveState;
    end

    SKILLABILITY_INIT_TOGGLE_ABILITY(parent, ctrl, abilClass, isActive)
    TOGGLE_ABILITY(abilName)
end

function TOGGLE_ABILITY(abilName)
    local topFrame = ui.GetFrame("skillability")

    local curTime = imcTime.GetAppTime();    
    local prevClickTime = tonumber( topFrame:GetUserValue("CLICK_ABIL_ACTIVE_TIME") );
    
    if prevClickTime == nil then
	    topFrame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", imcTime.GetAppTime());
    elseif prevClickTime + 0.5 > curTime then        
        return
    end
    
    -- 이특성에 해당 스킬을 시전중이면 on/off를 하지 못하게 한다.    
    if abilName == "Corsair7" and 1 == geClientSkill.MyActorHasCmd('HOOKEFFECT') then
        return;
    end
    
    local abilCls = GetClass("Ability", abilName)
    if abilCls.AlwaysActive ~= 'NO' then
        return;
    end

    topFrame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", curTime);
    pc.ReqExecuteTx("SCR_TX_PROPERTY_ACTIVE_TOGGLE", abilName);    
end

function SKILLABILITY_INIT_TOGGLE_ABILITY(parent, ctrl, abilClass, isActive)
    -- 항상 활성화 된 특성은 특성 활성화 버튼을 안보여준다.
	if abilClass.AlwaysActive == 'NO' then
		-- 특성 활성화 버튼

	    ctrl:EnableHitTest(0);

        local ret = true
        if abilClass.SkillCategory ~= 'None' then
            if CHECK_ABILITY_LOCK(GetMyPCObject(), abilClass) ~= 'UNLOCK' then
                ret = false;
            end
        end
        
        if ret == true then
            ctrl:EnableHitTest(1);
            ctrl:SetCheck(isActive);
        else  -- 특정 배움 조건을 만족시키지 못한다면 off 로 자동 설정해줘야 한다.
            ctrl:SetCheck(0);
        end    	
        ctrl:ShowWindow(1)
    else
        ctrl:ShowWindow(0);
	end
end

function ON_SKILLABILITY_TOGGLE_SKILL_ACTIVE(frame, msg, abilName, isActive)
    local abilCls = GetClass("Ability", abilName)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local abilitylist_gb = GET_CHILD_RECURSIVELY(gb, "abilitylist_gb");
    local linkabil_gb = GET_CHILD_RECURSIVELY(gb, "linkabil_gb");
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local abilCtrl = abilitylist_gb:GetControlSet("skillability_ability", "skillability_ability_"..abilName);
    if abilCtrl ~= nil then
        AUTO_CAST(abilCtrl);
        local toggle = GET_CHILD_RECURSIVELY(abilCtrl, "toggle");
        SKILLABILITY_INIT_TOGGLE_ABILITY(abilCtrl, toggle, abilCls, isActive)
    end

    local linkAbilCtrl = linkabil_gb:GetControlSet("skillability_linkabil", "skillability_linkabil_"..abilName);
    if linkAbilCtrl ~= nil then
        AUTO_CAST(linkAbilCtrl);
        local toggle = GET_CHILD_RECURSIVELY(linkAbilCtrl, "toggle");
        SKILLABILITY_INIT_TOGGLE_ABILITY(linkAbilCtrl, toggle, abilCls, isActive)
    end
end

function ABILITYSHOP_EXTRACTOR_BTN_CLICK(parent, ctrl)
    local mapClsName = session.GetMapName();
    local mapCls = GetClass('Map', mapClsName);
    if TryGetProp(mapCls, 'MapType', 'None') ~= 'City' then
        ui.SysMsg(ClMsg('AllowedInTown'));
        return;
    end

    ui.OpenFrame('ability_point_extractor');
end

function ABILITYSHOP_BUY_BTN_CLICK(parent, ctrl)
    local mapClsName = session.GetMapName();
    local mapCls = GetClass('Map', mapClsName);
    if TryGetProp(mapCls, 'MapType', 'None') ~= 'City' then
        ui.SysMsg(ClMsg('AllowedInTown'));
        return;
    end

    ui.OpenFrame('ability_point_buy');
end

function UI_TOGGLE_SKILLABILITY()
	if app.IsBarrackMode() == true then
		return;
	end

	ui.ToggleFrame('skillability')
end

function UI_TOGGLE_SKILLTREE()
    UI_TOGGLE_SKILLABILITY()
end

function ON_POPULAR_SKILL_INFO(frame)
    -- #63405 스킬 HOT 표시 UI 제거 일감으로 관련내용 삭제
end
    
function ON_UPDATE_COMMON_SKILL_LIST(frame, msg, argStr, argNum)
    local commonSkillCount = session.skill.GetCommonSkillCount();	
	if commonSkillCount < 1 then		
        local job_tab = GET_CHILD_RECURSIVELY(frame, "job_tab");
        if job_tab ~= nil then
            local tabIndex = job_tab:GetIndexByName("tab_0");
            job_tab:DeleteTab(tabIndex);
        end
    end
    
    SKILLABILITY_ON_FULL_UPDATE(frame);
end

function SKILLTREE_MAKE_COMMON_TYPE_SKILL_EMBLEM(frame)
	local grid = GET_CHILD_RECURSIVELY(frame, 'skill', 'ui::CGrid');
	local cid = frame:GetUserValue("TARGET_CID");
	local pcSession = session.GetSessionByCID(cid);
	local pcJobInfo = pcSession:GetPCJobInfo();
	local jobCount = pcJobInfo:GetJobCount();
	local childCount = grid:GetChildCount();
	if jobCount + 1 > childCount then
		local detailypos = (math.floor((jobCount + 1) /3) + 1) * 140
		local detail = GET_CHILD_RECURSIVELY(frame,'detailGBox','ui::CGroupBox')
		detail:SetOffset(detail:GetOriginalX(), grid:GetY() + detailypos)
	end

	local emblemCtrlSet = grid:CreateOrGetControlSet('classtreeIcon', 'classCtrl_CommonType', 0, 0);
	emblemCtrlSet:SetEventScript(ui.LBUTTONUP, "OPEN_COMMON_TYPE_SKILL");
	emblemCtrlSet:SetOverSound("button_over");
	emblemCtrlSet:SetClickSound("button_click_3");

	-- swap child order
    local childCount = grid:GetChildCount();
    local firstChild = grid:GetChildByIndex(0);
    if firstChild:GetName() ~= emblemCtrlSet:GetName() then
	    local lastChildIndex = grid:GetChildCount() - 1;
	    grid:SwapChildIndex(0, lastChildIndex);	
    end

	local classSlot = GET_CHILD(emblemCtrlSet, "slot", "ui::CSlot");
	classSlot:EnableHitTest(0);
	local selectedarrowPic = GET_CHILD(emblemCtrlSet, "selectedarrow", "ui::CPicture");
	selectedarrowPic:ShowWindow(0);

	local icon = CreateIcon(classSlot);
	local iconname = frame:GetUserConfig('CommonTypeIconImage');	
	icon:SetImage(iconname);

	local nameCtrl = GET_CHILD(emblemCtrlSet, "name", "ui::CRichText");
	nameCtrl:SetText("{@st41}"..ClMsg('Common'));

	local levelCtrl = GET_CHILD(emblemCtrlSet, "level", "ui::CRichText");
	levelCtrl:ShowWindow(0);
end


function SKILLABILITY_DEPLOY_JOB_SKILL_CONTROLSET(skilltree_gb, jobClsName, skillTreeClsName, x, y)
    local cls = GetClass("SkillTree", skillTreeClsName)
    local sklClsName = cls.SkillName;
    local ctrlset = skilltree_gb:CreateOrGetControlSet("skillability_skillset", "SKILL_"..sklClsName, x, y);
    AUTO_CAST(ctrlset);
    local info = GET_TREE_INFO_BY_CLSNAME(cls.ClassName);
    SKILLABILITY_FILL_SKILL_CTRLSET(ctrlset, info, jobClsName)
end

function SKILLABILITY_DEPLOY_COMMON_SKILL_CONTROLSET(skilltree_gb, jobClsName, sklClsName, x, y)
    local ctrlset = skilltree_gb:CreateOrGetControlSet("skillability_skillset", "SKILL_"..sklClsName, x, y);
    local info = GET_COMMON_SKILL_INFO_BY_CLSNAME(sklClsName);
    AUTO_CAST(ctrlset);
    SKILLABILITY_FILL_SKILL_CTRLSET(ctrlset, info, jobClsName);
end

function SKILLABILITY_DEPLOY_JOB_SKILL(skilltree_gb, jobClsName, unlockLvHash, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT, SKILL_LV_HEIGHT, SKILL_LV_MARGIN, SKILL_LV_DIST)
    local width = ui.GetControlSetAttribute("skillability_skillset", "width");
    local rowCount = 0;
    --deploy skill controlset
    local y = 0;

    if jobClsName == "Common" then
        skilltree_gb:RemoveAllChild()
    end
    
    --total loop count == skill count in job
    for lv, lvList in pairs(unlockLvHash) do 
        local levelRow = CALC_LIST_LINE_BREAK(lvList, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT);
        for i=1, #levelRow do 
            local levelCol = levelRow[i];
            y = rowCount * (SKILL_LV_HEIGHT) + SKILL_LV_MARGIN + (SKILL_LV_DIST)*(i-1);
            for j = 1, #levelCol do
                local x = CALC_CENTER_ALIGN_POSITION(j, #levelCol, width, 12, skilltree_gb:GetWidth())
                if jobClsName == "Common" then
                    SKILLABILITY_DEPLOY_COMMON_SKILL_CONTROLSET(skilltree_gb, jobClsName, levelCol[j], x, y)
                else
                    SKILLABILITY_DEPLOY_JOB_SKILL_CONTROLSET(skilltree_gb, jobClsName, levelCol[j], x, y)
                end
            end
            rowCount = rowCount + 1
        end
    end
end

function SKILLABILITY_DEPLOY_LABEL_LINE(skilltree_gb, unlockLvHash, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT, SKILL_LV_HEIGHT)
    --deploy skill level labelline
    local levelTable = {0, 15, 30, 45};
    local rowCount = 0;
    for i=2, #levelTable do 
        local lv = levelTable[i];
        local sklLv = levelTable[i-1]+1;
        if unlockLvHash[sklLv] ~= nil then
            local levelRow = CALC_LIST_LINE_BREAK(unlockLvHash[sklLv], SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT);
            rowCount = rowCount + #levelRow;
        else
            rowCount = rowCount + 1
        end
        local y = rowCount*SKILL_LV_HEIGHT;
	    local leveltext = skilltree_gb:CreateOrGetControl('richtext', 'lvlabel_' .. i, 10, y-10, 50, 25);
        local labelline = skilltree_gb:CreateOrGetControl('labelline', 'labelline_' .. i, 55, y, 465, 3);
        labelline:SetSkinName('labelline_def_5');
        leveltext:SetFontName('brown_16');
        leveltext:SetText('Lv.'..lv);
    end
end