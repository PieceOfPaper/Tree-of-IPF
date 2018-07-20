function INDUNENTER_ON_INIT(addon, frame)
    addon:RegisterMsg('MOVE_ZONE', 'INDUNENTER_CLOSE');
    addon:RegisterMsg('CLOSE_UI', 'INDUNENTER_CLOSE');
    addon:RegisterMsg('ESCAPE_PRESSED', 'INDUNENTER_ON_ESCAPE_PRESSED');

    PC_INFO_COUNT = 5;
end

function INDUNENTER_ON_ESCAPE_PRESSED(frame, msg, argStr, argNum)
    if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
        INDUNENTER_CLOSE(frame, msg, argStr, argNum);
    end
end

function INDUNENTER_CLOSE(frame, msg, argStr, argNum)
    INDUNENTER_AUTOMATCH_CANCEL();
    INDUNENTER_PARTYMATCH_CANCEL();
        
    INDUNENTER_MULTI_CANCEL(frame)

    ui.CloseFrame('indunenter');
    CloseIndunEnterDialog();
end

function INDUNENTER_AUTOMATCH_CANCEL()
    local frame = ui.GetFrame('indunenter');
    packet.SendCancelIndunMatching();
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function SHOW_INDUNENTER_DIALOG(indunType, isAlreadyPlaying, enableAutoMatch)
	IMC_LOG("INFO_NORMAL", "Test1111111111");
    -- get data and check
    local indunCls = GetClassByType('Indun', indunType);
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local indunAdmissionItemImage = admissionItemIcon
    local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
    if isTokenState == true then
        isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
    else
        isTokenState = 0
    end
    local etc = GetMyEtcObject();
    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    local nowAdmissionItemCount = admissionItemCount + nowCount - isTokenState
    if indunCls == nil then
        return;
    end

    local frame = ui.GetFrame('indunenter');
    local bigmode = frame:GetChild('bigmode');
    local smallmode = frame:GetChild('smallmode');
    local noPicBox = GET_CHILD_RECURSIVELY(bigmode, 'noPicBox');
    local smallBtn = GET_CHILD_RECURSIVELY(frame, 'smallBtn');
    local withBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
    local autoMatchText = GET_CHILD_RECURSIVELY(frame, 'autoMatchText');
    local enterBtn = GET_CHILD_RECURSIVELY(frame, 'enterBtn');
    
    if frame:IsVisible() == 1 then
        return;
    end
    
    -- set user value
    frame:SetUserValue('INDUN_TYPE', indunType);
    frame:SetUserValue('FRAME_MODE', 'BIG');
    frame:SetUserValue('INDUN_NAME', indunCls.Name);
    frame:SetUserValue('AUTOMATCH_MODE', 'NO');
    frame:SetUserValue('WITHMATCH_MODE', 'NO');
    frame:SetUserValue('AUTOMATCH_FIND', 'NO');
    frame:SetUserValue("multipleCount", 0);
    
    if admissionItemName ~= "None" and admissionItemName ~= nil then
        if admissionItemCount  ~= 0 then
            autoMatchText:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
            enterBtn:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
        end
    end

    -- make controls
    INDUNENTER_MAKE_HEADER(frame);
    INDUNENTER_MAKE_PICTURE(frame, indunCls);
    INDUNENTER_MAKE_COUNT_BOX(frame, noPicBox, indunCls);
    INDUNENTER_MAKE_LEVEL_BOX(frame, noPicBox, indunCls);
    INDUNENTER_MAKE_MULTI_BOX(frame, indunCls);
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
    INDUNENTER_MAKE_MONLIST(frame, indunCls);
    INDUNENTER_MAKE_REWARDLIST(frame, indunCls);

    -- setting
    INDUNENTER_INIT_MEMBERBOX(frame);
    INDUNENTER_AUTOMATCH_TYPE(0);
    INDUNENTER_AUTOMATCH_PARTY(0);
    INDUNENTER_SET_MEMBERCNTBOX();
    INDUNENTER_INIT_REENTER_UNDERSTAFF_BUTTON(frame, isAlreadyPlaying)
    withBtn:SetTextTooltip(ClMsg("PartyMatchInfo_Req"));

    if enableAutoMatch == 0 then
        INDUNENTER_SET_ENABLE(1, 0, 0, 0);
    end

    -- show
    frame:ShowWindow(1);
    bigmode:ShowWindow(1);
    smallmode:ShowWindow(0);
end

function INDUNENTER_INIT_REENTER_UNDERSTAFF_BUTTON(frame, enableReenter)
    if enableReenter == nil then
        enableReenter = frame:GetUserIValue('ENABLE_REENTER');
    end
    local reEnterBtn = GET_CHILD_RECURSIVELY(frame, 'reEnterBtn');
    local understaffEnterAllowBtn = GET_CHILD_RECURSIVELY(frame, 'understaffEnterAllowBtn');
    local smallUnderstaffEnterAllowBtn = GET_CHILD_RECURSIVELY(frame, 'smallUnderstaffEnterAllowBtn');
    
    reEnterBtn:ShowWindow(enableReenter);
    if enableReenter == 1 then
        understaffEnterAllowBtn:ShowWindow(0);
    else
        understaffEnterAllowBtn:ShowWindow(1);
        understaffEnterAllowBtn:SetEnable(0);
    end
    smallUnderstaffEnterAllowBtn:ShowWindow(1);    
    frame:SetUserValue('ENABLE_REENTER', enableReenter);
end

function INDUNENTER_INIT_MEMBERBOX(frame)
    INDUNENTER_INIT_MY_INFO(frame, 'NO');
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function INDUNENTER_INIT_MY_INFO(frame, understaff)
    local pc = GetMyPCObject();
    local aid = session.loginInfo.GetAID();
    local mySession = session.GetMySession();
    local jobID = TryGetProp(pc, "Job");
    local lv = TryGetProp(pc, "Lv");
    if pc == nil or jobID == nil or lv ==  nil or mySession == nil then
        return;
    end
    local cid = mySession:GetCID();

    frame:SetUserValue('MEMBER_INFO', aid..'/'..tostring(jobID)..'/'..tostring(lv)..'/'..cid..'/'..understaff);
end

function INDUNENTER_MAKE_PICTURE(frame, indunCls)
    local mapImage = TryGetProp(indunCls, 'MapImage');
    if frame == nil or mapImage == nil then
        return;
    end
    
    local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
    if mapImage ~= 'None' then
        indunPic:SetImage(mapImage);
    end
end

