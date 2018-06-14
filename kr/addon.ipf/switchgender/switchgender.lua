-- switchgender.lua

function SWITCHGENDER_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_MATERIAL_COUNT', 'ON_UPDATE_MATERIAL_COUNT');
end

function IS_OPENED_SWITCHGENDER(frame)
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return 0;
	end

	return 1;
end

function SWITCHGENDER_RESET_UI(frame)
	local bg_mid = frame:GetChild("bg_mid");
	local materialGbox = bg_mid:GetChild("materialGbox");	
	local reqitemName = materialGbox:GetChild("reqitemNameStr");
	reqitemName:SetTextByKey("txt", "");
	local reqitemtext = materialGbox:GetChild("reqitemCount");
	reqitemtext:SetTextByKey("txt", "");
end

function SWITCHGENDER_STORE_OPEN(groupName, sellType, handle)
	local frame = ui.GetFrame("switchgender");
	frame:SetUserValue("GroupName", groupName)
	frame:SetUserValue("HANDLE", handle);
	if groupName == 'None' then
		frame:SetUserValue("HANDLE", 'None');
		frame:ShowWindow(0)
		return;
	end

	local tabObj = frame:GetChild('statusTab');
	local itembox_tab = tolua.cast(tabObj, "ui::CTabControl");
	itembox_tab:SelectTab(0);
	SWITCHGENDER_VIEW_OPEN(frame, 0);
	SWITCHGENDER_UI_OPEN(frame, 1);

	if session.GetMyHandle() == handle then
		if 0 == IS_OPENED_SWITCHGENDER(frame) then
			return;
		end
		itembox_tab:ShowWindow(1);
		SWITCHGENDER_DRAW_CHANGE_STATE(frame);
	else
		SWITCHGENDER_DRAW_CHANGE_STATE(frame);
		SWITCHGENDER_DRAW_MATERAIL(frame, 1);
		itembox_tab:ShowWindow(0);
	end

	frame:ShowWindow(1);
end

function SWITCHGENDER_DRAW_MATERAIL(frame, isTargetMode)
	if nil == isTargetMode then
		isTargetMode = 0;
	end

	local bg_mid = frame:GetChild("bg_mid");
	local targetgBox = bg_mid:GetChild("targetgBox");
	targetgBox:ShowWindow(isTargetMode);

	local materialGbox = bg_mid:GetChild("materialGbox");
	if isTargetMode == 1 then
		local countText = GET_CHILD_RECURSIVELY(frame, 'count');
		countText:ShowWindow(0);
	end

	SWITCHGENDER_UPDATE_NEED_MATERIAL_CNT(frame, isTargetMode);
end

function SWITCHGENDER_DRAW_CHANGE_STATE(frame)
	local bg_mid = frame:GetChild("bg_mid");
	local repair = frame:GetChild("repair");
	local changeGender = 2; -- 남성이 기본 여자로 셋팅
	local msg = ScpArgMsg("Auto_NamSeong") .. ' -> ' ..ScpArgMsg("Auto_yeoSeong");
	if GETMYPCGENDER() == 2 then -- 여자면 남자로
		changeGender = 1;
		msg = ScpArgMsg("Auto_yeoSeong") .. '->' ..ScpArgMsg("Auto_NamSeong");
	end

	local myIconInfo = info.GetIcon( session.GetMyHandle() );
	local headIndex = myIconInfo:GetHeadIndex();

	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)

    local changeHeadIndex = headIndex;
    local etc = GetMyEtcObject();
    if changeGender == 2 then -- 여자로 바꾸는 경우는, 기본헤어가 다를 수도 있어
        local startFemaleHairType = TryGetProp(etc, 'StartFemaleHairType');
        if startFemaleHairType ~= nil and startFemaleHairType > 0 then
            changeHeadIndex = startFemaleHairType + 1;
        end
    end

    if etc.BeautyshopStartHair == 'Yes' then
    	changeHeadIndex = 1; -- ShortCut
    end

	local charimgName = ui.CaptureFullStdImage(pcjobinfo.ClassID, changeGender, changeHeadIndex, 1);
	local changepic = GET_CHILD(repair, "changepic");
	changepic:SetImage(charimgName);

	local myImgName = ui.CaptureFullStdImage(pcjobinfo.ClassID, GETMYPCGENDER(), headIndex, 2);
	local mypic = GET_CHILD(repair, "mypic");
	mypic:SetImage(myImgName);

	local effectGbox = bg_mid:GetChild("effectGbox");
	local switch = effectGbox:GetChild("switch");
	switch:SetTextByKey('value',msg);
