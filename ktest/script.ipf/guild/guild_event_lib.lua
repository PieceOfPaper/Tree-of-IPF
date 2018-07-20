function GUILDEVENT_SELECT_TYPE(self, pc)
	local guildObj = GetGuildObj(pc)
	local authority = IS_GUILD_AUTHORITY_SERVER(pc, AUTHORITY_GUILD_EVENT)
    local isLeader = IsPartyLeaderPc(guildObj, pc);
    local GuildEventTicketCount = guildObj.GuildEventTicketCount;
    local UsedTicketCount = guildObj.UsedTicketCount;

    if guildObj.TowerLevel < 4 then
        return;
    end

    --[[
	if authority == 0 and isLeader == 0 then	
		SendSysMsg(pc, 'OnlyGuildEventAuthority');
		return;
	end
    --]]

    local flag = IsExistGuildEvent(guildObj); --길드에서 이벤트가 등록되어 있는지 확인 --
	if flag == 1 then
		local select = ShowSelDlg(pc, 0, 'GUILD_EVENT_PROGRESS', ScpArgMsg('Yes'), ScpArgMsg('No'))
		if select == 1 then
		    local eventState = GetGuildEventState(guildObj)
		    if eventState == 'Started' then
		        local eventID = GetGuildEventID(guildObj)
                local eventCls = GetClassByType("GuildEvent", eventID);
                local eventName = TryGetProp(eventCls, "Name");
			    SendSysMsg(pc, "GuildEventStateStartedErrorMsg{EVENT_NAME}", 0, "EVENT_NAME", eventName);
			    return;
			elseif eventState == 'Recruiting' or eventState == 'Waiting' then
			    local eventID = GetGuildEventID(guildObj)
			    CancelGuildEvent(pc)
			    GuildEventMongoLog(pc, eventID, "Cancel", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
			end
			return;
		elseif select == 2 or select == nil then
			return;
		end
	end

	ExecClientScp(pc, "REQ_OPEN_GUILD_EVENT_PIP()");
end

function callback_guild_event_start(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then            
            RunScript('GUILD_EVENT_START_REQUEST', pc, tonumber(argList[1]))
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function SCR_GUILD_EVENT_START_REQUEST(pc, clsID)
    local argList = {}
    argList[1] = tostring(clsID)
    CheckClaim(pc, 'callback_guild_event_start', 401, argList)  -- code:401 (길드 이벤트 시작)    
    --RunScript('GUILD_EVENT_START_REQUEST', pc, tonumber(clsID))
end

function GUILD_EVENT_START_REQUEST(pc, clsID)
    
--    if IsShutDown("ShutDownContent", "Guild") == 1 then
--        SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
--        return;
--    end
--	
	local guildObj = GetGuildObj(pc)

	if guildObj == nil then
		return;
	end
    if guildObj.TowerLevel < 4 then
        return;
    end

	local authority = IS_GUILD_AUTHORITY_SERVER(pc, AUTHORITY_GUILD_EVENT) --길드 이벤트 시작 권한 체크 --
    local isLeader = IsPartyLeaderPc(guildObj, pc);
    
    --[[
	if authority == 0 and isLeader == 0 then	
		SendSysMsg(pc, 'OnlyGuildEventAuthority');
		return;
	end
    --]]

	local cls = GetClassByType("GuildEvent", clsID);
	
	if guildObj.Level < cls.GuildLv then
		return;
	end
    
	local haveTicket = GET_REMAIN_TICKET_COUNT(guildObj)
	if haveTicket <= 0 then
		return;
	end

    if StartGuildEventRecruiting(pc, clsID) ~= 1 then
        return;
    end

    local GuildEventTicketCount = guildObj.GuildEventTicketCount;
    local UsedTicketCount = guildObj.UsedTicketCount;

    local str, mapID = GUILD_EVENT_START_MAP_ON_LOCATION(pc, guildObj)

    BroadcastAddOnMsgToParty(guildObj, "GUILD_EVENT_WAITING_LOCATION", str, mapID, 0);
	GuildEventMongoLog(pc, eventID, "Recruiting", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
end

function GUILD_EVENT_IN_START_MAP_ON_WAITING(pc, eventID)
    local clsList, cnt = GetClassList('GuildEvent')
    if cnt > 0 then
    local warpList = {}
        for i = 0, cnt - 1 do
            warpList[i] = GetClassByIndexFromList(clsList, i)
            local startWarp = warpList[i].StartWarp
    		if isHideNPC(pc, startWarp) == "NO" then
                HideNPC(pc, startWarp);
    		end
    	end
	end

    local eventCls = GetClassByType("GuildEvent", eventID);
    local startWarp = TryGetProp(eventCls, "StartWarp");
    if startWarp == nil then
        return;
    end
    if isHideNPC(pc, startWarp) == 'YES' then
        UnHideNPC(pc, startWarp);
    end   
end

function GUILD_EVENT_PROPERTY_RESET(pc, guildObj)
	if guildObj == nil then
		return;
	end
	
    local clsList, cnt = GetClassList('GuildEvent')
    if cnt > 0 then
    local warpList = {}
        for i = 0, cnt - 1 do
            warpList[i] = GetClassByIndexFromList(clsList, i)
            local startWarp = warpList[i].StartWarp
    		if isHideNPC(pc, startWarp) == "NO" then
                HideNPC(pc, startWarp);
    		end
    	end
	end
end

function GUILD_EVENT_START_MAP_ON_LOCATION(pc, guildObj)
    
	local eventID = GetGuildEventID(guildObj)
	if eventID == nil then
	    return;
	end

	local eventCls = GetClassByNumProp('GuildEvent', 'ClassID', eventID);
	local eventType = TryGetProp(eventCls, "EventType");
	local startWarp = TryGetProp(eventCls, "StartWarp");
    local mapName = TryGetProp(eventCls, "StartMap");
	local mapCls = GetClassByStrProp("Map","ClassName" ,mapName);
    local idSpace = 'GenType_'..mapName
    local mapObj
    if eventType == 'MISSION' then
        mapObj = GetClassByStrProp(idSpace, 'Enter', startWarp)
    elseif eventType == 'FBOSS' then
        mapObj = GetClassByStrProp(idSpace, 'Dialog', startWarp)
    end

    local str = GET_GUILD_EVENT_WAITING_POSITION_STR( mapCls.ClassID, mapObj.GenType, 0);
    SendAddOnMsg(pc, "GUILD_EVENT_WAITING_LOCATION", str, mapCls.ClassID);
    
    return str, mapCls.ClassID;
end

function SCR_GUILD_EVENT_ENTER_CHECK(self, pc)
    if self == nil or pc == nil then
        return;
    end

    local guildObj = GetGuildObj(pc)
    if guildObj == nil then
        return;
    end

    local existGuildEvent = IsExistGuildEvent(guildObj)     --길드가 이벤트 중인지 체크 --
    if existGuildEvent ~= 1 then
        return;
    end
    
    -- local GuildEventParticipant = IsGuildEventParticipant(pc)   --PC가 길드 이벤트 참가중인지 체크 --
    -- if GuildEventParticipant ~= 1 then
    --     return;
    -- end
    
    local eventID = GetGuildEventID(guildObj)
    local zoneInst = GetZoneInstID(pc);
    local eventCls = GetClassByType("GuildEvent", eventID);
    local minigame = TryGetProp(eventCls, "MGame");
    local eventType = TryGetProp(eventCls, "EventType");
    local GuildEventTicketCount = guildObj.GuildEventTicketCount;
    local UsedTicketCount = guildObj.UsedTicketCount;
    local authority = IS_GUILD_AUTHORITY_SERVER(pc, AUTHORITY_GUILD_EVENT ) -- 길드 입장 권한이 있는지 체크 --
    local isLeader = IsPartyLeaderPc(guildObj, pc);
    local eventName = TryGetProp(eventCls, "Name");
    local guildID = GetIESID(guildObj) -- 길드 아이디도 받아두자--
    local GuildEventParticipant = IsGuildEventParticipant(pc)   --PC가 길드 이벤트 참가중인지 체크 --

    if GetGuildEventState(guildObj) == "Recruiting" then
        SendSysMsg(pc, 'GuildEventNotStarted');
    end

    if GetGuildEventState(guildObj) == "Waiting" then
        if GuildEventParticipant ~= 1 and isLeader == 0 then -- 참가 중인지 체크 --
            SendSysMsg(pc, 'doNotJoinGuildEvent');
            return;
        elseif authority == 0 and isLeader == 0 then
            SendSysMsg(pc, 'GuildEventNotStarted');
            return;
        end
        
        local select = ShowSelDlg(pc,0, 'GUILD_EVENT_START_SELECT_1', ScpArgMsg("Yes"), ScpArgMsg("No"))
        if select == 2 or select == nil then
		    return;
	    elseif select == 1 then
	        if GetGuildEventState(guildObj) == "Started" then -- 동시에 시작하는 일을 막기 위해 한번 더 State 를 확인 --
	            SendSysMsg(pc, 'GuildEventStarted');
	            return;
	        end
	        if eventType == 'FBOSS' then
    	        local layer = GetNewLayerByZoneID(zoneInst)
                SetLayer(pc, layer, 0)
                RunMGameWithPartyID(pc, minigame, PARTY_GUILD);
                if StartGuildEventPlayBossHunting(pc, layer) ~= 1 then
                    return;
                end
                GuildEventMongoLog(pc, eventID, "Started", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount) 
            elseif eventType == 'MISSION' then
                local openedMission, alreadyJoin,numArgOpenParty, missionInst  = OpenPartyMission(pc, pc, 0, eventCls.MGame, "", 1, PARTY_GUILD);
                if StartGuildEventPlayMission(pc, missionInst) ~= 1 then
                    return;
                end
                GuildEventMongoLog(pc, eventID, "Started", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
    	        ReqMoveToMission(pc, openedMission);
            else
                return;
            end
	    end
    elseif GetGuildEventState(guildObj) == "Started" then
        if GuildEventParticipant ~= 1 and isLeader == 0 then -- 참가 중인지 체크 --
            local select = ShowSelDlg(pc, 0, 'GUILD_EVENT_START_SELECT_2', ScpArgMsg("Yes"), ScpArgMsg("No")) -- 참가 중이 아니면 취소만 할수 있슴 --
            if select == 2 or select == nil then
                return
            elseif select == 1 then
                FailGuildEvent(guildObj)
                local cancelMsg = ScpArgMsg("GuildEvent{GuildEvent}Cancel", "GuildEvent", eventName);
    	        BroadcastToPartyMember(PARTY_GUILD, guildID, cancelMsg, "");
                GuildEventMongoLog(pc, eventID, "Error", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
                return
            end
        end

        local select = ShowSelDlg(pc, 0, 'GUILD_EVENT_START_SELECT_1', ScpArgMsg("Yes"), ScpArgMsg("No"))
        if select == 2 or select == nil then
		    return;
	    elseif select == 1 then
	        if GetGuildEventState(guildObj) ~= "Started" then
	            return;
	        end
	        if eventType == 'FBOSS' then
                local fbossInstStr, layer = GetGuildEventBossHuntingLayer(pc)
                fbossInst = tonumber(fbossInstStr);
                if SCR_GUILD_EVENT_FBOSS_VERITFY(pc) ~= 1 then
                    local selectCancel = ShowSelDlg(pc, 0, 'GUILD_EVENT_START_SELECT_3', ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if selectCancel == 2 or selectCancel == nil then
                        return;
                    else
                        FailGuildEvent(guildObj)
                        local cancelMsg = ScpArgMsg("GuildEvent{GuildEvent}Cancel", "GuildEvent", eventName);
                        BroadcastToPartyMember(PARTY_GUILD, guildID, cancelMsg, "");
                        GuildEventMongoLog(pc, eventID, "Error", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
                        return
                    end
                end
                
                if zoneInst == fbossInst then
                    if GuildEventParticipant ~= 1 and isLeader == 0 then
                        SendSysMsg(pc, 'doNotJoinGuildEvent');
                        return;
                    end
                    GuildEventMongoLog(pc, eventID, "Enter")
                    SetLayer(pc, layer, 0)
                else -- 만약 다른 채널에서 입장을 시도할 경우 --
                    local channel = GetMyChannel(fbossInst)
                    local x, y, z = GetPos(pc)
                    local mapName = TryGetProp(eventCls, "StartMap");
                    if GuildEventParticipant ~= 1 and isLeader == 0 then
                        SendSysMsg(pc, 'doNotJoinGuildEvent');
                        return;
                    end
                    MoveZone(pc, mapName, x, y, z, nil, channel)
                    GuildEventMongoLog(pc, eventID, "Enter")
                    SetLayer(pc, layer, 0)
                end
            elseif eventType == 'MISSION' then
            	local missionInstID = GetGuildEventMissionInstID(pc)
            	local openedMission, alreadyJoin = OpenPartyMission(pc, pc, 0, eventCls.MGame, "", 1, PARTY_GUILD);
            	GuildEventMongoLog(pc, eventID, "Enter", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
            	ReqMoveToMission(pc, openedMission);
            end
        end
    end
    return;    
end

function GET_GUILD_EVENT_WAITING_POSITION_STR(mapID, genType, genListIndex)
    local x, y, z = GetPartyQuestPosition(mapID, genType, genListIndex);
	local str = string.format("%f;%f;%f;", x, y, z);
    return str;
end

function SCR_GUILD_EVENT_GIVE_ITEM_LIST(pc, eventCls)

    local itemlist = {}
    local itemcount = {}
    local clslist, cnt = GetClassList("reward_guildevent");
    for i = 0, cnt-1 do
        local rewardcls = GetClassByIndexFromList(clslist, i)
        if TryGetProp(rewardcls, "ClassName") == eventCls.ClassName then
            local logic = TryGetProp(rewardcls, "GiveItemSystem")
            if logic == "EACH" then
                for i = 1, 10 do
                    local item = rewardcls["ItemName"..i]
                    if item == "None" or item == nil then
                        break;
                    end
                    local ratio = rewardcls["ItemRatio"..i]
                    if ratio == 0 or ratio == nil then
                        break;
                    end
                    if ratio >= IMCRandom(1, 10000) then
                        local count = rewardcls["ItemCount"..i]
                        table.insert(itemlist, 1, item)
                        table.insert(itemcount, 1, count)
                    end
                end
            elseif logic == "ALL" then
                local totalRatio = 0
                for i = 1, 10 do
                    local ratio = TryGetProp(rewardcls, "ItemRatio"..i);
                    if ratio == 0 or ratio == nil then
                        break;
                    end
                    totalRatio = totalRatio + ratio
                end
                local ratio = IMCRandom(1, totalRatio)
                local totalitemratio = 0;
                for j = 1, 10 do
                    local itemRatio = TryGetProp(rewardcls, "ItemRatio"..j);
                    totalitemratio = totalitemratio + itemRatio
                    if totalitemratio >= ratio then
                        local count = rewardcls["ItemCount"..j]
                        local item = rewardcls["ItemName"..j]
                        table.insert(itemlist, 1, item)
                        table.insert(itemcount, 1, count)
                        break
                    end
                end
            end
        end
    end
    return itemlist, itemcount
end

function SCR_GUILD_EVENT_STAYED_MONGOLOG(pc, guildObj)
    local eventID = GetGuildEventID(guildObj)
    GuildEventMongoLog(pc, eventID, "Stayed")
end

function SCR_GUILD_EVENT_FAIL_MONGOLOG(guildObj)
    local guildID = GetIESID(guildObj)
    local eventID = GetGuildEventID(guildObj)
    local GuildEventTicketCount = guildObj.GuildEventTicketCount;
    local UsedTicketCount = guildObj.UsedTicketCount;
    
    GuildEventMongoLogWithoutPC(guildID, eventID, "Fail", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
    FailGuildEvent(guildObj)	
end

function SCR_GUILD_EVENT_REWARD_CHECK_MONGOLOG(guildObj, pc)
    local guildID = GetIESID(guildObj)
    local eventID = GetGuildEventID(guildObj)
    
    if pc == nil then
        GuildEventMongoLogWithoutPC(guildID, eventID, "REWARD_CHECK_NIL")
        return
    end
    
    GuildEventMongoLog(pc, eventID, "REWARD_CHECK_PC")
end

function SCR_GUILD_EVENT_FBOSS_VERITFY(pc)
    local fbossInstStr, layer = GetGuildEventBossHuntingLayer(pc)
    local guildObj = GetGuildObj(pc)
    fbossInst = tonumber(fbossInstStr);
    if zoneInst == fbossInst then
        local list, cnt = GetLayerPCList(fbossInst, layer)
        local guildMember  = 0;
        if cnt <= 0 or cnt == nil then
            return 0;
        else
            for i = 1, cnt do
                local targetGuild = GetGuildObj(list[i])
                if guildObj == targetGuild then
                    guildMember = guildMember + 1
                end
            end
            if guildMember >= 1 then
                local monList, monCnt = GetLayerMonList(fbossInst, layer)
                if monCnt >= 1 or monCnt ~= nil then
                    return 1;
                end
            end
            return 0;
        end
    end
    return 0;
end