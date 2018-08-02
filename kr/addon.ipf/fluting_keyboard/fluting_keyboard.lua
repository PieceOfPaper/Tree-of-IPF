function FLUTING_KEYBOARD_ON_INIT(addon, frame)
	FLUTING_KEYBOARD_UPDATE_HOTKEYNAME(frame);

	addon:RegisterMsg('FLUTING_KEYBOARD_OPEN', 'ON_FLUTING_KEYBOARD_OPEN');
	addon:RegisterMsg('FLUTING_KEYBOARD_CLOSE', 'ON_FLUTING_KEYBOARD_CLOSE');
end

function GET_MIN_FLUTING_KEYBOARD_CNT()
	return 20;
end

function GET_MAX_FLUTING_KEYBOARD_CNT()
	return 30;
end
function GET_FLUTING_KEYBOARD_CNT()
	if IS_ENABLED_PIED_PIPER_FLUTING_OCTAVE_3(GetMyPCObject()) == 1 then
		return GET_MAX_FLUTING_KEYBOARD_CNT();
	else
		return GET_MIN_FLUTING_KEYBOARD_CNT();
	end
end

function FLUTING_KEYBOARD_UPDATE_HOTKEYNAME(frame)
	local flutingKeyboardCnt = GET_MAX_FLUTING_KEYBOARD_CNT()
	for i = 0, flutingKeyboardCnt-1 do
		local slot 			= GET_CHILD(frame, "slot"..i+1);
		if slot ~= nil then
		local slotString 	= 'QuickSlotExecute'..(i+1);
		local text 			= hotKeyTable.GetHotKeyString(slotString);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..text, 'default', 'left', 'top', 2, 1);
		end
	end
end

