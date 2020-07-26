

function QT(pc)

	SCR_QUESTPROGRESS_CHECK(pc, nil, nil, nil);
end

function QC(pc, questname)
    if IsServerSection(pc) ~= 1 and pc == nil then
        pc = GetMyPCObject()
    end
    local result1, result2 = SCR_QUEST_CHECK(pc,questname, nil)
    if IsServerSection(pc) == 1 then
        Chat(pc,'IsServer : '..IsServerSection(pc)..' / '..questname..' = '..result1)
    else
        ui.Chat('Client SCR_QUEST_CHECK / '..questname..' = '..result1)
        
        local result3 = SCR_QUEST_CHECK_C(pc, questname)
        ui.Chat('Client SCR_QUEST_CHECK_C / '..questname..' = '..result3)
    end
    if result2 ~= nil then
        print('result1',result1,table.concat(result2,' : '))
    else
        print('result1',result1)
    end
    
    if IsServerSection(pc) == 1 then
        ExecClientScp(pc, 'QC(nil,"'..questname..'")');
    end
end

function SCR_QUESTPROGRESS_CHECK( pc, quest_list, quest_name, npcquestcount_list)
    local i = 1;
    local y = 1;
    if quest_list == nil and quest_name == nil then
        local quest_list_copy = {};
        local quest_name_copy = {};
        local quest_index = GetClassCount('QuestProgressCheck')
        
        for i = 0, quest_index -1 do
    
            if GetClassStringByIndex('QuestProgressCheck', i, 'ClassName') ~= 'None' then
                quest_list_copy[y] = GetClassStringByIndex('QuestProgressCheck', i, 'ClassName');
                quest_name_copy[y] = GetClassStringByIndex('QuestProgressCheck', i, 'Name');
                y = y + 1;
            end
        end
        quest_list = quest_list_copy;
        quest_name = quest_name_copy;
    end
    
    local table_count = #quest_list;
    local quest_count = 0;
    local quest_check = {};
    local lvImpossibleList = {}
    local quest_succ = 0;
    local quest_progress = 0;
    local questIES
    
    for i = 1, table_count do
        local quest_reason
        quest_check[i], quest_reason = SCR_QUEST_CHECK(pc,quest_list[i], npcquestcount_list);
        if quest_check[i] == 'IMPOSSIBLE' then
            if #quest_reason == 1 and quest_reason[1] == "Lvup" then
                local questIES = GetClass('QuestProgressCheck',quest_list[i])
                if questIES.QuestMode == 'MAIN' and questIES.QuestStartMode ~= 'SYSTEM' and questIES.Lvup >= 0 then
                    lvImpossibleList[#lvImpossibleList + 1] = quest_list[i]
                end
            end
        elseif quest_check[i] == 'POSSIBLE' then
            quest_count = quest_count + 1;
        elseif quest_check[i] == 'PROGRESS' then
            quest_progress = quest_progress + 1;
        elseif quest_check[i] == 'SUCCESS' then
            quest_succ = quest_succ + 1;
        elseif quest_check[i] == 'COMPLETE' then
        end
    end
    
    local count = #quest_check;
--    print('quest_count',quest_count);
--    print('quest_succ',quest_succ);
--    print('quest_progress',quest_progress);
--    for i = 1, count do
--        print('quest_list['..i..'] '..quest_list[i]);
--        print('quest_name['..i..'] '..quest_name[i]);
--        print('quest_check['..i..'] '..quest_check[i]);
--    end
    
    return quest_count , quest_check, quest_succ, quest_progress, lvImpossibleList;
end

function SCR_QUEST_CHECK(pc,questname,npcquestcount_list)    
    
	if pc == nil then
		return;
	end

    if pc.ClassName ~= 'PC' then
        if IsServerSection(pc) == 1 then
            print(ScpArgMsg("Auto_{Auto_1}_KweSeuTeuui_CheKeuSi_PCKa_aNin_{Auto_2}_ui_aegTeoJeongBoKa_NeomeooKo_issSeupNiDa.","Auto_1",questname,"Auto_2",pc.Name))
	        return;
        end
    end
    if questname == 'None' then
        return
    end
    local questIES = GetClass('QuestProgressCheck', questname);
    local quest_reason = {}
    local sObj_quest
    local ssnInvItemCheck = false
    local ssnMonCheck = false
    
    if questIES ~= nil then
        local req_startarea = 'NO'
        local req_end = 'NO';
        local req_lvup = 'NO';
        local req_lvdown = 'NO';
        local req_jobstep = 'NO';
        local req_joblvup = 'NO';
        local req_joblvdown = 'NO';
        local req_atkup = 'NO';
        local req_atkdown = 'NO';
        local req_defup = 'NO';
        local req_defdown = 'NO';
        local req_mhpup = 'NO';
        local req_mhpdown = 'NO';
        local req_quest = 'NO';
        local req_tribe = 'NO';
        local req_job = 'NO';
        local req_Gender = 'NO';
        local req_InvItem = 'NO';
        local req_EqItem = 'NO';
        local req_Skill = 'NO';
        local req_SkillLv = 'NO';
        local req_Buff = 'No';
        local req_Location = 'No';
        local req_Period = 'No';
        local req_ReenterTime = 'No';
        local reenterRemainTimeSec = 0
        local req_AOSLine = 'No';
        local req_NPCQuestCount = 'No';
        local req_HonorPointUp = 'No';
        local req_HonorPointDown = 'No';
        local req_Script = 'No';
        local req_PartyProp = 'No';
        local req_Repeat = 'No';
        local req_JournalMonKill = 'No';
        
        local req_invitem_check = 0;
        local req_eqitem_check = 0;
        local req_skill_check = 0;
        local req_buff_check = 0;
        local req_script_check = 0;
        
        local sObj = GetSessionObject(pc, 'ssn_klapeda');
        
        if sObj == nil then
            quest_reason[1] = ScpArgMsg("Auto_Mein_MaeNiJeo_SeSyeoni_eopeum")
            return 'IMPOSSIBLE', quest_reason;
        elseif sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MAX and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_END then
            quest_reason[1] = sObj[questIES.QuestPropertyName]..ScpArgMsg("Auto__PeuLoPeoTi_Kapi_")..CON_QUESTPROPERTY_MAX..ScpArgMsg("Auto__KapKwa_KatDa.")
            return 'SUCCESS';
        elseif sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MAX then 
            if questIES.Succ_Check_Condition == 'None' then
                local Succ_req_InvItem = 'NO';
                local Succ_req_SSNInvItem = 'NO';
                local Succ_req_EqItem = 'NO';
                local Succ_req_Buff = 'No';
                local Succ_req_Lv = 'No';
                local Succ_req_Atkup = 'No';
                local Succ_req_Defup = 'No';
                local Succ_req_Mhpup = 'No';
                local Succ_req_MonKill = 'No';
                local Succ_req_OverKill = 'No';
                local Succ_req_Skill = 'NO';
                local Succ_req_Quest = 'NO';
                local Succ_req_HonorPoint = 'NO';
                local Succ_req_MapFogSearch = 'NO';
                local Succ_req_SessionObject = 'No';
                local Succ_req_Script = 'No';
                local Succ_req_JournalMonKill = 'No';
                
                
                local Succ_req_eqitem_check = 0;
                local Succ_req_buff_check = 0;
                local Succ_req_skill_check = 0;
                local Succ_req_script_check = 0;
                
                local noSuccessPropertyChangeFlag = 0
                
--                if sObj ~= nil then
--                    if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_END then
--                        req_end = 'NO'
--                        return 'COMPLETE'
--                    else
--                        req_end = 'YES'
--                    end
--                end
                
                if pc.Lv >= questIES.Succ_Lv then
                    Succ_req_Lv = 'YES';
                end
                
                if pc.MAXPATK >= questIES.Succ_Atkup or pc.MAXMATK >= questIES.Succ_Atkup then
                    Succ_req_Atkup = 'YES';
                end
                
                if pc.DEF >= questIES.Succ_Defup then
                    Succ_req_Defup = 'YES';
                end
                
                if pc.MHP >= questIES.Succ_Mhpup then
                    Succ_req_Mhpup = 'YES';
                end
                
                if questIES.Succ_HonorPoint == 'None' then
                    Succ_req_HonorPoint = 'YES'
                else
                    local honor_name, point_value = string.match(questIES.Succ_HonorPoint,'(.+)[/](.+)')
                    
                    if honor_name ~= nil then
                        local honor_point = GetAchievePoint(pc, honor_name)
                        if honor_point >= tonumber(point_value) then
                            Succ_req_HonorPoint = 'YES'
                        end
                    end
                end
                
                if questIES.Succ_MapFogSearch == 'None' then
                    Succ_req_MapFogSearch = 'YES'
                else
                    local mapList = SCR_STRING_CUT(questIES.Succ_MapFogSearch)
                    local flag = true
                    for x = 1, #mapList/2 do
                        local map_classname = mapList[x*2 - 1]
                        local percent = mapList[x*2]
                        if map_classname ~= nil then
                            local now_percent = GetMapFogSearchRate(pc, map_classname)
                            if now_percent == nil then
                                flag = false
                                break
                            end
                            if math.floor(now_percent) < tonumber(percent) then
                                flag = false
                                break
                            end
                        else
                            flag = false
                            break
                        end
                    end
                    
                    if flag == true then
                        Succ_req_MapFogSearch = 'YES'
                    end
                end
                
                if questIES.Quest_SSN == 'None' then
                    Succ_req_SessionObject = 'YES'
                else
                    sObj_quest = GetSessionObject(pc, questIES.Quest_SSN);
                    
                    if sObj_quest ~= nil then
                        local index
                        local max = 0
                        local succ_count = 0
                        for index = 1, 10 do
                            if sObj_quest['QuestInfoName'..index] ~= 'None' then
                                max = max + 1
                                if sObj_quest['QuestInfoValue'..index] >= sObj_quest['QuestInfoMaxCount'..index] then
                                    succ_count = succ_count + 1
                                end
                            end
                        end
                        if succ_count >= max then
                            Succ_req_SessionObject = 'YES'
                            if succ_count > 0 then
                                noSuccessPropertyChangeFlag = 1
                            end
                        end
                    end
                end
        
                if questIES.Succ_Check_Buff == 0 then
                    Succ_req_Buff = 'YES'
                elseif questIES.Succ_Buff_Condition == 'AND' then
                    if questIES.Succ_Check_Buff >= 1 then
                        if questIES.Succ_Check_Buff >= 4 then
                            if IsBuffApplied(pc, questIES.Succ_BuffName4) == 'YES' then
                                Succ_req_buff_check = Succ_req_buff_check + 1;
                            end
                        end
                        if questIES.Succ_Check_Buff >= 3 then
                            if IsBuffApplied(pc, questIES.Succ_BuffName3) == 'YES' then
                                Succ_req_buff_check = Succ_req_buff_check + 1;
                            end
                        end
                        if questIES.Succ_Check_Buff >= 2 then
                            if IsBuffApplied(pc, questIES.Succ_BuffName2) == 'YES' then
                                Succ_req_buff_check = Succ_req_buff_check + 1;
                            end
                        end
                        if questIES.Succ_Check_Buff >= 1 then
                            if IsBuffApplied(pc, questIES.Succ_BuffName1) == 'YES' then
                                Succ_req_buff_check = Succ_req_buff_check + 1;
                            end
                        end
                        if Succ_req_buff_check == questIES.Succ_Check_Buff then
                            Succ_req_Buff = 'YES';
                            noSuccessPropertyChangeFlag = 1
                        end
                    end
                elseif questIES.Succ_Buff_Condition == 'OR' then
                    if questIES.Succ_Check_Buff >= 1 then
                        local i
                        for i = 1, questIES.Succ_Check_Buff do
                            if IsBuffApplied(pc, questIES['Succ_BuffName'..i]) == 'YES' then
                                Succ_req_Buff = 'YES';
                                noSuccessPropertyChangeFlag = 1
                                break
                            end
                        end
                    end
                end
                
                local shortfall_1
        	    Succ_req_InvItem, shortfall_1, noSuccessPropertyChangeFlag = SCR_QUEST_SUCC_CHECK_MODULE_INVITEM(pc, questIES, noSuccessPropertyChangeFlag)
        	    
        	    Succ_req_SSNInvItem, ssnInvItemCheck, noSuccessPropertyChangeFlag = SCR_QUEST_SUCC_CHECK_MODULE_SSNINVITEM(pc, questIES, sObj_quest, noSuccessPropertyChangeFlag)
    
                
                
                
                if questIES.Succ_Check_Skill == 0 then
                    Succ_req_Skill = 'YES';
                elseif questIES.Succ_Skill_Condition == 'AND' then
                    if questIES.Succ_Check_Skill >= 1 then
                        if questIES.Succ_Check_Skill >= 6 then
                            if questIES.Succ_SkillVan6 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan6)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        if questIES.Succ_Check_Skill >= 5 then
                            if questIES.Succ_SkillVan5 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan5)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        if questIES.Succ_Check_Skill >= 4 then
                            if questIES.Succ_SkillVan4 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan4)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        if questIES.Succ_Check_Skill >= 3 then
                            if questIES.Succ_SkillVan3 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan3)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        if questIES.Succ_Check_Skill >= 2 then
                            if questIES.Succ_SkillVan2 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan2)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        if questIES.Succ_Check_Skill >= 1 then
                            if questIES.Succ_SkillVan1 ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Succ_SkillVan1)
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_skill_check = Succ_req_skill_check + 1
                                    end
                                end
                            end
                        end
                        
                        if Succ_req_skill_check == questIES.Succ_Check_Skill then
                            Succ_req_Skill = 'YES';
                        end
                    end
                elseif questIES.Succ_Skill_Condition == 'OR' then
                    if questIES.Succ_Check_Skill >= 1 then
                        local i
                        for i = 1, questIES.Succ_Check_Skill do
                            if questIES['Succ_SkillVan'..i] ~= 'None' then
                                local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES['Succ_SkillVan'..i])
                                
                                if skillname ~= nil then
                                    local skl = GetSkill(pc, skillname)
                                    if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                        Succ_req_Skill = 'YES';
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                
                
                
                if sObj ~= nil then
                    Succ_req_Quest = SCR_QUEST_SUCC_CHECK_MODULE_QUEST(pc, questIES, sObj)
                end
                
                local shortfall
                Succ_req_MonKill, shortfall, ssnMonCheck = SCR_QUEST_SUCC_CHECK_MODULE_MONKILL(pc, questIES)
                
                
                Succ_req_OverKill = SCR_QUEST_SUCC_CHECK_MODULE_OVERKILL(pc, questIES)
                
                
                
                
        
                if questIES.Succ_Check_EqItem == 0 then
                    Succ_req_EqItem = 'YES'
                elseif questIES.Succ_EqItem_Condition == 'AND' then
                    if questIES.Succ_Check_EqItem >= 1 then
                        if questIES.Succ_Check_EqItem >= 4 then
                            if questIES.Succ_EqItemName4 == 'None' then
                                print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_EqItemName4_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                            end
                            local Succ_EqItem4 = GetEquipItem(pc, GetClassString('Item', questIES.Succ_EqItemName4, 'DefaultEqpSlot'));
                            if Succ_EqItem4 ~= nil then
                                if Succ_EqItem4.ClassName == questIES.Succ_EqItemName4 then
                                    Succ_req_eqitem_check = Succ_req_eqitem_check + 1;
                                end
                            end
                        end
                        if questIES.Succ_Check_EqItem >= 3 then
                            if questIES.Succ_EqItemName3 == 'None' then
                                print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_EqItemName3_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                            end
                            local Succ_EqItem3 = GetEquipItem(pc, GetClassString('Item', questIES.Succ_EqItemName3, 'DefaultEqpSlot'));
                            if Succ_EqItem3 ~= nil then
                                if Succ_EqItem3.ClassName == questIES.Succ_EqItemName3 then
                                    Succ_req_eqitem_check = Succ_req_eqitem_check + 1;
                                end
                            end
                        end
                        if questIES.Succ_Check_EqItem >= 2 then
                            if questIES.Succ_EqItemName2 == 'None' then
                                print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_EqItemName2_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                            end
                            local Succ_EqItem2 = GetEquipItem(pc, GetClassString('Item', questIES.Succ_EqItemName2, 'DefaultEqpSlot'));
                            if Succ_EqItem2 ~= nil then
                                if Succ_EqItem2.ClassName == questIES.Succ_EqItemName2 then
                                    Succ_req_eqitem_check = Succ_req_eqitem_check + 1;
                                end
                            end
                        end
                        if questIES.Succ_Check_EqItem >= 1 then
                            if questIES.Succ_EqItemName1 == 'None' then
                                print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_EqItemName1_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                            end
                            local Succ_EqItem1 = GetEquipItem(pc, GetClassString('Item', questIES.Succ_EqItemName1, 'DefaultEqpSlot'));
                            if Succ_EqItem1 ~= nil then
                                if Succ_EqItem1.ClassName == questIES.Succ_EqItemName1 then
                                    Succ_req_eqitem_check = Succ_req_eqitem_check + 1;
                                end
                            end
                        end
                        if Succ_req_eqitem_check == questIES.Succ_Check_EqItem then
                            Succ_req_EqItem = 'YES';
                            noSuccessPropertyChangeFlag = 1
                        end
                    end
                elseif questIES.Succ_EqItem_Condition == 'OR' then
                    if questIES.Succ_Check_EqItem >= 1 then
                    
                        local i
                        for i = 1, questIES.Succ_Check_EqItem do
                            if questIES['Succ_EqItemName'..i] == 'None' then
                                print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_EqItemName")..i..ScpArgMsg("Auto__KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                            end
                            local Succ_EqItem = GetEquipItem(pc, GetClassString('Item', questIES['Succ_EqItemName'..i], 'DefaultEqpSlot'));
                            if Succ_EqItem ~= nil then
                                if Succ_EqItem.ClassName == questIES['Succ_EqItemName'..i] then
                                    Succ_req_EqItem = 'YES';
                                    noSuccessPropertyChangeFlag = 1
                                    break
                                end
                            end
                        end
                    end
                end
                
                
                if questIES.Succ_Check_Script == 0 then
                    Succ_req_Script = 'YES'
                elseif questIES.Succ_Script_Condition == 'AND' then
                    if questIES.Succ_Check_Script >= 1 then
                        for i = 1, questIES.Succ_Check_Script do
                            if questIES['Succ_Script'..i] ~= nil and questIES['Succ_Script'..i] ~= 'None' and questIES['Succ_Script'..i] ~= '' then
                                local scriptInfo = SCR_STRING_CUT(questIES['Succ_Script'..i])
                                local func = _G[scriptInfo[1]];
                                if func ~= nil then
                                    local result = func(pc,questname,scriptInfo);
                                    if result == 'YES' then
                                        Succ_req_script_check = Succ_req_script_check + 1;
                                    end
                                end
                            end
                        end
                        
                        if Succ_req_script_check == questIES.Succ_Check_Script then
                            Succ_req_Script = 'YES';
                            noSuccessPropertyChangeFlag = 1
                        end
                    end
                elseif questIES.Succ_Script_Condition == 'OR' then
                    if questIES.Succ_Check_Script >= 1 then
                        local i
                        for i = 1, questIES.Succ_Check_Script do
                            if questIES['Succ_Script'..i] ~= nil and questIES['Succ_Script'..i] ~= 'None' and questIES['Succ_Script'..i] ~= '' then
                                local scriptInfo = SCR_STRING_CUT(questIES['Succ_Script'..i])
                                local func = _G[scriptInfo[1]];
                                if func ~= nil then
                                    local result = func(pc, questname,scriptInfo);
                                    if result == 'YES' then
                                        Succ_req_Script = 'YES'
                                        noSuccessPropertyChangeFlag = 1
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                
                Succ_req_JournalMonKill = SCR_JOURNALMONKILL_SUCC_CHECK_MODULE_QUEST(pc, questIES)
                
        --        print('Succ_req_InvItem',Succ_req_InvItem,'Succ_req_EqItem',Succ_req_EqItem,'Succ_req_Buff',Succ_req_Buff,'req_end',req_end, 'Succ_req_Lv',Succ_req_Lv,'Succ_req_MonKill',Succ_req_MonKill)
                if Succ_req_InvItem == 'YES' and Succ_req_SSNInvItem == 'YES' and Succ_req_EqItem == 'YES' and Succ_req_Buff == 'YES' and Succ_req_Lv == 'YES' and Succ_req_MonKill == 'YES' and Succ_req_OverKill == 'YES' and Succ_req_Skill == 'YES' and Succ_req_Quest == 'YES' and Succ_req_Atkup == 'YES' and Succ_req_Defup == 'YES' and Succ_req_Mhpup == 'YES' and Succ_req_HonorPoint == 'YES' and Succ_req_MapFogSearch == 'YES' and Succ_req_SessionObject == 'YES' and Succ_req_Script == 'YES' and Succ_req_JournalMonKill == 'YES' then
                    if questIES.Succ_Check_Buff == 0 and questIES.Succ_Check_EqItem == 0 and questIES.Succ_Check_InvItem == 0 and ssnInvItemCheck == false and ssnMonCheck == false and questIES.Succ_Lv == 0 and questIES.Succ_Check_MonKill == 0 and questIES.Succ_Check_OverKill == 0 and questIES.Succ_Check_Skill == 0 and questIES.Succ_Check_QuestCount == 0 and questIES.Succ_Atkup == 0 and questIES.Succ_Defup == 0 and questIES.Succ_Mhpup == 0 and questIES.Succ_HonorPoint == 'None' and questIES.Succ_MapFogSearch == 'None' and (questIES.Quest_SSN == 'None' or (questIES.Quest_SSN ~= 'None' and SCR_SESSIONOBJ_INFO_CHECK(questIES.Quest_SSN) == 'NO')) and questIES.Succ_Check_Script == 0 and (GetPropType(questIES,'Succ_Check_JournalMonKillCount') == nil or questIES.Succ_Check_JournalMonKillCount == 0) then
                        quest_reason[1] = ScpArgMsg("Auto_DaLeun_wanLyo_JoKeon_eopeum_")..questIES.QuestPropertyName..ScpArgMsg("Auto__PeuLoPeoTi_Kapi_")..CON_QUESTPROPERTY_MAX..ScpArgMsg("Auto__ieoya_Ham")
                        return 'PROGRESS', quest_reason;
                    else
        --                print('SUCCESS')
                        local x = 1
                        
                        if questIES.Succ_Check_Buff > 0 then
                            quest_reason[x] = 'Succ_Check_Buff'
                            x = x + 1
                        end
                        if questIES.Succ_Check_EqItem > 0 then
                            quest_reason[x] = 'Succ_Check_EqItem'
                            x = x + 1
                        end
                        if questIES.Succ_Check_InvItem > 0 then
                            quest_reason[x] = 'Succ_Check_InvItem'
                            x = x + 1
                        end
                        
                        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
                            quest_reason[x] = 'SSNInvItem'
                            x = x + 1
                        end
                        
                        if questIES.Succ_Lv > 0 then
                            quest_reason[x] = 'Succ_Lv'
                            x = x + 1
                        end
                        if questIES.Succ_Atkup > 0 then
                            quest_reason[x] = 'Succ_Atkup'
                            x = x + 1
                        end
                        if questIES.Succ_Defup > 0 then
                            quest_reason[x] = 'Succ_Defup'
                            x = x + 1
                        end
                        if questIES.Succ_Mhpup > 0 then
                            quest_reason[x] = 'Succ_Mhpup'
                            x = x + 1
                        end
                        if questIES.Succ_Check_MonKill > 0 then
                            quest_reason[x] = 'Succ_Check_MonKill'
                            x = x + 1
                        end
                        if questIES.Succ_Check_OverKill > 0 then
                            quest_reason[x] = 'Succ_Check_OverKill'
                            x = x + 1
                        end
                        if questIES.Succ_Check_Skill > 0 then
                            quest_reason[x] = 'Succ_Check_Skill'
                            x = x + 1
                        end
                        if questIES.Succ_Check_QuestCount > 0 then
                            quest_reason[x] = 'Succ_Check_QuestCount'
                            x = x + 1
                        end
                        
                        if questIES.Succ_HonorPoint ~= 'None' then
                            quest_reason[x] = 'Succ_HonorPoint'
                            x = x + 1
                        end
                        
                        if questIES.Succ_MapFogSearch ~= 'None' then
                            quest_reason[x] = 'Succ_MapFogSearch'
                            x = x + 1
                        end
                        
                        if questIES.Quest_SSN ~= 'None' then
                            quest_reason[x] = 'Quest_SSN'
                            x = x + 1
                        end
                        
                        if questIES.Succ_Check_Script > 0 then
                            quest_reason[x] = 'Succ_Check_Script'
                            x = x + 1
                        end
                        
                        if (GetPropType(questIES,'Succ_Check_JournalMonKillCount') ~= nil and questIES.Succ_Check_JournalMonKillCount > 0) then
                            quest_reason[x] = 'Succ_Check_JournalMonKillCount'
                            x = x + 1
                        end
                        
                        if noSuccessPropertyChangeFlag == 0 and IsServerSection(pc) == 1 then
                            RunScript('SCR_QUEST_CHECK_SUB_SUCCESS_PROPERTY_CHANGE', pc, sObj, questIES)
                        end
                        
                        return 'SUCCESS', quest_reason;
                    end
                else
                    local x = 1
                    
                    if Succ_req_InvItem ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_InvItem'
                        x = x + 1
                    end
                    
                    if Succ_req_SSNInvItem ~= 'YES' then
                        quest_reason[x] = 'SSNInvItem'
                        x = x + 1
                    end
                    
                    if Succ_req_EqItem ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_EqItem'
                        x = x + 1
                    end
                    if Succ_req_Buff ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_Buff'
                        x = x + 1
                    end
                    if Succ_req_Lv ~= 'YES' then
                        quest_reason[x] = 'Succ_Lv'
                        x = x + 1
                    end
                    if Succ_req_Atkup ~= 'YES' then
                        quest_reason[x] = 'Succ_Atkup'
                        x = x + 1
                    end
                    if Succ_req_Defup ~= 'YES' then
                        quest_reason[x] = 'Succ_Defup'
                        x = x + 1
                    end
                    if Succ_req_Mhpup ~= 'YES' then
                        quest_reason[x] = 'Succ_Mhpup'
                        x = x + 1
                    end
                    if Succ_req_MonKill ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_MonKill'
                        x = x + 1
                    end
                    if Succ_req_OverKill ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_OverKill'
                        x = x + 1
                    end
                    if Succ_req_Skill ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_Skill'
                        x = x + 1
                    end
                    if Succ_req_Quest ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_QuestCount'
                        x = x + 1
                    end
                    
                    if Succ_req_HonorPoint ~= 'YES' then
                        quest_reason[x] = 'Succ_req_HonorPoint'
                        x = x + 1
                    end
                    
                    if Succ_req_MapFogSearch ~= 'YES' then
                        quest_reason[x] = 'Succ_req_MapFogSearch'
                        x = x + 1
                    end
                    
                    if Succ_req_SessionObject ~= 'YES' then
                        quest_reason[x] = 'Quest_SSN'
                        x = x + 1
                    end
                    
                    if Succ_req_Script ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_Script'
                        x = x + 1
                    end
                    
                    if Succ_req_JournalMonKill ~= 'YES' then
                        quest_reason[x] = 'Succ_Check_JournalMonKillCount'
                        x = x + 1
                    end
                    
                    return 'PROGRESS', quest_reason;
                end
            else
                local succConditionList =  SCR_STRING_CUT(questIES.Succ_Check_Condition)
                if #succConditionList > 0 then
                    local index
                    for index = 1, #succConditionList do
                        local succCheckList =  SCR_STRING_CUT(succConditionList[index], ':')
                        if #succCheckList > 0 then
                            local i
                            local retCount = 0
                            local successPropertyChangeFlag = 0
                            
                            for i = 1, #succCheckList do
                                local succCheck = succCheckList[i]
                                if succCheck == 'Succ_Lv' then
                                    if pc.Lv >= questIES.Succ_Lv then
                                        retCount = retCount + 1
                                        if questIES.Succ_Lv > 0 then
                                            successPropertyChangeFlag = 1
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif succCheck == 'Succ_Atkup' then
                                    if pc.MAXPATK >= questIES.Succ_Atkup or pc.MAXMATK >= questIES.Succ_Atkup then
                                        retCount = retCount + 1
                                        if questIES.Succ_Atkup > 0 then
                                            successPropertyChangeFlag = 1
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif succCheck == 'Succ_Defup' then
                                    if pc.DEF >= questIES.Succ_Defup then
                                        retCount = retCount + 1
                                        if questIES.Succ_Defup > 0 then
                                            successPropertyChangeFlag = 1
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif succCheck == 'Succ_Mhpup' then
                                    if pc.MHP >= questIES.Succ_Mhpup then
                                        retCount = retCount + 1
                                        if questIES.Succ_Mhpup > 0 then
                                            successPropertyChangeFlag = 1
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif succCheck == 'Succ_HonorPoint' then
                                    if questIES.Succ_HonorPoint == 'None' then
                                        retCount = retCount + 1
                                    else
                                        local honor_name, point_value = string.match(questIES.Succ_HonorPoint,'(.+)[/](.+)')
                                        
                                        if honor_name ~= nil then
                                            local honor_point = GetAchievePoint(pc, honor_name)
                                            if honor_point >= tonumber(point_value) then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    end
                                elseif succCheck == 'Succ_MapFogSearch' then
                                    if questIES.Succ_MapFogSearch == 'None' then
                                        retCount = retCount + 1
                                    else
                                        local mapList = SCR_STRING_CUT(questIES.Succ_MapFogSearch)
                                        local flag = true
                                        for x = 1, #mapList/2 do
                                            local map_classname = mapList[x*2 - 1]
                                            local percent = mapList[x*2]
                                            if map_classname ~= nil then
                                                local now_percent = GetMapFogSearchRate(pc, map_classname)
                                                if now_percent < tonumber(percent) then
                                                    flag = false
                                                    break
                                                end
                                            else
                                                flag = false
                                                break
                                            end
                                        end
                                        
                                        if flag == true then
                                            retCount = retCount + 1
                                            successPropertyChangeFlag = 1
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    end
                                elseif string.find(succCheck,'QuestSobj') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'QuestSobj',''))
                                    if num ~= nil then
                                        sObj_quest = GetSessionObject(pc, questIES.Quest_SSN);
                                        
                                        if sObj_quest ~= nil and GetPropType(sObj_quest, 'QuestInfoName'..num) ~= nil then
                                            if sObj_quest['QuestInfoName'..num] ~= 'None' then
                                                if sObj_quest['QuestInfoValue'..num] >= sObj_quest['QuestInfoMaxCount'..num] then
                                                    retCount = retCount + 1
                                                else
                                                    quest_reason[#quest_reason + 1] = succCheck
                                                end
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_BuffName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_BuffName',''))
                                    if num ~= nil then
                                        if IsBuffApplied(pc, questIES['Succ_BuffName'..num]) == 'YES' then
                                            retCount = retCount + 1
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_EqItemName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_EqItemName',''))
                                    if num ~= nil then
                                        local Succ_EqItem = GetEquipItem(pc, GetClassString('Item', questIES['Succ_EqItemName'..num], 'DefaultEqpSlot'));
                                        if Succ_EqItem ~= nil then
                                            if Succ_EqItem.ClassName == questIES['Succ_EqItemName'..num] then
                                                retCount = retCount + 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_SkillVan') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_SkillVan',''))
                                    if num ~= nil then
                                        local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES['Succ_SkillVan'..num])
                                        
                                        if skillname ~= nil then
                                            local skl = GetSkill(pc, skillname)
                                            if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_InvItemName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_InvItemName',''))
                                    if num ~= nil then
                                        if GetInvItemCount(pc, questIES['Succ_InvItemName'..num]) >= questIES['Succ_InvItemCount'..num] then
                                            retCount = retCount + 1
                                            local itemIES = GetClass('Item',questIES['Succ_InvItemName'..num])
                                            if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                                                successPropertyChangeFlag = 1
                                            end
                                            
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'SSNInvItem') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'SSNInvItem',''))
                                    if num ~= nil then
                                        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
                                            local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
                                            if #itemList >= num*2 then
                                                if GetInvItemCount(pc, itemList[num*2 - 1]) >= itemList[num*2] then
                                                    retCount = retCount + 1
                                                else
                                                    quest_reason[#quest_reason + 1] = succCheck
                                                end
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_QuestName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_QuestName',''))
                                    if num ~= nil then
                                        if questIES['Succ_QuestName'..num] ~= 'None' then
                                            local ret = SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, num)
                                            if ret == 'YES' then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_MonKillName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_MonKillName',''))
                                    local monkill_sObj = GetSessionObject(pc, questIES.Quest_SSN);
                                    if monkill_sObj ~= nil then
                                        if questIES['Succ_MonKillName'..num] ~= 'None' and questIES['Succ_MonKill_ItemGive'..num] == 'None' then
                                            if monkill_sObj['KillMonster'..num] >= questIES['Succ_MonKillCount'..num] and questIES['Succ_MonKillCount'..num] > 0 then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_OverKillName') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_OverKillName',''))
                                    local overkill_sObj = GetSessionObject(pc, questIES.Quest_SSN);
                                    if overkill_sObj ~= nil then
                                        if questIES['Succ_OverKillName'..num] ~= 'None' and questIES['Succ_OverKill_ItemGive'..num] == 'None' then
                                            if overkill_sObj['OverKill'..num] >= questIES['Succ_OverKillCount'..num] and questIES['Succ_OverKillCount'..num] > 0 then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_Script') ~= nil then
                                    local num = tonumber(string.gsub(succCheck,'Succ_Script',''))
                                    if questIES['Succ_Script'..num] ~= 'None' and questIES['Succ_Script'..num] ~= '' then
                                        local scriptInfo = SCR_STRING_CUT(questIES['Succ_Script'..num])
                                        local func = _G[scriptInfo[1]];
                                        if func ~= nil then
                                            local result = func(pc,questname,scriptInfo);
                                            if result == 'YES' then
                                                retCount = retCount + 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                elseif string.find(succCheck,'Succ_Journal_MonKillName') ~= nil then
                                    --revisioom function--                                    
                                    local num = tonumber(string.gsub(succCheck,'Succ_Journal_MonKillName',''))
                                    if GetPropType(questIES,'Succ_Journal_MonKillName'..num) ~= nil and  questIES['Succ_Journal_MonKillName'..num] ~= 'None' and questIES['Succ_Journal_MonKillName'..num] ~= '' then
                                        local killCount = nil;
                                        local monIDList = GetAdventureBookMonList(pc);
                                        if IsServerSection(pc) == 1 then
                                            if table.find(monIDList, questIES['Succ_Journal_MonKillName'..num]) > 0 then
                                                killCount = GetMonKillCount(pc, questIES['Succ_Journal_MonKillName'..num]);
                                            end
                                        else
                                            if table.find(monIDList, questIES['Succ_Journal_MonKillName'..num]) > 0 then
                                                killCount = GetMonKillCount(pc, questIES['Succ_Journal_MonKillName'..num]);
                                            end
                                        end
                                        if killCount ~= nil then
                                            if killCount >= questIES['Succ_Journal_MonKillCount'..num] then
                                                retCount = retCount + 1
                                                successPropertyChangeFlag = 1
                                            else
                                                quest_reason[#quest_reason + 1] = succCheck
                                            end
                                        else
                                            quest_reason[#quest_reason + 1] = succCheck
                                        end
                                    else
                                        quest_reason[#quest_reason + 1] = succCheck
                                    end
                                    --
                                end
                            end
                            
                            if retCount >= #succCheckList then
                                if successPropertyChangeFlag == 1 and IsServerSection(pc) == 1 then
                                    RunScript('SCR_QUEST_CHECK_SUB_SUCCESS_PROPERTY_CHANGE', pc, sObj, questIES)
                                end
                                return 'SUCCESS', quest_reason, succConditionList[index]
                            end
                        end
                    end
                    
                    return 'PROGRESS', quest_reason
                else
                    return 'PROGRESS', 'Succ_Check_Condition'
                end
            end
        else 
            if sObj ~= nil then
                req_startarea = 'YES';
                
                if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_END then
                    req_end = 'NO'
                    return 'COMPLETE'
                else
                    req_end = 'YES'
                end
            end
            
            if questIES.QuestMode == "PARTY" then
                local partyQuestClassName
                if questIES.QuestGroup == 'None' then
                    partyQuestClassName = questIES.QuestPropertyName
                else
                    local questGroupInfo = SCR_STRING_CUT(questIES.QuestGroup)
                    if tonumber(questGroupInfo[3]) == 1 then
                        partyQuestClassName = questIES.QuestPropertyName
                    else
                        local cnt = GetClassCount('QuestProgressCheck')
                    	local flag = false
                    	
                    	for i = 0, cnt - 1 do
                    		local questSUB = GetClassByIndex('QuestProgressCheck', i);
                    		if questSUB.QuestMode == "PARTY" and questSUB.QuestGroup ~= 'None' then
                        		local subGroupInfo = SCR_STRING_CUT(questSUB.QuestGroup)
                        		if subGroupInfo[1] == questGroupInfo[1] and tonumber(subGroupInfo[3]) == 1 then
                        		    partyQuestClassName = questSUB.QuestPropertyName
                        		    break
                        		end
                        	end
                    	end
                    end
                end
                
                if partyQuestClassName ~= nil then
                    local cnt = GetClassCount('RequestPartyQuest')
                	local checkFlag = true
                	for i = 0, cnt - 1 do
                		local partyMission = GetClassByIndex('RequestPartyQuest', i);
                		if GetPropType(partyMission,'Terms') ~= nil and partyMission.Terms ~= 'None' then
                		    local termList = SCR_STRING_CUT(partyMission.Terms)
                		    for x = 1, #termList do
                                local term = SCR_STRING_CUT(termList[x],':')
                                if term[1] == partyQuestClassName then
                                    table.remove(term, 1)
                                    checkFlag = SCR_PARTYQUEST_RANDOM_CHECK_SUB(pc, partyMission, term)
                                    
                                    if checkFlag == false then
                                        quest_reason[#quest_reason + 1] = "PartyQuestBasicTerm"
                                        return 'IMPOSSIBLE', quest_reason
                                    end
                                end
                            end
                		end
                	end
                end
                
                local cnt = GetClassCount('QuestProgressCheck')
            	for i = 0, cnt - 1 do
            		local questSUB = GetClassByIndex('QuestProgressCheck', i);
            		if questSUB.QuestMode == "PARTY" and questSUB.ClassName ~= questIES.ClassName then
            		    if sObj[questSUB.ClassName] > 0 and sObj[questSUB.ClassName] < 300 then
            		        quest_reason[#quest_reason + 1] = "PartyQuestOnlyOne"
                            return 'IMPOSSIBLE', quest_reason
            		    end
                	end
            	end
            	
            	if sObj.PARTY_Q_COUNT1 >= CON_PARTYQUEST_DAYMAX1 then
            	    quest_reason[#quest_reason + 1] = "PartyQuestOnlyOne"
                    return 'IMPOSSIBLE', quest_reason
            	end
            end
            
            req_ReenterTime, reenterRemainTimeSec = SCR_QUEST_PRE_CHECK_REENTERTIME(questIES, sObj)
            
            if questIES.Lvup == 0 then
                req_lvup = 'YES';
            elseif questIES.Lvup == -9999 then
            elseif pc.Lv >= questIES.Lvup then
                req_lvup = 'YES';
            end
            
            if questIES.Lvdown == 0 then
                req_lvdown = 'YES';
            elseif pc.Lv <= questIES.Lvdown then
                req_lvdown = 'YES';
            end
            
            if questIES.QuestMode == 'REPEAT' then
                if questIES.Repeat_Count == 0 then
                    req_Repeat = 'YES'
                else
                    if sObj[questIES.QuestPropertyName..'_R'] == questIES.Repeat_Count then
                        req_Repeat = 'NO'
                    elseif sObj[questIES.QuestPropertyName..'_R'] <= questIES.Repeat_Count then
                        req_Repeat = 'YES'
                    else
                        req_Repeat = 'NO'
                    end
                end
            else
                req_Repeat = 'YES'
            end
            
            if questIES.JobStep == 0 then
                req_jobstep = 'YES'
            else
                local jobstep = questIES.JobStep
                local grade, changedJobCount
                
                if IsServerSection(pc) == 1 then
                    grade, changedJobCount = GetJobGradeByName(pc, pc.JobName);
                else
                    changedJobCount = session.GetPcTotalJobGrade()
                end
                
                if questIES.JobStepTerms == 'EQUAL' then
                    if changedJobCount ~= nil and changedJobCount == jobstep then
                        req_jobstep = 'YES'
                    end
                elseif questIES.JobStepTerms == 'OVER' then
                    if changedJobCount ~= nil and changedJobCount >= jobstep then
                        req_jobstep = 'YES'
                    end
                elseif questIES.JobStepTerms == 'BELOW' then
                    if changedJobCount ~= nil and changedJobCount <= jobstep then
                        req_jobstep = 'YES'
                    end
                end
                
            end
            
            req_joblvup = SCR_QUEST_CHECK_MODULE_JOBLVUP(pc, questIES)

            req_joblvdown = SCR_QUEST_CHECK_MODULE_JOBLVDOWN(pc, questIES)
            
            if questIES.Atkup == 0 then
                req_atkup = 'YES';
            elseif pc.MAXATK >= questIES.Atkup then
                req_atkup = 'YES';
            end
            
            if questIES.Atkdown == 0 then
                req_atkdown = 'YES';
            elseif pc.MAXATK <= questIES.Atkdown then
                req_atkdown = 'YES';
            end
            
            if questIES.Defup == 0 then
                req_defup = 'YES';
            elseif pc.DEF >= questIES.Defup then
                req_defup = 'YES';
            end
            
            if questIES.Defdown == 0 then
                req_defdown = 'YES';
            elseif pc.DEF <= questIES.Defdown then
                req_defdown = 'YES';
            end
            
            if questIES.Mhpup == 0 then
                req_mhpup = 'YES';
            elseif pc.MHP >= questIES.Mhpup then
                req_mhpup = 'YES';
            end
            
            if questIES.Mhpdown == 0 then
                req_mhpdown = 'YES';
            elseif pc.MHP <= questIES.Mhpdown then
                req_mhpdown = 'YES';
            end
            
            if questIES.HonorPointUp == 'None' then
                req_HonorPointUp = 'YES'
            else
                local honor_name, point_value = string.match(questIES.HonorPointUp,'(.+)[/](.+)')
                
                if honor_name ~= nil then
                    local honor_point = GetAchievePoint(pc, honor_name)
                    if honor_point >= tonumber(point_value) then
                        req_HonorPointUp = 'YES'
                    end
                end
            end
            
            
            if questIES.HonorPointDown == 'None' then
                req_HonorPointDown = 'YES'
            else
                local honor_name, point_value = string.match(questIES.HonorPointDown,'(.+)[/](.+)')
                
                if honor_name ~= nil then
                    local honor_point = GetAchievePoint(pc, honor_name)
                    if honor_point <= tonumber(point_value) then
                        req_HonorPointDown = 'YES'
                    end
                end
            end
            
            
            if questIES.AOSLine == 'None' then
--                print('AAAAAAA',zoneInstID)
                req_AOSLine = 'YES'
            else
                
                local flag = 0
                local succ_count = 0
                
                
                if string.find(questIES.AOSLine, '/') == nil then
                    req_AOSLine = 'YES'
                else
                    local strlist = {}
                    if string.find(questIES.AOSLine, ';') ~= nil then
                        
                        local temp_list = {}
                        local i
                        temp_list = SCR_STRING_CUT_SEMICOLON(questIES.AOSLine)
                        flag = flag + #temp_list

                        for i = 1, #temp_list do
                            if SCR_AOSLine_Check(pc, temp_list[i]) == 'YES' then
                                succ_count = succ_count + 1
                            end
                        end
                    else
                        if string.find(questIES.AOSLine, '/') ~= nil then
                            flag = flag + 1
                            
                            if SCR_AOSLine_Check(pc, questIES.AOSLine) == 'YES' then
                                succ_count = succ_count + 1
                            end
                        end
                    end
                    
                    if succ_count >= flag then
                        req_AOSLine = 'YES'
                    end
                end
            end
            
            
            
            if questIES.NPCQuestCount == 'None' then
                req_NPCQuestCount = 'YES'
            else
                
                local succ_count = 0
                
                if string.find(questIES.NPCQuestCount, '/') == nil then
                    if SCR_NPCQuestCount_Check(npcquestcount_list, questIES.NPCQuestCount) == 'YES' then
                        req_NPCQuestCount = 'YES'
                    end
                else
                    local temp_list = {}
                    local i
                    temp_list = SCR_STRING_CUT(questIES.NPCQuestCount)

                    for i = 1, #temp_list do
                        if SCR_NPCQuestCount_Check(npcquestcount_list, temp_list[i]) == 'YES' then
                            succ_count = succ_count + 1
                        end
                    end
                    
                    if succ_count >= #temp_list then
                        req_NPCQuestCount = 'YES'
                    end
                end
            end
            
            req_quest = SCR_QUEST_CHECK_MODULE_QUEST(pc, questIES, sObj)
            
            req_PartyProp = SCR_PARTY_QUEST_CHECK_MODULE_QUEST(pc, questIES)
            
            req_JournalMonKill = SCR_JOURNALMONKILL_CHECK_MODULE_QUEST(pc, questIES)
            
            if questIES.Check_Location == 'NO' then
                req_Location = 'YES'
            else
                local posx, posy, posz = GetPos(pc)
                if questIES.Location6 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location6, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location6_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
                if questIES.Location5 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location5, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location5_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
                if questIES.Location4 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location4, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location4_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
                if questIES.Location3 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location3, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location3_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
                if questIES.Location2 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location2, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location2_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
                if questIES.Location1 ~= 'None' then
                    local locationInfo = SCR_STRING_CUT(questIES.Location1, ' ')
                    if #locationInfo < 1 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Location1_KeolLeomui_HyeongSigi_MajJi_anSeupNiDa._EX>_JonClassName_XJwaPyo_YJwaPyo_ZJwaPyo_Beomwi"))
                    end
                    local zonename = GetZoneName(pc) 
                    
                    if #locationInfo == 1 then
                        if zonename == locationInfo[1] then
                            req_Location = 'YES'
                        end
                    elseif #locationInfo == 5 then
                        if zonename == locationInfo[1] and SCR_POINT_DISTANCE(posx,posz,tonumber(locationInfo[2]),tonumber(locationInfo[4])) <= tonumber(locationInfo[5]) then
                            req_Location = 'YES'
                        end
                    end
                end
            end
            
            if questIES.Check_Tribe == 0 then
                req_tribe = 'YES'
            elseif questIES.Tribe4 == pc.Tribe then
                req_tribe = 'YES'
            elseif questIES.Tribe3 == pc.Tribe then
                req_tribe = 'YES'
            elseif questIES.Tribe2 == pc.Tribe then
                req_tribe = 'YES'
            elseif questIES.Tribe1 == pc.Tribe then
                req_tribe = 'YES'
            else
                print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeueSeo_JogJong_SaJeonCheKeuLeul_Sayong_JungipNiDa._HyeonJae_JongJog_SaJeonCheKeuNeun_SayongHaJi_aneuNi_DiPolTeuLo_ByeonKyeongi_PilyoHapNiDa."))
            end
            
            if questIES.Check_Job == 0 then
                req_job = 'YES'
            elseif questIES.Job4 == pc.JobName then
                req_job = 'YES'
            elseif questIES.Job3 == pc.JobName then
                req_job = 'YES'
            elseif questIES.Job2 == pc.JobName then
                req_job = 'YES'
            elseif questIES.Job1 == pc.JobName then
                req_job = 'YES'
            end
            
            if questIES.Gender == 0 then
                req_Gender = 'YES';
            elseif questIES.Gender == pc.Gender then
                req_Gender = 'YES';
            end
            
            if questIES.Check_InvItem == 0 then
                req_InvItem = 'YES';
            elseif questIES.InvItem_Condition == 'AND' then
                if questIES.Check_InvItem >= 1 then
                    if questIES.Check_InvItem >= 4 then
                        if questIES.InvItemName4 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemName4_KeolLeom_SeolJeongPilyo."))
                        end
                        if questIES.InvItemCount4 < 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemCount4_KeolLeom_SeolJeongPilyo."))
                        elseif questIES.InvItemCount4 == 0 then
                            if GetInvItemCount(pc, questIES.InvItemName4) == 0 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        else
                            if GetInvItemCount(pc, questIES.InvItemName4) >= questIES.InvItemCount4 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_InvItem >= 3 then
                        if questIES.InvItemName3 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemName3_KeolLeom_SeolJeongPilyo."))
                        end
                        if questIES.InvItemCount3 < 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemCount3_KeolLeom_SeolJeongPilyo."))
                        elseif questIES.InvItemCount3 == 0 then
                            if GetInvItemCount(pc, questIES.InvItemName3) == 0 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        else
                            if GetInvItemCount(pc, questIES.InvItemName3) >= questIES.InvItemCount3 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_InvItem >= 2 then
                        if questIES.InvItemName2 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemName2_KeolLeom_SeolJeongPilyo."))
                        end
                        if questIES.InvItemCount2 < 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemCount2_KeolLeom_SeolJeongPilyo."))
                        elseif questIES.InvItemCount2 == 0 then
                            if GetInvItemCount(pc, questIES.InvItemName2) == 0 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        else
                            if GetInvItemCount(pc, questIES.InvItemName2) >= questIES.InvItemCount2 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_InvItem >= 1 then
                        if questIES.InvItemName1 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemName1_KeolLeom_SeolJeongPilyo."))
                        end
                        if questIES.InvItemCount1 < 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemCount1_KeolLeom_SeolJeongPilyo."))
                        elseif questIES.InvItemCount1 == 0 then
                            if GetInvItemCount(pc, questIES.InvItemName1) == 0 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        else
                            if GetInvItemCount(pc, questIES.InvItemName1) >= questIES.InvItemCount1 then
                                req_invitem_check = req_invitem_check + 1;
                            end
                        end
                    end
                    if req_invitem_check == questIES.Check_InvItem then
                        req_InvItem = 'YES';
                    end
                end
            elseif questIES.InvItem_Condition == 'OR' then
                if questIES.Check_InvItem >= 1 then
                    local i
                    for i = 1, questIES.Check_InvItem do
                        if questIES['InvItemName'..i] == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemName")..i..ScpArgMsg("Auto__KeolLeom_SeolJeongPilyo."))
                        end
                        if questIES['InvItemCount'..i] < 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_InvItemCount")..i..ScpArgMsg("Auto__KeolLeom_SeolJeongPilyo."))
                        elseif questIES['InvItemCount'..i] == 0 then
                            if GetInvItemCount(pc, questIES['InvItemName'..i]) == 0 then
                                req_InvItem = 'YES';
                            end
                        else
                            if GetInvItemCount(pc, questIES['InvItemName'..i]) >= questIES['InvItemCount'..i] then
                                req_InvItem = 'YES';
                            end
                        end
                        
                        if req_InvItem == 'YES' then
                            break
                        end
                    end
                end
            end
            
            if questIES.Check_EqItem == 0 then
                req_EqItem = 'YES'
            elseif questIES.EqItem_Condition == 'AND' then
                if questIES.Check_EqItem >= 1 then
                    if questIES.Check_EqItem >= 4 then
                        if questIES.EqItemName4 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_EqItemName4_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        local EqItem4 = GetEquipItem(pc, GetClassString('Item', questIES.EqItemName4, 'DefaultEqpSlot'));
                        if EqItem4 ~= nil then
                            if EqItem4.ClassName == questIES.EqItemName4 then
                                req_eqitem_check = req_eqitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_EqItem >= 3 then
                        if questIES.EqItemName3 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_EqItemName3_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        local EqItem3 = GetEquipItem(pc, GetClassString('Item', questIES.EqItemName3, 'DefaultEqpSlot'));
                        if EqItem3 ~= nil then
                            if EqItem3.ClassName == questIES.EqItemName3 then
                                req_eqitem_check = req_eqitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_EqItem >= 2 then
                        if questIES.EqItemName2 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_EqItemName2_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        local EqItem2 = GetEquipItem(pc, GetClassString('Item', questIES.EqItemName2, 'DefaultEqpSlot'));
                        if EqItem2 ~= nil then
                            if EqItem2.ClassName == questIES.EqItemName2 then
                                req_eqitem_check = req_eqitem_check + 1;
                            end
                        end
                    end
                    if questIES.Check_EqItem >= 1 then
                        if questIES.EqItemName1 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_EqItemName1_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        local EqItem1 = GetEquipItem(pc, GetClassString('Item', questIES.EqItemName1, 'DefaultEqpSlot'));
                        if EqItem1 ~= nil then
                            if EqItem1.ClassName == questIES.EqItemName1 then
                                req_eqitem_check = req_eqitem_check + 1;
                            end
                        end
                    end
                    if req_eqitem_check == questIES.Check_EqItem then
                        req_EqItem = 'YES';
                    end
                end
            elseif questIES.EqItem_Condition == 'OR' then
                if questIES.Check_EqItem >= 1 then
                    local i
                    for i = 1, questIES.Check_EqItem do
                        if questIES['EqItemName'..i] == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_EqItemName")..i..ScpArgMsg("Auto__KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        local EqItem = GetEquipItem(pc, GetClassString('Item', questIES['EqItemName'..i], 'DefaultEqpSlot'));
                        if EqItem ~= nil then
                            if EqItem.ClassName == questIES['EqItemName'..i] then
                                req_EqItem = 'YES';
                                break
                            end
                        end
                    end
                end
            end
            
            if questIES.SkillLv == 'None' then
                req_SkillLv = 'YES';
            else
                local skilllv_list =  SCR_STRING_CUT(questIES.SkillLv)
                if #skilllv_list % 2 ~= 0 or #skilllv_list < 2 then
                    print(questIES.ClassName..ScpArgMsg("Auto_KweSeuTeuui_questIES.SkillLv_Kap_")..questIES.SkillLv..ScpArgMsg("Auto_i_SeuKilMyeong/LeBel_HyeongSige_MajJi_anNeunDa."))
                    return
                end
                local skillIES = GetSkill(pc, skilllv_list[1])
                if (tonumber(skilllv_list[2]) == 0 and skillIES == nil) or (skillIES ~= nil and tonumber(skilllv_list[2]) > 0 and skillIES.Level == tonumber(skilllv_list[2])) then
                    local class_count = GetClassCount('SkillVan')
                    
                    for y = 0, class_count -1 do
                        local classIES = GetClassByIndex('SkillVan', y)
                        
                        if classIES ~= nil then
                            local skillvan_skillname = SCR_STRING_CUT_SPACEBAR(classIES.SkillNames)
                            local x
                            for x = 1, #skillvan_skillname/2 do
                                if skillvan_skillname[x*2] == skilllv_list[1] and HaveSkillMap(pc, classIES.ClassName) == 0 then
                                    local skillvan_precheck = _G[classIES.EnableScp]
                                    if skillvan_precheck ~= nil then
                                        local result = skillvan_precheck(pc, classIES)
                                        if result == 2 then
                                            req_SkillLv = 'YES'
                                            break
                                        end
                                    end
                                end
                            end
                        end
                        if req_SkillLv == 'YES' then
                            break
                        end
                    end
                end
                    
                
            end
            
            if questIES.Check_Skill == 0 then
                req_Skill = 'YES';
            elseif questIES.Skill_Condition == 'AND' then
                if questIES.Check_Skill >= 1 then
                    if questIES.Check_Skill >= 6 then
                        if questIES.Skill6 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill6)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if questIES.Check_Skill >= 5 then
                        if questIES.Skill5 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill5)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if questIES.Check_Skill >= 4 then
                        if questIES.Skill4 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill4)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if questIES.Check_Skill >= 3 then
                        if questIES.Skill3 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill3)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if questIES.Check_Skill >= 2 then
                        if questIES.Skill2 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill2)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if questIES.Check_Skill >= 1 then
                        if questIES.Skill1 ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES.Skill1)
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_skill_check = req_skill_check + 1
                                end
                            end
                        end
                    end
                    
                    if req_skill_check == questIES.Check_Skill then
                        req_Skill = 'YES';
                    end
                end
            elseif questIES.Skill_Condition == 'OR' then
                if questIES.Check_Skill >= 1 then
                    local i
                    for i = 1, questIES.Check_Skill do
                        if questIES['Skill'..i] ~= 'None' then
                            local skillname, skill_req = SCR_QUEST_REQ_STRINGCUT('SKILL', questIES['Skill'..i])
                            
                            if skillname ~= nil then
                                local skl = GetSkill(pc, skillname)
                                if skl ~= nil and skl.Level >= tonumber(skill_req) then
                                    req_Skill = 'YES';
                                    break
                                end
                            end
                        end
                    end
                end
            end
            
            
            if questIES.Check_Buff == 0 then
                req_Buff = 'YES'
            elseif questIES.Buff_Condition == 'AND' then
                if questIES.Check_Buff >= 1 then
                    if questIES.Check_Buff >= 4 then
                        if questIES.BuffName4 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_BuffName4_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        if IsBuffApplied(pc, questIES.BuffName4) == 'YES' then
                            req_buff_check = req_buff_check + 1;
                        end
                    end
                    if questIES.Check_Buff >= 3 then
                        if questIES.BuffName3 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_BuffName3_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        if IsBuffApplied(pc, questIES.BuffName3) == 'YES' then
                            req_buff_check = req_buff_check + 1;
                        end
                    end
                    if questIES.Check_Buff >= 2 then
                        if questIES.BuffName2 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_BuffName2_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        if IsBuffApplied(pc, questIES.BuffName2) == 'YES' then
                            req_buff_check = req_buff_check + 1;
                        end
                    end
                    if questIES.Check_Buff >= 1 then
                        if questIES.BuffName1 == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_BuffName1_KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        if IsBuffApplied(pc, questIES.BuffName1) == 'YES' then
                            req_buff_check = req_buff_check + 1;
                        end
                    end
                    if req_buff_check == questIES.Check_Buff then
                        req_Buff = 'YES';
                    end
                end
            elseif questIES.Buff_Condition == 'OR' then
                if questIES.Check_Buff >= 1 then
                    local i
                    for i = 1, questIES.Check_Buff do
                        if questIES['BuffName'..i] == 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_BuffName")..i..ScpArgMsg("Auto__KeolLeom_Kap_SeolJeongi_PilyoHapNiDa."))
                        end
                        if IsBuffApplied(pc, questIES['BuffName'..i]) == 'YES' then
                            req_Buff = 'YES';
                            break
                        end
                    end
                end
            end
            
            
            if questIES.Check_PeriodType == 'None' then
                req_Period = 'YES'
            elseif questIES.Check_PeriodType == 'MAIN' then
                local req_Period_func = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Main)
                if req_Period_func == 'YES' then
                    req_Period = 'YES'
                end
            elseif questIES.Check_PeriodType == 'SUB' then
                if questIES.Period_Sub1 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub1)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub2 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub2)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub3 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub3)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub4 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub4)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub5 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub5)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub6 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub6)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub7 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub7)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub8 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub8)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub9 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub9)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
                if questIES.Period_Sub10 ~= 'None' then
                    local req_Period_func_sub = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Sub10)
                    if req_Period_func_sub == 'YES' then
                        req_Period = 'YES'
                    end
                end
            elseif questIES.Check_PeriodType == 'MAIN_WEEK' then
                if questIES.Period_Main ~= 'None' then
                    local req_Period_func = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Main)
                    if req_Period_func == 'YES' then
                        if questIES.Period_Sub1 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub1)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub2 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub2)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub3 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub3)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub4 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub4)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub5 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub5)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub6 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub6)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub7 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub7)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub8 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub8)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub9 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub9)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub10 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub10)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                    end
                else
                    if questIES.Period_Sub1 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub1)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub2 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub2)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub3 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub3)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub4 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub4)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub5 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub5)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub6 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub6)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub7 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub7)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub8 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub8)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub9 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub9)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub10 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('wday/hour:min', questIES.Period_Sub10)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                end
            elseif questIES.Check_PeriodType == 'MAIN_HOUR' then
                if questIES.Period_Main ~= 'None' then
                    local req_Period_func = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Main)
                    if req_Period_func == 'YES' then
                        if questIES.Period_Sub1 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub1)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub2 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub2)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub3 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub3)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub4 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub4)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub5 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub5)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub6 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub6)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub7 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub7)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub8 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub8)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub9 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub9)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub10 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES.Period_Sub10)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                    end
                else
					for i = 1 , 10 do
						if questIES["Period_Sub" .. i] ~= 'None' then
							local req_Period_func_sub = SCR_PERIOD_CHECK('hour:min', questIES["Period_Sub" .. i])
							if req_Period_func_sub == 'YES' then
								req_Period = 'YES';
							end
						else
							break;
						end
					end            
                end
            elseif questIES.Check_PeriodType == 'MAIN_MINUTE' then
                if questIES.Period_Main ~= 'None' then
                    local req_Period_func = SCR_PERIOD_CHECK('year/month/day/hour:min', questIES.Period_Main)
                    if req_Period_func == 'YES' then
                        if questIES.Period_Sub1 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub1)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub2 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub2)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub3 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub3)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub4 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub4)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub5 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub5)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub6 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub6)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub7 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub7)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub8 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub8)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub9 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub9)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                        if questIES.Period_Sub10 ~= 'None' then
                            local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub10)
                            if req_Period_func_sub == 'YES' then
                                req_Period = 'YES'
                            end
                        end
                    end
                else
                    if questIES.Period_Sub1 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub1)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub2 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub2)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub3 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub3)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub4 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub4)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub5 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub5)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub6 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub6)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub7 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub7)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub8 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub8)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub9 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub9)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                    if questIES.Period_Sub10 ~= 'None' then
                        local req_Period_func_sub = SCR_PERIOD_CHECK('min', questIES.Period_Sub10)
                        if req_Period_func_sub == 'YES' then
                            req_Period = 'YES'
                        end
                    end
                end
            end
            
            if questIES.Check_Script == 0 then
                req_Script = 'YES'
            elseif questIES.Script_Condition == 'AND' then
                if questIES.Check_Script >= 1 then
                    for i = 1, questIES.Check_Script do
                        if questIES['Script'..i] ~= nil and questIES['Script'..i] ~= 'None' and questIES['Script'..i] ~= '' then
                            local scriptInfo = SCR_STRING_CUT(questIES['Script'..i])
                            local func = _G[scriptInfo[1]];
                            if func ~= nil then
                                local result = func(pc, questname, scriptInfo);
                                if result == 'YES' then
                                    req_script_check = req_script_check + 1;
                                end
                            end
                        end
                    end
                    
                    if req_script_check == questIES.Check_Script then
                        req_Script = 'YES';
                    end
                end
            elseif questIES.Script_Condition == 'OR' then
                if questIES.Check_Script >= 1 then
                    local i
                    for i = 1, questIES.Check_Script do
                        if questIES['Script'..i] ~= nil and questIES['Script'..i] ~= 'None' and questIES['Script'..i] ~= '' then
                            local scriptInfo = SCR_STRING_CUT(questIES['Script'..i])
                            local func = _G[scriptInfo[1]];
                            if func ~= nil then
                                local result = func(pc, questname, scriptInfo);
                                if result == 'YES' then
                                    req_Script = 'YES'
                                    break
                                end
                            end
                        end
                    end
                end
            end
            
            if req_ReenterTime == 'NO' then
                local dT = 0
                local hT = 0
                local mT = 0
                local sT = 0
                local txt = "'"..questIES.Name.."'"..ScpArgMsg("QuestReenterTimeMSG1")
                if reenterRemainTimeSec >= 86400 then
                    dT = math.floor(reenterRemainTimeSec / 86400)
                    reenterRemainTimeSec = reenterRemainTimeSec - (dT * 86400)
                    txt = txt..dT..ScpArgMsg("QuestReenterTimeD")
                end
                if reenterRemainTimeSec >= 3600 then
                    hT = math.floor(reenterRemainTimeSec / 3600)
                    reenterRemainTimeSec = reenterRemainTimeSec - (hT * 3600)
                    txt = txt..hT..ScpArgMsg("QuestReenterTimeH")
                end
                if reenterRemainTimeSec >= 60 then
                    mT = math.floor(reenterRemainTimeSec / 60)
                    reenterRemainTimeSec = reenterRemainTimeSec - (mT * 60)
                    txt = txt..mT..ScpArgMsg("QuestReenterTimeM")
                end
                sT = reenterRemainTimeSec
                txt = txt..sT..ScpArgMsg("QuestReenterTimeS")..ScpArgMsg("QuestReenterTimeMSG2")
                
                SendAddOnMsg(pc, "NOTICE_Dm_!", txt, 5);
            end
            
            --에피소드 서브퀘스트 언락조건
            --SubQuest_UnLock_Check--
            local req_episode = 'YES'
            if questIES.QuestMode == 'SUB' then
                local accountObj = nil
                if IsServerObj(pc) == 1 then
            		accountObj =  GetAccountObj(pc);
            	else
		            accountObj = GetMyAccountObj();
                end
                if accountObj ~= nil then
                    local episodeCheck = TryGetProp(accountObj, "Episode_10_Clear", 0)
                    if episodeCheck ~= 1 then
                        local myLevel = 1
                        if IsServerObj(pc) == 1 then
                    		myLevel =  TryGetProp(pc, 'Lv', 1);
                    	else
        		            myLevel = GETMYPCLEVEL();
                        end
                        if myLevel < 390 then
                            req_episode = 'NO'
                        end
                    end
                end
            end
            
            if questIES.Check_Condition == 'AND' then
                if req_episode == 'YES' and req_lvup == 'YES' and req_lvdown == 'YES' and req_joblvup == 'YES' and req_joblvdown == 'YES' and req_atkup == 'YES' and req_atkdown == 'YES' and req_defup == 'YES' and req_defdown == 'YES' and req_mhpup == 'YES' and req_mhpdown == 'YES' and req_quest == 'YES' and req_PartyProp == 'YES' and req_JournalMonKill == 'YES' and req_tribe == 'YES' and req_job == 'YES' and req_Gender == 'YES' and req_InvItem == 'YES' and req_EqItem == 'YES' and req_Buff == 'YES' and req_end == 'YES' and req_Location == 'YES' and req_Period == 'YES' and req_ReenterTime =='YES'and req_Skill =='YES' and req_SkillLv =='YES' and req_AOSLine == 'YES' and req_NPCQuestCount == 'YES' and req_HonorPointUp == 'YES' and req_HonorPointDown == 'YES' and req_Script == 'YES' and req_jobstep == 'YES' and req_Repeat == 'YES' then
                    local x = 1
                    
                    if questIES.QuestMode == 'REPEAT' then
                        quest_reason[x] = 'REPEAT'
                        x = x + 1
                    end
                    
                    if questIES.Lvup > 0 then
                        quest_reason[x] = 'Lvup'
                        x = x + 1
                    end
                    if questIES.Lvdown > 0 then
                        quest_reason[x] = 'Lvdown'
                        x = x + 1
                    end
                    if questIES.JobStep > 0 then
                        quest_reason[x] = 'JobStep'
                        x = x + 1
                    end
                    if questIES.JobLvup ~= 'None' then
                        quest_reason[x] = 'JobLvup'
                        x = x + 1
                    end
                    if questIES.JobLvdown ~= 'None' then
                        quest_reason[x] = 'JobLvdown'
                        x = x + 1
                    end
                    if questIES.Atkup > 0 then
                        quest_reason[x] = 'Atkup'
                        x = x + 1
                    end
                    if questIES.Atkdown > 0 then
                        quest_reason[x] = 'Atkdown'
                        x = x + 1
                    end
                    if questIES.Defup > 0 then
                        quest_reason[x] = 'Defup'
                        x = x + 1
                    end
                    if questIES.Defdown > 0 then
                        quest_reason[x] = 'Defdown'
                        x = x + 1
                    end
                    if questIES.Mhpup > 0 then
                        quest_reason[x] = 'Mhpup'
                        x = x + 1
                    end
                    if questIES.Mhpdown > 0 then
                        quest_reason[x] = 'Mhpdown'
                        x = x + 1
                    end
                    if questIES.Check_Location ~= 'NO' and questIES.Check_Location ~= 'None' then
                        quest_reason[x] = 'Check_Location'
                        x = x + 1
                    end
                    if questIES.Check_Tribe > 0 then
                        quest_reason[x] = 'Check_Tribe'
                        x = x + 1
                    end
                    if questIES.Check_Job > 0 then
                        quest_reason[x] = 'Check_Job'
                        x = x + 1
                    end
                    if questIES.Check_QuestCount > 0 then
                        quest_reason[x] = 'Check_QuestCount'
                        x = x + 1
                    end
                    if questIES.Check_PartyPropCount > 0 then
                        quest_reason[x] = 'Check_PartyPropCount'
                        x = x + 1
                    end
                    if questIES.Check_EqItem > 0 then
                        quest_reason[x] = 'Check_EqItem'
                        x = x + 1
                    end
                    if questIES.Check_InvItem > 0 then
                        quest_reason[x] = 'Check_InvItem'
                        x = x + 1
                    end
                    if questIES.Check_PeriodType ~= 'None' then
                        quest_reason[x] = 'Check_PeriodType'
                        x = x + 1
                    end
                    if questIES.Gender > 0 then
                        quest_reason[x] = 'Gender'
                        x = x + 1
                    end
                    if questIES.Check_Buff > 0 then
                        quest_reason[x] = 'Check_Buff'
                        x = x + 1
                    end
                    if questIES.ReenterTime ~= 'None' then
                        quest_reason[x] = 'ReenterTime'
                        x = x + 1
                    end
                    if questIES.Check_Skill > 0 then
                        quest_reason[x] = 'Check_Skill'
                        x = x + 1
                    end
                    
                    if questIES.SkillLv ~= 'None' then
                        quest_reason[x] = 'SkillLv'
                        x = x + 1
                    end
                    
                    if questIES.AOSLine ~= 'None' then
                        quest_reason[x] = 'AOSLine'
                        x = x + 1
                    end
                    
                    if questIES.NPCQuestCount ~= 'None' then
                        quest_reason[x] = 'NPCQuestCount'
                        x = x + 1
                    end
                    
                    if questIES.Check_Script > 0 then
                        quest_reason[x] = 'Check_Script'
                        x = x + 1
                    end
                    
                    return 'POSSIBLE', quest_reason;
                else
                    if req_end == 'NO' then
                        quest_reason[1] = questIES.QuestPropertyName..ScpArgMsg("Auto__PeuLoPeoTi_Kapi_")..CON_QUESTPROPERTY_END..ScpArgMsg("Auto__Kwa_KatDa.")
                        return 'COMPLETE', quest_reason;
                    else
                        local x = 1
                        
                        if req_Repeat ~= 'YES' then
                            quest_reason[x] = 'REPEAT'
                            x = x + 1
                        end
                        
                        if req_lvup ~= 'YES' then
                            quest_reason[x] = 'Lvup'
                            x = x + 1
                        end
                        if req_lvdown ~= 'YES' then
                            quest_reason[x] = 'Lvdown'
                            x = x + 1
                        end
                        if req_jobstep ~= 'YES' then
                            quest_reason[x] = 'JobStep'
                            x = x + 1
                        end
                        if req_joblvup ~= 'YES' then
                            quest_reason[x] = 'JobLvup'
                            x = x + 1
                        end
                        if req_joblvdown ~= 'YES' then
                            quest_reason[x] = 'JobLvdown'
                            x = x + 1
                        end
                        if req_atkup ~= 'YES' then
                            quest_reason[x] = 'Atkup'
                            x = x + 1
                        end
                        if req_atkdown ~= 'YES' then
                            quest_reason[x] = 'Atkdown'
                            x = x + 1
                        end
                        if req_defup ~= 'YES' then
                            quest_reason[x] = 'Defup'
                            x = x + 1
                        end
                        if req_defdown ~= 'YES' then
                            quest_reason[x] = 'Defdown'
                            x = x + 1
                        end
                        if req_mhpup ~= 'YES' then
                            quest_reason[x] = 'Mhpup'
                            x = x + 1
                        end
                        if req_mhpdown ~= 'YES' then
                            quest_reason[x] = 'Mhpdown'
                            x = x + 1
                        end
                        if req_quest ~= 'YES' then
                            quest_reason[x] = 'Check_QuestCount'
                            x = x + 1
                        end
                        if req_PartyProp ~= 'YES' then
                            quest_reason[x] = 'Check_PartyPropCount'
                            x = x + 1
                        end
                        
                        if req_JournalMonKill ~= 'YES' then
                            quest_reason[x] = 'Check_JournalMonKillCount'
                            x = x + 1
                        end
                        
                        if req_tribe ~= 'YES' then
                            quest_reason[x] = 'Check_Tribe'
                            x = x + 1
                        end
                        if req_job ~= 'YES' then
                            quest_reason[x] = 'Check_Job'
                            x = x + 1
                        end
                        if req_Gender ~= 'YES' then
                            quest_reason[x] = 'Gender'
                            x = x + 1
                        end
                        if req_InvItem ~= 'YES' then
                            quest_reason[x] = 'Check_InvItem'
                            x = x + 1
                        end
                        if req_EqItem ~= 'YES' then
                            quest_reason[x] = 'Check_EqItem'
                            x = x + 1
                        end
                        if req_Buff ~= 'YES' then
                            quest_reason[x] = 'Check_Buff'
                            x = x + 1
                        end
                        if req_Location ~= 'YES' then
                            quest_reason[x] = 'Check_Location'
                            x = x + 1
                        end
                        if req_Period ~= 'YES' then
                            quest_reason[x] = 'Check_PeriodType'
                            x = x + 1
                        end
                        if req_ReenterTime ~= 'YES' then
                            quest_reason[x] = 'ReenterTime'
                            x = x + 1
                        end
                        if req_Skill ~= 'YES' then
                            quest_reason[x] = 'Check_Skill'
                            x = x + 1
                        end
                        if req_SkillLv ~= 'YES' then
                            quest_reason[x] = 'SkillLv'
                            x = x + 1
                        end
                        if req_AOSLine ~= 'YES' then
                            quest_reason[x] = 'AOSLine'
                            x = x +1
                        end
                        
                        
                        if req_NPCQuestCount ~= 'YES' then
                            quest_reason[x] = 'NPCQuestCount'
                            x = x +1
                        end
                        
                        if req_HonorPointUp ~= 'YES' then
                            quest_reason[x] = 'HonorPointUp'
                            x = x +1
                        end
                        
                        if req_HonorPointDown ~= 'YES' then
                            quest_reason[x] = 'HonorPointDown'
                            x = x +1
                        end
                        
                        if req_Script ~= 'YES' then
                            quest_reason[x] = 'Check_Script'
                            x = x + 1
                        end
                        
                        return 'IMPOSSIBLE', quest_reason;
                    end
                end
            elseif questIES.Check_Condition == 'OR' then
                if req_end == 'NO' then
                    quest_reason[1] = questIES.QuestPropertyName..ScpArgMsg("Auto__PeuLoPeoTi_Kapi_")..CON_QUESTPROPERTY_END..ScpArgMsg("Auto__Kwa_KatDa.")
                    return 'COMPLETE', quest_reason;
                elseif req_episode == "NO" then
                    return 'IMPOSSIBLE', quest_reason
                elseif req_ReenterTime =='NO' then
                    quest_reason[1] = ScpArgMsg("Auto_ReenterTime_KulTaimeul_ManJogHaJi_MosHam")
                    return 'IMPOSSIBLE', quest_reason;
                elseif (req_lvup == 'YES' and req_lvdown == 'YES' and questIES.Lvup > 0 and  questIES.Lvdown > 0) or (req_lvup == 'YES' and questIES.Lvup > 0 and questIES.Lvdown <= 0) or (req_lvdown == 'YES' and  questIES.Lvdown > 0 and questIES.Lvup <= 0) or (req_joblvup == 'YES' and req_joblvdown == 'YES' and questIES.JobLvup ~= 'None' and  questIES.JobLvdown ~= 'None') or (req_joblvup == 'YES' and questIES.JobLvup ~= 'None' and questIES.JobLvdown == 'None') or (req_joblvdown == 'YES' and  questIES.JobLvdown ~= 'None' and questIES.JobLvup == 'None') or (req_atkup == 'YES' and req_atkdown == 'YES' and questIES.Atkup > 0 and  questIES.Atkdown > 0) or (req_atkup == 'YES' and questIES.Atkup > 0 and questIES.Atkdown <= 0) or (req_atkdown == 'YES' and  questIES.Atkdown > 0 and questIES.Atkup <= 0) or (req_defup == 'YES' and req_defdown == 'YES' and questIES.Defup > 0 and  questIES.Defdown > 0) or (req_defup == 'YES' and questIES.Defup > 0 and questIES.Defdown <= 0) or (req_defdown == 'YES' and  questIES.Defdown > 0 and questIES.Defup <= 0) or (req_mhpup == 'YES' and req_mhpdown == 'YES' and questIES.Mhpup > 0 and  questIES.Mhpdown > 0) or (req_mhpup == 'YES' and questIES.Mhpup > 0 and questIES.Mhpdown <= 0) or (req_mhpdown == 'YES' and  questIES.Mhpdown > 0 and questIES.Mhpup <= 0) or (req_quest == 'YES' and questIES.Check_QuestCount > 0) or (req_PartyProp == 'YES' and questIES.Check_PartyPropCount > 0)or (req_JournalMonKill == 'YES' and GetPropType(questIES, 'Check_JournalMonKillCount') ~= nil and questIES.Check_JournalMonKillCount > 0) or (req_tribe == 'YES' and questIES.Check_Tribe > 0) or (req_job == 'YES' and questIES.Check_Job > 0) or (req_Gender == 'YES' and questIES.Gender > 0) or (req_InvItem == 'YES' and questIES.Check_InvItem > 0) or (req_EqItem == 'YES' and questIES.Check_EqItem > 0) or (req_Buff == 'YES' and questIES.Check_Buff > 0) or (req_Location == 'YES' and questIES.Check_Location ~= 'NO') or (req_Period == 'YES' and questIES.Check_PeriodType ~= 'None') or (req_Skill == 'YES' and questIES.Check_Skill > 0) or (req_SkillLv == 'YES' and questIES.SkillLv ~= 'None' ) or (req_AOSLine == 'YES' and questIES.AOSLine ~= 'None') or (req_NPCQuestCount == 'YES' and questIES.NPCQuestCount ~= 'None') or (req_HonorPointUp =='YES' and questIES.HonorPointUp ~= 'None') or (req_HonorPointDown =='YES' and questIES.HonorPointDown ~= 'None') or (req_Script == 'YES' and questIES.Check_Script > 0) or (req_jobstep == 'YES' and questIES.JobStep > 0) or (req_Repeat =='YES' and questIES.QuestMode == 'REPEAT') then
                    local x = 1
                    
                    if req_Repeat =='YES' and questIES.QuestMode == 'REPEAT' then
                        quest_reason[x] = 'REPEAT'
                        x = x + 1
                    end
                    
                    if req_lvup == 'YES' and req_lvdown == 'YES' and questIES.Lvup > 0 and  questIES.Lvdown > 0 then
                        quest_reason[x] = 'Lvup_Lvdown'
                        x = x + 1
                    end
                    if req_lvup == 'YES' and questIES.Lvup > 0 and questIES.Lvdown <= 0 then
                        quest_reason[x] = 'Lvup'
                        x = x + 1
                    end
                    if req_lvdown == 'YES' and  questIES.Lvdown > 0 and questIES.Lvup <= 0 then
                        quest_reason[x] = 'Lvdown'
                        x = x + 1
                    end
                    if req_joblvup == 'YES' and req_joblvdown == 'YES' and questIES.JobLvup ~= 'None' and  questIES.JobLvdown ~= 'None' then
                        quest_reason[x] = 'JobLvup_JobLvdown'
                        x = x + 1
                    end
                    if req_joblvup == 'YES' and questIES.JobLvup ~= 'None' and questIES.JobLvdown == 'None' then
                        quest_reason[x] = 'JobLvup'
                        x = x + 1
                    end
                    if req_joblvdown == 'YES' and  questIES.JobLvdown ~= 'None' and questIES.JobLvup == 'None' then
                        quest_reason[x] = 'JobLvdown'
                        x = x + 1
                    end
                    if req_atkup == 'YES' and req_atkdown == 'YES' and questIES.Atkup > 0 and  questIES.Atkdown > 0 then
                        quest_reason[x] = 'Atkup_Atkdown'
                        x = x + 1
                    end
                    if req_atkup == 'YES' and questIES.Atkup > 0 and questIES.Atkdown <= 0 then
                        quest_reason[x] = 'Atkup'
                        x = x + 1
                    end
                    if req_atkdown == 'YES' and  questIES.Atkdown > 0 and questIES.Atkup <= 0 then
                        quest_reason[x] = 'Atkdown'
                        x = x + 1
                    end
                    if req_defup == 'YES' and req_defdown == 'YES' and questIES.Defup > 0 and  questIES.Defdown > 0 then
                        quest_reason[x] = 'Defup_Defdown'
                        x = x + 1
                    end
                    if req_defup == 'YES' and questIES.Defup > 0 and questIES.Defdown <= 0 then
                        quest_reason[x] = 'Defup'
                        x = x + 1
                    end
                    if req_defdown == 'YES' and  questIES.Defdown > 0 and questIES.Defup <= 0 then
                        quest_reason[x] = 'Defdown'
                        x = x + 1
                    end
                    if req_mhpup == 'YES' and req_mhpdown == 'YES' and questIES.Mhpup > 0 and  questIES.Mhpdown > 0 then
                        quest_reason[x] = 'Mhpup_Mhpdown'
                        x = x + 1
                    end
                    if req_mhpup == 'YES' and questIES.Mhpup > 0 and questIES.Mhpdown <= 0 then
                        quest_reason[x] = 'Mhpup'
                        x = x + 1
                    end
                    if req_mhpdown == 'YES' and  questIES.Mhpdown > 0 and questIES.Mhpup <= 0 then
                        quest_reason[x] = 'Mhpdown'
                        x = x + 1
                    end
                    if req_quest == 'YES' and questIES.Check_QuestCount > 0 then
                        quest_reason[x] = 'Check_QuestCount'
                        x = x + 1
                    end
                    if req_PartyProp == 'YES' and questIES.Check_PartyPropCount > 0 then
                        quest_reason[x] = 'Check_PartyPropCount'
                        x = x + 1
                    end
                    
                    if req_JournalMonKill == 'YES' and GetPropType(questIES, 'Check_JournalMonKillCount') ~= nil and questIES.Check_JournalMonKillCount > 0 then
                        quest_reason[x] = 'Check_JournalMonKillCount'
                        x = x + 1
                    end
                    if req_tribe == 'YES' and questIES.Check_Tribe > 0 then
                        quest_reason[x] = 'Check_Tribe'
                        x = x + 1
                    end
                    if req_job == 'YES' and questIES.Check_Job > 0 then
                        quest_reason[x] = 'Check_Job'
                        x = x + 1
                    end
                    if req_Gender == 'YES' and questIES.Gender > 0 then
                        quest_reason[x] = 'Gender'
                        x = x + 1
                    end
                    if req_InvItem == 'YES' and questIES.Check_InvItem > 0 then
                        quest_reason[x] = 'Check_InvItem'
                        x = x + 1
                    end
                    if req_EqItem == 'YES' and questIES.Check_EqItem > 0 then
                        quest_reason[x] = 'Check_EqItem'
                        x = x + 1
                    end
                    if req_Buff == 'YES' and questIES.Check_Buff > 0 then
                        quest_reason[x] = 'Check_Buff'
                        x = x + 1
                    end
                    if req_Location == 'YES' and questIES.Check_Location ~= 'NO' then
                        quest_reason[x] = 'Check_Location'
                        x = x + 1
                    end
                    if req_Period == 'YES' and questIES.Check_PeriodType ~= 'None' then
                        quest_reason[x] = 'Check_PeriodType'
                        x = x + 1
                    end
                    if req_Skill == 'YES' and questIES.Check_Skill > 0 then
                        quest_reason[x] = 'Check_Skill'
                        x = x + 1
                    end
                    
                    if req_SkillLv == 'YES' and questIES.SkillLv ~= 'None' then
                        quest_reason[x] = 'SkillLv'
                        x = x + 1
                    end
                    
                    if req_AOSLine == 'YES' and questIES.AOSLine ~= 'None' then
                        quest_reason[x] = 'AOSLine'
                        x = x + 1
                    end
                    
                    if req_NPCQuestCount == 'YES' and questIES.NPCQuestCount ~= 'None' then
                        quest_reason[x] = 'NPCQuestCount'
                        x = x + 1
                    end
                    
                    if req_HonorPointUp == 'YES' and questIES.HonorPointUp ~= 'None' then
                        quest_reason[x] = 'HonorPointUp'
                        x = x + 1
                    end
                    
                    if req_HonorPointDown == 'YES' and questIES.HonorPointDown ~= 'None' then
                        quest_reason[x] = 'HonorPointDown'
                        x = x + 1
                    end
                    
                    if req_Script == 'YES' and questIES.Check_Script > 0 then
                        quest_reason[x] = 'Check_Script'
                        x = x + 1
                    end
                    
                    if req_jobstep == 'YES' and questIES.JobStep > 0 then
                        quest_reason[x] = 'JobStep'
                        x = x + 1
                    end
                    
                    
                    return 'POSSIBLE', quest_reason;
                else
                    local x = 1
                    
                    if req_Repeat ~='YES' and questIES.QuestMode == 'REPEAT' then
                        quest_reason[x] = 'REPEAT'
                        x = x + 1
                    end
                    
                    if req_lvup ~= 'YES' and questIES.Lvup > 0 and  questIES.Lvdown > 0 then
                        quest_reason[x] = 'Lvup'
                        x = x + 1
                    end
                    if req_lvdown ~= 'YES' and questIES.Lvup > 0 and  questIES.Lvdown > 0 then
                        quest_reason[x] = 'Lvdown'
                        x = x + 1
                    end
                    if req_lvup ~= 'YES' and questIES.Lvup > 0 and questIES.Lvdown <= 0 then
                        quest_reason[x] = 'Lvup'
                        x = x + 1
                    end
                    if req_lvdown ~= 'YES' and  questIES.Lvdown > 0 and questIES.Lvup <= 0 then
                        quest_reason[x] = 'Lvdown'
                        x = x + 1
                    end
                    
                    if req_joblvup ~= 'YES' and questIES.JobLvup ~= 'None' and  questIES.JobLvdown  ~= 'None' then
                        quest_reason[x] = 'JobLvup'
                        x = x + 1
                    end
                    if req_joblvdown ~= 'YES' and questIES.JobLvup  ~= 'None' and  questIES.JobLvdown  ~= 'None' then
                        quest_reason[x] = 'JobLvdown'
                        x = x + 1
                    end
                    if req_joblvup ~= 'YES' and questIES.JobLvup  ~= 'None' and questIES.JobLvdown  == 'None' then
                        quest_reason[x] = 'JobLvup'
                        x = x + 1
                    end
                    if req_joblvdown ~= 'YES' and  questIES.JObLvdown  ~= 'None' and questIES.JobLvup  == 'None' then
                        quest_reason[x] = 'JobLvdown'
                        x = x + 1
                    end
                    
                    if req_atkup ~= 'YES' and questIES.Atkup > 0 and  questIES.Atkdown > 0 then
                        quest_reason[x] = 'Atkup'
                        x = x + 1
                    end
                    if req_atkdown ~= 'YES' and questIES.Atkup > 0 and  questIES.Atkdown > 0 then
                        quest_reason[x] = 'Atkdown'
                        x = x + 1
                    end
                    if req_atkup ~= 'YES' and questIES.Atkup > 0 and questIES.Atkdown <= 0 then
                        quest_reason[x] = 'Atkup'
                        x = x + 1
                    end
                    if req_atkdown ~= 'YES' and  questIES.Atkdown > 0 and questIES.Atkup <= 0 then
                        quest_reason[x] = 'Atkdown'
                        x = x + 1
                    end
                    if req_defup ~= 'YES' and questIES.Defup > 0 and  questIES.Defdown > 0 then
                        quest_reason[x] = 'Defup'
                        x = x + 1
                    end
                    if req_defdown ~= 'YES' and questIES.Defup > 0 and  questIES.Defdown > 0 then
                        quest_reason[x] = 'Defdown'
                        x = x + 1
                    end
                    if req_defup ~= 'YES' and questIES.Defup > 0 and questIES.Defdown <= 0 then
                        quest_reason[x] = 'Defup'
                        x = x + 1
                    end
                    if req_defdown ~= 'YES' and  questIES.Defdown > 0 and questIES.Defup <= 0 then
                        quest_reason[x] = 'Defdown'
                        x = x + 1
                    end
                    if req_mhpup ~= 'YES' and questIES.Mhpup > 0 and  questIES.Mhpdown > 0 then
                        quest_reason[x] = 'Mhpup'
                        x = x + 1
                    end
                    if req_mhpdown ~= 'YES' and questIES.Mhpup > 0 and  questIES.Mhpdown > 0 then
                        quest_reason[x] = 'Mhpdown'
                        x = x + 1
                    end
                    if req_mhpup ~= 'YES' and questIES.Mhpup > 0 and questIES.Mhpdown <= 0 then
                        quest_reason[x] = 'Mhpup'
                        x = x + 1
                    end
                    if req_mhpdown ~= 'YES' and  questIES.Mhpdown > 0 and questIES.Mhpup <= 0 then
                        quest_reason[x] = 'Mhpdown'
                        x = x + 1
                    end
                    if req_quest ~= 'YES' and questIES.Check_QuestCount > 0 then
                        quest_reason[x] = 'Check_QuestCount'
                        x = x + 1
                    end
                    if req_PartyProp ~= 'YES' and questIES.Check_PartyPropCount > 0 then
                        quest_reason[x] = 'Check_PartyPropCount'
                        x = x + 1
                    end
                    if req_JournalMonKill ~= 'YES' and GetPropType(questIES, 'Check_JournalMonKillCount') ~= nil and questIES.Check_JournalMonKillCount > 0 then
                        quest_reason[x] = 'Check_JournalMonKillCount'
                        x = x + 1
                    end
                    if req_tribe ~= 'YES' and questIES.Check_Tribe > 0 then
                        quest_reason[x] = 'Check_Tribe'
                        x = x + 1
                    end
                    if req_job ~= 'YES' and questIES.Check_Job > 0 then
                        quest_reason[x] = 'Check_Job'
                        x = x + 1
                    end
                    if req_Gender ~= 'YES' and questIES.Gender > 0 then
                        quest_reason[x] = 'Gender'
                        x = x + 1
                    end
                    if req_InvItem ~= 'YES' and questIES.Check_InvItem > 0 then
                        quest_reason[x] = 'Check_InvItem'
                        x = x + 1
                    end
                    if req_EqItem ~= 'YES' and questIES.Check_EqItem > 0 then
                        quest_reason[x] = 'Check_EqItem'
                        x = x + 1
                    end
                    if req_Buff ~= 'YES' and questIES.Check_Buff > 0 then
                        quest_reason[x] = 'Check_Buff'
                        x = x + 1
                    end
                    if req_Location ~= 'YES' and questIES.Check_Location ~= 'NO' then
                        quest_reason[x] = 'Check_Location'
                        x = x + 1
                    end
                    if req_Period ~= 'YES' and questIES.Check_PeriodType ~= 'None' then
                        quest_reason[x] = 'Check_PeriodType'
                        x = x + 1
                    end
                    if req_Skill ~= 'YES' and questIES.Check_Skill > 0 then
                        quest_reason[x] = 'Check_Skill'
                        x = x + 1
                    end
                    if req_SkillLv ~= 'YES' and questIES.SkillLv ~= 'None' then
                        quest_reason[x] = 'SkillLv'
                        x = x + 1
                    end
                    if req_AOSLine ~= 'YES' and questIES.AOSLine ~= 'None' then
                        quest_reason[x] = 'AOSLine'
                        x = x + 1
                    end
                    if req_NPCQuestCount ~= 'YES' and questIES.NPCQuestCount ~= 'None' then
                        quest_reason[x] = 'NPCQuestCount'
                        x = x + 1
                    end
                    
                    if req_HonorPointUp ~= 'YES' and questIES.HonorPointUp ~= 'None' then
                        quest_reason[x] = 'HonorPointUp'
                        x = x + 1
                    end
                    
                    if req_HonorPointDown ~= 'YES' and questIES.HonorPointDown ~= 'None' then
                        quest_reason[x] = 'HonorPointDown'
                        x = x + 1
                    end
                    
                    if req_Script ~= 'YES' and questIES.Check_Script > 0 then
                        quest_reason[x] = 'Check_Script'
                        x = x + 1
                    end
                    
                    if req_jobstep ~= 'YES' and questIES.JobStep > 0 then
                        quest_reason[x] = 'JobStep'
                        x = x + 1
                    end
                    
                    return 'IMPOSSIBLE', quest_reason;
                end
            else
                print(questname,ScpArgMsg("Auto_KweSeuTeu_Check_Condition_Kapi_AND_/_OR_DulJunge_HaNayeoya_HapNiDa."))
            end
        end
    else
