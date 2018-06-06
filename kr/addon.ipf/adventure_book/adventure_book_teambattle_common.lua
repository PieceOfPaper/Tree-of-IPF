function ADVENTURE_BOOK_TEAM_BATTLE_COMMON_INIT(adventureBookFrame, teamBattleRankingPage)
    local ret = worldPVP.RequestPVPInfo();    
	if ret == false then -- 이미 데이타가 있음
		ADVENTURE_BOOK_TEAM_BATTLE_COMMON_UPDATE(adventureBookFrame);
	end

    -- ranking
    local rankingBox = teamBattleRankingPage:GetChild('teamBattleRankingBox');
    ADVENTURE_BOOK_TEAM_BATTLE_RANK(teamBattleRankingPage, rankingBox);
	
	local join = GET_CHILD_RECURSIVELY(teamBattleRankingPage, 'teamBattleMatchingBtn');
	join:SetEnable(0);
	
	local cnt = session.worldPVP.GetPlayTypeCount();
	if cnt > 0 then
		local isGuildBattle = 0;
		for i = 1, cnt do
			local type = session.worldPVP.GetPlayTypeByIndex(i);
			if type == 210 then
				isGuildBattle = 1;
				break;
			end
		end

		if isGuildBattle == 0 then
			join:SetEnable(1);
		end
	end
end

function GET_TEAM_BATTLE_CLASS()
    local pvpCls = GetClass("WorldPVPType", 'Three');
	return pvpCls;
end

function ADVENTURE_BOOK_TEAM_BATTLE_COMMON_UPDATE(adventureBookFrame, msg, argStr, argNum)
    local pvpCls = GET_TEAM_BATTLE_CLASS();
	if pvpCls == nil then
		return;
	end
	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(pvpCls);        
	if nil == pvpObj then
		return;
	end
    local winValue = pvpObj:GetPropValue(pvpCls.ClassName..'_WIN');
    local loseValue = pvpObj:GetPropValue(pvpCls.ClassName..'_LOSE');
    local totalValue = winValue + loseValue;
    local battleHistoryValueText = GET_CHILD_RECURSIVELY(adventureBookFrame, 'battleHistoryValueText');    
    battleHistoryValueText:SetTextByKey('total', totalValue);
    battleHistoryValueText:SetTextByKey('win', winValue);
    battleHistoryValueText:SetTextByKey('lose', loseValue);
        
    local mySession = session.GetMySession();
	local cid = mySession:GetCID();
    local pointInfo = session.worldPVP.GetRankInfoByCID(cid);
    local pointValue = pvpObj:GetPropValue(pvpCls.ClassName..'_RP', 1000);
    if pointInfo ~= nil then
        pointValue = pointInfo.point;
    end

    local battlePointValueText = GET_CHILD_RECURSIVELY(adventureBookFrame, 'battlePointValueText');
    battlePointValueText:SetTextByKey('point', pointValue);
end

function ADVENTURE_BOOK_TEAM_BATTLE_RANK(parent, teamBattleRankingBox)
    ADVENTURE_BOOK_RANKING_PAGE_SELECT(parent, teamBattleRankingBox, 'TeamBattle', 1);
end

