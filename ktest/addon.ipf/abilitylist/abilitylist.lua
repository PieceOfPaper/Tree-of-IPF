function ABILITYLIST_ON_INIT(addon, frame)

end

function ABILITYLIST_OPEN(frame)

	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end

	--REFRESH_ABILITY_LIST(frame);
	frame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", imcTime.GetAppTime());
end

function ABILITYLIST_CLOSE(frame)
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 0 and ui.IsVisibleFramePIPType('abilitylist') == false then
		questInfoSetFrame:ShowWindow(1);
	end

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();
end

function REFRESH_ABILITY_LIST_OLD(frame)

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local grid = GET_CHILD(frame, 'ability', 'ui::CGrid');
	DESTROY_CHILD_BYNAME(grid, 'ABIL_');
	local posY = 20;

	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
	-- learningAbility
		if pc[prop] ~= nil and pc[prop] > 0 then
			local abilClass = GetClassByType("Ability", pc[prop]);
		if abilClass ~= nil then
				posY = MAKE_ABILITY_ICON(frame, pc, grid, abilClass, posY, i);
		end
	end
	end
	

	-- Ability
	local abilList = session.GetAbilityList();
	local abilListCnt = 0;
	if abilList ~= nil then
		abilListCnt = abilList:Count();
	end

	if abilListCnt > 0 then
		for i=0, abilListCnt do
			local abil = session.GetAbilityByIndex(i);
			if abil ~= nil then
				local cls = GetIES(abil:GetObject());
				posY = MAKE_ABILITY_ICON(frame, pc, grid, cls, posY);
			end
		end
	end

	-- ActiveAbility  �̰� �Ⱦ�����.
	--for i=0, MAX_ACTIVE_ABILITY do
	--	local activeAbil = session.GetActiveAbility(i);
	--	if activeAbil ~= nil then
	--		local cls = GetIES(activeAbil:GetObject());
	--		posY = MAKE_ABILITY_ICON(frame, pc, grid, cls, posY);
	--	end
	--end

	frame:Invalidate();
end

function MAKE_ABILITY_ICON_OLD(frame, pc, grid, abilClass, posY, index)

	local classCtrl = grid:CreateOrGetControlSet('ability_set', 'ABIL_'..abilClass.ClassName, 0, posY);
	classCtrl:ShowWindow(1);
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] == abilClass.ClassID then
	-- ���� ���� Ư���� ������ �ش�Ư���� �����ð� ǥ��, Ȱ����ư�� ����
		local activeImg = GET_CHILD(classCtrl, "activeImg", "ui::CPicture");
		activeImg:ShowWindow(0);
	else
		-- Ư�� Ȱ��ȭ ��ư
		classCtrl:EnableHitTest(1);
		classCtrl:SetEventScript(ui.LBUTTONUP, "TOGGLE_ABILITY_ACTIVE");
		classCtrl:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		classCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		classCtrl:SetOverSound('button_over');
		classCtrl:SetClickSound('button_click_big');

		-- Ȱ��/��Ȱ���� ���� �̹��� ����
		local activeImg = GET_CHILD(classCtrl, "activeImg", "ui::CPicture");
		local activeText = GET_CHILD(classCtrl, "abilActive", "ui::CRichText");

		if abilClass.ActiveState == 1 then
			activeImg:SetImage("ability_on");
		else
			activeImg:SetImage("ability_off");
		end
		activeImg:ShowWindow(1);
	end
	end
	-- Ư�� ������
	local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
	local icon = CreateIcon(classSlot);	
	icon:SetImage(abilClass.Icon);

	-- Ư�� �̸�
	local nameCtrl = GET_CHILD(classCtrl, "abilName", "ui::CRichText");
	nameCtrl:SetText("{@st41}".. abilClass.Name);

	-- Ư�� ����
	local descCtrl = GET_CHILD(classCtrl, "abilDesc", "ui::CRichText");
	descCtrl:SetText("{@st42b}".. abilClass.Desc);

	-- Ư�� ����
	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if abilIES ~= nil and pc[prop] ~= nil and abilIES.ClassID ~= pc[prop] then
		local abilLv = abilIES.Level;

		local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
		levelCtrl:SetText("{@sti9}Lv.".. abilLv);

		-- Ư�� ����ó
		local shopCtrl = GET_CHILD(classCtrl, "abilShop", "ui::CRichText");
		shopCtrl:SetText(ScpArgMsg("Auto_{@st42}{b}{#ff9900}JeonSuJa_:_").. "NPC");
		shopCtrl:ShowWindow(1);
	else

		-- Ư�� ������
		local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
		levelCtrl:SetText("{@st42}Lv.1");
		if abilIES ~= nil then
			local abilLv = abilIES.Level + 1;
			levelCtrl:SetText("{@st42}Lv." .. abilLv);
		end

		local sysTime = geTime.GetServerSystemTime();
			local prop = "None";
			if 0 == i then
				prop = "LearnAbilityTime";
			else
				prop = "LearnAbilityTime" ..index;
			end
			local learnAbilTime = imcTime.GetSysTimeByStr(pc[prop]);
		local difSec = imcTime.GetDifSec(learnAbilTime, sysTime);
		local min = math.floor(difSec / 60);

		local shopCtrl = GET_CHILD(classCtrl, "abilShop", "ui::CRichText");
		shopCtrl:SetText("{@st42b}{s16}{#f0dcaa}[" .. abilClass.Name .. ScpArgMsg("Auto_]_TeugSeong_HagSeupJung.._(") .. min .. ScpArgMsg("Auto_Bun_Nameum)") );

		if min <= 1 then
			shopCtrl:SetText("{@st42b}{s16}{#ffcc33}[" .. abilClass.Name .. ScpArgMsg("Auto_]_TeugSeong_Kot_SeupDeug!_(1Bun_iNae)") );
		end

		local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_LEARN_ABIL_TIME");
		timer:Stop();
		timer:Start(1, 0);
		frame:SetUserValue("LEARN_ABIL_NAME", abilClass.Name);
		frame:SetUserValue("LEARN_ABIL_CLASSNAME", abilClass.ClassName);
	end
	end

	return posY + classCtrl:GetHeight();
