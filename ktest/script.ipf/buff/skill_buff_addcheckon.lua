--skill_buff_addcheckon.lua

function SCR_BUFF_ADDCHECKON_Prophecy_Buff(self, buff, targetBuffName)
    local buffArg1, buffArg2 = GetBuffArg(buff);
    if buffArg1 <= 0 then
        return 1;
    end
    
    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end
    
    if targetBuffCls.Group1 ~= "Debuff" then
        return 1;
    end
    
    if targetBuffCls.Lv == 1 then
        PlayEffectNode(self, "E_pc_shield_square", 1.0, "Dummy_emitter");
        buffArg1 = buffArg1 - 1;
        SetBuffArg(self, buff, buffArg1, buffArg2);
        if buffArg1 <= 0 then
            RemoveBuff(self, buff.ClassName);
        end
        
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_ADDCHECKON_BeakMask_Buff(self, buff, targetBuffName)
    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end
    
    if targetBuffCls.Group1 ~= "Debuff" then
        return 1;
    end
    
    if targetBuffCls.Lv == 1 or targetBuffCls.Lv == 2 then
        PlayEffectNode(self, "E_pc_shield_square", 1.0, "Dummy_emitter");
        return 0;
    end
    
    if targetBuffCls.Lv == 3 then
        PlayEffectNode(self, "E_pc_shield_square", 1.0, "Dummy_emitter");
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_ADDCHECKON_Bloodletting_Buff(self, buff, targetBuffName)
    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end
    
    if targetBuffCls.Group1 ~= "Debuff" then
        return 1;
    end
    
    if targetBuffCls.Lv == 1 or targetBuffCls.Lv == 2 then
        PlayEffectNode(self, "E_pc_shield_square", 1.0, "Dummy_emitter");
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_ADDCHECKON_Prevent_Buff(self, buff, targetBuffName, from)
    if from == nil then 
        return 1;
    end
    
    if GetObjType(self) ~= OT_PC then
        return 1;
    end
    
    if GetHandle(self) == GetHandle(from) then
        return 1;
    end
    
    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end
    
    if targetBuffCls.Group1 ~= "Debuff" then
        return 1;
    end
    
    if targetBuffCls.Lv <= 99 then
        return 0;
    end
    
    return 1;
end




------------------------------------------
------------------------------------------
---------- velcoffer_raid_gimmick---------
function SCR_BUFF_ADDCHECKON_INVINCIBILITY_EXCEPT_FOR_CERTAIN_ATTACKS(self, buff, targetBuffName, from)
    if from == nil then 
        return 1;
    end

    if GetHandle(self) == GetHandle(from) then
        return 1;
    end

    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end
    
    if targetBuffCls.Lv <= 3 then
        PlayEffectNode(self, "E_pc_shield_square", 1.0, "Dummy_emitter");
        return 0;
    end
    
    return 1;
end
