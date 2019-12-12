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
	local pos = info.GetPositionInUI(handle , offsetType);
		
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

function _FRAME_AUTOPOS_BY_FRAMEPOS(frame)

	local handle = frame:GetUserIValue("_AT_OFFSET_HANDLE");
	local offsetX = frame:GetUserIValue("_AT_OFFSET_X");
	local offsetY = frame:GetUserIValue("_AT_OFFSET_Y");
	local offsetType = frame:GetUserIValue("_AT_OFFSET_TYPE");
	local pos = info.GetPositionVectorInScreen(	handle , offsetType);
		
	if nil == world.GetActor(handle) then	
		local autoDestroy = frame:GetUserIValue("_AT_AUTODESTROY");
		if autoDestroy == 1 then
			frame:ShowWindow(0);
			return 0;
		end

		return 1;
	end

	AUTO_CAST(frame);
	local pt = frame:ScreenPosToFramePosVector(pos.x, pos.y);
	pt.x = pt.x + offsetX;
	pt.y = pt.y + offsetY;
	frame:MoveFrame(pt.x, pt.y);
	return 1;
end


function FRAME_AUTO_POS_TO_OBJ(frame, handle, offsetX, offsetY, offsetType, autoDestroy, useFramePos)
	frame:SetUserValue("_AT_OFFSET_HANDLE", handle);
	frame:SetUserValue("_AT_OFFSET_X", offsetX);
	frame:SetUserValue("_AT_OFFSET_Y", offsetY);
	frame:SetUserValue("_AT_OFFSET_TYPE", offsetType);
	frame:SetUserValue("_AT_AUTODESTROY", autoDestroy);
	
	AUTO_CAST(frame);
	frame:SetFloatPosFrame(true);

	if useFramePos == 1 then
		_FRAME_AUTOPOS_BY_FRAMEPOS(frame);
		frame:RunUpdateScript("_FRAME_AUTOPOS_BY_FRAMEPOS");	
	else
		_FRAME_AUTOPOS(frame);
		frame:RunUpdateScript("_FRAME_AUTOPOS");	
	end
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




function RESIZE_FRAME(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetWidth());
	frame:SetUserValue("BEFORE_H", frame:GetHeight());
	frame:StopUpdateScript("_PROCESS_MOVE_FRAME");
	frame:RunUpdateScript("_PROCESS_RESIZE_FRAME",  0.01, 0.0, 0, 1);
	
end


function _PROCESS_RESIZE_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then
		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);

	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height + dy;
	frame:Resize(width, height);

	return 1;

end


function MOVE_FRAME(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetX());
	frame:SetUserValue("BEFORE_H", frame:GetY());
	frame:StopUpdateScript("_PROCESS_RESIZE_FRAME");
	frame:RunUpdateScript("_PROCESS_MOVE_FRAME",  0.01, 0.0, 0, 1);
	
end

function SET_MOVE_END_CALLBACK(parent, cbFunc)
	local frame = parent:GetTopParentFrame();
	frame:SetUserValue("MOVE_END_CB", cbFunc);
end

function SET_MOVE_PROCESS_CALLBACK(parent, cbFunc)
	local frame = parent:GetTopParentFrame();
	frame:SetUserValue("MOVE_PRO_CB", cbFunc);
	frame:RunUpdateScript("UPDATE_MOVE_PROCESS_CB",  0.01, 0.0, 0, 1);
	
end

function UPDATE_MOVE_PROCESS_CB(frame)

	if false == frame:HaveUpdateScript("_PROCESS_MOVE_FRAME") then
		return 0;
	end

	local procCB = frame:GetUserValue("MOVE_PRO_CB");
	local func = _G[procCB];
	if 0 == func(frame) then
		return 0;
	end

	return 1;

end

function _PROCESS_MOVE_FRAME(frame)

	if mouse.IsLBtnPressed() == 0 then

		local cbFunc = frame:GetUserValue("MOVE_END_CB");
		if cbFunc ~= "None" then
			local fun = _G[cbFunc];
			frame:SetUserValue("MOVE_END_CB", "None");
			fun(frame);
		end

		return 0;
	end

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);

	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height + dy;
	frame:SetOffset(width, height);

	return 1;

end


