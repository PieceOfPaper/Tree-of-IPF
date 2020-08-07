function GET_USE_ROULETTE_TYPE()
	local type = "GODDESS_ROULETTE";

	return type;
end

function GET_USE_ROULETTE_COUNT(type, accObj)
	if accObj == nil then return;	end

    local table = 
    {
        ["GODDESS_ROULETTE"] = TryGetProp(accObj, "GODDESS_ROULETTE_USE_ROULETTE_COUNT"),
        ["GODDESS_ROULETTE_SEASON_SERVER"] = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_USE_ROULETTE_COUNT"),
    }

	return table[type];
end

function GET_MAX_ROULETTE_COUNT(type)
    local table = 
    {
        ["GODDESS_ROULETTE"] = GODDESS_ROULETTE_MAX_COUNT,
        ["GODDESS_ROULETTE_SEASON_SERVER"] = EVENT_NEW_SEASON_SERVER_ROULETTE_MAX_COUNT,
    }

	return table[type];
end

function GET_ROULETTE_COIN_CLASSNAME(type)
    local table = 
    {
        ["GODDESS_ROULETTE"] = "Event_Roulette_Coin_2",
        ["GODDESS_ROULETTE_SEASON_SERVER"] = "Event_Roulette_Coin",
    }

	return table[type];
end

function GET_ROULETTE_PROP(type)
    local table = 
    {
        ["GODDESS_ROULETTE"] = "GODDESS_ROULETTE_USE_ROULETTE_COUNT",
        ["GODDESS_ROULETTE_SEASON_SERVER"] = "EVENT_NEW_SEASON_SERVER_USE_ROULETTE_COUNT",
    }

	return table[type];
end

function GET_ROULETTE_TITLE(type)
    local table = 
    {
        ["GODDESS_ROULETTE"] = "GODDESS_ROULETTE",
        ["GODDESS_ROULETTE_SEASON_SERVER"] = "EVENT_NEW_SEASON_SERVER_ROULETTE",
    }

	return table[type];
end

function GET_ROULETTE_DIALOG(type)
    local table = 
    {
        ["GODDESS_ROULETTE"] = "GODDESS_ROULETTE_DLG_3",
        ["GODDESS_ROULETTE_SEASON_SERVER"] = "GODDESS_ROULETTE_DLG_2",
    }

	return table[type];
end

