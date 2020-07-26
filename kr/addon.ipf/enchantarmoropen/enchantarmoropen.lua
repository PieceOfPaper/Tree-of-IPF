-- enchantarmoropen.lua

function ENCHANTARMOROPEN_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_SPEND_ITEM', 'ENCHANTARMOROPEN_INIT_SPEND_ITEM');
end


function ENCHANTAROMOROPEN_BUFF_CENCEL(sellerHandle)
	packet.StopTimeAction(1);
end

function ENCHANTAROMOROPEN_CENCEL_CHECK(frame)
	frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	local skillName = frame:GetUserValue("GroupName");
	
	session.autoSeller.BuyerClose(AUTO_SELL_ENCHANTERARMOR, handle);
end

function ENCHANTAROMOROPEN_CLOSE(frame)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end
	
	session.autoSeller.Close(groupName);
	frame:ShowWindow(0);
end

function ENCHANTAROMOROPEN_TRY_UI_CLOSE(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	session.autoSeller.BuyerClose(AUTO_SELL_ENCHANTERARMOR, handle);
end


function ENCHANTAROR_STORE_OPEN(groupName, sellType, handle)
	local frame = ui.GetFrame("enchantarmoropen");
	if 'None' == groupName then
		frame:ShowWindow(0);
		return;
	end

	ENCHANTAROMOROPEN_UI_RESET(frame);
	frame:SetUserValue("HANDLE", handle);
	frame:SetUserValue("GroupName", groupName)

	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	itembox_tab:SelectTab(0);

	ENCHANTAROMOROPEN_VIEW_OPEN(frame, 0);
	local repairbox = frame:GetChild("repair");
	local materialGbox  = repairbox:GetChild("materialGbox");
	
	if session.GetMyHandle() == handle then	
		itembox_tab:ShowWindow(1);
		materialGbox:ShowWindow(1);
	else
		itembox_tab:ShowWindow(0);
		materialGbox:ShowWindow(0);	
	end

	frame:ShowWindow(1);
	ENCHANTAROMOROPEN_UPDATE_STORINFO(repairbox, groupName);
	ui.OpenFrame('inventory')
end

function ENCHANTAROMOROPEN_UPDATE_STORINFO(frame, groupName)
	local moneyGbox = frame:GetChild("moneyGbox");
	local money = moneyGbox:GetChild("money");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	money:SetTextByKey("txt", groupInfo.price);

	local topFrame = frame:GetTopParentFrame();
	topFrame:SetUserValue('GroupName', groupName);

	ENCHANTARMOROPEN_INIT_SPEND_ITEM(topFrame);
end

function ENCHANTARMOROPEN_INIT_SPEND_ITEM(frame)
	if frame:GetUserValue('GroupName') == "None" then
		return;
	end
	
	local materialGbox = GET_CHILD_RECURSIVELY(frame, 'materialGbox');
	local reqitemNameStr = materialGbox:GetChild("reqitemNameStr");
	local reqitemCount = materialGbox:GetChild("reqitemCount");
	local reqitemImage = materialGbox:GetChild("reqitemImage");

	local invItemList = session.GetInvItemList();

	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue('GroupName')];
	local name, cnt = checkFunc(invItemList, frame);
	local cls = GetClass("Item", name);
	local txt = GET_ITEM_IMG_BY_CLS(cls, 60);
	reqitemImage:SetTextByKey("txt", txt);
	reqitemNameStr:SetTextByKey("txt", cls.Name);
	local text = cnt .. " " .. ClMsg("CountOfThings");
	reqitemCount:SetTextByKey("txt", text);
end

