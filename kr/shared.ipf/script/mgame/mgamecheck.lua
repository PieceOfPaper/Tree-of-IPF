--- mgamecheck.lua

function TOURNAMENT_CHECK(pc)
	return 1;
end

function CHECK_MGAME_COMMON(pc, mGame)
	if mGame.minLv > 0 and pc.Lv < mGame.minLv then
	    return 0;
	end

	if mGame.maxLv > 0 and pc.Lv > mGame.maxLv then
	    return 0;
	end

	return 1;
end

