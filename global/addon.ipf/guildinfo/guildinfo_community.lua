function GUILDINFO_COMMUNITY_INIT(communityBox)
    GUILDINFO_COMMUNITY_INIT_ONELINE(communityBox);
    ui.CloseFrame('guild_authority_popup');
end

function GUILDINFO_COMMUNITY_INIT_ONELINE(communityBox, msg, argStr, argNum)
    local oneLineBox = GET_CHILD_RECURSIVELY(communityBox, 'oneLineBox');
    oneLineBox:RemoveAllChild();

	local sysTime = geTime.GetServerSystemTime();
    local cnt = session.guildState.GetBoardCount()
	for i = 0, cnt - 1 do
		local board = session.guildState.GetGuildBoardByIndex(i);
		if nil ~= board then
            local ctrlSet = oneLineBox:CreateOrGetControlSet('guild_board_ctrl', 'ONE_LINE_'..i, 0, 0);
            ctrlSet = AUTO_CAST(ctrlSet);
            -- skin
            local ODD_INDEX_SKIN = ctrlSet:GetUserConfig('ODD_INDEX_SKIN');
            if i % 2 == 1 then
                ctrlSet:SetSkinName(ODD_INDEX_SKIN);
            end

            -- date
            local reg = ctrlSet:GetChild('regTime');
			local regTime = imcTime.ImcTimeToSysTime(board.regTime);
            local dateStr = string.format('%04d/%02d/%02d %02d:%02d:%02d', regTime.wYear, regTime.wMonth, regTime.wDay, regTime.wHour, regTime.wMinute, regTime.wSecond); -- yyyy/mm/dd hh:mm:ss
		    reg:SetTextByKey('date', dateStr);

            -- name and message
            local name = ctrlSet:GetChild('name');
            local ONE_LINE_TEAM_NAME_STYLE = ctrlSet:GetUserConfig('ONE_LINE_TEAM_NAME_STYLE');         
			name:SetTextByKey('value', ONE_LINE_TEAM_NAME_STYLE..board:GetName() ..'{/}: '..board:GetMsg());
        end
    end
    GBOX_AUTO_ALIGN(oneLineBox, 0, 0, 0, true, false);
end

function GUILD_SAVE_ONE_SAY(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local edit = GET_CHILD_RECURSIVELY(frame, 'oneLineEdit');    
    local text = edit:GetText();
	if text == nil or text == '' or string.len( edit:GetText()) == 0 then		
		return;
	end
	session.guildState.SaveGuildBoard(edit:GetText());
    edit:SetText('');
end