
function COMPARE_ON_INIT(addon, frame)
	addon:RegisterMsg("RELATED_HISTORY", "COMPARE_RELATED_HISTORY");
end

function COMPARE_CREATE(addon, frame)

end


function PC_COMPARE_SET_ICON(slot, icon, equipItem)

	SET_ITEM_TOOLTIP_BY_TYPE(icon, equipItem.type)	
end

function LIKE_FAILED()
	if ui.IsFrameVisible("compare") == 0 then
		return;
	end

	local frame = ui.GetFrame("compare");
	local likeCheck = GET_CHILD_RECURSIVELY(frame,"likeCheck")
	likeCheck:SetCheck(0);

end

function REQUEST_LIKE_STATE(familyName)
	local otherpcinfo = session.otherPC.GetByFamilyName(familyName);
	
	local frame = ui.GetFrame("compare");
	local likeCheck = GET_CHILD_RECURSIVELY(frame,"likeCheck")
	if session.likeit.AmILikeYou(familyName) == false then
		if false == geClientInteraction.RequestLikeIt(otherpcinfo:GetAID(), otherpcinfo:GetCID()) then
			likeCheck:ToggleCheck();
		end
	else
		if false == geClientInteraction.RequestUnlikeIt(otherpcinfo:GetAID(), otherpcinfo:GetCID()) then
			likeCheck:ToggleCheck();
		end
	end
end

function DO_CLICK_LIKECHECK()

	local frame = ui.GetFrame("compare");
	local likeCheck = GET_CHILD_RECURSIVELY(frame,"likeCheck")

	local fname = likeCheck:GetUserValue("NOWFNAME");
	REQUEST_LIKE_STATE(fname);
end

function UPDATE_AM_I_LIKE_YOU(fname)
	
	local frame = ui.GetFrame("compare");
	local likeCheck = GET_CHILD_RECURSIVELY(frame,"likeCheck")
	
	if session.likeit.AmILikeYou(fname) == true then
		likeCheck:SetCheck(1)
	else
		likeCheck:SetCheck(0)
	end

	likeCheck:SetUserValue("NOWFNAME",fname);
end

