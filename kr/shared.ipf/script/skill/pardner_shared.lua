--- pardner_shared.lua

function GET_OBLATION_MAX_COUNT(skillLevel)
    local value = skillLevel * 100
	return value;

end

function GET_OBLATION_PRICE_PERCENT()
	return 0.8;
end

function GET_BUFF_SELLER_LIMIT_COUNT(pc, spellShopSkl)
	return 4; -- 판매 가능 개수를 바꾸고 싶다면 여기를 수정해주세요
end