function INDUNENTER_ON_INIT(addon, frame)
    addon:RegisterMsg('MOVE_ZONE', 'INDUNENTER_CLOSE');
    addon:RegisterMsg('CLOSE_UI', 'INDUNENTER_CLOSE');
    addon:RegisterMsg('ESCAPE_PRESSED', 'INDUNENTER_ON_ESCAPE_PRESSED');
    
    PC_INFO_COUNT = 5;
end

function is_invalid_indun_multiple_item()
    local name = 'Adventure_dungeoncount_01'
    local invItemList = session.GetInvItemList()
    local guidList = invItemList:GetGuidList();
    local cnt = guidList:Count();    
    local check_cnt = 0
    for i = 0, cnt - 1 do
        local guid = guidList:Get(i);
        local invItem = invItemList:GetItemByGuid(guid);
        if invItem ~= nil and invItem:GetObject() ~= nil then
            local itemObj = GetIES(invItem:GetObject());
            if TryGetProp(itemObj, 'ClassName', 'None') == name then
                check_cnt = check_cnt + 1
                if check_cnt >= 2 then
                    return true
                end
            end
        end
    end
    return false
end

function INDUNENTER_ON_ESCAPE_PRESSED(frame, msg, argStr, argNum)
    if frame:GetUserValue('AUTOMATCH_MODE') == 'NO' then
        INDUNENTER_CLOSE(frame, msg, argStr, argNum);
    end
end

function INDUNENTER_CLOSE(frame, msg, argStr, argNum)
    INDUNENTER_AUTOMATCH_CANCEL();
    INDUNENTER_PARTYMATCH_CANCEL();
        
    INDUNENTER_MULTI_CANCEL(frame);
    
    ui.CloseFrame('indunenter');
    CloseIndunEnterDialog();
end

function INDUNENTER_UI_RESET(frame)
    local topFrame = ui.GetFrame('indunenter');
    local rewardBox = GET_CHILD_RECURSIVELY(topFrame, 'rewardBox');
    local weaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'weaponBtn');
    local materialBtn = GET_CHILD_RECURSIVELY(rewardBox, 'materialBtn');
    local accBtn = GET_CHILD_RECURSIVELY(rewardBox, 'accBtn');
    local armourBtn = GET_CHILD_RECURSIVELY(rewardBox, 'armourBtn');
    local subweaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'subweaponBtn');
    
    weaponBtn:SetImage("indun_weapon")
    frame:SetUserValue('weaponBtn','NO')
    materialBtn:SetImage("indun_material")
    frame:SetUserValue('materialBtn','NO')
    accBtn:SetImage("indun_acc")
    frame:SetUserValue('accBtn','NO')
    armourBtn:SetImage("indun_armour")
    frame:SetUserValue('armourBtn','NO')
    subweaponBtn:SetImage("indun_shield")
    frame:SetUserValue('subweaponBtn','NO')
end

function INDUNENTER_AUTOMATCH_CANCEL()
    local frame = ui.GetFrame('indunenter');
    packet.SendCancelIndunMatching();
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function SHOW_INDUNENTER_DIALOG(indunType, isAlreadyPlaying, enableAutoMatch, enableEnterRight, enablePartyMatch)   
    INDUNENTER_MULTI_CANCEL(ui.GetFrame('indunenter'))
    -- get data and check
    local indunCls = GetClassByType('Indun', indunType);
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local indunAdmissionItemImage = admissionItemIcon
    local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
    if isTokenState == true then
        isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
    else
        isTokenState = 0
    end

    local etc = GetMyEtcObject()    
    if indunCls.UnitPerReset == 'ACCOUNT' then
        etc = GetMyAccountObj()        
    end
    
    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")),0)
    local addCount = math.floor(nowCount * admissionPlayAddItemCount);
    
    if indunCls.WeeklyEnterableCount ~= 0 then
        nowCount = TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType")),0)
        addCount = math.floor((nowCount - indunCls.WeeklyEnterableCount) * admissionPlayAddItemCount);
        if addCount < 0 then
            addCount = 0;
        end
    end
    
    local nowAdmissionItemCount

    local pc = GetMyPCObject()
