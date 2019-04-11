WIKI_RANKER_COLOR = "";
WIKI_RANKER_SIZE = 18;
WIKI_PROP_TITLE_COL = "";

function WIKI_ON_INIT(addon, frame)	
--	addon:RegisterMsg('WIKI_PROP_UPDATE', 'ON_WIKI_MSG');
--	addon:RegisterOpenOnlyMsg('S_OBJ_UPDATE', 'ON_WIKI_MSG');
--	addon:RegisterOpenOnlyMsg('WIKI_RANK_UPDATE', 'ON_WIKI_MSG');
--	addon:RegisterOpenOnlyMsg('WIKI_RANK_PROP_UPDATE', 'ON_WIKI_MSG');
--	WIKI_TAB_CHANGE(frame);
end

function ON_WIKI_MSG(frame, msg, argStr, argNum)
	if msg == "WIKI_PROP_UPDATE" or msg == "WIKI_RANK_UPDATE" or msg == "S_OBJ_UPDATE" then
		ON_WIKI_PROP_UPDATE(frame, msg, argStr, argNum);
	elseif msg == "WIKI_RANK_PROP_UPDATE" then
		ON_WIKI_RANK_PROP_UPDATE(frame);
	elseif msg == "HELP_MSG_ADD" then
		ON_WIKI_HELP_MSG_ADD(frame, argNum);
	end
end

function ON_WIKI_RANK_PROP_UPDATE(frame)

	ui.UpdateVisibleToolTips();

end

function UPDATE_CUR_WIKI(frame, msg, argStr, argNum)

	if frame:IsVisible() == 0 then
		return;
	end

	UPDATE_WIKI_FRAME(frame, argNum);
end

function WIKI_TAB_CHANGE(frame)	
	WIKI_ALLTROPHY_VIEW(frame);

	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end
end

function WIKI_OPEN(frame)
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(0)

end

function WIKI_CLOSE(frame)
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 0 and ui.IsVisibleFramePIPType('wiki') == false then
		questInfoSetFrame:ShowWindow(1);
	end

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(1)
	
	WIKI_LOST_FOCUS(frame);
end

function WIKI(wikiID, prev)
	local wikiframe = ui.GetFrame("wiki");
	UPDATE_WIKI_FRAME(wikiframe, wikiID, prev);
end

function UPDATE_WIKI_FRAME(frame, wikiID, prev)	
	WIKI_ALLTROPHY_VIEW(frame);
end

function ON_WIKI_PROP_UPDATE(frame, msg, str, wikiType)

	UPDATE_WIKI_FRAME(frame, wikiType, 1);
end

function SHOW_WIKI_TAB(frame, tab)
	local i_show = 0;
	local m_show = 0;

	if tab == 0 then
		i_show = 1;
	end

	if tab == 1 or tab == 2 or tab == 3 or tab == 4 then
		m_show = 1;
	end	
	WIKI_ALLTROPHY_VIEW(frame);
end

function WIKI_COMMON(frame, cls)

	local type = cls.ClassID;
	local index = session.GetWikiIndex(type);

	local tabidx = GET_WIKI_CATEGORY(type);
	local tab = frame:GetChild('itembox');
	tolua.cast(tab, "ui::CTabControl");
	
	tab:ChangeTab(tabidx);	
	WIKI_TAB_UPDATE(frame);

	if index == -1 and cls.AutoGet == 1 then
		session.RequestGetWiki(type);
		return;
	end

	local curRank = session.GetPairWikiRank(type);
	if curRank == nil then
		packet.ReqWikiRank(type, 1);
	end

end

function WIKI_TAB_UPDATE(frame)

	local tabObj = frame:GetChild('itembox');
	tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = tabObj:GetSelectItemIndex();

	SHOW_WIKI_TAB(frame, curtabIndex);


end

function WIKI_VIEW_TYPE(frame, ctrl, str, num)

	frame:SetValue2(num);
	UPDATE_WIKI_FRAME(frame, frame:GetValue());

end

function WIKI_NPC_(frame, cls, sameWiki)

	WIKI_MONSTER_(frame, cls, sameWiki);

end

