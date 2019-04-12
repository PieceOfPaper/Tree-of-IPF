---- lib_reinforce_131014.lua
function IS_MORU_FREE_PRICE(moruItem)
    if moruItem == nil then
        return false;
    end

    if moruItem.ClassName == "Moru_Silver" 
        or moruItem.ClassName == "Moru_Silver_test" 
        or moruItem.ClassName == "Moru_Silver_NoDay" 
        or moruItem.ClassName == "Moru_Silver_TA" 
        or moruItem.ClassName == "Moru_Silver_TA2" 
        or moruItem.ClassName == "Moru_Silver_Event_1704" 
        or moruItem.ClassName == 'Moru_Silver_TA_Recycle' 
        or moruItem.ClassName == 'Moru_Silver_TA_V2' 
        or moruItem.ClassName == "Moru_Gold_TA"        
        or moruItem.ClassName == "Moru_Gold_TA_NR"
        or moruItem.ClassName == "Moru_Gold_EVENT_1710_NEWCHARACTER"
        or moruItem.ClassName == "Moru_Event160609" 
        or moruItem.ClassName == "Moru_Event160929_14d" 
        or moruItem.ClassName == "Moru_Potential" 
        or moruItem.ClassName == "Moru_Potential14d"
        or moruItem.ClassName == "Moru_Silver_DLC"
        or moruItem.StringArg == 'SILVER' then
        return true;
    end

    return false;
end