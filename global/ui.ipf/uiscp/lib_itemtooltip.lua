-- lib_itemtooltip.lua

function GET_EQUIP_ITEM_IMAGE_NAME(invitem, imageType, gender)
	if 'TooltipImage' == imageType then
		local changeItemcls = nil;
		local faceID = TryGetProp(invitem, 'BriquettingIndex');
		if nil ~= faceID and tonumber(faceID) > 0 then
			faceID = tonumber(faceID);
			 changeItemcls = GetClassByType('Item', faceID)
		end

		if nil ~= changeItemcls then
			return changeItemcls.TooltipImage;
		end
		local imageName = TryGetProp(invitem, imageType);
		if nil ~= imageName then
			return tostring(imageName)
		end
	elseif 'Icon' == imageType then
		return GET_ITEM_ICON_IMAGE(invitem, gender);
	end

	return 'None'
end

function IS_NEED_DRAW_GEM_TOOLTIP(invitem)

	local cnt = 0
	for i=0, invitem.MaxSocket-1 do
		if invitem['Socket_' .. i] > 0 then
			cnt = cnt + 1;
		end
	end

	if cnt <= 0 then 
	return false
	end

	return true

end

function IS_NEED_DRAW_MAGICAMULET_TOOLTIP(invitem)

	local cnt = 0
	for i=0, invitem.MaxSocket_MA - 1 do
		if invitem['MagicAmulet_' .. i] > 0 then
			cnt = cnt + 1;
		end
	end

	if cnt <= 0 then 
	return false
	end

	return true

end

function GET_USEJOB_TOOLTIP_PET(invitem)
	local usejob = invitem.UsePetEquipGroup;
	local use_job = SCR_STRING_CUT_COMMA(invitem.UsePetEquipGroup);
	local resultStr = "";
	for i = 1 , #use_job do
		if i > 1 then
			resultStr = resultStr.. ", ";
		end

		resultStr = resultStr .. use_job[i];	
	end

	return resultStr .. ScpArgMsg('EquipPossible')
end

function GET_USEJOB_TOOLTIP(invitem)

	if string.find(invitem.ItemType, "Pet") ~= nil then
		return GET_USEJOB_TOOLTIP_PET(invitem);
	end

	local usejob = TryGetProp(invitem,'UseJob')
	if usejob == nil then
		return '';
	end

	local usegender = TryGetProp(invitem,'UseGender')

	local resultstr = ''	

	if usejob == "All" then
		resultstr =  ScpArgMsg("USEJOB_ALL")
	else
		local char1 = string.find(usejob, 'Char1')

		if char1 ~= nil then
			if resultstr ~= '' then
				resultstr = resultstr..', '
			end
			resultstr = resultstr .. ScpArgMsg("USEJOB_WAR")
		end
		local char2 = string.find(usejob, 'Char2')

		if char2 ~= nil then
			if resultstr ~= '' then
				resultstr = resultstr..', '
			end
			resultstr = resultstr .. ScpArgMsg("USEJOB_WIZ")
		end
		local char3 = string.find(usejob, 'Char3')

		if char3 ~= nil then
			if resultstr ~= '' then
				resultstr = resultstr..', '
			end
			resultstr = resultstr .. ScpArgMsg("USEJOB_ARC")
		end
		local char4 = string.find(usejob, 'Char4')

		if char4 ~= nil then
			if resultstr ~= '' then
				resultstr = resultstr..', '
			end
			resultstr = resultstr .. ScpArgMsg("USEJOB_CLE")
		end
		
	end

	if resultstr ~= '' then
		
		if usejob == "All" then
			resultstr =  resultstr .. ScpArgMsg('EquipPossible')
		else
			resultstr =  resultstr .. ScpArgMsg('EquipPossible')
		end

		if usegender ~= nil and usegender ~= 'Both' then
			resultstr = resultstr..', '
				
			if usegender == "Male" then
				resultstr = resultstr .. ScpArgMsg("OnlyMale")
			else
				resultstr = resultstr .. ScpArgMsg("OnlyFemale")
			end
		end

		return resultstr
	else
		return "ERROR! check invitem.usejob column";
	end
end

function SET_DAMAGE_TEXT(parent, strArg, iconname, mindamage, maxdamage, index, reinforceAddValue)
	tolua.cast(parent, "ui::CControlSet");
	if reinforceAddValue == nil then
		reinforceAddValue = 0
	end

	local color = parent:GetUserConfig("REINFORCE_ADD_VALUE_TEXT_COLOR");
	if color == 'None' then
		color = '{#33ff33}'
	end

	if iconname ~= 'None' then

		local weapon_type_img = GET_CHILD(parent, "weapon_type", "ui::CPicture");
		weapon_type_img:SetImage(iconname);
		weapon_type_img:ShowWindow(1)
	end
	
	local atkNameCtrl = GET_CHILD(parent, "atkName"..index, "ui::CRichText");
	atkNameCtrl:SetText(strArg);
	atkNameCtrl:ShowWindow(1);

	local atkValueCtrl = GET_CHILD(parent, "atkValue"..index, "ui::CRichText");
	if mindamage == maxdamage or maxdamage == 0 then
		if reinforceAddValue ~= 0 then
			--atkValueCtrl:SetText(mindamage..' '..color..'(+'..reinforceAddValue..'){/}');
			atkValueCtrl:SetText(mindamage + reinforceAddValue);
		else
			atkValueCtrl:SetText(mindamage);
		end
	else
		if reinforceAddValue ~= 0 then
			atkValueCtrl:SetText(mindamage + reinforceAddValue.." ~ "..maxdamage + reinforceAddValue);
		else
			atkValueCtrl:SetText(mindamage.." ~ "..maxdamage);
		end
	end

	atkValueCtrl:ShowWindow(1);

