local json = require "json"

function GUILDINFO_INFO_INIT(parent, infoBox)
    local guildObj = GET_MY_GUILD_OBJECT();
    GUILDINFO_INFO_INIT_EXP(infoBox, guildObj);
    GUILDINFO_INFO_INIT_TOWER(infoBox, guildObj);
    GUILDINFO_INFO_INIT_BENEFIT(infoBox, guildObj);
    GUILDINFO_INFO_INIT_ABILITY(infoBox, guildObj);
    GetGuildProfile("SET_INTRODUCE_TXT")
    ui.CloseFrame('guild_authority_popup');
end

function SET_INTRO_TXT()
    local frame = ui.GetFrame("guildinfo")
    local introduceText = GET_CHILD_RECURSIVELY(frame, 'regPromoteText');
    SetGuildProfile("RECV_INTRO_TXT", introduceText:GetText())
end

function RECV_INTRO_TXT(code, ret_json)
    if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "RECV_INTRO_TXT");
        return;
    end
    ui.SysMsg("길드 소개글 변경 완료")
end

function SET_INTRODUCE_TXT(code, ret_json)
    if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "SET_INTRODUCE_TXT");
        return;
    end
    local frame = ui.GetFrame("guildinfo")
    local introduceText = GET_CHILD_RECURSIVELY(frame, 'regPromoteText');
    if introduceText:IsHaveFocus() == 0 then
        introduceText:SetText(ret_json);
    end

end

function GUILDINFO_INFO_INIT_EXP(infoBox, guildObj)
    -- level and exp guage
    local levelText = GET_CHILD_RECURSIVELY(infoBox, 'levelText');
    local guildLevel = guildObj.Level;
    levelText:SetTextByKey('level', guildLevel);

    local exp = guildObj.Exp;
    local curLevelCls = GetClass("GuildExp", guildLevel);
    local nextLevelCls = GetClass("GuildExp", guildLevel + 1);
    local curExp = exp - curLevelCls.Exp;
    local expGuage = GET_CHILD_RECURSIVELY(infoBox, 'expGuage');
    if nextLevelCls ~= nil then
        expGuage:SetPoint(curExp, nextLevelCls.Exp - curLevelCls.Exp);
    else -- max level
        expGuage:SetPoint(1000, 1000);
    end
end

