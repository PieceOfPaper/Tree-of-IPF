
function PCBANG_POPUP_PURCHASE_ON_INIT(addon, frame)
end

function PCBANG_POPUP_PURCHASE_OPEN(productClsID)
    local itemName = nil;
    local infoCnt = session.pcBang.GetSellingListCount();
    local info = nil;
    for i = 0, infoCnt - 1 do 
        local iteminfo = session.pcBang.GetSellingItem(i);
        if iteminfo.productID == productClsID then
            info = iteminfo;
        end
    end
    
    if info == nil then
        return;
    end

    local frame = ui.GetFrame("pcbang_popup_purchase");

    local item_name = GET_CHILD(frame, "item_name");
    local item_pic = GET_CHILD(frame, "item_pic");
    local buycount_text = GET_CHILD(frame, "buycount_text");

    local cls = GetClass("Item", info.itemName);
    if cls == nil then
        frame:ShowWindow(0);
        return;
    end

    item_name:SetText(cls.Name);
    item_pic:SetImage(cls.Icon);

    local bought, buylimit = GET_PCBANG_SHOP_POINTSHOP_BUY_LIMIT(info)
    buycount_text:SetTextByKey("bought", bought)
    buycount_text:SetTextByKey("limit", buylimit)
    
    frame:SetUserValue("Product", productClsID);
    frame:ShowWindow(1);
end

function ON_PCBANG_POPUP_PURCHASE_YES(frame)
    local productClsID = frame:GetUserIValue("Product");
    pcBang.ReqPCBangShopPurchase(productClsID);
    frame:ShowWindow(0);
end

function ON_PCBANG_POPUP_PURCHASE_NO(frame)
    frame:ShowWindow(0);
end
