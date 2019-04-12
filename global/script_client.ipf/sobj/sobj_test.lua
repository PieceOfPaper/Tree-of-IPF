function SSN_TEST_ENTER_C(pc, sObj)

	RegisterHookMsg_C(pc, sObj, "HPUpdate", "SSN_TEST_HPUPDATE");
	RegisterHookMsg_C(pc, sObj, "ItemRemove", "SSN_TEST_ITEM_REMOVE");
	RegisterHookMsg_C(pc, sObj, "ItemAdd", "SSN_TEST_ITEM_ADD");
	RegisterHookMsg_C(pc, sObj, "ItemUse", "SSN_TEST_ITEM_USE");
	RegisterHookMsg_C(pc, sObj, "ItemChangeCount", "SSN_TEST_ITEM_CHANGECOUNT");
	RegisterHookMsg_C(pc, sObj, "EnterTrigger", "SSN_TEST_ENTER_TRIGGER");
	
	SetSObjTimeScp_C(pc, sObj, "SSN_CLIENT_SCP_UPDATE", 500);
	CLIENT_SMARTGEN_INIT();

end

function SSN_TEST_LEAVE_C(pc, sObj)

end

function SSN_CLIENT_SCP_UPDATE(pc)
	SSN_CLIENT_UPDATE_QUEST(pc);
	SSN_CLIENT_SMARTGEN(pc);
	SSN_CLIENT_PARTYQUEST_REFRESH(pc)
	SSN_CLIENT_GIMMICKCOUNTREFLASH(pc)
end

function SSN_CLIENT_GIMMICKCOUNTREFLASH(pc)
    local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj ~= nil then
    	sObj = GetIES(sObj:GetIESObject());
    	local cnt = GetClassCount('GimmickCountReflash')
    	local flag = 'NO'
    	for i = 0, cnt - 1 do
    		local reflashIES = GetClassByIndex('GimmickCountReflash', i);
    		local reflashHour = reflashIES.DayReflashHour
    		if reflashHour >= 0 and reflashIES.PropTimeInfo ~= 'None' and GetPropType(sObj, reflashIES.PropTimeInfo) ~= nil then
        		if sObj[reflashIES.PropTimeInfo] ~= 'None' then
                    local lTimeInfo = SCR_STRING_CUT(sObj[reflashIES.PropTimeInfo])
                    if #lTimeInfo == 3 then
                        local now_time = GetClientDBTimeString()
--                        local now_time = GetLocalTimeString()
                        local year = tonumber(string.sub(now_time,1,4))
                        local month = tonumber(string.sub(now_time,5,6))
                        local day = tonumber(string.sub(now_time,7,8))
                        local yday = SCR_MONTH_TO_YDAY(year,month,day)
                        local hour = tonumber(string.sub(now_time,9,10))
                        local lyear = lTimeInfo[1]
                        local lyday = lTimeInfo[2]
                        local lhour = lTimeInfo[3]
                        
                        local laddday = SCR_YEARYDAY_TO_DAY(lyear, lyday)
                        local addday = SCR_YEARYDAY_TO_DAY(year, yday)
                        
                        if (laddday - 1)*24 + lhour < (addday - 2)*24 + reflashHour then
                            flag = 'YES'
                        elseif (laddday - 1)*24 + lhour < (addday - 1)*24 + reflashHour and hour >= reflashHour then
                            flag = 'YES'
                        end
                        if flag == 'YES' then
                            break
                        end
                    end
                elseif sObj[reflashIES.PropTimeInfo] == 'None' and GetPropType(sObj, reflashIES.PropDayCount) ~= nil and sObj[reflashIES.PropDayCount] > 0  then
                    flag = 'YES'
                    break
            	end
            end
    	end
    	if flag == 'YES' then
    	    control.CustomCommand("GIMMICKCOUNTREFLASH", 0, 0, 0)
    	end
    end
end

function SSN_CLIENT_PARTYQUEST_REFRESH(pc)
    local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj ~= nil then
    	sObj = GetIES(sObj:GetIESObject());
    	if sObj.PARTY_Q_TIME1 ~= 'None' and sObj.PARTY_Q_COUNT1 > 0 then
            local lTimeInfo = SCR_STRING_CUT(sObj.PARTY_Q_TIME1)
            if #lTimeInfo == 3 then
                local now_time = GetClientDBTimeString()
                local year = tonumber(string.sub(now_time,1,4))
                local month = tonumber(string.sub(now_time,5,6))
                local day = tonumber(string.sub(now_time,7,8))
                local yday = SCR_MONTH_TO_YDAY(year,month,day)
                local hour = tonumber(string.sub(now_time,9,10))
--                print('XXXXXXX',year, yday, hour)
                local lyear = lTimeInfo[1]
                local lyday = lTimeInfo[2]
                local lhour = lTimeInfo[3]
                
                local laddday = SCR_YEARYDAY_TO_DAY(lyear, lyday)
                local addday = SCR_YEARYDAY_TO_DAY(year, yday)
                local flag = 'NO'
                
                if (laddday - 1)*24 + lhour < (addday - 2)*24 + CON_PARTYQUEST_REFLASH_HOUR1 then
                    flag = 'YES'
                elseif (laddday - 1)*24 + lhour < (addday - 1)*24 + CON_PARTYQUEST_REFLASH_HOUR1 and hour >= CON_PARTYQUEST_REFLASH_HOUR1 then
                    flag = 'YES'
                end
                
                if flag == 'YES' then
                    control.CustomCommand("PARTYQUEST_REFRESH", 0, 0, 0)
                end
            end
        elseif sObj.PARTY_Q_TIME1 == 'None' and sObj.PARTY_Q_COUNT1 > 0 then
            control.CustomCommand("PARTYQUEST_REFRESH", 0, 0, 0)
    	end
    end
