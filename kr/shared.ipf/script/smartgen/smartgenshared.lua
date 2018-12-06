--smartgenshared.lua

function INIT_SMARTGEN(sObj, zonename)
	sObj.Tendency_Flag = 'YES'

    local smartgen_main = GetClass('SmartGen_'..zonename, 'Main')
    if smartgen_main == nil then
        sObj.ZoneGenPoint = 0;
    else
        sObj.ZoneGenPoint = 300;
    end

    if sObj.ZoneID ~= GetClassNumber('Map', zonename, 'ClassID') then
        sObj.NormalAccrue = 0
        sObj.SpecialAccrue = 0
        sObj.HideAccrue = 0
        sObj.TreasureAccrue = 0
        
        sObj.ZoneID = GetClassNumber('Map', zonename, 'ClassID');
        
        SCR_SMARTGEN_GENFLAG_RESTART(sObj)
        
        SCR_SMARTGEN_STOUP_USE_RESTART(sObj)
        
        SCR_SMARTGEN_SCROLLLOCKGENFLAG_RESTART(sObj)
        
    end
    sObj.ZoneEnter_Start = 0;


end

function SCR_SMARTGEN_GENFLAG_RESTART(sObj)
    local i
    
    for i = 1, CON_SMARTGEN_GENFLAG_MAX_INDEX do
        local beforeValue = TryGetProp(sObj, 'GenFlag'..i)
        if beforeValue ~= nil and beforeValue ~= 'None' then
            sObj['GenFlag'..i] = 'None'
        end
    end
end

function SCR_SMARTGEN_STOUP_USE_RESTART(sObj)
    local i
    
    for i = 1, 10 do
        local beforeValue = TryGetProp(sObj, 'STOUP_USE'..i)
        if beforeValue ~= nil and beforeValue ~= 0 then
            sObj['STOUP_USE'..i] = 0
        end
    end
end

function SCR_SMARTGEN_SCROLLLOCKGENFLAG_RESTART(sObj)
    local i
    
    for i = 1, 100 do
        local beforeValue = TryGetProp(sObj, 'ScrollLockGenFlag'..i)
        if beforeValue ~= nil and beforeValue ~= 0 then
            sObj['ScrollLockGenFlag'..i] = 0
        end
    end
end

function SCR_QUEST_LOCATION_INFO(self, zonename, questIES, posx,posy,posz)
    local locationList = SCR_STRING_CUT_SPACEBAR(questIES.ProgLocation)
    local posInfo = {}
    
    if #locationList > 1 then
        for i = 1, #locationList do
            if tonumber(locationList[i+1]) ~= nil then
                if zonename == locationList[i] then
                    local distance = SCR_POINT_DISTANCE(posx,posz,locationList[i+1],locationList[i+3])
                    if distance <= tonumber(locationList[i+4]) then
                        posInfo[1] = tonumber(locationList[i+1])
                        posInfo[2] = tonumber(locationList[i+2])
                        posInfo[3] = tonumber(locationList[i+3])
                        posInfo[4] = tonumber(locationList[i+4])
                        return posInfo
                    end
                end
                i = i + 4
            else
                if zonename == locationList[i] then
                    local npcFunc = {'Dialog','Enter','Leave'}
                    for index = 1, 3 do
                        local dlgIESList = SCR_GET_XML_IES('GenType_'..zonename, npcFunc[index], locationList[i+1])
                        if #dlgIESList > 0 then
                            for x = 1, #dlgIESList do
                                local angdlgIESList = SCR_GET_XML_IES('Anchor_'..zonename, 'GenType', dlgIESList[x].GenType)
                                if #angdlgIESList > 0 then
                                    for y = 1, #angdlgIESList do
                                        local distance = SCR_POINT_DISTANCE(posx,posz,angdlgIESList[y].PosX,angdlgIESList[y].PosZ)
                                        if distance <= tonumber(locationList[i+2]) then
                                            posInfo[1] = tonumber(angdlgIESList[y].PosX)
                                            posInfo[2] = tonumber(angdlgIESList[y].PosY)
                                            posInfo[3] = tonumber(angdlgIESList[y].PosZ)
                                            posInfo[4] = tonumber(locationList[i+2])
                                            return posInfo
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                i = i + 2
            end
        end
    end
end

function SCR_LIB_ISENEMY_FACTION(self_faction, target_faction)
	local str = GetClass('Faction', self_faction);

	local words = SCR_STRING_CUT_SEMICOLON(str.HostileTo)
	for i = 1, #words do
		if target_faction == words[i] then
			return RESULT_OK;
		end
	end
	return RESULT_NO;
end

