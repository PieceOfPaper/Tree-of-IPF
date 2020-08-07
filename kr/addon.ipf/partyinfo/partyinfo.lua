local json = require "json_imc"
function PARTYINFO_ON_INIT(addon, frame)
	addon:RegisterMsg("PARTY_UPDATE", "ON_PARTYINFO_UPDATE");
	addon:RegisterMsg("PARTY_BUFFLIST_UPDATE", "ON_PARTYINFO_BUFFLIST_UPDATE");
	addon:RegisterMsg("PARTY_INST_UPDATE", "ON_PARTYINFO_INST_UPDATE");
	addon:RegisterMsg("PARTY_OUT", "ON_PARTYINFO_DESTROY");
	addon:RegisterMsg("PARTY_INVITE_CANCEL", "ON_PARTY_INVITE_CANCEL");
	addon:RegisterMsg("GAME_START", "PARTYINFO_CONTROL_INIT");
end

function PARTYINFO_CONTROL_INIT()
	local frame = ui.GetFrame("partyinfo"); -- party member info frame
	local summonsUI = ui.GetFrame("summonsinfo"); -- summon monster info frame
	local button = GET_CHILD_RECURSIVELY(frame, "partyinfobutton"); -- toggle button
	local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	local title_gbox = GET_CHILD_RECURSIVELY(frame, "titlegbox");

	if IS_NEED_SUMMON_UI() == 0 then
		if title_gbox ~= nil and button ~= nil and buttonText ~= nil then
			title_gbox:EnableDrawFrame(1);
			button:SetVisible(0);
			buttonText:SetVisible(1);
		end
	elseif IS_NEED_SUMMON_UI() == 1 and summonsUI ~= nil and summonsUI:IsVisible() then
		if button ~= nil and buttonText ~= nil then
			button:SetVisible(0);
			buttonText:SetVisible(0);
		end
	end

	local hotkey = summonsUI:GetUserConfig("SUMMONINFO_HOTKEY_TEXT");
	SUMMONSINFO_BUTTON_TOOLTIP_CHANGE(hotkey);
	if button ~= nil then
		if hotkey ~= nil and hotkey ~= "" then
			button:SetTextTooltip(ClMsg("SummonsInfo_ConvertSummonsInfo_ToolTip").."( "..hotkey.." )");
		end
		button:EnableHitTest(1);
	end
	
	if buttonText ~= nil then
		buttonText:SetTextByKey("title", ClMsg("SummonsInfo_PartyInfo"));
	end

	PARTYINFO_SET_POS(frame);
end

function PARTYINFO_SET_POS(frame)
	if frame ~= nil then
		local pos = ui.GetCatchMovePos(frame:GetName());
		if pos.x == 0 and pos.y == 0 then
			return;
		end

		frame:MoveFrame(pos.x, pos.y);

		local summonsInfoFrame = ui.GetFrame("summonsinfo");
		if summonsInfoFrame ~= nil then
			SUMMONSINFO_SET_POS(summonsInfoFrame, pos.x, pos.y);
		end
	end
end

function PARTYINFO_BUTTON_UI_CHECK(isVisible)
	local frame = ui.GetFrame("partyinfo");
	if frame == nil then
		return; 
	end

	local title_gbox = GET_CHILD_RECURSIVELY(frame, "titlegbox");
	local button = GET_CHILD_RECURSIVELY(frame, "partyinfobutton");
	local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	if title_gbox ~= nil and button ~= nil and buttonText ~= nil then
		title_gbox:EnableDrawFrame(isVisible);
		button:SetVisible(isVisible);
		buttonText:SetVisible(isVisible);
	end
end

function ON_PARTYINFO_INST_UPDATE(frame, msg, argStr, argNum)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return;
	end
	
	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();

	local myAid = session.loginInfo.GetAID();
	-- 접속중 파티원
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetMapID() > 0 then
			local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. partyMemberInfo:GetAID());
			if partyInfoCtrlSet ~= nil then
				UPDATE_PARTY_INST_SET(partyInfoCtrlSet, partyMemberInfo);	
				local lvbox = partyInfoCtrlSet:GetChild('lvbox');
				local levelObj = partyInfoCtrlSet:GetChild('lvbox');
				local levelRichText = tolua.cast(levelObj, "ui::CRichText");
				local level = partyMemberInfo:GetLevel();	
				levelRichText:SetTextByKey("lv", level);
				lvbox:Resize(levelRichText:GetWidth(), lvbox:GetHeight());		
			end
		end
	end	
	ON_PARTYINFO_BUFFLIST_UPDATE(frame);
end

