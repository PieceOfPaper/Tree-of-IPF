-- briquetting.lua

function BRIQUETTING_ON_INIT(addon, frame)

end

function BRIQUETTING_SET_SKILLTYPE(frame, skillName, skillLevel)
	frame:SetUserValue("SKILLNAME", skillName)
	frame:SetUserValue("SKILLLEVEL", skillLevel)
end

function BRIQUETTING_UI_CLOSE()
	ui.CloseFrame("briquetting");	
end

function BRIQUETTING_SLOT_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_RESET(frame);
end

function BRIQUETTIN_MAX_MIN_TEXT(nowPower, min, max)
	return string.format("%d > {#FF0000}%d ~ {#00FF00}%d", nowPower, min, max);
end

function BRIQUETTING_SLOT_SET(richtxt, item)
	if nil == item then
		richtxt:SetTextByKey("guid", "");
		richtxt:SetTextByKey("itemtype", "");
		return;
	end
	richtxt:SetTextByKey("guid", item:GetIESID());
	richtxt:SetTextByKey("itemtype", item.type);
end

function BRIQUETTING_SLOT_DROP(parent, ctrl)
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- 슬롯 박스에 이미지를 넣고
	local itemCls = GetClassByType("Item", invItem.type);
	
	SET_SLOT_ITEM_IMANGE(slot, invItem);

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return nil;
	end
	-- 원래 공격력, 마공을 가진 object를 만든다.
	local tempObj = CreateIESByID("Item", itemCls.ClassID);
	if nil == tempObj then
		return;
	end
	local refreshScp = tempObj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(tempObj);
	end	

	local frame				= parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext      = bodyGBox:GetChild("slotName");
	bodyGBox:RemoveChild('tooltip_only_pr');

	-- 이름을 표시한다.
	slotNametext:SetTextByKey("txt", obj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);

	-- 이후 최대, 최소 공격력, 포텐셜을표시한다.

	-- 컨트롤 셋으로 저장되어있는 포텐셜을 생성해 메인 bodx에 붙인다.
	local nowPotential = bodyGBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 40, 290);
	tolua.cast(nowPotential, "ui::CControlSet");
	-- 컨트롤셋 ui에 있는 pr_gauge를 찾아 현재 포텐셜과 본래 포텐셜을 표시하고
	local pr_gauge = GET_CHILD(nowPotential,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(obj.PR, tempObj.PR);
	-- pr_txt는 현재 여기서 보일 필요가 없다.
	local pr_txt = GET_CHILD(nowPotential,'pr_text','ui::CGauge')
	pr_txt:SetVisible(0);

	-- 최대, 최소를 작성하고자 해당 항목의 속성을 가지고 옵니다.
	local minPowerStr = bodyGBox:GetChild("minPowerStr");
	local maxPowerStr = bodyGBox:GetChild("maxPowerStr");

	-- 어떤 타입의 무기인지를 확인하는 속성을 리턴합니다.
	-- 이 함수를 보시면 무기에 근접 무기면 최대, 최소공격력을
	-- 마법공격력의 무기면 마법공격력과  빈  글자를 리턴합니다.
	local prop1, prop2 = GET_ITEM_PROPERT_STR(obj);
	
	-- 받은 내용의 값을 토대로, param1에 정의한 키값을 변경해줍니다.
	minPowerStr:SetTextByKey("txt", prop2);
	maxPowerStr:SetTextByKey("txt", prop1);
	
	local checkValue = _G["ALCHEMIST_VALUE_" .. frame:GetUserValue("SKILLNAME")];
	-- 이것은 각각의 최대 최소의 수치를 표시하고자 하는 속성입니다.
	local maxPower = bodyGBox:GetChild("maxPower");
	local minPower = bodyGBox:GetChild("minPower");
	if obj.BasicTooltipProp == "ATK" then
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MAXATK); -- 최대
		maxPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MAXATK, min, max));
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MINATK); -- 최소
		minPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MINATK, min, max));

	elseif obj.BasicTooltipProp == "MATK" then -- 마법공격력
		local min, max = checkValue(frame:GetUserIValue("SKILLLEVEL"), tempObj.MATK);
		maxPower:SetTextByKey("txt", BRIQUETTIN_MAX_MIN_TEXT(tempObj.MATK, min, max));
		minPower:SetTextByKey("txt", prop2);
	end

	local checkValue = _G["ALCHEMIST_NEEDITEM_" .. frame:GetUserValue("SKILLNAME")];
	local name, count = checkValue(GetMyPCObject(), tempObj);
	BRIQUETTING_REFRESH_MATERIAL(frame, count .. " " ..ClMsg("CountOfThings"));
	DestroyIES(tempObj);