function WIKI_MONSTER_(frame, cls, sameWiki)

	local wikiType = cls.ClassID;
	local name = frame:GetChild("m_name");
	name:SetText(cls.Name);

	local image = frame:GetChild('m_image');
	tolua.cast(image, "ui::CPicture");

	local desc = GET_CHILD(frame, "m_desc", "ui::CScrollText");

	local index = session.GetWikiIndex(wikiType);

	if index == -1 and cls.AutoGet == 0 then
		desc:SetText(ScpArgMsg("MONSTER_NOT_WRITTEN_IN_JOURNAL"));
		image:SetImage("unknown_monster");
		return;
	end

	local illust = cls.Illust;
	if illust == 'None' then
		image:SetImage("blank");
	else
		image:SetImage(illust);
	end

	local viewType = frame:GetValue2();

	if viewType == 0 then
		desc:SetText(cls.Desc);
		return;
	end


	local wiki = GetWiki(wikiType);
	if wiki == nil then
		desc:SetText(cls.Desc);
		return;
	end

	local txt = "";

	local pairRank = session.GetPairWikiRank(wikiType);
	local intRank = session.GetIntWikiRank(wikiType);

	if viewType == 1 then

		txt = txt .. GET_WIKI_INTPROP_TXT(frame, wiki, "Lv", ClientMsg(20018));
		txt = txt .. "{nl}" ..GET_WIKI_INTPROP_TXT(frame, wiki, "MHP", ClientMsg(20019));

		txt = txt .. "{nl}" .. GET_WIKI_INTPROP_TXT(frame, wiki, "KillCount", ClientMsg(20011), intRank);

		txt = txt .. "{nl}" .. GET_WIKI_SORT_PROP_TXT(frame, wiki, ClientMsg(20012).. " : ", "Map_", MAX_WIKI_MON_MAPID, "GET_WIKI_MON_MAP_TXT");

	elseif viewType == 2 then


		txt = txt .. "{nl}" .. GET_WIKI_SORT_PROP_TXT(frame, wiki, ClientMsg(20016), "TopAtk_", MAX_WIKI_TOPATTACK, "GET_WIKI_TOPATK_TXT", pairRank);

		txt = txt .. "{nl}" .. GET_WIKI_SORT_PROP_TXT(frame, wiki, ClientMsg(20017), "MonSkl_", MAX_WIKI_MON_ATK, "GET_WIKI_MONSKL_TXT");

	elseif viewType == 3 then
		txt = txt .. "{nl}" .. GET_WIKI_SORT_PROP_TXT(frame, wiki, ClientMsg(20010), "DropItem_", MAX_WIKI_MON_DROPITEM, "GET_WIKI_MON_DROP_TXT");

	end

	if sameWiki == 1 then
		desc:SetText_MaintainScroll(txt);
	else
		desc:SetText(txt);
	end

end


function WIKI_AREA(frame, cls)

	local name = frame:GetChild("m_name");
	name:SetText(cls.Name);

	local image = frame:GetChild('m_image');
	tolua.cast(image, "ui::CPicture");

	local desc = frame:GetChild("m_desc");

	local index = session.GetWikiIndex(cls.ClassID);

	if index == -1 and cls.AutoGet == 0 then
		desc:SetText(ScpArgMsg("MONSTER_NOT_WRITTEN_IN_JOURNAL"));
		image:SetImage("unknown_monster");
		return;
	end

	local illust = cls.Illust;
	if illust == 'None' then
		image:SetImage("blank");
	else
		image:SetImage(illust);
	end

	desc:SetText(cls.Desc);

end

function WIKI_ALLTROPHY_VIEW(frame)
	local tabCtrl = frame:GetChild('itembox');
	tolua.cast(tabCtrl, "ui::CTabControl");
	local selectName = tabCtrl:GetSelectItemName();
	local curtabIndex = tabCtrl:GetSelectItemIndex();

	HIDE_CHILD_BYNAME(frame, '_picasa');
	HIDE_CHILD_BYNAME(frame, 'statistics');
	HIDE_CHILD_BYNAME(frame, 'help');
		
	if selectName == 'Itembox1' then     -- 통계
		WIKI_STATISTICS_VIEW(frame);
	elseif selectName == 'Itembox2' then -- 아이템
		--WIKI_ITEM_TROPHY_VIEW(frame);
		STATISTICS_ITEM_VIEW_DETAIL(frame)
	elseif selectName == 'Itembox3' then -- 제작
		WIKI_RECIPE_TROPHY_VIEW(frame);
	elseif selectName == 'Itembox4' then -- 지역
		STATISTICS_MAP_VIEW(frame);
		--WIKI_MAP_TROPHY_VIEW(frame);
	elseif selectName == 'Itembox5' then -- 업적
		WIKI_ACHIEVE_TROPHY_VIEW(frame);
	elseif selectName == 'Itembox6' then -- 사냥
		STATISTICS_MONSTER_VIEW(frame)		
	elseif selectName == 'Itembox7' then -- 도움말		
		WIKI_HELP_VIEW(frame);
	end
	WIKI_ETC_CHILD_VIEW(frame, 0);

	frame:Invalidate();
