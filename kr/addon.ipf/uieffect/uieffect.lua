function UIEFFECT_ON_INIT(addon, frame)
	--addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'change_client_size');	
end

function START_SNIPE(sx, sy)    
	ui.OpenFrame("uieffect");
	local frame = ui.GetFrame("uieffect");
	if frame == nil then return; end

	local gb = GET_CHILD_RECURSIVELY(frame, "gb");
	if gb == nil then return; end
    
	local picture = GET_CHILD_RECURSIVELY(gb, "snipecenter");
	if picture ~= nil then 
		picture:SetVisible(1);
		AUTO_CAST(picture);
    end
    
	local skin_size = ui.GetSkinImageSize("snipe_center02");	
	local x = skin_size.x;
	local y = skin_size.y;

	local center_x, center_y;
	local center_x = x - picture:GetX() - picture:GetWidth() * 0.5;
	local center_y = y - picture:GetY() - picture:GetHeight() * 0.5;

	center_x = x;
	center_y = y;

	local text = GET_CHILD_RECURSIVELY(gb, "pos_text");
	if text == nil then
		text = gb:CreateControl("richtext", "pos_text", center_x - 80, center_y - 50, 0, 40);
	    text:SetText("{#FF0000}1313");        
	    text:RunUpdateScript("AUTOCHANGETEXT");
    else
		text = GET_CHILD_RECURSIVELY(gb, "pos_text");
	    text:SetText("{#FF0000}1313");        
	    text:RunUpdateScript("AUTOCHANGETEXT");
	end	
    
	UI_PLAYFORCE(frame, "appearWithAlpha");
	
		local pt = frame:ScreenPosToFramePos(sx, sy);  
	SNIPE_SETPOS(gb, pt.x, pt.y);
end

function END_SNIPE()
	local frame = ui.GetFrame("uieffect");
	local picture = GET_CHILD_RECURSIVELY(frame, "snipecenter");
	if picture ~= nil then 
		picture:SetVisible(0);
	end
	ui.CloseFrame("uieffect");
	end

function GET_CURRENT_SNIPE_POS()    
	local frame = ui.GetFrame("uieffect");
	if frame == nil then return; end

	local gb = GET_CHILD_RECURSIVELY(frame, "gb");
	if gb == nil then return; end
	
	local x = gb:GetUserValue("CURX");
	local y = gb:GetUserValue("CURY");

	local pos = frame:FramePosToScreenPos(x, y)
	return pos.x, pos.y;
end

function AUTOCHANGETEXT(ctrl)    
	local frame = ui.GetFrame("uieffect");
	if frame == nil then return; end

	local gb = GET_CHILD_RECURSIVELY(frame, "gb");
	if gb == nil then return; end
	
	local x = gb:GetUserValue("CURX");
	local y = gb:GetUserValue("CURY");

	local text = "{#FF0000}" .. x .. ", " .. y;
	ctrl:SetText(text);
	return 1;
end

function UPDATE_SNIPE_POSITION(x, y)
	local frame = ui.GetFrame("uieffect");
	if frame == nil then return; end
    
	local gb = GET_CHILD_RECURSIVELY(frame, "gb");
	if gb == nil then return end

	SNIPE_SETPOS(gb, x, y);
end

function SNIPE_SETPOS(gb, x, y)    
	local frame = gb:GetTopParentFrame();
	if frame == nil then return; end

	gb:SetUserValue("CURX", x);
	gb:SetUserValue("CURY", y);
		
	local picture = GET_CHILD_RECURSIVELY(gb, "snipecenter");
	if picture ~= nil then
		frame:MoveFrame(x - picture:GetWidth() * 0.5, y - picture:GetHeight() * 0.5);
	end
end

