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

                memberSet:ShowWindow(1);
                geSkillControl.SetPartyMemberTarget(index, partyMemberInfo:GetAID());
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
    local KEY_IMG_SIZE = frame:GetUserConfig('KEY_IMG_SIZE');
    local jumpKeyImg = string.format('{img key_%s %d %d}', jumpKey, KEY_IMG_SIZE, KEY_IMG_SIZE);
    if useShift == 'YES' then
        jumpKeyImg = string.format('{img SHIFT %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    if useAlt == 'YES' then
        jumpKeyImg = string.format('{img alt %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    if useCtrl == 'YES' then
        jumpKeyImg = string.format('{img ctrl %d %d}', KEY_IMG_SIZE, KEY_IMG_SIZE)..jumpKeyImg;
    end
    cancelText:SetTextByKey('img', jumpKeyImg);

    frame:ShowWindow(1);
end

function SELECT_TARGET_FROM_PARTY_SET_TARGET(index)
    local frame = ui.GetFrame('party_recommend');    
    local MAX_SHOW_COUNT = 4;
    for i = 1, MAX_SHOW_COUNT do
        local fan = GET_CHILD_RECURSIVELY(frame, 'fan_'..i);
        if i == index then
            fan:ShowWindow(1);
        else
            fan:ShowWindow(0);
        end
    end
end