function GUILDINFO_WAR_INIT(parent, warBox)
    GUILDINFO_WAR_INIT_CHECKBOX(parent);
    GUILDINFO_WAR_INIT_LIST(parent);
    ui.CloseFrame('guild_authority_popup');
end

function ON_GUILD_SET_NEUTRALITY(parent, checkBox)
	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
        GUILDINFO_WAR_INIT_CHECKBOX(parent);
		return;
	end

	local guild = GET_MY_GUILD_INFO();
    local guildObj = GET_MY_GUILD_OBJECT();
    if guild == nil or guildObj == nil then
        return;
    end

    -- 길드 중립 선포 가능 최소 레벨
    if IS_ENABLE_GUILD_NEUTRALITY(guildObj) == false then
        ui.SysMsg(ScpArgMsg('GuildNeutralityLevelUpperThan{LEVEL}', 'LEVEL', MIN_LEVEL_FOR_GUILD_NEUTRALITY));        
        GUILDINFO_WAR_INIT_CHECKBOX(parent);
        return;
    end

    -- 길드 중립 템플러 길마만 할 수 있다고 함
    local templerCls = GetClass('Job', 'Char1_16');
    if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == false then
        ui.SysMsg(ClMsg('TgtDonHaveTmpler'));        
        GUILDINFO_WAR_INIT_CHECKBOX(parent);
        return;
    end

    local curState = guild.info:GetNeutralityState();
    local neutralityCost = 0;
    if curState == false then -- 자금 확인
        neutralityCost = GET_GUILD_NEUTRALITY_COST(guildObj);
        if neutralityCost < 0 then
            GUILDINFO_WAR_INIT_CHECKBOX(parent);
            return;
        end
        local currentAsset = guildObj.GuildAsset;    
        if currentAsset == nil or currentAsset == 'None' then
            currentAsset = 0;
        end
        currentAsset = tonumber(currentAsset);
        if currentAsset < neutralityCost then
            ui.SysMsg(ScpArgMsg('UnableGuildNeutralityBecause{COST}', 'COST', GET_COMMAED_STRING(neutralityCost)));
            GUILDINFO_WAR_INIT_CHECKBOX(parent);
            return;
        end
    end

	local yesScp = string.format("C_GUILD_SET_NEUTRALITY(%d)", 1);
	local noScp = string.format("C_GUILD_SET_NEUTRALITY(%d)", 0);
	if true == curState then -- 중립상태 해제
		ui.MsgBox(ScpArgMsg("WantTobeChangedNoneNeutralityState"), yesScp, noScp);
	else -- 중립상태 원함
		ui.MsgBox(ScpArgMsg("WantTobeChangedNeutralityState{COST}", 'COST', neutralityCost), yesScp, noScp);
	end
end

function GUILDINFO_WAR_INIT_CHECKBOX(warBox)
    if warBox == nil then
        local guildinfo = ui.GetFrame('guildinfo');
        warBox = GET_CHILD_RECURSIVELY(guildinfo, 'warBox');
    end
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end

    local neutralCheck = GET_CHILD_RECURSIVELY(warBox, 'neutralCheck');    
    local state = 0;
    if true == guild.info:GetNeutralityState() then
		state = 1;
	end	
	neutralCheck:SetCheck(state);

    GUILDINFO_WAR_INIT_CHECKBOX_ALARM(warBox);
end

function GUILDINFO_WAR_INIT_LIST(warBox)
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local warListBox = GET_CHILD_RECURSIVELY(warBox, 'warListBox');    
    DESTROY_CHILD_BYNAME(warListBox, 'WAR_GUILD_');

    local cnt = guild.info:GetEnemyPartyCount();
	for i = 0 , cnt - 1 do
		local enemyInfo = guild.info:GetEnemyPartyByIndex(i);
        local ctrlSet = warListBox:CreateOrGetControlSet('guildwar_ctrlset', 'WAR_GUILD_'..enemyInfo:GetPartyName(), 0, 0);

        -- name
        local t_guildname = ctrlSet:GetChild('t_guildname');
        t_guildname:SetTextByKey("value", enemyInfo:GetPartyName());

        -- time
        local t_remainTime = ctrlSet:GetChild('t_remainTime');
        local serverTime = geTime.GetServerFileTime();
		local warEndTime = enemyInfo:GetEndTime();
		local remainSec = imcTime.GetIntDifSecByTime(warEndTime, serverTime);
		if remainSec <= 0 then
			local remainRemoveSec = (GUILD_WAR_REST_MINUTE * 60 + remainSec)
			local remainTimeText = GET_TIME_TXT_DHM(remainRemoveSec);
			t_remainTime:SetTextByKey("value", ScpArgMsg("NextDeclareWarAbleTime") .. " " .. remainTimeText);
		else
			local remainTimeText = GET_TIME_TXT_DHM(remainSec);
			t_remainTime:SetTextByKey("value", remainTimeText);
		end
    end
    GBOX_AUTO_ALIGN(warListBox, 60, 0, 0, true, false);
