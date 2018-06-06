-- guild_skill.lua

function GUILD_SKILL_USABLE_STATE_Templer_WarpToGuildMember(pc)
	local mapName = GetZoneName(pc);
	local mapCls = GetMapProperty(pc);
	
	if mapName == 'mission_groundtower_1' or mapName == 'mission_groundtower_2' then
		SendSysMsg(pc, "DisableWarpToGuildMemberSkill")
		return 0;
	end
	
    if mapCls.ClassName == 'guild_agit_1' or IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        SendSysMsg(pc, "DisableWarpToGuildMemberSkill")
        return 0;
    end
    
	return 1;
end

function GUILD_SKILL_CHECK_ACCEPT_Templer_WarpToGuildMember()
	return 0;
end

function GUILD_SKILL_Templer_WarpToGuildMember(leader, memberAID, sklLevel, x, y, z, memberMapID, memberChannelID, mx, my, mz)

	local mapCls = GetClassByType("Map", memberMapID);

    if mapCls.ClassName == 'd_castle_agario' or mapCls.ClassName == 'pvp_Mine' then
        SendSysMsg(leader, 'CantWarpBcz');        
        return;
    end
     
	WarpToGuildMember(leader, mapCls.ClassName, mx, my, mz, memberChannelID, memberAID);
	--MoveZone(leader, mapCls.ClassName, mx, my, mz, "None", memberChannelID, memberAID);

end


function GUILD_SKILL_USABLE_STATE_Templer_SummonGuildMember(pc)
    local mapCls = GetMapProperty(pc);
    local mapName = GetZoneName(pc);
    
	if mapName == 'mission_groundtower_1' or mapName == 'mission_groundtower_2' then
		SendSysMsg(pc, "DisableSummonGuildMemberSkill")
		return 0;
	end

	--콜로니전 안에서는 무조건 사용할 수 있어야 함.
	if IsJoinColonyWarMap(pc) == 1 then
		return 1;
	end

    if mapCls.ClassName == 'guild_agit_1' or IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        SendSysMsg(pc, "DisableSummonGuildMemberSkill")
        return 0;
    end
	
	return 1;
end

function GUILD_SKILL_CHECK_ACCEPT_Templer_SummonGuildMember()
	return 1;
end

function GUILD_SKILL_Templer_SummonGuildMember(leader, memberAID, sklLevel, x, y, z, memberMapID, memberChannelID, mx, my, mz)
	local mapID = GetMapID(leader);
	local channelID = GetMyChannel(leader);

	if mapID == 8021 then
		return;
	end

	if IsJoinColonyWarMap(leader) ~= 1 then
		RecallPlayerByAID(leader, memberAID, mapID, channelID, x, y, z, 0);
	else
		local zoneID = GetZoneInstID(leader)
		RecallPlayerByAID(leader, memberAID, mapID, channelID, x, y, z, zoneID);
	end


end

function ENTER_REDUCE_CRAFTTIME(self, skl, pad, target)
	
	AddBuff(self, target, 'ReduceCraftTime_Buff', skl.Level, 0, 0, 1);
end

function LEAVE_REDUCE_CRAFTTIME(self, skl, pad, target)
	RemoveBuff(target, 'ReduceCraftTime_Buff');
end


