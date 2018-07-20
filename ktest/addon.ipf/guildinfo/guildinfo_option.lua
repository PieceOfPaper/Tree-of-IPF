function GUILDINFO_OPTION_INIT(parent, optionBox)
    GUILDINFO_OPTION_INIT_AGIT_CHECKBOX(optionBox);
    GUILDINFO_OPTION_INIT_NOTIFY(optionBox);
    GUILDINFO_OPTION_INIT_INTRODUCE(optionBox);
	GUILDINFO_OPTION_INIT_EMBLEM(optionBox);
    ui.CloseFrame('guild_authority_popup');
end

function GUILDINFO_OPTION_INIT_AGIT_CHECKBOX(optionBox)    
    local guildObj = GET_MY_GUILD_OBJECT();
    local outsiderCheck = GET_CHILD_RECURSIVELY(optionBox, 'outsiderCheck');    
    if guildObj.GuildOnlyAgit == 1 then        
        outsiderCheck:SetCheck(0);
    else        
        outsiderCheck:SetCheck(1);
    end
end

function CHANGE_AGIT_ENTER_OPTION(parnet, ctrl)    
	ctrl = AUTO_CAST(ctrl);
    local onlyGuildMember = ctrl:IsChecked();

    if onlyGuildMember == 1 then
        onlyGuildMember = 0
    else
        onlyGuildMember = 1
    end

    local isLeader = AM_I_LEADER(PARTY_GUILD);    
	if 0 == isLeader then -- 해제는 길마만 가능
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));        
        GUILDINFO_OPTION_INIT_AGIT_CHECKBOX(parnet)
		return;        
	end         
	party.ReqChangeProperty(PARTY_GUILD, "GuildOnlyAgit", onlyGuildMember);
end

function GUILDINFO_OPTION_INIT_NOTIFY(optionBox)
    local noticeRegisterBtn = GET_CHILD_RECURSIVELY(optionBox, 'noticeRegisterBtn');
    if AM_I_LEADER(PARTY_GUILD) == 0 then
        noticeRegisterBtn:ShowWindow(0);
    else
        noticeRegisterBtn:ShowWindow(1);
    end

    local guild = GET_MY_GUILD_INFO();
    local noticeEdit = GET_CHILD_RECURSIVELY(optionBox, 'noticeEdit');
    noticeEdit:SetText(guild.info:GetNotice());
end

function SAVE_GUILD_NOTICE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local noticeEdit = GET_CHILD_RECURSIVELY(frame, 'noticeEdit')
	local noticeText = noticeEdit:GetText();
	local guild = GET_MY_GUILD_INFO();
	local nowNotice = guild.info:GetNotice();
	local badword = IsBadString(nowNotice);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
	if nowNotice ~= noticeText then
		party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_NOTICE, noticeText);
	end
	noticeEdit:ReleaseFocus();
end

function GUILDINFO_OPTION_INIT_INTRODUCE(optionBox)
    local introduceBtn = GET_CHILD_RECURSIVELY(optionBox, 'introduceBtn');
    if AM_I_LEADER(PARTY_GUILD) == 0 then
        introduceBtn:ShowWindow(0);
    else
        introduceBtn:ShowWindow(1);
    end

    local guild = GET_MY_GUILD_INFO();
    local introduceEdit = GET_CHILD_RECURSIVELY(optionBox, 'introduceEdit');
    introduceEdit:SetText(guild.info:GetProfile());
end

function GUILDINFO_OPTION_INIT_EMBLEM(optionBox)
	local registerBtn = GET_CHILD_RECURSIVELY(optionBox, 'registerBtn');    
    if AM_I_LEADER(PARTY_GUILD) == 0 then
        registerBtn:ShowWindow(0);
        return;
    end
    registerBtn:ShowWindow(1);

	local isRegisteredEmblem = session.party.IsRegisteredEmblem();	 
	local isPossibleRegistGuildEmblem = session.party.IsPossibleRegistGuildEmblem();
	
	local frame = ui.GetFrame('guildinfo')
	local impossible_color = "FF777777"
	local possible_color = "00000000"
    if frame ~= nil then
		impossible_color = frame:GetUserConfig("IMPOSSIBLE_REGIST_EMBLEM_COLOR")
		possible_color = frame:GetUserConfig("POSSIBLE_REGIST_EMBLEM_COLOR")
    end
	
	registerBtn:SetColorTone(possible_color)

	if isRegisteredEmblem == true then
    	registerBtn:SetTextByKey('register', ClMsg("GuildEmblemChange"));
		if isPossibleRegistGuildEmblem == false then
			-- 회색 톤으로 바꾸긴 하지만 창은 뜨게 한다. 이미지 확인용.
			 registerBtn:SetColorTone(impossible_color)
		end
	else
		registerBtn:SetTextByKey('register', ClMsg("GuildEmblemRegister"));
	end
    
end

function GUILDINFO_OPTION_UPDATE_EMBLEM(frame)
	local frame_guildInfo = ui.GetFrame("guildinfo");
    if frame_guildInfo ~= nil then
        if frame_guildInfo:IsVisible() == 1 then
			local optionBox = GET_CHILD_RECURSIVELY(frame_guildInfo, 'optionBox');
			if optionBox ~= nil then
				GUILDINFO_OPTION_INIT_EMBLEM(optionBox)
			end
        end
    end
end

function SAVE_GUILD_INTRODUCE(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local introduceEdit = GET_CHILD_RECURSIVELY(frame, 'introduceEdit')
	local text = introduceEdit:GetText();
	local guild = GET_MY_GUILD_INFO();
	local now = guild.info:GetProfile();
	local badword = IsBadString(now);
	if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
	if now ~= text then
		party.ReqPartyNameChange(PARTY_GUILD, PARTY_STRING_PROFILE, text);
	end
	introduceEdit:ReleaseFocus();
end