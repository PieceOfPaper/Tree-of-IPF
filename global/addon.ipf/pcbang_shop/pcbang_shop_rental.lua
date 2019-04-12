
function PCBANG_SHOP_RENTAL_MAKE_LIST(frame, group)
    local constants = {};
    constants["width"] = frame:GetUserConfig("RENTAL_PRODUCT_WIDTH");
    constants["height"] = frame:GetUserConfig("RENTAL_PRODUCT_HEIGHT");
    constants["divisor"] = frame:GetUserConfig("RENTAL_PRODUCT_DIVISOR");

    local products_gb = GET_CHILD_RECURSIVELY(frame, "rental_list_products_gb");
    products_gb:RemoveAllChild();

    local infoCnt = session.pcBang.GetRentalListCount();
    local groupItems = {}

    for i = 0, infoCnt - 1 do 
        local info = session.pcBang.GetRentalItem(i);
        local cls = GetClass("Item", info.itemName)
        if cls ~= nil and string.match(cls.GroupName, group) then
            groupItems[#groupItems + 1] = info;
        end
    end
    
    for i = 1, #groupItems do
        PCBANG_SHOP_RENTAL_MAKE_PRODUCT(products_gb, constants, i-1, groupItems[i]);
    end
end

function PCBANG_SHOP_RENTAL_MAKE_PRODUCT(products_gb, constants, positionIndex, rentalItemInfo)
    local cls = GetClass("Item", rentalItemInfo.itemName);
    local clsID = cls.ClassID;

    local x = (positionIndex % constants["divisor"]) * constants["width"];
    local y = math.floor(positionIndex / constants["divisor"]) * constants["height"];
    local ctrl = products_gb:CreateOrGetControlSet('pcbang_shop_rental_product', 'rental_product_' .. positionIndex, x, y);
    local ctrlgb = GET_CHILD(ctrl, "gb");

    local name_text = GET_CHILD(ctrlgb, "name_text");
    name_text:SetText(cls.Name);
    
    local item_pic = GET_CHILD(ctrlgb, "item_pic");
    item_pic:SetImage(cls.Icon)
    item_pic:SetTooltipType("wholeitem");
    local optionarg = string.format("pcbang_rental#%d#%d", rentalItemInfo.reinforce, rentalItemInfo.transcend)
    item_pic:SetTooltipArg(optionarg, clsID, "");
    item_pic:SetTooltipOverlap(1)
    
    local option_pic = GET_CHILD(ctrlgb, "option_pic");
    local option_text_2 = GET_CHILD(ctrlgb, "option_text_2");
    option_text_2:SetTextByKey("value", rentalItemInfo.reinforce);    

    local recv_btn = GET_CHILD(ctrlgb, "recv_btn");
    recv_btn:SetEventScriptArgNumber(ui.LBUTTONUP, clsID);
end

function ON_PCBANG_SHOP_POINTSHOP_PREVIEW_BTN(parent, btn, argstr, itemClsID)
    PCBANG_POPUP_PREVIEW_OPEN(itemClsID)
end

function ON_PCBANG_SHOP_RETNAL_RECV_BTN(parent, btn, argstr, itemClsID)
    pcBang.ReqPCBangShopRental(itemClsID);
end


function ON_UPDATE_PCBANG_SHOP_RENTAL_LIST(frame, msg, argstr, argnum)
    PCBANG_SHOP_RENTAL_MAKE_LIST(frame, PCBANG_SHOP_TABLE["RENTAL_CATEGORY"]);
end

function ON_PCBANG_SHOP_RENTAL_CATEGORY_BTN(parent, ctrl, argstr, argnum)
    PCBANG_SHOP_TABLE["RENTAL_CATEGORY"] = argstr;
    
    local frame = parent:GetTopParentFrame();
    PCBANG_SHOP_RENTAL_MAKE_LIST(frame, PCBANG_SHOP_TABLE["RENTAL_CATEGORY"]);
end