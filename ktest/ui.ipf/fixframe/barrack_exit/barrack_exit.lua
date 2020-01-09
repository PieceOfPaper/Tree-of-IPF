


function RESERVE_POST_BOX_STATE_UPDATE()
	local frame = ui.GetFrame("barrack_name");

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:Stop(); 
	timer:SetUpdateScript("POST_BOX_TIMER_STATE_UPDATE");
	timer:Start(0.5, 0); 
end

function POST_BOX_TIMER_STATE_UPDATE()
	local topFrame = ui.GetFrame("barrack_name");
	if topFrame ~= nil then
		POST_BOX_MESSAGE_COUNT()
		
		local timer = topFrame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:Stop(); 
	end
end


function POST_BOX_MESSAGE_COUNT()
	local frame = ui.GetFrame("barrack_name");
	if frame == nil then
		return;
	end

	local postbox_new = GET_CHILD(frame, "postbox_new");
	local postboxStepBox = GET_CHILD_RECURSIVELY(frame, "postboxStepBox");
	local postboxDigitNotice = GET_CHILD_RECURSIVELY(frame, "postboxDigitNotice");
	local drawnewicon = false; 
	local darwPeriodAttentionIcon = false;
	local cnt = session.postBox.GetMessageCount();
	for i = 0 , cnt - 1 do
		local msgInfo = session.postBox.GetMessageByIndex(i);
		if msgInfo ~= nil then

			-- 새로운 메세지가 있거나, 받을 아이템이 있는 경우.
			if msgInfo:IsNewMessage() == true or  msgInfo:IsItemTake() == true then
				drawnewicon = true

				-- 새로운 메세지이거나 받아갈 아이템이 있는데 삭제기간이 얼마 안남으면 표시. (1일)
				if msgInfo:IsPeriodAttention() == true  then
					darwPeriodAttentionIcon = true
				end
			end			
		end

		-- 둘다 true인 경우 더이상 검사할 필요가 없으므로 탈출.
		if drawnewicon == true and darwPeriodAttentionIcon == true then
			break;
		end
	end

	if postbox_new ~= nil and postboxStepBox ~= nil and postboxDigitNotice ~= nil then
		postbox_new:ShowWindow(0);
		postboxStepBox:ShowWindow(0);
		postboxDigitNotice:ShowWindow(0);
		postboxDigitNotice:EnableHitTest(0);

		-- 둘중에 오늘삭제 경고가 먼저. 
		if darwPeriodAttentionIcon == true then
			postboxStepBox:ShowWindow(1);
			postboxStepBox:SetTextTooltip("{@st41}"..ClMsg("PostboxPeriodAttentionMsg"));
			postboxStepBox:EnableHitTest(1);
			postboxDigitNotice:ShowWindow(1);
			postboxDigitNotice:EnableHitTest(0);
		elseif drawnewicon == true then
			postbox_new:ShowWindow(1);
		end	
	end
end

function OPEN_BARRACK_POSTBOX(parent, ctrl)

	ui.OpenFrame("postbox");

end

