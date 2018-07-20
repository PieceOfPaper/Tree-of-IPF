--itembuff.lua

function ITEMBUFF_ON_INIT(addon, frame)
	MAX_BYTE_OF_TITLE = 40;
end

function ITEMBUFF_SET_SKILLTYPE(frame, skillName, skillLevel, titleName)
	frame:SetUserValue("SKILLNAME", skillName)
	frame:SetUserValue("SKILLLEVEL", skillLevel)

	local title = frame:GetChild("title");
	title:SetTextByKey("txt", titleName);
end

function ITEM_STOR_FAIL()
	ui.SysMsg(ClMsg("CannotState"));
	ui.CloseFrame("itembuff");
end

function ITEMBUFF_REFRESH_LIST(frame)
	local reqitembox = frame:GetChild("Material");
	local reqitemtext = reqitembox:GetChild("reqitemCount");
	local reqitemName = reqitembox:GetChild("reqitemName");
	local reqitemStr = reqitembox:GetChild("reqitemStr");
	local pc = GetMyPCObject();
	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(invItemList, frame);
	local cls = GetClass("Item", name);
	local txt = GET_ITEM_IMG_BY_CLS(cls, 60);
	reqitemName:SetTextByKey("txt", txt);
	reqitemStr:SetTextByKey("txt", cls.Name);
	local text = cnt .. " " .. ClMsg("CountOfThings");
	reqitemtext:SetTextByKey("txt", text);
end

function ITEM_BUFF_CREATE_STORE(frame)
	ITEM_BUFF_CLOSE();
	local optionBox = frame:GetChild("OptionBox");
	local edit = GET_CHILD(optionBox, "TitleInput")
	local moneyInput = GET_CHILD(optionBox, "MoneyInput");

	local price = moneyInput:GetNumber();
	if price <= 0 then
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local titleLen = ui.GetCharNameLength(edit:GetText());
	if titleLen < 1 then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	elseif titleLen > MAX_BYTE_OF_TITLE then
		ui.MsgBox(ScpArgMsg("ShopNameMustLongerThen{ENG_LEN}{KOR_LEN}", "ENG_LEN", MAX_BYTE_OF_TITLE, "KOR_LEN", MAX_BYTE_OF_TITLE / 2));
		return;
	end

	session.autoSeller.ClearGroup("ItemBuffStore");	
	local sklName = frame:GetUserValue("SKILLNAME");
	local sklLevel = frame:GetUserIValue("SKILLLEVEL");
	local dummyInfo = session.autoSeller.CreateToGroup("ItemBuffStore");

	if sklName == 'Appraiser_Apprise' and price > APPRRISE_MAX_UNIT_MONEY then
		ui.MsgBox(ScpArgMsg("ApprisePriceMustLowerThan{PRICE}", "PRICE", APPRRISE_MAX_UNIT_MONEY));
		return;
	end

	dummyInfo.classID = GetClass("Skill", sklName).ClassID;
	dummyInfo.price = price;
	dummyInfo.level = sklLevel;

	local storeGroupName = frame:GetUserValue("STORE_GROUP_NAME");
	if storeGroupName == 'None' then
		storeGroupName = 'Squire';
	end

	if "" == edit:GetText() then
		return;
	end

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(invItemList, frame);

	if 0 == cnt then
		ui.MsgBox(ClMsg("NotEnoughRecipe"));
		return;
	end

	local material = session.GetInvItemByName(name);
	if nil == material then
		return;
	end

	if true == material.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	session.autoSeller.RequestRegister("ItemBuffStore", storeGroupName, edit:GetText(), sklName);
end

function OPEN_MY_ITEMBUFF_UI(groupName, sellType, handle)
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end

	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	if "Squire_Repair" == sklName then
		ITEMBUFF_REPAIR_UI_COMMON(groupName, sellType, handle);
		return;
	elseif "Alchemist_Roasting" == sklName then
		ITEMBUFFGEMROASTING_UI_COMMON(groupName, sellType, handle);
		return;
	elseif sklName == 'Appraiser_Apprise' then
		APPRAISAL_PC_UI_COMMON(groupName, sellType, handle);
		return;
    elseif groupName == 'Portal' then
		PORTAL_SELLER_OPEN_UI(groupName, sellType, handle);
		return;
	end

	OPEN_ITEMBUFF_UI_COMMON(groupName, sellType, handle);
end

