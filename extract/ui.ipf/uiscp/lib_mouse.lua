-- lib_mouse.lua --

function CHANGE_MOUSE_CURSOR(img, upImg, checkScp)
	local frame = ui.GetFrame("sysmenu");
	frame:SetUserValue("MOUSE_IMG", img);
	frame:SetUserValue("MOUSE_UP_IMG", upImg);
	mouse.ChangeCursorImg(img, 1);
	frame:SetUserValue("MOUSE_STATE", 0);
	frame:SetUserValue("MOUSE_CHECK_SCP", checkScp);
	frame:RunUpdateScript("_UPDATE_MOUSE_CURSOR", 0, 0, 0, 1);
end

function _UPDATE_MOUSE_CURSOR(frame)
	local obj = ui.GetFocusObject();
	local isUp = 0;
	if obj ~= nil then
		if obj:GetClassName() == "slot" then
			local scp = frame:GetUserValue("MOUSE_CHECK_SCP");
			local _func = _G[scp];
			local slot = tolua.cast(obj, "ui::CSlot");
			if _func(slot) == 1 then
				isUp = 1;
			end
		end
	end

	local curState = frame:GetUserIValue("MOUSE_STATE");
	if curState ~= isUp then
		frame:SetUserValue("MOUSE_STATE", isUp);
		if isUp == 1 then
			local img = frame:GetUserValue("MOUSE_UP_IMG");
			mouse.ChangeCursorImg(img, 1);
		else
			local img = frame:GetUserValue("MOUSE_IMG");
			mouse.ChangeCursorImg(img, 1);
		end
	end
	
	return 1;
end

function RESET_MOUSE_CURSOR()
	mouse.ChangeCursorImg("BASIC", 0);
	local frame = ui.GetFrame("sysmenu");
	frame:StopUpdateScript("_UPDATE_MOUSE_CURSOR");
end

