

function JOURNALRANK_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('WIKI_RANK_INFO', 'JOURNALRANK_ON_RECV_MY');
	addon:RegisterOpenOnlyMsg('WIKI_RANK_PAGE', 'ON_WIKI_RANK_PAGE');

	addon:RegisterMsg("WORLDPVP_RANK_PAGE", "ON_JOURNAL_WORLDPVP_RANK_PAGE");
	addon:RegisterMsg("WORLDPVP_RANK_ICON", "ON_JOURNAL_WORLDPVP_RANK_ICON");
	
end

function JOURNALRANK_FIRST_OPEN(frame)
	
	local rank_1 = frame:GetChild("rank_1");
	local rank_2 = frame:GetChild("rank_2");
	rank_2:ShowWindow(0);

end

function OPEN_JOURNALRANK(frame)
	packet.CheckWikiRankTime();	-- 5�ʸ��� ReqWikiCategoryRankPageInfo("Total" -1) ����
	--packet.CheckMgameRankTime();

end

function JOURNALRANK_ON_RECV_MY(frame)
	local ranking = geServerWiki.GetWikiServRank();

	local ctrlSet = GET_CHILD(frame, "rank_1");
	local pageCtrl = GET_CHILD(ctrlSet, 'control');
	local maxPage = ranking.totalCount / WIKI_RANK_PER_PAGE + 1;
	
	if maxPage > 2000 then
		maxPage = 2000
	end

	pageCtrl:SetMaxPage(maxPage);
end

function JOURNALRANK_VIEW_PAGE(frame, page)

	local journalFrame = ui.GetFrame("journal");
	local type = journalFrame:GetUserValue("JOURNAL_RANKVIEW");	
	if type == 'None' then
		type = 'Total';
	end

	packet.ReqWikiCategoryRankPageInfo(type, page);
end

function ON_WIKI_RANK_PAGE(frame, msg, str, num)
	if str == "Total" then
		JOURNAKRANK_SHOW_PAGE(frame, num);
	elseif str == "UpHill" then
		MGAME_SHOW_PAGE(frame, num);
	end
end

function JOURNAKRANK_SHOW_PAGE(frame, page)
	
	local ranking = geServerWiki.GetWikiServRank();

	local ctrlSet = GET_CHILD(frame, "rank_1");
	local pageCtrl = GET_CHILD(ctrlSet, 'control');
	pageCtrl:SetCurPage(page);
	local startRank = page * WIKI_RANK_PER_PAGE;
	local bg_ctrls = GET_CHILD(ctrlSet, "bg_ctrls");
	bg_ctrls:RemoveAllChild();
	bg_ctrls:EnableHitTest(0);
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	for i = 0 , WIKI_RANK_PER_PAGE - 1 do

		local rankIndex = ranking:GetIndexByRank(startRank + i);		
		if rankIndex < 0 then
			break;
		end

		local rankInfo = ranking:GetByIndex(rankIndex);
		if rankInfo == nil and rankInfo.totalScore <= 0 then
			break;
		end

		local key = rankInfo.ranking + 1;
		--local imgName = ui.CaptureModelHeadImage_IconInfo(rankInfo:GetIconInfo());
		local imgName = GET_JOB_ICON(rankInfo:GetIconInfo().job);
		local rankFont;
		if cid == rankInfo:GetStrCID() then
			rankFont = frame:GetUserConfig("RANK_MY_FONT_NAME");
		else
			rankFont = frame:GetUserConfig("RANK_FONT_NAME");
		end

		local rankSet = bg_ctrls:CreateOrGetControlSet('journal_rank_set', "SET_MGAME_" .. rankInfo.ranking, 0, 0);
		local rankStr = string.format("%s%d", rankFont, rankInfo.ranking+1, imgName);
		local txt_score = rankSet:GetChild("txt_score");
		txt_score:SetTextByKey("value", rankInfo.totalScore);
		local txt_rank = rankSet:GetChild("txt_rank");
		txt_rank:SetTextByKey("value", rankInfo.ranking+1);
		local txt_name = rankSet:GetChild("txt_name");
		local nameText =  rankInfo:GetIconInfo():GetGivenName() .. "{nl}" .. rankInfo:GetIconInfo():GetFamilyName();
		txt_name:SetTextByKey("value", nameText);

	end	
	
	GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);	
	frame:Invalidate();
		
end

function MGAME_SHOW_PAGE(frame, page)
	local ranking = geServerUphill.GetMGameRank();

	local ctrlSet = GET_CHILD(frame, "rank_3");
	local pageCtrl = GET_CHILD(ctrlSet, 'control');
	pageCtrl:SetCurPage(page);
	local startRank = page * WIKI_RANK_PER_PAGE;
	local bg_ctrls = GET_CHILD(ctrlSet, "bg_ctrls");
	bg_ctrls:RemoveAllChild();
	bg_ctrls:EnableHitTest(0);
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	for i = 0 , WIKI_RANK_PER_PAGE - 1 do

		local rankIndex = ranking:GetIndexByRank(startRank + i);		
		if rankIndex < 0 then
			break;
		end

		local rankInfo = ranking:GetByIndex(rankIndex);
		if rankInfo == nil and rankInfo.totalScore <= 0 then
			break;
		end

		local key = rankInfo.ranking + 1;
		--local imgName = ui.CaptureModelHeadImage_IconInfo(rankInfo:GetIconInfo());
		local imgName = GET_JOB_ICON(rankInfo:GetIconInfo().job);
		local rankFont;
		if cid == rankInfo:GetStrCID() then
			rankFont = frame:GetUserConfig("RANK_MY_FONT_NAME");
		else
			rankFont = frame:GetUserConfig("RANK_FONT_NAME");
		end

		local rankSet = bg_ctrls:CreateOrGetControlSet('journal_rank_set', "SET_" .. rankInfo.ranking, 0, 0);
		local rankStr = string.format("%s%d", rankFont, rankInfo.ranking+1, imgName);
		local txt_score = rankSet:GetChild("txt_score");
		txt_score:SetTextByKey("value", rankInfo.totalScore);
		local txt_rank = rankSet:GetChild("txt_rank");
		txt_rank:SetTextByKey("value", rankInfo.ranking+1);
		local txt_name = rankSet:GetChild("txt_name");
		local nameText =  rankInfo:GetIconInfo():GetGivenName() .. "{nl}" .. rankInfo:GetIconInfo():GetFamilyName();
		txt_name:SetTextByKey("value", nameText);

	end	
	
	GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);	
	frame:Invalidate();
		
