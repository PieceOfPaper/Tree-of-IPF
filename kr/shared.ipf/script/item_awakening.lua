-- item_awakening.lua


function GET_ITEM_AWAKENING_PRICE(obj)
	local count = obj.ItemStar * obj.ItemGrade;
	return "misc_catalyst_1", count;
end

