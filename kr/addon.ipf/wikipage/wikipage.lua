
--WIKIPAGE_RANKER_COLOR = "{#AABB00}{ol}";
WIKIPAGE_RANKER_COLOR = "";
WIKIPAGE_RANKER_SIZE = 18;
--WIKIPAGE_PROP_TITLE_COL = "{#FFCC66}{ol}";
WIKIPAGE_PROP_TITLE_COL = "";


function WIKIPAGE_ON_INIT(addon, frame)
	--addon:RegisterMsg('WIKIPAGE_LIST_ADD', 'UPDATE_CUR_WIKIPAGE');
	addon:RegisterOpenOnlyMsg('WIKIPAGE_PROP_UPDATE', 'ON_WIKIPAGE_PROP_UPDATE');
	addon:RegisterOpenOnlyMsg('WIKIPAGE_RANK_UPDATE', 'ON_WIKIPAGE_PROP_UPDATE');
	addon:RegisterOpenOnlyMsg('WIKIPAGE_RANK_PROP_UPDATE', 'ON_WIKIPAGE_RANK_PROP_UPDATE');

	WIKIPAGE_TAB_INDEX=0;
	WIKIPAGE_TROPHY_INDEX = 0;
	WIKIPAGE_TROPHY_PAGECOUNT = 1;
end

function ON_WIKIPAGE_RANK_PROP_UPDATE(frame)

	ui.UpdateVisibleToolTips();

end

function UPDATE_CUR_WIKIPAGE(frame, msg, argStr, argNum)

	if frame:IsVisible() == 0 then
		return;
	end


	UPDATE_WIKIPAGE_FRAME(frame, argNum);

end

function WIKIPAGE(wikiID, prev)

	local wikiframe = ui.GetFrame("wiki");
	UPDATE_WIKIPAGE_FRAME(wikiframe, wikiID, prev);

end

function UPDATE_WIKIPAGE_FRAME(frame, wikiID, prev, curtabIndex)

	local wikiobj = GetClassByType("Wiki", wikiID);

	if wikiobj == nil then
		WIKIPAGE_CLEAR(frame);
		return;
	end

	frame:GetChild("gBox"):ShowWindow(0);

	local sameWiki = 0;
	if frame:GetValue() == wikiID then
		sameWiki = 1;
	end
	if curtabIndex ~= nil then
		WIKIPAGE_TAB_INDEX = curtabIndex;
	end

	local wikiScp = _G[wikiobj.Scp];

	wikiScp(frame, wikiobj, sameWiki);
	WIKIPAGE_COMMON(frame, wikiobj, WIKIPAGE_TAB_INDEX);

	frame:Invalidate();
	frame:ShowWindow(1);
	ui.SetTopMostFrame(frame);

	if prev == 0 then
		session.AddWikiHistory(wikiID);
	end

	session.SetCurrentWiki(wikiID);
	frame:SetValue(wikiID);
end

function ON_WIKIPAGE_PROP_UPDATE(frame, msg, str, wikiType)

	if frame:GetValue() == wikiType then
		UPDATE_WIKIPAGE_FRAME(frame, wikiType, 1);
	end

end

function SHOW_WIKIPAGE_TAB(frame, tab)
	local i_show = 0;
	local m_show = 0;
	if tab == 0 then
		i_show = 1;
	end

	if tab == 1 or tab == 2 or tab == 3 or tab == 4 then
		m_show = 1;
	end

	frame:GetChild("i_image"):ShowWindow(i_show);
	frame:GetChild("i_name"):ShowWindow(i_show);
	frame:GetChild("i_desc"):ShowWindow(i_show);

	frame:GetChild("m_image"):ShowWindow(m_show);
	frame:GetChild("m_name"):ShowWindow(m_show);
	frame:GetChild("m_desc"):ShowWindow(m_show);

end

function WIKIPAGE_CLEAR(frame)

	local page = frame:GetChild("page");
	page:SetText("");

	local name = frame:GetChild("i_name");
	name:SetText(ScpArgMsg("Auto_JeongBoKa_eopSeupNiDa."));

	local image = frame:GetChild('i_image');
	tolua.cast(image, "ui::CPicture");
	image:SetImage("blank");

	local desc = frame:GetChild("i_desc");
	desc:SetText("");

	frame:GetChild("m_image"):ShowWindow(0);
	frame:GetChild("m_name"):ShowWindow(0);
	frame:GetChild("m_desc"):ShowWindow(0);

	frame:GetChild("i_image"):ShowWindow(0);
	frame:GetChild("i_name"):ShowWindow(0);
	frame:GetChild("i_desc"):ShowWindow(0);

	frame:GetChild("PREV"):ShowWindow(0);
	frame:GetChild("NEXT"):ShowWindow(0);

	frame:GetChild("gBox"):ShowWindow(0);

	frame:Invalidate();

