
function REPAIR_ON_INIT(addon, frame) -- �� �ֵ�� �Ⱦ���. �� �ֵ�� ��.
--[[
	addon:RegisterMsg('DIALOG_CLOSE', 'REPAIR_ON_MSG');
	addon:RegisterMsg('OPEN_DLG_REPAIR', 'REPAIR_ON_MSG');
	addon:RegisterMsg('UPDATE_DLG_REPAIR', 'REPAIR_ON_MSG');
	addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'REPAIR_ON_MSG');
	]]
end


function REPAIR_ON_MSG(frame, msg, argStr, argNum)

	if  msg == 'DIALOG_CLOSE'  then
		frame:ShowWindow(0);
        --ui.CloseFrame('inventory');
    elseif msg == 'OPEN_DLG_REPAIR' then
    	REPAIR_FILL_SELL_LIST(frame);
		frame:ShowWindow(1);
	elseif msg == 'UPDATE_DLG_REPAIR' then
		REPAIR_FILL_SELL_LIST(frame);
	elseif msg == 'UPDATE_ITEM_REPAIR' then

		if argNum == 90000 then
			DRAW_TOTAL_VIS_OTHER_FRAME(frame, 'sys_silver');
		else
			REPAIR_FILL_SELL_LIST(frame);
		end
	end
end


function UPDATE_REPAIR_LIST(frame)

	local repairframe = frame:GetTopParentFrame();
	local list = repairframe:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");

    local tabObj		        = repairframe:GetChild('itembox');
	tolua.cast(tabObj, "ui::CTabControl");
	local curtab	    = tabObj:GetSelectItemIndex();

	local totalprice = 0;

	local idx = 0;
	while 1 do

		local itemname = string.format("REPAIR_%d", idx);
		local Item_Ctrl = groupbox:GetChild(itemname)
		if Item_Ctrl == nil then
			break;
		end

		tolua.cast(Item_Ctrl, "ui::CControlSet");
		if Item_Ctrl:IsSelected() == 1 then

			local Slot = Item_Ctrl:GetChild('slot');
			tolua.cast(Slot, "ui::CSlot");
			local Icon = Slot:GetIcon();
			local iconInfo = Icon:GetInfo();

			local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID(), curtab);
			local itemobj = GetIES(invitem:GetObject());

			local repairamount = itemobj.MaxDur - itemobj.Dur
			totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount);

		end

		idx = idx + 1;
	end

	local Price_Text = repairframe:GetChild("total_price");
	local OutText = ScpArgMsg("Auto_Chong_KaKyeog_:_{Auto_1}","Auto_1", totalprice);
	tolua.cast(Price_Text, "ui::CRichText");
    Price_Text:SetText(OutText);
end


function REPAIR_FILL_SELL_LIST(frame)

    local tabObj		        = frame:GetChild('itembox');
	tolua.cast(tabObj, "ui::CTabControl");
	local curtab	    = tabObj:GetSelectItemIndex();

	local list = frame:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");
    groupbox:DeleteAllControl();

    local ctrlheight = ui.GetControlSetAttribute('repair_set', 'height');


	if curtab == 0 then
		isequip = 1
	else
		isequip = 0
	end

	local sortlist = session.GetSortItemList("Dur", isequip, 1);

    local cnt = sortlist:Count();


    local idx = 0;

    for i = 0, cnt - 1 do

        local sortItem = sortlist:PtrAt(i);


        local invitem;
		if sortItem.isEquip == 1 then
			invitem = tolua.cast(sortItem.item, "EQUIP_ITEM_INFO_C");
		else
			invitem = tolua.cast(sortItem.item, "INV_ITEM_INFO_C");
		end
		
		local itemobj = GetIES(sortItem.obj);

		local repairamount = itemobj.MaxDur - itemobj.Dur
		if sortItem.isEquip == 1 then
			local repairamount = itemobj.MaxDur - itemobj.Dur
		end

        if item.IsNoneItem(itemobj.ClassID) == 0 and itemobj.MaxDur > 0 and repairamount> 0 then

			local itemname = string.format("REPAIR_%d", idx);
			local Item_Ctrl = groupbox:CreateControlSet('repair_set', itemname, 0, 4 + idx * ctrlheight);
			
			tolua.cast(Item_Ctrl, "ui::CControlSet");
			Item_Ctrl:Resize(groupbox:GetWidth() - 30, Item_Ctrl:GetHeight());
			Item_Ctrl:SetEnableSelect(1);
			Item_Ctrl:EnableToggle(1);
			Item_Ctrl:SetEventScript(ui.LBUTTONDOWN, 'UPDATE_REPAIR_LIST')

			local Slot = Item_Ctrl:GetChild('slot');
			tolua.cast(Slot, "ui::CSlot");
			local icon = CreateIcon(Slot);
			local imageName = itemobj.Icon;
			icon:Set(imageName, 'Item', invitem.type, 0, invitem:GetIESID());
			Slot:EnableHitTest(0);

			local ase = invitem.type
			--SET_ITEM_TOOLTIP_TYPE(Item_Ctrl, ase);

			--Item_Ctrl:SetTooltipArg('repair', 0, invitem:GetIESID());

			
			

			local string = string.format( "{s16}%s {#FF6600}(%s : %d){/}", itemobj.Name, ScpArgMsg("REPAIR_PRICE"),GET_REPAIR_PRICE(itemobj,repairamount));
			Item_Ctrl:SetTextByKey('text', string);
			string = string.format("%s%s : (%d / %d){/}", GET_ENDURE_COLOR(itemobj), ScpArgMsg("DURABILITY"), itemobj.Dur / DUR_DIV(), itemobj.MaxDur / DUR_DIV())
			Item_Ctrl:SetTextByKey('durtext', string);

			idx = idx + 1;
		end

    end

    groupbox:UpdateData();

    DRAW_TOTAL_VIS_OTHER_FRAME(frame, 'sys_silver');
    UPDATE_REPAIR_LIST(frame);

