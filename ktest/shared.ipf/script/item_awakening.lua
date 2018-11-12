-- item_awakening.lua


function GET_ITEM_AWAKENING_PRICE(obj) -- 여기 각성 가루 아이템의 클래스 네임과 개수 공식을 써주십쇼    
	local count = 1;
--    if obj ~= nil then
--        count = obj.ItemStar * obj.ItemGrade;
--    end
    
	return "misc_wakepowder", count;
end

function IS_ITEM_AWAKENING_STONE(obj)
	if obj.ClassName == "misc_awakeningStone1" then
		return true;
	elseif obj.ClassName == "Premium_awakeningStone" or obj.ClassName == "Premium_awakeningStone14" or obj.ClassName == "Premium_awakeningStone_TA" or obj.ClassName == "Premium_awakeningStone14_Team" then
		return true;
	end

	return false;
end