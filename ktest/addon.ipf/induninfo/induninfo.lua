-- inuninfo.lua
function INDUNINFO_ON_INIT(addon, frame)
    addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'INDUNINFO_CHAT_OPEN');

    g_selectedIndunTable = {};
end

function UI_TOGGLE_INDUN()
    if app.IsBarrackMode() == true then
        return;
    end
    ui.ToggleFrame('induninfo');
end

function INDUNINFO_CHAT_OPEN(frame, msg, argStr, argNum)
    if nil ~= frame then
        frame:ShowWindow(1);
    else
        ui.OpenFrame("induninfo");
    end
end

function INDUNINFO_UI_OPEN(frame)
    INDUNINFO_RESET_USERVALUE(frame);
    INDUNINFO_CREATE_CATEGORY(frame);
    INDUNINFO_RESET_TIME_TEXT(frame);
end

function INDUNINFO_UI_CLOSE(frame)
    INDUNMAPINFO_UI_CLOSE();
    ui.CloseFrame('induninfo');
end

function INDUNINFO_CREATE_CATEGORY(frame)
    local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox');
    categoryBox:RemoveAllChild();

    local SCROLL_WIDTH = 20;
    local categoryBtnWidth = categoryBox:GetWidth() - SCROLL_WIDTH;
    local firstBtn = nil;
    resetGroupTable = {};
    local indunClsList, cnt = GetClassList('Indun');
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil then
            local resetGroupID = indunCls.PlayPerResetType;
            local category = indunCls.Category;
            local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
            if categoryCtrl == nil and category ~= 'None' then
                resetGroupTable[resetGroupID] = 1;                
                categoryCtrl = categoryBox:CreateOrGetControlSet('indun_cate_ctrl', 'CATEGORY_CTRL_'..resetGroupID, 0, i*50);

                local name = categoryCtrl:GetChild("name");
                local btn = categoryCtrl:GetChild("button");
                local countText = categoryCtrl:GetChild('countText');
                btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
                name:SetTextByKey("value", category);
                countText:SetTextByKey('current', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
                countText:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));

                categoryCtrl:SetUserValue('RESET_GROUP_ID', resetGroupID);
                if i == 0 then -- 디폴트는 첫번째가 클릭되게 함                              
                    firstBtn = btn;
                end
            elseif categoryCtrl ~= nil and category ~= 'None' then
                resetGroupTable[resetGroupID] = resetGroupTable[resetGroupID] + 1;
            end
        end
    end
    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);

    -- set the number of indun
    for resetGroupID, numIndun in pairs(resetGroupTable) do    
        local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
        local name = categoryCtrl:GetChild('name');
        name:SetTextByKey('cnt', numIndun);
    end

    -- default select
    INDUNINFO_CATEGORY_LBTN_CLICK(firstBtn:GetParent(), firstBtn);
end

function INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox)    
    GBOX_AUTO_ALIGN(categoryBox, 0, -6, 0, true, false);
end

function INDUNINFO_RESET_USERVALUE(frame)
    frame:SetUserValue('SELECT', 'None');
end

