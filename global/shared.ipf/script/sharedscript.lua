

function IMC_FATAL(code, stringinfo)
	imclog("Fatal",code,stringinfo)
end

function IMC_ERROR(code, stringinfo)
	imclog("Error",code,stringinfo)
end

function IMC_WARNING(code, stringinfo)
	imclog("Warning",code,stringinfo)
end

function IMC_INFO(code, stringinfo)
	imclog("Info",code,stringinfo)
end

function IMC_NORMAL_INFO(stringinfo)
	imclog("Info","ERRCODE_INFO_NORMAL", stringinfo)
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

	local x,y,z,mapname,uiname;
	
	for i = 0, 5 do

		local divStart, divEnd = string.find(stringpos, "/");
		if divStart == nil then
			uiname = stringpos
			break;
		end

		local divstringpos = string.sub(stringpos, 1, divStart-1);
		
		if i == 0 then
			mapname = divstringpos
		elseif i == 1 then
			x = divstringpos
		elseif i == 2 then
			y = divstringpos
		elseif i == 3 then
			z = divstringpos
		end

		stringpos = string.sub(stringpos, divEnd +1, string.len(stringpos));
	end

	return mapname,x,y,z,uiname
end


function IS_NO_EQUIPITEM(equipItem) -- No_~ 시리즈 아이템인지.

	local clsName = equipItem.ClassName;

	if clsName == 'NoWeapon' or clsName == "NoHat" or clsName == "NoBody" or clsName == "NoOuter" or clsName == 'NoShirt' or clsName == 'NoArmband' or clsName == 'NoHair' then
		return 1;
	elseif clsName == 'NoPants' or clsName == "NoGloves" or clsName == "NoBoots" or clsName == "NoRing" or clsName == 'NoHelmet' or clsName == 'NoNeck'then
		return 1;
	end

	return 0;
end

function IS_HAVE_GEM(item)

	for i = 0, item.MaxSocket - 1 do
		
		local nowsocketitem = item['Socket_Equip_' .. i]

		if nowsocketitem ~= 0 then
			return 1;
		end		
	end

	return 0;
end

function GET_MAKE_SOCKET_PRICE(itemlv, curcnt)

	local clslist, cnt  = GetClassList("socketprice");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if cls.Lv == itemlv then
		    local priceRatio = (curcnt + 1) * (curcnt + 1);
			return cls.NewSocketPrice * priceRatio;
		end
	end

	return 0;

end

function GET_REMOVE_GEM_PRICE(itemlv)

	local clslist, cnt  = GetClassList("socketprice");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if cls.Lv == itemlv then
			return cls.RemoveSocketPrice
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
    local idspace = 'Anchor_'..zoneName
    local class_count = GetClassCount(idspace)
    
    if class_count == nil or class_count == 0 then
        return nil, 'zone'
    end
    
    local rand = IMCRandom(0, class_count)
    
    local classIES = GetClassByIndex(idspace, rand)
    
    if classIES ~= nil  then
        return classIES
    end
    
end

-- 테이블에서 특정 컬럼을 검색해서 리턴해준다
function SCR_TABLE_SEARCH_ITEM(list, target)
    local result = 'NO'
    local keyList = {}
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
    local keyList = {}
    
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
                
                if listSub1[3] ~= nil and (listSub1[3] == 'M' or listSub1[3] == 'F') then
                    if listSub1[3] ~= target2 then
                        flag = 1
                    end
                end
                
                if flag == 0 and targetJob ~= nil and targetJob ~= 'None' then
                    local classIES = GetClass('Job',targetJob)
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
                                if ishave ~= 1 then
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
        if GetPropType( sObj_quest, 'QuestInfoMaxCount'..index) == nil or sObj_quest['QuestInfoMaxCount'..index] == 0 then
            return 'NO_USE'
        elseif sObj_quest['QuestInfoValue'..index] >= sObj_quest['QuestInfoMaxCount'..index] then
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
    local result2 = SCR_GET_XML_IES('GenType_'..zone_name, column, value)
    if  result2 ~= nil and #result2 > 0 then
        local result3 = SCR_GET_XML_IES('Anchor_'..zone_name, 'GenType', result2[1].GenType)
        if result3 ~= nil and  #result3 > 0 then
            return result3
        end
    end
end


