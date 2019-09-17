function ANCIENT_MON_LIST_ON_INIT(addon, frame)
    addon:RegisterMsg('ANCIENT_MON_REGISTER', 'ON_ANCIENT_MON_REGISTER');
    addon:RegisterMsg('ANCIENT_MON_REMOVE', 'ON_ANCIENT_MON_REMOVE');
    addon:RegisterMsg('ANCIENT_MON_LIST_LOAD', 'ON_ANCIENT_MON_LIST_LOAD');
    addon:RegisterMsg('ANCIENT_MON_UPDATE_EXP', 'ON_ANCIENT_MON_UPDATE');
    addon:RegisterMsg('ANCIENT_MON_COMPOSE', 'ON_ANCIENT_MON_UPDATE');
    addon:RegisterMsg('ANCIENT_MON_UPDATE_SLOT', 'ON_ANCIENT_MON_UPDATE');
end


function TOGGLE_ANCIENT_MON_LIST()
    local rframe = ui.GetFrame("ancient_mon_list");
    if rframe == nil then
        ui.OpenFrame("ancient_mon_list")
	elseif rframe:IsVisible() == 1 then
		rframe:ShowWindow(0);
	else
        rframe:ShowWindow(1);
        ANCIENT_MON_LIST_OPEN(rframe)
	end
end

function ANCIENT_MON_LIST_TAB_CHANGE(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab)
    local index = tab:GetSelectItemIndex();
    if index == 0 then
        INIT_ANCIENT_MON_LIST(frame)
        local button = GET_CHILD_RECURSIVELY(frame,"ancient_mon_compose_btn")
        button:SetVisible(0)
    elseif index < 3 then
        INIT_ANCIENT_MON_COMPSE(frame,index)
        ON_ANCIENT_MON_COMPOSE_LIST_LOAD(frame)
    else
        local ancient_mon_slot_Gbox =  GET_CHILD_RECURSIVELY(frame,'ancient_mon_slot_Gbox')
        ancient_mon_slot_Gbox:RemoveAllChild()
    end
end

function ANCIENT_MON_OPEN()
    ui.ToggleFrame('ancient_mon_list')
    local frame = ui.GetFrame('ancient_mon_list')
    local ancient_mon_num = frame:GetChild('ancient_mon_num')
    ancient_mon_num:SetTextByKey("max",ANCIENT_MON_SLOT_MAX)
    ANCEINT_COMBO_SET(frame)
end

function ANCEINT_COMBO_SET(frame)
    local typeList = ANCIENT_GET_COMBO_MON_LIST_C()
    local buffList = ANCIENT_GET_COMBO(typeList)
    local gBox = GET_CHILD_RECURSIVELY(frame,'ancient_mon_comb_slots')
    gBox:RemoveAllChild()
    local index = 1
    for buffName, over in pairs(buffList) do
        local buffCls = GetClass("Buff",buffName)
        local slot = gBox:CreateControl("slot", "COMBO_"..index, 35, 35, ui.LEFT, ui.TOP, 40*(index-1), 10, 0, 0);
        AUTO_CAST(slot)
        slot:SetUserValue("OVER",over)
        slot:EnableDrag(0)
        local icon = CreateIcon(slot)
        icon:SetImage("icon_"..buffCls.Icon)
        icon:SetTooltipType('buff');
        icon:SetTooltipArg(session.GetMyHandle(), buffCls.ClassID,0);
        index = index + 1
    end
end

function ANCIENT_GET_COMBO_MON_LIST_C()
    local typeList = {};
    local monNameList = {};
    for i = 0,3 do
        local info = session.pet.GetAncientMonInfoBySlot(i) 
        if info ~= nil then
            local clsName = info:GetClassName()
            monNameList[clsName] = true
        end
    end
    for clsName,_ in pairs(monNameList) do
        if clsName ~= nil and clsName ~="None" then
            local cls = GetClass("Monster",clsName)
            local types = {cls.RaceType,cls.Attribute}
            for i = 1,#types do
                if typeList[types[i]] == nil then
                    typeList[types[i]] = 1
                else
                    typeList[types[i]] = typeList[types[i]] + 1
                end
            end
            monNameList[clsName] = true;
        end
    end
    return typeList
end

function ANCIENT_MON_LIST_OPEN(frame)
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab);
    if tab ~= nil then
        tab:SelectTab(0);
        ANCIENT_MON_LIST_TAB_CHANGE(frame)
    end 
end

