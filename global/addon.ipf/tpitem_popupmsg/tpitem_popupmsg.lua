function TPITEM_POPUPMSG_ON_INIT(addon, frame)	
end

function OPEN_TPITEM_POPUPMSG(warningList, notWarningList, equipLimitList, itemAndTPItemIDTable, totalTP, prop)
	if prop == nil then
		prop ={}
	end

	local frame = ui.GetFrame('tpitem_popupmsg');
	local posy = 0;
	posy = TPITEM_POPUPMSG_INIT_PROBABILITY_LIST(posy, frame, warningList);
	posy = TPITEM_POPUPMSG_INIT_NON_PROBABILITY_LIST(posy, frame, notWarningList, equipLimitList, itemAndTPItemIDTable);

	TPITEM_POPUPMSG_INIT_BOTTOM_MSG(posy, frame, totalTP);
	frame:ShowWindow(1);

	local btnOk = GET_CHILD_RECURSIVELY(frame, "button_ok")
	if btnOk ~= nil and prop.okScp ~= nil then
		btnOk:SetEventScript(ui.LBUTTONUP, prop.okScp);
	else
		btnOk:SetEventScript(ui.LBUTTONUP, "EXEC_BUY_MARKET_ITEM");
	end

	local btnCancel = GET_CHILD_RECURSIVELY(frame, "button_cancel")
	if btnCancel ~= nil and prop.cancelSp ~= nil then
		btnCancel:SetEventScript(ui.LBUTTONUP, prop.cancelSp);
	else
		btnCancel:SetEventScript(ui.LBUTTONUP, "TPSHOP_ITEM_BASKET_BUY_CANCEL");
	end

end

function GET_NAME_COUNT_TABLE_BY_IES(iesList, property)
	local table = {};
	for i = 1, #iesList do
		local ies = iesList[i];
		if table[ies[property]] == nil then
			table[ies[property]] = 1;
		else
			table[ies[property]] = table[ies[property]] + 1;
		end		
	end
	return table;
end

function TPITEM_POPUPMSG_INIT_PROBABILITY_LIST(posy, frame, warningList)
	local probBox = GET_CHILD_RECURSIVELY(frame, 'probBox');
	local probText = GET_CHILD_RECURSIVELY(frame, 'probText');
	probBox:ShowWindow(0);
	probText:ShowWindow(0);

	if #warningList == 0 then
		return posy;
	end
	probBox:ShowWindow(1);
	probText:ShowWindow(1);	

	probBox:RemoveAllChild();

	local MAX_ITEM_BOX_HEIGHT = tonumber(frame:GetUserConfig('MAX_ITEM_BOX_HEIGHT'));
	local table = GET_NAME_COUNT_TABLE_BY_IES(warningList, 'Name');
	local SCROLL_WIDTH = 20;
	local ctrlsetWidth = probBox:GetWidth() - SCROLL_WIDTH;	
	local _posy = 5;
	local index = 1;
	for name, count in pairs (table) do		
		local ctrlset = probBox:CreateOrGetControlSet('adventure_book_text_elem', 'WARN_ITEM_'..name, 2, _posy);
		ctrlset:Resize(ctrlsetWidth, ctrlset:GetHeight());

		local text = GET_CHILD(ctrlset, 'text');
		text:SetTextByKey('value', '  '..name);
		text:SetGravity(ui.LEFT, ui.CENTER_VERT);

		local timeText = GET_CHILD(ctrlset, 'timeText');
		timeText:SetTextByKey('time', 'x'..count..'  ');
		timeText:SetGravity(ui.RIGHT, ui.CENTER_VERT);

		if index % 2 == 0 then
			local bg = GET_CHILD(ctrlset, 'bg');
			bg:EnableDrawFrame(1);
		end

		_posy = _posy + ctrlset:GetHeight();
		index = index + 1;
	end

	if MAX_ITEM_BOX_HEIGHT < _posy then
		probBox:EnableScrollBar(1);
		_posy = MAX_ITEM_BOX_HEIGHT;
	end
	probBox:Resize(probBox:GetWidth(), _posy);	
	return probBox:GetY() + _posy + 10;
end

function IS_EXIST_IN_IES_LIST(iesList, ies, property)
	for i = 1, #iesList do
		if iesList[i][property] == ies[property] then
			return true;
		end
	end
	return false;
