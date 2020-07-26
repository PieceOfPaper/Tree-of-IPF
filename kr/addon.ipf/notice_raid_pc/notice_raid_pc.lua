function NOTICE_RAID_PC_ON_INIT(addon, frame)
    addon:RegisterMsg("NOTICE_GLACIER_COLD_BALST", "ON_NOTICE_RAID_TO_UI");
    addon:RegisterMsg("NOTICE_GLACIER_ENCHANTMENT", "ON_NOTICE_RAID_TO_UI");
    addon:RegisterMsg("NOTICE_GLACIER_ENCHANTMENT_LEGEND", "ON_NOTICE_RAID_TO_UI");
    NOTICE_RAID_PC_SET_VISIBLE(frame, 0);
end

function ON_NOTICE_RAID_TO_UI(frame, msg, argStr, argNum)
    if msg == "NOTICE_GLACIER_COLD_BALST" then
        local iconName = argStr;
        local handle = tonumber(argNum);
        if handle ~= 0 then
            frame:SetUserValue("SUFFIX", handle);
        end
        local uiName = "notice_raid_pc"..frame:GetUserValue("SUFFIX");
        NOTICE_RAID_GLACIER_COLD_BLAST_TARGET(uiName, msg, iconName, handle);
    elseif msg == "NOTICE_GLACIER_ENCHANTMENT" then
        local curTime = tonumber(argNum);
        local handle = tonumber(argStr);
        if handle ~= 0 then
            frame:SetUserValue("SUFFIX", handle);
        end
        local uiName = "notice_raid_pc"..frame:GetUserValue("SUFFIX");
        NOTICE_RAID_GLACIER_ENCHANTMENT_TARGET(uiName, msg, handle, curTime);
    elseif msg == "NOTICE_GLACIER_ENCHANTMENT_LEGEND" then
        local curTime = tonumber(argNum);
        local handle = tonumber(argStr);
        if handle ~= 0 then
            frame:SetUserValue("SUFFIX", handle);
        end
        local uiName = "notice_raid_pc"..frame:GetUserValue("SUFFIX");
        NOTICE_RAID_GLACIER_ENCHANTMENT_TARGET_LEGEND(uiName, msg, handle, curTime);
    end
end

function NOTICE_RAID_GLACIER_COLD_BLAST_TARGET(uiName, msg, iconName, handle)
    local frame = ui.GetFrame(uiName);
    if frame == nil then 
        frame = ui.CreateNewFrame("notice_raid_pc", tostring(uiName));
    end

    local picture = GET_CHILD_RECURSIVELY(frame, "icon");
    if picture ~= nil then
        if handle == 0 then
            picture:Resize(0, 0);
            frame:SetUserValue(msg, 0);
            local name = frame:GetUserValue("COLD_BALST_UI_NAME");
            ui.CloseFrame(name);        
        else
            local width = tonumber(frame:GetUserConfig("COLD_BLAST_ICON_WIDTH"));
            local height = tonumber(frame:GetUserConfig("COLD_BLAST_ICON_HEIGHT"));
            picture:Resize(width, height);
            frame:SetUserValue(msg, 1);
            frame:SetUserValue("HANDLE", handle);
            frame:SetUserValue("COLD_BALST_UI_NAME", uiName);
            frame:RunUpdateScript("UPDATE_NOTICE_RAID_ICON_POS");
        end

        picture:SetImage(iconName);
        picture:SetVisible(1);
    end

    local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
    if gbox ~= nil then
        local startx = 0;
        local enchantmentMsgValue = frame:GetUserIValue("NOTICE_GLACIER_ENCHANTMENT");
        if enchantmentMsgValue == 1 then
            local coupleStartX = tonumber(frame:GetUserConfig("COUPLE_ICON_START_X"));
            startx = coupleStartX;
        else
            local gauge = GET_CHILD_RECURSIVELY(frame, "icon_gauge");
            if gauge ~= nil then
                gauge:SetVisible(0);
            end

            local singleStartX = tonumber(frame:GetUserConfig("SINGLE_ICON_START_X"));
            startx = singleStartX;
        end
        BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, startx, 0, 0, 200, true, 0, false);
        gbox:Invalidate();
    end
end