function ON_PARTYINFO_UPDATE(frame, msg, argStr, argNum)
	local summonsinfo = ui.GetFrame("summonsinfo");
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
		frame:ShowWindow(0);

		if summonsinfo ~= nil then
			SUMMONSINFO_TOGGLE_BUTTON(summonsinfo, 0)
		end

		local button = GET_CHILD_RECURSIVELY(summonsinfo, "summonsinfobutton");
		if button ~= nil then
			button:SetVisible(0);
			button:EnableHitTest(0);
			button:SetTextTooltip("");
		end
		return;
	end

	frame:ShowWindow(1);
	frame:SetVisible(1);
	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	local memberIndex = 0;
	local myAid = session.loginInfo.GetAID();	
    local partyID = pcparty.info:GetPartyID();

	for i = 0, count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetAID() ~= myAid then
			local ret = nil;		
			-- 접속중 파티원
			if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then
				ret = SET_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType, false, partyID);
			else-- 접속안한 파티원
				ret = SET_LOGOUT_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, false, partyInfo:GetLeaderAID(), pcparty.isCorsairType, partyID);
			end
		else -- 내정본데
			local headsup = ui.GetFrame("headsupdisplay");
			local leaderMark = GET_CHILD(headsup, "Isleader", "ui::CPicture");
			if partyInfo:GetLeaderAID() ~= myAid then-- 만약 내가 아니면
				leaderMark:SetImage('None_Mark');
			else
				leaderMark:SetImage('party_leader_mark');
			end
		end
	end	

	for i = 0, frame:GetChildCount() - 1 do
		local ctrlSet = frame:GetChildByIndex(i);
		if nil ~= ctrlSet then
			local ctrlSetName = ctrlSet:GetName();
			if string.find(ctrlSetName, "PTINFO_") ~= nil then
				local aid = string.sub(ctrlSetName, 8, string.len(ctrlSetName));
				local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, aid);
				if memberInfo == nil then
					frame:RemoveChildByIndex(i);
					i = i - 1;
				end
			end
		end
	end
	-- DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
	PARTYINFO_CONTROLSET_AUTO_ALIGN(frame);
	frame:Invalidate();

	-- invite party member visible check
	if summonsinfo:IsVisible() == 1 then
		frame:SetVisible(0);
		local button = GET_CHILD_RECURSIVELY(summonsinfo, "summonsinfobutton");
		local hotkey = summonsinfo:GetUserConfig("SUMMONINFO_HOTKEY_TEXT");
		if button ~= nil then
			button:SetVisible(1);
			if hotkey ~= nil and hotkey ~= "" then
				button:SetTextTooltip(ClMsg("SummonsInfo_ConvertPartyInfo_ToolTip").."( "..hotkey.." )");
			end
			button:EnableHitTest(1);
			CHANGE_BUTTON_TITLE(summonsinfo, ClMsg("SummonsInfo_SummonsInfo"));
			summonsinfo:Invalidate();
		end
	end
end

function IS_PARTY_INFO_SHOWICON(showIcon)
	if showIcon == nil then
		return false
	elseif showIcon == "FALSE" then
		return false
	elseif showIcon == "ONLYMYPC" then
		 -- 파티정보이므로 표시하지 않음.
		return false
	end

	return true
end

function ON_PARTYINFO_BUFFLIST_UPDATE(frame)
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		DESTROY_CHILD_BYNAME(frame, 'PTINFO_');
		frame:ShowWindow(0);
		return;
	end

	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(0);
	local count = list:Count();
	local memberIndex = 0;

	local myInfo = session.party.GetMyPartyObj();
	-- 접속중 파티원 버프리스트
	for i = 0, count - 1 do
		local partyMemberInfo = list:Element(i);
				if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then

			local buffCount = partyMemberInfo:GetBuffCount();
			local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. partyMemberInfo:GetAID());
			if partyInfoCtrlSet ~= nil then
				local buffListSlotSet = GET_CHILD(partyInfoCtrlSet, "buffList", "ui::CSlotSet");
				local debuffListSlotSet = GET_CHILD(partyInfoCtrlSet, "debuffList", "ui::CSlotSet");

				-- 초기화
				for j = 0, buffListSlotSet:GetSlotCount() - 1 do
					local slot = buffListSlotSet:GetSlotByIndex(j);
					slot:SetKeyboardSelectable(false);
					if slot == nil then
						break;
					end
					slot:ShowWindow(0);
				end
				
				for j = 0, debuffListSlotSet:GetSlotCount() - 1 do
					local slot = debuffListSlotSet:GetSlotByIndex(j);
					if slot == nil then
						break;
					end
					slot:ShowWindow(0);				
				end

				-- 아이콘 셋팅
				if buffCount <= 0 then
					partyMemberInfo:ResetBuff();
					buffCount = partyMemberInfo:GetBuffCount();
				end

				if buffCount > 0 then
					local buffIndex = 0;
					local debuffIndex = 0;
					for j = 0, buffCount - 1 do	
						local buffID = partyMemberInfo:GetBuffIDByIndex(j);
						local cls = GetClassByType("Buff", buffID);	
							if cls ~= nil and IS_PARTY_INFO_SHOWICON(cls.ShowIcon) == true and cls.ClassName ~= "TeamLevel" then
							local buffOver = partyMemberInfo:GetBuffOverByIndex(j);
							local buffTime = partyMemberInfo:GetBuffTimeByIndex(j);							
							local slot = nil;
							if cls.Group1 == 'Buff' then
								slot = buffListSlotSet:GetSlotByIndex(buffIndex);
								buffIndex = buffIndex + 1;
							
							elseif cls.Group1 == 'Debuff' then
								slot = debuffListSlotSet:GetSlotByIndex(debuffIndex);
								debuffIndex = debuffIndex + 1;
							end
														
							if slot ~= nil then
								local icon = slot:GetIcon();
								if icon == nil then
									icon = CreateIcon(slot);
								end

								local handle = 0;
								if myInfo ~= nil then
									if myInfo:GetMapID() == partyMemberInfo:GetMapID() and myInfo:GetChannel() == partyMemberInfo:GetChannel() then
										handle  = partyMemberInfo:GetHandle();
									end
								end

								handle = tostring(handle);
								icon:SetDrawCoolTimeText( math.floor(buffTime/1000) );
								icon:SetTooltipType('buff');
								icon:SetTooltipArg(handle, buffID, "");

								local imageName = 'icon_' .. cls.Icon;
								icon:Set(imageName, 'BUFF', buffID, 0);

								if buffOver > 1 then
									slot:SetText('{s13}{ol}{b}'..buffOver, 'count', ui.RIGHT, ui.BOTTOM, 1, 2);
								else
									slot:SetText("");
								end

								slot:ShowWindow(1);
							end
						end					
					end
				end
			end
		end
	end
