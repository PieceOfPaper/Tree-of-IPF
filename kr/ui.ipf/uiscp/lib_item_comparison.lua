---- lib_item_comparison.lua

function GET_EQUIP_TOOLTIP_PROP_LIST(invitem)

	local groupName = invitem.GroupName;
	if groupName == 'Weapon' then
		return GET_ATK_PROP_LIST();
	
	elseif groupName == "PetWeapon" then
		return GET_PET_WEAPON_PROP_LIST();
	elseif groupName == "PetArmor" then
		return GET_PET_ARMOR_PROP_LIST();
	else
		return GET_DEF_PROP_LIST();
	end

end

function GET_DEF_PROP_CHANGEVALUETOOLTIP_LIST()

	local list = {};
    list[#list+1] = "DEF";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "CON";
    list[#list+1] = "MNA";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "CRTMATK";
    list[#list+1] = "MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillWidthRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "BLK";
    list[#list+1] = "BLK_BREAK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
    list[#list+1] = "LootingChance";    
	return list;

end

function GET_ATK_PROP_CHANGEVALUETOOLTIP_LIST()
	
	local list = {};
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "MINATK";
    list[#list+1] = "MAXATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "MNA";
    list[#list+1] = "CON";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "CRTMATK";
    list[#list+1] = "MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillWidthRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "BlockRate";
    list[#list+1] = "BLK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
    list[#list+1] = "LootingChance";
	return list;

end

function GET_DEF_PROP_LIST()

	local list = {};
    list[#list+1] = "DEF";
    list[#list+1] = "ADD_DEF";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "ADD_MATK";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "CON";
    list[#list+1] = "MNA";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "ADD_HR";
    list[#list+1] = "ADD_DR";
    list[#list+1] = "CRTMATK";
    list[#list+1] = "MDEF";
    list[#list+1] = "ADD_MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillWidthRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "BLK";
    list[#list+1] = "BLK_BREAK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
    list[#list+1] = "LootingChance";
	return list;

end

function GET_ATK_PROP_LIST()
	
	local list = {};
    list[#list+1] = "SR";
    list[#list+1] = "SDR";
    list[#list+1] = "MINATK";
    list[#list+1] = "MAXATK";
    list[#list+1] = "ADD_MAXATK";
    list[#list+1] = "ADD_MINATK";
    list[#list+1] = "ADD_MATK";
    list[#list+1] = "PATK";
    list[#list+1] = "MATK";
    list[#list+1] = "ADD_DEF";
    list[#list+1] = "STR";
    list[#list+1] = "DEX";
    list[#list+1] = "INT";
    list[#list+1] = "MNA";
    list[#list+1] = "CON";
    list[#list+1] = "MHP";
    list[#list+1] = "MSP";
    list[#list+1] = "MSTA";
    list[#list+1] = "CRTHR";
    list[#list+1] = "CRTDR";
    list[#list+1] = "CRTATK";
    list[#list+1] = "KDPow";
    list[#list+1] = "SkillPower";
    list[#list+1] = "ADD_HR";
    list[#list+1] = "ADD_DR";
    list[#list+1] = "CRTMATK";
    list[#list+1] = "MDEF";
    list[#list+1] = "ADD_MDEF";
    list[#list+1] = "SkillRange";
    list[#list+1] = "SkillWidthRange";
    list[#list+1] = "SkillAngle";
    list[#list+1] = "MSPD";
    list[#list+1] = "RHP";
    list[#list+1] = "RSP";
    list[#list+1] = "BLK";
    list[#list+1] = "BLK_BREAK";
    list[#list+1] = "ADD_FORESTER";
    list[#list+1] = "ADD_WIDLING";
    list[#list+1] = "ADD_VELIAS";
    list[#list+1] = "ADD_PARAMUNE";
    list[#list+1] = "ADD_KLAIDA";
    list[#list+1] = "ADD_SMALLSIZE";
    list[#list+1] = "ADD_MIDDLESIZE";
    list[#list+1] = "ADD_LARGESIZE";
    list[#list+1] = "ADD_CLOTH";
    list[#list+1] = "ADD_LEATHER";
    list[#list+1] = "ADD_IRON";
    list[#list+1] = "ADD_GHOST";
    list[#list+1] = "ADD_FIRE";
    list[#list+1] = "ADD_ICE";
    list[#list+1] = "ADD_SOUL";
    list[#list+1] = "ADD_POISON";
    list[#list+1] = "ADD_LIGHTNING";
    list[#list+1] = "ADD_EARTH";
    list[#list+1] = "ADD_HOLY";
    list[#list+1] = "ADD_DARK";
    list[#list+1] = "Aries";
    list[#list+1] = "Slash";
    list[#list+1] = "Strike";
    list[#list+1] = "RES_FIRE";
    list[#list+1] = "RES_ICE";
    list[#list+1] = "RES_SOUL";
    list[#list+1] = "RES_POISON";
    list[#list+1] = "RES_LIGHTNING";
    list[#list+1] = "RES_EARTH";
    list[#list+1] = "RES_HOLY";
    list[#list+1] = "RES_DARK";
    list[#list+1] = "AriesDEF";
    list[#list+1] = "SlashDEF";
    list[#list+1] = "StrikeDEF";
    list[#list+1] = "HR";
    list[#list+1] = "DR";
    list[#list+1] = "LootingChance";
	return list;

end

function GET_PET_WEAPON_PROP_LIST()
	local list = GET_ATK_PROP_LIST();
	list[#list+1] = "MountPATK";
	list[#list+1] = "MountMATK";
	return list;
    
end

function GET_PET_ARMOR_PROP_LIST()
	local list = GET_DEF_PROP_LIST();
	list[#list+1] = "MountPATK";
	list[#list+1] = "MountMATK";
	return list;    
end

function GET_ATK_PICK_PROP_LIST()
    local list = {};
    local pc = GetMyPCObject()
    local jobObj = GetJobObject(self);
    if jobObj.CtrlType == 'Wizard' then
        list[#list+1] = "MINATK";
    	list[#list+1] = "MAXATK";
    	list[#list+1] = "ADD_MAXATK";
    	list[#list+1] = "ADD_MINATK";
    	list[#list+1] = "MATK";
    else
        list[#list+1] = "MINATK";
    	list[#list+1] = "MAXATK";
    	list[#list+1] = "ADD_MAXATK";
    	list[#list+1] = "ADD_MINATK";
    	list[#list+1] = "PATK";
	end

	return list;
end

function GET_EUQIPITEM_PROP_LIST()
	
	local list = {};
--  list[#list+1] = "Strike";
--  list[#list+1] = "Strike_Range";
--  list[#list+1] = "Slash_Range";
--  list[#list+1] = "Slash";
--  list[#list+1] = "Aries_Range";
--  list[#list+1] = "Aries";
	list[#list+1] = "HitCount";
	list[#list+1] = "BackHit";
	return list;
end

function GET_COMPARE_PROP_LIST(item)

	if item.ToolTipScp == "WEAPON" then
		return GET_ATK_PROP_LIST();
	else
		return GET_DEF_PROP_LIST();
	end

end

function GET_SUM_OF_PROP(equipItem, propList)

	local ret = 0;
	for i = 1 , #propList do
		ret = ret + equipItem[propList[i]];
	end
	
	return ret;
end


function ITEM_BETTER_THAN(a, b)

	if a.ToolTipScp == "WEAPON" then
		return ABILITY_COMPARITION_VALUE(a.MINATK, b.MINATK) < 0
		or ABILITY_COMPARITION_VALUE(a.MAXATK, b.MAXATK) < 0;
	else
		return ABILITY_COMPARITION_VALUE(a.DEF, b.DEF) < 0;
	end

end

function GET_MAIN_PROP_LIST(itemObj)
	
	local list = {};
	list[#list+1] = "MINATK";
	list[#list+1] = "MAXATK";
	list[#list+1] = "DEF";
	return list;

end


function GET_CHECK_OVERLAP_EQUIPPROP_LIST(propList, prop, list)
    local checkList = propList;
    if list == nil then
        list = {};
    end
    for i = 1, #checkList do
        if checkList[i] ~= prop then
            list = PUSH_BACK_IF_NOT_EXIST(list, checkList[i]);
        end
    end
    
    return list;
end