function NOTICE_RAID_GLACIER_ENCHANTMENT_TARGET(uiName, msg, handle, curTime)
    local frame = ui.GetFrame(uiName);
    if frame == nil then 
        frame = ui.CreateNewFrame("notice_raid_pc", tostring(uiName));
    end
    
    local gauge = GET_CHILD_RECURSIVELY(frame, "icon_gauge");
    if gauge ~= nil then
        handle = tonumber(handle);
        if handle == 0 then
            gauge:Resize(0, 0);
            frame:SetUserValue(msg, 0);
            local name = frame:GetUserValue("ENCHANTMENT_UI_NAME");
            ui.CloseFrame(name); 
        else
            local width = tonumber(frame:GetUserConfig("ENCHANTMENT_ICON_WIDTH"));
            local height = tonumber(frame:GetUserConfig("ENCHANTMENT_ICON_HEIGHT"));
            gauge:Resize(width, height);
            frame:SetUserValue(msg, 1);
            frame:SetUserValue("HANDLE", handle);
            frame:SetUserValue("ENCHANTMENT_UI_NAME", uiName);
            frame:RunUpdateScript("UPDATE_NOTICE_RAID_ICON_POS");
        end

        gauge = tolua.cast(gauge, "ui::CGauge");
        gauge:SetMaxPointWithTime(curTime, 5, 1);
        gauge:SetVisible(1);
    end

    local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
    if gbox ~= nil then
        local startx = 0;
        local coldBlastMsgValue = frame:GetUserIValue("NOTICE_GLACIER_COLD_BALST");
        if coldBlastMsgValue == 1 then
            local coupleStartX = tonumber(frame:GetUserConfig("COUPLE_ICON_START_X"));
            startx = coupleStartX;
        else
            local picture = GET_CHILD_RECURSIVELY(frame, "icon");
            if picture ~= nil then
                picture:SetVisible(0);
            end

            local singleStartX = tonumber(frame:GetUserConfig("SINGLE_ICON_START_X"));
            startx = singleStartX - 55;        
        end
        BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, startx, 0, 0, 200, true, 0, false);
        gbox:Invalidate();
    end
end

function NOTICE_RAID_GLACIER_ENCHANTMENT_TARGET_LEGEND(uiName, msg, handle, curTime)
    local frame = ui.GetFrame(uiName);
    if frame == nil then 
        frame = ui.CreateNewFrame("notice_raid_pc", tostring(uiName));
    end
    
    local gauge = GET_CHILD_RECURSIVELY(frame, "icon_gauge");
    if gauge ~= nil then
        handle = tonumber(handle);
        if handle == 0 then
            gauge:Resize(0, 0);
            frame:SetUserValue(msg, 0);
            local name = frame:GetUserValue("ENCHANTMENT_UI_NAME");
            ui.CloseFrame(name); 
        else
            local width = tonumber(frame:GetUserConfig("ENCHANTMENT_ICON_WIDTH"));
            local height = tonumber(frame:GetUserConfig("ENCHANTMENT_ICON_HEIGHT"));
            gauge:Resize(width, height);
            frame:SetUserValue(msg, 1);
            frame:SetUserValue("HANDLE", handle);
            frame:SetUserValue("ENCHANTMENT_UI_NAME", uiName);
            frame:RunUpdateScript("UPDATE_NOTICE_RAID_ICON_POS");
        end

        gauge = tolua.cast(gauge, "ui::CGauge");
        gauge:SetMaxPointWithTime(curTime, 3, 1);
        gauge:SetVisible(1);
    end

    local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
    if gbox ~= nil then
        local startx = 0;
        local coldBlastMsgValue = frame:GetUserIValue("NOTICE_GLACIER_COLD_BALST");
        if coldBlastMsgValue == 1 then
            local coupleStartX = tonumber(frame:GetUserConfig("COUPLE_ICON_START_X"));
            startx = coupleStartX;
        else
            local picture = GET_CHILD_RECURSIVELY(frame, "icon");
            if picture ~= nil then
                picture:SetVisible(0);
            end

            local singleStartX = tonumber(frame:GetUserConfig("SINGLE_ICON_START_X"));
            startx = singleStartX - 55;        
        end
        BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, startx, 0, 0, 200, true, 0, false);
        gbox:Invalidate();
    end
end

--------------------------------------------------------------------------------
function NOTICE_RAID_PC_SET_VISIBLE(frame, visible)
    if frame == nil then return; end
    local picture = GET_CHILD_RECURSIVELY(frame, "icon");
    if picture ~= nil then
        picture:SetVisible(visible);
    end

    local gauge = GET_CHILD_RECURSIVELY(frame, "icon_gauge");
    if gauge ~= nil then
        gauge:SetVisible(visible);
    end
end

function UPDATE_NOTICE_RAID_ICON_POS(frame, num)
	frame = tolua.cast(frame, "ui::CFrame");
    local handle = frame:GetUserIValue("HANDLE");
    if tonumber(handle) == 0 then
        return 0;
    end

	local point = info.GetPositionInUI(handle, 2);
	local x = point.x - frame:GetWidth() / 2;
	local y = point.y - frame:GetHeight() - 40;
    frame:MoveFrame(x, y);
	return 1;
end