---- lib_ENCHANTCHIP.lua

function ENCHANTCHIP_ABLIE(item)
	
	if item.GroupName ~= "Armor" then
		return 0;
	end

	if item.ClassType ~= 'Hat' then
		return 0;
	end

	return 1;
end

function IS_ENCHANT_ITEM(item)
	if item.ClassName == "Premium_Enchantchip" or item.ClassName == "Premium_Enchantchip14" or item.ClassName == "Premium_Enchantchip_CT" or
	   item.ClassName == "TeamBat_Enchantchip" or item.ClassName == "Adventure_Enchantchip" or item.ClassName == "Premium_Enchantchip14_Team" or
	   item.ClassName == "STEAM_MASTER_Premium_Enchantchip" or item.ClassName == "Event_Enchantchip_1" or item.ClassName == "Event_Enchantchip_2"
	   or item.ClassName == "Event_Enchantchip_3" then
		return 1;
	end

	return 0;
end