

---- Monster Rank Check
-- mon : Only Monster Object
-- ... : MonRank (Ex : 'Normal', 'Special', 'Elite', 'Material', 'Boss' ......)
function SCR_QUEST_MONRANK_CHECK(mon, ...)
    local pc_sk_list = {
                        'hidden_monster',
                        'hidden_monster2',
                        'hidden_monster3',
                        'summons_zombie',
                        'Zombie_hoplite',
                        'Zombie_Overwatcher',
                        'pcskill_icewall',
                        'pcskill_dirtywall',
                        'pcskill_summon_Familiar',
                        'pcskill_armor_maintain',
                        'pcskill_armor_maintain_sign',
                        'pcskill_Weapon_sign',
                        'pcskill_Weapon_stone',
                        'pcskill_squire_repair',
                        'pcskill_squire_tent',
                        'pcskill_squire_food_table',
                        'pcskill_pardoner_dedication',
                        'pcskill_falconer_roost',
                        'pcskill_stake_stockades',
                        'pcskill_stake_stockades2',
                        'pcskill_chortasmata',
                        'pcskill_dirtypole',
                        'pcskill_CorpseTower',
                        'pcskill_shogogoth',
                        'pcskill_skullsoldier',
                        'pcskill_snake',
                        'pcskill_bone',
                        'pcskill_Warlock_DarkTheurge',
                        'pcskill_merkabah',
                        'pcskill_warrior_skl_templar',
                        
                        
                        'None'
                        }
    
    local m_rank = {...};
    if mon.Faction == 'Monster' then
        local i;
        if #m_rank >= 1 then
            for i = 1, #m_rank do
                if mon.MonRank == tostring(m_rank[i]) then
                    local j;
                    for j = 1, #pc_sk_list do
                        if mon.ClassName == pc_sk_list[j] then
                            return "NO"
                        end
                    end
                    return "YES"
                end
            end
        end
    end
    return "NO"
end