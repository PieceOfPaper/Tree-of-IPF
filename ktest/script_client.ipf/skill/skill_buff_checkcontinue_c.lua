-- skill_buff_checkcontinue.lua
-- type : handle, type(Move or Stand)

function SCR_BUFF_C_CHECKCONTINUE_HiphopEffect_pre(handle, type)
    local actor = world.GetActor(handle);
    if actor == nil then
        return 0;
    end

    if type == "Stand" and actor:GetEquipItemFlagProp("EFFECTCOSTUME") == 0 then
        effect.AddActorEffectByOffset(actor, "E_pc_effectitem_hiphop", 1, "Ground");
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 1);
    elseif type == "Move" then
        effect.DetachActorEffect(actor, "E_pc_effectitem_hiphop", 0);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 0);
    end

    return 1;
end