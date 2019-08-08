function ITEMMSGQUEUE_ON_INIT(addon, frame)

	addon:RegisterMsg('ITEM_PICK', 'ITEMMSG_ITEM_COUNT');

end

function ITEMMSG_POP_QUEUE(frame)
	local msgInfo = session.bindFunc.PopItemMsgQueue();
	--msgInfo.cnt �� �ǹ� ��ü�� �����°�쵵 �ִµ�
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
--			return;
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
		return;
	end

	local itemCls = GetClassByType("Item", itemType);
	if itemCls.ClassName ~= "Vis" then
		return;
	end
		
	local textVis = GET_CHILD_RECURSIVELY(frame, "textVis", "ui::CRichText");
	textVis:DestroyUICommand(ui.UI_CMD_TEXTCHANGE, false);

	local fromCnt = 0;	
	local toCnt = tonumber(GET_TOTAL_MONEY_STR());
	
	local curValue = textVis:GetCurrentTextChangeEventValue();
	fromCnt = SumForBigNumberInt64(toCnt, '-'..count);
--	if curValue > 0 then
--		if curValue > fromCnt then
--			return;
--		end

--		fromCnt = curValue;
--	end

	local prevToCnt = frame:GetUserIValue("ITEMCOUNT");
	local prevType = frame:GetUserIValue("ITEMTYPE");
	frame = tolua.cast(frame, "ui::CFrame");
	
	if itemCls.MaxStack > 1 then
		local playTime = (toCnt - fromCnt) * 0.1;
		playTime = math.min(playTime, 2);
		
		local updateTime = playTime / (toCnt - fromCnt);
		local isShowCurVis = config.GetXMLConfig("ShowCurrentGetVis")
		if isShowCurVis == 1 then
			textVis:SetTextByKey("curVis", count .. " / ")
		else
			textVis:SetTextByKey("curVis", "")
		end		

		local tempFromCnt = math.max(fromCnt, toCnt - 200)
		textVis:PlayTextChangeEvent(updateTime, "totalVis", tostring(tempFromCnt), tostring(toCnt), "", 1);
		textVis:SetTextByKey("totalVis", toCnt);
	else
		textVis:SetTextByKey("totalVis", toCnt);
	end
	
	local textExp = GET_CHILD_RECURSIVELY(frame, "textExp", "ui::CRichText");
	local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
	
	if frame:IsVisible() ~= 1 then
		textExp:SetTextByKey("Exp", "0")
		textJobExp:SetTextByKey("jobExp", "0")

	end

	local isShowCurExp = config.GetXMLConfig("ShowCurrentGetExp")
	if isShowCurExp == 0 then
		textExp:ShowWindow(0)
		textJobExp:ShowWindow(0)
	else
		textExp:ShowWindow(1)
		textJobExp:ShowWindow(1)
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
	local itemCls = GetClassByType("Item", itemType);
	if itemCls.ClassName ~= "Vis" then
		return
	end

	local frame = ui.GetFrame("itemmsgqueue");
	local textVis = GET_CHILD_RECURSIVELY(frame, "textVis", "ui::CRichText");
	if frame:IsVisible() == 1 then
		local beforeItemType = frame:GetUserIValue("ITEMTYPE");
--		if beforeItemType == itemType then
			ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
--		elseif beforeItemType > 0 then
--			local itemCls = GetClassByType("Item", beforeItemType);
--			if itemCls.ClassName == "Vis" then
--				local curValue = textVis:GetCurrentTextChangeEventValue();
--				session.bindFunc.PushItemMsgQueue(itemCls.ClassID, curValue);
--				textVis:DestroyUICommand(ui.UI_CMD_TEXTCHANGE, false);
--				ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
--			end			
--		end
	else 
		local textExp = GET_CHILD_RECURSIVELY(frame, "textExp", "ui::CRichText");
		local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
		textExp:SetTextByKey("Exp", "0")
		textJobExp:SetTextByKey("jobExp", "0")
		ITEMMSG_SHOW_GET_ITEM(frame, itemType, itemCount);
	end

end


