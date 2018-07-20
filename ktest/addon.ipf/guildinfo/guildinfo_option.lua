local json = require "json"


function GUILDINFO_OPTION_INIT(parent, optionBox)
    GUILDINFO_OPTION_INIT_AGIT_CHECKBOX(optionBox);
    GUILDINFO_OPTION_INIT_NOTIFY(optionBox);
    GUILDINFO_OPTION_INIT_INTRODUCE(optionBox);
	GUILDINFO_OPTION_INIT_EMBLEM(optionBox);
	ui.CloseFrame('guild_authority_popup');
	GetGuildInfo("GUILDINFO_GET");

	local guild = GET_MY_GUILD_INFO();
	local leaderAID = guild.info:GetLeaderAID();
	local myAID = session.loginInfo.GetAID()
	if myAID ~= leaderAID then
		--GetPlayerClaims("GUILD_CLAIM_GET", myAID)
		local frame = ui.GetFrame("guildinfo");
		local introText = GET_CHILD_RECURSIVELY(frame, "guildPromoteCheck")
		introText:SetCheck(0)
		introText:SetEnable(0)
		
		local registerBanner = GET_CHILD_RECURSIVELY(frame, "registerBannerBtn");
		registerBanner:SetVisible(0)

		local registerPromoteImageBtn = GET_CHILD_RECURSIVELY(frame "registerPromoteImageBtn");
		registerPromoteImageBtn:SetVisible(0)
	end
end

function GUILD_CLAIM_GET(code, ret_json)
	if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILD_CLAIM_GET");
        return;
	end

	local parsedJson = json.decode(ret_json)
	print(ret_json)
end

function GUILD_PR_GET(code, ret_json)
	local frame = ui.GetFrame("guildinfo");
	local introText = GET_CHILD_RECURSIVELY(frame, "guildPromoteCheck")
	if code ~= 200 then
		local splitmsg = StringSplit(ret_json, " ");
		local errorCode = splitmsg[1];
		if tonumber(errorCode) == 1 then
			introText:SetCheck(0)
			introText:SetEnable(0)
			return;
		end

        SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILD_PR_GET")
        return;
	end

	if ret_json == "true" then
		introText:SetCheck(1)
	else
		introText:SetCheck(0);
	end
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
end

function save_guild_notice_call_back(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "save_guild_notice_call_back")
        return
    end

    ui.SysMsg(ClMsg("UpdateSuccess"))
    -- 여기에서 해당 ui에 글자 채워주기
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
        SetGuildNotice('save_guild_notice_call_back', noticeText)
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
end

function GUILDINFO_OPTION_INIT_EMBLEM(optionBox)
	local registerBtn = GET_CHILD_RECURSIVELY(optionBox, 'registerBtn');    
    if AM_I_LEADER(PARTY_GUILD) == 0 then
        registerBtn:ShowWindow(0);
        return;
    end
    registerBtn:ShowWindow(1);

	local isRegisteredEmblem = session.party.IsRegisteredEmblem();	 
	
	
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

		local changeItem = false;
		local invItem = session.GetInvItemByName("Premium_Change_Guild_Emblem");
		if invItem ~= nil then
		 	changeItem = true;
		end
		-- 인벤에 변경권이 없고, 길드 엠블럼 등록 가능한 상태가 아닐 때 회색톤으로 변경한다.
		local isPossibleRegistGuildEmblem = session.party.IsPossibleRegistGuildEmblem(changeItem);
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

function save_guild_introduce_call_back(code, ret_json)
    print(code, ret_json)
    if code ~= 200 then        
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "save_guild_introduce_call_back")
        return
    end

    ui.SysMsg(ClMsg("UpdateSuccess"))
    -- 여기에서 해당 ui에 글자 채워주기
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
		SetGuildProfile('save_guild_introduce_call_back', text);
	end
	introduceEdit:ReleaseFocus();
end

function REGISTER_GUILD_BANNER(frame, control)

	local selectorFrame = ui.GetFrame("loadimage");
	local acceptBtn = GET_CHILD_RECURSIVELY(selectorFrame, "acceptBtn");

	acceptBtn:SetEventScript(ui.LBUTTONUP, "CHECK_BANNER_FORMAT")

    LOAD_IMAGE_INIT("UploadBanner", "png")
end

