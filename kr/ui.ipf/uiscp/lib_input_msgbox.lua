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
		local sub_str = string.sub(titleName, tilde + 2, str_len - 1)
		local sellMaxNum = tonumber(sub_str) 
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

		edit2:SetEventScript(ui.ENTERKEY, strscp);
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
	confirm:SetEventScript(ui.LBUTTONUP, strscp);
	edit:SetEventScript(ui.ENTERKEY, strscp);

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