-- 자신의 캐릭과 능력치 비교하는 부분 소스코드가 필요하면 20140910 이전 리비전에서 확인할 것. 지금은 삭제되어 있다. (20140915)
function SHOW_PC_COMPARE(cid)

	local otherpcinfo = session.otherPC.GetByStrCID(cid);
	local jobhistory = otherpcinfo.jobHistory;
	local frame = ui.GetFrame("compare");
	frame:ShowWindow(1);

	local charName = otherpcinfo:GetAppearance():GetName()
	local teamName = otherpcinfo:GetAppearance():GetFamilyName()
	local gender = otherpcinfo:GetAppearance():GetGender()
	frame:SetUserValue('COMPARE_PC_GENDER', gender); -- 살펴보기할 때 살펴보기중인 캐릭의 성별 가져오기 위함

	local infoGbox = frame:GetChild("groupbox_1");

	local tab = GET_CHILD_RECURSIVELY(frame, "itembox", "ui::CTabControl");
	local tabIndex = tab:GetIndexByName("information");
	tab:SelectTab(tabIndex);
	tab:ShowWindow(1);

	local obj = GetIES(otherpcinfo:GetObject());

	--좋아요 수 표시
	local likeItCountTxt = GET_CHILD_RECURSIVELY(frame,"likeitCount")
	if otherpcinfo.likeMeCount ~= -1 then
		likeItCountTxt:SetTextByKey("count",otherpcinfo.likeMeCount)
	end

	--내가 이미 좋아요 했는지?
	UPDATE_AM_I_LIKE_YOU(otherpcinfo:GetAppearance():GetFamilyName())
	

	local charNameRTxt = GET_CHILD(infoGbox,"charName","ui::CRichText")
	charNameRTxt:SetTextByKey("teamName",teamName);
	charNameRTxt:SetTextByKey("charName",charName);

	local jobInfoRTxt = GET_CHILD(infoGbox,"jobInfo","ui::CRichText")

	local nowjobinfo = jobhistory:GetJobHistory(jobhistory:GetJobHistoryCount()-1);
	local clslist, cnt  = GetClassList("Job");
	local nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);

	local jobRank = jobhistory:GetJobHistoryCount()
	local jobName = GET_JOB_NAME(nowjobcls, gender);
	local level = obj.Lv
	
	jobInfoRTxt:SetTextByKey("rank", jobRank);
	jobInfoRTxt:SetTextByKey("job", jobName);
	jobInfoRTxt:SetTextByKey("lv", level);

	local rankInfo = otherpcinfo:GetOtherpcAdventureBookRanking();    
    local pcranking = rankInfo.rank;
	local score = math.max(rankInfo.score, 0); -- 랭킹 없으면 0점이어야 함
	local wholeusercnt = GetAdventureBookTotalRankCount();
	local rankingInfoRTxt = GET_CHILD(infoGbox,"rankingInfo","ui::CRichText")
	local unrankingInfoRTxt = GET_CHILD(infoGbox,"unrankingInfo","ui::CRichText")
    
	if pcranking < 0 then
		rankingInfoRTxt:ShowWindow(0)
		unrankingInfoRTxt:ShowWindow(1)
	else
		rankingInfoRTxt:ShowWindow(1)
		unrankingInfoRTxt:ShowWindow(0)
	end

	rankingInfoRTxt:SetTextByKey("journalScore", score);
	unrankingInfoRTxt:SetTextByKey("journalScore", score);
	rankingInfoRTxt:SetTextByKey("charRanking", pcranking);
	rankingInfoRTxt:SetTextByKey("userCount", wholeusercnt);

	local his_box_bg = GET_CHILD_RECURSIVELY(frame,"his_box_bg");
	his_box_bg:ShowWindow(0)
	
	local g_equip = frame:GetChild("groupbox_2");
	g_equip:ShowWindow(1)

	DESTROY_CHILD_BYNAME(g_equip, "EQUIPS"); -- 임시임

	eqpSet = g_equip:CreateOrGetControlSet("itemslotset_compare", "EQUIPS", 40, 20);
	eqpSet:ShowWindow(1);
	tolua.cast(eqpSet, "ui::CControlSet")

	local imagename = ui.CaptureSomeonesFullStdImage(otherpcinfo:GetAppearance())	
	
	local charImage = GET_CHILD(eqpSet,"shihouette","ui::CPicture");
	charImage:SetImage(imagename)

	local eqpList = otherpcinfo:GetEquipList();
	SET_EQUIP_LIST(eqpSet, eqpList, PC_COMPARE_SET_ICON);

	

	local OTHERPCJOBS = {}

	for i = 0, jobhistory:GetJobHistoryCount()-1 do
		local tempjobinfo = jobhistory:GetJobHistory(i);

		if OTHERPCJOBS[tempjobinfo.jobID] == nil then
			OTHERPCJOBS[tempjobinfo.jobID] = tempjobinfo.grade;
		else
			if tempjobinfo.grade > OTHERPCJOBS[tempjobinfo.jobID] then
				OTHERPCJOBS[tempjobinfo.jobID] = tempjobinfo.grade;
			end
		end
	end

	local classGbox = GET_CHILD(frame,"groupbox_3","ui::CGroupBox");
	classGbox:ShowWindow(1)

	DESTROY_CHILD_BYNAME(classGbox,"classCtrl_")
	
	local clsindex = 0
	for jobid, grade in pairs(OTHERPCJOBS) do
		local x = clsindex%3 * 150
		local y = math.floor(clsindex/3) * 160

		local cls = GetClassByTypeFromList(clslist, jobid);
		local classCtrl = classGbox:CreateOrGetControlSet('classtreeIcon', 'classCtrl_'..cls.ClassName, x+20, y+10);
		
		local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
		classSlot:EnableHitTest(0)
		
		local selectedarrowPic = GET_CHILD(classCtrl, "selectedarrow", "ui::CPicture");
		selectedarrowPic:ShowWindow(0)

		local icon = CreateIcon(classSlot);
		local iconname = cls.Icon;
		icon:SetImage(iconname);

		-- 클래스 이름
		local nameCtrl = GET_CHILD(classCtrl, "name", "ui::CRichText");
		nameCtrl:SetText("{@st41}".. cls.Name);

		-- 클래스 레벨 (★로 표시)
		local levelCtrl = GET_CHILD(classCtrl, "level", "ui::CRichText");
		local levelFont = frame:GetUserConfig("Font_Normal");
		
		local startext = ""
		for i = 1 , 3 do
			if i <= grade then
				startext = startext ..('{img star_in_arrow 20 20}')
			else
				startext = startext ..('{img star_out_arrow 20 20}')
			end
		end

		levelCtrl:SetText(startext);

		clsindex = clsindex + 1
	end


	local achieveGbox = GET_CHILD(frame,"groupbox_4","ui::CGroupBox");
	achieveGbox:ShowWindow(1)

	local achieveCountRtxt = GET_CHILD(achieveGbox,"achieveCount","ui::CGroupBox");
	achieveCountRtxt:SetTextByKey("count",otherpcinfo.achieveCount)
	
	local achieveGbox_sub = GET_CHILD(achieveGbox,"groupbox_4_sub","ui::CGroupBox");

	DESTROY_CHILD_BYNAME(achieveGbox_sub, "achieve_");
	local achiclslist, ahicnt  = GetClassList("Achieve");
	
	for i = 0, otherpcinfo.achieveCount-1 do 
		local achieve = otherpcinfo:GetAchieve(i)
		local nowachicls = GetClassByTypeFromList(achiclslist, achieve);
		local y = i * 30
		local achitext = achieveGbox_sub:CreateOrGetControl("richtext", "achieve_" .. i, 15, y+10, 300, 30);
		achitext:SetFontName("white_18_ol")
		achitext:SetText(nowachicls.DescTitle)
	end
	
	frame:Invalidate();
	frame:SetUserValue("VIEWAID", otherpcinfo:GetAID());