end

function SMARGEN_NEAR_NPC_EXIST_CLIENT(self)
    local objList, objCount = SelectBaseObject(self, 300, 'ALL', 1);                  
    if objCount > 0 then
        for i = 1 , objCount do
			local obj = GetBaseObjectIES(objList[i]);
			if obj.ClassName ~= 'PC' then
			    local x1,y1,z1 = GetPos(self)
			    local actor = tolua.cast(objList[i], "CFSMActor");
			    local pos = actor:GetPos();
			    local dist = SCR_POINT_DISTANCE(x1,z1,pos.x,pos.z)
			    
			    if dist <= obj.CantGenRange then
			        return 1
			    end
			end
		end
	end
end

function CLIENT_SMARTGEN_INIT()

	local sObj = session.GetSessionObjectByName("ssn_smartgen");
	if sObj == nil then
		return;
	end

	sObj = GetIES(sObj:GetIESObject());
	local mapProp = session.GetCurrentMapProp();
    local zonename = mapProp:GetClassName();

	INIT_SMARTGEN(sObj, zonename);
	if sObj.ZoneGenPoint == 0 then
		sObj.ZoneGenPoint = -1;
	end

end

function SSN_CLIENT_SMARTGEN(self)
    local myActor = GetMyActor();
    local myPC = GetMyPCObject();
    local sObj = session.GetSessionObjectByName("ssn_smartgen");
    local rootGenType = 0
    local genTimeValue = 60
    local mapProp = session.GetCurrentMapProp();
    local zonename = mapProp:GetClassName();
    local zoneIES = GetClass('Map', zonename);
    local stat 		= info.GetStat(session.GetMyHandle());

	if sObj == nil then
		return;
	end
	
	if zoneIES.MapType ~= 'Field' and zoneIES.MapType ~= 'Dungeon' then
	    return
	end

	sObj = GetIES(sObj:GetIESObject());
    
    local rootFlag = false
	if world.GetLayer() ~= 0 then
		if myActor:GetSystem():GetStamina() / stat.MaxStamina * 100 <= 30 then
		    local objList, objCount = SelectObject(self, 300, 'ENEMY')               
		    
		    local isRoot = false
		    for i = 1, objCount do
		        if objList[i].Faction == 'RootCrystal' then
		            isRoot = true
		            break
		        end
		    end
            if isRoot == false then
                if sObj.RootCrystalGenTime == 0 then
                    rootGenType = 1
                    rootFlag = true
                else
                    if os.clock() >= sObj.RootCrystalGenTime + genTimeValue then                
                        rootGenType = 1
                        rootFlag = true
                    end
                end
            end
    	end
    else
        if myPC.Lv <= 10 then
            if zoneIES.isVillage ~= 'YES' and ( zonename == 'f_siauliai_west' or  zonename == 'f_siauliai_2' or  zonename == 'f_siauliai_out' or zonename == 'f_siauliai_16' or  zonename == 'f_siauliai_15_re' or  zonename == 'f_siauliai_11_re')then
                if myActor:GetSystem():GetStamina() / stat.MaxStamina * 100 <= 10 then
                    local objList, objCount = SelectObject(self, 100, 'ENEMY')               
                    local isRoot = false
        		    
        		    for i = 1, objCount do
        		        if objList[i].Faction == 'RootCrystal' then
        		            isRoot = true
        		            break
        		        end
        		    end
        		    
                    if isRoot == false then
                        if sObj.RootCrystalGenTime == 0 then
                            rootGenType = 2
                            rootFlag = true
                        else
                            if os.clock() >= sObj.RootCrystalGenTime + genTimeValue then                
                                rootGenType = 2
                                rootFlag = true
                            end
                        end
                    end
                end
            end
        end
	end
	
	if rootFlag == true then
		control.CustomCommand("SMARTGEN_CRYSTAL", rootGenType, 0);
		sObj.RootCrystalGenTime = math.floor(os.clock() + genTimeValue);
    end
    
	if world.GetLayer() ~= 0 then
	    return
	end
	
	if 1 == SMARGEN_NEAR_NPC_EXIST_CLIENT(self) then
		return;
	end
	
    
	if sObj.ZoneGenPoint == 300 then
        if sObj.State == 0 then
			local myActor = GetMyActor();

            local objList, objCount = SelectBaseObject(self, 30, 'ENEMY');
            local i, y
            local around_monster = 0;
            if objCount > 0 then
                for i = 1 , objCount do
					local _obj = objList[i];
					local baseobj = tolua.cast(_obj, "CFSMActor");
					local obj = GetBaseObjectIES(_obj);
					local faction = baseobj:GetFactionStr();
					if obj.ClassName ~= 'PC' and GT_ITEM ~= baseobj:GetObjType() and faction ~= 'HitMe' and faction ~= 'RootCrystal' and faction ~= 'Trap' and faction ~= 'Trap_Sin' and faction ~= 'LifeStream' then
                        around_monster = 100;
                        break;
                    end
                end
            end
        	local myPos = myActor:GetPos();
			local x = myPos.x;
			local z = myPos.z;
        	if (IsAutoState(self) == 1 or SCR_POINT_DISTANCE(sObj.Before_PosX,sObj.Before_PosZ,x,z) >= 25) and  around_monster == 0 then
                sObj.NormalAccrue = sObj.NormalAccrue + IMCRandom(1,4);
                sObj.SpecialAccrue = sObj.SpecialAccrue + IMCRandom(1,4);
                sObj.HideAccrue = sObj.HideAccrue + IMCRandom(1,4);
                sObj.TreasureAccrue = sObj.TreasureAccrue + IMCRandom(1,4);
                sObj.QuestMonAccrue = sObj.QuestMonAccrue + IMCRandom(1,4);
                
                sObj.Before_PosX = math.floor(x);
                sObj.Before_PosZ = math.floor(z);
            else
