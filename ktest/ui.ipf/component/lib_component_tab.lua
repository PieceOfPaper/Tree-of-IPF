function UI_LIB_TAB_GET_ADD_TAB_INFO(tabItemName, groupBoxName, caption, tabKeyName, tabKeyValue)
    local info = {}
    info["TabItemName"] = tabItemName;
    info["GroupBoxName"] = groupBoxName;
    info["Caption"] = caption;
    info["TabItemKeyName"] = tabKeyName;
    info["TabItemKeyValue"] = tabKeyValue;
    return info;
end

-- desc : 탭 여러개 생성
function UI_LIB_TAB_ADD_TAB_LIST(parent, tab, addTabInfoList, width, height, uiHorizontal, uiVertical, x, y, groupBoxKey, groupBoxValue, tabWidth)
    tab:ClearItemAll();

    local gb_del = GET_CHILD_BY_USERVALUE(parent, groupBoxKey, groupBoxValue);
    while gb_del ~= nil do
        local index = parent:GetChildIndexByObj(gb_del);
        parent:RemoveChildByIndex(index);
        gb_del = GET_CHILD_BY_USERVALUE(parent, groupBoxKey, groupBoxValue);
    end

    local groupboxList = {};
    for i=1, #addTabInfoList do
        local addTabInfo = addTabInfoList[i];
        local groupbox = UI_LIB_TAB_ADD_TAB(parent, tab, addTabInfo["TabItemName"], addTabInfo["GroupBoxName"], addTabInfo["Caption"], width, height, uiHorizontal, uiVertical, x, y, addTabInfo["TabItemKeyName"], addTabInfo["TabItemKeyValue"])
        
        groupbox:SetUserValue(groupBoxKey, groupBoxValue);
        groupboxList[i] = groupbox;
    end
        
    if tabWidth ~= nil then
        tab:SetItemsFixWidth(tabWidth);
    end
    
    return groupboxList;
end

-- desc : 탭 한개 생성
function UI_LIB_TAB_ADD_TAB(parent, tab, tabItemName, gbName, caption, width, height, uiHorizontal, uiVertical, x, y, tabItemKeyName, tabItemKeyValue)
    local index = tab:GetIndexByName(tabItemName);
    if index ~= -1 then
        print('assert duplicate.')
        return;
    end
    
    if GET_CHILD(parent, gbName) ~= nil then
        print('assert duplicate.')
        return;
    end

    local tabitem = tab:AddItemWithName(caption, tabItemName);
    local groupbox = parent:CreateOrGetControl("groupbox", gbName, width, height, uiHorizontal, uiVertical, x, y, 0, 0);
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
