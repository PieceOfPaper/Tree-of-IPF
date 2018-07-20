-- lib_input_msgbox.lua


function INPUT_NUMBER_BOX(cbframe, titleName, strscp, defNumber, minNumber, maxNumber, numarg, strarg, isNumber)
	local frame = INPUT_STRING_BOX_CB(cbframe, titleName, strscp, defNumber, numarg, strarg, nil, isNumber)
	local edit = GET_CHILD(frame, 'input', "ui::CEditControl");
	edit:SetNumberMode(1);
	edit:SetMaxNumber(maxNumber);
	edit:SetMinNumber(minNumber);
	edit:AcquireFocus();
end

function INPUT_STRING_BOX_CB(fromFrame, titleName, strscp, defText, numarg, strarg, maxLen, isNumber)
	local titleName = ui.ConvertScpArgMsgTag(titleName)

	local newframe;

	--판매시, 가지고 있는 아이템 수량의 MAX 값 파싱
	if strscp == 'EXEC_SHOP_SELL' then
		local str_len = string.len(titleName)
		local tilde = string.find(titleName, "~")
        local sub_str = 1
        if config.GetServiceNation() == 'CHN' then
            sub_str = string.sub(titleName, tilde + 1, str_len - 2)
        else
            sub_str = string.sub(titleName, tilde + 2, str_len - 1)
        end		
		local sellMaxNum = tostring(sub_str):match("^%s*(.-)%s*$")
        
		newframe = INPUT_STRING_BOX(titleName, strscp, defText, numarg, maxLen, nil, nil, sellMaxNum,strarg, isNumber);
	else
		newframe = INPUT_STRING_BOX(titleName, strscp, defText, numarg, maxLen, nil, nil, nil, strarg, isNumber);
	
	end


	local confirm = newframe:GetChild("confirm");
	confirm:SetEventScript(ui.LBUTTONUP, "INPUT_STRING_EXEC");
	local edit = GET_CHILD(newframe, 'input', "ui::CEditControl");
	edit:SetNumberMode(0);
	edit:SetEventScript(ui.ENTERKEY, "INPUT_STRING_EXEC");
	newframe:SetSValue(strscp);

	if fromFrame ~= nil then
		newframe:SetUserValue("FROM_FR", fromFrame:GetName());
	else
		newframe:SetUserValue("FROM_FR", "NULL");
	end

	return newframe;

end

-- sellMaxNum 은 가지고 있는 아이템 판매 수량 Max 값
function INPUT_STRING_BOX(titleName, strscp, defaultText, numArg, maxLen, titleName2, defaultText2, sellMaxNum, strarg, isNumber)
	local newframe = ui.GetFrame("inputstring");
	
	newframe:SetUserValue("FROM_FR", "None");
	
	local byFullString = string.find(strscp, '%(') ~= nil;
	if titleName2 == nil then
		newframe:Resize(500, 220);
	else
		newframe:Resize(500, 420);
		local title2 = newframe:GetChild("title2");
		title2:SetText(titleName2);

		local edit2 = GET_CHILD(newframe, 'input', "ui::CEditControl");
		if defaultText2 == nil then
			edit2:SetText("");
		else
			edit2:SetText(defaultText2);
		end
                
		edit2:SetEventScript(ui.ENTERKEY, strscp, byFullString);
	end

	local edit = GET_CHILD(newframe, 'input', "ui::CEditControl");
	edit:SetEnableEditTag(1);
	if nil ~= isNumber and 1 == isNumber then
		edit:SetNumberMode(1);
	else
	edit:SetNumberMode(0);
	end
	edit:SetText("");
	if defaultText ~= nil then
		if strscp == "EXEC_SHOP_SELL" then			
			edit:SetText(sellMaxNum);
		else
			edit:SetText(defaultText);
		end
	else
		edit:SetText("");
	end

	if maxLen ~= nil then
		edit:SetMaxLen(maxLen);
	end

	newframe:ShowWindow(1);
	newframe:SetEnable(1);
	if numArg ~= nil then
		newframe:SetValue(numArg);
	end

	if strarg ~= nil then
		newframe:SetUserValue("ArgString", strarg);
	end

	local title = newframe:GetChild("title");
	tolua.cast(title, "ui::CRichText");
	title:SetText(titleName);
	ui.SetTopMostFrame(newframe);

	local confirm = newframe:GetChild("confirm");
	confirm:SetEventScript(ui.LBUTTONUP, strscp, byFullString);
	edit:SetEventScript(ui.ENTERKEY, strscp, byFullString);

	edit:AcquireFocus();
	return newframe;