end

function WIKI_ETC_CHILD_VIEW(frame, isVisible)

end

function WIKI_TROPHY_SLOT_LBTNUP(frame, slot, argStr, argNum)
	local wikiIndex = session.GetWikiIndex(argNum);

	if wikiIndex == -1 then
		return;
	end

	local tabObj = frame:GetChild('itembox');
	tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex = tabObj:GetSelectItemIndex();

	local wikiPageFrame = ui.GetFrame('wikipage');
	wikiPageFrame:ShowWindow(1);
	UPDATE_WIKIPAGE_FRAME(wikiPageFrame, argNum, 0, curtabIndex);
end


function GET_WIKI_SORT_LIST(wiki, nameHead, maxCnt, sortList)

	local tmpList = {};
	local idx = 1;
		for i = 1 , maxCnt do
		local propName = nameHead .. i;
		local propValue, count = GetWikiProp(wiki, propName);
		if propValue > 0 then
			tmpList[idx] = {};
			tmpList[idx]["Value"] = propValue;
			tmpList[idx]["Count"] = count;
			idx = idx + 1;
		end
	end

	if idx == 1 then
		return;
	end

	for i = 1, idx - 1 do
		sortList[i] = GET_MAXPROP_FROM_LIST(tmpList);
	end

end


--[[
struct WIKI_RANK_INFO_INT
{
	const char *	charName;
	int				count;
};

]]
function GET_FIRST_RANK_INFO(rankList, propType)
	if propType == 0 then
		return nil;
	end

	local sortList = rankList:FindAndGet(propType);
	if sortList == nil or sortList:Count() == 0 then
		return nil;
	end

	return sortList:PtrAt(0);
end

function GET_MAXPROP_FROM_LIST(tmpList)

	local maxIdx = -1;
	local maxProp = nil;
	local cnt = #tmpList;
	for i = 1 , cnt do
		local prop = tmpList[i];
		if prop ~= nil and (maxProp == nil or prop["Count"] > maxProp["Count"]) then
			maxIdx = i;
			maxProp = prop;
		end
	end

	tmpList[maxIdx] = nil;
	return maxProp;

end

