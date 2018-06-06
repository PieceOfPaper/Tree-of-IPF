function JOURNAL_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('INV_ITEM_ADD', 'JORNAL_UPDATE_INV');
	addon:RegisterOpenOnlyMsg('INV_ITEM_POST_REMOVE', 'JORNAL_UPDATE_INV');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'JORNAL_UPDATE_INV');
	addon:RegisterOpenOnlyMsg('WIKI_LIST_ADD', 'JOURNAL_WIKI_ADD');
	addon:RegisterOpenOnlyMsg('WIKI_PROP_UPDATE', 'JORNAL_WIKI_PROP_UPDATE');
	addon:RegisterOpenOnlyMsg('WIKI_SCORE_UPDATE', 'ON_WIKI_SCORE_UPDATE');
 	addon:RegisterOpenOnlyMsg('WIKI_RANK_INFO', 'JOURNAL_UPDATE_RANK_INFO');
	addon:RegisterOpenOnlyMsg('ADD_COLLECTION', 'JOURNAL_UPDATE_CONTENTS');
	addon:RegisterOpenOnlyMsg('COLLECTION_ITEM_CHANGE', 'JOURNAL_UPDATE_CONTENTS');
	addon:RegisterOpenOnlyMsg('GET_NEW_QUEST', 'JOURNAL_UPDATE_CONTENTS');
	addon:RegisterOpenOnlyMsg('ACHIEVE_POINT', 'JOURNAL_UPDATE_CONTENTS');
	addon:RegisterOpenOnlyMsg('NPC_STATE_UPDATE', 'JOURNAL_UPDATE_CONTENTS');
	addon:RegisterOpenOnlyMsg('LEVEL_UPDATE', 'JOURNAL_UPDATE_MAIN_PAGE');
	addon:RegisterOpenOnlyMsg('MON_RANKINFO_TOOLTIP', 'ON_MON_RANKINFO_TOOLTIP');

	addon:RegisterOpenOnlyMsg('WIKI_PROP_UPDATE_MAP', 'ON_JOURNAL_UPDATE_MAP');
	addon:RegisterOpenOnlyMsg('CHANGE_COUNTRY', 'JOURNAL_UPDATE_MAIN_PAGE');
	addon:RegisterOpenOnlyMsg('CHANGE_COUNTRY', 'JOURNAL_FIRST_OPEN'); 
        -- ??? ???? ?? UI ??????? : ??? ??? ??? ???¿??? ??? ????? ??? -140527 ayase



	local bg = GET_CHILD(frame, "test_skin_01", "ui::CGroupBox");
	if bg ~= nil then
		bg:SetSkinName('bg')
	end

	--local infogauge = GET_CHILD(bg, "infogauge", "ui::CInfoGauge");
	--infogauge:SetMaxValue(400);
	--infogauge:AddInfo('Item', 100, 'FFcc9933');
	--infogauge:AddInfo('Recipe', 50, 'FFff3333');
	--infogauge:AddInfo('Monster', 50, 'ff6666cc');
	--infogauge:AddInfo('Map', 50, 'ff669900');
    addon:RegisterMsg('JOURNAL_UI_OPEN', 'OPEN_DO_JOURNAL');

	frame:SetUserValue("IS_OPEN_BY_NPC","NO")

	for i = 0 , WIKI_COUNT - 1 do
		if i ~= WIKI_CONTENTS and i ~= WIKI_ETC and i ~= WIKI_SETITEM then

			local ctrlName = "CATE_"..GetWikiEnumName(i);
	
			local ctrl = GET_CHILD_RECURSIVELY(frame,ctrlName)
			if ctrl ~= nil then
				local btnControl = ctrl:GetChild("button");
				local newcount = ctrl:GetChild("newcount");
				btnControl:ShowWindow(0)
				newcount:ShowWindow(0)
			end

		end
	end

	packet.ReqWikiRecipeUpdate();