function INDUNENTER_MAKE_MONLIST(frame, indunCls)
    if frame == nil then
        return;
    end

    local monSlotSet = GET_CHILD_RECURSIVELY(frame, 'monSlotSet');
    local monRightBtn = GET_CHILD_RECURSIVELY(frame, 'monRightBtn');
    local monLeftBtn = GET_CHILD_RECURSIVELY(frame, 'monLeftBtn');
    
    -- init
    monSlotSet:ClearIconAll();
    monSlotSet:SetUserValue('CURRENT_SLOT', 1);
    monSlotSet:SetOffset(monSlotSet:GetOriginalX(), monSlotSet:GetY());

    -- data set
    local bossList = TryGetProp(indunCls, 'BossList');
    if bossList == nil or bossList == 'None' then
        return;
    end
    local bossTable = StringSplit(bossList, '/');
    frame:SetUserValue('MON_SLOT_CNT', #bossTable);

    for i = 1, #bossTable do
        local monIcon = nil;
        local monCls = nil;
        if bossTable[i] == "Random" then
            monIcon = frame:GetUserConfig('RANDOM_ICON');
        else
            monCls = GetClass('Monster', bossTable[i]);
            monIcon = TryGetProp(monCls, 'Icon');
        end

        if monIcon ~= nil then
            local slot = monSlotSet:GetSlotByIndex(i - 1);
            if slot ~= nil then
                local slotIcon = CreateIcon(slot);
                slotIcon:SetImage(monIcon);
                if monCls ~= nil then -- set tooltip
                    slotIcon:SetImage(GET_MON_ILLUST(monCls));
                    slotIcon:SetTooltipType("mon_simple");
                    slotIcon:SetTooltipArg(bossTable[i]);
                    slotIcon:SetTooltipOverlap(1);
                end
            end
        end
    end

    if #bossTable > 5 then
        monRightBtn:SetEnable(1);
        monLeftBtn:SetEnable(0);
    else
        monRightBtn:SetEnable(0);
        monLeftBtn:SetEnable(0);
    end
end

function INDUNENTER_MAKE_REWARDLIST(frame, indunCls)
    if frame == nil then
        return;
    end

    local rewardSlotSet = GET_CHILD_RECURSIVELY(frame, 'rewardSlotSet');
    local rewardRightBtn = GET_CHILD_RECURSIVELY(frame, 'rewardRightBtn');
    local rewardLeftBtn = GET_CHILD_RECURSIVELY(frame, 'rewardLeftBtn');

    -- init 
    rewardSlotSet:ClearIconAll();
    rewardSlotSet:SetOffset(rewardSlotSet:GetOriginalX(), rewardSlotSet:GetY());
    

    -- data set 
    local itemList = TryGetProp(indunCls, 'ItemList');
    if itemList == nil or itemList == 'None' then
        return;
    end
    local itemTable = StringSplit(itemList, '/');
    frame:SetUserValue('REWARD_SLOT_CNT', #itemTable);

    for i = 1, #itemTable do
        local itemIcon = nil;
        if itemTable[i] == "Random" then
            itemIcon = frame:GetUserConfig('RANDOM_ICON');
        else
            local itemCls = GetClass('Item', itemTable[i]);
            itemIcon = TryGetProp(itemCls, 'Icon');
        end

        if itemIcon ~= nil then
            local slot = rewardSlotSet:GetSlotByIndex(i - 1);
            local slotIcon = CreateIcon(slot);
            slotIcon:SetImage(itemIcon);
            SET_ITEM_TOOLTIP_BY_NAME(slot:GetIcon(), itemTable[i]);
            slotIcon:SetTooltipOverlap(1);
        end
    end

    if #itemTable > 5 then
        rewardRightBtn:SetEnable(1);
        rewardLeftBtn:SetEnable(0);
    else
        rewardRightBtn:SetEnable(0);
        rewardLeftBtn:SetEnable(0);
    end
end

function GET_MY_INDUN_MULTIPLE_ITEM_COUNT()
    local count = 0;
    local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
    for i = 1, #multipleItemList do
        local itemClassName = multipleItemList[i];
        count = count + GET_INVENTORY_ITEM_COUNT_BY_NAME(itemClassName);
    end
    return count;
end

function INDUNENTER_MAKE_MULTI_BOX(frame, indunCls)
    if frame == nil then
        return;
    end
    local multiBox = GET_CHILD_RECURSIVELY(frame, 'multiBox');
    local multiBtn = GET_CHILD_RECURSIVELY(frame, 'multiBtn');
    local arrow = GET_CHILD_RECURSIVELY(frame, 'arrow');
    local indunType = TryGetProp(indunCls, "PlayPerResetType");
    local viewBOX = false;
    
    -- view setting 
    multiBtn:ShowWindow(1);
    multiBtn:SetEnable(1);
    if indunType == 100 or indunType == 200 then
        viewBOX = true;
    end

    local multipleItemCount = GET_MY_INDUN_MULTIPLE_ITEM_COUNT();
    if viewBOX == false or multipleItemCount == 0 then
        multiBtn:SetEnable(0);
        return;
    end

    local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
    local maxMultiCnt = INDUN_MULTIPLE_USE_MAX_COUNT - 1; --frame:GetUserIValue('MAX_MULTI_CNT');
    local multiDefault = frame:GetUserConfig('MULTI_DEFAULT');
    
    multiEdit:SetText(multiDefault);
    multiEdit:SetMaxNumber(maxMultiCnt);
    multiBox:ShowWindow(1);
    arrow:ShowWindow(1);
    
    local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, "multiCancelBtn");
    multiCancelBtn:ShowWindow(0);
end

function INDUNENTER_MAKE_HEADER(frame)
    if frame == nil then
        return;
    end
    local header = frame:GetChild('header');
    local bigModeWidth = header:GetOriginalWidth();
    local smallModeWidth = tonumber(frame:GetUserConfig('SMALLMODE_WIDTH'));
    local indunName = header:GetChild('indunName');
    local indunNameTxt = frame:GetUserValue('INDUN_NAME');

    if frame:GetUserValue('FRAME_MODE') == "BIG" then
        header:Resize(bigModeWidth, header:GetHeight());
        indunName:SetText(indunNameTxt);
    else
        header:Resize(smallModeWidth, header:GetHeight());
        indunName:SetText(ClMsg("AutoMatchIng"));
    end

end

function INDUNENTER_MAKE_COUNT_BOX(frame, noPicBox, indunCls)
    local etc = GetMyEtcObject();
    if frame == nil or noPicBox == nil or indunCls == nil or etc == nil then
        return;
    end
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local indunAdmissionItemImage = admissionItemIcon
    
    if admissionItemCount == nil then
        admissionItemCount = 0;
    end
    
    admissionItemCount = math.floor(admissionItemCount);
    
    if admissionItemName == "None" or admissionItemName == nil or admissionItemCount == 0 then
        -- now play count
        local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
        countData:SetTextByKey("now", nowCount);
        -- max play count
        local maxCount = TryGetProp(indunCls, 'PlayPerReset');
        if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
            maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token')
        end
        if session.loginInfo.IsPremiumState(NEXON_PC) == true then
            maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_NexonPC')
        end
        countData:SetTextByKey("max", maxCount);
    
        -- set min/max multi count
        local minCount = frame:GetUserConfig('MULTI_MIN');
        frame:SetUserValue("MIN_MULTI_CNT", minCount);
        frame:SetUserValue("MAX_MULTI_CNT", maxCount - nowCount);
        
        local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
        countData:ShowWindow(1)
        countItemData:ShowWindow(0)
    else
        local pc = GetMyPCObject();
        if pc == nil then
            return;
        end
        
        local invAdmissionItemCount = GetInvItemCount(pc, admissionItemName)
        countItemData:SetTextByKey("ivnadmissionitem",  '  {img '..indunAdmissionItemImage..' 30 30}  '..invAdmissionItemCount ..'')
        
        local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
        countText:SetText(ScpArgMsg("IndunAdmissionItemPossession"))
        countItemData:ShowWindow(1)
        countData:ShowWindow(0)
    end
end

function INDUNENTER_MAKE_LEVEL_BOX(frame, noPicBox, indunCls)
    if frame == nil or frame == noPicBox or indunCls == nil then
        return;
    end
    local lvData = GET_CHILD_RECURSIVELY(noPicBox, 'lvData');
    lvData:SetText(TryGetProp(indunCls, 'Level'));
end

function INDUNENTER_MAKE_PARTY_CONTROLSET(pcCount, memberTable, understaffCount)
    local frame = ui.GetFrame('indunenter');
    local partyLine = GET_CHILD_RECURSIVELY(frame, 'partyLine');
    local memberBox = GET_CHILD_RECURSIVELY(frame, 'memberBox');
    local memberCnt = #memberTable / PC_INFO_COUNT;

    if pcCount < 1 then -- member초기화해주자
        memberCnt = 0;
    end

    local prevPcCnt = frame:GetUserIValue('UI_PC_COUNT');
    frame:SetUserValue('UI_PC_COUNT', pcCount);
    
    if prevPcCnt < pcCount then
        local MEMBER_FINDED_SOUND = frame:GetUserConfig('MEMBER_FINDED_SOUND');
        imcSound.PlaySoundEvent(MEMBER_FINDED_SOUND);
    end
    
    local previousUnderstaffCount = frame:GetUserIValue('UI_UNDERSTAFF_COUNT');
    frame:SetUserValue('UI_UNDERSTAFF_COUNT', understaffCount);
    
    if previousUnderstaffCount < understaffCount then
        local UNDERSTAFF_CHECK_SOUND = frame:GetUserConfig('UNDERSTAFF_CHECK_SOUND');
        imcSound.PlaySoundEvent(UNDERSTAFF_CHECK_SOUND);
    end
    
    if memberCnt > 1 then 
        partyLine:Resize(58 * (memberCnt - 1), 15);
        partyLine:ShowWindow(1);
    else
        partyLine:ShowWindow(0);
    end
    DESTROY_CHILD_BYNAME(memberBox, 'MEMBER_');
    
    local understaffShowCount = 0;
    for i = 1, INDUN_AUTOMATCHING_PCCOUNT do
        local memberCtrlSet = memberBox:CreateOrGetControlSet('indunMember', 'MEMBER_'..tostring(i), 10 * i + 58 * (i - 1), 0);
        memberCtrlSet:ShowWindow(1);

        -- default setting
        local leaderImg = memberCtrlSet:GetChild('leader_img');
        local levelText = memberCtrlSet:GetChild('level_text');
        local jobIcon = GET_CHILD_RECURSIVELY(memberCtrlSet, 'jobportrait');
        local matchedIcon = GET_CHILD_RECURSIVELY(memberCtrlSet, 'matchedIcon');
        local NO_MATCH_SKIN = frame:GetUserConfig('NO_MATCH_SKIN');
        local understaffAllowImg = memberCtrlSet:GetChild('understaffAllowImg');

        levelText:ShowWindow(0);
        leaderImg:ShowWindow(0);
        jobIcon:SetImage(NO_MATCH_SKIN);
        matchedIcon:ShowWindow(0);
        understaffAllowImg:ShowWindow(0);

        if i <= pcCount then -- 참여한 인원만큼 보여주는 부분
            if i * PC_INFO_COUNT <= #memberTable then -- 파티원인 경우      
                -- show leader
                local aid = memberTable[i * PC_INFO_COUNT - (PC_INFO_COUNT - 1)];
                local pcparty = session.party.GetPartyInfo(PARTY_NORMAL);
                if pcparty ~= nil and pcparty.info:GetLeaderAID() == aid then
                    leaderImg:ShowWindow(1);
                end

                -- show job icon
                local jobCls = GetClassByType("Job", tonumber(memberTable[i * PC_INFO_COUNT - (PC_INFO_COUNT - 2)]));
                local jobIconData = TryGetProp(jobCls, 'Icon');
                if jobIconData ~= nil then
                    jobIcon:SetImage(jobIconData);
                end

                -- show level
                local lv = memberTable[i * PC_INFO_COUNT - (PC_INFO_COUNT - 3)];
                levelText:SetText(lv);
                levelText:ShowWindow(1);

                -- set tooltip
                local cid = memberTable[i * PC_INFO_COUNT - (PC_INFO_COUNT - 4)];
                PARTY_JOB_TOOLTIP_BY_CID(cid, jobIcon, jobCls);

                -- show understaff
                local understaffAllowMember = memberTable[i * PC_INFO_COUNT - (PC_INFO_COUNT - 5)];
                if understaffAllowMember == 'YES' then
                    understaffAllowImg:ShowWindow(1);
                    understaffShowCount = understaffShowCount + 1;
                end
            else -- 파티원은 아닌데 매칭된 사람
                jobIcon:ShowWindow(0);
                matchedIcon:ShowWindow(1);

                -- show understaff
                if understaffShowCount < understaffCount then
                    understaffAllowImg:ShowWindow(1);
                    understaffShowCount = understaffShowCount + 1;
                end
            end
            
        end
    end
end

function INDUNENTER_MULTI_UP(frame, ctrl)
    if frame == nil or ctrl == nil then
        return;
    end
    local multiEdit = GET_CHILD(frame, 'multiEdit');
    local nowCnt = multiEdit:GetNumber();
    local topFrame = frame:GetTopParentFrame();
    --local maxCnt = topFrame:GetUserIValue('MAX_MULTI_CNT');
    local maxCnt = INDUN_MULTIPLE_USE_MAX_COUNT;
    
    local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
    for i = 1, #multipleItemList do
        local itemName = multipleItemList[i];
        local invItem = session.GetInvItemByName(itemName);
        if invItem ~= nil and invItem.isLockState then
            ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end
    end
       
    local itemCount = GET_MY_INDUN_MULTIPLE_ITEM_COUNT();    
    if itemCount == 0 then
        return;
    end

    nowCnt = nowCnt + 1;

    local etc = GetMyEtcObject();
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    if indunCls == nil then
        return;
    end

    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));

    local maxCount = TryGetProp(indunCls, 'PlayPerReset');
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
		maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token');
    end

    local remainCount = maxCount - nowCount;

    if nowCnt >= remainCount then
        nowCnt = remainCount - 1;
        ui.SysMsg(ScpArgMsg('NotEnoughIndunEnterCount'));
    elseif nowCnt == maxCnt then
        ui.SysMsg(ScpArgMsg('IndunMultipleMAX'));
        return
    end
    
    if nowCnt - 1 >= itemCount then
        ui.SysMsg(ScpArgMsg('NotEnoughIndunMultipleItem'));
        return;
    end

    if nowCnt < 0 then
        return;
    end

    local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
    local imgName = string.format("indun_x%d", nowCnt + 1);
    rateValue:SetImage(imgName);
    multiEdit:SetText(tostring(nowCnt));
