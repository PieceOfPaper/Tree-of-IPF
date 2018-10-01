s_warpDestYPos	 = 20.0;

function SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questName)
    local questIES = GetClass('QuestProgressCheck',questName)
    local quest_auto = GetClass('QuestProgressCheck_Auto',questName)
    local ret2 = {}
    if questIES == nil or quest_auto == nil then
        return 'NO', ret2
    end
    if TryGetProp(quest_auto , 'StepRewardList1') ~= nil and TryGetProp(quest_auto , 'StepRewardList1') ~= 'None' then
        local duplicate = TryGetProp(quest_auto, 'StepRewardDuplicatePayments')
        local lastReward
        local lastRewardList
        local ret1 = 'YES'
        if duplicate == 'NODUPLICATE' then
            local sObj = GetSessionObject(pc, 'ssn_klapeda')
            lastRewardList = TryGetProp(sObj, questIES.QuestPropertyName..'_SRL')
            if lastRewardList ~= nil and lastRewardList ~= 'None' then
                lastReward = SCR_STRING_CUT(lastRewardList)
                
                for index = 1, 10 do
                    if TryGetProp(quest_auto , 'StepRewardList'..index) ~= nil and TryGetProp(quest_auto , 'StepRewardList'..index) ~= 'None' then
                        if table.find(lastReward, index) == 0 then
                            ret2[#ret2 + 1] = index
                        end
                    end
                end
                
                return ret1, ret2
            end
        else
            ret1 = 'DUPLICATE'
        end
        
        for index = 1, 10 do
            local stepRewardList = TryGetProp(quest_auto, 'StepRewardList'..index)
            if stepRewardList ~= nil and stepRewardList ~= 'None' then
                ret2[#ret2 + 1] = index
            end
        end
        return ret1, ret2
    else
        return 'NO', ret2
    end
end

function SCR_PRE_SIAUL1_STATPOINT1(pc)
    if pc.Lv >= 6 and pc.StatByLevel + pc.StatByBonus - pc.UsedStat >= 1 then
        return 'YES'
    end
end

function GET_QUEST_RET_POS(pc, questIES, inputNpcState)

    local questnpc_state;
	if inputNpcState == nil then
		local result = SCR_QUEST_CHECK(pc, questIES.ClassName);
		questnpc_state = GET_QUEST_NPC_STATE(questIES, result, pc);
	else
		questnpc_state = inputNpcState;
	end
	
    if questnpc_state ~= nil then
    	local mapProp = geMapTable.GetMapProp(questIES[questnpc_state..'Map']);
    	if mapProp ~= nil then
    	    local npcFunc = questIES[questnpc_state..'NPC']
    		local npcProp = mapProp:GetNPCPropByDialog(npcFunc);
    		if npcProp~= nil then
				local genList = npcProp.GenList;
				if genList:Count() == 0 then
					return nil;
				end

    			local genPos = genList:Element(0);
				local genDirection = npcProp.direction;

    			genDirection = genDirection * math.pi / 180;

    			local xDir = math.cos(genDirection);
    			local yDir = math.sin(genDirection);
    			local retX = genPos.x + xDir * 20.0
    			local retZ = genPos.z + yDir * 20.0
    			
    			if npcFunc == 'SIAULIAIOUT_MINER_B' then
    			    retX = genPos.x - xDir * 20.0
    			    retZ = genPos.z - yDir * 20.0
    			elseif npcFunc == 'CMINE3_BOSSROOM_OPEN' then
    			    retX = genPos.x - xDir * 800.0
    			    retZ = genPos.z + yDir * 10.0
    			elseif npcFunc == 'ABBEY642_ROZE01' then
    			    retX = genPos.x - xDir * 10.0
    			    retZ = genPos.z + yDir * 10.0
    			elseif npcFunc == 'ABBEY641_MONK03' then
    			    retX = genPos.x - xDir * 30.0
    			    retZ = genPos.z - yDir * 30.0
    			end
				return questIES[questnpc_state..'Map'], retX, genPos.y + s_warpDestYPos, retZ
			end
		end
	end

	return nil;
end

function DROPITEM_REQUEST1_PROGRESS_CHECK_FUNC(pc)
    local itemList, monList, zoneClassNameList = DROPITEM_REQUEST1_PROGRESS_CHECK_FUNC_SUB(pc)
    if #itemList > 2 or #monList > 2 or #zoneClassNameList > 2 then
        return 'YES'
    end
    return 'NO'
end

function DROPITEM_REQUEST1_PROGRESS_CHECK_FUNC_SUB(pc)
    local pcLv = pc.Lv
    local minRange = 20
    local maxRange = 10
    local zoneClassNameList = {}
    local class_count = GetClassCount('Map')
    local itemList = {}
    local monList = {}
    
    local maxlevel = PC_MAX_LEVEL
    
    if pc.Lv + maxRange > maxlevel then
        minRange = minRange + (pc.Lv + maxRange - maxlevel)
    end
    
    for i = 0, class_count -1 do
        local mapIES = GetClassByIndex('Map', i)
        if mapIES ~= nil then
            if (mapIES.MapType == 'Field' or mapIES.MapType == 'Dungeon') and mapIES.WorldMapPreOpen == 'YES' and IS_FREE_DUNGEON(mapIES.ClassName) == 'NO' then
                if mapIES.QuestLevel >= pcLv - minRange and mapIES.QuestLevel <= pcLv + maxRange then
                    zoneClassNameList[#zoneClassNameList + 1] = mapIES.ClassName
                end
            end
        end
    end
    
--    if #zoneClassNameList > 0 then
--        local anotherPC = 13
--        local genTiem = 0.5
--        local basicTime = 15
--        for y = 1, #zoneClassNameList do
--            local targetZone = zoneClassNameList[y]
--            local targetMonList = SCR_GET_ZONE_FACTION_OBJECT(targetZone, 'Monster', 'Normal/Material/Elite', 120000)
--            local accMax = 0
--            if #targetMonList > 0 then
--                local zoneMonMaxPop = 0
--                for i = 1, #targetMonList do
--                    zoneMonMaxPop = zoneMonMaxPop + targetMonList[i][2]
--                end
--                for i = 1, #targetMonList do
--                    local maxPop = targetMonList[i][2]
--                    if maxPop/zoneMonMaxPop*100 >= 10 then
--                        local droplist = targetMonList[i][4]
--                        local dropID = 'MonsterDropItemList_'..droplist
--                        local dropClassCount = GetClassCount(dropID)
--                        if dropClassCount ~= nil and dropClassCount > 0 then
--                            for c = 0, dropClassCount - 1 do
--                                local dropIES = GetClassByIndex(dropID, c)
--                                if dropIES.GroupName == 'Item' then
--                                    local itemIES = GetClass('Item', dropIES.ItemClassName)
--                                    if itemIES ~= nil then
--                                        if itemIES.ItemType == 'Etc' and itemIES.GroupName == 'Material' then
--                                            local flag = false
--                                            for index = 1, #itemList do
--                                                if itemList[index][1] == dropIES.ItemClassName then
--                                                    flag = true
--                                                    break
--                                                end
--                                            end
--                                            
--                                            if flag == false then
--                                                local ratio = dropIES.DropRatio / 10000
--                                                if dropIES.DPK_Min > 0 and dropIES.DPK_Max > 0 then
--                                                    ratio = 1/((dropIES.DPK_Min + dropIES.DPK_Max)/2) * ratio
--                                                end
--                                                local maxMonCount =  basicTime / genTiem * maxPop
--                                                local maxDropCount =  math.floor(maxMonCount * ratio / anotherPC)
--                                                
--                                                if maxDropCount >= 5 then
--                                                    accMax = accMax + maxDropCount
--                                                    itemList[#itemList + 1] = {}
--                                                    itemList[#itemList][1] = dropIES.ItemClassName
--                                                    itemList[#itemList][2] = maxDropCount
--                                                    itemList[#itemList][3] = targetZone
--                                                end
--                                            end
--                                        end
--                                    end
--                                end
--                            end
--                        end
--                    end
--                end
--            end
--        end
--    end
    
    
    
--    if #zoneClassNameList > 0 then
--        local removeMonList = {"Silvertransporter_Qm", "Treasure_Goblin"}
--        local basicTime = 15
--        local genTiem = 0.5
--        local anotherPC = 5
--        for y = 1, #zoneClassNameList do
--            local targetZone = zoneClassNameList[y]
--            local targetMonList = SCR_GET_ZONE_FACTION_OBJECT(targetZone, 'Monster', 'Normal/Material/Elite', 120000)
--            local accMax = 0
--            if #targetMonList > 0 then
--                local zoneMonMaxPop = 0
--                for i = 1, #targetMonList do
--                    zoneMonMaxPop = zoneMonMaxPop + targetMonList[i][2]
--                end
--                for i = 1, #targetMonList do
--                    if table.find(removeMonList, targetMonList[i][1]) == 0 then
--                        local maxPop = targetMonList[i][2]
--                        if maxPop/zoneMonMaxPop*100 >= 10 then
--                            local maxMonCount =  basicTime / genTiem * maxPop
--                            local killCount =  math.floor(maxMonCount / anotherPC)
--                            
--                            
--                            if killCount > 80 and killCount < 400 then
--                                if killCount >= 200 then
--                                    killCount = math.floor(killCount * 0.6)
--                                elseif killCount >= 100 then
--                                    killCount = math.floor(killCount * 0.8)
--                                elseif killCount >= 50 then
--                                    killCount = math.floor(killCount * 0.9)
--                                end
--                                if killCount > 170 then
--                                    killCount = 170
--                                end
--                                monList[#monList + 1] = {}
--                                monList[#monList][1] = targetMonList[i][1]
--                                monList[#monList][2] = killCount
--                                monList[#monList][3] = targetZone
--                            end
--                        end
--                    end
--                end
--            end
--        end
--    end
    
    return itemList, monList, zoneClassNameList
end

function IS_FREE_DUNGEON(zoneClassName)
    local freeDungeonList = {
                                'd_limestonecave_73_1',
                                'd_prison_75_1',
                                'd_startower_76_1',
                                'd_velniasprison_77_1',
                                'd_cathedral_78_1',
                                'd_zachariel_79_1',
                                'd_zachariel_79_2',
                                'd_catacomb_80_1',
                                'd_catacomb_80_2',
                                'd_catacomb_80_3',
                                'd_startower_76_2'
                            }
    if table.find(freeDungeonList,zoneClassName) == 0 then
        return 'NO'
    else
        return 'YES'
    end
    
    return 'NO'
end

function SCR_JOB_PROPERTYQUESTCHECK(pc, questname, scriptInfo)
    local result = 'NO'
    local jlv, total = GetJobLevelByName(pc, pc.JobName);
    
--    local changedJobCount = 1
--    if IsServerSection(pc) == 1 then
--        grade, changedJobCount = GetJobGradeByName(pc, pc.JobName);
--    else
--        changedJobCount = session.GetPcTotalJobGrade()
----    end
--    
--    if jlv >= 5 + changedJobCount * 5 then
    if jlv >= 15 then
        local pcjobinfo = GetClass('Job', pc.JobName)
        local tarjobinfo = GetClass('Job', scriptInfo[2])
        if pcjobinfo.CtrlType == tarjobinfo.CtrlType then
            local questIES = GetClass('QuestProgressCheck', questname)
            
            local circle = 0
            local temp
            local totalRank
            if IsServerSection(pc) == 1 then
                circle = GetJobGradeByName(pc, scriptInfo[2]);
                temp, totalRank = GetJobGradeByName(pc, pc.JobName);
            else
                circle = session.GetJobGrade(tarjobinfo.ClassID)
                totalRank = session.GetPcTotalJobGrade()
            end
            
            if totalRank + 1 ~= tarjobinfo.Rank and pc.JobName ~= scriptInfo[2] then
                return 'NO'
            end
            
            
            if circle >= 3 then
                return 'NO'
            end
            
            if questIES.JobStep > 0 then
                local questList = SCR_GET_XML_IES('QuestProgressCheck','JobStep',questIES.JobStep)
                local flag = 0
                local main_sObj = GetSessionObject(pc, 'ssn_klapeda')
                if main_sObj ~= nil then
                    for i = 1, #questList do
                        if questList[i].ClassName ~= questname then
                            if main_sObj[questList[i].QuestPropertyName] > 0 then
                                flag = 1
                                break
                            end
                        end
                    end
                    if flag == 0 then
                        return 'YES'
                    end
                end
            end
        end
    end
    return result
end

function IS_SELECTED_JOB(pc, questname, scriptInfo)

	local etcObj
	if IsServerSection(pc) == 1 then
		etcObj = GetETCObject(pc);
	else
		etcObj = GetMyEtcObject();
		
	end
    
    
--    if IS_SEASON_SERVER(pc) == 'YES' then
--        local temp
--        local totalRank
--        if IsServerSection(pc) == 1 then
--            temp, totalRank = GetJobGradeByName(pc, pc.JobName);
--        else
--            totalRank = session.GetPcTotalJobGrade()
--        end
--        if totalRank >= 7 then
--            return 'NO'
--        end
--    end

	local jobclassid = 0

	local clslist, cnt  = GetClassList("Job");

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);

		local breakflag = 0

		for j = 1, 3 do
			--local strtemp = 'ChangeJobQuest' .. j
			local strtemp = "ChangeJobQuestCircle"..j
			local sObj = GetSessionObject(pc, 'ssn_klapeda')
        	if sObj.QSTARTZONETYPE == "StartLine1" then
        		strtemp = strtemp.."_1"
        	elseif sObj.QSTARTZONETYPE == "StartLine2" then
        		strtemp = strtemp.."_2"
        	else
        	    --Error Prevention : If StartLine isn't present, StartLine is _1 (Klapeda)--
        	    strtemp = strtemp.."_1"
        	end
			local tempquestname = cls[strtemp]
			if tempquestname == questname then
				jobclassid = cls.ClassID
				breakflag = 1
				break
			end
		end

		if breakflag == 1 then
			break
		end

	end

	if jobclassid == 0 then
		return 'NO'
	end


	local jobchanging = etcObj.JobChanging


	if jobclassid == jobchanging then

		return 'YES'
	end

	return 'NO'
end



---- Is it possible to hidden class?
--IS_POSSIBLE_HIDDEN_JOB/job_ClassName
function IS_POSSIBLE_HIDDEN_JOB(pc, questname, scriptInfo)
--    local etcObj
--    if IsServerSection(pc) == 1 then
--        etcObj = GetETCObject(pc);
--    else
--        etcObj = GetMyEtcObject();
--    end
--    
--    local clslist, cnt  = GetClassList("QuestProgressCheck_Auto");
--    local cls = GetClassByNameFromList(clslist, questname)
--    
--    if cls.Success_ChangeJob ~= nil then
--        local _hidden_job = cls.Success_ChangeJob;
--        
--        if etcObj["HiddenJob_".._hidden_job] == 300 then
--            return "YES"
--        end
--    end
--    return 'NO'



    local etcObj
    if IsServerSection(pc) == 1 then
        etcObj = GetETCObject(pc);
    else
        etcObj = GetMyEtcObject();
    end
    
    if scriptInfo[2] ~= nil then
        local classlist, class_cnt = GetClassList("Job")
        local selct_classlist = GetClassByNameFromList(classlist, scriptInfo[2])
        if selct_classlist ~= nil then
            if selct_classlist.HiddenJob == "YES" then
                if etcObj["HiddenJob_"..scriptInfo[2]] == 300 or IS_KOR_TEST_SERVER() then
                    return "YES"
                end
            end
        end
    end
    return 'NO'
end



function SCR_TUT_COLLECT_01_PRE_FUNC(pc, questname, scriptInfo)
    local zoneName = GetZoneName(pc)
    if zoneName ~= 'f_siauliai_west' then
        return 'YES'
    end
    return 'NO'
end

function SCR_QUEST_REASON_TXT(pc, questIES, quest_reason)
    local txt = ''
    for index = 1, #quest_reason do
        if txt ~= '' then
            txt = txt..', '
        end
        if quest_reason[index] == 'Lvup' then
            txt = txt..questIES.Lvup..ScpArgMsg('QuestReasonTxtLvup')
        elseif quest_reason[index] == 'Lvdown' then
            txt = txt..questIES.Lvdown..ScpArgMsg('QuestReasonTxtLvdown')
        elseif quest_reason[index] == 'JobStep' then
            if questIES.JobStepTerms == 'EQUAL' then
                txt = txt..questIES.JobStep..ScpArgMsg('QuestReasonJobStepEqual')
            elseif questIES.JobStepTerms == 'OVER' then
                txt = txt..questIES.JobStep..ScpArgMsg('QuestReasonJobStepOver')
            elseif questIES.JobStepTerms == 'BELOW' then
                txt = txt..questIES.JobStep..ScpArgMsg('QuestReasonJobStepBelow')
            end
        elseif quest_reason[index] == 'JobLvup' then
        elseif quest_reason[index] == 'JobLvdown' then
        elseif quest_reason[index] == 'Atkup' then
        elseif quest_reason[index] == 'Atkdown' then
        elseif quest_reason[index] == 'Defup' then
        elseif quest_reason[index] == 'Defdown' then
        elseif quest_reason[index] == 'Mhpup' then
        elseif quest_reason[index] == 'Mhpdown' then
        elseif quest_reason[index] == 'Check_QuestCount' then
            local sObj = GetSessionObject(pc, 'ssn_klapeda')
            for i = 1, 4 do
                if questIES['QuestName'..i] ~= 'None' then
                    local ret = SCR_QUEST_PRE_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, i)
                    if ret == 'NO' then
                        local reasonQuestName = GetClassString('QuestProgressCheck',questIES['QuestName'..i], 'Name')
                        local reasonQuestState = ''
                        local reasonQuestTerms = ''
                        
                        if questIES['QuestCount'..i] == CON_QUESTPROPERTY_MIN then
                            reasonQuestState = ScpArgMsg('Quest_PROGRESS')
                        elseif questIES['QuestCount'..i] == CON_QUESTPROPERTY_MAX then
                            reasonQuestState = ScpArgMsg('Quest_SUCCESS')
                        elseif questIES['QuestCount'..i] == CON_QUESTPROPERTY_END then
                            reasonQuestState = ScpArgMsg('Quest_COMPLETE')
                        end
                        
                        if reasonQuestName ~= nil and reasonQuestName ~= '' then
                            txt = txt..reasonQuestName..' '..reasonQuestState
                        end
                    end
                end
            end
        elseif quest_reason[index] == 'Check_Tribe' then
        elseif quest_reason[index] == 'Check_Job' then
        elseif quest_reason[index] == 'Gender' then
            if questIES.Gender == 1 then
                txt = txt..questIES.JobStep..ScpArgMsg('QuestReasonGender1')
            elseif questIES.Gender == 2 then
                txt = txt..questIES.JobStep..ScpArgMsg('QuestReasonGender2')
            end
        elseif quest_reason[index] == 'Check_InvItem' then
            for i = 1, 4 do
                local flag = false
                if questIES['InvItemCount'..i] == 0 then
                    flag = true
                else
                    if GetInvItemCount(pc, questIES['InvItemName'..i]) >= questIES['InvItemCount'..i] then
                        flag = true
                    end
                end
                if flag == false then
                    local itemName = GetClassString('Item',questIES['InvItemName'..i], 'Name')
                    if itemName ~= nil then
                        txt = txt..itemName..ScpArgMsg('QuestReasonInvItemName')..questIES['InvItemCount'..i]..ScpArgMsg('QuestReasonInvItemCount')
                    end
                end
            end
        elseif quest_reason[index] == 'Check_EqItem' then
        elseif quest_reason[index] == 'Check_Buff' then
        elseif quest_reason[index] == 'Check_Location' then
        elseif quest_reason[index] == 'Check_PeriodType' then
        elseif quest_reason[index] == 'ReenterTime' then
        elseif quest_reason[index] == 'Check_Skill' then
        elseif quest_reason[index] == 'SkillLv' then
        elseif quest_reason[index] == 'AOSLine' then
        elseif quest_reason[index] == 'NPCQuestCount' then
        elseif quest_reason[index] == 'HonorPointUp' then
        elseif quest_reason[index] == 'HonorPointDown' then
        elseif quest_reason[index] == 'Check_Script' then
        elseif quest_reason[index] == 'Mhpup_Mhpdown' then
        end
    end
    
    return txt
end

function SCR_HIDDEN_MIKO_GENDER_CHECK(pc, questname, scriptInfo)
    if pc.ClassName == 'PC' then
        local pcGender = pc.Gender
        if pcGender == 2 then
            return 'YES'
        end
    end
    return 'NO'
end


function SCR_TUTO_TP_SHOP_PRECHECK_FUNC(pc, questname, scriptInfo)
    local aObj
    
    if IsServerSection(pc) == 1 then
        aObj = GetAccountObj(pc);
    else
        aObj = GetMyAccountObj();
    end
    if aObj.TUTO_TP_SHOP_REWARD == 0 then
        return 'YES'
    end
    return 'NO'
end

--function CCC(pc, argList)
--    print('CCC',pc.Name, argList)
--    return 'NO'
--end
--
--function BBB(pc, argList)
--    print('BBB',pc.Name, argList)
--    return 'NO'
--end
--
--function AAAAA(pc, argList)
--    print('AAAAA',pc.Name, argList)
--    return 'NO'
--end

function SCR_JOB_RETIARII1_PRE_FUNC(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then
        return 'NO'
    end
    
    return 'YES'
end

function SCR_JOB_RETIARII1_STEPREWARD_CHECK1(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_RETIARII1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 250 then
            return 'YES'
        end
    end
end

function SCR_JOB_RETIARII1_STEPREWARD_CHECK2(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_RETIARII1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 330 then
            return 'YES'
        end
    end
end

function SCR_JOB_RETIARII1_STEPREWARD_CHECK3(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_RETIARII1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 450 then
            return 'YES'
        end
    end
end

function SCR_JOB_BULLETMARKER1_PRE_FUNC(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then
        return 'NO'
    end
    
    return 'YES'
end

function SCR_JOB_BULLETMARKER1_STEPREWARD_CHECK1(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_BULLETMARKER1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 300 then
            return 'YES'
        end
    end
end

function SCR_JOB_BULLETMARKER1_STEPREWARD_CHECK2(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_BULLETMARKER1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 380 then
            return 'YES'
        end
    end
end

function SCR_JOB_BULLETMARKER1_STEPREWARD_CHECK3(pc, stepRewardFuncList)
    local sObj = GetSessionObject(pc, 'SSN_JOB_BULLETMARKER1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 460 then
            return 'YES'
        end
    end
end


function SCR_ZEALOT_QUEST_COSTUME_REWARD1(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_ZEALOT_QUEST_COSTUME')
    if sObj ~= nil then
        if 1 == sObj.Step5 then
            return 'YES'
        end
    end
    
    return 'NO'
end

function SCR_ZEALOT_QUEST_COSTUME_REWARD2(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_ZEALOT_QUEST_COSTUME')
    if sObj ~= nil then
        if 2 == sObj.Step5 then
            return 'YES'
        end
    end
    
    return 'NO'
end

function SCR_ZEALOT_QUEST_COSTUME_REWARD3(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_ZEALOT_QUEST_COSTUME')
    if sObj ~= nil then
        if 3 == sObj.Step5 then
            return 'YES'
        end
    end
    
    return 'NO'
end

function SCR_ZEALOT_QUEST_COSTUME_START_CHECK(pc, questname)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then
        return 'NO'
    end
    
    return 'YES'
end

function SCR_JOB_EXORCIST1_PRE_FUNC(pc, questname, scriptInfo)
    local result1, result2 = SCR_STEPREWARD_QUEST_REMAINING_CHECK(pc, questname)
    if result1 == 'YES' and #result2 == 0 then
        return 'NO'
    end
    
    return 'YES'
end


function SCR_JOB_EXORCIST1_REWARD1(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_EXORCIST1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 400 then
            return 'YES'
        end
    end
    
    return 'NO'
end

function SCR_JOB_EXORCIST1_REWARD2(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_EXORCIST1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 450 then
            return 'YES'
        end
    end
    
    return 'NO'
end

function SCR_JOB_EXORCIST1_REWARD3(self)
    local sObj = GetSessionObject(self, 'SSN_JOB_EXORCIST1')
    if sObj ~= nil then
        if sObj.QuestInfoValue1 >= 500 then
            return 'YES'
        end
    end
    
    return 'NO'
end