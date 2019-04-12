function GUILDINVEN_SEND_ON_INIT(addon, frame)

end

function GUILDINVEN_SEND_INIT(itemClassName, itemCount, itemID)
    local frame = ui.GetFrame('guildinven_send');
    GUILDINVEN_SEND_INIT_ITEM(frame, itemClassName, itemCount, itemID);
    GUILDINVEN_SEND_INIT_MEMBER(frame);
    GUILDINVEN_SEND_SORT(frame, true)
    frame:ShowWindow(1);
end

function GUILDINVEN_SEND_INIT_ITEM(frame, itemClassName, itemCount, itemID)
    -- icon
    local itemSlot = GET_CHILD_RECURSIVELY(frame, 'itemSlot');
    itemSlot:ClearIcon();
    local itemCls = GetClass('Item', itemClassName);
    local icon = CreateIcon(itemSlot);
    icon:SetImage(itemCls.Icon);

    -- name 
    local itemNameText = GET_CHILD_RECURSIVELY(frame, 'itemNameText');
    itemNameText:SetText(itemCls.Name);

    -- count
    local haveText = GET_CHILD_RECURSIVELY(frame, 'haveText');
    local sendText = GET_CHILD_RECURSIVELY(frame, 'sendText');
    local remainText = GET_CHILD_RECURSIVELY(frame, 'remainText');
    haveText:SetTextByKey('count', itemCount);
    sendText:SetTextByKey('count', 0);
    remainText:SetTextByKey('count', itemCount);

    frame:SetUserValue('ITEM_ID', itemID);
end

function GUILDINVEN_SEND_INIT_MEMBER(frame)
    local listBox = GET_CHILD_RECURSIVELY(frame, 'listBox');
    listBox:RemoveAllChild();

    local ODD_INDEX_BG_SKIN = frame:GetUserConfig('ODD_INDEX_BG_SKIN');
    local allMemberCheck = GET_CHILD_RECURSIVELY(frame, 'allMemberCheck');
    local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);        
        local aid = partyMemberInfo:GetAID();
        local ctrlSet = listBox:CreateOrGetControlSet('guild_item_send', 'ITEMSEND_'..aid, 0, 0);
        ctrlSet:SetUserValue('MEMBER_AID', aid);

        local bgBox = ctrlSet:GetChild('bgBox');
        if i % 2 == 0 then
            bgBox:SetSkinName(ODD_INDEX_BG_SKIN);
            ctrlSet:SetUserValue('ODD_BG', 'YES');
        end

        local sendCheck = GET_CHILD(ctrlSet, 'sendCheck');
        sendCheck:SetCheck(allMemberCheck:IsChecked());

        local nameText = ctrlSet:GetChild('nameText');
        nameText:SetText(partyMemberInfo:GetName());      
    end
   GBOX_AUTO_ALIGN(listBox, 0, 0, 0, true, false);
end

function GUILDINVEN_SEND_TYPING(parent, edit)
    local frame = parent:GetTopParentFrame();
    local haveText = GET_CHILD_RECURSIVELY(frame, 'haveText');
    local haveCount = tonumber(haveText:GetTextByKey('count'));

    local sendCheck = GET_CHILD(parent, 'sendCheck');    
    local value = edit:GetText();
    if value ~= nil and value ~= '' and value ~= '0' then
        sendCheck:SetCheck(1);
        if tonumber(value) > haveCount then
            edit:SetText(haveCount);
        end
    else
        sendCheck:SetCheck(0);
    end
    GUILDINVEN_SEND_UPDATE_COUNT_BOX(frame);
end

function GUILDINVEN_SEND_UPDATE_COUNT_BOX(frame)
    local topFrame = frame:GetTopParentFrame();
    local listBox = GET_CHILD_RECURSIVELY(topFrame, 'listBox');
    local listCount = listBox:GetChildCount();
    local sendCount = 0;
    for i = 0, listCount - 1 do
        local child = listBox:GetChildByIndex(i);        
        if child ~= nil and string.find(child:GetName(), 'ITEMSEND_') ~= nil then
            local sendCheck = GET_CHILD(child, 'sendCheck');
            if sendCheck:IsChecked() == 1 then
                local countEdit = GET_CHILD(child, 'countEdit');
                local countText = countEdit:GetText();
                if countText ~= nil and countText ~= '' then
                    sendCount = sendCount + tonumber(countText);
                end
            end
        end
    end
    local haveText = GET_CHILD_RECURSIVELY(topFrame, 'haveText');
    local sendText = GET_CHILD_RECURSIVELY(topFrame, 'sendText');
    local remainText = GET_CHILD_RECURSIVELY(topFrame, 'remainText');
    sendText:SetTextByKey('count', sendCount);

    local remainCount = tonumber(haveText:GetText()) - sendCount;
    local remainStr = string.format('%d', remainCount);
    if remainCount < 0 then
        remainStr = '{#FF0000}'..remainStr;
    end
    remainText:SetTextByKey('count', remainStr);
