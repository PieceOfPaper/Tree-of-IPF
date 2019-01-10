-- lib_session.lua --

function GET_NPC_STATE_COUNT()
	local cnt = 0;

	local npcStateMaps = GetNPCStateMaps();
	for i = 1, #npcStateMaps do
		local mapName = npcStateMaps[i];
		local mapCls = GetClass("Map", mapName);
		if mapCls ~= nil then
			local npcGenTypes = GetNPCStateGenTypes(mapName);
			cnt = cnt + #npcGenTypes;
		end
	end

	return cnt;
end
	