end

function BRIQUETTING_SPEND_DROP(parent, ctrl)
	local invItem = BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	if nil == invItem or nil == slot then
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	-- 슬롯 박스에 이미지를 넣고
	SET_SLOT_ITEM_IMANGE(slot, invItem);
	local frame				= parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext		= bodyGBox:GetChild("spendName");

	local obj = GetIES(invItem:GetObject());
	if nil == obj then 
		return nil;
	end

	-- 이름을 표시한다.
	slotNametext:SetTextByKey("txt", obj.Name);
	BRIQUETTING_SLOT_SET(slotNametext, invItem);
end

function BRIQUETTING_SKILL_EXCUTE(parent)
	local frame = parent:GetTopParentFrame();
	local bodyGBox			= frame:GetChild("bodyGbox");
	local slotNametext		= bodyGBox:GetChild("spendName");
	local mainSlotName      = bodyGBox:GetChild("slotName");

	local index = 0;
	local slotName = frame:GetUserValue('SELECT');
	if slotName == 'checkbox_1' then
		index = 1;
	elseif slotName == 'checkbox_2' then
		index = 2;
	end

	local abil = session.GetAbilityByName('Alchemist10')
	if index > 0 then 
		if nil == abil then 
			ui.SysMsg(ClMsg("DonotLearnAbility"));
			return;
		end

		local mainGuid = mainSlotName:GetTextByKey("guid");
		local mainItem = session.GetInvItemByGuid(mainGuid);
		local spend = slotNametext:GetTextByKey("guid");
		local spendItem = session.GetInvItemByGuid(spend);		
		if nil == mainItem or spendItem == nil then
			return;
		end
		
		local mainObj = GetIES(mainItem:GetObject())
		local spendObj = GetIES(spendItem:GetObject())
		if mainObj.ClassType ~= spendObj.ClassType then
			ui.SysMsg(ClMsg("NeedSameEquipClassType"));
			return;
		end

	end
	Alchemist.ExcuteBriquetting(mainSlotName:GetTextByKey("guid"), slotNametext:GetTextByKey("guid"), index);
end

function BRIQUETTING_SPEND_POP(parent)
	local frame = parent:GetTopParentFrame();
	BRIQUETTING_UI_SPEND_RESET(frame);
end

