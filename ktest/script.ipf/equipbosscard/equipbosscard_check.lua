-- equipbosscard_check.lua
-- º¸½º?μ恥ø ?°??¿ v°?, ?·? 

-- MON~ ½ø®® kill attack damage ≫셰?-- SCR_CARDCHECK_NORMALμμ kill attack damage ≫셰?
-- self, target, obj, TypeValue, arg1, arg2, arg3
--typevalue : CardCount/StarCount/MaxStar

-- arg1 : potionType
-- arg2 : nil
function SCR_CARDCHECK_POTION_USE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and arg1 ~= nil then
        local potionList = { };
        potionList["HPPOTION"] = { "HPPOTION", "HPPOTION_TP", "HPPOTION_Alche" };
        potionList["SPPOTION"] = { "SPPOTION", "SPPOTION_TP", "SPPOTION_Alche" };
        potionList["STAPOTION"] = { "STAPOTION" };
        
        
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if potionList[arg1] ~= nil then
            for i = 1, #potionList[arg1] do
                if TryGetProp(target, "CoolDownGroup") == potionList[arg1][i] then
                    return 1;
                end
            end
        end
        
        if arg1=='HPPOTION' or arg1 == 'SPPOTION' then
            if TryGetProp(target, "CoolDownGroup") == 'HPSPPOTION' then
                return 1;
            end
        end 
    end
    return 0;
end

-- arg1 : rank
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_MONRANK(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        if arg2 == 'None' then
            arg2 = TypeValue;
        end     
        if TryGetProp(target, 'MonRank') == arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

-- arg1 : size
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_MONSIZE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)  
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        
        if TryGetProp(target, 'Size') == arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

-- arg1 : race
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_MONRACE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
         
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if TryGetProp(target, 'RaceType') == arg1 or TryGetProp(target, 'MoveType') == arg1 or TryGetProp(target, 'ArmorMaterial') == arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

-- arg1 : race
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_MOVE_TYPE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)    
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then

        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end 
        
        if TryGetProp(target, 'MoveType') == arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

-- arg1 : attribute
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_MONATTRIBUTE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        
        if TryGetProp(target, 'Attribute') == arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