function ENCHANTAROMOROPEN_UPDATE_OPTION(frame, groupName)
	local baseInfo = session.autoSeller.GetShopBaseInfo(AUTO_SELL_ENCHANTERARMOR);
	local sklgBox = frame:GetChild("sklgBox");
	sklgBox:RemoveAllChild();
	local itemName = frame:GetUserValue('ITEMNAME');
	local optionList = GET_ENCHANTARMOR_OPTION(baseInfo.skillLevel);
	for i = 1, #optionList do
		local ctrlSet = sklgBox:CreateControlSet("enchant_stor_option", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
		ctrlSet:SetUserValue('INDEX_NAME', optionList[i]);
		local msg = ScpArgMsg(optionList[i]);
		local name = ctrlSet:GetChild('name');
		name:SetTextByKey('value', msg .. ' '.. itemName)
		name:SetTextTooltip(msg .. ' '.. itemName);

		local des = ctrlSet:GetChild('des');
		des:SetTextByKey('value', ScpArgMsg(optionList[i]..'_DESC'))
	end

	GBOX_AUTO_ALIGN(sklgBox, 20, 0, 0, true, false); 
end

function ENCHANTAROMOROPEN_TAP_CHANGE(frame)
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	if nil == itembox_tab then
		return;
	end
	
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	ENCHANTAROMOROPEN_VIEW_OPEN(frame, curtabIndex);
end


function ENCHANTAROMOROPEN_VIEW_OPEN(frame, index)
	local repair = frame:GetChild("repair");
	local log = frame:GetChild("log");
	if 0 == index then
		repair:ShowWindow(1);
		log:ShowWindow(0);
	else
		repair:ShowWindow(0);
		log:ShowWindow(1);
	end
end

function ENCHANTAROMOROPEN_UI_RESET(frame)
	frame:SetUserValue('SELECT', 'None');
	frame:SetUserValue('SELECT_NAME', 'None');
	local repairbox = frame:GetChild("repair");
	local slot  = repairbox:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local slotNametext = repairbox:GetChild("slotName");
	slotNametext:SetTextByKey("txt", "");

	local sklgBox = repairbox:GetChild("sklgBox");
	sklgBox:RemoveAllChild();

	local materialGbox  = repairbox:GetChild("materialGbox");
	materialGbox:ShowWindow(1);	
end

function ENCHANTAROMOROPEN_SLOT_POPUP(frame, ctrl)
	local frame = frame:GetTopParentFrame();
	ENCHANTAROMOROPEN_UI_RESET(frame);
end

function ENCHANTAROMOROPEN_SLOT_DROP(frame, ctrl)
	local frame				= frame:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if iconInfo == nil or invItem == nil or slot == nil then
		return;
	end

	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return;
	end

	local pc = GetMyPCObject();
	local obj = GetIES(invItem:GetObject());
	local groupName = frame:GetUserValue("GroupName");
	local checkItem = _G["ITEMBUFF_CHECK_" .. groupName];
	if 1 ~= checkItem(pc, obj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end

	SET_SLOT_ITEM_IMAGE(slot, invItem);
	local repairbox = frame:GetChild("repair");
	repairbox:SetUserValue('ITEMNAME', obj.Name);
	repairbox:SetUserValue('ITEMIES', invItem:GetIESID());
	local slotNametext = repairbox:GetChild("slotName");
	slotNametext:SetTextByKey("txt", "{@st41}"..obj.Name);

	ENCHANTAROMOROPEN_UPDATE_OPTION(repairbox, groupName);

	local materialGbox  = repairbox:GetChild("materialGbox");
	materialGbox:ShowWindow(0);	
end

function ENCHANTARMOR_OPATION_SELECT(frame, ctrl)
	local name = frame:GetUserValue('INDEX_NAME');
	local parent	= frame:GetTopParentFrame();
	local select = parent:GetUserValue('SELECT');

	if 'None' ~= select then
		local repair = parent:GetChild("repair");
		local sklgBox = repair:GetChild("sklgBox");
		local child = sklgBox:GetChild(select);
		local excute = GET_CHILD(child, "excute", "ui::CCheckBox");
		excute:SetCheck(0);
	end

	if ctrl:IsChecked() == 0 then
		parent:SetUserValue('SELECT', 'None');
		parent:SetUserValue('SELECT_NAME', 'None');
		ctrl:SetCheck(0);
	else
		parent:SetUserValue('SELECT', frame:GetName());
		parent:SetUserValue('SELECT_INDEX', name);
		ctrl:SetCheck(1);
	end
end

function ENCHANTAROMOROPEN_BUFF_EXCUTE_BTN(frame, ctrl)	
	local frame = frame:GetTopParentFrame();
	if 'None' == frame:GetUserValue('SELECT') then
		return;
	end

	local repair = frame:GetChild("repair");
	local ies = repair:GetUserValue('ITEMIES');
	if "None" ==  ies then
		return;
	end

	local handle = frame:GetUserIValue("HANDLE");
	local skillName = frame:GetUserValue("GroupName");
	local selectName =  frame:GetUserValue('SELECT_INDEX');
	session.autoSeller.BuyEnchantBuff(handle, AUTO_SELL_ENCHANTERARMOR, selectName, skillName, ies);
end

function ENCHANTAROMOROPEN_UI_CLOSE()
	ui.CloseFrame("enchantarmoropen");
end

function ENCHANTAROMOROPEN_TARGET_BUFF_CENCEL()
	packet.StopTimeAction(1);
end

function ENCHANTARMOROPEN_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);

	local gboxctrl = frame:GetChild("log");
	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();
	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local sList = StringSplit(info:GetHistoryStr(), "#");
		if #sList >= 3 then
			local ctrlSet = log_gbox:CreateControlSet("enchanter_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			local itemCls = GetClassByType("Item", sList[2]);
			local txt = GET_ITEM_IMG_BY_CLS(itemCls, 60);
			local itemImg = ctrlSet:GetChild('itemImg');
			itemImg:SetTextByKey("value", txt);

			local itemName = ctrlSet:GetChild('itemName');
			itemName:SetTextByKey("value", itemCls.Name);

			local propName = StringSplit(sList[3], "@");
			if #propName >= 2 then
			local Property = ctrlSet:GetChild('Property');
				Property:SetTextByKey("value", ScpArgMsg(propName[1]..'_DESC'));
			end
			local userName = ctrlSet:GetChild('userName');
			userName:SetTextByKey("value", sList[1]);
		end
	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end