end

function SWITCHGENDER_UI_OPEN(frame, showWindow)
	SWITCHGENDER_RESET_UI(frame);

	local checkbox = frame:GetChild('checkbox');
	local repair = frame:GetChild('repair');
	local moneyGbox = frame:GetChild('moneyGbox');
	local titleGbox = frame:GetChild('titleGbox');	
	if 0 == showWindow then -- 아직 상점 열기 전
		checkbox:ShowWindow(1);
		local btn_excute = repair:GetChild('btn_excute');
		btn_excute:ShowWindow(0);
		local btn_excute_1 = repair:GetChild('btn_excute_1');
		btn_excute_1:ShowWindow(1);

		local money = moneyGbox:GetChild('money');
		money:ShowWindow(0);
		local moneyInput = moneyGbox:GetChild('moneyInput');
		moneyInput:ShowWindow(1);

		local title = titleGbox:GetChild('title_1');
		title:ShowWindow(0);
		local titleInput = titleGbox:GetChild('titleInput');
		titleInput:ShowWindow(1);

		local changepic = GET_CHILD(repair, "changepic");
		changepic:ShowWindow(0);

		local mypic = GET_CHILD(repair, "mypic");
		mypic:ShowWindow(0);
		SWITCHGENDER_DRAW_MATERAIL(frame, 0);
		return;
	end

	 -- 아직 상점 열기 후
	checkbox:ShowWindow(0);
	local btn_excute = repair:GetChild('btn_excute');
	btn_excute:ShowWindow(1);
	local btn_excute_1 = repair:GetChild('btn_excute_1');
	btn_excute_1:ShowWindow(0);

	local money = moneyGbox:GetChild('money');
	money:ShowWindow(1);
	local moneyInput = moneyGbox:GetChild('moneyInput');
	moneyInput:ShowWindow(0);

	local titleInput = titleGbox:GetChild('titleInput');
	titleInput:ShowWindow(0);

	local groupName = frame:GetUserValue("GroupName");

	local titleName = session.autoSeller.GetTitle(groupName);
	local title_1 = titleGbox:GetChild('title_1');
	title_1:ShowWindow(1);
	title_1:SetTextByKey("txt", titleName);

	local changepic = repair:GetChild('changepic');
	changepic:ShowWindow(1);

	local mypic = repair:GetChild('mypic');
	mypic:ShowWindow(1);
	
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if nil == groupInfo then
		return;
	end

	SWITCHGENDER_DRAW_MATERAIL(frame, 0);
	money:SetTextByKey("txt", groupInfo.price);
end

function SWITCHGENDER_TAP_CHANGE(frame)
	local tabObj = frame:GetChild('statusTab');
	local itembox_tab = tolua.cast(tabObj, "ui::CTabControl");
	if nil == itembox_tab then
		return;
	end
	
	local curtabIndex = itembox_tab:GetSelectItemIndex();

	if IS_OPENED_SWITCHGENDER(frame) == 0 and curtabIndex == 1 then
		ui.SysMsg(ClMsg("DonnotOpenautoseller"));
		itembox_tab:SelectTab(0);
		return;
	end

	SWITCHGENDER_VIEW_OPEN(frame, curtabIndex);
end

function SWITCHGENDER_VIEW_OPEN(frame, index)
	local repair = frame:GetChild("repair");
	local bg_mid = frame:GetChild("bg_mid");
	local moneyGbox = frame:GetChild('moneyGbox');
	local titleGbox = frame:GetChild('titleGbox');
	local log = frame:GetChild("log");

	if 0 == index then
		repair:ShowWindow(1);
		bg_mid:ShowWindow(1);
		moneyGbox:ShowWindow(1);
		titleGbox:ShowWindow(1);
		log:ShowWindow(0);
	else
		repair:ShowWindow(0);
		bg_mid:ShowWindow(0);
		moneyGbox:ShowWindow(0);
		titleGbox:ShowWindow(0);
		log:ShowWindow(1);
	end
