-- shared_challenge_mode.lua

-- party_bonus
function get_party_bouns(stage_level, map_level, pc_count)	
	local party_bonus = 1	
	if map_level > 420 then	-- 420 초과 레벨대 맵부터
		if stage_level <= 5 then
			party_bonus = math.max(pc_count - 1, 1)
		elseif stage_level > 5 then
			party_bonus = math.max(pc_count, 1)
		end
	end	
	return party_bonus
end
