s_warpDestYPos	 = 20.0;

function SCR_PRE_SIAUL1_STATPOINT1(pc)
    if pc.Lv >= 6 and pc.StatByLevel + pc.StatByBonus - pc.UsedStat >= 1 then
        return 'YES'
    end
end

function GET_QUEST_RET_POS(pc, questIES, inputNpcState)

    local questnpc_state;
	if inputNpcState == nil then
		local result = SCR_QUEST_CHECK(pc, questIES.ClassName);
		questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
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
                    if GetInvItemCount(pc, questIES['InvItemName'..i]) == 0 then
                        flag = true
                    end
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