end

function GET_ICONNAME_BY_WHENEQUIPSTR(innerCSet, str)

	if str == 'WhenEquipToWeapon' then
		return innerCSet:GetUserConfig("SWORD_ICON")
	elseif str == 'WhenEquipToSubWeapon' then
		return innerCSet:GetUserConfig("DEFENSE_ICON")
	elseif str == 'WhenEquipToShirtsOrPants' then
		return innerCSet:GetUserConfig("ARMOR_ICON")
	elseif str == 'WhenEquipToBoots' then
		return innerCSet:GetUserConfig("SHOES_ICON")
	elseif str == 'WhenEquipToGlove' then
		return innerCSet:GetUserConfig("GLOVE_ICON")
	end

end

function ADD_ITEM_SOCKET_PROP(GroupCtrl, invitem, socket, gem, gemExp, gemLv, yPos )
	if GroupCtrl == nil then
		return 0;
	end

	local cnt = GroupCtrl:GetChildCount();
	
	local ControlSetObj			= GroupCtrl:CreateControlSet('tooltip_item_prop_socket', "ITEM_PROP_" .. cnt , 0, yPos);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');

	local socket_image = GET_CHILD(ControlSetCtrl, "socket_image", "ui::CPicture");
	local socket_property_text = GET_CHILD(ControlSetCtrl, "socket_property", "ui::CRichText");
	local gradetext = GET_CHILD_RECURSIVELY(ControlSetCtrl,"grade","ui::CRichText");

	local NEGATIVE_COLOR = ControlSetObj:GetUserConfig("NEGATIVE_COLOR")
	local POSITIVE_COLOR = ControlSetObj:GetUserConfig("POSITIVE_COLOR")
	local STAR_SIZE = ControlSetObj:GetUserConfig("STAR_SIZE")

	if gem == 0 then
		local socketCls = GetClassByType("Socket", socket);
		socketicon = socketCls.SlotIcon
		local socket_image_name = socketCls.SlotIcon
		socket_image:SetImage(socket_image_name)		
		socket_property_text:ShowWindow(0)
		gradetext:ShowWindow(0)
	else

		local gemclass = GetClassByType("Item", gem);
		local socket_image_name = gemclass.Icon
		socket_image:SetImage(socket_image_name)		
		local lv = GET_ITEM_LEVEL_EXP(gemclass, gemExp);
		
		local prop = geItemTable.GetProp(gem);
		
		local desc = "";
		local socketProp = prop:GetSocketPropertyByLevel(lv);
		local type = invitem.ClassID;
		local cnt = socketProp:GetPropCountByType(type);
		gradetext:SetText(GET_STAR_TXT(STAR_SIZE,lv))
		gradetext:ShowWindow(1)

		for i = 0 , cnt - 1 do
			local addProp = socketProp:GetPropAddByType(type, i);

			local tempvalue = addProp.value

			local plma_mark = POSITIVE_COLOR .. "{img green_up_arrow 16 16}"..'{/}';
			if tempvalue < 0 then
				plma_mark = NEGATIVE_COLOR .. "{img red_down_arrow 16 16}"..'{/}';
				tempvalue = tempvalue * -1
			end

			if addProp:GetPropName() == "OptDesc" then
				desc = addProp:GetPropDesc().."{nl}";
			else
				desc = desc .. ScpArgMsg(addProp:GetPropName()) .. " : ".. plma_mark .. tempvalue.."{nl}";
			end

		end

		local cnt2 = socketProp:GetPropPenaltyCountByType(type);

		local penaltyLv = lv - gemLv;
		if 0 > penaltyLv then
			penaltyLv = 0;
		end
		local socketPenaltyProp = prop:GetSocketPropertyByLevel(penaltyLv);
		for i = 0 , cnt2 - 1 do
			local addProp = socketPenaltyProp:GetPropPenaltyAddByType(type, i);
			local tempvalue = addProp.value
			local plma_mark = POSITIVE_COLOR .. "{img green_up_arrow 16 16}"..'{/}';

			if tempvalue < 0 then
				plma_mark = NEGATIVE_COLOR .. "{img red_down_arrow 16 16}"..'{/}';			
			end

			if gemLv > 0 then
				if 0 < penaltyLv then
					desc = desc .. ScpArgMsg(addProp:GetPropName()) .. " : ".. plma_mark .. tempvalue.."{nl}";
				end
			else
				desc = desc .. ScpArgMsg(addProp:GetPropName()) .. " : ".. plma_mark .. tempvalue.."{nl}";
			end
		end
			
		socket_property_text:SetText(desc)
		socket_property_text:ShowWindow(1)
	end

	GroupCtrl:ShowWindow(1)
	GroupCtrl:Resize(GroupCtrl:GetWidth(),GroupCtrl:GetHeight() + ControlSetObj:GetHeight())
	return ControlSetCtrl:GetHeight() + ControlSetCtrl:GetY();

end

function ENABLE_ARMOR_EQUIP_CHANGE(equipItem)
	local clsName = equipItem.ClassName;
	if clsName == 'NoWeapon' or clsName == "NoHat" or clsName == "NoBody" or clsName == "NoOuter" or clsName == 'NoShirt' or clsName == 'NoArmband' then
		return 0;
	elseif clsName == 'NoPants' or clsName == "NoGloves" or clsName == "NoBoots" or clsName == "NoRing" then
		return 0;
	end
	return 1;
end

