function LETICIA_CUBE_ON_INIT(addon, frame)

end

function LETICIA_CUBE_OPEN(frame)
    local frame = ui.GetFrame('leticia_cube');
    LETICIA_CUBE_LIST_UPDATE(frame);
    frame:ShowWindow(1);
end

function LETICIA_CUBE_CLOSE()

end

function LETICIA_CUBE_LIST_UPDATE(frame)
    local cubeListBox = GET_CHILD_RECURSIVELY(frame, 'cubeListBox');
    local defaultSetted = false;
    local ITEM_LIST_INTERVAL = frame:GetUserConfig('ITEM_LIST_INTERVAL');
    local gachaList, cnt = GetClassList("GachaDetail");
    for i = 0, cnt-1 do
        local info = GetClassByIndexFromList(gachaList, i);
        if info ~= nil then
            if info.Group == "NPC" then
                local cube = cubeListBox:CreateOrGetControlSet("leticia_cube_list", 'LIST_'..info.ClassName, 0, 0);
                cube = AUTO_CAST(cube);

                local pic = GET_CHILD_RECURSIVELY(cube, 'iconPic');
                local itemNameText = cube:GetChild('itemNameText');
                local priceText = GET_CHILD_RECURSIVELY(cube, 'priceText');
                local tpText = GET_CHILD_RECURSIVELY(cube, 'tpText');
                local TP_IMG = frame:GetUserConfig('TP_IMG');
                local itemCls = GetClass('Item', info.ItemClassName);
                pic:SetImage(itemCls.Icon);
                if info.ConsumeType == 'TP' then                
                    tpText:SetTextByKey('consumeType', TP_IMG);
                    tpText:SetTextByKey('typeName', 'TP');
                    priceText:SetText(info.Price);                    
                else
                    tpText:SetTextByKey('consumeType', itemCls.Icon);
                    tpText:SetTextByKey('typeName', '');
                    priceText:SetText(itemCls.Name);                    
                end
                itemNameText:SetText(itemCls.Name);

                cube:SetEventScript(ui.LBUTTONDOWN, 'LETICIA_CUBE_CHANGE_INFO');
                cube:SetEventScriptArgString(ui.LBUTTONDOWN, info.ItemClassName);
                cube:SetUserValue('GACHA_DETAIL_CLASS_NAME', info.ClassName);

                if defaultSetted == false then
                    LETICIA_CUBE_CHANGE_INFO(cubeListBox, cube, info.ItemClassName);
                    defaultSetted = true;
                end
            end
        end
    end
    GBOX_AUTO_ALIGN(cubeListBox, 0, ITEM_LIST_INTERVAL, 0, true, false);
end

function LETICIA_CUBE_CHANGE_INFO(cubeListBox, ctrlSet, argStr)
    local itemCls = GetClass("Item", argStr);
    local gachaClassName = ctrlSet:GetUserValue('GACHA_DETAIL_CLASS_NAME');
    local gachaCls = GetClass('GachaDetail', gachaClassName);

    local topframe = cubeListBox:GetTopParentFrame();
    local TP_IMG = topframe:GetUserConfig('TP_IMG');
    local cubePic = GET_CHILD_RECURSIVELY(topframe, 'cubePic');
    local cubeText = GET_CHILD_RECURSIVELY(topframe, 'cubeText');
    local openBtn = GET_CHILD_RECURSIVELY(topframe, 'openBtn');
    cubePic:SetImage(itemCls.Icon);
    cubeText:SetText(itemCls.Name);
    if gachaCls.ConsumeType == 'TP' then
        openBtn:SetTextByKey('icon', TP_IMG);
    else
        openBtn:SetTextByKey('icon', itemCls.Icon);
    end
    topframe:SetUserValue("CubeName", itemCls.ClassName);
    topframe:SetUserValue('GACHA_DETAIL_NAME', gachaClassName);       
end

function LETICIA_CUBE_OPEN_BUTTON(frame, ctrl, argStr, argNum, _gachaClassName, _cubeName)
    local gachaClassName = frame:GetUserValue('GACHA_DETAIL_NAME');
    if _gachaClassName ~= nil then
        gachaClassName = _gachaClassName;
    end
    local cubeName = frame:GetUserValue("CubeName");
    if _cubeName ~= nil then
        cubeName = _cubeName;
    end

    local gachaCls = GetClass('GachaDetail', gachaClassName);    
    local cubeItemCls = GetClass('Item', cubeName);
    local TP_IMG = frame:GetUserConfig('TP_IMG');
    local clMsg = '';
    if gachaCls.ConsumeType == 'TP' then
        clMsg = string.format('{@st66d}{s18}{img %s 40 40} %d{/}{/}', TP_IMG, gachaCls.Price);
    else
        clMsg = string.format('{@st66d}{s18}{img %s 40 40} %s{/}{/}', cubeItemCls.Icon, cubeItemCls.Name);
    end    

    if frame:GetUserIValue('OPEN_MSG_BOX') == 0 then
        ui.MsgBox(ScpArgMsg('LeticiaGacha{CONSUME}', 'CONSUME', clMsg)..'{nl} {nl}'..'{#85070a}'..ClMsg('ContainWarningItem'), 'REQ_LETICIA_CUBE_OPEN("'..cubeName..'")', 'LETICIA_CUBE_CLOSE_ALL()');
        frame:SetUserValue('OPEN_MSG_BOX', 1);
    end
end

function REQ_LETICIA_CUBE_OPEN(cubeItemName)
    ui.CloseFrame('fulldark');

    local scpString = string.format("/leticia_gacha %s",  cubeItemName);    
	ui.Chat(scpString);

    LETICIA_CUBE_MSG_BOX_RESET();
    ui.CloseFrame('leticia_cube');
end

function LETICIA_CUBE_MSG_BOX_RESET()
    local leticia_cube = ui.GetFrame('leticia_cube');
    leticia_cube:SetUserValue('OPEN_MSG_BOX', 0);
end

function LETICIA_CUBE_CLOSE_ALL()
    ui.CloseFrame('fulldark');
    LETICIA_CUBE_MSG_BOX_RESET();
end