function INIT_ANCIENT_MON_LIST(frame)
    local ancient_mon_slot_Gbox =  GET_CHILD_RECURSIVELY(frame,'ancient_mon_slot_Gbox')
    if ancient_mon_slot_Gbox == nil then
        return;
    end
    ancient_mon_slot_Gbox:RemoveAllChild()

    local width = 4
    for i = 0,3 do
        local ctrlSet = INIT_ANCIENT_MON_SLOT(ancient_mon_slot_Gbox,"SET_"..i,width)
        ctrlSet:SetUserValue("INDEX",i)
        width = width + ctrlSet:GetWidth() + 2
        local slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_slot")
        AUTO_CAST(slot)
        local icon = CreateIcon(slot);
        slot:EnableHitTest(1)
        ctrlSet:SetEventScript(ui.DROP, 'ANCIENT_MON_SWAP_ON_DROP');
        ctrlSet:SetEventScript(ui.RBUTTONDOWN, 'ANCIENT_MON_SWAP_RBTNDOWN');
        ctrlSet:SetEventScriptArgNumber(ui.RBUTTONDOWN, -1);
        if i == 0 then
            local gold_border = GET_CHILD_RECURSIVELY(ctrlSet,"gold_border")
            AUTO_CAST(gold_border)
            gold_border:SetImage('monster_card_g_frame')
            ctrlSet:SetTextTooltip(ClMsg("AncientSlot1Tooltip"))
        end
    end

    local ancient_mon_list_Gbox =  GET_CHILD_RECURSIVELY(frame,'ancient_mon_list_Gbox')
    if ancient_mon_list_Gbox == nil then
        return;
    end
    ancient_mon_list_Gbox:RemoveAllChild()
    ancient_mon_list_Gbox:SetEventScript(ui.DROP,"ANCIENT_MON_SWAP_ON_DROP")
    ancient_mon_list_Gbox:SetUserValue("INDEX",-1)
    local cnt = session.pet.GetAncientMonInfoCount()

    local height = 0
    for i = 0,cnt-1 do
        local info = session.pet.GetAncientMonInfoByIndex(i)
        local ctrlSet = ANCIENT_MON_LOAD(frame,info)
        if info.slot > 3 then
            ctrlSet:SetEventScript(ui.DROP,"ANCIENT_MON_SWAP_ON_DROP")
            ctrlSet:SetUserValue("INDEX",-1)
        end
    end

    local ancient_mon_num = frame:GetChild('ancient_mon_num')
    ancient_mon_num:SetTextByKey("count",cnt)
end

function INIT_ANCIENT_MON_COMPSE(frame, index)
    local x = INIT_ANCIENT_MON_COMPOSE_SLOT_UI(frame)
    if index == 1 then
        MAKE_ANCIENT_MON_COMPOSE_BUTTON(frame,x,ClMsg("Compose"),"ANCIENT_MON_SACRIFICE")
    elseif index==2 then
        MAKE_ANCIENT_MON_COMPOSE_BUTTON(frame,x,ClMsg("Evolve"),"ANCIENT_MON_RANKUP")
    end
end

function INIT_ANCIENT_MON_COMPOSE_SLOT_UI(frame)
    local ancient_mon_slot_Gbox =  GET_CHILD_RECURSIVELY(frame,'ancient_mon_slot_Gbox')
    if ancient_mon_slot_Gbox == nil then
        return;
    end
    ancient_mon_slot_Gbox:RemoveAllChild()

    local width = 4
    for i = 0,3 do
        local ctrlSet = INIT_ANCIENT_MON_SLOT(ancient_mon_slot_Gbox,"SACRIFICE_"..i,width)
        ctrlSet:SetUserValue("INDEX",i)
        ctrlSet:SetEventScript(ui.DROP,"ON_ANCIENT_MON_COMPOSE_DROP")
        width = width + ctrlSet:GetWidth() + 2
        ctrlSet:SetEventScript(ui.RBUTTONDOWN, 'ANCIENT_MON_SLOT_POP_COMPOSE')
        if i == 3 then
            local default_image = GET_CHILD_RECURSIVELY(ctrlSet,"default_image")
            AUTO_CAST(default_image)
            default_image:SetImage("m_question_mark")
            default_image:Resize(97,128)
            default_image:SetAlpha(60)
            ctrlSet:SetEventScript(ui.RBUTTONDOWN,"ANCIENT_MON_RELOAD")
        end
    end
    return width;
end

