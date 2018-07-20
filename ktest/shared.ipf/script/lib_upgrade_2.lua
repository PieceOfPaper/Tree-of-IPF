---- lib_upgrade2.lua

function IS_ITEM_EVOLUTIONABLE(item)

	if 1 == 1 then
		return 1;
	end

	local prop = geItemTable.GetProp(item.ClassID);
	if prop.evolutionType == 0 then
		return 0;
	end

	local curLevel = GET_ITEM_LEVEL(item);
	if curLevel >= prop:GetMaxLevel() and prop:GetMaxLevel() > 0 then
		return 1;
	end

	return 0;

end

function GET_EVOLUTION_HIT_COUNT(fromItem, moru)

	local moruRank = string.sub(moru.ClassName, 6, 7);
	moruRank = tonumber(moruRank);
	local ItemStar = fromItem.ItemStar;
	
	local prop = geItemTable.GetProp(fromItem.ClassID);
	local cls = GetClassByType("itemevolution", prop.evolutionType);

	---- 모루와 아이템의 컬럼을 이용해서 몇번 모루를 때려야 하는지 계산한다.
	
	return cls.HitCount;

end

function IS_MORU_ITEM(obj)
	if string.len(obj.ClassName) < 5 then
		return 0;
	end

	if string.sub(obj.ClassName, 1, 5) == "Moru_" then
		return 1;
	end

	return 0;
end