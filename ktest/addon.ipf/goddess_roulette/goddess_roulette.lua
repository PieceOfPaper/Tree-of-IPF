function GODDESS_ROULETTE_ON_INIT(addon, frame)
	addon:RegisterMsg("GODDESS_ROULETTE_START", "GODDESS_ROULETTE_START");
	addon:RegisterMsg("GODDESS_ROULETTE_STATE_UPDATE", "GODDESS_ROULETTE_STATE_UPDATE");
	addon:RegisterMsg("GODDESS_ROULETTE_ITEM_UPDATE", "GODDESS_ROULETTE_ITEM_UPDATE");

	GODDESS_ROULETTE_INIT();
end

function GODDESS_ROULETTE_OPEN()
	frame = ui.GetFrame("goddess_roulette");
	if frame:IsVisible() == 1 then
		return;
	end

	ui.SetHoldUI(false);
	SetCraftState(0);

	local startbtn = GET_CHILD_RECURSIVELY(frame, "startbtn");
	startbtn:SetEnable(0);

	GODDESS_ROULETTE_BTN_UNFREEZE();
	GODDESS_ROULETTE_INIT();
	GODDESS_ROULETTE_ITEM_INIT(frame);

	frame:ShowWindow(1);
    SetCraftState(1);	
end

function GODDESS_ROULETTE_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
        return;
	end
    SetCraftState(0);

	local topframe = frame:GetTopParentFrame();
	topframe:ShowWindow(0);
end

function GODDESS_ROULETTE_INIT()
	local frame = ui.GetFrame("goddess_roulette");

	GODDESS_ROULETTE_REMAIN_UPDATE(frame);

	local roulette_board = GET_CHILD_RECURSIVELY(frame, "roulette_board");
	roulette_board:SetAngle(0);
	roulette_board:ShowWindow(0);

	goddess_roulette.RequestGoddessRouletteState();
end

function GODDESS_ROULETTE_ITEM_INIT(frame)
	local itemlist_gb = GET_CHILD(frame, "itemlist_gb");
	itemlist_gb:ShowWindow(0);
	itemlist_gb:SetUserValue("OPEN", 0);
	
	local itemlist = GET_CHILD_RECURSIVELY(itemlist_gb, "itemlist");
	itemlist:SetScrollPos(0);
end

function GODDESS_ROULETTE_BTN_UNFREEZE()
	ui.SetHoldUI(false);
end

function GODDESS_ROULETTE_REMAIN_UPDATE(frame)
	local startbtn = GET_CHILD_RECURSIVELY(frame, "startbtn");
	local accObj = GetMyAccountObj();
	local nowCnt = GET_USE_ROULETTE_COUNT(accObj);

	if nowCnt ~= 0 then
		startbtn:SetTextByKey("curCnt",  "{#fff200}"..nowCnt.."{/}");
	else
		startbtn:SetTextByKey("curCnt", nowCnt);
	end
	startbtn:SetTextByKey("maxCnt", GET_MAX_ROULETTE_COUNT(accObj));	

	local coinCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = GET_ROULETTE_COIN_CLASSNAME(accObj)}}, false);

	startbtn:SetTextTooltip(ScpArgMsg("GoddessRouletteUseCointipText{count}", "count", coinCnt));
end

function GODDESS_ROULETTE_STATE_UPDATE(frame, msg, argStr)
	local frame = ui.GetFrame("goddess_roulette");

	local strlist = StringSplit(argStr, ";");
	
	local roulette_board = GET_CHILD_RECURSIVELY(frame, "roulette_board");
	roulette_board:SetImage(strlist[1]);
	roulette_board:ShowWindow(1);
	roulette_board:SetAngle(strlist[2]);

	local startbtn = GET_CHILD_RECURSIVELY(frame, "startbtn");
	startbtn:SetEnable(1);
end

function GODDESS_ROULETTE_ITEM_UPDATE(frame, msg, argStr)
	local frame = ui.GetFrame("goddess_roulette");

	local strlist = StringSplit(argStr, ";");
	
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemlist");
	itemlist:RemoveAllChild();

	local startgrade = "SSS";
	local endgrade = "C";
	local rewardCnt = 0;
	for i = 1, #strlist do
		local strlist2 = StringSplit(strlist[i], ":");
		local grade = strlist2[1];
		if i == 1 then
			startgrade = grade;
		elseif i == #strlist then
			endgrade = grade;
		end

		local strlist3 = StringSplit(strlist2[2], "/");
		for j = 1, #strlist3, 2 do
			local itemCls = GetClass("Item", strlist3[j]);
			if itemCls ~= nil then
				local index = rewardCnt;	
				local ctrl = itemlist:CreateOrGetControlSet("reward_item_list", index, 0, index * 85);
				
				local gradectrl = GET_CHILD(ctrl, "grade");
				gradectrl:SetImage(string.lower(grade).."_item_rank");

				local icon = GET_CHILD(ctrl, "icon");
				icon:SetImage(itemCls.Icon);
				SET_ITEM_TOOLTIP_BY_NAME(icon, itemCls.ClassName);
				
				local name = GET_CHILD(ctrl, "name");
				name:SetTextByKey("name", itemCls.Name);

				local count = GET_CHILD(ctrl, "count");
				count:SetTextByKey("count", strlist3[j + 1]);
				icon:SetTooltipOverlap(1);
				rewardCnt = rewardCnt + 1;
			end
		end
	end

	local gradeinfo_text = GET_CHILD_RECURSIVELY(frame, "gradeinfo_text");
	gradeinfo_text:SetTextByKey("startgrade", startgrade);
	gradeinfo_text:SetTextByKey("endgrade", endgrade);
