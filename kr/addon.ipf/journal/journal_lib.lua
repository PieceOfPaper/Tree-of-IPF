---- journal_lib.lua

function JOURNALTREE_CLICK(parent, ctrl, str, num)
	local tree = AUTO_CAST(ctrl);
	local tnode = tree:GetLastSelectedNode();
	if tnode == nil then
		return;
	end
	
	local selValue = tnode:GetValue();
	local sList = StringSplit(selValue, "#");
	if "" == selValue or #sList <= 0 then
		return;
	end

	local idSpace = sList[1];
	local group = "All";
	local groupValue = "All";
	local cate = "All";
	local cateValue = "All";
	if #sList >= 2 then
		group = sList[2]; -- monrank
	end
	if #sList >= 3 then
		groupValue = sList[3]; -- 일반?보스
	end
	if #sList >= 4 then
		cate = sList[4]; -- category
	end
	if #sList >= 5 then
		cateValue = sList[5]; -- 식물?악마?
	end
	
	local frame = parent:GetParent(); -- gbox
	frame = frame:GetParent(); -- ctrlset?
	frame:SetUserValue("SELECT_CATEGORY", selValue);
	JOURNAL_DETAIL_LIST_RENEW(frame, idSpace, group, groupValue, cate, cateValue)
end

function JOURNAL_DEATIl_OPTIN_CHECK(frame, ctrl)
	local nameUp = GET_CHILD(frame, "nameUp", "ui::CCheckBox");
	local nameDown = GET_CHILD(frame, "nameDown", "ui::CCheckBox");
	local date = GET_CHILD(frame, "date", "ui::CCheckBox");

	if nameUp:GetName() == ctrl:GetName() then
		nameDown:SetCheck(0);
		date:SetCheck(0);
	elseif nameDown:GetName() == ctrl:GetName() then
		nameUp:SetCheck(0);
		date:SetCheck(0);
	elseif date:GetName() == ctrl:GetName() then
		nameUp:SetCheck(0);
		nameDown:SetCheck(0);
	else
		nameUp:SetCheck(0);
		nameDown:SetCheck(0);
		date:SetCheck(0);
	end
end

function JOURNAL_DETAIL_LIST_RENEW(ctrlset, idSpace, group, groupValue, cate, cateValue)
	local gbox = GET_CHILD(ctrlset, "detailGbox");
	local clsList = GetClassList(idSpace);
	
	if nil == clsList then
		return;
	end

	local input = GET_CHILD(ctrlset, "input", "ui::CEditControl");
	local inputText = input:GetText();
	if insertWikiType == nil then
		gbox:RemoveAllChild();
	end

	gbox:SetUserValue("CATEGORY", idSpace);
	local wikiList = GetClassList("Wiki");
	local list = GetWikiListByCategory(idSpace);
	
	ClearSortIESList();
	
	for i = 1 , #list do
		local wiki = list[i];
		local type = GetWikiType(wiki);
		local cls = GetClassByTypeFromList(wikiList, type);
		local monCls = GetClassByNameFromList(clsList, cls.ClassName);
		if true == JOURNAL_CHECK_FILTER(monCls, group, groupValue, cate, cateValue)  then
			local tempname = string.lower(dictionary.ReplaceDicIDInCompStr(monCls.Name));		
			local tempinputtext = string.lower(inputText)
			if tempinputtext == "" or true == ui.FindWithChosung(tempinputtext, tempname) then
				AddSortIESList(monCls, cls, wiki);
			end
		end
	end

	local detailSearch = GET_CHILD(ctrlset, "detailSearch");
	local nameUp = GET_CHILD(detailSearch, "nameUp", "ui::CCheckBox");
	local nameDown = GET_CHILD(detailSearch, "nameDown", "ui::CCheckBox");
	local date = GET_CHILD(detailSearch, "date", "ui::CCheckBox");

	if nameDown:IsChecked() == 1 then
		SortIESList("Name", 1);
	elseif nameUp:IsChecked() == 1 then
		SortIESList("Name");
	elseif date:IsChecked() == 1 then
		SortIESByWIkiDate("Date");
	end

	local sortedMonCls, sortedWikiCls = GetSortIESList();
	local startIndex = 1;
	local advIndex = 1;
	local endIndex = #sortedWikiCls + 1;
	if alignAscValue == "ASC" then
		startIndex = #sortedWikiCls;
		advIndex = -1;
		endIndex = 0;
	end

	if #sortedWikiCls > 0 then
		if insertWikiType == nil then

			while true do
				local cls = sortedWikiCls[startIndex];
				local wikiCls = GetClassByNameFromList(wikiList, cls.ClassName);
				JOURNAL_INSERT_ITEM(gbox, wikiCls, idSpace);

				startIndex = startIndex + advIndex;
				if startIndex == endIndex then
					break;
				end
			end

		else
			local insertIndex = 1;
			while true do
				local cls = sortedWikiCls[startIndex];
				local wikiCls = GetClassByNameFromList(wikiList, cls.ClassName);
				if insertWikiType == cls.ClassID then
					local ctrlset = JOURNAL_INSERT_ITEM(gbox, wikiCls, idSpace);
					gbox:MoveChildBefore(ctrlset, insertIndex);
					break;
				end

				startIndex = startIndex + advIndex;
				insertIndex = insertIndex + 1;
				if startIndex == endIndex then
					break;
				end
			end
		end
	end

	gbox:SetChildShownScript("UPDATE_JOURNAL_CTRLSET");
	GBOX_AUTO_ALIGN(gbox, 10, 0, 10);
		
	local gBox_category = GET_CHILD(ctrlset, "categoryGbox");
	if gBox_category ~= nil then
		local tree = GET_CHILD(gBox_category, "tree", 'ui::CTreeControl');
		if tree ~= nil then
			gbox:Resize(gbox:GetWidth(),gBox_category:GetHeight());
			return;
		end;
	end;
	gbox:Resize(gbox:GetWidth(),gbox:GetOriginalHeight());

