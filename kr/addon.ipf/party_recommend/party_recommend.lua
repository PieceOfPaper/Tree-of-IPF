function PARTY_RECOMMEND_ON_INIT(addon, frame)
    addon:RegisterMsg('OPEN_SELECT_TARGET', 'OPEN_SELECT_TARGET_FROM_PARTY');
end

function OPEN_SELECT_TARGET_FROM_PARTY(frame, msg, argStr, showHPGauge)
    -- skill
    local skillID = geSkillControl.GetSelectTargetFromPartyListSkillID();
    local skillCls = GetClassByType('Skill', skillID);
    if skillCls == nil then
        ui.CloseFrame('party_recommend');        
        return;
    end
    
    local skillSlot = GET_CHILD_RECURSIVELY(frame, 'skillSlot');
    local icon = skillSlot:GetIcon();
    if icon == nil then
        icon = CreateIcon(skillSlot);
    end
    icon:SetImage('icon_'..skillCls.Icon);
    
    -- default init
    local MAX_SHOW_COUNT = 4;
    for i = 1, MAX_SHOW_COUNT do
        local memberSet = GET_CHILD_RECURSIVELY(frame, 'memberSet_'..i);
        local fan = GET_CHILD_RECURSIVELY(frame, 'fan_'..i);
        memberSet:ShowWindow(0);
        fan:ShowWindow(0);
    end
    
    -- party member
    local myMapName = session.GetMapName();
    local myMapCls = GetClass('Map', myMapName);
    local partyList = session.party.GetPartyMemberList(PARTY_NORMAL);    
    local emphasizePic = nil;
    local emphasizeValue = nil;
    if partyList ~= nil then
        local count = partyList:Count();
        local index = 1;
        for i = 0, count - 1 do
            local partyMemberInfo = partyList:Element(i);
            if partyMemberInfo:GetAID() ~= session.loginInfo.GetAID() and myMapCls.ClassID == partyMemberInfo:GetMapID() then
                local memberSet = GET_CHILD_RECURSIVELY(frame, 'memberSet_'..index);
                local jobEmblemPic = GET_CHILD(memberSet, 'jobEmblemPic');
                local iconinfo = partyMemberInfo:GetIconInfo();
                local jobCls  = GetClassByType("Job", iconinfo.repre_job);
                if nil ~= jobCls then
                    jobEmblemPic:SetImage(jobCls.Icon);
                end
                local lvText = GET_CHILD(memberSet, 'lvText');
                lvText:SetTextByKey('lv', partyMemberInfo:GetLevel());
                local nameText = GET_CHILD(memberSet, 'nameText');
                nameText:SetTextByKey('name', partyMemberInfo:GetName());

                local stat = partyMemberInfo:GetInst();
                local hpGauge = GET_CHILD(memberSet, 'hpGauge');
                hpGauge:SetPoint(stat.hp, stat.maxhp);
                hpGauge:ShowWindow(showHPGauge);

                if showHPGauge == 1 then
                    if emphasizeValue == nil or (stat.hp < stat.maxhp and emphasizeValue < stat.hp) then
                        emphasizeValue = stat.hp;
                        emphasizePic = memberSet;
                    end
                end

                memberSet:ShowWindow(1);
                geSkillControl.SetPartyMemberTarget(index, partyMemberInfo:GetAID(), argStr);
                index = index + 1;
            end
        end
    end

    -- cancel key
    local cancelText = GET_CHILD_RECURSIVELY(frame, 'cancelText');
    config.InitHotKeyByCurrentUIMode('Battle');    
    local jumpKeyIdx = config.GetHotKeyElementIndex('ID', 'Jump');
    local jumpKey = config.GetHotKeyElementAttributeForConfig(jumpKeyIdx, 'Key');
    local useShift = config.GetHotKeyElementAttributeForConfig(jumpKeyIdx, "UseShift");
    local useAlt = config.GetHotKeyElementAttributeForConfig(jumpKeyIdx, "UseAlt");
    local useCtrl = config.GetHotKeyElementAttributeForConfig(jumpKeyIdx, "UseCtrl");
    local KEY_IMG_SIZE = tonumber(frame:GetUserConfig('KEY_IMG_SIZE'));
    local imgName = 'key_'..jumpKey;
    local originImgWidth = ui.GetImageWidth(imgName);
    local originImgHeight = ui.GetImageHeight(imgName);
    local sizeAmendCoeff = KEY_IMG_SIZE / originImgWidth;
    local jumpKeyImg = string.format('{img %s %d %d}', imgName, KEY_IMG_SIZE, originImgHeight * sizeAmendCoeff);
    if useShift == 'YES' then
        jumpKeyImg = string.format('{img SHIFT %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    if useAlt == 'YES' then
        jumpKeyImg = string.format('{img alt %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    if useCtrl == 'YES' then
        jumpKeyImg = string.format('{img ctrl %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    if IsJoyStickMode() == 0 then
        cancelText:SetTextByKey('img', jumpKeyImg);
    end
    if IsJoyStickMode() == 1 then
        jumpKeyImg = string.format('{img %s %d %d}', "a_button", KEY_IMG_SIZE, originImgHeight * sizeAmendCoeff);
        cancelText:SetTextByKey('img', jumpKeyImg);
    end

    frame:ShowWindow(1);
    geSkillControl.CheckDistancePartyMemberTarget();
end

function SELECT_TARGET_FROM_PARTY_SET_TARGET(index, outRange)
    local frame = ui.GetFrame('party_recommend');    
    local color = frame:GetUserConfig("NEAR_MEMBER_COLORTONE");

    local MAX_SHOW_COUNT = 4;
    for i = 1, MAX_SHOW_COUNT do
        local fan = GET_CHILD_RECURSIVELY(frame, 'fan_'..i);
        local memberSet = GET_CHILD_RECURSIVELY(frame, 'memberSet_'..i);
        local jobEmblemPic = nil;
        if memberSet ~= nil then
            jobEmblemPic = GET_CHILD_RECURSIVELY(memberSet, 'jobEmblemPic');
        end

        if i == index then
            fan:ShowWindow(1);

            if outRange == true then
                color = frame:GetUserConfig("FAR_MEMBER_COLORTONE");
            end
            
            if fan ~= nil and jobEmblemPic ~= nil then
                fan:SetColorTone(color);
                jobEmblemPic:SetColorTone(color);
            end
        else
            fan:ShowWindow(0);
        end
    end
end

function CHECKDIST_SELECT_TARGET_FROM_PARTY(index, outRange)
    local frame = ui.GetFrame("party_recommend");
    if frame == nil then return; end

    local color = frame:GetUserConfig("NEAR_MEMBER_COLORTONE");
    local fan = GET_CHILD_RECURSIVELY(frame, "fan_"..index);
    if fan == nil then return; end

    local memberSet = GET_CHILD_RECURSIVELY(frame, "memberSet_"..index);
    if memberSet == nil then return; end

    local jobEmblemPic = GET_CHILD_RECURSIVELY(memberSet, "jobEmblemPic");
    if jobEmblemPic == nil then return; end

    if outRange == true then
        color = frame:GetUserConfig("FAR_MEMBER_COLORTONE");
    end

    fan:SetColorTone(color);
    jobEmblemPic:SetColorTone(color);
end