

function PETCOMMAND_ON_INIT(addon, frame)
 
	
end 

function INSERT_PET_RINGCOMMAND(bg, name, img, text, toolTipText, angle, index, totalCount, cbFunc)

	local cx = bg:GetWidth() / 2;
	local cy = bg:GetHeight() / 2;

	local totalAngle = 140;
	local startIndex = (totalCount / 2);
	if math.mod(totalCount, 2) == 0 then
		startIndex = startIndex - 0.5;
	end
	
	angle = angle + (index - startIndex) * (totalAngle / totalCount);
	angle = DegToRad(angle);
	local radius = 140;
	local addX = math.cos(angle) * radius;
	local addY = math.sin(angle) * radius;
	local x = cx + addX;
	local y = cy - addY;

	local ctrlSet = bg:CreateControlSet('ringcmd_menu', name, ui.LEFT, ui.TOP, x, y, 0, 0);
	ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');

	-- �ش� ��Ʈ�Ѽ� ��ư ������ �ش� ��� �����ϱ� ���ؼ� name�� �Լ��� ����� ó����..
	-- ���� ������ �ƴѵ�.. ���� ���� ������ �������� �ʾƼ�.. �������� ���� ����.

    local byFullString = string.find(cbFunc, '%(') ~= nil;
	ctrlSet:SetEventScript(ui.LBUTTONUP, cbFunc, byFullString);

	local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
	pic:SetImage(img);
	local textCtrl = ctrlSet:GetChild("text");		
	textCtrl:SetTextByKey("text", text);		
	ctrlSet:SetTextTooltip(toolTipText);
	return y;
end


function SET_PETCOMMAND_TYPE(frame, typeStr, handle)
	
	frame:SetUserValue("HANDLE", handle);
	local ringCmdType = frame:GetUserValue("RINGCMD_TYPE");
	if typeStr ~= ringCmdType then
		frame:SetUserValue("RINGCMD_TYPE", typeStr);
		ringCmdType = typeStr;
	end

	local bg = frame:GetChild("bg");
	if ringCmdType == "COMPANION" then
		bg:RemoveAllChild();

		local myActor = GetMyActor();
		local angle = fsmactor.GetAngle(myActor) - 45;
		
		local index = 0;
		local totalCount = 4;

		INSERT_PET_RINGCOMMAND(bg, "RINGCMD_0", "companion_ride", "Alt+Up", ClMsg("Ride"), angle, index, totalCount, "ON_RIDING_VEHICLE(1)" );
		index = index + 1;
		INSERT_PET_RINGCOMMAND(bg, "RINGCMD_1", "companion_down", "Alt+Dn", ClMsg("Unride"), angle, index, totalCount, "ON_RIDING_VEHICLE(0)" );
		index = index + 1;
		INSERT_PET_RINGCOMMAND(bg, "RINGCMD_2", "companion_hand", "Alt+1", ClMsg("Stroke"), angle, index, totalCount, "PETCMD_STROKE");
		index = index + 1;
		INSERT_PET_RINGCOMMAND(bg, "RINGCMD_3", "companion_eat", "Alt+2", ClMsg("GiveFood"), angle, index, totalCount, "PETCMD_FEEDING");
		index = index + 1;
	end

	FRAME_AUTO_POS_TO_OBJ(frame, handle, -frame:GetWidth() / 2, -frame:GetHeight() / 2);

end

function PETCMD_STROKE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	control.CustomCommand("COMPANION_STROKE", handle, 0);
end

function PETCMD_FEEDING(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	local foodItem = session.GetPetFoodItemByInv(handle, "Script", "PET_FOOD_USE");
	if foodItem == nil then
		ui.SysMsg(ClMsg("HaveNoPetFood"));
		return;
	end

	if foodItem.isLockState == true then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	control.CustomCommand("COMPANION_GIVE_FEED", handle, foodItem.invIndex, 0);
	--INV_ICON_USE(foodItem);

end

function RINGCOMMAND_ALT_NUMKEY(index)
	local frame = ui.GetFrame("petcommand");
	local ringCmdType = frame:GetUserValue("RINGCMD_TYPE");
	if ringCmdType == "COMPANION" then
		if index == 1 then
			PETCMD_STROKE(frame);
			return 1;
		end

		if index == 2 then
			PETCMD_FEEDING(frame);
			return 1;
		end
		
	end
	
	return 0;
end


