-- inuninfo.lua
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
                PUSH_BACK_UNIQUE_INTO_INDUN_CATEGORY_LIST(resetGroupID);

                resetGroupTable[resetGroupID] = 1;                
                categoryCtrl = categoryBox:CreateOrGetControlSet('indun_cate_ctrl', 'CATEGORY_CTRL_'..resetGroupID, 0, i*50);

                local name = categoryCtrl:GetChild("name");
                local btn = categoryCtrl:GetChild("button");
                local countText = categoryCtrl:GetChild('countText');
                local cyclePicImg = GET_CHILD_RECURSIVELY(categoryCtrl, 'cycleCtrlPic')   --주/일 표시 이미지

                btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
                name:SetTextByKey("value", category);
                countText:SetTextByKey('current', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
                countText:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));
                if GET_RESET_CYCLE(resetGroupID) == true then
                    cyclePicImg:SetImage('indun_icon_week_s_eng')
                else
                    cyclePicImg:SetImage('indun_icon_day_s_eng')
                end

                --유니크 레이드의 경우 cyclePic을 숨긴다
                if indunCls.DungeonType == 'UniqueRaid' then
                    cyclePicImg:ShowWindow(0);
                end

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
    local cycleImage = GET_CHILD_RECURSIVELY(frame, 'cyclePic');
    
    --local tokenStatePic = GET_CHILD_RECURSIVELY(frame, 'tokenStatePic');
    local resetGroupID = indunCls.PlayPerResetType;    
    -- local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
    -- local TOKEN_STATE_IMAGE = frame:GetUserConfig('TOKEN_STATE_IMAGE');
    -- local NOT_TOKEN_STATE_IMAGE = frame:GetUserConfig('NOT_TOKEN_STATE_IMAGE');
    
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local indunAdmissionItemImage = admissionItemIcon
    local etc = GetMyEtcObject();
    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    local addCount = math.floor(nowCount * admissionPlayAddItemCount)
    ---local etNowCount = TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    
    if admissionItemCount == nil then
        admissionItemCount = 0;
    end
    
    admissionItemCount = math.floor(admissionItemCount);
    
    if admissionItemName == "None" or admissionItemName == nil then
      --  print("if " .. indunCls.Name)
    
        -- if isTokenState == true then
        --     tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        -- else
        --     tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        -- end
        countData:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
        countData:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));
        if GET_RESET_CYCLE(resetGroupID) == true then
            cycleImage:SetImage('indun_icon_week_l_eng')
        else
            cycleImage:SetImage('indun_icon_day_l_eng')
        end

        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
        countData:ShowWindow(1)
        countItemData:ShowWindow(0)
        cycleImage:ShowWindow(1);
    else
        -- if isTokenState == true then
        --     isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
        --     tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        -- else
        --     isTokenState = 0
        --     tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        -- end
        --local nowAdmissionItemCount = admissionItemCount + addCount - isTokenState
        local nowAdmissionItemCount = admissionItemCount + addCount
        countItemData:SetTextByKey('admissionitem', '  {img '..indunAdmissionItemImage..' 30 30}  '..nowAdmissionItemCount..'')
        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        countText:SetText(ScpArgMsg("IndunAdmissionItem"))

        if indunCls.DungeonType == 'UniqueRaid' then
            cycleImage:ShowWindow(0);
        end

        countData:ShowWindow(0)
        countItemData:ShowWindow(1)
    end    

    -- level
    local lvData = GET_CHILD_RECURSIVELY(frame, 'lvData');
    lvData:SetText(indunCls.Level);

    -- star
--    local starData = GET_CHILD_RECURSIVELY(frame, 'starData');
--    local STAR_IMAGE = frame:GetUserConfig('STAR_IMAGE');
--    local starText = '';
--    local numStar = (indunCls.Level - 1) / 100;
--    for i = 0, numStar do
--        starText = starText .. string.format('{img %s %d %d}', STAR_IMAGE, 20, 20);
--    end
--    starData:SetText(starText);

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