function MAKE_ANCIENT_MON_COMPOSE_BUTTON(frame,x,text,script)
    local button = GET_CHILD_RECURSIVELY(frame,'ancient_mon_compose_btn')
    button:SetText("{@st42}{s18}"..text)
    button:SetEventScript(ui.LBUTTONDOWN, script);
    button:SetVisible(1)
    local excuteTime = tonumber(frame:GetUserValue("EXECUTE_TIME"))
    if excuteTime ~= nil and imcTime.GetAppTime() - excuteTime < 0.5 then
        button:SetEnable(0);
    else
        button:SetEnable(1);
    end
end


function INIT_ANCIENT_MON_SLOT(gbox,name,width)
    local ctrlSet = gbox:CreateControlSet("ancient_mon_item_slot", name, width, 4);
    width = width + ctrlSet:GetWidth() + 2
    local ancient_mon_gbox = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_gbox")
    ancient_mon_gbox:SetVisible(0)
    return ctrlSet;
end

function SET_ANCIENT_MON_BASEINFO_SLOT(ctrlSet,info)
    local font = "{@st42b}{s14}"
    --slot image
    local slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_slot")
    AUTO_CAST(slot)
    local icon = CreateIcon(slot);
    local monCls = GetClass("Monster", info:GetClassName());
    local iconName = TryGetProp(monCls, "Icon");
    icon:SetImage(iconName)
    --star drawing
    local starText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_grade")
    local starStr=""
    for i = 1, info.starrank do
        starStr = starStr ..string.format("{img monster_card_starmark %d %d}", 21, 20)
    end
    
    starText:SetText(starStr)
    --set lv
    local exp = info:GetStrExp();
    local xpInfo = gePetXP.GetXPInfo(0, tonumber(exp))
    local level = xpInfo.level
    local lvText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_lv")
    lvText:SetText(font.."Lv. "..level.."{/}")
    --set lv and name
    local nameText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_name")
    local cls = GetClass("Monster",info:GetClassName())

    nameText:SetText(font..cls.Name.."{/}")

    --exp gauge
    local ancient_mon_gauge = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_gauge")
    AUTO_CAST(ancient_mon_gauge)
    local totalExp = xpInfo.totalExp - xpInfo.startExp;
    local curExp = exp - xpInfo.startExp;
    ancient_mon_gauge:SetPoint(curExp, totalExp);
    
    
    --type
    local racetypeDic = {
        Klaida="insect",
        Widling="wild",
        Velnias="devil",
        Forester="plant",
        Paramune="variation",
        None="melee"
    }

    local type1Text = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type1_text")
    type1Text:SetText(font..ScpArgMsg("MonInfo_RaceType_"..cls.RaceType).."{/}")
    local type1Pic = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type1_pic")
    local type1Icon = CreateIcon(type1Pic)
    type1Icon:SetImage("monster_"..racetypeDic[cls.RaceType])

    local type2Text = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type2_text")
    type2Text:SetText(font..ScpArgMsg("MonInfo_Attribute_"..cls.Attribute).."{/}")
    local type2Pic = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type2_pic")
    local type2Icon = CreateIcon(type2Pic)
    type2Icon:SetImage("attribute_"..cls.Attribute)


    ctrlSet:SetUserValue("ANCIENT_GUID",info:GetGuid())
    --tooltip
    ctrlSet:SetTooltipType("ancient_monster")
    ctrlSet:SetTooltipStrArg(info:GetGuid())
    icon:SetTooltipType("ancient_monster")
    icon:SetTooltipStrArg(info:GetGuid())
    
    local ancientCls = GetClass("Ancient",monCls.ClassName)
    local rarity = ancientCls.Rarity
    --hide
    local background = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_background")
    AUTO_CAST(background)
	if rarity == 1 then
		background:SetImage("normal_card")
	elseif rarity == 2 then
		background:SetImage("rare_card")
	elseif rarity == 3 then
		background:SetImage("unique_card")
	elseif rarity == 4 then
		background:SetImage("legend_card")
    end
    
    local groupbox = ctrlSet:GetChild("ancient_mon_gbox")
    groupbox:SetVisible(1)
    ctrlSet:SetDragFrame('ancient_frame_drag')
    ctrlSet:SetDragScp("INIT_ANCEINT_FRAME_DRAG")
end

