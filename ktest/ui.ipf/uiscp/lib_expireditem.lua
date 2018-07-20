----- lib_expireditem.lua

-- addon

function GET_TWO_DIGIT_STR(num)
    local digit = 2;
    if digit < 2 then
        return tostring(num);
    end
    if num >= 10*(digit-1) then
        return tostring(num);
    end

    return "0" .. tostring(num);
end

function GET_EXPIRED_ITEM_LIST()
    local pc = GetMyPCObject();
    local list = GetInvItemList(pc);
    local out = {};
    for i=1, #list do
        local item = list[i];
        if true == IS_EXPIRED_ITEM_BY_ITEMLIFETIMEOVER(item) then
            out[#out+1]=item;
        end
    end
    return out;
end

function IS_EXPIRED_ITEM_BY_ITEMLIFETIMEOVER(itemObj)
    local lifeTimeOver = TryGetProp(itemObj, "ItemLifeTimeOver");
    if lifeTimeOver == 1 then
        return true;
    else
        return false;
    end
end

function IS_SCHEDULED_TO_EXPIRED_ITEM_BY_SYSTIME(itemObj, sysTime)
    local lifeTime = TryGetProp(itemObj, "ItemLifeTime");
    if lifeTime == nil or lifeTime == "None" then
        return false;
    end
    local expirationSysTime = imcTime.GetSysTimeByStr(lifeTime);
    
    if 1 == imcTime.IsLaterThan(sysTime, expirationSysTime) then
        return true;
    else
        return false;
    end
end

function GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(addSec)
    local nearFutureSysTime = geTime.GetServerSystemTime();
    nearFutureSysTime = imcTime.AddSec(nearFutureSysTime, addSec);
    local pc = GetMyPCObject();
    local list = GetInvItemList(pc);
    local out = {};
    for i=1, #list do
        local item = list[i];
        if true == IS_SCHEDULED_TO_EXPIRED_ITEM_BY_SYSTIME(item, nearFutureSysTime) then
            out[#out+1]=item;
        end
    end
    return out;
end

function GET_ITEM_REMAIN_LIFETIME_BY_SEC(itemObj)
    local lifeTime = TryGetProp(itemObj, "ItemLifeTime");
    local lifeTimeOver = TryGetProp(itemObj, "ItemLifeTimeOver");

    if lifeTimeOver == 1 then
        return "Expired"
    end
    if lifeTime == nil or lifeTime == "None" then
        return "None"
    end
    
    local expirationSysTime = imcTime.GetSysTimeByStr(lifeTime);
    local nowSysTime = geTime.GetServerSystemTime();
    local diffSec = imcTime.GetDifSec(expirationSysTime, nowSysTime);
    return diffSec;
end

function COMPARE_BY_LIFETIME(itemObj1, itemObj2)
    local lifeTimeSec1 = GET_ITEM_REMAIN_LIFETIME_BY_SEC(itemObj1)
    local lifeTimeSec2 = GET_ITEM_REMAIN_LIFETIME_BY_SEC(itemObj2)
    
    -- 이미 만료되었거나 값이 없으면 뒤로 보냄.
    if lifeTimeSec1 == "None" or lifeTimeSec1 == "Expired" then
        return false;
    end
    if lifeTimeSec2 == "None" or lifeTimeSec2 == "Expired" then
        return true;
    end
    
    return lifeTimeSec1 < lifeTimeSec2;
end

function SORT_ITEM_LIST_BY_LIFETIME(list)
    table.sort(list, COMPARE_BY_LIFETIME);
    return list;
end

function ADD_EXPIRED_ITEM(groupbox, item, i, ypos)
    local ctrlset = groupbox:CreateOrGetControlSet('expireditem_ctrlset', 'expireditem_ctrlset' .. i , 0, ypos);
    tolua.cast(ctrlset, "ui::CGroupBox");
    local name = GET_CHILD_RECURSIVELY(ctrlset, 'name', 'ui::CRichText')
    local expirationTime = GET_CHILD_RECURSIVELY(ctrlset, 'expirationTime', 'ui::CRichText')
    local remainingTime = GET_CHILD_RECURSIVELY(ctrlset, 'remainingTime', 'ui::CRichText')
    local item_pic = GET_CHILD_RECURSIVELY(ctrlset, 'item_pic', 'ui::CPicture')
    name:SetTextByKey('itemname', item.Name);

    if TryGetProp(item, "ItemLifeTime") ~= nil and TryGetProp(item, "ItemLifeTime") ~= "None" then
        local expirationSysTime = imcTime.GetSysTimeByStr(item.ItemLifeTime);
        expirationTime:SetTextByKey('year', expirationSysTime.wYear);
        expirationTime:SetTextByKey('month', GET_TWO_DIGIT_STR(expirationSysTime.wMonth));
        expirationTime:SetTextByKey('day', GET_TWO_DIGIT_STR(expirationSysTime.wDay));

        if TryGetProp(item, "ItemLifeTimeOver") == 1 then
            remainingTime:SetText(ClMsg("TimeExpired"))
        else
            local nowSysTime = geTime.GetServerSystemTime();
            local diffSec = imcTime.GetDifSec(expirationSysTime, nowSysTime);
            local days = math.floor(diffSec / 86400);
            local hours = math.floor((diffSec % 86400) / 3600)
            local mins = math.floor(((diffSec % 86400) % 3600) / 60)
            local sec = ((diffSec % 86400) % 3600) % 60

            local difSecMsg = tostring(days) .. '.' .. tostring(hours) .. '.' .. tostring(mins);
            if days > 0 then
                difSecMsg = ScpArgMsg("{Day}Day{Hour}Hour{Min}Min", "Day", days, "Hour", hours, "Min", mins);
            elseif hours > 0 then
                difSecMsg = ScpArgMsg("{Hour}Hour{Min}Min{Sec}Sec", "Hour", hours, "Min", mins, "Sec", sec);
            elseif mins > 0 then
                difSecMsg = ScpArgMsg("{Min}Min{Sec}Sec", "Min", mins, "Sec", sec);
            else
                difSecMsg = ScpArgMsg("{Sec}Sec", "Sec", sec);
            end
            
            remainingTime:SetText(difSecMsg)
        end
    end

    item_pic:SetImage(item.Icon);

    ypos = ypos + ctrlset:GetHeight();
    return ypos;
end

-- slot

-- ICON_SET_ITEM_COOLDOWN ī��
function ICON_SET_ITEM_REMAIN_LIFETIME(icon)	
    if icon == nil then
		return;
	end
	
	local iconInfo = icon:GetInfo();
	local invItem = session.GetInvItemByGuid(iconInfo:GetIESID());
	if invItem == nil then
        return;
    end

	local obj = GetIES(invItem:GetObject());
    if obj == nil then
        return;
    end
    
    local remainTimeSec = GET_ITEM_REMAIN_LIFETIME_BY_SEC(obj);
    if remainTimeSec ~= "None" then
	    icon:SetOnLifeTimeUpdateScp('ICON_UPDATE_ITEM_REMAIN_LIFETIME');
    end
end

function ICON_UPDATE_ITEM_REMAIN_LIFETIME(icon)
	if icon == nil then
		return 0;
	end
	
	local iconInfo = icon:GetInfo();
	local invItem = session.GetInvItemByGuid(iconInfo:GetIESID());
	if invItem == nil then
        return 0;
    end

	local obj = GetIES(invItem:GetObject());
    if obj == nil then
        return 0;
    end
    
    local remainTimeSec = GET_ITEM_REMAIN_LIFETIME_BY_SEC(obj);
    if remainTimeSec == "None" or remainTimeSec == "Expired" then
        return 0;
    else
        return remainTimeSec;
    end
end

function GET_ITEM_LIFE_TIME(itemObj)
    local lifeTimeStr = TryGetProp(itemObj, "ItemLifeTime");
    if lifeTimeStr == nil then
        return;
    end
    if lifeTimeStr == "None" then
        return;
    end
    
    return lifeTimeStr;
end

function GET_LATEST_ITEM_LIFE_TIME_OVERED()
    local list = GET_EXPIRED_ITEM_LIST();
    if #list <= 0 then
        return;
    end
    local latestSysTimeStr = GET_ITEM_LIFE_TIME(list[1]);
    if latestSysTimeStr == nil then
        return;
    end
    
    local latestSysTime = imcTime.GetSysTimeByStr(latestSysTimeStr);

    for i=1, #list do
        local item = list[i];
        local lifeSysTimeStr = GET_ITEM_LIFE_TIME(item)
        if lifeSysTimeStr == nil then
            return;
        end
        local lifeSysTime =  imcTime.GetSysTimeByStr(lifeSysTimeStr);
        if 1 == imcTime.IsLaterThan(lifeSysTime, latestSysTime) then
            latestSysTime = lifeSysTime;
        end
    end

    latestSysTimeStr = imcTime.GetStringSysTime(latestSysTime);
    return latestSysTimeStr;
end
