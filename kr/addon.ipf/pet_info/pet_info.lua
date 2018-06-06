function PET_INFO_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("PET_PROP_UPDATE", "ON_PET_PROP_UPDATE");
	addon:RegisterOpenOnlyMsg("PET_EXP_UPDATE", "ON_PET_EXP_UPDATE");
	addon:RegisterMsg("COMPANION_UI_OPEN", "COMPANION_UI_OPEN_DO");
	addon:RegisterMsg("COMPANION_AUTO_ATK", "COMPANION_UI_AUTO_ATK");
	
	local frame = ui.GetFrame("pet_info");
	frame:SetUserValue("IS_OPEN_BY_NPC","NO")	

	local etc = GetMyEtcObject()
	COMPANION_UI_AUTO_ATK(frame, nil, TryGetProp(etc, 'CompanionAutoAtk'))
end

g_use_pet_friendly_point = 0;
g_treeStartSpace = 5;
g_treeEndSpace = 10;

function COMPANION_UI_OPEN_DO(frame)
	
	if ui.CheckHoldedUI() == true then
		return;
	end	

	local summonedPet = GET_SUMMONED_PET();
	if summonedPet == nil then
		ui.SysMsg(ClMsg("SummonedPetDoesNotExist"));
		return;
	end

	frame:SetUserValue("IS_OPEN_BY_NPC","YES")

	PET_INFO_SHOW(summonedPet:GetStrGuid());

end

function ON_PET_PROP_UPDATE(frame, msg, propName)
	
	if propName == "IsActivated" then
		PET_INFO_UPDATE_ACTIVATED(frame);
		return;
	end

	local guid = frame:GetUserValue("PET_GUID");
	PET_INFO_SHOW(guid);

end

function PET_INFO_OPEN(frame)
	--ui.OpenFrame("pet_list");
	ui.OpenFrame("inventory");
end

function PET_INFO_CLOSE(frame)
	ui.CloseFrame("inventory");
	frame:SetUserValue("IS_OPEN_BY_NPC","NO")
	--ui.CloseFrame("pet_list");
end

function SET_PET_XP_GAUGE(gauge, point, xpType)
	
	local curTotalExp = point;
	local xpInfo = gePetXP.GetXPInfo(xpType, curTotalExp);
	local totalExp = xpInfo.totalExp - xpInfo.startExp;
	local curExp = curTotalExp - xpInfo.startExp;
	
	gauge:SetPoint(curExp, totalExp);
	return xpInfo.level;
end