end

function UI_TOGGLE_JOURNAL()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('journal')
end

function ON_WIKI_SCORE_UPDATE(frame, msg, str, realtimeUpdate)
	JOURNAL_UPDATE_CONTENTS(frame);
	JOURNAL_UPDATE_MAIN_PAGE(frame, realtimeUpdate);

	for i = 0 , WIKI_COUNT - 1 do
		local category = GetWikiEnumName(i);
		local group = GET_CHILD(frame, category, 'ui::CGroupBox');
		if group ~= nil then
			JOURNAL_UPDATE_SCORE(frame, group, category);
		end
	end

end

function OPEN_DO_JOURNAL(frame)
	if nil == frame then
		frame = ui.GetFrame("journal");
	end

	frame:SetUserValue("IS_OPEN_BY_NPC","YES")
	OPEN_JOURNAL(frame,"YES")
	RUN_CHECK_LASTUIOPEN_POS(frame)

end

function OPEN_JOURNAL(frame,isopenbynpc)

	if isopenbynpc == "YES" then
		ui.OpenFrame("journal");
	end

	ui.OpenFrame("journalrank");
	packet.ReqUpdateMyWikiRank();

	for i = 0 , WIKI_COUNT - 1 do
		if i ~= WIKI_CONTENTS and i ~= WIKI_ETC and i ~= WIKI_SETITEM then
			local ctrlName = "CATE_"..GetWikiEnumName(i);

			local ctrl = GET_CHILD_RECURSIVELY(frame,ctrlName)
			if ctrl ~= nil then
				local btnControl = ctrl:GetChild("button");
				local newcount = ctrl:GetChild("newcount");
			
				if frame:GetUserValue("IS_OPEN_BY_NPC") == "YES" or isopenbynpc == "YES" then
					btnControl:ShowWindow(1)
					if btnControl:IsEnable() == 1 then
						newcount:ShowWindow(1)
					end
					
				else
					btnControl:ShowWindow(0)
					newcount:ShowWindow(0)
				end
			end

		end
	end
end

function JOURNAL_CLOSE(frame)
	ui.CloseFrame("journalrank");
	frame:SetUserValue("IS_OPEN_BY_NPC","NO")
	UNREGISTERR_LASTUIOPEN_POS(frame)
end

function JOURNAL_UPDATE_CONTENTS(frame)
	local grid = frame:GetChild('article')
	local contentCtrl = grid:GetChild('Contents')
	if contentCtrl == nil then -- 이전에 만들어둔 컨트롤이 없는 경우, 메인부터 차례대로 만들어준다.
		JOURNAL_BUILD_ALL_LIST(frame)
	else
		JOURNAL_BUILD_ALL_LIST(frame, "Contents") -- 있으면 컨텐츠 탭만 바꿔줌
	end
end

function JOURNAL_ON_RELOAD(frame)
	JOURNAL_BUILD_ALL_LIST(frame);
	JOURNAL_HIDE_ARTICLES(frame);
end

function JOURNAL_WIKI_ADD(frame, msg, str, wikiID)

	JOURNAL_UPDATE_ADD(frame, wikiID);
	JOURNAL_UPDATE_MAIN_PAGE(frame);

end

function JORNAL_WIKI_PROP_UPDATE(frame, msg, str, type)

	JOURNAL_UPDATE_MAIN_PAGE(frame);

	local wikiCls = GetClassByType("Wiki", type);
	local category = wikiCls.Category;
	local group = GET_CHILD(frame, category, 'ui::CGroupBox')
	local page = GET_CHILD(group, 'page', "ui::CPage");

	if category == "Map" then
		JOURNAL_BUILD_ALL_LIST(frame, "Map");
	end

	if page ~= nil then
		page:UpdateItem(wikiCls.ClassName);
	end

	JOURNAL_UPDATE_SCORE(frame, group, category);
	JOURNAL_UPDATE_CTRLSET_BY_TYPE(frame, group, type);