--                print('around monster');
        	end

            local peace_over;
            
			if sObj.ZoneEnter_Start ~= 0 then                  
				local mapProp = session.GetCurrentMapProp();
        	    local zonename = mapProp:GetClassName();
                local mon_summon = 'NO'
				local smartCls = GetClass('SmartGen_'..zonename, 'Main');
                local peacecount = smartCls.PeaceCount;

                if peacecount ~= 0 then
            	    for i = 1, peacecount do                                     
            	        local smartgen = GetClass('SmartGen_'..zonename, 'PeacePos'..i);
            	        if GetPropType(smartgen,'FunctionName') == nil or smartgen.FunctionName == 'None' then
                	        local distance = SCR_POINT_DISTANCE(x, z, smartgen.PosX, smartgen.PosZ)
                	        if distance < smartgen.Range then
                	            peace_over = 'OVER';
                	            break;
                	        end
                	    else
                	        
                	        local gentype_idspace = 'GenType_'..zonename;
                	        local anchor_idspace = 'Anchor_'..zonename
                	        local class_list, class_count = GetClassList(gentype_idspace);
                	        local gentype_list = {}

                	        if class_count > 0 then
                	            for gentypeIndex = 0, class_count-1 do
									local gencls = GetClassByIndexFromList(class_list, gentypeIndex);

                	                if TryGetProp(gencls, "Dialog") == smartgen.FunctionName then
                	                    gentype_list[#gentype_list+1] = gencls.GenType;
                	                elseif TryGetProp(gencls, "Enter") == smartgen.FunctionName then
                	                    gentype_list[#gentype_list+1] = gencls.GenType;
                	                elseif TryGetProp(gencls, "Leave") == smartgen.FunctionName then
                	                    gentype_list[#gentype_list+1] = gencls.GenType;
                	                end
                	            end
                	            
                	            if #gentype_list > 0 then
                	                for i = 1, #gentype_list do
										local anchor_clsList, class_count_anchor = GetClassList(anchor_idspace);
										if class_count_anchor > 0 then
                	                       
                	                        for y = 0, class_count_anchor -1 do
                	                            local classIES_anchor = GetClassByIndexFromList(anchor_clsList, y);
                	                            
                	                            if classIES_anchor ~= nil then
                	                                if classIES_anchor.GenType == gentype_list[i] then
                	                                    local distance = SCR_POINT_DISTANCE(x, z, classIES_anchor.PosX, classIES_anchor.PosZ)
                                            	        if distance < smartgen.Range then
                                            	            peace_over = 'OVER';
                                            	            break;
                                            	        end
                	                                end
                	                            end
                	                        end
                	                    end
                	                end
                	            end
                	        end
            	        end
            	    end
        	    end
        	    
        	    if peace_over ~= 'OVER' then                                        
					mon_summon = "YES";
        	        mon_summon = SCR_SMARTGEN_MON_CREATE_CLIENT(myActor, sObj)
        	        if sObj.QuestMonAccrue >= 40 then
            	        SCR_SMARTGEN_QUESTMON_CREATE_CLIENT(self, myActor, sObj)
            	    end
                else
--                    print(ScpArgMsg("Auto_anJeonJiDae"),mon_division);
                end
                
--                if mon_summon == 'YES' then
--                    local flag
--                    for flag = 1, CON_SMARTGEN_GENFLAG_MAX_INDEX do
--                        if sObj['GenFlag'..flag] == 'None' then
--                            sObj['GenFlag'..flag] = math.floor(x)..'/'..math.floor(z)
--                            break
--                        end
--                    end
--                end
            else
                if sObj.ZoneEnter_Start == 0 then
                    sObj.ZoneEnter_Start = 300;
                end
--                print(ScpArgMsg("Auto_iDong_eopeum"),mon_division);
        	end

            
        end
    else
		if sObj.ZoneGenPoint == 0 then
			CLIENT_SMARTGEN_INIT();
		end
	end


end

function SCR_SMARTGEN_QUESTMON_CREATE_CLIENT(self, myActor, sObj)

    local class_count = GetClassCount('QuestProgressCheck')
    local i;
    local mapProp = session.GetCurrentMapProp();
    local zonename = mapProp:GetClassName();
    local shortfallType;
    local flag = 0
    
    for i = 0, class_count-1 do
        local questIES = GetClassByIndex('QuestProgressCheck', i);
        if questIES.ProgMap == zonename and questIES.ClassName ~= 'None' then
            local sObj_main = session.GetSessionObjectByName("ssn_klapeda");
        	if sObj_main ~= nil then
            	sObj_main = GetIES(sObj_main:GetIESObject());
        	    local propertyValue = sObj_main[questIES.QuestPropertyName]
        	    if propertyValue >= CON_QUESTPROPERTY_MIN and propertyValue < CON_QUESTPROPERTY_MAX then
        	        if questIES.Succ_Kill_Layer == 'None' then
        	            if questIES.Succ_Check_MonKill > 0 then
        	                local result, shortfall = SCR_QUEST_SUCC_CHECK_MODULE_MONKILL(self, questIES)
        	                if result == 'NO' then
        	                    local ret = SCR_SMARTGEN_QUESTMON_CREATE_CLIENT_SUB1(self, questIES)
        	                    if ret == 'YES' then
        	                        if shortfall ~= nil then
        	                            local ret = SCR_NUMTABLE_STRING(shortfall)
        	                            ret = tostring(1)..ret
        	                            control.CustomCommand("SMARTGEN_QUESTMON", questIES.ClassID, tonumber(ret));
        	                            flag = 1
        	                        end
        	                    end
        	                end
        	            end
        	            if questIES.Succ_Check_OverKill > 0 then
        	                local result, shortfall = SCR_QUEST_SUCC_CHECK_MODULE_OVERKILL(self, questIES)
        	                if result == 'NO' then
        	                    local ret = SCR_SMARTGEN_QUESTMON_CREATE_CLIENT_SUB1(self, questIES)
        	                    if ret == 'YES' then
        	                        if shortfall ~= nil then
        	                            local ret = SCR_NUMTABLE_STRING(shortfall)
        	                            ret = tostring(2)..ret
        	                            control.CustomCommand("SMARTGEN_QUESTMON", questIES.ClassID, tonumber(ret));
        	                            flag = 1
        	                        end
        	                    end
        	                end
        	            end
        	            if questIES.Succ_Check_InvItem > 0 and questIES.Succ_MonKill_ItemGive1 ~= 'None' then
        	                local result, shortfall = SCR_QUEST_SUCC_CHECK_MODULE_INVITEM(self, questIES)
        	                if result == 'NO' then
        	                    local ret = SCR_SMARTGEN_QUESTMON_CREATE_CLIENT_SUB1(self, questIES)
        	                    if ret == 'YES' then
        	                        if shortfall ~= nil then
        	                            local ret = SCR_NUMTABLE_STRING(shortfall)
        	                            ret = tostring(3)..ret
        	                            control.CustomCommand("SMARTGEN_QUESTMON", questIES.ClassID, tonumber(ret));
        	                            flag = 1
        	                        end
        	                    end
        	                end
        	            end
        	        end
        	    end
        	end
        end
    end
    
    if flag > 0 then
        sObj.QuestMonAccrue = 0
    end
end

function SCR_SMARTGEN_QUESTMON_CREATE_CLIENT_SUB1(self, questIES)
    local posx,posy,posz = GetPos(self)
    local zonename = GetZoneName(self)
    local locationList = SCR_STRING_CUT_SPACEBAR(questIES.ProgLocation)
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
                    
                    local dlgIESList = SCR_GET_XML_IES('GenType_'..zonename, 'Dialog', locationList[i+1])
                    if dlgIESList ~= nil then
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
                    
                    local entIESList = SCR_GET_XML_IES('GenType_'..zonename, 'Enter', locationList[i+1])
                    if entIESList ~= nil then
                        if #entIESList > 0 then
                            for x = 1, #entIESList do
                                local angentIESList = SCR_GET_XML_IES('Anchor_'..zonename, 'GenType', entIESList[x].GenType)
                                if #angentIESList > 0 then
                                    for y = 1, #angentIESList do
                                        local distance = SCR_POINT_DISTANCE(posx,posz,angentIESList[y].PosX,angentIESList[y].PosZ)
                                        if distance <= tonumber(locationList[i+2]) then
                                            return 'YES'
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    local levIESList = SCR_GET_XML_IES('GenType_'..zonename, 'Leave', locationList[i+1])
                    if levIESList ~= nil then
                        if #levIESList > 0 then
                            for x = 1, #levIESList do
                                local anglevIESList = SCR_GET_XML_IES('Anchor_'..zonename, 'GenType', levIESList[x].GenType)
                                if #anglevIESList > 0 then
                                    for y = 1, #anglevIESList do
                                        local distance = SCR_POINT_DISTANCE(posx,posz,anglevIESList[y].PosX,anglevIESList[y].PosZ)
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
    
    return 'NO'
end

function SCR_SMARTGEN_MON_CREATE_CLIENT(myActor, sObj, DuplCreatePass_OPT, AccruePass_OPT)
    
	local mapProp = session.GetCurrentMapProp();
    local zone_name = mapProp:GetClassName();
	local myFaction = myActor:GetFactionStr();

    local myPos = myActor:GetPos();
	local x = myPos.x;
	local z = myPos.z;

    local min_mongen_range = nil
    local min_mongen = {};
    local mon_summon = 'NO'
    
    local pc = GetMyPCObject();
    if pc ~= nil then
        local fndList, fndCount = SelectObject(pc, 160, 'ENEMY');
        if fndCount >= 20 then
            return mon_summon
        end
    end
    
    if GetClassNumber('SmartGen_'..zone_name, 'Main', 'SPC_MongenCount') ~= 0 then
        for i = 1, GetClassNumber('SmartGen_'..zone_name, 'Main', 'SPC_MongenCount') do                              
	        local smartgen = GetClass('SmartGen_'..zone_name, 'SpecialMonGenPos'..i);
	        if smartgen ~= nil then
    	        local mongen_range = SCR_POINT_DISTANCE(x, z, smartgen.PosX, smartgen.PosZ);
    	        if mongen_range <= smartgen.Range then
    	            if min_mongen_range == nil or min_mongen_range > mongen_range then
    	                min_mongen_range = mongen_range;
    	                min_mongen[1] = smartgen;
    	            end
    	        end
    	    end
	    end
    end
    if GetClassNumber('SmartGen_'..zone_name, 'Main', 'NM_MongenCount') ~= 0 then
	    if min_mongen[1] == nil then
	        local min_mongen_range;
	        for i = 1, GetClassNumber('SmartGen_'..zone_name, 'Main', 'NM_MongenCount') do                              
		        local smartgen = GetClass('SmartGen_'..zone_name, 'NormalMonGenPos'..i);
		        if smartgen ~= nil then
    		        local mongen_range = SCR_POINT_DISTANCE(x, z, smartgen.PosX, smartgen.PosZ);
    	            if min_mongen_range == nil or min_mongen_range > mongen_range then
    	                min_mongen_range = mongen_range;
    	                min_mongen[2] = smartgen;
    	            end
    	        end
		    end
		else
		    if min_mongen[1].SpecialMongen_Only == 'NO' then
		        local min_mongen_range;
                for i = 1, GetClassNumber('SmartGen_'..zone_name, 'Main', 'NM_MongenCount') do                              
    		        local smartgen = GetClass('SmartGen_'..zone_name, 'NormalMonGenPos'..i);
    		        if smartgen ~= nil then
        		        local mongen_range = SCR_POINT_DISTANCE(x, z, smartgen.PosX, smartgen.PosZ);
    		            if min_mongen_range == nil or min_mongen_range > mongen_range then
    		                min_mongen_range = mongen_range;
    		                min_mongen[2] = smartgen;
    		            end
    		        end
    		    end
		    end
	    end
    end

    for mon_division = 1, 2 do
        if min_mongen[mon_division] ~= nil then
			local smartgen = min_mongen[mon_division];
			
            local gen_mon = 'NO'                                               
            local DuplCreate_Range = smartgen.DuplCreate_Range
            local flag
            
            if DuplCreatePass_OPT == 'YES' then
                DuplCreate_Range = 0
            end
--            if DuplCreate_Range > 0 then
--                
--                for flag = 1, CON_SMARTGEN_GENFLAG_MAX_INDEX do
--                    if sObj['GenFlag'..flag] == 'None' then
--                        
--                        break
--                    end
--                    local genflag_x, genflag_z = string.match(sObj['GenFlag'..flag], '(.+)[/](.+)')
--                    if SCR_POINT_DISTANCE(tonumber(genflag_x), tonumber(genflag_z), x, z) <= DuplCreate_Range then
--                        gen_mon = 'YES'
--                    end
--                end
--            end
--            if gen_mon == 'YES' then
--                break
--            end
            
	        if mon_division == 1 then                               
	            if smartgen.QuestName ~= 'None' then    
	                local quest_list = {};
                    quest_list[1] = smartgen.QuestName;
    		        local quest_count, quest_check, quest_succ, quest_progress = SCR_QUESTPROGRESS_CHECK( self, quest_list)
    		        if quest_check[1] ~= 'PROGRESS' then
    		            sObj.SpecialAccrue = 0 ;
    		            smartgen = nil;
    		        else
    		            sObj.SpecialAccrue = sObj.SpecialAccrue + 3 ;
    		        end
		        end
		    end
		    
		    local Accrue = {sObj.SpecialAccrue, sObj.NormalAccrue}
        	if Accrue[mon_division] >= smartgen.Accrue_Max * 3 or AccruePass_OPT == 'YES' then
				control.CustomCommand("SMARTGEN_CHECK", smartgen.ClassID);
                mon_summon = 'YES'
				if string.find(smartgen.ClassName, 'NormalMonGenPos') ~= nil then
    				sObj.NormalAccrue = 0
    			elseif string.find(smartgen.ClassName, 'SpecialMonGenPos') ~= nil then
    				sObj.SpecialAccrue = 0
    			end
			end
        end
    end

    return mon_summon
end

function SSN_CLIENT_UPDATE_QUEST_POSSIBLE(sObj, list, questPossible)
	local self = GetMyPCObject();
	if self == nil then
		return;
	end

	for i = 1, #list do
		local questIES = list[i];
    	if questIES.QuestPropertyName ~= 'None' then

			-- QUEST_POSSIBLE_AGREE check
			if questIES.QuestStartMode == 'SYSTEM' then
                if sObj[questIES.QuestPropertyName] == 0 then
					control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 1);
                end
            end

			-- Start NPC Unhide Check
			if questIES.StartNPC ~= 'None' and IsHideNPC_C(self, questIES.StartNPC) == 'YES' then
                   	control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 2);
            end

            -- Possible Add NPC Unhide Check
			if GetPropType(questIES, 'PossibleUnHideNPC') ~= nil and questIES.PossibleUnHideNPC ~= 'None' then
			    local npcList = SCR_STRING_CUT(questIES.PossibleUnHideNPC)
			    local flag = 0
			    for index = 1, #npcList do
			        if IsHideNPC_C(self, npcList[index]) == 'YES' then
			            flag = 1
			            break
			        end
			    end
			    if flag == 1 then
    	            control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 7);
			    end
            end

			-- QUEST MAP INFO CHECK
			if questIES.QuestMode == 'MAIN' then
                if questIES.StartMap ~= 'None' then
                    if self.Lv < 100 and questIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and questIES.QStartZone ~=  sObj.QSTARTZONETYPE then
                    else
                        local mapCls = GetClass('Map', questIES.StartMap)
                        if mapCls ~= nil and GetPropType(mapCls, 'WorldMapPreOpen') ~= nil and mapCls.WorldMapPreOpen == 'YES' then
                            local etc = GetMyEtcObject();
                            if table.find(questPossible,mapCls.ClassID) == 0 then
                                questPossible[#questPossible + 1] = mapCls.ClassID
                            end
                                    
                        	if etc['HadVisited_' .. mapCls.ClassID] ~= 1 then
                        		control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 5);
                        	end
                        end
                    end
                end
            end

			-- QUEST NPC ICON CHECK
			
            if questIES.QuestMode ~= 'MAIN' then
                    
                if questIES.StartMap ~= 'None' and questIES.StartNPC ~= 'None' and GetZoneName(self) == questIES.StartMap then
                    local result2
                    local subQuestZoneList = {}
                    result2, subQuestZoneList = SCR_POSSIBLE_UI_OPEN_CHECK(self, questIES, subQuestZoneList, 'ZoneMap')
                            
                    if result2 == 'OPEN' then
                        local genDlgIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Dialog', questIES.StartNPC)
                        local genEntIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Enter', questIES.StartNPC)
                        local genLevIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Leave', questIES.StartNPC)
                            	
                        if #genDlgIESList > 0 or #genEntIESList > 0 or #genLevIESList > 0 then
                            local genType
                            local genIES
                            if #genDlgIESList > 0 then
                            	genIES = genDlgIESList[1]
                            	genType = genDlgIESList[1].GenType
                            elseif  #genEntIESList > 0 then
                            	genIES = genEntIESList[1]
                            	genType = genEntIESList[1].GenType
                           	elseif  #genLevIESList > 0 then
                            	genIES = genLevIESList[1]
                            	genType = genLevIESList[1].GenType
                           	end
                           	        
                           	if genType ~= nil and ( genIES.Minimap == 1 or genIES.Minimap == 3) and string.find(genIES.ArgStr1, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr2, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr3, 'NPCStateLocal/') == nil  then
                           	    local mapprop = session.GetCurrentMapProp();
                                local mapNpcState = session.GetMapNPCState(mapprop:GetClassName());
                                local curState = mapNpcState:FindAndGet(genType);
                                if curState < 1 then
                                    control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 6);
                                end
                           	end
                        end
                    end
                end
            end
		end
	end
