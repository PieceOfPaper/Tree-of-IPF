function NOTICE_ON_PC_ON_INIT(addon, frame)
    addon:RegisterMsg("NOTICE_MORINGPONIA_TARGET", "NOTICE_ON_MORINGPONIA_TARGET");
    addon:RegisterMsg("NOTICE_TO_UI", "ON_NOTICE_TO_UI");
end

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

function NOTICE_ON_MORINGPONIA_TARGET(frame, msg, iconName, handle)
    ui.OpenFrame("notice_on_pc");

    if frame == nil then return; end
    frame:SetUserValue("HANDLE", handle);
    frame:SetDuration(2);
    frame:RunUpdateScript("UPDATE_NOTICE_ICON_POS");

    local picture = GET_CHILD_RECURSIVELY(frame, "icon");
    if picture ~= nil then
        picture:SetImage(iconName);
    end
end

function UPDATE_NOTICE_ICON_POS(frame, num)
	frame = tolua.cast(frame, "ui::CFrame");
	local handle = frame:GetUserIValue("HANDLE");
	local point = info.GetPositionInUI(handle, 2);
	local x = point.x - frame:GetWidth() / 2;
	local y = point.y - frame:GetHeight() - 40;
    frame:MoveFrame(x, y);
	return 1;
end

function ON_NOTICE_TO_UI(frame, msg, argStr, argNum)
    local argList = SCR_STRING_CUT(argStr)
    local uiName = argList[1]
    local iconName = argList[2]
    local handle = tonumber(argList[3])

    NOTICE_ON_UI(uiName, iconName, handle, argNum)
end