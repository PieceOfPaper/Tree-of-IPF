-- shared_decrease_heal.lua
-- 힐량 감소 디버프

-- 하플라이트 - 피어스
function get_decrease_heal_debuff_tooltip_Hoplite_Pierce(lv)
    local arg2 = 2.6 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 감정사 - 약점공격
function get_decrease_heal_debuff_tooltip_Appraiser_Blindside(lv)
    local arg2 = 2 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 아발리스트 - 가이디드 샷
function get_decrease_heal_debuff_tooltip_Arbalester_GuidedShot(lv)
    local arg2 = 1.6 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 아르디티 - 인바시오네
function get_decrease_heal_debuff_tooltip_Arditi_Invasione(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 바바리안 - 임바우얼
function get_decrease_heal_debuff_tooltip_Barbarian_Embowel(lv)
    local arg2 = 3.3 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 매화검수 - 일섬
function get_decrease_heal_debuff_tooltip_BlossomBlader_Flash(lv)
    local arg2 = 5 * tonumber(lv) * 1000
    local bfTime = 5000

    if IsServerSection() == 0 then
        local abil  = GetAbilityIESObject(GetMyPCObject(), "Blossomblader19");
        if abil ~= nil and TryGetProp(abil, 'ActiveState' , 0) == 1 then
            arg2 = arg2 / 2
        end   
    end

    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 불릿마커 - 파쇄탄
function get_decrease_heal_debuff_tooltip_Bulletmarker_SmashBullet(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 7000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 커세어 - 임페일 대거
function get_decrease_heal_debuff_tooltip_Corsair_ImpaleDagger(lv)
    local arg2 = 6 * tonumber(lv) * 1000
    local bfTime = 4000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 도펠죌트너 - 퍼니시
function get_decrease_heal_debuff_tooltip_Doppelsoeldner_Punish(lv)
    local arg2 = 3.3 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 드라군 - 드래곤 폴
function get_decrease_heal_debuff_tooltip_Dragoon_DragonFall(lv)
    local arg2 = 10 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 드라군 - 게이 불그
function get_decrease_heal_debuff_tooltip_Dragoon_Gae_Bulg(lv)
    local arg2 = 2 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 드라군 - 드래곤 투스
function get_decrease_heal_debuff_tooltip_Dragoon_Dragontooth(lv)
    local arg2 = 3.3 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 페더풋 - 블러드 커스
function get_decrease_heal_debuff_tooltip_Featherfoot_BloodCurse(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 7000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 페더풋 - 은가둔디
function get_decrease_heal_debuff_tooltip_Featherfoot_Ngadhundi(lv)
    local arg2 = 2 * tonumber(lv) * 1000
    local bfTime = 4000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 펜서 - 플레쉬
function get_decrease_heal_debuff_tooltip_Fencer_Fleche(lv)
    local arg2 = 8 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 플레처 - 브로드 헤드
function get_decrease_heal_debuff_tooltip_Fletcher_BroadHead(lv)
    local arg2 = 1.3 * tonumber(lv) * 1000
    local bfTime = 4000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 하카펠 - 스톰 볼트
function get_decrease_heal_debuff_tooltip_Hackapell_StormBolt(lv)
    local arg2 = 2.6 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 헌터 - 리트리브
function get_decrease_heal_debuff_tooltip_Hunter_Retrieve(lv)
    local arg2 = 1.2 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 헌터 - 코싱
function get_decrease_heal_debuff_tooltip_Hunter_Coursing(lv)
    local arg2 = 1.56 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 마타도르 - 파소 도블레
function get_decrease_heal_debuff_tooltip_Matador_PasoDoble(lv)
    local arg2 = 4 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 몽크 - 철사장
function get_decrease_heal_debuff_tooltip_Monk_PalmStrike(lv)
    local arg2 = 2 * tonumber(lv) * 1000
    local bfTime = 3000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 드루이드 - 코르타스마타
function get_decrease_heal_debuff_tooltip_Druid_Chortasmata(lv)    
    local arg2 = 1.5 * tonumber(lv) * 1000
    local bfTime = 7000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 플레이그닥터 - 흑사병 증기
function get_decrease_heal_debuff_tooltip_PlagueDoctor_PlagueVapours(lv)    
    local arg2 = 1.6 * tonumber(lv) * 1000
    local bfTime = 7000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 머스킷 - 헤드샷
function get_decrease_heal_debuff_tooltip_Musketeer_HeadShot(lv)
    local arg2 = 3.3 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 아웃로 - 모래 뿌리기
function get_decrease_heal_debuff_tooltip_OutLaw_SprinkleSands(lv)
    local arg2 = 2.3 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 랜서 - 자우스트
function get_decrease_heal_debuff_tooltip_Rancer_Joust(lv)
    local arg2 = 2.6 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 레인저 - 스파이럴 애로우
function get_decrease_heal_debuff_tooltip_Ranger_SpiralArrow(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 레티아리이 - 블란디르 카데나
function get_decrease_heal_debuff_tooltip_Retiarii_BlandirCadena(lv)
    local arg2 = 8 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 로그 - 나이프 스로잉
function get_decrease_heal_debuff_tooltip_Rogue_KnifeThrowing(lv)
    local arg2 = 5 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 세이지 - 홀 오브 다크니스
function get_decrease_heal_debuff_tooltip_Sage_HoleOfDarkness(lv)
    local arg2 = 10 * tonumber(lv) * 1000
    local bfTime = 15000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 새퍼 - 푼지 스테이크
function get_decrease_heal_debuff_tooltip_Sapper_PunjiStake(lv)
    local arg2 = 4.6 * tonumber(lv) * 1000
    local bfTime = 15000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 시노비 - 쿠나이
function get_decrease_heal_debuff_tooltip_Shinobi_Kunai(lv)
    local arg2 = 1.3 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 테라맨서 - 임플로전
function get_decrease_heal_debuff_tooltip_TerraMancer_Implosion(lv)
    local arg2 = 2 * tonumber(lv) * 1000
    local bfTime = 4000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 산포 - 관통 사격
function get_decrease_heal_debuff_tooltip_TigerHunter_PierceShot(lv)
    local arg2 = 1.6 * tonumber(lv) * 1000
    local bfTime = 5000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 워록 - 마스테마
function get_decrease_heal_debuff_tooltip_Warlock_Mastema(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 무고사 - 잠독백세
function get_decrease_heal_debuff_tooltip_Wugushi_LatentVenom(lv)
    local arg2 = 4.6 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 무고사 - 독무만상
function get_decrease_heal_debuff_tooltip_Wugushi_WideMiasma(lv)
    local arg2 = 3 * tonumber(lv) * 1000
    local bfTime = 20000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 엘리멘탈리스트 - 스톤 커스
function get_decrease_heal_debuff_tooltip_Elementalist_StoneCurse(lv)
    local arg2 = 5 * tonumber(lv) * 1000
    local bfTime = 15000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end

-- 소서러 - 사역마 소환
function get_decrease_heal_debuff_tooltip_Sorcerer_SummonFamiliar(lv)
    local arg2 = 1.3 * tonumber(lv) * 1000
    local bfTime = 10000
    local msg = string.format('DecreaseHeal_Debuff/%.2f/%.2f/%d/1/100/-1/0/0', arg2, arg2, bfTime)
    return msg
end


