

PARTYSEARCH_LAST_GBOX_SCROLL_POS = 0

function PARTY_SEARCH_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "UPDATE_PARTY_SEARCH_LIST");
	addon:RegisterOpenOnlyMsg("FOUND_PARTY_UPDATE", "UPDATE_PARTY_SEARCH_LIST");
	addon:RegisterMsg("RECOMMEND_MEMBER_LIST_UPDATE", "UPDATE_RECOMMEND_MEMBER_LIST");

end

function PARTY_SEARCH_OPEN(frame)
	
	INIT_PARTY_SEARCH_OPTION(frame)
	
	local partyNoteSearchEdit = GET_CHILD_RECURSIVELY(frame, "noteSearchEdit")
	local nowSearchKeyword = partyNoteSearchEdit:GetText();
	REQUEST_TO_FIND_PARTY_LIST(nowSearchKeyword)

	PARTYSEARCH_LAST_GBOX_SCROLL_POS = 0

	UPDATE_RECOMMEND_MEMBER_LIST(frame)

end

function PARTY_SEARCH_CLOSE(frame)
	
	ui.CloseFrame('party')

end

function RECOMMEND_MEMBER_LIST_UPDATE(frame, msg, str, num)

end

function UPDATE_PARTY_SEARCH_OPTION(frame, msg, str, num)

	local partyNoteSearchEdit = GET_CHILD_RECURSIVELY(frame, "noteSearchEdit")
	local nowSearchKeyword = partyNoteSearchEdit:GetText();
	
	local questOptList = GET_CHILD_RECURSIVELY(frame, "questOptList", "ui::CDropList");
	local quest_selecIndex = questOptList:GetSelItemIndex();

	config.ChangeXMLConfig("PartySearch_QuestShare", quest_selecIndex - 1);  -- 모두 보기 옵션때문에 -1 시킨다.
	
	local expOptList = GET_CHILD_RECURSIVELY(frame, "expOptList", "ui::CDropList");
	local exp_selecIndex = expOptList:GetSelItemIndex();

	config.ChangeXMLConfig("PartySearch_ExpShare", exp_selecIndex - 1); 

	local itemOptList = GET_CHILD_RECURSIVELY(frame, "itemOptList", "ui::CDropList");
	local item_selecIndex = itemOptList:GetSelItemIndex();

	config.ChangeXMLConfig("PartySearch_ItemShare", item_selecIndex - 1);

	local curValue = config.GetXMLConfig("UsePartySearchCondition");
	if curValue == 1 then
		REQUEST_TO_FIND_PARTY_LIST(nowSearchKeyword)
	end
	

end

function REQUEST_TO_FIND_PARTY_LIST(nowSearchKeyword)

	if nowSearchKeyword == nil then
		nowSearchKeyword = ""
	end

	if ui.GetPaperLength(nowSearchKeyword) > 0 and ui.GetPaperLength(nowSearchKeyword) < 2 then
		ui.SysMsg(ScpArgMsg("SearchKeywordMustLongerThen{LEN}","LEN",2));
		return;
	end

	local sendSearchKeyword = ""
	if ui.GetPaperLength(nowSearchKeyword) > 0 then
		sendSearchKeyword = nowSearchKeyword
	end
	
	local curValue = config.GetXMLConfig("UsePartySearchCondition");
	local UsePartySearchCondition = false
	if curValue == 1 then
		UsePartySearchCondition = true
	end

	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)

	local ctrlType = 0;
	if pcjobinfo.CtrlType == 'Warrior' then
		ctrlType = 1;
	elseif pcjobinfo.CtrlType == 'Wizard' then
		ctrlType = 2;
	elseif pcjobinfo.CtrlType == 'Archer' then
		ctrlType = 4;
	elseif pcjobinfo.CtrlType == 'Cleric' then
		ctrlType = 8;
	end

	party.RequestToFindPartyList(PARTY_NORMAL, UsePartySearchCondition, config.GetXMLConfig("PartySearch_ExpShare"), config.GetXMLConfig("PartySearch_ItemShare"), config.GetXMLConfig("PartySearch_QuestShare"), ctrlType,sendSearchKeyword);

end

function PARTYSEARCH_TAB_CHANGE()
end

