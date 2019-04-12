--- pet_client.lua --

function PET_EQUIP(invItem)
	
end

function REQ_PET_EQUIP(invItem)

	local type = invItem.type;
	local petInfo = session.pet.GetSummonedPet();
	local itemObj = GetIES(invItem:GetObject());
	local petSlot = TryGetProp(itemObj, "PetSlot");
	if petSlot == nil then
		return;
	end

	local itemEnum = gePet.StringToPetEquipSlot(petSlot);

	local obj = GetIES(petInfo:GetObject());
	if itemObj.UsePetEquipGroup ~= obj.EquipGroup then
		ui.SysMsg(ClMsg("ThisPetCannotEquipThisItem"));
		return;
	end

	if obj.Lv < itemObj.UseLv then
		ui.SysMsg(ClMsg("NotEnoughLevelToEquipItem"));
		return;
	end
	
	geClientPet.RequestEquipPet( petInfo:GetStrGuid(), invItem:GetIESID(), itemEnum, -1 );
	
end

function SET_TOOLTIP_REVIVAL_EGG_NAME(item)
	local keyWord = item.KeyWord;
	local ret = item.Name;
	ret = ret .. " - ";
	local strList = StringSplit(keyWord, "#");
	for i = 1 , #strList / 2 do
		local propName = strList[2 * i - 1];
		local propValue = strList[2 * i];
		if propName == "DeadName" then
			ret = ret .. propValue;
		end
	end

	return ret;
end

function SET_TOOLTIP_REVIVAL_EGG_DESC(obj)

	local keyWord = obj.KeyWord;

	local monName = nil;
	local name = "";
	local strList = StringSplit(keyWord, "#");
	for i = 1 , #strList / 2 do
		local propName = strList[2 * i - 1];
		local propValue = strList[2 * i];
		if propName == "ClsName" then
			monName = propValue;
		elseif propName == "DeadName" then
			name = propValue;
		end
	end	

	if monName ~= nil then
		local monCls = GetClass("Monster", monName);
		local ret = "{img " .. monCls.Icon .. " 80 80 }";
		ret = ret .. "{nl}";
		ret = ret .. string.format("%s (%s)", name, monCls.Name);
		return ret;
	end

	return "";
end


function SET_TOOLTIP_REVIVAL_EGG(icon, invitem, itemCls)

	local obj = GetIES(invitem:GetObject());

	local keyWord = obj.KeyWord;

	local monName = nil;
	local strList = StringSplit(keyWord, "#");
	for i = 1 , #strList / 2 do
		local propName = strList[2 * i - 1];
		local propValue = strList[2 * i];
		if propName == "ClsName" then
			monName = propValue;
		end
	end	

	print(monNamemonCls);
	if monName ~= nil then
		local monCls = GetClass("Monster", monName);
		icon:SetImage(monCls.Icon);
		print(monCls.Icon);
		--icon:SetTooltipType('skill');
		-- icon:SetTooltipArg("Level", skillType, level);
	end
	return 1;
end


function C_GET_COMPANION_POS(actor)
	local myPet = control.GetMyCompanionActor();

	if nil == myPet then
		return 0, 0, 0
	end
	myPet = tolua.cast(myPet, "CFSMActor");
	local pos = myPet:GetPos();
	print(pos.z, pos.y, pos.x);
	return pos.z, pos.y, pos.x;
end