

function CREATE_JOURNAL_ARTICLE_MONSTER(frame, grid, key, text, iconImage, callback)

	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);

	local monsterGroup = GET_CHILD(frame, key, 'ui::CGroupBox')
	monsterGroup:SetUserValue("CATEGORY", key);
	monsterGroup:SetUserValue("IDSPACE", "Monster");
	local ctrlset = monsterGroup:GetChild("ctrlset");
	if ctrlset ~= nil then
		SET_MON_CATEGORY_FILTER(ctrlset);
	end
	
	JOURNAL_UPDATE_SCORE(frame, monsterGroup, "Monster");
	JOURNAL_DETAIL_LIST_RENEW(ctrlset, "Monster", "MonRank", "All", "RaceType" ,"All");

end

function SET_MON_CATEGORY_FILTER(ctrlset)

	local gBox = GET_CHILD(ctrlset, "categoryGbox");
	local tree = GET_CHILD(gBox, "tree", 'ui::CTreeControl');
	local list = {};
	list[#list + 1] = "Normal";
	list[#list + 1] = "Boss";
	
	SET_CATEGORY_BY_PROP(tree, "Monster", "MonRank", "RaceType", "MonCategory_", list)	
end

function JOURNAL_PAGE_CHANGE_MONSTER(ctrl, ctrlset)

	local frame = ui.GetFrame('journal')
	local group = GET_CHILD(frame, 'monster', 'ui::CGroupBox');
	local page = GET_CHILD(group, 'page', 'ui::CPage')

	if page ~= nil then
		local control = GET_CHILD(group, 'control', 'ui::CPageController')
		local index = control:GetCurPage();
		page:SetCurPage(index)
		imcSound.PlaySoundEvent('button_click');
	end

end

function GET_MON_ILLUST(monCls)

	if monCls == nil then
		return "unknown_monster";
	end

	local name = monCls.Journal;
	if ui.IsImageExist(name) == 1 then
		return name;
	end
	
	name = "mon_"..name
	if ui.IsImageExist(name) == 1 then
		return name;
	end

	--아이콘은 이제 쓰지 않을꺼라고 해서 일단 주석을 합시다.
	--name = monCls.Icon;
	--if ui.IsImageExist(name) == 1 then
	--	return name;
	--end
	
	return "unknown_monster";
end

function UPDATE_JOURNAL_ITEM_SUB(frame, strarg, itemType, arg2, ud, obj, monName)
	local itemCls = GetClassByType("Item", itemType);
	
	local name = GET_CHILD(frame, "name");
	local clickto = GET_CHILD(frame, "clickto");
	clickto:SetTextByKey("value", ClMsg("ClickToItemPage"));
	        
	local getCount = 0;
	local wiki = session.GetWikiByName(monName);
	if wiki ~= nil then
		local prop = FIND_WIKI_COUNT_PROP(wiki, "DropItem_", MAX_WIKI_MON_DROPITEM, itemType);
		if prop ~= nil then
			getCount = prop.count;
		end
	end

	local nameText = itemCls.Name;
	if getCount > 0 then
		nameText = nameText .. " : " .. ScpArgMsg("GetByCount{Count}", "Count", getCount);		
	end	

	name:SetTextByKey("value", nameText);
	frame:ShowWindow(1);
end

function ON_MON_RANKINFO_TOOLTIP(frame, msg, monName, num)
	
	ui.UpdateWikiMonTooltip(monName);
end

function UPDATE_ARTICLE_Monster(ctrlset)
	local frame = ctrlset:GetTopParentFrame();

	local classID = ctrlset:GetUserIValue("WIKI_TYPE");
	local wiki = session.GetWiki(classID);
	local cls = GetClassByType("Wiki", classID);
	local name = cls.ClassName;
	local monCls = GetClass("Monster", cls.ClassName);
	local monstername = monCls.Name;

	local expProp = wiki:GetIntProp("Exp");
	local jobExpProp = wiki:GetIntProp("JobExp");


	local titleText = GET_CHILD(ctrlset, "name", "ui::CRichText");
	titleText:SetTextByKey("value", monstername);

	local score = GET_MON_WIKI_PTS(monCls);	
	local pointText = GET_CHILD(ctrlset, "point");
	pointText:SetTextByKey("value", score);
	
	local icon = GET_CHILD(ctrlset, "icon", "ui::CPicture");
	icon:SetImage(GET_MON_ILLUST(monCls));
	icon:SetTooltipType("monster");
	icon:SetTooltipArg(monCls.ClassName, expProp.propValue, jobExpProp.propValue);
	
	icon:SetOverSound("button_over")
	local items = GET_CHILD(ctrlset, "drop", "ui::CPage");
	local index  = 1;
	local itemTypeCount = 0;
	while true do
		local dropWikiProp = wiki:GetProp("DropItem_" .. index);
		if dropWikiProp.propValue == 0 then
			break;
		end

		local item = GetClassByType("Item", dropWikiProp.propValue);
		if item ~= nil then
			local pic = items:CreateOrGetControl('picture', item.ClassName, 30, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0)
			tolua.cast(pic, 'ui::CPicture')				
			pic:SetImage(item.Icon);
			pic:SetOverSound("button_over")
			pic:SetTooltipType('wholeitem', "journal_mon_item_sub");
			pic:SetTooltipArg('', item.ClassID, 0);
			pic:SetSubTooltipArg(monCls.ClassName);
		
			pic:SetEnableStretch(1);
			pic:SetEventScript(ui.LBUTTONUP, "JOURNAL_TO_ITEM_PAGE");				
			pic:SetUserValue("ITEMTYPE", item.ClassID)
			itemTypeCount = itemTypeCount + 1;

			index = index + 1;
			if index > MAX_WIKI_ITEM_MON then
				break;
			end
		end
	end
	
	local itemcountText = GET_CHILD(ctrlset, "itemcount");
	itemcountText:SetTextByKey("value", itemTypeCount);

	local topAtkProp = GET_WIKI_MAX_RANKPROP(wiki, "TopAtk_", MAX_WIKI_TOPATTACK);
	local skillicon = GET_CHILD(ctrlset, "skillicon");
	local skillValue = GET_CHILD(ctrlset, "skillValue");
	local skillName = GET_CHILD(ctrlset, "skillName");
	if topAtkProp.propValue > 0 then
		local sklCls = GetClassByType("Skill", topAtkProp.propValue);
		skillName:SetTextByKey("value", sklCls.Name);
		skillValue:SetTextByKey("value", "Damage " .. topAtkProp.count);
		skillicon:SetImage("Icon_" .. sklCls.Icon);

		skillValue:ShowWindow(1);
		skillicon:ShowWindow(1);
	else
		skillValue:ShowWindow(0);
		skillicon:ShowWindow(0);
		skillName:ShowWindow(0);
	end

	local t_date = GET_CHILD(ctrlset, "t_date");
	local dateString = GET_WIKI_ELAPSED_DATE_STRING(wiki);
	t_date:SetTextByKey("value", string.format("[%s]", dateString));

	--[[
	if wiki == nil then
		SET_COLORTONE_RECURSIVE(ctrlset, frame:GetUserConfig("NOT_HAVE_WIKI"));
	else
		SET_COLORTONE_RECURSIVE(ctrlset, "FFFFFFFF");
	end
	]]

end

function JOURNAL_TO_ITEM_PAGE(parent, ctrl)
	local itemType = ctrl:GetUserIValue("ITEMTYPE");

	local frame = parent:GetTopParentFrame();
	local itemGBox = frame:GetChild("Item");
	local ctrlset = itemGBox:GetChild("ctrlset");
	local input = ctrlset:GetChild("input");
	local itemCls = GetClassByType("Item", itemType);
	input:SetText(itemCls.Name);

	local type1 = GET_CHILD(ctrlset, "type1");
	type1:SelectItem(0);
	local type2 = GET_CHILD(ctrlset, "type2");
	type2:SelectItem(0);

	JOURNAL_OPEN_ITEM_ARTICLE(frame);
	JOURNAL_UPDATE_LIST_RENEW(itemGBox);

end

function JOURNAL_OPEN_MONSTER_ARTICLE(frame, ctrlSet)

	local f = ui.GetFrame("journal");
	JOURNAL_HIDE_ARTICLES(f)
	JOURNAL_OPEN_ARTICLE(f, 'monster')
	imcSound.PlaySoundEvent('button_click_3');

end



