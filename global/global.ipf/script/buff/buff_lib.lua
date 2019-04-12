function STEAM_BUFF_ON_ZONE_ENTER(pc) -- steam event friends --
    local myAID = GetPcAIDStr(pc);
    local teamNameLog = GetTeamName(pc);
    local oldAID, newAID, error, isOnline, teamName, maxAIDlevel = GetSteamPair(pc)
    
    if error ~= 0 then
        return
    end
    if IsBuffApplied(pc, 'Event_Steam_Friend_Rookie') == 'NO' and myAID == newAID then
        AddBuff(pc, pc, 'Event_Steam_Friend_Rookie', 1, 0, 86400000, 1)
        SysMsg(pc, "Instant", ScpArgMsg("EVENT_STEAM_EVENT_INVITE_FRIEND_SEL4", 'team', teamName));
    elseif IsBuffApplied(pc, 'Event_Steam_Friend_Savior') == 'NO' and myAID == oldAID then
        AddBuff(pc, pc, 'Event_Steam_Friend_Savior', 1, 0, 86400000, 1)
        SysMsg(pc, "Instant", ScpArgMsg("EVENT_STEAM_EVENT_INVITE_FRIEND_SEL4", 'team', teamName));
    end
    --SetTitle(pc, "이 유저는 친구가 있어요!")
end

function STEAM_BUFF_ON_DISCONNECT(pc)  -- steam event friends --
    --SetTitle(pc, "이 유저의 친구가 나갔어요!")
end