function SCR_SSN_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    local questIES = GetClass('QuestProgressCheck', sObj.QuestName)
    local returnFlag1 = true
    local returnFlag2 = true
    
	if questIES.Succ_Check_MonKill > 0 then
		returnFlag1 = false
	end
	
    if sObj.SSNMonKill ~= 'None' then
        returnFlag2 = false
    end
    
    if returnFlag1 == true and returnFlag2 == true then
        return
    end
    
    
    
    local layer = GetLayer(self)
    
    if sObj.CheckPos == 'YES' then
        local ret = SCR_QUEST_SESSIONOBJECT_CHECK_POS(self, sObj, argObj, questIES)
        if ret ~= 'YES' then
            return
        end
    end
    
    if questIES.Succ_Kill_Layer == 'Layer' and layer == 0 then
        return
    elseif questIES.Succ_Kill_Layer == 'Layer' and layer ~= 0 then
        local obj = GetLayerObject(GetZoneInstID(self), layer);
        if obj ~= nil then
            if obj.EventName ~= sObj.QuestName then
                return
            end
        end
    end
    
    if sObj.QuestName == 'None' or sObj.QuestName == nil then
        print(sObj.ClassName,'sObj.QuestName NIL');
        return;
    end
    local questIES = GetClass('QuestProgressCheck', sObj.QuestName);

    if questIES == nil then
        return;
    end
    
    local mon_count_check = sObj.KillMonster1 + sObj.KillMonster2 + sObj.KillMonster3 + sObj.KillMonster4 + sObj.KillMonster5 + sObj.KillMonster6
    
    local monInfo
    if sObj.SSNMonKill ~= 'None' then
        monInfo = SCR_STRING_CUT(sObj.SSNMonKill, ":")
    end
    
    if monInfo ~= nil then
        if #monInfo >= 3 and #monInfo % 3 == 0 and monInfo[1] ~= 'ZONEMONKILL' then
            local index
            local monIndexMax = #monInfo / 3
            for index = 1, 6 do
                if monIndexMax < index then
                    break
                else
                    if GetZoneName(self) == monInfo[index * 3] then
                        SCR_KILLMONSTER_CHECK(self, sObj, index, monInfo[index * 3 - 2], 'None', argObj.ClassName, argObj.Tactics)
                    end
                end
            end
        elseif monInfo[1] == 'ZONEMONKILL'  then
            for i = 1, 6 do
                if #monInfo - 1 >= i then
                    local index = i + 1
                    local zoneMonInfo = SCR_STRING_CUT(monInfo[index])
                    if GetZoneName(self) == zoneMonInfo[1] then
                        local targetMonList = SCR_GET_ZONE_FACTION_OBJECT(zoneMonInfo[1], 'Monster', 'Normal/Material/Elite', 120000)
                        for i2 = 1, #targetMonList do
                            if targetMonList[i2][1] == argObj.ClassName then
                                SCR_KILLMONSTER_CHECK(self, sObj, i, argObj.ClassName, 'None', argObj.ClassName, argObj.Tactics)
                                break
                            end
                        end
                    end
                else
                    break
                end
            end
        end
    else
        local index
        for index = 1, 6 do
            SCR_KILLMONSTER_CHECK(self, sObj, index, questIES['Succ_MonKillName'..index], questIES['Succ_MonTactics'..index], argObj.ClassName, argObj.Tactics)
        end
    end
    
    
    if mon_count_check ~= sObj.KillMonster1 + sObj.KillMonster2 + sObj.KillMonster3 + sObj.KillMonster4 + sObj.KillMonster5 + sObj.KillMonster6 then
        if string.find(sObj.HideNPC_Change,'UnHideNPC/') ~= nil then
    	    local result = SCR_QUEST_CHECK(self,sObj.QuestName)
    	    if result == 'SUCCESS' then
    	        local dlg_type, enter_name = string.match(sObj.HideNPC_Change,'(UnHideNPC/)(.+)')
                UnHideNPC(self, enter_name)
            end
        elseif string.find(sObj.HideNPC_Change,'HideNPC/') ~= nil then
            local result = SCR_QUEST_CHECK(self,sObj.QuestName)
    	    if result == 'SUCCESS' then
    	        local x, y, z = GetPos(self)
                local dlg_type, enter_name, move_x, move_z, move_speed = string.match(sObj.HideNPC_Change,'(HideNPC/)(.+)[/](.+)[/](.+)[/](.+)')
                HideNPC(self, enter_name, x + move_x, z + move_z, move_speed)
            end
    	end
	
        if questIES.QuestEndMode == 'SYSTEM' then
            local result = SCR_QUEST_CHECK(self,questIES.ClassName)
            if result == 'SUCCESS' then
                if GetLayer(self) > 0 then
                    local obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
                    if obj ~= nil then
                    	if obj.EventName == questname then
                    	    KILL_ALL_LAYER_MON_BY_PC(self)
                    	end
                    end
                end
                if 0 == GetQuestCheckState(self, questIES.ClassName) then
                    RunZombieScript('SCR_QUEST_SUCCESS', self, questIES.ClassName)
                    UnregisterHookMsg(self, sObj, "KillMonster");
                    UnregisterHookMsg(self, sObj, "KillMonster_PARTY");
                end
                return
            end
        end

