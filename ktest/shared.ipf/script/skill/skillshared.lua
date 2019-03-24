--- skillshared.lua

function SKILL_TARGET_ITEM_Swordman_Thrust(obj)
	
		
	return 1;	
end

function GET_NINJA_SKILLS()

	local retList = {};
	retList[#retList + 1] = "Shinobi_Kunai";
	retList[#retList + 1] = "Shinobi_Mijin_no_jutsu";
	retList[#retList + 1] = "Shinobi_Katon_no_jutsu";
	retList[#retList + 1] = "Shinobi_Raiton_no_Jutsu";
--	retList[#retList + 1] = "Swordman_Thrust";
--	retList[#retList + 1] = "Swordman_Bash";
--	retList[#retList + 1] = "Swordman_DoubleSlash";
--	retList[#retList + 1] = "Swordman_PommelBeat";
--	retList[#retList + 1] = "Peltasta_UmboBlow";
--	retList[#retList + 1] = "Peltasta_RimBlow";
--	retList[#retList + 1] = "Peltasta_ButterFly";
--	retList[#retList + 1] = "Peltasta_Langort";
--	retList[#retList + 1] = "Highlander_Crown";
--	retList[#retList + 1] = "Highlander_Moulinet";
--	retList[#retList + 1] = "Hoplite_SynchroThrusting";
--	retList[#retList + 1] = "Barbarian_Cleave";
--	retList[#retList + 1] = "Barbarian_Seism";
--	retList[#retList + 1] = "Rodelero_ShootingStar";
--	retList[#retList + 1] = "Rodelero_ShieldBash";
--	retList[#retList + 1] = "Rodelero_TargeSmash";
--	retList[#retList + 1] = "Corsair_DustDevil";
--	retList[#retList + 1] = "Corsair_HexenDropper";
--	retList[#retList + 1] = "Corsair_ImpaleDagger";
--	retList[#retList + 1] = "Doppelsoeldner_Mordschlag";
--	retList[#retList + 1] = "Doppelsoeldner_Zwerchhau";
--	retList[#retList + 1] = "Doppelsoeldner_Sturzhau";
--	retList[#retList + 1] = "Fencer_SeptEtoiles";
--	retList[#retList + 1] = "Fencer_AttaqueComposee";
--	retList[#retList + 1] = "Fencer_Fleche";
--	retList[#retList + 1] = "Dragoon_Dragontooth";
--	retList[#retList + 1] = "Dragoon_Dragon_Soar";
--	retList[#retList + 1] = "NakMuay_Attack";
--	retList[#retList + 1] = "Templer_MortalSlash";
--	retList[#retList + 1] = "Squire_DeadlyCombo";
	return retList;

end

function GET_HOMUNCULUS_SKILLS()

	local retList = {};
	retList[#retList + 1] = "Wizard_Sleep";
	retList[#retList + 1] = "Wizard_Lethargy";
	retList[#retList + 1] = "Wizard_MagicMissile";
	retList[#retList + 1] = "Pyromancer_FireBall";
	retList[#retList + 1] = "Pyromancer_EnchantFire";
	retList[#retList + 1] = "Pyromancer_FirePillar";
	retList[#retList + 1] = "Cryomancer_IceBolt";	
	retList[#retList + 1] = "Cryomancer_IceWall";
	retList[#retList + 1] = "Cryomancer_IciclePike";
	retList[#retList + 1] = "Cryomancer_SubzeroShield";
	retList[#retList + 1] = "Cryomancer_Gust";
	retList[#retList + 1] = "Linker_JointPenalty";
	retList[#retList + 1] = "Linker_Physicallink";
	retList[#retList + 1] = "Psychokino_Swap";
	retList[#retList + 1] = "Psychokino_Teleportation";
	retList[#retList + 1] = "Psychokino_Raise";
	retList[#retList + 1] = "Psychokino_MagneticForce";
	retList[#retList + 1] = "Elementalist_StoneCurse";
	retList[#retList + 1] = "Elementalist_Rain";
--	retList[#retList + 1] = "Chronomancer_Quicken";
	retList[#retList + 1] = "Chronomancer_Slow";
	retList[#retList + 1] = "Chronomancer_Stop";
	retList[#retList + 1] = "Thaumaturge_ShrinkBody";
	retList[#retList + 1] = "Thaumaturge_SwellBody";
	
	return retList;

end

function GET_ENCHANTARMOR_OPTION(sklLv)

	local retList = {};
	retList[#retList + 1] = "ENCHANTARMOR_SOLID";
	retList[#retList + 1] = "ENCHANTARMOR_HEALING";
	retList[#retList + 1] = "ENCHANTARMOR_PROTECTIVE";
	retList[#retList + 1] = "ENCHANTARMOR_BLESSING";
	retList[#retList + 1] = "ENCHANTARMOR_HOLY";
	retList[#retList + 1] = "ENCHANTARMOR_VOLITIVE";
	local maxCnt = math.min(sklLv+1, 6);
	local tempList = {}
	for i = 1, maxCnt do
		tempList[i] = retList[i];
	end

	return tempList;
end

function SAGE_PORTAL_SKL_PORTAL_COOLTIME(skill)
	return 1800 - (skill.Level - 1) * 60;
end

function GET_TEMPLAR_GUILD_SKIL_LIST()
	local sklList = {"Templer_BuildForge", "Templer_BuildShieldCharger"};

	return sklList;
end

function HAS_GUILDGROWTH_SKL_OBJ(guildObj, sklName, sklLv)

	local objName = 'None'
	if string.find(sklName, 'Forge') ~= nil then
		objName = 'Forge_';
	elseif string.find(sklName, 'ShieldCharger') ~= nil then
		objName = 'ShieldCharger_';
	end

	if objName == 'None' then
		return false;
	end

	local objCount = 0;
	local propName = 'BuildingLife_'..objName;
	for i = 1, 5 do
		local propValue = TryGetProp(guildObj, propName..i);
		if nil == propValue then
			return false;
		end

		if propValue ~= 'None' then
			objCount = objCount + 1;
		end
	end
	
	if sklLv < objCount then
		return false;
	end

	return true;
end
function SCR_ARRAY_SHUFFLE(arr_val)
    if arr_val ~= nil then
        if type(arr_val) == 'table' then
            local i;
            local temp_arr;
            local rnd;
            for i = 1, #arr_val do
                rnd = IMCRandom(i, #arr_val);
                if rnd ~= i then
                    temp_arr = arr_val[i];
                    arr_val[i] = arr_val[rnd];
                    arr_val[rnd] = temp_arr;
                end
            end
            
--            return arr_val;
--        else
--            print('ERR!! arr_val is not Arrange Value')
        end
--    else
--        print('ERR!! arr_val is nil')
    end
    return arr_val;
end


function SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	local shopClass = GetClass("UserShopPrice", shopClassName);
	if shopClass == nil then
		return 0;
	end
	
	local price = TryGetProp(shopClass, "DefaultPrice", 0);
	
	local minPrice = TryGetProp(shopClass, "MinPrice");
	local maxPrice = TryGetProp(shopClass, "MaxPrice");
	
	price = math.min(math.max(price, minPrice), maxPrice);
	
	return math.floor(price);
end


function SCR_GET_ROASTING_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

function SCR_GET_ITEMAWAKENING_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

function SCR_GET_PORTALSHOP_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

function SCR_GET_ENCHANTARMOR_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

function SCR_GET_SPELLSHOP_PRICE(shopClassName, mapClassName, buffClassName, abilList)
--	if buffClassName == 'Priest_Aspersion' then
--		return 714;
--	end
--	
--	if buffClassName == 'Priest_Blessing' then
--		return 714;
--	end
--	
--	if buffClassName == 'Priest_Sacrament' then
--		return 700;
--	end
--	
--	if buffClassName == 'Pardoner_IncreaseMagicDEF' then
--		return 714;
--	end
--	
--	return 100;
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	local mapClass = GetClass("Map", mapClassName);
	if TryGetProp(mapClass, "MapType") == "Dungeon" then
--		for i = 1, #abilList do
--			if abilList[i].ClassName == "Pardoner8" then
--				price = 1200
--				
--				break
--			end
--		end
		price = 1200
	end
	
	return math.floor(price);
end

function SCR_GET_SWITCHGENDER_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

-- deprecated: buff_seller_info.xml에 적어주세요 
-- function GET_BUFFSELLER_SPEND_ITEM_COUNT(sklClassName)
-- 	if sklClassName == "Priest_Aspersion" then
-- 		return 10;
-- 	end
	
-- 	if sklClassName == "Priest_Blessing" then
-- 		return 25;
-- 	end
	
-- 	if sklClassName == "Priest_Sacrament" then
-- 		return 14;
-- 	end
	
-- 	if sklClassName == "Pardoner_IncreaseMagicDEF" then
-- 		return 10;
-- 	end
	
-- 	return 0;
-- end

function SCR_GET_EQUIPMENTTOUCHUP_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	local mapClass = GetClass("Map", mapClassName);
	if TryGetProp(mapClass, "MapType") == "Dungeon" then
--		for i = 1, #abilList do
--			if abilList[i].ClassName == "Squire13" then
--				price = 500
--				
--				break
--			end
--		end
		price = 500
	end
	
	return math.floor(price);
end

function SCR_GET_REPAIR_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	local mapClass = GetClass("Map", mapClassName);
	if TryGetProp(mapClass, "MapType") == "Dungeon" then
--		for i = 1, #abilList do
--			if abilList[i].ClassName == "Squire12" then
--				price = 200
--				
--				break
--			end
--		end
		price = 200
	end
	
	return math.floor(price);
end

function SCR_GET_APPRISE_PRICE(shopClassName, mapClassName, buffClassName, abilList)
	local price = SCR_USER_SHOP_PIRCE_DEFAULT(shopClassName)
	
	return math.floor(price);
end

-- 해당 skill에 checkKeyword 키워드가 존재하는지 체크. 있으면 1 반환, 없으면 0 반환.
function CHECK_SKILL_KEYWORD(skill, checkKeyword)
	local skillKeyword = TryGetProp(skill, 'Keyword');
	if skillKeyword ~= nil and skillKeyword ~= 'None' then
		local skillKeywordList = SCR_STRING_CUT(skillKeyword, ';')
		local index = table.find(skillKeywordList, checkKeyword);
		if index ~= 0 then
			return 1;
		end
	end
	
	return 0;
end


-- 버프 강화 특성 증가 비율 계산-------
-- calc_property_skill.lua 의 function SCR_REINFORCEABILITY_TOOLTIP(skill) 와 내용 동일함
-- 같이 변경해야 함
function SCR_REINFORCEABILITY_FOR_BUFFSKILL(self, skill)
    local addRate = 1;
    if self ~= nil and skill ~= nil then
        local reinforceAbilName = TryGetProp(skill, "ReinforceAbility", "None");
        if reinforceAbilName ~= "None" then
            local reinforceAbil = GetAbility(self, reinforceAbilName)
            if reinforceAbil ~= nil then
                local abilLevel = TryGetProp(reinforceAbil, "Level")
                local masterAddValue = 0
                if abilLevel == 100 then
                    masterAddValue = 0.1
                end
                
                addRate = addRate + (abilLevel * 0.005 + masterAddValue);
            end
        end
    end
    return addRate
end
