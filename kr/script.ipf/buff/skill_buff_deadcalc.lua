
function SCR_BUFF_DEAD_VitalProtection_Buff(self, buff, sklID, damage, attacker)
    local abilRetiarii10 = GetAbility(self, "Retiarii10");
    if abilRetiarii10 ~= nil and TryGetProp(abilRetiarii10, "ActiveState") == 1 then    
        AddHP(self, damage);
        AddBuff(self, self, 'VitalProtection_Leave_Buff', 1, 0, 5000, 1);
        return 0;
    end
    
    return 1;
end