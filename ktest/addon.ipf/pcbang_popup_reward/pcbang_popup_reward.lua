
function PCBANG_POPUP_REWARD_ON_INIT(addon, frame)
end

function PCBANG_POPUP_REWARD_OPEN(rewardType, titleText, time)
    local itemName = nil
    if rewardType == "Hour" then
        itemName = session.pcBang.GetTotalRewardItemName(time)
    else
        itemName = session.pcBang.GetConnectRewardItemName(rewardType);
    end

    local frame = ui.GetFrame('pcbang_popup_reward');
    local title = GET_CHILD(frame, "title");
    local item_name = GET_CHILD(frame, "item_name");
    local item_pic = GET_CHILD(frame, "item_pic");
    local ok_btn = GET_CHILD(frame, "ok_btn");

    local cls = GetClass("Item", itemName);
    if cls == nil then
        frame:ShowWindow(0);
        return;
    end

    title:SetTextByKey("value", titleText)
    item_name:SetText(cls.Name);
    item_pic:SetImage(cls.Icon);
    
    ok_btn:SetEventScriptArgString(ui.LBUTTONUP, rewardType);
    ok_btn:SetEventScriptArgNumber(ui.LBUTTONUP, time);

    frame:ShowWindow(1);
end


function ON_PCBANG_POPUP_REWARD_REQ(parent, ctrl, rewardType, hour)
    if rewardType == "Hour" then
        pcBang.ReqPCBangShopTotalReward(hour);
    else
        pcBang.ReqPCBangShopConnectReward(rewardType);
    end
    parent:ShowWindow(0);
end

function ON_PCBANG_POPUP_REWARD_CLOSE(frame)
    frame:ShowWindow(0);
end

