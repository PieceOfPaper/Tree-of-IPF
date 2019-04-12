function BRIQUETTING_RESULT_ON_INIT(addon, frame)
    addon:RegisterMsg('SUCCESS_BRIQUETTING', 'ON_SUCCESS_BRIQUETTING');
end

function ON_SUCCESS_BRIQUETTING(frame, msg, argStr, briquettingItemID)
    local itemPic = GET_CHILD_RECURSIVELY(frame, 'itemPic');
    local itemCls = GetClassByType('Item', briquettingItemID);
    itemPic:SetImage(itemCls.Icon);
    frame:ShowWindow(1);

    local posX = option.GetClientWidth() / 2;
    local posY = option.GetClientHeight() / 2 - 50;
    movie.PlayUIEffect('I_gacha_end03', posX, posY, 7);
end