function ADD_ITEM_PROPERTY_TEXT(GroupCtrl, txt, xmargin, yPos )

	if GroupCtrl == nil then
		return 0;
	end

	local cnt = GroupCtrl:GetChildCount();
	local ControlSetObj			= GroupCtrl:CreateControlSet('tooltip_item_prop_richtxt', "ITEM_PROP_" .. cnt , 0, yPos);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');
	local richText = GET_CHILD(ControlSetCtrl, "text", "ui::CRichText");
	richText:SetTextByKey('text', txt);
	ControlSetCtrl:Resize(ControlSetCtrl:GetWidth(), richText:GetHeight());
	GroupCtrl:ShowWindow(1)

	GroupCtrl:Resize(GroupCtrl:GetWidth(),GroupCtrl:GetHeight() + ControlSetObj:GetHeight())
	return ControlSetCtrl:GetHeight() + ControlSetCtrl:GetY();

end

function SET_GRADE_TOOLTIP(parent, invitem, starsize)
	local gradeChild = parent:GetChild('grade');
	if gradeChild ~= nil then
		local itemGuid = parent:GetTopParentFrame():GetUserValue('TOOLTIP_ITEM_GUID');
		local isEquiped = 1;
		if session.GetEquipItemByGuid(itemGuid) == nil then
			isEquiped = 0;
		end
		local gradeString = GET_ITEM_GRADE_TXT(invitem, starsize, isEquiped);
		gradeChild:SetText(gradeString);

		local gradeSize = gradeChild:GetY () + gradeChild:GetHeight();
		if parent:GetHeight() < gradeSize then
			parent:Resize(parent:GetWidth(), gradeSize);
		end
	end
end


function ITEM_COMPARISON_SET_OFFSET(tooltipframe, isReadObj)
	local equipChild = tooltipframe:GetChild('equip');
	if equipChild ~= nil then
		equipChild:SetOffset(15, 20);
		equipChild:SetGravity(ui.LEFT, ui.TOP);
	end
end

function COMPARISON_BY_PROPLIST(list, invitem, eqpItem, tooltipframe, equipchange, ispickitem)

	local valueList = GET_COMPARE_VALUE_LIST(list, invitem, eqpItem);

	local IsNeedShowTooltip = 0;
		for i = 1 , #list do
		local propName = list[i];
		local changeValue = valueList[i];
		if ADD_COMPARITION_TOOLTIP(equipchange, changeValue) == 1 then
			IsNeedShowTooltip = 1;
		end
	end

	if IsNeedShowTooltip == 0 then
		return 0;
	else
		local cnt = equipchange:GetChildCount();
		local width = equipchange:GetWidth();
		if cnt > 0 then
			width = -1;
			for i = 0 , cnt - 1 do
				local obj = equipchange:GetChildByIndex(i);
				width = math.max(width, obj:GetWidth() + 50);
			end
		end

		local lastChild = equipchange:GetChild("EX" .. cnt-1)
		
		if ispickitem == 1 then
			--tooltipframe:Resize(tooltipframe:GetOriginalWidth(), lastChild:GetY() + lastChild:GetHeight() + 55);
		end

		local lastHeight = lastChild:GetY() + lastChild:GetHeight();
		equipchange:Resize(width, lastHeight + 40)
		tooltipframe:Resize(width, lastHeight + 55);

		return equipchange:GetY() + equipchange:GetHeight();
	end
end

function GET_COMPARE_VALUE_LIST(list, invitem, eqpItem, style)
	local valueList = {};
	for i = 1 , #list do
		local propName = list[i];
		if eqpItem == nil then

			local invaddvalue = TryGetProp(invitem,'ADD_'..propName);
			if invaddvalue == nil then
				invaddvalue = 0
			end

			local invtemvalue = invitem[propName] + invaddvalue

			local changeValue = ABILITY_DESC_COMPARITION(ScpArgMsg(propName), invtemvalue, 0, style);
			valueList[i] = changeValue;
		else
			local invaddvalue = TryGetProp(invitem,'ADD_'..propName);
			if invaddvalue == nil then
				invaddvalue = 0
			end

			local equipaddvalue = TryGetProp(eqpItem,'ADD_'..propName);
			if equipaddvalue == nil then
				equipaddvalue = 0
			end

			local invtemvalue = invitem[propName] + invaddvalue
			local equiptemvalue = eqpItem[propName] + equipaddvalue

			local changeValue = ABILITY_DESC_COMPARITION(ScpArgMsg(propName), invtemvalue, equiptemvalue, style);
			valueList[i] = changeValue;
		end
	end

	return valueList;
end

function IS_DRAG_RECIPE_ITEM(itemObj)

	local itemProp = geItemTable.GetProp(itemObj.ClassID);
	if itemProp == nil then
		return 0;
	end

	local recipeProp = itemProp.dragRecipe;
	if recipeProp == nil then
		return 0;
	end

	if GetWiki(recipeProp.needWikiID) == nil then
		return 0;
	end

	local liftIcon = ui.GetLiftIcon();
	if liftIcon == nil then
		return 0;
	end

	return 0;
end

function GET_DRAG_RECIPE_INFO(itemObj)
	local itemProp = geItemTable.GetProp(itemObj.ClassID);
	if itemProp == nil then
		return 0;
	end
	local recipeProp = itemProp.dragRecipe;
	local itemtype = recipeProp.makeItemID;
	return ClMsg("RecipeResult"), itemtype;
end


function GET_LAST_VISIBLE_Y(ctrl)

	if ctrl == nil then
		return 0;
	end
	local maxY = 0;
	local cnt = ctrl:GetChildCount();
	for i = 0 , cnt - 1 do
		local chl = ctrl:GetChildByIndex(i);
		maxY = math.max(maxY, GET_END_POS(chl));
	end

	return maxY;

