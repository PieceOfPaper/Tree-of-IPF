random_item = { }
date_time = { }
account_warehouse = {} 

random_item.is_sealed_random_item = function(itemobj)
    if IS_EQUIP(itemobj) == false then
        return false;
    end

    local isRandomOption = TryGetProp(itemobj, 'NeedRandomOption')
    local isAppraisal = TryGetProp(itemobj, 'NeedAppraisal')

    if isRandomOption == 1 then
        return true;
    elseif isAppraisal == 1 then
        return true;
    end
    return false;
end

random_item.set_sealed_random_item_icon_color = function(icon)
    if icon ~= nil then
        icon:SetColorTone("FFFF0000")
    end
end

-- str = yyyy-mm-dd hh:mm:ss
date_time.get_date_time = function(str)
    if str == nil or str == 'None' then
        return nil
    end

    local token = StringSplit(str, ' ')
    if #token ~= 2 then
        return nil
    end

    local date = token[1]
    local time = token[2]

    local date_token = StringSplit(date, '-')
    local time_token = StringSplit(time, ':')
    if #date_token ~= 3 or #time_token ~= 3 then
        return nil
    end

    local year = tonumber(date_token[1])
    local month = tonumber(date_token[2])
    local day = tonumber(date_token[3])

    local hour = tonumber(time_token[1])
    local minute = tonumber(time_token[2])
    local second = tonumber(time_token[3])

    return year, month, day, hour, minute, second
end

-- 문자열 시간으로부터 루아시간을 가져온다.
date_time.get_lua_datetime_from_str = function(str)
    return date_time.get_lua_datetime(date_time.get_date_time(str))
end

date_time.get_lua_datetime = function(_year, _month, _day, _hour, _min, _sec)
    if _year == nil or _month == nil or _day == nil or _hour == nil or _min == nil or _sec == nil then
        return nil
    end
    return os.time { year = _year, month = _month, day = _day, hour = _hour, min = _min, sec = _sec }
end

-- 루아 시간으로 현재시간을 가져온다.
date_time.get_lua_now_datetime = function()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local sec = now_time['sec']
    local now = date_time.get_lua_datetime(year, month, day, hour, min, sec)
    return now
end

-- 루아 타임으로 현재시간을 가져온다.
date_time.get_lua_now_datetime_str = function()
    local ret = date_time.lua_datetime_to_str(date_time.get_lua_now_datetime())
    return ret
end

-- start_datetime, end_datetime = yyyy-mm-dd hh:mm:ss (string)
-- 현재 시간이 start, end 사이에 존재하는가
date_time.is_between_time = function(start_datetime, end_datetime)
    if start_datetime == nil or end_datetime == nil or start_datetime == 'None' or end_datetime == 'None' then
        return false
    end

    local lua_start_datetime = date_time.get_lua_datetime_from_str(start_datetime)
    local lua_end_datetime = date_time.get_lua_datetime_from_str(end_datetime)

    if lua_start_datetime == nil or lua_end_datetime == nil then
        return false
    end

    local now = date_time.get_lua_now_datetime()
    if lua_start_datetime <= now and now <= lua_end_datetime then
        return true
    else
        return false
    end
end

-- 루아 시간을 yyyy-mm-dd hh:mm:ss 로 변환한다
date_time.lua_datetime_to_str = function(lua_datetime)
    local ret_time = os.date('*t', lua_datetime)
    local year = ret_time['year']
    local month = ret_time['month']
    local day = ret_time['day']
    local hour = ret_time['hour']
    local min = ret_time['min']
    local sec = ret_time['sec']

    local ret_str = string.format('%04d-%02d-%02d %02d:%02d:%02d', year, month, day, hour, min, sec)
    return ret_str
end

-- pivot = yyyy-mm-dd hh:mm:ss (string)
-- pivot 에 sec를 더한 string을 반환
date_time.add_time = function(pivot, sec)
    local ret = date_time.get_lua_datetime_from_str(pivot)
    ret = ret + tonumber(sec)

    local ret_time = os.date('*t', ret)
    local year = ret_time['year']
    local month = ret_time['month']
    local day = ret_time['day']
    local hour = ret_time['hour']
    local min = ret_time['min']
    local sec = ret_time['sec']

    local ret_str = string.format('%04d-%02d-%02d %02d:%02d:%02d', year, month, day, hour, min, sec)
    return ret_str
end

-- 추가 팀창고 개수
account_warehouse.get_max_tab = function()
    return 4
end

account_warehouse.get_max_slot_per_tab = function()
    return 70
end

function is_balance_patch_care_period()    
    local eventCls = GetClass("time_check_for_balance_patch", 'time_check_for_balance_patch')
    if eventCls ~= nil and eventCls.Activate == 'YES' then
        local curTime = GetDBTime()
        local cur = date_time.get_lua_datetime(curTime.wYear, curTime.wMonth, curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wDay)
        local start = date_time.get_lua_datetime(date_time.get_date_time(eventCls.Start))
        local endd = date_time.get_lua_datetime(date_time.get_date_time(eventCls.End))

        if cur == nil or start == nil or endd == nil then
            return false
        end

        if start <= cur and cur < endd then
            return true
        else
            return false
        end
    else
        return false
    end
end

function get_balance_patch_care_ratio()
    local eventCls = GetClass("time_check_for_balance_patch", 'time_check_for_balance_patch')
    if eventCls ~= nil and eventCls.Activate == 'YES' then
        local ratio = eventCls.Ratio
        if ratio == nil then
            return 1
        else
            return tonumber(ratio)
        end
    else
        return 1
    end
end


function SCR_QUEST_LINK_FIRST(pc, questname)
    return SCR_QUEST_LINK_FIRST_SUB(pc, { questname }, { }, { })
end