function SCR_GET_AROUND_MONGEN_ANCHOR(self, zonename, x, y, z, minrange, maxrange)
    local anchor_idspace = 'Anchor_'..zonename
    local class_list_anchor, class_count_anchor = GetClassList(anchor_idspace)
    local result = {}
    if class_count_anchor > 0 then
        for y = 0, class_count_anchor -1 do
            local classIES_anchor = GetClassByIndexFromList(class_list_anchor, y);
            
            if classIES_anchor ~= nil then
                local distance = SCR_POINT_DISTANCE(x, z, classIES_anchor.PosX, classIES_anchor.PosZ)
                if minrange > 0 or maxrange > 0 then
                    local flag = 0
                    if minrange == nil then
                        flag = 1
                    else
                        if minrange > 0 and distance >= minrange then
                            flag = 1
                        end
                    end
                    if flag == 1 then
                        if maxrange == nil then
                        else
                            if distance <= maxrange then
                            else
                                flag = 0
                            end
                        end
                    end
                    if flag == 1 then
                        result[#result +1] = classIES_anchor
                    end
                end
            end
        end
    end
    return result
end

function SCR_GET_AROUND_MONGEN_MONLIST(self, zonename, myFaction, range, x, y, z, monList,  returnType, minrange, maxrange)
    local gentype_idspace = 'GenType_'..zonename
    local anchor_idspace = 'Anchor_'..zonename
    local clsList, class_count = GetClassList(gentype_idspace);
    local gentype_list = {}
    local near_gentype_list = {}
    local result_mon_list = {}
    
    if class_count > 0 then
        for i = 0, class_count-1 do
            local classIES_gentype = GetClassByIndexFromList(clsList, i);
            if classIES_gentype.ArgStr1 ~= nil and string.find(classIES_gentype.ArgStr1, 'SmartGen') ~= nil then
                if SCR_LIB_ISENEMY_FACTION(myFaction, classIES_gentype.Faction) == 'YES' then
                    if monList ~= nil then
                        if table.find(monList, classIES_gentype.ClassType) > 0 then
                            gentype_list[#gentype_list + 1] = {}
                            gentype_list[#gentype_list][1] = classIES_gentype.ClassID;
                            gentype_list[#gentype_list][2] = classIES_gentype.GenType;
                            gentype_list[#gentype_list][3] = classIES_gentype.GenRange
                        end
                    else
                        gentype_list[#gentype_list + 1] = {}
                        gentype_list[#gentype_list][1] = classIES_gentype.ClassID;
                        gentype_list[#gentype_list][2] = classIES_gentype.GenType;
                        gentype_list[#gentype_list][3] = classIES_gentype.GenRange
                    end
                end
            end
        end
        
        if #gentype_list > 0 then
            for i = 1, #gentype_list do
                local class_list_anchor, class_count_anchor = GetClassList(anchor_idspace)

                if class_count_anchor > 0 then
                   local near_gentype_list_count = #near_gentype_list
                    for y = 0, class_count_anchor -1 do
                        local classIES_anchor = GetClassByIndexFromList(class_list_anchor, y);
                        
                        if classIES_anchor ~= nil then
                            if classIES_anchor.GenType == gentype_list[i][2] then
                                local distance = SCR_POINT_DISTANCE(x, z, classIES_anchor.PosX, classIES_anchor.PosZ)
                                if range > 0 then
                                    if distance <= range + gentype_list[i][3] then                -- ????? ??????? ?? ???? ???? ???????? u?
                                        near_gentype_list[#near_gentype_list +1] = gentype_list[i]
                                    end
                                elseif minrange > 0 or maxrange > 0 then
                                    local flag = 0
                                    if minrange == nil then
                                        flag = 1
                                    else
                                        if minrange > 0 and distance >= minrange then
                                            flag = 1
                                        end
                                    end
                                    if flag == 1 then
                                        if maxrange == nil then
                                        else
                                            if distance <= maxrange then
                                            else
                                                flag = 0
                                            end
                                        end
                                    end
                                    if flag == 1 then
                                        near_gentype_list[#near_gentype_list +1] = gentype_list[i]
                                        near_gentype_list[#near_gentype_list][3] = distance
                                    end
                                else
                                    if distance <= 150 + gentype_list[i][3] then                        -- PC?? ???? ????? ?? ?????? ??????? u?
                                        if #near_gentype_list == near_gentype_list_count then
                                            near_gentype_list[#near_gentype_list +1] = gentype_list[i]
                                            near_gentype_list[#near_gentype_list][3] = distance
                                        elseif near_gentype_list[ near_gentype_list_count + 1][3] >= distance then
                                            near_gentype_list[near_gentype_list_count + 1] = gentype_list[i]
                                            near_gentype_list[near_gentype_list_count + 1][3] = distance
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if #near_gentype_list > 0 then
            if returnType == 'IES' then
                for i = 1, #near_gentype_list do
                    local tar_class = GetClassByNumProp(gentype_idspace, 'ClassID', near_gentype_list[i][1])
                    result_mon_list[#result_mon_list + 1] = tar_class
                end
                
                return result_mon_list
            else
                for i = 1, #near_gentype_list do
                    local tar_class = GetClassByNumProp(gentype_idspace, 'ClassID', near_gentype_list[i][1])
                    result_mon_list[#result_mon_list + 1] = {}
                    result_mon_list[#result_mon_list][1] = tar_class.ClassType
                    result_mon_list[#result_mon_list][2] = tar_class.Name
                    if GetPropType(tar_class, 'Tactics') ~= nil then
                        result_mon_list[#result_mon_list][3] = tar_class.Tactics
                    end
                    if GetPropType(tar_class, 'BTree') ~= nil then
                        result_mon_list[#result_mon_list][4] = tar_class.BTree
                    end
                    result_mon_list[#result_mon_list][5] = tar_class.Lv
                    result_mon_list[#result_mon_list][6] = tar_class.Faction
                    result_mon_list[#result_mon_list][7] = 'None'
                    result_mon_list[#result_mon_list][8] = tar_class.SimpleAI
                end
                
                if #result_mon_list > 0 then
                    return result_mon_list
                end
            end
        end
        
    end
end
                
                