end

function JOURNAL_BUILD_ALL_LIST(frame, category)

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	local grid = GET_CHILD(frame, "article", "ui::CGrid");

	if category == nil then
		CREATE_JOURNAL_ARTICLE_MAIN(frame, grid, 'Main', ScpArgMsg('Main'), 'journal_main_icon', 'JOURNAL_OPEN_MAIN_ARTICLE');
		CREATE_JOURNAL_ARTICLE_ITEM(frame, grid, 'Item', ScpArgMsg('Auto_aiTem'), 'journal_item_icon', 'JOURNAL_OPEN_ITEM_ARTICLE');
		CREATE_JOURNAL_ARTICLE_MONSTER(frame, grid, 'Monster', ScpArgMsg('Auto_MonSeuTeo'), 'journal_mon_icon', 'JOURNAL_OPEN_MONSTER_ARTICLE');
		CREATE_JOURNAL_ARTICLE_CRAFT(frame, grid, 'Recipe', ScpArgMsg('Auto_JeJag'), 'journal_craet_icon', 'JOURNAL_OPEN_CRAFT_ARTICLE');
		CREATE_JOURNAL_ARTICLE_MAP(frame, grid, 'Map', ScpArgMsg('Auto_MaepTamHeom'), 'journal_map_icon', 'JOURNAL_OPEN_MAP_ARTICLE');
		CREATE_JOURNAL_ARTICLE_CONTENTS(frame, grid, 'Contents', ScpArgMsg('Auto_KeonTenCheu'), 'journal_con_icon', 'JOURNAL_OPEN_CONTENTS_ARTICLE');
	elseif category == "Map" then
		CREATE_JOURNAL_ARTICLE_MAP(frame, grid, 'Map', ScpArgMsg('Auto_MaepTamHeom'), 'journal_map_icon', 'JOURNAL_OPEN_MAP_ARTICLE');
	elseif category == "Item" then
		CREATE_JOURNAL_ARTICLE_ITEM(frame, grid, 'Item', ScpArgMsg('Auto_aiTem'), 'journal_con_icon', 'JOURNAL_OPEN_ITEM_ARTICLE');
	elseif category == "Monster" then
		CREATE_JOURNAL_ARTICLE_MONSTER(frame, grid, 'Monster', ScpArgMsg('Auto_MonSeuTeo'), 'journal_mon_icon', 'JOURNAL_OPEN_MONSTER_ARTICLE');
	elseif category == "Recipe" then
		CREATE_JOURNAL_ARTICLE_CRAFT(frame, grid, 'Recipe', ScpArgMsg('Auto_JeJag'), 'journal_craet_icon', 'JOURNAL_OPEN_CRAFT_ARTICLE');
	elseif category == "Contents" then
		CREATE_JOURNAL_ARTICLE_CONTENTS(frame, grid, 'Contents', ScpArgMsg('Auto_KeonTenCheu'), 'journal_con_icon', 'JOURNAL_OPEN_CONTENTS_ARTICLE');
	end

end

