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
	