-- arg1 : nil
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_NORMAL(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil then
        if IsBuffApplied(self, tostring(arg3)) == 'YES' then
            return 0;
        end
        
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end

        if arg2 >= IMCRandom(1, 100) then
            return 1;   
        end
    end
    return 0;
end

-- arg1 : nil
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_DEAD(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if GetExProp(self, "DURAHAN_CARD_COUNT") == 2 then
        return 0;
    end
    
    if self ~= nil then
        
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if arg2 >= IMCRandom(1, 100) then
            return 1;   
        end
    end
    return 0;
end

-- arg1 : classType (Melee, Missile, Magic)
-- arg2 : probability : default TypeValue
function SCR_CARDCHECK_ATTACKTYPE_ATTACK(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end

        local arg1List = SCR_STRING_CUT(arg1)
        if #arg1List >= 1 then
            for i = 1, #arg1List do
                if TryGetProp(obj, 'ClassType') == arg1List[i] then
                    if arg2 >= IMCRandom(1, 100) then
                        return 1;
                    end
                end
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_ATTACKTYPE_EQUIP(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and TypeValue ~= nil then
        local equipitem = GetEquipItem(self, 'RH')
        local equipType = TryGetProp(equipitem, "EqpType")
        local atkType = TryGetProp(equipitem, "AttackType")
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        
        if arg1 == equipType then
            arg2 = math.floor(arg2)
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        elseif arg1 == atkType then
            arg2 = math.floor(arg2)
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_ATTACK_RATE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil then
        if IsBuffApplied(self, arg3) == 'YES' then
            return 0;
        end

        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        if arg2 >= 1 then
            if arg2 == 100 then
                return 1;
            end
            arg2 = math.floor(TypeValue/arg2)
        end
        if arg2 >= IMCRandom(1, 100) then
            return 1;
        end
    end
    return 0;
end

function SCR_CARDCHECK_ATTACKTYPE_MISSILE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and TypeValue ~= nil then
        local equipitemrh = GetEquipItem(self, 'RH')
        local equipitemlh = GetEquipItem(self, 'LH')
        local atktyperh = TryGetProp(equipitemrh, "AttackType")
        local atktypelh = TryGetProp(equipitemlh, "AttackType")

        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end

        if atktyperh == "Arrow" or atktyperh == "Gun" then
            arg2 = math.floor(arg2)
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_MONSTATE(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        if arg1 ~= "None" then
            return 0;
        end        
        local arg1 = GetActionState(target);
        if arg1 == 'AS_KNOCKDOWN' or agr1 == 'AS_DOWN' then
            return 1;
        end
    end
    return 0;
end

function SCR_CARDCHECK_MONRANK_DUAL(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    local arg1List = StringSplit(arg1, "/");
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1List ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
        
        if arg2 == 'None' then
            arg2 = TypeValue;
        end

        for i = 1, #arg1List do     
            if TryGetProp(target, 'MonRank') == arg1List[i] then
                if arg2 >= IMCRandom(1, 100) then
                    return 1;
                end
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_NORMAL_COOLDOWN(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil then
        local nowtime = imcTime.GetAppTimeMS();
        local cooldown = arg4
        local effctActive = GetExProp(self, "CARD_EFFECT_ACTIVE")

        if nowtime >= effctActive + cooldown or effctActive == nil then
            if tonumber(arg2) ~= nil then
                arg2 = tonumber(arg2)
            end
        
            if arg2 == 'None' then
                arg2 = TypeValue;
            end
        
            if arg2 >= IMCRandom(1, 100) then
                return 1;   
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_MONRANK_SIZE_DUAL_COOLDOWN(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    local arg1List = StringSplit(arg1, "/");
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1List ~= nil then
        local nowtime = imcTime.GetAppTimeMS();
        local cooldown = arg4
        local effctActive = GetExProp(self, "CARD_EFFECT_ACTIVE")

        if nowtime >= effctActive + cooldown or effctActive == nil then
            if tonumber(arg2) ~= nil then
                arg2 = tonumber(arg2)
            end
            
            if arg2 == 'None' then
                arg2 = TypeValue;
            end
    
            for i = 1, #arg1List do     
                if TryGetProp(target, 'MonRank') == arg1List[i] or TryGetProp(target, 'Size') == arg1List[i]then
                    if arg2 >= IMCRandom(1, 100) then
                        return 1;
                    end
                end
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_MONSIZE_COOLDOWN(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)  
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        local nowtime = imcTime.GetAppTimeMS();
        local cooldown = arg4
        local effctActive = GetExProp(self, "CARD_EFFECT_ACTIVE")

        if nowtime >= effctActive + cooldown or effctActive == nil then
            if tonumber(arg2) ~= nil then
                arg2 = tonumber(arg2)
            end
            
            if arg2 == 'None' then
                arg2 = TypeValue;
            end
            
            if TryGetProp(target, 'Size') == arg1 then
                if arg2 >= IMCRandom(1, 100) then
                    return 1;
                end
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_MONRACE_DUAL(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    local arg1List = StringSplit(arg1, "/");
    if self ~= nil and target ~= nil and TypeValue ~= nil and arg1 ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end
            
        if arg2 == 'None' then
            arg2 = TypeValue;
        end
        
        for i = 1, #arg1List do     
            if TryGetProp(target, 'MonRank') == arg1List[i] or TryGetProp(target, 'Size') == arg1List[i]then
                if arg2 >= IMCRandom(1, 100) then
                    return 1;
                end
            end
        end
    end
    return 0;
end

function SCR_CARDCHECK_ATTACKTYPE_ATTACK_BOSS_CHECK(self, target, obj, TypeValue, arg1, arg2, arg3, arg4)
    if self ~= nil and target ~= nil and TypeValue ~= nil then
        if tonumber(arg2) ~= nil then
            arg2 = tonumber(arg2)
        end

        if arg2 == 'None' then
            arg2 = TypeValue;
        end

        if TryGetProp(target, 'MonRank') ~= arg1 then
            if arg2 >= IMCRandom(1, 100) then
                return 1;
            end
        end
    end

    return 0;
end