function JOURNAL_UPDATE_ADD(frame, wikiID)
	local wiki = GetWiki(wikiID);
	local cls = GetWikiObject(wiki);
	local clsCate = cls.Category;

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	local grid = GET_CHILD(frame, "article", "ui::CGrid");

	if clsCate == "Map" then
		CREATE_JOURNAL_ARTICLE_MAP(frame, grid, 'Map', ScpArgMsg('Auto_MaepTamHeom'), 'journal_map_icon', 'JOURNAL_OPEN_MAP_ARTICLE');
		return;
	elseif clsCate == "Recipe" then
		CREATE_JOURNAL_ARTICLE_CRAFT(frame, grid, 'Recipe', ScpArgMsg('Auto_JeJag'), 'journal_craet_icon', 'JOURNAL_OPEN_CRAFT_ARTICLE');
		JOURNAL_OPEN_CRAFT_ARTICLE(frame);
		return;
	end
	local wikiCls = GetClassByType("Wiki", wikiID);
	local category = wikiCls.Category;
	local group = GET_CHILD(frame, category, 'ui::CGroupBox');
	JOURNAL_UPDATE_SCORE(frame, group, category);

	if clsCate == "Item" or clsCate == "Monster" then
		local monsterGroup = GET_CHILD(frame, clsCate, 'ui::CGroupBox')
		local ctrlset = monsterGroup:GetChild("ctrlset");
		if nil ~= ctrlset then
			JOURNAL_DETAIL_LIST_RENEW(ctrlset, clsCate, "GroupName", "All", "ClassType" ,"All");
		end
	else
		JOURNAL_UPDATE_LIST_RENEW(group, wikiID);
	end
end

function SET_JOURNAL_RANK_TYPE(frame, typeName)

	if typeName ~= 'Total' then
		return;
	end

	frame:SetUserValue("JOURNAL_RANKVIEW", typeName);
	local rankFrame = ui.GetFrame("journalrank");
	JOURNALRANK_VIEW_PAGE(rankFrame, -1);
end

function JOURNAL_FIRST_OPEN(frame)
	SET_JOURNAL_RANK_TYPE(frame, 'Total');
	local ranking = geServerWiki.GetWikiServRank();
	JOURNAL_UPDATE_RANK_INFO(frame);
	JOURNAL_BUILD_ALL_LIST(frame);
	JOURNAL_OPEN_MAIN_ARTICLE(frame);
	JOURNAL_UPDATE_MAIN_PAGE(frame);
end

function CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback)

	local journalArticle = grid:CreateOrGetControlSet("journalArticle", key, 10, 10);
	local nameText = GET_CHILD(journalArticle, "name");
	nameText:SetText('{@st66b}'..text..'{/}');

	local rationText = GET_CHILD(journalArticle, "rating");
	rationText:SetText('{@st66b}');

	local icon = GET_CHILD(journalArticle, "icon");
	icon:SetImage(iconImage);
	icon:SetEventScript(ui.LBUTTONUP, callback);

end

function JOURNAL_HIDE_ARTICLES(frame)

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(0);

	local article = GET_CHILD(frame, 'item', "ui::CGroupBox");

	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'monster', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'map', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'contents', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'leveling', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'achieve', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end

	local article = GET_CHILD(frame, 'recipe', "ui::CGroupBox");
	if article ~= nil then
		article:ShowWindow(0)
	end


	local pic = GET_CHILD(frame, "pic", "ui::CPicture");
	if pic ~= nil then
		pic:ShowWindow(0)
	end

end

function JOURNAL_TO_MAIN(frame, btnCtrl, argStr, argNum)

	local f = ui.GetFrame("journal");
	JOURNAL_HIDE_ARTICLES(f);

	SET_JOURNAL_RANK_TYPE(f, 'Total');
end

function CREATE_JOURNAL_ARTICLE_MAIN(frame, grid, key, text, iconImage, callback)
	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);
end

function JOURNAL_OPEN_MAIN_ARTICLE(parent, image, groupName)
	local frame = parent:GetTopParentFrame();
	JOURNAL_HIDE_ARTICLES(frame);
	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
	bg:ShowWindow(1);
	imcSound.PlaySoundEvent('button_click_3');
end

function JOURNAL_OPEN_ARTICLE(frame, groupName)

	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");

	local itemGroupBox = GET_CHILD(frame, groupName, "ui::CGroupBox");
	itemGroupBox:ShowWindow(1)

end

function JORNAL_UPDATE_INV(frame)
	JORNAL_CRAFT_UPDATE_INV(frame);
end

