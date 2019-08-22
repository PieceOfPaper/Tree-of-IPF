function PET_INFO_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("PET_PROP_UPDATE", "ON_PET_PROP_UPDATE");
	addon:RegisterOpenOnlyMsg("PET_EXP_UPDATE", "ON_PET_EXP_UPDATE");
	addon:RegisterOpenOnlyMsg("PET_NAME_CHANGED", "ON_PET_NAME_CHANGED");
	addon:RegisterMsg("COMPANION_UI_OPEN", "COMPANION_UI_OPEN_DO");
	addon:RegisterMsg("COMPANION_AUTO_ATK", "COMPANION_UI_AUTO_ATK");
	addon:RegisterOpenOnlyMsg("UPDATE_COLONY_TAX_RATE_SET", "ON_COMPANION_UI_UPDATE_COLONY_TAX_RATE_SET");
	
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
	PET_INFO_CANCEL_TRAIN(frame)	
end

function ON_COMPANION_UI_UPDATE_COLONY_TAX_RATE_SET(frame)
	local tree = GET_CHILD_RECURSIVELY(frame, "pettree");
	local statBox = tree:CreateOrGetControl("groupbox", "statbox" ,tree:GetWidth(), 200, ui.LEFT, ui.TOP, 0,0,0,0);

	SET_PET_TRAIN_COST_TEXT(frame, statBox)

	PET_INFO_CALC_TRAIN_COST(frame)
end

function ON_PET_NAME_CHANGED(frame, msg, strArg, numArg)
	PET_INFO_SHOW(frame:GetUserValue('PET_GUID'));
end

