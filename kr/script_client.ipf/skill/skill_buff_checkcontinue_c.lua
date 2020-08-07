-- skill_buff_checkcontinue.lua
-- type : handle, type(Move or Stand)

function SCR_BUFF_C_CHECKCONTINUE_HiphopEffect_pre(handle, type)
    local actor = world.GetActor(handle);
    if actor == nil then
        return 0;
    end

    if session.colonywar.GetIsColonyWarMap() == true and seesion. config.GetShowGuildInColonyEffectCostume() == 0 then
        return 0;
    end

    if type == "Stand" and actor:GetEquipItemFlagProp("EFFECTCOSTUME") == 0 then
        effect.AddActorEffectByOffset(actor, "E_pc_effectitem_hiphop", 1, "Ground", false, true);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 1);
    elseif type == "Move" then
        effect.DetachActorEffect(actor, "E_pc_effectitem_hiphop", 0);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 0);
    end

    return 1;
end

function SCR_BUFF_C_CHECKCONTINUE_EP12TACTICAL_EFFECT02_PRE(handle, type)
    local actor = world.GetActor(handle);
    if actor == nil then
        return 0;
    end

    if session.colonywar.GetIsColonyWarMap() == true and config.GetShowGuildInColonyEffectCostume() == 0 then
        return 0;
    end

    if type == "Stand" and actor:GetEquipItemFlagProp("EFFECTCOSTUME") == 0 then
        effect.AddActorEffectByOffset(actor, "I_policeline001_mesh", 1, "Middle", true, true);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 1);
    elseif type == "Move" then
        effect.DetachActorEffect(actor, "I_policeline001_mesh", 0);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 0);
    end

    return 1;
end
-- 끼룩끼룩 갈매기
function SCR_BUFF_C_CHECKCONTINUE_ITEM_EP12FLYINGSEAGULL_EFFECT_PRE(handle, type)
    local actor = world.GetActor(handle);
    if actor == nil then
        return 0;
    end

    if session.colonywar.GetIsColonyWarMap() == true and config.GetShowGuildInColonyEffectCostume() == 0 then
        return 0;
    end

    if type == "Stand" and actor:GetEquipItemFlagProp("EFFECTCOSTUME") == 0 then
        effect.AddActorEffectByOffset(actor, "I_pc_effectitem_flyingseagull", 1.35, "BOT", true, true);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 1);
    elseif type == "Move" then
        effect.DetachActorEffect(actor, "I_pc_effectitem_flyingseagull", 0);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 0);
    end

    return 1;
end-- 주변을 맴도는 상어
function SCR_BUFF_C_CHECKCONTINUE_ITEM_EP12TWINSHARK_EFFECT_PRE(handle, type)
    local actor = world.GetActor(handle);
    if actor == nil then
        return 0;
    end

    if session.colonywar.GetIsColonyWarMap() == true and config.GetShowGuildInColonyEffectCostume() == 0 then
        return 0;
    end

    if type == "Stand" and actor:GetEquipItemFlagProp("EFFECTCOSTUME") == 0 then
        effect.AddActorEffectByOffset(actor, "E_effect_twinshark", 1.35, "BOT", true, true);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 1);
    elseif type == "Move" then
        effect.DetachActorEffect(actor, "E_effect_twinshark", 0);
        actor:SetEquipItemFlagProp("EFFECTCOSTUME", 0);
    end

    return 1;
end