function SET_ANCIENT_MON_BASEINFO_LIST(gbox,info,height)
    local ctrlSet = gbox:CreateControlSet("ancient_mon_item_list", "SET_" .. info.slot, 0, height);
    --set level
    local exp = info:GetStrExp();
    local xpInfo = gePetXP.GetXPInfo(0, tonumber(exp))
    local level = xpInfo.level
    local levelText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_level")
    levelText:SetText("{@st42b}{s16}Lv. "..level.."{/}")

    --set image
    local monCls = GetClass("Monster", info:GetClassName());
    local iconName = TryGetProp(monCls, "Icon");
    local slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_slot")
    local image = CreateIcon(slot)
    image:SetImage(iconName)

    --set name
    local nameText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_name")
    local name = monCls.Name
    local starStr = ""
    for i = 1, info.starrank do
        starStr = starStr ..string.format("{img monster_card_starmark %d %d}", 21, 20)
    end
    local ancientCls = GetClass("Ancient",monCls.ClassName)
    local rarity = ancientCls.Rarity
    AUTO_CAST(ctrlSet)
	if rarity == 1 then
		name = ctrlSet:GetUserConfig("NORMAL_GRADE_TEXT")..name..' '..starStr.."{/}"
	elseif rarity == 2 then
		name = ctrlSet:GetUserConfig("MAGIC_GRADE_TEXT")..name..' '..starStr.."{/}" 
	elseif rarity == 3 then
		name = ctrlSet:GetUserConfig("UNIQUE_GRADE_TEXT")..name..' '..starStr.."{/}"
	elseif rarity == 4 then
		name = ctrlSet:GetUserConfig("LEGEND_GRADE_TEXT")..name..' '..starStr.."{/}"
	end
    nameText:SetText(name)

    local racetypeDic = {
                        Klaida="insect",
                        Widling="wild",
                        Velnias="devil",
                        Forester="plant",
                        Paramune="variation",
                        None="melee"
                    }
    --set type
    local type1Slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type1_pic")
    local type1Icon = CreateIcon(type1Slot)
    type1Icon:SetImage("monster_"..racetypeDic[monCls.RaceType])

    local type2Slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_mon_type2_pic")
    local type2Icon = CreateIcon(type2Slot)
    type2Icon:SetImage("attribute_"..monCls.Attribute)    
    
    --tooltip
    ctrlSet:SetTooltipType("ancient_monster")
    ctrlSet:SetTooltipStrArg(info:GetGuid())

    ctrlSet:SetUserValue("ANCIENT_GUID",info:GetGuid())
    ctrlSet:SetDragFrame('ancient_frame_drag')
    ctrlSet:SetDragScp("INIT_ANCEINT_FRAME_DRAG")
    return ctrlSet
end

function ON_ANCIENT_MON_COMPOSE_DROP(parent, FromctrlSet, argStr, argNum)
    local frame = parent:GetTopParentFrame();
    local FromGuid = frame:GetUserValue("LIFTED_GUID")
    for i = 0,2 do
        local slotBox = GET_CHILD_RECURSIVELY(frame,"SACRIFICE_"..i)
        if slotBox:GetUserValue("ANCIENT_GUID") == FromGuid then
            return;
        end
    end
    ON_ANCIENT_MON_COMPOSE(frame, FromGuid, argStr, argNum)
    frame:SetUserValue("LIFTED_GUID","None")
end

function ON_ANCIENT_MON_COMPOSE_RBUTTONDOWN(parent, FromctrlSet, argStr, argNum)
    local FromGuid = FromctrlSet:GetUserValue("ANCIENT_GUID")
    local frame = parent:GetTopParentFrame();
    ON_ANCIENT_MON_COMPOSE(frame, FromGuid, argStr, argNum)
end

function ON_ANCIENT_MON_COMPOSE(frame, FromGuid, argStr, argNum)
    local info = session.pet.GetAncientMonInfoByGuid(FromGuid)
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab)
    local index = tab:GetSelectItemIndex();

    local resultBox = GET_CHILD_RECURSIVELY(frame,"SACRIFICE_3")
    if resultBox:GetUserValue("ANCIENT_GUID") ~= "None" then
        addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientCompseResultRemove"), 3);
        return;
    elseif index == 1 and ON_ANCIENT_MON_SACRIFICE_RBUTTONDOWN(frame,FromGuid) == false then
        addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientNotSameRarity"), 3);
        return;
    elseif index == 2 and ON_ANCIENT_MON_RANKUP_RBUTTONDOWN(frame,FromGuid) == false then
        return;
    end
    local slotBox = GET_CHILD_RECURSIVELY(frame,"ancient_mon_slot_Gbox")
    local cnt = slotBox:GetChildCount()
    for i = 0,cnt-1 do
        local ToctrlSet = slotBox:GetChildByIndex(i)
        local ToGuid = ToctrlSet:GetUserValue("ANCIENT_GUID")
        if ToctrlSet:GetUserValue("INDEX") ~= "None" and ToctrlSet:GetUserValue("INDEX") ~= "3" then
            if ToGuid == nil or ToGuid == "None" then
                SET_ANCIENT_MON_BASEINFO_SLOT(ToctrlSet,info)
                break;
            end
        end
    end
    ON_ANCIENT_MON_COMPOSE_LIST_LOAD(frame)
    slotBox:Invalidate();