function ON_PET_PROP_UPDATE(frame, msg, strArg)
	if strArg == "IsActivated" then
		PET_INFO_UPDATE_ACTIVATED(frame);
		return;
	end

	if frame:GetUserValue("IS_OPEN_BY_NPC") == "NO" then
		PET_INFO_SHOW(frame:GetUserValue('PET_GUID'));
	elseif frame:GetUserValue('IS_OPEN_BY_NPC') == 'YES' and strArg ~= "Stamina" then
		PET_INFO_UPDATE_TRAIN(frame);
		if strArg == "UNEQUIP" or strArg == "EQUIP" then
			PET_INFO_SHOW(frame:GetUserValue('PET_GUID'));
		end
	end
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
	icon:SetImage(obj.Icon);
	
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
	local exp = tonumber(petInfo:GetStrExp());
	local petLv = SET_PET_XP_GAUGE(gauge_exp, exp, gePetXP.EXP_PET);
	
	local lv = bg:GetChild("lv");
	lv:SetTextByKey("value", petLv);

	local monCls = GetClassByType("Monster", petInfo:GetPetType());

	local bg_stat = GET_CHILD(frame, "bg_stat", "ui::CGroupBox");
	local trainBtn = bg_stat:GetChild('trainBtn');
	local cancelBtn = bg_stat:GetChild('cancelBtn');

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

		if frame:GetUserValue("IS_OPEN_BY_NPC") == "NO" then
			local pet_stat_info_text = statBox:CreateOrGetControlSet("pet_stat_info_text", "STAT_TEXT_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			pet_stat_info_text:SetUserValue("CLSNAME", statCls.ClassName);
			pet_stat_info_text:Resize(statBox:GetWidth() - 20, pet_stat_info_text:GetHeight());
			
			local name = pet_stat_info_text:GetChild("name");
			name:SetTextByKey("value", ClMsg("Pet_" .. statCls.ClassName));
			local value = pet_stat_info_text:GetChild("value");
			value:SetTextByKey("value", val);

			trainBtn:ShowWindow(0);
			cancelBtn:ShowWindow(0);
		else 
			-- 훈련 창인 경우
			local petStatInfoTrain = statBox:CreateOrGetControlSet("pet_stat_info_train", "STAT_TEXT_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			petStatInfoTrain:SetUserValue("CLSNAME", statCls.ClassName);
			petStatInfoTrain:SetUserValue('TRAIN_CNT', 0);
			petStatInfoTrain:SetUserValue('STAT_VALUE', TryGetProp(obj, "Stat_"..statCls.ClassName));
		
			local statNameText = petStatInfoTrain:GetChild("statNameText");
			local statValueText = petStatInfoTrain:GetChild('statValueText');
			local afterValueText = petStatInfoTrain:GetChild('afterValueText');
			local statUpBtn = petStatInfoTrain:GetChild('statUpBtn');

			statNameText:SetTextByKey("name", ClMsg("Pet_" .. statCls.ClassName));
			statValueText:SetTextByKey('value', val);
			afterValueText:SetTextByKey('value', val);
			statUpBtn:SetTextTooltip('zzz');

			petStatInfoTrain:ShowWindow(1);
			trainBtn:ShowWindow(1);
			cancelBtn:ShowWindow(1);
		end		
	end

	-- 총 강화 소비 비용
	SET_PET_TRAIN_COST_TEXT(frame, statBox)
	PET_INFO_CALC_TRAIN_COST(frame);
	local statnode = tree:Add(ClMsg("DetailInfo"), "Stats", 5, 10);
	tree:Add(statnode, statBox);
	
	local slotsize = tonumber(frame:GetUserConfig('TREE_SLOT_SIZE'));
	for i = 0, PET_EQUIP_PARTS_COUNT - 2 do
		local caption = "";
		if i == 0 then
			caption = ClMsg("Wiki_Weapon");
		elseif i == 1 then
			caption = ClMsg("Wiki_Armor");
		end

		local petEquipParts = petInfo:GetEquipPartsByType(i);
		if petEquipParts ~= nil and petEquipParts:GetEquipableCount() > 0 then
			local equips = tree:Add(ClMsg("EquipInfomation") .. " - " .. caption, "EquipInfomation" .. i, 5, 10);
			local newslotset = MAKE_PET_EQUIP_SLOT(tree, petInfo, i, slotsize);
			if newslotset ~= nil then
				newslotset:ShowWindow(1);
				PET_INFO_BUILD_EQUIP(frame, newslotset, petInfo, i);
				tree:Add(equips, newslotset);
			end
		end		
	end
	tree:OpenNodeAll();

	-- 자동 공격 관련 컨트롤을 트리 밑에 넣어야 한다
	local autoAtkBox = GET_CHILD_RECURSIVELY(frame, 'autoAtkBox');
    autoAtkBox:SetOffset(autoAtkBox:GetX(), tree:GetY() + tree:GetAllHeight() + slotsize);
    
    local companionList , cnt = GetClassList('Companion')
	local checkRidingOnly = 'None'
	for i = 0, cnt - 1 do
	    local companion = GetClassByIndexFromList(companionList, i)
	    if companion.ClassName == obj.ClassName then
	        checkRidingOnly = companion.RidingOnly
	    end
	end
    
    if checkRidingOnly == 'YES' then
        autoAtkBox:ShowWindow(0);
    elseif checkRidingOnly == 'NO' then
        autoAtkBox:ShowWindow(1);
    end
    
	frame:ShowWindow(1);
	
	PET_INFO_UPDATE_ACTIVATED(frame, true);
end

function SET_PET_TRAIN_COST_TEXT(frame, statBox)
	if frame:GetUserValue("IS_OPEN_BY_NPC") == "YES" then
		local petTrainTotal = statBox:CreateOrGetControlSet("petTrainTotal", "STAT_TEXT_TOTAL", ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local costText = GET_CHILD_RECURSIVELY(petTrainTotal, "costText")
		SET_COLONY_TAX_RATE_TEXT(costText, "tax_rate")
	end

	GBOX_AUTO_ALIGN(statBox, 20, 3, 10, true, true);
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

function UNLOCK_LEAVE_SUMMONED_PET()
	local pet = GET_SUMMONED_PET();
	if pet ~= nil then
		world.Leave(pet:GetHandle(), 0);
	end

	local hawk = GET_SUMMONED_PET_HAWK()
	if hawk ~= nil then
		world.Leave(hawk:GetHandle(), 0);
	end
end

function TOGGLE_PET_ACTIVITY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local pet_guid = frame:GetUserValue("PET_GUID");

	ui.DisableForTime(ctrl, 3);
	
	local petInfo = session.pet.GetPetByGUID(pet_guid);
	local obj = petInfo:GetObject();
	obj = GetIES(obj);

	local myHandle = session.GetMyHandle();
	local haingBuff = info.GetBuffByName(myHandle, "HangingShot");
	local isActivated = TryGet(obj, "IsActivated");
	if isActivated == 1 and haingBuff == nil then
		world.Leave(petInfo:GetHandle(), 0);
	end

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

function MAKE_PET_EQUIP_SLOT(ctrl, petInfo, type, slotsize)
	local petEquipParts = petInfo:GetEquipPartsByType(type);
	if petEquipParts == nil then
		return nil;
	end

	local size = petEquipParts:GetEquipableCount();
	if size < 1 then
		return nil;
	end

	local newslotset = ctrl:CreateOrGetControl('slotset', "equpslot_" .. type ,0,0,0,0) 
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

    if invItem.isLockState == true then
        ui.SysMsg(ClMsg('MaterialItemIsLock'));
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
		ui.SysMsg(ClMsg("NotEquipableSlot"));
		return;
	end
	
	local blongProp = TryGetProp(itemObj, "BelongingCount");
	local blongCnt = 0;

	if blongProp ~= nil then
		blongCnt = tonumber(blongProp);
	end

	if 0 < blongCnt then
		ui.SysMsg(ClMsg("CantEquipItem"));
		return;
	end

	geClientPet.RequestEquipPet(guid, liftIcon:GetIESID(), typeEnum, slotSpot);

end

function ON_PET_EXP_UPDATE(frame)
	local guid = frame:GetUserValue("PET_GUID");

	local petInfo = session.pet.GetPetByGUID(guid);	
	if petInfo == nil then
		return;
	end

	local bg = frame:GetChild("bg");
	local gauge_exp = GET_CHILD(bg, "gauge_exp", "ui::CGauge");
	local exp = tonumber(petInfo:GetStrExp());
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
	local autoAtkImg = GET_CHILD_RECURSIVELY(topFrame, 'atkActiveImg', 'ui::CPicture')

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

function PET_STAT_UP(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local pc = GetMyPCObject();
	local guid = topFrame:GetUserValue("PET_GUID");
	local trainCnt = frame:GetUserIValue('TRAIN_CNT');
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end
	obj = GetIES(obj);

	local needSilver = PET_INFO_GET_STAT_SILVER(frame, pc, obj, trainCnt + 1);
	if IsGreaterThanForBigNumber(needSilver, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	local statName = frame:GetUserValue('CLSNAME');
	local statValue = frame:GetUserIValue('STAT_VALUE');
	local afterValueText = frame:GetChild('afterValueText');

	local statFuncScp = "PET_"..statName.."_C";
	local afterStatValue = 0;
	if statName == 'MHP' then
		statFuncScp = "PET_GET_"..statName.."_C";
	else
		statValue = TryGetProp(obj, statName);
	end
	local StatFunc = _G[statFuncScp];
	afterStatValue = StatFunc(obj, trainCnt + 1);

	frame:SetUserValue('TRAIN_CNT', trainCnt + 1);
	afterValueText:SetTextByKey('value', afterStatValue);

	PET_INFO_CALC_TRAIN_COST(frame:GetTopParentFrame());
end

function PET_INFO_SAVE_TRAIN(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	if topFrame:GetUserValue('IS_OPEN_BY_NPC') == 'NO' then
		return;
	end
	local totalCost = topFrame:GetUserIValue('TOTAL_COST');
	if IsGreaterThanForBigNumber(totalCost, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	local guid = topFrame:GetUserValue("PET_GUID");
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end
	obj = GetIES(obj);
	
	local statList, statCnt = GetClassList("Pet_ShowStats");
	if statList == nil or statCnt < 1 then
		return;
	end
	for i = 0 , statCnt - 1 do
		local ctrlset = GET_CHILD_RECURSIVELY(topFrame, 'STAT_TEXT_'..i);
		local clsName = ctrlset:GetUserValue('CLSNAME');
		local statValue = obj["Stat_" .. clsName];
		local trainCnt = ctrlset:GetUserIValue('TRAIN_CNT');
		if trainCnt > 0 then
			local chatStr = string.format("/petstat %s %s %d", guid, clsName, trainCnt);
			ui.Chat(chatStr);
			ctrlset:SetUserValue('TRAIN_CNT', 0);
		end
	end
end

function PET_INFO_CANCEL_TRAIN(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	if topFrame:GetUserValue('IS_OPEN_BY_NPC') == 'NO' then
		return;
	end
	local guid = topFrame:GetUserValue("PET_GUID");
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end
	obj = GetIES(obj);

	local statList, statCnt = GetClassList("Pet_ShowStats");
	if statList == nil or statCnt < 1 then
		return;
	end
	for i = 0 , statCnt - 1 do
		local ctrlset = GET_CHILD_RECURSIVELY(topFrame, 'STAT_TEXT_'..i);
		local statValueText = ctrlset:GetChild('statValueText');
		local afterValueText = ctrlset:GetChild('afterValueText');
		local statValue = TryGetProp(obj, ctrlset:GetUserValue('CLSNAME'));

		ctrlset:SetUserValue('TRAIN_CNT', 0);
		statValueText:SetTextByKey('value', statValue);
		afterValueText:SetTextByKey('value', statValue);
	end
	PET_INFO_CALC_TRAIN_COST(topFrame);
end

function PET_INFO_UPDATE_TRAIN(frame)
    local topFrame = frame:GetTopParentFrame()
	if topFrame:GetUserValue('IS_OPEN_BY_NPC') == 'NO' then
		return;
	end
	local guid = topFrame:GetUserValue("PET_GUID");
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end
	obj = GetIES(obj);

	local statList, statCnt = GetClassList("Pet_ShowStats");
	if statList == nil or statCnt < 1 then
		return;
	end
	for i = 0 , statCnt - 1 do
		local ctrlset = GET_CHILD_RECURSIVELY(topFrame, 'STAT_TEXT_'..i);
		local statValueText = ctrlset:GetChild('statValueText');
		local afterValueText = ctrlset:GetChild('afterValueText');
		local statValue = TryGetProp(obj, ctrlset:GetUserValue('CLSNAME'));

		local trainCnt = ctrlset:GetUserIValue('TRAIN_CNT');
		statValueText:SetTextByKey('value', statValue);
		afterValueText:SetTextByKey('value', (statValue + trainCnt));
	end
	PET_INFO_CALC_TRAIN_COST(topFrame);
end

function PET_INFO_CALC_TRAIN_COST(frame)
	if frame:GetUserValue('IS_OPEN_BY_NPC') == 'NO' then
		return;
	end
	
	local pc = GetMyPCObject();
	local guid = frame:GetUserValue("PET_GUID");
	local petInfo = session.pet.GetPetByGUID(guid);
	local obj = petInfo:GetObject();
	if obj == nil then
		return;
	end
	obj = GetIES(obj);
	
	local cost = 0;
	local statList, statCnt = GetClassList("Pet_ShowStats");
	if statList == nil or statCnt < 1 or pc == nil then
		return;
	end
	for i = 0 , statCnt - 1 do
		-- control
		local ctrlset = GET_CHILD_RECURSIVELY(frame, 'STAT_TEXT_'..i);
		local statUpBtn = ctrlset:GetChild('statUpBtn');
		local clsName = ctrlset:GetUserValue('CLSNAME');
		local statValue = obj["Stat_" .. clsName];
		local trainCnt = ctrlset:GetUserIValue('TRAIN_CNT');
		
		-- style
		local TRAIN_TOOLTIP_EMPHA_ST = ctrlset:GetUserConfig('TRAIN_TOOLTIP_EMPHA_ST');
		local TRAIN_TOOLTIP_ST = ctrlset:GetUserConfig('TRAIN_TOOLTIP_ST');
		local TRAIN_TOOLTIP_IMG = ctrlset:GetUserConfig('TRAIN_TOOLTIP_IMG');
		local STYLE_TAX_RATE = ctrlset:GetUserConfig('STYLE_TAX_RATE');

		-- cost
		local statCost = PET_INFO_GET_STAT_SILVER(ctrlset, pc, obj, trainCnt);

		-- tooltip
		local tooltipText = string.format("%s[%s]{/}%s%s{/}{nl}", TRAIN_TOOLTIP_EMPHA_ST, ClMsg("Pet_" .. clsName), TRAIN_TOOLTIP_ST, ClMsg('NextReinforceCost'));
		tooltipText = tooltipText..string.format("{img %s 18 18}", TRAIN_TOOLTIP_IMG);
		tooltipText = tooltipText..string.format("%s%s{/}{nl}", TRAIN_TOOLTIP_EMPHA_ST, GET_COMMAED_STRING(PET_INFO_GET_STAT_SILVER(ctrlset, pc, obj, trainCnt + 1)));
		local taxStr = GET_COLONY_TAX_APPLIED_STRING();
		tooltipText = tooltipText..string.format("%s%s{/}", STYLE_TAX_RATE, taxStr)
		statUpBtn:SetTextTooltip(tooltipText);

		cost = cost + statCost;
	end

	ui.UpdateVisibleToolTips();

	local totalCostText = GET_CHILD_RECURSIVELY(frame, 'totalCostText');
	frame:SetUserValue('TOTAL_COST', cost);
	totalCostText:SetTextByKey('cost', GET_COMMAED_STRING(cost));
end

function PET_INFO_GET_STAT_SILVER(ctrl, pc, pet, trainCnt)
	if ctrl == nil or pc == nil or pet == nil then
		return 0;
	end

	local clsName = ctrl:GetUserValue('CLSNAME');
	local statValue = pet["Stat_" .. clsName];
	local statCost = 0;
	for j = 0, trainCnt - 1 do
		local needSilver = GET_PET_STAT_PRICE(pc, pet, clsName, statValue + j, GET_COLONY_TAX_RATE_CURRENT_MAP());
		statCost = statCost + needSilver;
	end
	return statCost;
end

function CHANGE_MYPET_NAME(frame, btn)
    local topFrame = frame:GetTopParentFrame()
    local petGuid = topFrame:GetUserValue('PET_GUID')
    if petGuid == nil or petGuid == "None" then
        ui.SysMsg(ClMsg("SummonedPetDoesNotExist"));
        return;
    end

    local petInfo = session.pet.GetPetByGUID(petGuid);
    if petInfo == nil then
        return;
    end

    local beforeName = petInfo:GetName();
    local newframe = ui.GetFrame("inputstring");
    newframe:SetUserValue("InputType", "PetName");
    INPUT_STRING_BOX(ClMsg("PetName"), "EXEC_CHANGE_NAME_PET", petName, 0, 16);
end

function EXEC_CHANGE_NAME_PET(inputframe, ctrl)
    if ctrl:GetName() == "inputstr" then
        inputframe = ctrl;
    end

    local changedName = GET_INPUT_STRING_TXT(inputframe);
    
    local petInfoFrame = ui.GetFrame("pet_info");
    local petGuid = petInfoFrame:GetUserValue("PET_GUID");
    local petInfo = session.pet.GetPetByGUID(petGuid);
    if petInfo == nil then
	return;
    end

    OPEN_CHECK_USER_MIND_BEFOR_YES(inputframe, "petName", changedName, petInfo:GetName(), petGuid);
end