--        local questIES_auto = GetClass('QuestProgressCheck_Auto', sObj.QuestName);
--        if questIES_auto.Track1 ~= 'None' then
--            if questIES_auto.Track_Auto_Complete ~= 'NO' then
--                local result = SCR_QUEST_CHECK(self,questIES.ClassName)
--                if result == 'SUCCESS' then
--                    RunZombieScript('SCR_TRACK_END',self, questIES.ClassName, questIES_auto.Track1, 'Success')
----                    SCR_TRACK_END(self, questIES.ClassName, questIES_auto.Track1, 'Success')
--                end
--            end
--        end
    end
    SaveSessionObject(self, sObj)

--    print(sObj.KillMonster1, sObj.KillMonster2, sObj.KillMonster3, sObj.KillMonster4, sObj.KillMonster5, sObj.KillMonster6);
end

function SCR_SSN_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if party_pc ~= nil and self ~= nil then
        if SHARE_QUEST_PROP(self, party_pc) == true then
            if GetLayer(self) ~= 0 then
                if GetLayer(self) == GetLayer(party_pc) then
                    SCR_SSN_KillMonster(self, sObj, msg, argObj, argStr, argNum)
                end
            else
                SCR_SSN_KillMonster(self, sObj, msg, argObj, argStr, argNum)
            end
        end
    end
end

























function SCR_SSN_KillMonster_Target(self, sObj, msg, argObj, argStr, argNum)
    if sObj.QuestName == 'None' or sObj.QuestName == nil then
        print(sObj.ClassName,'sObj.QuestName NIL');
        return;
    end
    local questIES = GetClass('QuestProgressCheck', sObj.QuestName);

    if questIES == nil then
        return;
    end
    
    local mon_count_check = sObj.KillMonster1 + sObj.KillMonster2 + sObj.KillMonster3 + sObj.KillMonster4 + sObj.KillMonster5 + sObj.KillMonster6

    if sObj.KillMonster1 == questIES.Succ_MonKillCount1 and sObj.KillMonster2 == questIES.Succ_MonKillCount2 and sObj.KillMonster3 == questIES.Succ_MonKillCount3 and sObj.KillMonster4 == questIES.Succ_MonKillCount4 and sObj.KillMonster5 == questIES.Succ_MonKillCount5 and sObj.KillMonster6 == questIES.Succ_MonKillCount6 then
        UnregisterHookMsg(self, sObj, "KillMonster");
    end
    
    local index
    
    for index = 1, 6 do
        SCR_KILLMONSTER_CHECK_Target(self, sObj, argObj, index, questIES['Succ_MonKillName'..index], questIES['Succ_MonTactics'..index], argObj.ClassName, argObj.Tactics)
    end
    
    
    if mon_count_check ~= sObj.KillMonster1 + sObj.KillMonster2 + sObj.KillMonster3 + sObj.KillMonster4 + sObj.KillMonster5 + sObj.KillMonster6 then
        if string.find(sObj.HideNPC_Change,'UnHideNPC/') ~= nil then
    	    local result = SCR_QUEST_CHECK(self,sObj.QuestName)
    	    if result == 'SUCCESS' then
    	        local dlg_type, enter_name = string.match(sObj.HideNPC_Change,'(UnHideNPC/)(.+)')
                UnHideNPC(self, enter_name)
            end
        elseif string.find(sObj.HideNPC_Change,'HideNPC/') ~= nil then
            local result = SCR_QUEST_CHECK(self,sObj.QuestName)
    	    if result == 'SUCCESS' then
    	        local x, y, z = GetPos(self)
                local dlg_type, enter_name, move_x, move_z, move_speed = string.match(sObj.HideNPC_Change,'(HideNPC/)(.+)[/](.+)[/](.+)[/](.+)')
                HideNPC(self, enter_name, x + move_x, z + move_z, move_speed)
            end
    	end
	
        if questIES.QuestEndMode == 'SYSTEM' then
            local result = SCR_QUEST_CHECK(self,questIES.ClassName)
            if result == 'SUCCESS' then
                if GetLayer(self) > 0 then
                    local obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
                    if obj ~= nil then
                    	if obj.EventName == questname then
                    	    KILL_ALL_LAYER_MON_BY_PC(self)
                    	end
                    end
                end
                if 0 == GetQuestCheckState(self, questIES.ClassName) then
                    RunZombieScript('SCR_QUEST_SUCCESS', self, questIES.ClassName)
                    UnregisterHookMsg(self, sObj, "KillMonster");
                    UnregisterHookMsg(self, sObj, "KillMonster_PARTY");
                end
            end
        end

