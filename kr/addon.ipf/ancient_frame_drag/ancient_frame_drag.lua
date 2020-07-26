function INIT_ANCEINT_FRAME_DRAG(dragFrame,frame)
    local guid = frame:GetUserValue("ANCIENT_GUID")
    local card = session.pet.GetAncientCardByGuid(guid)
    SET_ANCIENT_CARD_SLOT(dragFrame,card)
    frame = frame:GetTopParentFrame()
    frame:SetUserValue("LIFTED_GUID",guid)
end
