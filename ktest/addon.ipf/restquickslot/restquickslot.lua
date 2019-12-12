MAX_RESTSLOT_CNT = 20;

function RESTQUICKSLOT_ON_INIT(addon, frame)
	RESTQUICKSLOT_UPDATE_HOTKEYNAME(frame);

	addon:RegisterMsg('RESTQUICKSLOT_OPEN', 'ON_RESTQUICKSLOT_OPEN');
	addon:RegisterMsg('RESTQUICKSLOT_CLOSE', 'ON_RESTQUICKSLOT_CLOSE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'RESTQUICKSLOT_ON_ITEM_CHANGE');
end

function RESTQUICKSLOT_UPDATE_HOTKEYNAME(frame)
	for i = 0, MAX_RESTSLOT_CNT-1 do
		local slot = frame:GetChild("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString = 'QuickSlotExecute'..(i+1);
		local text = hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', ui.LEFT, ui.TOP, 2, 1);
	end
end;

function RESTQUICKSLOT_ON_ITEM_CHANGE(frame)
	-- �켱 ���� ������Ʈ �ϴ°ŷ�
	if frame:IsVisible() == 1 then
		ON_RESTQUICKSLOT_OPEN(frame);
	end
end

function ON_RESTQUICKSLOT_OPEN(frame, msg, argStr, argNum)

	local slotIndex = 1;
	local list = GetClassList('restquickslotinfo')
	for i = 0, MAX_RESTSLOT_CNT-1 do
		local cls = GetClassByIndexFromList(list, i);
		if cls ~= nil then
			if cls.VisibleScript == "None" or _G[cls.VisibleScript]() == 1 then
				if scp ~= "None" then
					local slot = GET_CHILD(frame, "slot"..slotIndex, "ui::CSlot");
					if slot ~= nil then
						slot:ReleaseBlink();
						slot:ClearIcon();
						SET_REST_QUICK_SLOT(slot, cls);
						slotIndex = slotIndex + 1;
					end
				end
			end
		end
	end
	
	frame:ShowWindow(1);

	if IsJoyStickMode() == 0 then

		local quickFrame = ui.GetFrame('quickslotnexpbar')
		quickFrame:ShowWindow(0);
	elseif IsJoyStickMode(pc) == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		joystickQuickFrame:ShowWindow(0);
	end

	OPEN_REST_QUICKSLOT(frame);
end

function OPEN_REST_QUICKSLOT(frame)
end

function QSLOT_ENABLE_ENCHANT_CRAFT()
	local abil = session.GetAbilityByName("Enchanter_Bomb")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_ARROW_CRAFT()
	local abil = session.GetAbilityByName("Fletching")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_DISPELLER_CRAFT()
	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_OMAMORI_CRAFT()
	local abil = session.GetAbilityByName("Omamori")
	if abil ~= nil then
		return 1;
	end

	return 0;
end

function QSLOT_ENABLE_FLUTING_KEYBOARD()
	if FLUTING_ENABLED ~= 1 then
		return 0;
	end
	if IS_EXIST_JOB_IN_HISTORY(3012) == true then
		return 1;
	end
	return 0;
end

function QSLOT_VISIBLE_ARROW_CRAFT()
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType
	if pcCtrlType == "Archer" then
		return 1;
	end

	return 0;
end

function ON_RESTQUICKSLOT_CLOSE(frame, msg, argStr, argNum)

	local flutFrame = ui.GetFrame("fluting_keyboard");
	if flutFrame:IsVisible() == 1 then
		flutFrame:ShowWindow(0);
	end
	frame:ShowWindow(0);

	if IsJoyStickMode() == 0 then
		local quickFrame = ui.GetFrame('quickslotnexpbar')
		quickFrame:ShowWindow(1);
	elseif IsJoyStickMode() == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		joystickQuickFrame:ShowWindow(1);
	end
	ui.CloseFrame('reinforce_by_mix')

end

function SET_REST_QUICK_SLOT(slot, cls)

	slot:SetUserValue("REST_TYPE", cls.ClassID);
	
	local icon 	= CreateIcon(slot);
	local desctext = cls.Desc;
	
	if desctext ~= 'None' then
		 icon:SetTextTooltip('{@st59}'..desctext);
	 end
	
	if cls.Icon ~= 'None' then
		icon:SetImage(cls.Icon);
	end
	slot:EnableDrag(0);
	slot:Invalidate();

	local targetItem = cls.TargetItem;
	if targetItem ~= "None" then
		local invItem = session.GetInvItemByName(targetItem);
		local itemCount = 0;
		if invItem ~= nil then
			itemCount = invItem.count;
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end

		slot:GetIcon():SetText('{s18}{ol}{b}'.. itemCount, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
	end

	local enableScp = cls.EnableScript;
	if enableScp ~= "None" then
		if _G[enableScp]() == 0 then
			slot:SetEventScript(ui.LBUTTONUP, "None");
			icon:SetTextTooltip('{@st59}'..cls.DisableTooltip);
			icon:SetGrayStyle(1);
		end
	end
	if QSLOT_ENABLE_INDUN(cls) == false then
		slot:GetIcon():SetGrayStyle(1);
		
	else
		slot:SetEventScript(ui.LBUTTONUP, cls.Script);
	end
	

end

function REST_SLOT_USE(frame, slotIndex)

	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("CHATHEDRAL53_MQ03_ITEM02"));
		return;
	end

	local slot = GET_CHILD(frame, "slot"..slotIndex+1, "ui::CSlot");	
	if slot == nil then
		return;
	end
	local type = slot:GetUserValue("REST_TYPE");
	local cls = GetClassByType("restquickslotinfo", type);	
	
	if QSLOT_ENABLE_INDUN(cls) == false then
		return;
	end

	if cls == nil then
		return;
	end

	local scp = _G[cls.Script];
	if scp == nil then
		print(cls.Script);
		return;
	end
	scp();
end

function REQUEST_OPEN_JORUNAL_CRAFT()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

	local frame = ui.GetFrame("itemcraft");
	if frame ~= nil then
		if frame:IsVisible() == 1 then
			ui.CloseFrame("itemcraft");
		else			
			SET_CRAFT_IDSPACE(frame, "Recipe");
			SET_ITEM_CRAFT_UINAME("itemcraft");
			ui.OpenFrame("itemcraft");
			CRAFT_OPEN(frame);
		end
		
	end
end

function OPEN_ENCHENCT_CRAFT()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

	local abil = session.GetAbilityByName("Enchanter_Bomb")
	if nil == abil then
		return;
	end

	local obj = GetIES(abil:GetObject());
	local frame = ui.GetFrame("itemcraft_fletching");
	local title = frame:GetChild("title");
	title:SetTextByKey("value",  obj.Name);
	SET_ITEM_CRAFT_UINAME("itemcraft_fletching");
	SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
	CREATE_CRAFT_ARTICLE(frame);
	ui.ToggleFrame("itemcraft_fletching");
end

function OPEN_ARROW_CRAFT()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

	local abil = session.GetAbilityByName("Fletching")
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		local frame = ui.GetFrame("itemcraft_fletching");
		local title = frame:GetChild("title");
		title:SetTextByKey("value",  obj.Name);
		SET_ITEM_CRAFT_UINAME("itemcraft_fletching");
		SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
		CREATE_CRAFT_ARTICLE(frame);
		ui.ToggleFrame("itemcraft_fletching");
	end

end

function OPEN_OMAMORI_CRAFT()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

	local abil = session.GetAbilityByName("Omamori")
	if nil == abil then
		return;
	end
	
	local obj = GetIES(abil:GetObject());
	local frame = ui.GetFrame("itemcraft_fletching");
	local title = frame:GetChild("title");
	title:SetTextByKey("value",  obj.Name);
	SET_ITEM_CRAFT_UINAME("itemcraft_alchemist");
	SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
	CREATE_CRAFT_ARTICLE(frame);
	ui.ToggleFrame("itemcraft_fletching");
	
end

function OPEN_FLUTING_KEYBOARD()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
	end
	
	if FLUTING_ENABLED ~= 1 then
		return;
	end

	if IS_EXIST_JOB_IN_HISTORY(3012) ~= true then
		return;
	end
	
	local frame = ui.GetFrame("fluting_keyboard");
	ON_FLUTING_KEYBOARD_OPEN(frame);
end

function OPEN_DISPELLER_CRAFT()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

	local abil = session.GetAbilityByName("Pardoner_Dispeller")
	if abil ~= nil then
		local obj = GetIES(abil:GetObject());
		local frame = ui.GetFrame("itemcraft_fletching");
		local title = frame:GetChild("title");
		title:SetTextByKey("value",  obj.Name);
		SET_ITEM_CRAFT_UINAME("itemcraft_alchemist");
		SET_CRAFT_IDSPACE(frame, "Recipe_ItemCraft", obj.ClassName, obj.Level);
		CREATE_CRAFT_ARTICLE(frame);
		ui.ToggleFrame("itemcraft_fletching");
		
	end

end

function CHECK_CAMPFIRE_ENABLE(x, y, z)

	local mon = world.GetMonsterByClassName(x, y, z, "bonfire_1", 20);
	local camfireitem = session.GetInvItemByName('misc_campfireKit');
	if mon ~= nil or camfireitem == nil then
		return 0;
	end

	return 1;
end

function REQUEST_CAMPFIRE()
    if GetCraftState() == 1 then
        ui.SysMsg(ClMsg('CHATHEDRAL53_MQ03_ITEM02'));
        return;
    end

    local camfireitem = session.GetInvItemByName('misc_campfireKit');
	if camfireitem == nil then
		ui.AlarmMsg("NotCampfireKit");
	return
	end
	
	item.CellSelect(30, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}", "F_sys_select_gorund_red"); 
end

function CLOSE_REST_QUICKSLOT(frame)
	item.CellSelect(0, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}", "None");
end

function EXEC_CAMPFIRE(x, y, z)
	control.CustomCommand("PUT_CAMPFIRE", x, z);
end


function QSLOT_VISIBLE_ENCHNTE_CRAFT()
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType
	if pcCtrlType == "Scout" then
		return 1;
	end

	return 0;
end

function QSLOT_VISIBLE_DISPELLER_CRAFT()
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType
	if pcCtrlType == "Cleric" then
		return 1;
	end

	return 0;
end

function QSLOT_VISIBLE_FLUTING_KEYBOARD()
	if FLUTING_ENABLED ~= 1 then
		return 0;
	end
	if IS_EXIST_JOB_IN_HISTORY(3012) == true then
		return 1;
	end
	return 0;
end

function QSLOT_ENABLE_INDUN(cls)
	if  session.world.IsIntegrateServer() == true or
		session.world.IsIntegrateIndunServer() == true or
	    session.IsMissionMap() == true or 
		session.world.IsDungeon() == true then    
	    if cls.IndunEnabled == "true" then
			return true;
		else
			return false;
		end
    end
	return true;
end

function QSLOT_VISIBLE_CRAFT_SPELL_BOOK()
	local runecasterCls = GetClass('Job', 'Char2_17');
	if IS_HAD_JOB(runecasterCls.ClassID) == true then
		return 1;
	end
	return 0;
end