local tempfilePath = nil
function CHECK_BANNER_FORMAT(frame, control)
	local fullPath = control:GetUserValue("fullPath")
	local result = session.party.RegisterGuildBanner(fullPath,false)
	if result == EMBLEM_RESULT_ABNORMAL_IMAGE then
		ui.SysMsg(ClMsg("AbnormalImageData"))
	elseif result == EMBLEM_RESULT_SUCCESS then
		local orgPath = control:GetUserValue("orgPath");
		local fileName = control:GetUserValue("fileName");
		local tempPath = filefind.GetBinPath("tempfiles"):c_str();
		local result = RemoveInterlaceFromBanner(orgPath, fileName, tempPath);

		if result == false then
			ui.MsgBox(ClMsg("AbnormalImageData"))
			ui.CloseFrame('loadimage')
			return;
		end
		tempfilePath = tempPath .. "\\" .. fileName;

		PostGuildBannerImage("BANNER_UPLOADED", tempfilePath);
	end
	ui.CloseFrame('loadimage')
end

function BANNER_UPLOADED(code, ret_json)
    if code ~= 200 then
		if string.find(ret_json, "registering") ~= nil then
			ui.MsgBox(ClMsg("RegisterGuildPromoteBeforeBanner"))
		else
			SHOW_GUILD_HTTP_ERROR(code, ret_json, "BANNER_UPLOADED")
		end
        return;
	end
	ui.MsgBox(ClMsg("UpdateSuccess"))
	os.remove(tempfilePath)
end

function REGISTER_GUILD_PAGE(frame, control)
	
	local selectorFrame = ui.GetFrame("loadimage");
	local acceptBtn = GET_CHILD_RECURSIVELY(selectorFrame, "acceptBtn");

	acceptBtn:SetEventScript(ui.LBUTTONUP, "CHECK_PAGE_FORMAT")

	LOAD_IMAGE_INIT("UploadPromo", "png")
	
end

function CHECK_PAGE_FORMAT(parent, control)
	local fullPath = control:GetUserValue("fullPath")
	local result = session.party.RegisterGuildPage(fullPath, false)
	if result == EMBLEM_RESULT_ABNORMAL_IMAGE then
		ui.SysMsg(ClMsg("AbnormalImageData"))
	elseif result == EMBLEM_RESULT_SUCCESS then
		local orgPath = control:GetUserValue("orgPath");
		local fileName = control:GetUserValue("fileName");
		local tempPath = filefind.GetBinPath("tempfiles"):c_str();
		local height = session.party.GetGuildPageHeight(fullPath);

		if height == 0 then
			ui.MsgBox(ClMsg("AbnormalImageData"))
			return
		end

		local result = RemoveInterlaceFromIntroductionImage(orgPath, fileName, tempPath, height);

		if result == false then
			ui.MsgBox(ClMsg("AbnormalImageData"))
			ui.CloseFrame('loadimage')
			return;
		end
		tempfilePath = tempPath .. "\\" .. fileName;

		SetIntroductionImage("INTRO_IMAGE_UPLOADED", tempfilePath);
	end
	ui.CloseFrame('loadimage')
end

function INTRO_IMAGE_UPLOADED(code, ret_json)
	if code ~= 200 then
		if string.find(ret_json, "registering") ~= nil then
			ui.MsgBox(ClMsg("RegisterGuildPromoteBeforeBanner"))
		else
			SHOW_GUILD_HTTP_ERROR(code, ret_json, "INTRO_IMAGE_UPLOADED")
		end
        return;
	end


	ui.MsgBox(ClMsg("UpdateSuccess"))
	--os.remove(tempfilePath)
end

function SAVE_GUILD_PROMOTE(frame, control)
	local parentFrame = frame:GetTopParentFrame();
	local introText = GET_CHILD_RECURSIVELY(parentFrame, "promoteEdit")
	local badword = IsBadString(introText:GetText());
    if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
	PutGuildInfo("PUT_GUILD_PROMOTE", introText:GetText(), "");
end

function PUT_GUILD_PROMOTE(code, ret_json)
	if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "PUT_GUILD_PROMOTE")
        return;
	end
	ui.SysMsg(ClMsg("UpdateSuccess"))
	
end

function GUILDINFO_GET(code, ret_json)
	if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILDINFO_GET")
        return;
	end
	local parentFrame = ui.GetFrame("guildinfo");
	local list = json.decode(ret_json)
	if list == '' then
		local promoteCheck = GET_CHILD_RECURSIVELY(parentFrame, "guildPromoteCheck")
		promoteCheck:SetCheck(0)
		return
	end
	GetGuildPRState("GUILD_PR_GET")

	local introText = GET_CHILD_RECURSIVELY(parentFrame, "promoteEdit")
	introText:SetText(list['shortDesc']);
end

function SET_GUILD_PROMOTE(frame, control)
	print(control:GetName());
	if control:IsChecked() == 1 then
		SetGuildPRVisible("ON_PR_CHECK");
	else
		SetGuildPRInvisible("ON_PR_CHECK");
	end
end

function ON_PR_CHECK(code, ret_json)
	if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_PR_CHECK");
        return;
	end
	print(ret_json)	
end