end

function GET_INPUT_STRING_TXT(frame)

	local edit = frame:GetChild('input');
	tolua.cast(edit, "ui::CEditControl");	
	return edit:GetText();
end

function GET_INPUT2_STRING_TXT(frame)

	local edit = frame:GetChild('input2');
	tolua.cast(edit, "ui::CEditControl");
	return edit:GetText();

end



function INPUT_DROPLIST_BOX(barrackFrame, strscp, charName, jobName, minNumber, maxNumber)
if barrackFrame == nil then
		return
	end

	ui.OpenFrame("barrack_move_popup")
	local frame = ui.GetFrame("barrack_move_popup")
	if frame == nil then
		return
	end

	frame:SetUserValue("character_cid", barrackFrame:GetUserValue("character_cid"))
	frame:SetSValue(strscp);

	local msgtext = GET_CHILD_RECURSIVELY(frame, "richtext_1")
	msgtext:SetTextByKey("JobName", jobName)
	msgtext:SetTextByKey("CharName", charName)

	local yesBtn = GET_CHILD_RECURSIVELY(frame, "button_1")
	yesBtn:SetEventScript(ui.LBUTTONUP, "INPUT_DROPLIST_BOX_EXEC")
	local noBtn = GET_CHILD_RECURSIVELY(frame, "button_2")
	noBtn:SetEventScript(ui.LBUTTONUP, "CLOSE_INPUT_DROPLIST_BOX")

	local dropList = GET_CHILD_RECURSIVELY(frame, "droplist_new")
	local dropListText = frame:GetUserConfig("DROPBOX_TEXT")
	local dropListText_i = dropListText
	for i = minNumber, maxNumber do
		dropListText_i = dropListText .. ' ' .. i
		dropList:AddItem(i, dropListText_i)
	end
end

function CLOSE_INPUT_DROPLIST_BOX(frame)
	local frame = ui.GetFrame("barrack_move_popup")
	if frame ~= nil then
		ui.CloseFrame("barrack_move_popup")
	end
end

function INPUT_DROPLIST_BOX_EXEC(frame)
	local frame = ui.GetFrame("barrack_move_popup")
	if frame == nil then
		return
	end

	local dropList = GET_CHILD_RECURSIVELY(frame, "droplist_new")
	dropList:GetSelItemKey()

	local scpName = frame:GetSValue();
	local execScp = _G[scpName];
	local resultString = dropList:GetSelItemKey()
	execScp(frame, resultString, frame);
	
	ui.CloseFrame("barrack_move_popup")
end

