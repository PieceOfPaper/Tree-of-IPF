---- lib_party.lua

function AM_I_LEADER(partyType)
	
	local myAid = session.loginInfo.GetAID();
	
	local pcparty = session.party.GetPartyInfo(partyType);
	if pcparty == nil then
		return 0;
	end

	local iamLeader = 0;

	if pcparty.info:GetLeaderAID() == myAid then
		iamLeader = 1;
	end

	return iamLeader;
end

function IS_GUILD_AUTHORITY(flag, aid)
	
	if aid == nil then
		aid = session.loginInfo.GetAID();		
	end

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	
	if pcGuild == nil then
		return 0;
	end

	local guildObj = GetIES(pcGuild:GetObject()); 

	if guildObj == nil then
		return 0;
	end

	for i = 1, 40 do
		local propName = "GuildAuthority_"..i;
		local propValue = guildObj[propName];
	
		if propValue ~= "None" then
			local firstIndex, lastIndex = string.find(propValue, aid)
			if firstIndex ~= nil then
				local findPipe = string.find(propValue, "|");
				if findPipe ~= nil then
					local bitValue = string.sub(propValue, lastIndex + 2, string.len(propValue))
					return pc.CheckBitFlag(bitValue, flag)
				else
					local bitFlagPropName = "GuildAuthorityBitFlag_"..i;
					local bitValue = guildObj[bitFlagPropName];
					return pc.CheckBitFlag(bitValue, flag)
				end
			end
		end
	end

	return 0;
end