end

function OPEN_PARTY_INFO()
	ui.ToggleFrame("party");
end

function POST_OUT_PARTY()
    if session.GetCurrentMapProp():GetUsePartyOut() == "NO" then
		ui.SysMsg(ScpArgMsg("ThatMapCannotPartyOut"));
		return;
	end

	-- 통합매칭 파티 입장 신청 중에는 파티 탈퇴 못함
	local indunenter = ui.GetFrame('indunenter');
	if indunenter ~= nil and indunenter:IsVisible() == 1 and indunenter:GetUserValue('WITHMATCH_MODE') == 'YES' then
		ui.SysMsg(ScpArgMsg("CannotPartyOutDuringMatching"));
		return;
	end

    packet.ReqPartyOut()
	
	local headsup = ui.GetFrame("headsupdisplay");
	local leaderMark = GET_CHILD(headsup, "Isleader", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
end

function OUT_PARTY()
    local buff = 'ChallengeMode_Player'
    local pc = GetMyPCObject()
    if IsBuffApplied(pc, buff) == 'YES' then
        local yesScp = "POST_OUT_PARTY()"
	    ui.MsgBox(ScpArgMsg("ReallyWantToPartyForChallengeMode"), yesScp, "None");
    else
        POST_OUT_PARTY()
    end
end

function BAN_PARTY_MEMBER(name)
	ui.Chat("/partyban " .. PARTY_NORMAL.. " " .. name);	
end

function GIVE_PARTY_LEADER(name)
	if session.GetCurrentMapProp():GetUsePartyOut() == "NO" then
		ui.SysMsg(ScpArgMsg("ThatMapCannotChangePartyLeader"));
		return;
	end
	
	ui.Chat("/partyleader " .. name);

	local contents_multiple = ui.GetFrame('contents_multiple')
	contents_multiple:ShowWindow(0)
end

function OPEN_PARTY_MEMBER_INFO(handle)
	ui.PropertyCompare(handle, 1);
end

function CONTEXT_PARTY(frame, ctrl, aid)	
	local myAid = session.loginInfo.GetAID();
	local pcparty = session.party.GetPartyInfo();
	local iamLeader = false;
	if pcparty.info:GetLeaderAID() == myAid then
		iamLeader = true;
	end

	local myInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, myAid);	
	local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, aid);	
	local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);
	if session.world.IsIntegrateServer() == true and session.world.IsIntegrateIndunServer() == false then
		local actor = GetMyActor();
		local execScp = string.format("ui.Chat(\"/changePVPObserveTarget %d 0\")", memberInfo:GetHandle());
		ui.AddContextMenuItem(context, ScpArgMsg("Observe{PC}", 'PC',memberInfo:GetName() ), execScp);
		ui.OpenContextMenu(context);
		return;
	end

	if aid == myAid then
		-- 1. 누구든 자기 자신.
		ui.AddContextMenuItem(context, ScpArgMsg("WithdrawParty"), "OUT_PARTY()");			
	elseif iamLeader == true then
		-- 2. 파티장이 파티원 우클릭
		-- 대화하기. 세부정보보기. 파티장 위임. 추방.
		ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", memberInfo:GetName()));	
		local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", memberInfo:GetName());
		ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
		ui.AddContextMenuItem(context, ScpArgMsg("ShowInfomation"), string.format("OPEN_PARTY_MEMBER_INFO(%d)", memberInfo:GetHandle()));	
		ui.AddContextMenuItem(context, ScpArgMsg("GiveLeaderPermission"), string.format("GIVE_PARTY_LEADER(\"%s\")", memberInfo:GetName()));	
		ui.AddContextMenuItem(context, ScpArgMsg("Ban"), string.format("BAN_PARTY_MEMBER(\"%s\")", memberInfo:GetName()));	
		
		if session.world.IsDungeon() and session.world.IsIntegrateIndunServer() == true then
			local aid = memberInfo:GetAID();
			local serverName = GetServerNameByGroupID(GetServerGroupID());
			local playerName = memberInfo:GetName();
			local scp = string.format("SHOW_INDUN_BADPLAYER_REPORT(\"%s\", \"%s\", \"%s\")", aid, serverName, playerName);
			ui.AddContextMenuItem(context, ScpArgMsg("IndunBadPlayerReport"), scp);
		end
	else
		-- 3. 파티원이 파티원 우클릭
		-- 대화하기. 세부 정보 보기.
		ui.AddContextMenuItem(context, ScpArgMsg("WHISPER"), string.format("ui.WhisperTo('%s')", memberInfo:GetName()));	
		local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", memberInfo:GetName());
		ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
		ui.AddContextMenuItem(context, ScpArgMsg("ShowInfomation"), string.format("OPEN_PARTY_MEMBER_INFO(%d)", memberInfo:GetHandle()));				
		
		if session.world.IsDungeon() and session.world.IsIntegrateIndunServer() == true then
			local aid = memberInfo:GetAID();
			local serverName = GetServerNameByGroupID(GetServerGroupID());
			local playerName = memberInfo:GetName();
			local scp = string.format("SHOW_INDUN_BADPLAYER_REPORT(\"%s\", \"%s\", \"%s\")", aid, serverName, playerName);
			ui.AddContextMenuItem(context, ScpArgMsg("IndunBadPlayerReport"), scp);
		end
	end
	
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);
end

function UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo)
	-- 파티원 hp / sp 표시 --
	local hpGauge = GET_CHILD(partyInfoCtrlSet, "hp", "ui::CGauge");
	local spGauge = GET_CHILD(partyInfoCtrlSet, "sp", "ui::CGauge");
	
	local stat = partyMemberInfo:GetInst();
	hpGauge:SetPoint(stat.hp, stat.maxhp);
	spGauge:SetPoint(stat.sp, stat.maxsp);

	local hpRatio = stat.hp / stat.maxhp;
	if  hpRatio <= 0.3 and hpRatio > 0 then
		hpGauge:SetBlink(0.0, 1.0, 0xffff3333); -- (duration, 주기, ?�상)
	else
		hpGauge:ReleaseBlink();
	end
end

function PARTY_HP_UPDATE(actor, partyMemberInfo)
	local frame = ui.GetFrame("partyinfo"); 
	if frame == nil then
		return;
	end
	local apc = actor:GetPCApc();
	local ctrlName = 'PTINFO_'.. apc:GetAID();
	local ctrlSet = frame:GetChild(ctrlName);
	if ctrlSet ~= nil then
		UPDATE_PARTYINFO_HP(ctrlSet, partyMemberInfo);
	end
end

function UPDATE_PARTY_INST_SET(partyInfoCtrlSet, partyMemberInfo)
	UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo);	
end

function SET_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, makeLogoutPC, leaderFID, isCorsairType, ispipui, partyID)
    if partyID ~= nil and partyMemberInfo ~= nil and partyID ~= partyMemberInfo:GetPartyID() then
        return nil;
    end

	local partyinfoFrame = ui.GetFrame('partyinfo')
	local FAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("FAR_MEMBER_FACE_COLORTONE")
	local NEAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("NEAR_MEMBER_FACE_COLORTONE")
	local FAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("FAR_MEMBER_NAME_FONT_COLORTAG")
	local NEAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("NEAR_MEMBER_NAME_FONT_COLORTAG")

	local mapName = geMapTable.GetMapName(partyMemberInfo:GetMapID());
	local partyMemberName = partyMemberInfo:GetName();
	
	local myHandle = session.GetMyHandle();
	local ctrlName = 'PTINFO_'.. partyMemberInfo:GetAID();
	if mapName == 'None' and makeLogoutPC == false then
		frame:RemoveChild(ctrlName);
		return nil;
	end	

	local partyInfoCtrlSet = frame:CreateOrGetControlSet('partyinfo', ctrlName, 10, count * 100);
		
	UPDATE_PARTYINFO_HP(partyInfoCtrlSet, partyMemberInfo);

	local leaderMark = GET_CHILD(partyInfoCtrlSet, "leader_img", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
	leaderMark:ShowWindow(0)
	-- 머리
	local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
	local nameObj = partyInfoCtrlSet:GetChild('name_text');
	local nameRichText = tolua.cast(nameObj, "ui::CRichText");	
	local hpGauge = GET_CHILD(partyInfoCtrlSet, "hp", "ui::CGauge");
	local spGauge = GET_CHILD(partyInfoCtrlSet, "sp", "ui::CGauge");
	
	if jobportraitImg ~= nil then
		local jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
		local iconinfo = partyMemberInfo:GetIconInfo();
		local jobCls  = GetClassByType("Job", iconinfo.repre_job)
		if nil ~= jobCls then
			jobIcon:SetImage(jobCls.Icon);
		end
			
		local partyMemberCID = partyInfoCtrlSet:GetUserValue("partyMemberCID")
		if partyMemberCID ~= nil and partyMemberCID ~= 0 and partyMemberCID ~= "None" then
			local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
			if jobportraitImg ~= nil then
				local jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
				local partyinfoFrame = ui.GetFrame("partyinfo");	
				PARTY_JOB_TOOLTIP(partyinfoFrame, partyMemberCID, jobIcon, jobCls, 1);  
					
				local partyFrame = ui.GetFrame('party');
				local gbox = partyFrame:GetChild("gbox");
				local memberlist = gbox:GetChild("memberlist");					
				PARTY_JOB_TOOLTIP(memberlist, partyMemberCID, jobIcon, jobCls, 1);            
			end;
		end

		local tooltipID = jobIcon:GetTooltipIESID();		
		if nil == tooltipID then	
			jobName = GET_JOB_NAME(jobCls, iconinfo.gender);	
			jobIcon:SetTextTooltip(jobName);
		end
		
		local stat = partyMemberInfo:GetInst();
		local pos = stat:GetPos();

		local dist = info.GetDestPosDistance(pos.x, pos.y, pos.z, myHandle);
		local sharedcls = GetClass("SharedConst",'PARTY_SHARE_RANGE');

		local mymapname = session.GetMapName();

		local partymembermapName = GetClassByType("Map", partyMemberInfo:GetMapID()).ClassName;
		local partymembermapUIName = GetClassByType("Map", partyMemberInfo:GetMapID()).Name;

		if ispipui == true then
			partyMemberName = ScpArgMsg("PartyMemberMapNChannel","Name",partyMemberName,"Mapname",partymembermapUIName,"ChNo",partyMemberInfo:GetChannel() + 1)
		end
				

		if dist < sharedcls.Value and mymapname == partymembermapName then
			jobportraitImg:SetColorTone(NEAR_MEMBER_FACE_COLORTONE)
			partyMemberName = NEAR_MEMBER_NAME_FONT_COLORTAG..partyMemberName;
			nameRichText:SetTextByKey("name", partyMemberName);
			hpGauge:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
			spGauge:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
		else
			jobportraitImg:SetColorTone(FAR_MEMBER_FACE_COLORTONE)
			partyMemberName = FAR_MEMBER_NAME_FONT_COLORTAG..partyMemberName;
			nameRichText:SetTextByKey("name", partyMemberName);
			hpGauge:SetColorTone(FAR_MEMBER_FACE_COLORTONE);
			spGauge:SetColorTone(FAR_MEMBER_FACE_COLORTONE);
		end

	end
		
	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "CONTEXT_PARTY");
	partyInfoCtrlSet:SetEventScriptArgString(ui.RBUTTONUP, partyMemberInfo:GetAID());

	if partyMemberInfo:GetAID() == leaderFID then
		leaderMark:ShowWindow(1)
		if isCorsairType == true then
			leaderMark:SetImage('party_corsair_mark');
		else
			leaderMark:SetImage('party_leader_mark');
		end
	end

	partyInfoCtrlSet:SetUserValue("MEMBER_NAME", partyMemberName);

	if hpGauge:GetStat() == 0 then
		hpGauge:AddStat("%v / %m");
		hpGauge:SetStatOffset(0, 0, -1);
		hpGauge:SetStatAlign(0, ui.CENTER_HORZ, ui.CENTER_VERT);
		hpGauge:SetStatFont(0, 'white_12_ol');
	end
	
	if spGauge:GetStat() == 0 then
		spGauge:AddStat("%v / %m");
		spGauge:SetStatOffset(0, 0, -1);
		spGauge:SetStatAlign(0, ui.CENTER_HORZ, ui.CENTER_VERT);
		spGauge:SetStatFont(0, 'white_12_ol');
	end

	-- 파티원 레벨 표시 -- 
	local lvbox = partyInfoCtrlSet:GetChild('lvbox');
	local levelObj = partyInfoCtrlSet:GetChild('lvbox');
	local levelRichText = tolua.cast(levelObj, "ui::CRichText");
	local level = partyMemberInfo:GetLevel();	
	levelRichText:SetTextByKey("lv", level);
	levelRichText:SetColorTone(NEAR_MEMBER_FACE_COLORTONE);
	lvbox:Resize(levelRichText:GetWidth(), lvbox:GetHeight());
		
	if frame:GetName() == 'partyinfo' then
		frame:Resize(frame:GetOriginalWidth(), count * partyInfoCtrlSet:GetHeight());
	else
		frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight());
	end
	
	return 1;