--    if  SCR_RAID_EVENT_20190102(nil, false) and admissionItemName == "Dungeon_Key01" then
    if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" and admissionItemName == "Dungeon_Key01" then
        nowAdmissionItemCount = admissionItemCount
    else
        nowAdmissionItemCount = admissionItemCount + addCount - isTokenState
    end
        
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
--        if admissionItemCount  ~= 0 then
        if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
            if nowCount >= indunCls.WeeklyEnterableCount then
                --nowAdmissionItemCount = 3 + (nowCount - (indunCls.WeeklyEnterableCount));
                autoMatchText:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
                enterBtn:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
            else
                autoMatchText:SetTextByKey("image", '')
                enterBtn:SetTextByKey("image", '')
            end
        else
            autoMatchText:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
            enterBtn:SetTextByKey("image", '  {img '..indunAdmissionItemImage..' 24 24} - '..nowAdmissionItemCount..'')
        end
--        end
    else
        autoMatchText:SetTextByKey("image", '')
        enterBtn:SetTextByKey("image", '')
    end

    -- make controls
    INDUNENTER_MAKE_HEADER(frame);
    INDUNENTER_MAKE_PICTURE(frame, indunCls);
    INDUNENTER_MAKE_ALERT(frame, indunCls);
    INDUNENTER_MAKE_COUNT_BOX(frame, noPicBox, indunCls);
    INDUNENTER_MAKE_LEVEL_BOX(frame, noPicBox, indunCls);
    INDUNENTER_MAKE_MULTI_BOX(frame, indunCls);
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
    INDUNENTER_MAKE_MONLIST(frame, indunCls);

    -- setting
    INDUNENTER_INIT_MEMBERBOX(frame);
    INDUNENTER_AUTOMATCH_TYPE(0);
    INDUNENTER_AUTOMATCH_PARTY(0);
    INDUNENTER_SET_MEMBERCNTBOX();
    INDUNENTER_INIT_REENTER_UNDERSTAFF_BUTTON(frame, isAlreadyPlaying)
    withBtn:SetTextTooltip(ClMsg("PartyMatchInfo_Req"));

    local enableMulti = 1;
    if enableAutoMatch == 0 then
        enableMulti = 0;
    end

    frame:SetUserValue('ENABLE_ENTERRIGHT', enableEnterRight);
    frame:SetUserValue('ENABLE_AUTOMATCH', enableAutoMatch);
    frame:SetUserValue('ENABLE_PARTYMATCH', enablePartyMatch);
    INDUNENTER_SET_ENABLE(enableEnterRight, enableAutoMatch, enablePartyMatch, enableMulti);

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

function REFRESH_REENTER_UNDERSTAFF_BUTTON(isEnableReEnter)
    local frame = ui.GetFrame('indunenter');

    INDUNENTER_INIT_REENTER_UNDERSTAFF_BUTTON(frame, isEnableReEnter);
end

function INDUNENTER_INIT_MEMBERBOX(frame)
    INDUNENTER_INIT_MY_INFO(frame, 'NO');
    INDUNENTER_UPDATE_PC_COUNT(frame, nil, "None", 0);
end

function INDUNENTER_INIT_MY_INFO(frame, understaff)
    local pc = GetMyPCObject();
    local aid = session.loginInfo.GetAID();
    local mySession = session.GetMySession();
    local etcObject = GetMyEtcObject();
    local jobID = TryGetProp(etcObject, "RepresentationClassID");
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

-- 스킬 제한 경고문
function INDUNENTER_MAKE_ALERT(frame, indunCls)
    local restrictBox = GET_CHILD_RECURSIVELY(frame, 'restrictBox');
    restrictBox:ShowWindow(0);

    local mapName = TryGetProp(indunCls, "MapName");
    if mapName ~= nil and mapName ~= "None" then
        local indunMap = GetClass("Map", mapName);
        local mapKeyword = TryGetProp(indunMap, "Keyword");
        if string.find(mapKeyword, "IsRaidField") ~= nil then
            restrictBox:ShowWindow(1);
            restrictBox:SetTooltipOverlap(1);
            local TOOLTIP_POSX = frame:GetUserConfig("TOOLTIP_POSX");
            local TOOLTIP_POSY = frame:GetUserConfig("TOOLTIP_POSY");
            restrictBox:SetPosTooltip(TOOLTIP_POSX, TOOLTIP_POSY);
            restrictBox:SetTooltipType("skillRestrictList");
            restrictBox:SetTooltipArg("IsRaidField");
        end
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