end

function UPDATE_LIKEIT_COUNT(aid, count)

	local frame = ui.GetFrame("compare");
	local nowaid = frame:GetUserValue("VIEWAID");

	if aid == nowaid then
		local likeitCount = GET_CHILD_RECURSIVELY(frame,"likeitCount")
		likeitCount:SetTextByKey("count",count)
		frame:Invalidate();
	end

end

function COMPARE_TAB_CHANGE(parent, tab)
	local frame = parent:GetTopParentFrame();
	local tab = GET_CHILD_RECURSIVELY(parent, "itembox", "ui::CTabControl");
	if tab:GetSelectItemName() == "history" then

		local viewAID = frame:GetUserValue("VIEWAID");
		--geClientInteraction.RequestHistory(viewAID, 0);

		local his_box_bg = GET_CHILD_RECURSIVELY(frame,"his_box_bg");
		his_box_bg:ShowWindow(1)

		local groupbox2 = frame:GetChild("groupbox_2");
		local groupbox3 = frame:GetChild("groupbox_3");
		local groupbox4 = frame:GetChild("groupbox_4");
		groupbox2:ShowWindow(0)
		groupbox3:ShowWindow(0)
		groupbox4:ShowWindow(0)
		
	else

		local groupbox2 = frame:GetChild("groupbox_2");
		local groupbox3 = frame:GetChild("groupbox_3");
		local groupbox4 = frame:GetChild("groupbox_4");
		groupbox2:ShowWindow(1)
		groupbox3:ShowWindow(1)
		groupbox4:ShowWindow(1)

		local his_box_bg = GET_CHILD_RECURSIVELY(frame,"his_box_bg");
		his_box_bg:ShowWindow(0)

	end
	
end

function COMPARE_RELATED_HISTORY(frame, msg, aid, page)


	
	local groupbox = frame:GetChild("groupbox_1");
	--local queue = groupbox:GetChild("info_box");
	local tab = GET_CHILD_RECURSIVELY(frame, "itembox");
	
	local tabIndex = tab:GetIndexByName("history");
	tab:SelectTab(tabIndex);
	local his_box_bg = GET_CHILD_RECURSIVELY(frame,"his_box_bg");
	local his_box = GET_CHILD_RECURSIVELY(frame, "his_box");

	local lastAID = his_box:GetUserValue("LAST_AID");
	if lastAID ~= aid then
		DESTROY_CHILD_BYNAME(his_box, "HIS_");
		his_box:SetUserValue("MAX_PAGE", 0);
	end
	
	his_box:SetUserValue("LAST_AID", aid);
	local maxPage = his_box:GetUserIValue("MAX_PAGE");
	if page > maxPage then
		his_box:SetUserValue("MAX_PAGE", page);
	end

	local pcInfo = geClientInteraction.GetRelatedPCByAID(aid);
	if pcInfo == nil then
		return;
	end
	
	
	local cnt = pcInfo:GetHistoryCount();
	for i = 0 , cnt - 1 do
		local historyInfo = pcInfo:GetHistoryByIndex(i);
		local set = his_box:CreateOrGetControlSet("compare_history", "HIS_" .. historyInfo.totalSeq, ui.LEFT, ui.TOP, 50, 0, 0, 0);
		local txtCtrl = set:GetChild("txt");
		local mapCls = GetClassByType("Map", historyInfo.mapID);
		if mapCls ~= nil then

			local text = ClMsg(GetInteractionTypeStr(historyInfo.type));
			text = text .. " (" .. GET_YMDHM_BY_SYSTIME(historyInfo:GetTime());
			text = text .. ") - " .. mapCls.Name;

			txtCtrl:SetTextByKey("text", text);
		end
	end

	his_box:SortChilds(true);
	GBOX_AUTO_ALIGN(his_box, 10, 0, 10, true, false);
	his_box:UpdateData();

	his_box:SetCurLine(0);
	his_box:InvalidateScrollBar();
	frame:Invalidate()

end

function SCROLL_COMPARE_HISTORY(frame, ctrl, str, scrollValue)
	
	if ctrl:GetClassName() ~= "groupbox" then
		return;
	end

	frame = frame:GetTopParentFrame();

	local groupbox = tolua.cast(ctrl, "ui::CGroupBox");
	local curEndPos = scrollValue + groupbox:GetVisibleLineCount();
	local totalCnt = groupbox:GetLineCount();
	if curEndPos >= totalCnt then
		local viewAID = groupbox:GetUserValue("LAST_AID");
		local maxPage = groupbox:GetUserIValue("MAX_PAGE");
		--geClientInteraction.RequestHistory(viewAID, maxPage + 1);
	end

end