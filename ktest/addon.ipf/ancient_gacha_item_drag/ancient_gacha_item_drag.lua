function INIT_ANCEINT_GACHA_ITEM_DRAG(dragFrame,ctrlSet)
    local clsID = ctrlSet:GetUserValue("ITEM_ID")
    local itemCls = GetClassByType("Item",clsID)
    local pic = GET_CHILD_RECURSIVELY(dragFrame,'drag_pic')
    pic:SetImage(itemCls.Icon)
    local frame = ctrlSet:GetTopParentFrame()
    frame:SetUserValue("LIFTED_ITEM_ID",clsID)
end