--        DumpCallStack();
--        print(ScpArgMsg("Auto__QuestProgressCheck.xml_Paile_")..questname..ScpArgMsg("Auto__i_JonJae_HaJi_anSeupNiDa."))
        return
    end
end

function SCR_PERIOD_CHECK(check_type,period_data)
    
    local s_year, s_month, s_day, s_wday, s_hour, s_minute, e_year, e_month, e_day, e_wday, e_hour, e_minute
    
    if check_type == 'year/month/day/hour:min' then
        s_year, s_month, s_day, s_hour, s_minute, e_year, e_month, e_day, e_hour, e_minute = string.match(period_data, '(%d+)/(%d+)/(%d+)/(%d+):(%d+)~(%d+)/(%d+)/(%d+)/(%d+):(%d+)')
        
        if s_year == nil or s_month == nil or s_day == nil or s_hour == nil or s_minute == nil or e_year == nil or e_month == nil or e_day == nil or e_hour == nil or e_minute == nil then
            print(period_data,ScpArgMsg("Auto_Kapi"),check_type,ScpArgMsg("Auto_HyeongSige_MajJi_anSeupNiDa."))
        end
        
    elseif check_type == 'wday/hour:min' then
        s_wday, s_hour, s_minute, e_wday, e_hour, e_minute = string.match(period_data, '(%a+)/(%d+):(%d+)~(%a+)/(%d+):(%d+)')
        
        if s_wday == nil or s_hour == nil or s_minute == nil or e_wday == nil or e_hour == nil or e_minute == nil then
            print(period_data,ScpArgMsg("Auto_Kapi"),check_type,ScpArgMsg("Auto_HyeongSige_MajJi_anSeupNiDa."))
        end
        
        if s_wday == 'SUN' then
            s_wday = 1
        elseif s_wday == 'MON' then
            s_wday = 2
        elseif s_wday == 'TUE' then
            s_wday = 3
        elseif s_wday == 'WED' then
            s_wday = 4
        elseif s_wday == 'THU' then
            s_wday = 5
        elseif s_wday == 'FRI' then
            s_wday = 6
        elseif s_wday == 'SAT' then
            s_wday = 7
        end
        
        
        if e_wday == 'SUN' then
            e_wday = 1
        elseif e_wday == 'MON' then
            e_wday = 2
        elseif e_wday == 'TUE' then
            e_wday = 3
        elseif e_wday == 'WED' then
            e_wday = 4
        elseif e_wday == 'THU' then
            e_wday = 5
        elseif e_wday == 'FRI' then
            e_wday = 6
        elseif e_wday == 'SAT' then
            e_wday = 7
        end
    elseif check_type == 'hour:min' then
        s_hour, s_minute, e_hour, e_minute = string.match(period_data, '(%d+):(%d+)~(%d+):(%d+)')
        
        if s_hour == nil or s_minute == nil or e_hour == nil or e_minute == nil then
            print(period_data,ScpArgMsg("Auto_Kapi"),check_type,ScpArgMsg("Auto_HyeongSige_MajJi_anSeupNiDa."))
        end
    elseif check_type == 'min' then
        s_minute, e_minute = string.match(period_data, '(%d+)~(%d+)')
        
        if s_minute == nil or e_minute == nil then
            print(period_data,ScpArgMsg("Auto_Kapi"),check_type,ScpArgMsg("Auto_HyeongSige_MajJi_anSeupNiDa."))
        end
    end
    
    local now_time = os.date('*t')
    local req_Period_func = 'NO'
    local req_Period_start = 'NO'
    local req_Period_end = 'NO'

    s_year = tonumber(s_year);
    s_month = tonumber(s_month);
    s_day = tonumber(s_day);
    s_wday = tonumber(s_wday);
    s_hour = tonumber(s_hour);
    s_minute = tonumber(s_minute);
    e_year = tonumber(e_year);
    e_month = tonumber(e_month);
    e_day = tonumber(e_day);
    e_wday = tonumber(e_wday);
    e_hour = tonumber(e_hour);
    e_minute = tonumber(e_minute);
    
    
    if check_type == 'year/month/day/hour:min' then
        if s_year < now_time['year'] then
            req_Period_start = 'YES'
        elseif s_year == now_time['year'] then
            if s_month < now_time['month'] then
                req_Period_start = 'YES'
            elseif s_month == now_time['month'] then
                if s_day < now_time['day'] then
                    req_Period_start = 'YES'
                elseif s_day == now_time['day'] then
                    if s_hour < now_time['hour'] then
                        req_Period_start = 'YES'
                    elseif s_hour == now_time['hour'] then
                        if s_minute < now_time['min'] then
                            req_Period_start = 'YES'
                        elseif s_minute == now_time['min'] then
                            req_Period_start = 'YES'
                            req_Period_func = 'YES'
                        end
                    end
                end
            end
        end
        
        if e_year > now_time['year'] then
            req_Period_end = 'YES'
        elseif e_year == now_time['year'] then
            if e_month > now_time['month'] then
                req_Period_end = 'YES'
            elseif e_month == now_time['month'] then
                if e_day > now_time['day'] then
                    req_Period_end = 'YES'
                elseif e_day == now_time['day'] then
                    if e_hour > now_time['hour'] then
                        req_Period_end = 'YES'
                    elseif e_hour == now_time['hour'] then
                        if e_minute > now_time['min'] then
                            req_Period_end = 'YES'
                        elseif e_minute == now_time['min'] then
                            req_Period_end = 'YES'
                            req_Period_func = 'YES'
                        end
                    end
                end
            end
        end
        
        if req_Period_start == 'YES' and req_Period_end == 'YES' then
            req_Period_func = 'YES'
        end
    elseif check_type == 'wday/hour:min' then
        if s_wday < now_time['wday'] then
            req_Period_start = 'YES'
        elseif s_wday == now_time['wday'] then
            if s_hour < now_time['hour'] then
                req_Period_start = 'YES'
            elseif s_hour == now_time['hour'] then
                if s_minute < now_time['min'] then
                    req_Period_start = 'YES'
                elseif s_minute == now_time['min'] then
                    req_Period_start = 'YES'
                end
            end
        end
        
        if e_wday > now_time['wday'] then
            req_Period_end = 'YES'
        elseif e_wday == now_time['wday'] then
            if e_hour > now_time['hour'] then
                req_Period_end = 'YES'
            elseif e_hour == now_time['hour'] then
                if e_minute > now_time['min'] then
                    req_Period_end = 'YES'
                elseif e_minute == now_time['min'] then
                    req_Period_end = 'YES'
                end
            end
        end
        
        if req_Period_start == 'YES' and req_Period_end == 'YES' then
            req_Period_func = 'YES'
        end
    elseif check_type == 'hour:min' then
        if s_hour < now_time['hour'] then
            req_Period_start = 'YES'
        elseif s_hour == now_time['hour'] then
            if s_minute < now_time['min'] then
                req_Period_start = 'YES'
            elseif s_minute == now_time['min'] then
                req_Period_start = 'YES'
                req_Period_func = 'YES'
            end
        end
        
        if e_hour > now_time['hour'] then
            req_Period_end = 'YES'
        elseif e_hour == now_time['hour'] then
            if e_minute > now_time['min'] then
                req_Period_end = 'YES'
            elseif e_minute == now_time['min'] then
                req_Period_end = 'YES'
                req_Period_func = 'YES'
            end
        end
        
        if req_Period_start == 'YES' and req_Period_end == 'YES' then
            req_Period_func = 'YES'
        end
    elseif check_type == 'min' then
        if s_minute < now_time['min'] then
            req_Period_start = 'YES'
        elseif s_minute == now_time['min'] then
            req_Period_start = 'YES'
            req_Period_func = 'YES'
        end
        
        if e_minute > now_time['min'] then
            req_Period_end = 'YES'
        elseif e_minute == now_time['min'] then
            req_Period_end = 'YES'
            req_Period_func = 'YES'
        end
        
        if req_Period_start == 'YES' and req_Period_end == 'YES' then
            req_Period_func = 'YES'
        end
    end
    
    return req_Period_func
