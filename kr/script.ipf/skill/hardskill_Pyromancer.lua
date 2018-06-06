--- hardskill_Pyromancer.lua

function SCR_FLARE_FIREBALL_SKL_HIT(self, skill, x, y, z, range)
    local tgtList = GetHardSkillTargetList(self);
    if tgtList == nil then
        return;
    end
    
    if #tgtList >= 1 then
        local fireballCount = 0;
        for i = 1 , #tgtList do
            local target = tgtList[i];
            if target.ClassName == 'hidden_monster2' then
                fireballCount = fireballCount + 1;
                
                local list, cnt = SelectObjectNear(self, target, range, "ENEMY");
                if cnt >= 1 then
                    for i = 1, cnt do
                        if list[i].ClassName ~= 'hidden_monster2' then
                            AddScpObjectList(self, "FLARE_FIREBALL_ENEMY", list[i]);
                        end
                    end
                end
            end
        end
        
        local enemyList = GetScpObjectList(self, "FLARE_FIREBALL_ENEMY");
        if fireballCount > 0 and #enemyList > 0 then
            local damage = GET_SKL_DAMAGE(self, target, 'Pyromancer_Flare');
            local skill = GET_MON_SKILL(self, 'Pyromancer_Flare');
            
            local enemyCount = math.min(fireballCount, #enemyList);
            
            for j = 1, enemyCount do
                local enemy = enemyList[j];
                
                TakeDamage(self, enemy, skill.ClassName, damage, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
            end
        end
        
        ClearScpObjectList(self, "FLARE_FIREBALL_ENEMY")
    end
end
