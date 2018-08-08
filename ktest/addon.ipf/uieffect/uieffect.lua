
local g_screen_width = nil
local g_screen_height = nil

function UIEFFECT_ON_INIT(addon, frame)
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'change_client_size');	
	frame:ShowWindow(1)
end

function END_SNIPE()
	local frame = ui.GetFrame("uieffect");
	local child = frame:GetChild("SNIPER");
    local text = child:GetChild('POSTEXT')
    text:StopUpdateScript('AUTOCHANGETEXT')
	child:StopUpdateScript("UPDATE_SNIPE_POSITION")
	child:ShowWindow(0)
end

function GET_CURRENT_SNIPE_POS()    
	local frame = ui.GetFrame("uieffect");
	local child = frame:GetChild("SNIPER");
	local childName = child:GetUserValue("CENTERNAME");
	local centerChild = child:GetChild(childName);
	local x = centerChild:GetGlobalX() + centerChild:GetWidth() * 0.5;
	local y = centerChild:GetGlobalY() + centerChild:GetHeight() * 0.5;
	local pos = frame:FramePosToScreenPos(x, y)
	return pos.x, pos.y;
end

function change_client_size(frame)
	frame:MoveFrame(0, 0);
	local width = option.GetClientWidth()
    if width < 1920 then width = 1920 end    
    local ratio = option.GetClientHeight() / option.GetClientWidth()
	local height = width * ratio
	frame:Resize(width, height)    
	frame:Invalidate();
end


function START_SNIPE(sx, sy)    
	local frame = ui.GetFrame("uieffect");
    change_client_size(frame)
	local centerX, centerY;
	local child = frame:GetChild("SNIPER");    
    local screen_width = option.GetClientWidth();
	local screen_height = option.GetClientHeight();    
    if g_screen_width == nil then g_screen_width = screen_width end
    if g_screen_height == nil then g_screen_height = screen_height end    
    local re_create_controlset = false
    if g_screen_width ~= screen_width or g_screen_height ~= screen_height then re_create_controlset = true end
    g_screen_width = screen_width
    g_screen_height = screen_height    
    local x_size = 8
    local ratio = screen_width / screen_height    
    if ratio > 2 then x_size = 12 end
    
    if re_create_controlset == true then 
        DESTROY_CHILD_BYNAME(frame, 'POSTEXT')    
        DESTROY_CHILD_BYNAME(frame, 'SNIPER')    
        child = nil
    end
    
	if child == nil then        
		local skinSize = ui.GetSkinImageSize("snipe_center");	
		child = frame:CreateControl("groupbox", "SNIPER", 0, 0, screen_width * 2 + skinSize.x * x_size, screen_height * 8 + skinSize.y * 4);
		child:SetSkinName("None");        
		local createX = 16 + x_size - 2
		local createY = 14        
		for i = 0 , createX - 1 do
			for j = 0 , createY - 1 do
				local x = i * skinSize.x;
				local y = j * skinSize.y;
				local childName = "PIC_" .. i .. "_" .. j;
				local pic = child:CreateControl("picture", childName, x, y, skinSize.x, skinSize.y);
				AUTO_CAST(pic);
				if i == math.floor(createX / 2) and j == math.floor(createY / 2) then
					local centerOffsetX = x + skinSize.x * 1.5;
					local centerOffsetY = y + skinSize.y * 0.75;
					child:SetUserValue("CENTER_X", centerOffsetX / 2);
					child:SetUserValue("CENTER_Y", centerOffsetY / 2);
					pic:SetImage("snipe_center");
					child:SetUserValue("CENTERNAME", childName);
					centerX = x;
					centerY = y;
				else
					pic:SetImage("snipe_bg");
				end
			end
		end
		local text = child:CreateControl("richtext", "POSTEXT", centerX + skinSize.x - 60, centerY + skinSize.y - 50, 300, 20);
	    text:SetText("{#FF0000}1313");        
	    text:RunUpdateScript("AUTOCHANGETEXT");
    else
        local text = child:GetChild("POSTEXT")
	    text:SetText("{#FF0000}1313");        
	    text:RunUpdateScript("AUTOCHANGETEXT");
	end	
    
	child:ShowWindow(1);
	UI_PLAYFORCE(frame, "appearWithAlpha");
	
	if sx == nil then        
		SNIPE_SETPOS(child, screen_width / 2, screen_height / 2);
	else
		local pt = frame:ScreenPosToFramePos(sx, sy);        
		SNIPE_SETPOS(child, pt.x, pt.y);
	end

	child:RunUpdateScript("UPDATE_SNIPE_POSITION",  0.01, 0.0, 0, 1);
end

function AUTOCHANGETEXT(ctrl)    
	local x, y = GET_CURRENT_SNIPE_POS();
	local text = "{#FF0000}" .. x .. ", " .. y;
	ctrl:SetText(text);
	return 1;
end
					

function UPDATE_SNIPE_POSITION(child, totalTime, elapsedTime)
	if session.config.IsMouseMode() == true then
		local x, y = GET_MOUSE_POS();
		local frame = child:GetTopParentFrame();
		local pt = frame:ScreenPosToFramePos(x, y);
		SNIPE_SETPOS(child, pt.x, pt.y);
		return 1;
	end

	local x = tonumber(child:GetUserValue("CURX"));
	local y = tonumber(child:GetUserValue("CURY"));
    
    local pivot = 1920
    local ratio = option.GetClientHeight() / option.GetClientWidth()
    local ratio_x = option.GetClientWidth() / option.GetClientHeight()

    local childName = child:GetUserValue("CENTERNAME");
	local centerChild = child:GetChild(childName);
	local x1 = centerChild:GetGlobalX() + centerChild:GetWidth() * 0.5;
	local y1 = centerChild:GetGlobalY() + centerChild:GetHeight() * 0.5;
	local pos = ui.GetFrame("uieffect"):FramePosToScreenPos(x1, y1)
    
    if option.GetClientWidth() > 1920 then pivot = option.GetClientWidth() end
    
    local height = pivot * ratio
    local _pos = ui.GetFrame("uieffect"):ScreenPosToFramePos(pivot, height)
    if pos.x >= pivot then
        x = _pos.x
    end
	
    if pos.y >= height then y = _pos.y end
    
	local spd = 1000 * elapsedTime;
	local changed = false;
	if true == imcinput.HotKey.IsPress("MoveLeft") then
			x = x - spd;
			changed = true;
	end
	
	if true == imcinput.HotKey.IsPress("MoveRight") then
			x = x + spd;
			changed = true;
	end

	if true == imcinput.HotKey.IsPress("MoveUp") then
			y = y - spd;
			changed = true;
	end
	
	if true == imcinput.HotKey.IsPress("MoveDown") then
			y = y + spd;
			changed = true;
	end
	
	if changed == true then
		SNIPE_SETPOS(child, x, y);
	end
	
	return 1;
end

function SNIPE_SETPOS(child, x, y)    
	local frame = child:GetTopParentFrame();    
	x = CLAMP(x, 0, frame:GetWidth());
	y = CLAMP(y, 0, frame:GetHeight());
	local child = frame:GetChild("SNIPER");
	child:SetUserValue("CURX", x);
	child:SetUserValue("CURY", y);

	local childName = child:GetUserValue("CENTERNAME");
	local centerChild = child:GetChild(childName);	
	
	local childCenterX = x - centerChild:GetX() - centerChild:GetWidth() * 0.5;
	local childCenterY = y - centerChild:GetY() - centerChild:GetHeight() * 0.5;
	
	child:SetOffset( childCenterX, childCenterY);

end

