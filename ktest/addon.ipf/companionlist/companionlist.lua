-- companionlist.lua

function COMPANIONLIST_ON_INIT(addon, frame)

	
end

function COMPANIONLIST_OPEN(petinfo_frame)
	if petinfo_frame == nil then
		return
	end

	local petListBtn = GET_CHILD_RECURSIVELY(petinfo_frame, "petListBtn", "ui::CButton");
	if petListBtn == nil then
	return
	end

	local x = petinfo_frame:GetGlobalX() + petinfo_frame:GetWidth() - 5;
	local y = petListBtn:GetGlobalY();
	local frame = ui.GetFrame("companionlist");	
	
	-- frame이 현재 보여지는 상태면 닫는다.
	if frame:IsVisible() == 1 then
		CLOSE_COMPANIONLIST()
	else 
		UPDATE_COMPANIONLIST(frame);
		frame:SetGravity(ui.LEFT, ui.TOP);
		frame:SetOffset(x,y);
		frame:ShowWindow(1);
	end

end

function ON_OPEN_COMPANIONLIST()
	local frame = ui.GetFrame("companionlist");
	frame:ShowWindow(1);
	UPDATE_COMPANIONLIST(frame);
end

function CLOSE_COMPANIONLIST()
	local frame = ui.GetFrame("companionlist");	
	frame:ShowWindow(0);
end

function UPDATE_COMPANIONLIST(frame)

	local gb_petlist = frame:GetChild("gb_petlist");
	DESTROY_CHILD_BYNAME(gb_petlist, "_CTRLSET_");	
	local petList = session.pet.GetPetInfoVec();
	local x = 0;
	local y = 0;

	for i = 0 , petList:size() - 1 do
		local info = petList:at(i);
		local obj = GetIES(info:GetObject());

		-- 0 공통 펫만 출력.
		if info:GetNeedJobID() == 0 then
			local setName = "_CTRLSET_" .. i;
			local ctrlset = gb_petlist:CreateControlSet('companionlist_ctrl', setName, x, y);
			y = y + ui.GetControlSetAttribute("companionlist_ctrl", "height");

			local slot = GET_CHILD(ctrlset, "slot");
			slot:SetEventScript(ui.RBUTTONDOWN, 'USE_COMPANION_ICON');

			local icon = CreateIcon(slot);
			icon:SetImage(obj.Icon);
			icon:Set(obj.Icon, "Companion", obj.ClassID, 1, info:GetStrGuid());
			icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_COMPANION_COOLDOWN');
			icon:SetColorTone("FFFFFFFF");
			icon:ClearText();
		
			local lv = GET_CHILD(ctrlset, "companion_level", "ui::CRichText");
			local name = GET_CHILD(ctrlset, "companion_name", "ui::CRichText");
			lv:SetTextByKey("value", obj.Lv);
			name:SetTextByKey("value", info:GetName());
		end
	end
end

local function  USE_COMPANION_ICON_AFTER_ACTION(parent, ctrl, argStr, argNum)
	local canClose = false;
	local frame = ui.GetFrame("pet_info");
	if frame ~= nil then
		 -- 펫정보 창이 열리지 않은 상태라면 컴패니언 목록을 닫는다.
		 if frame:IsVisible() == 0 then
			canClose = true;
		 end
	else
		canClose = true;
	end

	if canClose == true then
		CLOSE_COMPANIONLIST();
	end
end

function USE_COMPANION_ICON(parent, ctrl, argStr, argNum)

	local slot = ctrl;
	tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return;
	end	

	local iconInfo = icon:GetInfo();
	local petGuidStr = iconInfo:GetIESID();
	-- 컴패니언 목록에서는 클릭으로 소환/역소환 가능.
	local summonedPet = session.pet.GetSummonedPet();
	if summonedPet ~= nil then
		if summonedPet:GetStrGuid() == petGuidStr then
			-- 소환되어 있는 컴패니언을 다시 우클릭한 컴패니언이라면 역소환한다
			control.SummonPet(0,0,0);  
			return;
		end
	end
	
	-- 그외에 소환 요청
	ICON_USE(icon);
	-- 1초간 비활성
	ui.DisableForTime(slot, 1, 1); 

	USE_COMPANION_ICON_AFTER_ACTION(parent, ctrl, argStr, argNum)
end