function GUILDINFO_INFO_INIT_TOWER(infoBox, guildObj)
    local towerInfoText = GET_CHILD_RECURSIVELY(infoBox, 'towerInfoText');
    local towerMapText = GET_CHILD_RECURSIVELY(infoBox, 'towerMapText');
    local towerTimeText = GET_CHILD_RECURSIVELY(infoBox, 'towerTimeText');
    local towerPosition = guildObj.HousePosition;
    if towerPosition == 'None' then
        towerInfoText:SetTextByKey('current', 0);
        towerMapText:ShowWindow(0);
        towerTimeText:ShowWindow(0);
    else
        towerInfoText:SetTextByKey('current', 1);
        local towerInfo = StringSplit(towerPosition, "#");
		if #towerInfo == 3 then -- destroy by other guild
            local destroyPartyName = towerInfo[2];
			local destroyedTime = towerInfo[3];			
			if destroyPartyName == "None" then
				destroyPartyName = ScpArgMsg("Enemy");
			end

			local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
			towerMapText:SetTextByKey("map", positionText);

			local timeText = ScpArgMsg("ToRebuildableTime") .. " " ;
			towerTimeText:SetUserValue("PARTYNAME", destroyPartyName);	
			towerTimeText:SetUserValue("DESTROYTIME", destroyedTime);
			towerTimeText:RunUpdateScript("UPDATE_TOWER_DESTROY_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_DESTROY_TIME(towerTimeText);
        else
            local mapID = towerInfo[1];
			local towerID = towerInfo[2];
			local x = towerInfo[3];
			local y = towerInfo[4];
			local z = towerInfo[5];
			local builtTime = towerInfo[6];
			local mapCls = GetClassByType("Map", mapID);
			towerMapText:SetTextByKey('map', MAKE_LINK_MAP_TEXT(mapCls.ClassName, x, z));
			towerTimeText:SetUserValue("BUILTTIME", builtTime);
			towerTimeText:RunUpdateScript("UPDATE_TOWER_REMAIN_TIME", 1, 0, 0, 1);
			UPDATE_TOWER_REMAIN_TIME(towerTimeText);
        end
    end
end

function UPDATE_TOWER_REMAIN_TIME(towerTimeText)
	local builtTime = towerTimeText:GetUserValue("BUILTTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_LIFE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	local difSecString = GET_TIME_TXT_DHM(difSec);
	towerTimeText:SetTextByKey("time", difSecString);
	return 1;
end

function GUILDINFO_INFO_INIT_BENEFIT(infoBox, guildObj)
    local benefitBox = GET_CHILD_RECURSIVELY(infoBox, 'benefitBox');    
    DESTROY_CHILD_BYNAME(benefitBox, 'BENEFIT_');

    local yPos = 40;
    local currentTowerLevel = guildObj.TowerLevel;    

    -- warp
    local towerCtrlSet1 = benefitBox:CreateOrGetControlSet('guild_benefit', 'BENEFIT_WARP', 0, yPos);
    towerCtrlSet1 = AUTO_CAST(towerCtrlSet1);
    towerCtrlSet1:SetGravity(ui.CENTER_HORZ, ui.TOP)
    local WARP_IMG = towerCtrlSet1:GetUserConfig('WARP_IMG');    
    local DISABLE_COLOR = towerCtrlSet1:GetUserConfig('DISABLE_COLOR');
    local infoPic = GET_CHILD(towerCtrlSet1, 'infoPic');
    local infoText = towerCtrlSet1:GetChild('infoText');
    local infoStr = string.format('%s %s %d: %s', ClMsg('GuildTower'), ClMsg('Level'), 1, ClMsg('Warp'));
    infoPic:SetImage(WARP_IMG);
    infoText:SetText(infoStr);
    if currentTowerLevel < 1 then        
        towerCtrlSet1:SetColorTone(DISABLE_COLOR);
    end
    yPos = yPos + towerCtrlSet1:GetHeight();

    -- warehouse
    local towerCtrlSet2 = benefitBox:CreateOrGetControlSet('guild_benefit', 'BENEFIT_WAREHOUSE', 0, yPos);
    towerCtrlSet2 = AUTO_CAST(towerCtrlSet2);
    towerCtrlSet2:SetGravity(ui.CENTER_HORZ, ui.TOP)
    local WAREHOUSE_IMG = towerCtrlSet2:GetUserConfig('WAREHOUSE_IMG');    
    local infoPic = GET_CHILD(towerCtrlSet2, 'infoPic');
    local infoText = towerCtrlSet2:GetChild('infoText');
    local infoStr = string.format('%s %s %d: %s', ClMsg('GuildTower'), ClMsg('Level'), 2, ClMsg('WareHouse'));
    infoPic:SetImage(WAREHOUSE_IMG);
    infoText:SetText(infoStr);
    if currentTowerLevel < 2 then        
        towerCtrlSet2:SetColorTone(DISABLE_COLOR);
    end
    yPos = yPos + towerCtrlSet2:GetHeight();

    -- growth
    local towerCtrlSet3 = benefitBox:CreateOrGetControlSet('guild_benefit', 'BENEFIT_GROWTH', 0, yPos);
    towerCtrlSet3 = AUTO_CAST(towerCtrlSet3);
    towerCtrlSet3:SetGravity(ui.CENTER_HORZ, ui.TOP)
    local GROWTH_IMG = towerCtrlSet3:GetUserConfig('GROWTH_IMG');    
    local infoPic = GET_CHILD(towerCtrlSet3, 'infoPic');
    local infoText = towerCtrlSet3:GetChild('infoText');
    local infoStr = string.format('%s %s %d: %s', ClMsg('GuildTower'), ClMsg('Level'), 3,  ClMsg('GuildGrowth'));
    infoPic:SetImage(GROWTH_IMG);
    infoText:SetText(infoStr);
    if currentTowerLevel < 3 then        
        towerCtrlSet3:SetColorTone(DISABLE_COLOR);
    end
    yPos = yPos + towerCtrlSet3:GetHeight();

    -- event
    local towerCtrlSet4 = benefitBox:CreateOrGetControlSet('guild_benefit', 'BENEFIT_EVENT', 0, yPos);
    towerCtrlSet4 = AUTO_CAST(towerCtrlSet4);
    towerCtrlSet4:SetGravity(ui.CENTER_HORZ, ui.TOP)
    local EVENT_IMG = towerCtrlSet4:GetUserConfig('EVENT_IMG');    
    local infoPic = GET_CHILD(towerCtrlSet4, 'infoPic');
    local infoText = towerCtrlSet4:GetChild('infoText');
    local infoStr = string.format('%s %s %d: %s', ClMsg('GuildTower'), ClMsg('Level'), 4,  ClMsg('GuildEvent'));
    infoPic:SetImage(EVENT_IMG);
    infoText:SetText(infoStr);
    if currentTowerLevel < 4 then        
        towerCtrlSet4:SetColorTone(DISABLE_COLOR);
    end
    yPos = yPos + towerCtrlSet4:GetHeight();

    -- agit
    local towerCtrlSet5 = benefitBox:CreateOrGetControlSet('guild_benefit', 'BENEFIT_AGIT', 0, yPos);
    towerCtrlSet5 = AUTO_CAST(towerCtrlSet5);
    towerCtrlSet5:SetGravity(ui.CENTER_HORZ, ui.TOP)
    local AGIT_IMG = towerCtrlSet5:GetUserConfig('AGIT_IMG');    
    local infoPic = GET_CHILD(towerCtrlSet5, 'infoPic');
    local infoText = towerCtrlSet5:GetChild('infoText');
    local infoStr = string.format('%s %s %d: %s', ClMsg('GuildTower'), ClMsg('Level'), 5,  ClMsg('MoveToAgit'));
    infoPic:SetImage(AGIT_IMG);
    infoText:SetText(infoStr);
    if currentTowerLevel < 5 then        
        towerCtrlSet5:SetColorTone(DISABLE_COLOR);
    end
    yPos = yPos + towerCtrlSet5:GetHeight();
end

function GUILDINFO_INFO_INIT_ABILITY(infoBox, guildObj)
    local pointText = GET_CHILD_RECURSIVELY(infoBox, 'pointText');
    local currentPoint = GET_GUILD_ABILITY_POINT(guildObj);
    pointText:SetTextByKey('point', currentPoint);

    local yPos = 40;
    local abilityBox = GET_CHILD_RECURSIVELY(infoBox, 'abilityBox');
    local clsList, cnt = GetClassList("Guild_Ability");
    for i = 0, cnt - 1 do
        local abilityCls = GetClassByIndexFromList(clsList, i);
        local ctrlSet = abilityBox:CreateOrGetControlSet('guild_benefit', 'ABILITY_'..abilityCls.ClassName, 0, yPos);
        ctrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP)
        ctrlSet = AUTO_CAST(ctrlSet);

        local DISABLE_COLOR = ctrlSet:GetUserConfig('DISABLE_COLOR');
        local infoPic = GET_CHILD(ctrlSet, 'infoPic');
        local infoText = ctrlSet:GetChild('infoText');
        local abilLevel = guildObj["AbilLevel_" .. abilityCls.ClassName];
        local infoStr = string.format('Lv. %d %s: %s', abilLevel, abilityCls.Name, abilityCls.Desc);
        infoPic:SetImage(abilityCls.Icon);
        infoText:SetText(infoStr);
        
        if abilLevel < 1 then
            ctrlSet:SetColorTone(DISABLE_COLOR);
        end
        yPos = yPos + ctrlSet:GetHeight();
    end
end

function UPDATE_TOWER_DESTROY_TIME(towerTimeText)
	local builtTime = towerTimeText:GetUserValue("DESTROYTIME");
	local endTime = imcTime.GetSysTimeByStr(builtTime);
	endTime = imcTime.AddSec(endTime, GUILD_TOWER_DESTROY_REBUILD_ABLE_MIN * 60);
	local sysTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
	if difSec > 0 then
		local difSecString = GET_TIME_TXT_DHM(difSec);
		towerTimeText:SetTextByKey("remaintime", difSecString);
	else
		local destroyPartyName = towerTimeText:GetUserValue("PARTYNAME");
		local positionText = "{#FF0000}" .. ScpArgMsg("DestroyedByGuild{Name}", "Name", destroyPartyName) .. "{/}";
		towerTimeText:SetTextByKey("time", positionText);
		return 0;
	end
	return 1;
end

function GUILDINFO_INFO_UPDATE_TOWERLEVEL(benefitBox, updateBtn)
    local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
		return;
	end

    local templerCls = GetClass('Job', 'Char1_16');
    if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == false then
        ui.SysMsg(ClMsg('TgtDonHaveTmpler'));
        return;
    end
    control.CustomCommand('UPDATE_GUILD_TOWER_LEVEL', 0);
end

function GUILDINFO_INFO_UPDATE_WAREHOUSE(frame, ctrl)
	party.RequestReloadInventory(PARTY_GUILD);
	DISABLE_BUTTON_DOUBLECLICK("guildinfo", ctrl:GetName(), 0.1);
end

function IS_EXIST_JOB_IN_HISTORY(jobID)
    local mySession = session.GetMySession();
    local jobHistory = mySession.jobHistory;
    local jobHistoryCnt = jobHistory:GetJobHistoryCount();
    for i = 0, jobHistoryCnt - 1 do
		local jobInfo = jobHistory:GetJobHistory(i);
        if jobID == jobInfo.jobID then
            return true;
        end
    end
    return false;
end


function save_guild_notice_call_back(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "save_guild_notice_call_back")
        return
    end

    ui.SysMsg(ClMsg("UpdateSuccess"))
    -- 여기에서 해당 ui에 글자 채워주기
end

function SAVE_GUILD_NOTICE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local noticeEdit = GET_CHILD_RECURSIVELY(frame, 'noticeEdit')
	local noticeText = noticeEdit:GetText();
	local guild = GET_MY_GUILD_INFO();
	local nowNotice = guild.info:GetNotice();
	local badword = IsBadString(noticeText);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
	if nowNotice ~= noticeText then		
        SetGuildNotice('save_guild_notice_call_back', noticeText)
	end
	noticeEdit:ReleaseFocus();
end
