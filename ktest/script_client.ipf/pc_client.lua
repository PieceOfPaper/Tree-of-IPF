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

function LEVEL_LINFORM_MESSAGE_CLIENT(idList)
    local idList = SCR_STRING_CUT(idList)
    local msg = '{img lvup_guide_banner}'
    local noticeMsg
    for i = 1, #idList do
        local ies = GetClassByType('levelinformmessage', idList[i])
        local uiType = TryGetProp(ies, 'UIType', 'None')
        if string.find(uiType, 'None') ~= nil then
            msg = msg..'{nl} {nl}'..i..'. '..ies.Message
        end
        if string.find(uiType, 'Notice') ~= nil then
            noticeMsg = ies.Message
        end
    end
    if msg ~= '{img lvup_guide_banner}' then
    --    ui.MsgBox_NonNested(msg,0x00000000)
        ui.MsgBox_NonNested(msg,0x00000000, nil, 'None', 'None', -300)
    end
    if noticeMsg ~= nil then
        addon.BroadMsg("NOTICE_Dm_scroll", ScpArgMsg(noticeMsg), 20);
    end
end
