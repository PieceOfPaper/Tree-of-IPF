-- item_ark_event_func.lua

-- 아이템 아크 이벤트 관련 함수
-- 아크 아이템 경험치 증가시에 추가 배수를 적용할 수치
function get_event_exp_up_multiple(pc, item)    

    return 1 -- 기본은 1로 리턴한다.
end

-- 아크 아이템 레벨업에 필요한 재료 개수를 줄여준다.
function get_event_lv_up_decrease_ratio(pc, item)
    -- return 0.5 절반으로 줄이고 싶으면 0.5로 한다.

    return 1 -- 기본은 1로 리턴한다.
end
