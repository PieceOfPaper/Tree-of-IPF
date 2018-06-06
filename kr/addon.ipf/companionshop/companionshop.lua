
function COMPANIONSHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_COMPANIONSHOP', 'ON_OPEN_DLG_COMPANIONSHOP');
	addon:RegisterMsg('COMPANIONSHOP_FOOD_TAB', 'ON_COMPANIONSHOP_FOOD_TAB');
	addon:RegisterMsg('COMPANIONSHOP_DIALOG_CLOSE', 'ON_COMPANIONSHOP_DIALOG_CLOSE');
end

function ON_OPEN_DLG_COMPANIONSHOP(frame, msg, shopGroup)
	frame:SetUserValue("SHOP_GROUP", shopGroup);
	frame:ShowWindow(1);
end

function COMPANIONSHOP_OPEN(frame)
	UPDATE_COMPANION_SELL_LIST(frame);
	COMPANIONSHOP_UPDATE_REMAINMONEY(frame);
	COMPANIONSHOP_TAB_CHANGE(frame);
end

function UPDATE_COMPANION_SELL_LIST(frame)
	local shopGroup = frame:GetUserValue("SHOP_GROUP");
	local adoptTopBox = GET_CHILD_RECURSIVELY(frame, 'adoptTopBox');
	adoptTopBox:RemoveAllChild();
	
	local pc = GetMyPCObject();
	local clsList, cnt = GetClassList("Companion");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local sellPrice = cls.SellPrice;
		if sellPrice ~= "None" and shopGroup == cls.ShopGroup then
			sellPrice = _G[sellPrice];
			local price = sellPrice(cls, pc);		
			local ctrlSet = adoptTopBox:CreateControlSet("companionshop_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			ctrlSet:SetUserValue("CLSNAME", cls.ClassName);
			local name = ctrlSet:GetChild("name");
			local priceCtrl = ctrlSet:GetChild("price");
			priceCtrl:SetTextByKey("txt", GET_MONEY_IMG(20) ..  " " .. GetCommaedText(price));
			ctrlSet:SetUserValue('SELL_PRICE', price);
			local monCls = GetClass("Monster", cls.ClassName);
			name:SetTextByKey("txt", monCls.Name);
			name:SetTextByKey("JobID", cls.JobID);
			local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
			local icon = CreateIcon(slot);
			icon:SetImage(monCls.Icon);
			ctrlSet:SetEventScript(ui.LBUTTONUP, "COMPANIONSHOP_SELECT_COMPANION");			
		end
		
	end

	GBOX_AUTO_ALIGN(adoptTopBox, 20, 0, 10, true, false);
end

function CLOSE_COMPANION_SHOP(frame)
	control.DialogOk();
	COMPANIONSHOP_CLEAR(frame);
	SHOP_UI_CLOSE(frame:GetChild('foodBox'));
end

function COMPANIONSHOP_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local adoptBox = GET_CHILD_RECURSIVELY(frame, 'adoptBox');
	local foodBox = GET_CHILD_RECURSIVELY(frame, 'foodBox');
	local tabCtrl = GET_CHILD_RECURSIVELY(frame, 'companionTab');

	local tabIndex = tabCtrl:GetSelectItemIndex();
	if tabIndex == 0 then -- 분양 탭
		adoptBox:ShowWindow(1);
		foodBox:ShowWindow(0);
	elseif tabIndex == 1 then -- 먹이 탭
		adoptBox:ShowWindow(0);
		foodBox:ShowWindow(1);
	end
end

function COMPANIONSHOP_SELECT_COMPANION(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(topFrame, 'compaSelectSlot');
	local name = GET_CHILD_RECURSIVELY(topFrame, 'compaSelectText');
	local buyMoneyText = GET_CHILD_RECURSIVELY(topFrame, 'buyMoneyText');
	local selectedCompa = ctrl:GetUserValue('CLSNAME');
	local compaCls = GetClass('Companion', selectedCompa);
	local monCls = GetClass('Monster', selectedCompa);
	if compaCls == nil or monCls == nil then
		return;
	end

	local icon = CreateIcon(slot);
	icon:SetImage(monCls.Icon);
	name:SetTextByKey('name', monCls.Name);
	buyMoneyText:SetTextByKey('money', ctrl:GetUserValue('SELL_PRICE'));
	topFrame:SetUserValue('CLSNAME', selectedCompa);

	COMPANIONSHOP_UPDATE_REMAINMONEY(topFrame);
end

function COMPANIONSHOP_UPDATE_REMAINMONEY(frame)
	local remainMoneyText = GET_CHILD_RECURSIVELY(frame, 'remainMoneyText');
	local buyMoneyText = GET_CHILD_RECURSIVELY(frame, 'buyMoneyText');
	local visItem = session.GetInvItemByName("Vis");
	if visItem == nil then
		return;
	end

	local buyMoney = tonumber(buyMoneyText:GetTextByKey('money'));
	remainMoneyText:SetTextByKey('money', visItem.count - buyMoney);
end

function COMPANIONSHOP_CLEAR(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local slot = GET_CHILD_RECURSIVELY(topFrame, 'compaSelectSlot');
	local name = GET_CHILD_RECURSIVELY(topFrame, 'compaSelectText');
	local buyMoneyText = GET_CHILD_RECURSIVELY(topFrame, 'buyMoneyText');
	local compaNameEdit = GET_CHILD_RECURSIVELY(topFrame, 'compaNameEdit');
	local DEFAULT_ADOPT_NAME = topFrame:GetUserConfig('DEFAULT_ADOPT_NAME');

	slot:ClearIcon();
	compaNameEdit:ClearText();
	name:SetTextByKey('name', '');
	buyMoneyText:SetTextByKey('money', '0');
	topFrame:SetUserValue('CLSNAME', '');

	COMPANIONSHOP_UPDATE_REMAINMONEY(frame);
end

function COMPANIONSHOP_ADOPT(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local selectedCompa = topFrame:GetUserValue('CLSNAME');
	local compaCls = GetClass('Companion', selectedCompa);
	if compaCls == nil then
		return;
	end

	-- 일반적으로 0 이거나, 등록된 잡아이디와 같지 않으면 살수없음!
	-- ex) 응사는 매만 살 수 있다.
	if compaCls.JobID == 0 or 0 ~= session.GetJobGrade(compaCls.JobID) then
		TRY_CHECK_BARRACK_SLOT(frame, ctrl, true);
	else
		ui.MsgBox(ScpArgMsg("HaveNotJobForbyingCompaion"));
	end
end

function ON_COMPANIONSHOP_FOOD_TAB(frame, msg, argStr, argNum)
	local foodFrame = frame:GetChild('foodBox');
	SHOP_ON_MSG(foodFrame, "SHOP_ITEM_LIST_GET", argStr, argNum);
	OPEN_SHOPUI_COMMON();

	ON_OPEN_DLG_COMPANIONSHOP(frame, msg, argStr);
	COMPANIONSHOP_OPEN(frame);
end

function ON_COMPANIONSHOP_DIALOG_CLOSE(frame, msg, argStr, argNum)
	local foodFrame = frame:GetChild('foodBox');
	SHOP_ON_MSG(foodFrame, "DIALOG_CLOSE", argStr, argNum);
	frame:ShowWindow(0);
end

function COMPANIONSHOP_ADD_COMPANION_INFO(ctrlset, foodGroup) -- foodGroup은 string
	local compaList, cnt = GetClassList('Companion');
	if compaList == nil or cnt < 1 then
		return;
	end
	local numCompa = 1;
	local foodInfoBox = ctrlset:GetChild('foodInfoBox');
	local ICON_SIZE = 38;
	local width = foodInfoBox:GetWidth();
	for i = 0, cnt -1 do
		local compaCls = GetClassByIndexFromList(compaList, i);
		local monCls = GetClass('Monster', compaCls.ClassName);
		if TryGetProp(compaCls, 'FoodGroup') ~= nil and TryGetProp(monCls, 'Icon') ~= nil then
			if compaCls.FoodGroup ~= 'None' and compaCls.FoodGroup == foodGroup and string.find(compaCls.ClassName, 'dummy') == nil and string.find(compaCls.ClassName, 'baby') == nil then
				local compaPic = foodInfoBox:CreateControl('picture', 'COMPA_INFO_'..foodGroup..numCompa, width - ICON_SIZE * numCompa - 5 * numCompa, 0, ICON_SIZE, ICON_SIZE);
				compaPic = tolua.cast(compaPic, 'ui::CPicture');
				compaPic:SetImage(monCls.Icon);
				compaPic:SetEnableStretch(1);
				numCompa = numCompa + 1;
			end
		end
	end

	local MARKET_ARROW_IMG = ctrlset:GetUserConfig('MARKET_ARROW_IMG');
	local arrowPic = foodInfoBox:CreateControl('picture', 'COMPA_INFO_'..foodGroup..numCompa, width - ICON_SIZE * numCompa - 5 * numCompa + 10, 7, 30, 20);
	arrowPic = tolua.cast(arrowPic, 'ui::CPicture');
	arrowPic:SetImage(MARKET_ARROW_IMG);
end