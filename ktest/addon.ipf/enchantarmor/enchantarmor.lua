-- enchantcostum.lua

function ENCHANTAMOR_ON_INIT(addon, frame)
end

function AUTOSELLER_REGISTER_FRAME_INIT(frame, obj)
	frame:SetUserValue("SKILLNAME", obj.ClassName)
	frame:SetUserValue("SKILLLEVEL", obj.Level)
end

function ENCHANTARMOR_OPEN_UI_SET(frame, obj)
	AUTOSELLER_REGISTER_FRAME_INIT(frame, obj);
	
	local repair = frame:GetChild('repair');
	local materialGbox = repair:GetChild('materialGbox');
	local reqitemNameStr = materialGbox:GetChild("reqitemNameStr");
	local reqitemCount = materialGbox:GetChild("reqitemCount");
	local reqitemImage = materialGbox:GetChild("reqitemImage");

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. obj.ClassName];
	local name, cnt = checkFunc(invItemList, frame);

	local cls = GetClass("Item", name);
	local txt = GET_ITEM_IMG_BY_CLS(cls, 60);
	reqitemImage:SetTextByKey("txt", txt);
	reqitemNameStr:SetTextByKey("txt", cls.Name);
	local text = cnt .. " " .. ClMsg("CountOfThings");
	reqitemCount:SetTextByKey("txt", text);
end

function ENCHANTARMOR_BUFF_EXCUTE_BTN(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local repair = frame:GetChild('repair');
	local moneyGbox = repair:GetChild("moneyGbox");
	local moneyInput = GET_CHILD(moneyGbox, "MoneyInput");

	local price = moneyInput:GetNumber();
	if price <= 0 then
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local titleGbox = repair:GetChild("titleGbox");
	local titleInput = GET_CHILD(titleGbox, "titleInput");
	if string.len( titleInput:GetText() ) == 0 or "" == titleInput:GetText() then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	end

	local sklName = frame:GetUserValue("SKILLNAME");
	session.autoSeller.ClearGroup(sklName);	
	local sklLevel = frame:GetUserIValue("SKILLLEVEL");
	local dummyInfo = session.autoSeller.CreateToGroup(sklName);
	dummyInfo.classID = GetClass("Skill", sklName).ClassID;
	dummyInfo.price = price;
	dummyInfo.level = sklLevel;

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. sklName];
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

	session.autoSeller.RequestRegister(sklName, sklName, titleInput:GetText(), sklName);
end