end

function INDUNENTER_MULTI_DOWN(frame, ctrl)
    if frame == nil or ctrl == nil then
        return;
    end
    local multiEdit = GET_CHILD(frame, 'multiEdit');
    local nowCnt = multiEdit:GetNumber();
    local topFrame = frame:GetTopParentFrame();
    local minCnt = topFrame:GetUserIValue('MIN_MULTI_CNT');

    nowCnt = nowCnt - 1;
    if nowCnt < minCnt then
        nowCnt = minCnt;
    end

    local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
    local imgName = string.format("indun_x%d", nowCnt + 1);
    rateValue:SetImage(imgName);
    multiEdit:SetText(tostring(nowCnt));
end

function INDUNENTER_SMALL(frame, ctrl, forceSmall)
    if frame == nil then
        return;
    end
    local topFrame = frame:GetTopParentFrame();
    local bigmode = topFrame:GetChild('bigmode');
    local smallmode = topFrame:GetChild('smallmode');
    local header = topFrame:GetChild('header');

    if forceSmall == true and topFrame:GetUserValue('FRAME_MODE') == 'SMALL' then
        return;
    end
    
    if topFrame:GetUserValue('FRAME_MODE') == "BIG" then    -- to small mode
        if topFrame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
            ui.SysMsg(ScpArgMsg('EnableWhenAutoMatching'));
            return;
        end
        bigmode:ShowWindow(0);
        smallmode:ShowWindow(1);
        topFrame:SetUserValue('FRAME_MODE', 'SMALL');
        topFrame:Resize(smallmode:GetWidth(), smallmode:GetHeight());
    else                                            -- to big mode
        bigmode:ShowWindow(1);
        smallmode:ShowWindow(0);
        topFrame:SetUserValue('FRAME_MODE', 'BIG');
        topFrame:Resize(bigmode:GetWidth(), bigmode:GetHeight());

        INDUNENTER_AMEND_OFFSET(topFrame);
    end
    INDUNENTER_MAKE_HEADER(topFrame);

    frame:ShowWindow(1);