end

function SSN_CLIENT_UPDATE_QUEST_SUCCESS(sObj, list)
	local self = GetMyPCObject();
	if self == nil then
		return;
	end
	

	for i = 1, #list do
		local questIES = list[i];
    	if questIES.QuestPropertyName ~= 'None' then
			
			-- End NPC Unhide Check
			if questIES.EndNPC ~= 'None' and IsHideNPC_C(self, questIES.EndNPC) == 'YES' then
        		if questIES.ClassName ~= 'FTOWER41_MQ_02' and questIES.ClassName ~= 'FTOWER41_MQ_03' and questIES.ClassName ~= 'FTOWER43_MQ_02' and questIES.ClassName ~= 'FTOWER43_MQ_06' then
        		    control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 3);
                end
			end

			--Quest Complete Check
			if questIES.QuestEndMode == 'SYSTEM' then
				control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 4);
			end

			
            -- Success Add NPC Unhide Check
        	if GetPropType(questIES, 'SuccessUnHideNPC') ~= nil and questIES.SuccessUnHideNPC ~= 'None' then
        	    local npcList = SCR_STRING_CUT(questIES.SuccessUnHideNPC)
        	    local flag = 0
        	    for index = 1, #npcList do
        	        if IsHideNPC_C(self, npcList[index]) == 'YES' then
        	            flag = 1
        	            break
        	        end
        	    end
        	    if flag == 1 then
                    control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 9);
        	    end
            end
            
            if GetLayer(self) > 0 and questIES.QuestEndMode ~= 'SYSTEM' then
                local zoneLayerObj = GetClientZoneObject()
                if zoneLayerObj ~= nil and zoneLayerObj.EventName == questIES.ClassName then
                    local questIES_auto = GetClass('QuestProgressCheck_Auto', questIES.ClassName)
                    if questIES_auto.Track1 ~= 'None' and questIES_auto.Track_Auto_Complete ~= 'NO' then
                        local nowSec = math.floor(os.clock())
                        if sObj.TRACK_AUTO_COMPLETE_LAST_QUEST == questIES.ClassName and sObj.TRACK_AUTO_COMPLETE_LAST_TIME + 15 > nowSec then
                        else
                            sObj.TRACK_AUTO_COMPLETE_LAST_QUEST = questIES.ClassName
                            sObj.TRACK_AUTO_COMPLETE_LAST_TIME = nowSec
            				control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 10);
            			end
                    end
                end
            end

		end
	end
