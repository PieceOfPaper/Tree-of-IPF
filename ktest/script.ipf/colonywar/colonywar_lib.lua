-- colonywar_lib.lua

COLONY_WAR_STATE_READY = 1;
COLONY_WAR_STATE_START = 2;
COLONY_WAR_STATE_DELAY = 3;
COLONY_WAR_STATE_END = 4;
COLONY_WAR_STATE_CLOSE = 5;

function COLONY_WAR_RETURN_CITY_ZONE(pc)
    local zoneName = GetZoneName(pc);
    local cls = GetClassByStrProp("guild_colony", "ZoneClassName", zoneName);
    if cls ~= nil then
        local warpCls = GetClassByStrProp("Warp", "TargetZone", cls.ReturnCityZoneClassName);
        if warpCls ~= nil then
            Warp(pc, warpCls.ClassName);
        end
    end
end

function SCR_COLONY_START_ALARM(timeEventCls, diffSec)
    local colonyDayOfWeek = GET_COLONY_WAR_DAY_OF_WEEK();
    local curTime = GetDBTime();
    if colonyDayOfWeek ~= -1 then --매일 오픈이 아니라면,
        if curTime.wDayOfWeek ~= colonyDayOfWeek then
            return;
        end
    end

    local checkScp = 'IS_ENTRY_GUILD';
    if diffSec == -63 then -- 시작 63초전, 콜로니전 참가인원 BGM 변경
        checkScp = 'IS_ENABLE_ENTER_COLONY_WAR';
    end

    if diffSec == -1800 or diffSec == -600 or diffSec == -300 or diffSec == -60 or diffSec == 0 then
        SendAddOnMsgToAllServerPC('COLONY_ALARM_MSG', 'START', diffSec, checkScp);
    elseif diffSec == -63 then
        SendAddOnMsgToAllServerPC('COLONY_BGM', 'START', diffSec, checkScp);
    end
end

function SCR_COLONY_END_ALARM(timeEventCls, diffSec)
    local colonyDayOfWeek = GET_COLONY_WAR_DAY_OF_WEEK();
    local curTime = GetDBTime();
    if colonyDayOfWeek ~= -1 then --매일 오픈이 아니라면,
        if curTime.wDayOfWeek ~= colonyDayOfWeek then
            return;
        end
    end

    local checkScp = 'IS_ENABLE_ENTER_COLONY_WAR_MAP';
    if diffSec == 0 then -- 정각인 경우, 길드가 있는 인원 모두에게 메시지 출력
        checkScp = 'IS_ENABLE_ENTER_COLONY_WAR_MAP_RESULT';
    end

    if diffSec == -1800 or diffSec == -600 or diffSec == -300 or diffSec == -60 or
      (diffSec >= -10 and diffSec <= 0) then
        SendAddOnMsgToAllServerPC('COLONY_ALARM_MSG', 'END', diffSec, checkScp);
    end
end

function SCR_CHANGE_COLONY_CONFIG(pc, changeValue)
    if IsRunningScript(pc, 'EXEC_CHANGE_COLONY_CONFIG') ~= 1 then
        EXEC_CHANGE_COLONY_CONFIG(pc, changeValue);
    end
end

function EXEC_CHANGE_COLONY_CONFIG(pc, changeValue)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return;
    end

    local pcGuildID = GetGuildID(pc);
    local guild = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);
    if IsPartyLeaderPc(guild, pc) == 0 then
        return;
    end

    local jobHistoryStr = GetJobHistoryString(pc);
    if string.find(jobHistoryStr, 'Char1_16') == nil then
        return;
    end
    
    if IsOccupationGuild(pcGuildID) == 1 then
        return;
    end

    if IsEnableChangeColonyEnterConfigTime() == 0 then
        SendSysMsg(pc, 'CannotChangeConfigAtColonyTime');
        SendAddOnMsg(pc, 'COLONY_ENTER_CONFIG_FAIL');
        return;
    end
    local beforeValue = guild.EnableEnterColonyWar;
    ChangePartyProp(pc, PARTY_GUILD, "EnableEnterColonyWar", changeValue);
	
	--변경되는 시점을 정확히 알기 힘들기 때문에 여기서 로깅
	EnableEnterColonyWarMongoLog(pc, guild, beforeValue, changeValue);

end

function NOTIFY_RETURN_CITY_ZONE(pc, count) 
    SendSysMsg(pc, 'AfterAWhileReturnCity{SEC}', 0, "SEC", count);
end

function IS_ENABLE_ENTER_COLONY_WAR(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return 0;
    end

    if IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        if IsJoinColonyWarMap(pc) ~= 1 then
            return 0;
        end
    end

    local enableEnterColonyWar = TryGetProp(guildObj, 'EnableEnterColonyWar');
    if enableEnterColonyWar ~= 1 then
        return 0;
    end

    return 1;
end



function SEND_KILL_DEAD_MESSAGE(Deader, killer)
    local fromGuildID = GetGuildID(killer);
	local guildID = GetGuildID(Deader);
	if fromGuildID == "0" or guildID == "0" then
		return;
	end

    local guild = GetGuildObj(Deader);
	local fromGuild = GetGuildObj(killer);
	local guildName = GetPartyName(guild);
	local fromGuildName = GetPartyName(fromGuild);
    local killMsg = ScpArgMsg("Colony_GuildMember{Name}Killed{Target}OfGuild{TargetGuild}", "Name", GetTeamName(killer), "Target", GetTeamName(Deader), "TargetGuild", guildName);
	BroadcastToPartyMember(PARTY_GUILD, fromGuildID, killMsg, "{#00FF00}");

	local killedMsg = ScpArgMsg("Colony_GuildMember{Name}HasKilledBy{From}OfGuild{FromGuild}", "Name", GetTeamName(Deader), "From", GetTeamName(killer), "FromGuild", fromGuildName);
	BroadcastToPartyMember(PARTY_GUILD, guildID, killedMsg, "");
end

function IS_ENTRY_GUILD(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return 0;
    end
    if IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        if IsJoinColonyWarMap(pc) ~= 1 then
            return 0;
        end
    end

    return 1;
end

function IS_ENABLE_ENTER_COLONY_WAR_MAP(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return 0;
    end

    if IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        if IsJoinColonyWarMap(pc) ~= 1 then
            return 0;
        end
    end

    local enableEnterColonyWar = TryGetProp(guildObj, 'EnableEnterColonyWar');
    if enableEnterColonyWar ~= 1 then
        return 0;
    end

    local enableEnterColonyWarMap = IsJoinColonyWarMap(pc)
    if enableEnterColonyWarMap ~= 1 then
        return 0;
    end

    return 1;
end

function IS_ENABLE_ENTER_COLONY_WAR_MAP_RESULT(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return 0;
    end

    if IsIndun(pc) == 1 or IsPVPServer(pc) == 1 or IsMissionInst(pc) == 1 then
        if IsJoinColonyWarMap(pc) ~= 1 then
            return 0;
        end
    end

    local enableEnterColonyWarMap = IsJoinColonyWarMap(pc)
    if enableEnterColonyWarMap == 1 then
        return 0;
    end

    return 1;
end