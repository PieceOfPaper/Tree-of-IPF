function NOTICE_ON_UI(uiName, iconName, handle, duration)
    local frame = ui.GetFrame(uiName);
    if frame == nil then
        frame = ui.CreateNewFrame("notice_on_pc", uiName);
    end
    if duration == 0 then
       ui.CloseFrame(uiName) 
       return;
    end
    frame:SetUserValue("HANDLE", handle);
    frame:SetDuration(duration)
    frame:RunUpdateScript("UPDATE_NOTICE_ICON_POS");
    local picture = GET_CHILD(frame, "icon", "ui::CPicture");
    picture:SetImage(iconName)
end

function UPDATE_NOTICE_ICON_POS(frame)
	frame = tolua.cast(frame, "ui::CFrame");
	local handle = frame:GetUserIValue("HANDLE");
	local point = info.GetPositionInUI(handle, 2);
	local x = point.x - frame:GetWidth() / 2;
	local y = point.y - frame:GetHeight() - 40;
    frame:MoveFrame(x, y);
	return 1;
end
