-- 기본정보창 연산식 정보 제공 관련

 -- CRTHR - 치명
 -- CRTDR - 치명 저항
 -- HR - 명중
 -- DR - 회피

 ITEM_POINT_MULTIPLE = 10
 ITEM_ATK_POINT_MULTIPLE = 20

-- 주기별 회복 수치
local max_hp_recovery_ratio = 0.2 -- MHP 의 전체의 비율

function get_log_scale(ret)
    ret = (math.log(ret + 6.01) / math.log(1.06) - 30.8) * 0.8    
    return ret
end

-- 서버에서 사용하는 함수
function get_hp_recovery_ratio(pc, value)
    if pc == nil then
        pc = GetMyPCObject()
    end
    
    if pc == nil then
        return 0
    end
    local mhp = TryGetProp(pc, 'MHP', 1)
    local rhp = 0

    if value == nil then
        rhp = TryGetProp(pc, 'RHP', 0)
    else
        rhp = value
    end
   
    local ratio = rhp / (ITEM_POINT_MULTIPLE * pc.Lv)
    ratio = ratio * max_hp_recovery_ratio    
    ratio = math.min(max_hp_recovery_ratio, ratio)
    ratio = ratio * mhp

    return math.floor(ratio)
end

-- hp 회복력
function get_RHP_ratio_for_status(value)
    local applied_value = get_hp_recovery_ratio(nil, value)
    return value .. '{#00FF00} (' .. applied_value .. ')'
end

-- sp 회복력
function get_RSP_ratio_for_status(value)     
    return value .. '{#66b3ff} (' .. value .. ')'
end

-- 추가 공격력 관련
function get_calc_atk_value_for_status(pc, prop_value)
    local value = prop_value / (pc.Lv * ITEM_ATK_POINT_MULTIPLE)
    value = value * 100

    if value > 100 then
        value = 100
    elseif value < 0 then
        value = 0
    end        
    return string.format("%.1f", value)
end

function get_SmallSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_MiddleSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_LargeSize_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_MiddleSize_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Cloth_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Leather_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Iron_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Cloth_Def_ratio_for_status(value)    
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Leather_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Iron_Def_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#66b3ff}(' .. ret .. '%)'
end

function get_Forester_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Widling_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Klaida_Atk_ratio_for_status(value)
    local ret = 0    
    local pc = GetMyPCObject()
    
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)        
    end
    
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Paramune_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Velnias_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_Ghost_Atk_ratio_for_status(value)
    local ret = 0

    local pc = GetMyPCObject()
    if pc ~= nil then        
        ret = get_calc_atk_value_for_status(pc, value)
    end
    return value .. ' {#ff4040}(' .. ret .. '%)'
end

function get_AttackType_value_Cannon(pc)
    local value = 10
    if pc ~= nil then
        --value = value + (TryGetProp(pc, 'STR', 0) / 100)
    end

    return value
end