function SCR_QUEST_LINK_FIRST_SUB(pc, t, ext, statet)
    if #t == 0 then
        return t, ext, statet
    end

    local list1 = { }
    local removeList1 = { }
    if #t > 0 then
        for i = 1, #t do
            if table.find(ext, t[i]) == 0 then
                local flag = 0
                for i2 = 1, 4 do
                    local questIES = GetClass('QuestProgressCheck', t[i])
                    local before = TryGetProp(questIES, 'QuestName' .. i2, 'None')
                    if before ~= 'None' then
                        local beforeCount = TryGetProp(questIES, 'QuestCount' .. i2, 0)
                        local state
                        if IsServerSection(pc) == 1 then
                            state = SCR_QUEST_CHECK(pc, before)
                        else
                            state = SCR_QUEST_CHECK_C(pc, before)
                        end
                        if beforeCount == 300 then
                            if state ~= 'COMPLETE' then
                                if table.find(list1, before) == 0 then
                                    list1[#list1 + 1] = before
                                    statet[#statet + 1] = { before, beforeCount, '>=' }
                                end
                                flag = 1
                            end
                        elseif beforeCount == 200 then
                            local terms = TryGetProp(questIES, 'QuestTerms' .. i2, '==')
                            if terms == '>=' then
                                if state ~= 'COMPLETE' and state ~= 'SUCCESS' then
                                    if table.find(list1, before) == 0 then
                                        list1[#list1 + 1] = before
                                        statet[#statet + 1] = { before, beforeCount, terms }
                                    end
                                    flag = 1
                                end
                            else
                                if state ~= 'SUCCESS' then
                                    if table.find(list1, before) == 0 then
                                        list1[#list1 + 1] = before
                                        statet[#statet + 1] = { before, beforeCount, terms }
                                    end
                                    flag = 1
                                end
                            end
                        elseif beforeCount == 1 then
                            local terms = TryGetProp(questIES, 'QuestTerms' .. i2, '==')
                            if terms == '>=' then
                                if state ~= 'COMPLETE' and state ~= 'SUCCESS' and state ~= 'PROGRESS' then
                                    if table.find(list1, before) == 0 then
                                        list1[#list1 + 1] = before
                                        statet[#statet + 1] = { before, beforeCount, terms }
                                    end
                                    flag = 1
                                end
                            else
                                if state ~= 'PROGRESS' then
                                    if table.find(list1, before) == 0 then
                                        list1[#list1 + 1] = before
                                        statet[#statet + 1] = { before, beforeCount, terms }
                                    end
                                    flag = 1
                                end
                            end
                            --                        elseif beforeCount == 0 then
                            --                            local terms = TryGetProp(questIES,'QuestTerms'..i2, '==')
                            --                            if terms == '>=' then
                            --                                if state ~= 'COMPLETE' and state ~= 'SUCCESS' and state ~= 'PROGRESS' and state ~= 'POSSIBLE' then
                            --                                    if table.find(list1, before) == 0 then
                            --                                        list1[#list1 + 1] = before
                            --                                    end
                            --                                    flag = 1
                            --                                end
                            --                            else
                            --                                if state ~= 'POSSIBLE' then
                            --                                    if table.find(list1, before) == 0 then
                            --                                        list1[#list1 + 1] = before
                            --                                    end
                            --                                    flag = 1
                            --                                end
                            --                            end
                        end
                    end
                end
                if flag == 1 then
                    if table.find(removeList1, t[i]) == 0 then
                        removeList1[#removeList1 + 1] = t[i]
                    end
                else
                    if table.find(ext, t[i]) == 0 then
                        ext[#ext + 1] = t[i]
                    end
                end
            end
        end
    end
    if #ext > 0 then
        for i = 1, #ext do
            local index = table.find(list1, ext[i])
            if index > 0 then
                table.remove(list1, index)
            end
        end
    end
    if #removeList1 > 0 then
        for i = 1, #removeList1 do
            local index = table.find(list1, removeList1[i])
            if index > 0 then
                table.remove(list1, index)
            end
        end
    end

    local ret1, ret2, ret3 = SCR_QUEST_LINK_FIRST_SUB(pc, list1, ext, statet)
    if #ret1 == 0 then
        return ret1, ret2, ret3
    end
end

function JOB_CHAPLAIN_PRE_CHECK(pc)
    local jobCircle = 0
    if IsServerSection(pc) == 1 then
        jobCircle = GetJobGradeByName(pc, 'Char4_2');
    else
        local jobIES = GetClass('Job', 'Char4_2')
        jobCircle = session.GetJobGrade(jobIES.ClassID);
    end

    if jobCircle >= 3 then
        return 'YES'
    end

    return 'NO'
end

function IS_KOR_JOB_EXEMPTION_PERIOD(jobClassName)
    local jobList = { 'Char1_19', 'Char2_19', 'Char5_12', 'Char4_19' }
    if GetServerNation() == 'KOR' then
        if table.find(jobList, jobClassName) > 0 then
            return 'YES'
        end
    end
    return 'NO'
end

function IS_KOR_TEST_SERVER()
    if GetServerNation() == 'KOR' and GetServerGroupID() == 9001 then
        return true
    end
    return false
end
function IS_SEASON_SERVER(pc)

    if pc ~= nil then
        if IsServerObj(pc) == 1 then
            if IsIndun(pc) == 1 then
                local etc = GetETCObject(pc)
                local serverGroupID = TryGetProp(etc, "MyWorldID");

                -- Test Server
                -- if GetServerNation() == "KOR" and serverGroupID == 1550 then
                --  return "NO";
                -- else
                --  return "YES";
                -- end

                -- Live Server
                if GetServerNation() == "KOR" and(serverGroupID == 3001 or serverGroupID == 8801) then
                    return "YES";
                else
                    return "NO";
                end
            else
                -- Test Server
                -- if (GetServerNation() == "KOR" and GetServerGroupID() == 1550) then
                --  return "YES"
                -- else
                --  return "NO"
                -- end

                -- Live Server
                if (GetServerNation() == "KOR" and(GetServerGroupID() == 3001 or GetServerGroupID() == 8801)) then
                    return "YES"
                else
                    return "NO"
                end
            end
        else
            if session.world.IsIntegrateServer() == true then
                local pcEtc = GetMyEtcObject();

                local serverGroupID = TryGetProp(pcEtc, "MyWorldID");

                -- Test Server
                -- if GetServerNation() == "KOR" and serverGroupID == 1550 then
                --  return "NO";
                -- else
                --  return "YES";
                -- end

                -- Live Server
                if GetServerNation() == "KOR" and(serverGroupID == 3001 or serverGroupID == 8801) then
                    return "NO";
                else
                    return "YES";
                end
            else
                -- Test Server
                -- if (GetServerNation() == "KOR" and GetServerGroupID() == 1550) then
                --  return 'YES'
                -- end

                -- Live Server
                if (GetServerNation() == "KOR" and(GetServerGroupID() == 3001 or GetServerGroupID() == 8801)) then
                    return "YES"
                else
                    return "NO"
                end
            end
        end
    else
        -- Test Server
        -- if (GetServerNation() == "KOR" and GetServerGroupID() == 1550) then
        --  return 'YES'
        -- end

        -- Live Server
        if (GetServerNation() == "KOR" and(GetServerGroupID() == 3001 or GetServerGroupID() == 8801)) then
            return 'YES'
        end
    end


    -- Test Server
    -- if (GetServerNation() == "KOR" and GetServerGroupID() == 1550) then
    --  return 'YES'
    -- end

    -- Live Server
    -- if (GetServerNation() == "KOR" and ( GetServerGroupID() == 3001 or GetServerGroupID() == 8801)) then
    --   return 'YES'
    -- end

    return 'NO'
end

function IMC_LOG(code, stringinfo)
    imclog(code, stringinfo);
end

-- new logger
function IMCLOG_FATAL(logger, code, stringinfo)
    ImcScriptLog(logger, "FATAL", code, stringinfo)
end
function IMCLOG_ALERT(logger, code, stringinfo)
    ImcScriptLog(logger, "ALERT", code, stringinfo)
end
function IMCLOG_CRITICAL(logger, code, stringinfo)
    ImcScriptLog(logger, "CRITICAL", code, stringinfo)
end
function IMCLOG_ERROR(logger, code, stringinfo)
    ImcScriptLog(logger, "ERROR", code, stringinfo)
end
function IMCLOG_WARN(logger, code, stringinfo)
    ImcScriptLog(logger, "WARN", code, stringinfo)
end
function IMCLOG_NOTICE(logger, code, stringinfo)
    ImcScriptLog(logger, "NOTICE", code, stringinfo)
end
function IMCLOG_INFO(logger, code, stringinfo)
    ImcScriptLog(logger, "INFO", code, stringinfo)
end
function IMCLOG_DEBUG(logger, code, stringinfo)
    ImcScriptLog(logger, "DEBUG", code, stringinfo)
end

function IMCLOG_CONTENT(tag, ...)
    local logMsg = "";
    for i, v in ipairs { ...} do
        logMsg = logMsg .. tostring(v);
    end

    ImcContentLog(tag, logMsg)
end

function IS_REINFORCEABLE_ITEM(item)

    if item.GroupName == 'Weapon' then
        return 1;
    end
    if item.GroupName == 'Armor' then
        return 1;
    end
    if item.GroupName == 'SubWeapon' and item.BasicTooltipProp ~= 'None' then
        return 1;
    end

    return 0;
end

function GET_LAST_UI_OPEN_POS(etc)

    if etc == nil then
        return nil
    end

    local stringpos = etc["LastUIOpenPos"]

    if stringpos == 'None' then
        return nil

    end

    local x, y, z, mapname, uiname;

    for i = 0, 5 do

        local divStart, divEnd = string.find(stringpos, "/");
        if divStart == nil then
            uiname = stringpos
            break;
        end

        local divstringpos = string.sub(stringpos, 1, divStart - 1);

        if i == 0 then
            mapname = divstringpos
        elseif i == 1 then
            x = divstringpos
        elseif i == 2 then
            y = divstringpos
        elseif i == 3 then
            z = divstringpos
        end

        stringpos = string.sub(stringpos, divEnd + 1, string.len(stringpos));
    end

    return mapname, x, y, z, uiname
end


function IS_NO_EQUIPITEM(equipItem) -- No_~ 시리즈 아이템인지.

    local clsName = equipItem.ClassName;

    if clsName == 'NoWeapon' or clsName == "NoHat" or clsName == "NoBody" or clsName == "NoOuter" or clsName == 'NoShirt' or clsName == 'NoArmband' or clsName == 'NoHair' then
        return 1;
    elseif clsName == 'NoPants' or clsName == "NoGloves" or clsName == "NoBoots" or clsName == "NoRing" or clsName == 'NoHelmet' or clsName == 'NoNeck' then
        return 1;
    end

    return 0;
end

function GET_MAKE_SOCKET_PRICE(itemlv, grade, curcnt, taxRate)
    local clslist, cnt = GetClassList("socketprice");
    local gradRatio = { 1.2, 1, 0.5, 0.4, 0.3 }
    local itemGradeRatio = 1;
    local secretNumber = 1;
    if curcnt >= 1 then
        secretNumber = 0.8;
        itemGradeRatio = gradRatio[grade]
    end
    for i = 0, cnt - 1 do

        local cls = GetClassByIndexFromList(clslist, i);

        if cls.Lv == itemlv then
            local priceRatio =(curcnt + 1);
            local ret = SyncFloor(cls.NewSocketPrice * secretNumber *(priceRatio ^ 1 / itemGradeRatio));
            if taxRate ~= nil then
                ret = tonumber(CALC_PRICE_WITH_TAX_RATE(ret, taxRate))
            end
            return ret
        end
    end

    return 0;

end

function GET_REMOVE_GEM_PRICE(itemlv, taxRate)

    local clslist, cnt = GetClassList("socketprice");

    for i = 0, cnt - 1 do

        local cls = GetClassByIndexFromList(clslist, i);

        if cls.Lv == itemlv then
            local price = cls.RemoveSocketPrice
            if taxRate ~= nil then
                price = tonumber(CALC_PRICE_WITH_TAX_RATE(price, taxRate)) -- 젬 추출 세금
            end
            return price
        end
    end

    return 0;

end

function GET_GEM_TYPE_NUMBER(GemType)

    if GemType == 'Circle' then
        return 1;
    elseif GemType == 'Square' then
        return 2;
    elseif GemType == 'Diamond' then
        return 3;
    elseif GemType == 'Star' then
        return 4;
    end

    return -1;
end

-- 특정 존 앵커 중 랜덤으로 1개 IES를 리턴해준다
function SCR_RANDOM_ZONE_ANCHORIES(zoneName)
    local idspace = 'Anchor_' .. zoneName
    local class_count = GetClassCount(idspace)

    if class_count == nil or class_count == 0 then
        return nil, 'zone'
    end

    local rand = IMCRandom(0, class_count)

    local classIES = GetClassByIndex(idspace, rand)

    if classIES ~= nil then
        return classIES
    end

end

-- 테이블에서 특정 컬럼을 검색해서 리턴해준다
function SCR_TABLE_SEARCH_ITEM(list, target)
    local result = 'NO'
    local keyList = { }
    for key, value in pairs(list) do
        if value == target then
            keyList[#keyList + 1] = key
        end
    end

    if #keyList > 0 then
        result = 'YES'
    end

    return result, keyList
end



function SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, list, target1, target2, targetJob)
    local result = 'NO'
    local keyList = { }

    if target2 == 1 then
        target2 = 'M'
    elseif target2 == 2 then
        target2 = 'F'
    else
        return
    end
    for key, value in pairs(list) do
        local listSub1 = SCR_STRING_CUT_COLON(value)
        if listSub1[1] == 'JobChange' then
            if listSub1[2] == 'First' then
                local flag = 0

                if listSub1[3] ~= nil and(listSub1[3] == 'M' or listSub1[3] == 'F') then
                    if listSub1[3] ~= target2 then
                        flag = 1
                    end
                end

                if flag == 0 and targetJob ~= nil and targetJob ~= 'None' then
                    local classIES = GetClass('Job', targetJob)
                    if classIES ~= nil then
                        target1 = classIES.Initial
                        if IsServerSection(pc) == 1 then
                            local circle, changedJobCount = GetJobGradeByName(pc, targetJob);
                            if circle == 0 then
                                keyList[#keyList + 1] = key
                            end
                        else
                            local jobIES = SCR_GET_XML_IES('Job', 'Initial', target1)
                            if #jobIES >= 1 then
                                local ishave = IS_HAD_JOB(jobIES[1].ClassID)
                                if ishave == false then
                                    keyList[#keyList + 1] = key
                                end
                            end
                        end
                    end
                end
            end
        elseif #listSub1 == 1 then
            if listSub1[1] == 'M' or listSub1[1] == 'F' then
                if listSub1[1] == target2 then
                    keyList[#keyList + 1] = key
                end
            else
                if listSub1[1] == target1 then
                    keyList[#keyList + 1] = key
                end
            end
        elseif #listSub1 == 2 then
            if listSub1[1] == target1 then
                if listSub1[2] == target2 then
                    keyList[#keyList + 1] = key
                end
            end
        end
    end

    if #keyList > 0 then
        result = 'YES'
    end

    return result, keyList
end


-- 두개의 IES 리스트를 합쳐준다
function SCR_IES_ADD_IES(IES_list1, IES_list2)
    if IES_list1 == nil and IES_list2 == nil then
        return nil
    elseif IES_list1 == nil then
        IES_list1 = IES_list2
        return IES_list1
    elseif IES_list2 == nil then
        return IES_list1
    end

    if IES_list2 ~= nil then
        if #IES_list2 ~= nil then
            for y = 1, #IES_list2 do
                IES_list1[#IES_list1 + 1] = IES_list2[y]
            end
        end
    end
    return IES_list1
end

-- 특정 퀘스트 세션오브젝트 완료 조건 중 index 번째 조건 만족 확인
function SCR_QUEST_SOBJ_TERMS(pc, sObj_name, index)
    local sObj_quest = GetSessionObject(pc, sObj_name)
    if sObj_quest ~= nil then
        if GetPropType(sObj_quest, 'QuestInfoMaxCount' .. index) == nil or sObj_quest['QuestInfoMaxCount' .. index] == 0 then
            return 'NO_USE'
        elseif sObj_quest['QuestInfoValue' .. index] >= sObj_quest['QuestInfoMaxCount' .. index] then
            return 'YES'
        else
            return 'NO'
        end
    else
        return 'NO_QUEST'
    end
end

-- 특정 존에 있는 오브젝트의 좌표 IES 리스트를 찾아줌
function SCR_GET_MONGEN_ANCHOR(zone_name, column, value)
    local result2 = SCR_GET_XML_IES('GenType_' .. zone_name, column, value)
    if result2 ~= nil and #result2 > 0 then
        local result3 = SCR_GET_XML_IES('Anchor_' .. zone_name, 'GenType', result2[1].GenType)
        if result3 ~= nil and #result3 > 0 then
            return result3
        end
    end
end


-- xml 중 특정 컬럼의 값과 일치/유사 한 IES 리스트를 찾아줌 (option 1이면 유사 값, 아니면 일치)
function SCR_GET_XML_IES(idspace, column_name, target_value, option)
    local return_list = { }
    if idspace == nil then
        return return_list;
    end

    if GetClassByIndex(idspace, 0) == nil then
        return return_list;
    end

    local obj = GetClassByIndex(idspace, 0)
    if column_name == nil then
        return return_list;
    end

    if GetPropType(GetClassByIndex(idspace, 0), column_name) == nil then
        return return_list;
    end

    local class_count = GetClassCount(idspace)

    for y = 0, class_count - 1 do
        local classIES = GetClassByIndex(idspace, y)

        if option ~= 1 then
            if tostring(classIES[column_name]) == tostring(target_value) then
                return_list[#return_list + 1] = classIES
            end
        else
            if string.find(tostring(classIES[column_name]), tostring(target_value)) ~= nil then
                return_list[#return_list + 1] = classIES
            end
        end
    end

    return return_list
end

function SCR_JOBNAME_MATCHING(jobclassname)
    local result = GetClassString('Job', jobclassname, 'Initial')

    if result == nil then
        result = GetClassString('Job', 'Char1_1', 'Initial')
    end

    return result
end


function ZERO()
    return 0;
end

function ONE()
    return 1;
end

function FIVE()
    return 5;
end

function NONECP()
    return -1;
end

function SCR_MAX_SPL()
    return 512;
end

function SCR_DUPLICATION_SOLVE_TABLE(tb)
    local index1, index2, index3 = 0
    local temp_tb = { }

    for index1 = 1, #tb - 1 do
        for index2 = index1 + 1, #tb do
            if tb[index1] ~= 'None' and tb[index1] == tb[index2] then
                tb[index2] = 'None'
            end
        end
    end

    for index3 = 1, #tb do
        if tb[index3] ~= 'None' then
            temp_tb[#temp_tb + 1] = tb[index3]
        end
    end

    return temp_tb
end

function SCR_DUPLICATION_SOLVE(tb)
    local index1, index2, index3 = 0
    local temp_tb = { }

    for index1 = 1, #tb - 1 do
        for index2 = index1 + 1, #tb do
            if tb[index1][1] ~= 'None' and tb[index1][1] == tb[index2][1] then
                tb[index2][1] = 'None'
                if tb[index1][2] == -100 or tb[index2][2] == -100 then
                    tb[index1][2] = -100
                else
                    tb[index1][2] = tb[index1][2] + tb[index2][2]
                end
            end
        end
    end

    for index3 = 1, #tb do
        if tb[index3][1] ~= 'None' then
            temp_tb[#temp_tb + 1] = { }
            temp_tb[#temp_tb][1] = tb[index3][1]
            temp_tb[#temp_tb][2] = tb[index3][2]
        end
    end

    return temp_tb
end

function SCR_DUPLICATION_SOLVE_IES(tb, column)
    local index1, index2, index3 = 0
    local temp_tb = { }
    local temp_tb2 = tb
    local list = { }

    for index1 = 1, #temp_tb2 - 1 do
        for index2 = index1 + 1, #temp_tb2 do
            if temp_tb2[index1][column] == temp_tb2[index2][column] then
                list[#list + 1] = index2
            end
        end
    end

    for index3 = 1, #temp_tb2 do
        local flag = 0
        for i = 1, #list do
            if index3 == list[i] then
                flag = flag + 1
                break
            end
        end

        if flag == 0 then
            temp_tb[#temp_tb + 1] = temp_tb2[index3]
        end

        --        if temp_tb2[index3][column] ~= 'None' then
        --            temp_tb[#temp_tb + 1] = temp_tb2[index3]
        --        end
    end

    return temp_tb
end

function SCR_STRING_CUT_UNDERBAR(a)
    if a == nil then
        return
    end

    local temp_table = { };
    local w;
    local i;
    for w in string.gmatch(a, "[^_]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end
    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end

function SCR_STRING_CUT_SHAP(a)
    if a == nil then
        return
    end

    local temp_table = { };
    local w;
    local i;
    for w in string.gmatch(a, "[^#]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end
    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end

function SCR_STRING_CUT_SEMICOLON(a)
    if a == nil then
        return
    end

    local temp_table = { };
    local w;
    local i;
    for w in string.gmatch(a, "[^;]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end
    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end

function SCR_STRING_CUT_COLON(a)
    if a == nil then
        return
    end
    local temp_table = { };
    local w;
    local i;
    for w in string.gmatch(a, "[^:]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end

    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end

function SCR_STRING_CUT_COMMA(a)
    if a == nil then
        return
    end

    local temp_table = { };
    local w;
    local i;
    for w in string.gmatch(a, "[^,]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end
    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end


function SCR_STRING_CUT_SPACEBAR(a)
    if a == nil then
        return
    end

    local temp_table = { };
    local w;
    local i;

    for w in string.gmatch(a, "[^ ]+") do
        if tonumber(w) ~= nil then
            temp_table[#temp_table + 1] = tonumber(w);
        else
            temp_table[#temp_table + 1] = w;
        end
    end

    --    for i = 1, #temp_table do
    --        print(temp_table[i]);
    --    end
    --    print('AAAAA'..#temp_table)
    return temp_table;
end

function SCR_STRING_CUT_CHAR(a)
    if a == nil then
        return
    end
    local temp_table = { };
    local i;
    for i = 1, string.len(a) do
        if tonumber(string.sub(a, i, i)) ~= nil then
            temp_table[#temp_table + 1] = tonumber(string.sub(a, i, i))
        else
            temp_table[#temp_table + 1] = string.sub(a, i, i)
        end
    end

    return temp_table
end

function SCR_STRING_CUT(a, b)
    if a == nil then
        return
    end
    local temp_table = { };
    local w;

    if type(a) == table then
        for i = 1, #a do
            if b == nil then
                b = '/'
            end
            if string.find(a[i], b) ~= nil then
                for w in string.gmatch(a[i], "[^" .. b .. "]+") do
                    if tonumber(w) ~= nil then
                        temp_table[#temp_table + 1] = tonumber(w);
                    else
                        temp_table[#temp_table + 1] = w;
                    end
                end
            else
                if tonumber(a[i]) ~= nil then
                    temp_table[#temp_table + 1] = tonumber(a[i])
                else
                    temp_table[#temp_table + 1] = a[i]
                end
            end
        end
    else
        if b == nil then
            b = '/'
        end
        for w in string.gmatch(a, "[^" .. b .. "]+") do
            if tonumber(w) ~= nil then
                temp_table[#temp_table + 1] = tonumber(w);
            else
                temp_table[#temp_table + 1] = w;
            end
        end
    end

    return temp_table;
end





function SCR_STRING_CUT_TO_STR(a, b)
    if a == nil then
        return
    end
    local temp_table = { };
    local w;

    if b == nil then
        b = '/'
    end
    for w in string.gmatch(a, "[^" .. b .. "]+") do
        temp_table[#temp_table + 1] = w;
    end

    return temp_table;
end






function SCR_STRING_CONCAT(table, a)
    local concatStr = "";
    if a == nil then
        a = ";";
    end

    for i = 1, #table do
        if type(table[i]) == "string" and string.find(concatStr, table[i]) == nil then
            if i < #table then
                concatStr = concatStr .. table[i] .. a;
            else
                concatStr = concatStr .. table[i];
            end
        end
    end

    return concatStr;
end

function SCR_STRING_TO_TABLE(a)
    if a == nil then
        return a
    end
    local ret = { }
    for i = 1, string.len(a) do
        ret[#ret + 1] = string.sub(a, i, i)
    end

    return ret
end
function SCR_DATE_TO_YHOUR_BASIC_2000_STR(str)
    if str == nil or type(str) ~= 'string' then
        return
    end

    local date = SCR_STRING_CUT(str)
    if #date == 4 then
        return SCR_DATE_TO_YHOUR_BASIC_2000(date[1], date[2], date[3], date[4])
    end
end
function SCR_DATE_TO_YHOUR_BASIC_2000(yy, mm, dd, hh)
    local days, monthdays, leapyears, nonleapyears, nonnonleapyears

    monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    leapyears = math.floor((yy - 2000) / 4);
    nonleapyears = math.floor((yy - 2000) / 100)
    nonnonleapyears = math.floor((yy - 1600) / 400)

    if ((math.mod(yy, 4) == 0) and mm < 3) then
        leapyears = leapyears - 1
    end

    days = 365 *(yy - 2000) + leapyears - nonleapyears + nonnonleapyears - 1

    local c = 1
    while (c < mm) do
        days = days + monthdays[c]
        c = c + 1
    end

    days = days + dd + 1

    local yhour = days * 24 + hh

    return yhour
end

function SCR_DATE_TO_YMIN_BASIC_2000(yy, mm, dd, hh, min)
    local days, monthdays, leapyears, nonleapyears, nonnonleapyears

    monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    leapyears = math.floor((yy - 2000) / 4);
    nonleapyears = math.floor((yy - 2000) / 100)
    nonnonleapyears = math.floor((yy - 1600) / 400)

    if ((math.mod(yy, 4) == 0) and mm < 3) then
        leapyears = leapyears - 1
    end

    days = 365 *(yy - 2000) + leapyears - nonleapyears + nonnonleapyears - 1

    local c = 1
    while (c < mm) do
        days = days + monthdays[c]
        c = c + 1
    end

    days = days + dd + 1

    local ymin = days * 1440 + hh * 60 + min

    return ymin
end
function SCR_DATE_TO_YDAY_BASIC_2000_REVERSE(yday)
    local yy, mm, dd
    local startY = 2000
    local monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    while 1 do
        local leapDay = 0
        if startY % 400 == 0 then
            leapDay = 1
        elseif startY % 100 == 0 then
        elseif startY % 4 == 0 then
            leapDay = 1
        end

        leapDay = monthdays[2] + leapDay

        for i = 1, #monthdays do
            local monDay = monthdays[i]
            if i == 2 then
                monDay = leapDay
            end

            if yday < monDay then
                yy = startY
                mm = i
                dd = yday
                return yy, mm, dd
            else
                yday = yday - monDay
            end

        end
        startY = startY + 1
    end


    return yy, mm, dd
end
function SCR_DATE_HOUR_TO_YWEEK_BASIC_2000(yy, mm, dd, hour, firstWday, firstHour)
    local yday2000 = SCR_DATE_TO_YDAY_BASIC_2000(yy, mm, dd)
    if hour < firstHour then
        yday2000 = yday2000 - 1
    end
    local result = math.floor((yday2000 + 6 - firstWday) / 7) + 1
    return result

end
function SCR_DATE_TO_YWEEK_BASIC_2000(yy, mm, dd, firstWday)
    local yday2000 = SCR_DATE_TO_YDAY_BASIC_2000(yy, mm, dd)
    local result = math.floor((yday2000 + 6 - firstWday) / 7) + 1
    return result
end
function SCR_DATE_TO_YDAY_BASIC_2000(yy, mm, dd)
    local days, monthdays, leapyears, nonleapyears, nonnonleapyears

    monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    leapyears = math.floor((yy - 2000) / 4);
    nonleapyears = math.floor((yy - 2000) / 100)
    nonnonleapyears = math.floor((yy - 1600) / 400)

    if ((math.mod(yy, 4) == 0) and mm < 3) then
        leapyears = leapyears - 1
    end

    days = 365 *(yy - 2000) + leapyears - nonleapyears + nonnonleapyears - 1

    local c = 1
    while (c < mm) do
        days = days + monthdays[c]
        c = c + 1
    end

    days = days + dd + 1

    return days
end

function SCR_DATE_TO_HOUR(year, yday, hour)
    year = tonumber(year)
    yday = tonumber(yday)
    hour = tonumber(hour)
    local ret =(SCR_DATE_TO_YDAY_BASIC_2000(year - 1, 12, 31) * 24) +((yday - 1) * 24) + hour
    return ret
end

function SCR_YEARYDAY_TO_DAY(year, yday)
    year = tonumber(year)
    yday = tonumber(yday)
    local ret = SCR_DATE_TO_YDAY_BASIC_2000(year - 1, 12, 31) + yday
    return ret
end

function SCR_WDAY_TO_HOUR(wday, hour)
    wday = tonumber(wday)
    hour = tonumber(hour)
    local ret =((wday - 1) * 24) + hour
    return ret
end
function SCR_DAY_TO_HOUR(day, hour)
    day = tonumber(day)
    hour = tonumber(hour)
    local ret =((day - 1) * 24) + hour
    return ret
end
function SCR_MONTH_TO_YDAY(year, month, day)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    local leapyears1 = year % 4
    local leapyears2 = year % 100
    local leapyears3 = year % 400

    local monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local retDay = 0
    if month > 1 then
        for i = 1, month - 1 do
            retDay = retDay + monthdays[i]
        end
    end

    if month >= 3 then
        if leapyears1 == 0 then
            if leapyears2 ~= 0 or(leapyears2 == 0 and leapyears3 == 0) then
                retDay = retDay + 1
            end
        end
    end

    local ret = retDay + day
    return ret
end

function SCR_MONTH_TO_HOUR(year, month, day, hour)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    hour = tonumber(hour)

    local leapyears1 = year % 4
    local leapyears2 = year % 100
    local leapyears3 = year % 400

    local monthdays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    local retDay = 0
    if month > 1 then
        for i = 1, month - 1 do
            retDay = retDay + monthdays[i]
        end
    end

    if month >= 3 then
        if leapyears1 == 0 then
            if leapyears2 ~= 0 or(leapyears2 == 0 and leapyears3 == 0) then
                retDay = retDay + 1
            end
        end
    end

    local ret =((retDay + day - 1) * 24) + hour
    return ret
end


function SCR_NUMTABLE_STRING(t)
    local ret = ''
    local count = #t
    for i = 1, count do
        ret = ret .. tostring(t[i])
    end

    return ret
end

function IS_WARPNPC(zoneClassName, npcFunc)
    local getTypeIdspace = 'GenType_' .. zoneClassName
    local isMap = GetClassCount(getTypeIdspace)
    if isMap ~= nil and isMap > 0 then
        local dialogIESList = SCR_GET_XML_IES(getTypeIdspace, 'Dialog', npcFunc)
        if dialogIESList ~= nil and #dialogIESList > 0 then
            for i = 1, #dialogIESList do
                if 'Warp_arrow' == dialogIESList[i].ClassType then
                    return 'YES'
                end
            end
        end
        local enterIESList = SCR_GET_XML_IES(getTypeIdspace, 'Enter', npcFunc)
        if enterIESList ~= nil and #enterIESList > 0 then
            for i = 1, #enterIESList do
                if 'Warp_arrow' == enterIESList[i].ClassType then
                    return 'YES'
                end
            end
        end
        local leaveIESList = SCR_GET_XML_IES(getTypeIdspace, 'Leave', npcFunc)
        if leaveIESList ~= nil and #leaveIESList > 0 then
            for i = 1, #leaveIESList do
                if 'Warp_arrow' == leaveIESList[i].ClassType then
                    return 'YES'
                end
            end
        end
    end
    return 'NO'
end

function table.find(t, ele)
    if t ~= nil then
        local count = #t
        if count > 0 then
            for i = 1, count do
                if type(t[i]) ~= type(ele) then
                    if type(t[i]) == 'number' then
                        ele = tonumber(ele)
                    elseif type(t[i]) == 'string' then
                        ele = tostring(ele)
                    end
                end
                if t[i] == ele then
                    return i
                end
            end
        end
    end
    return 0
end

function table.count(t, ele)
    local count = #t
    local ret = 0
    if count > 0 then
        for i = 1, count do
            local eleTemp = ele
            if type(t[i]) ~= type(ele) then
                if type(t[i]) == 'number' then
                    eleTemp = tonumber(ele)
                elseif type(t[i]) == 'string' then
                    eleTemp = tostring(ele)
                end
            end
            if t[i] == eleTemp then
                ret = ret + 1
            end
        end
    end

    return ret
end

function ADD_GQUEST_MULTIPLY(cls, propName, mul)
    if cls[propName] == 1 then
        return mul + 0.5;
    end

    return mul;
end

function GET_GQUEST_POINT(cls, arg)

    local cnt = G_TOTAL_MON_CNT(cls);
    local mul = 1.0;
    mul = ADD_GQUEST_MULTIPLY(cls, "CheckSkill", mul);
    mul = ADD_GQUEST_MULTIPLY(cls, "CheckOverKill", mul);
    mul = ADD_GQUEST_MULTIPLY(cls, "OnlyOverKill", mul);
    mul = ADD_GQUEST_MULTIPLY(cls, "FailByDamage", mul);
    mul = ADD_GQUEST_MULTIPLY(cls, "TimeLimit", mul);
    mul = ADD_GQUEST_MULTIPLY(cls, "OnlyOverKill", mul);

    return(cls.Level * 4 + cnt * 2) * mul;

end



function GET_CLS_GROUP(idSpace, groupName)

    local clsList = GetClassList(idSpace);
    local retList = { };
    if clsList == nil then
        return retList;
    end

    local index = 1;

    while 1 do

        local name = groupName .. "_" .. index;
        local cls = GetClassByNameFromList(clsList, name);
        if cls == nil then
            return retList;
        end

        retList[index] = cls;
        index = index + 1;
    end

end


function GET_MAP_ACHI_NAME(mapCls)

    local name = ScpArgMsg("Auto_{Auto_1}_TamSaJa", "Auto_1", mapCls.Name);
    local desc = ScpArgMsg("Auto_{Auto_1}_Jiyeogeul_MoDu_TamSaHayeossSeupNiDa.", "Auto_1", mapCls.Name);
    local desctitle = name -- 임시. 나중에 맵 업적 달성시 보상및 칭호에 대한 데이터 세팅 이루어 지면 바꾸자.
    local reward = "None"
    return desc, name, desctitle, reward;

end

-- 경험치 페널티 (인던 제외) --
function GET_EXP_RATIO(myLevel, monLevel, highLv, monster)
    -- hgihLv : 파티원중 가장 높은 레벨, 파티가 아니거나 1인 파티면 0임
    local pcLv = myLevel;
    local monLv = monLevel;
    local value = 1;

    if monster ~= nil then
        if IsBuffApplied(monster, 'SuperExp') == 'YES' then
            value = 500;
        end
    end

    local standardLevel = 30;
    local levelGap = math.abs(pcLv - monLv);


    if levelGap > standardLevel then
        local penaltyRatio = 0.0;
        if pcLv < monLv then
	        penaltyRatio = 0.05;	-- 고레벨 몬스터 사냥 시 페널티
        else
	    	penaltyRatio = 0.02;	-- 저레벨 몬스터 사냥 시 페널티
        end

        local lvRatio = 1 -((levelGap - standardLevel) * penaltyRatio);
        value = value * lvRatio;
    end

    if value < 0 then
        value = 0;
    end

    return value;
end

-- 인던 경험치 페널티 --
function GET_EXP_RATIO_INDUN(myLevel, indunLevel, highLv)
    -- hgihLv : 파티원중 가장 높은 레벨, 파티가 아니거나 1인 파티면 0임
    local pcLv = myLevel;
    local indunLv = indunLevel;
    local value = 1;

    local standardLevel = 80;
    local levelGap = math.abs(pcLv - indunLv);


    if levelGap > standardLevel then
        local penaltyRatio = 0.0;
        if pcLv < indunLv then
	        penaltyRatio = 0.05;	-- 고레벨 몬스터 사냥 시 페널티
        else
	    	penaltyRatio = 0.05;	-- 저레벨 몬스터 사냥 시 페널티
        end

        local lvRatio = 1 -((levelGap - standardLevel) * penaltyRatio);
        value = value * lvRatio;
    end

    if value < 0 then
        value = 0;
    end

    return value;
end

function GET_ADD_SPRAY_USE(colCnt, obj)

    local curUsed = obj.RemainAmount;
    local addUse = colCnt % MAX_COLSPRAY_PIXEL();

    local remain = MAX_COLSPRAY_PIXEL() - curUsed - addUse;
    if remain < 0 then
        return 0;
    end

    if remain > GET_SPRAY_REMOVE_AMOUNT() then
        return 0;
    end

    return remain;

end

function GET_TOTAL_SPRAY_PIXEL(cnt, obj)

    local curUse = obj.RemainAmount;
    return cnt * MAX_COLSPRAY_PIXEL() - curUse;

end

function GET_SPRAY_REMOVE_AMOUNT()

    return 50;

end



function IS_GUILDQUEST_CHECK_ITEM(sObj)

    for j = 1, GUILDQUEST_MAX_ITEM do

        local ItemID = sObj["Step" .. j + 4];
        if ItemID > 0 then
            return 1;
        end
    end

    return 0;
end

function IS_GULID_QUEST_ITEM(sObj, itemID)

    for j = 1, GUILDQUEST_MAX_ITEM do
        local reqID = sObj["Step" .. j + 4];
        if reqID == itemID then
            return 1;
        else
            return 0;
        end

    end

    return 0;
end

function REGISTER_XML_CONST(propName, propValue)

    _G[propName] = propValue;

end

function GET_MS_TXT(sec)
    local appTime = imcTime.GetAppTime();
    local m, s = GET_MS(sec);
    local colon = ":";
    if math.mod(math.floor(appTime * 2.0), 2) == 1 then
        colon = " ";
    end

    return string.format("%02d%s%02d", m, colon, s);
end

function GET_MS(sec)
    if sec < 0 then
        sec = 0;
    end

    local min = 0;
    local s = 0;
    if sec >= 60 then
        min = math.floor(sec / 60);
        s = sec % 60;
    else
        s = sec
    end

    return min, s;
end

function GET_DHMS(sec)

    local day = 0;
    local hour = 0;
    local min = 0;
    local s = 0;
    if sec >= 86400 then
        day = math.floor(sec / 86400);
        sec = sec % 86400;
    end

    if sec >= 3600 then
        hour = math.floor(sec / 3600);
        sec = sec % 3600;
    end

    if sec >= 60 then
        min = math.floor(sec / 60);
        s = sec % 60;
    else
        s = sec
    end

    return day, hour, min, s;

end

function GET_DHMS_STRING(sec)

    if sec < 0 then
        sec = 0;
    end

    local d, h, m, s = GET_DHMS(sec);
    local ret = "";
    if d > 0 then
        ret = ret .. string.format("%02d:", d);
    end
    if h > 0 then
        ret = ret .. string.format("%02d:", h);
    end

    ret = ret .. string.format("%02d:", m);
    ret = ret .. string.format("%02d", s);

    return ret;

end

function SCR_GET_MCY_BUY_PRICE(itemIndex, curValue)

    if itemIndex > 5 then
        return 50;
    end

    return 100;
    -- return 600 + 200 * curValue;

end

function GET_ABIL_LEVEL(self, abilName)

    local abil = GetAbility(self, abilName);
    if abil == nil then
        return 0;
    end

    return abil.Level;

end

function GET_SKILL_LEVEL(self, skillName)

    local skl = GetSkill(self, skillName);
    if skl == nil then
        return 0;
    end

    return skl.Level;

end

function SCR_DIALOG_NPC_ANIM(animName)

    -- control.DestTgtPlayDialogAnim(animName);
    local handle = session.GetTargetHandle();
    movie.PlayAnim(handle, animName, 1.0, 1);

end

-- 공용 라이브러리
--------------------------------------------------------------------------------------
-- 특정 문자를 기준으로 문자열을 잘라 테이블로 반환
function StringSplit(str, delimStr)  
    local _tempStr = str;
    local _result = { };
    local _index = 1;

    if dic ~= nil and type(dic) == "table" then
        _tempStr = dic.getTranslatedStr(str);
    end

    while true do
        if _tempStr == nil then
            break
        end

        local _temp = string.find(_tempStr, delimStr);
        if _temp == nil then
            _result[_index] = _tempStr;
            break;
        else
            _result[_index] = string.sub(_tempStr, 0, _temp - 1);
        end

        _tempStr = string.sub(_tempStr, string.len(_result[_index]) + string.len(delimStr) + 1, string.len(_tempStr));
        _index = _index + 1;

        if string.len(_tempStr) <= 0 then
            break;
        end
    end
    return _result;
end


function IS_EQUIP(item)
    return item.ItemType == "Equip";
end

function IS_NEED_APPRAISED_ITEM(item)
    if IS_EQUIP(item) == false then
        return false;
    end

    local isAppraised = TryGetProp(item, 'NeedAppraisal')
    if isAppraised == nil then
        return false;
    end

    if isAppraised == 1 then
        return true;
    end
    return false;
end

function IS_NEED_RANDOM_OPTION_ITEM(item)
    if IS_EQUIP(item) == false then

        return false;
    end

    local isRandomOption = TryGetProp(item, 'NeedRandomOption')
    if isRandomOption == nil then
        return false;
    end

    if isRandomOption == 1 then
        return true;
    end
    return false;
end

function INCR_PROP(self, obj, propName, propValue)

    self[propName] = self[propName] + propValue;
    SetExProp(obj, propName, propValue);

end

function RESTORE_PROP(self, obj, propName)

    local value = GetExProp(obj, propName);
    self[propName] = self[propName] - value;

end


function IsEnableEffigy(self, skill)

    if "NO" == IsBuffApplied(self, "Hexing_Buff") then
        return 0;
    end

    -- 거리 체크하는거 추가해야할듯?
    -- 근데 그럼 성능낭비인디???
    return 1;
end


-- 보스 드랍 리스트 교체 바인딩 함수
function CHANGE_BOSSDROPLIST(self, equipDropList)
    ChangeClassValue(self, 'EquipDropType', equipDropList);
end

function GET_RECIPE_REQITEM_CNT(cls, propname)

    local recipeType = cls.RecipeType;
    if recipeType == "Anvil" or recipeType == "Grill" then
        return cls[propname .. "_Cnt"], TryGet(cls, propname .. "_Level");
    elseif recipeType == "Drag" or recipeType == "Upgrade" then
        return cls[propname .. "_Cnt"], TryGet(cls, propname .. "_Level");
    end

    return 0;

end

-- 전직가능 조건체크하는 함수. skilltree.lua ui애드온에서 사용하고 서버에서도 조건체크할때 사용.
function CHECK_CHANGE_JOB_CONDITION(cls, haveJobNameList, haveJobGradeList)

    -- 이미 가지고있는 직업이면 바로 true리턴
    for i = 0, #haveJobNameList do
        if haveJobNameList[i] ~= nil then
            if haveJobNameList[i] == cls.ClassName then
                return true;
            end
        end
    end

    -- 아래는 새로운 직업에대한 조건 체크
    local i = 1;

    while 1 do

        -- 조건체크하는 칼럼이 더 필요하면 xml에서 걍 늘리면됨. ㅇㅋ?
        if GetPropType(cls, "ChangeJobCondition" .. i) == nil then
            break;
        end


        -- ChangeJobCondition이 전부 'None'이면 퀘스트를 통해서 전직하는거임. UI에서는 안보여줌.
        if cls["ChangeJobCondition" .. i] == 'None' then
            return false;
        end


        local sList = StringSplit(cls["ChangeJobCondition" .. i], ";");
        local conditionCount = #sList / 2;  -- 해당직업 전직조건 체크갯수

        local completeCount = 0;            -- 전직조건에 몇개나 만족하는지
        for j = 1, conditionCount do
            -- 직업가지고있고 요구레벨보다 높은지 체크
            for n = 0, #haveJobNameList do

                if sList[j * 2 - 1] == haveJobNameList[n] and tonumber(sList[j * 2]) <= tonumber(haveJobGradeList[n]) then
                    completeCount = completeCount + 1;
                end
            end
        end

        -- 전직조건에 모두 만족하면 전직가능하다고 셋팅해줌
        if conditionCount == completeCount then
            return true;
        end

        i = i + 1;
    end

    return false;
end


function GET_2D_DIS(x1, y1, x2, y2)

    if x1 == nil or y1 == nil or x2 == nil or y2 == nil then
        return 0
    end

    local x = x1 - x2
    local y = y1 - y2

    return math.sqrt(x * x + y * y);
end

function NUM_KILO_CHANGE(num)
    local str = ""
    if num >= 1000 then
        while 1 do
            local remain = num % 1000
            if remain >= 100 then
                str = tostring(remain) .. "," .. str
            elseif remain >= 10 then
                str = "0" .. tostring(remain) .. "," .. str
            else
                str = "00" .. tostring(remain) .. "," .. str
            end

            num = math.floor(num / 1000)
            if num < 1000 then
                str = tostring(num) .. "," .. str
                break
            end
        end
    else
        str = tostring(num)
    end
    if string.sub(str, -1) == ',' then
        str = string.sub(str, 1, -2)
    end
    return str
end

function SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestZoneList, chType)
    local ret = "HIDE"
    if questIES.PossibleUI_Notify == 'NO' then
        return ret, subQuestZoneList
    end
    local sobjIES = GET_MAIN_SOBJ();
    local abandonCheck = 'None';
    local fun = _G['QUEST_ABANDON_RESTARTLIST_CHECK']
    if nil ~= fun then
        abandonCheck = fun(questIES, sobjIES)
    end
    local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName)

    local checkZoneList = { }
    local subQuestFlag = 0
    local subQuestNowZone = ''
    local maxLv = 10

    if pc.Lv <= 10 then
        maxLv = 2
    elseif pc.Lv <= 20 then
        maxLv = 3
    elseif pc.Lv <= 30 then
        maxLv = 5
    end

    if questIES.Level >= pc.Lv - 5 and questIES.Level <= pc.Lv + maxLv then
        if pc.Lv < 100 and questIES.QStartZone ~= 'None' and sobjIES.QSTARTZONETYPE ~= 'None' and questIES.QStartZone ~= sobjIES.QSTARTZONETYPE then
            subQuestFlag = 4
        else
            if questIES.StartMapListUI ~= 'None' then
                checkZoneList = SCR_STRING_CUT(questIES.StartMapListUI)
            end
            if table.find(checkZoneList, questIES.StartMap) == 0 then
                checkZoneList[#checkZoneList + 1] = questIES.StartMap
            end
            if subQuestZoneList == nil then
            else
                if #checkZoneList > 0 then
                    for i = 1, #checkZoneList do
                        if table.find(subQuestZoneList, checkZoneList[i]) > 0 then
                            subQuestFlag = 1
                            break
                        end
                    end
                else
                    subQuestFlag = 2
                end
            end

            if subQuestFlag == 0 then
                if questIES.StartMap ~= 'None' then
                    subQuestNowZone = questIES.StartMap
                else
                    subQuestNowZone = checkZoneList[1]
                end
            end
        end
    else
        subQuestFlag = 3
    end

    if subQuestZoneList == nil then
        subQuestZoneList = { }
    end

    local zonecheckFun = _G['LINKZONECHECK'];
    if chType == 'Set2' then
        ret = "OPEN"
        return ret, subQuestZoneList
    elseif (chType == 'ZoneMap' or chType == 'NPCMark') and abandonCheck == 'ABANDON/LIST' then
        ret = "OPEN"
        return ret, subQuestZoneList
    elseif questIES.QuestMode ~= "MAIN" and questIES.QuestMode ~= "KEYITEM" and result == 'POSSIBLE' and(subQuestFlag == 0 or subQuestFlag == 1) then
        ret = "OPEN"
        subQuestZoneList[#subQuestZoneList + 1] = subQuestNowZone
        return ret, subQuestZoneList
    elseif questIES.QuestMode ~= "MAIN" and questIES.QuestMode ~= "KEYITEM" and questIES.Check_QuestCount > 0 and zonecheckFun ~= nil and zonecheckFun(GetZoneName(pc), questIES.StartMap) == 'YES' then
        local sObj = GetSessionObject(pc, "ssn_klapeda")
        local result1 = SCR_QUEST_CHECK_MODULE_QUEST(pc, questIES, sObj)
        if result1 == "YES" then
            ret = "OPEN"
            return ret, subQuestZoneList
        end
    elseif questIES.QuestMode == "MAIN" or questIES.PossibleUI_Notify == 'UNCOND' then
        ret = "OPEN"
        return ret, subQuestZoneList
    end

    return ret, subQuestZoneList
end

function SCR_GET_ZONE_FACTION_OBJECT(zoneClassName, factionList, monRankList, respawnTime)
    local zoneGentype = 'GenType_' .. zoneClassName
    local classCount = GetClassCount(zoneGentype)
    local factionList = SCR_STRING_CUT(factionList)
    local monRankList = SCR_STRING_CUT(monRankList)
    local i
    local monList = { }
    for i = 0, classCount - 1 do
        local gentypeIES = GetClassByIndex(zoneGentype, i)
        if gentypeIES ~= nil and table.find(factionList, gentypeIES.Faction) > 0 and gentypeIES.MaxPop > 0 then
            if respawnTime == nil or gentypeIES.RespawnTime <= respawnTime then
                local monIES = GetClass('Monster', gentypeIES.ClassType)
                if monIES ~= nil then
                    local rankFlag = 'YES'
                    if #monRankList > 0 and GetPropType(monIES, 'MonRank') ~= nil and table.find(monRankList, monIES.MonRank) == 0 then
                        rankFlag = 'NO'
                    end
                    if rankFlag == 'YES' then
                        local flag = false
                        if #monList > 0 then
                            for j = 1, #monList do
                                if monList[j][1] == gentypeIES.ClassType then
                                    monList[j][2] = monList[j][2] + gentypeIES.MaxPop
                                    flag = true
                                    break
                                end
                            end
                        end
                        if flag == false then
                            monList[#monList + 1] = { }
                            monList[#monList][1] = gentypeIES.ClassType
                            monList[#monList][2] = gentypeIES.MaxPop
                            monList[#monList][3] = monIES.MonRank
                            monList[#monList][4] = monIES.DropItemList
                        end
                    end
                end
            end
        end
    end

    return monList
end

function GET_COMMA_SEPARATED_STRING(num)
    local stringValue = tostring(num);
    local retStr = stringValue;
    local strLen = string.len(stringValue);
    if strLen > 14 then
        print('Can not use more than 14 digits!');
        return num, "FAIL";
        -- 	retStr = GET_COMMA_SEPARATED_STRING_FOR_HIGH_VALUE(num);
        -- 	return retStr;
    end

    local loop = math.floor((strLen - 1) / 3);
    if loop >= 1 then
        retStr = string.sub(stringValue, -3);
        for i = 1, loop do
            local tempStr = string.sub(stringValue, -3 *(i + 1),(-3 * i) -1);

            retStr = tempStr .. ',' .. retStr;
        end
    end

    return retStr, "SUCCESS";
end

function GET_COMMA_SEPARATED_STRING_FOR_HIGH_VALUE(num)
    local retStr = "";
    local numValue = num;

	for i = 1, 1000 do	-- 무한루프 방지용 --
        local tempValue = numValue % 1000;
        if string.len(tempValue) < 3 then
            for j = 1, 3 - string.len(tempValue) do
                tempValue = tostring(0 .. tempValue);
            end
        end

        numValue = math.floor(numValue / 1000);

        if retStr == "" then
            retStr = tempValue;
        else
            retStr = tempValue .. ',' .. retStr;
        end

        if numValue < 1000 then
            if numValue == 0 then
                break;
            end

            retStr = numValue .. ',' .. retStr;
            break;
        end
    end

    return retStr, "SUCCESS";
end

-- 이 함수는 이제 사용하지 말 것 --
-- 그래도 혹시 어디서 참조할지 몰라서 남겨두긴 함 --
function GET_COMMAED_STRING(num) -- unsigned long 범위내에서 가능하게 수정함
    if num == nil then
        return "0";
    end
    local retStr = "";
    num = tonumber(num);
    if num >= 0 then
        retStr = GetCommaedString(num);
    else
        retStr = '-' .. GetCommaedString(- num);
    end
    return retStr;
end

function GET_NOT_COMMAED_NUMBER(commaedString)
    local retStr = "";
    local strLen = string.len(commaedString);
    local tempStr = commaedString;
    local startIndex, endIndex = string.find(tempStr, ',');
    local noInfinite = 0;

    while startIndex ~= nil do
        retStr = retStr .. string.sub(tempStr, 1, startIndex - 1);
        tempStr = string.sub(tempStr, startIndex + 1, string.len(tempStr));
        startIndex, endIndex = string.find(tempStr, ',');
        noInfinite = noInfinite + 1;

        -- 혹시 모를 무한루프 방지
        if noInfinite >= 10000 then
            break;
        end
    end
    retStr = retStr .. tempStr;
    local retNum = tonumber(retStr);
    if retNum == nil then
        retNum = 0;
    end
    return retNum;
end

function IS_ENABLE_EQUIP_GEM(targetItem, gemType, targetItemInvItem)
    if targetItem == nil or gemType == nil then
        return false;
    end

    local maxSocket = TryGetProp(targetItem, 'MaxSocket');
    if maxSocket < VALID_DUP_GEM_CNT then
        return true;
    end

    local curCnt = 0;
    if targetItemInvItem ~= nil then
        for i = 0, maxSocket - 1 do
            if targetItemInvItem:GetEquipGemID(i) == gemType then
                curCnt = curCnt + 1;
            end
        end
    else -- server
        for i = 0, maxSocket - 1 do
            if GetItemSocketInfo(targetItem, i) == gemType then
                curCnt = curCnt + 1;
            end
        end
    end

    if curCnt + 1 > VALID_DUP_GEM_CNT then
        return false;
    end

    return true;
end

function IS_ITEM_IN_LIST(list, item)
    if list == nil or item == nil or #list < 1 then
        return false;
    end

    for i = 1, #list do
        if list[i] == item then
            return true;
        end
    end

    return false;
end


function EXIST_ITEM(list, element)
    if list == nil or #list < 1 then
        return false;
    end
    for i = 1, #list do
        if list[i] == element then
            return true;
        end
    end
    return false;
end

function PUSH_BACK_IF_NOT_EXIST(list, element)
    if EXIST_ITEM(list, element) == true then
        return list;
    end

    list[#list + 1] = element;
    return list;
end

function SCR_REINFORCE_COUPON()
    local couponList = { 'Event_Reinforce_100000coupon', 'Event_Reinforce_100000coupon_Event'}
    return couponList
end

function SCR_REINFORCE_COUPON_PRECHECK(pc, price)
    local retCouponList = { };
    local couponList = SCR_REINFORCE_COUPON()
    local couponValueList = { }
    for i = 1, #couponList do
        local itemIES = GetClass('Item', couponList[i])
        if itemIES ~= nil then
            local value = TryGetProp(itemIES, 'NumberArg1')
            if value ~= nil then
                local itemCount = GetInvItemCount(pc, couponList[i])
                if itemCount > 0 then
                    couponValueList[#couponValueList + 1] = { couponList[i], value, itemCount }
                end
            end
        end
    end

    for i = 1, #couponValueList - 1 do
        for x = i + 1, #couponValueList do
            if couponValueList[i][2] < couponValueList[x][2] then
                local temp = { couponValueList[i][1], couponValueList[i][2], couponValueList[i][3] }
                couponValueList[i] = { couponValueList[x][1], couponValueList[x][2], couponValueList[x][3] }
                couponValueList[x] = temp
            end
        end
    end
    if #couponValueList > 0 then
        for i = 1, #couponValueList do
            for x = 1, couponValueList[i][3] do
                if price >= couponValueList[i][2] then
                    price = price - couponValueList[i][2]
                    if #retCouponList > 0 then
                        local flag = 0
                        for y = 1, #retCouponList do
                            if retCouponList[y][1] == couponValueList[i][1] then
                                retCouponList[y][3] = retCouponList[y][3] + 1
                                flag = 1
                                break
                            end
                        end
                        if flag == 0 then
                            retCouponList[#retCouponList + 1] = { couponValueList[i][1], couponValueList[i][2], 1 }
                        end
                    else
                        retCouponList[#retCouponList + 1] = { couponValueList[i][1], couponValueList[i][2], 1 }
                    end
                end
            end
        end
    end

    return price, retCouponList
end

----EVENT_1804_TRANSCEND_REINFORCE
-- function SCR_EVENT_REINFORCE_DISCOUNT_CHECK(pc)
--    if GetServerNation() ~= "KOR" then
--        return 'NO'
--    end
--
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--
--    if IsServerSection(pc) ~= 1 then
--        local serverTime = imcTime.GetCurdateNumber()
--        year = 2000 + tonumber(string.sub(serverTime,1, 2))
--        month = tonumber(string.sub(serverTime,3, 4))
--        day = tonumber(string.sub(serverTime,5, 6))
--    end
--
--    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--
--    if nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 19) and nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 5, 3) then
--        return 'YES'
--    end
--
--    return 'NO'
-- end



function SCR_TABLE_TYPE_SEPARATE(inputTable, typeTable)
    local index = 1
    local tempTable = { }
    local inputType
    while 1 do
        if index > #inputTable then
            break
        end
        if table.find(typeTable, inputTable[index]) > 0 then
            tempTable[inputTable[index]] = { }
            inputType = inputTable[index]
        elseif inputType ~= nil then
            tempTable[inputType][#tempTable[inputType] + 1] = inputTable[index]
        end

        index = index + 1
    end
    local retTable = { }
    for i = 1, #typeTable do
        retTable[typeTable[i]] = tempTable[typeTable[i]]
    end

    return retTable
end

function IS_IN_EVENT_MAP(pc)
    if GetZoneName(pc) == 'd_castle_agario' then
        return true;
    end

    return false;
end

-- 일반 파티 경험치 계산
function NORMAL_PARTY_EXP_BOUNS_RATE(partyMemberCount, pc)
    -- 1인 100. 2인 190(95), 3인 270(90), 4인 340(85), 5인 400(80)
    -- 대문자로 선언되어있는 변수는 다 sharedconst_system.xml에 있는 값임.
    local expUpRatio = 1;

    -- 파티인원수에 대한 계산
    if partyMemberCount > 1 then
        expUpRatio = expUpRatio +((1 -(partyMemberCount * PARTY_EXP_BONUS)) *(partyMemberCount - 1));
    end

    return expUpRatio;
end

-- 인던 자동매칭 경험치 계산
function INDUN_AUTO_MATCHING_PARTY_EXP_BOUNS_RATE(partyMemberCount)
    -- 한명당 120프로씩 더 준다. 단! 1명일 땐, 경험치 보너스 없다.
    local expUpRatio = NORMAL_PARTY_EXP_BOUNS_RATE(partyMemberCount);

    if partyMemberCount > 1 then
        expUpRatio = expUpRatio +(partyMemberCount * INDUN_AUTO_FIND_EXP_BONUS);
    end

    return expUpRatio;
end

function GET_INDUN_SILVER_RATIO(myLevel, indunLevel)
    local pcLv = myLevel;
    local dungeonLv = indunLevel;
    local value = 1;

    local standardLevel = 30;
    local levelGap = math.abs(pcLv - dungeonLv);

    if levelGap > standardLevel then
    	local penaltyRatio = 0.02;	-- 저레벨 인던 사냥 시 실버 페널티--
        local lvRatio = 1 -((levelGap - standardLevel) * penaltyRatio);
        value = value * lvRatio;
    end

    if value < 0 then
        value = 0;
    end

    return value;
end

function IMCLOG_CONTENT_SPACING(tag, ...)
    local logMsg = "";
    for i, v in ipairs { ...} do
        logMsg = logMsg .. " " .. tostring(v);
    end

    ImcContentLog(tag, logMsg)
end

function SCR_TEXT_HIGHLIGHT(dialogClassName, text)
    local targetZoneWordList = { }
    local targetMonWordList = { }

    local exceptList, exceptcnt = GetClassList("DialogExceptionText");
    local exceptdialog = { }
    local exceptword = { }
    for i = 0, exceptcnt - 1 do
        local cls = GetClassByIndexFromList(exceptList, i);
        local clstype = TryGetProp(cls, 'Type', 'None')
        local clsword = TryGetProp(cls, 'Word', 'None')
        local clsdialog = TryGetProp(cls, 'Dialog', 'None')
        if clstype == 'WORD' then
            exceptdialog[#exceptdialog + 1] = clsdialog
            exceptword[#exceptword + 1] = SCR_STRING_CUT(clsword)
        end
    end

    local exceptIndex = table.find(exceptdialog, dialogClassName)

    --    if #TEXT_ZONENAMELIST == 0 then
    --        local maplist, mapcnt  = GetClassList("Map");
    --        for i = 0 , mapcnt - 1 do
    --            local cls = GetClassByIndexFromList(maplist, i);
    --            local zoneName = TryGetProp(cls,'Name', 'None')
    --            if zoneName ~= 'None' and table.find(TEXT_ZONENAMELIST, zoneName) == 0 then
    --                TEXT_ZONENAMELIST[#TEXT_ZONENAMELIST + 1] = zoneName
    --            end
    --        end
    --
    --        local arealist, areacnt  = GetClassList("Map_Area");
    --        for i = 0 , areacnt - 1 do
    --            local cls = GetClassByIndexFromList(arealist, i);
    --            local zoneName = TryGetProp(cls,'Name', 'None')
    --            if zoneName ~= 'None' and table.find(TEXT_ZONENAMELIST, zoneName) == 0 then
    --                TEXT_ZONENAMELIST[#TEXT_ZONENAMELIST + 1] = zoneName
    --            end
    --        end
    --    end

    local maxi1 = #TEXT_ZONENAMELIST
    for i = 1, maxi1 do
        local findIndex = string.find(text, TEXT_ZONENAMELIST[i])
        if findIndex ~= nil then
            local beforeChar = string.sub(text, findIndex - 1, findIndex - 1)
            local beforeNum = string.byte(beforeChar)
            if findIndex == 1 or beforeChar == ' ' or(beforeNum >= 33 and beforeNum <= 47) or(beforeNum >= 58 and beforeNum <= 64) or(beforeNum >= 91 and beforeNum <= 96) or(beforeNum >= 123 and beforeNum <= 126) then
                if exceptIndex == 0 then
                    targetZoneWordList[#targetZoneWordList + 1] = TEXT_ZONENAMELIST[i]
                else
                    if table.find(exceptword[exceptIndex], TEXT_ZONENAMELIST[i]) == 0 then
                        targetZoneWordList[#targetZoneWordList + 1] = TEXT_ZONENAMELIST[i]
                    end
                end
            end
        end
    end

    --    if #TEXT_MONNAMELIST == 0 then
    --        local monlist, moncnt  = GetClassList("Monster");
    --        for i = 0 , moncnt - 1 do
    --            local cls = GetClassByIndexFromList(monlist, i);
    --            local monName = TryGetProp(cls,'Name', 'None')
    --            if monName ~= 'None' and table.find(TEXT_ZONENAMELIST, monName) == 0 then
    --                TEXT_MONNAMELIST[#TEXT_MONNAMELIST + 1] = monName
    --            end
    --        end
    --    end


    local maxi2 = #TEXT_MONNAMELIST
    for i = 1, maxi2 do
        local findIndex = string.find(text, TEXT_MONNAMELIST[i])
        if findIndex ~= nil then
            local beforeChar = string.sub(text, findIndex - 1, findIndex - 1)
            local beforeNum = string.byte(beforeChar)
            if findIndex == 1 or beforeChar == ' ' or(beforeNum >= 33 and beforeNum <= 47) or(beforeNum >= 58 and beforeNum <= 64) or(beforeNum >= 91 and beforeNum <= 96) or(beforeNum >= 123 and beforeNum <= 126) then
                if exceptIndex == 0 then
                    targetMonWordList[#targetMonWordList + 1] = TEXT_MONNAMELIST[i]
                else
                    if table.find(exceptword[exceptIndex], TEXT_MONNAMELIST[i]) == 0 then
                        targetMonWordList[#targetMonWordList + 1] = TEXT_MONNAMELIST[i]
                    end
                end
            end
        end
    end

    if #targetZoneWordList > 0 then
        for i = 1, #targetZoneWordList - 1 do
            for r = i + 1, #targetZoneWordList do
                if string.len(targetZoneWordList[i]) < string.len(targetZoneWordList[r]) then
                    local tempStr = targetZoneWordList[i]
                    targetZoneWordList[i] = targetZoneWordList[r]
                    targetZoneWordList[r] = tempStr
                end
            end
        end
    end

    if #targetMonWordList > 0 then
        for i = 1, #targetMonWordList - 1 do
            for r = i + 1, #targetMonWordList do
                if string.len(targetMonWordList[i]) < string.len(targetMonWordList[r]) then
                    local tempStr = targetMonWordList[i]
                    targetMonWordList[i] = targetMonWordList[r]
                    targetMonWordList[r] = tempStr
                end
            end
        end
    end

    if #targetZoneWordList > 0 then
        for i = 1, #targetZoneWordList do
            text = string.gsub(text, targetZoneWordList[i], '{#003399}' .. targetZoneWordList[i] .. '{/}')
        end
    end

    if #targetMonWordList > 0 then
        for i = 1, #targetMonWordList do
            text = string.gsub(text, targetMonWordList[i], '{#003399}' .. targetMonWordList[i] .. '{/}')
        end
    end

    return text
end

function GET_DATE_BY_DATE_STRING(dateString) -- yyyy-mm-dd hh:mm:ss
    local tIndex = string.find(dateString, ' ');
    if tIndex == nil then
        return -1;
    end
    local dateStr = string.sub(dateString, 0, tIndex - 1);
    local firstHipenIndex = string.find(dateString, '-');
    local secondHipenIndex = string.find(dateString, '-', firstHipenIndex + 1);
    local year = tonumber(string.sub(dateStr, 0, firstHipenIndex - 1));
    local month = tonumber(string.sub(dateStr, firstHipenIndex + 1, secondHipenIndex - 1));
    local day = tonumber(string.sub(dateStr, secondHipenIndex + 1));

    local hourStr = string.sub(dateString, tIndex + 1);
    local firstColonIndex = string.find(hourStr, ':');
    local secondColonIndex = string.find(hourStr, ':', firstColonIndex + 1);
    local hour = tonumber(string.sub(hourStr, 0, firstColonIndex - 1));
    local minute = tonumber(string.sub(hourStr, firstColonIndex + 1, secondColonIndex - 1));
    local second = tonumber(string.sub(hourStr, secondColonIndex + 1));

    return year, month, day, hour, minute, second;
end

function GET_INTERSECT_TABLE_BY_VALUE(table1, table2)
    local hash2 = { };
    for k2, v2 in pairs(table2) do
        hash2[v2] = 1;
    end

    local ret = { };
    for k1, v1 in pairs(table1) do
        if hash2[v1] == 1 then
            ret[#ret + 1] = v1;
            hash2[v1] = nil;
        end
    end
    return ret;
end

function CALC_CENTER_ALIGN_POSITION(index, count, len, dist, bgLen)
    local bgOffset = bgLen / 2;
    local firstOffset =(len * count / 2) + math.floor(count / 2) * dist;
    return bgOffset - firstOffset +(len + dist) *(index - 1);
end 

function CALC_LIST_LINE_BREAK(lvList, maxCol, breakedMaxCol)
    if maxCol < breakedMaxCol then
        return;
    end
    local breakedList = { }
    breakedList[#breakedList + 1] = { }

    local col = 1
    for i = 1, #lvList do
        local remainCount = #lvList - i;
        if col + remainCount > maxCol and col > breakedMaxCol then
            breakedList[#breakedList + 1] = { }
            col = 1;
        else
            col = col + 1
        end
        local curRow = breakedList[#breakedList]
        curRow[#curRow + 1] = lvList[i];
    end

    return breakedList
end

function SCR_MAIN_QUEST_WARP_CHECK(pc, questState, questIES, questName)
    if questName == nil and questIES == nil then
        return 'NO'
    end
    if questIES == nil then
        questIES = GetClass('QuestProgressCheck', questName)
    end

    if questName == nil then
        questName = questIES.ClassName
    end

    if questState == nil then
        if IsServerSection(pc) == 1 then
            questState = SCR_QUEST_CHECK(pc, questName)
        else
            questState = SCR_QUEST_CHECK_C(pc, questName)
        end
    end

    if questState ~= 'POSSIBLE' then
        return 'NO'
    end

    if GetClass('mainquest_startnpcwarp', questName) == nil then
        return 'NO'
    end

    if IsServerSection(pc) ~= 1 and GET_QUESTINFO_PC_FID() ~= 0 then
        return 'NO'
    end

    local sObj
    if IsServerSection(pc) == 1 then
        sObj = GetSessionObject(pc, 'ssn_klapeda')
    else
        pc = GetMyPCObject()
        sObj = GetSessionObject(pc, 'ssn_klapeda')
    end

    if sObj == nil then
        return 'NO'
    end

    local clsList, cnt = GetClassList("mainquest_startnpcwarp");
    for i = 0, cnt - 1 do
        local tQuest = GetClassByIndexFromList(clsList, i);
        local tQuestState
        local preQuestState = {}
        local preQuestStateCheck = {}
        if IsServerSection(pc) == 1 then
            tQuestState = SCR_QUEST_CHECK(pc, tQuest.ClassName)
            if tQuest.CheckQuestName ~= "None" then
                local sList1 = StringSplit(tQuest.CheckQuestName, ';')
                local sList2 = StringSplit(tQuest.CheckQuestState, ';')
                if #sList1 > 0 then
                    for j = 1, #sList1 do
                        preQuestState[#preQuestState+1] = SCR_QUEST_CHECK(pc, sList1[j])
                        preQuestStateCheck[#preQuestStateCheck+1] = sList2[j]
                    end
                end
            end
        else
            if pc.Lv == nil then
                pc = GetMyPCObject()
            end
            tQuestState = SCR_QUEST_CHECK_C(pc, tQuest.ClassName)
            if tQuest.CheckQuestName ~= "None" then
                local sList1 = StringSplit(tQuest.CheckQuestName, ';')
                local sList2 = StringSplit(tQuest.CheckQuestState, ';')
                if #sList1 > 0 then
                    for j = 1, #sList1 do
                        preQuestState[#preQuestState+1] = SCR_QUEST_CHECK_C(pc, sList1[j])
                        preQuestStateCheck[#preQuestStateCheck+1] = sList2[j]
                    end
                end
            end
        end

        if tQuestState == 'POSSIBLE' then
            local tquestIES = GetClass('QuestProgressCheck', tQuest.ClassName)
                if tquestIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and tquestIES.QStartZone ~= sObj.QSTARTZONETYPE then
                elseif tQuest.ClassName == questName then
                if tQuest.CheckQuestName ~= "None" then
                    if #preQuestState > 1 then
                        local flag = 0
                        for j = 1, #preQuestState do
                            if preQuestState[j] == preQuestStateCheck[j] then
                                flag = flag + 1
                            end
                        end
                        if flag > 0 then
                            return 'YES'
                        else
                            return 'NO'
                        end
                    else
                        if preQuestState[1] == preQuestStateCheck[1] then
                    return 'YES'
                        else
                            return 'NO'
                        end
                    end
                else
                    return 'YES'
                end
                elseif tquestIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and tquestIES.QStartZone == sObj.QSTARTZONETYPE then
                    return 'NO'
                end
        end
        if tQuest.ClassName == questName then
            if tQuest.CheckQuestName ~= "None" then
                if #preQuestState > 1 then
                    local flag = 0
                    for j = 1, #preQuestState do
                        if preQuestState[j] == preQuestStateCheck[j] then
                            flag = flag + 1
                        end
                    end
                    if flag > 0 then
                        return 'YES'
            else
                return 'NO'
            end
                else
                    if preQuestState[1] == preQuestStateCheck[1] then
                        return 'YES'
                    else
                        return 'NO'
                    end
        end
--                if preQuestState == preQuestStateCheck then
--                print(questName, tQuest.ClassName, 'in')
--                    return 'YES'
--                else
--                    return 'NO'
--                end
            else
            return 'YES'
        end
    end
    end
    return 'NO'
end

function IS_KANNUSHI_GENDER_CHANGE_FLAG(pc, targetJobClassName)
    if pc == nil then
        return 'NO'
    end

    local jobclass = 'Char4_18'

    if IsServerSection(pc) == 1 then
        local pcEtc = GetETCObject(pc)
        if targetJobClassName == jobclass then
            return 'YES'
        end
    else
        local myPCetc = GetMyEtcObject();
        if targetJobClassName == jobclass then
            return 'YES'
        end
    end

    return 'NO'
end



function SCR_ZONE_KEYWORD_CHECK(zoneName, keyword)
    if zoneName == nil or keyword == nil then
        return "NO";
    end

    local mapClass = GetClass("Map", zoneName);
    local mapKeyWord = TryGetProp(mapClass, "Keyword", "None");
    if mapKeyWord == "None" or mapKeyWord == "" then
        return "NO";
    end

    local keyWordList = SCR_STRING_CUT(mapKeyWord, ";");
    if keyWordList ~= nil and #keyWordList >= 1 then
        local index = table.find(keyWordList, keyword);
        if index ~= 0 then
            return "YES";
        end
    end

    return 'NO';
end

function SCR_CHECK_MONSTER_KEYWORD(mon, keyword)
    if keyword == nil then
        return "NO"
    end

    local monKeyword = TryGetProp(mon, "Keyword", "None");
    if monKeyword == "None" or monKeyword == "" then
        return "NO";
    end

    local keywordList = SCR_STRING_CUT(monKeyword, ";");
    if keywordList ~= nil and #keywordList >= 1 then
        local index = table.find(keywordList, keyword);
        if index ~= 0 then
            return "YES";
        end
    end

    return "NO";
end

function SCR_GET_MONSTER_KEYWORD(mon)
    local monKeyword = TryGetProp(mon, "Keyword", "None");
    if monKeyword == "None" or monKeyword == "" then
        return nil;
    end

    local keywordList = SCR_STRING_CUT(monKeyword, ";");

    return keywordList;
end


function SCR_DATE_HOUR_TO_YWEEK2_BASIC_2000(yy, mm, dd, hour, firstWday, firstHour, secondWday, secondHour)
    local yday2000 = SCR_DATE_TO_YDAY_BASIC_2000(yy, mm, dd)
    local accDay1 = yday2000
    local accDay2 = yday2000

    if hour < firstHour then
        accDay1 = accDay1 - 1
    end

    if hour < secondHour then
        accDay2 = accDay2 - 1
    end

    local result = 0
    local result1 = math.floor((accDay1 + 6 - firstWday) / 7) + 1
    local result2 = math.floor((accDay2 + 6 - secondWday) / 7) + 1

    if result1 > result2 then
        result = result2 * 2
    elseif result1 == result2 then
        result = result2 * 2 - 1
    end

    return result
end


function JOB_NAKMUAY_PRE_CHECK(pc, jobCount)
    if jobCount == nil then
        jobCount = GetTotalJobCount(pc);
    end
    if jobCount >= 2 then
        local pcEtc
        if IsServerSection() == 0 then
            pcEtc = GetMyEtcObject();
        else
            pcEtc = GetETCObject(pc);
        end

        if pcEtc ~= nil then
            local value = TryGetProp(pcEtc, 'HiddenJob_Char1_20', 0)
            if value == 300 or IS_KOR_TEST_SERVER() == true then
                return 'YES'
            end
        end
    end

    return 'NO'
end


function JOB_RUNECASTER_PRE_CHECK(pc, jobCount)
    if jobCount == nil then
        jobCount = GetTotalJobCount(pc);
    end
    if jobCount >= 2 then
        local pcEtc
        if IsServerSection() == 0 then
            pcEtc = GetMyEtcObject();
        else
            pcEtc = GetETCObject(pc);
        end

        if pcEtc ~= nil then
            local value = TryGetProp(pcEtc, 'HiddenJob_Char2_17', 0)
            if value == 300 or IS_KOR_TEST_SERVER() == true then
                return 'YES'
            end
        end
    end

    return 'NO';
end


function JOB_APPRAISER_PRE_CHECK(pc, jobCount)
    if jobCount == nil then
        jobCount = GetTotalJobCount(pc);
    end
    if jobCount >= 2 then
        local pcEtc
        if IsServerSection() == 0 then
            pcEtc = GetMyEtcObject();
        else
            pcEtc = GetETCObject(pc);
        end

        if pcEtc ~= nil then
            local value = TryGetProp(pcEtc, 'HiddenJob_Char3_13', 0)
            if value == 300 or IS_KOR_TEST_SERVER() == true then
                return 'YES'
            end
        end
    end

    return 'NO'
end


function JOB_MIKO_PRE_CHECK(pc, jobCount)
    if jobCount == nil then
        jobCount = GetTotalJobCount(pc);
    end
    if jobCount >= 2 then
        local pcEtc
        if IsServerSection() == 0 then
            pcEtc = GetMyEtcObject();
        else
            pcEtc = GetETCObject(pc);
        end

        if pcEtc ~= nil then
            local value = TryGetProp(pcEtc, 'HiddenJob_Char4_18', 0)
            if value == 300 or IS_KOR_TEST_SERVER() == true then
                return 'YES'
            end
        end
    end

    return 'NO'
end


function JOB_SHINOBI_PRE_CHECK(pc, jobCount)
    if jobCount == nil then
        jobCount = GetTotalJobCount(pc);
    end
    if jobCount >= 2 then
        local pcEtc
        if IsServerSection() == 0 then
            pcEtc = GetMyEtcObject();
        else
            pcEtc = GetETCObject(pc);
        end

        if pcEtc ~= nil then
            local value = TryGetProp(pcEtc, 'HiddenJob_Char5_6', 0)
            if value == 300 or IS_KOR_TEST_SERVER() == true then
                return 'YES'
            end
        end
    end

    return 'NO'
end

function GET_ACCOUNT_WAREHOUSE_EXTEND_PRICE(aObj, taxRate)
    local slotDiff = aObj.AccountWareHouseExtend;
    local price = ACCOUNT_WAREHOUSE_EXTEND_PRICE;
    if slotDiff > 0 then
        if slotDiff >= tonumber(ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT) then
            return;
        end
        if slotDiff < 4 then
            price = price *(math.pow(2, slotDiff))
        else
            -- Form the fifth slot, it will be fixde at 2000000 silver
            price = price * 10
        end
    end

    if taxRate ~= nil then
        price = tonumber(CALC_PRICE_WITH_TAX_RATE(price, taxRate))
    end
    return price
end

function GET_COMPANION_PRICE(petCls, pc, taxRate)
    if petCls.SellPrice == "None" then
        return nil
    end

    local sellPrice = _G[petCls.SellPrice];
    sellPrice = sellPrice(petCls, pc);
    if taxRate ~= nil then
        sellPrice = tonumber(CALC_PRICE_WITH_TAX_RATE(sellPrice, taxRate))
    end
    return sellPrice
end

-- function JOB_CANNONEER_PRE_CHECK(pc, jobCount)
--    if jobCount == nil then
--        jobCount = GetTotalJobCount(pc);
--    end
-- if jobCount >= 2 then
--        return 'YES';
--    end
--
--    return 'NO';
-- end
--
--
-- function JOB_MUSKETEER_PRE_CHECK(pc, jobCount)
--    if jobCount == nil then
--        jobCount = GetTotalJobCount(pc);
--    end
-- if jobCount >= 2 then
--        return 'YES';
--    end
--
--    return 'NO';
-- end


function GET_TIMESTAMP_TO_COUNTDOWN_DATESTR(timestamp, prop)

    if prop == nil then
        prop = { }
    end

    local day = math.floor(timestamp / 86400)
    local remainder =(timestamp % 86400)
    local hour = math.floor(remainder / 3600)
    local remainder =(timestamp % 3600)
    local min = math.floor(remainder / 60)
    local sec =(remainder % 60)

    local countdownStr = ""

    if prop.noDay == nil then
        if day > 0 then
            countdownStr = countdownStr .. day .. ClMsg("UI_Day") .. " ";
        end
    end

    if prop.noHour == nil then
        if hour > 0 then
            countdownStr = countdownStr .. hour .. ClMsg("UI_Hour") .. " ";
        end
    end

    if prop.noMin == nil then
        if min > 0 then
            countdownStr = countdownStr .. min .. ClMsg("UI_Min") .. " ";
        end
    end

    if prop.noSec == nil then
        if sec > 0 then
            countdownStr = countdownStr .. sec .. ClMsg("UI_Sec") .. " ";
        end
    end

    return countdownStr

end

function GET_MODIFIED_PROPERTIES_STRING(item, invitem)
    local str = GetModifiedPropertiesString(item);
    str = str .. '#';
    if IsServerSection() == 1 then
        local additionalStr = GetAdditionalModifiedString(item);
        if additionalStr ~= nil then
            str = str .. additionalStr;
        end
    else
        local itemIdx = GetIESID(item);
        if invitem == nil then
            invitem = GET_PC_ITEM_BY_GUID(itemIdx);
        end
        str = str .. invitem:GetAdditionalModifiedString();
    end
    return str;
end