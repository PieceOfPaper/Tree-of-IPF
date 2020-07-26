function GET_EVENT_FLEX_BOX_CONSUME_CLASSNAME()
    return "EVENT_Flex_Gold_Moneybag";
end

-- 획득 가능 최대 수량
function GET_EVENT_FLEX_BOX_MAX_CONSUME_COUNT()
    return 2000;
end

-- 일일 1시간 접속 보상 획득 가능 최대 수량
function GET_EVENT_FLEX_BOX_DAILY_PLAY_TIME_MAX_CONSUME_COUNT()
    return 36;
end

-- 일일 콘텐츠 클리어 보상 획득 가능 최대 수량
function GET_EVENT_FLEX_BOX_DAILY_CONTENTS_MAX_CONSUME_COUNT()
    return 30;
end

-- flex box 개봉 가능 수량, None 이면 max 제한 없음
function GET_EVENT_FLEX_BOX_MAX_OPEN_COUNT()
    return 200;
end

-- flex box 개봉에 드는 재료 수량
function GET_EVENT_FLEX_BOX_CONSUME_COUNT()
    return 10;
end

-- 누적 보상 
function GET_EVENT_FLEX_BOX_ACCRUE_REWARD_TABLE()
    local table = 
    {
        -- 누적 보상 카운트/아이템 ClassName/제공 수량
        [1] = "50/medeina_emotion06/3",
        [2] = "100/medeina_emotion05/3",
        [3] = "150/medeina_emotion04/3",
        [4] = "200/Gesture_Flex/1",
    }

    return table;
end

function GET_EVENT_FLEX_BOX_CURRENT_ACCRUE_REWARD(accObj, count)
    local table = GET_EVENT_FLEX_BOX_ACCRUE_REWARD_TABLE();
    for k, v in pairs(table) do
        local rewardlist = StringSplit(v, "/");
        if tonumber(rewardlist[1]) == count then
            local ItemclassName = rewardlist[2];
            local Itemcount = rewardlist[3];
            return true, ItemclassName, Itemcount;
        end
    end

    return false;
end

-- 주머니 획득 가능 여부 확인
function ENABLE_ACQURE_EVENT_FLEX_BOX_CONSUME(accObj, count)
    local curCnt = TryGetProp(accObj, "EVENT_FLEX_BOX_ACQUIRE_CONSUME_COUNT")

    if GET_EVENT_FLEX_BOX_MAX_CONSUME_COUNT() <= curCnt then
        return false;
    end

    if GET_EVENT_FLEX_BOX_MAX_CONSUME_COUNT() <= curCnt + count then
        count = GET_EVENT_FLEX_BOX_MAX_CONSUME_COUNT() - curCnt;
    end

    if tonumber(count) <= 0 then
        return false;
    end

    return true, count;
end

function GET_EVENT_FLEX_BOX_TITLE()
    return ClMsg("EVENT_2007_FLEX_BOX_TITLE");
end

function GET_EVENT_FLEX_BOX_DESC()
    return ClMsg("EVENT_2007_FLEX_BOX_DESC");
end