end

function ANCIENT_MON_SLOT_POP_COMPOSE_BY_DROP(parent,ctrlSet)
    local frame = parent:GetTopParentFrame()
    local guid = frame:GetUserValue("LIFTED_GUID")
    for i = 0,2 do
        local slotCtrl = GET_CHILD_RECURSIVELY(frame,"SACRIFICE_"..i)
        if slotCtrl:GetUserValue("ANCIENT_GUID") == guid then
            ANCIENT_MON_SLOT_POP_COMPOSE(frame,slotCtrl)
            break;
        end
    end
    frame:SetUserValue("LIFTED_GUID","None")
end

function ANCIENT_MON_SLOT_POP_COMPOSE(parent, ctrlSet)
    ANCIENT_MON_SLOT_POP(parent, ctrlSet)
    ON_ANCIENT_MON_COMPOSE_LIST_LOAD(parent:GetTopParentFrame())
end

function ANCIENT_MON_SLOT_POP(parent, ctrlSet)
    local groupbox = ctrlSet:GetChild("ancient_mon_gbox")
    groupbox:SetVisible(0)
    local default_box = ctrlSet:GetChild("default_box")
    default_box:SetVisible(1)
    local guid = ctrlSet:GetUserValue("ANCIENT_GUID")
    ctrlSet:SetUserValue("ANCIENT_GUID","None")
    ctrlSet:SetTooltipType("None")
    ctrlSet:SetTooltipStrArg("None")
    ctrlSet:SetDragFrame('None')
    ctrlSet:SetDragScp("None")
    ctrlSet:Invalidate();

    local frame = parent:GetTopParentFrame()
    local listFrame = GET_CHILD_RECURSIVELY(frame, "ancient_mon_list_Gbox")
end

function ON_ANCIENT_MON_SACRIFICE_RBUTTONDOWN(frame, guid)
    local Frominfo = session.pet.GetAncientMonInfoByGuid(guid)
    local slotBox = GET_CHILD_RECURSIVELY(frame,"ancient_mon_slot_Gbox")
    local cnt = slotBox:GetChildCount()
    for i = 0,cnt-1 do
        local ToctrlSet = slotBox:GetChildByIndex(i)
        local ToGuid = ToctrlSet:GetUserValue("ANCIENT_GUID")
        if ToGuid ~= nil and ToGuid ~= "None" then   
            local Toinfo = session.pet.GetAncientMonInfoByGuid(ToGuid)
            if Toinfo.rarity ~= Frominfo.rarity then
                return false;
            else
                return true;
            end
        end
    end
    return true;
end

function ON_ANCIENT_MON_RANKUP_RBUTTONDOWN(frame,guid)
    local Frominfo = session.pet.GetAncientMonInfoByGuid(guid)
    local slotBox = GET_CHILD_RECURSIVELY(frame,"ancient_mon_slot_Gbox")
    local cnt = slotBox:GetChildCount()
    if Frominfo.starrank >= 3 then
        addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientUnableMonster"), 3);
        return false;
    end
    for i = 0,2 do
        local ToctrlSet = slotBox:GetChildByIndex(i)
        local ToGuid = ToctrlSet:GetUserValue("ANCIENT_GUID")
        if ToGuid ~= nil and ToGuid ~= "None" then   
            local Toinfo = session.pet.GetAncientMonInfoByGuid(ToGuid)
            if Toinfo:GetClassName() ~= Frominfo:GetClassName() then
                addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientNotSameMonster"), 3);
                return false;
            elseif Toinfo.starrank ~= Frominfo.starrank then
                addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientNotSameStarrank"), 3);
                return false;
            else
                return true;
            end
        end
    end
    return true;
end

