---- lib_reinforce_131014.lua

function REINFORCE_ABLE_131014(item)
	
	if item.ItemType ~= 'Equip' then
		return 0;
	end

	if item.Reinforce_Type ~= "Moru" then
		return 0;
	end

	return 1;
end

function GET_REINFORCE_131014_PRICE(fromItem, moruItem)
	if moruItem.ClassName == "Moru_Potential" or moruItem.ClassName == "Moru_Potential14d" then
		return 0;
	end
	local reinforcecount = fromItem.Reinforce_2;
	local slot = fromItem.DefaultEqpSlot;
	local grade = fromItem.ItemGrade;
    local value = 0;
    local star = fromItem.ItemStar;
	local priceobj = GetClassByType('item_reinforceprice', star);
    local lv = fromItem.ItemLv;
    
    local price = priceobj.ReinforcePrice / 8;
    local priceRatio = 1;

    if slot == 'RH' then
        if fromItem.DBLHand == 'YES' then
            priceRatio = 1.2;
        else
            priceRatio = 1;
        end
    elseif slot == 'LH' then
        if fromItem.ClassType == 'Shield' then
            priceRatio = 0.66;
        else
            priceRatio = 0.8;
        end
    elseif slot == 'SHIRT' or 'PANTS' then
        priceRatio = 0.75;
    elseif slot == 'GLOVES' or 'BOOTS' then
        priceRatio = 0.75;
    elseif slot == 'NECK' then
        priceRatio = 0.5;
    elseif slot == 'RING' then
        priceRatio = 0.5;
    end

    if reinforcecount < 1 then
        reinforcecount = 0.6
    end

    value = (price * reinforcecount * ((grade + 9) / 10)) * priceRatio;
	if moruItem.ClassName == "Moru_Platinum_Premium" then
		value = value / 2;
	end
	
    if moruItem.ClassName == "Moru_Silver" then
		value = 0;
	end
	
    if moruItem.ClassName == "Moru_Silver_test" then
		value = 0;
	end
    if moruItem.ClassName == "Moru_Potential" or moruItem.ClassName == "Moru_Potential14d" then
		value = 0;
	end
	
    value = math.floor(value)
	return math.floor(value);

end


function GET_REINFORCE_131014_HITCOUNT(fromItem, moru)

	local moruRank = string.sub(moru.ClassName, 6, 7);
	moruRank = tonumber(moruRank);
	local ItemStar = fromItem.ItemStar;
	
	local prop = geItemTable.GetProp(fromItem.ClassID);
	return 3;

end