end

function SET_ITEM_CATEGORY_BY_PROP(tree)
	tree:Clear();
	local clslist, cnt = GetClassList("ItemCategory");

	for i = -1 , cnt - 1 do
		local iesPropName;
		local cls = nil;
		if -1 == i then
			iesPropName = "All";
		else
			cls = GetClassByIndexFromList(clslist, i);
			iesPropName = cls.ClassName;
		end
		if iesPropName ~= "Recipe" then
			local subCateList = {};
			if nil ~= cls and cls.SubCategory ~= "None" then
				subCateList = StringSplit(cls.SubCategory, "/");
			end
			local title = ClMsg(iesPropName);
			local ctrlSet = tree:CreateControlSet("journal_tree", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
			local part = ctrlSet:GetChild("part");
			part:SetTextByKey("value", title);

			local data = "Item#GroupName#"..iesPropName.."#ClassType";

			if 0 >= #subCateList then
				local foldimg = ctrlSet:GetChild("foldimg");
				foldimg:ShowWindow(0);
				tree:Add(ctrlSet,  data);
			else
				tree:Add(ctrlSet, data);
				local htreeitem = tree:FindByName(ctrlSet:GetName());
				tree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
				for j = 1 , #subCateList do
					local cate = subCateList[j]
			    	if cate ~= 'None' then
						tree:Add(htreeitem, "{ol}"..ClMsg(cate), data.."#"..cate, "{#FFCC33}{ds}");
			    	end
				end
			end
		end
	end
	
	if clMsgHeader == nil then
		GBOX_AUTO_ALIGN(tree, 10, 10, 0)
	else
		GBOX_AUTO_ALIGN(tree, 10, 10, 0, true, false);
	end
end

function SET_CATEGORY_BY_PROP(tree, idSpace, groupName, classType, clMsgHeader, list, marginY)
	
	tree:Clear();
	local typeList = nil;
	local typeCnt = 0;
	if list == nil then
		list = GetPropValueList(idSpace, groupName);	
	else
		typeList = GetPropValueList(idSpace, classType);
		typeCnt = #typeList;
	end
	
	for i = 0 , #list do
		local iesPropName;
		if i == 0 then
			iesPropName = "All";
		else
			iesPropName = list[i];
		end
	
		if iesPropName ~= "Unused" then
			local title;	
			if clMsgHeader == nil then
				title = ClMsg(iesPropName);
			else
				title = ClMsg(clMsgHeader .. iesPropName);
			end
	
			local ctrlSet = tree:CreateControlSet("journal_tree", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
			local part = ctrlSet:GetChild("part");
			part:SetTextByKey("value", title);
			
			local j = 1;
			if clMsgHeader == nil then
				typeList = geItemTable.CreateClassTypeList(iesPropName);
				typeCnt = typeList:Count();
				j = 0;
			end

			local data = idSpace .."#"..groupName.."#"..iesPropName.."#"..classType;
			if typeList ~= nil and 0 < typeCnt and i > 0 then
				tree:Add(ctrlSet, data);
				local htreeitem = tree:FindByName(ctrlSet:GetName());
				tree:SetFoldingScript(htreeitem, "KEYCONFIG_UPDATE_FOLDING");
				for j = 1 , typeCnt do
					local propName = "None";
					if "Item" == idSpace then
						if j < typeCnt then
							propName = typeList:Get(j-1);
						end
					else
						propName = typeList[j];
					end

					if "Monster" == idSpace then
						if ("Item" == propName) or ("Cloth" == propName) then
							propName = 'None';
						end;	
					end;

					if propName ~= 'None' then
						tree:Add(htreeitem, "{ol}"..ClMsg(propName), data.."#"..propName, "{#FFCC33}{ds}");
					end
				end
			else
				local foldimg = ctrlSet:GetChild("foldimg");
				foldimg:ShowWindow(0);
				tree:Add(ctrlSet, data);
			end

			if clMsgHeader == nil then
				typeList = nil;
				typeCnt = 0;
			end
		end
	end
	tree:SetFitToChild(true,marginY);

	if clMsgHeader == nil then
		GBOX_AUTO_ALIGN(tree, 10, 10, 0)
	else
		GBOX_AUTO_ALIGN(tree, 10, 10, 0, true, false);
	end

end

function SELECT_CATEGORY_BY_PROP(parent, ctrl)

	local configName = ctrl:GetUserValue("CONFIG_NAME");
	config.SetConfig(configName, ctrl:GetSelItemKey());
	local gbox = parent:GetParent();
	gbox = gbox:GetParent();
	JOURNAL_UPDATE_LIST_RENEW(gbox);
		
end

function JOURNAL_FIND_BY_NAME(frame, ctrl)
	local gbox = frame:GetParent()
	idSpace = gbox:GetName();
	local group ="None";
	local cate ="None";
	if "Item" == idSpace then
		group = "GroupName";
		cate = "ClassType";
	else
		group = "MonRank";
		cate = "RaceType";

	end
	JOURNAL_DETAIL_LIST_RENEW(frame, idSpace, group, "All", cate, "All")
end

function SELECT_CATEGORY_SORT(parent, ctrl)
	local configName = ctrl:GetUserValue("CONFIG_NAME");
	local sortConfigName = ctrl:GetUserValue("SORT_CONFIG_NAME");
	local selConfigValue = ctrl:GetSelItemKey();
	local curConfigValue = config.GetConfig(configName);
	local beforeConfigValue = curConfigValue;
	local curSortValue = config.GetConfig(sortConfigName);
	
	if selConfigValue == curConfigValue then
		if curSortValue == "DESC" then
			config.SetConfig(sortConfigName, "ASC");
			curSortValue = "ASC";
		else
			config.SetConfig(sortConfigName, "DESC");
			curSortValue = "DESC";
		end
	else
		config.SetConfig(configName, selConfigValue);
		curConfigValue  = selConfigValue;
	end
	
	local msgHeader = ctrl:GetUserValue("MSG_HEADER");
	local title = ClMsg(msgHeader .. curConfigValue);
	if curSortValue == "DESC" then
		title = title .. " {img channel_mark_full 20 20}";
	else
		title = title .. " {img channel_mark_lim 20 20}";
	end

	local beforeTitle = ClMsg(msgHeader .. beforeConfigValue);
	ctrl:SetItemTextByKey(beforeConfigValue, beforeTitle);
	ctrl:SetItemTextByKey(curConfigValue , title);
	
	local gbox = parent:GetParent();
	gbox = gbox:GetParent();
	JOURNAL_UPDATE_LIST_RENEW(gbox);

end

function JOURNAL_CHECK_FILTER(cls, filterName1, filterValue1, filterName2, filterValue2)
	if filterValue1 ~= "All" then
		local val = TryGetProp(cls, filterName1);
		if val ~= filterValue1 then
			return false;
		end
	else
		local val = TryGetProp(cls, filterName1);
		if val == 'Material' and filterName1=='MonRank' then
			return false;
		end
	end


	if filterValue2 ~= "All" then
		local val = TryGetProp(cls, filterName2);
		if val ~= filterValue2 then
			return false;
		end
	end

	return true;
end


function APPLY_FUNC_WIKI_CATEGORY(category, func, ...)
	local list = GetWikiListByCategory(category);
	for i = 1 , #list do
		local wiki = list[i];
		func(wiki, ...);
	end
end

function JOURNAL_UPDATE_SCORE(frame, monsterGroup, category)
	
	local wikiClsList = GetClassList("Wiki");
	local myList = GetWikiListByCategory(category);
	local myCount = 0;
	if myList ~= nil then
		myCount = #myList;
	end

	local cnt = GetCategoryWikiListCount(category);
	if cnt == 0 then
		return;
	end
	
	local rate = myCount / cnt;

	local pc = GetMyPCObject();
	-- 갱신이 안된다는 버그처럼 제보됨...우선 UI표기는 그냥 갱신점수로 하자.
	-- 기획이 계속 바뀌다보니 뭐가버그고 아닌지 분간도 안가고... 우선 아래처럼 해놓자.
	local score = session.GetUpdatedWikiScore(GetWikiCategoryEnum(category));
	if score < session.GetMyWikiScore(GetWikiCategoryEnum(category)) then
		score = session.GetMyWikiScore(GetWikiCategoryEnum(category))
	end

	local ctrlSet = monsterGroup:GetChild("ctrlset");
	if ctrlSet ~= nil then
		local title_score = ctrlSet:GetChild("title_score");
		if title_score ~= nil then
			local txt = string.format("%s %.2f%%  %s %d", ClMsg("GetRatio"), rate * 100, ClMsg("GetScore"), score);
			title_score:SetTextByKey("value", txt);
		end
	else
		local rationText = monsterGroup:GetChild("rationText");
		local scoreText = monsterGroup:GetChild("scoreText");
		if rationText ~= nil then
			rationText:SetTextByKey("rate", string.format("%d", rate * 100));
			scoreText:SetTextByKey("score", score);
		end
	end	
end

function JOURNAL_UPDATE_LIST_RENEW(groupBox, insertWikiType)

	local category = groupBox:GetUserValue("CATEGORY");
	local idSpace = groupBox:GetUserValue("IDSPACE");

	local ctrlset = groupBox:GetChild("ctrlset");
	local gbox = GET_CHILD(ctrlset, "gbox");
	local clsList = GetClassList(idSpace);
	local type1 = GET_CHILD(ctrlset, "type1");
	local type2 = GET_CHILD(ctrlset, "type2");
	local filterName1 = type1:GetUserValue("PROPNAME");
	local filterValue1 = type1:GetSelItemKey();
	local filterName2 = type2:GetUserValue("PROPNAME");	
	local filterValue2 = type2:GetSelItemKey();
	local align = GET_CHILD(ctrlset, "align");
	local alignKey = align:GetUserValue("CONFIG_NAME");
	local alignAscKey = align:GetUserValue("SORT_CONFIG_NAME");
	local alignValue = config.GetConfig(alignKey);
	local alignAscValue = config.GetConfig(alignAscKey);

	local input = GET_CHILD(ctrlset, "input");
	local inputText = input:GetText();

	if insertWikiType == nil then
		gbox:RemoveAllChild();
	end

	gbox:SetUserValue("CATEGORY", idSpace);
	local wikiList = GetClassList("Wiki");
	local list = GetWikiListByCategory(category);
	
	ClearSortIESList();
	for i = 1 , #list do
		local wiki = list[i];
		local type = GetWikiType(wiki);
		local cls = GetClassByTypeFromList(wikiList, type);
		local monCls = GetClassByNameFromList(clsList, cls.ClassName);
		if true == JOURNAL_CHECK_FILTER(monCls, filterName1, filterValue1, filterName2, filterValue2) then
			
			local tempname = string.lower(dictionary.ReplaceDicIDInCompStr(monCls.Name));		
			local tempinputtext = string.lower(inputText)

			if tempinputtext == "" or true == ui.FindWithChosung(tempinputtext, tempname) then
				AddSortIESList(monCls, cls, wiki);
			end
		end
	end

	if alignValue == "Date" then
		SortIESByWIkiDate(alignValue);
	else
		SortIESList(alignValue);
	end
		
	
	local sortedMonCls, sortedWikiCls = GetSortIESList();
	local startIndex = 1;
	local advIndex = 1;
	local endIndex = #sortedWikiCls + 1;
	if alignAscValue == "ASC" then
		startIndex = #sortedWikiCls;
		advIndex = -1;
		endIndex = 0;
	end

	if #sortedWikiCls > 0 then
		if insertWikiType == nil then

			while true do
				local cls = sortedWikiCls[startIndex];
				local wikiCls = GetClassByNameFromList(wikiList, cls.ClassName);
				JOURNAL_INSERT_ITEM(gbox, wikiCls, category);

				startIndex = startIndex + advIndex;
				if startIndex == endIndex then
					break;
				end
			end

		else
			local insertIndex = 1;
			while true do
				local cls = sortedWikiCls[startIndex];
				local wikiCls = GetClassByNameFromList(wikiList, cls.ClassName);
				if insertWikiType == cls.ClassID then
					local ctrlset = JOURNAL_INSERT_ITEM(gbox, wikiCls, category);
					gbox:MoveChildBefore(ctrlset, insertIndex);
					break;
				end

				startIndex = startIndex + advIndex;
				insertIndex = insertIndex + 1;
				if startIndex == endIndex then
					break;
				end
			end
		end
	end

	

	gbox:SetChildShownScript("UPDATE_JOURNAL_CTRLSET");
	GBOX_AUTO_ALIGN(gbox, 10, 0, 10);

	local gBox_category = GET_CHILD(ctrlset, "categoryGbox");
	if gBox_category ~= nil then
		local tree = GET_CHILD(gBox_category, "tree", 'ui::CTreeControl');
		if tree ~= nil then
			gbox:Resize(gbox:GetWidth(),gBox_category:GetHeight());
			return;
		end;
	end;
	gbox:Resize(gbox:GetWidth(),gbox:GetOriginalHeight());
end

function JOURNAL_INSERT_ITEM(gbox, cls, category)
	if gbox == nil then
		DumpCallStack();
	end

	local app = gbox:CreateOrGetControlSet("journal" .. category, cls.ClassName, 10, 10);
	app:SetUserValue("WIKI_TYPE", cls.ClassID);
	app:SetUserValue("CATEGORY", category);

	return app;
end


function UPDATE_JOURNAL_CTRLSET(parent, ctrl)
	if ctrl:GetUserValue("PAGE_SET") == 1 then
		return;
	end

	ctrl:SetUserValue("PRAGE_SET", 1);
	local category = parent:GetParent():GetUserValue("CATEGORY");
	local func = _G["UPDATE_ARTICLE_" .. category];
	if func ~= nil then
		func(ctrl);
	end

end

function JOURNAL_UPDATE_CTRLSET_BY_TYPE(frame, group, wikiType)
	local wikiCls = GetClassByType("Wiki", wikiType);

	local ctrlset = group:GetChild("ctrlset");
	if ctrlset ~= nil then
		local gbox = GET_CHILD(ctrlset, "gbox");
		if gbox ~= nil then
			local category = group:GetUserValue("CATEGORY");
			local ctrl = gbox:GetChild(wikiCls.ClassName);
			local func = _G["UPDATE_ARTICLE_" .. category];
			if ctrl ~= nil and func ~= nil then
				func(ctrl);
			end
		end
	end
end

function GET_WIKI_ELAPSED_DATE_STRING(wiki)
	local wikiTime = GetWikiGetTime(wiki);
	local curTime = geTime.GetServerFileTime();
	local difSec = imcTime.GetIntDifSecByTime(curTime, wikiTime);
	if difSec <= 3600 then
		return ClMsg("ShortTimeAgo");
	end

	local difHour = math.floor(difSec / 3600);
	if difHour <= 24 then
		return ScpArgMsg("{Hour}", "Hour", difHour);
	end

	local difDay = math.floor(difSec / (3600 * 24));
	if difDay <= 7 then
		return ScpArgMsg("{Day}", "Day", difDay);
	end

	local difMonth = math.floor(difSec / (3600 * 24 * 30));
	if difMonth <= 11 then
		return ScpArgMsg("{Month}", "Month", difMonth);
	end

	local difYear = math.floor(difSec / (3600 * 24 * 30 * 12));
	return ScpArgMsg("{Year}", "Year", difYear);

end
