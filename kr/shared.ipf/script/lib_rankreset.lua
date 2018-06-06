-- lib_rankreset.lua

function IS_RANKRESET_ITEM(itemClassName)
    if  itemClassName == 'Premium_RankReset' or itemClassName == '1706Event_RankReset' or itemClassName == 'Premium_RankReset_14d' or itemClassName == 'Premium_RankReset_60d' or itemClassName == 'Premium_RankReset_1d' then
       return 1; 
    end
    return 0;
end

function IS_RANKROLLBACK_ITEM(itemClassName)
    if  itemClassName == 'Premium_RankRollback' then
       return 1; 
    end
    return 0;
end