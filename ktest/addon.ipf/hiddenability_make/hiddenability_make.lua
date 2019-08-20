
function HIDDENABILITY_MAKE_ON_INIT(addon, frame)
    addon:RegisterMsg('HIDDENABILITY_DECOMPOSE_MAKE', 'HIDDENABILITY_MAKE_SET_RESULT');
end

function HIDDENABILITY_MAKE_OPEN_NPC(npcClassName)
    local frame = ui.GetFrame("hiddenability_make")
    
    frame:SetUserValue("NPC_CLASSNAME", npcClassName);
    ui.OpenFrame("hiddenability_make");
end

function HIDDENABILITY_MAKE_OPEN(frame)
    HIDDENABILITY_MAKE_RESET_MATERIAL(frame);
    HIDDENABILITY_MAKE_RESET_CENTER_UI(frame);
    HIDDENABILITY_MAKE_RESET_RESULT(frame);
    HIDDENABILITY_MAKE_DROPLIST_INIT(frame);
    HIDDENABILITY_CONTROL_ENABLE(frame, 1);

    INVENTORY_SET_CUSTOM_RBTNDOWN("HIDDENABILITY_MAKE_ITEM_RBTNDOWN");
    
	ui.OpenFrame("inventory");	
end

function HIDDENABILITY_MAKE_CLOSE(frame)
    ui.CloseFrame("hiddenability_make")
    ui.CloseFrame("inventory");	
    
    frame:SetUserValue("NPC_CLASSNAME", "None");

    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
end

function HIDDENABILITY_MAKE_ITEM_RBTNDOWN(itemobj,slot)
    local icon = slot:GetIcon()
	local iconInfo = icon:GetInfo();
	local guid = iconInfo:GetIESID();
    local invitem = GET_ITEM_BY_GUID(guid);
    if invitem == nil then
        return;
    end

    local frame = ui.GetFrame("hiddenability_make")

    local argNum = -1
    if IS_HIDDENABILITY_MATERIAL_PIECE(itemobj) == true then
        argNum = 1
    elseif IS_HIDDENABILITY_MATERIAL_STONE(itemobj) == true then
        argNum = 2
    end
    if HIDDENABILITY_MAKE_MATERIAL_ENABLE(frame, argNum, invitem) == true then
        frame:SetUserValue("MATERIAL_GUID_"..argNum, guid);
        HIDDENABILITY_MAKE_SET_MATERIAL(frame, argNum, invitem);
    end
end

function HIDDENABILITY_MAKE_ITEM_DROP(frame, ctrl, argStr, argNum)
    if ui.CheckHoldedUI() == true then
		return;
	end

	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
    frame = frame:GetTopParentFrame();
    
    if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
        local invitem = session.GetInvItemByGuid(guid)
        if invitem == nil then
            return;
        end
    
        if HIDDENABILITY_MAKE_MATERIAL_ENABLE(frame, argNum, invitem) == false then
            return;
        end
	    frame:SetUserValue("MATERIAL_GUID_"..argNum, guid);
		HIDDENABILITY_MAKE_SET_MATERIAL(frame, argNum, invitem);
    end
    
end

function HIDDENABILITY_MAKE_ITEM_POP(frame, ctrl, argStr, argNum)
    local frame = ui.GetFrame("hiddenability_make");
    frame:SetUserValue("MATERIAL_GUID_"..argNum, "None");

    local matslot = GET_CHILD_RECURSIVELY(frame, "matslot_"..argNum);
    matslot:ClearIcon();

    local matslot_count = GET_CHILD_RECURSIVELY(frame, "matslot_"..argNum.."_count");
    matslot_count:SetTextByKey("cur", 0);
    matslot_count:SetTextByKey("need", 0);
    matslot_count:ShowWindow(0);    
end

function HIDDENABILITY_MAKE_MATERIAL_ENABLE(frame, argNum, invitem)
    local resultitemClassName = frame:GetUserValue("RESULT_ITEM_CLASSNAME");
    if resultitemClassName == "None" or resultitemClassName == nil then
        ui.SysMsg(ClMsg("Arts_Please_Select_HiddenabilityItem"));
        return false;
    end

    if  invitem.isLockState == true then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return false;
    end
    
    local itemobj = GetIES(invitem:GetObject());
    if argNum == 1 and IS_HIDDENABILITY_MATERIAL_PIECE(itemobj) == true then
        return true;
    elseif argNum == 2 and IS_HIDDENABILITY_MATERIAL_STONE(itemobj) == true then
        return true;
    else
        ui.SysMsg(ClMsg("NotEnoughTarget"));
        return false;
    end

    return false;
end

