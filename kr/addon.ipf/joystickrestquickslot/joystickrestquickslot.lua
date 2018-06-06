--joystickrestquickslot.lua

MAX_JOYSTICK_RESTSLOT_CNT = 20;

--안들어와서 일단 주석처리.. 이름이 잘못되어있음. 이제 들어옴
function JOYSTICKRESTQUICKSLOT_ON_INIT(addon, frame)

	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_OPEN', 'JOYSTICK_ON_RESTQUICKSLOT_OPEN');
	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_CLOSE', 'ON_JOYSTICK_RESTQUICKSLOT_CLOSE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'JOYSTICK_RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'JOYSTICK_RESTQUICKSLOT_ON_ITEM_CHANGE');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'JOYSTICK_RESTQUICKSLOT_ON_ITEM_CHANGE');
	
	for i = 0, MAX_JOYSTICK_RESTSLOT_CNT-1 do
		local slot 			= frame:GetChildRecursively("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		local slotString 	= 'QuickSlotExecute'..(i+1);
		
		local string = "";

		if SLOT_NAME_INDEX == 0 then
			string = "X";
			SLOT_NAME_INDEX = 1;
		elseif SLOT_NAME_INDEX  == 1 then
			string = "A";
			SLOT_NAME_INDEX = 2;
		elseif SLOT_NAME_INDEX == 2 then
			string = "Y";
			SLOT_NAME_INDEX = 3;
		elseif SLOT_NAME_INDEX == 3 then
			string = "B";
			SLOT_NAME_INDEX = 0;
		end

		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..string, 'default', 'left', 'top', 2, 1);
	end
	
end

function JOYSTICK_RESTQUICKSLOT_ON_ITEM_CHANGE(frame)
	if frame:IsVisible() == 1 then
		JOYSTICK_ON_RESTQUICKSLOT_OPEN(frame);
	end
end

function JOYSTICK_ON_RESTQUICKSLOT_OPEN(frame, msg, argStr, argNum)

	frame = ui.GetFrame("joystickrestquickslot");

	padslot_onskin = frame:GetUserConfig("PADSLOT_ONSKIN")
	padslot_offskin = frame:GetUserConfig("PADSLOT_OFFSKIN")

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_JOYSTICK_REST_INPUT");
	timer:Start(0.1);

	local slotIndex = 1;
	local list = GetClassList('restquickslotinfo')
	for i = 0, MAX_JOYSTICK_RESTSLOT_CNT-1 do
		local cls = GetClassByIndexFromList(list, i);
		if cls ~= nil then
			if cls.VisibleScript == "None" or _G[cls.VisibleScript]() == 1 then
				if scp ~= "None" then
					local slot 			  = GET_CHILD_RECURSIVELY(frame, "slot"..slotIndex, "ui::CSlot");
					if slot ~= nil then
						slot:ReleaseBlink();
						slot:ClearIcon();
						SET_JOYSTICK_REST_QUICK_SLOT(slot, cls);
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
end

function ON_JOYSTICK_RESTQUICKSLOT_CLOSE(frame, msg, argStr, argNum)

	frame = ui.GetFrame("joystickrestquickslot");

	frame:ShowWindow(0);

	if IsJoyStickMode() == 0 then
		local quickFrame = ui.GetFrame('quickslotnexpbar')
		quickFrame:ShowWindow(1);
	elseif IsJoyStickMode() == 1 then
		local joystickQuickFrame = ui.GetFrame('joystickquickslot')
		joystickQuickFrame:ShowWindow(1);
	end
	ui.CloseFrame('reinforce_by_mix')
	item.CellSelect(0, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}","None");
end

function SET_JOYSTICK_REST_QUICK_SLOT(slot, cls)

	slot:SetEventScript(ui.LBUTTONUP, cls.Script);
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

		slot:GetIcon():SetText('{s18}{ol}{b}'.. itemCount, 'count', 'right', 'bottom', -2, 1);
	end

	local enableScp = cls.EnableScript;
	if enableScp ~= "None" then
		if _G[enableScp]() == 0 then
			slot:SetEventScript(ui.LBUTTONUP, "None");
			icon:SetTextTooltip('{@st59}'..cls.DisableTooltip);
			icon:SetGrayStyle(1);
		end
	end