end

function C_GUILD_SET_NEUTRALITY(change)
	local guild = GET_MY_GUILD_INFO();
	if nil == guild then
        GUILDINFO_WAR_INIT_CHECKBOX();
		return;
	end
	
	if change == 0 then
		local frame = ui.GetFrame("guildinfo");
		GUILDINFO_WAR_INIT_CHECKBOX();
		return;
	end

	session.guildState.ChangeGuildNeutralityState(guild.info);
end

function ON_GUILD_NEUTRALITY_UPDATE(frame, msg, strArg, numArg)
	local guild = GET_MY_GUILD_INFO();
	if guild == nil then
		return;
	end

	if strArg ~= nil and strArg == "Change" then
		if true == guild.info:GetNeutralityState() then
			ui.SysMsg(ScpArgMsg("ChangeGuildNeutralityState"));
		else
			ui.SysMsg(ScpArgMsg("ChangeGuildNoneNeutralityState"));
		end
	end
    GUILDINFO_WAR_INIT_CHECKBOX(frame);
    GUILDINFO_INIT_PROFILE(frame);
end

function GUILDINFO_WAR_NEUTRALITY_ALARM(parent, alarmCheck)
    local alarmValue = alarmCheck:IsChecked();
    local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
        GUILDINFO_WAR_INIT_CHECKBOX_ALARM(parent);
		return;
	end

    local guildObj = GET_MY_GUILD_OBJECT();
    if alarmValue == guildObj.GuildNeutralityAlarm then
        GUILDINFO_WAR_INIT_CHECKBOX_ALARM(parent);
		return;
    end

    session.guildState.ReqGuildNeutralityAlaram(alarmValue);
end

function GUILDINFO_WAR_INIT_CHECKBOX_ALARM(warBox)
    local neutralAlarmCheck = GET_CHILD_RECURSIVELY(warBox, 'neutralAlarmCheck');
    local guildObj = GET_MY_GUILD_OBJECT();
    local state = guildObj.GuildNeutralityAlarm;
	neutralAlarmCheck:SetCheck(state);
end

function GUILD_GAME_START_3SEC(frame)

	local guild = GET_MY_GUILD_INFO();
	if guild == nil then
		return;
	end

    -- 전쟁 알람
    local serverTime = geTime.GetServerFileTime();
	local cnt = guild.info:GetEnemyPartyCount();
	for i = 0 , cnt - 1 do
		local enemyInfo = guild.info:GetEnemyPartyByIndex(i);
		local remainSec = imcTime.GetIntDifSecByTime(enemyInfo:GetEndTime(), serverTime);
		if remainSec > 0 then
			local msg = ScpArgMsg("WarWith{Name}GuildRemain{Time}", "Name", enemyInfo:GetPartyName(), "Time", GET_TIME_TXT_DHM(remainSec));
			ui.SysMsg(msg);
		end
	end

    -- 중립 해제 알람
    local guildObj = GET_MY_GUILD_OBJECT();
    if guildObj.GuildNeutralityAlarm == 1 and true == guild.info:GetNeutralityState() then
        local neutralityEndTime = guild.info.neutralityEndTime;
        local remainSec = imcTime.GetIntDifSecByTime(neutralityEndTime, serverTime);

        if remainSec < 86400 and remainSec > 0 then -- 1일전부터 알람
            local msg = ScpArgMsg("GuildNeutralityEndTimeRemain{TIME}", "TIME", GET_TIME_TXT_DHM(remainSec));
			ui.SysMsg(msg);
        end
    end	
end

function WAR_BEGIN_MSG(partyName)
	local msg = ScpArgMsg("WarStartedWith{GuildName}", "GuildName", partyName);
	ui.SysMsg(msg);		
end

function WAR_END_MSG(partyName)
	local msg = ScpArgMsg("WarEndedWith{GuildName}", "GuildName", partyName);
	ui.SysMsg(msg);
end