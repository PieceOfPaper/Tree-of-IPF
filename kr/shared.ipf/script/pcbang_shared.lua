
function CALC_PCBANG_GROWTH_ITEM_LEVEL(item)
    local itemName = TryGetProp(item,"ClassName");
    if itemName == nil then
        return nil;
    end
    
    local lv  = TryGetProp(item, "ItemLv");
    if lv == nil then
        return nil;
    end
    
    if _G["GetValidPCBangRentalItemList"] == nil then
        return nil;
    end
    
    local pcBangRental = GetValidPCBangRentalItemList()
    local isPCBangRental = false;
    for i = 1, #pcBangRental do
        if pcBangRental[i] == itemName then
            isPCBangRental = true;
        end
    end

    if isPCBangRental == false then
        return nil;
    end
    
    if _G["GetItemOwner"] == nil then
        return nil;
    end

    local pc = GetItemOwner(item);
    if pc == nil then
        return nil;
    end
    
    local pcLv = pc.Lv;
    local lvList = {
                        1,
                        15,
                        40,
                        75,
                        120,
                        170,
                        220,
                        270,
                        315,
                        350,
                        380,
                        400
                    };
    
    if pcLv >= lvList[#lvList] then
       lv = lvList[#lvList];
    else
        for i = 2, #lvList do
            local targetLv = lvList[i];
            local targetItemLv = lvList[i - 1];
            
            if pcLv < targetLv then
                lv = targetItemLv;
                break;
            elseif pcLv >= targetLv then
                lv = targetLv
            end
        end
    end
    
    return lv;
end

function IS_ALREADY_RECEIVED_PCBANG_REWARD_DAILY(lastRecvSysTime, curTime)
    local criterion = imcTime.GetSysTime(curTime.wYear, curTime.wMonth, curTime.wDay, PCBANG_CONNECT_REWARD_CRITERION_HOUR);
    if curTime.wHour < PCBANG_CONNECT_REWARD_CRITERION_HOUR then
		criterion = imcTime.AddSec(criterion, -86400);
	end
    if imcTime.IsLaterThan(lastRecvSysTime, criterion) == 1 then
        return 1;
    else
        return 0;
    end
end

function IS_ALREADY_RECEIVED_PCBANG_REWARD_MONTHLY(lastRecvSysTime, curTime)
    local criterion = imcTime.GetSysTime(curTime.wYear, curTime.wMonth, 1, PCBANG_CONNECT_REWARD_CRITERION_HOUR);
    if curTime.wHour < PCBANG_CONNECT_REWARD_CRITERION_HOUR then
        if criterion.wMonth ~= 1 then
            criterion.wMonth = criterion.wMonth - 1;
        else
            criterion.wYear = criterion.wYear - 1;
            criterion.wMonth = 12;
        end
	end
    if imcTime.IsLaterThan(lastRecvSysTime, criterion) == 1 then
        return 1;
    else
        return 0;
    end
end