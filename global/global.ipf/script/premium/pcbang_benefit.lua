function APPLY_PCBANG_PARTY_MEMBER_BUFF(pc, premiumMemberCnt, memberCnt)
    if GetServerNation() == 'KOR' then -- STEAM_PCBANG_BUFF_RETURN --
    	local partyBuffName = "Premium_Nexon_PartyExp";
    	if premiumMemberCnt >= 1 and memberCnt >= 2 then
    		AddBuff(pc, pc, partyBuffName, 1, 0, 0, premiumMemberCnt);
    	else
    		RemoveBuff(pc, partyBuffName);
    	end
    end -- STEAM_PCBANG_BUFF_RETURN --
end