end

function SCR_GET_NEXT_GEM_LEVEL_EXP(item)

	local nowgemLv = item.Level;

	local clslist, cnt  = GetClassList("gemexptable");

	local result = 0

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if cls.Lv == nowgemLv then
			result = cls.Exp
			break;
		end
	end

	return result;

end



function INIT_TOOLTIPPAGE(tooltipframe)
	for i=0, 6 do
		local pageGroupBox = tooltipframe:GetChild('itemcomparison_'..i);
		if pageGroupBox ~= nil then
			pageGroupBox:ShowWindow(0);
		end
	end
end


function IS_DRAW_ETC_ITEM_DAMAGE(invitem)
	if invitem.Usable == 'ITEMTARGET' or invitem.Usable ~= 'YES' or invitem.GroupName == 'Book' or invitem.GroupName == 'Quest' then
		return 0;
	end

	if invitem.StringArg == 'Jungtan' then
		return 0;
	end


	if invitem.NumberArg1 > invitem.NumberArg2 and invitem.NumberArg2 ~= 0 then
		return 0;
	end

	if invitem.NumberArg1 == invitem.NumberArg2 then
		return 0;
	end

	if invitem.NumberArg1 == 0 and invitem.NumberArg2 == 0 then
		return 0;
	end

	return 1;
end

function GET_TOOLTIP_ITEM_OBJECT(strarg, guid, numarg1)

	local invitem = nil;
	if strarg == 'select' then
		invitem = session.GetSelectItemByIndex(guid);
	elseif strarg == 'soldItem' then
		invitem = GET_SOLDITEM_BY_INDEX(guid);
	elseif strarg == 'equip' then
		invitem = GET_ITEM_BY_GUID(guid, 1);
		if invitem == nil then
			invitem = session.otherPC.GetItemByGuid(guid);
		end
	elseif strarg == 'dummyPC' then
		invitem = GET_DUMMYPC_ITEM(guid, numarg1);
	elseif strarg == "warehouse" then
		invitem = session.GetWarehouseItemByGuid(guid);
	elseif strarg == "accountwarehouse" then
		invitem = session.GetEtcItemByGuid(IT_ACCOUNT_WAREHOUSE, guid);
	elseif strarg == "party" then
		invitem = GetItemByID(guid, session.party.GetPartyInfo().inv);
	elseif strarg == "exchange" then
		local idx = math.floor(guid / 10);
		local listIndex = guid % 10;
		invitem = exchange.GetExchangeItemInfo(listIndex, idx);
	elseif strarg == "tooltips" then
		local obj = session.tooltip.GetTooltipObject(tonumber(guid));
		if obj ~= nil then
			return GetIES(obj);
		end
	elseif strarg == "collection" then
		--[[
		local colls = session.GetMySession():GetCollection();
		local coll = colls:Get(numarg1);
		if coll ~= nil then
			local collItem = coll:GetByItemID(guid);
			if collItem == nil then
				local item = GetClassByType("Item", guid);
				return item;
			end

			if collItem ~= nil then
				return GetIES(collItem:GetObject());
			end
		end
		]]--
		-- collection parameter(guid) is classID.
		local item = GetClassByType("Item", guid);
		return item;
	elseif strarg == "market" then
		local marketItem = session.market.GetItemByMarketID(guid);
		if marketItem ~= nil then
			local obj = GetIES(marketItem:GetObject());
			return obj;
		end
	elseif strarg == "cabinet" then
		local cabinetItem = session.market.GetCabinetItemByItemID(guid);
		if cabinetItem ~= nil then
			local obj = GetIES(cabinetItem:GetObject());
			return obj;
		end
	elseif strarg == "petequip" then
		local item = session.pet.GetPetEquipObjByGuid(guid);
		if item ~= nil then
			local obj = GetIES(item:GetObject());
			return obj;
		end
	elseif strarg == "cardbattle" then
		local handle = math.floor(guid / 10);
		local side = guid % 10;
		local ownerItemObj, targetItem = GetCardBattleItems(handle);
		if ownerItemObj ~= nil then
			if side == 1 then
				return targetItem;
			else
				return ownerItemObj;
			end
		end
	elseif strarg == "guildwarehouse" then
		invitem = session.GetEtcItemByGuid(IT_GUILD, guid);
	else
		invitem = GET_ITEM_BY_GUID(guid, 0);
	end

	if invitem ~= nil then
		return GetIES(invitem:GetObject()), 0;
	end

	local itemObj = GetClassByType("Item", numarg1)
	viewObj = CloneIES_NotUseCalc(itemObj);
	if nil ~= viewObj then
		local refreshScp = viewObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(viewObj);
		end	
	end
	return viewObj, 1;
end

function ADD_TXT_GROUP(frame, name, txt, x, ypos, height)

	local width = frame:GetWidth() - x;
	local ctrl = frame:CreateOrGetControl("richtext", name, x, ypos, width, height);
	ctrl:ShowWindow(1);
	ctrl:SetText(txt);
	return GET_END_POS(ctrl);
end

function SET_BUFF_TEXT(gBox, invitem, yPos, strarg)

