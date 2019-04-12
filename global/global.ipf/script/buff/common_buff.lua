-- 프리미엄 유저에게 주어지는 혜택들
function ADD_PREMIUM_BENEFIT(pc)
	local pcetc = GetETCObject(pc);
	local pcState = GetPremiumState(pc);
	if NONE_PREMIUM == pcState then
		return;
	end
	
	if "NO" == IsBuffApplied(pc, "Premium_speedUp") then
		AddBuff(pc, pc, 'Premium_speedUp');
	end

	if 1 == IsPremiumState(pc, ITEM_TOKEN) and "NO" == IsBuffApplied(pc, "Premium_Token") then
		local premiumArg = GetPremiumStateArg(pc, ITEM_TOKEN);
		AddBuff(pc, pc, 'Premium_Token', premiumArg);
	end
    
    if GetServerNation() == 'KOR' then -- STEAM_PCBANG_BUFF_RETURN --
    	if 1 == IsPremiumState(pc, NEXON_PC) and "NO" == IsBuffApplied(pc, "Premium_Nexon") then
    		AddBuff(pc, pc, 'Premium_Nexon');
    	end
	    RENEW_PCBANG_PARTY_MEMBER_BUFF(pc);
	end -- STEAM_PCBANG_BUFF_RETURN --
end