function PET_INFO_SHOW(petGuid)
	local list = session.pet.GetPetInfoVec();

	local petInfo = session.pet.GetPetByGUID(petGuid);
	if petInfo == nil then
		pirnt("nil")
		return;
	end

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local frame = ui.GetFrame("pet_info");
	frame:SetUserValue("PET_GUID", petInfo:GetStrGuid());
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end

	obj = GetIES(obj);
	
	local bg_Icon = frame:GetChild("bg_icon");
	local icon = GET_CHILD(bg_Icon, "icon", "ui::CPicture");
	icon:SetImage(obj.IconImage);
	
	local bg = frame:GetChild("bg");
	local name = bg:GetChild("name");
	local pettype = bg:GetChild("pettype");
	name:SetTextByKey("value", petInfo:GetName());
	pettype:SetTextByKey("value", "("..obj.Name..")");
	local gauge_stamina = GET_CHILD(bg, "gauge_stamina");
	gauge_stamina:SetPoint(obj.Stamina, obj.MaxStamina);

	local companionCls = GetClass("Companion", obj.ClassName);
	if companionCls ~= nil then
		local gauge_lifetime = GET_CHILD(bg, "gauge_lifetime");
		local t_lifetime = GET_CHILD(bg, "t_lifetime");
		if companionCls.LifeMin == 0 then
			t_lifetime:ShowWindow(0);
			gauge_lifetime:ShowWindow(0);
		else

			local overDate = obj.OverDate;
			if overDate > 0 then
				local remainDate = 10 - overDate;

				local statText = "{@st42b}{b}%v/%m " .. ScpArgMsg("AbilityReduced");
				gauge_lifetime:SetTextStat(0, statText);
				gauge_lifetime:SetPoint(remainDate, 10);
				
			else
				gauge_lifetime:SetTextStat(0, "{@st42b}{b}%v/%m H");

				local sysTime = geTime.GetServerSystemTime();
				local adoptTime = imcTime.GetSysTimeByStr(obj.AdoptTime );
				local difSec = imcTime.GetDifSec(sysTime, adoptTime);
				local minute = difSec / 60;
				local remainMin = 	companionCls.LifeMin - minute;
				if remainMin < 0 then
					remainMin = 0;
				end

				remainMin = remainMin / 60;
				gauge_lifetime:SetPoint(remainMin, companionCls.LifeMin / 60);
				
			end
			
			t_lifetime:ShowWindow(1);
			gauge_lifetime:ShowWindow(1);
		end
	end


	
	local friendLevel = tonumber(petInfo:GetPCProperty(cid, "FriendLevel", "1"));
	local friendPoint = tonumber(petInfo:GetPCProperty(cid, "FriendPoint", 0));

	local friendpoint = bg:GetChild("friendpoint");
	friendpoint:SetTextByKey("lv", friendLevel);
	local gauge_friendly = GET_CHILD(bg, "gauge_friendly", "ui::CGauge");
	SET_PET_XP_GAUGE(gauge_friendly, friendPoint, gePetXP.EXP_FRIENDLY);
	local t_friendly = bg:GetChild("t_friendly");
	friendpoint:ShowWindow(g_use_pet_friendly_point);
	gauge_friendly:ShowWindow(g_use_pet_friendly_point);
	t_friendly:ShowWindow(g_use_pet_friendly_point);

	local gauge_exp = GET_CHILD(bg, "gauge_exp", "ui::CGauge");
	local exp = petInfo:GetExp();
	local petLv = SET_PET_XP_GAUGE(gauge_exp, exp, gePetXP.EXP_PET);
	
	local lv = bg:GetChild("lv");
	lv:SetTextByKey("value", petLv);

	local monCls = GetClassByType("Monster", petInfo:GetPetType());

	local bg_stat = GET_CHILD(frame, "bg_stat", "ui::CGroupBox");

	local tree = GET_CHILD(bg_stat, "pettree", "ui::CTreeControl");
	
	local groupfontname = frame:GetUserConfig("TREE_GROUP_FONT");
	local tabwidth = frame:GetUserConfig("TREE_TAB_WIDTH");
	tree:SetDrawStart(0, 0);
	tree:Clear();
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,60)
	tree:SetFontName(groupfontname);
	tree:SetTabWidth(tabwidth);
	
	local statBox = tree:CreateOrGetControl('groupbox',"statbox" ,tree:GetWidth(), 200, ui.LEFT, ui.TOP, 0,0,0,0);
	tolua.cast(statBox, "ui::CGroupBox");
	statBox:RemoveAllChild();
	statBox:EnableDrawFrame(0);
	statBox:EnableScrollBar(0);
	statBox:ShowWindow(1);
	local statList, statCnt = GetClassList("Pet_ShowStats");
	for i = 0 , statCnt - 1 do
		local statCls = GetClassByIndexFromList(statList, i);
		local val = obj[statCls.ClassName];
		
		local pet_stat_info_text = statBox:CreateOrGetControlSet("pet_stat_info_text", "STAT_TEXT_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		pet_stat_info_text:SetUserValue("CLSNAME", statCls.ClassName);
		pet_stat_info_text:Resize(statBox:GetWidth() - 20, pet_stat_info_text:GetHeight());
		
		local name = pet_stat_info_text:GetChild("name");
		name:SetTextByKey("value", ClMsg("Pet_" .. statCls.ClassName));
		local value = pet_stat_info_text:GetChild("value");
		value:SetTextByKey("value", val);
		
		local btn = pet_stat_info_text:GetChild("btn");
		if frame:GetUserValue("IS_OPEN_BY_NPC") == "YES" then
			btn:ShowWindow(1)
		else
			btn:ShowWindow(0)
		end
		
	end
	
	GBOX_AUTO_ALIGN(statBox, 5, 3, 10, true, true);
	local statnode = tree:Add(ClMsg("DetailInfo"), "Stats", 5, 10);
	tree:Add(statnode, statBox);
	
	for i = 0, PET_EQUIP_PARTS_COUNT - 2 do
		local caption = "";
		if i == 0 then
			caption = ClMsg("Wiki_Weapon");
		elseif i == 1 then
			caption = ClMsg("Wiki_Armor");
		end

		local equips = tree:Add(ClMsg("EquipInfomation") .. " - " .. caption, "EquipInfomation" .. i, 5, 10);
		local newslotset = MAKE_PET_EQUIP_SLOT(tree, petInfo, i);
		if newslotset ~= nil then
			newslotset:ShowWindow(1);
			PET_INFO_BUILD_EQUIP(frame, newslotset, petInfo, i);
			tree:Add(equips, newslotset);
		end
	end
		
	tree:OpenNodeAll();
	frame:ShowWindow(1);
	
	PET_INFO_UPDATE_ACTIVATED(frame, true);

---	bg_stat:SetScrollPos(0);
end

function PET_INFO_UPDATE_ACTIVATED(frame, isFirstUpdate)

	local pet_guid = frame:GetUserValue("PET_GUID");
	local petInfo = session.pet.GetPetByGUID(pet_guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end

	obj = GetIES(obj);

	local bg = frame:GetChild("bg");
	local activate = GET_CHILD(bg, "activate", "ui::CPicture");
	--local activate = bg:GetChild("activate");
	if obj.IsActivated == 1 then
		activate:SetImage("test_com_ability_on");
	else
		activate:SetImage("test_com_ability_off");
	end

	if isFirstUpdate ~= true then
		ui.DisableForTime(activate, 0);
		ui.DisableForTime(activate, PET_ACTIVATE_COOLDOWN);	
	end

end

function TOGGLE_PET_ACTIVITY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local pet_guid = frame:GetUserValue("PET_GUID");

	ui.DisableForTime(ctrl, 3);

	control.CustomCommand("PET_ACTIVATE", 0);	
end

function PET_INFO_BUILD_EQUIP(frame, newslotset, petInfo, type)

	local petEquipParts = petInfo:GetEquipPartsByType(type);
	if petEquipParts == nil then
		return;
	end

	local size = petEquipParts:GetEquipableCount();
	for i = 0 , size - 1 do
		local obj = petEquipParts:GetObject(i);
		if obj ~= nil then
			obj = GetIES(obj);
			local slot = newslotset:GetSlotByIndex(i);
			SET_SLOT_ITEM_OBJ(slot, obj);
			local icon = slot:GetIcon();

			icon:SetTooltipArg("petequip", obj.ClassID, GetIESID(obj), obj);

			slot:SetUserValue("ITEM_GUID", GetIESID(obj));
			slot:SetEventScript(ui.RBUTTONUP, "PET_ITEM_UNEQUIP");
		end
	end

end

function PET_ITEM_UNEQUIP(parent, ctrl)
	
	local guid = ctrl:GetUserValue("ITEM_GUID");
	local frame = parent:GetTopParentFrame();
	local pet_guid = frame:GetUserValue("PET_GUID");
	
	geClientPet.RequestEquipPet(pet_guid, guid, PET_EQUIP_PARTS_COUNT, -1);
	imcSound.PlaySoundEvent("item_pick_up")		
end

function MAKE_PET_EQUIP_SLOT(tree, petInfo, type)

	local frame = tree:GetTopParentFrame();
	local slotsize = frame:GetUserConfig("TREE_SLOT_SIZE");
	
	local petEquipParts = petInfo:GetEquipPartsByType(type);
	if petEquipParts == nil then
		return nil;
	end

	local size = petEquipParts:GetEquipableCount();

	local newslotset = tree:CreateOrGetControl('slotset', "equpslot_" .. type ,0,0,0,0) 
	tolua.cast(newslotset, "ui::CSlotSet");
	newslotset:EnablePop(1)
	newslotset:EnableDrag(1)
	newslotset:EnableDrop(1)
	newslotset:SetMaxSelectionCount(999)
	newslotset:SetSlotSize(slotsize,slotsize)
	newslotset:SetColRow(size, 1)
	newslotset:SetSpc(0,0)
	newslotset:SetSkinName('invenslot2');
	newslotset:EnableSelection(0)
	newslotset:SetEventScript(ui.DROP, "DROP_PET_EQUIP");
	newslotset:CreateSlots();

	for i = 0, size - 1 do
		local slotStr = gePet.PetPartsToString(type);
		local slot = newslotset:GetSlotByIndex(i);
		slot:SetUserValue("TYPE", slotStr);
		slot:SetUserValue("SPOT", i);
		slot:SetOverSound("button_over");
	end

	return newslotset;
end

function PET_ABIL_UP(parent, ctrl)

	local clsName = parent:GetUserValue("CLSNAME");
	local frame = parent:GetTopParentFrame();
	local guid = frame:GetUserValue("PET_GUID");
	
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end

	obj = GetIES(obj);

	local pc = GetMyPCObject();
	local needSilver = GET_PET_STAT_PRICE(pc, obj, clsName);
	local statTitle = ClMsg("Pet_" .. clsName);
	local msg = ScpArgMsg("Increase{Stat}By{Silver}Silver?", "Stat", ClMsg("Pet_" .. clsName), "Silver", needSilver);
	local scriptString = string.format("EXEC_PET_ABIL(\"%s\", \"%s\")", guid, clsName);
	local myMoney = GET_TOTAL_MONEY();


	if myMoney < needSilver then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	ui.MsgBox_NonNested(msg, frame:GetName(), scriptString, "None");

end

function EXEC_PET_ABIL(guid, clsName)
	imcSound.PlaySoundEvent("button_click_big");

	local chatStr = string.format("/petstat %s %s", guid, clsName);
	ui.Chat(chatStr);

end

function DROP_PET_EQUIP(parent, slot, str, num)

	local liftIcon = ui.GetLiftIcon():GetInfo();
	local frame = parent:GetTopParentFrame();
	local guid = frame:GetUserValue("PET_GUID");

	local list = session.pet.GetPetInfoVec();

	local petInfo = session.pet.GetPetByGUID(guid);
	if petInfo == nil then
		return;
	end
	
	slot = tolua.cast(slot, "ui::CSlot");
	local slotType = slot:GetUserValue("TYPE");
	local slotSpot = slot:GetUserValue("SPOT");
	local typeEnum = gePet.StringToPetEquipType(slotType);

	local invItem = session.GetInvItemByGuid(liftIcon:GetIESID());
	local slotlist = tolua.cast(parent, "ui::CSlotSet");
	local itemObj = invItem:GetObject();
	if itemObj ~= nil then
		itemObj = GetIES(itemObj);
	else
		return;
	end
	local itemEnum = PET_EQUIP_PARTS_COUNT;
	local group = TryGetProp(itemObj, "GroupName");
	if group == "Weapon" or group == "SubWeapon" then
		local equip = TryGetProp(itemObj, "EquipGroup");
		if equip ~= "None" then
			itemEnum = PET_EQUIP_PARTS_WEAPON;
		end
	elseif group == "Armor" then
		local equip = TryGetProp(itemObj, "EquipGroup");
		if equip ~= "None" then
			itemEnum = PET_EQUIP_PARTS_ARMOR;
		end
	end

	if itemEnum == PET_EQUIP_PARTS_COUNT then
		ui.SysMsg(ClMsg("ThisItemIsNotForCompanion"));
		return;
	end

	local isAble = petInfo:IsEquipable(itemEnum, typeEnum, slotSpot);
	if isAble == false then
		return;
	end

	local itemProp = geItemTable.GetPropByName(itemObj.ClassName);
	local blongProp = TryGetProp(itemObj, "BelongingCount");
	local blongCnt = 0;

	if blongProp ~= nil then
		blongCnt = tonumber(blongProp);
	end

	if itemProp:IsExchangeable() == false or GetTradeLockByProperty(itemObj) ~= "None" or 0 <  blongCnt then
		ui.SysMsg(ClMsg("CantEquipItem"));
		return;
	end

	geClientPet.RequestEquipPet( guid, liftIcon:GetIESID(), typeEnum, slotSpot );

end

function ON_PET_EXP_UPDATE(frame)
	local guid = frame:GetUserValue("PET_GUID");

	local petInfo = session.pet.GetPetByGUID(guid);	
	if petInfo == nil then
		return;
	end

	local bg = frame:GetChild("bg");
	local gauge_exp = GET_CHILD(bg, "gauge_exp", "ui::CGauge");
	local exp = petInfo:GetExp();
	local petLv = SET_PET_XP_GAUGE(gauge_exp, exp, gePetXP.EXP_PET);
		
	local lv = bg:GetChild("lv");
	lv:SetTextByKey("value", petLv);

end

function TOGGLE_PET_ATTACK(frame, ctrl)
	local topFrame = frame:GetTopParentFrame()
	local atkEnable = topFrame:GetUserValue('AUTO_ATK')

	if atkEnable == 'YES' then
		geClientPet.RequestAutoAtkPet(false)
	else
		geClientPet.RequestAutoAtkPet(true)
	end
end

function COMPANION_UI_AUTO_ATK(frame, msg, argStr, argNum)
	local topFrame = frame:GetTopParentFrame()
	local TOGGLE_ATK_ON = topFrame:GetUserConfig('TOGGLE_ATK_ON')
	local TOGGLE_ATK_OFF = topFrame:GetUserConfig('TOGGLE_ATK_OFF')
	local bg_stat = topFrame:GetChild('bg_stat')
	local autoAtkImg = GET_CHILD(bg_stat, 'atkActiveImg', 'ui::CPicture')

	local TOGGLE_ATK_ON = frame:GetUserConfig('TOGGLE_ATK_ON')
	local TOGGLE_ATK_OFF = frame:GetUserConfig('TOGGLE_ATK_OFF')

	local atkValue = argStr
	if argStr == nil then
		atkValue = 'YES' --default value
	end

	topFrame:SetUserValue('AUTO_ATK', atkValue)

	if atkValue == 'YES' then
		autoAtkImg:SetImage(TOGGLE_ATK_ON)
	else
		autoAtkImg:SetImage(TOGGLE_ATK_OFF)
	end
end