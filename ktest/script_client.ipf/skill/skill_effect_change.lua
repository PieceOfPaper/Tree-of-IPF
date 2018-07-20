--- skill_effect_change.lua

function EFFECT_CHANGE_ItemSkill_boss_Golem(self, obj, eftName, eftScale)

	return eftName, eftScale * (1 + obj.Level * 0.2);

end

function EFFECT_CHANGE_ItemSkill_boss_Gaigalas(self, obj, eftName, eftScale)

	return eftName, eftScale;

end

function EFFECT_CHANGE_ItemSkill_boss_onion_the_great(self, obj, eftName, eftScale)

	local ret_eftScale = eftScale * (1 + obj.Level * 0.1);
	
	return eftName, ret_eftScale;
	
end

function EFFECT_CHANGE_ItemSkill_boss_Denoptic(self, obj, eftName, eftScale)

    --print(eftName)
    --print(eftScale)

    if eftName == 'F_sys_target_pc' then    
        local ret_eftScale = eftScale * (1 + obj.Level * 0.08);
	    return eftName, ret_eftScale;
    end
    
    if eftName == 'I_smoke043' then    
        local ret_eftScale = eftScale * (1 + obj.Level * 0.12);
	    return eftName, ret_eftScale;
    end

end

function EFFECT_CHANGE_ItemSkill_boss_Colimencia(self, obj, eftName, eftScale)

    --print(eftName)
    --print(eftScale)

    if eftName == 'I_smoke016_spread_out' then    
        local ret_eftScale = eftScale * (1 + obj.Level * 0.08);
	    return eftName, ret_eftScale;
    end

end