end
function SWITCHGENDER_OPEN_UI_SET(frame, sklName, isSellerOpen)
    local isOpened = IS_OPENED_SWITCHGENDER(frame);
    if isSellerOpen == true then
        isOpened = 0;
    end
	SWITCHGENDER_UI_OPEN(frame, isOpened);
	SWITCHGENDER_VIEW_OPEN(frame, 0);
	frame:SetUserValue("GroupName", sklName)
	
	local moneyInput = GET_CHILD_RECURSIVELY(frame, 'moneyInput');
	if moneyInput ~= nil then
		SWITCHGENDER_USER_SHOP_PRICE(sklName, moneyInput);
	end
end

function SWITCHGENDER_USER_SHOP_PRICE(sklClassName, editCtrl)
	local userPriceCls = GetClass('UserShopPrice', sklClassName);	
	if userPriceCls ~= nil then
		local priceType = userPriceCls.PriceType;
		local price = 0;
		if priceType == 'UnitPrice' then
			price = userPriceCls.DefaultPrice;
		elseif priceType == 'ConstantPrice' then
			local GetPriceScp = _G[TryGetProp(userPriceCls, 'Price', 'None')];
			if GetPriceScp ~= nil then
				price = GetPriceScp(sklClassName);
				if price < 1 then
					IMC_LOG('ERROR_LOGIC', 'PROCESS_USER_SHOP_PRICE: price error- shop['..sklClassName..'], argStr['..argStr..']');
				end
			end	
		end
		editCtrl:SetText(price);
		editCtrl:EnableHitTest(0);
		return;
	end
	editCtrl:EnableHitTest(1);
end

function SWITCHGENDER_TRY_UI_CLOSE(frame, ctrl)
	local frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function SWITCHGENDER_BUFF_EXCUTE_BTN(frame, ctrl)
	local frame = frame:GetTopParentFrame();
	local targetbox = frame:GetChild("bg_mid");
	local effectBox = targetbox:GetChild("materialGbox");
	local reqitemImage = effectBox:GetChild("reqitemImage");
	local handle = frame:GetUserIValue("HANDLE");
	if session.GetMyHandle() == handle then	
		ui.MsgBox(ClMsg("DonotUseMySelf"));
		return;
	end

	local frame = ui.GetFrame('switchgender');
	local skillName = frame:GetUserValue("GroupName");
	local sklCls = GetClass('Skill', 'Oracle_SwitchGender');
	local reqitem_slot = GET_CHILD_RECURSIVELY(frame, 'reqitem_slot');
	local icon = reqitem_slot:GetIcon();	
	if icon == nil then
		local needItemCls = GetClass('Item', GET_SWITCHGENDER_MATERIAL_ITEM_NAME());
		ui.SysMsg(ScpArgMsg('SwitchGenderNeed{ITEM}', 'ITEM', needItemCls.Name));
		return;
	end

	local etc = GetMyEtcObject();
	if etc.BeautyshopStartHair == 'Yes' then
		local yesscp = string.format('_SWITCHGENDER_BUFF_EXCUTE_BTN(%d, "%s", "%s")', handle, ctrl:GetName(), icon:GetInfo():GetIESID());
		ui.MsgBox(ClMsg('ChangeHairForcelyIfYouSwitchGender'), yesscp, 'None');
		return;
	end

	session.autoSeller.BuyWithMaterialItem(handle, sklCls.ClassID, AUTO_SELL_ORACLE_SWITCHGENDER, icon:GetInfo():GetIESID(), '0');

	DISABLE_BUTTON_DOUBLECLICK("switchgender", ctrl:GetName())
	DISABLE_BUTTON_DOUBLECLICK("switchgender", 'btn_cencel')
end

function _SWITCHGENDER_BUFF_EXCUTE_BTN(handle, ctrlName, matItemGuid)
	local frame = ui.GetFrame('switchgender');
	local skillName = frame:GetUserValue("GroupName");
	local sklCls = GetClass('Skill', 'Oracle_SwitchGender');
	session.autoSeller.BuyWithMaterialItem(handle, sklCls.ClassID, AUTO_SELL_ORACLE_SWITCHGENDER, matItemGuid, '0');

	DISABLE_BUTTON_DOUBLECLICK("switchgender", ctrlName)
	DISABLE_BUTTON_DOUBLECLICK("switchgender", 'btn_cencel')
end

