-- community.lua --

function SELECT_PC_CONTEXT_MENU(handleList)
		
		local context = ui.CreateContextMenu("PC_CONTEXT_MENU", "", 0, 0, 170, 100);
		local handleCount = #handleList;
		for i = 1 , handleCount do
			local handle = handleList[i];
			local pcObj = world.GetActor(handle);
			if pcObj ~= nil then
				ui.AddContextMenuItem(context, pcObj:GetPCApc():GetFamilyName(), string.format("SELECT_PC_CONTEXT_MENU_OK(%d)", handle));
			end
		end

		ui.AddContextMenuItem(context, ClMsg("Cancel"), "None");
		ui.OpenContextMenu(context);

		g_lastContextMenuX = context:GetMargin().left;
		g_lastContextMenuY = context:GetMargin().top;

end

function SELECT_PC_CONTEXT_MENU_OK(handle)

	ReserveScript(string.format("_SHOW_PC_CONTEXT_MENU(%d)", handle), 0.01);
end

function _SHOW_PC_CONTEXT_MENU(handle)

	local context = SHOW_PC_CONTEXT_MENU(handle);
	if context == nil then
		return;
	end
	context:SetOffset(g_lastContextMenuX, g_lastContextMenuY);
	

end

function SHOW_PC_CONTEXT_MENU(handle)
	if world.IsPVPMap() == true or session.colonywar.GetIsColonyWarMap() == true or IS_IN_EVENT_MAP() == true then
		return;
	end

	local targetInfo= info.GetTargetInfo(handle);
	if targetInfo.IsDummyPC == 1 then
		if targetInfo.isSkillObj == 0 then --유체이탈은 클릭해도 아무반응 없도록 한다.
			POPUP_DUMMY(handle, targetInfo);
		end
		return
	end

	local pcObj = world.GetActor(handle);
	if pcObj == nil then
		return;
	end

	if pcObj:IsMyPC() == 1 then
		if 1 == session.IsGM() then
			local contextMenuCtrlName = string.format("{@st41}%s (%d){/}", pcObj:GetPCApc():GetFamilyName(), handle);
			local context = ui.CreateContextMenu("PC_CONTEXT_MENU", pcObj:GetPCApc():GetFamilyName(), 0, 0, 100, 100);

			local strscp = string.format("ui.Chat(\"//runscp TEST_SERVPOS %d\")", handle);
			ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}SeoBeowiChiBoKi{/}"), strscp);

			strscp = string.format("debug.TestNode(%d)", handle);
			ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}NodeBoKi{/}"), strscp);

			strscp = string.format("debug.CheckModelFilePath(%d)", handle);
			ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}XACTegSeuChyeoKyeongLo{/}"), strscp);

			strscp = string.format("debug.TestSnapTexture(%d)", handle);
			ui.AddContextMenuItem(context, "{@st42b}SnapTexture{/}", strscp);

			strscp = string.format("debug.TestShowBoundingBox(%d)", handle);
			ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}BaunDingBagSeuBoKi{/}"), strscp);
			
            strscp = string.format("SCR_OPER_RELOAD_HOTKEY(%d)", handle);
			ui.AddContextMenuItem(context, "ReloadHotKey", strscp);
			
			strscp = string.format("SCR_CLIENTTESTSCP(%d)", handle);
			ui.AddContextMenuItem(context, "ClientTestScp", strscp);
			
			ui.OpenContextMenu(context);

			return context;
		end

		
	end
	
	local partyinfo = session.party.GetPartyInfo();
	local accountObj = GetMyAccountObj();
	if pcObj:IsMyPC() == 0 and info.IsPC(pcObj:GetHandleVal()) == 1 then
		if targetInfo.IsDummyPC == 1 then
			packet.DummyPCDialog(handle);
			return  context;
		end
			
		local contextMenuCtrlName = string.format("{@st41}%s (%d){/}", pcObj:GetPCApc():GetFamilyName(), handle);
		local context = ui.CreateContextMenu("PC_CONTEXT_MENU", pcObj:GetPCApc():GetFamilyName(), 0, 0, 170, 100);

		-- 여기에 캐릭터 정보보기, 로그아웃PC관련 메뉴 추가하면됨
		if session.world.IsIntegrateServer() == false then
			local strScp = string.format("exchange.RequestChange(%d)", pcObj:GetHandleVal());
			ui.AddContextMenuItem(context, ClMsg("Exchange"), strScp);
		
			local strWhisperScp = string.format("ui.WhisperTo('%s')", pcObj:GetPCApc():GetFamilyName());
			ui.AddContextMenuItem(context, ClMsg("WHISPER"), strWhisperScp);
			strScp = string.format("PARTY_INVITE(\"%s\")", pcObj:GetPCApc():GetFamilyName());
			ui.AddContextMenuItem(context, ClMsg("PARTY_INVITE"), strScp);
                        
            strScp = string.format("GUILD_INVITE(\"%s\")", pcObj:GetPCApc():GetFamilyName());
			ui.AddContextMenuItem(context, ClMsg("GUILD_INVITE"), strScp);


			strscp = string.format("barrackNormal.Visit(%d)", handle);
			ui.AddContextMenuItem(context, ScpArgMsg("VisitBarrack"), strscp);
			strscp = string.format("ui.ToggleHeaderText(%d)", handle);
			if pcObj:GetHeaderText() ~= nil and string.len(pcObj:GetHeaderText()) ~= 0 then
				if pcObj:IsHeaderTextVisible() == true  then			
					ui.AddContextMenuItem(context, ClMsg("BlockTitleText"), strscp);
				else
					ui.AddContextMenuItem(context, ClMsg("UnblockTitleText"), strscp);
				end
			end
		end

		strscp = string.format("PROPERTY_COMPARE(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_SalPyeoBoKi"), strscp);
			
		if session.world.IsIntegrateServer() == false then
			local strRequestAddFriendScp = string.format("friends.RequestRegister('%s')", pcObj:GetPCApc():GetFamilyName());
			ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strRequestAddFriendScp);
		end

		ui.AddContextMenuItem(context, ScpArgMsg("RequestFriendlyFight"), string.format("REQUEST_FIGHT(\"%d\")", pcObj:GetHandleVal()));

		local familyname = pcObj:GetPCApc():GetFamilyName()
		local otherpcinfo = session.otherPC.GetByFamilyName(familyname);
		
		if session.world.IsIntegrateServer() == false then
			local strRequestLikeItScp = string.format("SEND_PC_INFO(%d)", handle);
			if session.likeit.AmILikeYou(familyname) == true then
				ui.AddContextMenuItem(context, ScpArgMsg("ReqUnlikeIt"), strRequestLikeItScp);
			else
				ui.AddContextMenuItem(context, ScpArgMsg("ReqLikeIt"), strRequestLikeItScp);
			end
		end


		ui.AddContextMenuItem(context, ScpArgMsg("Report_AutoBot"), string.format("REPORT_AUTOBOT_MSGBOX(\"%s\")", pcObj:GetPCApc():GetFamilyName()));

        -- report guild emblem
        if  pcObj:IsGuildExist() == true then
            ui.AddContextMenuItem(context, ScpArgMsg("Report_GuildEmblem"), string.format("REPORT_GUILDEMBLEM_MSGBOX(\"%s\")", pcObj:GetPCApc():GetFamilyName()));        
        end

		-- 보호모드, 강제킥
		if 1 == session.IsGM() then
			ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Protected"), string.format("REQUEST_GM_ORDER_PROTECTED(\"%s\")", pcObj:GetPCApc():GetFamilyName()));
			ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Kick"), string.format("REQUEST_GM_ORDER_KICK(\"%s\")", pcObj:GetPCApc():GetFamilyName()));
		end


		ui.AddContextMenuItem(context, ClMsg("Cancel"), "None");
		ui.OpenContextMenu(context);
		return  context;
	end
