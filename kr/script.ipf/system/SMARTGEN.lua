--SMARTGEN.lua

function SCR_SMARTGEN_ZONEENTER(self, sObj, msg, argObj, argStr, argNum)
    
	--INIT_SMARTGEN(sObj, argStr);
end

function SCR_SMARTGEN_DISPOSITION(gencenterObj, genRange, dispositionType, summon_num, x, z, max_moncount)
    
    local dist_min_max = SCR_STRING_CUT(genRange)
    local mongenX, mongenY, mongenZ
    if #dist_min_max == 2 then
        local distance = IMCRandom(tonumber(dist_min_max[1]) , tonumber(dist_min_max[2]))
        if dispositionType == 'Front' or dispositionType == 'None' then
            local angle = 0
            angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 25)
            
            mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, angle, distance)
        elseif dispositionType == 'Right' then
            local angle = -90
            angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 25)
            
            mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, angle, distance)
        elseif dispositionType == 'Left' then
            local angle = 90
            angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 25)
            
            mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, angle, distance)
        elseif dispositionType == 'Back' then
            local angle = 180
            angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 25)
            mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, angle, distance)
        elseif dispositionType == 'Triangle' then
            local flag = summon_num % 3
            
            if flag == 1 then
                mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, 0, distance)
            elseif flag == 2 then
                mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, -120, distance)
            elseif flag == 0 then
                mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, 120, distance)
            end
        elseif dispositionType == 'Circle' then
            local angle = 0
            
            if max_moncount == nil then
                angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 0)
            else
                angle = SCR_NEXT_MONGEN_ANGLE(summon_num, angle, 360 / max_moncount)
            end
            mongenX, mongenY, mongenZ = GetActorByDirAnglePos(gencenterObj, angle, distance)
        end
    end
    
    return mongenX, mongenZ
end

function SCR_NEXT_MONGEN_ANGLE(summon_num, angle, next_angle)
    if summon_num % 2 == 1 then
        if summon_num ~= 1 then
            angle = angle + next_angle * math.floor(summon_num/2)
        end
    else
        angle = angle - next_angle * math.floor(summon_num/2)
    end
    
    if angle > 180 then
        local rem = angle % 360
        if rem <= 180 then
            angle = rem
        else
            angle = -360 + rem
        end
    elseif angle < -180 then
        local rem = angle % -360
        if rem > -180 then
            angle = rem
        else
            angle = 360 + rem
        end
    end
    
    return angle
end


function SCR_SMARTGEN_MON_SUMMON(self, tendency_Flag,aroundPC_Count, mongenIES, dispositionType, x, y, z)
    local mon_summon = 'NO'
    
    local summon_monlist = {}
    local monSizeLargeCount = 0
    
    
    local mon_list = {}
    local i
    
    if mongenIES.Mon_ClassName1 == 'None' then
        mon_list = SCR_GET_AROUND_MONGEN_MONLIST(self, GetZoneName(self), GetCurrentFaction(self), 100, x, y, z)