end

function REST_JOYSTICK_SLOT_USE(frame, slotIndex)

	local slot = GET_CHILD_RECURSIVELY(frame, "slot"..slotIndex+1, "ui::CSlot");	
	local type = slot:GetUserValue("REST_TYPE");
	local cls = GetClassByType("restquickslotinfo", type);	
	local scp = _G[cls.Script];
	if scp == nil then
		print(cls.Script);
	end
	scp();
end

function CLOSE_JOYSTICK_REST_QUICKSLOT(frame)
	item.CellSelect(0, "F_sys_select_ground_blue", "EXEC_CAMPFIRE", "CHECK_CAMPFIRE_ENABLE", "WhereToMakeCampFire?", "{@st64}","None");
end



function UPDATE_JOYSTICK_REST_INPUT(frame)

	if IsJoyStickMode() == 0 then
		return;
	end
	
	local input_L1 = joystick.IsKeyPressed("JOY_BTN_5")
	local input_L2 = joystick.IsKeyPressed("JOY_BTN_7")
	local input_R1 = joystick.IsKeyPressed("JOY_BTN_6")
	local input_R2 = joystick.IsKeyPressed("JOY_BTN_8")

	local set1 = frame:GetChildRecursively("Set1");
	local set2 = frame:GetChildRecursively("Set2");
	local set1_Button = frame:GetChildRecursively("L2R2_Set1");
	local set2_Button = frame:GetChildRecursively("L2R2_Set2");
	
	--print(joystick.IsKeyPressed("JOY_L1L2"))
	
	if input_L1 == 1 and input_R1 == 0 then
		local gbox = frame:GetChildRecursively("L1_slot_Set1");
		if joystick.IsKeyPressed("JOY_L1L2") == 0 then
			gbox:SetSkinName(padslot_onskin);
		end
	elseif input_L1 == 0 or input_L1 == 1 and input_R1 == 1 then
		local gbox = frame:GetChildRecursively("L1_slot_Set1");
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R1 == 1 and input_L1 == 0 then
		local gbox = frame:GetChildRecursively("R1_slot_Set1");
		if joystick.IsKeyPressed("JOY_R1R2") == 0 then
			gbox:SetSkinName(padslot_onskin);
		end
	elseif input_R1 == 0 or input_L1 == 1 and input_R1 == 1 then
		local gbox = frame:GetChildRecursively("R1_slot_Set1");
		gbox:SetSkinName(padslot_offskin);
	end

	if input_L2 == 1 and input_R2 == 0 then
		local gbox = frame:GetChildRecursively("L2_slot_Set1");
		if joystick.IsKeyPressed("JOY_L1L2") == 0 then
---------------------------------------------------------------------
-- sysmenu 조작 끼워넣음
			if SYSMENU_JOYSTICK_IS_OPENED() == 1 then
				SYSMENU_JOYSTICK_MOVE_LEFT();
			end
			gbox:SetSkinName(padslot_onskin);
---------------------------------------------------------------------
		end
	elseif input_L2 == 0 then
		local gbox = frame:GetChildRecursively("L2_slot_Set1");
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R2 == 1 and input_L2 == 0 then
		local gbox = frame:GetChildRecursively("R2_slot_Set1");
		if joystick.IsKeyPressed("JOY_R1R2") == 0 then
---------------------------------------------------------------------
-- sysmenu 조작 끼워넣음
			if SYSMENU_JOYSTICK_IS_OPENED() == 1 then
				SYSMENU_JOYSTICK_MOVE_RIGHT();
			end
			gbox:SetSkinName(padslot_onskin);
---------------------------------------------------------------------
		end
	elseif input_R2 == 0 then
		local gbox = frame:GetChildRecursively("R2_slot_Set1");
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R1 == 1 and input_L1 == 1 then
		local gbox = frame:GetChildRecursively("L1R1_slot_Set1");
		gbox:SetSkinName(padslot_onskin);
	elseif input_R2 == 0 then
		local gbox = frame:GetChildRecursively("L1R1_slot_Set1");
		gbox:SetSkinName(padslot_offskin);
	end

end

function OPEN_JOYSTICK_REST_QUICKSLOT(frame)
end

function CLOSE_JOYSTICK_REST_QUICKSLOT(frame)
end