function GET_USE_ROULETTE_COUNT(accObj)
	if accObj == nil then return;	end

	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		return TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_USE_ROULETTE_COUNT");
	elseif GetServerNation() == "KOR" then
		return TryGetProp(accObj, "GODDESS_ROULETTE_USE_ROULETTE_COUNT");
	end
end

function GET_MAX_ROULETTE_COUNT(accObj)
	if accObj == nil then return;	end

	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		return EVENT_NEW_SEASON_SERVER_ROULETTE_MAX_COUNT;
	elseif GetServerNation() == "KOR" then
		return GODDESS_ROULETTE_MAX_COUNT;
	end
end
 
function GET_ROULETTE_COIN_CLASSNAME(accObj)
	if accObj == nil then return;	end

	if IS_EVENT_NEW_SEASON_SERVER(accObj) == true then
		return "Event_Roulette_Coin";
	elseif GetServerNation() == "KOR" then
		return "Event_Roulette_Coin_2";
	end
end
