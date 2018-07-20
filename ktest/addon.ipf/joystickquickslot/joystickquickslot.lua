--joystickquickslot.lua

--기존의 퀵슬롯과 같은 함수는 그대로 사용하려고 하였으나,
--특정 경우의 피씨 환경에서는 함수를 찾을 수 없다는 에러메시지를 띄워서
--그냥 기존의 함수의 이름을 변경하여 사용하기로 함.

MAX_SLOT_CNT = 40;
SLOT_NAME_INDEX = 0;

function JOYSTICKQUICKSLOT_ON_INIT(addon, frame)

	addon:RegisterMsg('GAME_START', 'QUICKSLOT_UI_OPEN');
	addon:RegisterMsg('GAME_START', 'QUICKSLOT_INIT');
	addon:RegisterMsg('JOYSTICK_QUICKSLOT_LIST_GET', 'JOYSTICK_QUICKSLOT_ON_MSG');
	addon:RegisterMsg('JOYSTICK_INPUT', 'JOYSTICK_INPUT');

	addon:RegisterMsg('JUNGTAN_SLOT_UPDATE', 'JOYSTICK_JUNGTAN_SLOT_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_ON', 'JOYSTICK_EXP_ORB_SLOT_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_OFF', 'JOYSTICK_EXP_ORB_SLOT_ON_MSG');
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_ON', 'JOYSTICK_TOGGLE_ITEM_SLOT_ON_MSG');
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_OFF', 'JOYSTICK_TOGGLE_ITEM_SLOT_ON_MSG');

	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_OPEN', 'JOYSTICK_ON_RESTQUICKSLOT_OPEN');
	addon:RegisterMsg('JOYSTICK_RESTQUICKSLOT_CLOSE', 'ON_JOYSTICK_RESTQUICKSLOT_CLOSE');

	padslot_onskin = frame:GetUserConfig("PADSLOT_ONSKIN")
	padslot_offskin = frame:GetUserConfig("PADSLOT_OFFSKIN")

	setButton_onSkin = frame:GetUserConfig("SET_BUTTON_ONSKIN")
	setButton_offSkin = frame:GetUserConfig("SET_BUTTON_OFFSKIN")

	JOYSTICK_QUICKSLOTNEXPBAR_Frame = frame;

	for i = 0, MAX_SLOT_CNT-1 do
		local slot 			= frame:GetChildRecursively("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		
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
		JOYSTICK_QUICKSLOT_MAKE_GAUGE(slot)
	end

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_JOYSTICK_QUICKSLOT_OVERHEAT");
	timer:Start(0.1);

	JOYSTICKQUICKSLOT_TOGGLE_ITEM_LIST={}

end

function  JOYSTICK_QUICKSLOT_MAKE_GAUGE(slot)

	local x = 4;
	local y = slot:GetHeight() - 9;
	local width  = 40;
	local height = 8;
	local gauge = slot:MakeSlotGauge(x, y, width, height);
	gauge:SetDrawStyle(ui.GAUGE_DRAW_CELL);
	gauge:SetSkinName("dot_skillslot");
	
end


function UPDATE_JOYSTICK_QUICKSLOT_OVERHEAT(frame, ctrl, num, str, time)

	UPDATE_JOYSTICK_INPUT(frame)

	--[[땜빵코드입니다.
	다이얼로그를 열 때마다 조이스틱모드에서 특정 조건에
	그냥 퀵슬롯이 같이 열리는 경우가 있어서 그냥 여기서 강제로 꺼버림
	넥슨 테스트 대비 땜빵이고 찾아서 고쳐야함.
	]]--

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");

	--if quickSlotFrame:IsVisible() == 1 and IsJoyStickMode() == 1  then
	--quickSlotFrame:ShowWindow(0);
	--end


	for i = 0, MAX_SLOT_CNT - 1 do
		local slot 			= frame:GetChildRecursively("slot"..i+1);
		tolua.cast(slot, "ui::CSlot");
		UPDATE_JOYSTICK_SLOT_OVERHEAT(slot);
	end
end

function UPDATE_JOYSTICK_SLOT_OVERHEAT(slot)
	local obj = GET_JOYSTICK_SLOT_SKILL_OBJ(slot);
	if obj == nil or obj.OverHeatGroup == "None" then
		return;
	end

	local sklType = obj.ClassID;
	local skl = session.GetSkill(sklType);
	skl = GetIES(skl:GetObject());
	local useOverHeat = skl.UseOverHeat;
	local curHeat = session.GetSklOverHeat(sklType);
	curHeat = curHeat + useOverHeat - 1;
	local maxOverHeat = session.GetSklMaxOverHeat(sklType);
	local gauge = slot:GetSlotGauge();

	gauge:SetCellPoint(useOverHeat);
	gauge:SetPoint(curHeat, maxOverHeat);
	slot:InvalidateGauge();
end

function GET_JOYSTICK_SLOT_SKILL_OBJ(slot)

	local type = GET_JOYSTICK_SLOT_SKILL_TYPE(slot);
	if type == 0 then
		return nil;
	end

	local skl = session.GetSkill(type);

	if skl == nil then
		return nil;
	end

	return GetIES(skl:GetObject());

end

function GET_JOYSTICK_SLOT_SKILL_TYPE(slot)

	local icon = slot:GetIcon();
	if icon == nil then
		return 0;
	end;

	local category = icon:GetTooltipType();
	if category ~= "skill" then
		return 0;
	end

	return icon:GetTooltipNumArg();
end

function JOYSTICK_QUICKSLOT_ON_MSG(frame, msg, argStr, argNum)
--[[
	local Set1 			= frame:GetChildRecursively("Set1");
	local Set2 			= frame:GetChildRecursively("Set2");
	local visible = 0;

	if Set1:IsVisible() == 1 then
		visible = 1
	elseif Set2:IsVisible() == 1 then
		visible = 2
	end
	]]--
	--tolua.cast(slot, "ui::CSlot");
	--print(msg)
-- 스킬과 인벤토리 정보를 가지고 온다.
	local skillList 		= session.GetSkillList();
	local skillCount 		= skillList:Count();
	local invItemList 		= session.GetInvItemList();
	local itemCount 		= invItemList:Count();

	local MySession		= session.GetMyHandle();
	local MyJobNum		= info.GetJob(MySession);
	local JobName		= GetClassString('Job', MyJobNum, 'ClassName');

	if msg == 'GAME_START' then
		--ON_PET_SELECT(frame);
	end
	
	if msg == 'JOYSTICK_QUICKSLOT_LIST_GET' or msg == 'GAME_START' or msg == 'EQUIP_ITEM_LIST_GET' or msg == 'PC_PROPERTY_UPDATE' 
	or  msg == 'INV_ITEM_ADD' or msg == 'INV_ITEM_POST_REMOVE' or msg == 'INV_ITEM_CHANGE_COUNT' then
		DebounceScript("JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT", 0.1);
	end
	
	if msg == 'CHANGE_INVINDEX' then
		local toInvIndex = tonumber(argStr);
		local fromInvIndex = argNum;
		local toQuickIndex = -1;
		local fromQuickIndex = -1;

		local invenItemInfo = session.GetInvItem(toInvIndex);

		for i = 0, MAX_QUICKSLOT_CNT - 1 do
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			local icon = slot:GetIcon();
			if icon ~= nil then
				local iconInfo = icon:GetInfo();
				if fromInvIndex == 0 then
					if iconInfo.type == invenItemInfo.type then
						iconInfo.ext = toInvIndex;
						quickslot.SetInfo(slot:GetSlotIndex(), iconInfo.category, iconInfo.type, iconInfo.ext);
					end
				else
					if iconInfo.ext == toInvIndex then
						toQuickIndex = i;
					elseif iconInfo.ext == fromInvIndex then
						fromQuickIndex = i;
					end
				end
			end
		end
		if toQuickIndex ~= -1 and fromQuickIndex ~= -1 then
			QUICKSLOTNEXPBAR_CHANGE_INVINDEX(quickslot, toQuickIndex, fromInvIndex);
			QUICKSLOTNEXPBAR_CHANGE_INVINDEX(quickslot, fromQuickIndex, toInvIndex);
		end
	end
	
	local curCnt = quickslot.GetActiveSlotCnt();

	curCnt = 40;

	JOYSTICK_QUICKSLOT_REFRESH(curCnt);
end

function JOYSTICK_QUICKSLOT_REFRESH(curCnt)
	if curCnt < 20 or curCnt > 40 then
		curCnt = 20;
	end

	if curCnt % 10 ~= 0 then
		curCnt = 20;
	end

	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local slot 			= GET_CHILD_RECURSIVELY(JOYSTICK_QUICKSLOTNEXPBAR_Frame, "slot"..i+1, "ui::CSlot");
		tolua.cast(slot, "ui::CSlot");
		if i < curCnt then
			slot:ShowWindow(1);
		else
			slot:ShowWindow(0);
		end		
	end
	--[[
	local add = JOYSTICK_QUICKSLOTNEXPBAR_Frame:GetChild("slot_add");
	if curCnt >= 40 then
		add:SetEnable(0);
	else
		add:SetEnable(1);
	end
	local del = JOYSTICK_QUICKSLOTNEXPBAR_Frame:GetChild("slot_del");	
	if curCnt <= 20 then		
		del:SetEnable(0);
	else
		del:SetEnable(1);
	end
	]]--
	return curCnt;
end


function JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT()
	local frame = ui.GetFrame('joystickquickslot');
	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');	
	for i = 0, MAX_SLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		local updateslot = true;

		if sklCnt > 0 then
			if  quickSlotInfo.category == 'Skill' then
				updateslot = false;
			end

			if i <= sklCnt then
				updateslot = false;
			end
		end

		if true == updateslot and quickSlotInfo.category ~= 'NONE' then
			local slot = frame:GetChildRecursively("slot"..i+1);
			tolua.cast(slot, "ui::CSlot");
			SET_QUICK_SLOT(slot, quickSlotInfo.category, quickSlotInfo.type, quickSlotInfo:GetIESID(), 0, false);
		end
	end
end


function JOYSTICK_QUICKSLOT_EXECUTE(slotIndex)
	local quickFrame = ui.GetFrame('joystickquickslot')
	local Set1 = GET_CHILD_RECURSIVELY(quickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD_RECURSIVELY(quickFrame,'Set2','ui::CGroupBox');

	local input_L1  = joystick.IsKeyPressed("JOY_BTN_5")
	local input_R1  = joystick.IsKeyPressed("JOY_BTN_6")

	local joystickRestFrame = ui.GetFrame('joystickrestquickslot')
	if joystickRestFrame:IsVisible() == 1 then
		REST_JOYSTICK_SLOT_USE(joystickRestFrame, slotIndex);
		return;
	end

	if Set2:IsVisible() == 1 then
			slotIndex = slotIndex + 20
	end
	
	if input_L1 == 1 and input_R1 == 1 then
		if Set1:IsVisible() == 1 then
			if	slotIndex == 2  or slotIndex == 14 then
				slotIndex = 10
			elseif	slotIndex == 0  or slotIndex == 12 then
				slotIndex = 8
			elseif	slotIndex == 1  or slotIndex == 13 then
				slotIndex = 9
			elseif	slotIndex == 3  or slotIndex == 15 then
				slotIndex = 11
			end
		end	

		if Set2:IsVisible() == 1 then
			if	slotIndex == 22  or slotIndex == 34 then
				slotIndex = 30
			elseif	slotIndex == 20  or slotIndex == 32 then
				slotIndex = 28
			elseif	slotIndex == 21  or slotIndex == 33 then
				slotIndex = 29
			elseif	slotIndex == 23  or slotIndex == 35 then
				slotIndex = 31
			end
		end
	else

	end
	 
	local quickslotFrame = ui.GetFrame('joystickquickslot');
	local slot = quickslotFrame:GetChildRecursively("slot"..slotIndex+1);
	QUICKSLOTNEXPBAR_SLOT_USE(quickSlotFrame, slot, 'None', 0);	

end


function JOYSTICK_QUICKSLOT_ON_DROP(frame, control, argStr, argNum)
	
	-- 아이콘 셋
	-- imcSound.PlaySoundItem('ui_item_drop');

	local liftIcon 					= ui.GetLiftIcon();
	local liftIconiconInfo	 		= liftIcon:GetInfo();
	local iconParentFrame 			= liftIcon:GetTopParentFrame();
	local slot 						= tolua.cast(control, 'ui::CSlot');
	slot:SetEventScript(ui.RBUTTONUP, 'QUICKSLOTNEXPBAR_SLOT_USE');
	
	local iconCategory = 0;
	local iconType = 0;
	local iconGUID = "";
	if nil ~= liftIconiconInfo then
		iconCategory = liftIconiconInfo.category;
		iconType = liftIconiconInfo.type;
		iconGUID = liftIconiconInfo:GetIESID();
	end

	if iconParentFrame:GetName() == 'joystickquickslot' then
		-- NOTE : 퀵슬롯으로 부터 팝된 아이콘인 경우 기존 아이콘과 교환 합니다.
		local popSlotObj 		  = liftIcon:GetParent();
		if popSlotObj:GetName()  ~=  slot:GetName() then
			local popSlot = tolua.cast(popSlotObj, "ui::CSlot");
			local oldIcon = slot:GetIcon();
			if oldIcon ~= nil then
				local iconInfo = oldIcon:GetInfo();
				if iconInfo.imageName == "None" then
					oldIcon = nil;
				end
			end
			QUICKSLOTNEXPBAR_SETICON(popSlot, oldIcon, 1, false);
		end
	elseif iconParentFrame:GetName() == 'status' then
		STATUS_EQUIP_SLOT_SET(iconParentFrame);
		return;
	end
	
	--QUICKSLOTNEXPBAR_SETICON(slot, liftIcon, 1, true);
	QUICKSLOTNEXPBAR_NEW_SETICON(slot, iconCategory, iconType, iconGUID);
end



function JOYSTICK_QUICKSLOT_SWAP(test)
	local quickFrame = ui.GetFrame('joystickquickslot')
	local Set1 = GET_CHILD_RECURSIVELY(quickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD_RECURSIVELY(quickFrame,'Set2','ui::CGroupBox');

	if Set1:IsVisible() == 1 then
		Set1:ShowWindow(0);
		Set2:ShowWindow(1);
	elseif Set2:IsVisible() == 1 then
		Set2:ShowWindow(0);
		Set1:ShowWindow(1);
	end
end

function CLOSE_JOYSTICK_QUICKSLOT(frame)
end

function UPDATE_JOYSTICK_INPUT(frame)

	if IsJoyStickMode() == 0 then
		return;
	end
	
	--print(joystick.IsKeyPressed("JOY_TARGET_CHANGE"))
	local input_L1 = joystick.IsKeyPressed("JOY_BTN_5")
	local input_L2 = joystick.IsKeyPressed("JOY_BTN_7")
	local input_R1 = joystick.IsKeyPressed("JOY_BTN_6")
	local input_R2 = joystick.IsKeyPressed("JOY_BTN_8")

	local set1 = frame:GetChildRecursively("Set1");
	local set2 = frame:GetChildRecursively("Set2");
	local set1_Button = frame:GetChildRecursively("L2R2_Set1");
	local set2_Button = frame:GetChildRecursively("L2R2_Set2");
	
	--print(joystick.IsKeyPressed("JOY_L1L2"))
	
	if joystick.IsKeyPressed("JOY_UP") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		ON_RIDING_VEHICLE(1)
	end

	if joystick.IsKeyPressed("JOY_DOWN") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		ON_RIDING_VEHICLE(0)
	end

	if joystick.IsKeyPressed("JOY_LEFT") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		COMPANION_INTERACTION(2)
	end

	if joystick.IsKeyPressed("JOY_RIGHT") == 1 and joystick.IsKeyPressed("JOY_L1L2") == 1  then
		COMPANION_INTERACTION(1)
	end
	
	local setIndex = 0;

	if set1:IsVisible() == 1 then
		setIndex = 1;
		set1_Button:SetSkinName(setButton_onSkin);
		set2_Button:SetSkinName(setButton_offSkin);
	elseif set2:IsVisible() == 1 then
		setIndex = 2;
		set2_Button:SetSkinName(setButton_onSkin);
		set1_Button:SetSkinName(setButton_offSkin);
	end
	
	if input_L1 == 1 and input_R1 == 0 then
		local gbox = frame:GetChildRecursively("L1_slot_Set"..setIndex);
		if joystick.IsKeyPressed("JOY_L1L2") == 0 then
			gbox:SetSkinName(padslot_onskin);
		end
	elseif input_L1 == 0 or input_L1 == 1 and input_R1 == 1 then
		local gbox = frame:GetChildRecursively("L1_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R1 == 1 and input_L1 == 0 then
		local gbox = frame:GetChildRecursively("R1_slot_Set"..setIndex);
		if joystick.IsKeyPressed("JOY_R1R2") == 0 then
			gbox:SetSkinName(padslot_onskin);
		end
	elseif input_R1 == 0 or input_L1 == 1 and input_R1 == 1 then
		local gbox = frame:GetChildRecursively("R1_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_offskin);
	end

	if input_L2 == 1 and input_R2 == 0 then
		local gbox = frame:GetChildRecursively("L2_slot_Set"..setIndex);
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
		local gbox = frame:GetChildRecursively("L2_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R2 == 1 and input_L2 == 0 then
		local gbox = frame:GetChildRecursively("R2_slot_Set"..setIndex);
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
		local gbox = frame:GetChildRecursively("R2_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_offskin);
	end

	if input_R1 == 1 and input_L1 == 1 then
		local gbox = frame:GetChildRecursively("L1R1_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_onskin);
	elseif input_R2 == 0 then
		local gbox = frame:GetChildRecursively("L1R1_slot_Set"..setIndex);
		gbox:SetSkinName(padslot_offskin);
	end

end


function QUICKSLOT_UI_OPEN(frame, msg, argStr, argNum)
	
	if IsJoyStickMode() == 1 then
		local quickframe = ui.GetFrame("quickslotnexpbar");
		quickframe:ShowWindow(0)

		local joyframe = ui.GetFrame('joystickquickslot')
		joyframe:ShowWindow(1)
	end

end

function QUICKSLOT_INIT(frame, msg, argStr, argNum)
	local quickFrame = ui.GetFrame('joystickquickslot')
	local Set1 = GET_CHILD_RECURSIVELY(quickFrame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD_RECURSIVELY(quickFrame,'Set2','ui::CGroupBox');

	if Set1:IsVisible() == 1 then
		Set1:ShowWindow(0);
		Set2:ShowWindow(1);
		Set2:ShowWindow(0);
		Set1:ShowWindow(1);
	elseif Set2:IsVisible() == 1 then
		Set2:ShowWindow(0);
		Set1:ShowWindow(1);
		Set1:ShowWindow(0);
		Set2:ShowWindow(1);
	end
end

function JOYSTICK_EXP_ORB_SLOT_ON_MSG(frame, msg, str, num)
	local timer = GET_CHILD(frame, "exporbtimer", "ui::CAddOnTimer");
	if msg == "EXP_ORB_ITEM_OFF" then
		frame:SetUserValue("EXP_ORB_EFFECT", 0);
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');
	elseif msg == "EXP_ORB_ITEM_ON" then
		frame:SetUserValue("EXP_ORB_EFFECT", str);
		timer:SetUpdateScript("UPDATE_JOYSTICKQUICKSLOT_EXP_ORB");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	end
	DebounceScript("JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT", 0.1);
end

--토글
function JOYSTICK_TOGGLE_ITEM_SLOT_ON_MSG(frame, msg, argstr, argnum)
	if msg == "TOGGLE_ITEM_SLOT_ON" then
		JOYSTICKQUICKSLOT_TOGGLE_ITEM_LIST[argnum] = 1;
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	elseif msg == "TOGGLE_ITEM_SLOT_OFF" then
		JOYSTICKQUICKSLOT_TOGGLE_ITEM_LIST[argnum] = nil;
		imcSound.PlaySoundEvent('sys_booster_off');
	end

	local cnt = 0;
	for k, v in pairs(JOYSTICKQUICKSLOT_TOGGLE_ITEM_LIST) do
		cnt = cnt + 1;
	end
	
	if cnt > 0 then
		frame:RunUpdateScript("UPDATE_JOYSTICKQUICKSLOT_TOGGLE_ITEM", 1.0);
	else
		frame:StopUpdateScript("UPDATE_JOYSTICKQUICKSLOT_TOGGLE_ITEM");
	end
end

--업데이트
function UPDATE_JOYSTICKQUICKSLOT_TOGGLE_ITEM(frame)
	for k, v in pairs(QUICKSLOT_TOGGLE_ITEM_LIST) do
		PLAY_JOYSTICKQUICKSLOT_UIEFFECT(frame, k);
	end
	return 1
end

function JOYSTICK_JUNGTAN_SLOT_ON_MSG(frame, msg, str, itemType)

	-- atk jungtan
	if str == 'JUNGTAN_OFF' then

		frame:SetUserValue("JUNGTAN_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'JUNGTAN_ON' then

		frame:SetUserValue("JUNGTAN_EFFECT", itemType);
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_JOYSTICKQUICKSLOT_JUNGTAN");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');

	-- def jungtan
	elseif str == 'JUNGTANDEF_OFF' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'JUNGTANDEF_ON' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_JOYSTICKQUICKSLOT_JUNGTANDEF");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_def_booster_on');

	-- dispel magic
	elseif str == 'DISPELDEBUFF_OFF' then

		frame:SetUserValue("DISPELDEBUFF_EFFECT", 0);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');

	elseif str == 'DISPELDEBUFF_ON' then

		frame:SetUserValue("DISPELDEBUFF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_JOYSTICKQUICKSLOT_DISPEL_DEBUFF");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_def_booster_on');
	
	end
	
end

function UPDATE_JOYSTICKQUICKSLOT_EXP_ORB(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local expOrb = frame:GetUserValue("EXP_ORB_EFFECT");
	if expOrb ~= nil and expOrb ~= "None" then
		PLAY_JOYSTICKQUICKSLOT_UIEFFECT_BY_GUID(frame, expOrb);
	end
end

function UPDATE_JOYSTICKQUICKSLOT_JUNGTAN(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanID = tonumber( frame:GetUserValue("JUNGTAN_EFFECT") );
	if jungtanID > 0 then
		PLAY_JOYSTICKQUICKSLOT_UIEFFECT(frame, jungtanID);
	end
end

function UPDATE_JOYSTICKQUICKSLOT_JUNGTANDEF(frame, ctrl, num, str, time)

	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanDefID = tonumber( frame:GetUserValue("JUNGTANDEF_EFFECT") );
	if jungtanDefID > 0 then
		PLAY_JOYSTICKQUICKSLOT_UIEFFECT(frame, jungtanDefID);
	end

end

function UPDATE_JOYSTICKQUICKSLOT_DISPEL_DEBUFF(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local dispelmagicID = tonumber( frame:GetUserValue("DISPELDEBUFF_EFFECT") );
	if dispelmagicID > 0 then
		PLAY_JOYSTICKQUICKSLOT_UIEFFECT(frame, dispelmagicID);
	end

end

function PLAY_JOYSTICKQUICKSLOT_UIEFFECT_BY_GUID(frame, guid)
	local slotlist = {};
	for i = 0, MAX_QUICKSLOT_CNT-1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		if quickSlotInfo ~= nil then
			if quickSlotInfo:GetIESID() == guid then
				slotlist[#slotlist + 1] = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			end
		end
	end

	for i=1, #slotlist do
		local slot = slotlist[i];
		if slot ~= nil then
			local posX, posY = GET_SCREEN_XY(slot);
			if CHECK_SLOT_ON_ACTIVEJOYSTICKSLOTSET(frame, i) == true then
				movie.PlayUIEffect('I_sys_item_slot', posX, posY, 0.7); 
			end
		end
	end
end

function PLAY_JOYSTICKQUICKSLOT_UIEFFECT(frame, itemID)
	for i = 0, MAX_QUICKSLOT_CNT - 1 do
		local quickSlotInfo = quickslot.GetInfoByIndex(i);
		if quickSlotInfo ~= nil then
			if quickSlotInfo.type == itemID then
				local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
				if slot ~= nil then
					local posX, posY = GET_SCREEN_XY(slot);
					if CHECK_SLOT_ON_ACTIVEJOYSTICKSLOTSET(frame, i) == true then
						-- 스케일이 너무 크게 나와서 조금 줄임. 키보드모드와는 다르게 조이패드가 조금더 작다.
						movie.PlayUIEffect('I_sys_item_slot', posX, posY, 0.7); 
					end
				end
			end
		end
	end
end

-- 현재 활성화된 조이패드 슬롯셋에 속하는 SlotNumber(실제 슬롯 번호가 넘어옴)인지 확인
function CHECK_SLOT_ON_ACTIVEJOYSTICKSLOTSET(frame, slotNumber)
	local Set1 = GET_CHILD_RECURSIVELY(frame,'Set1','ui::CGroupBox');
	local Set2 = GET_CHILD_RECURSIVELY(frame,'Set2','ui::CGroupBox');

	-- Set1이 활성화 되었을때는 슬롯번호를 0~19까지 검사한다. (Slot의 실제 Number는 0부터 시작함)
	if Set1:IsVisible() == 1 and slotNumber >= 0 and slotNumber < 20 then
		return true;
	-- Set2이 활성화 되었을때는 슬롯번호를 20~39까지 검사한다. 
	elseif Set2:IsVisible() == 1 and slotNumber >= 20 and slotNumber < 40 then
		return true;
	end
	return false;
end


-- 조이패드 핫키 문자열을 X A Y B + 기능 키(L1,L2,R1,R2)의 조합으로 변경.
function JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(isFunctionKeyUse, hotKeyString)
	local hotKey = hotKeyString;
	
	-- 이 땜빵을 어찌해아 하나? 제일 좋은건 hotkey_joystic.xml의 Key, PressedKey를 예쁘게 정리하는 것이다.
	hotKey = string.gsub(hotKey, "JOY_BTN_1", "X");
	hotKey = string.gsub(hotKey, "JOY_BTN_2", "A");
	hotKey = string.gsub(hotKey, "JOY_BTN_3", "B");
	hotKey = string.gsub(hotKey, "JOY_BTN_4", "Y");

	-- 기능키까지 보여줬으면 할때	
	if isFunctionKeyUse == true then
		hotKey = string.gsub(hotKey, "JOY_BTN_5", "L1");
		hotKey = string.gsub(hotKey, "JOY_BTN_6", "R1"); 
		hotKey = string.gsub(hotKey, "JOY_BTN_7", "L2");
		hotKey = string.gsub(hotKey, "JOY_BTN_8", "R2"); 
	else -- 기능키를 제거
		hotKey = string.gsub(hotKey, "+", ""); -- +도 제거해준다.
		hotKey = string.gsub(hotKey, "JOY_BTN_5", "");
		hotKey = string.gsub(hotKey, "JOY_BTN_6", ""); 
		hotKey = string.gsub(hotKey, "JOY_BTN_7", "");
		hotKey = string.gsub(hotKey, "JOY_BTN_8", ""); 
	end

	return hotKey;
end


function JOYSTICK_QUICKSLOT_MY_MONSTER_SKILL(isOn, monName, buffType)
	
	local frame = ui.GetFrame('joystickquickslot')
	-- ON 일때.
	if isOn == 1 then
		local monCls = GetClass("Monster", monName);
		local list = GetMonsterSkillList(monCls.ClassID);
		for i = 0, list:Count() - 1 do
			local sklName = list:Get(i);
			local sklCls = GetClass("Skill", sklName);
			local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i+1, "ui::CSlot");
			tolua.cast(slot, "ui::CSlot");	
			local icon = slot:GetIcon();
			if icon ~= nil then
				local iconInfo = icon:GetInfo();
				slot:SetUserValue('ICON_CATEGORY', iconInfo.category);
				slot:SetUserValue('ICON_TYPE', iconInfo.type);
			end
			CLEAR_SLOT_ITEM_INFO(slot);
			local slotString 	= 'QuickSlotExecute'..(i+1);
			local hotKey		= hotKeyTable.GetHotKeyString(slotString, 1); -- 조이패드 핫키
			hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(false , hotKey);
			slot:SetText('{s14}{#f0dcaa}{b}{ol}'..hotKey, 'default', 'left', 'top', 2, 1);
			local type = sklCls.ClassID;
			local icon = CreateIcon(slot);
			local imageName = 'icon_' .. sklCls.Icon;
			icon:Set(imageName, "Skill", type, 0);
			icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_SKILL_COOLDOWN');
			icon:SetEnableUpdateScp('MONSTER_ICON_UPDATE_SKILL_ENABLE');
			icon:SetColorTone("FFFFFFFF");
			quickslot.OnSetSkillIcon(slot, type);
			SET_QUICKSLOT_OVERHEAT(slot);

			slot:EnableDrag(0);
		end

		local lastSlot = GET_CHILD_RECURSIVELY(frame, "slot"..list:Count() +1, "ui::CSlot");
		local icon = lastSlot:GetIcon();
		if icon ~= nil then
			local iconInfo = icon:GetInfo();
			lastSlot:SetUserValue('ICON_CATEGORY', iconInfo.category);
			lastSlot:SetUserValue('ICON_TYPE', iconInfo.type);
		end

		CLEAR_SLOT_ITEM_INFO(lastSlot);
		local icon = CreateIcon(lastSlot);
		local slotString 	= 'QuickSlotExecute'..(list:Count() +1);
		local hotKey		= hotKeyTable.GetHotKeyString(slotString, 1); -- 조이패드 핫키
		hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(false , hotKey);
		lastSlot:SetText('{s14}{#f0dcaa}{b}{ol}'..hotKey, 'default', 'left', 'top', 2, 1);
		icon:SetImage("druid_del_icon");	
		lastSlot:EnableDrag(0);
		SET_QUICKSLOT_OVERHEAT(lastSlot);
		frame:SetUserValue('SKL_MAX_CNT',list:Count() + 1)
		return;
	end

	-- OFF 일때(복구)
	local sklCnt = frame:GetUserIValue('SKL_MAX_CNT');
	for i = 1, sklCnt do
		local slot = GET_CHILD_RECURSIVELY(frame, "slot"..i, "ui::CSlot");
		CLEAR_SLOT_ITEM_INFO(slot);	
		local slotString 	= 'QuickSlotExecute'..i;
		local hotKey		= hotKeyTable.GetHotKeyString(slotString, 1); -- 조이패드 핫키
		hotKey = JOYSTICK_QUICKSLOT_REPLACE_HOTKEY_STRING(false , hotKey);
		slot:SetText('{s14}{#f0dcaa}{b}{ol}'..hotKey, 'default', 'left', 'top', 2, 1);
		local cate = slot:GetUserValue('ICON_CATEGORY');
		if 'None' ~= cate then
			SET_QUICK_SLOT(slot, cate, slot:GetUserIValue('ICON_TYPE'),  "", 0, 0);
		end
		slot:SetUserValue('ICON_CATEGORY', 'None');
		slot:SetUserValue('ICON_TYPE', 0);
		SET_QUICKSLOT_OVERHEAT(slot)

	end
	frame:SetUserValue('SKL_MAX_CNT',0)
end

function JOYSTICKQUICKSLOT_DRAW()
    JOYSTICK_QUICKSLOT_UPDATE_ALL_SLOT();
    JOYSTICK_QUICKSLOT_REFRESH(40);
end