function INPUT_GETALL_MSG_BOX(frame, ctrl, now, flag, moneyItem)

	-- market 완료 모두받기
	local marketFrame = ui.GetFrame("market_cabinet");
	local gBox = GET_CHILD_RECURSIVELY(frame, 'listGbox');
	if gBox == nil then
		return
	end
	gBox:RemoveAllChild()

	local sysTime = geTime.GetServerSystemTime();
	local inner_yPos = 0;
	local count = session.market.GetCabinetItemCount()
	for i = 0, count - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local whereFrom = cabinetItem:GetWhereFrom();
		if whereFrom == 'market_sell' then
			--Draw ControlSet
			local soldItemCtrl = gBox:CreateControlSet('market_cabinet_item_sold', 'Item_GetAll_Ctrl_'..i, 0, inner_yPos)
			inner_yPos = inner_yPos + soldItemCtrl:GetHeight()

			--팝업 UI Text 설정.
			local itemName = GET_CHILD_RECURSIVELY(soldItemCtrl, "ItemName")
			local itemObj = GetIES(cabinetItem:GetObject());

			if itemObj.MaxStack <= 1 then
				local itemReinforce_Level = TryGetProp(itemObj, "Reinforce_2", 0);
				if itemReinforce_Level > 0 then
					local levelStr = string.format("+%s ", itemReinforce_Level);
					itemName:SetTextByKey("value1", levelStr)
				end
			end

			itemName:SetTextByKey("value2", itemObj.Name)
			itemName:SetTextByKey("value3", cabinetItem.sellItemAmount)		
			itemName:SetTextByKey("value4", GET_COMMAED_STRING(cabinetItem.count))

			--수수료 계산 / 추후 작업
			--local fees, fessPercent;
			--if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
				--fees = cabinetItem.count * 0.1
				--fessPercent = 10;
			--elseif false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
				--fees = cabinetItem.count * 0.3   	
				--fessPercent = 30;		
			--end

		else --Draw ControlSet
			local buyItemCtrl = gBox:CreateControlSet('market_cabinet_item_etc', 'Item_GetAll_Ctrl_'..i, 0, inner_yPos)
			inner_yPos = inner_yPos + buyItemCtrl:GetHeight()

			--PopUp Text Setting
			local itemName = GET_CHILD_RECURSIVELY(buyItemCtrl, "ItemName")
			local itemObj = GetIES(cabinetItem:GetObject());
			
			if itemObj.MaxStack <= 1 then
				local itemReinforce_Level = TryGetProp(itemObj, "Reinforce_2", 0);
				if itemReinforce_Level > 0 then
					local levelStr = string.format("+%s ", itemReinforce_Level);
					itemName:SetTextByKey("value1", levelStr)
				end
			end

			itemName:SetTextByKey("value2", itemObj.Name)
			itemName:SetTextByKey("value3", cabinetItem.count)		
		end
	end

	--yes & no Btn
	local noBtn = GET_CHILD_RECURSIVELY(frame, "button_1")
	noBtn:SetEventScript(ui.LBUTTONUP, "CLOSE_INPUT_GETALL_MSG_BOX")
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "button_2")
	yesBtn:SetEventScript(ui.LBUTTONUP, "CABINET_GET_ALL_LIST")
	yesBtn:SetEventScriptArgNumber(ui.LBUTTONUP, now)
end

function CLOSE_INPUT_GETALL_MSG_BOX(frame)
	local frame = ui.GetFrame("market_cabinet_soldlist")
	if frame ~= nil then
		ui.CloseFrame("market_cabinet_soldlist")
	end
end

