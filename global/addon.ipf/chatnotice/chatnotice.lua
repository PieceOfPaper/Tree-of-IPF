function CHATNOTICE_ON_INIT(addon, frame)
end

function CHATNOTICE_ON_MSG(frame, msg, argStr, argNum)

end

function SHOW_CHATNOTICE_MSG(chatType, targetName, msg, headInfo)
	
	--[[
	새로운 채팅 메시지가 도착했습니다  <- 이거 안뜨게 해달라고해서 출력하는부분 주석해버림

	local frame = ui.GetFrame('chatnotice');

	local chatSlot = frame:GetChild('chatslot');
	tolua.cast(chatSlot, 'ui::CSlot');
	local chatNotice = frame:GetChild('notice');
	tolua.cast(chatNotice, 'ui::CRichText');

	local slotImageName;
	local noticeMsg = ScpArgMsg('Auto_{@st61}SaeLoun_ChaeTing_MeSeJiKa_DoChagHaessSeupNiDa!{/}');

	if chatType == 'generalchat' then
		slotImageName = 'ti_all';
	elseif chatType == 'partychat' then
		slotImageName = 'ti_party';
	elseif chatType == 'shoutchat' then
		slotImageName = 'ti_shout';
	elseif chatType == 'whisperFromchat' then
		slotImageName = 'ti_message';
	elseif chatType == 'tradechat' then
		slotImageName = 'ti_trade';
	elseif chatType == 'systemchat' then
		slotImageName = 'ti_system';
	else 
		return;
	end
		
	local icon 	= CreateIcon(chatSlot);
	icon:SetImage(slotImageName);
	chatNotice:SetText('{@st42b}'..noticeMsg);
	
	frame:ShowWindow(1);
	frame:SetDuration(5.0);
	]]
end