--- item buff value
	if invitem.BuffValue > 0 then
		local y = GET_CHILD_MAX_Y(gBox);
		local content = gBox:CreateOrGetControl('richtext', "BUFFVALUE", 20, yPos, gBox:GetWidth() - 30, 20);
		local clientTxt = "";
		content = tolua.cast(content, "ui::CRichText");
		content:SetTextFixWidth(1);
		content:SetFormat("%s %s");
		content:AddParamInfo("text", "");
		content:AddParamInfo("remaintime", "");

		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(invitem.BuffEndTime);
		local difSec = imcTime.GetDifSec(endTime, sysTime);
		content:SetUserValue("REMAINSEC", difSec);
		content:SetUserValue("STARTSEC", imcTime.GetAppTime());
		SHOW_REMAIN_BUFF_TIME(content);
		content:RunUpdateScript("SHOW_REMAIN_BUFF_TIME");

		if invitem.GroupName == "Armor" then
			clientTxt = "ArmorTouchUp"
		elseif invitem.GroupName == "Weapon" then
			clientTxt = "WeaponTouchUp"
		elseif invitem.GroupName == "SubWeapon" then
			clientTxt = "WeaponTouchUp"
		end

		local text = string.format("{#004123}".."- "..ScpArgMsg(clientTxt));
		content:SetTextByKey("text", text);


		local content2 = gBox:CreateOrGetControl('richtext', "UPVALUE", 350, yPos, gBox:GetWidth() - 30, 20);

		local upValue = string.format("{#004123}"..ScpArgMsg("PropUp") .. "%d", invitem.BuffValue);
		content2:SetTextByKey("upValue", upValue);

		yPos = yPos + content:GetHeight();

		
		local casterInfo = gBox:CreateOrGetControl('richtext', "CASTERINFO", 20, yPos, gBox:GetWidth() - 30, 20);
		content = tolua.cast(casterInfo, "ui::CRichText");
		casterInfo:SetTextFixWidth(1);
		casterInfo:SetFormat("%s %s");
		casterInfo:AddParamInfo("caster", "");
		casterInfo:AddParamInfo("count", "");

		local casterName = string.format("{#004123}".."   (%s)", invitem.BuffCaster);
		casterInfo:SetTextByKey("caster", casterName)


		local casterInfo2 = gBox:CreateOrGetControl('richtext', "COUNT", 300, yPos, gBox:GetWidth() - 30, 20);
		casterInfo2:SetUserValue("BuffUseCount", invitem.BuffUseCount);
		casterInfo2:SetUserValue("BuffCount", invitem.BuffCount);
		casterInfo2:RunUpdateScript("SHOW_REMAIN_BUFF_COUNT");
		SHOW_REMAIN_BUFF_COUNT(casterInfo2);

		yPos = yPos + casterInfo:GetHeight();

	end

	if invitem.EnchanterBuffValue ~= 'None' and invitem.EnchanterBuffValue ~= 0  then
		local y = GET_CHILD_MAX_Y(gBox);
		local content = gBox:CreateOrGetControl('richtext', "ENCHANTBUFF", 20, yPos, gBox:GetWidth() - 30, 20);
		local clientTxt = "";
		content = tolua.cast(content, "ui::CRichText");
		content:SetTextFixWidth(1);
		content:SetFormat("%s %s");
		content:AddParamInfo("text", "");
		content:AddParamInfo("remaintime", "");

		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(invitem.EnchanterBuffEndTime);
		local difSec = imcTime.GetDifSec(endTime, sysTime);
		content:SetUserValue("REMAINSEC", difSec);
		content:SetUserValue("STARTSEC", imcTime.GetAppTime());
		content:SetUserValue("ENCHANT", 1);
		SHOW_REMAIN_BUFF_TIME(content);
		content:RunUpdateScript("SHOW_REMAIN_BUFF_TIME");
		local clientTxt = invitem.EnchanterBuffValue .. '_DESC';
		local text = string.format("{#004123}".."- "..ScpArgMsg(clientTxt));
		content:SetTextByKey("text", text);

		yPos = yPos + content:GetHeight();
	end

	return yPos;
end

function SHOW_REMAIN_BUFF_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	if 0 > startSec then
		ctrl:SetTextByKey("remaintime", "{#004123}");
		ctrl:StopUpdateScript("SHOW_REMAIN_BUFF_TIME");
		return 0;
	end 
	local timeTxt = GET_TIME_TXT(startSec);
	local enchant = ctrl:GetUserIValue("ENCHANT");
	if 1 == enchant then
		ctrl:SetTextByKey("remaintime", "{nl}{#004123}    " .. timeTxt);
	else
		ctrl:SetTextByKey("remaintime", "{#004123}" .. timeTxt);
	end
	return 1;
end

function SHOW_REMAIN_BUFF_COUNT(ctrl)
	local buffUseCount = ctrl:GetUserValue("BuffUseCount");
	local buffCount = ctrl:GetUserValue("BuffCount");
	local timeTxt = string.format("{img gemtooltip_sword 16 16}".."%d/%d", buffUseCount, buffCount)
	ctrl:SetTextByKey("count", "{#004123}"..timeTxt);
	return 1;
end

function SET_TRANSCEND_TEXT(gBox, invitem, yPos, isEquiped)
    if isEquiped == nil then
		isEquiped = 0;
	end
	local pc = GetMyPCObject();
	local ignoreTranscend = TryGetProp(pc, 'IgnoreReinforce');
	if isEquiped == 0 then
		ignoreTranscend = 0;
	end
    local transcend = TryGetProp(invitem, "Transcend");
	if ignoreTranscend == 1 then
		transcend = 0;
	end

	if transcend ~= nil and transcend > 0 then
		local y = GET_CHILD_MAX_Y(gBox);

		local propNames, propValues = GET_ITEM_TRANSCENDED_PROPERTY(invitem);
		for i = 1 , #propNames do
			local propName = propNames[i];
			local propValue = propValues[i];

			local mhpText = gBox:CreateOrGetControl('richtext', "TRASNCEND_TEXT_" .. propName, 20, yPos, gBox:GetWidth() - 30, 20);
			mhpText = AUTO_CAST(mhpText);
			mhpText:SetTextFixWidth(1);
			local text = "{#004123}- " .. ScpArgMsg(propName .. "TranscendBy{Count}", "Count", transcend);
			mhpText:SetText(text);
		
			local hpUpValue = gBox:CreateOrGetControl('richtext', "TRASNCEND_VALUE_" .. propName, 200, yPos, 200, 20);
			hpUpValue = AUTO_CAST(hpUpValue);
			hpUpValue:SetTextFixWidth(1);
			hpUpValue:SetTextAlign("right", "center");

			local valueText = string.format("{#004123}"..ScpArgMsg("PropUp").."%d", propValue)
			hpUpValue:SetText(valueText.."%");
			
			yPos = yPos + mhpText:GetHeight();
		end
	end

	return yPos;
