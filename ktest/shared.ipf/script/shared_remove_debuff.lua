-- shared_remove_debuff.lua
-- 아군 디버프 삭제 관련

--------------------------------------------------------------------
---------------------------- 소드맨  --------------------------------
-------------------------------------------------------------------- 
-- 펠타스타 - 가디언
function get_remove_debuff_tooltip_Peltasta_Guardian(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around 
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 템플러 - 불가침 영역
function get_remove_debuff_tooltip_Templer_NonInvasiveArea(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end


-- 매화검수 - 기수식
function get_remove_debuff_tooltip_BlossomBlader_StartUp(level)
    local percent = 6.7 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

--------------------------------------------------------------------
---------------------------- 아처   --------------------------------
-------------------------------------------------------------------- 

-- 헌터 - 그로울링
function get_remove_debuff_tooltip_Hunter_Growling(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 쿼렐슈터 - 블록 앤드 샷
function get_remove_debuff_tooltip_QuarrelShooter_BlockAndShoot(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 파아드파이어 - 마쉬렌데스리트
function get_remove_debuff_tooltip_PiedPiper_Marschierendeslied(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 감정사 - 보험증서
function get_remove_debuff_tooltip_Appraiser_Insurance(level)
    local percent = 100 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 응사 - 행잉 샷
function get_remove_debuff_tooltip_Falconer_HangingShot(level)
    local percent = 50 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end


-- 매트로스 - 파이어 앤드 런
function get_remove_debuff_tooltip_Matross_FireAndRun(level)
    local percent = 2 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 산포 - 은폐 사격
function get_remove_debuff_tooltip_TigerHunter_HideShot(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 아발리스터 - 이스케이프
function get_remove_debuff_tooltip_Arbalester_Escape(level)
    local percent = 3 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

--------------------------------------------------------------------
---------------------------- 위저드  --------------------------------
-------------------------------------------------------------------- 
-- 크리오맨서 - 서브제로 실드
function get_remove_debuff_tooltip_Cryomancer_SubzeroShield(level)
    local percent = 7.5 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 크로노맨서 - 백마스킹
function get_remove_debuff_tooltip_Chronomancer_BackMasking(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 섀도우맨서 - 섀도우 풀
function get_remove_debuff_tooltip_Shadowmancer_ShadowPool(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end


--------------------------------------------------------------------
---------------------------- 클레릭  --------------------------------
-------------------------------------------------------------------- 
-- 드루이드 - 라이칸쓰로피
function get_remove_debuff_tooltip_Druid_Lycanthropy(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 파드너 - 인둘겐티아
function get_remove_debuff_tooltip_Pardoner_Indulgentia(level)
    local percent = 3.3 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 팔라딘 - 레지스트 엘리멘츠
function get_remove_debuff_tooltip_Paladin_ResistElements(level)
    local percent = 6.7 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 채플린 - 비나시오
function get_remove_debuff_tooltip_Chaplain_Binatio(level)
    local percent = 6.7 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 질럿 - 인버너러블
function get_remove_debuff_tooltip_Zealot_Invulnerable(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 크루세이더 - 프로텍션 오브 가디스
function get_remove_debuff_tooltip_Crusader_ProtectionOfGoddess(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end


--------------------------------------------------------------------
---------------------------- 스카우트 -------------------------------
-------------------------------------------------------------------- 
-- 커세어 - 졸리 로저
function get_remove_debuff_tooltip_Corsair_JollyRoger(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 시노비 - 인법 분신술
function get_remove_debuff_tooltip_Shinobi_Bunshin_no_jutsu(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 쏘마터지 - 스웰 브레인
function get_remove_debuff_tooltip_Thaumaturge_SwellBrain(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/around', remove_count, percent)
    return str
end

-- 링커 - 생명줄 - 구현상의 문제로 self로 처리한다.
function get_remove_debuff_tooltip_Linker_UmbilicalCord(level)
    local percent = 20 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 로그 - 버로우
function get_remove_debuff_tooltip_Rogue_Burrow(level)
    local percent = 6.67 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 슈바르츠라이더 - 회피기동
function get_remove_debuff_tooltip_Schwarzereiter_EvasiveAction(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 아르디티 - 리티라르시
function get_remove_debuff_tooltip_Arditi_Ritirarsi(level)
    local percent = 2 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 아르디티 - 레쿠페로
function get_remove_debuff_tooltip_Arditi_Recupero(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

-- 셰리프 - 리뎀션
function get_remove_debuff_tooltip_Sheriff_Redemption(level)
    local percent = 10 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, self/around
    local str = string.format('Debuff/3/%d/%.2f/FRIEND/self', remove_count, percent)
    return str
end

