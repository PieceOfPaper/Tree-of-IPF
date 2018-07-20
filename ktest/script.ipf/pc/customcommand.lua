function SCR_REFUSE_FEVENT(pc, arg)


	if arg == 1 then
		local curDate = GetCurDateNumber();
		pc.FEventRefuse = curDate;
	else
		pc.FEventRefuse = 0;
	end

end

function SCR_VIEW_LIKE_LIST(pc, handle, page)

	local zoneInst = GetZoneInstID(pc);
	local mon = GetSprayMonster(zoneInst, handle);
	if mon == nil then
		return;
	end

	SendLikeList(pc, mon, page);

end


function SCR_PARTY_ITEM_CHANGE(pc, arg)

	local partyObj = GetPartyObj(pc, 0);
	local myMem = GetMemberObj(partyObj, pc.Name);
	if IsPartyLeaderPc(partyObj, pc) == 0 then
		SendSysMsg(pc, "OnlyLeaderAbleToDoThis");
		return;
	end

	ChangePartyProp(pc, PARTY_NORMAL, "Item", arg);

end

function SCR_PARTY_R_ITEM_CHANGE(pc, arg)

	local partyObj = GetPartyObj(pc, 0);
	local myMem = GetMemberObj(partyObj, pc.Name);
	if IsPartyLeaderPc(partyObj, pc) == 0 then
		SendSysMsg(pc, "OnlyLeaderAbleToDoThis");
		return;
	end

	ChangePartyProp(pc, PARTY_NORMAL, "RItem", arg);

end

function SCR_MAP_INTRO_CHECK(pc, mapID)
	local sObj = GetSessionObject(pc, 'ssn_mapintro');
	if sObj == nil then
		RunScript("_SCR_MAP_INTRO_CHECK", pc, mapID);
		return;
	end

	local mapCls = GetClassByType("Map", mapID);
	sObj[mapCls.ClassName] = 1;
	SaveSessionObject(pc, sObj);
end

function _SCR_MAP_INTRO_CHECK(pc, mapID)
	CreateSessionObject(pc, 'ssn_mapintro', 1);
	local sObj = GetSessionObject(pc, 'ssn_mapintro');
	local mapCls = GetClassByType("Map", mapID);
	sObj[mapCls.ClassName] = 1;
	SaveSessionObject(pc, sObj);
end

function SCR_HAT_VISIBLE_STATE(pc, index)

	local pcetc = GetETCObject(pc);

	if pcetc == nil then
		return;
	end

	local indexName = "None";
	if index == 0 then
		indexName = "HAT"
	elseif index == 1 then
		indexName = "HAT_T"
	elseif index == 2 then
		indexName = "HAT_L"
	end

	if indexName == "None" then
		return;
	end

	local indexHATvalue = pcetc[indexName.."_Visible"]

	if indexHATvalue == 1 then
		indexHATvalue = 0
	else
		indexHATvalue = 1
	end

	pcetc[indexName.."_Visible"] = indexHATvalue
	
		BroadcastHatVisible(pc)
	end

function SCR_BROADCAST_HAT_VISIBLE_STATE(pc)
	BroadcastHatVisible(pc)
end

function SCR_HAIR_WIG_VISIBLE_STATE(pc)
	local pcetc = GetETCObject(pc);

	if pcetc == nil then
		return;
	end

	local value = pcetc["HAIR_WIG_Visible"]

	if value == 1 then
		value = 0
	else
		value = 1
	end

	pcetc["HAIR_WIG_Visible"] = value

	BroadcastHairWigVisible(pc)
end