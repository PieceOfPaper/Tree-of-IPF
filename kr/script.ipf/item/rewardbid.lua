function CREATE_REWARD_BID_ITEM(guildMember)

	local guildObj = GetGuildObj(guildMember);

	if guildObj == nil then
		print("guild is nil")
	end
    
    local existGuildEvent = IsExistGuildEvent(guildObj)     --길드가 이벤트 중인지 체크
    if existGuildEvent ~= 1 then
        IMC_LOG("INFO_NORMAL"," eventID is 0");
        return;
    end
        
	local eventID = GetGuildEventID(guildObj)
	local eventCls = GetClassByType("GuildEvent", eventID)

	local itemListStr = "";
	local itemCountStr = "";
    
    local listIndex = 0;
    local clslist, cnt = GetClassList("reward_guildevent");
    for i = 0, cnt-1 do
        local rewardcls = GetClassByIndexFromList(clslist, i)
        if TryGetProp(rewardcls, "ClassName") == eventCls.ClassName then
            for i = 1, 5 do
                local item = rewardcls["BidItemName"..i]
                if item == "None" or item == nil then
                    break;
                end
                local ratio = rewardcls["BidItemRatio"..i]
                if ratio == "0" or ratio == nil then
                    break;
                end
                if ratio >= IMCRandom(1, 10000) then
                    local count = rewardcls["BidItemCount"..i]
                    itemListStr = itemListStr..item.."/"
            		itemCountStr = itemCountStr..count.."/"
                end
            end    
        end
    end
    
    if itemListStr == nil or itemCountStr == nil then
        return
    end
    
    SetExProp_Str(guildObj, "bidItemList", itemListStr)
    SetExProp_Str(guildObj, "bidItemCount", itemCountStr)
    
    CustomMongoLog(guildMember, "GuildEvent", "Type", "BidItemReady", "bidItemList", itemListStr, "bidItemCount", itemCountStr)
	SEND_REWARD_BID(guildMember, guildObj)
    
end

function SEND_REWARD_BID(guildMember, guildObj)
	
	if guildObj == nil then
		return;
	end
	
	ChangePartyProp(guildMember, PARTY_GUILD, "RewardBidState", 0)
	
	local itemListStr = GetExProp_Str(guildObj, "bidItemList")
	local itemCountStr = GetExProp_Str(guildObj, "bidItemCount")
	
	local itemList = SCR_STRING_CUT(itemListStr);
	local itemCount = SCR_STRING_CUT(itemCountStr);
	
	-- 더 많은 아이템을 입찰 돌리고 싶으면 RewardBidItemCount 를 1씩 늘려가면서 아이템 리스트 전부를 입찰시키면 됨 --
	local bidCount = guildObj.RewardBidItemCount
	
	if itemList == "None" or itemList == nil then
		return;
	end

	if  GetClass("Item", itemList[bidCount]) == nil then
        return;
    end

	local sysTime = geServerTime.GetStringNowSystemTime();
		
	ChangePartyProp(guildMember, PARTY_GUILD, "RewardBidStartTime", sysTime)


    
    local bidRewardItemCls = GetClass("Item", itemList[bidCount])
    local bidRewardCount = itemCount[bidCount]

	local scp = string.format("UPDATE_REWARD_BID_POPUP(\'%s\', \'%s\')", bidRewardItemCls.ClassID, bidRewardCount);
	
    local eventID = GetGuildEventID(guildObj)
    local eventCls = GetClassByType("GuildEvent", eventID);
	local eventType = TryGetProp(eventCls, "EventType")
	local zoneInst = GetZoneInstID(guildMember);
	
	if eventType == 'FBOSS' then
	    local fbossInstStr, layer = GetGuildEventBossHuntingLayer(guildMember)
	    local fbossInst = tonumber(fbossInstStr)
	    if fbossInst ~= zoneInst then
	        return;
	    end
	    
    	local objList, objCount = GetLayerPCList(zoneInst, layer)
        for i = 1, objCount do
            ExecClientScp(objList[i], scp);
    	end
	elseif eventType == 'MISSION' then
	    local layer = GetWorldLayer(guildMember)
	    local missionInstID = GetGuildEventMissionInstID(guildMember)
	    local instID = tonumber(missionInstID)
    	local objList, objCount = GetLayerPCList(instID, layer)
        for i = 1, objCount do
            ExecClientScp(objList[i], scp);
    	end	
	else
    	return
	end
end

function SCR_REQUEST_ITEM_BID(pc, itemID)
   
	local guildObj = GetGuildObj(pc);

	if guildObj == nil then
		return;
	end
    
    CustomMongoLog(pc, "GuildEvent", "Type", "BidAddMember")
	AddBidList(pc)

end

function SCR_REQUEST_BID_LOTTERY(pc)

	local guildObj = GetGuildObj(pc);
	if guildObj == nil then
		return;
	end
	
	if guildObj.RewardBidState == 1 then
	    return;
	end
	
	ChangePartyProp(pc, PARTY_GUILD, "RewardBidState", 1)
	
	local topUser = nil
	local topScore = 0;
    local scoreList = {}
    local bidRanking = 1;

	local list, cnt = GetBidList(pc)

	if cnt <= 0 then
		return;
	end
    
	for i = 1, cnt do
		local score = IMCRandom(1, 100);
		SetExProp(list[i], "bidScore", score)
        if #scoreList == 0 then
            table.insert(scoreList, 1, list[i])
        elseif #scoreList >= 1 then
            bidRanking = 1;
            for j = 1, #scoreList do
                if score > GetExProp(list[j], "bidScore") then
                    break
                else
                    bidRanking = bidRanking + 1;
                end
            end
            table.insert(scoreList, bidRanking, list[i])
            SetExProp(scoreList[bidRanking], "bidScore", score)
        end
    end

    SCR_REQUEST_BID_TX_ITEMCHECK(pc, scoreList, guildObj, itemCls)
	
	ClearBidList(pc);
end

function TEST_BID(pc)
--AddBidList(pc)
local list, cnt = GetBidList(pc);
	print(list, cnt)
	ClearBidList(pc);
end

function SCR_REQUEST_BID_TX_ITEMCHECK(pc, scoreList, guildObj)

	local itemListStr = GetExProp_Str(guildObj, "bidItemList")
	local itemCountStr = GetExProp_Str(guildObj, "bidItemCount")
	local itemList = SCR_STRING_CUT(itemListStr);
	local itemCount = SCR_STRING_CUT(itemCountStr);
	local bidCount = guildObj.RewardBidItemCount
	local itemCls = GetClass("Item", itemList[bidCount])
	local guildID = GetIESID(guildObj)
	
	for k = 1, #scoreList do
    	local topUser = scoreList[k]
    	local tx = TxBegin(topUser);
    	TxGiveItem(tx, itemCls.ClassName, itemCount[bidCount], "Guild_Event_Bid");
    	local ret = TxCommit(tx);
    	
    	if ret == "SUCCESS" then
    	    local bidItemMsg = ScpArgMsg("GuildMember{Name}TakeItem{ItemName}", "Name", GetTeamName(topUser), "ItemName", itemCls.Name);
    	    BroadcastToPartyMember(PARTY_GUILD, guildID, bidItemMsg, "");
    	    CustomMongoLog(topUser, "GuildEvent", "Type", "BidItemTx", "GuildID", guildID, "GuildLv", guildObj.Level, "RName_"..bidCount, itemCls.ClassName, "RCnt_"..bidCount, itemCount[bidCount])
    	    break;
    	end
    end
end