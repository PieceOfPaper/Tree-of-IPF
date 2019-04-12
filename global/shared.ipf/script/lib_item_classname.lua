function GET_INDUN_MULTIPLE_ITEM_LIST()
    return {'Premium_dungeoncount_01', 
            'Premium_dungeoncount_Event',
            'Adventure_dungeoncount_01'};
end

function IS_INDUN_MULTIPLE_ITEM(itemClassName)
    local list = GET_INDUN_MULTIPLE_ITEM_LIST();
    for i = 1, #list do
        if list[i] == itemClassName then
            return 1;
        end
    end
    return 0;
end