end

function SET_REINFORCE_TEXT(gBox, invitem, yPos, isEquiped, basicProp)
	if isEquiped == nil then
		isEquiped = 0;
	end
	local pc = GetMyPCObject();
	local ignoreReinf = TryGetProp(pc, 'IgnoreReinforce');
	local bonusReinf = TryGetProp(pc, 'BonusReinforce');
	if TryGetProp(invitem, 'EquipGroup') ~= 'SubWeapon' or isEquiped == 0 then
		bonusReinf = 0;
	end
	if isEquiped == 0 then
		ignoreReinf = 0;
	end
	local itemReinf = invitem.Reinforce_2 + bonusReinf;

	if itemReinf > 0  then
		local y = GET_CHILD_MAX_Y(gBox);
		local reinforceText = gBox:CreateOrGetControl('richtext', "REINFORCE_TEXT", 20, yPos, gBox:GetWidth() - 30, 20);
		reinforceText = tolua.cast(reinforceText, "ui::CRichText");
		reinforceText:SetTextFixWidth(1);
		reinforceText:SetFormat("%s");
		reinforceText:AddParamInfo("ReinforceText", "");

		local reinforceValue = 0;

		if invitem.GroupName == "Armor" then
			reinforceValue = GET_REINFORCE_ADD_VALUE(basicProp, invitem, ignoreReinf, bonusReinf);
		elseif invitem.GroupName == "Weapon" then
			reinforceValue = GET_REINFORCE_ADD_VALUE_ATK(invitem, ignoreReinf, bonusReinf, basicProp);
		elseif invitem.GroupName == "SubWeapon" then
			reinforceValue = GET_REINFORCE_ADD_VALUE_ATK(invitem, ignoreReinf, bonusReinf, basicProp);
		end

		if invitem.BuffValue > 0 then
			if invitem.BuffValue > reinforceValue then
				reinforceValue = invitem.BuffValue - reinforceValue
			else
				reinforceValue = reinforceValue - invitem.BuffValue
			end
		end
		local infoText = ScpArgMsg("MoruReinforce");
		if bonusReinf > 0 then
			infoText = ScpArgMsg("OverEstimate");
		end
		if ignoreReinf == 1 then
			infoText = ScpArgMsg("Devaluation");
		end
		local text = string.format("{#004123}".."- "..infoText)
		reinforceText:SetTextByKey("ReinforceText", text);

		local reinforceUpValue = gBox:CreateOrGetControl('richtext', "REINFORCE_VALUE", 350, yPos, gBox:GetWidth() - 30, 20);
		reinforceUpValue = tolua.cast(reinforceUpValue, "ui::CRichText");
		local valueText = string.format("{#004123}"..ScpArgMsg("PropUp").."%d", reinforceValue)
		reinforceUpValue:SetTextFixWidth(1);
		reinforceUpValue:SetFormat("%s");
		reinforceUpValue:AddParamInfo("ReinforceValue", "");
		reinforceUpValue:SetTextByKey("ReinforceValue", valueText);

		yPos = yPos + reinforceText:GetHeight();
	end

	return yPos;
end

function SET_REINFORCE_BUFF_TEXT(gBox, invitem, yPos)
	if invitem.Reinforce_2 >= 10  then
		if invitem.DefRatio == 0 and invitem.MDefRatio == 0 then
			return yPos;
		end
		
		local y = GET_CHILD_MAX_Y(gBox);
		
		local reinforceBuffText = gBox:CreateOrGetControl('richtext', "REINFORCE_BUFF_TEXT", 20, yPos, gBox:GetWidth() - 30, 20);
		reinforceBuffText = tolua.cast(reinforceBuffText, "ui::CRichText");
		reinforceBuffText:SetTextFixWidth(1);
		reinforceBuffText:SetFormat("%s");
		reinforceBuffText:AddParamInfo("ReinforceBuffText", "");

		local text;
		local ratioValue = 0;
		if invitem.DefRatio > 0 then
			text = string.format("{#004123}".."- "..ScpArgMsg("MeleeDamage"))
			ratioValue = invitem.DefRatio;
		elseif invitem.MDefRatio > 0 then
			text = string.format("{#004123}".."- "..ScpArgMsg("MagicDamage"));
			ratioValue = invitem.MDefRatio;
		end
		reinforceBuffText:SetTextByKey("ReinforceBuffText", text);

		local reinforceBuffValue = gBox:CreateOrGetControl('richtext', "REINFORCE_BUFF_VALUE", 350, yPos, gBox:GetWidth() - 30, 20);
		reinforceBuffValue = tolua.cast(reinforceBuffValue, "ui::CRichText");
		reinforceBuffValue:SetTextFixWidth(1);
		reinforceBuffValue:SetFormat("%s");
		reinforceBuffValue:AddParamInfo("ReinforceValue", "");
		
		local valueText = string.format("{#004123}"..ScpArgMsg("PropUp").."%d%%", ratioValue);
		reinforceBuffValue:SetTextByKey("ReinforceValue", valueText);

		yPos = yPos + reinforceBuffValue:GetHeight();
	end

	return yPos;
