

function RAID_REWARD_ON_INIT(addon, frame)
	addon:RegisterMsg("RAID_REWARD_START", "ON_RAID_REWARD_START");
	addon:RegisterMsg("RAID_REWARD_PICKCNT", "ON_RAID_REWARD_PICKCNT");
	addon:RegisterMsg("REWARD_EXEC_COMPLETE", "ON_REWARD_EXEC_COMPLETE");
	addon:RegisterMsg("RAID_REWARD_FAIL", "ON_RAID_REWARD_FAIL");

end

function ON_RAID_REWARD_FAIL(frame)
	frame:ShowWindow(0);
end

function ON_RAID_REWARD_PICKCNT(frame, msg, str, num)
	frame:SetUserValue("END_TIME", imcTime.GetAppTime() + 10);
	RAID_REWARD_UPDATE_PICKCNT(frame);
end

function R_REWARD_SEL(frame, ctrl, str, selIndex)

	local b_add_count = GET_CHILD(frame, "b_add_count", "ui::CButton");
	b_add_count:ShowWindow(0);

	local curPickCount = session.reward.GetCurPickCount();
	local selCnt = frame:GetUserIValue("SELECTED_CNT");
	if selCnt >= curPickCount then
		return;
	end

	if selCnt == 0 then
		reward.ReqExecPick();
	end

	for i = 0 , selCnt - 1 do
		local _selIndex = frame:GetUserIValue("SEL_INDEX_" ..i);
		if _selIndex == selIndex then
			return;
		end
	end

	frame:SetUserValue("SEL_INDEX_" ..selCnt, selIndex);
	selCnt = selCnt + 1;
	frame:SetUserValue("SELECTED_CNT", selCnt);
	RAID_UPDATE_SEL_CNT_TXT(frame);

	if selCnt >= curPickCount then
		frame:StopUpdateScript("RAID_REWARD_TIME_UPDATE");
		local t_sec = GET_CHILD(frame, "t_sec", "ui::CRichText");
		t_sec:SetTextByKey("remainSec", "");

		local t_able_count = GET_CHILD(frame, "t_able_count", "ui::CRichText");
		t_able_count:ShowWindow(0);
		return;
	end

end

function RAID_UPDATE_SEL_CNT_TXT(frame)
	local cnt = frame:GetUserIValue("SELECTED_CNT");
	local curPickCount = session.reward.GetCurPickCount();
	local remainCnt = curPickCount - cnt;
	local t_able_count = GET_CHILD(frame, "t_able_count", "ui::CRichText");
	t_able_count:SetTextByKey("opValue", tostring(remainCnt));

end

--서버에서 응답받아서 아이템패킷을 받은 순간부터 보상 표기 스크립트를 돌린다.
function ON_REWARD_EXEC_COMPLETE(frame)
	frame:RunUpdateScript("RAID_SHOW_REWARD");
end

function RAID_GET_EMPTY_SLOT(frame)
	for i = 1 , 3 do
		local pic = GET_CHILD(frame, "picture_" .. i, "ui::CPicture");
		if pic:GetUserIValue("SHOWN") == 0 then
			return i;
		end
	end

	return -1;
end

-- 해당 슬롯에 아이템을 보여준다.
function SLOT_SET_RITEM(frame, rItem, index, isPicked)

	local pic = GET_CHILD(frame, "picture_" .. index, "ui::CPicture");
	local slot = GET_CHILD(frame, "slot_" .. index, "ui::CSlot");
	local itemSlot = GET_CHILD(frame, "itemslot_" .. index, "ui::CSlot");
	local itemtext = GET_CHILD(frame, "itemtext_" .. index, "ui::CRichText");

	if isPicked == true then
		slot:SetSkinName("belt_slot");
	end

	pic:SetUserValue("SHOWN", 1);
	local itemCls = GetClassByType("Item", rItem.itemType);
	SET_SLOT_ITEM_CLS(itemSlot, itemCls);
	pic:ShowWindow(0);
	slot:EnableHitTest(0);
	itemSlot:ShowWindow(1);

	local gradeTxt = GET_ITEM_GRADE_TXT(itemCls, 24);
	itemtext:SetTextByKey("txt", gradeTxt .. itemCls.Name);

end

-- 선택된 값들을 체크하면서 슬롯을 표기해준다.
function RAID_SHOW_REWARD(frame)

	local curPickCount = session.reward.GetCurPickCount();
	local selCnt = frame:GetUserIValue("SELECTED_CNT");
	local showCnt = frame:GetUserIValue("SHOWN_ITEM_CNT");
	for i = showCnt , selCnt - 1 do
		local _selIndex = frame:GetUserIValue("SEL_INDEX_" ..i);
		local pic = GET_CHILD(frame, "picture_" .. _selIndex, "ui::CPicture");
		if pic:GetUserIValue("SHOWN") == 0 then
			local rItem = session.reward.GetReward(i);
			SLOT_SET_RITEM(frame, rItem, _selIndex, true);
			local curShowCnt = frame:GetUserIValue("SHOWN_ITEM_CNT")
			frame:SetUserValue("SHOWN_ITEM_CNT", curShowCnt + 1);
		end
	end

	if curPickCount == showCnt then
		for i = curPickCount + 1 , 3 do
			local _selIndex = RAID_GET_EMPTY_SLOT(frame);
			local rItem = session.reward.GetReward(i - 1);
			SLOT_SET_RITEM(frame, rItem, _selIndex, false);
		end

		ReserveScript("RAID_CLOSE_AND_BROADCAST()", 5.0);
		geClientItem.ResumeHidedItemGetList();
		return 0;
	end

	return 1;