function INDUNINFO_CATEGORY_LBTN_CLICK(categoryCtrl, ctrl)
    -- set button skin
    local topFrame = categoryCtrl:GetTopParentFrame();
    local preSelectType = topFrame:GetUserIValue('SELECT');
    local selectedResetGroupID = categoryCtrl:GetUserIValue('RESET_GROUP_ID');
    if preSelectType == selectedResetGroupID then    
        return;
    end

    categoryCtrl = tolua.cast(categoryCtrl, 'ui::CControlSet');
    local SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('SELECTED_BTN_SKIN');
    local NOT_SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('NOT_SELECTED_BTN_SKIN');
    local preSelect = GET_CHILD_RECURSIVELY(topFrame, "CATEGORY_CTRL_" .. preSelectType);
    if nil ~= preSelect then
        local button = preSelect:GetChild("button");
        button:SetSkinName(NOT_SELECTED_BTN_SKIN);
    end
    topFrame:SetUserValue('SELECT', selectedResetGroupID);    
    ctrl:SetSkinName(SELECTED_BTN_SKIN);

    -- make indunlist
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame, 'categoryBox');
    local listBoxWidth = categoryBox:GetWidth() - SCROLL_WIDTH;
    categoryBox:RemoveChild('INDUN_LIST_BOX');
    g_selectedIndunTable = {};
        
    local indunListBox = categoryBox:CreateControl('groupbox', 'INDUN_LIST_BOX', 0, 0, listBoxWidth, 30);
    indunListBox = tolua.cast(indunListBox, 'ui::CGroupBox');
    indunListBox:EnableDrawFrame(0);
    indunListBox:EnableScrollBar(0);

    local indunClsList, cnt = GetClassList('Indun');    
    local showCnt = 0;    
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls.PlayPerResetType == selectedResetGroupID and indunCls.Category ~= 'None' then
            local indunDetailCtrl = indunListBox:CreateOrGetControlSet('indun_detail_ctrl', 'DETAIL_CTRL_'..indunCls.ClassID, 0, 0);
            indunDetailCtrl = tolua.cast(indunDetailCtrl, 'ui::CControlSet');
            indunDetailCtrl:SetUserValue('INDUN_CLASS_ID', indunCls.ClassID);
            indunDetailCtrl:SetEventScript(ui.LBUTTONUP, 'INDUNINFO_DETAIL_LBTN_CLICK');

            local infoText = indunDetailCtrl:GetChild('infoText');
            local nameText = indunDetailCtrl:GetChild('nameText');
            
            infoText:SetTextByKey('level', indunCls.Level);
            nameText:SetTextByKey('name', indunCls.Name);            
            if showCnt == 0 then -- 디폴트는 리스트의 첫번째
                indunListBox:SetUserValue('FIRST_INDUN_ID', indunCls.ClassID)
                INDUNINFO_DETAIL_LBTN_CLICK(indunListBox, indunDetailCtrl);
            end
            showCnt = showCnt + 1;
            g_selectedIndunTable[showCnt] = indunCls;
        end
    end
    GBOX_AUTO_ALIGN(indunListBox, 0, 0, 0, true, true);

    -- category box align
    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);
    indunListBox:SetOffset(categoryCtrl:GetX(), categoryCtrl:GetY() + categoryCtrl:GetHeight() - 5);
    local listBoxSize = indunListBox:GetHeight();
    local selectedCtrlIndex = categoryBox:GetChildIndex(categoryCtrl:GetName());
    local childCount = categoryBox:GetChildCount();
    for i = selectedCtrlIndex + 1, childCount - 1 do
        local _categoryCtrl = categoryBox:GetChildByIndex(i);
        local resetGroupID = _categoryCtrl:GetUserIValue('RESET_GROUP_ID');
        if resetGroupID ~= 0 and resetGroupID ~= selectedResetGroupID then
            _categoryCtrl:SetOffset(_categoryCtrl:GetX(), _categoryCtrl:GetY() + listBoxSize);
        end 
    end
    INDUNINFO_SORT_BY_LEVEL(topFrame);
end

function GET_CURRENT_ENTERANCE_COUNT(resetGroupID)
    local etc = GetMyEtcObject();
    if etc == nil then
        return 0;
    end
    return etc['InDunCountType_'..resetGroupID];
end

function GET_MAX_ENTERANCE_COUNT(resetGroupID)
    local etc = GetMyEtcObject();
    if etc == nil then
        return 0;
    end

    local indunClsList, cnt = GetClassList('Indun');
    local indunCls = nil;
    for i = 0, cnt - 1 do
        indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
            break;
        end
    end

    if indunCls.AdmissionItemName ~= "None" then
        local a = "{img infinity_text 20 10}"
        return a;
    end
    
    local bonusCount = 0;
    local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);    
    if isTokenState == true then
        bonusCount = indunCls.PlayPerReset_Token
    end
    return indunCls.PlayPerReset + bonusCount;
end