end

function INDUNENTER_ENTER(frame, ctrl)
    local topFrame = frame:GetTopParentFrame();
    if INDUNENTER_CHECK_ADMISSION_ITEM(topFrame) == false then
        return;
    end

    local textCount = topFrame:GetUserIValue("multipleCount");
    local yesScript = string.format("ReqMoveToIndun(%d,%d)", 1, textCount);
    ui.MsgBox(ScpArgMsg("EnterRightNow"), yesScript, "None");
end

function INDUNENTER_AUTOMATCH(frame, ctrl)
    local topFrame = frame:GetTopParentFrame();
    if INDUNENTER_CHECK_ADMISSION_ITEM(topFrame) == false then
        return;
    end

    local textCount = topFrame:GetUserIValue("multipleCount");
    if topFrame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
        ReqMoveToIndun(2, textCount);
    else
        INDUNENTER_AUTOMATCH_CANCEL();
    end
end

function INDUNENTER_PARTYMATCH(frame, ctrl)
    if session.party.GetPartyInfo(PARTY_NORMAL) == nil then 
        ui.SysMsg(ClMsg('HadNotMyParty'));
        return;
    end

    local topFrame = frame:GetTopParentFrame();
    if INDUNENTER_CHECK_ADMISSION_ITEM(topFrame) == false then
        return;
    end

    local textCount = topFrame:GetUserIValue("multipleCount");
    local partyAskText = GET_CHILD_RECURSIVELY(topFrame, "partyAskText");
    local understaffEnterAllowBtn = GET_CHILD_RECURSIVELY(topFrame, 'understaffEnterAllowBtn');

    if topFrame:GetUserValue('WITHMATCH_MODE') == 'NO' then
        ReqMoveToIndun(3, textCount);
        ctrl:SetTextTooltip(ClMsg("PartyMatchInfo_Go"));
        understaffEnterAllowBtn:ShowWindow(1);
        INDUNENTER_SET_ENABLE(0, 0, 1, 0);
    else
        ReqRegisterToIndun(topFrame:GetUserIValue('INDUN_TYPE'));
        ctrl:SetTextTooltip(ClMsg("PartyMatchInfo_Req"));
        INDUNENTER_SET_ENABLE(0, 1, 0, 0);
    end
end

function INDUNENTER_PARTYMATCH_CANCEL()
    local frame = ui.GetFrame('indunenter');
    local indunType = frame:GetUserIValue("INDUN_TYPE");
    local indunCls = GetClassByType('Indun', indunType);
    if frame ~= nil and indunCls ~= nil then
        packet.SendCancelIndunPartyMatching();
    end
    local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');
    withTime:SetText(ClMsg('MatchWithParty'));
end

