


fame_cur_page = 1;
fame_max_page = 1;
open_not_reqinfo = 0;

function HALLOFFAME_ON_INIT(addon, frame)
	local uiHeight = frame:GetHeight() - 260;
	local fameAdvBox = GET_FAME_ADVBOX(frame);
	fameAdvBox:Resize(fameAdvBox:GetWidth(), uiHeight);

	--FAME_LOADING_MODE(frame, 0);

	addon:RegisterMsg("FAME_RANK_UPDATED", "FAME_RANK_UPDATED");
	addon:RegisterMsg("RANK_UI", "RANK_UI");
end

function CLOSE_FAME_FRAME(frame)

	frame:SetValue(0);
	TRADE_DIALOG_CLOSE();

	camera.CamDestMoving(-20, 0.5);

	SHOW_RIGHTBASE_UI();

end

function OPEN_FAME_FRAME(frame)

	if 0 == open_not_reqinfo then
		UPDATE_FAME_FRAME(frame);
		FAME_REQ_PAGE(frame, 1);
	end

	open_not_reqinfo = 0;
	camera.CamDestMoving(20, 0.5);

	HIDE_RIGHTBASE_UI()

end

function IS_FAME_LOADING_MODE(frame)

	local loading = frame:GetChild("loading");
	return loading:IsVisible();

end

function GET_CUR_POINT_CLS(frame)

	local clsID = frame:GetValue();
	local cls = GetClassByType("AchievePoint", clsID);
	return cls;

end

function FAME_LOADING_MODE(frame, isLoading)

	local fameList = GET_CHILD(frame, "fameList", "ui::CRichText");

	local loadingVisible = isLoading;
	local fameVisible = 0;
	if isLoading == 0 then
		fameVisible = 1;
		local clsID = frame:GetValue();
		local cls = GetClassByType("AchievePoint", clsID);
		if cls ~= nil then
			frame:GetChild("title"):SetTextByKey("title", cls.Name);
		end
	else
		frame:SetTitleName("Loading...");
	end

	local tabVisible = fameVisible;

	local loading = frame:GetChild("loading");
	loading:ShowWindow(loadingVisible);
	fameList:ShowWindow(fameVisible);

	local tab = GET_CHILD(frame, "daytype", "ui::CTabControl");
	tab:SetEnable(tabVisible);
end

function GET_FAME_LIST(frame)

	local fameList = frame:GetChild('fameList');
	tolua.cast(fameList, 'ui::CRichText');
	return fameList;

end

function UPDATE_FAME_FRAME(frame)

	local value = frame:GetValue();
	local rankGroup = frame:GetSValue();

	local fameList = GET_FAME_LIST(frame);
	local setTxt = "";

	local clsList, cnt  = GetClassList("AchievePoint");
	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clsList, i);
		local rankName = cls.RankName;
		local group = cls.RankGroup;

		if rankName ~= "None" then
			if rankGroup == "None" or group == rankGroup then
				-- fameList:AddItem(cls.ClassID, rankName, 0);

				local key = cls.ClassID;
				local name = string.format("{a SEL_VIEW_RANK %s}{@st45}%s{/}{/}", key, rankName);
				setTxt = setTxt .. name .. "{s6}{nl} {nl}{/}";
				--local item = SET_ADVBOX_ITEM_C(fameList, key, 0, name, "white_16_ol");
				--item:EnableHitTest(1);
			end
		end

	end

	--fameList:UpdateAdvBox();
	fameList:SetText(setTxt);

end

function GET_SELECTED_POINT_TYPE(frame)

	local classID = frame:GetValue();
	local tab = GET_CHILD(frame, "daytype", "ui::CTabControl");
	local tabIdx = tab:GetSelectItemIndex();
	local resultID = classID + tabIdx * geAchieveTable.GetMaxClassID();
	return resultID;

end

function GET_SEARCH_TEXT(frame)

	local edit = frame:GetChild("searchinput");
	local text = edit:GetText();
	return text;

end

function SET_SEARCH_TEXT(frame, text)

	local edit = frame:GetChild("searchinput");
	edit:SetText(text);

end

function SEL_VIEW_RANK(type)

	local frame = ui.GetFrame("halloffame");
	frame:SetValue(type);
	SET_SEARCH_TEXT(frame, "");
	FAME_REQ_PAGE(frame, 1);

end

function FAME_DROPLIST_SELECTED(frame)

	SET_SEARCH_TEXT(frame, "");
	FAME_REQ_PAGE(frame, 1);

end

function FAME_REQ_PAGE(frame, page, option)
	if option == nil then
		option = 0;
	end

	REQUEST_SERVER_FAME_LIST(frame, page, option);
end

function REQUEST_SERVER_FAME_LIST(frame, page, findType)

	page = CLAMP(page, 1, fame_max_page);
	local text = GET_SEARCH_TEXT(frame);

	local curIndex = GET_FAME_SELECTED_INDEX(frame) + 1;
	local pointID = GET_SELECTED_POINT_TYPE(frame);

	local fameAdvBox = GET_FAME_ADVBOX(frame);
	local viewInPage = fameAdvBox:GetMaxRowInPage();

	-----------packet.ReqFameListInfo(pointID, page, text, curIndex, findType, viewInPage);
	FAME_LOADING_MODE(frame, 1);
	ReserveScript("FAME_LIST_RECOVER()", 2.0);

end

function FIND_FAME_BY_NAME(frame)

	FAME_REQ_PAGE(frame, 1);

