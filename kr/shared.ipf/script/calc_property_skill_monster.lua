function SCR_Get_SkillFactor_Weekly(skill)
    local skillOwner = GetSkillOwner(skill)
    local value = skill.SklFactor
    
    local buffCheck = false
    local buffList = GetBuffList(skillOwner);
    for i = 1, #buffList do
        local buff = buffList[i];
        if IS_CONTAIN_KEYWORD_BUFF(buff, "NormalSkill") == true then
            buffCheck = true;
            break;
        end
    end
    
    local skillKeyword = TryGetProp(skill, "Keyword", "None");
    skillKeyword = StringSplit(skillKeyword, ";");
    if table.find(skillKeyword,"NormalSkill") > 0 and buffCheck == true then
        value = value * 3
    end
    
    return math.floor(value);
end

function SCR_MON_SKILL_SPDRATE_WEEKLY(skill)
    local value = skill.SklSpdRateValue;
    local dexAddAtkSpd = 0;
    local ASPDRate = 100;
    
    if TryGetProp(skill, "AffectedByAttackSpeedRate") == "YES" then
        dexAddAtkSpd = SCR_SKILL_SPDRATE_FROM_DEX(skill);
    end
    
    local skillOwner = GetSkillOwner(skill)
    local buffCheck = false
    local buffList = GetBuffList(skillOwner);
    for i = 1, #buffList do
        local buff = buffList[i];
        if IS_CONTAIN_KEYWORD_BUFF(buff, "NormalSkill") == true then
            buffCheck = true;
            break;
        end
    end
    
    local skillKeyword = TryGetProp(skill, "Keyword", "None");
    skillKeyword = StringSplit(skillKeyword, ";");
    if table.find(skillKeyword,"NormalSkill") > 0 and buffCheck == true then
        ASPDRate = ASPDRate + 50;
    end
    
    value = (value + dexAddAtkSpd) * (ASPDRate / 100);
    
    value = SCR_SPDRATE_LIMIT_CALC(value, "SKILL_ATK");
    
    return value;
end