--        print('SSSSSSSSSSSSSSSSSSSS',#mon_list,mon_list[1][1])
    else
        for i = 1, 10 do
            if mongenIES['Mon_ClassName'..i] ~= 'None' then
                mon_list[#mon_list + 1] = {}
                mon_list[#mon_list][1] = mongenIES['Mon_ClassName'..i]
                mon_list[#mon_list][2] = mongenIES['Mon_Name'..i]
                mon_list[#mon_list][3] = mongenIES['Mon_Tactics'..i]
                mon_list[#mon_list][4] = mongenIES['Mon_BTree'..i]
                mon_list[#mon_list][5] = mongenIES['Mon_Lv'..i]
                mon_list[#mon_list][6] = mongenIES['Mon_Faction'..i]
                mon_list[#mon_list][7] = mongenIES['Mon_Modify'..i]
                mon_list[#mon_list][8] = 'None'
            end
        end
    end
    
    if mon_list == nil then
        return
    end
    
    for i = 1, #mon_list do
        local Setgen = GetClass('SmartGen_'..GetZoneName(self), mon_list[i][1])
        if Setgen ~= nil then
            if GetPropType(Setgen, 'ChangeLeader') ~= nil and Setgen.ChangeLeader ~= 'None' and Setgen.ChangeLeader ~= 0 then
                local list = SCR_STRING_CUT(Setgen.ChangeLeader)
                if #list > 0 then
                    for index = 1, 2 do
                        mon_list[i][index] = list[index]
                    end
                end
            end
            
            if GetPropType(Setgen, 'Leader_Modify') ~= nil and Setgen.Leader_Modify ~= 'None' and Setgen.Leader_Modify ~= 0 then
                mon_list[i][7] = Setgen.Leader_Modify
            end
            
            
            local layer = GetLayer(self)
            local pos_list = SCR_CELLGENPOS_LIST(self, 'Front1', 0)
            local customAttack
            local fixedAttack
            local customLife
            local fixedLife
            local moveSpeed
            local shield
            local scale
            local kdArmor
            local surroundRate
            
            if mon_list[i][7] ~= nil and mon_list[i][7] ~= 'None' then
                local monModifyList = SCR_STRING_CUT(mon_list[i][7])
                if #monModifyList > 0 then
                    for index = 1, #monModifyList do
                        local monModify = SCR_STRING_CUT_SEMICOLON(monModifyList[index])
                        
                        if monModify[1] == 'CustATK' then
                            if tonumber(monModify[2]) ~= nil then
                                customAttack = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'FixATK' then
                            if tonumber(monModify[2]) ~= nil then
                                fixedAttack = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'CustLife' then
                            if tonumber(monModify[2]) ~= nil then
                                customLife = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'FixLife' then
                            if tonumber(monModify[2]) ~= nil then
                                fixedLife = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'RMSPD' then
                            if tonumber(monModify[2]) ~= nil then
                                moveSpeed = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'Shield' then
                            if tonumber(monModify[2]) ~= nil then
                                shield = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'Scale' then
                            if tonumber(monModify[2]) ~= nil then
                                scale = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'KDArmor' then
                            if tonumber(monModify[2]) ~= nil then
                                kdArmor = tonumber(monModify[2])
                            end
                        elseif monModify[1] == 'SRRate' then
                            if tonumber(monModify[2]) ~= nil then
                                surroundRate = tonumber(monModify[2])
                            end
                        end
                    end
                end
            end
            
            local monIES1 = GetClass('Monster', mon_list[i][1])
            if monIES1.MonRank == "Elite" then
                monSizeLargeCount = monSizeLargeCount + 1
            end
            local mon = CREATE_MONSTER(self, mon_list[i][1], pos_list[1][1], pos_list[1][2], pos_list[1][3], nil, mon_list[i][6], layer, nil, mon_list[i][3], mon_list[i][2], nil, fixedLife, 1, nil, nil, mon_list[i][4], customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, nil, nil, nil, mon_list[i][8])
            if mon ~= nil then
--                Chat(mon,'Line 202')
                local monX, monY, monZ = GetPos(mon)
                CustomMongoLog(self, "SmartGenMon", "Type", "FileSetMain", "ClassName", mon_list[i][1], "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
--                print('GGGGGGGGGG Line 202',monX, monY, monZ)
                
                LookAt(mon, self)
                
                if tendency_Flag ~= nil and tendency_Flag == 'YES' then
                    SetTendency(mon, 'Attack')
                else
                    SetTendency(mon, 'None')
                end

				if GetPropType(Setgen, 'FamilyGroup') ~= nil then
					if Setgen.FamilyGroup == 'Yes' then										
						if GetPropType(Setgen, 'FamilyTendency') ~= nil then
							if Setgen.FamilyTendency == 'Attack' then
								SetTendency(mon, 'Attack');
							else
								SetTendency(mon, 'None');
							end						
						end
						SetExProp(mon, 'FAMILY_MON_LEADER', GetHandle(mon));
					end
				end
                
                CreateSessionObject(mon, 'ssn_smartgen_mon')
                local list = GetCellCoord(mon, 'Siege1',  1);
                local index2 = 1;
                local pos_list = {}
                while true do
                    if index2 >= #list then
                        break;
                    end
                    
                    pos_list[#pos_list + 1] = {}
                    pos_list[#pos_list][1] = list[index2];
                    pos_list[#pos_list][2] = list[index2 + 1];
                    pos_list[#pos_list][3] = list[index2 + 2];
                    
                    index2 = index2 + 3
                end
                
                
                
                if #pos_list > 0 then
                    local angle_index = 1
                    
                    for index = 1, 10 do
                        if Setgen['SubMon_ClassName'..index] ~= 'None' and tonumber(Setgen['SubMon_PerMille'..index]) ~= nil and IMCRandom(1,1000) <= tonumber(Setgen['SubMon_PerMille'..index]) then
                            if angle_index > #pos_list then
                                angle_index = 1
                            end
                            
                            local customAttack
                            local fixedAttack
                            local customLife
                            local fixedLife
                            local moveSpeed
                            local shield
                            local scale
                            local kdArmor
                            local surroundRate
                            
                            if Setgen['SubMon_Modify'..index] ~= nil and Setgen['SubMon_Modify'..index] ~= 'None' then
                                local monModifyList = SCR_STRING_CUT(Setgen['SubMon_Modify'..index])
                                if #monModifyList > 0 then
                                    for index2 = 1, #monModifyList do
                                        local monModify = SCR_STRING_CUT_SEMICOLON(monModifyList[index2])
                                        
                                        if monModify[1] == 'CustATK' then
                                            if tonumber(monModify[2]) ~= nil then
                                                customAttack = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'FixATK' then
                                            if tonumber(monModify[2]) ~= nil then
                                                fixedAttack = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'CustLife' then
                                            if tonumber(monModify[2]) ~= nil then
                                                customLife = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'FixLife' then
                                            if tonumber(monModify[2]) ~= nil then
                                                fixedLife = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'RMSPD' then
                                            if tonumber(monModify[2]) ~= nil then
                                                moveSpeed = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'Shield' then
                                            if tonumber(monModify[2]) ~= nil then
                                                shield = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'Scale' then
                                            if tonumber(monModify[2]) ~= nil then
                                                scale = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'KDArmor' then
                                            if tonumber(monModify[2]) ~= nil then
                                                kdArmor = tonumber(monModify[2])
                                            end
                                        elseif monModify[1] == 'SRRate' then
                                            if tonumber(monModify[2]) ~= nil then
                                                surroundRate = tonumber(monModify[2])
                                            end
                                        end
                                    end 
                                end     
                            end         
                            local monIES1 = GetClass('Monster', Setgen['SubMon_ClassName'..index])
                            local largeFlag = false
                            if monIES1.MonRank == "Elite" then
                                largeFlag = true
                                monSizeLargeCount = monSizeLargeCount + 1
                            end
                            if largeFlag == false or monSizeLargeCount <= 1 then
                                local submon = CREATE_MONSTER(self, Setgen['SubMon_ClassName'..index], pos_list[angle_index][1], pos_list[angle_index][2], pos_list[angle_index][3], nil, mon_list[i][6], layer, nil, Setgen['SubMon_Tactics'..index], Setgen['SubMon_Name'..index], nil, fixedLife, 1, nil, nil, Setgen['SubMon_BTree'..index], customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, nil, nil, nil, mon_list[i][8])
                                if submon ~= nil then
--                                    Chat(submon,'Line 317')
                                    local monX, monY, monZ = GetPos(submon)
                                    CustomMongoLog(self, "SmartGenMon", "Type", "FileSetSub", "ClassName", Setgen['SubMon_ClassName'..index], "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
--                                    print('GGGGGGGGGG Line 317',monX, monY, monZ)
                                    
                                    CreateSessionObject(submon, 'ssn_smartgen_mon')
                                    LookAt(submon, self)
                                    if tendency_Flag ~= nil and tendency_Flag == 'YES' then
                                        SetTendency(submon, 'Attack')
                                    else
                                        SetTendency(submon, 'None')
                                    end
                                    
    								if GetPropType(Setgen, 'FamilyGroup') ~= nil then
    									if Setgen.FamilyGroup == 'Yes' then
    										
    										if GetPropType(Setgen, 'FamilyTendency') ~= nil then
    											if Setgen.FamilyTendency == 'Attack' then
    												SetTendency(submon, 'Attack');
    											else
    												SetTendency(submon, 'None');
    											end						
    										end
    										SetExProp(submon, 'FAMILY_MON_LEADER', GetHandle(mon));
    									end
    								end
    
                                    summon_monlist[#summon_monlist + 1] = submon
                                    
                                    angle_index = angle_index + 1
                                end
                            end
                        end
                    end
                end
                
--                local sObj = GetSessionObject(self, "ssn_smartgen")
--                if sObj ~= nil then
--                    local flag
--                    for flag = 1, CON_SMARTGEN_GENFLAG_MAX_INDEX do
--                        if sObj['GenFlag'..flag] == 'None' then
--                            sObj['GenFlag'..flag] = math.floor(x)..'/'..math.floor(z)
--                            break
--                        end
--                    end
--                end
                
                mon_summon = 'YES'
                
                return mon_summon, summon_monlist
            end
        end
    end
    
    
    local partyGenMax = aroundPC_Count
    if partyGenMax == nil then
        partyGenMax = 0
    elseif partyGenMax >= 1 then
        partyGenMax = math.floor(1 + (partyGenMax/4))
    end
    
    for aroundPC_gen = 0, partyGenMax do
        local dispositionType_value = SCR_STRING_CUT_COMMA(dispositionType)
        local angle = dispositionType_value[2] + aroundPC_gen * 20
        local aroundPC_monlist = {}
        
        if angle >= 360 then
            angle = angle % 360
        end
--        print('IIIIIIIIIIIIII',angle)
        local list = GetCellCoord(self, dispositionType_value[1],  angle);
        local index = 1;
        local pos_list = {}
        while true do
            if index >= #list then
                break;
            end
            
            pos_list[#pos_list + 1] = {}
            pos_list[#pos_list][1] = list[index];
            pos_list[#pos_list][2] = list[index + 1];
            pos_list[#pos_list][3] = list[index + 2];
            
            index = index + 3
        end
        
        local mon_count_list
        local mon_count = 0
        
        if GetPropType(mongenIES, 'MonCount') ~= nil then
            mon_count_list  = SCR_STRING_CUT(mongenIES.MonCount)
            if mon_count_list ~= nil and #mon_count_list >= 2 then
                mon_count = IMCRandom(mon_count_list[1], mon_count_list[2])
                
                if aroundPC_gen == 1 and aroundPC_Count >= 2 then
                    mon_count = math.floor(mon_count + (mon_count * ((aroundPC_Count - 1) * 0.5)))
                end
                if mon_count <= 0 then
                    mon_count = 1
                end
            end
        end
        
        
        for i = 1, mon_count do
            local mon_list_num = i
            if mon_list_num > #pos_list then
                mon_list_num = mon_list_num % #pos_list
                if mon_list_num == 0 then
                    mon_list_num = #pos_list
                end
            end
            
            local j = i 
            if (GetPropType(mongenIES, 'MonListRandom') ~= nil and mongenIES.MonListRandom == 'YES') or mon_list[i] == nil then
                j = IMCRandom(1, #mon_list)
            end
            if mon_list[j] ~= nil then
                local layer = GetLayer(self)
                local customAttack
                local fixedAttack
                local customLife
                local fixedLife
                local moveSpeed
                local shield
                local scale
                local kdArmor
                local surroundRate
                
                if mon_list[j][7] ~= nil and mon_list[j][7] ~= 'None' then
                    local monModifyList = SCR_STRING_CUT(mon_list[j][7])
                    if #monModifyList > 0 then
                        for index = 1, #monModifyList do
                            local monModify = SCR_STRING_CUT_SEMICOLON(monModifyList[index])
                            
                            if monModify[1] == 'CustATK' then
                                if tonumber(monModify[2]) ~= nil then
                                    customAttack = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'FixATK' then
                                if tonumber(monModify[2]) ~= nil then
                                    fixedAttack = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'CustLife' then
                                if tonumber(monModify[2]) ~= nil then
                                    customLife = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'FixLife' then
                                if tonumber(monModify[2]) ~= nil then
                                    fixedLife = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'RMSPD' then
                                if tonumber(monModify[2]) ~= nil then
                                    moveSpeed = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'Shield' then
                                if tonumber(monModify[2]) ~= nil then
                                    shield = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'Scale' then
                                if tonumber(monModify[2]) ~= nil then
                                    scale = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'KDArmor' then
                                if tonumber(monModify[2]) ~= nil then
                                    kdArmor = tonumber(monModify[2])
                                end
                            elseif monModify[1] == 'SRRate' then
                                if tonumber(monModify[2]) ~= nil then
                                    surroundRate = tonumber(monModify[2])
                                end
                            end
                        end
                    end
                end
            
                local monIES1 = GetClass('Monster', mon_list[j][1])
                local largeFlag = false
                if monIES1.MonRank == "Elite" then
                    largeFlag = true
                    monSizeLargeCount = monSizeLargeCount + 1
                end
                if largeFlag == false or monSizeLargeCount <= 1 then
                    local mon = CREATE_MONSTER(self, mon_list[j][1], pos_list[mon_list_num][1], pos_list[mon_list_num][2], pos_list[mon_list_num][3], nil, mon_list[j][6], layer, nil, mon_list[j][3], mon_list[j][2], nil, fixedLife, 1, nil, nil, mon_list[j][4], customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, nil, nil, nil, mon_list[j][8])
                    if mon ~= nil then
--                        Chat(mon,'Line 501')
                        local monX, monY, monZ = GetPos(mon)
                        CustomMongoLog(self, "SmartGenMon", "Type", "AutoSetMon", "ClassName", mon_list[j][1], "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
--                        print('GGGGGGGGGG Line 501',monX, monY, monZ)
                        
                        CreateSessionObject(mon, 'ssn_smartgen_mon')
                        LookAt(mon, self)
                        if tendency_Flag ~= nil and tendency_Flag == 'YES' then
                            SetTendency(mon, 'Attack')
                            
                            if i <= mon_count / 3 then
                                InsertHate(mon, self, 1)
                            else
                                SetTendencysearchRange(mon, 100)
                            end
                        else
                            SetTendency(mon, 'None')
                        end
                        
                        summon_monlist[#summon_monlist + 1] = mon
                        aroundPC_monlist[#aroundPC_monlist + 1] = mon
                    end
                end
            end
        end
        
        if #aroundPC_monlist > 0 then
            mon_summon = 'YES'
           	--MAKE_CELL_GROUP(self, aroundPC_monlist, dispositionType_value[1]);
        end
    end
    
    
    if #summon_monlist > 0 then
        mon_summon = 'YES'
    end
    
    return mon_summon, summon_monlist
    
end

function SCR_SMARTGEN_AROUNDPC_SOBJ(AroundPC, AroundPC_sObj, Accrue, cooltime)
    AroundPC_sObj[Accrue] = 0
    AroundPC_sObj[cooltime] = math.floor(os.clock())
    local x, y, z = GetPos(AroundPC)
    AroundPC_sObj.LastGenPosServer = math.floor(x)..'/'..math.floor(z)
    AroundPC_sObj.LastGenTimeServer = math.floor(os.clock())
--    print('CCCCCCC_AroundPC_sObj.LastGenPosServer/LastGenTimeServer',AroundPC_sObj.LastGenPosServer, AroundPC_sObj.LastGenTimeServer)
    SendPropertyByName(AroundPC, AroundPC_sObj, Accrue);
end




function SCR_SMARTGEN_CRYSTAL(self, rootGenType)
	local sObj = GetSessionObject(self, "ssn_smartgen");
	if sObj == nil then
		return;
	end
	
	if IsPlayingDirection(self) ~= 0 then
	    return
	end
	
	local pos_list
	local genTimeValue = 60
	if rootGenType == 1 then
	    if IMCRandom(1,100) <= 30 then
	        sObj.RootCrystalGenTime = math.floor(os.clock())
	        return
	    end
	    pos_list = SCR_CELLGENPOS_LIST(self, 'Front3', 0)
	else
	    pos_list = SCR_CELLGENPOS_LIST(self, 'Front2', 0)
	end
	if os.clock() >= sObj.RootCrystalGenTime + genTimeValue then
        if pos_list ~= nil and #pos_list > 0 then
            local rootcrystalName = 'rootcrystal_01'
            local ret = SCR_GET_XML_IES('GenType_'..GetZoneName(self), 'ClassType', 'rootcrystal_', 1)
            if #ret > 0 then
                for i = 1, #ret do
                    if ret[i].ClassType == 'rootcrystal_01' or ret[i].ClassType == 'rootcrystal_02' or ret[i].ClassType == 'rootcrystal_03' or ret[i].ClassType == 'rootcrystal_04' or ret[i].ClassType == 'rootcrystal_05' then
                        rootcrystalName = ret[i].ClassType;
                        break
                    end
                end
            end
			local root = CREATE_MONSTER(self, rootcrystalName, pos_list[1][1], pos_list[1][2], pos_list[1][3], 0, 'RootCrystal', GetLayer(self), 1, 'MON_TORCH', ScpArgMsg("Auto_NaMuPpuLi_SuJeong"))
			if root ~= nil then
			    local monX, monY, monZ = GetPos(root)
                CustomMongoLog(self, "SmartGenMon", "Type", "Rootcrystal", "ClassName", rootcrystalName, "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
			    if rootGenType ~= 1 then
    			    SendAddOnMsg(self, 'NOTICE_Dm_Clear', ScpArgMsg("RootcrystalAttack"), 7)
    			    AddHelpByName(self, "TUTO_ROOTCRYSTAL")
    			end
				sObj.RootCrystalGenTime = math.floor(os.clock())
			end
		end
	end		
end

function SMARTGEN_ABLE_CREATE(self, monCheckDist)
    local objList, objCount = SelectObject(self, 300, 'ALL', 1);
    if objCount > 0 then
        for i = 1 , objCount do
			local obj = objList[i];
			if obj.ClassName ~= 'PC' then
    			local dist = GetDist2D(self, obj);
                if dist <= obj.CantGenRange then
                    return 0
                end
            end
        end
    end
    return 1
end

function SCR_SMARTGEN_QUESTMON(self, qusetClassID, shortfallType)
    local dataList = SCR_STRING_CUT_CHAR(tostring(shortfallType))
    local questIES = GetClassByType('QuestProgressCheck',qusetClassID)
    local x,y,z = GetPos(self)
    local addMonList = {}
    
    local result = SCR_QUEST_CHECK(self, questIES.ClassName)
--    print('XXXXXXXXXXXXXXX',questIES.ClassName,result)
    if result ~= 'PROGRESS' then
--        print('UUUUUUUUUUUUUU',questIES.ClassName,result)
        return
    end
    
    local sObj = GetSessionObject(self, "ssn_smartgen");
    if sObj.LastGenPosServer ~= 'None' then
        local genflag_x, genflag_z = string.match(sObj.LastGenPosServer , '(.+)[/](.+)')
        if SCR_POINT_DISTANCE(x,z,genflag_x, genflag_z) < 300 then
--            print('POS_QUEST_AAAAAAAAAAAAAAAAA',SCR_POINT_DISTANCE(x,z,genflag_x, genflag_z),x,z,genflag_x, genflag_z)
            return
        end
    end
    
    local osTime = math.floor(os.clock())
    
    if sObj.LastGenTimeServer > 0 then
	    if sObj.LastGenTimeServer > osTime then
	        sObj.LastGenTimeServer = osTime
--	        print('TIME_QUEST_CCCCCC',sObj.LastGenTimeServer, osTime)
	        return
	    elseif sObj.LastGenTimeServer >= osTime - 30 then
--            print('TIME_QUEST_BBBBBBBBBB',sObj.LastGenTimeServer, osTime)
	        return
	    end
    end
--    print('HHHHHHHHHHHHHH')
    if dataList[1] == '1' then
        for x = 2, #dataList do
            if questIES['Succ_MonKillName'..dataList[x]] ~= 'ALL' then
                local monList = SCR_STRING_CUT(questIES['Succ_MonKillName'..dataList[x]])
                if #monList > 0 then
                    for y = 1, #monList do
                        addMonList[#addMonList + 1] = monList[y]
                    end
                end
            end
        end
    elseif dataList[1] == '2' then
        for x = 2, #dataList do
            if questIES['Succ_OverKillName'..dataList[x]] ~= 'ALL' then
                local monList = SCR_STRING_CUT(questIES['Succ_OverKillName'..dataList[x]])
                if #monList > 0 then
                    for y = 1, #monList do
                        addMonList[#addMonList + 1] = monList[y]
                    end
                end
            end
        end
    elseif dataList[1] == '3' then
        local listTxt = ''
        for x = 2, #dataList do
            for index = 1, 6 do
                if questIES['Succ_MonKill_ItemGive'..index] ~= 'None' and questIES['Succ_MonKill_ItemGive'..index] == 'Succ_InvItemName'..dataList[x] then
                    if questIES['Succ_MonKillName'..index] ~= 'None' and questIES['Succ_MonKillName'..index] ~= 'ALL' then
                        if listTxt == '' then
                            listTxt = questIES['Succ_MonKillName'..index]
                        else
                            listTxt = listTxt..'/'..questIES['Succ_MonKillName'..index]
                        end
                    end
                end
                if questIES['Succ_OverKill_ItemGive'..index] ~= 'None' and questIES['Succ_OverKill_ItemGive'..index] == 'Succ_InvItemName'..dataList[x] then
                    if questIES['Succ_OverKillName'..index] ~= 'None' and questIES['Succ_OverKillName'..index] ~= 'ALL' then
                        if listTxt == '' then
                            listTxt = questIES['Succ_OverKillName'..index]
                        else
                            listTxt = listTxt..'/'..questIES['Succ_OverKillName'..index]
                        end
                    end
                end
            end
        end
        
        if listTxt ~= '' then
            local monList = SCR_STRING_CUT(listTxt)
            if #monList > 0 then
                for y = 1, #monList do
                    addMonList[#addMonList + 1] = monList[y]
                end
            end
        end
    end
    
    addMonList = SCR_DUPLICATION_SOLVE_TABLE(addMonList)
    if #addMonList > 0 then
        
        local posInfo = SCR_QUEST_LOCATION_INFO(self, GetZoneName(self), questIES, x,y,z)
        if posInfo ~= nil then
            local monIESList = SCR_GET_AROUND_MONGEN_MONLIST(self, GetZoneName(self), GetCurrentFaction(self), posInfo[4], posInfo[1], posInfo[2], posInfo[3], addMonList, 'IES')
            if monIESList ~= nil then
                local x, y, z = GetPos(self)
                sObj.LastGenPosServer = math.floor(x)..'/'..math.floor(z)
                sObj.LastGenTimeServer = math.floor(os.clock())
                
                local count = 3
                local pos_list = SCR_CELLGENPOS_LIST(self, 'Front1', 0)
                local layer = GetLayer(self)
                
                for i = 1, count do
                    local mon = CREATE_MONSTER(self, monIESList[i].ClassType, pos_list[1][1], pos_list[1][2], pos_list[1][3], nil, monIESList[i].Faction, layer, nil, monIESList[i].Tactics, monIESList[i].Name, nil, nil, 1, nil, nil, monIESList[i].BTree,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,monIESList[i].SimpleAI)
                    if mon ~= nil then
--                        Chat(mon,'Line 721')
                        local monX, monY, monZ = GetPos(mon)
                        CustomMongoLog(self, "SmartGenMon", "Type", "QuestMon", "ClassName", monIESList[i], "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
--                        print('GGGGGGGGGG Line 721',monX, monY, monZ)
                        
                        LookAt(mon, self)
                        SetTendency(mon, 'Attack')
                        CreateSessionObject(mon, 'ssn_smartgen_mon')
                        return
                    end
                end
            end
        end
    end
end

function SCR_SMARTGEN_CHECK_CREATE(self, smartgenClassID)
	if GetLayer(self) ~= 0 then
        return
    end
    
	if IsJoinColonyWarMap(self) == 1 then
		return;
	end

    if IsInScrollLockBox(self) == 1 then
        return
    end
    
    local zone_name = GetZoneName(self);
	local x, y, z = GetPos(self);
    local smartgen = GetClassByType('SmartGen_'..zone_name, smartgenClassID);
	if smartgen == nil then
		return;
	end
    
	local sObj = GetSessionObject(self, "ssn_smartgen");
	if sObj.LastGenPosServer ~= 'None' then
        local genflag_x, genflag_z = string.match(sObj.LastGenPosServer , '(.+)[/](.+)')
        local x, y, z = GetPos(self)
        if SCR_POINT_DISTANCE(x,z,genflag_x, genflag_z) < 300 then
--            print('POS_BBBBBBBBBB',SCR_POINT_DISTANCE(x,z,genflag_x, genflag_z),x,z,genflag_x, genflag_z)
            return
        end
    end
    
    local osTime = math.floor(os.clock())
    
    if sObj.LastGenTimeServer > 0 then
	    if sObj.LastGenTimeServer > osTime then
	        sObj.LastGenTimeServer = osTime
--	        print('TIME_CCCCCCCCCCC',sObj.LastGenTimeServer, osTime)
	        return
	    elseif sObj.LastGenTimeServer >= osTime - 30 then
--            print('TIME_BBBBBBBBBB',sObj.LastGenTimeServer, osTime)
	        return
	    end
    end
    
	local mongen_range = SCR_POINT_DISTANCE(x, z, smartgen.PosX, smartgen.PosZ);
	local range = TryGet(smartgen, "Range");
    if range > 0 and mongen_range > range then
		return;
    end
	
	local aroundPC_Count = 0
    local scrollLockBoxRange = smartgen.ScrollLockBoxRange
        	    
    if scrollLockBoxRange == 0 then
        	    
		local mon_division = 1;
		if string.find(smartgen.ClassName, 'NormalMonGenPos') ~= nil then
    		mon_division = 2;
    	elseif string.find(smartgen.ClassName, 'SpecialMonGenPos') ~= nil then
    		mon_division = 1;
		end
		
		
		if mon_division == 1 then
		    if sObj.SpecialCooltime >= osTime - 150 and sObj.SpecialCooltime <= osTime then
		        return
    	    elseif sObj.SpecialCooltime > osTime then
	            sObj.SpecialCooltime = osTime
		    end
		elseif mon_division == 2 then
		    if sObj.NormalCooltime >= osTime - 150 and sObj.NormalCooltime <= osTime then
		        return
    	    elseif sObj.NormalCooltime > osTime then
	            sObj.NormalCooltime = osTime
		    end
		end
	
	    local objList, objCount = GET_PARTY_ACTOR(self, 0);
        local partyPC = {}
		if objCount > 0 then
			for index = 1, objCount do
				if objList[index].ClassName == 'PC' and IsSameActor(self,objList[index]) == 'NO' then
				    if GetDistance(self,objList[index]) <= 300 then
    	        		local AroundPC_sObj = GetSessionObject(objList[index], 'ssn_smartgen')
    	        		if AroundPC_sObj ~= nil then
       		        		local AroundPC_Accrue = {AroundPC_sObj.SpecialAccrue, AroundPC_sObj.NormalAccrue}
--       		        		if AroundPC_Accrue[mon_division] >= (smartgen.Accrue_Max * 2) then
            	                aroundPC_Count = aroundPC_Count + 1
       		        	        partyPC[#partyPC + 1] = objList[index]
--       		        		end
       					end
       				end
				end
			end
		end
		if #partyPC > 0 then
		    if mon_division == 1 then
    		    sObj.SpecialCooltime = math.floor(os.clock())
    		elseif mon_division == 2 then
    		    sObj.NormalCooltime = math.floor(os.clock())
    		end
		    for index = 1, #partyPC do
		        local AroundPC_sObj = GetSessionObject(partyPC[index], 'ssn_smartgen')
		        if mon_division == 1 then
    				RunScript('SCR_SMARTGEN_AROUNDPC_SOBJ', partyPC[index], AroundPC_sObj, 'SpecialAccrue', 'SpecialCooltime')
    			elseif mon_division == 2 then
    				RunScript('SCR_SMARTGEN_AROUNDPC_SOBJ', partyPC[index], AroundPC_sObj, 'NormalAccrue', 'NormalCooltime')
    			end
		    end
		end
	end
        	    
    local boxMon
    local dispositionType = smartgen.DispositionType
    local zoneInstID = GetZoneInstID(self)
    local summon_monlist = {}
        	    
    if dispositionType ~= 'None' then
        local dispositionTypelist = SCR_STRING_CUT(dispositionType)
        	        
        dispositionType = dispositionTypelist[IMCRandom(1, #dispositionTypelist)]
    end
        	    
    if scrollLockBoxRange > 0 then
        boxMon = CREATE_BATTLE_BOX(self, 20, "None", 1000, x - scrollLockBoxRange / 2, y, z - scrollLockBoxRange/ 2, x + scrollLockBoxRange / 2, y, z + scrollLockBoxRange / 2);
    end
    if GetPropType(smartgen,'TimeCycle') ~= nil and  smartgen.TimeCycle ~= 'None' then
        local mon = CREATE_MONSTER(self, 'HiddenTrigger2', x, y, z, nil, 'Neutral', GetLayer(self), 1, 'MON_SMARTGEN_TIMECYCLE')
        if mon ~= nil then
            local monX, monY, monZ = GetPos(mon)
            CustomMongoLog(self, "SmartGenMon", "Type", "TIMECYCLE", "ClassName", 'HiddenTrigger2', "Pos", monX..'/'..monY..'/'..monZ, "ServerOSClock", math.floor(os.clock()))
            
        	SetExProp_Str(mon,'TIMECYCLE_CLASS',smartgen.ClassName)
        	SetExProp_Str(mon,'TIMECYCLE_DISPOSTYPE',dispositionType)
        	SetTacticsArgObject(mon, self, boxMon);
        	mon_summon = 'YES'
        	summon_monlist[#summon_monlist + 1] = mon
        end
    else
        local x, y, z = GetPos(self)
        sObj.LastGenPosServer = math.floor(x)..'/'..math.floor(z)
        sObj.LastGenTimeServer = math.floor(os.clock())
        local mon_summon_temp, summon_monlist_temp = SCR_SMARTGEN_MON_SUMMON(self, sObj.Tendency_Flag, aroundPC_Count, smartgen, dispositionType, x, y, z)
        if mon_summon == nil or mon_summon == 'NO' then
        	mon_summon = mon_summon_temp
        end
        	        
        summon_monlist = summon_monlist_temp
    end
                
    if summon_monlist ~= nil and #summon_monlist > 0 then
        if string.find(smartgen.ClassName, 'NormalMonGenPos') ~= nil then
    	    sObj.NormalAccrue = 0
    	elseif string.find(smartgen.ClassName, 'SpecialMonGenPos') ~= nil then
    	    sObj.SpecialAccrue = 0
    	end
    end
                
    if boxMon ~= nil then
        if summon_monlist ~= nil and #summon_monlist > 0 then
            local summon_moncount
            for summon_moncount = 1, #summon_monlist do
                ADD_BATTLE_BOX_MONSTER(boxMon, summon_monlist[summon_moncount]);
            end
        else
            END_BATTLE_BOX(boxMon)
        end
    end
end