function ANCIENT_MON_SACRIFICE(parent, control, argStr, argNum)
    local frame = parent:GetTopParentFrame()
    local guids = {}
    for i = 0,2 do
        local gbox = GET_CHILD_RECURSIVELY(frame,'SACRIFICE_'..i)
        local guid = gbox:GetUserValue("ANCIENT_GUID")
        if guid == "None" or guid == nil then
            return;
        end
        guids[i+1] = guid
    end
    if #guids ~= 3 then
        return
    end
    ReqSacrificeAncientmon(guids[1],guids[2],guids[3])
    control:SetEnable(0)
    frame:SetUserValue("EXECUTE_TIME",imcTime.GetAppTime())

    local info = session.pet.GetAncientMonInfoByGuid(guids[3])
    frame:SetUserValue("RARITY",info.rarity)
end

function ANCIENT_MON_RANKUP(parent, control, argStr, argNum)
    local frame = parent:GetTopParentFrame()
    local guids = {}
    for i = 0,2 do
        local gbox = GET_CHILD_RECURSIVELY(frame,'SACRIFICE_'..i)
        local guid = gbox:GetUserValue("ANCIENT_GUID")
        if guid == "None" or guid == nil then
            return;
        end
        guids[i+1] = guid
    end
    if #guids ~= 3 then
        return
    end
    ReqRankUpAncientmon(guids[1],guids[2],guids[3])
    control:SetEnable(0)
    frame:SetUserValue("EXECUTE_TIME",imcTime.GetAppTime())
end

function ANCIENT_MON_LIST_CLOSE(frame)
end


function ON_ANCIENT_MON_REGISTER(frame,msg, guid)
    local info = session.pet.GetAncientMonInfoByGuid(guid)
    local ctrlSet = ANCIENT_MON_LOAD(frame,info)
    if ctrlSet ~= nil then
        local slot = GET_CHILD_RECURSIVELY(ctrlSet,'ancient_mon_slot')
        slot:SetHeaderImage('new_inventory_icon');

        local ancient_mon_num = frame:GetChild('ancient_mon_num')
        ancient_mon_num:SetTextByKey("count",session.pet.GetAncientMonInfoCount())
        
        local button = GET_CHILD_RECURSIVELY(frame,'ancient_mon_compose_btn')
        button:SetEnable(1)

        ANCEINT_COMBO_SET(frame)
    end
end

function ANCIENT_MON_INFO_SHOW(parent,ctrl)
    local guid = ctrl:GetUserValue("ANCIENT_GUID")
    ANCIENT_MON_INFO_SET(guid)
end

function ON_ANCIENT_MON_REMOVE(frame,msg, guid)
    ANCIENT_MON_LIST_TAB_CHANGE(frame)
    local ancient_mon_num = frame:GetChild('ancient_mon_num')
    ancient_mon_num:SetTextByKey("count",session.pet.GetAncientMonInfoCount())
    local button = GET_CHILD_RECURSIVELY(frame,'ancient_mon_compose_btn')
    button:SetEnable(1)
end

function ANCIENT_MON_SWAP_ON_DROP(parent,toCtrlSet, argStr, argNum)
    local toIndex = toCtrlSet:GetUserValue("INDEX")
    local frame = parent:GetTopParentFrame()
    local guid = frame:GetUserValue("LIFTED_GUID")
    if guid == "None" or guid == nil then
        return;
    end
    REQUEST_SWAP_ANCIENT_MONSTER(toCtrlSet:GetTopParentFrame(),guid,toIndex)
    frame:SetUserValue("LIFTED_GUID","None")
end

function ANCIENT_MON_SWAP_RBTNDOWN(parent,ctrlSet,argStr,argNum)
    local guid = ctrlSet:GetUserValue("ANCIENT_GUID")
    REQUEST_SWAP_ANCIENT_MONSTER(parent:GetTopParentFrame(),guid,argNum)
end

function REQUEST_SWAP_ANCIENT_MONSTER(frame,guid,slot)
    local zoneName = session.GetMapName();
    if zoneName == 'd_solo_dungeon_2' then
        return;
    end
    if guid == "None" or guid == nil then
        return;
    end
    frame:SetUserValue("EXECUTE_TIME",imcTime.GetAppTime())
    local toInfo = session.pet.GetAncientMonInfoBySlot(slot)
    if toInfo ~= nil then
        if toInfo:GetGuid() == guid then
            return
        end
    end
    ReqSwapAncientmon(guid,slot)
end