end

function WIKIPAGE_COMMON(frame, cls, curtabIndex)
	local type = cls.ClassID;

	local cnt = session.GetWikiCount(type);
	local index = session.GetWikiIndex(type);
	if curtabIndex ~= nil then
		frame:SetTabName('Itembox'..curtabIndex+1);
	end
	frame:UpdateVisibleByTab();

	SHOW_WIKIPAGE_TAB(frame, curtabIndex);

	if index == -1 and cls.AutoGet == 1 then
		session.RequestGetWiki(type);
		return;
	end

	local curRank = session.GetPairWikiRank(type);
	if curRank == nil then
		packet.ReqWikiRank(type, 1);
	end

end

function WIKIPAGE_VIEW_TYPE(frame, ctrl, str, num)
	frame:SetValue2(num);
	UPDATE_WIKIPAGE_FRAME(frame, frame:GetValue());

end

function WIKIPAGE_NPC(frame, cls, sameWiki)

	WIKIPAGE_MONSTER(frame, cls, sameWiki);

end

function WIKIPAGE_MONSTER(frame, cls, sameWiki)

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
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Lv", ClientMsg(20018));
		txt = txt .. "{nl}" ..GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "MHP", ClientMsg(20019));
		txt = txt .. "{nl}" .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "KillCount", ClientMsg(20011), intRank);
		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20012).. " : ", "Map_", MAX_WIKI_MON_MAPID, "GET_WIKIPAGE_MON_MAP_TXT");

	elseif viewType == 2 then

		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20016), "TopAtk_", MAX_WIKI_TOPATTACK, "GET_WIKIPAGE_TOPATK_TXT", pairRank);

		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20017), "MonSkl_", MAX_WIKI_MON_ATK, "GET_WIKIPAGE_MONSKL_TXT");

	elseif viewType == 3 then
		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20010), "DropItem_", MAX_WIKI_MON_DROPITEM, "GET_WIKIPAGE_MON_DROP_TXT");

	end

	if sameWiki == 1 then
		desc:SetText_MaintainScroll(txt);
	else
		desc:SetText(txt);
	end

end


function WIKIPAGE_AREA(frame, cls)

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

function WIKIPAGE_ITEM_1(frame, cls, sameWiki)

	local wikiType = cls.ClassID;
	local itemcls = GetClass("Item", cls.StrArg);
	local fullname = GET_FULL_NAME(itemcls);
	local FontColor = GET_ITEM_FONT_COLOR(itemcls.ItemStar);

	local image = frame:GetChild('i_image');
	tolua.cast(image, "ui::CPicture");
	local desc = GET_CHILD(frame, "i_desc", "ui::CScrollText");

	local txt = frame:GetChild('i_name');
	txt:SetText(FontColor .. fullname);

	local index = session.GetWikiIndex(wikiType);

	if index == -1 and cls.AutoGet == 0 then
		local desc = frame:GetChild("i_desc");
		desc:SetText(COLOR_GRAY .. ScpArgMsg("ITEM_NOT_WRITTEN_IN_JOURNAL"));
		image:SetImage("unknown_item");
		return;
	end

	local iconname = itemcls.Icon;
	image:SetImage(iconname);
	local txt = "";
	if itemcls.Desc ~= nil then
		txt = txt .. itemcls.Desc .."{nl}";
	end

	txt = txt .. cls.Desc;

	local wiki = GetWiki(wikiType);
	if wiki == nil then
		desc:SetText(txt);
		return;
	end

	local viewType = frame:GetValue2();
	if viewType == 0 or viewType >= 2 then
		desc:SetText(cls.Desc);
		return;
	end


	local pairRank = session.GetPairWikiRank(wikiType);
	local intRank = session.GetIntWikiRank(wikiType);

	if viewType == 1 then

		txt = "";
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Total", ClientMsg(20020), intRank);
		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20021), "Mon_", MAX_WIKI_ITEM_MON, "GET_WIKIPAGE_ITEM_MON_TXT")
		txt = txt .. "{nl}" .. GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, ClientMsg(20022), "Q_", MAX_WIKI_ITEM_QUEST, "GET_WIKIPAGE_ITEM_QUEST_TXT")
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Buy", ClientMsg(20022));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Sell", ClientMsg(20023));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Cheat", ClientMsg(20024));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Exchange", ClientMsg(20025));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "EquipChange", ClientMsg(20026));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Recipe", ClientMsg(20027));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Quest", ClientMsg(20028));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Bag", ClientMsg(20029));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Package", ClientMsg(20030));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "GuildQuest", ClientMsg(20031));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Inn", ClientMsg(20032));
		txt = txt .. GET_WIKIPAGE_INTPROP_TXT(frame, wiki, "Rullet", ClientMsg(20033));
	end

	if sameWiki == 1 then
		desc:SetText_MaintainScroll(txt);
	else
		desc:SetText(txt);
	end