-- 큐브 재개봉 시스템 개편에 따른 변경사항으로 보상 아이템 목록 보여주는 부분 큐브 대신 구성품으로 풀어서 보여주도록 변경함(2019.2.27 변경)
function INDUNENTER_DROPBOX_ITEM_LIST(parent, control)
    local frame = ui.GetFrame('indunenter');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local controlName = control:GetName();
    -- 여기서 부터
    local topFrame = frame:GetTopParentFrame();
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local dungeonType = TryGetProp(indunCls, 'DungeonType')
    local indunClsName = TryGetProp(indunCls, 'ClassName')
    local rewardItem = GetClass('Indun_reward_item', indunClsName)
    local indunRewardItem = TryGetProp(rewardItem, 'Reward_Item')
    local groupList = SCR_STRING_CUT(indunRewardItem, '/')
    
    local indunRewardItemList = { };
    indunRewardItemList['weaponBtn'] = { };
    indunRewardItemList['subweaponBtn'] = { };
    indunRewardItemList['armourBtn'] = { };
    indunRewardItemList['accBtn'] = { };
    indunRewardItemList['materialBtn'] = { };

    local allIndunRewardItemList, allIndunRewardItemCount = GetClassList('reward_freedungeon');
    if dungeonType == "Indun" or dungeonType == "UniqueRaid" or dungeonType == "Raid" then
        allIndunRewardItemList, allIndunRewardItemCount = GetClassList('reward_indun');
    end
    
    if groupList ~= nil then
        for i = 1, #groupList do
            local itemCls = GetClass('Item', groupList[i])
            local itemStringArg = TryGetProp(itemCls, 'StringArg')

            for j = 0, allIndunRewardItemCount - 1  do
                local indunRewardItemClass = GetClassByIndexFromList(allIndunRewardItemList, j);
                if indunRewardItemClass ~= nil and TryGetProp(indunRewardItemClass, 'Group') == itemStringArg then
                    local item = GetClass('Item', indunRewardItemClass.ItemName);
                    if item ~= nil then   -- 있다면 아이템 --
                        local itemType = TryGetProp(item, 'GroupName');
                        local itemClassType = TryGetProp(item, 'ClassType');
                        if itemType == 'Recipe' then
                            local recipeItemCls = GetClass('Recipe', item.ClassName);
                            local targetItem = TryGetProp(recipeItemCls, 'TargetItem');
                            if targetItem ~= nil then
                                local targetItemCls = GetClass('Item', targetItem);
                                if targetItemCls ~= nil then
                                    itemType = TryGetProp(targetItemCls, 'GroupName');
                                    itemClassType = TryGetProp(targetItemCls, 'ClassType');
                                end
                            end
                        end
                        if itemType ~= nil then
                            if itemType == 'Weapon' then
                                if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['weaponBtn'],item.ClassName) == false and IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['subweaponBtn'],item.ClassName) == false then
                                    indunRewardItemList['weaponBtn'][#indunRewardItemList['weaponBtn'] + 1] = item;
                                end
                            elseif itemType == 'SubWeapon' then
                                if itemClassType == 'Armband' then
                                    if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['accBtn'],item.ClassName) == false then
                                        indunRewardItemList['accBtn'][#indunRewardItemList['accBtn'] + 1] = item;
                                    end
                                else 
                                    if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['subweaponBtn'],item.ClassName) == false then
                                        indunRewardItemList['subweaponBtn'][#indunRewardItemList['subweaponBtn'] + 1] = item;
                                    end
                                end
                            elseif itemType == 'Armor' then
                                if itemClassType == 'Neck' or itemClassType == 'Ring' then
                                    if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['accBtn'],item.ClassName) == false then
                                        indunRewardItemList['accBtn'][#indunRewardItemList['accBtn'] + 1] = item;
                                    end
                                elseif itemClassType == 'Shield' then
                                    if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['subweaponBtn'],item.ClassName) == false then
                                        indunRewardItemList['subweaponBtn'][#indunRewardItemList['subweaponBtn'] + 1] = item;
                                    end
                                else
                                    if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['armourBtn'],item.ClassName) == false then
                                        indunRewardItemList['armourBtn'][#indunRewardItemList['armourBtn'] + 1] = item;
                                    end
                                end
                            else
                                if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['materialBtn'],item.ClassName) == false then
                                    indunRewardItemList['materialBtn'][#indunRewardItemList['materialBtn'] + 1] = item;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if #indunRewardItemList[controlName] == 0 then
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 1, ui.LEFT, "INDUNENTER_DROPBOX_AFTER_BTN_DOWN",nil,nil);
            ui.AddDropListItem(ClMsg('IndunRewardItem_Empty'))
        return;
    elseif #indunRewardItemList[controlName] ~= 0 and #indunRewardItemList[controlName] < 10 then
        local dropListSize = #indunRewardItemList[controlName] * 1
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, dropListSize, ui.LEFT, "GET_INDUNENTER_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNENTER_DROPBOX_LIST_MOUSE_OVER","GET_INDUNENTER_DROPBOX_LIST_MOUSE_OUT");
    else
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 10, ui.LEFT, "GET_INDUNENTER_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNENTER_DROPBOX_LIST_MOUSE_OVER","GET_INDUNENTER_DROPBOX_LIST_MOUSE_OUT");
    end

    if #indunRewardItemList[controlName] >= 1 then
        for l = 1, #indunRewardItemList[controlName] do
            local dropBoxItem = indunRewardItemList[controlName][l];
            ui.AddDropListItem(dropBoxItem.Name, nil, dropBoxItem.ClassName)
        end
    end
    
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    itemFrame:SetUserValue('MouseClickedCheck','NO')
    -- 여기까지
