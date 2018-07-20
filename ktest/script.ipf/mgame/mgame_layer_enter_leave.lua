-- mgame_layer_enter_leave.lua

function MGAME_CRE_SOBJ(self, cmd, objType, sobjName)
	
	if objType ~= 0 and GetObjType(self) ~= objType then
		return;
	end

	CreateSessionObject(self, sobjName, 0);
end

function MGAME_ZONEENTER_SCRIPT(self, cmd, objType, funcName)

	if objType ~= 0 and GetObjType(self) ~= objType then
		return;
	end

	local funcPtr = _G[funcName];
	funcPtr(self);

end

function MGAME_RANDOM_SET_TEAM(self, cmd)

	if GetObjType(self) ~= OT_PC then
		return;
	end
	
	local teamID = MGAME_GET_SMALLER_TEAM(self);
	SET_MGAME_TEAM(self, teamID);

end

function MGAME_RESUR_DLG(self, cmd, isEnable)
	if GetObjType(self) ~= OT_PC then
		return;
	end
	EnableResurrect(self, isEnable);
end

function MGAME_CREATE_PC_SIMPLE_AI(self, cmd, aiName)
	if GetObjType(self) ~= OT_PC then
		return;
	end
	RunSimpleAI(self, aiName);
end

function MGAME_PC_LIST_UPDATE(self, cmd, sendOnlyTeamPC)

	if GetObjType(self) ~= OT_PC then
		return;
	end

	SendUpdateLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer(), sendOnlyTeamPC);
end

function MGAME_PC_UI_BYFACTION(self, cmd, faction, funcName, arg)

	if GetObjType(self) ~= OT_PC then
		return;
	end

	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1 , cnt do
		local pc = list[i];
		if GetCurrentFaction(pc) == faction then
			SendPropertyInfo(self, pc, 0);
			RunTargetPCUIFunc(self, pc, funcName, arg);
		end
	end	
end




