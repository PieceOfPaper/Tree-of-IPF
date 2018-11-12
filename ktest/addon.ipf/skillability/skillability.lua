
function SKILLABILITY_ON_INIT(addon, frame)
    addon:RegisterOpenOnlyMsg('SUCCESS_BUY_ABILITY_POINT', 'ON_SKILLABILITY_BUY_ABILITY_POINT');
    addon:RegisterOpenOnlyMsg('SUCCESS_LEARN_ABILITY', 'ON_SKILLABILITY_LEARN_ABILITY');
    addon:RegisterOpenOnlyMsg('UPDATE_ABILITY_POINT', 'ON_SKILLABILITY_UPDATE_ABILITY_POINT');
    addon:RegisterOpenOnlyMsg('RESET_ABILITY_ACTIVE', 'ON_SKILLABILITY_TOGGLE_SKILL_ACTIVE');

    --moved
    addon:RegisterOpenOnlyMsg('RESET_SKL_UP', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('JOB_CHANGE', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('UPDATE_SKILLMAP', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('SKILL_LIST_GET', 'SKILLABILITY_ON_FULL_UPDATE');
    addon:RegisterOpenOnlyMsg('SKILL_LIST_GET_RESET_SKILL', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('ABILITY_LIST_GET', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('RESET_ABILITY_UP', 'SKILLABILITY_ON_FULL_UPDATE');
	addon:RegisterOpenOnlyMsg('UPDATE_COMMON_SKILL_LIST', 'ON_UPDATE_COMMON_SKILL_LIST');
	addon:RegisterOpenOnlyMsg('POPULAR_SKILL_INFO', 'ON_POPULAR_SKILL_INFO');
end

function SKILLABILITY_ON_FULL_UPDATE(frame)
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
end

function SKILLABILITY_MAKE_JOB_TAB(frame)
    if frame == nil then
        DumpCallStack()
    end
    local job_tab = GET_CHILD(frame, "job_tab");

    local job_tab_width = frame:GetUserConfig("JOB_TAB_WIDTH");
    local job_tab_height = frame:GetUserConfig("JOB_TAB_HEIGHT");
    local job_tab_x = frame:GetUserConfig("JOB_TAB_X");
    local job_tab_y = frame:GetUserConfig("JOB_TAB_Y");
    local tab_width = frame:GetUserConfig("TAB_WIDTH");

    local addTabInfoList = SKILLABILITY_GET_JOB_TAB_INFO_LIST();
    local gblist = UI_LIB_TAB_ADD_TAB_LIST(frame, job_tab, addTabInfoList, job_tab_width, job_tab_height, ui.CENTER_HORZ, ui.TOP, job_tab_x, job_tab_y, "job_tab_box", "true", tab_width);

    for i=1, #gblist do
        local gb = gblist[i];
        gb:SetTabChangeScp("SKILLABILITY_ON_CHANGE_TAB");
    end
    SKILLABILITY_ON_CHANGE_TAB(frame);
	frame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", imcTime.GetAppTime());
end

function SKILLABILITY_ON_OPEN(frame)
    SKILLABILITY_MAKE_JOB_TAB(frame);
    session.skill.ReqCommonSkillList();
end

function SKILLABILITY_ON_CHANGE_TAB(frame)
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local jobClsName = gb:GetUserValue("JobClsName");
    gb:RemoveChild("skillability_job_"..jobClsName);
    
    CLEAR_SKILLABILITY_POINT(jobClsName)
    
    local skillability_job = gb:CreateControlSet("skillability_job", "skillability_job_"..jobClsName, 0, 0);
    SKILLABILITY_FILL_JOB_GB(skillability_job, jobClsName)
end

function SKILLABILITY_FILL_JOB_GB(skillability_job, jobClsName)

    local skill_gb = GET_CHILD(skillability_job, "skill_gb");
    local ability_gb = GET_CHILD(skillability_job, "ability_gb");
    local skilltree_gb = GET_CHILD_RECURSIVELY(skill_gb, "skilltree_gb");
    SKILLABILITY_FILL_SKILL_GB(skillability_job, skill_gb, jobClsName);
    SKILLABILITY_FILL_ABILITY_GB(skillability_job, ability_gb, jobClsName);

    if jobClsName ~= "Common" then
        local mySession = session.GetMySession();
        local treelist = GET_TREE_INFO_VEC(jobClsName)
        local unlockLvHash = GET_TREE_UNLOCK_LEVEL_LIST(treelist);
        local width = ui.GetControlSetAttribute("skillability_skillset", "width");
        local skillTreeClsName = unlockLvHash[1][1];
        local cls = GetClass("SkillTree", skillTreeClsName)
        local ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..cls.SkillName);
        SKILLABILITY_SELECT_SKILL(skilltree_gb, ctrlset)--
    end
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
	local lv = info["lv"];
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
    level_txt:SetTextByKey("value", info["lv"]);

    local upbtn = GET_CHILD(ctrlset, "upbtn");
    if cls ~= nil then
        upbtn:SetEventScript(ui.LBUTTONUP, "ON_CLICK_SKILLABILITY_SKILL_CTRLSET_UP_BTN");
        upbtn:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassID);
        upbtn:SetEventScriptArgNumber(ui.LBUTTONUP, info["lv"]);
        upbtn:SetClickSound("button_click_skill_up");
    end
    
    local lockbtn = GET_CHILD(ctrlset, 'lockbtn');
	lockbtn:ShowWindow(0);
    local totallv = lv + statlv;
    if statlv > 0 then
        level_txt:SetTextByKey("value", "{#FF0000}"..totallv);
    end

    local result, reason = false, "";
    if jobClsName ~= "Common" then
	    result, reason = CHECK_ENABLE_GET_SKILL_C(sklClsName, totallv, maxlv);
    end
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
    local jobEngName = jobCls.EngName
    
    local skillinfo_gb = GET_CHILD_RECURSIVELY(tab_gb, "skillinfo_gb");
    skillinfo_gb:RemoveChild("skillability_skillinfo")
    local infoctrl = skillinfo_gb:CreateOrGetControlSet("skillability_skillinfo", "skillability_skillinfo", 0, 0);
    AUTO_CAST(infoctrl)

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
    icon:SetTooltipOverlap(1);
    icon:SetTooltipStrArg(abilClass.Name);
    icon:SetTooltipNumArg(abilClass.ClassID);
    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
    icon:SetTooltipIESID(GetIESGuid(abilIES));
    
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

    local lv = info["lv"]
    local sp = 0;
    local overHeat = 0;
    local coolDown = 0;
    
    if obj ~= nil then
        sp = GET_SPENDSP_BY_LEVEL(obj);
        overHeat = obj.SklUseOverHeat;
        coolDown = obj.CoolDown/1000;
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

	local dummyObj = CreateGCIES("Skill", cls.SkillName);
    dummyObj.Level = info["lv"]+info["statlv"];
    dummyObj.LevelByDB = info["DBLv"]+info["statlv"];

    local afterLv = "";    
    if info["statlv"] > 0 then
        afterLv = dummyObj.Level;
        afterLv = ScpArgMsg("level{value}", "value", afterLv);
    end
    level_txt:SetTextByKey("after", afterLv)

    local weapon_gb = GET_CHILD(infoctrl, "weapon_gb");
    local skillCls = GetClass("Skill", cls.SkillName);
    local iconCount, companionIconCount = MAKE_STANCE_ICON(weapon_gb, skillCls.ReqStance, skillCls.EnableCompanion, 0, 0);
    local weaponWidth = iconCount*20+companionIconCount*20;
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
    local abilitylist_gb = GET_CHILD(ability_gb, "abilitylist_gb");

    local jobCls = GetClass("Job", jobClsName);
    local jobEngName = jobCls.EngName;
    local abilGroupName = SKILLABILITY_GET_ABILITY_GROUP_NAME(jobEngName);
    local list = SKILLABILITY_GET_ABILITY_NAME_LIST(jobEngName)--Ability_Peltasta

    local clsList = {};

    for i=1, #list do
        local abilClass = GetClass("Ability", list[i]);
        clsList[#clsList+1] = abilClass;
    end

    -- sort them. 
    table.sort(clsList, function(lhs, rhs)
        return lhs.ActiveGroup < rhs.ActiveGroup;
    end);

    CLEAR_SKILLABILITY_LEARN_COUNT_BY_JOB(ability_gb, jobClsName);

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
    local pointAmount = GET_SKILLABILITY_ABILITY_POINT_REMAIN_AMOUNT();
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
        
	local maxLevel = tonumber(groupClass.MaxLevel)
    local abilIES = GetAbilityIESObject(GetMyPCObject(), abilClass.ClassName);
    local isMax = IS_ABILITY_MAX(GetMyPCObject(), groupClass, abilClass);
    local abilLv = 0;
    if isMax == 1 then
        abilLv = groupClass.MaxLevel;
    elseif abilIES ~= nil then
        abilLv = abilIES.Level;
    end
    if maxLevel < abilLv then
        abilLv = groupClass.MaxLevel;
    end
    
    local notMax = 1;
    if isMax == 1 then
        notMax = 0;
    end
    local learnCount = GET_SKILLABILITY_LEARN_COUNT(ability_gb, abilClass.ClassName)
    
	-- icon.
	local icon = CreateIcon(slot);	
    icon:SetImage(abilClass.Icon);
    icon:SetTooltipType('ability');
    icon:SetTooltipOverlap(1);
    icon:SetTooltipStrArg(abilClass.Name);
    icon:SetTooltipNumArg(abilClass.ClassID);
    icon:SetTooltipIESID(GetIESGuid(abilIES));
    
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
    abilLevelMaxText:SetTextByKey("value", "Lv."..groupClass.MaxLevel);

    -- condition.
    local condition = SKILLABILITY_GET_ABILITY_CONDITION(abilIES, groupClass, isMax);
    abilConditionText:SetTextByKey("value", condition);
    abilConditionText:SetTextTooltip(condition);

    -- master.
    abilMasterPic:SetVisible(isMax);
    local abilPointGB = GET_CHILD(classCtrl, "abilPointGB");
    abilPointGB:SetVisible(notMax);

    -- skin
    local unlockScpRet = GET_ABILITY_CONDITION_UNLOCK(abilIES, groupClass);
    local isLock = (unlockScpRet ~= nil and unlockScpRet ~= 'UNLOCK');
    if isLock then
		classCtrl:SetSkinName(SKIN_LOCK);
    elseif abilLv + learnCount <= 0 then
		classCtrl:SetSkinName(SKIN_LEVEL_ZERO);
	elseif isMax == 1 then
        classCtrl:SetSkinName(SKIN_LEVEL_MAX);
    else
        classCtrl:SetSkinName(SKIN_UNLOCK);
    end

    -- price
    local abilPrice = GET_CHILD_RECURSIVELY(classCtrl, "abilPrice");
    local cost = 0;
    if learnCount > 0 then
        cost = GET_ABILITY_LEARN_COST(GetMyPCObject(), groupClass, abilClass, abilLv + learnCount);
    end
    abilPrice:SetTextByKey("value", cost);

    local btnEnabled = 1;
    if isLock then
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
    local info = GET_TREE_INFO_BY_CLSNAME(cls.ClassName)
    AUTO_CAST(parent);
    SKILLABILITY_FILL_SKILL_CTRLSET(parent, info, jobClsName)

    local skillinfo_gb = GET_CHILD_RECURSIVELY(gb, "skillinfo_gb");
    local infoctrl = skillinfo_gb:GetControlSet("skillability_skillinfo", "skillability_skillinfo");
    AUTO_CAST(infoctrl)
    
    local sklTreeClsName = nil;
    if cls ~= nil then
        sklTreeClsName = cls.ClassName;
    end
    local info = GET_SKILL_INFO_BY_JOB_CLSNAME(jobClsName, sklTreeClsName, sklClsName);
    SKILLABILITY_FILL_SKILL_INFO(infoctrl, info)
    
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
    local pointAmount = GET_SKILLABILITY_ABILITY_POINT_REMAIN_AMOUNT();
    abilitypoint_text:SetTextByKey("value", GetCommaedText(pointAmount));

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
    local pointAmount = GET_SKILLABILITY_ABILITY_POINT_REMAIN_AMOUNT();
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

    local curTime = imcTime.GetAppTime();    
    local topFrame = parent:GetTopParentFrame();
    local prevClickTime = tonumber( topFrame:GetUserValue("CLICK_ABIL_ACTIVE_TIME") );
    
    if prevClickTime == nil then
        return
    end

    if prevClickTime + 0.5 > curTime then        
        return
    end
    
    -- 이특성에 해당 스킬을 시전중이면 on/off를 하지 못하게 한다.    
    if abilName == "Corsair7" and 1 == geClientSkill.MyActorHasCmd('HOOKEFFECT') then
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
    ui.OpenFrame('ability_point_extractor');
end

function ABILITYSHOP_BUY_BTN_CLICK(parent, ctrl)
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
    local gb = SKILLABILITY_GET_SELECTED_TAB_GROUPBOX(frame);
    local skilltree_gb = GET_CHILD_RECURSIVELY(gb, "skilltree_gb");
    local jobClsName = gb:GetUserValue("JobClsName");
    if jobClsName == "Common" then
        return;
    end

    local treelist = GET_TREE_INFO_VEC(jobClsName)
    local topSkillName1 = ui.GetRedisHotSkillByRanking(jobClsName, 1);
    local topSkillName2 = ui.GetRedisHotSkillByRanking(jobClsName, 2);
	for i = 1, #treelist do
        local info = treelist[i];
        local cls = info["class"];
        local ctrlset = skilltree_gb:GetControlSet("skillability_skillset", "SKILL_"..cls.SkillName);
        local hotimg = GET_CHILD(ctrlset, "hitimg");
        if topSkillName1 == cls.SkillName then
            hotimg:SetImage("Hit_indi_icon");
        elseif topSkillName2 == cls.SkillName then
            hotimg:SetImage("Hit_indi_icon");
        else
            hotimg:SetImage("None_Mark");
        end
	end
end
    
function ON_UPDATE_COMMON_SKILL_LIST(frame, msg, argStr, argNum)
	local commonSkillCount = session.skill.GetCommonSkillCount();	
	if commonSkillCount < 1 then		
		return;
	end
	
    SKILLABILITY_MAKE_JOB_TAB(frame);
end

function SKILLTREE_MAKE_COMMON_TYPE_SKILL_EMBLEM(frame)
	local grid = GET_CHILD_RECURSIVELY(frame, 'skill', 'ui::CGrid');
	local cid = frame:GetUserValue("TARGET_CID");
	local pcSession = session.GetSessionByCID(cid);
	local pcJobInfo = pcSession.pcJobInfo;
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
    SKILLABILITY_FILL_SKILL_CTRLSET(ctrlset, info, jobClsName)
end

function SKILLABILITY_DEPLOY_JOB_SKILL(skilltree_gb, jobClsName, unlockLvHash, SKILL_COL_COUNT, SKILL_LINE_BREAK_COUNT, SKILL_LV_HEIGHT, SKILL_LV_MARGIN, SKILL_LV_DIST)
    local width = ui.GetControlSetAttribute("skillability_skillset", "width");
    local rowCount = 0;
    --deploy skill controlset
    local y = 0;
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