end


function JOURNALRANK_SELECT(frame, page, str, num)
	frame = frame:GetTopParentFrame();
	JOURNALRANK_VIEW_PAGE(frame, num);
end

function JOURNALRANK_PAGE(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local rank_1 = frame:GetChild("rank_1");
	local rank_2 = frame:GetChild("rank_2");
	local rank_3 = frame:GetChild("rank_3");
	
	rank_1:ShowWindow(1);
	rank_2:ShowWindow(0);
	rank_3:ShowWindow(0);

	
end

function JOURNALRANK_PVP(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local rank_1 = frame:GetChild("rank_1");
	local rank_2 = frame:GetChild("rank_2");
	local rank_3 = frame:GetChild("rank_3");

	rank_1:ShowWindow(0);
	rank_2:ShowWindow(1);
	rank_3:ShowWindow(0);
	
	JOURNAL_REQUEST_PVPRANK(frame, 1, 1);

end

function JOURNALRANK_UP_HILL(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local rank_1 = frame:GetChild("rank_1");
	local rank_2 = frame:GetChild("rank_2");
	local rank_3 = frame:GetChild("rank_3");

	rank_1:ShowWindow(0);
	rank_2:ShowWindow(0);
	rank_3:ShowWindow(1);
	
	MGAME_SHOW_PAGE(frame, 0);
end

function GET_JOUNNAL_PVP_TYPE(frame)
	local clsList, cnt  = GetClassList("WorldPVPType");
	local rankCls;
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.StatuePosition ~= "None" then
			rankCls = cls;
			break;
		end
	end

	return rankCls.ClassID;
end

function JOURNAL_REQUEST_PVPRANK(frame, page, findMyRanking)
	local pvpType = GET_JOUNNAL_PVP_TYPE(frame);
	local rank_2 = frame:GetChild("rank_2");
	local input_findname = GET_CHILD(rank_2, "input_findname");
	if findMyRanking == nil then
		findMyRanking = 0;
	end

	worldPVP.RequestPVPRanking(pvpType, 0, -1, page, findMyRanking, input_findname:GetText());

end

function JOURNAL_WORLDPVP_RANK_SELECT(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local rank_2 = frame:GetChild("rank_2");
	local control = GET_CHILD(rank_2, "control", 'ui::CPageController')
	JOURNAL_REQUEST_PVPRANK(frame, control:GetCurPage() + 1);
	ui.DisableForTime(control, 0.5);
end

function UPDATE_PVP_RANK_CTRLSET_JOURNAL(ctrlSet, info)
	UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);
end

function ON_JOURNAL_WORLDPVP_RANK_PAGE(frame)
	local rank_type = session.worldPVP.GetRankProp("Type");
	if rank_type == 210 then
		OPEN_GUILDBATTLE_RANKING_FRAME(0);
		return;
	end

	local rank_2 = frame:GetChild("rank_2");
	local bg_ctrls = GET_CHILD(rank_2, "bg_ctrls");
	bg_ctrls:RemoveAllChild();

	local pvpType = GET_JOUNNAL_PVP_TYPE(frame);

	local type = session.worldPVP.GetRankProp("Type");
	local league = session.worldPVP.GetRankProp("League");
	local page = session.worldPVP.GetRankProp("Page");
	local totalCount = session.worldPVP.GetRankProp("TotalCount");

	local cnt = session.worldPVP.GetRankInfoCount();
	local rankPageFont = frame:GetUserConfig("RANK_PAGE_FONT");

	for i = 0 , cnt - 1 do
		local info = session.worldPVP.GetRankInfoByIndex(i);
		local ctrlSet = bg_ctrls:CreateControlSet("journal_rank_pvp_set", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		UPDATE_PVP_RANK_CTRLSET_JOURNAL(ctrlSet, info);

	end

	GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);

	local totalPage = math.floor((totalCount + WORLDPVP_RANK_PER_PAGE)/ WORLDPVP_RANK_PER_PAGE) ;
	local control = GET_CHILD(rank_2, 'control', 'ui::CPageController')
	control:SetMaxPage(totalPage);
	control:SetCurPage(page - 1);
	
end

function ON_JOURNAL_WORLDPVP_RANK_ICON(frame, msg, cid, argNum, info)

	local bg_ranking = frame:GetChild("bg_ranking");
	local gbox_ctrls = bg_ranking:GetChild("gbox_ctrls");
	local ctrlSet = GET_CHILD_BY_USERVALUE(gbox_ctrls, "CID", cid);
	if ctrlSet ~= nil then
		info = tolua.cast(info, "WORLD_PVP_RANK_INFO_C");
		UPDATE_PVP_RANK_CTRLSET(ctrlSet, info);
	end	
	

end