function INDUNENTER_SET_WAIT_PC_COUNT(pcCount)
    local frame = ui.GetFrame('indunenter');
    if frame == nil or frame:IsVisible() ~= 1 then
        return;
    end
    local memberCntText = GET_CHILD_RECURSIVELY(frame, 'memberCntText');
    memberCntText:SetTextByKey('cnt', pcCount..ClMsg('PersonCountUnit'));
end

function INDUNENTER_SET_MEMBERCNTBOX()
    local frame = ui.GetFrame('indunenter');
    local memberCntBox = GET_CHILD_RECURSIVELY(frame, 'memberCntBox');
    local memberCntText = GET_CHILD_RECURSIVELY(frame, 'memberCntText');
    local partyAskText = GET_CHILD_RECURSIVELY(frame, 'partyAskText');
    
    if frame:GetUserValue('WITHMATCH_MODE') == 'YES' then
        memberCntText:ShowWindow(0);
        partyAskText:ShowWindow(1);
    elseif frame:GetUserValue('AUTOMATCH_MODE') == 'YES' then
        memberCntText:ShowWindow(1);
        partyAskText:ShowWindow(0);
    else
        memberCntBox:ShowWindow(0);
        return;
    end
    memberCntBox:ShowWindow(1);
end

function INDUNENTER_AUTOMATCH_TYPE(indunType, needUnderstaffAllow)
    if needUnderstaffAllow == nil then
        needUnderstaffAllow = 1;
    end
    local frame = ui.GetFrame("indunenter");
    local memberCntBox = GET_CHILD_RECURSIVELY(frame, 'memberCntBox');
    local autoMatchText = GET_CHILD_RECURSIVELY(frame, 'autoMatchText');
    local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
    local withBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
    local smallBtn = GET_CHILD_RECURSIVELY(frame, 'smallBtn');
    local smallmode = GET_CHILD_RECURSIVELY(frame, 'smallmode');
    local cancelAutoMatch = GET_CHILD_RECURSIVELY(frame, 'cancelAutoMatch');
    local understaffEnterAllowBtn = GET_CHILD_RECURSIVELY(frame, 'understaffEnterAllowBtn');

    if indunType == 0 then
        frame:SetUserValue('AUTOMATCH_MODE', 'NO');
        frame:SetUserValue('EXCEPT_CLOSE_TARGET', 'NO');
        autoMatchText:ShowWindow(1);
        autoMatchTime:ShowWindow(0);

        INDUNENTER_SET_ENABLE(1, 1, 1, 1);
        INDUNENTER_INIT_MEMBERBOX(frame);
        INDUNENTER_INIT_REENTER_UNDERSTAFF_BUTTON(frame);

        if frame:GetUserValue('FRAME_MODE') == "SMALL" then
            INDUNENTER_SMALL(frame, smallBtn);
        end
    elseif frame:GetUserValue('AUTOMATCH_MODE') ~= 'YES' then
        frame:SetUserValue('AUTOMATCH_MODE', 'YES');
        frame:SetUserValue('EXCEPT_CLOSE_TARGET', 'YES');
        autoMatchText:ShowWindow(0);
        cancelAutoMatch:SetEnable(1);
        understaffEnterAllowBtn:ShowWindow(1);

        INDUNENTER_UNDERSTAFF_BTN_ENABLE(frame, needUnderstaffAllow);
        INDUNENTER_AUTOMATCH_TIMER_START(frame);
        INDUNENTER_SET_ENABLE(0, 1, 0, 0);
        INDUNENTER_MAKE_SMALLMODE(frame, false);
    end
    
    INDUNENTER_SET_MEMBERCNTBOX();
end

function INDUNENTER_AUTOMATCH_TIMER_START(frame)
    local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
    autoMatchTime:ShowWindow(1);

    frame:SetUserValue("START_TIME", os.time());
    frame:RunUpdateScript("_INDUNENTER_AUTOMATCH_UPDATE_TIME", 0.5);
    _INDUNENTER_AUTOMATCH_UPDATE_TIME(frame);
end

function _INDUNENTER_AUTOMATCH_UPDATE_TIME(frame)
    local elaspedSec = os.time() - frame:GetUserIValue("START_TIME");
    local minute = math.floor(elaspedSec / 60);
    local second = elaspedSec % 60;
    local txt = string.format("%02d:%02d", minute, second);

    local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
    local smallMatchTime = GET_CHILD_RECURSIVELY(frame, 'matchTime');
    autoMatchTime:SetText(txt);
    smallMatchTime:SetText(txt);

    if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' or frame:GetUserValue('AUTOMATCH_FIND') == 'YES' then
        autoMatchTime:ShowWindow(0);
        return 0;
    end

    return 1;
end

function INDUNENTER_SMALLMODE_CANCEL(frame, ctrl)
    INDUNENTER_AUTOMATCH_CANCEL();
end

function INDUNENTER_AUTOMATCH_PARTY(numWaiting, level, limit, indunLv, indunName, elapsedTime)
    local frame = ui.GetFrame("indunenter");
    local withText = GET_CHILD_RECURSIVELY(frame, 'withText');
    local withTime = GET_CHILD_RECURSIVELY(frame, 'withTime');
    local memberCntBox = GET_CHILD_RECURSIVELY(frame, 'memberCntBox');
    local partyAskText = GET_CHILD_RECURSIVELY(frame, 'partyAskText');
    
    if numWaiting == 0 then -- party match cancel
        frame:SetUserValue('WITHMATCH_MODE', 'NO');
        withText:ShowWindow(1);
        withTime:ShowWindow(0);
    else                    -- party match start
        -- level info
        local lowerBound = level - limit;
        local upperBound = level + limit;
        if lowerBound < indunLv then
            lowerBound = indunLv;
        end
        if upperBound > PC_MAX_LEVEL then
            upperBound = PC_MAX_LEVEL;
        end 
        partyAskText:SetTextByKey("value", ScpArgMsg("MatchWithParty").."(Lv."..tostring(lowerBound)..'~'..tostring(upperBound)..")");  

        -- frame info
        frame:SetUserValue('WITHMATCH_MODE', 'YES');
        withText:ShowWindow(0);
        withTime:ShowWindow(1);
        INDUNENTER_SET_ENABLE(0, 0, 1, 0);
        INDUNENTER_UNDERSTAFF_BTN_ENABLE(frame, 1);
    end

    INDUNENTER_SET_MEMBERCNTBOX();
end