end

s_nextTime = 0;

function SSN_CLIENT_UPDATE_QUEST(pc)
    local now = math.floor(os.clock())
	if now < s_nextTime then
		return;
	end
	
	s_nextTime = now + 2;

	--QA Test �뵵
	if imcperfOnOff.IsEnableOptQuestLoop() == 0 then
		PREV_SSN_CLIENT_UPDATE_FOR_QA(pc);
		return;
	end	
	
	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj == nil then
		return;
	end

	sObj = GetIES(sObj:GetIESObject());

	local class_count = GetClassCount('QuestProgressCheck')
    local i;
    
	local questPossible = {};
	
	local progressQuestList = GetQuestProgressClassByState("PROGRESS");
	local possibleQuestList = GetQuestProgressClassByState("POSSIBLE");
	local successQuestList = GetQuestProgressClassByState("SUCCESS");

	for i = 1, #progressQuestList do
		local questIES = progressQuestList[i];
		local prop = TryGetProp(sObj, questIES.QuestPropertyName);
		--[[
		-- CREATE SESSOION OBJECT (PROGRESS)
		if nil ~= prop and TryGetProp(questIES,'Quest_SSN') ~= nil and questIES.Quest_SSN ~= 'None' and prop >= CON_QUESTPROPERTY_MIN and prop < CON_QUESTPROPERTY_END then
			local sObj2 = session.GetSessionObjectByName(questIES.Quest_SSN);
			if sObj2 == nil then
        		control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 0);
			end
		end
		]]
		--Quest Complete Check
		if prop ~= nil and prop == 200 then
			control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 4);
		end
	end

	for i = 1, #possibleQuestList do
		local questIES = possibleQuestList[i];
		local prop = TryGetProp(sObj, questIES.QuestPropertyName);
		--[[
		-- CREATE SESSOION OBJECT (POSSIBLE)
		if nil ~= prop and TryGetProp(questIES,'Quest_SSN') ~= nil and questIES.Quest_SSN ~= 'None' and prop >= CON_QUESTPROPERTY_MIN and prop < CON_QUESTPROPERTY_END then
			local sObj2 = session.GetSessionObjectByName(questIES.Quest_SSN);
			if sObj2 == nil then
        		control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 0);
			end
		end
		]]
		--Quest Complete Check
		if prop ~= nil and prop == 200 then
			control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 4);
		end
	end
	
	-- Session Object�� �ִ� ��� Progress ������ ����Ʈ�� ��з��Ѵ�. 
	local progressQuestListArrange = {}
	for i = 1, #progressQuestList do
	    local flag = 0
		local questIES = progressQuestList[i];
		local prop = TryGetProp(sObj, questIES.QuestPropertyName);
		if nil ~= prop and TryGetProp(questIES,'Quest_SSN') ~= nil and questIES.Quest_SSN ~= 'None' then
			local sObj2 = session.GetSessionObjectByName(questIES.Quest_SSN);
			if sObj2 ~= nil then
				local state = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
				if state == "SUCEESS" then
					successQuestList[#successQuestList + 1] = progressQuestList[i];
					flag = 1
				elseif state == "POSSIBLE" then
					possibleQuestList[#possibleQuestList + 1] = progressQuestList[i];
					flag = 2
				end
			end
		end
		if flag == 0 then
		    progressQuestListArrange[#progressQuestListArrange + 1] = progressQuestList[i]
				end
			end
	
    -- Progress Add NPC Unhide Check
	for i = 1, #progressQuestListArrange do
		local questIES = progressQuestListArrange[i];
    	if GetPropType(questIES, 'ProgressUnHideNPC') ~= nil and questIES.ProgressUnHideNPC ~= 'None' then
    	    local npcList = SCR_STRING_CUT(questIES.ProgressUnHideNPC)
    	    local flag = 0
    	    for index = 1, #npcList do
    	        if IsHideNPC_C(pc, npcList[index]) == 'YES' then
    	            flag = 1
    	            break
    	        end
    	    end
    	    if flag == 1 then
                control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 8);
    	    end
		end
	end

	SSN_CLIENT_UPDATE_QUEST_POSSIBLE(sObj, possibleQuestList, questPossible);
	SSN_CLIENT_UPDATE_QUEST_SUCCESS(sObj, successQuestList);
    
    if #questPossible > 0 then
        sObj.MQ_POSSIBLE_LIST = 'None'
        for i = 0 , #questPossible do
            if questPossible[i] ~= nil then
                if sObj.MQ_POSSIBLE_LIST == 'None' then
                    sObj.MQ_POSSIBLE_LIST = tostring(questPossible[i])
                else
                    sObj.MQ_POSSIBLE_LIST = sObj.MQ_POSSIBLE_LIST..'/'..tostring(questPossible[i])
                end
            end
        end
    end
	


end

-- QA TEST �뵵
function PREV_SSN_CLIENT_UPDATE_FOR_QA(pc)
    local questPossible = {}
	
	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj == nil then
		return;
	end

	sObj = GetIES(sObj:GetIESObject());

	local class_count = GetClassCount('QuestProgressCheck')
    local i;
    
	local self = GetMyPCObject();
	if self == nil then
		return;
	end
	
	local subQuestZoneList = {}
	
    for i = 0, class_count-1 do
        local questIES = GetClassByIndex('QuestProgressCheck', i);

		if questIES ~= nil then
    		if questIES.QuestPropertyName ~= 'None' then
    		    local result
				local prop = TryGetProp(sObj, questIES.QuestPropertyName);
                if nil ~= prop and TryGetProp(questIES,'Quest_SSN') ~= nil and questIES.Quest_SSN ~= 'None' and sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_END then
                    local sObj2 = session.GetSessionObjectByName(questIES.Quest_SSN);
                    if sObj2 == nil then
        				control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 0);
                        --CreateSessionObject(self,questIES.Quest_SSN, 1);
                    end
                end
            
    
        		-- questIES.QuestStartMode == 'SYSTEM' 
        		
                if questIES.QuestStartMode == 'SYSTEM' then
                    if sObj[questIES.QuestPropertyName] == 0 then
                        if result == nil then
                            result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                        end
                        if result == 'POSSIBLE' then
        					control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 1);
                        end
                    end
                end
            
    		
                if questIES.StartNPC ~= 'None' and IsHideNPC_C(self, questIES.StartNPC) == 'YES' then
                    if result == nil then
                        result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                    end
                    if result == 'POSSIBLE' then
        				control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 2);
                        -- UnHideNPC(self, questIES.StartNPC)
                    end
                end
            
        		if questIES.EndNPC ~= 'None' and IsHideNPC_C(self, questIES.EndNPC) == 'YES' then
        		    if questIES.ClassName ~= 'FTOWER41_MQ_02' and questIES.ClassName ~= 'FTOWER41_MQ_03' and questIES.ClassName ~= 'FTOWER43_MQ_02' and questIES.ClassName ~= 'FTOWER43_MQ_06' then
        		        if result == nil then
                            result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                        end
                        if result == 'SUCCESS' then
            				control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 3);
                            --UnHideNPC(self, questIES.EndNPC)
                        end
                    end
                end
            
                if questIES.QuestEndMode == 'SYSTEM' then
                    local flag = false
					local prop = TryGetProp(sObj, questIES.QuestPropertyName);
                    if prop ~= nil and sObj[questIES.QuestPropertyName] == 200 then
                        flag = true
                    else
                        if result == nil then
                            result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                        end
                        if result == 'SUCCESS' then
        					flag = true
                        end
                    end
                    
                    if flag == true then
                        control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 4);
                    end
                end
                
                if questIES.QuestMode == 'MAIN' then
                    if result == nil then
                        result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                    end
                    if result == 'POSSIBLE' then
                        if questIES.StartMap ~= 'None' then
                            if pc.Lv < 100 and questIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and questIES.QStartZone ~=  sObj.QSTARTZONETYPE then
                            else
                                local mapCls = GetClass('Map', questIES.StartMap)
                                if mapCls ~= nil and GetPropType(mapCls, 'WorldMapPreOpen') ~= nil and mapCls.WorldMapPreOpen == 'YES' then
                                    local etc = GetMyEtcObject();
                                    if table.find(questPossible,mapCls.ClassID) == 0 then
                                        questPossible[#questPossible + 1] = mapCls.ClassID
                                    end
                                    
                        			if etc['HadVisited_' .. mapCls.ClassID] ~= 1 then
                        			    control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 5);
                        			end
                        		end
                        	end
                        end
                    end
                end
                
                if questIES.QuestMode ~= 'MAIN' then
                    if result == nil then
                        result = SCR_QUEST_CHECK_C(self, questIES.ClassName)
                    end
                    if result == 'POSSIBLE' then
                        if questIES.StartMap ~= 'None' and questIES.StartNPC ~= 'None' and GetZoneName(self) == questIES.StartMap then
                            local result2
                            result2, subQuestZoneList = SCR_POSSIBLE_UI_OPEN_CHECK(self, questIES, subQuestZoneList, 'ZoneMap')
                            
                            if result2 == 'OPEN' then
                            	local genDlgIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Dialog', questIES.StartNPC)
                            	local genEntIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Enter', questIES.StartNPC)
                            	local genLevIESList = SCR_GET_XML_IES('GenType_'..questIES.StartMap, 'Leave', questIES.StartNPC)
                            	
                            	if #genDlgIESList > 0 or #genEntIESList > 0 or #genLevIESList > 0 then
                            	    local genType
                            	    local genIES
                            	    if #genDlgIESList > 0 then
                            	        genIES = genDlgIESList[1]
                            	        genType = genDlgIESList[1].GenType
                            	    elseif  #genEntIESList > 0 then
                            	        genIES = genEntIESList[1]
                            	        genType = genEntIESList[1].GenType
                           	        elseif  #genLevIESList > 0 then
                            	        genIES = genLevIESList[1]
                            	        genType = genLevIESList[1].GenType
                           	        end
                           	        
                           	        if genType ~= nil and ( genIES.Minimap == 1 or genIES.Minimap == 3) and string.find(genIES.ArgStr1, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr2, 'NPCStateLocal/') == nil and string.find(genIES.ArgStr3, 'NPCStateLocal/') == nil  then
                           	            local mapprop = session.GetCurrentMapProp();
                                    	local mapNpcState = session.GetMapNPCState(mapprop:GetClassName());
                                    	local curState = mapNpcState:FindAndGet(genType);
                                    	if curState < 1 then
                                    	    control.CustomCommand("QUEST_SOBJ_CHECK", questIES.ClassID, 6);
                                    	end
                           	        end
                            	end
                            end
                        end
                    end
                end
            end
        end
    end
    
    if #questPossible > 0 then
        sObj.MQ_POSSIBLE_LIST = 'None'
        for i = 0 , #questPossible do
            if questPossible[i] ~= nil then
                if sObj.MQ_POSSIBLE_LIST == 'None' then
                    sObj.MQ_POSSIBLE_LIST = tostring(questPossible[i])
                else
                    sObj.MQ_POSSIBLE_LIST = sObj.MQ_POSSIBLE_LIST..'/'..tostring(questPossible[i])
                end
            end
        end
    end



