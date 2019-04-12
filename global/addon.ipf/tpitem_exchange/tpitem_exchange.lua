
-- tpitem_package.lua : (tp shop)

function TPITEM_EXCHANGE_OPEN()		
	local tpframe = ui.GetFrame("tpitem");
	local screenbgTemp = tpframe:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(1);	

		local frame = ui.GetFrame("tpitem_exchange");				
		local strURL = ui.ExcNCurl();
		frame:ShowWindow(1);
						
		local webB = GET_CHILD_RECURSIVELY(frame,'webB');
		webB:SetUrlinfo(strURL);	
		webB:SetForActiveX(true);
		webB:ShowBrowser(true);
		
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local MaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth();
	local MaxHeight = MaxWidth * ratio;

	frame:Resize(MaxWidth/4, MaxHeight/6, MaxWidth/2, MaxHeight*2/3);
	TPITEM_EXCHANGE_RESIZE(frame);
end

function TPITEM_EXCHANGE_CLOSE(parent, control)		
		local frame = ui.GetFrame("tpitem_exchange");	
		local webB = GET_CHILD_RECURSIVELY(frame,'webB');
		webB:ShowBrowser(false);
		frame:ShowWindow(0);

	local tpframe = ui.GetFrame("tpitem");
	local screenbgTemp = tpframe:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(0);	
end

function TPITEM_EXCHANGE_BACK(parent, control)		
		local frame = ui.GetFrame("tpitem_exchange");	
		local webB = GET_CHILD_RECURSIVELY(frame,'webB');
		webB:GoBack();
end

function TPITEM_EXCHANGE_FORWARD(parent, control)		
		local frame = ui.GetFrame("tpitem_exchange");	
		local webB = GET_CHILD_RECURSIVELY(frame,'webB');
		webB:GoForward();
end

function TPITEM_EXCHANGE_REFRESH(parent, control)		
		local frame = ui.GetFrame("tpitem_exchange");	
		local webB = GET_CHILD_RECURSIVELY(frame,'webB');
		webB:Refresh();
end



function TPITEM_EXCHANGE_RESIZE(parent)
	local szWidth = parent:GetWidth();
	local szHeight = parent:GetHeight();
	
	local stdBox = GET_CHILD_RECURSIVELY(parent,'stdBox');
	stdBox:Resize(szWidth, szHeight);
	
	local webB = GET_CHILD(stdBox, "webB");
	webB:Resize(szWidth - webB:GetOffsetX() - 10, szHeight- webB:GetOffsetY() - 25);
end


function TPITEM_EXCHANGE_MOVE_FRAME_START(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();

	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_X", frame:GetX());
	frame:SetUserValue("BEFORE_Y", frame:GetY());
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME_FOR_TPITEM_EXCHANGE");
	frame:RunUpdateScript("_PROCESS_MOVING_MOVE_FRAME_FOR_TPITEM_EXCHANGE",  0.01, 0.0, 0, 1);
end

function TPITEM_EXCHANGE_MOVE_FRAME_END(parent, ctrl)
	local frame = parent:GetTopParentFrame();	
	frame:StopUpdateScript("_PROCESS_MOVING_MOVE_FRAME_FOR_TPITEM_EXCHANGE");
end


function _PROCESS_MOVING_MOVE_FRAME_FOR_TPITEM_EXCHANGE(frame)

	if mouse.IsLBtnPressed() == 0 then
		frame:StopUpdateScript("_PROCESS_MOVING_MOVE_FRAME_FOR_TPITEM_EXCHANGE");
		return 0;
	end
	
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local MaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth();
	local MaxHeight = MaxWidth * ratio;

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");
	local wndX = frame:GetUserIValue("BEFORE_X");
	local wndY = frame:GetUserIValue("BEFORE_Y");
	local dx = (mx - bx);
	local dy = (my - by);	
	local wndW = frame:GetWidth();
	local wndH = frame:GetHeight();
	
	wndX =  wndX + dx;
	wndY =  wndY + dy;
	
	local limitOffset = 10;
	
	if wndX < limitOffset then
		wndX = limitOffset;
	end;

	if wndY < limitOffset then
		wndY = limitOffset;
	end;
	
	if wndX > (MaxWidth - limitOffset - wndW) then
		wndX = MaxWidth - limitOffset - wndW;
	end;
	
	if wndY > (MaxHeight - limitOffset - wndH - 60) then	-- 왜 60만큼 차이 나는지 모르겠음.
		wndY = MaxHeight - limitOffset - wndH - 60;
	end;
	
	frame:SetOffset(wndX, wndY);
	return 1;
end

function TPITEM_EXCHANGE_RESIZE_FRAME_START(parent)
	local frame = parent:GetTopParentFrame();
	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / ui.GetRatioHeight();

	frame:SetUserValue("MOUSE_X", mx);
	frame:SetUserValue("MOUSE_Y", my);
	frame:SetUserValue("BEFORE_W", frame:GetWidth());
	frame:SetUserValue("BEFORE_H", frame:GetHeight());
	frame:StopUpdateScript("_PROCESS_MOVING_MOVE_FRAME_FOR_TPITEM_EXCHANGE");
	frame:RunUpdateScript("_PROCESS_MOVING_RESIZE_FRAME_FOR_TPITEM_EXCHANGE",  0.01, 0.0, 0, 1);
	frame:Invalidate();
	TPITEM_EXCHANGE_RESIZE(frame);
end;

function TPITEM_EXCHANGE_RESIZE_FRAME_END(parent)
	local frame = parent:GetTopParentFrame();	
	frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME_FOR_TPITEM_EXCHANGE");
end;


function _PROCESS_MOVING_RESIZE_FRAME_FOR_TPITEM_EXCHANGE(frame)

	if mouse.IsLBtnPressed() == 0 then
		frame:StopUpdateScript("_PROCESS_MOVING_RESIZE_FRAME_FOR_TPITEM_EXCHANGE");
		return 0;
	end
	
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local MaxWidth = ui.GetSceneWidth() / ui.GetRatioWidth();
	local MaxHeight = MaxWidth * ratio;

	local mx, my = GET_MOUSE_POS();
	mx = mx / ui.GetRatioWidth();
	my = my / (ui.GetSceneHeight() / MaxHeight);
	local bx = frame:GetUserIValue("MOUSE_X");
	local by = frame:GetUserIValue("MOUSE_Y");

	local dx = (mx - bx);
	local dy = (my - by);

	local width = frame:GetUserIValue("BEFORE_W");
	local height = frame:GetUserIValue("BEFORE_H");
	width = width + dx;
	height = height + dy;
	
	local wndX = frame:GetX();
	local wndY = frame:GetY();

	local limitOffset = 10;

	if width < limitOffset then
		width = limitOffset;
	end;

	if height < limitOffset then
		height = limitOffset;
	end;
		
	if width > (MaxWidth - limitOffset - wndX) then
		width = MaxWidth - limitOffset - wndX;
	end;
	
	if height > (MaxHeight - limitOffset - wndY - 60) then	-- 왜 60만큼 차이 나는지 모르겠음.
		height = MaxHeight - limitOffset - wndY - 60;
	end;

	frame:Resize(width, height);
	TPITEM_EXCHANGE_RESIZE(frame);
	return 1;
end
