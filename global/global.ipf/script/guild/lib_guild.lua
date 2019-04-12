function GUILD_EXP_UP(pc, iesID, count)
	
	local partyObj = GetGuildObj(pc);
	if partyObj == nil then
		return;
	end

	local item, cnt = GetInvItemByGuid(pc, iesID);
	local needItem, expPerItem = GET_GUILD_EXPUP_ITEM_INFO();
	if item.ClassName == 'misc_talt_event' then
	    needItem, expPerItem = GET_GUILD_EXPUP_ITEM_INFO2();
	end
	
	if needItem ~= item.ClassName or count > cnt then
		SendSysMsg(pc, "REQUEST_TAKE_ITEM");
		return;
	end
	
	local curExp = partyObj.Exp;
	local addExp = count * expPerItem;
	local nextExp = curExp + addExp;
	local curLevel = partyObj.Level;
	local nextLevel = GET_GUILD_LEVEL_BY_EXP(nextExp);

	if curLevel >= GUILD_MAX_LEVEL then
		SendSysMsg(pc, "CantUseInMaxLv");
		return;
	end

	local teamName = GetTeamName(pc);
	local memberObj = GetMemberObjByPC(partyObj, pc);
	local currentContribution = memberObj.Contribution;
	currentContribution = currentContribution + addExp;
	local tx = TxBegin(pc);
	TxSetPartyMemberProp(tx, PARTY_GUILD, "Contribution", currentContribution)
	TxTakeItemByObject(tx, item, count, "GuildExpUp");
	TxSetPartyProp(tx, PARTY_GUILD, "Exp", nextExp);
	if curLevel ~= nextLevel then
		TxSetPartyProp(tx, PARTY_GUILD, "Level", nextLevel);
	end
   	local ret = TxCommit(tx);

	if ret == "SUCCESS" then
		SendSysMsg(pc, "GuildExpUpSuccessByItem");
	end
	
end