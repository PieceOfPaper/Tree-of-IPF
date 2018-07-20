
function PCBANG_SHOP_MAIN_FILL_REWARD_BOX(frame, ctrlName, rewardTitle, rewardType, isEnableRecv)
    local ctrl = GET_CHILD_RECURSIVELY(frame, ctrlName)
    local itemName = session.pcBang.GetConnectRewardItemName(rewardType);

    local ctrlgb = GET_CHILD(ctrl, "gb");
    local name_text = GET_CHILD(ctrlgb, "name_text");
    local reward_pic = GET_CHILD(ctrlgb, "reward_pic");
    local recv_btn = GET_CHILD(ctrlgb, "recv_btn");

    local cls = GetClass("Item", itemName);
    if cls == nil then
        return;
    end

    name_text:SetText(rewardTitle);
    reward_pic:SetImage(cls.Icon);
    reward_pic:SetTooltipType("wholeitem")
    reward_pic:SetTooltipArg("", cls.ClassID, "");
    reward_pic:SetTooltipOverlap(1)
    
    if isEnableRecv == 1 then
        recv_btn:SetEventScriptArgString(ui.LBUTTONUP, rewardType);
        recv_btn:SetEventScriptArgNumber(ui.LBUTTONUP, 0);
        recv_btn:SetEnable(1);
        local colorTone = frame:GetUserConfig("COLOR_ENABLE_RECV");
        recv_btn:SetColorTone(colorTone);
    else
        recv_btn:SetEventScriptArgString(ui.LBUTTONDOWN, "None");
        recv_btn:SetEventScriptArgNumber(ui.LBUTTONUP, 0);
        recv_btn:SetEnable(0);
        local colorTone = frame:GetUserConfig("COLOR_DISABLE_RECV");
        recv_btn:SetColorTone(colorTone);
    end

end

function PCBANG_SHOP_MAIN_FILL_TOTAL_REWARD_BOX(frame, ctrlName, receivedTotalHour, curTotalHour)
    local itemName = session.pcBang.GetTotalRewardItemName(receivedTotalHour);
    local isEnableRecv = 0;
    
    local next = session.pcBang.GetNextTotalRewardItemHour(receivedTotalHour);
    if next ~= -1 then
        itemName = session.pcBang.GetTotalRewardItemName(next);
        if next <= curTotalHour then
            isEnableRecv = 1;
        end
    end
    local rewardTitle = ScpArgMsg("PCBangTotalReward{Hour}", "Hour", next);

    local ctrl = GET_CHILD_RECURSIVELY(frame, ctrlName)
    local ctrlgb = GET_CHILD(ctrl, "gb");
    local name_text = GET_CHILD(ctrlgb, "name_text");
    local reward_pic = GET_CHILD(ctrlgb, "reward_pic");
    local recv_btn = GET_CHILD(ctrlgb, "recv_btn");
    
    local cls = GetClass("Item", itemName);
    if cls == nil then
        return;
    end
    
    name_text:SetText(rewardTitle);
    reward_pic:SetImage(cls.Icon);
    reward_pic:SetTooltipType("wholeitem")
	reward_pic:SetTooltipArg("", cls.ClassID, "");
    reward_pic:SetTooltipOverlap(1)

    if isEnableRecv == 1 then
        recv_btn:SetEventScriptArgString(ui.LBUTTONUP, "Hour");
        recv_btn:SetEventScriptArgNumber(ui.LBUTTONUP, next);
        recv_btn:SetEnable(1);
        local colorTone = frame:GetUserConfig("COLOR_ENABLE_RECV");
        recv_btn:SetColorTone(colorTone);
    else
        recv_btn:SetEventScriptArgNumber(ui.LBUTTONDOWN, 0);
        recv_btn:SetEnable(0);
        local colorTone = frame:GetUserConfig("COLOR_DISABLE_RECV");
        recv_btn:SetColorTone(colorTone);
    end

end

function ON_PCBANG_SHOP_MAIN_REWARD_RECV_BTN(parent, ctrl, rewardType, time)
    local name_text = GET_CHILD(parent, "name_text");
    PCBANG_POPUP_REWARD_OPEN(rewardType, name_text:GetText(), time)
end

function ON_UPDATE_PCBANG_SHOP_MAIN_PAGE(frame, msg, strarg, numarg)
    local banner_left_pic = GET_CHILD_RECURSIVELY(frame, "banner_left_pic");
    local banner_bottom_pic = GET_CHILD_RECURSIVELY(frame, "banner_bottom_pic");
    
    local leftBanner = session.pcBang.GetLeftBanner();
    local bottomBanner = session.pcBang.GetBottomBanner();

    banner_left_pic:SetImage(leftBanner);
    banner_bottom_pic:SetImage(bottomBanner);
end
