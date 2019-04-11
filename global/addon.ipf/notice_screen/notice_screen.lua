function NOTICE_SCREEN_ON_INIT(addon, frame)

	addon:RegisterMsg('NOTICE_SCREEN', 'NOTICE_ON_MSG_SCREEN');
end

function NOTICE_ON_MSG_SCREEN(frame, msg, text, time)
	frame:Invalidate();

	local pFrame = tolua.cast(frame, "ui::CFrame");	
    local textObj = pFrame:GetChild('text');
	tolua.cast(textObj, "ui::CRichText");

	local exeText = '{@st64}'..text ;
	textObj:SetText(exeText);

	pFrame:SetDuration(time);
	pFrame:SetOffset(0, 350);
	pFrame:Resize(frame:GetWidth(), 80);

	pFrame:ShowWindow(1);

end
