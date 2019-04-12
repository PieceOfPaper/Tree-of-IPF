function ON_PCBANG_SHOP_OPEN(frame)
    local tab = GET_CHILD_RECURSIVELY(frame, "tab")
    tab:SetTabVisible(tab:GetIndexByName("main_tab"), false);
    tab:SetTabVisible(tab:GetIndexByName("rental_tab"), false);
    tab:SetTabVisible(tab:GetIndexByName("guide_tab"), false);
    tab:SelectTab(tab:GetIndexByName("pointshop_tab"));    
    local tabName = tab:GetSelectItemName();

    pcBang.ReqPCBangShopPage("COMMON");

    if tabName == "main_tab" then
        ON_PCBANG_SHOP_TAB_MAIN(frame);
    elseif tabName == "pointshop_tab" then
        ON_PCBANG_SHOP_TAB_POINTSHOP(frame);
    elseif tabName == "rental_tab" then
        ON_PCBANG_SHOP_TAB_RENTAL(frame);
    elseif tabName == "guide_tab" then
        ON_PCBANG_SHOP_TAB_GUIDE(frame);
    end
end