function GET_FLUTING_SCALE_LIST_BY_HOT_KEY_NAME(hotkeyName)
	local scaleList = {};

	local clsList, cnt = GetClassList('fluting_scale');
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.HotKey == hotkeyName then
			scaleList[#scaleList + 1] = cls;
		end
	end

	return scaleList;
end

function ON_FLUTING_KEYBOARD_OPEN(frame, msg, argStr, argNum)
	local cnt = GET_FLUTING_KEYBOARD_CNT()
	for i = 0, cnt-1 do
		local slot = GET_CHILD(frame, "slot"..i+1);
		local slotString = 'QuickSlotExecute'..(i+1);
		local clsList = GET_FLUTING_SCALE_LIST_BY_HOT_KEY_NAME(slotString);
		SET_FLUTING_KEYBOARD_QUICK_SLOT(slot, clsList);
	end
	
	local minCnt = GET_MIN_FLUTING_KEYBOARD_CNT()
	local maxCnt = GET_MAX_FLUTING_KEYBOARD_CNT()

	local isVisible = 0;
	if cnt == maxCnt then
		isVisible = 1;
	end

	local line2 = frame:GetChild("Line_2");
	line2:SetVisible(isVisible)
	for i = minCnt, maxCnt-1 do
		local slot = GET_CHILD(frame, "slot"..i+1);
		slot:SetVisible(isVisible);
	end

	local closeSlotNum = frame:GetUserConfig("CLOSE_INDEX");
	local closeSlot = GET_CHILD(frame, "slot"..(closeSlotNum));
	SET_FLUTING_KEYBOARD_CLOSE_SLOT(closeSlot)
	
	Piedpiper.ReqReadyFluting(1);	
	frame:ShowWindow(1);
	
	local joystickrestquickslot = ui.GetFrame('joystickrestquickslot')
	local restquickslot = ui.GetFrame('restquickslot')
	if joystickrestquickslot:IsVisible() == 1 then
		joystickrestquickslot:ShowWindow(0);
	end
	if restquickslot:IsVisible() == 1 then
		restquickslot:ShowWindow(0);
	end
end

function ON_FLUTING_KEYBOARD_CLOSE(frame, msg, argStr, argNum)
	Piedpiper.ReqReadyFluting(0);
	frame:ShowWindow(0);
end

function CLOSE_FLUTING_KEYBOARD()
	local frame = ui.GetFrame("fluting_keyboard");
	ON_FLUTING_KEYBOARD_CLOSE(frame);
	
	local joystickrestquickslot = ui.GetFrame('joystickrestquickslot')
	local restquickslot = ui.GetFrame('restquickslot')
	
	if control.IsRestSit() == true then
		Piedpiper.ReqReadyFluting(0);
		if IsJoyStickMode() == 1 then
			joystickrestquickslot:ShowWindow(1);
		else
			restquickslot:ShowWindow(1);
		end
	end

end

function SET_FLUTING_KEYBOARD_QUICK_SLOT(slot, clslist)
	if #clslist <= 0 then
		slot:ReleaseBlink();
		slot:ClearIcon();
		slot:SetEventScript(ui.LBUTTONDOWN, "None");
		slot:SetEventScript(ui.LBUTTONUP, "None");
		slot:SetUserValue("FLUTING_SCALE_TYPE", "None");
		return;
	end

	for i=1, #clslist do
		local cls = clslist[i];
		if cls.IsSharp ~= "YES" then
			slot:SetUserValue("FLUTING_SCALE_TYPE", cls.ClassID);
			slot:ReleaseBlink();
			slot:ClearIcon();
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
			
			slot:SetEventScript(ui.LBUTTONDOWN, "FLUTING_SLOT_LBTN_DOWN");
			slot:SetEventScript(ui.LBUTTONUP, "FLUTING_SLOT_LBTN_UP");
		else
			slot:SetUserValue("FLUTING_SCALE_SHARP_TYPE", cls.ClassID);
		end
	end
end

function SET_FLUTING_KEYBOARD_CLOSE_SLOT(slot)
	local icon 	= CreateIcon(slot);
	local desctext = ClMsg("FlutingKeyboardClose");
	icon:SetTextTooltip('{@st59}'..desctext);
	
	local frame = slot:GetTopParentFrame();
	local iconName = frame:GetUserConfig("CLOSE_ICON");
	if iconName ~= "None" then
		icon:SetImage(iconName);
	end
	slot:EnableDrag(0);
	slot:Invalidate();

	slot:SetEventScript(ui.LBUTTONUP, "CLOSE_FLUTING_KEYBOARD");
end

function FLUTING_SLOT_USE(frame, slotIndex)
	local slot = GET_CHILD(frame, "slot"..slotIndex+1);
	if slot:GetEventScript(ui.LBUTTONUP) == "CLOSE_FLUTING_KEYBOARD" then
		CLOSE_FLUTING_KEYBOARD();
	end
end

function FLUTING_SLOT_LBTN_DOWN(frame, slot, strarg, numarg)
	local type = slot:GetUserIValue("FLUTING_SCALE_TYPE");
	local isSpaceBar = keyboard.IsKeyPressed("SPACE");
	if isSpaceBar == 1 then
		type = slot:GetUserIValue("FLUTING_SCALE_SHARP_TYPE");
	end
	
	if type == 0 then
		return;
	end

	local cls = GetClassByType("fluting_scale", type);	
	if cls == nil then
		return;
	end

	Piedpiper.ReqPlayFluting(cls.ClassID)
end

function FLUTING_SLOT_LBTN_UP(frame, slot, strarg, numarg)
	local type = slot:GetUserIValue("FLUTING_SCALE_TYPE");
	local isSpaceBar = keyboard.IsKeyPressed("SPACE");
	if isSpaceBar == 1 then
		type = slot:GetUserIValue("FLUTING_SCALE_SHARP_TYPE");
	end
	
	if type == 0 then
		return;
	end

	local cls = GetClassByType("fluting_scale", type);	
	if cls == nil then
		return;
	end

	Piedpiper.ReqStopFluting(cls.ClassID)
end