end 

function INDUNENTER_MAKE_DROPBOX(parent, control)
    local frame = ui.GetFrame('indunenter');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local controlName = control:GetName();
    
    local btnList, imgList = GET_INDUNENTER_MAKE_DROPBOX_BTN_LIST();
    for i = 1, #btnList do
        local btnName = btnList[i];
        local imgName = imgList[i];
        
        if controlName == btnName then
            if control:GetUserValue(btnName) == 'NO' then
                control:SetImage(imgName .. '_clicked');
                control:SetUserValue(btnName, 'YES');
            else
                control:SetImage(imgName);
                control:SetUserValue(btnName, 'NO');
            end
        else
            local btn = GET_CHILD_RECURSIVELY(rewardBox, btnName);
            btn:SetImage(imgName);
            btn:SetUserValue(btnName, 'NO');
        end
        if control:GetUserValue(btnName) == 'NO' then
            return ;
        end
    end
    INDUNENTER_DROPBOX_ITEM_LIST(parent, control)
end

function GET_INDUNENTER_MAKE_DROPBOX_BTN_LIST()
    local btnList = {
                        'weaponBtn',
                        'subweaponBtn',
                        'armourBtn',
                        'accBtn',
                        'materialBtn'
                    };
    
    local imgList = {
                        'indun_weapon',
                        'indun_shield',
                        'indun_armour',
                        'indun_acc',
                        'indun_material'
                    };
    
    return btnList, imgList;
end

function INDUNENTER_DROPBOX_AFTER_BTN_DOWN(index, classname)
    local frame = ui.GetFrame('indunenter');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local weaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'weaponBtn');
    local materialBtn = GET_CHILD_RECURSIVELY(rewardBox, 'materialBtn');
    local accBtn = GET_CHILD_RECURSIVELY(rewardBox, 'accBtn');
    local armourBtn = GET_CHILD_RECURSIVELY(rewardBox, 'armourBtn');
    local subweaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'subweaponBtn');
    
    weaponBtn:SetImage("indun_weapon")
    frame:SetUserValue('weaponBtn','NO')
    materialBtn:SetImage("indun_material") 
    frame:SetUserValue('materialBtn','NO')
    accBtn:SetImage("indun_acc")
    frame:SetUserValue('accBtn','NO')
    armourBtn:SetImage("indun_armour")
    frame:SetUserValue('armourBtn','NO')
    subweaponBtn:SetImage("indun_shield")
    frame:SetUserValue('subweaponBtn','NO')
end

function GET_INDUNENTER_DROPBOX_LIST_MOUSE_OVER(index, classname)
    local indunenterFrame = ui.GetFrame("indunenter")
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    tolua.cast(itemFrame, 'ui::CTooltipFrame');

    local newobj = CreateIES('Item', classname);
    itemFrame:SetTooltipType('wholeitem');
    newobj = tolua.cast(newobj, 'imcIES::IObject');
    itemFrame:SetToolTipObject(newobj);

    currentFrame = itemFrame;
    currentFrame:RefreshTooltip();
    currentFrame:ShowWindow(1);
    if indunenterFrame ~= nil then
        itemFrame:SetOffset(indunenterFrame:GetX()+720,indunenterFrame:GetY())
    end
    INDUNENTER_DROPBOX_AFTER_BTN_DOWN(index, classname)
