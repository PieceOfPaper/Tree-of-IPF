

function ON_JOURNAL_UPDATE_MAP(frame, msg, argStr, argNum)
	JOURNAL_BUILD_ALL_LIST(frame, "Map");
end

function CREATE_JOURNAL_ARTICLE_MAP(frame, grid, key, text, iconImage, callback)

	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);

	local group = GET_CHILD(frame, 'map', 'ui::CGroupBox')
	local page = group:CreateOrGetControl('groupbox', 'page_Map', 0, 0, ui.NONE_HORZ, ui.NONE_VERT, 0, 0, 0, 0)
	local queue = page:CreateOrGetControl('queue', 'page_Queue', 0, 100, ui.NONE_HORZ, ui.TOP, 0, 0, 0, 0)
	queue:RemoveAllChild();
	page:SetSkinName(frame:GetUserConfig(""));
	queue:SetSkinName(frame:GetUserConfig("BG_MAP_QUEUE"));

	page:SetBorder(0, 0, 0, 0)

	local wikiList = GetClassList("Wiki");
	local mapList = GetClassList("Map");
	local list = GetWikiListByCategory("Map");

	local totalScore = 0;
	---- Make Each Map Reveal Rate
	local cateList = {};

	for i = 1 , #list do
		local wiki = list[i];
		local type = GetWikiType(wiki);
		local wikiCls = GetClassByTypeFromList(wikiList, type);
		local cls = GetClassByNameFromList(mapList, wikiCls.ClassName);

		local zone = queue:GetChild(cls.CategoryName);
		if zone == nil then
			zone = queue:CreateOrGetControl('queue', cls.CategoryName, 0, 0, ui.NONE_HORZ, ui.TOP, 5, 0, 5, 0)
			zone:SetUserValue("MAPNAME", cls.ClassName);
			zone:SetSkinName ('');
			cateList[#cateList + 1] = zone;

			zone:CreateOrGetControlSet('mapElementZone', zone:GetName(), 10, 0);
		end

		local element = zone:CreateOrGetControlSet('mapElementRegion', cls.ClassName, 10, 0)

		local name = GET_CHILD(element, 'name', 'ui::CRichText')
		name:SetText('{@st41b}{#f0dcaa}'..cls.Name..' ' .. ClMsg("ExploreRate"));

		rating = GET_CHILD(element, 'rating', 'ui::CRichText')
		local recoverRate = 0;
		if wiki ~= nil then
			recoverRate = GetWikiIntProp(wiki, "RevealRate");
		end

		--마을 같은 경우에는 모두 탐색률 100프로로 보여주자
		if cls.Journal == "TRUE" and cls.UseMapFog == 0 then
			recoverRate = 100
		else
			totalScore = totalScore + recoverRate;
		end
		
		local mapRewardImg
		local pcetc = GetMyEtcObject()
		if cls ~= nil and cls.MapRatingRewardItem1 ~= 'None' and cls.WorldMapPreOpen == 'YES' and cls.UseMapFog ~= 0  then
		    local mapClassName = cls.ClassName
		    local property = 'Reward_'..mapClassName
		    if GetPropType(pcetc, property) ~= nil then
		        if pcetc[property] == 1 then
		            mapRewardImg = '{img M_message_open 30 30}'
		        elseif recoverRate >= 100 then
		            mapRewardImg = '{img M_message_Unopen 30 30}'
		        end
		    end
		end
		local ratingTxt = string.format("{@st41b} %d%%", recoverRate)
		if mapRewardImg ~= nil then
		    ratingTxt = mapRewardImg..ratingTxt
		    rating:Resize(100, 40)
		end
		rating:SetText(ratingTxt);
	end

	--- Calculate Whole Category Map List;
	for i = 1, #cateList do
		local zone = cateList[i];
		local mapName = zone:GetUserValue("MAPNAME");

		local title = zone:CreateOrGetControlSet('mapElementZone', zone:GetName(), 0, 0);
		tolua.cast(title, 'ui::CControlSet')

		local name = GET_CHILD(title, 'name', 'ui::CRichText')
		name:SetText('{@st41}'..zone:GetName()..' {@st41b}' .. ClMsg("ExploreRateOfAll"));

		local cates = geMapTable.GetCategoryMaps(mapName);
		local recoverRate = 0;
		local totalRate = 0;
		for j = 0 , cates:Count() - 1 do
			local cateMapName = cates:Get(j);
			local cateMapWikiCls = GetClass("Wiki", cateMapName);
			if cateMapWikiCls ~= nil then
				totalRate = totalRate + 100;
				local cateMapWiki = GetWikiByName(cateMapName);
				if cateMapWiki ~= nil then
					local intProp = GetWikiIntProp(cateMapWiki, "RevealRate");
					if intProp ~= nil then
						recoverRate = recoverRate + intProp;
					end
				end
			end
		end
		
		local resultRate = recoverRate / totalRate;
		local rating = GET_CHILD(title, 'rating', 'ui::CRichText')
		rating:SetText(string.format("{@st41} %d%%", resultRate));
	end

	JOURNAL_MAP_UPDATE_SCORE(frame, group, totalScore * 0.1);

	tolua.cast(page, 'ui::CGroupBox')
	--page:SetCurLine(0);
	page:Invalidate();

end

function JOURNAL_MAP_UPDATE_SCORE(frame, group, totalScore)

	local ctrlset = group:GetChild("ctrlset");
	local rationText = ctrlset:GetChild("rationText");
	local scoreText = ctrlset:GetChild("scoreText");
	local allCount = GetCategoryWikiListCount("Map");

	if rationText ~= nil then
		rationText:SetTextByKey("rate", math.floor(totalScore / allCount));
		scoreText:SetTextByKey("score2", math.floor(totalScore));
	end
	
end

function JOURNAL_PREV_MAP(ctrl, ctrlset)

	local frame = ui.GetFrame('journal')
	local group = GET_CHILD(frame, 'map', 'ui::CGroupBox');
	local selectName = frame:GetUserConfig('JOURNAL_MAP');
	local page = GET_CHILD(group, 'page_'..selectName, 'ui::CPage')

	if page ~= nil then
		page:PrevPage();
	end

end

function JOURNAL_NEXT_MAP(ctrl, ctrlset)

	local frame = ui.GetFrame('journal')
	local group = GET_CHILD(frame, 'map', 'ui::CGroupBox');
	local selectName = frame:GetUserConfig('JOURNAL_MAP');
	local page = GET_CHILD(group, 'page_'..selectName, 'ui::CPage')

	if page ~= nil then
		page:NextPage();
	end

end

function JOURNAL_OPEN_MAP_ARTICLE(frame, ctrlSet)

	local f = ui.GetFrame("journal");

	JOURNAL_HIDE_ARTICLES(f)
	JOURNAL_OPEN_ARTICLE(f, 'map')

	local group = GET_CHILD(f, 'map', 'ui::CGroupBox');

	local bg = GET_CHILD(f, "bg", "ui::CGroupBox");
	local page = group:CreateOrGetControl('groupbox', 'page_Map', 0, 0, ui.NONE_HORZ, ui.NONE_VERT, 10, 50, 10, 30);
	local scrollBarHeight = bg:GetHeight() - group:GetY();
	tolua.cast(page, 'ui::CGroupBox');
	page:SetScrollBar(scrollBarHeight);

	group:ShowWindow(1);
	imcSound.PlaySoundEvent('button_click_3');
	--SET_JOURNAL_RANK_TYPE(f, 'Map');
end