end

function GUILDINVEN_SEND_CLICK(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local itemID = frame:GetUserValue('ITEM_ID');    
    if itemID == 'None' then
        return;
    end

    if session.colonywar.GetProgressState() == true then
        local colonyRewardItem = GetClass('Item', GET_COLONY_REWARD_ITEM());
        if colonyRewardItem.ClassID == itemID then
            ui.SysMsg(ClMsg('CannotSendColonyReward'));
            return;
        end
    end
    
    local remainText = GET_CHILD_RECURSIVELY(frame, 'remainText');
    local remainCount = tonumber(remainText:GetTextByKey('count'));    
    if remainCount == nil or remainCount < 0 then        
        ui.SysMsg(ClMsg('LackOfHaveCount'));
        return;
    end

    local listBox = GET_CHILD_RECURSIVELY(frame, 'listBox');
    local listCount = listBox:GetChildCount();
    local aidList = {};
    local countList = {};
    for i = 0, listCount - 1 do
        local child = listBox:GetChildByIndex(i);
        if child ~= nil and string.find(child:GetName(), 'ITEMSEND_') ~= nil then
            local aid = child:GetUserValue('MEMBER_AID');
            local sendCheck = GET_CHILD(child, 'sendCheck');
            local countEdit = child:GetChild('countEdit');
            local countValue = countEdit:GetText();
            if aid ~= 'None' and sendCheck:IsChecked() == 1 and countValue ~= nil and countValue ~= '' then
                aidList[#aidList + 1] = aid;
                countList[#countList + 1] = tonumber(countValue);
            end
        end
    end
    local itemGUID = frame:GetUserValue('ITEM_ID');    
    ReqGuildInventorySend(itemGUID, aidList, countList);
    ui.CloseFrame('guildinven_send');
end

function GUILDINVEN_SEND_ALL_MEMBER_CHECK(parent, allMemberCheck)
    local checkValue = allMemberCheck:IsChecked();
    local listBox = parent:GetChild('listBox');
    local listBoxChildCount = listBox:GetChildCount();
    for i = 0, listBoxChildCount - 1 do
        local child = listBox:GetChildByIndex(i);
        local sendCheck = GET_CHILD(child, 'sendCheck');
        if sendCheck ~= nil then
            sendCheck:SetCheck(checkValue);
        end
    end
    GUILDINVEN_SEND_UPDATE_COUNT_BOX(parent);
end

function GUILDINVEN_SEND_SEARCH(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local SEARCH_TARGET_BG_SKIN = topFrame:GetUserConfig('SEARCH_TARGET_BG_SKIN');
    local ODD_INDEX_BG_SKIN = topFrame:GetUserConfig('ODD_INDEX_BG_SKIN');

    local searchEdit = GET_CHILD_RECURSIVELY(topFrame, 'searchEdit');
    local searchText = searchEdit:GetText();

    local searchChild = {};
    local notSearchChild = {};
    local listBox = GET_CHILD_RECURSIVELY(topFrame, 'listBox');
    local childCount = listBox:GetChildCount();    
    for i = 0, childCount - 1 do
        local child = listBox:GetChildByIndex(i);        
        if child ~= nil and string.find(child:GetName(), 'ITEMSEND_') ~= nil then
            local nameText = child:GetChild('nameText');
            if searchText ~= '' and string.find(nameText:GetText(), searchText) ~= nil then
                searchChild[#searchChild + 1] = child:GetName();
            else
                notSearchChild[#notSearchChild + 1] = child:GetName();
            end
        end
    end

    local y = 0;
    for i = 1, #searchChild do
        local child = listBox:GetChild(searchChild[i]);
        local bgBox = child:GetChild('bgBox');
        bgBox:SetSkinName(SEARCH_TARGET_BG_SKIN);
        child:SetOffset(child:GetX(), y);
        y = y + child:GetHeight();
    end
    
    local index = #searchChild + 1;
    for i = 1, #notSearchChild do
        local child = listBox:GetChild(notSearchChild[i]);
        local bgBox = child:GetChild('bgBox');
        if index % 2 == 1 then
            bgBox:SetSkinName(ODD_INDEX_BG_SKIN);
        else
            bgBox:SetSkinName('None');
        end
        child:SetOffset(child:GetX(), y);
        y = y + child:GetHeight();
        index = index + 1;
    end
end

function GUILDINVEN_SEND_SORT_BY_NAME(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local nameText = GET_CHILD_RECURSIVELY(frame, 'nameText');
    local MEMBER_SORT_IMG_ON = frame:GetUserConfig('MEMBER_SORT_IMG_ON');
    local MEMBER_SORT_IMG_OFF = frame:GetUserConfig('MEMBER_SORT_IMG_OFF');
    local sortByName = frame:GetUserValue('SORT_BY_NAME');
    local isByName = false;
    if sortByName == 'YES' then
        nameText:SetTextByKey('arrow', MEMBER_SORT_IMG_ON);
        frame:SetUserValue('SORT_BY_NAME', 'NO');
    else
        nameText:SetTextByKey('arrow', MEMBER_SORT_IMG_OFF);
        frame:SetUserValue('SORT_BY_NAME', 'YES');
        isByName = true;
    end
    GUILDINVEN_SEND_SORT(frame, isByName);

    local searchEdit = GET_CHILD_RECURSIVELY(frame, 'searchEdit');
    searchEdit:SetText('');
end

function GUILDINVEN_SEND_SORT(frame, isByName)
    local listBoxChildTable = {};
    local listBox = GET_CHILD_RECURSIVELY(frame, 'listBox');
    local listBoxChildCount = listBox:GetChildCount();
    for i = 0, listBoxChildCount - 1 do
        local child = listBox:GetChildByIndex(i);
        if child ~= nil and string.find(child:GetName(), 'ITEMSEND_') ~= nil then
            listBoxChildTable[#listBoxChildTable + 1] = child:GetName();
        end
    end

    if isByName == true then
        table.sort(listBoxChildTable, SORT_GUILDINVEN_SEND_BY_NAME);
    else
        table.sort(listBoxChildTable, SORT_GUILDINVEN_SEND_BY_NAME_REVERSE);
    end

    local ODD_INDEX_BG_SKIN = frame:GetUserConfig('ODD_INDEX_BG_SKIN');
    for i = 1, #listBoxChildTable do
        local child = listBox:GetChild(listBoxChildTable[i]);
        local bgBox = child:GetChild('bgBox');
        if i % 2 == 1 then
            bgBox:SetSkinName(ODD_INDEX_BG_SKIN);
        else
            bgBox:SetSkinName('None');
        end
        child:SetOffset(child:GetX(), child:GetHeight() * (i - 1));
    end
end

function SORT_GUILDINVEN_SEND_BY_NAME(a, b)
    local guildinven_send = ui.GetFrame('guildinven_send');
    local aChild = GET_CHILD_RECURSIVELY(guildinven_send, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinven_send, b);
    local aNameCtrl = aChild:GetChild('nameText');
    local bNameCtrl = bChild:GetChild('nameText');
    
    if aNameCtrl == nil or bNameCtrl == nil then
        return false
    end

    if aNameCtrl:GetText() == nil or aNameCtrl:GetText() == "" or bNameCtrl:GetText() == nil or bNameCtrl:GetText() == "" then
        return false
    end

    return aNameCtrl:GetText() < bNameCtrl:GetText();
end

function SORT_GUILDINVEN_SEND_BY_NAME_REVERSE(a, b)
    local guildinven_send = ui.GetFrame('guildinven_send');
    local aChild = GET_CHILD_RECURSIVELY(guildinven_send, a);
    local bChild = GET_CHILD_RECURSIVELY(guildinven_send, b);
    local aNameCtrl = aChild:GetChild('nameText');
    local bNameCtrl = bChild:GetChild('nameText');

    if aNameCtrl == nil or bNameCtrl == nil then
        return false
    end

    if aNameCtrl:GetText() == nil or aNameCtrl:GetText() == "" or bNameCtrl:GetText() == nil or bNameCtrl:GetText() == "" then
        return false
    end


    return aNameCtrl:GetText() > bNameCtrl:GetText();
end