function HIDDENABILITY_MAKE_SET_MATERIAL(frame, argNum, invitem)
    local itemobj = GetIES(invitem:GetObject());

    local resultitemClassName = frame:GetUserValue("RESULT_ITEM_CLASSNAME");
    local needcnt = 0;
    local classnamevalue = "";
    if argNum == 1 then
        classnamevalue = "HiddenAbility_Piece";
        needcnt = HIDDENABILITY_MAKE_NEED_PIECE_COUNT(resultitemClassName);
    else
        classnamevalue = "Premium_item_transcendence_Stone";
        needcnt = HIDDENABILITY_MAKE_NEED_STONE_COUNT(resultitemClassName);
    end

    local curcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value = classnamevalue}
    }, false);
        
    local matslot_count = GET_CHILD_RECURSIVELY(frame, "matslot_"..argNum.."_count");
    matslot_count:SetTextByKey("cur", curcnt);
    matslot_count:SetTextByKey("need", needcnt);
	if curcnt < needcnt then
		local NOT_ENOUPH_STYLE = frame:GetUserConfig('NOT_ENOUPH_STYLE');
		matslot_count:SetTextByKey('style', NOT_ENOUPH_STYLE);
	else
		local ENOUPH_STYLE = frame:GetUserConfig('ENOUPH_STYLE');
		matslot_count:SetTextByKey('style', ENOUPH_STYLE);
	end
    matslot_count:ShowWindow(1);

    local matslot = GET_CHILD_RECURSIVELY(frame, "matslot_"..argNum); 
    HIDDENABILITY_MAKE_SET_SLOT(matslot, itemobj);
end

function HIDDENABILITY_MAKE_SET_SLOT(slot, itemcls)
    local icon = slot:GetIcon();
    if icon == nil then
		icon = CreateIcon(slot);
    end

    itemicon = TryGetProp(itemcls, "Icon", "None");

    if itemicon ~= "None" then
        icon:SetImage(itemicon);
        SET_ITEM_TOOLTIP_BY_TYPE(icon, itemcls.ClassID);
    end	
end

-- 확인 버튼 클릭
function HIDDENABILITY_MAKE_OK_CLLICK(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end
    
    HIDDENABILITY_MAKE_RESET_CENTER_UI(frame);

    local resultitemslot = GET_CHILD_RECURSIVELY(frame, "result_slot");
    local resultitemClassName = frame:GetUserValue("RESULT_ITEM_CLASSNAME");
    if resultitemClassName == "None" or resultitemClassName == nil then
        HIDDENABILITY_MAKE_RESET_MATERIAL(frame);
        HIDDENABILITY_MAKE_RESET_RESULT(frame);
        HIDDENABILITY_MAKE_DROPLIST_INIT(frame);
        return;
    end

    -- 재료 아이템 소지 수량 변경 - 신비한서 낱장
    local pieceguid = frame:GetUserValue("MATERIAL_GUID_1");
    local pieceneedcnt = HIDDENABILITY_MAKE_NEED_PIECE_COUNT(resultitemClassName);
    local piececurcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='HiddenAbility_Piece'}
    }, false);

    local pieceslot_count = GET_CHILD_RECURSIVELY(frame, "matslot_1_count");
    pieceslot_count:SetTextByKey("cur", piececurcnt);
    pieceslot_count:SetTextByKey("need", pieceneedcnt);
	if piececurcnt < pieceneedcnt then
		local NOT_ENOUPH_STYLE = frame:GetUserConfig('NOT_ENOUPH_STYLE');
		pieceslot_count:SetTextByKey('style', NOT_ENOUPH_STYLE);
	else
		local ENOUPH_STYLE = frame:GetUserConfig('ENOUPH_STYLE');
		pieceslot_count:SetTextByKey('style', ENOUPH_STYLE);
	end
    pieceslot_count:ShowWindow(1);

    -- 재료 아이템 소지 수량 변경 - 여신의 축복석
    local stoneguid = frame:GetUserValue("MATERIAL_GUID_2");
    local stoneneedcnt = HIDDENABILITY_MAKE_NEED_STONE_COUNT(resultitemClassName);
    local stonecurcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='Premium_item_transcendence_Stone'}
    }, false);
    local stoneslot_count = GET_CHILD_RECURSIVELY(frame, "matslot_2_count");
    stoneslot_count:SetTextByKey("cur", stonecurcnt);
    stoneslot_count:SetTextByKey("need", stoneneedcnt);
	if stonecurcnt < stoneneedcnt then
		local NOT_ENOUPH_STYLE = frame:GetUserConfig('NOT_ENOUPH_STYLE');
		stoneslot_count:SetTextByKey('style', NOT_ENOUPH_STYLE);
	else
		local ENOUPH_STYLE = frame:GetUserConfig('ENOUPH_STYLE');
		stoneslot_count:SetTextByKey('style', ENOUPH_STYLE);
	end
    stoneslot_count:ShowWindow(1);

    HIDDENABILITY_CONTROL_ENABLE(frame, 1);
