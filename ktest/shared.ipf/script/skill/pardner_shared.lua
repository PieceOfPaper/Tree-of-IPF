--- pardner_shared.lua

-- done, 해당 함수 내용은 cpp로 이전되었습니다. 변경 사항이 있다면 반드시 프로그램팀에 알려주시기 바랍니다.
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