end

function REPORT_AUTOBOT_MSGBOX(teamName)

	local msgBoxString = ScpArgMsg("DoYouReportAuto{Name}?", "Name", teamName);
	local yesScp = string.format("REPORT_AUTOBOT( \"%s\" )", teamName);
	
	ui.MsgBox(msgBoxString, yesScp, "None");	
end

function REPORT_AUTOBOT(teamName)

	packet.ReportAutoBot(teamName);
	local msgStr = ScpArgMsg("ThxReportAuto{Name}", "Name", teamName);
	ui.SysMsg(msgStr);
end

function REPORT_GUILDEMBLEM_MSGBOX(teamName)

	local msgBoxString = ScpArgMsg("DoYouReportGuildEmblem{Name}?", "Name", teamName);
	local yesScp = string.format("REPORT_GUILDEMBLEM( \"%s\" )", teamName);
	
	ui.MsgBox(msgBoxString, yesScp, "None");	
end

function REPORT_GUILDEMBLEM(teamName)

	packet.ReportGuildEmblem(teamName);
	local msgStr = ScpArgMsg("ThxReportGuildEmblem{Name}", "Name", teamName);
	ui.SysMsg(msgStr);
end


function REQUEST_GM_ORDER_PROTECTED(teamName)
	packet.RequestGmOrderMsg(teamName, 'protected');
end

function REQUEST_GM_ORDER_KICK(teamName)
	packet.RequestGmOrderMsg(teamName, 'kick');
end

function REQUEST_FIGHT(handle)
	
	packet.RequestFriendlyFight(handle, 0);

end

function ASKED_FRIENDLY_FIGHT(handle, familyName)

	local msgBoxString = ScpArgMsg("DoYouAcceptFriendlyFightingWith{Name}?", "Name", familyName);
	ui.MsgBox(msgBoxString, string.format("ACK_FRIENDLY_FIGHT(%d)", handle) ,"None");

end

function ACK_FRIENDLY_FIGHT(handle)

	packet.RequestFriendlyFight(handle, 1);

end

function PARTY_INVITE(name)
	party.ReqDirectInvite(PARTY_NORMAL, name);
end

function GUILD_INVITE(name)
	party.GuildMemberInviteByWeb(name)
end

function GUILD_INVITE_BY_WEB(name)    
    party.GuildMemberInviteByWeb(name)
end

function PROPERTY_COMPARE(handle)
	ui.PropertyCompare(handle, 1);
end

function SEND_PC_INFO(handle)
	ui.PropertyCompare(handle, 0, 1);
end

function CHAT_SYSTEM()
	local chatFrame = ui.GetFrame("chat");

	if chatFrame:IsVisible() == 0 then
		chatFrame:ShowWindow(1);
	end
end

function MYPAGE_INIT(handle)
	session.SetMyPageOwnerHandle(handle);
	session.GetTargetMyPage();
	session.GetTargetGuestBook();

	ui.OpenFrame("social");
end

function MYPAGE_TARGET_INIT(handle)
	session.SetMyPageOwnerHandle(handle);
	session.GetTargetMyPage();
	session.GetTargetGuestBook();

	MYPAGET_TARGET_UI_INIT(handle);

	ui.OpenFrame("socialtarget");
end

