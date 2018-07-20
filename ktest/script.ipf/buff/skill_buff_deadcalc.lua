
function SCR_BUFF_DEAD_VitalProtection_Buff(self, buff, sklID, damage, attacker)
    local abilRetiarii10 = GetAbility(self, "Retiarii10");
    if GetExProp(self, "VITALPROTECTION_TBL_COUNT") == 0 then
        if abilRetiarii10 ~= nil and TryGetProp(abilRetiarii10, "ActiveState") == 1 then    
            
            local addHP = GetExProp(buff, "VITALPROTECTION_ADDHP");
            if addHP == nil then
                addHP = damage
            elseif addHP <= 1 then
                addHP = 1
            end
            
            AddHP(self, addHP);
            AddBuff(self, self, 'VitalProtection_Leave_Buff', 1, 0, 5000, 1);
            if IsPVPServer(self) == 1 then
                SetExProp(self, "VITALPROTECTION_TBL_COUNT", 1);
            end
            return 0;
        end
    end
    
    return 1;
end