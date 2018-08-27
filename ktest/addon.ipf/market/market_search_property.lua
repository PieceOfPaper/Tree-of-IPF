local MARKET_OPTION_GROUP_PROP_LIST = {
	STAT = {
		"STR",
		"DEX",
		"INT",
		"CON",
		"MNA",
	},
    UTIL = {
		"BLK",
		"BLK_BREAK",
		"ADD_HR",
		"ADD_DR",
		"CRTHR",
		"MHP",
		"MSP",
		"MSTA",
		"RHP",
		"RSP",
		"LootingChance",
	},
    MARKET_DEF = {
		"ADD_DEF",
		"ADD_MDEF",
		"AriesDEF",
		"SlashDEF",
		"StrikeDEF",
		"RES_FIRE",
		"RES_ICE",
		"RES_POISON",
		"RES_LIGHTNING",
		"RES_EARTH",
		"RES_SOUL",
		"RES_HOLY",
		"RES_DARK",
		"CRTDR",
	},
    ATK = {
		"PATK",
		"ADD_MATK",
		"CRTATK",
		"ADD_MHR",
		"ADD_CLOTH",
		"ADD_LEATHER",
		"ADD_IRON",
		"ADD_SMALLSIZE",
		"ADD_MIDDLESIZE",
		"ADD_LARGESIZE",
		"ADD_GHOST",
		"ADD_FORESTER",
		"ADD_WIDLING",
		"ADD_VELIAS",
		"ADD_PARAMUNE",
		"ADD_KLAIDA",
		"ADD_FIRE",
		"ADD_ICE",
		"ADD_POISON",
		"ADD_LIGHTNING",
		"ADD_EARTH",
		"ADD_SOUL",
		"ADD_HOLY",
		"ADD_DARK",
	},
    ETC = {
		"SR",
		"MSPD",
	},
};

local MARKET_DETAIL_SETTING_LIST = {
	"Transcend",
	"Reinforce_2",
	"PR",
};

local MARKET_ITEM_COUNT_PER_PAGE = {
	Weapon = 7,
	Armor = 7,
	Accessory = 7,	
	RecipeMaterial = 7,
	Recipe_Detail = 3,
	Default = 11
};

function IS_MARKET_DETAIL_SETTING_OPTION(optionName)
	for i = 1, #MARKET_DETAIL_SETTING_LIST do
		if MARKET_DETAIL_SETTING_LIST[i] == optionName then
			return true;
		end
	end
	return false;
end

function IS_MARKET_SEARCH_OPTION_GROUP(optionName)
	for group, list in pairs(MARKET_OPTION_GROUP_PROP_LIST) do
		for i = 1, #list do
			if optionName == list[i] then
				return true, group;
			end
		end
	end
	return false;
end

function MARKET_INIT_OPTION_GROUP_DROPLIST(dropList)
	dropList:ClearItems();
	dropList:AddItem('', '');
	for group, list in pairs(MARKET_OPTION_GROUP_PROP_LIST) do		
		dropList:AddItem(group, ClMsg(group));
	end
	MARKET_INIT_OPTION_GROUP_VALUE_DROPLIST(dropList:GetParent(), dropList);
end

function MARKET_INIT_OPTION_GROUP_VALUE_DROPLIST(optionGroupSet, groupList)
	local selectedGroup = groupList:GetSelItemKey();
	local nameList = GET_CHILD(optionGroupSet, 'nameList');
	local nameValueList = MARKET_OPTION_GROUP_PROP_LIST[selectedGroup];	
	nameList:ClearItems();
	nameList:AddItem('', '');
	if nameValueList ~= nil then
		for i = 1,  #nameValueList do
			nameList:AddItem(nameValueList[i], ClMsg(nameValueList[i]));
		end
	end
end

function MARKET_INIT_DETAIL_SETTING_DROPLIST(groupList)
	groupList:ClearItems();
	groupList:AddItem('', '');
	for i = 1, #MARKET_DETAIL_SETTING_LIST do
		local group = MARKET_DETAIL_SETTING_LIST[i];
		groupList:AddItem(group, ClMsg(group));
	end
end

function GET_MARKET_SEARCH_ITEM_COUNT(category)
	if MARKET_ITEM_COUNT_PER_PAGE[category] == nil then
		return MARKET_ITEM_COUNT_PER_PAGE['Default'];
	end
	return MARKET_ITEM_COUNT_PER_PAGE[category];
end