end

function GET_INDUNENTER_DROPBOX_LIST_TOOLTIP_VIEW(index, classname)
    local indunenterFrame = ui.GetFrame("indunenter")
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    tolua.cast(itemFrame, 'ui::CTooltipFrame');

    local newobj = CreateIES('Item', classname);
    itemFrame:SetTooltipType('wholeitem');
    newobj = tolua.cast(newobj, 'imcIES::IObject');
    itemFrame:SetToolTipObject(newobj);

    currentFrame = itemFrame;
    currentFrame:RefreshTooltip();
    currentFrame:ShowWindow(1);

    if indunenterFrame ~= nil then
        itemFrame:SetOffset(indunenterFrame:GetX()+720,indunenterFrame:GetY())
    end
    INDUNENTER_DROPBOX_AFTER_BTN_DOWN(index, classname)
    itemFrame:SetUserValue('MouseClickedCheck','YES')
    
end

function GET_INDUNENTER_DROPBOX_LIST_MOUSE_OUT()
    local indunenterframe = ui.GetFrame('indunenter');
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    if itemFrame:GetUserValue('MouseClickedCheck') == 'NO' then
        itemFrame:ShowWindow(0)
    end
    if  itemFrame:GetUserValue('MouseClickedCheck') == 'YES' then
        itemFrame:ShowWindow(1)
        itemFrame:SetUserValue('MouseClickedCheck','NO')
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

    if indunCls.UnitPerReset == 'ACCOUNT' then
        etc = GetMyAccountObj()
    end
    
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local cycleCtrlPic = GET_CHILD_RECURSIVELY(frame, 'cycleCtrlPic');
    cycleCtrlPic:ShowWindow(0);

    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local indunAdmissionItemImage = admissionItemIcon
    local WeeklyEnterableCount = TryGetProp(indunCls, "WeeklyEnterableCount");

    if admissionItemCount == nil then
        admissionItemCount = 0;
    end
    admissionItemCount = math.floor(admissionItemCount);

    if admissionItemName == "None" or admissionItemName == nil then
        -- now play count
        local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")), 0)        
        if WeeklyEnterableCount ~= nil and WeeklyEnterableCount ~= "None" and WeeklyEnterableCount ~= 0 then            
            nowCount = GET_CURRENT_ENTERANCE_COUNT(TryGetProp(indunCls, "PlayPerResetType"))            
        end

        -- add count
        local addCount = math.floor(nowCount * admissionPlayAddItemCount);
        countData:SetTextByKey("now", nowCount);

        -- max play count
        local maxCount = TryGetProp(indunCls, 'PlayPerReset');
        if WeeklyEnterableCount ~= nil and WeeklyEnterableCount ~= "None" and WeeklyEnterableCount ~= 0 then
            maxCount = WeeklyEnterableCount
        end

        if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
            local playPerResetToken = TryGetProp(indunCls, 'PlayPerReset_Token');
            if playPerResetToken ~= nil then
                maxCount = maxCount + playPerResetToken;
            end
        end
        if session.loginInfo.IsPremiumState(NEXON_PC) == true then
            local playPerResetNexonPC = TryGetProp(indunCls, 'PlayPerReset_NexonPC')
            if playPerResetNexonPC ~= nil then
                maxCount = maxCount + playPerResetNexonPC;
            end
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

        -- now play count
        local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")), 0)        
        if WeeklyEnterableCount ~= nil and WeeklyEnterableCount ~= "None" and WeeklyEnterableCount ~= 0 then            
            nowCount = GET_CURRENT_ENTERANCE_COUNT(TryGetProp(indunCls, "PlayPerResetType"))            
        end

        if indunCls.DungeonType == "Raid" or indunCls.DungeonType =="GTower" then
            if nowCount >= WeeklyEnterableCount then
                local invAdmissionItemCount = GetInvItemCount(pc, admissionItemName)
                countItemData:SetTextByKey("ivnadmissionitem",  '  {img '..indunAdmissionItemImage..' 30 30}  '..invAdmissionItemCount ..'')
    
                local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
                countText:SetText(ScpArgMsg("IndunAdmissionItemPossession"))
                countItemData:ShowWindow(1)
                countData:ShowWindow(0)
    
                if indunCls.DungeonType == 'UniqueRaid' then
