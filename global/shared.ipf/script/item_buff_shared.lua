--item_buff.lua

function GET_ITEM_PROPERT_STR(item)
	if item.GroupName == "Weapon" then
		if item.BasicTooltipProp == "ATK" then
			return ClMsg("MAXATK"), ClMsg("MINATK");
		elseif item.BasicTooltipProp == "MATK" then
			return ClMsg("Magic_Atk"), "";
		end
	elseif item.GroupName == "SubWeapon" then
	    if item.BasicTooltipProp == "ATK" then
			return ClMsg("MAXATK"), ClMsg("MINATK");
		elseif item.BasicTooltipProp == "DEF" then
			return ClMsg("MELEEDEF"), "";
		end
	else
		if item.BasicTooltipProp == "DEF" then
			return ClMsg("MELEEDEF"), "";
		elseif item.BasicTooltipProp == "MDEF" then
			return ClMsg("MDEF"), "";
		elseif  item.BasicTooltipProp == "HR" then
			return ClMsg("ADD_HR"), "";
		elseif  item.BasicTooltipProp == "DR" then
			return ClMsg("ADD_DR"), "";
		elseif  item.BasicTooltipProp == "MHR" then
			return ClMsg("MHR"), "";
		elseif  item.BasicTooltipProp == "ADD_FIRE" then
			return ClMsg("ADD_FIRE"), "";
		elseif  item.BasicTooltipProp == "ADD_ICE" then
			return ClMsg("ADD_ICE"), "";
		elseif  item.BasicTooltipProp == "ADD_LIGHTNING" then
			return ClMsg("ADD_LIGHTNING"), "";
		else
		return "";
		end
	end
end

function ITEMBUFF_CHECK_Squire_WeaponTouchUp(self, item)
	if false == IS_EQUIP(item) then
		return 0;
	end

	if item.GroupName == "Weapon" then
		return 1;
	elseif item.GroupName == 'SubWeapon' and item.BasicTooltipProp == 'ATK' then
	    return 1;
	end

	return 0;
end

function ITEMBUFF_CHECK_Squire_ArmorTouchUp(self, item)
	if false == IS_EQUIP(item) then
		return 0;
	end
	if item.GroupName == "Armor" then
		if item.ClassType == "Shield" or
		   item.ClassType == "Shirt" or
		   item.ClassType == "Pants" then
				return 1;
		end
		return 0;
	end
	return 0;
end

function ITEMBUFF_CHECK_Enchanter_EnchantArmor(self, item)
	if false == IS_EQUIP(item) then
		return 0;
	end

	if item.GroupName == "Armor" then
		if item.ClassType == "Shield" or
		   item.ClassType == "Shirt" or
		   item.ClassType == "Pants" then
				return 1;
		end
		return 0;
	end
	return 0;
end

function ITEMBUFF_NEEDITEM_Enchanter_EnchantArmor(self, item)	
	return "misc_emptySpellBook", 1;
end

function ITEMBUFF_NEEDITEM_Squire_WeaponTouchUp(self, item)
	local needCount = item.ItemStar + item.ItemStar * (item.ItemGrade - 1) / 2;
	needCount = math.max(1, needCount);
	return "misc_whetstone", math.floor(needCount);
end

function ITEMBUFF_NEEDITEM_Squire_ArmorTouchUp(self, item)
	local needCount = item.ItemStar + item.ItemStar * (item.ItemGrade - 1) / 2;
	needCount = math.max(1, needCount);
	return "misc_repairkit_1", math.floor(needCount);
end

function ITEMBUFF_NEEDITEM_Squire_Repair(self, item)
	local needCount = item.ItemStar + item.ItemStar * (item.ItemGrade - 1) / 2;
	return "misc_repairkit_1", math.floor(needCount);
end

function ITEMBUFF_STONECOUNT_Squire_WeaponTouchUp(invItemList)
	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_whetstone" then
			count = count + invItem.count;
		end
	end

	return "misc_whetstone", count;
end

function ITEMBUFF_STONECOUNT_Squire_ArmorTouchUp(invItemList)
	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_repairkit_1" then
			count = count + invItem.count;
		end
	end

	return "misc_repairkit_1", count;
end

function ITEMBUFF_STONECOUNT_Squire_Repair(invItemList)

	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_repairkit_1" then
			count = count + invItem.count;
		end
	end

	return "misc_repairkit_1", count;
end

function ITEMBUFF_STONECOUNT_Enchanter_EnchantArmor(invItemList)
	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_emptySpellBook" then
			count = count + invItem.count;
		end
	end

	return "misc_emptySpellBook", count;
end

function ITEMBUFF_VALUE_Squire_WeaponTouchUp(self, item, skillLevel)

    local star = item.ItemStar;
    
    if star > 8 then
        star = 8;
    end
    
	local value = item.ItemStar + skillLevel * item.ItemStar;
	local count = 2500 + skillLevel * 250 + self.INT;
	local sec = 3600;
	local Squire3 = GetAbility(self, 'Squire3');
	
	if Squire3 ~= nil then
	    count = count + Squire3.Level * 20
	end
	
	return value, sec, count;
end

function ITEMBUFF_VALUE_Squire_ArmorTouchUp(self, item, skillLevel)
	local value = skillLevel;
	local count = 500 + skillLevel * 50 + self.INT;
	local sec = 3600;
	local Squire4 = GetAbility(self, 'Squire4');
	
	if Squire4 ~= nil then
	    count = count + Squire4.Level * 5
	end
	
	return value, sec, count;
end

function ITEMBUFF_VALUE_Squire_Repair(self, item, skill)

	local sklValue = skill.Level * 100;
	
	local owner = GetSkillOwner(skill);
	local abil = GetAbility(owner, "Squire10")
	if abil ~= nil then
	    if IMCRandom(1, 9999) < abil.Level * 500 then
	        sklValue = sklValue * 2 
	    end
	end
	
	local value = (item.MaxDur - item.Dur) + sklValue
	
	value = item.Dur + value;
	return value;
end


function ITEMBUFF_STONECOUNT_Alchemist_Roasting(invItemList, frame)

	frame:SetUserValue("STORE_GROUP_NAME", 'GemRoasting');

	local i = invItemList:Head();
	local count = 0;
	while 1 do
		if i == invItemList:InvalidIndex() then
			break;
		end
		local invItem = invItemList:Element(i);		
		i = invItemList:Next(i);
		local obj = GetIES(invItem:GetObject());
		
		if obj.ClassName == "misc_catalyst_1" then
			count = count + invItem.count;
		end
	end

	return "misc_catalyst_1", count;
end


function ITEMBUFF_NEEDITEM_Alchemist_Roasting(self, item)
	local needCount = 1;
	return "misc_catalyst_1", needCount;
end


function ITEMBUFF_CHECK_Alchemist_Roasting(self, item)
	
	if item.GroupName == "Gem" then
		return 1;
	end

	return 0;
end