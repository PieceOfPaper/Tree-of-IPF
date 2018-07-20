--- pardner_shared.lua

function GET_OBLATION_MAX_COUNT(skillLevel)
    local value = skillLevel * 100
	return value;

end

function GET_OBLATION_PRICE_PERCENT()
	return 0.8;
end