end

function ABILITY_CHANGEVALUE_SKINSET(tooltipframe, itemtype, invitem, equipItem)
	local valueUp = IS_VALUE_UP_BY_CHANGE_ITEM(itemtype, invitem, equipItem);
	local gbox = GET_CHILD(tooltipframe,'changevalue','ui::CGroupBox')

	if valueUp == 0 then
		gbox:SetSkinName("comparisonballoon_negative");
	else
		gbox:SetSkinName("comparisonballoon_positive");
	end
end

function IS_VALUE_UP_BY_CHANGE_ITEM(itemtype, beforeItem, afterItem)
	local valueUp = 0;
	if itemtype == "WEAPON" and afterItem ~= nil then

		local equipMinAtkInfo = afterItem.MINATK;
		local equipMaxAtkInfo = afterItem.MAXATK;

		local invMinAtkInfo = beforeItem.MINATK;
		local invMaxAtkInfo = beforeItem.MAXATK;

		if ABILITY_COMPARITION_VALUE(invMinAtkInfo, equipMinAtkInfo) < 0 or ABILITY_COMPARITION_VALUE(invMaxAtkInfo, equipMaxAtkInfo) < 0 then
			valueUp = 1;
		else
			local equipAbilityTotal = 0;
			local invAbilityTotal = 0;

			local list = GET_ATK_PROP_LIST();
			
			for i = 3 , #list do
				local propName = list[i];
				equipAbilityTotal = equipAbilityTotal + afterItem[propName];
				invAbilityTotal = invAbilityTotal + beforeItem[propName];
			end

			if ABILITY_COMPARITION_VALUE(invAbilityTotal, equipAbilityTotal) < 0 then
				valueUp = 1;
			end
		end
	elseif itemtype == "ARMOR" and afterItem ~= nil then
		local equipDefInfo = 0;
		local invDefInfo = 0;

		if afterItem.ClassType == 'Pants' or afterItem.ClassType == 'Shirt' then
			equipDefInfo = afterItem.DEF;
			invDefInfo = beforeItem.DEF;
		elseif afterItem.ClassType == 'Gloves' then

			equipDefInfo = afterItem.CRTATK;
			invDefInfo = beforeItem.CRTATK;

		elseif afterItem.ClassType == 'Boots' then

			equipDefInfo = afterItem.MSTA;
			invDefInfo = beforeItem.MSTA;
		end

		if ABILITY_COMPARITION_VALUE(invDefInfo, equipDefInfo) < 0 then
			valueUp = 1;
		end

		local equipAbilityTotal = 0;
		local invAbilityTotal = 0;

		local list = GET_DEF_PROP_LIST();

		for i = 1 , #list do
			local propName = list[i];
			equipAbilityTotal = equipAbilityTotal + afterItem[propName];
			invAbilityTotal = invAbilityTotal + beforeItem[propName];

		end

		if ABILITY_COMPARITION_VALUE(invAbilityTotal, equipAbilityTotal) < 0 then
			valueUp = 1;
		end
	end
	return valueUp;
end

function ABILITY_COMPARITION_VALUE(invInfo, equipInfo)
	return equipInfo - invInfo;
end

function ABILITY_DESC_COMPARITION(desc, invInfo, equipInfo, style)
	if style == nil then
		style = "{s20}";
	end
	local result = invInfo - equipInfo;
	if result > 0 then

		--if desc == ScpArgMsg('Auto_KangHwaJamJaeLyeog') then
		--	result = invInfo;
		--end
		return string.format(style.."{#050505}%s{/} "..style.."{#004000}{b}+%d{/}", desc, result);
	elseif result < 0 then
		return string.format(style.."{#050505}%s{/} "..style.."{#400000}{b}%d{/}", desc, result);
	end
	return string.format("None");
end

function ADD_COMPARITION_TOOLTIP(GroupCtrl, txt)
	if txt ~= "None" then
		local cnt = GroupCtrl:GetChildCount();		
		local ControlSetObj			= GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');
		
		local MARGIN_BETWEEN_TITLE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_TITLE_N_VALUE")
		local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

		ControlSetCtrl:SetOffset(0, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + MARGIN_BETWEEN_TITLE_N_VALUE)

		local richtextChild	 		= ControlSetCtrl:GetChild('changetext');

		tolua.cast(richtextChild, "ui::CRichText");
		richtextChild:EnableResizeByText(1);
		richtextChild:SetTextFixWidth(0);
		richtextChild:SetTextAlign("center", "center");
		richtextChild:SetText(txt);
		richtextChild:SetGravity(ui.CENTER_HORZ, ui.TOP);		
		ControlSetObj:Resize(richtextChild:GetWidth(), ControlSetObj:GetHeight());
		return 1;
	end
	return 0;
end

function ABILITY_DESC(desc, basic, cur)

	if basic == cur then
		return string.format("%s  %d", desc ,cur);
	else
		return string.format("%s  {#00FF00}%d{/} (%d + {#00FF00}%d{/})", desc ,cur, basic, cur - basic);
	end
end

function ABILITY_DESC_PLUS_OLD(desc, basic, cur, color)
	if basic == 0 and cur == 0 then
		return string.format("%s %s", desc ,ScpArgMsg("NONEINC"));
	end

	local fontColor = color;
	if fontColor == nil then
		fontColor = "{#ffffff}";
	end

	if basic == cur then
		return string.format(fontColor.."- %s + %d", desc, cur);
	else
		return string.format(fontColor.."- %s + %d", desc, cur);
	end
