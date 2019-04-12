function CARD_OPTION_CREATE_BY_GROUP(monsterCardSlotFrame, i, clientMessage, cardID, cardLv, cardExp, optionIndex, labelIndex)
	local frame = monsterCardSlotFrame;
	if frame == nil then
		frame = ui.GetFrame('monstercardslot')
	end

	
	local itemcls = GetClassByType("Item", cardID)
	if itemcls == nil then
		return
	end

	local strInfo = ""
	
	local optionValue = { }
	optionValue[1] = frame:GetUserIValue("DUPLICATE_OPTION_VALUE1")
	optionValue[2] = frame : GetUserIValue("DUPLICATE_OPTION_VALUE2")
	optionValue[3] = frame : GetUserIValue("DUPLICATE_OPTION_VALUE3")
	local optionValue_temp = { }
	optionValue_temp[1] = 0
	optionValue_temp[2] = 0
	optionValue_temp[3] = 0

	local itemClassName = itemcls.ClassName

	local cardcls = GetClass("EquipBossCard", itemClassName);
	if cardcls == nil then
		return;
	end

	local optionImage = string.format("%s", ClMsg(clientMessage));
	strInfo = strInfo .. optionImage
				
	local optionGbox = GET_CHILD_RECURSIVELY(frame, "option_bg")
	local itemClsCtrl = nil
				
	local duplicateOptionIndex = -1
	local duplicateCount = frame:GetUserIValue("DUPLICATE_COUNT")
			
	local optionTextValue = cardcls.OptionTextValue
	local optionTextValueList = StringSplit(optionTextValue, "/")

	if optionTextValueList == nil then
		return
	end

	for j = 0, i - 1 do
		local cardID_temp, cardLv_temp = GETMYCARD_INFO(j)
		if cardID == cardID_temp then
			if duplicateOptionIndex == -1 then
				duplicateOptionIndex = j
				local preIndex = frame:GetUserIValue("PREINDEX")
				local cardID_flag = GETMYCARD_INFO(preIndex)
				if i - j == 2 and preIndex ~= j and cardID_flag ~= cardID_temp then
					duplicateCount = duplicateCount + 1
				end
			end

			for k = 1, #optionTextValueList do
				optionValue_temp[k] = optionValue_temp[k] + optionTextValueList[k] * cardLv_temp
			end
		end
	end

	if optionGbox ~= nil then
		if duplicateOptionIndex == -1 then
			optionIndex = optionIndex + 1
			itemClsCtrl = optionGbox:CreateOrGetControlSet('eachoption_in_monstercard', 'OPTION_CSET_'..i, 0, 0);
			for k = 1, #optionTextValueList do
				optionValue_temp[k] = optionValue_temp[k] + optionTextValueList[k] * cardLv
			end

			local optionText = cardcls.OptionText
			local temp = dictionary.ReplaceDicIDInCompStr(optionText);
			optionText = string.format(temp, optionValue_temp[1], optionValue_temp[2], optionValue_temp[3])

			strInfo = strInfo ..optionText
		else
			itemClsCtrl = optionGbox:CreateOrGetControlSet('eachoption_in_monstercard', 'OPTION_CSET_'..duplicateOptionIndex, 0, 0);

			for k = 1, #optionTextValueList do
				optionValue[k] = optionValue_temp[k] + optionTextValueList[k] * cardLv
			end

			local optionText = cardcls.OptionText
			local temp = dictionary.ReplaceDicIDInCompStr(optionText);
			optionText = string.format(temp, optionValue_temp[1], optionValue_temp[2], optionValue_temp[3])

			strInfo = strInfo ..optionText
			frame : SetUserValue("DUPLICATE_OPTION_VALUE1", optionValue[1])
			frame : SetUserValue("DUPLICATE_OPTION_VALUE2", optionValue[2])
			frame : SetUserValue("DUPLICATE_OPTION_VALUE3", optionValue[3])
		end

		itemClsCtrl = AUTO_CAST(itemClsCtrl)
		local pos_y = itemClsCtrl:GetUserConfig("POS_Y")
		local labelHeight = frame:GetUserIValue("LABEL_HEIGHT")
		itemClsCtrl : Move(0, (optionIndex - duplicateCount) * pos_y + labelHeight)
		local optionList = GET_CHILD_RECURSIVELY(itemClsCtrl, "option_name", "ui::CRichText");
		optionList:SetText(strInfo)
		frame : SetUserValue("CURRENT_HEIGHT", (optionIndex + 1) * pos_y);
	end				

	frame : SetUserValue("IS_EQUIP_TYPE", i)
	frame : SetUserValue("CARD_OPTION_INDEX", optionIndex);
	frame:SetUserValue("DUPLICATE_COUNT", duplicateCount)
	frame : SetUserValue("PREINDEX", i)
end