function SORT_ANCIENT_MON()
	local context = ui.CreateContextMenu("CONTEXT_ANCIENT_SORT", "", 0, 0, 170, 100);
	local scpScp = "";

	local frame = ui.GetFrame("ancient_mon_list")
	if frame == nil then
		return
	end

	scpScp = string.format("REQ_ANCIENT_MON_SORT(%d)", session.pet.SORT_BY_RARITY);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByGrade"), scpScp);	
	scpScp = string.format("REQ_ANCIENT_MON_SORT(%d)", session.pet.SORT_BY_NAME);
    ui.AddContextMenuItem(context, ScpArgMsg("SortByName"), scpScp);	
    scpScp = string.format("REQ_ANCIENT_MON_SORT(%d)", session.pet.SORT_BY_STARRANK);
    ui.AddContextMenuItem(context, ScpArgMsg("SortByStarrank"), scpScp);	
    scpScp = string.format("REQ_ANCIENT_MON_SORT(%d)", session.pet.SORT_BY_LEVEL);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByLevel"), scpScp);	
	ui.OpenContextMenu(context);
end

function REQ_ANCIENT_MON_SORT(sortType)
    session.pet.SortAncientMonInfo(sortType)
    if sortType == SORT_BY_GRADE then
    elseif sortType == SORT_BY_NAME then
    end
end

function SCR_ANCIENT_MON_SELL(parent,ctrl)
    local guid = parent:GetUserValue("ANCIENT_GUID")
    local info = session.pet.GetAncientMonInfoByGuid(guid)
    
    local monClassName = info:GetClassName()
    local monCls = GetClass("Ancient",monClassName)
    local monName = '{#003399}{ol}'.. monCls.Name ..'{/}{/}'.. '{ol}[{/}'
    
    for i = 1,info.starrank do
        monName = monName.. '{#ff6d00}{ol}★{/}{/}'
    end
    monName = monName..'{ol}]{/}'

    local rarityCls = GetClassByNumProp("Ancient_Rarity","Rarity",info.rarity)
    local str = ScpArgMsg("AncientSellMsg","monName",monName,"price",rarityCls.Cost-1)
	local yesScp = string.format("ON_ANCIENT_MON_SELL(\"%s\")", guid);
	ui.MsgBox(str, yesScp, "None");
end

function ON_ANCIENT_MON_SELL(guid)
    SellAncientMon(guid)
    local frame = ui.GetFrame('ancient_mon_list')
    local button = GET_CHILD_RECURSIVELY(frame,'ancient_mon_compose_btn')
    button:SetEnable(0)
end

function ON_ANCIENT_MON_LIST_LOAD(frame,msg, count)
    local ancient_mon_list_Gbox = GET_CHILD_RECURSIVELY(frame,'ancient_mon_list_Gbox')
    ancient_mon_list_Gbox:RemoveAllChild()
    for i = 0,count-1 do
        local info = session.pet.GetAncientMonInfoByIndex(i)
        ANCIENT_MON_LOAD(frame,info)
    end
end

function ANCIENT_MON_LOAD(frame,info)
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab)
    local index = tab:GetSelectItemIndex();
    local ctrlSet;
    if info.slot < 4 then
        if index == 0 then
            ctrlSet = GET_CHILD_RECURSIVELY(frame,"SET_"..info.slot)
            if ctrlSet ~= nil then
                SET_ANCIENT_MON_BASEINFO_SLOT(ctrlSet,info)
            end
        end
    else
        local ancient_mon_list_Gbox =  GET_CHILD_RECURSIVELY(frame,'ancient_mon_list_Gbox')
        local height = (ancient_mon_list_Gbox:GetChildCount()-1) * 51
        ctrlSet = SET_ANCIENT_MON_BASEINFO_LIST(ancient_mon_list_Gbox,info,height)
        if index ~= 0 then
            ctrlSet:SetEventScript(ui.RBUTTONDOWN, 'ON_ANCIENT_MON_COMPOSE_RBUTTONDOWN');
        else
            ctrlSet:SetEventScript(ui.RBUTTONDOWN, 'ANCIENT_MON_SWAP_RBTNDOWN');
            ctrlSet:SetEventScriptArgNumber(ui.RBUTTONDOWN, -2);
        end
    end
    return ctrlSet;
end