end

function TPITEM_POPUPMSG_INIT_NON_PROBABILITY_LIST(posy, frame, notWarningList, equipLimitList, itemAndTPItemIDTable)
	local notProbBox = GET_CHILD_RECURSIVELY(frame, 'notProbBox');
	local notProbText = GET_CHILD_RECURSIVELY(frame, 'notProbText');
	notProbText:ShowWindow(0);
	notProbBox:ShowWindow(0);
	if #notWarningList == 0 then
		return posy;
	end
	notProbText:ShowWindow(1);
	notProbBox:ShowWindow(1);

	notProbText:SetOffset(0, posy);
	posy = posy + notProbText:GetHeight() + 5;

	notProbBox:SetOffset(0, posy);
	notProbBox:RemoveAllChild();

	local MAX_ITEM_BOX_HEIGHT = tonumber(frame:GetUserConfig('MAX_ITEM_BOX_HEIGHT'));	
	local ICON_SIZE = tonumber(frame:GetUserConfig('ICON_SIZE'));	
	local limitEquipIconStr = string.format('{img %s %d %d}', frame:GetUserConfig('LIMIT_EQUIP_ICON'), ICON_SIZE, ICON_SIZE);
	local limitCountIconStr = string.format('{img %s %d %d}', frame:GetUserConfig('LIMIT_COUNT_ICON'), ICON_SIZE, ICON_SIZE);	

	local table = GET_NAME_COUNT_TABLE_BY_IES(notWarningList, 'ClassName');
	local SCROLL_WIDTH = 20;
	local ctrlsetWidth = notProbBox:GetWidth() - SCROLL_WIDTH;
	local _posy = 5;
	local index = 1;
	for className, count in pairs (table) do		
		local itemCls = GetClass('Item', className);
		local ctrlset = notProbBox:CreateOrGetControlSet('adventure_book_text_elem', 'WARN_ITEM_'..className, 2, _posy);
		ctrlset:Resize(ctrlsetWidth, ctrlset:GetHeight());

		local text = GET_CHILD(ctrlset, 'text');
		local nameStr = itemCls.Name;
		if IS_EXIST_IN_IES_LIST(equipLimitList, itemCls, 'ClassName') == true then
			nameStr = nameStr..limitEquipIconStr;
		end
		if GET_LIMITATION_TO_BUY(itemAndTPItemIDTable[itemCls.ClassID]) ~= 'NO' then
			nameStr = nameStr..limitCountIconStr;
		end

		text:SetTextByKey('value', '  '..nameStr);
		text:SetGravity(ui.LEFT, ui.CENTER_VERT);

		local timeText = GET_CHILD(ctrlset, 'timeText');
		timeText:SetTextByKey('time', 'x'..count..'  ');
		timeText:SetGravity(ui.RIGHT, ui.CENTER_VERT);

		if index % 2 == 0 then
			local bg = GET_CHILD(ctrlset, 'bg');
			bg:EnableDrawFrame(1);
		end

		_posy = _posy + ctrlset:GetHeight();
		index = index + 1;
	end

	if MAX_ITEM_BOX_HEIGHT < _posy then
		notProbBox:EnableScrollBar(1);
		_posy = MAX_ITEM_BOX_HEIGHT;
	end
	notProbBox:Resize(notProbBox:GetWidth(), _posy);

	local itemBox = GET_CHILD_RECURSIVELY(frame, 'itemBox');
	itemBox:Resize(itemBox:GetWidth(), notProbBox:GetY() + notProbBox:GetHeight());	
	return notProbBox:GetY() + _posy + 10;
end

function TPITEM_POPUPMSG_INIT_BOTTOM_MSG(posy, frame, totalTP)	
	local askText = GET_CHILD_RECURSIVELY(frame, 'askText');
	askText:SetTextByKey('tp', totalTP);

	local probInfoText = GET_CHILD_RECURSIVELY(frame, 'probInfoText');
	probInfoText:SetTextByKey('msg', ClMsg('ContainWarningItem'));	

	local bottomBox = GET_CHILD_RECURSIVELY(frame, 'bottomBox');
	local itemBox = GET_CHILD_RECURSIVELY(frame, 'itemBox');
	frame:Resize(frame:GetWidth(), posy + itemBox:GetY() + bottomBox:GetHeight());
end