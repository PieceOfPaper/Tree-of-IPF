-- cardbattle_shared.lua

function CARDBATTLE_RULLET_OPEN_DELAY()

	return 1.0;

end

function GET_CARDBATTLE_DECISION_DESC(randValue)
	if randValue == 0 then
		return "LonggerName";
	elseif randValue == 1 then
		return "ShorterName";
	elseif randValue == 2 then
		return "ManyStars";
	elseif randValue == 3 then
		return "ManyLegs";
	elseif randValue == 4 then
		return "LittleLegs";
	elseif randValue == 5 then
		return "HeavyWeight";
	elseif randValue == 6 then
		return "TallerHeight";
	end
end

function GET_CARDBATTLE_SCORE(targetItem, randValue)

	local cls = GetClass("CardBattle", targetItem.ClassName);
	if cls == nil then
		return 0, 0;
	end

	if randValue == 0 then
		return string.len(cls.EngName), 0;
	elseif randValue == 1 then
		return string.len(cls.EngName), 1;
	elseif randValue == 2 then
		return GET_ITEM_LEVEL_EXP(targetItem), 0;
	elseif randValue == 3 then
		return cls.LegCount, 0;
	elseif randValue == 4 then
		return cls.LegCount, 1;
	elseif randValue == 5 then
		return cls.BodyWeight, 0;
	elseif randValue == 6 then
		return cls.Height, 0;
	end
	
end

function CALC_CARD_BATTLE_RESULT(item, targetItem)
	
	local randValue = IMCRandom(0, 6);
	local itemScore, smallerWin = GET_CARDBATTLE_SCORE(item, randValue);
	local targetScore = GET_CARDBATTLE_SCORE(targetItem, randValue);

	local winSide = 0;
	if smallerWin == 0 then
		if itemScore > targetScore then
			winSide = 2;
		elseif itemScore < targetScore then
			winSide = 1;
		end
	else
		if itemScore > targetScore then
			winSide = 1;
		elseif itemScore < targetScore then
			winSide = 2;
		end
	end

	local factor = 1.2;
	local startSpeed, accel = GET_CARD_BATTLE_RULLET_SPEED(factor);
	local stopTime = startSpeed / accel;
	return randValue, winSide, factor, stopTime;

end

function GET_CARD_BATTLE_RULLET_SPEED(factor)

	local startSpeed = 2.5 * 360;
	local accel = 0.4 * 360;
	return startSpeed * factor, accel * factor;

end