function INDUNENTER_SET_ENABLE_MULTI(enable)
    local frame = ui.GetFrame('indunenter');
    local multiBtn = GET_CHILD_RECURSIVELY(frame, 'multiBtn');
    local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, 'multiCancelBtn');
    local upBtn = GET_CHILD_RECURSIVELY(frame, 'upBtn');
    local downBtn = GET_CHILD_RECURSIVELY(frame, 'downBtn');
    
    multiBtn:SetEnable(enable);
    multiCancelBtn:SetEnable(enable);
    upBtn:SetEnable(enable);
    downBtn:SetEnable(enable);
end

function INDUNENTER_SET_ENABLE(enter, autoMatch, withParty, multi)
    local frame = ui.GetFrame('indunenter');
    local enterBtn = GET_CHILD_RECURSIVELY(frame, 'enterBtn');
    local autoMatchBtn = GET_CHILD_RECURSIVELY(frame, 'autoMatchBtn');
    local withPartyBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
    local multiBtn = GET_CHILD_RECURSIVELY(frame, 'multiBtn');
    local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, 'multiCancelBtn');
    local reEnterBtn = GET_CHILD_RECURSIVELY(frame, 'reEnterBtn');
    
    enterBtn:SetEnable(enter);
    autoMatchBtn:SetEnable(autoMatch);
    withPartyBtn:SetEnable(withParty);
    INDUNENTER_SET_ENABLE_MULTI(multi);

    -- multi btn: 배수토큰 있어야 사용 가능. 인던/의뢰소 미션만 사용가능
    local indunCls = GetClassByType('Indun', frame:GetUserIValue('INDUN_TYPE'));
    local resetType = TryGetProp(indunCls, 'PlayPerResetType');
    local itemCount = GET_INDUN_MULTIPLE_ITEM_LIST();
    if itemCount == 0 or (resetType ~= 100 and resetType ~= 200) then
        INDUNENTER_SET_ENABLE_MULTI(0);
    end
end

function INDUNENTER_UPDATE_PC_COUNT(frame, msg, infoStr, pcCount, understaffCount) -- infoStr: aid/jobID/level/CID/understaffAllow(YES/NO)
    if frame == nil then
        return;
    end
    if understaffCount == nil then
        understaffCount = 0;
    end
    
	-- enable auto match, with match mode; except initialize
	if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' and frame:GetUserValue('WITHMATCH_MODE') == 'NO' and pcCount > 0 then
		return;
	end

    -- update pc count
    if infoStr == nil then
        infoStr = "None";
    end

    local memberInfo = frame:GetUserValue('MEMBER_INFO');
    if infoStr ~= "None" then -- update party member info
        memberInfo = infoStr;
        frame:SetUserValue('MEMBER_INFO', memberInfo);
    end

    local memberTable = StringSplit(memberInfo, '/');
    INDUNENTER_MAKE_PARTY_CONTROLSET(pcCount, memberTable, understaffCount);
    INDUNENTER_UPDATE_SMALLMODE_PC(pcCount, understaffCount);
end

function INDUNENTER_UPDATE_SMALLMODE_PC(pcCount, understaffCount)
    local frame = ui.GetFrame("indunenter");
    local YES_MATCH_SKIN = frame:GetUserConfig('YES_MATCH_SKIN');

    local matchPCBox = GET_CHILD_RECURSIVELY(frame, 'matchPCBox');
    matchPCBox:RemoveAllChild();
    local notWaitingCount = INDUN_AUTOMATCHING_PCCOUNT - pcCount;

    local pictureIndex = 0;
    local understaffShowCount = 0;
    for i = 0 , pcCount - 1 do
        local ctrlset = matchPCBox:CreateOrGetControlSet("smallIndunMember", "MAN_PICTURE_" .. pictureIndex, 0, 0);
        ctrlset:SetGravity(ui.LEFT, ui.CENTER_VERT);
        local pic = ctrlset:GetChild('pcImg');
        local understaffAllowPic = ctrlset:GetChild('understaffAllowImg');
        AUTO_CAST(pic);
        pic:SetEnableStretch(1);
        pic:SetImage(YES_MATCH_SKIN);
        if understaffShowCount < understaffCount then
            understaffAllowPic:ShowWindow(1);
            understaffShowCount = understaffShowCount + 1;
        else
            understaffAllowPic:ShowWindow(0);
        end
        pictureIndex = pictureIndex + 1;
    end

    for i = 0 , notWaitingCount - 1 do
        local ctrlset = matchPCBox:CreateOrGetControlSet("smallIndunMember", "MAN_PICTURE_" .. pictureIndex, 0, 0);
        ctrlset:SetGravity(ui.LEFT, ui.CENTER_VERT);
        local pic = ctrlset:GetChild('pcImg');
        local understaffAllowPic = ctrlset:GetChild('understaffAllowImg');
        AUTO_CAST(pic);
        pic:SetEnableStretch(1);
        pic:SetColorTone("FF222222");
        pic:SetImage(YES_MATCH_SKIN);
        understaffAllowPic:ShowWindow(0);
        pictureIndex = pictureIndex + 1;
    end
    
    GBOX_AUTO_ALIGN_HORZ(matchPCBox, 0, 0, 0, true, true);
end

function INDUNENTER_MAKE_SMALLMODE(frame, isSuccess)
    local matchSuccBox = GET_CHILD_RECURSIVELY(frame, 'matchSuccBox');
    local autoMatchBox = GET_CHILD_RECURSIVELY(frame, 'autoMatchBox');

    if isSuccess == false then
        matchSuccBox:ShowWindow(0);
        autoMatchBox:ShowWindow(1);
    else
        matchSuccBox:ShowWindow(1);
        autoMatchBox:ShowWindow(0);
    end     
end

function INDUNENTER_AUTOMATCH_FINDED()
    local frame = ui.GetFrame('indunenter');
    local cancelAutoMatch = GET_CHILD_RECURSIVELY(frame, 'cancelAutoMatch');
    local autoMatchText = GET_CHILD_RECURSIVELY(frame, 'autoMatchText');
    local autoMatchTime = GET_CHILD_RECURSIVELY(frame, 'autoMatchTime');
    local indunName = GET_CHILD_RECURSIVELY(frame, 'indunName');

    cancelAutoMatch:SetEnable(0);
    indunName:SetText(ClMsg('AutoMatchComplete'));
    frame:SetUserValue('AUTOMATCH_FIND', 'YES');
    autoMatchText:SetText(ClMsg('PILGRIM41_1_SQ07_WATER'));
    autoMatchTime:ShowWindow(0);
    autoMatchText:ShowWindow(1);

    -- play matching sound
    local MATCH_FINDED_SOUND = frame:GetUserConfig('MATCH_FINDED_SOUND');
    imcSound.PlaySoundEvent(MATCH_FINDED_SOUND);

    app.SetWindowTopMost();

    INDUNENTER_SET_ENABLE(0, 0, 0, 0);
    INDUNENTER_MAKE_SMALLMODE(frame, true);
    INDUNENTER_AUTOMATCH_FIND_TIMER_START(frame);
