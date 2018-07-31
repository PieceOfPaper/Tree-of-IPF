
function PCBANG_SHOP_POINTSHOP_GET_CATEGORY_ITEM_LIST(group)
    local infoCnt = session.pcBang.GetSellingListCount();
    local groupItems = {}
    
    for i = 0, infoCnt - 1 do 
        local info = session.pcBang.GetSellingItem(i);
        if info:GetGroupStr() == group then
            groupItems[#groupItems + 1] = i;
        end
    end
    return groupItems;
end

function PCBANG_SHOP_POINTSHOP_MAKE_LIST(frame, group)
    local constants = {};
    constants["width"] = frame:GetUserConfig("POINTSHOP_PRODUCT_WIDTH");
    constants["height"] = frame:GetUserConfig("POINTSHOP_PRODUCT_HEIGHT");
    constants["divisor"] = frame:GetUserConfig("POINTSHOP_PRODUCT_DIVISOR");

    local products_gb = GET_CHILD_RECURSIVELY(frame, "pointshop_list_products_gb");
    products_gb:RemoveAllChild();

    local infoCnt = session.pcBang.GetSellingListCount();
    local groupItems = PCBANG_SHOP_POINTSHOP_GET_CATEGORY_ITEM_LIST(group);
    
    if #groupItems > 0 then
        for i = 1, #groupItems do
            PCBANG_SHOP_POINTSHOP_MAKE_PRODUCT(products_gb, constants, i-1, groupItems[i]);
        end
    end
end

function PCBANG_SHOP_POINTSHOP_MAKE_PRODUCT(products_gb, constants, positionIndex, productIndex)
    local x = (positionIndex % constants["divisor"]) * constants["width"];
    local y = math.floor(positionIndex / constants["divisor"]) * constants["height"];
    local ctrl = products_gb:CreateOrGetControlSet('pcbang_shop_point_product', 'point_product_' .. positionIndex, x, y);
    AUTO_CAST(ctrl);
    local ctrlgb = GET_CHILD(ctrl, "gb");
    local name_width = ctrl:GetUserConfig("NAME_WIDTH");
    name_width = tonumber(name_width)

    local info = session.pcBang.GetSellingItem(productIndex);
    if info == nil then
        return;
    end
    local cls = GetClass("Item", info.itemName);
    if cls == nil then
        return;
    end

    local productID = info.productID;
    if productID == nil then
        return;
    end
    
    local name_text = GET_CHILD(ctrlgb, "name_text");
    local namestr = cls.Name;
    if info.itemCount > 1 then
        local countstr = "("..ScpArgMsg("Count{n}", "n", info.itemCount)..")"
        namestr = namestr .. countstr;
    end
    name_text:SetText(namestr);
    name_text:AdjustFontSizeByWidth(name_width);
    
    local item_pic = GET_CHILD(ctrlgb, "item_pic");
    item_pic:SetImage(cls.Icon)
    item_pic:SetTooltipType("wholeitem");
    item_pic:SetTooltipArg("", cls.ClassID, 0);
    item_pic:SetTooltipOverlap(1)

    local price_gb = GET_CHILD(ctrl, "price_gb");
    local price_text = GET_CHILD(price_gb, "price_text");
    price_text:SetTextByKey("price", info.price)
    
    local preview_btn = GET_CHILD(ctrlgb, "preview_btn");
    preview_btn:SetVisible(0);

    if TryGetProp(cls, "ClassType") == "Outer" then
        preview_btn:SetEventScriptArgNumber(ui.LBUTTONUP, cls.ClassID);
        preview_btn:SetVisible(1);
    else
        local firstCostumeName = GET_FIRST_COSTUME_NAME_FROM_PACKAGE(cls.ClassName);
        if firstCostumeName ~= nil then
            preview_btn:SetEventScriptArgNumber(ui.LBUTTONUP, cls.ClassID);
            preview_btn:SetVisible(1);
        end
    end

    local purchase_btn = GET_CHILD(ctrlgb, "purchase_btn");
    purchase_btn:SetEventScriptArgNumber(ui.LBUTTONUP, productID);

    local buycount_text = GET_CHILD(ctrlgb, "buycount_text");
    local bought, buylimit = GET_PCBANG_SHOP_POINTSHOP_BUY_LIMIT(info)
    buycount_text:SetTextByKey("bought", bought)
    buycount_text:SetTextByKey("limit", buylimit)
end

function GET_PCBANG_SHOP_POINTSHOP_BUY_LIMIT(productinfo)
    local boughtinfo = session.pcBang.GetBuyCount(productinfo.productID)
    if boughtinfo ~= nil then
        return boughtinfo.boughtCount, productinfo.buyLimitCount;
    end
    return 0, productinfo.buyLimitCount;
end

function ON_PCBANG_SHOP_POINTSHOP_PURCHASE_BTN(parent, btn, argstr, productClsID)
    PCBANG_POPUP_PURCHASE_OPEN(productClsID)
end

function ON_UPDATE_PCBANG_SHOP_POINTSHOP_LIST(frame, msg, argstr, argnum)
    local pointshop_category_common_btn = GET_CHILD_RECURSIVELY(frame, "pointshop_category_common_btn");
    local y = pointshop_category_common_btn:GetOriginalY();
    y = PCBANG_SHOP_POINTSHOP_UPDATE_CATEGORY_BTN(frame, "Common", "pointshop_category_common_btn", y);
    y = PCBANG_SHOP_POINTSHOP_UPDATE_CATEGORY_BTN(frame, "Rotation", "pointshop_category_rotation_btn", y);
    y = PCBANG_SHOP_POINTSHOP_UPDATE_CATEGORY_BTN(frame, "Event", "pointshop_category_event_btn", y);
    PCBANG_SHOP_POINTSHOP_MAKE_LIST(frame, PCBANG_SHOP_TABLE["POINTSHOP_CATEGORY"]);
end

function ON_UPDATE_PCBANG_SHOP_POINTSHOP_BUY_COUNT(frame, msg, argstr, argnum)
    PCBANG_SHOP_POINTSHOP_MAKE_LIST(frame, PCBANG_SHOP_TABLE["POINTSHOP_CATEGORY"]);
end

function PCBANG_SHOP_POINTSHOP_UPDATE_CATEGORY_BTN(frame, category, btnname, y)
    local height = frame:GetUserConfig("POINTSHOP_CATEGORY_HEIGHT")
    height = tonumber(height);
    local pointshop_category_gb = GET_CHILD_RECURSIVELY(frame, "pointshop_category_gb");
    local btn = GET_CHILD(pointshop_category_gb, btnname);

    local groupItems = PCBANG_SHOP_POINTSHOP_GET_CATEGORY_ITEM_LIST(category)
    if #groupItems > 0 then
        btn:SetVisible(1);
        btn:SetOffset(btn:GetOriginalX(), y)
        return y + tonumber(height);
    else
        btn:SetVisible(0);
        return y;
    end
end

function ON_PCBANG_SHOP_POINTSHOP_CATEGORY_BTN(parent, ctrl, argstr, argnum)
    PCBANG_SHOP_TABLE["POINTSHOP_CATEGORY"] = argstr;

    local frame = parent:GetTopParentFrame();
    PCBANG_SHOP_POINTSHOP_MAKE_LIST(frame, PCBANG_SHOP_TABLE["POINTSHOP_CATEGORY"]);
end