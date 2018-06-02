
--[[ 20150411 사용 안하는 중으로 일단 주석. 오류 고쳐서 써야 함.

function BARRACKSIMPLECHAT_ON_INIT(addon, frame)
	frame:RunUpdateScript("_BCHAT_AUTO_POS", 0);	
end

function BARRACK_CHAT_ACQUIRE_FOCUS(frame, sec)
	frame:RunUpdateScript("_BCHAT_ACQ_FOCUS", 0.2);
end

function _BCHAT_ACQ_FOCUS(frame)
	local chat = GET_CHILD(frame, "chat", "ui::CEditControl");
	chat:AcquireFocus();
	return 0;
end

function _BCHAT_AUTO_POS(frame)
	local selObj = barrack.GetSelectedObject();
	if selObj ~= nil and GetBarrackSystem(selObj):IsMyAccount() then
		local pos = info.GetPositionInUI(	selObj:GetHandleVal() );

		frame:MoveFrame(pos.x - frame:GetWidth() / 2, pos.y + 20);
		
	end
	
	return 1;
end


function ENTER_BARRACK_CHAT(frame, ctrl)

	local txt = ctrl:GetText();
	if txt == "" then
		frame:ShowWindow(0);
		return;
	end

	ctrl:SetText("");
	barrack.Chat(txt);
end]]