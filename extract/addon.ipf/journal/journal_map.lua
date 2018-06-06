

function CREATE_JOURNAL_ARTICLE_MAP(frame, grid, key, text, iconImage, callback)

	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);

	local group = GET_CHILD(frame, 'map', 'ui::CGroupBox')
	local page = group:CreateOrGetControl('groupbox', 'page_Map', 0, 0, ui.NONE_HORZ, ui.NONE_VERT, 10, 50, 10, 30)
	local queue = page:CreateOrGetControl('queue', 'page_Queue', 0, 100, ui.NONE_HORZ, ui.TOP, 15, 20, 20, 0)
	queue:RemoveAllChild();
	page:SetSkinName(frame:GetUserConfig(""));
	queue:SetSkinName(frame:GetUserConfig("BG_MAP_QUEUE"));

	page:SetBorder(0, 0, 0, 0)

	local wikiList = GetClassList("Wiki");
	local mapList = GetClassList("Map");
	local list = session.GetWikiListByCategory("Map");

	local totalScore = 0;
	---- Make Each Map Reveal Rate
	local cateList = {};

	for i = 0 , list:Count() - 1 do
		local type = list:Element(i):GetType();	
		local wikiCls = GetClassByTypeFromList(wikiList, type);
		local wiki = session.GetWikiByName(wikiCls.ClassName);
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
			recoverRate = wiki:GetIntProp("RevealRate").propValue;
		end

		--마을 같은 경우에는 모두 탐색률 100프로로 보여주자
		if cls.Journal == "TRUE" and cls.UseMapFog == 0 then
			recoverRate = 100
		end
		rating:SetText(string.format("{@st41b} %d%%", recoverRate));
		totalScore = totalScore + recoverRate * 0.1;
	end

	--- Calculate Whole Category Map List;
	for i = 1, #cateList do
		local zone = cateList[i];
		local mapName = zone:GetUserValue("MAPNAME");

		local title = zone:CreateOrGetControlSet('mapElementZone', zone:GetName(), 10, 0);
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
				local cateMapWiki = session.GetWikiByName(cateMapName);
				if cateMapWiki ~= nil then
					local intProp = cateMapWiki:GetIntProp("RevealRate");
					if intProp ~= nil then
						recoverRate = recoverRate + intProp.propValue;
					end
				end
			end
		end
		
		local resultRate = recoverRate / totalRate;
		local rating = GET_CHILD(title, 'rating', 'ui::CRichText')
		rating:SetText(string.format("{@st41} %d%%", resultRate));
	end

	JOURNAL_MAP_UPDATE_SCORE(frame, group, totalScore);

	tolua.cast(page, 'ui::CGroupBox')
	--page:SetCurLine(0);
	page:Invalidate();

end

function JOURNAL_MAP_UPDATE_SCORE(frame, group, totalScore)

	local ctrlset = group:GetChild("ctrlset");
	local rationText = ctrlset:GetChild("rationText");
	local scoreText = ctrlset:GetChild("scoreText");
	local list, allCount = GetCategoryWikiList("Map");

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

	local group = GET_CHILD(f, 'map', 'ui::CGroupBox')
	group:ShowWindow(1)
	imcSound.PlaySoundEvent('button_click_3');
	SET_JOURNAL_RANK_TYPE(f, 'Map');
end