function REFRESH_MEMBER_RECOMMEND_LIST(parent, ctrl)

	local pcparty = session.party.GetPartyInfo();
	
	if pcparty == nil then
		ui.SysMsg(ScpArgMsg("OnlyPartyLeader"));
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());

	if partyObj == nil then
		ui.SysMsg(ScpArgMsg("OnlyPartyLeader"));
		return;
	end 
	
	if session.loginInfo.GetAID() ~= pcparty.info:GetLeaderAID() then
		ui.SysMsg(ScpArgMsg("OnlyPartyLeader"));
		return;
	end

	local usePartyMatch = partyObj["UsePartyMatch"];
	
	if usePartyMatch ~= 1 then
		ui.SysMsg(ScpArgMsg("NeedTurnOnRecommend"));
		return;
	end

	party.RefreshMemberRecommendList();

	-- 연타 방지용 시간 제한 걸기
	ReserveScript("REFRESH_MEMBER_RECOMMEND_LIST_BTN_SET_ENABLE()", 3);
	ctrl:SetEnable(0)

end

function REFRESH_MEMBER_RECOMMEND_LIST_BTN_SET_ENABLE()

	local frame = ui.GetFrame("party_search")
	local btn = GET_CHILD_RECURSIVELY(frame,"refreshBtn")
	
	btn:SetEnable(1)
end

function MEMBER_RECOMMEND_INVITE_PARTY_SEARCH(frame, ctrl)

	local fname = frame:GetUserValue("RECOMMEND_FNAME");
	local recommendType = frame:GetUserValue("RECOMMEND_TYPE");

	party.ReqRecommendInvite(fname,recommendType);

end


function UPDATE_RECOMMEND_MEMBER_LIST(frame, ctrl, argStr, argNum)	

	local recommendcount = session.party.GetLastPartyMatchRecommendMemberCount();
	local mainGbox3 = GET_CHILD_RECURSIVELY(frame,'mainGbox3','ui::CGroupBox')
	local startYmargin = 3

	DESTROY_CHILD_BYNAME(mainGbox3, 'eachrecommendmember_');

	local pcparty = session.party.GetPartyInfo();
	

	local onlyEnableToLeader = GET_CHILD_RECURSIVELY(frame,"onlyEnableToLeader")
	onlyEnableToLeader:ShowWindow(0)

	local needTurnOnRecommend = GET_CHILD_RECURSIVELY(frame,"needTurnOnRecommend")
	needTurnOnRecommend:ShowWindow(0)

	if pcparty == nil then
		onlyEnableToLeader:ShowWindow(1)
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());

	if partyObj == nil then
		onlyEnableToLeader:ShowWindow(1)
		return;
	end 
	
	if session.loginInfo.GetAID() ~= pcparty.info:GetLeaderAID() then
		onlyEnableToLeader:ShowWindow(1)
		return;
	end

	local usePartyMatch = partyObj["UsePartyMatch"];
	
	if usePartyMatch ~= 1 then
		needTurnOnRecommend:ShowWindow(1)
		onlyEnableToLeader:ShowWindow(0)
		return;
	end

	for i =  0, recommendcount-1 do

		local ctrlheight = ui.GetControlSetAttribute('memberrecommend_info', 'height') 
		local set = mainGbox3:CreateOrGetControlSet('memberrecommend_info', 'eachrecommendmember_'..i, 0, startYmargin + ctrlheight*i);
		
		local otherpcinfo = session.party.GetLastPartyMatchRecommendMemberInfoByIndex(i);

		if otherpcinfo ~= nil and otherpcinfo.partyMatchMainReason ~= 0 then

			local imagename = nil
			imagename = ui.CaptureSomeonesFullStdImage(otherpcinfo:GetAppearance())	
			
			local charImage = GET_CHILD_RECURSIVELY(set,"shihouette");
			if imagename ~= nil then
				charImage:SetImage(imagename)
				charImage:ShowWindow(1)
			else
				charImage:ShowWindow(0)
			end

			local fnametext = GET_CHILD_RECURSIVELY(set,"fname")
			local fname		= otherpcinfo:GetAppearance():GetFamilyName()
			fnametext:SetText(fname);

			local cnametext = GET_CHILD_RECURSIVELY(set,"cname")
			local cname		= otherpcinfo:GetAppearance():GetName()
			cnametext:SetText(cname);

			local lvtext = GET_CHILD_RECURSIVELY(set,"lv")
			local lv		= otherpcinfo:GetAppearance():GetLv()
			lvtext:SetTextByKey("level",lv);

			local jobhistory = otherpcinfo.jobHistory;
			local nowjobinfo = jobhistory:GetJobHistory(jobhistory:GetJobHistoryCount()-1);
			local clslist, cnt  = GetClassList("Job");
			local nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
			local jobRank		= nowjobinfo.grade
			local gender		= otherpcinfo:GetAppearance():GetGender();
			local jobName		= GET_JOB_NAME(nowjobcls, gender)
			local jobtext = GET_CHILD_RECURSIVELY(set,"job")
			jobtext:SetTextByKey("jobname",jobName);
			jobtext:SetTextByKey("jobrank",jobRank);

			set:SetUserValue("RECOMMEND_TYPE",otherpcinfo.partyMatchMainReason);
			set:SetUserValue("RECOMMEND_FNAME", fname);


			local mapUIName = GetClassByType("Map", otherpcinfo.mapID).Name;
			local maptext = GET_CHILD_RECURSIVELY(set,"mapname")
			maptext:SetTextByKey("map",mapUIName);
			maptext:SetTextByKey("channel",otherpcinfo.channel+1);


			local description = GET_CHILD_RECURSIVELY(set,"description")
			local matchmakerCls = GetClassByType("PartyMatchMaker",otherpcinfo.partyMatchMainReason)

			description:SetText(matchmakerCls.RecommendMent)
		end

	end

	mainGbox3:SetScrollPos(0)

	frame:Invalidate()
