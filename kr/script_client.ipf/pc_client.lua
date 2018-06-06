-- pc_clinet.lua

function GET_CASH_POINT_C()
	local aobj = GetMyAccountObj();
	-- PremiumMedal : À¯Àú ±¸¸Å TP, Medal : ¹«·áTP, GiftMedal : ³Ø½¼ service TP
	return aobj.Medal + aobj.GiftMedal + aobj.PremiumMedal;
end