function SHOW_GET_EXP(frame, exp)
	local frame = ui.GetFrame("itemmsgqueue");

	if frame:IsVisible() == 1 then
		SET_TEXT_GET_EXP(frame, exp);
	else 
		local visCls = GetClass("Item", "Vis");
		local visCount = session.GetInvItemCountByType(visCls.ClassID);

		local textVis = GET_CHILD_RECURSIVELY(frame, "textVis", "ui::CRichText");
		local textExp = GET_CHILD_RECURSIVELY(frame, "textExp", "ui::CRichText");
		local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
		local isShowCurVis = config.GetXMLConfig("ShowCurrentGetVis")
		if isShowCurVis == 1 then
			textVis:SetTextByKey("curVis", "0 / ")
		else
			textVis:SetTextByKey("curVis", "")
		end
		textVis:SetTextByKey("totalVis", visCount)

		local isShowCurExp = config.GetXMLConfig("ShowCurrentGetExp")
		if isShowCurExp == 0 then
			textExp:ShowWindow(0)
			textJobExp:ShowWindow(0)
		else
			textExp:ShowWindow(1)
			textJobExp:ShowWindow(1)
		end

		textJobExp:SetTextByKey("jobExp", "0")
		SET_TEXT_GET_EXP(frame, exp);
	end

end



function SET_TEXT_GET_EXP(frame, exp)
	local frame = ui.GetFrame("itemmsgqueue");
	if frame:IsVisible() ~= 1 then
		frame:ShowWindow(1)
	end

	local textExp = GET_CHILD_RECURSIVELY(frame, "textExp", "ui::CRichText");
	
	local curValue = textExp:GetCurrentTextChangeEventValue();
		
	frame = tolua.cast(frame, "ui::CFrame");
	if exp == -1 then
		textExp:SetTextByKey("Exp", "Level Up")
	else
		textExp:SetTextByKey("Exp", exp);
	end
	
	frame:ShowWindow(1);
	frame:RunUpdateScript("ITEM_MSG_CHECK_HIDE", 0.01, 0.0, 0);
end



function SHOW_GET_JOBEXP(frame, jobExp)
	local frame = ui.GetFrame("itemmsgqueue");
	if jobExp == nil or jobExp == '' or jobExp == '0' then
		local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
		textJobExp:SetText("0")
		return
	end

	if frame:IsVisible() == 1 then
		SET_TEXT_GET_JOBEXP(frame, jobExp);
	else 
		local visCls = GetClass("Item", "Vis");
		local visCount = session.GetInvItemCountByType(visCls.ClassID);

		local textVis = GET_CHILD_RECURSIVELY(frame, "textVis", "ui::CRichText");
		local textExp = GET_CHILD_RECURSIVELY(frame, "textExp", "ui::CRichText");
		local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
		local isShowCurVis = config.GetXMLConfig("ShowCurrentGetVis")
		if isShowCurVis == 1 then
			textVis:SetTextByKey("curVis", "0 / ")
		else
			textVis:SetTextByKey("curVis", "")
		end

		textVis:SetTextByKey("totalVis", visCount)

		local isShowCurExp = config.GetXMLConfig("ShowCurrentGetExp")
		if isShowCurExp == 0 then
			textExp:ShowWindow(0)
			textJobExp:ShowWindow(0)
		else
			textExp:ShowWindow(1)
			textJobExp:ShowWindow(1)
		end

		textExp:SetTextByKey("Exp", 0);
		SET_TEXT_GET_JOBEXP(frame, jobExp);
	end

end



function SET_TEXT_GET_JOBEXP(frame, jobExp)
	local frame = ui.GetFrame("itemmsgqueue");
	if frame:IsVisible() ~= 1 then
		frame:ShowWindow(1)
	end

	local textJobExp = GET_CHILD_RECURSIVELY(frame, "textJobExp", "ui::CRichText");
	
	local curValue = textJobExp:GetCurrentTextChangeEventValue();
		
	frame = tolua.cast(frame, "ui::CFrame");
	textJobExp:SetTextByKey("jobExp", jobExp);
	
	frame:ShowWindow(1);
	frame:RunUpdateScript("ITEM_MSG_CHECK_HIDE", 0.01, 0.0, 0);
end