function INDUNINFO_DETAIL_LBTN_CLICK(parent, detailCtrl)
    local indunClassID = detailCtrl:GetUserIValue('INDUN_CLASS_ID');
    local preSelectedDetail = parent:GetUserIValue('SELECTED_DETAIL');
    if indunClassID == preSelectedDetail then
        return;
    end
    
    -- set skin
    local SELECTED_BOX_SKIN = detailCtrl:GetUserConfig('SELECTED_BOX_SKIN');
    local NOT_SELECTED_BOX_SKIN = detailCtrl:GetUserConfig('NOT_SELECTED_BOX_SKIN');    
    local preSelectedCtrl = parent:GetChild('DETAIL_CTRL_'..preSelectedDetail);
    if preSelectedCtrl ~= nil then
        local preSkinBox = GET_CHILD(preSelectedCtrl, 'skinBox');
        if preSkinBox:GetUserValue('DEFAULT_SKIN_2') == 'YES' then
            preSkinBox:SetSkinName(NOT_SELECTED_BOX_SKIN);
        else
            preSkinBox:SetSkinName('None');
        end
    end
    local skinBox = GET_CHILD(detailCtrl, 'skinBox');
    skinBox:SetSkinName(SELECTED_BOX_SKIN);
    parent:SetUserValue('SELECTED_DETAIL', indunClassID);
    
    local topFrame = parent:GetTopParentFrame();
    
    -- 인스턴스 던전 정보 처리를 위한 임시 처리 시작 --
    -- INDUNINFO_DROPBOX_ITEM_LIST 에서 parent의 SELECTED_DETAIL 값을 불러올 수 있도록 같은 프레임을 호출하도록 변경해야 함 --
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame,'categoryBox')
    local indunListBox = GET_CHILD_RECURSIVELY(categoryBox, 'INDUN_LIST_BOX');
    indunListBox:SetUserValue('SELECTED_DETAIL', indunClassID);
    -- 인스턴스 던전 정보 처리를 위한 임시 처리 끝 --
    
    INDUNINFO_MAKE_DETAIL_INFO_BOX(topFrame, indunClassID);
end

function INDUNINFO_DROPBOX_ITEM_LIST(parent, control)
    local topFrame = parent:GetTopParentFrame();
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame,'categoryBox')
    local indunListBox = GET_CHILD_RECURSIVELY(categoryBox, 'INDUN_LIST_BOX');
    local indunClassID = indunListBox:GetUserIValue('SELECTED_DETAIL');
    local preSelectedCtrl = indunListBox:GetChild('DETAIL_CTRL_'..indunClassID);
    
    local controlName = control:GetName();
    -- 여기서 부터
    local indunCls = GetClassByType('Indun', indunClassID);
    local dungeonType = TryGetProp(indunCls, 'DungeonType')
    local indunClsName = TryGetProp(indunCls, 'ClassName')
    local rewardItem = GetClass('Indun_reward_item', indunClsName)
    local indunRewardItem = TryGetProp(rewardItem, 'Reward_Item')
    local itemCls = GetClass('Item', indunRewardItem)
    local itemStringArg = TryGetProp(itemCls, 'StringArg')
    local indunRewardItemList = { };
    indunRewardItemList['weaponBtn'] = { };
    indunRewardItemList['subweaponBtn'] = { };
    indunRewardItemList['armourBtn'] = { };
    indunRewardItemList['accBtn'] = { };
    indunRewardItemList['materialBtn'] = { };
    if dungeonType == "Indun" or dungeonType == "UniqueRaid" or dungeonType == "Raid" then
        local allIndunRewardItemList, allIndunRewardItemCount = GetClassList('reward_indun');
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
                            if IS_EXIST_CLASSNAME_IN_LIST(indunRewardItemList['subweaponBtn'],item.ClassName) == false then
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
    else
        local rewardCube = TryGetProp(rewardItem, 'Reward_Item');
        local cubeList = SCR_STRING_CUT(rewardCube, '/');
        
        for e = 1, #cubeList do
            local cubeCls = GetClass('Item', cubeList[e]);
            indunRewardItemList['materialBtn'][#indunRewardItemList['materialBtn'] + 1] = cubeCls
        end
    end

    if #indunRewardItemList[controlName] == 0 then
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 1, ui.LEFT, "INDUNINFO_DROPBOX_AFTER_BTN_DOWN",nil,nil);
        ui.AddDropListItem(ClMsg('IndunRewardItem_Empty'))
        return;
    elseif #indunRewardItemList[controlName] ~= 0 and #indunRewardItemList[controlName] < 10 then
        local dropListSize = #indunRewardItemList[controlName] * 1
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, dropListSize, ui.LEFT, "GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT");
    else
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 10, ui.LEFT, "GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT");
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

