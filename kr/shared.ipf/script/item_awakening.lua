-- item_awakening.lua


function GET_ITEM_AWAKENING_PRICE(obj)
	local count = obj.ItemStar * obj.ItemGrade;
	return "misc_catalyst_1", count;
end

function IS_ITEM_AWAKENING_STONE(obj)
	if obj.ClassName == "misc_awakeningStone1" then
		return true;
	end

	return false;
end