--                    if SCR_RAID_EVENT_20190102(nil, false) == true and admissionItemName == 'Dungeon_Key01' then
                    if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES"and admissionItemName == "Dungeon_Key01" then
                        cycleCtrlPic:ShowWindow(1);
                    end
                end
            else
                local addCount = math.floor(nowCount * admissionPlayAddItemCount);
                countData:SetTextByKey("now", nowCount);
                -- max play count
            
                local maxCount = TryGetProp(indunCls, 'PlayPerReset');
                if WeeklyEnterableCount ~= nil and WeeklyEnterableCount ~= "None" and WeeklyEnterableCount ~= 0 then
                    maxCount = WeeklyEnterableCount
                end
            
                if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
                    maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token', 0)
                end
                if session.loginInfo.IsPremiumState(NEXON_PC) == true then
                    maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_NexonPC', 0)
                end
                countData:SetTextByKey("max", maxCount);
            
                    -- set min/max multi count
                local minCount = frame:GetUserConfig('MULTI_MIN');
                frame:SetUserValue("MIN_MULTI_CNT", minCount);
                frame:SetUserValue("MAX_MULTI_CNT", maxCount - nowCount);
            
                local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
                countData:ShowWindow(1)
                countItemData:ShowWindow(0)
            end
        else
            local invAdmissionItemCount = GetInvItemCount(pc, admissionItemName)
            countItemData:SetTextByKey("ivnadmissionitem",  '  {img '..indunAdmissionItemImage..' 30 30}  '..invAdmissionItemCount ..'')
    
            local countText = GET_CHILD_RECURSIVELY(frame, 'countText');
            countText:SetText(ScpArgMsg("IndunAdmissionItemPossession"))
            countItemData:ShowWindow(1)
            countData:ShowWindow(0)

            local pc = GetMyPCObject()
            if indunCls.DungeonType == 'UniqueRaid' then