function UPDATE_CATEGORY_CONTROL_SCORE(ctrl, score, destScore, cateType, realtimeUpdate)

	local frame = ctrl:GetTopParentFrame();
	local isopenbyNPC = frame:GetUserValue("IS_OPEN_BY_NPC")

	local gauge = GET_CHILD(ctrl, "gauge", "ui::CGauge");
	local rewardInfo = session.GetRewardInfoByPoint(cateType, score);
	local startScore = 0;
	if rewardInfo.beforeStep ~= nil then
		startScore = rewardInfo.beforeStep.totalScore;
	end

	local curGaugePoint = score - startScore;

	if curGaugePoint < 0 then
		curGaugePoint = 0
	end
	
	gauge:SetPoint(curGaugePoint, rewardInfo.step.totalScore - startScore);
	if destScore > score then
		gauge:SetDrawFillPoint(destScore - startScore);
	end

	local levelCtrl = ctrl:GetChild("lv");
	levelCtrl:SetTextByKey("level",rewardInfo.currentStep + 1)

	local newCountBox = ctrl:GetChild("newcount");
	local btnControl = ctrl:GetChild("button");

	local rewardCount = session.GetAbleRewardCount(cateType, rewardInfo.currentStep);
	if rewardCount > 0 then
		if isopenbyNPC == "YES" then
			newCountBox:ShowWindow(1);
		end
		local text = newCountBox:GetChild("text");
		text:SetTextByKey("value", rewardCount);
		btnControl:SetGrayStyle(0);
		btnControl:SetEnable(1);
		btnControl:SetEventScript(ui.LBUTTONUP, "REQ_GET_WIKI_SCORE_REWARD");
		btnControl:SetTextTooltip(ScpArgMsg('WIKI_SCORE_REWARD_MONEY_TOOLTIP'))

		if realtimeUpdate == 1 then
			local beforeRewardCount = ctrl:GetUserIValue("REWARDCOUNT");
			if rewardCount > beforeRewardCount then
				UI_PLAYFORCE(ctrl:GetChild("button"), "emphasize_2", 0, 0);
				ctrl:SetUserValue("REWARDCOUNT", rewardCount);
			end
		end
	
	else
		newCountBox:ShowWindow(0);
		btnControl:SetGrayStyle(1);
		btnControl:SetEnable(0);
	end

	if isopenbyNPC == "YES" then
		btnControl:ShowWindow(1)
	else
		btnControl:ShowWindow(0)
		newCountBox:ShowWindow(0);
	end
end

function REQ_GET_WIKI_SCORE_REWARD(parent, btn)
	local cateType = parent:GetUserIValue("CATETYPE");
	addon.BroadMsg('NOTICE_Dm_GetItem', ScpArgMsg('WIKI_SCORE_REWARD_MONEY_MSG'), 10);
	packet.ReqGetWikiScoreReward(cateType);
end

function ADD_JOURNAL_SCORE_CTRL_BY_CATEGORY(queue, cateType, realtimeUpdate)
	local enumString = GetWikiEnumName(cateType);
	local langName = GetWikiCategoryLangName(cateType);

	local ctrl = queue:CreateOrGetControlSet("journal_mainscore", "CATE_"..enumString, 10, 10);

	ctrl:GetChild("title"):SetTextByKey("categoryname", ScpArgMsg(langName));
	ctrl:SetUserValue("CATETYPE", cateType);

	local score = session.GetMyWikiScore(cateType);
	UPDATE_CATEGORY_CONTROL_SCORE(ctrl, score, score, cateType, 0);
	
	if realtimeUpdate == 1 then
		local updatedScore = session.GetUpdatedWikiScore(cateType);
		if updatedScore > score then
			ctrl:RunUpdateScript("VIEW_UPDATED_SCORE", 0, 0, 0, 1);
			ctrl:SetUserValue("STARTPOINT", score);
			ctrl:SetUserValue("STARTTIME", imcTime.GetAppTimeMS());
		end
	end
end