function ON_ANCIENT_MON_UPDATE(frame,msg, guid,slot)
    if msg == "ANCIENT_MON_UPDATE_EXP" then
        local info = session.pet.GetAncientMonInfoByGuid(guid)
        ANCIENT_MON_LOAD(frame,info)
    elseif msg == "ANCIENT_MON_COMPOSE" then
        ANCIENT_MON_COMPOSE_COMPLETE(frame,guid)
    elseif msg == "ANCIENT_MON_UPDATE_SLOT" then
        INIT_ANCIENT_MON_LIST(frame)
    end
    local ancient_mon_num = frame:GetChild('ancient_mon_num')
    ancient_mon_num:SetTextByKey("count",session.pet.GetAncientMonInfoCount())
    local button = GET_CHILD_RECURSIVELY(frame,'ancient_mon_compose_btn')
    button:SetEnable(1)
    frame:SetUserValue("EXECUTE_TIME","None")
    ANCEINT_COMBO_SET(frame)
end

function ANCIENT_MON_COMPOSE_COMPLETE(frame,guid)
    frame:SetUserValue("EXECUTE_TIME","None")
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab)
    local index = tab:GetSelectItemIndex();
    if index == 0 then
        return;
    end
    local btn = GET_CHILD_RECURSIVELY(frame,"ancient_mon_compose_btn")
    btn:SetEnable(1)

    local resultBox = GET_CHILD_RECURSIVELY(frame,'SACRIFICE_3')
    local posX, posY = GET_SCREEN_XY(resultBox);
    posX = posX + tonumber(frame:GetUserConfig("COMPOSE_EFFECT_X"))
    posY = posY + tonumber(frame:GetUserConfig("COMPOSE_EFFECT_Y"))
    
    local rarity = tonumber(frame:GetUserValue("RARITY"))
    local info = session.pet.GetAncientMonInfoByGuid(guid)
    if rarity ~= nil and rarity ~= 0 and info.rarity > rarity then
        resultBox:PlayUIEffect(frame:GetUserConfig("COMPOSE_EFFECT_SPECIAL"), tonumber(frame:GetUserConfig("COMPOSE_EFFECT_SCALE")),"COMPSE")
    else
        resultBox:PlayUIEffect(frame:GetUserConfig("COMPOSE_EFFECT"), tonumber(frame:GetUserConfig("COMPOSE_EFFECT_SCALE")),"COMPSE")
    end
    resultBox:SetUserValue("ANCIENT_GUID","SOMETHING_EXIST")
    frame:SetUserValue("RARITY",0)
    RunScript('ANCIENT_MON_COMPOSE_END',guid,index)
end

function ANCIENT_MON_COMPOSE_END(guid,index)
    sleep(1500)
    local frame = ui.GetFrame('ancient_mon_list')
    local tab = frame:GetChild("tab")
    AUTO_CAST(tab)
    if index ~= tab:GetSelectItemIndex() then
        return;
    end
    local ctrlSet = GET_CHILD_RECURSIVELY(frame,"SACRIFICE_3")
    local info = session.pet.GetAncientMonInfoByGuid(guid)
    SET_ANCIENT_MON_BASEINFO_SLOT(ctrlSet,info)
    ON_ANCIENT_MON_COMPOSE_LIST_LOAD(frame)
    ctrlSet:Invalidate()
end

function ANCIENT_MON_RELOAD(parent,ctrlSet)
    ANCIENT_MON_LIST_TAB_CHANGE(parent)
end

function ON_ANCIENT_MON_COMPOSE_LIST_LOAD(frame)
    local ancient_mon_list_Gbox = GET_CHILD_RECURSIVELY(frame,'ancient_mon_list_Gbox')
    ancient_mon_list_Gbox:RemoveAllChild()
    ancient_mon_list_Gbox:SetEventScript(ui.DROP,"ANCIENT_MON_SLOT_POP_COMPOSE_BY_DROP")
    local slotBox = GET_CHILD_RECURSIVELY(frame,'ancient_mon_slot_Gbox')
    local guidList = {}
    local index = 1
    for i = 0,3 do
        local ctrl = slotBox:GetChild("SACRIFICE_"..i)
        local guid = ctrl:GetUserValue("ANCIENT_GUID")
        if guid ~= "None" then
            guidList[index] = guid
            index = index + 1
        end
    end

    local count = session.pet.GetAncientMonInfoCount()
    for i = 0,count-1 do
        local info = session.pet.GetAncientMonInfoByIndex(i)
        local isSelected = false;
        for i = 1,#guidList do
            if guidList[i] == info:GetGuid() then
                isSelected = true;
                break;
            end
        end
        if info.slot >= 4 and isSelected == false then
            local ctrlSet = ANCIENT_MON_LOAD(frame,info)
            ctrlSet:SetEventScript(ui.DROP,"ANCIENT_MON_SLOT_POP_COMPOSE_BY_DROP")
        end
    end
end