-- xml 중 특정 컬럼의 값과 일치/유사 한 IES 리스트를 찾아줌 (option 1이면 유사 값, 아니면 일치)
function SCR_GET_XML_IES(idspace, column_name, target_value, option)
    if idspace == nil then
		return;
	end

    if GetClassByIndex(idspace, 0) == nil then
		return;
	end

    local obj = GetClassByIndex(idspace, 0)
    if column_name == nil then
		return;
	end
    
	if GetPropType(GetClassByIndex(idspace, 0),column_name) == nil then    
		return;
	end

    local class_count = GetClassCount(idspace)
    local return_list = {}
        
    for y = 0, class_count -1 do
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
    local result = GetClassString('Job',jobclassname, 'Initial')
    
    if result == nil then
        result = GetClassString('Job','Char1_1', 'Initial')
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
    local temp_tb = {}
    
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
    local temp_tb = {}
    
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
            temp_tb[#temp_tb + 1] = {}
            temp_tb[#temp_tb][1] = tb[index3][1]
            temp_tb[#temp_tb][2] = tb[index3][2]
        end
    end
    
    return temp_tb
end

function SCR_DUPLICATION_SOLVE_IES(tb, column)
    local index1, index2, index3 = 0
    local temp_tb = {}
    local temp_tb2 = tb
    local list = {}
    
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

    local temp_table = {};
    local w;
    local i;
    for w in string.gmatch(a,"[^_]+") do
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

    local temp_table = {};
    local w;
    local i;
    for w in string.gmatch(a,"[^#]+") do
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

    local temp_table = {};
    local w;
    local i;
    for w in string.gmatch(a,"[^;]+") do
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
    local temp_table = {};
    local w;
    local i;
    for w in string.gmatch(a,"[^:]+") do
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

    local temp_table = {};
    local w;
    local i;
    for w in string.gmatch(a,"[^,]+") do
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

    local temp_table = {};
    local w;
    local i;
    
    for w in string.gmatch(a,"[^ ]+") do
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
    local temp_table = {};
    local i;
    for i = 1, string.len(a) do
        if tonumber(string.sub(a,i,i)) ~= nil then
            temp_table[#temp_table + 1] = tonumber(string.sub(a,i,i))
        else
            temp_table[#temp_table + 1] = string.sub(a,i,i)
        end
    end
    
    return temp_table
end

function SCR_STRING_CUT(a,b)
    if a == nil then
        return
    end
    local temp_table = {};
    local w;
    
    if type(a) == table then
        for i = 1, #a do
            if b == nil then
                b = '/'
            end
            if string.find(a[i], b) ~= nil then
                for w in string.gmatch(a[i],"[^"..b.."]+") do
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
        for w in string.gmatch(a,"[^"..b.."]+") do
            if tonumber(w) ~= nil then
                temp_table[#temp_table + 1] = tonumber(w);
            else
                temp_table[#temp_table + 1] = w;
            end
        end
    end
    
    return temp_table;
end


function SCR_STRING_TO_TABLE(a)
    if a == nil then
        return a
    end
    local ret = {}
    for i = 1, string.len(a) do
        ret[#ret+ 1] = string.sub(a, i,i)
    end
    
    return ret
end

function SCR_DATE_TO_YDAY_BASIC_2000(yy, mm, dd)
    local days, monthdays, leapyears, nonleapyears, nonnonleapyears

    monthdays= { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

    leapyears=math.floor((yy-2000)/4);
    nonleapyears=math.floor((yy-2000)/100)
    nonnonleapyears=math.floor((yy-1600)/400)

    if ((math.mod(yy,4)==0) and mm<3) then
      leapyears = leapyears - 1
    end

    days= 365 * (yy-2000) + leapyears - nonleapyears + nonnonleapyears - 1

    c=1
    while (c<mm) do
      days = days + monthdays[c]
	c=c+1
    end

    days=days+dd+1

    return days
end

function SCR_DATE_TO_HOUR(year, yday, hour)
    year = tonumber(year)
    yday = tonumber(yday)
    hour = tonumber(hour)
    local ret = (SCR_DATE_TO_YDAY_BASIC_2000(year - 1, 12, 31) * 24) + ((yday - 1) * 24) + hour
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
    local ret = ((wday - 1) * 24) + hour
    return ret
end
function SCR_DAY_TO_HOUR(day, hour)
    day = tonumber(day)
    hour = tonumber(hour)
    local ret = ((day - 1) * 24) + hour
    return ret
end
function SCR_MONTH_TO_YDAY(year,month,day)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    
    local leapyears1 = year % 4
    local leapyears2 = year % 100
    local leapyears3 = year % 400
    
    local monthdays = {31,28,31,30,31,30,31,31,30,31,30,31}
    local retDay = 0
    if month > 1 then
        for i = 1, month - 1 do
            retDay = retDay + monthdays[i]
        end
    end
    
    if month >= 3 then
        if leapyears1 == 0 then
            if leapyears2 ~= 0 or (leapyears2 == 0 and leapyears3 == 0) then
                retDay = retDay + 1
            end
        end
    end
    
    local ret = retDay + day
    return ret
end

function SCR_MONTH_TO_HOUR(year,month,day,hour)
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)
    hour = tonumber(hour)
    
    local leapyears1 = year % 4
    local leapyears2 = year % 100
    local leapyears3 = year % 400
    
    local monthdays = {31,28,31,30,31,30,31,31,30,31,30,31}
    local retDay = 0
    if month > 1 then
        for i = 1, month - 1 do
            retDay = retDay + monthdays[i]
        end
    end
    
    if month >= 3 then
        if leapyears1 == 0 then
            if leapyears2 ~= 0 or (leapyears2 == 0 and leapyears3 == 0) then
                retDay = retDay + 1
            end
        end
    end
    
    local ret = ((retDay + day - 1) * 24)+hour
    return ret
end


function SCR_NUMTABLE_STRING(t)
    local ret = ''
    local count = #t
    for i = 1, count do
        ret = ret..tostring(t[i])
    end
    
    return ret
end

function IS_WARPNPC(zoneClassName, npcFunc)
    local getTypeIdspace = 'GenType_'..zoneClassName
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

	return (cls.Level * 4 + cnt * 2) * mul;

end



function GET_CLS_GROUP(idSpace, groupName)

	local clsList = GetClassList(idSpace);
	local retList = {};
	if clsList == nil then
		return retList;
	end
	
	local index = 1;
	
	while 1 do

		local name = groupName .. "_" .. index;
		local cls =	GetClassByNameFromList(clsList, name);
		if cls == nil then
			return retList;
		end
		
		retList[index] = cls;
		index = index + 1;			
	end

end


function GET_MAP_ACHI_NAME(mapCls)

	local name = ScpArgMsg("Auto_{Auto_1}_TamSaJa","Auto_1", mapCls.Name);
	local desc = ScpArgMsg("Auto_{Auto_1}_Jiyeogeul_MoDu_TamSaHayeossSeupNiDa.","Auto_1", mapCls.Name);
	local desctitle = name -- 임시. 나중에 맵 업적 달성시 보상및 칭호에 대한 데이터 세팅 이루어 지면 바꾸자.
	local reward = "None"
	return desc, name, desctitle, reward;

end

-- hgihLv : 파티원중 가장 높은 레벨, 파티가 아니거나 1인 파티면 0임
function GET_EXP_RATIO(myLevel, monLevel, highLv, monster)
    local pcLv = myLevel;
    local monLv = monLevel;
    local value = 1;
    if IsBuffApplied(monster, 'SuperExp') == 'YES' then
        value = 500;
    end
    
    if (pcLv - 4) > monLv then
        local lvRatio = 1 - ((pcLv - monLv - 4) * 0.05);
        value = value * lvRatio;
    end
    
    if monLv > (pcLv + 10) then
        local lvRatio = 1 - ((monLv - pcLv - 10) * 0.05);
        value = value * lvRatio;
        
        if value < 0.2 then
            value = 0.2;
        end
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

	for j = 1 , GUILDQUEST_MAX_ITEM do
		
		local ItemID = sObj["Step".. j + 4];
		if ItemID > 0 then
			return 1;
		end
	end

	return 0;
end

function IS_GULID_QUEST_ITEM(sObj, itemID)

	for j = 1 , GUILDQUEST_MAX_ITEM do
		local reqID = sObj["Step".. j + 4];
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
	--return 600 + 200 * curValue;

end

function GET_WIKI_ITEM_SET_COUNT(wiki)

	local setProp = geItemTable.GetSetByName( GetWikiTargetClassName(wiki) );
	local setCnt = setProp:GetItemCount();
	local curCnt = 0;		 
	for j = 0 , setCnt - 1 do
		local isGetItem = GetWikiBoolProp(wiki, "Get_" .. j);
		if isGetItem == 1 then
			curCnt = curCnt + 1;
		end
	end
	
	return curCnt, setCnt;
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
	control.DestTgtPlayDialogAnim(animName);
end

									-- 공용 라이브러리
--------------------------------------------------------------------------------------
-- 특정 문자를 기준으로 문자열을 잘라 테이블로 반환
function StringSplit(str, delimStr)
	local _tempStr = str;
	local _result = {};
	local _index = 1;

	while true do
		local _temp = string.find(_tempStr, delimStr);
		if _temp == nil then
			_result[_index] = _tempStr;
			break;
		else
			_result[_index] = string.sub(_tempStr, 0, _temp - 1);
		end
		
		_tempStr = string.sub(_tempStr, string.len(_result[_index]) + string.len(delimStr)+1, string.len(_tempStr));
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
		local conditionCount = #sList / 2;	-- 해당직업 전직조건 체크갯수
		
		local completeCount = 0;			-- 전직조건에 몇개나 만족하는지
		for j = 1, conditionCount do
			-- 직업가지고있고 요구레벨보다 높은지 체크
			for n=0, #haveJobNameList do
							
				if sList[j*2-1] == haveJobNameList[n] and tonumber(sList[j*2]) <= tonumber(haveJobGradeList[n]) then
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


function GET_2D_DIS(x1,y1,x2,y2)

	if x1 == nil or y1 == nil or x2 == nil or y2 == nil then
		return 0
	end

	local x = x1 - x2
	local y = y1 - y2
	
	return math.sqrt(x*x+y*y);
end

function NUM_KILO_CHANGE(num)
    local str = ""
    if num >= 1000 then
        while 1 do
            local remain = num % 1000
            if remain >= 100 then
                str = tostring(remain)..","..str
            elseif remain >= 10 then
                str = "0"..tostring(remain)..","..str
            else
                str = "00"..tostring(remain)..","..str
            end
            
            num = math.floor(num / 1000)
            if num < 1000 then
                str = tostring(num)..","..str
                break
            end
        end
    else
        str = tostring(num)
    end
    if string.sub(str,-1) == ',' then
        str = string.sub(str,1,-2)
    end
    return str
end

function SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestCount, chType)
    local ret = "HIDE"
    if questIES.PossibleUI_Notify == 'NO' then
        return ret, subQuestCount
    end
    local sobjIES = GET_MAIN_SOBJ();
    local abandonCheck = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES)
    local result = SCR_QUEST_CHECK_C(pc,questIES.ClassName)
    
    if chType == 'Set2' then
        ret = "OPEN"
        return ret, subQuestCount
    elseif (chType == 'ZoneMap' or chType == 'NPCMark') and abandonCheck == 'ABANDON/LIST' then
        ret = "OPEN"
        return ret, subQuestCount
    elseif questIES.QuestMode ~= "MAIN" and subQuestCount == 0 and result == 'POSSIBLE' and (questIES.StartMap == GetZoneName(pc) or table.find(SCR_STRING_CUT(questIES.StartMapListUI), GetZoneName(pc)) > 0) then
        ret = "OPEN"
        return ret, subQuestCount + 1
    elseif questIES.QuestMode ~= "MAIN" and questIES.Check_QuestCount > 0 and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'YES' then
        local sObj = GetSessionObject(pc, "ssn_klapeda")
        local result1 = SCR_QUEST_CHECK_MODULE_QUEST(pc, questIES, sObj)
        if result1 == "YES" then
            ret = "OPEN"
            return ret, subQuestCount
        end
    elseif questIES.QuestMode == "MAIN" or questIES.PossibleUI_Notify == 'UNCOND' then
        ret = "OPEN"
        return ret, subQuestCount
    end
    
    return ret, subQuestCount
end

function SCR_GET_ZONE_FACTION_OBJECT(zoneClassName, factionList, monRankList, respawnTime)
    local zoneGentype = 'GenType_'..zoneClassName
    local classCount = GetClassCount(zoneGentype)
    local factionList = SCR_STRING_CUT(factionList)
    local monRankList = SCR_STRING_CUT(monRankList)
    local i
    local monList = {}
    for i = 0 , classCount -1 do
        local gentypeIES = GetClassByIndex(zoneGentype, i)
        if gentypeIES ~= nil and table.find(factionList, gentypeIES.Faction) > 0 and gentypeIES.MaxPop > 0 then
            if respawnTime == nil or gentypeIES.RespawnTime <= respawnTime then
            local monIES = GetClass('Monster', gentypeIES.ClassType)
            if monIES ~= nil then
                local rankFlag = 'YES'
                if #monRankList > 0 and GetPropType(monIES,'MonRank') ~= nil and table.find(monRankList,monIES.MonRank) == 0 then
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
                        monList[#monList + 1] = {}
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