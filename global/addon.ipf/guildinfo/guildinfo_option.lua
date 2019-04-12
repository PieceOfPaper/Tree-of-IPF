local json = require "json_imc"
local emblemPath = nil
local bannerPath = nil
local introImagePath = nil
local tempfilePath = nil
local registeredGuildInfo = false
function callback_change_agit_enter_option(code, ret_json, argList)
    if code ~= 200 then        
        SHOW_GUILD_HTTP_ERROR(code, "1", "callback_change_agit_enter_option") -- 권한 없음
        return
    end

    if ret_json == 'True' then
        party.ReqGuildAgitEnter(PARTY_GUILD, tonumber(argList[1]));
    else
        SHOW_GUILD_HTTP_ERROR(code, "1", "callback_change_agit_enter_option") -- 권한 없음
    end
end

function GUILDINFO_OPTION_INIT(parent, optionBox)
	emblemPath = nil
	registeredGuildInfo = false
	bannerPath = nil
	introImagePath = nil
 	tempfilePath = nil
 	local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local myGuildID = guild.info:GetPartyID();

    GUILDINFO_OPTION_INIT_AGIT_CHECKBOX(optionBox);
	GUILDINFO_OPTION_INIT_EMBLEM(optionBox);
	GetGuildBannerImage("GUILDINFO_OPTION_INIT_BANNER", myGuildID);

	emblemPath = filefind.GetBinPath("GuildEmblem"):c_str()
	bannerPath = filefind.GetBinPath("GuildBanner"):c_str()
	introImagePath = filefind.GetBinPath("GuildIntroImage"):c_str()
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
    
    local argList = {}
    argList[1] = tostring(onlyGuildMember)
    CheckClaim('callback_change_agit_enter_option', 402, argList)     
end

function REGISTER_GUILD_EMBLEM(frame)
	GUILDEMBLEM_CHANGE_INIT(frame);
 end

function GUILDINFO_OPTION_INIT_BANNER(code, ret_json)
	if code ~= 200 then
		if code ~= 400 then -- 400 = no banner
			SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILDINFO_OPTION_INIT_BANNER")
		end
        return;
	end
	local frame_guildInfo = ui.GetFrame("guildinfo");
	local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local myGuildID = guild.info:GetPartyID();
	local fileDir = bannerPath .. "\\" .. myGuildID .. ".png";
	local banner = GET_CHILD_RECURSIVELY(frame_guildInfo, "previewBanner")
	banner = tolua.cast(banner, "ui::CPicture");
	banner:SetImage("guildbanner_slot")
	if filefind.FileExists(fileDir, true) == true then
		banner:SetImage("")
		banner:SetFileName(fileDir)
	end

end
function GUILDINFO_OPTION_INIT_EMBLEM(optionBox)
	local registerBtn = GET_CHILD_RECURSIVELY(optionBox, 'regEmblemBtn');   
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
			local optionBox = GET_CHILD_RECURSIVELY(frame_guildInfo, 'setting');
			if optionBox ~= nil then
				GUILDINFO_OPTION_INIT_EMBLEM(optionBox)
			end
        end
    end
end

function save_guild_introduce_call_back(code, ret_json)
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
			ui.MsgBox(ClMsg("ImageInterlaceException"))
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
	ui.MsgBox(ClMsg("BannerUploadSuccess"))

	local frame = ui.GetFrame("guildinfo");

	local banner = GET_CHILD_RECURSIVELY(frame, "previewBanner")
	banner = tolua.cast(banner, "ui::CPicture");
	banner:SetImage("guildbanner_slot")
	if filefind.FileExists(tempfilePath, true) == true then
		banner:SetImage("")
		banner:SetFileName(tempfilePath)
	end
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
			ui.MsgBox(ClMsg("ImageInterlaceException"))
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
			ui.MsgBox(ClMsg("RegGuildPromoteBeforeImage"))
		else
			SHOW_GUILD_HTTP_ERROR(code, ret_json, "INTRO_IMAGE_UPLOADED")
		end
        return;
	end
	ui.MsgBox(ClMsg("ImageUploadSuccess"))
end

function SAVE_GUILD_PROMOTE(frame, control)
	local parentFrame = frame:GetTopParentFrame();
	local introText = GET_CHILD_RECURSIVELY(parentFrame, "regPromoteText")
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
registeredGuildInfo = true
	ui.MsgBox(ClMsg("UpdateSuccess"))
	
end

function GUILDINFO_GET(code, ret_json)
	if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILDINFO_GET")
        return;
	end
	local parentFrame = ui.GetFrame("guildinfo");
	local list = json.decode(ret_json)
	if list == '' then
 registeredGuildInfo = false
		local promoteCheck = GET_CHILD_RECURSIVELY(parentFrame, "guildPromoteCheck")
		promoteCheck:SetCheck(0)
		return
	end
 registeredGuildInfo = true
	GetGuildPRState("GUILD_PR_GET")
	local introText = GET_CHILD_RECURSIVELY(parentFrame, "regPromoteText")
	introText:SetText(list['shortDesc']);
end

function SET_GUILD_PROMOTE(frame, control)
	if registeredGuildInfo == false then
		ui.MsgBox(ClMsg("WebService_101"))
		control:SetCheck(0)
		return
	end
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
end


