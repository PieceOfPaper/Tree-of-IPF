

function REPAIRITEM_ON_INIT(addon, frame)

--[[ - 이 애드온 이제 안쓰겠지?
	addon:RegisterMsg("UPDATE_DLG_REPAIR", "ON_UPDATE_DLG_REPAIR");
	addon:RegisterMsg("OPEN_DLG_REPAIRITEM", "ON_OPEN_REPAIRITEM");]]


end

function ON_OPEN_REPAIRITEM(frame)

	frame:ShowWindow(1);
	
end

function OPEN_REPAIRITEM(frame)

	LOAD_REPAIR_LIST(frame);
	
end

function CLOSE_REPAIRITEM(frame)
	
	ui.CloseFrame("repairitem_pop");
	control.DialogOk();

end

function GET_REPAIR_TXT(item)

	local percent = item.Dur / item.MaxDur;
	local color = "";
	if percent <= 0.2 then
		color = "{#FF1111}";
	end
	return color .. GET_FULL_NAME(item);

end

function ON_UPDATE_DLG_REPAIR(frame)

	LOAD_REPAIR_LIST(frame);
	local popFrame = ui.GetFrame("repairitem_pop");
	UPDATE_REPAIRITEM_POP(popFrame);

end

function LOAD_REPAIR_LIST(frame)

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	LOAD_REPAIR_ADVBOX(frame, advBox, 0);
	LOAD_REPAIR_ADVBOX(frame, advBox, 1);
	
end


function LOAD_REPAIR_ADVBOX(frame, advBox, isequip)

	local sortlist = session.GetSortItemList("Dur", isequip, 2);
	local cnt = sortlist:Count();
    
    for i = 0, cnt - 1 do
        local sortItem = sortlist:PtrAt(i);
        local obj = GetIES(sortItem.obj);
        
		if 1 == IS_NEED_REPAIR(obj) then
			local item;
			if sortItem.isEquip == 1 then
				item = tolua.cast(sortItem.item, "EQUIP_ITEM_INFO_C");
			else
				item = tolua.cast(sortItem.item, "INV_ITEM_INFO_C");
			end
		
			local key = item:GetIESID();
			local title = GET_REPAIR_TXT(obj);
			local text = SET_ADVBOX_ITEM(advBox, key, 0, title, "white_16_ol");
			text:EnableHitTest(0);
			
		end
	end

end	

function SET_ANY_REPAIR_ITEM(frame)

	local repFrame = ui.GetFrame("repairitem");
	local advBox = GET_CHILD(repFrame, "AdvBox", "ui::CAdvListBox");
	
	local rowCnt = advBox:GetRowItemCnt(); 
	local row = rowCnt;
	while 1 do
		if row < advBox:GetStartRow() then
			break;
		end
		
		local item = advBox:GetObjectXY(row, 0);
		local itemID = advBox:GetKeyByRow(row);
		local invItem = nil;
		if itemID ~= nil then
			invItem = GET_ITEM_BY_GUID(itemID);
		end
		
		if invItem ~= nil then
			advBox:SelectItem(row);
			advBox:FocusToSelect();
			frame:SetTooltipIESID(itemID);
			UPDATE_REPAIRITEM_POP(frame, 1);
			return;
		end
		
		row = row - 1;
	end
	
	frame:ShowWindow(0);
end

function SELECT_REPAIRITEM(frame, advBox)

	tolua.cast(advBox, "ui::CAdvListBox");
	local key = advBox:GetSelectedKey();
	local popFrame = ui.GetFrame("repairitem_pop");
	popFrame:ShowWindow(1);
	popFrame:SetTooltipIESID(key);
	UPDATE_REPAIRITEM_POP(popFrame);

end

function UPDATE_REPAIRITEM_POP(frame, isRepeat)

	local guid = frame:GetTooltipIESID();
	local item = GET_ITEM_BY_GUID(guid);
	if item == nil then
		frame:ShowWindow(0);
		return;
	end
	
	local obj = GetIES(item:GetObject());
	local pic = GET_CHILD(frame, "itemicon", "ui::CPicture");
	pic:SetImage(obj.Icon);
	
	local t_item = GET_CHILD(frame, "t_item", "ui::CRichText");
	t_item:SetText(GET_FULL_NAME(obj));
	
	
	local gbox = GET_CHILD(frame, "gbox", "ui::CGroupBox");
	gbox:DeleteAllControl();
	
	local totalNeed = 0;
	local y = 0;

	totalNeed, y = SET_REPAIR_GROUPBOX(gbox, "Dur", "Dur", "MaxDur", obj, "GET_REPAIR_PRICE", totalNeed, y);
	totalNeed, y = SET_REPAIR_GROUPBOX(gbox, "ROp1", "ROp1", "MROp1", obj, "GET_ROP1_PRICE", totalNeed, y);
	totalNeed, y = SET_REPAIR_GROUPBOX(gbox, "ROp2", "ROp2", "MROp2", obj, "GET_ROP2_PRICE", totalNeed, y);
	local optCnt = GET_OPTION_CNT(obj);
	for i = 0 , optCnt - 1 do
		totalNeed, y = SET_OP_REPAIR_GROUPBOX(gbox, i, obj, totalNeed, y);
	end
	
	if totalNeed <= 0 then
		if isRepeat == nil then
			SET_ANY_REPAIR_ITEM(frame);
		end
		return;
	end
	

	gbox:UpdateData();
	frame:Invalidate();

