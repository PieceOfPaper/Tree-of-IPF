-- lib_rankreset.lua

function IS_RANKRESET_ITEM(itemClassName)
    if  itemClassName == 'Premium_RankReset' or
        itemClassName == '1706Event_RankReset' then
       return 1; 
    end
    return 0;
end