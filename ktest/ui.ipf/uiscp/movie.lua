-- movie.lua

function ACT_START_MANUFAC(handle, animName)	
	movie.PlayAnim(handle, animName, 1.0, 1);	
end

function ACT_STOP_MANUFAC(handle)
	movie.StopAnim(handle);	
end

function ACT_QUEST_WARP(handle)
	if session.GetMyHandle() == handle then
		return;
	end

	movie.QuestWarp(handle, "None", 0);
end

function ACT_INTE_WARP(handle)
	if session.GetMyHandle() == handle then
		return;
	end

	movie.InteWarp(handle, "None");
end