end


function CHECK_OBJ_TIME(obj, propName, checkSec)
	local nextAlarmTime = obj[propName];
	local curTime = GetServerAppTime();
	
	if curTime < nextAlarmTime then
		return 0;
	end
	
	obj[propName] = curTime + checkSec;
	return 1;

end

function SSN_TEST_ENTER_TRIGGER(self, sObj, msg, argObj, argStr, argNum)



end

function SSN_TEST_HPUPDATE(self, sObj, msg, argObj, argStr, beforeHP, argNum2, base_stat)

	if sObj.CValue_1 ~= 0 then
		return;
	end
	
	if beforeHP < base_stat.HP then
		return;
	end
		
	if base_stat:GetPercent() >= 50 then
		return;
	end
	
	GUIDE_MSG(ScpArgMsg("HPUnder{Auto_1}Percent!_UseItem", "Auto_1", math.floor(base_stat:GetPercent())));
		
	SetSObjProp_C(self, sObj, "CValue_1", 1);
	
end

function SSN_TEST_ITEM_ADD(self, sObj, msg, argObj, argStr, argNum)
    if sObj.HELP_SHOP <= 0 then
        local a = GetEmptyItemSlotCount()
        if a <= 1 then
            sObj.HELP_SHOP = 300
            AddHelpByName_C('TUTO_SHOP')
        end
    end

	if argObj.ClassName == 'Drug_MaxSTAUP1' then
	    addon.BroadMsg("NOTICE_Dm_Clear", ScpArgMsg("Drug_MaxSTAUP1Use","Auto_1", argObj.Name, "Auto_2", argObj.NumberArg1), 6);
	end

end

function SSN_TEST_ITEM_REMOVE(self, sObj, msg, argObj, argStr, argNum)
    
end

function SSN_TEST_ITEM_USE(self, sObj, msg, argObj, argStr, argNum)

	if string.find(argObj.Script, "AddHP") ~= nil then
		addon.BroadMsg("NOTICE_Dm_UsePotion", ClMsg("YouUsedRecoverItem"), 2);
		
		SetSObjProp_C(self, sObj, "CValue_1", 1);
	end

end


function SSN_TEST_ITEM_CHANGECOUNT(self, sObj, msg, argObj, argStr, argNum)
    if sObj.HELP_SHOP == 0 then
        local hpItem = GetInvItemCount(self, 'Drug_HP1')
        local spItem = GetInvItemCount(self, 'Drug_SP1')
        local staItem = GetInvItemCount(self, 'Drug_STA1')
        if hpItem <= 2 or spItem <= 2 or staItem <= 2 then
            sObj.HELP_SHOP = 300
            AddHelpByName_C('TUTO_SHOP')
        end
    end
end