end

function INDUNENTER_AUTOMATCH_FIND_TIMER_START(frame)
    local gaugeBar = GET_CHILD_RECURSIVELY(frame, 'gaugeBar');
    gaugeBar:SetPoint(5, 5);

    frame:SetUserValue("START_TIME", os.time());
    frame:RunUpdateScript("_INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME", 0.1);
    _INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME(frame);
end

function _INDUNENTER_AUTOMATCH_FIND_UPDATE_TIME(frame)
    local elapsedSec = os.time() - frame:GetUserIValue("START_TIME");
    local gaugeBar = GET_CHILD_RECURSIVELY(frame, 'gaugeBar');
    gaugeBar:SetPointWithTime(0, 5 - elapsedSec);

    return 1;   
end

function INDUNENTER_AUTOMATCH_PARTY_SET_COUNT(memberCnt, memberInfo, understaffCount)
    local frame = ui.GetFrame('indunenter');
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, memberInfo, memberCnt, understaffCount);
end

function INDUNENTER_REENTER(frame, ctrl)
    local topFrame = frame:GetTopParentFrame();
    local textCount = topFrame:GetUserIValue("multipleCount");
    ReqMoveToIndun(4, textCount);
end

function INDUNENTER_MON_CLICK_RIGHT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local monSlotCnt = topFrame:GetUserIValue('MON_SLOT_CNT');
    if monSlotCnt < 6 then
        return;
    end

    local monSlotSet = GET_CHILD_RECURSIVELY(topFrame, 'monSlotSet');
    local currentSlot = monSlotSet:GetUserIValue('CURRENT_SLOT');
    if currentSlot + 4 == monSlotCnt then
        return;
    end
            
    UI_PLAYFORCE(monSlotSet, "slotsetLeftMove_1");
    monSlotSet:SetUserValue('CURRENT_SLOT', currentSlot + 1);

    -- button enable
    if currentSlot + 5 == monSlotCnt then
       ctrl:SetEnable(0);
    end
    local leftBtn = GET_CHILD_RECURSIVELY(topFrame, 'monLeftBtn');
    leftBtn:SetEnable(1);
end

function INDUNENTER_MON_CLICK_LEFT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local monSlotCnt = topFrame:GetUserIValue('MON_SLOT_CNT');
    if monSlotCnt < 6 then
        return;
    end

    local monSlotSet = GET_CHILD_RECURSIVELY(topFrame, 'monSlotSet');
    local currentSlot = monSlotSet:GetUserIValue('CURRENT_SLOT');
    if currentSlot == 1 then
        return;
    end
        
    UI_PLAYFORCE(monSlotSet, "slotsetRightMove_1");
    monSlotSet:SetUserValue('CURRENT_SLOT', currentSlot - 1);

     -- button enable
    if currentSlot - 1 == 1 then
       ctrl:SetEnable(0);
    end
    local rightBtn = GET_CHILD_RECURSIVELY(topFrame, 'monRightBtn');
    rightBtn:SetEnable(1);
end

function INDUNENTER_REWARD_CLICK_RIGHT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local rewardSlotCnt = topFrame:GetUserIValue('REWARD_SLOT_CNT');
    if rewardSlotCnt < 6 then
        return;
    end

    local rewardSlotSet = GET_CHILD_RECURSIVELY(topFrame, 'rewardSlotSet');
    local currentSlot = rewardSlotSet:GetUserIValue('CURRENT_SLOT');
    if currentSlot + 4 == rewardSlotCnt then
        return;
    end
        
    UI_PLAYFORCE(rewardSlotSet, "slotsetLeftMove_1");
    rewardSlotSet:SetUserValue('CURRENT_SLOT', currentSlot + 1);

    -- button enable
    if currentSlot + 5 == rewardSlotCnt then
       ctrl:SetEnable(0);
    end
    local leftBtn = GET_CHILD_RECURSIVELY(topFrame, 'rewardLeftBtn');
    leftBtn:SetEnable(1);   
end

function INDUNENTER_REWARD_CLICK_LEFT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local rewardSlotCnt = topFrame:GetUserIValue('REWARD_SLOT_CNT');
    if rewardSlotCnt < 6 then
        return;
    end

    local rewardSlotSet = GET_CHILD_RECURSIVELY(topFrame, 'rewardSlotSet');
    local currentSlot = rewardSlotSet:GetUserIValue('CURRENT_SLOT');
    if currentSlot == 1 then
        return;
    end
        
    UI_PLAYFORCE(monSlotSet, "slotsetRightMove_1");
    rewardSlotSet:SetUserValue('CURRENT_SLOT', currentSlot - 1);

    -- button enable
    if currentSlot - 1 == 1 then
       ctrl:SetEnable(0);
    end
    local rightBtn = GET_CHILD_RECURSIVELY(topFrame, 'rewardRightBtn');
    rightBtn:SetEnable(1);
end

function INDUNENTER_MULTI_EXEC(frame, ctrl)
    
    local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
    for i = 1, #multipleItemList do
        local itemName = multipleItemList[i];
        local invItem = session.GetInvItemByName(itemName);
        if invItem ~= nil and invItem.isLockState then
            ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end
    end
    
    local indunenterFrame = ui.GetFrame('indunenter');
    local indunType = indunenterFrame:GetUserValue('INDUN_TYPE');

    local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
    local textCount = multiEdit:GetNumber();

    if textCount == 0 then
        return;
    end

    if textCount >= INDUN_MULTIPLE_USE_MAX_COUNT then
        multiEdit:SetText(tostring(0));
        return;
    end

    local indunCls = GetClassByType('Indun', indunType);
    if indunCls == nil then
        return;
    end

    local etc = GetMyEtcObject();

    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    --
    local maxCount = TryGetProp(indunCls, 'PlayPerReset');
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
		maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token');
    end

    local remainCount = maxCount - nowCount;

    if textCount >= remainCount then
        ui.SysMsg(ScpArgMsg('NotEnoughIndunEnterCount'));
        return;
    end

    local itemCount = GET_MY_INDUN_MULTIPLE_ITEM_COUNT();
    if itemCount < textCount then
        ui.SysMsg(ScpArgMsg('NotEnoughIndunMultipleItem'));
        return;
    end

    local topFrame = frame:GetTopParentFrame();
    topFrame:SetUserValue("multipleCount", textCount);

    local multiCancelBtn = GET_CHILD_RECURSIVELY(frame, "multiCancelBtn");
    multiCancelBtn:ShowWindow(1);
    local multiBtn = GET_CHILD_RECURSIVELY(frame, "multiBtn");
    multiBtn:ShowWindow(0);
