


function SET_ITEM_CATEGORY_FILTER(ctrlset)

	local gBox = GET_CHILD(ctrlset, "categoryGbox");
	local tree = GET_CHILD(gBox, "tree", 'ui::CTreeControl');
	
	SET_ITEM_CATEGORY_BY_PROP(tree);

end

function CREATE_JOURNAL_ARTICLE_ITEM(frame, grid, key, text, iconImage, callback)

	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);

	local monsterGroup = GET_CHILD(frame, key, 'ui::CGroupBox')
	monsterGroup:SetUserValue("CATEGORY", key);
	monsterGroup:SetUserValue("IDSPACE", "Item");
	local ctrlset = monsterGroup:GetChild("ctrlset");
	if ctrlset ~= nil then
		SET_ITEM_CATEGORY_FILTER(ctrlset);
	end
	grid:SetOverSound("button_over")	
	JOURNAL_UPDATE_SCORE(frame, monsterGroup, "Item");
	JOURNAL_DETAIL_LIST_RENEW(ctrlset, "Item", "GroupName", "All", "ClassType" ,"All");

end

function UPDATE_ARTICLE_Item(ctrlset)

	local classID = ctrlset:GetUserIValue("WIKI_TYPE");
	local wiki = GetWiki(classID);
	local wikiCls = GetClassByType("Wiki", classID);
	local cls = GetClass("Item", wikiCls.ClassName);
	local score = GET_ITEM_WIKI_PTS(cls, wiki);

	local titleText = GET_CHILD(ctrlset, "t_name", "ui::CRichText");
	titleText:SetTextByKey("value", cls.Name);

	local GRADE_FONT_SIZE = ctrlset:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기
	SET_GRADE_TOOLTIP(ctrlset,cls,GRADE_FONT_SIZE)

	local infoGbox = GET_CHILD(ctrlset, "infoGbox");	
	infoGbox:SetOffset(infoGbox:GetOffsetX(), titleText:GetY() + titleText:GetHeight());
	local icon = GET_CHILD(ctrlset, "icon", "ui::CPicture");
	icon:SetImage(cls.Icon);
	icon:SetEnableStretch(1)

	SET_ITEM_TOOLTIP_TYPE(icon, cls.ClassID, cls);
	icon:SetTooltipArg('', cls.ClassID, 0);
	icon:SetOverSound('button_over')

	local monsters = GET_CHILD(infoGbox, "drop", "ui::CPage");
	if wiki ~= nil then
		local sortList = {};
		GET_WIKI_SORT_LIST(wiki, "Mon_", MAX_WIKI_ITEM_MON, sortList);
		for i = 1 , #sortList do
			local prop = sortList[i];
			local monCls = GetClassByType("Monster", prop["Value"]);
			if monCls ~= nil then
				local pic = monsters:CreateOrGetControl('picture', monCls.ClassName, 30, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0)
				tolua.cast(pic, 'ui::CPicture')
				pic:SetImage(GET_MON_ILLUST(monCls));
				pic:SetEnableStretch(1)
				local tooltipText = ScpArgMsg('From{Auto_1}_Get_{Auto_2}_Count', "Auto_1", monCls.Name, "Auto_2", prop["Count"]);
								
				pic:SetTextTooltip(tooltipText);
			end
		end
	end

	local totalCount = GetWikiIntProp(wiki, "Total");
	local t_totalcount = GET_CHILD(infoGbox, "t_totalcount");
	t_totalcount:SetTextByKey("value", totalCount);

	local pts = GET_ITEM_WIKI_PTS(cls, wiki);
	local t_point = GET_CHILD(infoGbox, "t_point");
	t_point:SetTextByKey("value", math.floor(pts));
	
	local maxPts = GET_ITEM_MAX_WIKI_PTS(cls, wiki);
	local t_scoreratio = GET_CHILD(infoGbox, "t_scoreratio");
	if maxPts > 0 then
		local ratio = math.floor(pts * 100 / maxPts);
		t_scoreratio:SetTextByKey("value", ratio);
		t_scoreratio:ShowWindow(1);
	else
		t_scoreratio:ShowWindow(0);
	end
	

	local t_level = GET_CHILD(infoGbox, "t_level");
	if cls.ItemType == "Equip" then
		local reinforceValue = GetWikiIntProp(wiki, "MaxReinforce");
		if reinforceValue > 0 then
			local reinText = ClMsg("Reinforce") .. " : +" .. reinforceValue;
			t_level:SetTextByKey("value", reinText);
		else
			t_level:SetTextByKey("value", "");
		end
	elseif cls.GroupName == "Gem" then
		local maxLevel = GetWikiIntProp(wiki, "MaxLevel");
		if maxLevel > 0 then
			local reinText = ClMsg("Level") .. " : +" .. maxLevel;
			t_level:SetTextByKey("value", reinText);
		else
			t_level:SetTextByKey("value", "");
		end
	else
		t_level:SetTextByKey("value", "");
	end
	
	local t_date = GET_CHILD(ctrlset, "t_date");
	local dateString = GET_WIKI_ELAPSED_DATE_STRING(wiki);
	t_date:SetTextByKey("value", string.format("[%s]", dateString)); 



	--[[
	if wiki == nil then
		local frame = ctrlset:GetTopParentFrame();
		SET_COLORTONE_RECURSIVE(ctrlset, frame:GetUserConfig("NOT_HAVE_WIKI"));
	else
		SET_COLORTONE_RECURSIVE(ctrlset, "FFFFFFFF");
	end
	]]

	ctrlset:Resize(ctrlset:GetWidth(), infoGbox:GetHeight() + infoGbox:GetY() + 8);
end

function JOURNAL_OPEN_ITEM_ARTICLE(frame)

	local f = ui.GetFrame("journal");
	JOURNAL_HIDE_ARTICLES(f)
	JOURNAL_OPEN_ARTICLE(f, 'item')
	imcSound.PlaySoundEvent('button_click_3');
end