function INDUNINFO_MAKE_DROPBOX(parent, control)
    local frame = ui.GetFrame('induninfo');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local controlName = control:GetName();
    
    local btnList, imgList = GET_INDUNINFO_MAKE_DROPBOX_BTN_LIST();
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
    INDUNINFO_DROPBOX_ITEM_LIST(parent, control)
end

function GET_INDUNINFO_MAKE_DROPBOX_BTN_LIST()
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

function INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
    local frame = ui.GetFrame('induninfo');
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

function GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER(index, classname)
    local induninfoFrame = ui.GetFrame("induninfo")
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
    
    if induninfoFrame ~= nil then
        itemFrame:SetOffset(induninfoFrame:GetX()+1090,induninfoFrame:GetY())
    end
    INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
end

function GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW(index, classname)
    local induninfoFrame = ui.GetFrame("induninfo")
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
    
    if induninfoFrame ~= nil then
        itemFrame:SetOffset(induninfoFrame:GetX()+1090,induninfoFrame:GetY())
    end
    INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
    itemFrame:SetUserValue('MouseClickedCheck','YES')
    
end

function GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT()
    local induninfoframe = ui.GetFrame('induninfo');
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

function INDUNINFO_MAKE_DETAIL_INFO_BOX(frame, indunClassID)
    local indunCls = GetClassByType('Indun', indunClassID);
    local etc = GetMyEtcObject();
    if indunCls == nil or etc == nil then
        return;
    end
    -- name
    local nameBox = GET_CHILD_RECURSIVELY(frame, 'nameBox');
    local nameText = nameBox:GetChild('nameText');
    nameText:SetTextByKey('name', indunCls.Name);

    -- picture
    local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
    indunPic:SetImage(indunCls.MapImage);

    -- count
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local tokenStatePic = GET_CHILD_RECURSIVELY(frame, 'tokenStatePic');
    local resetGroupID = indunCls.PlayPerResetType;    
    local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
    local TOKEN_STATE_IMAGE = frame:GetUserConfig('TOKEN_STATE_IMAGE');
    local NOT_TOKEN_STATE_IMAGE = frame:GetUserConfig('NOT_TOKEN_STATE_IMAGE');
    
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local indunAdmissionItemImage = admissionItemIcon
    local etc = GetMyEtcObject();
    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));

    
    if admissionItemCount == nil then
        admissionItemCount = 0;
    end
    
    admissionItemCount = math.floor(admissionItemCount);
    
    if admissionItemName == "None" or admissionItemName == nil or admissionItemCount == 0 then
    
        if isTokenState == true then
            tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
            tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        else
            tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
            tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        end
        countData:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
        countData:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));
        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
        countData:ShowWindow(1)
        countItemData:ShowWindow(0)
    else
        if isTokenState == true then
            isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
            tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
            tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        else
            isTokenState = 0
            tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
            tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        end
        local nowAdmissionItemCount = admissionItemCount + nowCount - isTokenState
        countItemData:SetTextByKey('admissionitem', '  {img '..indunAdmissionItemImage..' 30 30}  '..nowAdmissionItemCount..'')
        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        countText:SetText(ScpArgMsg("IndunAdmissionItem"))
        
        countData:ShowWindow(0)
        countItemData:ShowWindow(1)
    end    

    -- level
    local lvData = GET_CHILD_RECURSIVELY(frame, 'lvData');
    lvData:SetText(indunCls.Level);

    -- star
    local starData = GET_CHILD_RECURSIVELY(frame, 'starData');
    local STAR_IMAGE = frame:GetUserConfig('STAR_IMAGE');
    local starText = '';
    local numStar = (indunCls.Level - 1) / 100;
    for i = 0, numStar do
        starText = starText .. string.format('{img %s %d %d}', STAR_IMAGE, 20, 20);
    end
    starData:SetText(starText);

    -- map
    local posBox = GET_CHILD_RECURSIVELY(frame, 'posBox');
    DESTROY_CHILD_BYNAME(posBox, 'MAP_CTRL_');
    local mapList = StringSplit(indunCls.StartMap, '/');
    for i = 1, #mapList do
        local mapCls = GetClass('Map', mapList[i]);        
        if mapCls ~= nil then
            local mapCtrlSet = posBox:CreateOrGetControlSet('indun_pos_ctrl', 'MAP_CTRL_'..mapCls.ClassID, 0, 0);            
            local mapNameText = mapCtrlSet:GetChild('mapNameText');
            mapCtrlSet:SetGravity(ui.RIGHT, ui.TOP);
            mapCtrlSet:SetOffset(0, 10 + (10 + mapCtrlSet:GetHeight()) * (i-1));
            mapCtrlSet:SetUserValue('INDUN_CLASS_ID', indunClassID);
            mapCtrlSet:SetUserValue('INDUN_START_MAP_ID', mapCls.ClassID);
            mapNameText:SetText(mapCls.Name);
        end
    end

    INDUNENTER_MAKE_MONLIST(frame, indunCls);