end

function GODDESS_ROULETTE_BTN_CLICK(parent, ctrl)
	if ui.CheckHoldedUI() == true then
        return;
	end

	local accObj = GetMyAccountObj();
	
	-- 코인 수량 확인
	local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = GET_ROULETTE_COIN_CLASSNAME(accObj)}}, false);
	if curCnt < 10 then
		ui.SysMsg(ClMsg("Goddess_Roulette_Coin_Fail"));
		return;
	end

	-- 남은 이용 횟수 확인
	local nowCnt = GET_USE_ROULETTE_COUNT(accObj);
	if GET_MAX_ROULETTE_COUNT(accObj) <= nowCnt then
		ui.SysMsg(ClMsg("Goddess_Roulette_Max_Rullet_count"));
		return;
	end

	local frame = ui.GetFrame("goddess_roulette");
    imcSound.PlaySoundEvent(frame:GetUserConfig("BUTTON_CLICK_SOUND"));
	goddess_roulette.RequestGoddessRoulette();
end

function GODDESS_ROULETTE_START(frame, msg, argStr)
	ui.SetHoldUI(true);
    frame = ui.GetFrame("goddess_roulette");
	
	local strlist = StringSplit(argStr, '/');
	
	local randomValue = strlist[1];
	local grade = strlist[2];
	local itemClassName = strlist[3];
	local itemCount = strlist[4];

	frame:SetUserValue("DEST_ANGLE", randomValue);
	frame:SetUserValue("ANGLE", 0);
	
	frame:SetUserValue("GRADE", grade);
	frame:SetUserValue("ITEM_CLASS_NAME", itemClassName);
	frame:SetUserValue("ITEM_COUNT", itemCount);
    
	ReserveScript("GODDESS_ROULETTE_START_SOUND()", 0.1);
	frame:RunUpdateScript("GODDESS_ROULETTE_RUN", 0, 0, 0, 1);
end

function GODDESS_ROULETTE_RUN(frame, elapsedTime)
	local factor = 1.0;

	local startSpeed, accel = GET_GODDESS_ROULETTE_SPEED(factor);
	local stopTime = startSpeed / accel;
	local isEnd = false;
	if elapsedTime >= stopTime then
		isEnd = true;
		imcSound.PlaySoundEvent("sys_card_battle_roulette_turn_end");
	end

	local angle = GODDESS_ROULETTE_ANGLE_WHEN_TIME(startSpeed, -accel, elapsedTime);
	local lastAngle = GODDESS_ROULETTE_ANGLE_WHEN_TIME(startSpeed, -accel, stopTime);
	lastAngle = lastAngle % 360;
	
	local destAngle = tonumber(frame:GetUserValue("DEST_ANGLE")) - lastAngle;
	destAngle = destAngle * math.pow(elapsedTime / stopTime, 0.5);

	angle = angle + destAngle;
	angle = angle % 360;
	
	local roulette_board = GET_CHILD_RECURSIVELY(frame, "roulette_board");
	roulette_board:SetAngle(angle);

	if isEnd == true then
		ReserveScript("GODDESS_ROULETTE_RESULT()", 0.5);
		return 0;
	else
		return 1;
	end

end

function GET_GODDESS_ROULETTE_SPEED(factor)
	local startSpeed = 2.9 * 360;
	local accel = 0.44 * 360;

	return startSpeed * factor, accel * factor;
end

function GODDESS_ROULETTE_ANGLE_WHEN_TIME(speed, accel, time)
	return time * speed + 0.5 * accel * (time * time);
end

function GODDESS_ROULETTE_START_SOUND()
    imcSound.PlaySoundEvent("sys_card_battle_roulette_turn");
end

function GODDESS_ROULETTE_RESULT()
	ReserveScript("GODDESS_ROULETTE_BTN_UNFREEZE()", 1.5);

	local frame = ui.GetFrame("goddess_roulette");
	local grade = frame:GetUserValue("GRADE");
	local itemClassName = frame:GetUserValue("ITEM_CLASS_NAME");
	local itemCount = frame:GetUserValue("ITEM_COUNT");
	
	GODDESS_ROULETTE_RESULT_FULLDARK_UI_OPEN(grade, itemClassName, itemCount);
end

function GODDESS_ROULETTE_ITEM_OPEN(parent)
	if ui.CheckHoldedUI() == true then
        return;
	end

	local frame = ui.GetFrame("goddess_roulette");
	
	local itemlist_gb = GET_CHILD(frame, "itemlist_gb");
	if itemlist_gb:GetUserIValue("OPEN") == 1 then
		itemlist_gb:ShowWindow(0);
		itemlist_gb:SetUserValue("OPEN", 0);
		return;
	end
	
	GODDESS_ROULETTE_ITEM_INIT(frame);
	
	itemlist_gb:ShowWindow(1);
	itemlist_gb:SetUserValue("OPEN", 1);
end

function GODDESS_ROULETTE_ITEM_CLOSE(parent)
	if ui.CheckHoldedUI() == true then
        return;
	end

	local frame = ui.GetFrame("goddess_roulette");
	local itemlist_gb = GET_CHILD(frame, "itemlist_gb");
	itemlist_gb:ShowWindow(0);
	itemlist_gb:SetUserValue("OPEN", 0);
end