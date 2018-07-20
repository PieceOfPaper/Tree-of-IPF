-- switchgender.lua

function SWITCHGENDER_ON_INIT(addon, frame)
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
	local reqitemIamge = materialGbox:GetChild("reqitemImage");
	reqitemIamge:SetTextByKey("txt", "");
	reqitemIamge:SetUserValue("guid", "None");

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

	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
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

function SWITCHGENDER_DRAW_MATERAIL(frame, isTragetMode)
	if nil == isTragetMode then
		isTragetMode = 0;
	end

	local bg_mid = frame:GetChild("bg_mid");
	local targetgBox = bg_mid:GetChild("targetgBox");
	targetgBox:ShowWindow(isTragetMode);

	local materialGbox = bg_mid:GetChild("materialGbox");
	if 0 ~= isTragetMode then
		materialGbox:ShowWindow(0);
		return;
	end

	materialGbox:ShowWindow(1);
	
	local skl = GetClass("Skill", 'Oracle_SwitchGender');
	if nil == skl then
		return;
	end

	local cls = GetClass("Item", skl.SpendItem);
	if nil == cls then
		return;
	end

	local reqitemImage = materialGbox:GetChild('reqitemImage');
	reqitemImage:SetTextByKey("txt", GET_ITEM_IMG_BY_CLS(cls, 60));
	local reqitemNameStr = materialGbox:GetChild('reqitemNameStr');
	reqitemNameStr:SetTextByKey("txt", cls.Name);
	
	local reqitemCount = materialGbox:GetChild('reqitemCount');
	local text = session.GetInvItemCountByType(cls.ClassID) .. " " .. ClMsg("CountOfThings");
	reqitemCount:SetTextByKey("txt", text);
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

	local charimgName = ui.CaptureFullStdImage(pcjobinfo.ClassID, changeGender, headIndex, 1);
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
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	if nil == itembox_tab then
		return;
	end
	
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();

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
function SWITCHGENDER_OPEN_UI_SET(frame, sklName)
	SWITCHGENDER_UI_OPEN(frame, IS_OPENED_SWITCHGENDER(frame));
	SWITCHGENDER_VIEW_OPEN(frame, 0);
	frame:SetUserValue("GroupName", sklName)
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

	local skillName = frame:GetUserValue("GroupName");
	session.autoSeller.Buy(handle, 1, 1, AUTO_SELL_ORACLE_SWITCHGENDER);
	DISABLE_BUTTON_DOUBLECLICK("switchgender", ctrl:GetName())
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