---- lib_math.lua

-- ¼±? º¸°￡ °??Linear Interpolation)
-- ¿¹) 1Lv O¶§ 30, 100Lv O¶§ 100G ¼???·¹º§¸μ; ?°렽??
-- set_LI(value, 30, 100, 1, 100) ¶? set_LI(value, 30, 100) (1°??: ±?°ª8·?d?n V¾? ≫셃?´?
function set_LI(value, min, max, s, e)
    
    s = s and s or 1
    e = e and e or 100
    local x = value<s and s or (value>e and e or value)
    
    local ret = min + ((x-s) / (e-s) * (max-min))
    --print(s.."  "..e.."  "..x.."  "..ret)
    
    return ret
    
end

function CLAMP(v, minv, maxv)
    if v < minv then
        return minv;
    end

    if v > maxv then
        return maxv;
    end

    return v;
end

function SyncFloor(value)
    -- ROUND --
    value = math.floor((value*1.0)+0.5) / 1.0;
    return(value);
end

function MinMaxCorrection(value, minVal, maxVal)
    value = math.min(math.max(minVal, value), maxVal);
    return(value);
end

function LERP(p1, p2, d1)
  return (1 - d1) * p1 + d1 * p2;
end