end

function UPDATE_PARTY_SEARCH_LIST(frame, msg, str, page)

	local foundpartylist = session.party.GetFoundPartyList(PARTY_NORMAL);
	local listcount = foundpartylist:Count()

	local mainGbox = GET_CHILD_RECURSIVELY(frame,'mainGbox','ui::CGroupBox')
	local mainGbox2 = GET_CHILD_RECURSIVELY(frame,'mainGbox2','ui::CGroupBox')
	local partyTab = GET_CHILD_RECURSIVELY(frame, 'itembox')
	local nowtab = partyTab:GetSelectItemIndex();

	
	if nowtab == 0 then
	end
	
	local MARGIN_PARTYLIST_START = frame:GetUserConfig("MARGIN_PARTYLIST_START")
	local startYmargin = MARGIN_PARTYLIST_START

	if page < 1 then
		page = 1
	end

	if page == 1 then
		DESTROY_CHILD_BYNAME(mainGbox2, 'foundpartylist_');
	end

	for i = (page-1)*3 , listcount-1 do

		local ctrlheight = ui.GetControlSetAttribute('partyfound_info2', 'height') + 5;
		local set = mainGbox2:CreateOrGetControlSet('partyfound_info2', 'foundpartylist_'..i, 0, startYmargin + ctrlheight*i);
		if foundpartylist:Element(i) == nil then
			break;
		end
		local eachpartyinfo = foundpartylist:Element(i).partyInfo

		local eachpartymemberlist = foundpartylist:Element(i):GetMemberList()
		
		local ppartyobj = eachpartyinfo:GetObject();
		local partyObj = GetIES(ppartyobj);

		-- 파티 이름
		--[[
		local nameTxt = GET_CHILD(set,'name')
		nameTxt:SetTextByKey('name',eachpartyinfo.info.name)
		]]--

		-- 파티 설명
		local noteTxt = GET_CHILD(set,'note')
		noteTxt:SetTextByKey('note',partyObj["Note"])

		-- 찾는 직업 세팅
		local curClassType = partyObj["RecruitClassType"];

		local num = curClassType
		local calcresult={}
		local k = 0
	
		while num > 0 do 
		
			calcresult[k] = num%2
			num = math.floor(num/2)
			k = k + 1
			if num < 1 then
				break;
			end
		end

		local findclassstr = ""

		if calcresult[0] == 1 then -- 전사
			findclassstr = findclassstr .. ScpArgMsg('JustWarrior')
		end
		if calcresult[1] == 1 then -- 법사
			if findclassstr ~= "" then
				findclassstr = findclassstr .. ' / '
			end
			findclassstr = findclassstr .. ScpArgMsg('JustWizard')
		end
		if calcresult[2] == 1 then -- 궁수
			if findclassstr ~= "" then
				findclassstr = findclassstr .. ' / '
			end
			findclassstr = findclassstr .. ScpArgMsg('JustArcher')
		end
		if calcresult[3] == 1 then -- 클레릭
			if findclassstr ~= "" then
				findclassstr = findclassstr .. ' / '
			end
			findclassstr = findclassstr .. ScpArgMsg('JustCleric')
		end
		--[[
		local findClassTxt = GET_CHILD(set,'findClass','ui::CRichText')
		findClassTxt:SetTextByKey('findClass',findclassstr)
		]]--
		--[[
		-- 퀘스트 공유 옵션 세팅
		local questPolicyTxt = GET_CHILD(set,'questPolicy','ui::CRichText')
		if partyObj["IsQuestShare"] == 1 then
			questPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchQuestOpt2"))
		else
			questPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchQuestOpt1"))
		end
		]]--
		--[[
		-- 경험치 공유 옵션 세팅
		local expPolicyTxt = GET_CHILD(set,'expPolicy','ui::CRichText')
		if partyObj["ExpGainType"] == 0 then
			expPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchExpOpt1"))
		elseif partyObj["ExpGainType"] == 1 then
			expPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchExpOpt2"))
		else
			expPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchExpOpt3"))
		end
		]]--
		--[[
		-- 아이템 분배 규칙 옵션 세팅
		local itemPolicyTxt = GET_CHILD(set,'itemPolicy','ui::CRichText')
		if partyObj["ItemRouting"] == 0 then
			itemPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchItemOpt1"))
		elseif partyObj["ItemRouting"] == 1 then
			itemPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchItemOpt2"))
		else
			itemPolicyTxt:SetTextByKey('isuse',ScpArgMsg("PartySearchItemOpt3"))
		end		
		]]--

		-- 파티원 정보 표시
		--DESTROY_CHILD_BYNAME(set, 'foundeachmember_');

		local avglevel = 0;
		local loginMemberCnt = 0
		local partyMemberCnt = eachpartymemberlist:Count();
		local joinParty = GET_CHILD(set,'joinParty')
		local leaderAid = eachpartyinfo.info:GetLeaderAID();
		joinParty:SetEventScript(ui.LBUTTONDOWN, 'LCLICK_PARTY_LIST');
		joinParty:SetEventScriptArgString(ui.LBUTTONDOWN, eachpartyinfo.info.leaderName );
		for j = 0 , partyMemberCnt - 1 do

			local eachpartymember = eachpartymemberlist:Element(j);
			avglevel = avglevel + eachpartymember:GetLevel();
			loginMemberCnt = loginMemberCnt + 1;
			--[[
			local memberinfoset = set:CreateOrGetControlSet('partyfound_member_info', 'foundeachmember_'..j, 5+(j*127), 180);
			
			local joblv = eachpartymember:GetIconInfo().joblv			
			local name_text = GET_CHILD(memberinfoset,'name_text','ui::CRichText')			
			local familyname_text = GET_CHILD(memberinfoset,'familyname_text','ui::CRichText')
			familyname_text:SetTextByKey('fname',eachpartymember:GetName())

			local level_text = GET_CHILD_RECURSIVELY(memberinfoset,'level_text','ui::CRichText')			
			local leaderMark = GET_CHILD(memberinfoset, "leader_img", "ui::CPicture");

			if eachpartyinfo.info:GetLeaderAID() == eachpartymember:GetAID() then

				if eachpartyinfo.info.isCorsairType == true then
					leaderMark:SetImage('party_corsair_mark');
				else
					leaderMark:SetImage('party_leader_mark');
				end

			else
				leaderMark:SetImage('None_Mark');
			end

			local jobportraitImg = GET_CHILD(memberinfoset, "jobportrait", "ui::CPicture");
			

			if geMapTable.GetMapName(eachpartymember:GetMapID()) ~= 'None' then			 

				local imgName = ui.CaptureModelHeadImage_IconInfo(eachpartymember:GetIconInfo());		
				jobportraitImg:SetImage(imgName);
				
				level_text:SetTextByKey('lv',eachpartymember:GetLevel())

				local givenname = eachpartymember:GetIconInfo():GetGivenName()
				name_text:SetTextByKey('name',givenname)

				avglevel = avglevel + eachpartymember:GetLevel()
				loginMemberCnt = loginMemberCnt + 1

				set:SetEventScript(ui.LBUTTONDOWN, 'LCLICK_PARTY_LIST')
				set:SetEventScriptArgString(ui.LBUTTONDOWN, eachpartymember:GetName());

				memberinfoset:SetEventScript(ui.LBUTTONDOWN, 'LCLICK_EACH_MEMBERINFO')
				memberinfoset:SetEventScriptArgString(ui.LBUTTONDOWN, eachpartymember:GetName());

			else
				local color = "FF555555";

				level_text:SetTextByKey('lv','Out')
				jobportraitImg:SetImage('');
				name_text:SetTextByKey('name','')

				name_text:SetColorTone(color);
				familyname_text:SetColorTone(color);
				level_text:SetColorTone(color);
				leaderMark:SetColorTone(color);
				jobportraitImg:SetColorTone(color);
			end
				]]--
		end

		avglevel = math.floor( avglevel / loginMemberCnt );

		-- 파티 평균 레벨
		local avgLevelTxt = GET_CHILD(set,'avgLevel','ui::CRichText');
		avgLevelTxt:SetTextByKey('avglv',avglevel);
		
		local numberNmax = GET_CHILD(set,'numberNmax','ui::CRichText');
		numberNmax:SetTextByKey('maxCnt',partyMemberCnt);
		
		set:SetTooltipType("partyinfotooltipNormal");
		set:SetTooltipArg("", i)

	end

	if page == 1 then
		mainGbox2:SetScrollPos(0)
	end

	mainGbox2:SetEventScript(ui.SCROLL, "SCROLL_PARTY_SEARCH_GBOX");
	frame:Invalidate()

