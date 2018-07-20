-- lib_session.lua --

function GET_NPC_STATE_COUNT()
	local cnt = 0;
	local npcStates = session.GetNPCStateMap();
	local idx = npcStates:Head();
	while idx ~= npcStates:InvalidIndex() do

		local mapName = npcStates:KeyPtr(idx);
		local mapList = npcStates:Element(idx);
		cnt = cnt + mapList:Count();
		idx = npcStates:Next(idx);
	end

	return cnt;
end
	