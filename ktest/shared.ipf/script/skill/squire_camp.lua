--- squire_camp.lua

function CAMP_NEED_PRICE(skillName, sklLevel)
	
	local itemList = {};
	itemList[#itemList + 1] = "misc_campkit";
	itemList[#itemList + 1] = 10;
	
	return 1000, itemList;
	
end

function CAMP_EXTEND_PRICE(skillName, skillLevel)
	return 2000;
end

function CAMP_TIME(skillName, sklLevel)
	return 60 * 60 + 60 * 30 * sklLevel;
end

function CAMP_BUFF_TIME(sklLevel)
	return sklLevel * 20;
end


function FOODTABLE_NEED_PRICE(skillName, sklLevel)

	local itemList = {};
	itemList[#itemList + 1] = "misc_campkit";
	itemList[#itemList + 1] = 10;
	
	return 1000, itemList;
	
end