end

function INDUNINFO_RESET_TIME_TEXT(frame)
    local resetInfoText = GET_CHILD_RECURSIVELY(frame, 'resetInfoText');
    local resetTime = INDUN_RESET_TIME % 12;
    local ampm = ClMsg('AM');
    if INDUN_RESET_TIME > 12 then
        ampm = ClMsg('PM');
    end
    local resetText = string.format('%s %s', ampm, resetTime);
    resetInfoText:SetTextByKey('resetTime', resetText);
end

function INDUNINFO_SORT_BY_LEVEL(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local radioBtn = GET_CHILD_RECURSIVELY(topFrame, 'lvAscendRadio');
    local selectedBtn = radioBtn:GetSelectedButton();    
    if selectedBtn:GetName() == 'lvAscendRadio' then
        table.sort(g_selectedIndunTable, SORT_BY_LEVEL);
    else
        table.sort(g_selectedIndunTable, SORT_BY_LEVEL_REVERSE);
    end

    local indunListBox = GET_CHILD_RECURSIVELY(topFrame, 'INDUN_LIST_BOX');    
    local firstChild = indunListBox:GetChild('DETAIL_CTRL_'..indunListBox:GetUserValue('FIRST_INDUN_ID'));
    firstChild = tolua.cast(firstChild, 'ui::CControlSet');
    local startY = firstChild:GetY();    
    local NOT_SELECTED_BOX_SKIN = firstChild:GetUserConfig('NOT_SELECTED_BOX_SKIN');
    for i = 1, #g_selectedIndunTable do
        local indunCls = g_selectedIndunTable[i];        
        local detailCtrl = indunListBox:GetChild('DETAIL_CTRL_'..indunCls.ClassID);        
        if detailCtrl ~= nil then
            detailCtrl:SetOffset(detailCtrl:GetX(), startY + detailCtrl:GetHeight()*(i-1));                
            local skinBox = GET_CHILD(detailCtrl, 'skinBox');
            if i % 2 == 0 then
                skinBox:SetSkinName(NOT_SELECTED_BOX_SKIN);
                skinBox:SetUserValue('DEFAULT_SKIN_2', 'YES');
            else
                skinBox:SetSkinName('None');
                skinBox:SetUserValue('DEFAULT_SKIN_2', 'NO');
            end

            if i == 1 then
                indunListBox:SetUserValue('FIRST_INDUN_ID', indunCls.ClassID)
            end
        end
    end
    
    local firstSelectedID = indunListBox:GetUserIValue('FIRST_INDUN_ID');
    INDUNINFO_MAKE_DETAIL_INFO_BOX(topFrame, firstSelectedID);
    indunListBox:SetUserValue('SELECTED_DETAIL', firstSelectedID);
end

function SORT_BY_LEVEL(a, b)    
    if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
        return false;
    end
    return tonumber(a.Level) < tonumber(b.Level)
end

function SORT_BY_LEVEL_REVERSE(a, b)    
    if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
        return false;
    end
    return tonumber(a.Level) > tonumber(b.Level)
end

function INDUNINFO_OPEN_INDUN_MAP(parent, ctrl)
    local mapID = parent:GetUserValue('INDUN_START_MAP_ID');
    local indunClassID = parent:GetUserValue('INDUN_CLASS_ID');
    OPEN_INDUN_MAP_INFO(indunClassID, mapID);
end

function INDUN_CANNOT_YET(msg)
    ui.SysMsg(ScpArgMsg(msg));
    ui.OpenFrame("induninfo");
end
