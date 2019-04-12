function GUILDINFO_COLONY_INIT(frame, colonyBox)   
    GUILDINFO_COLONY_INIT_RADIO(colonyBox);
    --GUILDINFO_COLONY_INIT_INFO(colonyBox);
    GUILDINFO_COLONY_UPDATE_OCCUPY_INFO(frame);
end

function GUILDINFO_COLONY_HELP_CLICK(parent, ctrl)
    local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", 'None', 550);
end

function GUILDINFO_COLONY_ENTER_CONFIG(parent, ctrl)
    local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
        GUILDINFO_COLONY_INIT_RADIO(parent);
		return;
	end

    local templerCls = GetClass('Job', 'Char1_16');
    if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == false then
        ui.SysMsg(ClMsg('TgtDonHaveTmpler'));
        GUILDINFO_COLONY_INIT_RADIO(parent);
        return;
    end

    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        GUILDINFO_COLONY_INIT_RADIO(parent);
        return;
    end

    local changeValue = GET_RADIOBTN_NUMBER(ctrl);
    if changeValue == 0 and session.colonywar.GetOccupationInfoByGuildID(guild.info:GetPartyID()) ~= nil then
        ui.SysMsg(ClMsg('CannotChangeConfigBecauseOccupation'));
        GUILDINFO_COLONY_INIT_RADIO(parent);
        return;
    end

    local yesscp = string.format('control.CustomCommand("CHANGE_COLONY_CONFIG", %d)', changeValue);
    local clmsg = '';
    if changeValue == 1 then
        clmsg = ScpArgMsg('ReallyChangeColonyEnterConfigTo{VALUE}', 'VALUE', ClMsg('Auto_ChamKa'));
    else
        clmsg = ScpArgMsg('ReallyChangeColonyEnterConfigTo{VALUE}', 'VALUE', ClMsg('NotJoin'));
    end
    ui.MsgBox(clmsg, yesscp, 'GUILDINFO_COLONY_INIT_RADIO()');
end

function GUILDINFO_COLONY_INIT_RADIO(colonyBox)
    local guildObj = GET_MY_GUILD_OBJECT();
    if guildObj == nil then
        return;
    end    

       colonyBox = ui.GetFrame('guildinfo');

    local currentConfigValue = guildObj.EnableEnterColonyWar;
    local radioBtn = GET_CHILD_RECURSIVELY(colonyBox, 'joinRadio_'..currentConfigValue);
    radioBtn:Select();
end

function GUILDINFO_COLONY_UPDATE_OCCUPY_INFO(frame, msg, argStr, argNum)
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local myGuildID = guild.info:GetPartyID();
    local COLONY_EVEN_SKIN = frame:GetUserConfig('COLONY_EVEN_SKIN');
    local occupyInfoBox = GET_CHILD_RECURSIVELY(frame, 'occupyInfoBox');
    occupyInfoBox:RemoveAllChild();
    local occupyCount = session.colonywar.GetOccupationInfoCount();    
    for i = 0, occupyCount - 1 do
        local occupyInfo = session.colonywar.GetOccupationInfoByIndex(i);
        if occupyInfo ~= nil then
            local mapID = occupyInfo:GetLocationID();
            local mapCls = GetClassByType('Map', mapID);
            if occupyInfo:GetGuildID() == myGuildID and mapCls ~= nil then
                local infoCtrlSet = occupyInfoBox:CreateOrGetControlSet('colony_occupy_info', 'OCCUPY_'..mapID, 0, 0);            
                local mapNameText = infoCtrlSet:GetChild('mapNameText');
                mapNameText:SetText(mapCls.Name);

                local grade, rewardPercentage = GET_COLONY_MAP_GRADE_AND_PERCENTAGE(mapCls.QuestLevel);
                local gradeText = infoCtrlSet:GetChild('gradeText');
                local percentText = infoCtrlSet:GetChild('percentText');
                gradeText:SetText(grade);
                percentText:SetTextByKey('percentage', rewardPercentage);

                local rewardItem = GetClass('Item', GET_COLONY_REWARD_ITEM());
                local rewardText = infoCtrlSet:GetChild('rewardText');
                rewardText:SetTextByKey('icon', rewardItem.Icon);
                rewardText:SetTextByKey('name', rewardItem.Name);

                if i % 2 == 1 then
                    local bgBox = infoCtrlSet:GetChild('bgBox');
                    bgBox:SetSkinName(COLONY_EVEN_SKIN);
                end
            end
        end
    end   
    GBOX_AUTO_ALIGN(occupyInfoBox, 0, 0, 0, true, false);
end

function GUILDINFO_COLONY_INIT_INFO(colonyBox)
    local colonyBenefitInfoText = GET_CHILD_RECURSIVELY(colonyBox, 'colonyBenefitInfoText');
    local timeText = string.format('%s %02d:00', ClMsg('ClMsgDay_'..COLONY_REWARD_DAY), COLONY_REWARD_HOUR);
    colonyBenefitInfoText:SetTextByKey('time', timeText);
    colonyBenefitInfoText:SetTextByKey('maxReward', MAX_COLONY_REWARD_SILVER);
end