end

function ABILITY_DESC_PLUS(desc, cur)

    if cur < 0 then
        return string.format(" - %s "..ScpArgMsg("PropDown").."%d", desc, math.abs(cur));
    else
    	return string.format(" - %s "..ScpArgMsg("PropUp").."%d", desc, math.abs(cur));
	end

end

function ABILITY_DESC_GENERAL(desc, basic, cur, color)
	local fontColor = color;
	if fontColor == nil then
		fontColor = "{#050505}";
	end

	return string.format(fontColor.."%s %d", desc, cur);
end

function GET_ITEM_GRADE_FROM_LEVEL(invitem)

	local i = math.floor(invitem.UseLv / 10) + 1;
	local enums = {"E","D","C","B","A","AA","AAA","S"};
	return enums[i];
end

function GET_DUR_TEXT(invitem)

	local dureinfo = "";
	local Durability = invitem.MaxDur;
	if Durability ~= 0 then
		local viewDur = invitem.Dur / DUR_DIV();
		dureinfo = string.format( "{#050505}".."%s", ScpArgMsg("DURABILITY"));
	else
		dureinfo = "";
	end

	return dureinfo;
end

function TOGGLE_TRADE_OPTION(tradabilityCset, invitem, pictureName, richtextName, property)
    local styleTradeOn = tradabilityCset:GetUserConfig('STYLE_TRADE_ON');
    local styleTradeOff = tradabilityCset:GetUserConfig('STYLE_TRADE_OFF');

	local picture = GET_CHILD(tradabilityCset, pictureName, 'ui::CPicture')
	local richtext = GET_CHILD(tradabilityCset, richtextName, 'ui::CRichText')

	if IS_ENABLE_TRADE_BY_TRADE_TYPE(invitem, property) == true then
		picture:SetImage('tradecondition_on')
        richtext:SetTextByKey('style', styleTradeOn);
    else
	    picture:SetImage('tradecondition_off')
        richtext:SetTextByKey('style', styleTradeOff);
    end
end

function IS_ENABLE_TRADE_BY_TRADE_TYPE(invitem, property)
    if property == "ShopTrade" then
	    return IS_ENABLED_SHOP_TRADE_ITEM(invitem)
    elseif property == "UserTrade" then
	    return IS_ENABLED_USER_TRADE_ITEM(invitem)
    elseif property == "TeamTrade" then
	    return IS_ENABLED_TEAM_TRADE_ITEM(invitem)
    elseif property == "MarketTrade" then
	    return IS_ENABLED_MARKET_TRADE_ITEM(invitem)
    else
        IMC_ERROR("NORMAL", "IS_ENABLE_TRADE_BY_TRADE_TYPE ERROR!!")
    end
end

function ON_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC()
	local frame = ui.GetFrame("inventory")
    if frame == nil then
        return;
    end
	local wholeitem = ui.GetTooltip("wholeitem")
	local wholeitem_link = ui.GetFrame("wholeitem_link")
    
    local is_frame_visible = frame ~= nil and frame:IsVisible() == 1;
    local is_wholeitem_visible = wholeitem ~= nil and wholeitem:IsVisible() == 1;
    local is_wholeitem_link_visible = wholeitem_link ~= nil and wholeitem_link:IsVisible() == 1;
    
    if is_frame_visible == false and is_wholeitem_link_visible == false then
        return;
    end

    isToggle = IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC()
	if isToggle == 1 then
		frame:SetUserValue("IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC", 0);
	else
        frame:SetUserValue("IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC", 1);
	end

    ON_REFRESH_ITEM_TOOLTIP()
end

function IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC()
    local frame = ui.GetFrame("inventory")
    if frame == nil then
        return 0;
    end
    local value = frame:GetUserValue("IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC");
	return tonumber(value)
end

function IS_DISABLED_TRADE(invitem)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
	local blongProp = TryGetProp(invitem, "BelongingCount");
	local blongCnt = 0;
	if blongProp ~= nil then
		blongCnt = tonumber(blongProp);
	end

    if invitem.MaxStack <= 1 and (GetTradeLockByProperty(invitem) ~= "None" or 0 <  blongCnt) then
        return true;
    end
    return false;
end

function IS_ENABLED_SHOP_TRADE_ITEM(invitem)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);
    if false == itemProp:IsEnableShopTrade() then
        return false;
    else
        return true;
    end
end
function IS_ENABLED_USER_TRADE_ITEM(invitem)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);

	if false == itemProp:IsEnableUserTrade()then
        return false;
	elseif true == IS_DISABLED_TRADE(invitem) then
        return false;
    else
        return true;
	end
end

function IS_ENABLED_MARKET_TRADE_ITEM(invitem)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);

    if false == itemProp:IsEnableMarketTrade() then
        return false;
    elseif true == IS_DISABLED_TRADE(invitem) then
        return false;
    else
        return true;
    end
end

function IS_ENABLED_TEAM_TRADE_ITEM(invitem)
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);

    if false == itemProp:IsEnableTeamTrade() then
        return false;
    elseif true == IS_DISABLED_TRADE(invitem) then
        return false;
    else
        return true;
    end
end

function GET_ENABLE_TRADE_MSG(itemProp)
    if itemProp == nil then
        return "";
    elseif itemProp:IsEnableUserTrade() == true then
        return ScpArgMsg("UserTradeAble");
    elseif itemProp:IsEnableMarketTrade() == true then
        return ScpArgMsg("MarketTradeAble");
    else 
        return ScpArgMsg("UserTradeUnable")
    end
end
