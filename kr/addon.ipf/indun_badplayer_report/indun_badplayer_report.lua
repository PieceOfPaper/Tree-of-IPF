function INDUN_BADPLAYER_REPORT_ON_INIT(addon, frame)
end

function SHOW_INDUN_BADPLAYER_REPORT(aid, serverName, playerName)
    if IsBuffApplied(GetMyPCObject(), "System_IndunBadPlayerReporter") == "YES" then
        ui.SysMsg(ClMsg("AlreadyReported_IndunBadPlayer"));
        return;
    end

    local frame = ui.GetFrame("indun_badplayer_report");
    frame:ShowWindow(1);
    
    local gboxBadPlayerInfo = frame:GetChild("gboxBadPlayerInfo");
    local badplayer_server_value = gboxBadPlayerInfo:GetChild("badplayer_server_value");
    local badplayer_name_value = gboxBadPlayerInfo:GetChild("badplayer_name_value");
    
    badplayer_server_value:SetTextByKey("value", serverName);
    badplayer_name_value:SetTextByKey("value", playerName);
    badplayer_name_value:SetUserValue("BadPlayerAID", aid);

    local gboxReason = frame:GetChild("gboxReason");
    local curReason_value = gboxReason:GetChild("curReason_value");
    
    curReason_value:SetTextByKey("value", ClMsg("IndunBadPlayerReport_Reason_Trolling"));
    curReason_value:SetUserValue("BadPlayer_Report_Reason", "IndunBadPlayerReport_Reason_Trolling");
end

function POPUP_REPORT_REASON_LIST(parent)
    local frame = parent:GetTopParentFrame();
    local gboxReason = frame:GetChild("gboxReason");
    local ctrl = gboxReason:GetChild("btn");
    local dropListFrame = ui.MakeDropListFrame(parent, 0, 0, gboxReason:GetWidth(), 200, 3, ui.LEFT, "SELECT_INDUN_BADPLAYER_REPORT_REASON", nil, nil);
    
    ui.AddDropListItem(ClMsg("IndunBadPlayerReport_Reason_Trolling"), "", "IndunBadPlayerReport_Reason_Trolling");
    ui.AddDropListItem(ClMsg("IndunBadPlayerReport_Reason_Abusive"), "", "IndunBadPlayerReport_Reason_Abusive");
    ui.AddDropListItem(ClMsg("IndunBadPlayerReport_Reason_Etc"), "", "IndunBadPlayerReport_Reason_Etc");
    
end

function SELECT_INDUN_BADPLAYER_REPORT_REASON(index, reasonID)
    local frame = ui.GetFrame("indun_badplayer_report");
    local gboxReason = frame:GetChild("gboxReason");
    local curReason_value = gboxReason:GetChild("curReason_value");
    
    curReason_value:SetTextByKey("value", ClMsg(reasonID));
    curReason_value:SetUserValue("BadPlayer_Report_Reason", reasonID);
end

function SEND_INDUN_BADPLAYER_REPORT()
    local frame = ui.GetFrame("indun_badplayer_report");
    
    local gboxBadPlayerInfo = frame:GetChild("gboxBadPlayerInfo");
    local badplayer_name_value = gboxBadPlayerInfo:GetChild("badplayer_name_value");

    local aid = badplayer_name_value:GetUserValue("BadPlayerAID");
    local playerName = badplayer_name_value:GetTextByKey("value");
    
    local gboxReason = frame:GetChild("gboxReason");
    local curReason_value = gboxReason:GetChild("curReason_value");
    
    local reason = curReason_value:GetUserValue("BadPlayer_Report_Reason");

    packet.SendIndunBadPlayerReport(aid, playerName, reason);
    
    frame:ShowWindow(0);
end

function CANCEL_INDUN_BADPLAYER_REPORT()
    local frame = ui.GetFrame("indun_badplayer_report");
    frame:ShowWindow(0);
end