

function GUILDBATTLE_RANKING_ON_INIT(addon, frame)
	
end

function ON_UPDATE_PREV_GUILD_RANK_INFO(frame)
	UPDATE_PREV_RANKING_GUILD(frame);
	UPDATE_GET_REWARD_BUTTON(frame);
end

function ON_UPDATE_ALL_SEASON_TOP_RANK_INFO(frame)
	UPDATE_ALL_SEASON_TOP_RANKING_GUILD(frame);
end

function UPDATE_ALL_SEASON_TOP_RANKING_GUILD(frame)
	
	local page = session.worldPVP.GetRankProp("AS_Page");
	local totalCount = session.worldPVP.GetRankProp("AS_TotalCount");

	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	gbox_ctrls:RemoveAllChild();

	local cnt = session.worldPVP.GetAllSeasonTopRankInfoCount();

	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetAllSeasonTopRankInfoByIndex(i);
		local ctrlSet = gbox_ctrls:CreateControlSet("guildbattle_rank_ctrl", "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 0, 0, 0, 0);

		UPDATE_GUILDBATTLE_RANKING_CONTROL(ctrlSet, info, 0);

	end

	GBOX_AUTO_ALIGN(gbox_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor(((totalCount - 1) + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE);
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);

end

function UPDATE_PREV_RANKING_GUILD(frame)
	
	local cnt = session.worldPVP.GetPrevRankInfoCount();

	local first_info = session.worldPVP.GetPrevRankInfoByIndex(0);

	local first_rank = frame:GetChild("first_rank");
	local first_server = frame:GetChild("first_server");
	local first_name = frame:GetChild("first_name");
	local first_winlose = frame:GetChild("first_winlose");
	local first_point = frame:GetChild("first_point");
	local first_guild_award = frame:GetChild("first_guild_award");

	frame = frame:GetTopParentFrame();
	local prevRank = frame:GetChild("prev_rank");
	prevRank:RemoveAllChild();

	if cnt < 1 then
		first_rank:ShowWindow(0);
		first_server:SetTextByKey("value", "");
		first_name:SetTextByKey("value", "");
		first_winlose:SetTextByKey("value", "");
		first_point:SetTextByKey("value", "");
		first_guild_award:SetTextByKey("value", "");
	else
		if first_info:GetCID() ~= "0" then
			first_rank:ShowWindow(1);
			local serverName = GetServerNameByGroupID(first_info.groupID);
			first_server:SetTextByKey("value", "[" .. serverName .. "]");
			first_name:SetTextByKey("value", first_info:GetIconInfo():GetFamilyName());
			first_winlose:SetTextByKey("value", ScpArgMsg("Win{Win}Lose{Lose}", "Win", first_info.win, "Lose", first_info.lose));
			first_point:SetTextByKey("value", ScpArgMsg("{Point}Point", "Point", first_info.point));

			first_guild_award:SetTextByKey("value", "");

			local rewardClass = GetClassByType("GuildBattleReward", 1);
			if rewardClass ~= nil then
				local reward = TryGetProp(rewardClass, "TPCount");
			
				if reward ~= nil then
					first_guild_award:SetTextByKey("value", reward.."TP");
				end
			end
		end	
		for i = 1, cnt - 1 do
			local info = session.worldPVP.GetPrevRankInfoByIndex(i);
			local ctrlSet = prevRank:CreateControlSet("guildbattle_prev_rank_ctrl", "CTRLSET_PREV_" .. i - 1,  ui.LEFT, ui.TOP, 0, 0, 0, 0);

			UPDATE_PREV_RANKING_CTRL(ctrlSet, info);
		end
	end
	
	GBOX_AUTO_ALIGN(prevRank, 0, 0, 0, true, false);
	end

function UPDATE_PREV_RANKING_CTRL(ctrlSet, info)
	
	local txt_servername = ctrlSet:GetChild("txt_servername");
	local txt_rank = ctrlSet:GetChild("txt_rank");
	local txt_guildname = ctrlSet:GetChild("txt_guildname");
	local txt_win = ctrlSet:GetChild("txt_win");
	local txt_point = ctrlSet:GetChild("txt_point");
	
	local serverName = GetServerNameByGroupID(info.groupID);
	txt_servername:SetTextByKey("value", serverName);
	txt_rank:SetTextByKey("value", ScpArgMsg("Rank{Value}", "Value", info.ranking + 1));
	txt_guildname:SetTextByKey("value", info:GetIconInfo():GetFamilyName());
	txt_point:SetTextByKey("value", info.point);

end

function UPDATE_GET_REWARD_BUTTON(frame)
	
	local btn = frame:GetChild("btn_get_reward");
	btn:ShowWindow(0);
	local prevSeason = session.worldPVP.GetCurrentSeason() - 1;
	local prevSeasonMyRank = session.worldPVP.GetPrevSeasonMyGuildRank();

	if prevSeasonMyRank > 0 then
		local isLeader = AM_I_LEADER(PARTY_GUILD);
		if isLeader == 1 then
			local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
			if pcparty ~= nil then
				local partyObj = GetIES(pcparty:GetObject());
				local lastPVPRewardSeason = partyObj.LastPVPRewardSeason;
				
				if lastPVPRewardSeason ~= prevSeason then
					btn:ShowWindow(1);				
				end
			end	
			
		end
	end

end

function REQ_GET_GUILD_BATTLE_REWARD(frame, ctrl)

	local type = session.worldPVP.GetRankProp("Type");
	worldPVP.RequestGetWorldPVPReward(type);

	DISABLE_BUTTON_DOUBLECLICK("guildbattle_ranking",ctrl:GetName())

end

function GUILDBATTLE_RANKING_TAB_CHANGE(frame)
	local topFrame = frame:GetTopParentFrame();
	local tab = GET_CHILD_RECURSIVELY(topFrame, "tab", "ui::CTabControl");
	local nTabIdx = tab:GetSelectItemIndex();

	if nTabIdx == 0 then
	GUILDBATTLE_RANKING_REQUEST_RANK(frame, 1, 0);
	elseif nTabIdx == 1 then
		GUILDBATTLE_RANKING_REQUEST_ALL_SEASON_TOP_RANKER(frame, 1);
	end

end

function GUILDBATTLE_RANKING_REQUEST_ALL_SEASON_TOP_RANKER(frame, page)

	frame = frame:GetTopParentFrame();
	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	local input_findname = rankingpage:GetChild("input_findname");
	gbox_ctrls:RemoveAllChild();

	local pvpType = 200 --frame:GetUserIValue("PVP_TYPE");

	worldPVP.RequestAllSeasonTopPVPRanking(pvpType, page, input_findname:GetText());

end

function OPEN_GUILDBATTLE_RANKING_FRAME(openPage)
		
end

function OPEN_GUILDBATTLE_RANKING(frame)

	local type = session.worldPVP.GetRankProp("Type");
	worldPVP.RequestGuildBattlePrevSeasonRanking(type);
	--UPDATE_PREV_RANKING_GUILD(frame);
	UPDATE_GET_REWARD_BUTTON(frame);
	UPDATE_GUILDBATTLE_RANK_MYRANK(frame);
end

function GET_GUILD_BATTLE_REWARD_BY_CLS(cls)

	return cls.TP .. " " .. ScpArgMsg("TPChangeTicket") .. " "  .. cls.TPCount .. ScpArgMsg("CountOfThings");

end


function GUILDBATTLE_RANKING_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local rankpage = frame:GetChild("rankingpage");
	local control = GET_CHILD(rankpage, "control", 'ui::CPageController')
	
	local tab = GET_CHILD_RECURSIVELY(frame, "tab", "ui::CTabControl");
	local nTabIdx = tab:GetSelectItemIndex();

	if nTabIdx == 0 then
		GUILDBATTLE_RANKING_REQUEST_RANK(frame, control:GetCurPage() + 1, 0);
	elseif nTabIdx == 1 then
		GUILDBATTLE_RANKING_REQUEST_ALL_SEASON_TOP_RANKER(frame, control:GetCurPage() + 1);
	end

	ui.DisableForTime(control, 0.5);
end

function GUILDBATTLE_RANKING_SELECT_NEXT(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local rankpage = frame:GetChild("rankingpage");
	local control = GET_CHILD(rankpage, "control", 'ui::CPageController')
	local page = control:GetUserIValue("PAGE");

	if page >= control:GetMaxPage() then
		control:SetCurPage(control:GetMaxPage() - 1);
		return;
	end
	
	local tab = GET_CHILD_RECURSIVELY(frame, "tab", "ui::CTabControl");
	local nTabIdx = tab:GetSelectItemIndex();

	if nTabIdx == 0 then
		GUILDBATTLE_RANKING_REQUEST_RANK(frame, control:GetCurPage() + 1, 0);
	elseif nTabIdx == 1 then
		GUILDBATTLE_RANKING_REQUEST_ALL_SEASON_TOP_RANKER(frame, control:GetCurPage() + 1);
	end

	ui.DisableForTime(control, 0.5);
end

function GUILDBATTLE_RANKING_SELECT_PREV(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local rankpage = frame:GetChild("rankingpage");
	local control = GET_CHILD(rankpage, "control", 'ui::CPageController')
	local page = control:GetUserIValue("PAGE");

	if page < 2 then
		control:SetCurPage(0);
		return;
	end
	
	local tab = GET_CHILD_RECURSIVELY(frame, "tab", "ui::CTabControl");
	local nTabIdx = tab:GetSelectItemIndex();

	if nTabIdx == 0 then
		GUILDBATTLE_RANKING_REQUEST_RANK(frame, control:GetCurPage() + 1, 0);
	elseif nTabIdx == 1 then
		GUILDBATTLE_RANKING_REQUEST_ALL_SEASON_TOP_RANKER(frame, control:GetCurPage() + 1);
	end

	ui.DisableForTime(control, 0.5);
end

function GUILDBATTLE_RANKING_REQUEST_RANK(frame, page, findMyRanking)

	frame = frame:GetTopParentFrame();
	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	local input_findname = rankingpage:GetChild("input_findname");
	gbox_ctrls:RemoveAllChild();

	local pvpType = 200 --frame:GetUserIValue("PVP_TYPE");
	worldPVP.RequestPVPRanking(pvpType, 0, -1, page, findMyRanking, input_findname:GetText());

end

function GUILDBATTLE_RANK_REMAINTIME_UPDATE(frame)

	local remainSec = session.worldPVP.GetRemainSecondToNextSeason();

	local timeText = GET_TIME_TXT_DHM(remainSec);
	local msgString = ScpArgMsg("{Time}WeeklyRankingRefresh", "Time", timeText);
	
	local txt_nextseason = frame:GetChild("txt_nextseason");
	txt_nextseason:SetTextByKey("value", msgString);
	
	return 1;
end

function UPDATE_GUILDBATTLE_RANK_MYRANK(frame)
		
	local pvpType = frame:GetUserIValue("PVP_TYPE");
	local cls = GetClassByType("WorldPVPType", pvpType);
	local pvpObj = nil;
	if cls ~= nil then
		pvpObj = GET_PVP_OBJECT_FOR_TYPE(cls);
	end

	local txt_title_myrank = frame:GetChild("txt_title_myrank");
	local txt_myrank = frame:GetChild("txt_myrank");

	txt_title_myrank:ShowWindow(0);
	txt_myrank:ShowWindow(0);

	if pvpObj ~= nil then
		local rank = pvpObj:GetRankByType(pvpType);
		if rank > 0 then
			txt_title_myrank:ShowWindow(1);
			txt_myrank:ShowWindow(1);
			txt_myrank:SetTextByKey("value", rank);
		end
	end	
end

function GUILDBATTLE_RANKING_UPDATE(frame)
	frame:RunUpdateScript("GUILDBATTLE_RANK_REMAINTIME_UPDATE", 10);
	GUILDBATTLE_RANK_REMAINTIME_UPDATE(frame);

	local type = session.worldPVP.GetRankProp("Type");
	frame:SetUserValue("PVP_TYPE", 200);
	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");

	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	gbox_ctrls:RemoveAllChild();

	local cnt = session.worldPVP.GetRankInfoCount();
	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = gbox_ctrls:CreateControlSet("guildbattle_rank_ctrl", "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 0, 0, 0, 0);

		UPDATE_GUILDBATTLE_RANKING_CONTROL(ctrlSet, info, 1);

	end

	GBOX_AUTO_ALIGN(gbox_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor(((totalCount - 1) + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);
	control:SetUserValue("PAGE", page);

	UPDATE_GUILDBATTLE_RANK_MYRANK(frame);

end

function UPDATE_GUILDBATTLE_RANKING_CONTROL(ctrlSet, info, showUpDown)

	local txt_servername = ctrlSet:GetChild("txt_servername");
	local txt_rank = ctrlSet:GetChild("txt_rank");
	local txt_guildname = ctrlSet:GetChild("txt_guildname");
	local txt_win = ctrlSet:GetChild("txt_win");
	local txt_point = ctrlSet:GetChild("txt_point");
	
	local serverName = GetServerNameByGroupID(info.groupID);
	txt_servername:SetTextByKey("value", serverName);
	txt_rank:SetTextByKey("value", ScpArgMsg("Rank{Value}", "Value", info.ranking + 1));
	txt_guildname:SetTextByKey("value", info:GetIconInfo():GetFamilyName());
	txt_win:SetTextByKey("value", ScpArgMsg("Win{Win}Lose{Lose}", "Win", info.win, "Lose", info.lose));
	txt_point:SetTextByKey("value", info.point);
	
	if showUpDown == 1 then
		local txt_rank_updown = ctrlSet:GetChild("txt_rank_updown");
		local imgUpDown = GET_CHILD(ctrlSet, "pic_updown");

		local nUpDown = info.lastRank - info.ranking;
		local newRanker = false;
		if info.lastRank < 0 then
			newRanker = true;
		end
				
		if newRanker == true then
			txt_rank_updown:SetTextByKey("value", "New");
			imgUpDown:SetImage("green_up_arrow");
		else
			if nUpDown == 0 then
				txt_rank_updown:SetTextByKey("value", "");
			elseif nUpDown < 0 then
				txt_rank_updown:SetTextByKey("value", nUpDown);
			else
				local str = "+" .. nUpDown;
				txt_rank_updown:SetTextByKey("value", str);
			end					
			
			if nUpDown < 0 then
				imgUpDown:SetImage("red_down_arrow");
				txt_rank_updown:SetColorTone("FFED1C24");
			elseif nUpDown > 0 then
				imgUpDown:SetImage("green_up_arrow");
				txt_rank_updown:SetColorTone("FF14672D");
			else
				imgUpDown:SetImage("blue_none_arrow");
				txt_rank_updown:SetColorTone("FF000000");
			end
		end
	else
		local txt_rank_updown = ctrlSet:GetChild("txt_rank_updown");
		local imgUpDown = GET_CHILD(ctrlSet, "pic_updown");
		txt_rank_updown:SetVisible(0);
		imgUpDown:SetVisible(0);
	end
end