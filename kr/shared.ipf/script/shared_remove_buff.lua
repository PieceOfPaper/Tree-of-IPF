-- shared_remove_buff.lua
-- 버프 삭제 관련


-- 하플라이트 - 스태빙
function get_remove_buff_tooltip_Hoplite_Stabbing(level)
    local percent = 0.23 * tonumber(level)
    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 바바리안 - 워크라이
function get_remove_buff_tooltip_Barbarian_Warcry(level)
    local percent = 3.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 하이랜더 - 크라운
function get_remove_buff_tooltip_Highlander_Crown(level)
    local percent = 3.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 펠타스타 - 엄보 블로
function get_remove_buff_tooltip_Peltasta_UmboBlow(level)
    local percent = 0.8 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 도펠죌트너 - 존하우
function get_remove_buff_tooltip_Doppelsoeldner_Zornhau(level)
    local percent = 5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 로델레로 - 실드 배시
function get_remove_buff_tooltip_Rodelero_ShieldBash(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 무르밀로 - 실드 트레인
function get_remove_buff_tooltip_Murmillo_ShieldTrain(level)
    local percent = 2.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 펜서 - 발레스트라 팡트
function get_remove_buff_tooltip_Fencer_BalestraFente(level)
    local percent = 2.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 드라군 - 드래곤 피어
function get_remove_buff_tooltip_Dragoon_DragonFear(level)
    local percent = 30 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 랜서 - 기간테 마르샤
function get_remove_buff_tooltip_Rancer_GiganteMarcha(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 낙무아이 - 카오로이
function get_remove_buff_tooltip_NakMuay_KhaoLoi(level)
    local percent = 1.7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 레티아리이 - 투망 던지기
function get_remove_buff_tooltip_Retiarii_ThrowingFishingNet(level)
    local percent = 15 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 하카펠 - 카발리 차지
function get_remove_buff_tooltip_Hackapell_CavalryCharge(level)
    local percent = 1.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 하카펠 - 헬름 쵸퍼
function get_remove_buff_tooltip_Hackapell_HelmChopper(level)
    local percent = 0.7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 매화검수 - 매화 베기
function get_remove_buff_tooltip_BlossomBlader_BlossomSlash(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

----------------------------------------------------------------------------------
--------------------------------- 위저드 -----------------------------------------
----------------------------------------------------------------------------------
-- 사이코키노 - 그라비티 폴
function get_remove_buff_tooltip_Psychokino_GravityPole(level)
    local percent = 2 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 사이코키노 - 헤비 그라비티
function get_remove_buff_tooltip_Psychokino_HeavyGravity(level)
    local percent = 0.8 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 알케미스트 - 알케미스틱 미사일
function get_remove_buff_tooltip_Alchemist_AlchemisticMissile(level)
    local percent = 1.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 크로노맨서 - 타임 포워드
function get_remove_buff_tooltip_Chronomancer_TimeForward(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)
    return str
end

-- 룬캐스터 - 파괴의 룬
function get_remove_buff_tooltip_RuneCaster_Hagalaz(level)
    local percent = 5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

----------------------------------------------------------------------------------
--------------------------------- 아처 -----------------------------------------
----------------------------------------------------------------------------------

-- 헌터 - 코싱
function get_remove_buff_tooltip_Hunter_Coursing(level)
    local percent = 0.72 * tonumber(level)
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 플레쳐 - 보드킨 포인트
function get_remove_buff_tooltip_Fletcher_BodkinPoint(level)
    local percent = 2.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 파이드 파이퍼 - 비겐리트
function get_remove_buff_tooltip_PiedPiper_Wiegenlied(level)
    local percent = 3.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 감정사 - 평가절하
function get_remove_buff_tooltip_Appraiser_Devaluation(level)
    local percent = 5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 캐노니어 - 스위핑 캐논
function get_remove_buff_tooltip_Cannoneer_SweepingCannon(level)
    local percent = 7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 매트로스 - 캐니스터 샷
function get_remove_buff_tooltip_Matross_CanisterShot(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

----------------------------------------------------------------------------------
--------------------------------- 클레릭 -----------------------------------------
----------------------------------------------------------------------------------

-- 크리비 - 디바인 스티그마
function get_remove_buff_tooltip_Kriwi_DivineStigma(level)
    local percent = 5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 사두 - 유체 폭발
function get_remove_buff_tooltip_Sadhu_AstralBodyExplosion(level)
    local percent = 1.7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 딥디르비 - 세계수 조각
function get_remove_buff_tooltip_Dievdirbys_CarveAustrasKoks(level)
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 몽크 - 촌경
function get_remove_buff_tooltip_Monk_1InchPunch(level)
    local percent = 0.9 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 몽크 - 양광수
function get_remove_buff_tooltip_Monk_EnergyBlast(level)
    local percent = 3.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 파드너 - 데카토스
function get_remove_buff_tooltip_Pardoner_Dekatos(level)
    local percent = 1.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 팔라딘 - 데몰리션
function get_remove_buff_tooltip_Paladin_Demolition(level)    
    local percent = 0.8 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 채플린 - 비지블 탤런트
function get_remove_buff_tooltip_Chaplain_VisibleTalent(level)    
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 카발리스트 - 게부라
function get_remove_buff_tooltip_Kabbalist_Gevura(level)    
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 인퀴지터 - 마도 심판
function get_remove_buff_tooltip_Inquisitor_MalleusMaleficarum(level)    
    local percent = 3.3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 무녀 - 하마야
function get_remove_buff_tooltip_Miko_Hamaya(level)    
    local percent = 2.2 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 질럿 - 엠퍼시스 트러스트
function get_remove_buff_tooltip_Zealot_EmphasisTrust(level)    
    local percent = 7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 엑소시스트 - 아쿠아 베네틱타
function get_remove_buff_tooltip_Exorcist_AquaBenedicta(level)    
    local percent = 1.1 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 크루세이더 - 프로텍션 오브 가디스
function get_remove_buff_tooltip_Crusader_ProtectionOfGoddess(level)    
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 크루세이더 - 리탤리에이션
function get_remove_buff_tooltip_Crusader_Retaliation(level)    
    local percent = 2.5 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

----------------------------------------------------------------------------------
--------------------------------- 스카우트 -----------------------------------------
----------------------------------------------------------------------------------

-- 아웃로 - 난동 부리기
function get_remove_buff_tooltip_OutLaw_Rampage(level)    
    local percent = 3 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 스콰이어 - 포박
function get_remove_buff_tooltip_Squire_Arrest(level)    
    local percent = 6.7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 시노비 - 인법 미진술
function get_remove_buff_tooltip_Shinobi_Mijin_no_jutsu(level)    
    local percent = 10 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 2

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 링커 - 조인트 페널티
function get_remove_buff_tooltip_Linker_JointPenalty(level)    
    local percent = 1.6 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 로그 - 최루
function get_remove_buff_tooltip_Rogue_Lachrymator(level)    
    local percent = 6.7 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end

-- 랑다 - 케레티한
function get_remove_buff_tooltip_Rangda_Keletihan(level)    
    local percent = 1.6 * tonumber(level)    
    if percent > 100 then
        percent = 100
    end

    local remove_count = 1

    -- buff_type, lv, count, percent, relation, boss_check
    local str = string.format('Buff/3/%d/%.2f/ENEMY/0', remove_count, percent)    
    return str
end