end

function INDUN_MULTIPLE_CHECK_NUMBER(frame)
    local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
    for i = 1, #multipleItemList do
        local itemName = multipleItemList[i];
        local invItem = session.GetInvItemByName(itemName);
        if invItem ~= nil and invItem.isLockState then
            ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end
    end

    local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
    local textCount = multiEdit:GetNumber();
    if textCount >= INDUN_MULTIPLE_USE_MAX_COUNT then
        multiEdit:SetText(tostring(0));
        return;
    end
    local topFrame = frame:GetTopParentFrame(); 

    local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
    local imgName = string.format("indun_x%d", textCount + 1);
    rateValue:SetImage(imgName);
end

function INDUNENTER_MULTI_CANCEL(frame, ctrl)
    local topFrame = frame:GetTopParentFrame(); 
    local multiEdit = GET_CHILD_RECURSIVELY(topFrame, 'multiEdit');
    multiEdit:SetText(tostring(0));

    local rateValue = GET_CHILD_RECURSIVELY(topFrame, "RateValue");
    rateValue:SetImage("indun_x1");

    topFrame:SetUserValue("multipleCount", 0);

    local multiCancelBtn = GET_CHILD_RECURSIVELY(topFrame, "multiCancelBtn");
    multiCancelBtn:ShowWindow(0);
    local multiBtn = GET_CHILD_RECURSIVELY(topFrame, "multiBtn");
    multiBtn:ShowWindow(1);
end

function GET_INVENTORY_ITEM_COUNT_BY_NAME(name)
    if name == nil or name == "" then
        return 0;
    end

    local invItemList = session.GetInvItemList();
    local index = invItemList:Head();
    local itemCount = session.GetInvItemList():Count();
    local invITemCount = 0;
    for i = 0, itemCount - 1 do     
        local invItem = invItemList:Element(index);
        local itemobj = GetIES(invItem:GetObject());            
        if invItem ~= nil then
            if itemobj.ClassName == name then            
                invITemCount = invITemCount + invItem.count;
            end
        end
        index = invItemList:Next(index);
    end
    return invITemCount;
end

function INDUNENTER_AMEND_OFFSET(frame)
    local left = frame:GetX();
    local top = frame:GetY();
    if left < 0 then
        left = 0;
    end
    if top < 0 then
        top = 0;
    end
        
    local rightDiff = left + frame:GetWidth() - option.GetClientWidth();
    local bottomDiff = top + frame:GetHeight() - option.GetClientHeight();
    if rightDiff > 0 then
        left = left - rightDiff;
    end
    if bottomDiff > 0 then
        top = top - bottomDiff;
    end

    frame:SetOffset(left, top); 
end

function INDUNENTER_REQ_UNDERSTAFF_ENTER_ALLOW(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local withMatchMode = topFrame:GetUserValue('WITHMATCH_MODE');
    if topFrame:GetUserValue('AUTOMATCH_MODE') ~= 'YES' and withMatchMode == 'NO' then
        ui.SysMsg(ScpArgMsg('EnableWhenAutoMatching'));
        return;
    end

    local indunType = topFrame:GetUserIValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local UnderstaffEnterAllowMinMember = TryGetProp(indunCls, 'UnderstaffEnterAllowMinMember');
    if UnderstaffEnterAllowMinMember == nil then
        return;
    end
        
    -- 파티원과 자동매칭인 경우 처리
    local yesScpStr = '_INDUNENTER_REQ_UNDERSTAFF_ENTER_ALLOW()';
    local clientMsg = ScpArgMsg('ReallyAllowUnderstaffMatchingWith{MIN_MEMBER}?', 'MIN_MEMBER', UnderstaffEnterAllowMinMember);
    if INDUNENTER_CHECK_UNDERSTAFF_MODE_WITH_PARTY(topFrame) == true then
        clientMsg = ClMsg('CancelUnderstaffMatching');
    end
    if withMatchMode == 'YES' then
        yesScpStr = 'ReqUnderstaffEnterAllowModeWithParty('..indunType..')';
    end
    ui.MsgBox(clientMsg, yesScpStr, "None");
end

function _INDUNENTER_REQ_UNDERSTAFF_ENTER_ALLOW()
    local frame = ui.GetFrame('indunenter');

    ReqUnderstaffEnterAllowMode();
    INDUNENTER_INIT_MY_INFO(frame, 'YES');
    INDUNENTER_UNDERSTAFF_BTN_ENABLE(frame, 0);
end

function INDUNENTER_UNDERSTAFF_BTN_ENABLE(frame, enable)
    local understaffEnterAllowBtn = GET_CHILD_RECURSIVELY(frame, 'understaffEnterAllowBtn');
    local smallUnderstaffEnterAllowBtn = GET_CHILD_RECURSIVELY(frame, 'smallUnderstaffEnterAllowBtn');

    understaffEnterAllowBtn:SetEnable(enable);
    smallUnderstaffEnterAllowBtn:SetEnable(enable);

    local reEnterBtn = GET_CHILD_RECURSIVELY(frame, 'reEnterBtn');
    if understaffEnterAllowBtn:IsVisible() == 1 then
        reEnterBtn:ShowWindow(0);
    end
end

function INDUNENTER_CHECK_UNDERSTAFF_MODE_WITH_PARTY(frame)
    local withMatchMode = frame:GetUserValue('WITHMATCH_MODE');
    if withMatchMode ~= 'YES' then
        return false;
    end
    
    local memberInfo = frame:GetUserValue('MEMBER_INFO');
    local memberInfoTable = StringSplit(memberInfo, '/');
    if #memberInfoTable < PC_INFO_COUNT then
        return false;
    end
    if memberInfoTable[PC_INFO_COUNT] ~= 'YES' then
        return false;
    end
    return true;
end

function INDUNENTER_CHECK_ADMISSION_ITEM(frame)
    local indunType = frame:GetUserIValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    if indunCls ~= nil and indunCls.AdmissionItemName ~= 'None' then
        local invItem = session.GetInvItemByName(indunCls.AdmissionItemName);
        if invItem == nil or invItem.isLockState == true then
            ui.MsgBox_NonNested(ClMsg('AdmissionItemLockMsg'), 0x00000000);
            return false;
        end        
    end
    return true;
end