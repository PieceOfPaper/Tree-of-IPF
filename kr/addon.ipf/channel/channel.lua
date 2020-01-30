function CHANNEL_ON_INIT(addon, frame)

    addon:RegisterMsg("ZONE_TRAFFICS", "ON_ZONE_TRAFFICS");

    UPDATE_CURRENT_CHANNEL_TRAFFIC(frame);
end

function UPDATE_CURRENT_CHANNEL_TRAFFIC(frame)
    local curchannel = frame:GetChild("curchannel");

    local channel = session.loginInfo.GetChannel();     
    local zoneInst = session.serverState.GetZoneInst(channel);
    if zoneInst ~= nil then
        local str, stateString = GET_CHANNEL_STRING(zoneInst);
        curchannel:SetTextByKey("value", str .. "                                  " .. stateString);
    else
        curchannel:SetTextByKey("value", "");
    end
end

function POPUP_CHANNEL_LIST(parent)
    if session.colonywar.GetIsColonyWarMap() == true then
        return;
    end
	
	local mapName = session.GetMapName();
	if mapName == 'guild_agit_1' or mapName == 'guild_agit_extension' then
		return;
	end
	
	local housingPlaceClass = GetClass("Housing_Place", mapName);
	if housingPlaceClass ~= nil then
		local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
		if housingPlaceType == "Personal" then
			return;
		end
	end

    if parent:GetUserValue("ISOPENDROPCHANNELLIST") == "YES" then
        parent:SetUserValue("ISOPENDROPCHANNELLIST", "NO");
        return;
    end
    parent:SetUserValue("ISOPENDROPCHANNELLIST", "YES");

    local frame = parent:GetTopParentFrame();
    local ctrl = frame:GetChild("btn");
    local curchannel = frame:GetChild("curchannel");

    local channel = session.loginInfo.GetChannel();     
    
    local dropListFrame = ui.MakeDropListFrame(parent, 0, 0, 300, 600, 10, ui.LEFT, "SELECT_ZONE_MOVE_CHANNEL",nil,nil);
    dropListFrame:SetOverSound("button_cursor_over_2")
    dropListFrame:SetClickSound("button_cursor_over_2")
    
    local zoneInsts = session.serverState.GetMap();

    if zoneInsts == nil then
        app.RequestChannelTraffics();
    else
        if zoneInsts:NeedToCheckUpdate() == true then
            app.RequestChannelTraffics();
        end

        local cnt = zoneInsts:GetZoneInstCount();
        for i = 0  , cnt - 1 do
            local zoneInst = zoneInsts:GetZoneInstByIndex(i);
            local str, gaugeString = GET_CHANNEL_STRING(zoneInst, true);
            ui.AddDropListItem(str, gaugeString, zoneInst.channel);
        end
    end
    
end

function ON_ZONE_TRAFFICS(frame, msg, argStr)
    local dropListFrame = ui.GetDropListFrame("SELECT_ZONE_MOVE_CHANNEL")
    if dropListFrame ~= nil then
        POPUP_CHANNEL_LIST(frame);
    end
    
    UPDATE_CURRENT_CHANNEL_TRAFFIC(frame);

end

function SELECT_ZONE_MOVE_CHANNEL(index, channelID)
    local zoneInsts = session.serverState.GetMap();
    if zoneInsts == nil or zoneInsts.pcCount == -1 then
        ui.SysMsg(ClMsg("ChannelIsClosed"));
        return;
    end
    
    local msg = ScpArgMsg("ReallyMoveToChannel_{Channel}", "Channel", channelID + 1);
    local scpString = string.format("RUN_GAMEEXIT_TIMER(\"Channel\", %d)", channelID);
    ui.MsgBox(msg, scpString, "None");
end