end

-- 제작 버튼 클릭
function HIDDENABILITY_MAKE_RESULT_ITEM_CREATE(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end

    local frame = ui.GetFrame("hiddenability_make");
    
    local resultitemslot = GET_CHILD_RECURSIVELY(frame, "result_slot");
    local resultitemClassName = frame:GetUserValue("RESULT_ITEM_CLASSNAME");
    if resultitemClassName == "None" or resultitemClassName == "" then
        ui.SysMsg(ClMsg("Arts_Please_Select_HiddenabilityItem"));
        return;
    end

    local pieceguid = frame:GetUserValue("MATERIAL_GUID_1");
    local pieceneedcnt = HIDDENABILITY_MAKE_NEED_PIECE_COUNT(resultitemClassName);
    local piececurcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='HiddenAbility_Piece'}
    }, false);
    if piececurcnt == 0 or pieceguid == "None" then
        ui.SysMsg(ClMsg("Arts_Please_Register_MaterialItem"));
        return;
    end
    if piececurcnt < pieceneedcnt then
        ui.SysMsg(ClMsg('NotEnoughRecipe'));
        return;
    end  

    local stoneguid = frame:GetUserValue("MATERIAL_GUID_2");
    local stoneneedcnt = HIDDENABILITY_MAKE_NEED_STONE_COUNT(resultitemClassName);
    local stonecurcnt = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value ='Premium_item_transcendence_Stone'}
    }, false);
    if stonecurcnt == 0 or stoneguid == "None" then
        ui.SysMsg(ClMsg("Arts_NeedOnemoreStone"));
        return;
    end
    if stonecurcnt < stoneneedcnt then
        ui.SysMsg(ClMsg('NotEnoughRecipe'));
        return;
    end

    -- 신비한 서 제작 함수 호출    
    local nameList = NewStringList();
    nameList:Add(resultitemClassName)    
    session.ResetItemList();
    session.AddItemID(pieceguid, pieceneedcnt);
    session.AddItemID(stoneguid, stoneneedcnt);
    local resultlist = session.GetItemIDList();

    item.DialogTransaction('HIDDENABILITY_MAKE', resultlist, "", nameList)
    
	ui.SetHoldUI(true);
    ReserveScript("HIDDENABILITY_MAKE_BUTTON_UNFREEZE()", 1.5);
end

function HIDDENABILITY_MAKE_BUTTON_UNFREEZE()
   ui.SetHoldUI(false);
end

-- 제작 결과 
function HIDDENABILITY_MAKE_SET_RESULT(frame, msg)
    local frame = ui.GetFrame("hiddenability_make")
    imcSound.PlaySoundEvent(frame:GetUserConfig("MAKE_START_SOUND"));
    imcSound.PlaySoundEvent(frame:GetUserConfig("MAKE_RESULT_SOUND"));
    
    local Btn = GET_CHILD_RECURSIVELY(frame, "Btn");
    Btn:ShowWindow(0);
    
    local ok_Btn = GET_CHILD_RECURSIVELY(frame, "ok_Btn");
    ok_Btn:ShowWindow(1);

    local issuccess_gb = GET_CHILD_RECURSIVELY(frame, "issuccess_gb");
    local issuccess_pic = GET_CHILD_RECURSIVELY(frame, "issuccess_pic");
    issuccess_gb:ShowWindow(1);

    HIDDENABILITY_CONTROL_ENABLE(frame, 0);
end