function OPEN_ITEMBUFF_UI(groupName, sellType, handle)
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end

	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	if "Squire_Repair" == sklName then
		local frame = ui.GetFrame("itembuffrepair");
		ITEMBUFF_REPAIR_UI_COMMON(groupName, sellType, handle);
		SQUIRE_HIDE_UI(frame);
		REGISTERR_LASTUIOPEN_POS(frame);
		frame:RunUpdateScript("LASTUIOPEN_CHECK_PC_POS", 0.1);
		return
	elseif "Alchemist_Roasting" == sklName then
		local frame = ui.GetFrame("itembuffgemroasting");
		ITEMBUFFGEMROASTING_UI_COMMON(groupName, sellType, handle);
		GEMROASTING_HIDE_UI(frame);
		REGISTERR_LASTUIOPEN_POS(frame);
		frame:RunUpdateScript("LASTUIOPEN_CHECK_PC_POS", 0.1);
		return
	elseif sklName == 'Appraiser_Apprise' then
		APPRAISAL_PC_UI_COMMON(groupName, sellType, handle);
		return;
    elseif groupName == 'Portal' then
		PORTAL_SELLER_OPEN_UI(groupName, sellType, handle);
		return;
	end

	OPEN_ITEMBUFF_UI_COMMON(groupName, sellType, handle);

	local frame = ui.GetFrame("itembuffopen");
	SQUIRE_HIDE_UI(frame);
	REGISTERR_LASTUIOPEN_POS(frame);
	frame:RunUpdateScript("LASTUIOPEN_CHECK_PC_POS", 0.1);
end

function GEMROASTING_HIDE_UI(frame)
	local log = frame:GetChild("statusTab");
	log:SetVisible(0);
	local repairBox = frame:GetChild("roasting");
	local material = repairBox:GetChild("materialGbox");
	material:SetVisible(0);
end

function SQUIRE_HIDE_UI(frame)
	local log = frame:GetChild("statusTab");
	log:SetVisible(0);
	local repairBox = frame:GetChild("repair");

	local material = repairBox:GetChild("materialGbox");
	material:SetVisible(0);
end

function OPEN_ITEMBUFF_UI_COMMON(groupName, sellType, handle)
	if 	groupName == "None" then
		ui.CloseFrame("itembuffopen");
		ui.CloseFrame("inventory");	
		return;
	end
	
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local open = ui.GetFrame("itembuffopen");
	open:ShowWindow(1);
	open:SetUserValue("GroupName", groupName);

	local statusTab = open:GetChild('statusTab');
	ITEMBUFF_SHOW_TAB(statusTab, handle);

	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	local armor = open:GetChild("Squire_ArmorTouchUp");
	local Weapon = open:GetChild("Squire_WeaponTouchUp");
	
	if 'Squire_WeaponTouchUp' == sklName then 

		armor:SetVisible(0);
		Weapon:SetVisible(1);
	else

		armor:SetVisible(1);
		Weapon:SetVisible(0);
	end
	
	open:SetUserValue("SKILLNAME", sklName)
	open:SetUserValue("SKILLLEVEL", groupInfo.level);
	open:SetUserValue("HANDLE", handle);

	local repairBox = open:GetChild("repair");

	if session.GetMyHandle() == handle then
		local money = repairBox:GetChild("reqitemMoney");
		money:SetTextByKey("txt", groupInfo.price);
		local effectGbox = repairBox:GetChild("effectGbox");
	end
	
	open:SetUserValue("PRICE", groupInfo.price)
	
	local tabObj		    = open:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	itembox_tab:SelectTab(0);
	SQIORE_BUFF_VIEW(open);
	SQUTE_UI_RESET(open);
	SQUIRE_UPDATE_MATERIAL(open);
	ui.OpenFrame("inventory");
end

function ITEM_BUFF_CLOSE()
	ui.CloseFrame("itembuff");
end

function ITEM_BUFF_UI_CLOSE(handle)
	local frame = ui.GetFrame("BUFF_BALLOON_" .. handle);
	if nil ~= frame then
		DESTROY_FRAME("BUFF_BALLOON_" .. handle);
		frame:ShowWindow(0);
	end

	ui.CloseFrame("itembuffopen");	
end

function ITEMBUFF_SHOW_TAB(tabCtrl, handle)
	if handle == session.GetMyHandle() then
		tabCtrl:ShowWindow(1);
	else
		tabCtrl:ShowWindow(0);
	end
end