end

function SCR_QUEST_REQ_STRINGCUT(arg_type, arg_msg)
    local result1, result2
    if arg_type == 'SKILL' then
        result1, result2 = string.match(arg_msg,'(.+)[/](.+)')
    end
    return result1, result2
end


function SCR_AOSLine_Check(pc, aosline)
    local cut_list = {}
    
    cut_list = SCR_STRING_CUT(aosline)
--    print('WWWWWWWWWWWWW',GetMonsterDistribution(zoneInstID, cut_list[2]), cut_list[1], cut_list[2], type(tonumber(cut_list[3])), tonumber(cut_list[3]))
--    print('WWWWWWWWWWWWW',GetMonsterDistribution(zoneInstID, cut_list[2]))
    local distribute = GetMonsterDistribution(pc, cut_list[2]);
    if distribute == nil then
        return 'NO';
    end
    
    if cut_list[1] == "UP" then
        if distribute >= tonumber(cut_list[3]) then
            return 'YES'
        end
    elseif cut_list[1] == "DOWN" then
        if distribute <= tonumber(cut_list[3]) then
            return 'YES'
        end
    end
    
    return 'NO'
end


function SCR_NPCQuestCount_Check(npcquestcount_list, quest_terms)
    local cut_list = {}
    local i
    
    if npcquestcount_list == nil then
        return 'NO'
    end
    quest_terms = string.gsub(quest_terms, 'QuestCount', '')
    
    for i = 1, #npcquestcount_list do
        if npcquestcount_list[i] ~= nil and npcquestcount_list[i] > 0 then
            if i == tonumber(quest_terms) then
                return 'YES'
            end
        end
    end
    
    return 'NO'