end

function RAID_CLOSE_AND_BROADCAST()

	local frame = ui.GetFrame("raid_reward");
	frame:ShowWindow(0);
	reward.ReqComplete();

end

function RAID_REWARD_UPDATE_PICKCNT(frame)

	local b_add_count = GET_CHILD(frame, "b_add_count", "ui::CButton");
	local info = session.reward.GetRewardInfo();
	local curPickCount = session.reward.GetCurPickCount();
	if curPickCount < info.maxPickCount then
		b_add_count:ShowWindow(1);
	else
		b_add_count:ShowWindow(0);
	end

	local t_able_count = GET_CHILD(frame, "t_able_count", "ui::CRichText");
	t_able_count:SetTextByKey("opValue", tostring(curPickCount));
	b_add_count:SetText( ScpArgMsg("Auto_{@st41b}SeonTaeg_HoesSu_NeulLiKie_")  ..  ScpArgMsg("Auto_(MeDal{Auto_1}_SoMo)","Auto_1", info.pickUpForMedal)  );

end

-- 값들 초기화시킴
function ON_RAID_REWARD_START(frame, msg, str, num)

	for i = 1 , 3 do
		local slot = GET_CHILD(frame, "slot_" .. i, "ui::CSlot");
		slot:EnableHitTest(1);
		slot:SetSkinName("ring");

		local pic = GET_CHILD(frame, "picture_" .. i, "ui::CPicture");
		pic:ShowWindow(1);
		pic:SetUserValue("SHOWN", 0);
		local itemslot = GET_CHILD(frame, "itemslot_" .. i, "ui::CSlot");
		itemslot:ShowWindow(0);
		itemslot:ClearIcon();
		local itemtext = GET_CHILD(frame, "itemtext_" .. i, "ui::CRichText");
		itemtext:SetText("");
	end

	local t_able_count = GET_CHILD(frame, "t_able_count", "ui::CRichText");
	t_able_count:ShowWindow(1);

	local b_add_count = GET_CHILD(frame, "b_add_count", "ui::CButton");
	b_add_count:ShowWindow(1);

	frame:StopUpdateScript("RAID_SHOW_REWARD");
	frame:SetUserValue("SELECTED_CNT", 0);
	frame:SetUserValue("SHOWN_ITEM_CNT", 0);
	RAID_REWARD_POS(frame);
	frame:RunUpdateScript("RAID_REWARD_TIME_UPDATE", 0, 0, 0, 0);
	frame:SetUserValue("END_TIME", imcTime.GetAppTime() + 10);

	frame:RunUpdateScript("RAID_REWARD_POS", 0, 0, 0, 0);
	frame:ShowWindow(1);

	RAID_REWARD_UPDATE_PICKCNT(frame);

end

function R_REWARD_ADD_CNT(frame)

	local accountObj = GetMyAccountObj();
	local info = session.reward.GetRewardInfo();
	if GET_CASH_TOTAL_POINT_C() < info.pickUpForMedal then
		ui.MsgBox(ClMsg("NotEnoughMedal"));
		return;
	end

	local curPickCount = session.reward.GetCurPickCount();
	if curPickCount < info.maxPickCount then
		reward.ReqAddPickCount();
	end

end

function RAID_REWARD_GET_EMPTY_SEL(frame)

	local selIndex = 1;
	local selCnt = frame:GetUserIValue("SELECTED_CNT");
	while 1 do
		local exist = false;
		for i = 0 , selCnt - 1 do
			local _selIndex = frame:GetUserIValue("SEL_INDEX_" .. i);
			if selIndex == _selIndex then
				exist = true;
			end
		end

		if false == exist then
			return selIndex;
		end

		selIndex = selIndex + 1;
	end

end

function RAID_REWARD_AUTOSELECT(frame)
	-- 자동선택
	local curPickCount = session.reward.GetCurPickCount();
	local selCnt = frame:GetUserIValue("SELECTED_CNT");
	if selCnt == 0 then
		reward.ReqExecPick();
	end

	while 1 do
		if selCnt >= curPickCount then
			break;
		end

		local selIndex = RAID_REWARD_GET_EMPTY_SEL(frame);
		frame:SetUserValue("SEL_INDEX_" .. selCnt, selIndex);
		selCnt = selCnt + 1;
		frame:SetUserValue("SELECTED_CNT", selCnt);
	end
	RAID_UPDATE_SEL_CNT_TXT(frame);
end

function RAID_REWARD_TIME_UPDATE(frame)
	local endTime = frame:GetUserIValue("END_TIME");
	local remainTime = endTime - imcTime.GetAppTime();
	remainTime = math.ceil(remainTime);
	local t_sec = GET_CHILD(frame, "t_sec", "ui::CRichText");

	if remainTime <= 0 then

		local curPickCount = session.reward.GetCurPickCount();
		local selCnt = frame:GetUserIValue("SELECTED_CNT");
		if selCnt < curPickCount then
			RAID_REWARD_AUTOSELECT(frame);
		end

		t_sec:SetTextByKey("remainSec", "");
		return 0;
	end

	t_sec:SetTextByKey("remainSec", remainTime);
	return 1;
end

function RAID_REWARD_POS(frame)

	local myHandle 		= session.GetMyHandle();
	local point = info.GetPositionInUI(myHandle, 2);
	local x = point.x - frame:GetWidth() / 2;
	local y = point.y - frame:GetHeight() - 40;
	frame:MoveFrame(x, y);

	return 1;
end