end

function REPAIR_EDIT_PRICE(gbox, ctrl)

	local slide = GET_CHILD(gbox, "s_Dur", "ui::CSlideBar");
	tolua.cast(ctrl, "ui::CEditControl");
	local point = ctrl:GetNumber();
	slide:SetLevel(point);	
	
	UPDATE_REPAIR_GBOX_PRICE(gbox);


end

function REPAIR_SLIDE_PRICE(gbox, ctrl)

	local edit = GET_CHILD(gbox, "e_Dur", "ui::CEditControl");
	tolua.cast(ctrl, "ui::CSlideBar");
	local point = ctrl:GetLevel();
	edit:SetText(point);	
	
	UPDATE_REPAIR_GBOX_PRICE(gbox);

end

function SET_OP_REPAIR_GROUPBOX(frame, index, obj, totalNeed, y)

	local priceFunc = "GET_OP_REFILL_PRICE";
	
	local price, y = SET_REPAIR_GROUPBOX(frame, "OpDur_" .. index, "OpDur_" .. index, "OpMDur_" .. index, obj, priceFunc, totalNeed, y);
	if price == totalNeed then
		return totalNeed, y;
	end
	
	local opt, val = GET_OPT(obj, index);
	local txt = GET_OPT_TEXT(obj, index);
	local gBox = frame:GetChild("OpDur_" .. index);
	gBox:GetChild("t_Dur"):SetTextByKey("title", txt);	
	return totalNeed + price, y;
end

function SET_REPAIR_GROUPBOX(frame, groupName, propName, maxPropName, obj, priceFunc, totalNeed, y)

	local needRepair = obj[maxPropName]- obj[propName];
	local needRepair_View = math.ceil(needRepair / DUR_DIV(propName) );
	if needRepair_View == 0 then
		return totalNeed, y;
	end
	
	local groupBox = frame:CreateControlSet('repairctrl', groupName, 0, y);
	groupBox:SetSValue(priceFunc);
	groupBox:GetChild("t_DurMax"):SetTextByKey("MaxDur", needRepair_View);
	
	local slide = GET_CHILD(groupBox, "s_Dur", "ui::CSlideBar");
	slide:SetMinSlideLevel(0);
	slide:SetMaxSlideLevel(needRepair_View);
	slide:SetLevel(needRepair_View);
	
	local edit = GET_CHILD(groupBox, "e_Dur", "ui::CEditControl");
	edit:SetMaxNumber(needRepair_View);
	edit:SetMinNumber(0);
	edit:SetText(needRepair_View);
	
	UPDATE_REPAIR_GBOX_PRICE(groupBox);
	
	local ctrlheight = ui.GetControlSetAttribute('repairctrl', 'height');
	return totalNeed + needRepair_View, y + ctrlheight;
end

function UPDATE_REPAIR_GBOX_PRICE(groupBox)

	local iesID = groupBox:GetTopParentFrame():GetTooltipIESID();
	local item = GET_ITEM_BY_GUID(iesID);
	if item == nil then
		return;
	end
	
	local propName = groupBox:GetName();
	local slide = GET_CHILD(groupBox, "s_Dur", "ui::CSlideBar");
	local fillValue = slide:GetLevel() * DUR_DIV(propName);	
	local obj = GetIES(item:GetObject());
	local price = _G[groupBox:GetSValue()](obj, fillValue);
	
	groupBox:GetChild("p_Dur"):SetTextByKey("Price_Dur", price);
	
end

function REQ_ITEM_REPAIR(frame, ctrl)

	local iesID = frame:GetTooltipIESID();
	local item = GET_ITEM_BY_GUID(iesID);
	if item == nil then
		return;
	end
	
	local gbox = frame:GetChild("gbox");
	local argList = "";
	argList = argList ..  GET_REPAIR_VALUE(gbox, "Dur")
	.. " " .. GET_REPAIR_VALUE(gbox, "ROp1")
	.. " " .. GET_REPAIR_VALUE(gbox, "ROp2");
	
	local obj = GetIES(item:GetObject());
	
	for i = 0 , OPT_COUNT - 1 do		
		argList = argList .. " " .. GET_REPAIR_VALUE(gbox, "OpDur_" .. i);
	end	
	
	pc.ReqExecuteTx_Item("REPAIR", iesID, argList);
	
end


function GET_REPAIR_VALUE(frame, propName)

	local gbox = frame:GetChild(propName);
	if gbox == nil then
		return 0;
	end
	
	local check = GET_CHILD(gbox, "c_Dur", "ui::CCheckBox");
	local slide = GET_CHILD(gbox, "s_Dur", "ui::CSlideBar");
	if check:IsChecked() == 0 then
		return 0;
	end
	
	local sl = slide:GetLevel();
	return sl * DUR_DIV(propName);

end