function SWITCHGENDER_STORE_CLOSE(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end

	session.autoSeller.Close(groupName);
	frame:ShowWindow(0);
end

function SWITCHGENDER_STORE_OPEN_EXCUTE(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local repair = frame:GetChild('bg_mid');
	local moneyGbox = frame:GetChild('moneyGbox');
	local moneyInput = moneyGbox:GetChild('moneyInput');
	local price = moneyInput:GetNumber();
	if price <= 0 then
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;

	end
	local titleGbox = frame:GetChild('titleGbox');
	local titleInput = titleGbox:GetChild('titleInput');
	if string.len( titleInput:GetText() ) == 0 or "" == titleInput:GetText() then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	end

	local groupName = frame:GetUserValue("GroupName");
	session.autoSeller.ClearGroup(groupName);	

	local skill = session.GetSkillByName(groupName);
	if nil == skill then
		return
	end

	local needItemName = GET_SWITCHGENDER_SELLER_SPEND_ITEM();
	local cls = GetClass("Item", needItemName);
	if session.GetInvItemCountByType(cls.ClassID) < 1 then
		ui.SysMsg(ClMsg('NotEnoughMaterial'));
		return;
	end

	local dummyInfo = session.autoSeller.CreateToGroup(groupName);
	dummyInfo.classID = GetClass("Skill", groupName).ClassID;
	dummyInfo.price = price;
	local obj = GetIES(skill:GetObject());
	dummyInfo.level = obj.Level;
	session.autoSeller.RequestRegister(groupName, groupName, titleInput:GetText(), groupName);
end

function SWITCHGENDER_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);

	local gboxctrl = frame:GetChild("log");
	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = log_gbox:CreateControlSet("switchgender_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local sList = StringSplit(info:GetHistoryStr(), "#");
		local desc = ctrlSet:GetChild("desc");
		desc:SetTextByKey("text", sList[1]);
		local nowGender = ScpArgMsg("Auto_NamSeong");
		local befroe = ScpArgMsg("Auto_yeoSeong");
		if sList[2] == '2' then
			nowGender = ScpArgMsg("Auto_yeoSeong")
			befroe = ScpArgMsg("Auto_NamSeong");
		end
		desc:SetTextByKey("before", befroe);
		desc:SetTextByKey("after", nowGender);

		local time = ctrlSet:GetChild("time");
		time:SetTextByKey("value", sList[3]);
	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end

function SWITCHGENDER_UPDATE_NEED_MATERIAL_CNT(frame, isTargetMode)
	local needCntText = GET_CHILD_RECURSIVELY(frame, 'needCntText');
	local reqitemCount = GET_CHILD_RECURSIVELY(frame, 'reqitemCount');
	local reqitem_slot = GET_CHILD_RECURSIVELY(frame, 'reqitem_slot');
	needCntText:ShowWindow(isTargetMode);

	if isTargetMode == 1 then
		local needItemName = GET_SWITCHGENDER_MATERIAL_ITEM_NAME();		
		local cls = GetClass('Item', needItemName);
		local needItemCnt = session.GetInvItemCountByType(cls.ClassID);		
		local countText = tostring(needItemCnt);
		if needItemCnt < 1 then
			countText = '{#FF0000}'..countText..'{/}'
		end
		countText = countText..'/1 '..ClMsg("CountOfThings");

		reqitemCount:SetTextByKey('txt', countText);
		reqitem_slot:ClearIcon();
	else
		local needItemName = GET_SWITCHGENDER_SELLER_SPEND_ITEM();
		local cls = GetClass("Item", needItemName);
		SET_SLOT_ITEM_CLS(reqitem_slot, cls);

		local text = session.GetInvItemCountByType(cls.ClassID) .. " " .. ClMsg("CountOfThings");
		reqitemCount:SetTextByKey("txt", text);
	end
end

function SWITCHGENDER_DROP_ITEM(parent, ctrl)
	local liftIcon = ui.GetLiftIcon();
	local slot = tolua.cast(ctrl, ctrl:GetClassString());
	local iconInfo = liftIcon:GetInfo();
	local invItem, isEquip = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());	
	if invItem == nil or invItem:GetObject() == nil then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local needItemCls = GetClass('Item', GET_SWITCHGENDER_MATERIAL_ITEM_NAME());
	if itemObj.ClassName ~= needItemCls.ClassName then
		ui.SysMsg(ScpArgMsg('SwitchGenderNeed{ITEM}', 'ITEM', needItemCls.Name));
		return;
	end

	SET_SLOT_ITEM(slot, invItem, invItem.count);	
end

function ON_UPDATE_MATERIAL_COUNT(frame, msg, argStr, argNum)
	SWITCHGENDER_UPDATE_NEED_MATERIAL_CNT(frame, 1);
end