end

function REPAIR_ALL_SELECT(frame)

	local list = frame:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");

	local allselected = 1;
	local idx = 0;
	while 1 do

		local itemname = string.format("REPAIR_%d", idx);
		local Item_Ctrl = groupbox:GetChild(itemname)
		if Item_Ctrl == nil then
			break;
		end

		tolua.cast(Item_Ctrl, "ui::CControlSet");
		if Item_Ctrl:IsSelected() == 0 then
			allselected = 0;
		end

		Item_Ctrl:Select();

		idx = idx + 1;
	end

	if allselected == 1 then
		REPAIR_ALL_DESELECT(frame);
	end

	UPDATE_REPAIR_LIST(frame);

end


function REPAIR_ALL_DESELECT(frame)

	local list = frame:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");

	local allselected = 1;
	local idx = 0;
	while 1 do

		local itemname = string.format("REPAIR_%d", idx);
		local Item_Ctrl = groupbox:GetChild(itemname)
		if Item_Ctrl == nil then
			break;
		end

		tolua.cast(Item_Ctrl, "ui::CControlSet");
		Item_Ctrl:Deselect();

		idx = idx + 1;
	end

	if allselected == 1 then

	end

	UPDATE_REPAIR_LIST(frame);

end


function EXECUTE_REPAIR(frame)

	session.ResetItemList();

	local repairframe = frame:GetTopParentFrame();
	local list = repairframe:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");

    local tabObj		        = repairframe:GetChild('itembox');
	tolua.cast(tabObj, "ui::CTabControl");
	local curtab	    = tabObj:GetSelectItemIndex();

	local totalprice = 0;

	local idx = 0;
	while 1 do

		local itemname = string.format("REPAIR_%d", idx);
		local Item_Ctrl = groupbox:GetChild(itemname)
		if Item_Ctrl == nil then
			break;
		end

		tolua.cast(Item_Ctrl, "ui::CControlSet");
		if Item_Ctrl:IsSelected() == 1 then

			local Slot = Item_Ctrl:GetChild('slot');
			tolua.cast(Slot, "ui::CSlot");
			local Icon = Slot:GetIcon();
			local iconInfo = Icon:GetInfo();

			session.AddItemID(iconInfo:GetIESID());

			local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID(), curtab);
			local itemobj = GetIES(invitem:GetObject());

			local repairamount = itemobj.MaxDur - itemobj.Dur
			totalprice = totalprice + GET_REPAIR_PRICE(itemobj,repairamount);

		end

		idx = idx + 1;
	end

	if totalprice == 0 then
		return;
	end

	if IsGreaterThanForBigNumber(totalprice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local msg = ScpArgMsg('ReallyRepair',"Price",totalprice)
	ui.MsgBox(msg, 'EXECUTE_REPAIR_COMMIT', "None");
end

function EXECUTE_REPAIR_COMMIT_OLD()

	local resultlist = session.GetItemIDList();

	item.DialogTransaction("REPAIR", resultlist);
end

