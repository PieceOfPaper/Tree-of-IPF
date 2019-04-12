

function GUILDBATTLE_RANKING_ON_INIT(addon, frame)

	addon:RegisterMsg("FIRST_GUILD_RANK_INFO", "UPDATE_FIRST_RANKING_GUILD");

end

function UPDATE_FIRST_RANKING_GUILD(frame)

	local firstRankGuildInfo = session.worldPVP.GetFirstRankGuildInfo();

	local first_rank = frame:GetChild("first_rank");
	local first_server = frame:GetChild("first_server");
	local first_name = frame:GetChild("first_name");
	local first_winlose = frame:GetChild("first_winlose");
	local first_point = frame:GetChild("first_point");

	if firstRankGuildInfo:GetCID() == "0" then
		first_rank:ShowWindow(0);
		first_server:SetTextByKey("value", "");
		first_name:SetTextByKey("value", "");
		first_winlose:SetTextByKey("value", "");
		first_point:SetTextByKey("value", "");
	else

		first_rank:ShowWindow(1);
		local serverName = GetServerNameByGroupID(firstRankGuildInfo.groupID);
		first_server:SetTextByKey("value", "[" .. serverName .. "]");
		first_name:SetTextByKey("value", firstRankGuildInfo:GetIconInfo():GetFamilyName());
		first_winlose:SetTextByKey("value", ScpArgMsg("Win{Win}Lose{Lose}", "Win", firstRankGuildInfo.win, "Lose", firstRankGuildInfo.lose));
		first_point:SetTextByKey("value", ScpArgMsg("{Point}Point", "Point", firstRankGuildInfo.point));

	end
	
end

function GUILDBATTLE_RANKING_TAB_CHANGE(frame)

	GUILDBATTLE_RANKING_REQUEST_RANK(frame, 1, 0);

end

function OPEN_GUILDBATTLE_RANKING(frame)

	local type = session.worldPVP.GetRankProp("Type");
	worldPVP.RequestGuildBattlePrevSeasonTop(type);
	UPDATE_FIRST_RANKING_GUILD(frame);
	UPDATE_GUILD_REWARD_TEXTS(frame);

end

function GET_GUILD_BATTLE_REWARD_BY_CLS(cls)

	return cls.TP .. " " .. ScpArgMsg("TPChangeTicket") .. " "  .. cls.TPCount .. ScpArgMsg("CountOfThings");

end

function UPDATE_GUILD_REWARD_TEXTS(frame)

	local first_reward = frame:GetChild("first_reward");
	local txt_rewardlist = frame:GetChild("txt_rewardlist");
	local gbox_guild_rewards = frame:GetChild("gbox_guild_rewards");

	local clsList, cnt = GetClassList("GuildBattleReward");
	local firstCls = GetClassByIndexFromList(clsList, 0);
	local firsttxt = "GuildReward{nl}";
	firsttxt = firsttxt .. ScpArgMsg("{Rank}Rank", "Rank", "1") .. " : " .. GET_GUILD_BATTLE_REWARD_BY_CLS(firstCls);
	firsttxt = firsttxt .. "{nl}" .. ScpArgMsg("FirstRankServerReward") .. "{nl}"
	firsttxt = firsttxt .. ScpArgMsg("ForTheNextRankingRefreshFreeTPPlus{Value}", "Value", GUILD_BATTLE_FIRSTSERVER_FREETP);		
	first_reward:SetTextByKey("value", firsttxt);

	gbox_guild_rewards:RemoveAllChild();
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local ctrlSet = gbox_guild_rewards:CreateControlSet("text_guild_battle_ranker_reward", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local txt_rank = ctrlSet:GetChild("txt_rank");
		txt_rank:SetTextByKey("value", ScpArgMsg("{Rank}Rank", "Rank", i + 1));
		local text = ctrlSet:GetChild("text");
		text:SetTextByKey("value", GET_GUILD_BATTLE_REWARD_BY_CLS(cls));
	end

	GBOX_AUTO_ALIGN(gbox_guild_rewards, 0, 0, 0, true, false);


end

function GUILDBATTLE_RANKING_REQUEST_RANK(frame, page, findMyRanking)

	frame = frame:GetTopParentFrame();
	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	local input_findname = rankingpage:GetChild("input_findname");

	local pvpType = frame:GetUserIValue("PVP_TYPE");
	local seasonOffset = 0;
	local tab = GET_CHILD(frame, "tab");
	local tabIndex = tab:GetSelectItemIndex();
	if tabIndex == 1 then
		seasonOffset = -1;
	end

	worldPVP.RequestPVPRanking(pvpType, seasonOffset, -1, page, findMyRanking, input_findname:GetText());

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
			txt_myrank:SetTexxtByKey("value", rank);
		end
	end
	
end

function GUILDBATTLE_RANKING_UPDATE(frame)

	frame:RunUpdateScript("GUILDBATTLE_RANK_REMAINTIME_UPDATE", 10);
	GUILDBATTLE_RANK_REMAINTIME_UPDATE(frame);

	local type = session.worldPVP.GetRankProp("Type");
	frame:SetUserValue("PVP_TYPE", type);
	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");

	local rankingpage = frame:GetChild("rankingpage");
	local gbox_ctrls = rankingpage:GetChild("gbox_ctrls");
	gbox_ctrls:RemoveAllChild();

	local cnt = session.worldPVP.GetRankInfoCount();
	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = gbox_ctrls:CreateControlSet("guildbattle_rank_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		UPDATE_GUILDBATTLE_RANKING_CONTROL(ctrlSet, info);

	end

	GBOX_AUTO_ALIGN(gbox_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor((totalCount + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(rankingpage, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);
	control:SetUserValue("PAGE", page);

	UPDATE_GUILDBATTLE_RANK_MYRANK(frame);

end

function UPDATE_GUILDBATTLE_RANKING_CONTROL(ctrlSet, info)

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
	
end

