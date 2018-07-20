-- pc_clinet.lua

function GET_CASH_TOTAL_POINT_C()
	local aobj = GetMyAccountObj();
	-- PremiumMedal : 유저 구매 TP, Medal : 무료TP, GiftMedal : 넥슨 service TP
	return aobj.Medal + aobj.GiftMedal + aobj.PremiumMedal;
end
-- pc의 partymember 오브젝트를 가져오는 함수
function GET_MY_PARTY_INFO_C()
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if myInfo == nil then
		return;
	end	
	return GetIES(myInfo:GetObject());	
end