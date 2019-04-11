function NOTICEITEM_ON_INIT(addon, frame)
	addon:RegisterMsg('NOTICE_New_Item', 'NOTICEITEM_ON_MSG');
end

function NOTICEITEM_FIRST_OPEN(frame)
	local bgPic = frame:GetChild('bgimage');
	tolua.cast(bgPic, "ui::CPicture");
	bgPic:SetImage('itemgetnotice_bg');
end

function NOTICEITEM_ON_MSG(frame, msg, argStr, argNum)
	if msg == "NOTICE_New_Item" then
		local itemClass = GetClass('Item', argStr);

		if itemClass == nil then
			return;
		end

		local itemPic = frame:GetChild('itemimage');
		tolua.cast(itemPic, "ui::CPicture");
		itemPic:SetImage(itemClass.TooltipImage);

		local itemDesc = frame:GetChild('itemtext');
		tolua.cast(itemDesc, "ui::CRichText");
		itemDesc:SetText("{@st43}"..itemClass.Name.."{/}{nl}{s20}{ol}"..ClientMsg(20044));

		frame:ShowWindow(1);
		frame:SetDuration(5.0);
	end
end
