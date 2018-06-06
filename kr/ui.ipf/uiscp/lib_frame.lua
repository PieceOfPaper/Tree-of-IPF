-- lib_frame.lua

function RUN_INVALIDATING(frame, sec)

	frame:RunUpdateScript("INVALIDATING", 0.0001, sec);

end

function INVALIDATING(frame)
	frame:Invalidate();
	return 1;
end

function ALIGN_CHILDS(frame, starty, spacey, frameAddY, findName)
	
	local y = starty;
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		if string.find(ctrl:GetName(), findName) ~= nil  then
			ctrl:SetOffset(ctrl:GetX(), y);
			y = y + ctrl:GetHeight() + spacey;
		end
	end

	if frameAddY ~= nil then
		frame:Resize(frame:GetWidth(), y + frameAddY);
	end

end

function SET_TABKEY_VISIBLE(frame)
	frame:EnableHideProcess(1);
	frame:RunUpdateScript("UPDATE_TABKEY_VISIBLE", 0.01);
end

function UPDATE_TABKEY_VISIBLE(frame)
	local curVisible = keyboard.IsKeyPressed("GRAVE");
	if frame:IsVisible() ~= curVisible then
		frame:ShowWindow(curVisible);
	end
	
	return 1;
end

function FRAME_FULLSCREEN(frame)
	
	local width = ui.GetClientInitialWidth();
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	frame:Resize(width,width*ratio);

	return width,width*ratio;
end


function _FRAME_AUTOPOS(frame)

	local handle = frame:GetUserIValue("_AT_OFFSET_HANDLE");
	local offsetX = frame:GetUserIValue("_AT_OFFSET_X");
	local offsetY = frame:GetUserIValue("_AT_OFFSET_Y");
	local offsetType = frame:GetUserIValue("_AT_OFFSET_TYPE");
	local pos = info.GetPositionInUI(	handle , offsetType);
		
	if nil == world.GetActor(handle) then	
		local autoDestroy = frame:GetUserIValue("_AT_AUTODESTROY");
		if autoDestroy == 1 then
			frame:ShowWindow(0);
			return 0;
		end

		return 1;
	end

	local x = pos.x + offsetX;
	local y = pos.y + offsetY;
	frame:SetOffset(x, y);
	return 1;
end

function FRAME_AUTO_POS_TO_OBJ(frame, handle, offsetX, offsetY, offsetType, autoDestroy)
	frame:SetUserValue("_AT_OFFSET_HANDLE", handle);
	frame:SetUserValue("_AT_OFFSET_X", offsetX);
	frame:SetUserValue("_AT_OFFSET_Y", offsetY);
	frame:SetUserValue("_AT_OFFSET_TYPE", offsetType);
	frame:SetUserValue("_AT_AUTODESTROY", autoDestroy);
	_FRAME_AUTOPOS(frame);
	frame:RunUpdateScript("_FRAME_AUTOPOS");	
end

function UIEFFECT_CHANGE_CLIENT_SIZE(frame)
	frame:MoveFrame(0, 0);
	local width = 1920;
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local height = width * ratio;
	--local height = 1080;
	frame:Resize(width,height);
	frame:Invalidate();
end



