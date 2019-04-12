
function IS_COLONY_TAX_SHOP_NAME(cityMapClsName, shopName) --deparecated.
    local shopTaxCls = GetClass("Shop_tax", shopName);
    return shopTaxCls ~= nil;
end

function CALC_PRICE_WITH_TAX_RATE(originalPriceStr, taxRate)
    if taxRate == nil then 
        return originalPriceStr
    end
    return CalcColonyTaxPrice(originalPriceStr, taxRate)
end

function CALC_TAX_AMOUNT_BY_TAX_RATE(originalPriceStr, taxRate)
    if taxRate == nil then 
        return 0
    end
    return CalcColonyTaxAmount(originalPriceStr, taxRate)
end

---------------------TEST FUNCTIONS---------------------

function TEST_COLONY_TAX_SHOP_NAME()
    local mapClsName = ""
    local shopName = ""
    local ret = false

    mapClsName = "c_Klaipe"

    shopName = "Klapeda_Weapon"
    ret = IS_COLONY_TAX_SHOP_NAME(mapClsName, shopName)
    print(ret, mapClsName, shopName)

    shopName = "Fedimian_Misc"
    ret = IS_COLONY_TAX_SHOP_NAME(mapClsName, shopName)
    print(ret, mapClsName, shopName)
    
    shopName = "Master_Bokor"
    ret = IS_COLONY_TAX_SHOP_NAME(mapClsName, shopName)
    print(ret, mapClsName, shopName)
end