function GET_WIKI_MON_MAP_TXT(frame, propValue, count, index)

	local ret = "";

	local cls = GetClassByType("Map", propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : MAP Not Exists");
		return "";
	end

	if index > 1 then
		ret = ", ";
	end

	ret = ret .. string.format("%s (%d %s)", cls.Name, count, ClientMsg(20013));
	return ret;

end

function GET_WIKI_MON_DROP_TXT(frame, propValue, count, index)

	local ret = "";

	local cls = GetClassByType("Item", propValue);
	if cls == nil then
		ErrorMsg(propValue .. " : Item Not Exists");
		return "";
	end


	local icon = cls.Icon;

	local gBox = frame:GetChild("gbox");
	gBox:ShowWindow(1);
	local cWidth = 48;
	local cHeight = 48;
	local x, y = GET_WIKI_UI_POS(gBox, index, cWidth, cHeight);
	local ctrl = gBox:CreateOrGetControl('picture', "_WK_ICON_" .. index, x, y, cWidth, cHeight);
	tolua.cast(ctrl, "ui::CPicture");
	MAKE_HAVE_ITEM_TOOLTIP(ctrl, cls.ClassID);

	SET_IMAGE_HITTEST(ctrl, icon);

	local ctrlTxt = gBox:CreateOrGetControl("richtext", "_WI_ICON_TXT_" .. index, x, y + cWidth - 16, cWidth, 16);
	ctrlTxt:ShowWindow(1);
	ctrlTxt:SetTextAlign("right", "bottom");
	ctrlTxt:SetText("{@st41}" .. count);

	return "";


end

function GET_WIKI_UI_POS(frame, index, cWidth, cHeight)

	cWidth = cWidth + 10;
	cHeight = cHeight + 10;
	index = index - 1;
	local width = frame:GetWidth() - 10;
	local height = frame:GetHeight() - 10;

	local maxCol = math.floor(width / cWidth);

	local col = index % maxCol;
	local row = math.floor(index / maxCol);

	local x = col * cWidth + 10;
	local y = row * cHeight + 10;
	return x, y;

end

--------- About Rank Tooltip


function WIKI_TOOLTIP_INT()

end

function WIKI_TOOLTIP_INT_ON(ctrl, funcName, typeInt)

	ctrl:SetTooltipType("wikirank");
	ctrl:SetTooltipArg(funcName, 1, typeInt);
	ui.UpdatePickTooltip();

end

function WIKI_TOOLTIP_INT_OFF(ctrl, type, propType)

	ctrl:SetTooltipType("None");
	ui.UpdatePickTooltip();

end

function WIKI_TOOLTIP_PAIR()

end

function WIKI_TOOLTIP_PAIR_ON(ctrl, funcName, typeInt)

	ctrl:SetTooltipType("wikirank");
	ctrl:SetTooltipArg(funcName, 0, typeInt);
	ui.UpdatePickTooltip();

end

function WIKI_TOOLTIP_PAIR_OFF(ctrl, type, propType)

	ctrl:SetTooltipType("None");
	ui.UpdatePickTooltip();
end

function UPDATE_WIKI_TOOLTIP(frame, funcName, datatype, typeInt)

	typeInt = tonumber(typeInt);
	local wikiType = math.floor(typeInt / 1000);
	local propType = typeInt % 1000;

	local wiki = GetWiki(wikiType);
	if wiki == nil then
		frame:ShowWindow(0);
		return;
	end

	local rankList = nil;
	if datatype == 0 then
		rankList = session.GetPairWikiRank(wikiType);
	else
		rankList = session.GetIntWikiRank(wikiType);
	end

	local sortList = rankList:FindAndGet(propType);
	if sortList == nil then
		packet.ReqWikiRank(wikiType, 1);
		return;
	end

	local cnt = sortList:Count();
	if cnt == 1 then
		packet.ReqWikiPropRank(wikiType, datatype, propType);
	end

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	advBox:SetColWidth(2, 500);

	local height = 0;
	local maxWidth = 0;
	local rank = 1;
	for i = 0 , cnt - 1 do
		local rankInfo = sortList:PtrAt(i);
		maxWidth, height = SET_WIKIRANK_BOX_INT(advBox, rankInfo, rank, funcName, datatype, maxWidth);
		rank = rank + 1;
	end

	advBox:SetColWidth(2, maxWidth);
	advBox:Resize(maxWidth + 150, advBox:GetHeight());

	for i = 1 , cnt  do
		local item = advBox:GetObjectXY(i, 2);
		item:Resize(maxWidth, item:GetHeight());
	end

	advBox:UpdateAdvBox();

	frame:Resize(advBox:GetWidth() + 20, advBox:GetY() + height + 10);

end

function SET_WIKIRANK_BOX_INT(advBox, rankInfo, rank, funcName, datatype, maxWidth)

	local key = rank;
	SET_ADVBOX_ITEM_C(advBox, key, 0, rank, "white_20_ol");
	SET_ADVBOX_ITEM_C(advBox, key, 1, rankInfo.charName, "white_20_ol");

	local item;
	if datatype == 1 then
		item = SET_ADVBOX_ITEM_C(advBox, key, 2, rankInfo.count, "white_20_ol");
	else
		local func = _G[funcName];
		local rankTxt = func(nil, rankInfo);
		rankTxt = string.sub(rankTxt, 5, string.len(rankTxt));
		item = SET_ADVBOX_ITEM_C(advBox, key, 2, rankTxt, "white_20_ol");
	end

	tolua.cast(item, "ui::CRichText");
	local width = item:GetTextWidth() + 100;
	if width > maxWidth then
		maxWidth = width;
	end

	return maxWidth, item:GetY() + item:GetHeight();

end

function WIKIPAGE_ACHIEVE(frame, cls)
	local detailBox = frame:GetChild('wikidetail');
	tolua.cast(detailBox, 'ui::CGroupBox');
	local uiEffect = detailBox:GetEffectByName('wikidetailopen');
	uiEffect:SetDestMovePos(0, 50, 2.0, 0.0);
	detailBox:ShowWindow(1);
	detailBox:DeleteAllControl();

	local achievecls = GetClass("Achieve", cls.ClassName);

	local itemCloseCtrl = detailBox:CreateOrGetControl('button', 'itemClose', -17, 10, 40, 40);
	tolua.cast(itemCloseCtrl, 'ui::CButton');
	itemCloseCtrl:SetGravity(ui.RIGHT, ui.TOP);
	itemCloseCtrl:SetImage('btn_close');
	itemCloseCtrl:SetLBtnUpScp('WIKIPAGE_CLOSE_LBTNUP');

	local itemNameCtrl = detailBox:CreateOrGetControl('richtext', 'itemName', 125, 50, 180, 20);
	tolua.cast(itemNameCtrl, 'ui::CRichText');
	itemNameCtrl:SetText('{@st41}'..achievecls.Name);

	local itemPicCtrl = detailBox:CreateOrGetControl('picture', 'itemPic', 40, 20, 80, 80);
	tolua.cast(itemPicCtrl, 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(achievecls.Icon);

	if achievecls.Desc ~= 'None' then
		local itemDescCtrl = detailBox:CreateOrGetControl('richtext', 'itemDesc', 40, 110, 280, 20);
		tolua.cast(itemDescCtrl, 'ui::CRichText');
		itemDescCtrl:SetTextFixWidth(1);
		itemDescCtrl:EnableResizeByText(0);
		itemDescCtrl:SetText('{@st55_c}'.. achievecls.Desc);
	end
end

function WIKIPAGE_RECIPE(frame, cls)
	local detailBox = frame:GetChild('wikidetail');
	tolua.cast(detailBox, 'ui::CGroupBox');
	local uiEffect = detailBox:GetEffectByName('wikidetailopen');
	uiEffect:SetDestMovePos(0, 50, 2.0, 0.0);
	detailBox:ShowWindow(1);
	detailBox:DeleteAllControl();

	local itemCloseCtrl = detailBox:CreateOrGetControl('button', 'itemClose', -17, 10, 40, 40);
	tolua.cast(itemCloseCtrl, 'ui::CButton');
	itemCloseCtrl:SetGravity(ui.RIGHT, ui.TOP);
	itemCloseCtrl:SetImage('btn_close');
	itemCloseCtrl:SetLBtnUpScp('WIKIPAGE_CLOSE_LBTNUP');

	local itemCls = GetClass('Item', cls.TargetItem);

	local itemNameCtrl = detailBox:CreateOrGetControl('richtext', 'itemName', 125, 50, 180, 20);
	tolua.cast(itemNameCtrl, 'ui::CRichText');
	itemNameCtrl:SetText('{@st45}'..itemCls.Name);

	local itemPicCtrl = detailBox:CreateOrGetControl('picture', 'itemPic', 40, 20, 80, 80);
	tolua.cast(itemPicCtrl, 'ui::CPicture');
	itemPicCtrl:SetEnableStretch(1);
	itemPicCtrl:SetImage(itemCls.TooltipImage);

	local index = 1;
	local yPos = 30;

	local recipeType = cls.RecipeType;
	local cnt = GetEntryCount(cls);
	for i = 0 , cnt - 1 do
		local propname, propvalue, propType = GetEntryByIndex(cls, i);
		local recipeItem = IS_WIKI_RECIPE_PROP(recipeType, propname, propType);

		if 1 == recipeItem and propvalue ~= "None" then
			local recipeItem = propvalue;
			local recipeItemCls = GetClass('Item', recipeItem);
			local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(cls, propname);

			local y = yPos + (40 * (index-1));
			local itemRecipePicCtrl = detailBox:CreateOrGetControl('picture', recipeItem, 40, y+70, 40, 40);
			tolua.cast(itemRecipePicCtrl, 'ui::CPicture');
			itemRecipePicCtrl:SetEnableStretch(1);
			itemRecipePicCtrl:SetImage(recipeItemCls.TooltipImage);

			local itemRecipeNameCtrl = detailBox:CreateOrGetControl('richtext', recipeItem..'itemName', 85, y+80, 100, 20);
			tolua.cast(itemRecipeNameCtrl, 'ui::CRichText');
			itemRecipeNameCtrl:SetText('{@st55_c}: '.. GET_RECIPE_ITEM_TXT(recipeType, recipeItemCls.Name, recipeItemCnt, recipeItemLv));
			index = index + 1;
		end
	end

end

function GET_RECIPE_REQITEM_CNT_OLD(cls, propname)

	local recipeType = cls.RecipeType;
	if recipeType == "Anvil" or recipeType == "Grill" then
		return cls[propname .. "_Cnt"], TryGet(cls, propname .. "_Level");
	elseif recipeType == "Drag" or recipeType == "Upgrade" then
		return cls[propname .. "_Cnt"], TryGet(cls, propname .. "_Level");
	end

	return 0;

end

function GET_RECIPE_MATERIAL_INFO(recipeCls, index)

	local clsName = "Item_"..index.."_1";
	local itemName = recipeCls[clsName];
	if itemName == "None" then
		return nil;
	end
		
	local dragRecipeItem = GetClass('Item', itemName);
	local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipeCls, clsName);

	local invItem = nil
	local invItemlist = nil

	if dragRecipeItem.MaxStack > 1 then
		invItem = session.GetInvItemByType(dragRecipeItem.ClassID);
	else
		invItemlist = GET_INVITEMS_BY_TYPE_WORTH_SORTED(dragRecipeItem.ClassID)
	end

	local invItemCnt = GET_PC_ITEM_COUNT_BY_LEVEL(dragRecipeItem.ClassID, recipeItemLv);
	return recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist;

end

function IS_WIKI_RECIPE_PROP(recipeType, propname, propType)

	if recipeType == "Anvil" or recipeType == 'Grill' then
		if string.find(propname, "Item_") ~= nil and string.find(propname, "_Cnt") == nil and string.find(propname, "_Level") == nil or string.find(propname, "FromItem") ~= nil then
			return 1;
		end
	elseif recipeType == "Drag" or recipeType == "Upgrade" then
		if string.find(propname, "Item_") ~= nil and string.find(propname, "_Cnt") == nil and string.find(propname, "_Level") == nil then
			return 1;
		end
	end

	return 0;

end


function WIKIPAGE_CLOSE_LBTNUP(frame, ctrl, argStr, argNum)
	frame:ShowWindow(0);
end

function WIKI_PICASA_VIEW_TYPE(frame, ctrl, argStr, argNum)
	local itemPicasaCtrl = GET_CHILD(frame, 'item_picasa', 'ui::CPicasa');
	local recipePicasaCtrl = GET_CHILD(frame, 'recipe_picasa', 'ui::CPicasa');
	local mapPicasaCtrl = GET_CHILD(frame, 'map_picasa', 'ui::CPicasa');
	local achievePicasaCtrl = GET_CHILD(frame, 'achieve_picasa', 'ui::CPicasa');
	local monsterPicasaCtrl = GET_CHILD(frame, 'monster_picasa', 'ui::CPicasa');

	local simple = true;
	local viewtypeCtrl = GET_CHILD(frame, 'viewtype', 'ui::CButton');
	if itemPicasaCtrl:IsItemViewSimple() == true then
		simple = false;
		viewtypeCtrl:SetText(ScpArgMsg('Auto_{@st41}aiKon'));
	else
		viewtypeCtrl:SetText(ScpArgMsg('Auto_{@st41}LiSeuTeu'));
	end

	itemPicasaCtrl:SetItemViewSimple(simple);
	recipePicasaCtrl:SetItemViewSimple(simple);
	achievePicasaCtrl:SetItemViewSimple(simple);
	mapPicasaCtrl:SetItemViewSimple(simple);
	monsterPicasaCtrl:SetItemViewSimple(simple);
end

function ON_WIKI_HELP_MSG_ADD(frame, argNum)

	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end
	
	WIKI_HELP_FOCUS(frame, argNum);
end