end

function SCROLL_PARTY_SEARCH_GBOX(parent, ctrl, str, wheel)

	if wheel == ctrl:GetScrollBarMaxPos() and PARTYSEARCH_LAST_GBOX_SCROLL_POS ~= ctrl:GetScrollBarMaxPos() then
		party.RequestToFindPartyList_NextPage();
		PARTYSEARCH_LAST_GBOX_SCROLL_POS = ctrl:GetScrollBarMaxPos()
	end
	
end


function INIT_PARTY_SEARCH_OPTION(frame)

	local questOptList = GET_CHILD_RECURSIVELY(frame, "questOptList", "ui::CDropList");
	questOptList:ClearItems();

	questOptList:AddItem(0, ScpArgMsg('PartyShowAll'));
	questOptList:AddItem(1, ScpArgMsg('PartySearchQuestOpt1'));
	questOptList:AddItem(2, ScpArgMsg('PartySearchQuestOpt2'));
	questOptList:SelectItem(config.GetXMLConfig("PartySearch_QuestShare") + 1)

	local expOptList = GET_CHILD_RECURSIVELY(frame, "expOptList", "ui::CDropList");
	expOptList:ClearItems();
	expOptList:AddItem(0, ScpArgMsg('PartyShowAll'));
	expOptList:AddItem(1, ScpArgMsg('PartySearchExpOpt1'));
	expOptList:AddItem(2, ScpArgMsg('PartySearchExpOpt2'));
	expOptList:AddItem(3, ScpArgMsg('PartySearchExpOpt3'));
	expOptList:SelectItem(config.GetXMLConfig("PartySearch_ExpShare") + 1)

	local itemOptList = GET_CHILD_RECURSIVELY(frame, "itemOptList", "ui::CDropList");
	itemOptList:ClearItems();
	itemOptList:AddItem(0, ScpArgMsg('PartyShowAll'));
	itemOptList:AddItem(1, ScpArgMsg('PartySearchItemOpt1'));
	itemOptList:AddItem(2, ScpArgMsg('PartySearchItemOpt2'));
	itemOptList:AddItem(3, ScpArgMsg('PartySearchItemOpt3'));
	itemOptList:SelectItem(config.GetXMLConfig("PartySearch_ItemShare") + 1)
	
end

function LCLICK_EACH_MEMBERINFO(frame, ctrl, familyName, argNum)	

	local pcparty = session.party.GetPartyInfo();

	if pcparty == nil then
		party.ReqMemberDetailInfo(familyName)
	end

end

function LCLICK_PARTY_LIST(frame, ctrl, familyName, argNum)	

	-- 내가 이미 파티에 가입되어있는지 확인 후 없을때만 요청.
	if session.party.GetPartyInfo() ~= nil then
		ui.SysMsg(ClMsg('HadMyParty'));
		return;
	end

	local str = ScpArgMsg("AreYouWantReqJoinTheParty");
	local yesScp = string.format("REQUEST_JOIN_FOUND_PARTY(\"%s\")", familyName);
	ui.MsgBox(str, yesScp, "None");

end

function REQUEST_JOIN_FOUND_PARTY(familyName)

	if familyName ~= nil and familyName ~= "" then
		party.ReqInviteMe(familyName)
	end
	ui.CloseFrame('party_search');

end