function HIDDENABILITY_MAKE_DROPLIST_INIT(frame)
    local npcClassName = frame:GetUserValue("NPC_CLASSNAME")

    frame:SetUserValue("RESULT_ITEM_CLASSNAME", "None");
    local list = GET_CHILD_RECURSIVELY(frame, "result_droplist");
    list:ClearItems();
    list:AddItem("", "");
    if npcClassName == "swordmaster" then        
        local str = "HiddenAbility_SwordmanPackage"    
        for i = 1, 100 do
            local jobitemcls = GetClass("Item", str..tostring(i));
            if jobitemcls == nil then
                break
            end
            list:AddItem(jobitemcls.ClassName, jobitemcls.Name);    
        end        
    elseif npcClassName == "wizardmaster" then
        local str = "HiddenAbility_WizardPackage"    
        for i = 1, 100 do
            local jobitemcls = GetClass("Item", str..tostring(i));
            if jobitemcls == nil then
                break
            end
            list:AddItem(jobitemcls.ClassName, jobitemcls.Name);    
        end
    elseif npcClassName == "npc_ARC_master" then
        local str = "HiddenAbility_ArcherPackage"    
        for i = 1, 100 do
            local jobitemcls = GetClass("Item", str..tostring(i));
            if jobitemcls == nil then
                break
            end
            list:AddItem(jobitemcls.ClassName, jobitemcls.Name);    
        end
    elseif npcClassName == "npc_healer" then
        local str = "HiddenAbility_ClericPackage"    
        for i = 1, 100 do
            local jobitemcls = GetClass("Item", str..tostring(i));
            if jobitemcls == nil then
                break
            end
            list:AddItem(jobitemcls.ClassName, jobitemcls.Name);    
        end
    elseif npcClassName == "npc_SCT_master" then
        local str = "HiddenAbility_ScoutPackage"    
        for i = 1, 100 do
            local jobitemcls = GetClass("Item", str..tostring(i));
            if jobitemcls == nil then
                break
            end
            list:AddItem(jobitemcls.ClassName, jobitemcls.Name);    
        end
    end

    
end

function HIDDENABILITY_MAKE_DROPLIST_SELECT(frame, ctrl)
    --HIDDENABILITY_MAKE_RESET_MATERIAL(frame);
    HIDDENABILITY_MAKE_RESET_CENTER_UI(frame);
    
    local resultitemClassName = ctrl:GetSelItemKey();
    frame:SetUserValue("RESULT_ITEM_CLASSNAME", resultitemClassName);

    local cls = GetClass("Item", resultitemClassName);
    if cls == nil then
        HIDDENABILITY_MAKE_RESET_RESULT(frame);
        return;
    end

    local slot = GET_CHILD_RECURSIVELY(frame, "result_slot");
    HIDDENABILITY_MAKE_SET_SLOT(slot, cls);

    local result_text = GET_CHILD_RECURSIVELY(frame, "result_text");
    result_text:SetTextByKey("value", "");
    result_text:SetTextByKey("value", cls.Name);
    result_text:ShowWindow(1);

end

function HIDDENABILITY_MAKE_RESET_MATERIAL(frame)
    local matslot_1 = GET_CHILD_RECURSIVELY(frame, "matslot_1");
    matslot_1:ClearIcon();
    
    local matslot_1_count = GET_CHILD_RECURSIVELY(frame, "matslot_1_count");
    matslot_1_count:SetTextByKey("cur", 0);
    matslot_1_count:SetTextByKey("need", 0);
    matslot_1_count:ShowWindow(0);
    
    frame:SetUserValue("MATERIAL_GUID_1", "None");

    local matslot_2 = GET_CHILD_RECURSIVELY(frame, "matslot_2");
    matslot_2:ClearIcon();

    local matslot_2_count = GET_CHILD_RECURSIVELY(frame, "matslot_2_count");
    matslot_2_count:SetTextByKey("cur", 0);
    matslot_2_count:SetTextByKey("need", 0);
    matslot_2_count:ShowWindow(0);

    frame:SetUserValue("MATERIAL_GUID_2", "None");
end

function HIDDENABILITY_MAKE_RESET_CENTER_UI(frame)
    local issuccess_gb = GET_CHILD_RECURSIVELY(frame, "issuccess_gb");
    issuccess_gb:ShowWindow(0);

    local Btn = GET_CHILD_RECURSIVELY(frame, "Btn");
    Btn:ShowWindow(1);

    local ok_Btn = GET_CHILD_RECURSIVELY(frame, "ok_Btn");
    ok_Btn:ShowWindow(0);
end

function HIDDENABILITY_MAKE_RESET_RESULT(frame)
    local slot = GET_CHILD_RECURSIVELY(frame, "result_slot");
    slot:ClearIcon();

    local result_text = GET_CHILD_RECURSIVELY(frame, "result_text");
    result_text:ShowWindow(0);
end

function HIDDENABILITY_CONTROL_ENABLE(frame, isenable)
    local frame = ui.GetFrame("hiddenability_make")
    local matslot_1 = GET_CHILD_RECURSIVELY(frame, "matslot_1");
    matslot_1:EnableDrop(isenable);
    matslot_1:EnablePop(isenable);
	matslot_1:EnableDrag(isenable);

    local matslot_2 = GET_CHILD_RECURSIVELY(frame, "matslot_2");
    matslot_2:EnableDrop(isenable);
    matslot_2:EnablePop(isenable);
    matslot_2:EnableDrag(isenable);
        
    local result_droplist = GET_CHILD_RECURSIVELY(frame, "result_droplist");
    result_droplist:EnableHitTest(isenable);

end