end

function SCR_SESSIONOBJ_INFO_CHECK(quest_ssn_name)
    local quest_ssn = GetClass('SessionObject',quest_ssn_name)
    local i
    local flag = 0
    local result = 'NO'
    for i = 1, QUEST_MAX_ETC_CNT do
        if quest_ssn['QuestInfoName'..i] ~= 'None' then
            flag = flag + 1
        end
    end
    
    if flag > 0 then
        result =  'YES'
    end
    
    return result
end



--function SCR_TEST_FUNC(pc)
--    return 'YES'
--end

function SCR_QUEST_STATE_COMPARE(pc_quest_state, target_quest_state)
    local quest_state_list = {
                    IMPOSSIBLE = 100,
                    POSSIBLE = 200,
                    PROGRESS = 300,
                    SUCCESS = 400,
                    COMPLETE = 500
                    }
    if quest_state_list[pc_quest_state] >= quest_state_list[target_quest_state] then
        return 'YES'
    else
        return 'NO'
    end
end


function GET_QUEST_NPC_STATE(questIES, result, pc)
	if result == 'POSSIBLE' then
        if questIES.POSSI_WARP == 'YES' and questIES.StartNPC ~= 'None' then
            return 'Start';
        end
        
        if pc ~= nil and SCR_MAIN_QUEST_WARP_CHECK(pc, result, questIES, questIES.ClassName) == 'YES' then
            return 'Start';
        end
        
    elseif result == 'PROGRESS' and questIES.ProgNPC ~= 'None' then
        if questIES.PROG_WARP == 'YES' then
            return 'Prog';
        end
    elseif result == 'SUCCESS' and questIES.EndNPC ~= 'None' then
        if questIES.SUCC_WARP == 'YES' then
            return 'End';
        end
    end

	return nil;