function BRIQUETTING_SLOT_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local iconInfo			= liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return nil;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	if nil == session.GetInvItemByType(invItem.type) then
		ui.SysMsg(ClMsg("CannotDropItem"));
		return nil;
	end
	
	if iconInfo == nil or invItem == nil then
		return nil;
	end

	local checkItem = _G["ALCHEMIST_CHECK_" .. frame:GetUserValue("SKILLNAME")];
	local obj = GetIES(invItem:GetObject())
	if 1 ~= checkItem(GetMyPCObject(), obj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return nil;
	end
	
	if 0 > obj.PR then
		ui.SysMsg(ClMsg("NoMorePotential"));
	end

	-- 위에 걸린 재료와 일치하지 않는지 확인한다.
	local bodyGBox = frame:GetChild("bodyGbox");
	local mainSlotName      = bodyGBox:GetChild("slotName");
	local slotNametext		= bodyGBox:GetChild("spendName");

	if slotNametext:GetTextByKey("guid") == invItem:GetIESID() or
	  mainSlotName:GetTextByKey("guid") == invItem:GetIESID() then 
		--테스트 문구: 같은종류의 아이템을 등록할 수 없습니다.
		ui.SysMsg(ClMsg("CantRegisterSameTypeGoods"));
		return nil;
	end

	local MainType = mainSlotName:GetTextByKey("itemtype");
	local spendType = slotNametext:GetTextByKey("itemtype");

	-- 메인과 소비재료 별 비교..
	local mainCls = GetClassByType("Item", MainType);
	local spendCls = GetClassByType("Item", spendType);
	if nil ~= mainCls and mainCls.ItemStar > obj.ItemStar or
		nil ~= spendCls and spendCls.ItemStar > obj.ItemStar then
		ui.SysMsg(ClMsg("LowWeaponStar"));
		return nil;
	end

	return invItem;
end

function BRIQUETTING_SELECT_WEAPON(frame, ctrl)
	local parent	= frame:GetTopParentFrame();
	local select = parent:GetUserValue('SELECT');
	if 'None' ~= select then
		local excute = GET_CHILD(frame, select, "ui::CCheckBox");
		excute:SetCheck(0);
	end

	if ctrl:IsChecked() == 0 then
		parent:SetUserValue('SELECT', 'None');
		ctrl:SetCheck(0);
	else
		parent:SetUserValue('SELECT', ctrl:GetName());
		ctrl:SetCheck(1);
	end
end


function BRIQUETTING_UI_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot  = bodyGBox:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();
	
	local slotName = bodyGBox:GetChild("slotName");
	slotName:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotName);

	local maxPowerStr = bodyGBox:GetChild("maxPowerStr");
	local minPowerStr = bodyGBox:GetChild("minPowerStr");
	local maxPower = bodyGBox:GetChild("maxPower");
	local minPower = bodyGBox:GetChild("minPower");
	maxPowerStr:SetTextByKey("txt", "");
	maxPowerStr:SetTextByKey("txt", "");
	minPowerStr:SetTextByKey("txt", "");
	maxPower:SetTextByKey("txt", "");
	minPower:SetTextByKey("txt", "");
	bodyGBox:RemoveChild('tooltip_only_pr');

	local check2Name      = frame:GetChild("check2Name");
	check2Name:SetTextByKey("txt", '');

	local abil = session.GetAbilityByName('Alchemist10')
	
	local checkbox_2 = GET_CHILD(frame, "checkbox_2", "ui::CCheckBox");
	local spendMainStr_1 = bodyGBox:GetChild("spendMainStr_1");

	if nil == abil then
	checkbox_2:ShowWindow(0);
	spendMainStr_1:ShowWindow(0);
	else
		checkbox_2:ShowWindow(1);
		spendMainStr_1:ShowWindow(1);
	end
	checkbox_2:SetCheck(0);


	BRIQUETTING_UI_SPEND_RESET(frame);
	BRIQUETTING_REFRESH_MATERIAL(frame, "");
end 

function BRIQUETTING_UI_SPEND_RESET(frame)
	local bodyGBox = frame:GetChild("bodyGbox");
	local slot  = bodyGBox:GetChild("slot2");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();

	local slotNametext		= bodyGBox:GetChild("spendName");
	slotNametext:SetTextByKey("txt", "");
	BRIQUETTING_SLOT_SET(slotNametext);

	local check2Name      = frame:GetChild("check2Name");
	check2Name:SetTextByKey("txt", '');

	frame:SetUserValue('SELECT', 'None');
end

function BRIQUETTING_REFRESH_MATERIAL(frame, spendUI)
	local bodyGBox = frame:GetChild("bodyGbox");
	local materiaICount = bodyGBox:GetChild("materiaICount");
	local metarialName = bodyGBox:GetChild("metarialName");
	local materiaIimage = bodyGBox:GetChild("materiaIimage");
	
	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ALCHEMIST_MATERIAL_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(invItemList);
	local cls = GetClass("Item", name);
	local txt = GET_ITEM_IMG_BY_CLS(cls, 60);
	materiaIimage:SetTextByKey("txt", txt);
	metarialName:SetTextByKey("txt", cls.Name);
	local text = cnt .. " " .. ClMsg("CountOfThings");
	materiaICount:SetTextByKey("txt", text);

	local spendCount = bodyGBox:GetChild("spendCount");
	spendCount:SetTextByKey("txt", spendUI);
end

function ALCHEMIST_BRIQUE_SUCCEED()
	local frame = ui.GetFrame("briquetting");
	if nil == frame then
		return;
	end
	BRIQUETTING_UI_RESET(frame);
end