--                if SCR_RAID_EVENT_20190102(nil, false) == true and admissionItemName == 'Dungeon_Key01' then
                if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" and admissionItemName == "Dungeon_Key01"then
                    cycleCtrlPic:ShowWindow(1);
                end
            end
        end
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

    if pcCount < 1 then -- member초기?�해주자
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
    local maxMatchingCount = GET_MAX_MATCHING_COUNT(frame);
    for i = 1, maxMatchingCount do
        local memberCtrlSet = memberBox:CreateOrGetControlSet('indunMember', 'MEMBER_'..tostring(i), 10 * i + 47 * (i - 1), 0);
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

        if i <= pcCount then -- 참여???�원만큼 보여주는 부�?
            if i * PC_INFO_COUNT <= #memberTable then -- ?�티?�인 경우      
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
            else -- ?�티?��? ?�닌??매칭???�람
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
    local useCount = tonumber(topFrame:GetUserValue("multipleCount"));
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local indunMinPCRank = TryGetProp(indunCls, 'PCRank')
    local totaljobcount = session.GetPcTotalJobGrade()
    
    if indunMinPCRank ~= nil then
        if indunMinPCRank > totaljobcount and indunMinPCRank ~= totaljobcount then
            ui.SysMsg(ScpArgMsg('IndunEnterNeedPCRank', 'NEED_RANK', indunMinPCRank))
            return;
        end
    end
   
    if useCount > 0 then
        local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
        for i = 1, #multipleItemList do
        local itemName = multipleItemList[i];
            local invItem = session.GetInvItemByName(itemName);
            if invItem ~= nil and invItem.isLockState then
                ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end        
    end
    end
    
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
    local useCount = tonumber(topFrame:GetUserValue("multipleCount"));
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local indunMinPCRank = TryGetProp(indunCls, 'PCRank')
    local totaljobcount = session.GetPcTotalJobGrade()
    
    if indunMinPCRank ~= nil then
        if indunMinPCRank > totaljobcount and indunMinPCRank ~= totaljobcount then
            ui.SysMsg(ScpArgMsg('IndunEnterNeedPCRank', 'NEED_RANK', indunMinPCRank))
            return;
        end
    end
    
    if useCount > 0 then
        local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
        for i = 1, #multipleItemList do
            local itemName = multipleItemList[i];
            local invItem = session.GetInvItemByName(itemName);
            if invItem ~= nil and invItem.isLockState then
                ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end        
    end
    end
    
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
    local topFrame = frame:GetTopParentFrame();
    local useCount = tonumber(topFrame:GetUserValue("multipleCount"));
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local indunMinPCRank = TryGetProp(indunCls, 'PCRank')
    local totaljobcount = session.GetPcTotalJobGrade()
    
    if indunMinPCRank ~= nil then
        if indunMinPCRank > totaljobcount and indunMinPCRank ~= totaljobcount then
            ui.SysMsg(ScpArgMsg('IndunEnterNeedPCRank', 'NEED_RANK', indunMinPCRank))
            return;
        end
    end
    
    if useCount > 0 then
        local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
        for i = 1, #multipleItemList do
            local itemName = multipleItemList[i];
            local invItem = session.GetInvItemByName(itemName);
            if invItem ~= nil and invItem.isLockState then
                ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end        
    end
    end
    
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
    
    local enableReenter = frame:GetUserIValue('ENABLE_REENTER');

    if topFrame:GetUserValue('WITHMATCH_MODE') == 'NO' then
        ReqMoveToIndun(3, textCount);
        ctrl:SetTextTooltip(ClMsg("PartyMatchInfo_Go"));
        if enableReenter == trhe then
            understaffEnterAllowBtn:ShowWindow(1);
        else
            understaffEnterAllowBtn:ShowWindow(0);
        end
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
    
    if frame:GetUserIValue('ENABLE_ENTERRIGHT') == 0 and enter == 1 then
        enter = 0;
    end
    if frame:GetUserIValue('ENABLE_AUTOMATCH') == 0 and autoMatch == 1 then
        autoMatch = 0;
    end
    if frame:GetUserIValue('ENABLE_PARTYMATCH') == 0 and withParty == 1 then
        withParty = 0;
    end

    enterBtn:SetEnable(enter);
    autoMatchBtn:SetEnable(autoMatch);
    _INDUNENTER_SET_ENABLE_PARTYMATCHBTN(frame, withParty);
    INDUNENTER_SET_ENABLE_MULTI(multi);

    -- multi btn: 배수?�큰 ?�어???�용 가?? ?�던/?�뢰??미션�??�용가??
    local indunCls = GetClassByType('Indun', frame:GetUserIValue('INDUN_TYPE'));
    local resetType = TryGetProp(indunCls, 'PlayPerResetType');
    local itemCount = GET_INDUN_MULTIPLE_ITEM_LIST();
    if itemCount == 0 or (resetType ~= 100 and resetType ~= 200) then
        INDUNENTER_SET_ENABLE_MULTI(0);
    end
end

function _INDUNENTER_SET_ENABLE_PARTYMATCHBTN(frame, enable)
    local withPartyBtn = GET_CHILD_RECURSIVELY(frame, 'withBtn');
    local withText = GET_CHILD_RECURSIVELY(frame, 'withText');
    withPartyBtn:SetEnable(enable);
    withText:SetEnable(enable);
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

function GET_MAX_MATCHING_COUNT(frame)
    local maxMatchingCount = INDUN_AUTOMATCHING_PCCOUNT;
    local indunCls = GetClassByType('Indun', frame:GetUserIValue('INDUN_TYPE'));
    if indunCls == nil then
        return 0;
    end
    if maxMatchingCount ~= indunCls.PlayerCnt then
        maxMatchingCount = indunCls.PlayerCnt;
    end
    return maxMatchingCount;
end