end

function WIKIPAGE_ALLTROPHY_LBTN_UP(frame)
	WIKIPAGE_ETC_CHILD_VIEW(frame, 1, 1);
	frame:UpdateVisibleByTab();
	WIKIPAGE_TAB_CHANGE(frame);
	frame:Invalidate();
end

function WIKIPAGE_ETC_CHILD_VIEW(frame, isVisible, pageChildVisible)
	local tabCtrl = frame:GetChild('itembox');
	tolua.cast(tabCtrl, "ui::CTabControl");
	local selectName = tabCtrl:GetSelectItemName();

	if selectName == 'Itembox1' then
		local inameChild = frame:GetChild('i_name');
		local idescChild = frame:GetChild('i_desc');
		local iimageChild = frame:GetChild('i_image');
		inameChild:ShowWindow(isVisible);
		idescChild:ShowWindow(isVisible);
		iimageChild:ShowWindow(isVisible);
	else
		local mnameChild = frame:GetChild('m_name');
		local mdescChild = frame:GetChild('m_desc');
		local mimagehild = frame:GetChild('m_image');
		mnameChild:ShowWindow(isVisible);
		mdescChild:ShowWindow(isVisible);
		mimagehild:ShowWindow(isVisible);
	end

	local pageChild = frame:GetChild('page');
	local prevChild = frame:GetChild('PREV');
	local nextChild = frame:GetChild('NEXT');

	pageChild:ShowWindow(pageChildVisible);
	prevChild:ShowWindow(pageChildVisible);
	nextChild:ShowWindow(pageChildVisible);

	if isVisible == 0 then
		SHOW_CHILD_BYNAME(frame, "cbtn_", 0);
		frame:GetChild("gBox"):ShowWindow(0);
	end

end

function WIKIPAGE_TROPHY_SLOT_LBTNUP(frame, slot, argStr, argNum)
	WIKIPAGE_ALL_TROPHY_VIEW = 0;
	UPDATE_WIKIPAGE_FRAME(frame, argNum);
end

--[[
struct WIKIPAGE_RANK_INFO_INT
{
	const char *	charName;
	int				count;
};

]]

function GET_WIKIPAGE_INTPROP_TXT(frame, wiki, propName, msgTxt, rankList)

	local cnt = GetWikiIntProp(wiki, propName);
	if cnt == 0 then
		return "";
	end

	local txt = WIKIPAGE_PROP_TITLE_COL .. msgTxt  .. " {/}{/}: " .. cnt .. " ";

	if rankList == nil then
		return txt;
	end

	local propType = WikiNameToType_Int(wiki, propName);
	local rankInfo = GET_FIRST_RANK_INFO(rankList, propType);
	if rankInfo == nil then
		return txt;
	end

	local linkScp = string.format( "{a #WIKIPAGE_TOOLTIP_INT %s %d}", "None", GetWikiType(wiki) * 1000 +  propType);
	local topTxt = string.format("{s%d}%s%s 1%s - %s : %d{/}{/}{/}{/}", WIKIPAGE_RANKER_SIZE, WIKIPAGE_RANKER_COLOR, linkScp, ClientMsg(20034), rankInfo.charName, rankInfo.count);
	return txt .. " " .. topTxt;
end

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

function GET_WIKIPAGE_SORT_PROP_TXT(frame, wiki, msg, nameHead, maxCnt, getFunc, rankList)

	local txt = WIKIPAGE_PROP_TITLE_COL .. msg .. "{/}{/}";

	local sortList = {};
	GET_WIKIPAGE_SORT_LIST(wiki, nameHead, maxCnt, sortList);

	if #sortList == 0 then
		return "";
	end

	local func = _G[getFunc];
	for i = 1, #sortList do
		local prop = sortList[i];
		txt = txt .. func(frame, prop, i);
	end

	if rankList == nil then
		return txt;
	end

	local firstPropName = nameHead .. "1";
	local propType = WikiNameToType(wiki, firstPropName);
	local rankInfo = GET_FIRST_RANK_INFO(rankList, propType);
	if rankInfo == nil then
		return txt;
	end

	local linkScp = string.format( "{a #WIKIPAGE_TOOLTIP_PAIR %s %d}", getFunc, GetWikiType(wiki) * 1000 + propType);

	local rankTxt = func(frame, rankInfo);
	rankTxt = string.sub(rankTxt, 5, string.len(rankTxt));
	local topTxt = string.format("{nl}{s%d}%s%s1%s - %s %s{/}{/}{/}{/}", WIKIPAGE_RANKER_SIZE, WIKIPAGE_RANKER_COLOR, linkScp, ClientMsg(20034), rankInfo.charName, rankTxt);
	return txt .. " " .. topTxt;

