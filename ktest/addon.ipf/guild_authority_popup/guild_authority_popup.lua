
function ON_GUILD_AUTHO_POPUP_OPEN(frame, ctrl, argStr, argNum)
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	guild_authority_popup:ShowWindowToggle();	-- Open / Close
end

function GUILD_AUTHO_POPUP_DO_OPEN(frame, ctrl, argStr, argNum)	
	local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        frame:ShowWindow(0);
        return;
    end

    GUILD_AUTHORITY_POPUP_SET_OFFSET(frame);
    GUILD_AUTHORITY_POPUP_SET_MEMBER(frame);
end

function SET_AUTHO_MEMBER_CONFIG(frame, ctrl, argStr, argNum)
	packet.SetGuildMemberAuthority(argStr, ctrl:IsChecked(), argNum);
end

function SET_AUTHO_MEMBERS_SCROLL(frame, ctrl, argStr, argNum)
	local guild_authority_popup = ui.GetFrame("guild_authority_popup");	
	local authBox = GET_CHILD_RECURSIVELY(guild_authority_popup, 'authBox');
	authBox:SetScrollPos(argNum);
end

function GUILD_AUTHORITY_POPUP_SET_OFFSET(frame)
    local guildinfo = ui.GetFrame('guildinfo');
    local memberListBox = GET_CHILD_RECURSIVELY(guildinfo, 'memberListBox');
    if memberListBox:IsVisible() ~= 1 then
        frame:ShowWindow(0);
        return;
    end
    frame:SetOffset(memberListBox:GetGlobalX() - frame:GetWidth(), memberListBox:GetGlobalY() - 10);
end

function GUILD_AUTHORITY_POPUP_SET_MEMBER(frame)
    local strCol = "ADD#REMOVE";	
	--strCol = strCol .. "#INVEN";
	--strCol = strCol .. "#EVENT";
	local sList = StringSplit(strCol, "#");

    local authBox = GET_CHILD_RECURSIVELY(frame, 'authBox');    
    authBox:RemoveAllChild();

    local guild = GET_MY_GUILD_INFO();
    local leaderAID = guild.info:GetLeaderAID();
    local bLeader = 0;
    if session.loginInfo.GetAID() == leaderAID then
        bLeader = 1;
    end

    local guildinfo = ui.GetFrame('guildinfo');
    local memberCtrlBox = GET_CHILD_RECURSIVELY(guildinfo, 'memberCtrlBox');
    local memberCount = memberCtrlBox:GetChildCount();
    local showCnt = 1;
    local maxOffset = 0;
    for i = 0, memberCount - 1 do
        local member = memberCtrlBox:GetChildByIndex(i);        
        if string.find(member:GetName(), 'MEMBER_') ~= nil then
            local aid = member:GetUserValue('AID');
            local authCtrlSet = authBox:CreateOrGetControlSet('guild_auth', 'AUTH_'..aid, 0, 0);            
            
            local inviteCheck = GET_CHILD(authCtrlSet, 'inviteCheck');
            local outCheck = GET_CHILD(authCtrlSet, 'outCheck');
            for j = 1, #sList do            
                local checkCtrl = nil;
                if sList[j] == 'ADD' then
                    checkCtrl = inviteCheck;
                elseif sList[j] == 'REMOVE' then
                    checkCtrl = outCheck;
                end
                    
                if checkCtrl ~= nil then
                    if aid == leaderAID then -- 길마는 모든 권한을 가짐                    
                        checkCtrl:SetCheck(1);
				        checkCtrl:SetCheckWhenClicked(0);
                    else
				        checkCtrl:SetCheckWhenClicked(bLeader);
				        checkCtrl:SetCheck(IS_GUILD_AUTHORITY(j, aid));
                    end
			        checkCtrl:SetEventScript(ui.LBUTTONUP, 'SET_AUTHO_MEMBER_CONFIG');
			        checkCtrl:SetEventScriptArgString(ui.LBUTTONUP, aid);		
			        checkCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, j);
                end
            end
            local memberOffsetY = member:GetY();
            authCtrlSet:SetOffset(authCtrlSet:GetX(), memberOffsetY);
            maxOffset = math.max(maxOffset, memberOffsetY);
        end
    end
end