end

function UPDATE_LEARN_ABIL_TIME_OLD(frame, timer, str, num, time, index)

	local pc  = GetMyPCObject();
	local sysTime = geTime.GetServerSystemTime();
	local prop = "None";
	if 0 == index then
		prop = "LearnAbilityTime";
	else
		prop = "LearnAbilityTime" ..index;
	end
	local learnAbilTime = imcTime.GetSysTimeByStr(pc[prop]);
	local difSec = imcTime.GetDifSec(learnAbilTime, sysTime);
	local min = math.floor(difSec / 60);
		
	local abilName = frame:GetUserValue("LEARN_ABIL_NAME");
	local abilClassName = frame:GetUserValue("LEARN_ABIL_CLASSNAME");

	local grid = GET_CHILD(frame, 'ability', 'ui::CGrid');
	local classCtrl = grid:CreateOrGetControlSet('ability_set', 'ABIL_'..abilClassName, 0, 0);
	local shopCtrl = GET_CHILD(classCtrl, "abilShop", "ui::CRichText");
	shopCtrl:SetText("{@st42b}{s16}{#f0dcaa}[" .. abilName .. ScpArgMsg("Auto_]_TeugSeong_HagSeupJung.._(") .. min .. ScpArgMsg("Auto_Bun_Nameum)") );
	if min == 1 then
		shopCtrl:SetText("{@st42b}{s16}{#ffcc33}[" .. abilName .. ScpArgMsg("Auto_]_TeugSeong_Kot_SeupDeug!_(1Bun_iNae)") );

	elseif min == 0 then
		timer:Stop();
	end
end

function TOGGLE_ABILITY_ACTIVE_OLD(frame, control, abilName, abilID)

	local curTime = imcTime.GetAppTime();
	local topFrame = frame:GetParent();
	local prevClickTime = tonumber( topFrame:GetUserValue("CLICK_ABIL_ACTIVE_TIME") );
	if prevClickTime + 0.1 > curTime then
		return;
	end

	topFrame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", curTime);
	pc.ReqExecuteTx("SCR_TX_PROPERTY_ACTIVE_TOGGLE", abilName);
end

