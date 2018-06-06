
function ON_GUILD_AUTHO_POPUP_OPEN(frame, ctrl, argStr, argNum)
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	guild_authority_popup:ShowWindowToggle();	-- Open / Close
end


function GUILD_AUTHO_POPUP_DO_OPEN(frame, ctrl, argStr, argNum)
	
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		frame:ShowWindow(0);
		return;
	end

	
	local guild = ui.GetFrame("guild");	
	local party_info = GET_CHILD_RECURSIVELY(guild, 'party_info');	
	local gbox_list = GET_CHILD_RECURSIVELY(guild, 'gbox_list');	
		
	local bg_box = GET_CHILD_RECURSIVELY(frame, 'bg_box');
	local bg_title_key = GET_CHILD_RECURSIVELY(bg_box, 'bg_title_key');
	local bg_checkgroup = GET_CHILD_RECURSIVELY(bg_box, 'bg_checkgroup');
	bg_checkgroup:EnableScrollBar(0);
	
	local strCol = "ADD#REMOVE";
	-- 해당 타입을 추가하는 곳
	--strCol = strCol .. "#INVEN";
	--strCol = strCol .. "#EVENT";
			
	local sList = StringSplit(strCol, "#");
	local numCount = #sList;
	local plist = session.party.GetPartyMemberList(PARTY_GUILD);
		
	local showOnlyConnected = config.GetXMLConfig("Guild_ShowOnlyConnected");	
	local connectionCount = 0;
		
	local maxWndW = 148 * numCount + 4 * numCount;	
	local maxWndH = party_info:GetHeight() + 10;
	frame:Resize(party_info:GetDrawX() + guild:GetWidth() - 15 , party_info:GetDrawY() - 8, maxWndW, maxWndH);

	bg_box:Resize(0 ,0 ,maxWndW - 17, maxWndH - 17);	
	bg_checkgroup:Resize(3, 3 + bg_title_key:GetHeight(), maxWndW + 17, maxWndH - 24);	
	bg_title_key:Resize(maxWndW - 20, bg_title_key:GetHeight());
	local leaderAID = pcparty.info:GetLeaderAID();
	local myAid = session.loginInfo.GetAID();
		
	local wndX = 0;
	local wndY = 0;
	
	local bLeader = 1;
	if leaderAID ~= myAid then
		bLeader = 0;
	end
		
	bg_checkgroup:DeleteAllControl();		
	local showOnlyConnected = config.GetXMLConfig("Guild_ShowOnlyConnected");	
	local lastHiehgt = 0;
	for i = 1 , numCount do
		local strName = sList[i]; 
		local strText = ScpArgMsg("Guild_Authority_" ..strName);
		local checkList_typeText = bg_title_key:CreateOrGetControl('richtext', "TEXT_" .. strName, wndX, -5, 140, 50);
		checkList_typeText = tolua.cast(checkList_typeText, "ui::CRichText");
		checkList_typeText:SetTextAlign("center", "center");
		checkList_typeText:SetFontName("black_16_b");
		checkList_typeText:SetText(string.format("{s20}%s{/}", strText)); 

		local checkList_gBox = bg_checkgroup:CreateOrGetControl('groupbox', "GBOX_" .. strName, 4 + wndX, 0, 140, numCount * 34);
		checkList_gBox = tolua.cast(checkList_gBox, "ui::CGroupBox");
		checkList_gBox:SetSkinName("pvp_Team_skin");		

		if (i % 2) == 0 then
			checkList_gBox:EnableDrawFrame(0);
		else
			checkList_gBox:EnableDrawFrame(1);
		end

		local midleX = checkList_gBox:GetWidth() / 2;
		local subY = wndY + 5;		
		for j = 0 , plist:Count() - 1 do
			local partyMemberInfo = plist:Element(j);

			if (showOnlyConnected == 0) or (partyMemberInfo:GetMapID() > 0) then

				local aid = partyMemberInfo:GetAID();
					
				local checkbox_member = bg_checkgroup:CreateOrGetControl('checkbox', 'CHECK_'..j ..'_'..i, 4 + wndX + midleX - 15, subY, 20, 20);
				checkbox_member = tolua.cast(checkbox_member, "ui::CCheckBox");
				checkbox_member:SetSkinName("MCC_checkbox");

				if aid == leaderAID then
					checkbox_member:SetCheck(1);
					checkbox_member:SetCheckWhenClicked(0);
				else
					checkbox_member:SetCheckWhenClicked(bLeader);
					checkbox_member:SetCheck(IS_GUILD_AUTHORITY(i, aid));
				end

				checkbox_member:SetEventScript(ui.LBUTTONUP, 'SET_AUTHO_MEMBER_CONFIG');
				checkbox_member:SetEventScriptArgString(ui.LBUTTONUP, aid);		
				checkbox_member:SetEventScriptArgNumber(ui.LBUTTONUP, i);	
				
				if (i == numCount) then
					local checkbox_line = bg_checkgroup:CreateOrGetControl('labelline', 'LINE_'..connectionCount, 4, subY + checkbox_member:GetHeight(), (maxWndW * numCount) - 25, 10);
					checkbox_line:SetSkinName('labelline_def_2');
				end
				
				connectionCount = connectionCount + 1;
				subY = subY + checkbox_member:GetHeight() + 10;		
			end
		end			
		
		lastHiehgt = subY;
		wndX = wndX + checkList_gBox:GetWidth() + 6;
		checkList_gBox:Resize(checkList_gBox:GetWidth(),  subY - 9);
	end	
	local row = (math.floor(connectionCount/numCount) - 1);
	bg_checkgroup:RemoveChild("LINE_".. row );
	frame:SetUserValue("AUTHO_S_ROW", math.floor(connectionCount/numCount));	
	
	if (gbox_list:GetHeight() + 10) <= lastHiehgt then
		maxWndH = (gbox_list:GetHeight() + 10); 
	else
		maxWndH = lastHiehgt; 
	end

	frame:Resize(	(party_info:GetDrawX() + guild:GetWidth() - 15), 	(party_info:GetDrawY() - 8), 	(maxWndW), 	(maxWndH + bg_title_key:GetHeight() + 17)	);
	bg_box:Resize(0 ,0 ,maxWndW - 17, maxWndH + bg_title_key:GetHeight() );	
	bg_checkgroup:Resize(maxWndW - 17, maxWndH);	
	bg_title_key:Resize(maxWndW - 20, bg_title_key:GetHeight());
end

function SET_AUTHO_MEMBER_CONFIG(frame, ctrl, argStr, argNum)
	packet.SetGuildMemberAuthority(argStr, ctrl:IsChecked(), argNum)
end

function SET_AUTHO_MEMBERS_SCROLL(frame, ctrl, argStr, argNum)
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	local bg_checkgroup = GET_CHILD_RECURSIVELY(guild_authority_popup, 'bg_checkgroup');
	bg_checkgroup:SetScrollPos(argNum);
end

