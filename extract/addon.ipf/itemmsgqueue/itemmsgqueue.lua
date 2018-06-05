function ITEMMSGQUEUE_ON_INIT(addon, frame)

	addon:RegisterMsg('ITEM_PICK', 'ITEMMSG_ITEM_COUNT');

end

function ITEMMSG_POP_QUEUE(frame)

	local msgInfo = session.bindFunc.PopItemMsgQueue();
	ITEMMSG_SHOW_GET_ITEM(frame, msgInfo.itemType, msgInfo.cnt);

end

function ITEMMSG_QUEUE(frame, itemType, cnt)
	session.bindFunc.PushItemMsgQueue(itemType, cnt);
end

function FORCE_GET_ITEM(itemType, cnt)

	local frame = ui.GetFrame("itemmsgqueue");
	if frame:IsVisible() == 1 then
		local beforeItemType = frame:GetUserIValue("ITEMTYPE");
		if beforeItemType ~= itemType then
			ITEMMSG_QUEUE(frame, itemType, cnt);
			return;
		end
	end

	ITEMMSG_SHOW_GET_ITEM(frame, itemType, cnt);
end

function CLOSE_ITEMMSG_QUEUE(frame)
	session.bindFunc.ClearItemMsgQueue();	
	frame:SetUserValue("ITEMTYPE", 0);
end

function ITEMMSG_SHOW_GET_ITEM(frame, itemType, count)

	local item = session.GetInvItemByType(itemType);
	if item == nil then
		frame:ShowWindow(0);
		return;
	end

	local fromCnt = 0;	
	local itemCls = GetClassByType("Item", itemType);
	local text = GET_CHILD(frame, "text", "ui::CRichText");
	local curValue = text:GetCurrentTextChangeEventValue();
	fromCnt = item.count - count;
	if curValue > 0 then
		if curValue > fromCnt then
			return;
		end

		fromCnt = curValue;
	end
		
	local toCnt = item.count;

	local prevToCnt = frame:GetUserIValue("ITEMCOUNT");
	local prevType = frame:GetUserIValue("ITEMTYPE");
	if prevType == itemType and toCnt == prevToCnt then
		return;
	end

	frame = tolua.cast(frame, "ui::CFrame");
	local txt;
	if itemCls.ClassName == "Vis" then
		txt = frame:GetUserConfig("HEAD_FONT") .. ClMsg("GetItem") .. " : " .. GET_ITEM_IMG_BY_CLS(itemCls, 22) .. frame:GetUserConfig("ITEM_FONT");
	else
		txt = frame:GetUserConfig("HEAD_FONT") .. ClMsg("GetItem") .. " : ".. string.format("{img %s 26 26}", itemCls.Icon) .. " " .. frame:GetUserConfig("ITEM_FONT") .. itemCls.Name;
	end

	text:DestroyUICommand(ui.UI_CMD_TEXTCHANGE, false);
	if itemCls.MaxStack > 1 then
		local playTime = (toCnt - fromCnt) * 0.1;
		playTime = math.min(playTime, 2);
		local updateTime = playTime / (toCnt - fromCnt);
		txt = txt .. " %s";
		text:ResetParamInfo();
		text:SetFormat(txt);		
		text:AddParamInfo("value", "0");
		text:PlayTextChangeEvent(updateTime, "value", fromCnt, toCnt, "", 1);
	else
		text:ResetParamInfo();
		text:SetText(txt);
	end
	
	frame:ShowWindow(1);
	frame:SetUserValue("ITEMTYPE", itemType);
	frame:SetUserValue("ITEMCOUNT", toCnt);
	frame:SetUserValue("FROMCOUNT", fromCnt);
	frame:RunUpdateScript("ITEM_MSG_CHECK_HIDE", 0.01, 0.0, 0);

end

function ITEM_MSG_CHECK_HIDE(frame, totalElapsedTime)

	if totalElapsedTime >= 3.0 then
		local queueCnt = session.bindFunc.GetItemMsgQueueSize();
		if queueCnt >= 1 then
			ITEMMSG_POP_QUEUE(frame);
			return 1;
		end
	end

	if totalElapsedTime >= 5.0 then
		frame:ShowWindow(0);
		return 0;
	end

	return 1;

end

function ITEMMSG_ITEM_COUNT(frame, msg, itemType, itemCount)

	itemType = tonumber(itemType);
	local frame = ui.GetFrame("itemmsgqueue");
	if frame:IsVisible() == 1 then
		local beforeItemType = frame:GetUserIValue("ITEMTYPE");
		if beforeItemType == itemType then
			ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
		elseif beforeItemType > 0 then
			local itemCls = GetClassByType("Item", beforeItemType);
			if itemCls.ClassName == "Vis" then -- 돈먹는거 표기하다가 잠깐 홀딩하고 다른 아이템 먼저 보여주자
				local text = GET_CHILD(frame, "text", "ui::CRichText");
				local curValue = text:GetCurrentTextChangeEventValue();
				session.bindFunc.PushItemMsgQueue(itemCls.ClassID, curValue);
				text:DestroyUICommand(ui.UI_CMD_TEXTCHANGE, false);
				ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
			end			
		end
	else 
		ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
	end

end