end


function SCR_QUEST_MONKILL_CHEKC(self, questname)
    local result = 'NO'
    local questIES = GetClass('QuestProgressCheck', questname)
    if questIES ~= nil then
        local sObj = GetSessionObject(self, questIES.Quest_SSN)
        if sObj ~= nil then
            if questIES ~= nil then
                if questIES.Succ_MonKillCount1 > 0 then
                    local i
                    local flag = 0
                    
                    for i = 1, questIES.Succ_MonKillCount1 do
                        if sObj.KillMonster1 >= questIES.Succ_MonKillCount1 then
                            flag = flag + 1
                        end
                    end
                    
                    if questIES.Succ_MonKill_Condition == 'AND' then
                        if questIES.Succ_MonKillCount1 == flag then
                            result = 'YES'
                        end
                    else
                        if flag > 0 then
                            result = 'YES'
                        end
                    end
                end
            end
        end
    end
    return result
end


function SCR_QUEST_SUCC_CHECK_MODULE_MONKILL(pc, questIES)
    local Succ_req_monkill_check = 0;
    local Succ_req_MonKill = 'NO'
    local shortfall = {}
    local monkill_sObj
    local ssnMonCheck = false
    
    if questIES.Quest_SSN ~= 'None' then
        monkill_sObj = GetSessionObject(pc, questIES.Quest_SSN);
    end
    
    if monkill_sObj ~= nil and GetPropType(monkill_sObj, 'SSNMonKill') ~= nil and monkill_sObj.SSNMonKill ~= 'None' then
        ssnMonCheck = true
        local monInfo = SCR_STRING_CUT(monkill_sObj.SSNMonKill, ":")
        if #monInfo >= 3 and #monInfo % 3 == 0 and monInfo[1] ~= 'ZONEMONKILL' then
            local ssnMonListCount = #monInfo / 3
            local flag = 0
            for i = 1, QUEST_MAX_MON_CHECK do
                if ssnMonListCount >= i then
                    local needCount = tonumber(monInfo[i*3 - 1])
                    local nowCount = monkill_sObj['KillMonster'..i]
                    if nowCount >= needCount then
                        flag = flag + 1
                    end
                else
                    break
                end
            end
            
            if flag >= ssnMonListCount then
                Succ_req_MonKill = 'YES'
            end
        elseif monInfo[1] == 'ZONEMONKILL'  then
            local flag = 0
            for i = 1, QUEST_MAX_MON_CHECK do
                if #monInfo - 1 >= i then
                    local index = i + 1
                    local zoneMonInfo = SCR_STRING_CUT(monInfo[index])
                    local needCount = tonumber(zoneMonInfo[2])
                    local nowCount = monkill_sObj['KillMonster'..i]
                    if nowCount >= needCount then
                        flag = flag + 1
                    end
                else
                    break
                end
            end
            if flag >= #monInfo - 1 then
                Succ_req_MonKill = 'YES'
            end
        end
    elseif questIES.Succ_Check_MonKill == 0 then
        Succ_req_MonKill = 'YES';
    elseif questIES.Succ_MonKill_Condition == 'AND' then
        if questIES.Succ_Check_MonKill >= 1 then
            if monkill_sObj ~= nil then
                if questIES.Succ_Check_MonKill >= 6 then
                    if monkill_sObj.KillMonster6 >= questIES.Succ_MonKillCount6 and questIES.Succ_MonKill_ItemGive6 == 'None' and questIES.Succ_MonKillCount6 > 0 then
                        Succ_req_monkill_check = Succ_req_monkill_check + 1;
                    else
                        if questIES.Succ_MonKill_ItemGive6 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive6_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_MonKillCount6 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount6_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        shortfall[#shortfall + 1] = 6
                    end
                end
                if questIES.Succ_Check_MonKill >= 5 then
                    if monkill_sObj.KillMonster5 >= questIES.Succ_MonKillCount5 and questIES.Succ_MonKill_ItemGive5 == 'None' and questIES.Succ_MonKillCount5 > 0 then
                        Succ_req_monkill_check = Succ_req_monkill_check + 1;
                    else
                        if questIES.Succ_MonKill_ItemGive5 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive5_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_MonKillCount5 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount5_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 5
                    end
                end
                if questIES.Succ_Check_MonKill >= 4 then
                    if monkill_sObj.KillMonster4 >= questIES.Succ_MonKillCount4 and questIES.Succ_MonKill_ItemGive4 == 'None' and questIES.Succ_MonKillCount4 > 0 then
                        Succ_req_monkill_check = Succ_req_monkill_check + 1;
                    else
                        if questIES.Succ_MonKill_ItemGive4 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive4_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_MonKillCount4 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount4_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 4
                    end
                end
                if questIES.Succ_Check_MonKill >= 3 then
                    if monkill_sObj.KillMonster3 >= questIES.Succ_MonKillCount3 and questIES.Succ_MonKill_ItemGive3 == 'None' and questIES.Succ_MonKillCount3 > 0 then
                        Succ_req_monkill_check = Succ_req_monkill_check + 1;
                    else
                        if questIES.Succ_MonKill_ItemGive3 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive3_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_MonKillCount3 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount3_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 3
                    end
                end
                if questIES.Succ_Check_MonKill >= 2 then
                    if monkill_sObj.KillMonster2 >= questIES.Succ_MonKillCount2 and questIES.Succ_MonKill_ItemGive2 == 'None' and questIES.Succ_MonKillCount2 > 0 then
                        Succ_req_monkill_check = Succ_req_monkill_check + 1;
                    else
                        if questIES.Succ_MonKill_ItemGive2 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive2_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_MonKillCount2 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount2_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 2
                    end
                end
                if monkill_sObj.KillMonster1 >= questIES.Succ_MonKillCount1 and questIES.Succ_MonKill_ItemGive1 == 'None' and questIES.Succ_MonKillCount1 > 0 then
                    Succ_req_monkill_check = Succ_req_monkill_check + 1;
                else
                    if questIES.Succ_MonKill_ItemGive1 ~= 'None' then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKill_ItemGive1_KeolLeomi_None_ieoyaHam"))
                    end
                    if questIES.Succ_MonKillCount1 <= 0 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_MonKillCount1_KeolLeomi_0BoDa_KeoyaHam"))
                    end
                    
                    shortfall[#shortfall + 1] = 1
                end
            else
                if IsServerSection(pc) == 1 then
                    print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_"),questIES.Quest_SSN,ScpArgMsg("Auto__SeSyeonoBeuJegTeuKa_PCeKe_eopeum"))
                end
            end
            if Succ_req_monkill_check == questIES.Succ_Check_MonKill then
                Succ_req_MonKill = 'YES';
            end
        end
    elseif questIES.Succ_MonKill_Condition == 'OR' then
        if questIES.Succ_Check_MonKill >= 1 then
            if monkill_sObj ~= nil then
                local i
                for i = 1, 6 do
                    if questIES['Succ_MonKillName'..i] ~= 'None' and questIES['Succ_MonKill_ItemGive'..i] == 'None' then
                        if monkill_sObj['KillMonster'..i] >= questIES['Succ_MonKillCount'..i] then
                            Succ_req_MonKill = 'YES';
                        else
                            shortfall[#shortfall + 1] = i
                        end
                    else
                        shortfall[#shortfall + 1] = i
                    end
                end
            else
                if IsServerSection(pc) == 1 then
                    print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_"),questIES.Quest_SSN,ScpArgMsg("Auto__SeSyeonoBeuJegTeuKa_PCeKe_eopeum"))
                end
            end
        end
    end
    
    return Succ_req_MonKill, shortfall, ssnMonCheck
end

function SCR_QUEST_SUCC_CHECK_MODULE_OVERKILL(pc, questIES)
    local Succ_req_overkill_check = 0;
    local Succ_req_OverKill = 'NO'
    local shortfall = {}
    
    if questIES.Succ_Check_OverKill == 0 then
        Succ_req_OverKill = 'YES';
    elseif questIES.Succ_OverKill_Condition == 'AND' then
        if questIES.Succ_Check_OverKill >= 1 then
            local overkill_sObj = GetSessionObject(pc, questIES.Quest_SSN);
            if overkill_sObj ~= nil then
                if questIES.Succ_Check_OverKill >= 6 then
                    if overkill_sObj.OverKill6 >= questIES.Succ_OverKillCount6 and questIES.Succ_OverKill_ItemGive6 == 'None' and questIES.Succ_OverKillCount6 > 0 then
                        Succ_req_overkill_check = Succ_req_overkill_check + 1;
                    else
                        if questIES.Succ_OverKill_ItemGive6 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive6_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_OverKillCount6 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount6_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 6
                    end
                end
                if questIES.Succ_Check_OverKill >= 5 then
                    if overkill_sObj.OverKill5 >= questIES.Succ_OverKillCount5 and questIES.Succ_OverKill_ItemGive5 == 'None' and questIES.Succ_OverKillCount5 > 0 then
                        Succ_req_overkill_check = Succ_req_overkill_check + 1;
                    else
                        if questIES.Succ_OverKill_ItemGive5 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive5_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_OverKillCount5 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount5_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 5
                    end
                end
                if questIES.Succ_Check_OverKill >= 4 then
                    if overkill_sObj.OverKill4 >= questIES.Succ_OverKillCount4 and questIES.Succ_OverKill_ItemGive4 == 'None' and questIES.Succ_OverKillCount4 > 0 then
                        Succ_req_overkill_check = Succ_req_overkill_check + 1;
                    else
                        if questIES.Succ_OverKill_ItemGive4 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive4_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_OverKillCount4 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount4_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 4
                    end
                end
                if questIES.Succ_Check_OverKill >= 3 then
                    if overkill_sObj.OverKill3 >= questIES.Succ_OverKillCount3 and questIES.Succ_OverKill_ItemGive3 == 'None' and questIES.Succ_OverKillCount3 > 0 then
                        Succ_req_overkill_check = Succ_req_overkill_check + 1;
                    else
                        if questIES.Succ_OverKill_ItemGive3 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive3_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_OverKillCount3 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount3_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 3
                    end
                end
                if questIES.Succ_Check_OverKill >= 2 then
                    if overkill_sObj.OverKill2 >= questIES.Succ_OverKillCount2 and questIES.Succ_OverKill_ItemGive2 == 'None' and questIES.Succ_OverKillCount2 > 0 then
                        Succ_req_overkill_check = Succ_req_overkill_check + 1;
                    else
                        if questIES.Succ_OverKill_ItemGive2 ~= 'None' then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive2_KeolLeomi_None_ieoyaHam"))
                        end
                        if questIES.Succ_OverKillCount2 <= 0 then
                            print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount2_KeolLeomi_0BoDa_KeoyaHam"))
                        end
                        
                        shortfall[#shortfall + 1] = 2
                    end
                end
                if overkill_sObj.OverKill1 >= questIES.Succ_OverKillCount1 and questIES.Succ_OverKill_ItemGive1 == 'None' and questIES.Succ_OverKillCount1 > 0 then
                    Succ_req_overkill_check = Succ_req_overkill_check + 1;
                else
                    if questIES.Succ_OverKill_ItemGive1 ~= 'None' then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKill_ItemGive1_KeolLeomi_None_ieoyaHam"))
                    end
                    if questIES.Succ_OverKillCount1 <= 0 then
                        print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_Succ_OverKillCount1_KeolLeomi_0BoDa_KeoyaHam"))
                    end
                        
                    shortfall[#shortfall + 1] = 1
                end
            else
                if IsServerSection(pc) == 1 then
                    print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_"),questIES.Quest_SSN,ScpArgMsg("Auto__SeSyeonoBeuJegTeuKa_PCeKe_eopeum"))
                end
            end
            if Succ_req_overkill_check == questIES.Succ_Check_OverKill then
                Succ_req_OverKill = 'YES';
            end
        end
    elseif questIES.Succ_OverKill_Condition == 'OR' then
        if questIES.Succ_Check_OverKill >= 1 then
            local overkill_sObj = GetSessionObject(pc, questIES.Quest_SSN);
            if overkill_sObj ~= nil then
                local i
                for i = 1, 6 do
                    if questIES['Succ_OverKillName'..i] ~= 'None'  and questIES['Succ_OverKill_ItemGive'..i] == 'None' then
                        if overkill_sObj['OverKill'..i] >= questIES['Succ_OverKillCount'..i] then
                            Succ_req_OverKill = 'YES';
                        else
                            shortfall[#shortfall + 1] = i
                        end
                    else
                        shortfall[#shortfall + 1] = i
                    end
                end
            else
                if IsServerSection(pc) == 1 then
                    print(questIES.ClassName,ScpArgMsg("Auto__KweSeuTeu_"),questIES.Quest_SSN,ScpArgMsg("Auto__SeSyeonoBeuJegTeuKa_PCeKe_eopeum"))
                end
            end
        end
    end
    
    return Succ_req_OverKill, shortfall
end

function SCR_QUEST_SUCC_CHECK_MODULE_SSNINVITEM(pc, questIES, sObj_quest, noSuccessPropertyChangeFlag)
    local Succ_req_SSNInvItem = 'NO'
    local flag = true
    local ssnInvItemCheck = false
    
    if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
        ssnInvItemCheck = true
        local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
        local maxCount = math.floor(#itemList/3)
        for i = 1, maxCount do
            if GetInvItemCount(pc, itemList[i*3 - 2]) < itemList[i*3 - 1] then
                flag = false
                break
            end
        end
    end
    
    if flag == true then
        Succ_req_SSNInvItem = 'YES'
        if ssnInvItemCheck == true then
            noSuccessPropertyChangeFlag = 1
        end
    end
    
    return Succ_req_SSNInvItem, ssnInvItemCheck, noSuccessPropertyChangeFlag
end
function SCR_QUEST_SUCC_CHECK_MODULE_INVITEM(pc, questIES, noSuccessPropertyChangeFlag)
    local Succ_req_InvItem = 'NO'
    local Succ_req_invitem_check = 0;
    local shortfall = {}
    local questItemFlag = 0
    
    if questIES.Succ_Check_InvItem == 0 then
        Succ_req_InvItem = 'YES';
    elseif questIES.Succ_InvItem_Condition == 'AND' then
        if questIES.Succ_Check_InvItem >= 1 then
            if questIES.Succ_Check_InvItem >= 4 then
                if questIES.Succ_InvItemCount4 <= 0 then
                    print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_InvItemCount4_KeolLeom_Kapi_0_BoDa_KeoyaHam"))
                else
                    if GetInvItemCount(pc, questIES.Succ_InvItemName4) >= questIES.Succ_InvItemCount4 then
                        Succ_req_invitem_check = Succ_req_invitem_check + 1;
                        local itemIES = GetClass('Item',questIES.Succ_InvItemName4)
                        if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                            questItemFlag = questItemFlag + 1
                        end
                    else
                        shortfall[#shortfall + 1] = 4
                    end
                end
            end
            if questIES.Succ_Check_InvItem >= 3 then
                if questIES.Succ_InvItemCount3 <= 0 then
                    print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_InvItemCount3_KeolLeom_Kapi_0_BoDa_KeoyaHam"))
                else
                    if GetInvItemCount(pc, questIES.Succ_InvItemName3) >= questIES.Succ_InvItemCount3 then
                        Succ_req_invitem_check = Succ_req_invitem_check + 1;
                        local itemIES = GetClass('Item',questIES.Succ_InvItemName3)
                        if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                            questItemFlag = questItemFlag + 1
                        end
                    else
                        shortfall[#shortfall + 1] = 3
                    end
                end
            end
            if questIES.Succ_Check_InvItem >= 2 then
                if questIES.Succ_InvItemCount2 <= 0 then
                    print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_InvItemCount2_KeolLeom_Kapi_0_BoDa_KeoyaHam"))
                else
                    if GetInvItemCount(pc, questIES.Succ_InvItemName2) >= questIES.Succ_InvItemCount2 then
                        Succ_req_invitem_check = Succ_req_invitem_check + 1;
                        local itemIES = GetClass('Item',questIES.Succ_InvItemName2)
                        if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                            questItemFlag = questItemFlag + 1
                        end
                    else
                        shortfall[#shortfall + 1] = 2
                    end
                end
            end
            if questIES.Succ_Check_InvItem >= 1 then
                if questIES.Succ_InvItemCount1 <= 0 then
                    print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_InvItemCount1_KeolLeom_Kapi_0_BoDa_KeoyaHam"))
                else
                    if GetInvItemCount(pc, questIES.Succ_InvItemName1) >= questIES.Succ_InvItemCount1 then
                        Succ_req_invitem_check = Succ_req_invitem_check + 1;
                        local itemIES = GetClass('Item',questIES.Succ_InvItemName1)
                        if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                            questItemFlag = questItemFlag + 1
                        end
                    else
                        shortfall[#shortfall + 1] = 1
                    end
                end
            end
            
            if Succ_req_invitem_check == questIES.Succ_Check_InvItem then
                Succ_req_InvItem = 'YES';
                if questItemFlag ~= Succ_req_invitem_check then
                    noSuccessPropertyChangeFlag = 1
                end
            end
        end
    elseif questIES.Succ_InvItem_Condition == 'OR' then
        if questIES.Succ_Check_InvItem >= 1 then
            local i
            for i = 1, questIES.Succ_Check_InvItem do
                if questIES['Succ_InvItemName'..i] ~= 'None' then
                    if questIES['Succ_InvItemCount'..i] <= 0 then
                        print(questIES.ClassName,ScpArgMsg("Auto_KweSeuTeuui_Succ_InvItemCount")..i..ScpArgMsg("Auto__KeolLeom_Kapi_0_BoDa_KeoyaHam"))
                    else
                        if GetInvItemCount(pc, questIES['Succ_InvItemName'..i]) >= questIES['Succ_InvItemCount'..i] then
                            Succ_req_InvItem = 'YES';
                            local itemIES = GetClass('Item',questIES['Succ_InvItemName'..i])
                            if itemIES.GroupName == 'Quest' and itemIES.Destroyable == 'NO' and itemIES.TeamTrade == 'NO' and itemIES.ShopTrade == 'NO' and itemIES.MarketTrade == 'NO' and itemIES.UserTrade == 'NO' and itemIES.Consumable == 'NO' then
                                questItemFlag = questItemFlag + 1
                            end
                        else
                            shortfall[#shortfall + 1] = i
                        end
                    end
                end
            end
            if Succ_req_InvItem == 'YES' and questItemFlag == 0 then
                noSuccessPropertyChangeFlag = 1
            end
        end
    end
    
    return Succ_req_InvItem, shortfall, noSuccessPropertyChangeFlag
end

function SCR_QUEST_SUCC_CHECK_MODULE_QUEST(pc, questIES, sObj)
    local result = 'NO'
    if questIES.Succ_Check_QuestCount == 0 then
        result = 'YES';
    elseif questIES.Succ_Quest_Condition == 'AND' then
        local Succ_req_quest_check = 0;
        local i
        for i = 1, 10 do
            if questIES['Succ_QuestName'..i] ~= 'None' then
                local ret = SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, i)
                if ret == 'YES' then
                    Succ_req_quest_check = Succ_req_quest_check + 1
                end
            end
        end
        if Succ_req_quest_check == questIES.Succ_Check_QuestCount then
            result = 'YES';
        end
    elseif questIES.Succ_Quest_Condition == 'OR' then
        local i
        for i = 1, 10 do
            if questIES['Succ_QuestName'..i] ~= 'None' then
                local ret = SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, i)
                if ret == 'YES' then
                    result = 'YES'
                    break
                end
            end
        end
    end
    
    return result
end

function SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, i)
    local result = 'NO'
    
    if questIES['Succ_QuestName'..i] ~= 'None' then
        local state
        if questIES['Succ_QuestCount'..i] <= 0 then
            state = 'POSSIBLE'
        elseif questIES['Succ_QuestCount'..i] == CON_QUESTPROPERTY_MIN then
            state = 'PROGRESS'
        elseif questIES['Succ_QuestCount'..i] == CON_QUESTPROPERTY_MAX then
            state = 'SUCCESS'
        elseif questIES['Succ_QuestCount'..i] == CON_QUESTPROPERTY_END then
            state = 'COMPLETE'
        end
        if questIES['Succ_QuestTerms'..i] == '>=' then
            if state == 'POSSIBLE' or state == 'PROGRESS' or state == 'COMPLETE'  then
                if state == 'POSSIBLE' and sObj[questIES['Succ_QuestName'..i]] > 0 then
                    result = 'YES'
                elseif state == 'POSSIBLE' and sObj[questIES['Succ_QuestName'..i]] <= 0 then
                    local quest_state = SCR_QUEST_CHECK(pc, questIES['Succ_QuestName'..i])
                    if quest_state == 'POSSIBLE' then
                        result = 'YES'
                    end
                elseif state == 'PROGRESS' and sObj[questIES['Succ_QuestName'..i]] >= 1 then
                    result = 'YES'
                elseif state == 'COMPLETE' and sObj[questIES['Succ_QuestName'..i]] >= 300 then
                    result = 'YES'
                end
            elseif state == 'SUCCESS' then
                if sObj[questIES['Succ_QuestName'..i]] >= 200 then
                    result = 'YES'
                else
                    local succQuestIES = GetClass('QuestProgressCheck',questIES['Succ_QuestName'..i])
                    if succQuestIES ~= nil then
                        local quest_state = SCR_QUEST_CHECK(pc, questIES['Succ_QuestName'..i])
                        if SCR_QUEST_STATE_COMPARE( quest_state, state) == 'YES' then
                            result = 'YES'
                        end
                    end
                end
            end
        elseif questIES['Succ_QuestTerms'..i] == '==' then
            if state == 'POSSIBLE' or state == 'COMPLETE'  then
                if state == 'POSSIBLE' and sObj[questIES['Succ_QuestName'..i]] <= 0 then
                    local quest_state = SCR_QUEST_CHECK(pc, questIES['Succ_QuestName'..i])
                    if quest_state == 'POSSIBLE' then
                        result = 'YES'
                    end
                elseif state == 'COMPLETE' and sObj[questIES['Succ_QuestName'..i]] == 300 then
                    result = 'YES'
                end
            elseif state == 'PROGRESS' or state == 'SUCCESS' then
                if state == 'PROGRESS' and sObj[questIES['Succ_QuestName'..i]] >= 1 and sObj[questIES['Succ_QuestName'..i]] < 200 then
                    result = 'YES'
                elseif state == 'SUCCESS' and sObj[questIES['Succ_QuestName'..i]] == 200 then
                    result = 'YES'
                else
                    local succQuestIES = GetClass('QuestProgressCheck',questIES['Succ_QuestName'..i])
                    if succQuestIES ~= nil then
                        if IS_QUEST_STATE(pc, questIES['Succ_QuestName'..i], state) == true then
                            result = 'YES'
                        end
                    end
                end
            end
        end
    end
    
    return result
end


function SCR_QUEST_PRE_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj, i)
    local result = 'NO'
    
    if questIES['QuestName'..i] ~= 'None' then
        local state
        if questIES['QuestCount'..i] <= 0 then
            state = 'POSSIBLE'
        elseif questIES['QuestCount'..i] == CON_QUESTPROPERTY_MIN then
            state = 'PROGRESS'
        elseif questIES['QuestCount'..i] == CON_QUESTPROPERTY_MAX then
            state = 'SUCCESS'
        elseif questIES['QuestCount'..i] == CON_QUESTPROPERTY_END then
            state = 'COMPLETE'
        end
        if questIES['QuestTerms'..i] == '>=' then
            if state == 'POSSIBLE' or state == 'PROGRESS' or state == 'COMPLETE'  then
                if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] >= 0 then
                    result = 'YES'
                elseif state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 then
                    result = 'YES'
                elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] >= 300 then
                    result = 'YES'
                end
            elseif state == 'SUCCESS' then
                if sObj[questIES['QuestName'..i]] >= 200 then
                    result = 'YES'
                else
                    local succQuestIES = GetClass('QuestProgressCheck',questIES['QuestName'..i])
                    if succQuestIES ~= nil then
                        local quest_state = SCR_QUEST_CHECK(pc, questIES['QuestName'..i])
                        if SCR_QUEST_STATE_COMPARE( quest_state, state) == 'YES' then
                            result = 'YES'
                        end
                    end
                end
            end
        elseif questIES['QuestTerms'..i] == '==' then
            if state == 'POSSIBLE' or state == 'COMPLETE'  then
                if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] == 0 then
                    result = 'YES'
                elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] == 300 then
                    result = 'YES'
                end
            elseif state == 'PROGRESS' or state == 'SUCCESS' then
                if state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 and sObj[questIES['QuestName'..i]] < 200 then
                    result = 'YES'
                elseif state == 'SUCCESS' and sObj[questIES['QuestName'..i]] == 200 then
                    result = 'YES'
                else
                    local succQuestIES = GetClass('QuestProgressCheck',questIES['QuestName'..i])
                    if succQuestIES ~= nil then
                        if IS_QUEST_STATE(pc, questIES['QuestName'..i], state) == true then
                            result = 'YES'
                        end
                    end
                end
            end
        end
    end
    
    return result
end

function SCR_REPEAT_REWARD_CHECK(pc, questIES, quest_auto, sObj)
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local questname = questIES.ClassName
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    if quest_auto.Success_RepeatComplete ~= 'None' and questIES.QuestMode == 'REPEAT' then
        if string.find(quest_auto.Success_RepeatComplete, 'SELECTITEM') ~= nil then
            repeat_reward_select = true
        end
        
        local strList = SCR_STRING_CUT(quest_auto.Success_RepeatComplete)
        for i = 1, #strList do
            local strItem = SCR_STRING_CUT_COLON(strList[i])
            local flag = false
            if questname ~= nil then
                if GetPropType(sObj, questname..'_R') ~= nil then
                    local targetValue = tonumber(strItem[1]) - 1
                    if strItem[2] == '>=' then
                        if sObj[questname..'_R'] >= targetValue then
                            flag = true
                        end
                    elseif strItem[2] == '<=' then
                        if sObj[questname..'_R'] <= targetValue then
                            flag = true
                        end
                    elseif strItem[2] == '==' then
                        if sObj[questname..'_R'] == targetValue then
                            flag = true
                        end
                    end
                end
            end
            
            if flag == true then
                table.remove(strItem, 1)
                table.remove(strItem, 1)
                if strItem[1] == 'ITEM' then
                    repeat_reward_item[#repeat_reward_item + 1] = {}
                    strItem[3] = tonumber(strItem[3])
                    repeat_reward_item[#repeat_reward_item] = strItem
                elseif strItem[1] == 'ACHIEVE_POINT' then
                    repeat_reward_achieve_point[#repeat_reward_achieve_point + 1] = {}
                    strItem[3] = tonumber(strItem[3])
                    repeat_reward_achieve_point[#repeat_reward_achieve_point] = strItem
                elseif strItem[1] == 'ACHIEVE' then
                    repeat_reward_achieve[#repeat_reward_achieve + 1] = {}
                    repeat_reward_achieve[#repeat_reward_achieve] = strItem
                elseif strItem[1] == 'EXP' and tonumber(strItem[2]) ~= nil  then
                    repeat_reward_exp = tonumber(strItem[2])
                elseif strItem[1] == 'NPC_POINT' then
                    repeat_reward_npc_point = repeat_reward_npc_point + tonumber(strItem[2])
                elseif strItem[1] == 'SELECTITEM' then
                    repeat_reward_select_use = true
                end
            end
        end
    end
    return repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use
end


function SCR_QUEST_SUCC_REWARD_DLG(pc, questIES, quest_auto, sObj)
    local result = 'DlgNo'
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questIES, quest_auto, sObj)
    
    local item_list = {}
    local take_list = {}
    local rullet_use = 'NO'
    local jobclassname = SCR_JOBNAME_MATCHING(pc.JobName)
    
    if quest_auto.Success_ItemName1 ~= 'None' or quest_auto.Success_JobItem_Name1 ~= 'None' or #repeat_reward_item > 0 then
        if quest_auto.Success_ItemName1 ~= 'None' then
            for i = 1, 4 do
                if quest_auto['Success_ItemName'..i] ~= 'None' then
                    item_list[#item_list + 1] = {}
                    
                    item_list[#item_list][1] = quest_auto['Success_ItemName'..i]
                    item_list[#item_list][2] = quest_auto['Success_ItemCount'..i]
                end
            end
        end
        if quest_auto.Success_JobItem_Name1 ~= 'None' then
            for i = 1, 20 do
                if quest_auto['Success_JobItem_Name'..i] ~= 'None' and quest_auto['Success_JobItem_JobList'..i] ~= 'None' then
                    local jobList = SCR_STRING_CUT(quest_auto['Success_JobItem_JobList'..i])
                    if SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, jobList, jobclassname, pc.Gender, quest_auto.Success_ChangeJob) == 'YES' then
                        item_list[#item_list + 1] = {}
                        
                        item_list[#item_list][1] = quest_auto['Success_JobItem_Name'..i]
                        item_list[#item_list][2] = quest_auto['Success_JobItem_Count'..i]
                    end
                end
            end
        end
        if #repeat_reward_item > 0 then
            for i = 1, #repeat_reward_item do
                item_list[#item_list + 1] = {}
                
                item_list[#item_list][1] = repeat_reward_item[i][2]
                item_list[#item_list][2] = repeat_reward_item[i][3]
            end
        end
        
        
        take_list = SCR_QUEST_SUCCESS_TAKEITEM_LIST(pc, questIES, quest_auto)
    end
    
    local qRewardDlgBefore = true
    local track1Cut = SCR_STRING_CUT(quest_auto.Track1)
    if #track1Cut > 1 and track1Cut[1] == 'SSuccess' then
        qRewardDlgBefore = false
    end
    if qRewardDlgBefore == true then
        for i = 1, 10 do
            if string.find(quest_auto['Success_Dialog'..i], '/TrackInTrack/') ~= nil then
                qRewardDlgBefore = false
                break
            end
        end
    end
    
    if #repeat_reward_achieve > 0 or #repeat_reward_achieve_point > 0 or repeat_reward_exp > 0 or repeat_reward_npc_point > 0 or #item_list > 0 or #take_list > 0 or quest_auto.Success_ChangeJob ~= 'None' or quest_auto.Success_HonorPoint ~= 'None' or quest_auto.Success_Exp > 0 or quest_auto.Success_Lv_Exp > 0 or quest_auto.Success_SkillPoint > 0 or quest_auto.Success_StatByBonus > 0 or quest_auto.Success_PropertyByBonus > 0 or (tonumber(quest_auto.Success_MedalADD) ~= nil and tonumber(quest_auto.Success_MedalADD) ~= 0) or quest_auto.Success_HitMe ~= 0 or quest_auto.Success_Rullet ~= 'None' or (quest_auto.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] ~= 'None' ) or (quest_auto.Success_SelectItemName1 ~= 'None' and (repeat_reward_select == false or (repeat_reward_select == true and repeat_reward_select_use == true))) then
        if qRewardDlgBefore == true then
            result = 'DlgBefore'
        else
            result = 'DlgAfter'
        end
    end
    
    return result
end

function SCR_QUEST_POSS_TAKEITEM_LIST(quest_auto)
    local take_list = {}
    
    for i = 1, 5 do
        if quest_auto['Possible_TakeItemName'..i] ~= 'None' then
            take_list[#take_list + 1] = {}
            
            take_list[#take_list][1] = quest_auto['Possible_TakeItemName'..i]
            take_list[#take_list][2] = quest_auto['Possible_TakeItemCount'..i]
        end
    end
    return take_list
end

function SCR_QUEST_PROG_TAKEITEM_LIST(quest_auto)
    local take_list = {}
    
    for i = 1, 5 do
        if quest_auto['Progress_TakeItemName'..i] ~= 'None' then
            take_list[#take_list + 1] = {}
            
            take_list[#take_list][1] = quest_auto['Progress_TakeItemName'..i]
            take_list[#take_list][2] = quest_auto['Progress_TakeItemCount'..i]
        end
    end
    return take_list
end

function SCR_QUEST_SUCCESS_TAKEITEM_LIST(pc, questIES, quest_auto)
    local take_list = {}
    
    for i = 1, 5 do
        if quest_auto['Success_TakeItemName'..i] ~= 'None' then
            take_list[#take_list + 1] = {}
            
            take_list[#take_list][1] = quest_auto['Success_TakeItemName'..i]
            take_list[#take_list][2] = quest_auto['Success_TakeItemCount'..i]
        end
    end
    
                        
    if questIES.Succ_QuestNeedItemAutoTake == 'YES' and questIES.Succ_Check_InvItem > 0 then
        for i = 1, 4 do
            if questIES['Succ_InvItemName'..i] ~= 'None' then
                local itemSameCheck = 0
                for x = 1, 5 do
                    if quest_auto['Success_TakeItemName'..x] == questIES['Succ_InvItemName'..i] then
                        itemSameCheck = 1
                        break
                    end
                end
                if itemSameCheck == 0 then
                    take_list[#take_list + 1] = {}
                
                    take_list[#take_list][1] = questIES['Succ_InvItemName'..i]
                    take_list[#take_list][2] = questIES['Succ_InvItemCount'..i]
                end
            end
        end
    end
    
    if questIES.Succ_QuestNeedItemAutoTake == 'YES' and questIES.Quest_SSN ~= 'None' then
        local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
                local itemSameCheck = 0
                for x = 1, 5 do
                    if quest_auto['Success_TakeItemName'..x] == itemList[i*3 - 2] then
                        itemSameCheck = 1
                        break
                    end
                end
                if itemSameCheck == 0 then
                    take_list[#take_list + 1] = {}
                
                    take_list[#take_list][1] = itemList[i*3 - 2]
                    take_list[#take_list][2] = itemList[i*3 - 1]
                end
            end
        end
    end
    
    return take_list
end

function SCR_QUEST_PRE_CHECK_REENTERTIME(questIES, sObj)
    local req_ReenterTime = 'NO'
    local reenterRemainTimeSec
    
    if questIES.ReenterTime ~= 'None' then
        if sObj[questIES.QuestPropertyName..'_RT'] > 0 then
            local now_time = os.date('*t')
            local now_time_sec = (now_time['year'] - 2000) * 3600 * 24 * 365 + now_time['yday'] * 3600 * 24 + now_time['hour'] * 3600 + now_time['min'] * 60 + now_time['sec']
            if now_time_sec > sObj[questIES.QuestPropertyName..'_RT'] then
                req_ReenterTime = 'YES'
            else
                reenterRemainTimeSec = sObj[questIES.QuestPropertyName..'_RT'] - now_time_sec
                req_ReenterTime = 'NO'
            end
        else
            req_ReenterTime = 'YES'
        end
    else
        req_ReenterTime = 'YES'
    end
    
    return req_ReenterTime, reenterRemainTimeSec
end

function SCR_QUEST_CHECK_MODULE_QUEST(pc, questIES, sObj)
    local req_quest = "NO"
    if questIES.Check_QuestCount == 0 then
        req_quest = 'YES';
    end
    if sObj ~= nil then
        local req_quest_check = 0
        
        if questIES.Quest_Condition == 'AND' then
            local i
            for i = 1, 4 do
                if questIES['QuestName'..i] ~= 'None' then
                    local state
                    if questIES['QuestCount'..i] <= 0 then
                        state = 'POSSIBLE'
                    elseif questIES['QuestCount'..i] == 1 then
                        state = 'PROGRESS'
                    elseif questIES['QuestCount'..i] == 200 then
                        state = 'SUCCESS'
                    elseif questIES['QuestCount'..i] == 300 then
                        state = 'COMPLETE'
                    end
                    if questIES['QuestTerms'..i] == '>=' then
                        if state == 'POSSIBLE' or state == 'PROGRESS' or state == 'COMPLETE'  then
                            if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] >= 0 then
                                req_quest_check = req_quest_check + 1
                            elseif state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 then
                                req_quest_check = req_quest_check + 1
                            elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] >= 300 then
                                req_quest_check = req_quest_check + 1
                            end
                        elseif state == 'SUCCESS' then
                            if sObj[questIES['QuestName'..i]] >= 200 then
                                req_quest_check = req_quest_check + 1
                            else
                                local quest_state = SCR_QUEST_CHECK(pc, questIES['QuestName'..i])
                                if SCR_QUEST_STATE_COMPARE( quest_state, state) == 'YES' then
                                    req_quest_check = req_quest_check + 1
                                end
                            end
                        end
                    elseif questIES['QuestTerms'..i] == '==' then
                        if state == 'POSSIBLE' or state == 'COMPLETE'  then
                            if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] <= 0 then
                                req_quest_check = req_quest_check + 1
                            elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] >= 300 then
                                req_quest_check = req_quest_check + 1
                            end
                        elseif state == 'PROGRESS' or state == 'SUCCESS' then
                            if state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 and sObj[questIES['QuestName'..i]] < 200 then
                                req_quest_check = req_quest_check + 1
                            elseif state == 'SUCCESS' and sObj[questIES['QuestName'..i]] == 200 then
                                req_quest_check = req_quest_check + 1
                            else
                                if IS_QUEST_STATE(pc, questIES['QuestName'..i], state) == true then
                                    req_quest_check = req_quest_check + 1
                                end
                            end
                        end
                    end
                end
            end
            if req_quest_check == questIES.Check_QuestCount then
                req_quest = 'YES';
            end
        elseif questIES.Quest_Condition == 'OR' then
            local i
            for i = 1, 4 do
                if questIES['QuestName'..i] ~= 'None' then
                    local state
                    if questIES['QuestCount'..i] <= 0 then
                        state = 'POSSIBLE'
                    elseif questIES['QuestCount'..i] == 1 then
                        state = 'PROGRESS'
                    elseif questIES['QuestCount'..i] == 200 then
                        state = 'SUCCESS'
                    elseif questIES['QuestCount'..i] == 300 then
                        state = 'COMPLETE'
                    end
                    if questIES['QuestTerms'..i] == '>=' then
                        if state == 'POSSIBLE' or state == 'PROGRESS' or state == 'COMPLETE'  then
                            if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] >= 0 then
                                req_quest = 'YES'
                                break
                            elseif state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 then
                                req_quest = 'YES'
                                break
                            elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] >= 300 then
                                req_quest = 'YES'
                                break
                            end
                        elseif state == 'SUCCESS' then
                            if sObj[questIES['QuestName'..i]] >= 200 then
                                req_quest = 'YES'
                                break
                            else
                                local quest_state = SCR_QUEST_CHECK(pc, questIES['QuestName'..i])
                                if SCR_QUEST_STATE_COMPARE( quest_state, state) == 'YES' then
                                    req_quest = 'YES'
                                    break
                                end
                            end
                        end
                    elseif questIES['QuestTerms'..i] == '==' then
                        if state == 'POSSIBLE' or state == 'COMPLETE'  then
                            if state == 'POSSIBLE' and sObj[questIES['QuestName'..i]] <= 0 then
                                req_quest = 'YES'
                                break
                            elseif state == 'COMPLETE' and sObj[questIES['QuestName'..i]] >= 300 then
                                req_quest = 'YES'
                                break
                            end
                        elseif state == 'PROGRESS' or state == 'SUCCESS' then
                            if state == 'PROGRESS' and sObj[questIES['QuestName'..i]] >= 1 and sObj[questIES['QuestName'..i]] < 200 then
                                req_quest = 'YES'
                                break
                            elseif state == 'SUCCESS' and sObj[questIES['QuestName'..i]] == 200 then
                                req_quest = 'YES'
                                break
                            else
                                if IS_QUEST_STATE(pc, questIES['QuestName'..i], state) == true then
                                    req_quest = 'YES'
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return req_quest
end

function SCR_JOURNALMONKILL_SUCC_CHECK_MODULE_QUEST(pc, questIES)
    local Succ_req_JournalMonKill = "NO"
    local checkCount = {}
    
    if GetPropType(questIES, 'Succ_Check_JournalMonKillCount') == nil or questIES.Succ_Check_JournalMonKillCount == 0 then
        return 'YES'
    end
    
    if GetPropType(questIES, 'Succ_Check_JournalMonKillCount') ~= nil and GetPropType(questIES, 'Succ_Journal_MonKill_Condition') ~= nil then
        if questIES.Succ_Journal_MonKill_Condition == 'OR' then
            for i = 1, questIES.Succ_Check_JournalMonKillCount do
                if GetPropType(questIES, 'Succ_Journal_MonKillName'..i) ~= nil and GetPropType(questIES, 'Succ_Journal_MonKillCount'..i) ~= nil then
                    if questIES['Succ_Journal_MonKillName'..i] ~= 'None' and questIES['Succ_Journal_MonKillName'..i] ~= '' then
                        checkCount[#checkCount+1] = {i,"NO"}
                        local killCount = nil;
                        --[[ hs_comment: 개편될 함수로 교체해주세요~
                        if IsServerSection(pc) == 1 then
                            local wiki = GetWikiByName(pc, questIES['Succ_Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount")
                            end
                        else
                            local wiki = GetWikiByName(questIES['Succ_Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount");
                            end
                        end
                        if killCount ~= nil then
                            if killCount >= questIES['Succ_Journal_MonKillCount'..i] then
                                checkCount[#checkCount][2] = "YES"
                                return 'YES', checkCount
                            end
                        end
                        ]]--
                    end
                end
            end
        else
            local succCount = 0
            for i = 1, questIES.Succ_Check_JournalMonKillCount do
                if GetPropType(questIES, 'Succ_Journal_MonKillName'..i) ~= nil and GetPropType(questIES, 'Succ_Journal_MonKillCount'..i) ~= nil then
                    if questIES['Succ_Journal_MonKillName'..i] ~= 'None' and questIES['Succ_Journal_MonKillName'..i] ~= '' then
                        checkCount[#checkCount+1] = {i,"NO"}
                        local killCount
                        --[[ hs_comment: 개편된 함수로 교체해주세요~
                        if IsServerSection(pc) == 1 then
                            local wiki = GetWikiByName(pc, questIES['Succ_Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount")
                            end
                        else
                            local wiki = GetWikiByName(questIES['Succ_Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount");
                            end
                        end
                        if killCount ~= nil then
                            if killCount >= questIES['Succ_Journal_MonKillCount'..i] then
                                checkCount[#checkCount][2] = "YES"
                                succCount = succCount + 1
                            end
                        end
                        ]]--
                    end
                end
            end
            if #checkCount <= succCount then
                return "YES", checkCount
            end
        end
    end
    return "NO", checkCount
end

function SCR_JOURNALMONKILL_CHECK_MODULE_QUEST(pc, questIES)
    local req_JournalMonKill = "NO"
    local checkCount = {}
    
    if GetPropType(questIES, 'Check_JournalMonKillCount') == nil or questIES.Check_JournalMonKillCount == 0 then
        return 'YES'
    end
    
    if GetPropType(questIES, 'Check_JournalMonKillCount') ~= nil and GetPropType(questIES, 'Journal_MonKill_Condition') ~= nil then
        if questIES.Journal_MonKill_Condition == 'OR' then
            for i = 1, questIES.Check_JournalMonKillCount do
                if GetPropType(questIES, 'Journal_MonKillName'..i) ~= nil and GetPropType(questIES, 'Journal_MonKillCount'..i) ~= nil then
                    if questIES['Journal_MonKillName'..i] ~= 'None' and questIES['Journal_MonKillName'..i] ~= '' then
                        checkCount[#checkCount+1] = {i,"NO"}
                        local killCount
                        --[[ hs_comment: 개편된 함수로 교체해주세요~
                        if IsServerSection(pc) == 1 then
                            local wiki = GetWikiByName(pc, questIES['Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount")
                            end
                        else
                            local wiki = GetWikiByName(questIES['Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount");
                            end
                        end
                        if killCount ~= nil then
                            if killCount >= questIES['Journal_MonKillCount'..i] then
                                checkCount[#checkCount][2] = "YES"
                                return 'YES', checkCount
                            end
                        end
                        ]]--
                    end
                end
            end
        else
            local succCount = 0
            for i = 1, questIES.Check_JournalMonKillCount do
                if GetPropType(questIES, 'Journal_MonKillName'..i) ~= nil and GetPropType(questIES, 'Journal_MonKillCount'..i) ~= nil then
                    if questIES['Journal_MonKillName'..i] ~= 'None' and questIES['Journal_MonKillName'..i] ~= '' then
                        checkCount[#checkCount+1] = {i,"NO"}
                        local killCount
                        --[[ hs_comment: 개편된 함수로 교체해주세요~
                        if IsServerSection(pc) == 1 then
                            local wiki = GetWikiByName(pc, questIES['Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount")
                            end
                        else
                            local wiki = GetWikiByName(questIES['Journal_MonKillName'..i])
                            if wiki ~= nil then
                                killCount = GetWikiIntProp(wiki, "KillCount");
                            end
                        end
                        if killCount ~= nil then
                            if killCount >= questIES['Journal_MonKillCount'..i] then
                                checkCount[#checkCount][2] = "YES"
                                succCount = succCount + 1
                            end
                        end
                        ]]--
                    end
                end
            end
            if #checkCount <= succCount then
                return "YES", checkCount
            end
        end
    end
    return "NO", checkCount
end

function SCR_PARTY_QUEST_CHECK_MODULE_QUEST(pc, questIES)
    local req_PartyProp = "NO"
    if questIES.Check_PartyPropCount == 0 then
        req_PartyProp = 'YES';
    end
    local partyObj;
    if IsServerSection(pc) == 1 then
        partyObj = GetPartyObj(pc)
    else
        local pcparty = session.party.GetPartyInfo();
        if pcparty ~= nil then
            partyObj = GetIES(pcparty:GetObject());
        end
    end
    
    if partyObj ~= nil then
        local req_PartyProp_check = 0
        local partyPropCheckCount = questIES.Check_PartyPropCount
        if questIES.PartyProp_Condition == 'AND' then
            local i
            for i = 1, partyPropCheckCount do
                if questIES['PartyPropName'..i] ~= 'None' then
                    if GetPropType(partyObj, questIES['PartyPropName'..i]) ~= nil then
                        if questIES['PartyPropTerms'..i] == '>=' then
                            if partyObj[questIES['PartyPropName'..i]] >= questIES['PartyPropCount'..i] then
                                req_PartyProp_check = req_PartyProp_check + 1
                            end
                        elseif questIES['PartyPropTerms'..i] == '==' then
                            if partyObj[questIES['PartyPropName'..i]] == questIES['PartyPropCount'..i] then
                                req_PartyProp_check = req_PartyProp_check + 1
                            end
                        elseif questIES['PartyPropTerms'..i] == '<=' then
                            if partyObj[questIES['PartyPropName'..i]] <= questIES['PartyPropCount'..i] then
                                req_PartyProp_check = req_PartyProp_check + 1
                            end
                        end
                    end
                end
            end
            if req_PartyProp_check == questIES.Check_PartyPropCount then
                req_PartyProp = 'YES';
            end
        elseif questIES.PartyProp_Condition == 'OR' then
            local i
            for i = 1, partyPropCheckCount do
                if GetPropType(partyObj, questIES['PartyPropName'..i]) ~= nil then
                    if questIES['PartyPropName'..i] ~= 'None' then
                        if questIES['PartyPropTerms'..i] == '>=' then
                            if partyObj[questIES['PartyPropName'..i]] >= questIES['PartyPropCount'..i] then
                                req_PartyProp = 'YES'
                                break
                            end
                        elseif questIES['PartyPropTerms'..i] == '==' then
                            if partyObj[questIES['PartyPropName'..i]] == questIES['PartyPropCount'..i] then
                                req_PartyProp = 'YES'
                                break
                            end
                        elseif questIES['PartyPropTerms'..i] == '<=' then
                            if partyObj[questIES['PartyPropName'..i]] <= questIES['PartyPropCount'..i] then
                                req_PartyProp = 'YES'
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    return req_PartyProp
end


function SCR_QUEST_POSSIBLE_CHECK_ITEM_LIST(pc, questIES)
    local ret = {}
    if questIES.Check_Location == 'YES' then
        ret[#ret+1] = 'Check_Location'
    end
    if questIES.Check_Job > 0 then
        ret[#ret+1] = 'Check_Job'
    end
    if questIES.Gender > 0 then
        ret[#ret+1] = 'Gender'
    end
    if questIES.Check_Buff > 0 then
        ret[#ret+1] = 'Check_Buff'
    end
    if questIES.Check_EqItem > 0 then
        ret[#ret+1] = 'Check_EqItem'
    end
    if questIES.Check_InvItem > 0 then
        ret[#ret+1] = 'Check_InvItem'
    end
    if questIES.Check_PeriodType ~= 'None' then
        ret[#ret+1] = 'Check_PeriodType'
    end
    if questIES.Atkup > 0 then
        ret[#ret+1] = 'Atkup'
    end
    if questIES.Atkdown > 0 then
        ret[#ret+1] = 'Atkdown'
    end
    if questIES.Defup > 0 then
        ret[#ret+1] = 'Defup'
    end
    if questIES.Defdown > 0 then
        ret[#ret+1] = 'Defdown'
    end
    if questIES.Mhpup > 0 then
        ret[#ret+1] = 'Mhpup'
    end
    if questIES.Mhpdown > 0 then
        ret[#ret+1] = 'Mhpdown'
    end
    if questIES.HonorPointUp ~= 'None' then
        ret[#ret+1] = 'HonorPointUp'
    end
    if questIES.HonorPointDown ~= 'None' then
        ret[#ret+1] = 'HonorPointDown'
    end
    if questIES.JobLvup ~= 'None' then
        ret[#ret+1] = 'JobLvup'
    end
    if questIES.JobLvdown ~= 'None' then
        ret[#ret+1] = 'JobLvdown'
    end
    if questIES.Check_Script > 0 then
        ret[#ret+1] = 'Check_Script'
    end
    if questIES.JobStep > 0 then
        ret[#ret+1] = 'JobStep'
    end
    if questIES.Lvup > 0 then
        ret[#ret+1] = 'Lvup'
    end
    if questIES.Lvdown > 0 then
        ret[#ret+1] = 'Lvdown'
    end
    if questIES.Check_QuestCount > 0 then
        ret[#ret+1] = 'Check_QuestCount'
    end
    if questIES.Check_PartyPropCount > 0 then
        ret[#ret+1] = 'Check_PartyPropCount'
    end
    
    return ret
end

function QUEST_STATE_NUMBER_RETURN(state)
    
    if state == 'IMPOSSIBLE' then
        return 0;
	elseif state == 'POSSIBLE' then
		return 1;
	elseif state == 'PROGRESS' then
		return 2;
	elseif state == 'SUCCESS' then
		return 3;
	elseif state == 'COMPLETE' then
		return 4;
	end
end

function SCR_PARTYQUEST_RANDOM_CHECK_SUB(partyPC, pQuestIES, term)
    local checkFlag = true
    if pQuestIES.Level_Limit > partyPC.Lv then
        checkFlag = false
        return checkFlag
    end
    
    local termCount = #term
    if termCount > 0 then
        for x = 1, termCount do
            local termSub = SCR_STRING_CUT(term[x],'#')
            local termType = termSub[1]
            table.remove(termSub, 1)
            
            if termType == 'Q' then
                local count = math.floor(#termSub / 2)
                for y = 1, count do
                    local quest = termSub[y*2 - 1]
                    local questState = termSub[y*2]
                    
                    local nowState
                    if IsServerSection(partyPC) == 1 then
                        nowState = SCR_QUEST_CHECK(partyPC, quest)
                    else
                        nowState = SCR_QUEST_CHECK_C(partyPC, quest)
                    end
                    if QUEST_STATE_NUMBER_RETURN(questState) > QUEST_STATE_NUMBER_RETURN(nowState) then
                        checkFlag = false
                        break
                    end
                end
                
                if checkFlag == false then
                    break
                end
            elseif termType == 'Z' then
                local count = #termSub
                for y = 1, count do
                    local zone = termSub[y]
                    local now_percent = GetMapFogSearchRate(partyPC, zone)
                    local currZone = GetZoneName(partyPC)
                    if (now_percent == nil or now_percent <= 0) and currZone ~= zone then
                        checkFlag = false
                        break
                    end
                end
                
                if checkFlag == false then
                    break
                end
            end
        end
    end
    
    return checkFlag
end

function SCR_QUEST_POSSIBLE_DIALOG_CHECK(pc, questname)
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    local questIES = GetClass('QuestProgressCheck', questname);
    
    if SCR_QUEST_POSSIBLE_DIALOG_CHECK_SUB(pc, questname, quest_auto.Possible_SelectDialog1) then
        return 'YES'
    else
        for i = 1, 10 do
            if quest_auto['Possible_AgreeDialog'..i] ~= 'None' then
                local ret = SCR_QUEST_POSSIBLE_DIALOG_CHECK_SUB(pc, questname, quest_auto['Possible_AgreeDialog'..i])
                if ret == 'YES' then
                    return 'YES'
                end
            end
        end
    end
end

function SCR_QUEST_POSSIBLE_DIALOG_CHECK_SUB(pc, questname, argmsg)
    local new_line = argmsg
    local dlg_type
    local seltxt
    local dlgtxt
    local enter_name
    local move_x
    local move_z
    local move_speed
    local jobclassname
    local quest_auto = GetClass('QuestProgressCheck_Auto', questname);
    
    if argmsg == 'None' then
        return 'NO'
    end
    
    if string.find(argmsg, 'Retry%%') ~= nil then
	    argmsg = string.gsub(argmsg,'Retry%%','')
	    local normalmsg, abandonmsg, failmsg =  string.match(argmsg,'(.+)[%%](.+)[%%](.+)')
        argmsg = normalmsg
	    if argmsg == 'None' then
	        return 'NO'
	    end
	end
    if string.find(argmsg, 'CustomOkDlg/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, 'JobGenderOkDlg/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, 'GenderOkDlg/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, 'JobOkDlg/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, 'SelDlg/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, 'BalloonText/') ~= nil then
        return 'YES'
    elseif string.find(argmsg, '/') == nil or string.find(argmsg, ';') == nil then
        return 'YES'
    end
end

-- 퀘스트 조건 체크
function SCR_QUEST_CHECK_MODULE_JOBLVUP(pc, questIES)
    local req_joblvup = 'NO'
    
    if questIES.JobLvup == 'None' then
        req_joblvup = 'YES'
    else
        local jobinfo = SCR_STRING_CUT(questIES.JobLvup)
        local job_name = jobinfo[1]
        local jobCircleTarget = tonumber(jobinfo[2])
        local jobCircle = 0
                
        jobCircle = GetJobGradeByName(pc, job_name);        
                
        if jobinfo[3] == '>=' then
            if jobCircle ~= nil and jobCircle >= tonumber(jobCircleTarget) then
                req_joblvup = 'YES'
            end
        elseif jobinfo[3] == '<=' then
            if jobCircle ~= nil and jobCircle <= tonumber(jobCircleTarget) then
                req_joblvup = 'YES'
            end
        elseif jobinfo[3] == '==' then
            if jobCircle ~= nil and jobCircle == tonumber(jobCircleTarget) then
                req_joblvup = 'YES'
            end
        end
    end
    return req_joblvup
end

function SCR_QUEST_CHECK_MODULE_JOBLVDOWN(pc, questIES)
    local req_joblvdown = 'NO'
    
    if questIES.JobLvdown == 'None' then
        req_joblvdown = 'YES'
    else
        local jobinfo = SCR_STRING_CUT(questIES.JobLvdown)
        local job_name = jobinfo[1]
        local jobCircleTarget = tonumber(jobinfo[2])
        local jobCircle, jobRank
        
        if IsServerSection(pc) == 1 then
            jobCircle, jobRank = GetJobGradeByName(pc, job_name);
        else
            local jobIES = GetClass('Job', job_name)
            jobCircle = session.GetJobGrade(jobIES.ClassID);
        end
        
        if jobinfo[3] == '>=' then
            if jobCircle ~= nil and jobCircle >= tonumber(jobCircleTarget) then
                req_joblvdown = 'YES'
            end
        elseif jobinfo[3] == '<=' then
            if jobCircle ~= nil and jobCircle <= tonumber(jobCircleTarget) then
                req_joblvdown = 'YES'
            end
        elseif jobinfo[3] == '==' then
            if jobCircle ~= nil and jobCircle == tonumber(jobCircleTarget) then
                req_joblvdown = 'YES'
            end
        end
    end
    return req_joblvdown
end

function SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(self, questName)
    local maxRewardIndex
    local questIES = GetClass('QuestProgressCheck', questName)
    local quest_auto = GetClass('QuestProgressCheck_Auto', questName)
    local duplicate = TryGetProp(quest_auto, 'StepRewardDuplicatePayments')
    local lastReward
    local lastRewardList
    local sObj = GetSessionObject(self, 'ssn_klapeda');
    if duplicate == 'NODUPLICATE' then
        lastRewardList = TryGetProp(sObj, questIES.QuestPropertyName..'_SRL')
        if lastRewardList ~= nil and lastRewardList ~= 'None' then
            lastReward = SCR_STRING_CUT(lastRewardList)
        end
    end
    
    for index = 1, 10 do
        if table.find(lastReward, index) == 0 then
            local stepRewardFuncList = TryGetProp(quest_auto, 'StepRewardFunc'..index)
            if stepRewardFuncList ~= nil and stepRewardFuncList ~= 'None' then
                stepRewardFuncList = SCR_STRING_CUT(stepRewardFuncList)
                local stepRewardFunc = _G[stepRewardFuncList[1]]
                if stepRewardFunc ~= nil then
                    local result = stepRewardFunc(self, stepRewardFuncList)
                    if result == 'YES' then
                        maxRewardIndex = index
                    end
                end
            end
        end
    end
    return maxRewardIndex
end

function SCR_QUEST_CHECK_SUB_SUCCESS_PROPERTY_CHANGE(pc, sObj, questIES)
    if pc ~= nil and sObj ~= nil and questIES ~= nil then
        if questIES.QuestEndMode ~= 'SYSTEM' then
            if sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_MIN and sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MAX then
                local tx = TxBegin(pc);
            	TxEnableInIntegrate(tx);
            	TxSetIESProp(tx, sObj, questIES.QuestPropertyName, CON_QUESTPROPERTY_MAX)
            	local ret = TxCommit(tx);
            end
        end
    end
end

-- episode
local s_episdoe_list  = nil
local function GET_EPISODE_QUEST_LIST(episodeNumberStr)
    if s_episdoe_list == nil then
        s_episdoe_list = {}

        local clsList, cnt = GetClassList("Episode_Quest");
        for i = 0, cnt -1 do
            local episodeCls = GetClassByIndexFromList(clsList, i);
            if episodeCls ~= nil then
                local episodeNameProp = TryGetProp(episodeCls, "EpisodeName");
                local questIDProp= TryGetProp(episodeCls, "QuestID");
                if episodeNameProp ~= nil and questIDProp ~= nil then
                    if s_episdoe_list[episodeNameProp] == nil then
                        s_episdoe_list[episodeNameProp] ={}
                    end
                    table.insert(s_episdoe_list[episodeNameProp],questIDProp);
                end
            end 
        end
    end

    if s_episdoe_list[episodeNumberStr] == nil then
        return nil
    end

    return s_episdoe_list[episodeNumberStr]
end

function SCR_EPISODE_CHECK(pc, episodeRewardClassName)
  
    if pc == nil then
        return "Error"
    end
    
    local episodeRewardIES = GetClass('Episode_Reward', episodeRewardClassName)
    if episodeRewardIES == nil then
        return "Error"
    end
    
    local episodeNumberStrProp = TryGetProp(episodeRewardIES, "ClassName")
    if episodeNumberStrProp == nil then
        return "Error"
    end

    local unLockGroup = TryGetProp(episodeRewardIES, "EpisodeUnLockGroup")
    if unLockGroup == nil then
        return "Error"
    end
   
    local accountObj = nil;
	if IsServerObj(pc) == 1 then
		accountObj =  GetAccountObj(pc);
	else
		accountObj = GetMyAccountObj();
    end

    if accountObj == nil then
        return "Error"
    end

    -- 0. New 검사
    if unLockGroup ~= nil and unLockGroup == "New" then
        local unLockGroupPropName = "Episode_Unlock_" .. unLockGroup ;
        local unLockGroupProp = TryGetProp(accountObj, unLockGroupPropName)
        if unLockGroupProp ~= 1 then
            return "New"; 
        end
    end
    
    -- 0. Next 검사
    if unLockGroup ~= nil and unLockGroup == "Next" then
        local unLockGroupPropName = "Episode_Unlock_" .. unLockGroup ;
        local unLockGroupProp = TryGetProp(accountObj, unLockGroupPropName)
        if unLockGroupProp ~= 1 then
            return "Next"; 
        end
    end

    -- 1. Lock 검사
    if unLockGroup ~= nil and unLockGroup ~= "None" then
        local unLockGroupPropName = "Episode_Unlock_" .. unLockGroup ;
        local unLockGroupProp = TryGetProp(accountObj, unLockGroupPropName)
        if unLockGroupProp ~= 1 then
            return "Locked"; 
        end
    end

    -- 2. Account 프로퍼티에 1이 있는 경우 Clear
    local clearPropName = episodeRewardClassName .. "_Clear";
    local clearProp = TryGetProp(accountObj, clearPropName)
    if clearProp == 1 then
        return "Clear"; -- 이미 받아감.
    end
    
    -- 3. 에피소드의 모든 퀘스트 검사.
    local list = GET_EPISODE_QUEST_LIST(episodeNumberStrProp)
    if list == nil then
        return "Error"
    end
    
    for _notUse , questID in pairs(list) do
        local questIES = GetClassByType('QuestProgressCheck', questID);
        if questIES == nil then
            return "Error"
        end
        local questName = TryGetProp(questIES, "ClassName")
        if questName == nil then
            return "Error"
        end
        local state = SCR_QUEST_CHECK(pc, questName )
        if state ~= "COMPLETE" then
            return "Progress";
        end
    end
    
    return "Reward";
end
