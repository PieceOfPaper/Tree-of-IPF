---- lib_math.lua

-- 선형 보간 공식 (Linear Interpolation)
-- 예) 1Lv 일때 30, 100Lv 일때 100의 수치로 레벨링을 하고 싶다.
-- set_LI(value, 30, 100, 1, 100) 또는 set_LI(value, 30, 100) (1과 100은 기본값으로 정해져 있어서 생략 가능)
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