end

function SET_LOGOUT_PARTYINFO_ITEM(frame, msg, partyMemberInfo, count, makeLogoutPC, leaderFID, isCorsairType, partyID)
    if partyID ~= nil and partyMemberInfo ~= nil and partyID ~= partyMemberInfo:GetPartyID() then
        return nil;
    end

	local partyinfoFrame = ui.GetFrame('partyinfo')
	local FAR_MEMBER_FACE_COLORTONE = partyinfoFrame:GetUserConfig("FAR_MEMBER_FACE_COLORTONE")
	local FAR_MEMBER_NAME_FONT_COLORTAG = partyinfoFrame:GetUserConfig("FAR_MEMBER_NAME_FONT_COLORTAG")

	local mapName = geMapTable.GetMapName(partyMemberInfo:GetMapID());
	local partyMemberName = partyMemberInfo:GetName();

	local ctrlName = 'PTINFO_'.. partyMemberInfo:GetAID();
	local partyInfoCtrlSet = frame:CreateOrGetControlSet('partyinfo', ctrlName, 10, count * 60);
	
	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "None");
	AUTO_CAST(partyInfoCtrlSet);
		
	-- 파티원 hp / sp 표시 --
	local hpObject 				= partyInfoCtrlSet:GetChild('hp');
	local hpGauge 				= tolua.cast(hpObject, "ui::CGauge");
	local spObject 				= partyInfoCtrlSet:GetChild('sp');
	local spGauge 				= tolua.cast(spObject, "ui::CGauge");
	
	hpGauge:SetPoint(0, 0);
	spGauge:SetPoint(0, 0);
	
	local nameObj = partyInfoCtrlSet:GetChild('name_text');
	local nameRichText = tolua.cast(nameObj, "ui::CRichText");		
	nameRichText:SetTextByKey("name", FAR_MEMBER_NAME_FONT_COLORTAG .. partyMemberName);		
	partyInfoCtrlSet:SetUserValue("MEMBER_NAME", partyMemberName);

	local leaderMark = GET_CHILD(partyInfoCtrlSet, "leader_img", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
	leaderMark:ShowWindow(0)
	
	if partyMemberInfo:GetAID() == leaderFID then
		leaderMark:ShowWindow(1)
		if isCorsairType == true then
			leaderMark:SetImage('party_corsair_mark');
		else
			leaderMark:SetImage('party_leader_mark');
		end	
	end
				
	-- 머리
	local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
	if jobportraitImg ~= nil then
		jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
		local iconinfo = partyMemberInfo:GetIconInfo();
		local jobCls  = GetClassByType("Job", iconinfo.repre_job);
		if nil ~= jobCls then
			jobIcon:SetImage(jobCls.Icon);
		end
	end

	-- 파티원 레벨 표시 -- 
	local lvbox = partyInfoCtrlSet:GetChild('lvbox');
	local levelObj = partyInfoCtrlSet:GetChild('lvbox');
	local levelRichText = tolua.cast(levelObj, "ui::CRichText");
	levelRichText:SetTextByKey("lv", 'Out');
	lvbox:Resize(levelRichText:GetWidth(), lvbox:GetHeight());

	local color = FAR_MEMBER_FACE_COLORTONE
	jobportraitImg:SetColorTone(color);
	levelRichText:SetColorTone(color);
	hpGauge:SetColorTone(color);
	spGauge:SetColorTone(color);

	-- 파티 ContextMenu
	partyInfoCtrlSet:SetEventScript(ui.RBUTTONUP, "CONTEXT_PARTY");
	partyInfoCtrlSet:SetEventScriptArgString(ui.RBUTTONUP, partyMemberInfo:GetAID());

	frame:Resize(frame:GetWidth(), count * partyInfoCtrlSet:GetHeight());
	return 1;
end

-- party relation grade
PARTY_RELATION_VAN		= 0
PARTY_RELATION_NONE		= 1;
PARTY_RELATION_BASIC	= 2;
PARTY_RELATION_EXP		= 3;
PARTY_RELATION_QUEST	= 4;
PARTY_RELATION_EXP_QUEST= 5;
PARTY_RELATION_LEADER	= 6;
PARTY_RELATION_GUILD	= 7;

function ON_PARTYINFO_DESTROY(frame)
	frame:RemoveAllChild();	
	frame:ShowWindow(0);
end

-- ReqChangeRelation  reqType
PARTY_ADD_MEMBER = 0
PARTY_REQ_KICK = 1
PARTY_SHARE_EXP = 2
PARTY_SHARE_QUEST = 3
PARTY_DIST_LOCK = 4
PARTY_ADD_VANLIST = 5
PARTY_RELATION_INIT = 6

function PARTYMEMBER_JOIN(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_ADD_MEMBER);
end

function PARTYMEMBER_OUT(ctrlset, ctrl)
	if GetLayer(GetMyPCObject()) == 0 then
		local name = ctrlset:GetUserValue("MEMBER_NAME");
		party.ReqChangeRelation(name, PARTY_REQ_KICK);
	end
end

function PARTYMEMBER_EXP_SHARE(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");
	party.ReqChangeRelation(name, PARTY_SHARE_EXP);
end

function PARTYMEMBER_QUEST_SHARE(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");
	party.ReqChangeRelation(name, PARTY_SHARE_QUEST);
end

function PARTYMEMBER_LOCK(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_DIST_LOCK);
end

function PARTYMEMBER_VAN(ctrlset, ctrl)
	local name = ctrlset:GetUserValue("MEMBER_NAME");	
	party.ReqChangeRelation(name, PARTY_ADD_VANLIST);
end

function RECEIVE_PARTY_INVITE(partyType, inviterAid, familyName)
	local msg = "";
	if partyType == PARTY_NORMAL then
		msg = "{Inviter}InviteYouToParty_DoYouAccept?";
	else
		msg = "{Inviter}InviteYouToGuild_DoYouAccept?";
	end
	
	local str = ScpArgMsg(msg, "Inviter", familyName);
	local yesScp = string.format("party.AcceptInvite(%d, \"%s\", \"%s\", 0)", partyType, inviterAid, familyName);
	local noScp = string.format("party.CancelInvite(%d, \"%s\", 0)", partyType, familyName);
	ui.MsgBox(str, yesScp, noScp);
end

function RECEIVE_GUILD_INVITE(partyType, inviterAid, familyName, guildID)    
	local msg = "";
	msg = "{Inviter}InviteYouToGuild_DoYouAccept?";	
	local str = ScpArgMsg(msg, "Inviter", familyName);
	str = ui.ConvertScpArgMsgTag(str)

	local msgBox = ui.GetMsgBox(str);
	if msgBox ~= nil then
		return
	end

	local yesScp = string.format("party.AcceptGuildInvite(\"%s\", \"%s\")", inviterAid, familyName);
	local noScp = string.format("party.CancelInvite(%d, \"%s\", 0)", partyType, familyName);
	local etcScp = string.format("GetGuildInfo(\"%s\", \"%s\")", "GET_INVITED_GUILD_INFO", guildID);
	local ret = ui.MsgBoxEtc(str, yesScp, noScp, etcScp, ClMsg("guildinfo"));
	ret:SetMsgBoxOpenAfterBtnPressed(true)
	ret:SetGravity(ui.LEFT, ui.CENTER_VERT)
end

function GET_INVITED_GUILD_INFO(code, ret_json)
	if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "GET_INVITED_GUILD_INFO")
        return
	end
	if ret_json == "\"\"" then
		ui.MsgBox(ClMsg("GuildHasNoGuildInfo"));
		return
	end
	local parsedJson = json.decode(ret_json)

    local emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
    local emblemPath = emblemFolderPath .. "\\" .. parsedJson["id"] .. ".png";
    if filefind.FileExists(emblemPath, true) == false then
    	emblemPath = "None";
    end
    GUILDINFO_DETAIL_INIT(parsedJson, emblemPath, parsedJson['additionalInfo'], parsedJson["id"] )
end

function PARTY_AUTO_REFUSE_INVITE(familyName)
	local noScp = string.format("PARTY_AUTO_REFUSE_INVITE_EXEC(\"%s\")", familyName);
	ReserveScript(noScp, 5);
end

function PARTY_AUTO_REFUSE_INVITE_EXEC(familyName)
	party.CancelInvite(0, familyName, 0);
end

function ON_PARTY_INVITE_CANCEL(frame, msg, familyName, arg2)
	ui.SysMsg(familyName .. ClMsg("PartyInviteCancelMsg"));
end

function SET_PARTY_JOB_TOOLTIP(cid)	
	local ret = 0;
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return ret;
	end	
	local partyInfo = pcparty.info;
	local info = session.otherPC.GetByStrCID(cid);		
	
	if info == nil then
		return ret;
	end;
	local frame = ui.GetFrame("partyinfo");	
	ret = PARTY_JOB_TOOLTIP_CTRLSET(frame, cid, info);

	local partyFrame = ui.GetFrame('party');
	local gbox = partyFrame:GetChild("gbox");
	local memberlist = gbox:GetChild("memberlist");		
	ret = PARTY_JOB_TOOLTIP_CTRLSET(memberlist, cid, info);

	return ret;
end

function PARTY_JOB_TOOLTIP_CTRLSET(frame, cid, info)
	local ret = 0;
	if frame == nil then
		return ret;
	end
	
	local partyInfoCtrlSet = frame:GetChild('PTINFO_'.. info:GetAID());
	if partyInfoCtrlSet ~= nil then	
		partyInfoCtrlSet:SetUserValue("partyMemberCID", cid)
		local jobportraitImg = GET_CHILD(partyInfoCtrlSet, "jobportrait_bg", "ui::CPicture");
		if jobportraitImg ~= nil then
			local jobIcon = GET_CHILD(jobportraitImg, "jobportrait", "ui::CPicture");
			local jobCls  = GetClassByType("Job", info:GetRepreJob())
			ret = PARTY_JOB_TOOLTIP(frame, cid, jobIcon, jobCls);            
		end
	end
	return ret;
end

function PARTY_JOB_TOOLTIP(frame, cid, uiChild, nowJobName, isChangeMainClass)   
	if (nil == session.otherPC.GetByStrCID(cid)) or (nil == uiChild) then 
		return 0;
	end		 
	
	local otherpcinfo = session.otherPC.GetByStrCID(cid);	
	local gender = otherpcinfo:GetIconInfo().gender;
	local clslist, cnt  = GetClassList("Job");
	
	local nowjobinfo = otherpcinfo:GetJobInfoByIndex(otherpcinfo:GetJobCount() - 1);
	local nowjobcls;
	if nil == nowjobinfo or (nowJobName ~= nil and 	GetClassByTypeFromList(clslist, nowjobinfo.jobID) ~= nowJobName) then
		nowjobcls = nowJobName; 
	else
		nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);        
	end

	local OTHERPCJOBS = {}	
	for i = 0, otherpcinfo:GetJobCount()-1 do
		local tempjobinfo = otherpcinfo:GetJobInfoByIndex(i);		
		if OTHERPCJOBS[tempjobinfo.jobID] == nil then
			OTHERPCJOBS[tempjobinfo.jobID] = 1;
		end
	end

	local jobtext = ("");
	for jobid, grade in pairs(OTHERPCJOBS) do
		-- 클래스 이름{@st41}
		local cls = GetClassByTypeFromList(clslist, jobid);
		if cls.Name == nowjobcls.Name then
			jobtext = jobtext .. ("{@st41_yellow}").. GET_JOB_NAME(cls, gender);
		else
			jobtext = jobtext .. ("{@st41}").. GET_JOB_NAME(cls, gender);
		end
		jobtext = jobtext ..('{nl}');
	end

	uiChild:SetTextTooltip(jobtext);
	uiChild:EnableHitTest(1);
	return 1;
end

function PARTY_JOB_TOOLTIP_BY_CID(cid, icon, nowJobName)
	if (nil == session.otherPC.GetByStrCID(cid)) or (nil == icon) then 
		return 0;
	end		 
			 	

	local otherpcinfo = session.otherPC.GetByStrCID(cid);
	local nowjobinfo, jobCount;	
    local gender;
	local mySession = session.GetMySession();
	if otherpcinfo ~= nil then
		jobCount = otherpcinfo:GetJobCount();
        nowjobinfo = otherpcinfo:GetJobInfoByIndex(jobCount - 1);
	    gender = otherpcinfo:GetIconInfo().gender;
    else
		jobCount = mySession:GetPCJobInfo():GetJobCount();
        nowjobinfo = mySession:GetPCJobInfo():GetJobInfoByIndex(jobCount - 1);
        gender = info.GetGender(session.GetMyHandle());
    end

	local clslist, cnt  = GetClassList("Job");
	local nowjobcls;
	if nil == nowjobinfo then
		nowjobcls = nowJobName; 
	else
		nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
	end

	local OTHERPCJOBS = {}
	for i = 0, jobCount - 1 do		
		local tempjobinfo;
		if otherpcinfo ~= nil then
			tempjobinfo = otherpcinfo:GetJobInfoByIndex(i);
		else
			tempjobinfo = mySession:GetPCJobInfo():GetJobInfoByIndex(i);
		end

		if OTHERPCJOBS[tempjobinfo.jobID] == nil then
			OTHERPCJOBS[tempjobinfo.jobID] = 1;
		end
	end

	local jobtext = ("");
	local jobName = nowjobcls.Name;
	local etc = GetMyEtcObject();
    if etc.RepresentationClassID ~= 'None' then
        local repreJobCls = GetClassByType('Job', etc.RepresentationClassID);
        if repreJobCls ~= nil then
            jobName = repreJobCls.Name;
        end
    end

	for jobid, grade in pairs(OTHERPCJOBS) do
		-- 클래스 이름{@st41}
		local cls = GetClassByTypeFromList(clslist, jobid);

		if cls.Name == jobName then
			jobtext = jobtext .. ("{@st41_yellow}").. GET_JOB_NAME(cls, gender)..'{nl}{/}';
		else
			jobtext = jobtext .. ("{@st41}").. GET_JOB_NAME(cls, gender)..'{nl}{/}';
		end
	end

	icon:SetTextTooltip(jobtext);
	icon:EnableHitTest(1);
	return 1;
end

function UPDATE_MY_JOB_TOOLTIP(jobClassID, icon, nowJobName, isChangeMainClass)
	if nil == icon then 
		return 0;
	end		 	

   	local mySession = session.GetMySession();
	local pcJobInfo = mySession:GetPCJobInfo();
	local jobhistory = mySession:GetPCJobInfo();
    local gender = info.GetGender(session.GetMyHandle());
	local clslist, cnt  = GetClassList("Job");
	
	local nowjobinfo = jobhistory:GetJobInfoByIndex(jobhistory:GetJobCount()-1);
	local nowjobcls;
	
	if nil == nowjobinfo or (isChangeMainClass ~= nil and isChangeMainClass == 1) then
		nowjobcls = nowJobName; 
	else
		nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
	end; 

	local MYPCJOBS = {}
	for i = 0, jobhistory:GetJobCount()-1 do
		
		local tempjobinfo = jobhistory:GetJobInfoByIndex(i);

		if MYPCJOBS[tempjobinfo.jobID] == nil then
			MYPCJOBS[tempjobinfo.jobID] = 1;
		end
	end

	local jobtext = ("");
	for jobid, grade in pairs(MYPCJOBS) do
		-- 클래스 이름{@st41}
		local cls = GetClassByTypeFromList(clslist, jobid);

		if cls.Name == nowjobcls.Name then
			jobtext = jobtext .. ("{@st41_yellow}").. GET_JOB_NAME(cls, gender);
		else
			jobtext = jobtext .. ("{@st41}").. GET_JOB_NAME(cls, gender);
		end
		
		jobtext = jobtext ..('{nl}');
	end
	
	icon:SetTextTooltip(jobtext);
	icon:EnableHitTest(1);
	return 1;
end

-- grave hotkey down
function PARTYINFO_TOGGLE()
local frame = ui.GetFrame("partyinfo");
	if frame == nil then
		return;
	end

	local pcparty = session.party.GetPartyInfo();
	if frame ~= nil and pcparty ~= nil then
		PARTYINFO_UPDATE_BUTTON(frame);
	end
end

-- partyinfo update button input
function PARTYINFO_UPDATE_BUTTON(frame)
	local summonsinfo = ui.GetFrame("summonsinfo"); 
	local isNeedSummonUI = IS_NEED_SUMMON_UI();
	if isNeedSummonUI == 0 then
		return;
	end

	local button = GET_CHILD_RECURSIVELY(frame, "partyinfobutton");
	local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	local title_gbox = GET_CHILD_RECURSIVELY(frame, "titlegbox");

	local changeFlag = tonumber(frame:GetUserConfig("CHANGE_FLAG"));
	if changeFlag == 0 then -- summonsinfo	
		PARTYINFO_REMOVE_CONTROLSET(frame);

		frame:SetVisible(0);
		frame:SetUserConfig("CHANGE_FLAG", "1");
	title_gbox:EnableDrawFrame(0);

		if button ~= nil and buttonText ~= nil then
			button:SetVisible(0);
			buttonText:SetVisible(0);
		end
	elseif changeFlag == 1 then	-- partyinfo
		ON_PARTYINFO_UPDATE(frame);

		frame:SetVisible(1);
		frame:SetUserConfig("CHANGE_FLAG", "0");
		title_gbox:EnableDrawFrame(1);
		
		local hotkey = summonsinfo:GetUserConfig("SUMMONINFO_HOTKEY_TEXT");
		if button ~= nil and buttonText ~= nil then
			-- button tooltip
			if hotkey ~= nil and hotkey ~= "" then
				button:SetTextTooltip(ClMsg("SummonsInfo_ConvertSummonsInfo_ToolTip").."( "..hotkey.." )");
			end
			button:SetVisible(1);
			button:EnableHitTest(1);
			buttonText:SetVisible(1);
			buttonText:SetTextByKey("title", ClMsg("SummonsInfo_PartyInfo"));
		end
	end

	SUMMONSINFO_TOGGLE_BUTTON(summonsinfo, changeFlag);
	PARTYINFO_CONTROLSET_AUTO_ALIGN(frame);
end

-- partyinfo controlset Remove
function PARTYINFO_REMOVE_CONTROLSET(frame)
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	
	for i = 0, count - 1 do
		local partyMemberInfo = list:Element(i);
		local partyInfoCtrlSet = GET_CHILD_RECURSIVELY(frame, 'PTINFO_'.. partyMemberInfo:GetAID()); 
		if partyInfoCtrlSet ~= nil then
			frame:RemoveChild(partyInfoCtrlSet:GetName());
		end
	end

	frame:Invalidate();
	PARTYINFO_CONTROLSET_AUTO_ALIGN(frame);
end

function PARTYINFO_CONTROLSET_AUTO_ALIGN(frame)
	GBOX_AUTO_ALIGN(frame, 10, 0, 0, true, false);
	frame:Invalidate();
end