function VIEW_UPDATED_SCORE(ctrl)
	local cateType = ctrl:GetUserIValue("CATETYPE");
	local elapsedMS = imcTime.GetAppTimeMS() - ctrl:GetUserIValue("STARTTIME");
	local startScore = ctrl:GetUserIValue("STARTPOINT");
	local updatedScore = session.GetUpdatedWikiScore(cateType);
	local processMSec = (updatedScore - startScore) * 50;
	processMSec = math.min(processMSec, 2000);
	local blendRate = elapsedMS / processMSec;
	local curScore = imc.GetBlend(updatedScore, startScore, blendRate);
	if curScore >= updatedScore then
		curScore = updatedScore;
	end

	session.SetWikiScore(cateType, curScore);
	UPDATE_CATEGORY_CONTROL_SCORE(ctrl, curScore, updatedScore, cateType, 1)
	if curScore >= updatedScore then
		local gauge = GET_CHILD(ctrl, "gauge", "ui::CGauge");
		gauge:PlayOnceUIEffect("I_sys_fullcharge", 5.0);
		gauge:SetDrawFillPoint(0);

		local frame = ui.GetFrame("journal");
		JOURNAL_UPDATE_CONTENTS(frame);
		return 0;
	end
	
	return 1;
end

function ADD_JOURNAL_SCORE_CTRL(queue, name, score)
	local cateType = GetWikiCategoryEnum(name);
	local ctrl = queue:CreateOrGetControlSet("journal_serverrank", name, 10, 10);
	ctrl:GetChild("Title"):SetTextByKey("categoryname", ClMsg(name));
	ctrl:GetChild("Point"):SetTextByKey("value", score);
end

function JOURNAL_UPDATE_MAIN_PAGE(frame, realtimeUpdate)

	local bg = frame:GetChild("bg");
	local myinfobg = bg:GetChild("myinfobg");
	local queue = GET_CHILD(myinfobg, "queue", "ui::CQueue");
	queue:RemoveAllChild();

	local pc = GetMyPCObject();
	local scoreList = {};
	local totalScore = session.GetMyWikiScore(WIKI_TOTAL);

	local myRank = session.GetMyWikiRank();
	local wikiCategoryType = session.GetWikiCategoryType(frame:GetUserValue("JOURNAL_RANKVIEW"));
	local key = session.GetMyWikiCategoryRanking(wikiCategoryType) + 1;
	if key <= 0 then
		key = "Unknown";
	end

	local nowMyRankRTxt = GET_CHILD_RECURSIVELY(frame,'nowMyRank','ui::CRichText')
	nowMyRankRTxt:SetTextByKey('nowrank',key)
	local nowMyScoreRTxt = GET_CHILD_RECURSIVELY(frame,'nowMyScore','ui::CRichText')
	nowMyScoreRTxt:SetTextByKey('nowscore',totalScore)

	--ADD_JOURNAL_SCORE_CTRL(queue, "ServerRanking", key);
	--ADD_JOURNAL_SCORE_CTRL(queue, "JournalScore", totalScore);
	for i = 0 , WIKI_COUNT - 1 do
		if i ~= WIKI_CONTENTS and i ~= WIKI_ETC and i ~= WIKI_SETITEM then
			local langName = GetWikiCategoryLangName(i);
			if langName ~= "" then
				ADD_JOURNAL_SCORE_CTRL_BY_CATEGORY(queue, i, realtimeUpdate);
			end
		end
	end

	local pic = GET_CHILD(myinfobg, "pic", "ui::CPicture");
	local imgName = ui.CaptureModelHeadImage_IconInfo(myRank:GetIconInfo());
	pic:SetImage(imgName);	

end

