function UI_LIB_TAB_GET_ADD_TAB_INFO(tabItemName, groupBoxName, caption, tabKeyValue, isIndexChangeValue)
    local info = {}
    info["TabItemName"] = tabItemName;
    info["GroupBoxName"] = groupBoxName;
    info["Caption"] = caption;
    info["TabItemKeyValue"] = tabKeyValue;

    if isIndexChangeValue == nil then
        isIndexChangeValue = true;
    end
    info["IsIndexChangeValue"] = isIndexChangeValue;

    return info;
end

function UI_LIB_TAB_GET_INFO_HASH(addTabInfoList)
    local hash = {}
    for i=1, #addTabInfoList do
        local info = addTabInfoList[i]
        hash[info["TabItemKeyValue"]] = info
    end
    return hash
end

-- desc : 탭 여러개 생성
function UI_LIB_TAB_ADD_TAB_LIST(parent, tab, addTabInfoList, width, height, uiHorizontal, uiVertical, x, y, groupBoxKey, groupBoxValue, tabWidth, tabItemKeyName)
    tab:ClearItemAll();

    local infoHash = UI_LIB_TAB_GET_INFO_HASH(addTabInfoList)
    local oldChildren = GET_CHILD_LIST_BY_USERVALUE(parent, groupBoxKey, groupBoxValue)
    for i=1, #oldChildren do
        local gb_del = oldChildren[i]
        local value = gb_del:GetUserValue(tabItemKeyName)
        if infoHash[value] == nil then
            local index = parent:GetChildIndexByObj(gb_del);
            parent:RemoveChildByIndex(index);
        end
    end

    local groupboxList = {};
    for i=1, #addTabInfoList do
        local addTabInfo = addTabInfoList[i];
        local groupbox = GET_CHILD(parent, gbName)
        if groupbox == nil then
            groupbox = UI_LIB_TAB_ADD_TAB(parent, tab, addTabInfo["TabItemName"], addTabInfo["GroupBoxName"], addTabInfo["Caption"], width, height, uiHorizontal, uiVertical, x, y, tabItemKeyName, addTabInfo["TabItemKeyValue"], addTabInfo["IsIndexChangeValue"])
            groupboxList[i] = groupbox;
        end
    end
        
    if tabWidth ~= nil then
        tab:SetItemsFixWidth(tabWidth);
    end
    
    return groupboxList;
end

-- desc : 탭 한개 생성
function UI_LIB_TAB_ADD_TAB(parent, tab, tabItemName, gbName, caption, width, height, uiHorizontal, uiVertical, x, y, tabItemKeyName, tabItemKeyValue, isIndexChangeValue)
    if isIndexChangeValue == nil then
        isIndexChangeValue = true;
    end
    
    local index = tab:GetIndexByName(tabItemName);
    if index ~= -1 then
        return;
    end
    
    local tabitem = tab:AddItemWithName(caption, tabItemName);
    local groupbox = parent:CreateOrGetControl("groupbox", gbName, width, height, uiHorizontal, uiVertical, x, y, 0, 0);
    tab:SetIsIndexChange(isIndexChangeValue);
    AUTO_CAST(groupbox);
    groupbox:SetTabName(tabItemName);
    groupbox:SetSkinName("none");
    
    if tab:GetSelectItemName() == tabItemName then
        groupbox:SetVisible(1);
    else
        groupbox:SetVisible(0);
    end

    groupbox:SetUserValue(tabItemKeyName, tabItemKeyValue);
    return groupbox;
end
