-- self : Defender
-- from : Attacker
-- skill : AttackSkill
-- atk : Attack Value
-- ret
-- rateTable : Rate Value Table (calc_battle_lib.lua)
-- buff : This Buff

--exemplification
--function SCR_BUFF_RATETABLE_BuffClassName(self, from, skill, atk, ret, rateTable, buff)
--    if IsBuffApplied(from, 'BuffClassName') == 'YES' then
--    if IsBuffApplied(self, 'BuffClassName') == 'YES' then
--        local feintSklLv = GetBuffArgs(buff);
--        if feintSklLv > 0 then
--            local feintRatio = 300 * feintSklLv;
--            rateTable.dodgeDefRatio = rateTable.dodgeDefRatio - feintRatio;
--        end
--    end
--end

--Blk_Down_Debuff
function SCR_BUFF_RATETABLE_Blk_Down(self, from, skill, atk, ret, rateTable, buff)

    if IsBuffApplied(self, 'Blk_Down') == 'YES' then
        local skillLevel = GetBuffArg(buff)
        local blkRate = 500 * skillLevel

        rateTable.blkAdd = rateTable.blkAdd - blkRate;

    end
end

--Velcofer Debuff
function SCR_BUFF_RATETABLE_Raid_Velcofer_Awake_Buff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Raid_Velcofer_Awake_Buff') == 'YES' then
        rateTable.addDamageRate = rateTable.addDamageRate - 0.3
    end
end

--FeildBoss Buff
function SCR_BUFF_RATETABLE_Ability_Weakness_Melee(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Melee') == 'YES' then
        rateTable.addDamageRate = rateTable.addDamageRate - 0.75
    end
end

function SCR_BUFF_RATETABLE_Ability_Weakness_Missile(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Missile') == 'YES' then
        rateTable.addDamageRate = rateTable.addDamageRate - 0.75
    end
end

function SCR_BUFF_RATETABLE_Ability_Weakness_Magic(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Ability_Weakness_Magic') == 'YES' then
        rateTable.addDamageRate = rateTable.addDamageRate - 0.75
    end
end