end

function GET_WIKIPAGE_ITEM_MON_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("Monster", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : Monster Not Exists");
		return "";
	end

	ret = string.format("{nl}%s : %d %s", cls.Name, prop.count, ClientMsg(20014));
	return ret;

end

function GET_WIKIPAGE_ITEM_QUEST_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("QuestProgressCheck", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : Quest Not Exists");
		return "";
	end

	ret = string.format("{nl}%s : %d %s", cls.Name, prop.count, ClientMsg(20014));
	return ret;

end

function GET_WIKIPAGE_MONSKL_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("Skill", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : Skill Not Exists");
		return "";
	end

	ret = string.format("{nl}%s : %d %s", cls.Name, prop.count, ClientMsg(20015));
	return ret;

end


function GET_WIKIPAGE_TOPATK_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("Skill", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : Skill Not Exists");
		return "";
	end

	ret = string.format("{nl}{img icon_%s 20 20} %s : %d %s", cls.Icon, cls.Name, prop.count, ClientMsg(20015));
	return ret;

end

function GET_WIKIPAGE_MON_MAP_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("Map", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : MAP Not Exists");
		return "";
	end

	if index > 1 then
		ret = ", ";
	end

	ret = ret .. string.format("%s (%d %s)", cls.Name, prop.count, ClientMsg(20013));
	return ret;

end

function GET_WIKIPAGE_MON_DROP_TXT(frame, prop, index)

	local ret = "";

	local cls = GetClassByType("Item", prop.propValue);
	if cls == nil then
		ErrorMsg(prop.propValue .. " : Item Not Exists");
		return "";
	end


	local icon = cls.Icon;

	local gBox = frame:GetChild("gbox");
	gBox:ShowWindow(1);
	local cWidth = 40;
	local cHeight = 40;
	local x, y = GET_WIKIPAGE_UI_POS(gBox, index, cWidth, cHeight);
	local ctrl = gBox:CreateOrGetControl('picture', "_WK_ICON_" .. index, x, y, cWidth, cHeight);
	tolua.cast(ctrl, "ui::CPicture");
	MAKE_HAVE_ITEM_TOOLTIP(ctrl, cls.ClassID);

	SET_IMAGE_HITTEST(ctrl, icon);

	local ctrlTxt = gBox:CreateOrGetControl("richtext", "_WI_ICON_TXT_" .. index, x, y + cWidth - 16, cWidth, 16);
	ctrlTxt:ShowWindow(1);
	ctrlTxt:SetTextAlign("right", "bottom");
	ctrlTxt:SetText("{ol}{s20}" .. prop.count);

	return "";


end

function GET_WIKIPAGE_UI_POS(frame, index, cWidth, cHeight)

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


function WIKIPAGE_TOOLTIP_INT()

end

function WIKIPAGE_TOOLTIP_INT_ON(ctrl, funcName, typeInt)

	ctrl:SetTooltipType("wikirank");
	ctrl:SetTooltipArg(funcName, 1, typeInt);
	ui.UpdatePickTooltip();

end

function WIKIPAGE_TOOLTIP_INT_OFF(ctrl, type, propType)

	ctrl:SetTooltipType("None");
	ui.UpdatePickTooltip();

end

function WIKIPAGE_TOOLTIP_PAIR()

end

function WIKIPAGE_TOOLTIP_PAIR_ON(ctrl, funcName, typeInt)

	ctrl:SetTooltipType("wikirank");
	ctrl:SetTooltipArg(funcName, 0, typeInt);
	ui.UpdatePickTooltip();

end

function WIKIPAGE_TOOLTIP_PAIR_OFF(ctrl, type, propType)

	ctrl:SetTooltipType("None");
	ui.UpdatePickTooltip();

end



function UPDATE_WIKIPAGE_TOOLTIP(frame, funcName, datatype, typeInt)

	typeInt = tonumber(typeInt);
	local wikiType = math.floor(typeInt / 1000);
	local propType = typeInt % 1000;

	local wiki = session.etWiki(wikiType);
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
		maxWidth, height = SET_WIKIPAGERANK_BOX_INT(advBox, rankInfo, rank, funcName, datatype, maxWidth);
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

function SET_WIKIPAGERANK_BOX_INT(advBox, rankInfo, rank, funcName, datatype, maxWidth)

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


