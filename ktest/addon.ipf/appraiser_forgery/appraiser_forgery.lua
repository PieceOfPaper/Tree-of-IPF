function APPRAISER_FORGERY_ON_INIT(addon, frame)
    addon:RegisterMsg('ADDON_CLOSE_MSG', 'APPRAISER_FORGERY_CLOSE');
end

function OPEN_APPRAISER_FORGERY(ownerAID, ring1ID, ring2ID, neckID, ring1Str, ring2Str, neckStr)
	-- create virtual item
	local tempRing1, tempRing2, tempNeck = nil;
	if ring1ID ~= nil and ring1ID > 0 then
		tempRing1 = CreateGCIESByID("Item", ring1ID);
	end
	if ring2ID ~= nil and ring2ID > 0 then
		tempRing2 = CreateGCIESByID("Item", ring2ID);
	end
	if neckID ~= nil and neckID > 0 then
		tempNeck = CreateGCIESByID("Item", neckID);
	end
	if tempRing1 == nil and tempRing2 == nil and tempNeck == nil then
		return;
	end

	-- set property
	if tempRing1 ~= nil and ring1Str ~= nil and ring1Str ~= '0' then
		SetModifiedPropertiesString(tempRing1, ring1Str);
	end
	if tempRing2 ~= nil and ring2Str ~= nil and ring2Str ~= '0' then
		SetModifiedPropertiesString(tempRing2, ring2Str);
	end
	if tempNeck ~= nil and neckStr ~= nil and neckStr ~= '0' then
		SetModifiedPropertiesString(tempNeck, neckStr);
	end

	-- set control
	local frame = ui.GetFrame('appraiser_forgery');
	local itemBox = frame:GetChild('itemBox');
	DESTROY_CHILD_BYNAME(itemBox, 'FORGERY_ITEM_');

	local yPos = APPRAISER_FORGERY_CREATE_ITEM_BOX(itemBox, 'RING1', tempRing1, 0);
	yPos = yPos + APPRAISER_FORGERY_CREATE_ITEM_BOX(itemBox, 'RING2', tempRing2, yPos);
	yPos = yPos + APPRAISER_FORGERY_CREATE_ITEM_BOX(itemBox, 'NECK', tempNeck, yPos);
	
	-- default setting
	frame:SetUserValue('OWNER_AID', ownerAID);

	frame:ShowWindow(1);
end