function ADVENTURE_BOOK_TEAM_BATTLE_RANK_UPDATE(frame, msg, argStr, argNum)
    local rank_type = session.worldPVP.GetRankProp("Type");    
	if rank_type == 210 then
        return;
	end
	local teamBattleRankSet = GET_CHILD_RECURSIVELY(frame, 'teamBattleRankSet');
    local rankingBox = GET_CHILD(teamBattleRankSet, 'rankingBox');
	rankingBox:RemoveAllChild();
    local pvpCls = GET_TEAM_BATTLE_CLASS();
	local pvpType = pvpCls.ClassID;
	local type = session.worldPVP.GetRankProp("Type");
	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");
	local cnt = session.worldPVP.GetRankInfoCount();
	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = rankingBox:CreateControlSet("pvp_rank_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);
        ctrlSet:Resize(rankingBox:GetWidth(), ctrlSet:GetHeight());
	end
	GBOX_AUTO_ALIGN(rankingBox, 0, 0, 0, true, false);

	local totalPage = math.floor((totalCount + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(teamBattleRankSet, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);
end

function ADVENTURE_BOOK_JOIN_WORLDPVP(parent, ctrl)
    if IS_IN_EVENT_MAP() == true then
        ui.SysMsg(ClMSg('ImpossibleInCurrentMap'));
        return;
    end 

	local accObj = GetMyAccountObj();
	if IsBuffApplied(GetMyPCObject(), "TeamBattleLeague_Penalty_Lv1") == "YES" or IsBuffApplied(GetMyPCObject(), "TeamBattleLeague_Penalty_Lv2") == "YES" then
		ui.SysMsg(ClMsg("HasTeamBattleLeaguePenalty"));
		return;
	end
	local cls = GET_TEAM_BATTLE_CLASS();
	if nil == cls then
		ui.SysMsg(ScpArgMsg("DonotOpenPVP"))
		return;
	end	
    local pvpType = cls.ClassID;
	if cls.MatchType == "Guild" then
		local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
		if pcparty == nil then
			ui.SysMsg(ScpArgMsg("PleaseJoinGuild"));
			return;
		end
	end

	local isLeader = AM_I_LEADER(PARTY_GUILD);	
	if cls.MatchType ~= "Guild" or isLeader == 0 then
		JOIN_WORLDPVP_BY_TYPE(parent, pvpType);
		return;
	end
	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(cls);
	if nullptr == pvpObj then
		ui.SysMsg(ScpArgMsg("DonotOpenPVP"))
		return;
	end	
	local myCnt = pvpObj:GetPropValue(cls.ClassName .. "_Cnt", 0);
	local yesScp = string.format("NOTICE_AND_CHECK_PVP_COUNT(%d, %d)", pvpType, myCnt);	
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_PLAYING then
		ui.MsgBox(ScpArgMsg("ExistsPlayingPVP"), yesScp, "None");	
	elseif state == PVP_STATE_NONE then
		local msg = ScpArgMsg("PVPEnter{COUNT}{MAX}",'COUNT',myCnt, 'MAX',cls.MaxPlayCount )
		ui.MsgBox(msg, yesScp, "None");
	elseif state == PVP_STATE_FINDING then
		local msg = ScpArgMsg("AskPVPEnterCancel")
		ui.MsgBox(msg, yesScp, "None");
	end
end

function JOIN_WORLDPVP_BY_TYPE(btn, pvpType)
	local cls = GET_TEAM_BATTLE_CLASS();
	local join = btn;
	local state = session.worldPVP.GetState();
	if state == PVP_STATE_NONE then
		if cls.Party == 0 then
			if session.GetPcTotalJobGrade() < WORLDPVP_MIN_JOB_GRADE and cls.MatchType ~= "Guild" then
				local msg = ScpArgMsg("OnlyAbleOver{Rank}", "Rank", WORLDPVP_MIN_JOB_GRADE);
				ui.MsgBox(msg);
				 return;
			end
			if cls.MatchType == "Guild" then
				local isLeader = AM_I_LEADER(PARTY_GUILD);
				if isLeader == 1 then
					worldPVP.ReqJoinPVP(pvpType, PVP_STATE_FINDING);
					join:SetEnable(0);
				else
					local pvpGuid = frame:GetUserIValue("GUILD_PVP_GUID_" .. pvpType);
					if pvpGuid > 0 then
						worldPVP.ReqJoinGuildPVP(pvpType, pvpGuid)
					else
						ui.SysMsg(ScpArgMsg("DonotPlayGuildBattleYet"))
						return;
					end
				end
			else
				worldPVP.ReqJoinPVP(pvpType, PVP_STATE_FINDING);
				join:SetEnable(0);
			end
		else
			local partyMemberList = session.party.GetPartyMemberList(PARTY_NORMAL);
			local curCount = 0;
			if partyMemberList ~= nil then
				local count = partyMemberList:Count();
				for i = 0 , count - 1 do
					local partyMemberInfo = partyMemberList:Element(i);
					if partyMemberInfo:GetMapID() > 0 then
						curCount = curCount + 1;
					end
				end
			end

			if curCount < cls.PlayerCnt then
				local strBuf = string.format(ClMsg("NotEnoughPartyMember(%d/%d)"), curCount, cls.PlayerCnt);
				ui.SysMsg(strBuf);
				return;
			end
		
			worldPVP.ReqInvitePartyPVP(pvpType);
			ui.MsgBox(ClMsg("InvitedPartyMembers_WaitAccept"));
		end

	elseif state == PVP_STATE_FINDING then
		worldPVP.ReqJoinPVP(pvpType, PVP_STATE_NONE);
		join:SetEnable(0);
	elseif state == PVP_STATE_PLAYING then

		if cls.MatchType == "Guild" then
			local pvpGuid = frame:GetUserIValue("GUILD_PVP_GUID_" .. pvpType);
			if pvpGuid > 0 then
				worldPVP.ReqJoinGuildPVP(pvpType, pvpGuid);
			end
		end
	end

end

function ADVENTURE_BOOK_TEAM_BATTLE_STATE_CHANGE(frame, msg, argStr, argNum)
	local state = session.worldPVP.GetState();
	local stateText = GetPVPStateText(state);
	local viewText = ClMsg( "PVP_State_".. stateText );
	local join = GET_CHILD_RECURSIVELY(frame, 'teamBattleMatchingBtn');
	join:SetTextByKey("text", viewText);

	if state == PVP_STATE_FINDING then
        ADVENTURE_BOOK_TEAM_BATTLE_COMMON_UPDATE(frame);
	elseif state == PVP_STATE_READY then
		local cls = GET_TEAM_BATTLE_CLASS();
		if cls.MatchType ~= "Guild" then
			return;
		end
		local isLeader = AM_I_LEADER(PARTY_GUILD);
		if 1 ~= isLeader then
			return;
		end
		ui.Chat("/sendMasterEnter");
	end
	if 1 == ui.IsFrameVisible("worldpvp_ready") then
		WORLDPVP_READY_STATE_CHANGE(state, pvpType);
	end
end

function ADVENTURE_BOOK_TEAM_BATTLE_HISTORY_UPDATE(frame, msg, argStr, argNum)
end

function ADVENTURE_BOOK_TEAM_BATTLE_SEARCH(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local teamBattleRankSet = GET_CHILD_RECURSIVELY(topFrame, 'teamBattleRankSet');
    local control = GET_CHILD(teamBattleRankSet, 'control');
    local page = control:GetCurPage();
    local adventureBookRankSearchEdit = GET_CHILD_RECURSIVELY(teamBattleRankSet, 'adventureBookRankSearchEdit');
    local teamBattleCls = GET_TEAM_BATTLE_CLASS();
	worldPVP.RequestPVPRanking(teamBattleCls.ClassID, 0, -1, page, 0, adventureBookRankSearchEdit:GetText());
	ui.DisableForTime(control, 0.5);
end

function WORLDPVP_PUBLIC_GAME_LIST(frame, msg, argStr, argNum)
	local isGuildPVP = 0;
	if 0 == frame:IsVisible() then		
		isGuildPVP = 1;
	end
    local worldPVPFrame = ui.GetFrame('worldpvp');
	local bg_observer = GET_CHILD_RECURSIVELY(frame, "bg_observer");
	local gbox = bg_observer:GetChild("gbox");
	gbox:RemoveAllChild();

	local gameIndexList = WORLDPVP_PUBLIC_GAME_LIST_BY_TYPE(isGuildPVP);	
	local maxCnt = 3;
	local cnt = math.min(#gameIndexList, maxCnt);
	for i = 1 , cnt do
		local index = gameIndexList[i];
		if index ~= nil then
			local info = session.worldPVP.GetPublicGameByIndex(index);
			local ctrlSet = gbox:CreateControlSet("pvp_observe_ctrlset", "CTRLSET_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);		
			ctrlSet:SetUserValue("GAME_ID", info.guid);

			local gbox_pc = ctrlSet:GetChild("gbox_pc");
			local teamVec1 = info:CreateTeamInfo(1);
			local teamVec2 = info:CreateTeamInfo(2);
			local gbox_ctrlSet = ctrlSet:GetChild("gbox");
			local gbox_whole = ctrlSet:GetChild("gbox_whole");
			local gbox_1 = ctrlSet:GetChild("gbox_1");
			local gbox_2 = ctrlSet:GetChild("gbox_2");

			local guildName1 = WORLDPVP_PUBLIC_GAME_SET_PCTEAM(frame, gbox_1, teamVec1, 1);

			SET_VS_NAMES(worldPVPFrame, ctrlSet, 1, WORLDPVP_PUBLIC_GAME_SET_PCTEAM(frame, gbox_1, teamVec1, 1));
			SET_VS_NAMES(worldPVPFrame, ctrlSet, 2, WORLDPVP_PUBLIC_GAME_SET_PCTEAM(frame, gbox_2, teamVec2, 2));		

			local heightAddValue = 7;
			local height = math.max(gbox_1:GetHeight(), gbox_2:GetHeight()) + heightAddValue;
			gbox_ctrlSet:Resize(gbox_ctrlSet:GetWidth(), height);

			local btn = ctrlSet:GetChild("btn");
			ctrlSet:Resize(ctrlSet:GetWidth(), height + btn:GetHeight() + heightAddValue +45);
			gbox_whole:Resize(ctrlSet:GetWidth(), height + btn:GetHeight() + heightAddValue +50 );
		end
	end

	GBOX_AUTO_ALIGN(gbox, 10, 3, 10, true, true);
end