--        local questIES_auto = GetClass('QuestProgressCheck_Auto', sObj.QuestName);
--        if questIES_auto.Track1 ~= 'None' then
--            if questIES_auto.Track_Auto_Complete ~= 'NO' then
--                local result = SCR_QUEST_CHECK(self,questIES.ClassName)
--                if result == 'SUCCESS' then
--                    RunZombieScript('SCR_TRACK_END',self, questIES.ClassName, questIES_auto.Track1, 'Success')
----                    SCR_TRACK_END(self, questIES.ClassName, questIES_auto.Track1, 'Success')
--                end
--            end
--        end
    end
    SaveSessionObject(self, sObj)

--    print(sObj.KillMonster1, sObj.KillMonster2, sObj.KillMonster3, sObj.KillMonster4, sObj.KillMonster5, sObj.KillMonster6);
end

function SCR_SSN_KillMonster_PARTY_Target(self, party_pc, sObj, msg, argObj, argStr, argNum)
    local questIES = GetClass('QuestProgressCheck', sObj.QuestName)
    local layer = GetLayer(self)
    if questIES.Succ_Kill_Layer == 'Layer' and layer == 0 then
        return
    elseif questIES.Succ_Kill_Layer == 'Layer' and layer ~= 0 then
        local obj = GetLayerObject(GetZoneInstID(self), layer);
        if obj ~= nil then
            if obj.EventName ~= sObj.QuestName then
                return
            end
        end
    end
    
    if party_pc ~= nil and self ~= nil then
        SCR_SSN_KillMonster_Target(self, sObj, msg, argObj, argStr, argNum)
    end
end


function SCR_QUEST_SESSIONOBJECT_CHECK_POS(self, sObj, argObj, questIES)
    local posx, posy, posz = GetPos(argObj)
    local result = 'NO'
    local zonename = GetZoneName(self)
    local list = {questIES.ProgLocation}
    for i = 1, 10 do
        if sObj['QuestMapPointGroup'..i] ~= 'None' and sObj['QuestMapPointView'..i] ~= 0 then
            list[#list + 1] = sObj['QuestMapPointGroup'..i]
        end
    end
    
    for i = 1, #list do
        local ret = SCR_QUEST_SESSIONOBJECT_CHECK_POS_SUB1(self, questIES, list[i], zonename, posx, posy, posz)
        if ret == 'YES' then
            return ret
        end
    end
    
    return result
end

function SCR_QUEST_SESSIONOBJECT_CHECK_POS_SUB1(self, questIES, locationInfo, zonename, posx, posy, posz)
    local locationList = SCR_STRING_CUT_SPACEBAR(locationInfo)
    local posInfo = {}
    
    if #locationList > 1 then
        for i = 1, #locationList do
            if tonumber(locationList[i+1]) ~= nil then
                if zonename == locationList[i] then
                    local distance = SCR_POINT_DISTANCE(posx,posz,locationList[i+1],locationList[i+3])
                    if distance <= tonumber(locationList[i+4]) then
                        return 'YES'
                    end
                end
                i = i + 4
            else
                if zonename == locationList[i] then
                    npcFunc = {'Dialog','Enter','Leave'}
                    for index = 1, 3 do
                        local dlgIESList = SCR_GET_XML_IES('GenType_'..zonename, npcFunc[index], locationList[i+1])
                        if #dlgIESList > 0 then
                            for x = 1, #dlgIESList do
                                local angdlgIESList = SCR_GET_XML_IES('Anchor_'..zonename, 'GenType', dlgIESList[x].GenType)
                                if #angdlgIESList > 0 then
                                    for y = 1, #angdlgIESList do
                                        local distance = SCR_POINT_DISTANCE(posx,posz,angdlgIESList[y].PosX,angdlgIESList[y].PosZ)
                                        if distance <= tonumber(locationList[i+2]) then
                                            return 'YES'
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