function INPUT_TEXTMSG_BOX(marketFrame, strscp, charName, jobName, minNumber, maxNumber, guid)    
	-- market 완료 받기
	if marketFrame == nil then
		return
	end

	local cabinetItem = session.market.GetCabinetItemByItemID(guid);
	local cabinetItem_Obj = GetIES(cabinetItem:GetObject())	
	local whereFrom = cabinetItem:GetWhereFrom()

	if whereFrom == 'market_sell' then
		ui.OpenFrame("market_cabinet_popup")
		frame = ui.GetFrame("market_cabinet_popup")
    else
	    ui.OpenFrame("market_cabinet_popup_etc")
	    frame = ui.GetFrame("market_cabinet_popup_etc")        
	end
	if frame == nil then
		return
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, 'bg')
	if gBox == nil then
		return
	end

	--아이템 이름 & 갯수 ( & 가격 ) 
	local itemReinforce_Level = TryGetProp(cabinetItem_Obj, "Reinforce_2");
	local richText_1 = GET_CHILD_RECURSIVELY(frame, "richtext_1");
	richText_1:SetTextByKey("itemName", cabinetItem_Obj.Name);	
	
	if whereFrom == 'market_sell' then
		--실 수령 금액 계산

		--수수료 계산 / 추후 작업
		--local frame, fees, fessPercent;
		--if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then	
			--fees = cabinetItem.count * 0.1
			--fessPercent = 10;
		--elseif false == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			--fees = cabinetItem.count * 0.3   			
			--fessPercent = 30;
		--end
		if cabinetItem_Obj.MaxStack <= 1 and itemReinforce_Level > 0 then
			local levelStr = string.format("+%s ", itemReinforce_Level);
			richText_1:SetTextByKey("item_reinforce_level", levelStr);
		end
		richText_1:SetTextByKey("itemCount", cabinetItem.sellItemAmount);
		richText_1:SetTextByKey("itemPrice", GET_COMMAED_STRING(cabinetItem.count));

		--no btn ( market_sell )
		local noBtn = GET_CHILD_RECURSIVELY(frame, "button_1")
		noBtn:SetEventScript(ui.LBUTTONUP, "CLOSE_INPUT_TEXTMSG_BOX")
		local yesBtn = GET_CHILD_RECURSIVELY(frame, "button_2")
		yesBtn:SetEventScript(ui.LBUTTONUP, strscp)        
		yesBtn:SetEventScriptArgString(ui.LBUTTONUP, guid)
    else 
		richText_1:SetTextByKey("itemCount", cabinetItem.count);
		--Reinforce Level Setting
		if cabinetItem_Obj.MaxStack <= 1 and itemReinforce_Level > 0 then
			local levelStr = string.format("+%s ", itemReinforce_Level);
			richText_1:SetTextByKey("item_reinforce_level", levelStr);
		end

		--yes & no btn ( market .. etc )
		local noBtn = GET_CHILD_RECURSIVELY(frame, "button_1")
		noBtn:SetEventScript(ui.LBUTTONUP, "CLOSE_INPUT_TEXTMSG_BOX_ETC")
		local yesBtn = GET_CHILD_RECURSIVELY(frame, "button_2")
		yesBtn:SetEventScript(ui.LBUTTONUP, strscp)
		yesBtn:SetEventScriptArgString(ui.LBUTTONUP, guid)
	end
end

function CLOSE_INPUT_TEXTMSG_BOX(frame)
	local frame = ui.GetFrame("market_cabinet_popup")
	local richText_1 = GET_CHILD_RECURSIVELY(frame, "richtext_1");
	richText_1:SetTextByKey("itemName", "");	
	richText_1:SetTextByKey("itemPrice", "");
	richText_1:SetTextByKey("itemCount", "");
	richText_1:SetTextByKey("item_reinforce_level", "");
	
	if frame ~= nil then
		ui.CloseFrame("market_cabinet_popup")
	end
end

function CLOSE_INPUT_TEXTMSG_BOX_ETC(frame)
	local frame = ui.GetFrame("market_cabinet_popup_etc")
	local richText_1 = GET_CHILD_RECURSIVELY(frame, "richtext_1");
	richText_1:SetTextByKey("itemName", "");	
	richText_1:SetTextByKey("itemCount", "");
	richText_1:SetTextByKey("item_reinforce_level", "");

	if frame ~= nil then
		ui.CloseFrame("market_cabinet_popup_etc")
	end
end

function INPUT_TEXTMSG_BOX_EXEC(frame)
	local frame = ui.GetFrame("market_cabinet_popup")
	if frame == nil then
		return
	end

	local scpName = frame:GetSValue();
	local execScp = _G[scpName];
	execScp(frame, resultString, frame);
	
	ui.CloseFrame("market_cabinet_popup")
end