function JOURNAL_UPDATE_RANK_INFO(frame, msg)

	local bg = frame:GetChild("bg");
	local serverAvg = bg:GetChild("serverAvg");
	local serverTopAvg = bg:GetChild("top10Avg");
	local myRank = session.GetMyWikiRank();
	local wikiCategoryType = session.GetWikiCategoryType(frame:GetUserValue("JOURNAL_RANKVIEW"));

	local ranking = geServerWiki.GetWikiServRank();
	serverAvg:SetTextByKey("score", GetCommaedText(ranking.totalAvgScore));
	serverTopAvg:SetTextByKey("score", GetCommaedText(ranking.topTenAvgScore));
	
	local firstRankIndex = ranking:GetIndexByRank(0);
	local serverTop = GET_CHILD_RECURSIVELY(frame,"serverTop","ui::CRichText")
	local serverName = GET_CHILD_RECURSIVELY(frame, "serverName", "ui::CPicture");
	local serverTopPic = GET_CHILD_RECURSIVELY(frame, "serverTopPic", "ui::CPicture");
	
	if firstRankIndex < 0 then
		serverTop:ShowWindow(0);
		serverName:ShowWindow(0);
		serverTopPic:ShowWindow(0);
	else
		serverTop:ShowWindow(1);
		serverName:ShowWindow(1);
		serverTopPic:ShowWindow(1);

		local firstRank = ranking:GetByIndex(firstRankIndex);
		local imgName = ui.CaptureModelHeadImage_IconInfo(firstRank:GetIconInfo());
		serverTopPic:SetImage(imgName);
		serverName:SetTextByKey("image", imgName);		
		serverName:SetTextByKey("name", firstRank:GetName());
		serverTop:SetTextByKey("score", GetCommaedText(firstRank.totalScore));
		--serverTopPic:SetTooltipType('journalrank');
		--serverTopPic:SetTooltipArg(firstRank:GetStrCID(), 0, "");
		
	end

	local myinfobg = bg:GetChild("myinfobg");
	local pic = GET_CHILD(myinfobg, "pic", "ui::CPicture");
	local imgName = ui.CaptureModelHeadImage_IconInfo(myRank:GetIconInfo());
	pic:SetImage(imgName);
	local name = GET_CHILD_RECURSIVELY(frame, "nowMyName", "ui::CRichText");
	name:SetTextByKey("given", GetMyName());	
	local teamName		= info.GetFamilyName(session.GetMyHandle());
	name:SetTextByKey("family", teamName);

	local job = info.GetJob(session.GetMyHandle());
	local gender = info.GetGender(session.GetMyHandle());
	local jobCls = GetClassByType(job);
	local jName = GET_JOB_NAME(jobCls, gender);
	local nowMyJobName = GET_CHILD_RECURSIVELY(frame, "nowMyJobName", "ui::CRichText");
	nowMyJobName:SetTextByKey("job", jName);	

	local queue = GET_CHILD(myinfobg, "queue", "ui::CQueue");
	local serverRanking = queue:GetChild("ServerRanking");
	if serverRanking ~= nil then
		
		if session.GetMyWikiCategoryRanking(wikiCategoryType) < 0 then
			serverRanking:GetChild("Point"):SetTextByKey("value", "Unknown");
		else
			serverRanking:GetChild("Point"):SetTextByKey("value", session.GetMyWikiCategoryRanking(wikiCategoryType) + 1);
		end
	end

	local myPercentage = 0;
	if ranking.totalCount > 0 then
		myPercentage = math.floor(session.GetMyWikiCategoryRanking(wikiCategoryType) * 100 / ranking.totalCount);
	end

	local infogauge = GET_CHILD(bg, "newgaugepic", "ui::CPicture");
	local myAvg = bg:GetChild("myAvg");
	myAvg:SetGravity(ui.LEFT, ui.TOP);
	local x, y = GET_C_XY(infogauge);
	x = x + infogauge:GetWidth();
	local totalHeight = infogauge:GetHeight() - myAvg:GetHeight();
	y = y + totalHeight * (myPercentage / 100);
	myAvg:SetOffset(x - 56, y);
	myinfobg:UpdateData();
	
end