function APPRAISER_FORGERY_REQUEST(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local ring1CtrlSet = GET_CHILD_RECURSIVELY(topFrame, 'FORGERY_ITEM_RING1');
	local ring2CtrlSet = GET_CHILD_RECURSIVELY(topFrame, 'FORGERY_ITEM_RING2');
	local neckCtrlSet = GET_CHILD_RECURSIVELY(topFrame, 'FORGERY_ITEM_NECK');
	local ring1CheckBox = GET_CHILD(ring1CtrlSet, 'checkBox', 'ui::CCheckBox');
	local ring2CheckBox = GET_CHILD(ring2CtrlSet, 'checkBox', 'ui::CCheckBox');
	local neckCheckBox = GET_CHILD(neckCtrlSet, 'checkBox', 'ui::CCheckBox');

	local ring1 = ring1CheckBox:IsChecked();
	local ring2 = ring2CheckBox:IsChecked();
	local neck = neckCheckBox:IsChecked();
	local ownerAID = topFrame:GetUserValue('OWNER_AID');
	
	Appraiser.ReqForgery(ownerAID, ring1, ring2, neck);
	ui.CloseFrame('appraiser_forgery');
end

function APPRAISER_FORGERY_CLOSE()
	ui.CloseFrame('appraiser_forgery');
end

function APPRAISER_FORGERY_CREATE_ITEM_BOX(frame, part, itemObj, yPos)
	-- get my item info
	local myItem = session.GetEquipItemBySpot(item.GetEquipSpotNum(part));
	local myItemObj = nil;
	if myItem ~= nil then	
		myItemObj = GetIES(myItem:GetObject());
	end
	
	-- create controlset
	local ctrlSet = frame:CreateOrGetControlSet('forgery_item', 'FORGERY_ITEM_'..part, 20, yPos);
	local itemName = ctrlSet:GetChild('itemName');
	local checkBox = GET_CHILD(ctrlSet, 'checkBox', 'ui::CCheckBox');
	local appraiserItemPic = GET_CHILD_RECURSIVELY(ctrlSet, 'appraiserItemPic');
	local myItemPic = GET_CHILD_RECURSIVELY(ctrlSet, 'myItemPic');
	local appraiserItemText = GET_CHILD_RECURSIVELY(ctrlSet, 'appraiserItemText');

	-- default set
	checkBox:SetCheck(1);

	-- process by part
	if part == 'RING1' then
		itemName:SetTextByKey('part', '['..ClMsg('Ring')..'1] ');
		appraiserItemText:SetTextByKey('part', ClMsg('Ring'));
	elseif part == 'RING2' then
		itemName:SetTextByKey('part', '['..ClMsg('Ring')..'2] ');
		appraiserItemText:SetTextByKey('part', ClMsg('Ring'));
	elseif part == 'NECK' then
		itemName:SetTextByKey('part', '['..ClMsg('Neck')..'] ');
		appraiserItemText:SetTextByKey('part', ClMsg('Neck'));
	end

	-- item info set
	local compareBox = ctrlSet:GetChild('compareBox');
	local compareResText = compareBox:GetChild('compareResText');
	local list = GET_DEF_PROP_CHANGEVALUETOOLTIP_LIST();
	if itemObj ~= nil then
		itemName:SetTextByKey('name', GET_FULL_NAME(itemObj));
		appraiserItemPic:SetImage(itemObj.Icon);
		APPRAISER_FORGERY_SET_TOOLTIP(appraiserItemPic, itemObj);

		if myItemObj ~= nil and myItemObj.ClassName ~= 'NoRing' and myItemObj.ClassName ~= 'NoNeck' then
			myItemPic:SetImage(myItemObj.Icon);
			APPRAISER_FORGERY_SET_TOOLTIP(myItemPic, myItemObj);
			myItemPic:SetTooltipTopParentFrame(frame:GetTopParentFrame():GetName());
		end

		-- get user config
		local castedCtrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');
		local COMPARE_TEXT_STYLE = castedCtrlSet:GetUserConfig('COMPARE_TEXT_STYLE');
		local COMPARE_ADDITIONAL_MARGIN = tonumber(castedCtrlSet:GetUserConfig('COMPARE_ADDITIONAL_MARGIN'));
		local COMPARE_ADDITIONAL_MARGIN_HORZ = tonumber(castedCtrlSet:GetUserConfig('COMPARE_ADDITIONAL_MARGIN_HORZ'));
		local COMPARE_TEXT_HEIGHT = tonumber(castedCtrlSet:GetUserConfig('COMPARE_TEXT_HEIGHT'));
		local COMPARE_POSITIVE = castedCtrlSet:GetUserConfig('COMPARE_POSITIVE');
		local COMPARE_NEGATIVE = castedCtrlSet:GetUserConfig('COMPARE_NEGATIVE');

		-- get change value
		local valueList = GET_COMPARE_VALUE_LIST(list, itemObj, myItemObj, COMPARE_TEXT_STYLE);
		local notNoneValueList = {};
		for i = 1 , #list do
			local changeValue = valueList[i];
			if changeValue ~= 'None' then
				notNoneValueList[#notNoneValueList + 1] = changeValue;
			end
		end

		-- show change value
		DESTROY_CHILD_BYNAME(compareBox, 'CHANGE_VALUE_');
		local yPos = COMPARE_ADDITIONAL_MARGIN;
		local boxWidth = compareBox:GetWidth();
		for i = 1, #notNoneValueList do
			if #notNoneValueList == 1 then
				local changeValCtrlSet = compareBox:CreateOrGetControlSet('changevalue', 'CHANGE_VALUE_'..i, 0, 0);
				local textChild = changeValCtrlSet:GetChild('changetext');
				textChild:SetText(notNoneValueList[i]);
				changeValCtrlSet:SetGravity(ui.LEFT, ui.CENTER_VERT);
				changeValCtrlSet:ShowWindow(1);
			else
				local marginFactor = math.floor((i - 1) / 2);
				yPos = COMPARE_ADDITIONAL_MARGIN * (marginFactor + 1) + COMPARE_TEXT_HEIGHT * marginFactor;
				local changeValCtrlSet = compareBox:CreateOrGetControlSet('changevalue', 'CHANGE_VALUE_'..i, boxWidth / 2 * ((i - 1) % 2) + COMPARE_ADDITIONAL_MARGIN_HORZ, yPos);
				changeValCtrlSet:SetGravity(ui.LEFT, ui.TOP);

				local textChild = changeValCtrlSet:GetChild('changetext');
				textChild:SetText(notNoneValueList[i]);
				changeValCtrlSet:ShowWindow(1);
			end
		end
		compareBox:Resize(boxWidth, yPos + COMPARE_TEXT_HEIGHT + COMPARE_ADDITIONAL_MARGIN * 2);
		compareResText:ShowWindow(0);

		-- set skin
		if IS_VALUE_UP_BY_CHANGE_ITEM(string.upper(itemObj.GroupName), itemObj, myItemObj) == 1 then
			compareBox:SetSkinName(COMPARE_POSITIVE);
		else
			compareBox:SetSkinName(COMPARE_NEGATIVE);
		end
	else
		itemName:SetTextByKey('name', '');
		compareResText:ShowWindow(1);
	end

	-- resize
	local bgBox = ctrlSet:GetChild('bgBox');
	local newYpos = compareBox:GetY() + compareBox:GetHeight() + 10;
	ctrlSet:Resize(ctrlSet:GetWidth(), newYpos);
	bgBox:Resize(bgBox:GetWidth(), newYpos - 5);
	ctrlSet:ShowWindow(1);

	return newYpos;
end

function APPRAISER_FORGERY_SET_TOOLTIP(ctrl, itemObj)
	SET_ITEM_TOOLTIP_TYPE(ctrl, itemObj.ClassID);
	ctrl:SetTooltipArg('forgery#'..GetModifiedPropertiesString(itemObj), itemObj.ClassID);
end

function GET_FORGERY_ITEM_OBJECT(spotName)
	local forgeryItem = nil;
	if spotName == 'RING1' then
		forgeryItem = session.GetForgeryRing1Item();
	elseif spotName == 'RING2' then
		forgeryItem = session.GetForgeryRing2Item();
	elseif spotName == 'NECK' then
		forgeryItem = session.GetForgeryNeckItem();
	end

	if forgeryItem == nil or forgeryItem:GetClassID() == 0 then
		return nil;
	end

	-- create virtual item
	local forgeryClassID = forgeryItem:GetClassID();
	local forgeryModifiedString = forgeryItem:GetModifiedString();
	local forgeryItemObj = CreateGCIESByID('Item', forgeryClassID);
	if forgeryItemObj == nil then
		return nil;
	end
	if forgeryModifiedString ~= '0' then
		SetModifiedPropertiesString(forgeryItemObj, forgeryModifiedString);
	end

	return forgeryItemObj;
end

function SET_EQUIP_ICON_FORGERY(frame, spotName)
	local slot = GET_CHILD_RECURSIVELY(frame, spotName);	
	if slot == nil then
		return false;
	end
	slot = tolua.cast(slot, 'ui::CSlot');
	DESTROY_CHILD_BYNAME(slot, 'FORGERY_ICON_');

	local forgeryTime = frame:GetUserIValue('FORGERY_BUFF_TIME');
	if forgeryTime == 0 then
		return false;
	end

	-- get forgery item
	local forgeryItemObj = GET_FORGERY_ITEM_OBJECT(spotName);
	if forgeryItemObj == nil then
		return false;
	end

	-- set icon
	local icon = CreateIcon(slot);
	local imageName = GET_EQUIP_ITEM_IMAGE_NAME(forgeryItemObj, 'Icon');
	icon:SetImage(imageName);
	APPRAISER_FORGERY_SET_TOOLTIP(icon, forgeryItemObj);

	local forgeryFrame = ui.GetFrame('appraiser_forgery');
	local FORGERY_ITEM_ICON_SKIN = forgeryFrame:GetUserConfig('FORGERY_ITEM_ICON_SKIN');
	local FORGERY_ITEM_ICON_TIMER_TEXT_STYLE = forgeryFrame:GetUserConfig('FORGERY_ITEM_ICON_TIMER_TEXT_STYLE');

	local gBox = slot:CreateControl('groupbox', 'FORGERY_ICON_BOX', 0, 0, slot:GetWidth(), slot:GetHeight());
	gBox:SetSkinName(FORGERY_ITEM_ICON_SKIN);
	gBox:EnableHitTest(0);
	gBox:ShowWindow(1);

	local timerText = slot:CreateControl('richtext', 'FORGERY_ICON_TIMER_TEXT', 0, 0, slot:GetWidth(), slot:GetHeight());
	timerText = tolua.cast(timerText, "ui::CRichText");
	timerText:SetFormat(FORGERY_ITEM_ICON_TIMER_TEXT_STYLE.."%s{/}");
	timerText:AddParamInfo("time", "03:00");
	timerText:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	timerText:EnableHitTest(0);
	timerText:ShowWindow(1);

	local buffTime = GET_FORGERY_BUFFTIME();
	if buffTime < forgeryTime then
		buffTime = forgeryTime; -- 클라 갱신 시간이 늦는 경우, 애드온 메세지로 전달된 값을 이용한다
	end
	APPRAISER_FORGERY_TOOLTIP_SET_BUFFTIME(timerText, buffTime);

	return true;
end

function APPRAISER_FORGERY_TOOLTIP_SET_BUFFTIME(ctrl, buffTime)
	if buffTime == nil then
		buffTime = GET_FORGERY_BUFFTIME();
	end

	-- get time
	local difSec = math.floor(buffTime / 1000);
	ctrl:SetUserValue("REMAINSEC", difSec);
	ctrl:SetUserValue("STARTSEC", math.floor(imcTime.GetAppTime()));
	ctrl:RunUpdateScript("GET_REMAIN_FORGERY_TIME");
end

function GET_FORGERY_BUFFTIME()
	local forgeryBuff = GetClass('Buff', 'Forgery_Buff');
	if forgeryBuff == nil then
		return 0;
	end
	local buff = info.GetBuff(session.GetMyHandle(), forgeryBuff.ClassID);
	if buff == nil then
		return 0;
	end
	return buff.time;
end

function GET_REMAIN_FORGERY_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = math.floor(startSec - elapsedSec);
	if 0 > startSec then
		ctrl:StopUpdateScript("SHOW_REMAIN_LIFE_TIME");
		return 0;
	end 

	local minute = math.floor(startSec / 60);
	local timeStr = string.format("%02d:%02d", minute, startSec % 60);
	ctrl:SetTextByKey("time", timeStr);
	
	local topFrame = ctrl:GetTopParentFrame();
	topFrame:SetUserValue('FORGERY_BUFF_TIME', startSec * 1000);
	return 1;
end