end

function FAME_LIST_RECOVER()

	local frame = ui.GetFrame("halloffame");
	local isLoading = IS_FAME_LOADING_MODE(frame);
	if isLoading == 0 then
		return;
	end

	FAME_LOADING_MODE(frame, 0);

end

function RANK_UI(frame, msg, showallCategory, num)

	if showallCategory == "1" then
		frame:SetSValue("None");
	else
		local rankGroup = GetClassByType("AchievePoint", num).RankGroup;
		frame:SetSValue(rankGroup);
	end

	open_not_reqinfo = 1;
	UPDATE_FAME_FRAME(frame);
	frame:ShowWindow(1);
	frame:SetValue(num);
	FAME_DROPLIST_SELECTED(frame);

end

function FAME_RANK_UPDATED(frame)

	UPDATE_FAME_FRAME(frame);

	FAME_LOADING_MODE(frame, 0);

	local pageInfo = session.GetFamePageInfo();
	fame_cur_page = pageInfo.page;
	fame_max_page = pageInfo.maxPage;
	fame_max_page = MAX(1, fame_max_page);

	FAME_UPDATE_PAGE(frame);
	FAME_PC_LIST_UPDATE(frame);

	if pageInfo.name ~= "" then
		FAME_LIST_SELECT_INDEX(frame, pageInfo.findedIndex);
	end
end

function GET_FAME_ADVBOX(frame)
	local advBox = frame:GetChild("AdvBox_0");
	tolua.cast(advBox, "ui::CAdvListBox");
	return advBox;
end

function FAME_LIST_SELECT_INDEX(frame, rankIndex)

	local advBox = GET_FAME_ADVBOX(frame);
	advBox:SelectItemByKey(rankIndex);

end

function GET_FAME_SELECTED_INDEX(frame)

	local advBox = GET_FAME_ADVBOX(frame);
	local key = advBox:GetSelectedKey();
	if key == nil or key == "None" then
		return -1;
	end

	return tonumber(key);

end

function SET_FAME_SELECTED_INDEX(frame, index)

	local advBox = GET_FAME_ADVBOX(frame);
	advBox:SelectItem(index);

end

function SET_SCORE_TITLE(frame, advBox)

	local cls = GET_CUR_POINT_CLS(frame);
	local titleTxt = "{@st56}" .. cls.ScoreTitle;
	advBox:GetObjectXY(0, 1):SetText(titleTxt);

end

function FAME_PC_LIST_UPDATE(frame)

	local advBox = GET_FAME_ADVBOX(frame);
	advBox:SelectItem(-1);
	advBox:ClearUserItems();

	local pointType = GET_SELECTED_POINT_TYPE(frame);
	local curPage = session.GetFamePageInfo().page;

	local list = session.GetFameRankList();
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		SET_FAME_BOXITEM(advBox, pointType, info);
	end

	SET_SCORE_TITLE(frame, advBox);
	advBox:UpdateAdvBox();

end

function SET_FAME_BOXITEM(advBox, pointType, info)
	local key = info.rank;
	local rank = info.rank + 1;
	SET_ADVBOX_ITEM_C(advBox, key, 0, rank, "white_16_ol");

	local port = advBox:SetItemByType(key, 2, "picture", 30, 30, 0);
	tolua.cast(port, "ui::CPicture");		
	local portrait = string.format("Job_Portrait_Char%s", info.job)
	port:SetImage(portrait);
	port:SetEnableStretch(1);
	
	SET_ADVBOX_ITEM_C(advBox, key, 1, info.point, "white_16_ol");
	SET_ADVBOX_ITEM(advBox, key, 3, info.name, "white_16_ol");
end

function GET_ACHIEVE_NAME_BY_POINT(pointType, point)

	local cls = GET_ACHIEVE_CLASS(pointType, point);
	if cls == nil then
		return "";
	end

	return cls.Name;

end

function GET_ACHIEVE_CLASS(pointType, point)

	local achieveID = geAchieveTable.GetAchieveID(pointType, point);
	if achieveID == 0 then
		return nil;
	end

	local cls = GetClassByType("Achieve", achieveID);
	return cls;

end


function FAME_UPDATE_PAGE(frame)

	fame_cur_page = CLAMP(fame_cur_page, 0, fame_max_page);

	local pagetext = frame:GetChild("pagetext");
	pagetext:SetTextByKey("curpage", fame_cur_page);
	pagetext:SetTextByKey("maxpage", fame_max_page);

end

function FAME_SET_PAGE(frame, ctrl, str, page)

	FAME_REQ_PAGE(frame, fame_cur_page + page)

end

function FAME_SEARCH_POINT_NAME(pointType, name)

	local frame = ui.GetFrame("halloffame");
	open_not_reqinfo = 1;
	frame:ShowWindow(1);

	frame:SetValue(pointType);
	SET_FAME_SELECTED_INDEX(frame, -1);
	SET_SEARCH_TEXT(frame, name);
	FAME_REQ_PAGE(frame, 1, 1);

end

--[[
class ACHIEVE_RANK_PAGE_INFO
{
	int		type;
	int		page;
	int		maxPage;
	int		count;
};

class ACHIEVE_RANK_INFO
{
	const char * pcName;
	int			point;
};

class ACHIEVE_RANK_LIST_C
{
	int			Count();
	ACHIEVE_RANK_INFO*	PtrAt(int i);
};

]]