function INDUNENTER_UPDATE_SMALLMODE_PC(pcCount, understaffCount)
    local frame = ui.GetFrame("indunenter");
    local YES_MATCH_SKIN = frame:GetUserConfig('YES_MATCH_SKIN');

    local matchPCBox = GET_CHILD_RECURSIVELY(frame, 'matchPCBox');
    matchPCBox:RemoveAllChild();
    local notWaitingCount = GET_MAX_MATCHING_COUNT(frame) - pcCount;
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
    local indunType = topFrame:GetUserValue('INDUN_TYPE');
    local indunCls = GetClassByType('Indun', indunType);
    local indunMinPCRank = TryGetProp(indunCls, 'PCRank')
    local totaljobcount = session.GetPcTotalJobGrade()
    
    if indunMinPCRank ~= nil then
        if indunMinPCRank > totaljobcount and indunMinPCRank ~= totaljobcount then
            ui.SysMsg(ScpArgMsg('IndunEnterNeedPCRank', 'NEED_RANK', indunMinPCRank))
            return;
        end
    end
    
    if textCount > 0 then
        local yesscp = string.format('ReqMoveToIndun(4, %d)', textCount);
        ui.MsgBox(ClMsg('ReenterMultipleNotAllowed'), yesscp, 'None');
        return;
    end
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
        
    UI_PLAYFORCE(rewardSlotSet, "slotsetRightMove_1");
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

    if tonumber(textCount) > 1 then
        if is_invalid_indun_multiple_item() == true then
            ui.SysMsg(ClMsg("IndunMultipleItemError"))
            return
        end
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
    local count = GET_INV_ITEM_COUNT_BY_PROPERTY({
        {Name = 'ClassName', Value = name}
    }, false, invItemList);
    return count;
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
    local useCount = tonumber(topFrame:GetUserValue("multipleCount"));
    if useCount > 0 then
        local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
        for i = 1, #multipleItemList do
            local itemName = multipleItemList[i];
            local invItem = session.GetInvItemByName(itemName);
            if invItem ~= nil and invItem.isLockState then
                ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end        
    end
    end

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
        
    -- ?�티?�과 ?�동매칭??경우 처리
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

    local indunCls = GetClassByType('Indun', frame:GetUserIValue('INDUN_TYPE'));
    if TryGetProp(indunCls, 'EnableUnderStaffEnter', 'YES') == 'NO' then
        enable = 0;
    end

    understaffEnterAllowBtn:SetEnable(enable);
    smallUnderstaffEnterAllowBtn:SetEnable(enable);

    if enable == 1 then
        understaffEnterAllowBtn:ShowWindow(1);
    end

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
        local user = GetMyPCObject();
        local etc = GetMyEtcObject();
        if indunCls.UnitPerReset == 'ACCOUNT' then
            etc = GetMyAccountObj()
        end
        
        local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
        if isTokenState == true then
            isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
        else
            isTokenState = 0
        end

        local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
        
        local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
        local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
        local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
        if indunCls.WeeklyEnterableCount ~= 0 then
            nowCount = TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
        end
        local addCount = math.floor((nowCount - indunCls.WeeklyEnterableCount) * admissionPlayAddItemCount)
        local nowAdmissionItemCount = admissionItemCount + addCount - isTokenState

--        if SCR_RAID_EVENT_20190102(nil , false) and admissionItemName == "Dungeon_Key01" then
        if IsBuffApplied(user, "Event_Unique_Raid_Bonus") == "YES" and admissionItemName == "Dungeon_Key01" then
            nowAdmissionItemCount = admissionItemCount
        end 
        
        local cnt = GetInvItemCount(user, admissionItemName)
        local invItem = session.GetInvItemByName(indunCls.AdmissionItemName);
        
        if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
            if nowCount < indunCls.WeeklyEnterableCount then
                return true;
            elseif nowCount > indunCls.WeeklyEnterableCount then
                nowAdmissionItemCount = nowAdmissionItemCount + (nowCount - (indunCls.WeeklyEnterableCount));
            end
        end 

        if cnt == nil or cnt < nowAdmissionItemCount then
            ui.MsgBox_NonNested(ClMsg('CannotJoinIndunItemScarcity'), 0x00000000);
            return false;
        end
        
        if invItem == nil or invItem.isLockState == true then
            ui.MsgBox_NonNested(ClMsg('AdmissionItemLockMsg'), 0x00000000);
            return false;
        end
    end
    return true;
end

function INDUN_ALREADY_PLAYING()
    local yesScp = string.format("AnsGiveUpPrevPlayingIndun(%d)", 1);
    local noScp = string.format("AnsGiveUpPrevPlayingIndun(%d)", 0);
    ui.MsgBox(ClMsg("IndunAlreadyPlaying_AreYouGiveUp"), yesScp, noScp);
end

function IS_EXIST_CLASSNAME_IN_LIST(list, value)
    for i =1, #list do
        if list[i].ClassName == value then
            return true;
        end
    end
    return false;
end
