-- lib_mission.lua --

function GET_MY_TEAMID()

	local handle = session.GetMyHandle();
	return info.GetTeamID(handle);
	
end
