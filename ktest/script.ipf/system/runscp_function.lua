function give(pc, item, count)
    if count == nil or count == 0 then
        count = 1
    end
    GIVE_ITEM_TX(pc, item, count, 'TEST')
end

function CBT_ACHIEVE(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'PlayCBT1', 1)
    local ret = TxCommit(tx);
end

function PC_LAYER_RUN(self)
    local zoneInst = GetZoneInstID(self);
    local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneInst, layer);
    local i
    if cnt > 1 then
        for i = 1, cnt do
            SetLayer(list[i], 0)
        end
    else
        SetLayer(self, 0)
    end
end

function SCR_SUITABLE_ITEM(pc, option1, option2)
    local lv = pc.Lv
    
    if option2 ~= nil and option2 ~= 'None' and tonumber(option2)~= nil and tonumber(option2) > 0 then
        lv = tonumber(option2)
    end
    
    local itemlv1 = 0
    local itemlv2 = 0
    local class_count = GetClassCount('Item')
    local return_list = {}
    if GetPropType(GetClassByIndex('Item', 0),'UseLv') == nil then
        return
    end
    
    for y = 0, class_count -1 do
        local classIES = GetClassByIndex('Item', y)
        if classIES.ItemType == 'Equip' and classIES.UseLv <= lv and classIES.UseLv > itemlv1 then
            itemlv2 = itemlv1
            itemlv1 = classIES.UseLv
        end
    end
    
    if itemlv1 > 0 then
        local itemListIES = SCR_GET_XML_IES('Item', 'UseLv', itemlv1)
        if option1 ~= nil and option1 ~= 0 and option1 ~= 'None' and option1 ~= '0' then
            local itemListIES2 = SCR_GET_XML_IES('Item', 'UseLv', itemlv2)
            local itemListIES = SCR_IES_ADD_IES(itemListIES, itemListIES2)
        end

        if itemListIES == nil then
            return
        end
        
        local itemList = {}
        for i = 1, #itemListIES do
            itemList[#itemList + 1] = itemListIES[i].Name..' : '..itemListIES[i].UseLv..' : '..itemListIES[i].ItemStar..' : '..itemListIES[i].ReqToolTip
        end
        local select = SCR_SEL_LIST(pc,itemList, 'SCR_SUITABLE_ITEM', 1, 'DLG_NO_WAIT')
        if select ~= nil and select > 0 and #itemListIES >= select then
            local tx = TxBegin(pc);
            TxGiveEquipItem(tx, itemListIES[select].DefaultEqpSlot, itemListIES[select].ClassName)
            local ret = TxCommit(tx);
        end
    end
end

function SCR_SMARTGEN_MON_CREATE_TEST(pc)
    local result = SCR_SMARTGEN_MON_CREATE(pc, 'YES', 'YES')
    if result ~= nil then
        Chat(pc, ScpArgMsg("Auto_MopJen_SeongKong_:_")..result)
    else
        Chat(pc, ScpArgMsg("Auto_KeunCheoe_MonJen_eopeum"))
    end
end
function SCR_SMARTGEN_CHEAT_SELECTGEN(pc, zoneName)
    if zoneName == nil or zoneName == 'None' then
        zoneName = GetZoneName(pc)
    end
    
    local genlist = {}
    local selectList = {}
    
    local cnt = GetClassCount("SmartGen_"..zoneName);
    if cnt ~= nil and cnt > 0 then
        for i = 0, cnt -1 do
            local genIES = GetClassByIndex("SmartGen_"..zoneName, i);
            if genIES ~= nil then
                if string.find(genIES.ClassName, 'SpecialMonGenPos') ~= nil then
                    genlist[#genlist + 1] = {}
                    genlist[#genlist][1] = 'SPECIAL'
                    genlist[#genlist][2] = genIES
                    
                    selectList[#selectList + 1] = genIES.ClassName
                elseif GetPropType(genIES, 'SubMon_ClassName1') ~= nil then
                    genlist[#genlist + 1] = {}
                    genlist[#genlist][1] = 'SET'
                    genlist[#genlist][2] = genIES
                    
                    selectList[#selectList + 1] = genIES.ClassName
                end
            end
        end
    else
        Chat(pc, zoneName..ScpArgMsg("Auto__HaeDangJoneNeun_SeuPeSyeolJen,_SesJeni_SeolJeongDoeeoissJi_anSeupNiDa."))
        return
    end
    
    if #genlist > 0 then
        local select = SCR_SEL_LIST(pc,selectList, 'SMARTGEN_CHEAT_SELECTGEN', nil, 'DLG_NO_WAIT')
        if select ~= nil and select ~= 0 and select <= #selectList then
            local x,y,z = GetPos(pc)
            if genlist[select][1] == 'SPECIAL' then
                SCR_SMARTGEN_MON_SUMMON(pc, 'YES', 1, genlist[select][2], 'Basic3,1', x, y, z)
            elseif genlist[select][1] == 'SET' then
                local result1 = SCR_GET_XML_IES('GenType_'..zoneName, 'ClassType', genlist[select][2].ClassName)
                
                if #result1 > 0 then
                    local monIES = {}
                    monIES= {Mon_ClassName1 = result1[1].ClassType, Mon_Name1 = result1[1].Name, Mon_Tactics1 = result1[1].Tactics, Mon_BTree1 = result1[1].BTree, Mon_Lv1 = result1[1].Lv, Mon_Faction1 = result1[1].Faction, Mon_Modify1 = 'None'}
                    
                    SCR_SMARTGEN_MON_SUMMON(pc, 'YES', 1, monIES, 'Basic3,1', x, y, z)
                end
            end
        end
    else
        Chat(pc, zoneName..ScpArgMsg("Auto__HaeDangJoneNeun_SeuPeSyeolJen,_SesJeni_SeolJeongDoeeoissJi_anSeupNiDa."))
        return
    end
end
function SCR_SMARTGEN_GENFLAG_RESTART_RUN(pc)
    local smartgen_sObj = GetSessionObject(pc, 'ssn_smartgen')
    if smartgen_sObj ~= nil then
        SCR_SMARTGEN_GENFLAG_RESTART(smartgen_sObj)
        SCR_SMARTGEN_STOUP_USE_RESTART(smartgen_sObj)
        SCR_SMARTGEN_SCROLLLOCKGENFLAG_RESTART(smartgen_sObj)
    end
end

function SCR_NPC_HIDE_SWITCH(pc, npcname)
    if pc ~= nil and npcname ~= nil then
        if isHideNPC(pc, npcname) == 'YES' then
            UnHideNPC(pc, npcname)
        else
            HideNPC(pc, npcname, 0, 0, 0)
        end
    end
end


function SCR_MAP_EVENT_REWARD_UNEXPECTED(pc)
    local zone_name = GetZoneName(pc)
    local mapEventReward_sObj = GetSessionObject(pc, 'SSN_MAPEVENTREWARD')
    if mapEventReward_sObj ~= nil then
        local mapEventReward_IES = GetClass('Map_Event_Reward', zone_name)
        if mapEventReward_IES ~= nil then
            if GetPropType(mapEventReward_sObj, mapEventReward_IES.UnexpectedPropCount) ~= nil then
                mapEventReward_sObj[mapEventReward_IES.UnexpectedPropCount] = mapEventReward_sObj[mapEventReward_IES.UnexpectedPropCount] + 1
            end
        end
    end
end

function SCR_MAP_EVENT_REWARD_ONESHOT(pc)
    local zone_name = GetZoneName(pc)
    local mapEventReward_sObj = GetSessionObject(pc, 'SSN_MAPEVENTREWARD')
    if mapEventReward_sObj ~= nil then
        local mapEventReward_IES = GetClass('Map_Event_Reward', zone_name)
        if mapEventReward_IES ~= nil then
            if GetPropType(mapEventReward_sObj, mapEventReward_IES.OneShotPropCount) ~= nil then
                mapEventReward_sObj[mapEventReward_IES.OneShotPropCount] = mapEventReward_sObj[mapEventReward_IES.OneShotPropCount] + 1
            end
        end
    end
end

function RUN_CHEAT_START(pc, cheatObj)

    SET_CHEAT_CHAR(pc, cheatObj);
    RUN_CHEAT_QUEST(pc, cheatObj);

end


function REQ_TX_CHANGE_JOB(pc, jobID)

    --클라에서 해당 코드를 콜하는 부분을 지웠기 때문에 이제 살려도 되지 않을까?

    if pc == nil then
        return;
    end
    
    local jobLv, totlaJobLv = GetJobLevelByName(pc, pc.JobName);    
    if jobLv < 10 then
        return;
    end


    local clslist, listcnt  = GetClassList("Job");
    local cls = GetClassByTypeFromList(clslist, jobID);
    if cls == nil then
        return;
    end
    local jobName = cls.ClassName;  
    

    
    local haveJobNameList = {};
    local haveJobGradeList = {};    
    for i = 0, listcnt do

        local class = GetClassByIndexFromList(clslist, i);
        if class == nil then
            break;
        end
                
        local jobGrade, totalChangeJob = GetJobGradeByName(pc, class.ClassName);        
        if jobGrade > 0 then
            haveJobNameList[#haveJobNameList + 1] = class.ClassName;
            haveJobGradeList[#haveJobGradeList + 1] = jobGrade;
        end

    end
    
    local ret = CHECK_CHANGE_JOB_CONDITION(cls, haveJobNameList, haveJobGradeList);
    if GetJobObject(pc).ClassName == jobName then
        ret = true;
    end
    
    if ret == false then
        return;
    end
    
    local tx = TxBegin(pc); 
    TxChangeJob(tx, jobName);
    
    local etc = GetETCObject(pc);
    TxSetIESProp(tx, etc, "JobChanging", 0);
    local ret = TxCommit(tx);
    
    
    if ret == 'SUCCESS' then
        local jobGrade, totalChangeJob = GetJobGradeByName(pc, jobName);
        Chat(pc, jobName .. ScpArgMsg("Auto_Jigeop_") .. jobGrade .. ScpArgMsg("Auto_LepeuLo_") .. ret);
    else
        Chat(pc, jobName .. " " .. ret);
    end
end

function SET_CHEAT_CHAR(pc, cheatObj, autoselect)

    if tonumber(cheatObj.Lv) == nil then
        return
    else
        lvup(pc, cheatObj.Lv)        
    end
    
    if cheatObj.Job ~= 'None' then
        local job_list = SCR_STRING_CUT_SHAP(cheatObj.Job)
        local job_list_sel = {}
        
        for i = 1, #job_list do
            local job_list2 = SCR_STRING_CUT(job_list[i])
            local job_list2_kor = {}
            local job_list2_temp = {}
            
            for j = 1, #job_list2 do
                if string.find(job_list2[j], string.sub(pc.JobName, 1, 5)) ~= nil then
                    job_list2_temp[#job_list2_temp + 1] = job_list2[j]
                    job_list2_kor[#job_list2_kor + 1] = GetClassString('Job',job_list2[j], 'Name')
                end
            end
            
            if #job_list2_temp >= 1 then
                local select3;
                if autoselect == nil then
                    select3 = SCR_SEL_LIST(pc,job_list2_kor, 'Cheat_Start_dlg3', nil, 'DLG_NO_WAIT')
                else
                    select3 = autoselect;
                end
         
                if select3 > 0 and select3 <= #job_list2_temp then
                    jlvup(pc, 20)
                    
                    local tx = TxBegin(pc);
                    TxChangeJob(tx, job_list2_temp[select3])
                    local etc = GetETCObject(pc);
                    TxSetIESProp(tx, etc, "JobChanging", 0);
                    
                    local ret = TxCommit(tx);
                end
            end
        end
    end
    
    if cheatObj.JobLv ~= 0 then
        jlvup(pc, cheatObj.JobLv)
    end
    
    
    
    
    local tx = TxBegin(pc);
    
    local job_item_list = cheatObj['Item_'..pc.JobName]
    if job_item_list ~= 'None' then
        job_item_list = SCR_STRING_CUT(job_item_list)
        if #job_item_list > 0 then
            for y = 1, #job_item_list do
                local item = GetClass('Item', job_item_list[y])
                if item ~= nil then
                    TxGiveEquipItem(tx, item.DefaultEqpSlot, job_item_list[y])
                end
            end
        end
    end
    
    
    for y = 1, 20 do
        
        local item_name = cheatObj['Item'..y]
        local item_job = cheatObj['ItemJob'..y]
        if item_name ~= 'None' then
            if item_job ~= 'None' then
                local item_job_list = SCR_STRING_CUT(item_job)
                local item_job_flag = 0
                
                for i = 1, #item_job_list do
                    if item_job_list[i] == pc.JobName then
                        item_job_flag = 1
                        break
                    end
                end
                
                if item_job_flag > 0 then
                    local item_info = SCR_STRING_CUT(item_name)
                    if #item_info > 1 then
                        TxGiveItem(tx, item_info[1], item_info[2], 'Cheat');
                    else
                        TxGiveItem(tx, item_info[1], 1, 'Cheat');
                    end
                end
            else
                local item_info = SCR_STRING_CUT(item_name)
                if #item_info > 1 then
                    TxGiveItem(tx, item_info[1], item_info[2], 'Cheat');
                else
                    TxGiveItem(tx, item_info[1], 1, 'Cheat');
                end
            end
        end
    end
    local ret = TxCommit(tx);

end
    
function RUN_CHEAT_QUEST(pc, cheatObj)
    
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    local main_ssn_save_flag = 0
    for y = 1, 5 do
        local quest_name = cheatObj['QuestEnd'..y]
        if quest_name ~= 'None' then
            main_ssn[quest_name] = CON_QUESTPROPERTY_END
            
            main_ssn_save_flag = 1
        end
    end
    
    if main_ssn_save_flag > 0 then
        SaveSessionObject(pc, main_ssn)
    end
    
    for y = 1, 5 do
        local quest_start_name = cheatObj['QuestStart'..y]
        if quest_start_name ~= 'None' then
            SCR_QUEST_POSSIBLE(pc, quest_start_name)
        end
    end
    
    
    if cheatObj.HideNPCSwitch ~= 'None' then
        local hideSwitch_list = SCR_STRING_CUT(cheatObj.HideNPCSwitch)
        if #hideSwitch_list > 0 then
            for i = 1, #hideSwitch_list do
                SCR_NPC_HIDE_SWITCH(pc, hideSwitch_list[i])
            end
        end
    end
    
    if cheatObj.MoveZoneName ~= 'None' then
        MoveZone(pc, cheatObj.MoveZoneName)
    end
end



function cheat_start(pc)
    
    local tb = {}
    local class_count = GetClassCount('Cheat_Start')
    
    for y = 0, class_count -1 do
        tb[#tb + 1] = GetClassByIndex('Cheat_Start', y)
    end
    
    tb = SCR_DUPLICATION_SOLVE_IES(tb, 'Group')
    
    local sel_list = {}
    
    for y = 1, #tb do
        sel_list[#sel_list + 1] = tb[y].Group
    end
    
    
    local select1 = SCR_SEL_LIST(pc,sel_list, 'Cheat_Start_dlg1', nil  , 'DLG_NO_WAIT')
    
    if select1 == nil or select1 == 0 then
        return
    end
    
    local tb1 = SCR_GET_XML_IES('Cheat_Start', 'Group', sel_list[select1])
    local sel_list1 = {}
    
    if tb1 == nil or #tb1 == 0 then
        return
    end
    
    for y = 1, #tb1 do
        sel_list1[#sel_list1 + 1] = tb1[y].Name
    end
    
    local select2 = SCR_SEL_LIST(pc,sel_list1, 'Cheat_Start_dlg2', nil  , 'DLG_NO_WAIT')
    
    if select2 == nil or select2 == 0 then
        return;
    end
    
    local cheatObj = tb1[select2];
    RUN_CHEAT_START(pc, cheatObj);
    
end

function pcpropup(pc, count)

        local tx = TxBegin(pc);
        TxAddIESProp(tx, pc, 'PropertyByBonus', count)

        local ret = TxCommit(tx);

end

--function skilllockopen(pc, skillName)
--    
--    local skill_list = {}
--    local ability_list = {}
--    local sel_list = {}
--    local sel_classname_list = {}
--    local i
--    local main_sObj = GetSessionObject(pc, 'ssn_klapeda')
--    
--    skill_list = SCR_GET_XML_IES('Skill', 'Name', skillName, 1)
--    ability_list = SCR_GET_XML_IES('Ability', 'Name', skillName, 1)
--   
--    if skill_list ~= nil and #skill_list > 0 then
--        for i = 1, #skill_list do
--            sel_list[#sel_list + 1] = skill_list[i].Name
--            sel_classname_list[#sel_classname_list + 1] = skill_list[i].ClassName
--        end
--    end
--    
--    if ability_list ~= nil and #ability_list > 0 then
--        for i = 1, #ability_list do
--            sel_list[#sel_list + 1] = ability_list[i].Name
--            sel_classname_list[#sel_classname_list + 1] = ability_list[i].ClassName
--        end
--    end
--    
--    if #sel_list == 1 then
--        skilllockopen_lv(pc, main_sObj, sel_classname_list[1])
--    elseif #sel_list > 1 then
--        
--        local select = SCR_SEL_LIST(pc,sel_list, Skill_Lock_Open, nil, 'DLG_NO_WAIT')
--        skilllockopen_lv(pc, main_sObj, sel_classname_list[select])
--    else
--        Chat(pc, ScpArgMsg("Auto_SeuKil_eopeum"))
--    end
--end
--
--function skilllockopen_lv(pc, main_sObj, sel_classname)
--    
--    local skill_lv_list = {}
--    for i = 1, 10 do
--        if GetPropType(main_sObj, sel_classname..i) ~= nil then
--            skill_lv_list[#skill_lv_list + 1] = i
--        end
--    end
--    
--    if #skill_lv_list == 1 then
--        main_sObj[sel_classname..skill_lv_list[1]] = 300
--        SaveSessionObject(pc, main_sObj)
--        Chat(pc, sel_classname..skill_lv_list[1]..ScpArgMsg("Auto_wanLyo"))
--    elseif #skill_lv_list > 1 then
--        local select = SCR_SEL_LIST(pc,skill_lv_list, Skill_Lock_Open_lv, nil, 'DLG_NO_WAIT')
--        main_sObj[sel_classname..skill_lv_list[select]] = 300
--        SaveSessionObject(pc, main_sObj)
--        Chat(pc, sel_classname..skill_lv_list[select]..ScpArgMsg("Auto_wanLyo"))
--    else
--        Chat(pc, ScpArgMsg("Auto_SeuKil_Lag_eopeum"))
--    end
--end

function jlvup(pc, lv)
    local jexp = 0
    local nowjexp = 0
    
    lv = tonumber(lv)
    if lv == 1 then
        return
    end
    
    local grade, changedJobCount = GetJobGradeByName(pc, pc.JobName);
    
    local jtype = changedJobCount
    
    if GetJobLv(pc) > 1 then
        nowjexp = GetClassNumber('Xp_Job', 'Job_'..jtype..'_'..GetJobLv(pc) -1 , 'TotalXp')
    end
    
    if string.find(pc.JobName,'_1') ~= nil then
        jexp = GetClassNumber('Xp_Job', 'Job_'..jtype..'_'..lv -1 , 'TotalXp') 
    else
        jexp = GetClassNumber('Xp_Job', 'Job_'..jtype..'_'..lv -1 , 'TotalXp') 
    end
    
    jexp = jexp - nowjexp
    
    if jexp > 0 then
        GiveJobExp(pc, jexp)
    end
end


function ABIL(pc, search_word,lv, gm)

    local Abil_index = GetClassCount('Ability')
    local i
    local x = 1
    local Abil_list = {}
    local sel_list = {}
    local level_interval = 5
	local lv = tonumber(lv)


    for i = 0, Abil_index -1 do
        
        if search_word ~= nil then
        
            local tempclassname = GetClassStringByIndex('Ability', i, 'Name')
            tempclassname = dictionary.ReplaceDicIDInCompStr(tempclassname);
    
            if string.find(GetClassStringByIndex('Ability', i, 'ClassName'), search_word) ~= nil or string.find(tempclassname, search_word) ~= nil then
            --�?찾기 ?�작.
                Abil_list[x] = {}
                Abil_list[x][1] = GetClassStringByIndex('Ability', i, 'ClassName');
                Abil_list[x][2] = GetClassStringByIndex('Ability', i, 'Name');
                sel_list[x] = Abil_list[x][2]--..'/'..quest_list[x][3]..'/'..GetClassNumberByIndex('QuestProgressCheck', i, 'Level')
                x = x + 1;
            end
        end
    end

    local select

    if #sel_list == 0 then
        return --�??�을 ??리턴처리.
    elseif #sel_list == 1 then
        select = 1
    else
    
        local y
        for y = 0, math.floor(#sel_list/10) do
            if y ~= math.floor(#sel_list/10) then
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    select = ShowSelDlg(gm, 0, 'EMPTY_DIALOG', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'NEXT PAGE')
                else
                    select = ShowSelDlg(pc, 0, 'EMPTY_DIALOG', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'NEXT PAGE')
                end
            else
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    select = ShowSelDlg(gm, 0, 'EMPTY_DIALOG', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'CANCEL')
                else
                    select = ShowSelDlg(pc, 0, 'EMPTY_DIALOG', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'CANCEL')
                end
            end
            
            if select < 11 and select ~= nil then
                select = select + 10*y
                break
            elseif y == math.floor(#sel_list/10) and select == 11 then
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                else
                    Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                end
                return
            end
        end
    end
    
    if select == nil or select >= #sel_list + 1 then
        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
            Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        else
            Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        end
        return
    end

	if lv == nil then
		lv=1;
	end

	ABIL_UP(pc, Abil_list[select][1], lv);

end
 
 

function lvup(pc, lv)
    lv = tonumber(lv)
    
    if lv == nil or pc.Lv >= lv then
        return
    end
    
    if lv == 1 then
        return
    end
    

    
    local totalxp = GetClassNumber('Xp', tonumber(lv) -1 , 'TotalXp')
    
    if totalxp ~= 0 then
        totalxp = totalxp + 1
        if totalxp > GetExp(pc) then
--            local tx = TxBegin(pc);
            
            totalxp = totalxp - GetExp(pc)
            local expLimit = 1000000000;
            local loop = math.floor(((totalxp - 1) / expLimit) + 1)
            
            for i = 1, loop do
                local tx = TxBegin(pc);
                
                local giveExp = totalxp;
                if totalxp > expLimit then
                    giveExp = expLimit;
                    totalxp = totalxp - expLimit;
                end
                
--                TxGiveExp(tx, totalxp - GetExp(pc));
                TxGiveExp(tx, giveExp);
                
	            local ret = TxCommit(tx);
	            
                if i < loop then
                	sleep(100);
                end
            end
            
--            local ret = TxCommit(tx);
        end
    else
        Chat(pc,ScpArgMsg("Auto_SeolJeongLeBeli_SusJaKa_aNipNiDa."))
    end
end
function hitmecall(pc)
    local iesObj = CreateGCIES('Monster', 'HitMe');
    iesObj.Faction = 'HitMe';
    local posX, posY, posZ = GetPos(pc)
    local mon = CreateMonster(pc, iesObj, posX, posY, posZ, 0, 1);
    INIT_ITEM_OWNER(mon, pc);
    SetTacticsArgFloat(mon, 100, 0);
end

function map(pc, search_word)
    local zonename = string.upper(search_word)
    
    local zone_index = GetClassCount('Map')
    local i
    local x = 1
    local zone_list = {}

    if zone_index ~= 0 and zone_index ~= nil then
        for i = 0, zone_index -1 do
            local classid_map = GetClassNumberByIndex('Map', i, 'ClassID')
            local classname_map = string.upper(GetClassStringByIndex('Map', i, 'ClassName'))
            local zonename_map = string.upper(GetClassStringByIndex('Map', i, 'Name'))
            local category_map = string.upper(GetClassStringByIndex('Map', i, 'CategoryName'))
            local flag = false
            
            if string.find(classid_map, zonename) ~= nil or string.find(classname_map, zonename) ~= nil or string.find(zonename_map, zonename) ~= nil or string.find(category_map, zonename) ~= nil then
                zone_list[#zone_list+1] = {}
                if string.find(classid_map, zonename) ~= nil then
                    if zone_list[#zone_list][1] ~= nil then
                        zone_list[#zone_list][1] = zone_list[#zone_list][1]..'ID/'..classid_map..'/'
                        flag = true
                    else
                        zone_list[#zone_list][1] = 'ID/'..classid_map..'/'
                        flag = true
                    end
                end
                if string.find(classname_map, zonename) ~= nil then
                    if zone_list[#zone_list][1] ~= nil then
                        zone_list[#zone_list][1] = zone_list[#zone_list][1]..'Class/'..classname_map..'/'
                        flag = true
                    else
                        zone_list[#zone_list][1] = 'Class/'..classname_map..'/'
                        flag = true
                    end
                end
                if string.find(zonename_map, zonename) ~= nil then
                    if zone_list[#zone_list][1] ~= nil then
                        zone_list[#zone_list][1] = zone_list[#zone_list][1]..ScpArgMsg('Auto_iLeum/')..zonename_map..'/'
                        flag = true
                    else
                        zone_list[#zone_list][1] = ScpArgMsg('Auto_iLeum/')..zonename_map..'/'
                        flag = true
                    end
                end
                if string.find(category_map, zonename) ~= nil then
                    if zone_list[#zone_list][1] ~= nil then
                        zone_list[#zone_list][1] = zone_list[#zone_list][1]..'Category/'..category_map..'/'
                        flag = true
                    else
                        zone_list[#zone_list][1] = 'Category/'..category_map..'/'
                        flag = true
                    end
                end
            end
            
            
            if flag == true then
                zone_list[#zone_list][2] = GetClassStringByIndex('Map', i, 'ClassName')
            end
        end

        if #zone_list == 0 then
            Chat(pc, ScpArgMsg("Auto_HyeonJae_Jon_Junge_KeomSaeg_KyeolKwaKa_eopSeupNiDa."))
            return
        end
        local select = SCR_SEL_LIST(pc, zone_list, 'npc_move_zone_select1', nil, 'DLG_NO_WAIT')

        if select == 0 or select == nil then
            Chat(pc, ScpArgMsg("Auto_SeonTaeg_Kapi_eopSeupNiDa."))
            return
        else
            MoveZone(pc, zone_list[select][2])
        end
    end
end

function npcmove(pc, search_word, zonename, pos_option, search_allmatch)
    local npc_list = {}
    search_word = string.upper(search_word)
    if zonename ~= 'None' and zonename ~= nil and zonename ~= 0 then
        if search_word == nil or search_word == 'None' then
            MoveZone(pc, zonename)
            return
        end
        
        local zone_index = GetClassCount('Map')
        local i
        local x = 1
        local zone_list = {}

        if zone_index ~= 0 and zone_index ~= nil then
            for i = 0, zone_index -1 do
                local flag = false
                if search_allmatch == nil or search_allmatch == false then
                    if string.find(GetClassNumberByIndex('Map', i, 'ClassID'), zonename) ~= nil or string.find(GetClassStringByIndex('Map', i, 'ClassName'), zonename) ~= nil or string.find(GetClassStringByIndex('Map', i, 'Name'), zonename) ~= nil then
                        zone_list[#zone_list+1] = {}
                        if string.find(GetClassNumberByIndex('Map', i, 'ClassID'), zonename) ~= nil then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..'ID/'..GetClassNumberByIndex('Map', i, 'ClassID')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = 'ID/'..GetClassNumberByIndex('Map', i, 'ClassID')..'/'
                                flag = true
                            end
                        end
                        if string.find(GetClassStringByIndex('Map', i, 'ClassName'), zonename) ~= nil then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..'Class/'..GetClassStringByIndex('Map', i, 'ClassName')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = 'Class/'..GetClassStringByIndex('Map', i, 'ClassName')..'/'
                                flag = true
                            end
                        end
                        if string.find(GetClassStringByIndex('Map', i, 'Name'), zonename) ~= nil then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..ScpArgMsg('Auto_iLeum/')..GetClassStringByIndex('Map', i, 'Name')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = ScpArgMsg('Auto_iLeum/')..GetClassStringByIndex('Map', i, 'Name')..'/'
                                flag = true
                            end
                        end
                    end
                else
                    if GetClassNumberByIndex('Map', i, 'ClassID') == zonename or GetClassStringByIndex('Map', i, 'ClassName') == zonename or GetClassStringByIndex('Map', i, 'Name') == zonename then
                        zone_list[#zone_list+1] = {}
                        if GetClassNumberByIndex('Map', i, 'ClassID') ==  zonename then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..'ID/'..GetClassNumberByIndex('Map', i, 'ClassID')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = 'ID/'..GetClassNumberByIndex('Map', i, 'ClassID')..'/'
                                flag = true
                            end
                        end
                        if GetClassStringByIndex('Map', i, 'ClassName') ==  zonename then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..'Class/'..GetClassStringByIndex('Map', i, 'ClassName')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = 'Class/'..GetClassStringByIndex('Map', i, 'ClassName')..'/'
                                flag = true
                            end
                        end
                        if GetClassStringByIndex('Map', i, 'Name') ==  zonename then
                            if zone_list[#zone_list][1] ~= nil then
                                zone_list[#zone_list][1] = zone_list[#zone_list][1]..ScpArgMsg('Auto_iLeum/')..GetClassStringByIndex('Map', i, 'Name')..'/'
                                flag = true
                            else
                                zone_list[#zone_list][1] = ScpArgMsg('Auto_iLeum/')..GetClassStringByIndex('Map', i, 'Name')..'/'
                                flag = true
                            end
                        end
                    end
                end
                
                if flag == true then
                    zone_list[#zone_list][2] = GetClassStringByIndex('Map', i, 'ClassName')
                end
            end

            if #zone_list == 0 then
                Chat(pc, ScpArgMsg("Auto_HyeonJae_Jon_Junge_KeomSaeg_KyeolKwaKa_eopSeupNiDa."))
                return
            end
            local select = SCR_SEL_LIST(pc, zone_list, 'npc_move_zone_select1', nil, 'DLG_NO_WAIT')

            if select == 0 or select == nil then
                Chat(pc, ScpArgMsg("Auto_SeonTaeg_Kapi_eopSeupNiDa."))
                return
            else
                zonename = zone_list[select][2]
            end
        end
        
        if search_word == 'None' or search_word == nil or search_word == 0 then
            Chat(pc, ScpArgMsg("Auto_KeomSaegHal_DaneoKa_eopeoSeo_Jon_Nae_MoDeun_GenType_PyoSi"))
            search_word = nil
        end
        
        npc_list = npcmove_genlist(zonename, search_word, npc_list)
    else
        local zone_index = GetClassCount('Map')
        local i
        local x = 1
        local zone_list = {}
        if zone_index ~= 0 and zone_index ~= nil then
            for i = 0, zone_index -1 do
                local mapIES = GetClassByIndex('Map', i)
                local genCount = GetClassCount('GenType_'..mapIES.ClassName)
                if genCount > 0 then
                    npc_list = npcmove_genlist(mapIES.ClassName, search_word, npc_list)
                end
            end
            
            if search_word == 'None' or search_word == nil or search_word == 0 then
                Chat(pc, ScpArgMsg("Auto_KeomSaegHal_DaneoKa_eopeoSeo_Jon_Nae_MoDeun_GenType_PyoSi"))
                search_word = nil
            end
        end
    end
    
    if #npc_list == 0 then
        Chat(pc, ScpArgMsg("Auto_ClassType,_Name,_Tactics,_Dialog,_Enter,_Leave_Junge_KeomSaeg_KyeolKwaKa_eopSeupNiDa."))
        return
    end
    
    local select = SCR_SEL_LIST(pc, npc_list, 'npc_move_gen_select1', nil, 'DLG_NO_WAIT')


    if select == 0 or select == nil then
        Chat(pc, ScpArgMsg("Auto_SeonTaeg_Kapi_eopSeupNiDa."))
        return
    end
    
    zonename = npc_list[select][4]
    local move_range = npc_list[select][3]
    local gentypeID = npc_list[select][2]
    
    local anchor_list = npcmove_anchorlist(zonename, gentypeID)

    local select1 = SCR_SEL_LIST(pc, anchor_list, 'npc_move_anchor_select1', nil, 'DLG_NO_WAIT')
    
    if #anchor_list == 0 then
        Chat(pc, ScpArgMsg("NotFindNPCAnchor"))
        return
    end

    if select1 == 0 or select1 == nil then
        Chat(pc, ScpArgMsg("Auto_SeonTaeg_Kapi_eopSeupNiDa."))
        return
    end

    if zonename == GetZoneName(pc) then
        local zoneInstID = GetZoneInstID(pc);
        local i
        local x, z
        
        if pos_option ~= nil and pos_option == '1' then
            x = anchor_list[select1][3]
            z = anchor_list[select1][5]
        else
            x = anchor_list[select1][3] + move_range + 10
            z = anchor_list[select1][5] + move_range + 10
            if IsValidPos(zoneInstID, x, 0, z) == 'NO' then
                x = anchor_list[select1][3] + move_range + 10
                z = anchor_list[select1][5] - move_range - 10
                if IsValidPos(zoneInstID, x, 0, z) == 'NO' then
                    x = anchor_list[select1][3] - move_range - 10
                    z = anchor_list[select1][5] + move_range + 10
                    if IsValidPos(zoneInstID, x, 0, z) == 'NO' then
                        x = anchor_list[select1][3] - move_range - 10
                        z = anchor_list[select1][5] - move_range - 10
                        if IsValidPos(zoneInstID, x, 0, z) == 'NO' then
                            MoveZone(pc, zonename, anchor_list[select1][3], anchor_list[select1][4], anchor_list[select1][5])
                            return
                        end
                    end
                end
            end
        end

        MoveZone(pc, zonename, x, anchor_list[select1][4]+ 100, z)
    else
        MoveZone(pc, zonename, anchor_list[select1][3], anchor_list[select1][4] + 100, anchor_list[select1][5])
    end

    ExecClientScp(gm, scp);

end

function npcmove_anchorlist(zonename, gentypeID)
    
    local anchor_list = {}
    local anchor_index = GetClassCount('Anchor_'..zonename)
    if anchor_index ~= 0 or anchor_index ~= nil then
        for i = 0, anchor_index -1 do
            local cls = GetClassByIndex('Anchor_'..zonename, i)
            if GetClassNumberByIndex('Anchor_'..zonename, i, 'GenType') == gentypeID then
                anchor_list[#anchor_list+1] = {}

                anchor_list[#anchor_list][1] = 'X'..GetClassNumberByIndex('Anchor_'..zonename, i, 'PosX')..'/Y'..GetClassNumberByIndex('Anchor_'..zonename, i, 'PosY')..'/Z'..GetClassNumberByIndex('Anchor_'..zonename, i, 'PosZ')
                local npcid = ""
                local npcname = ""
                if GetPropType(cls, 'NPCID') ~= nil then
                    npcid = GetClassNumberByIndex('Anchor_'..zonename, i, 'NPCID')
                end
                if GetPropType(cls, 'Name') ~= nil then
                    npcname = GetClassStringByIndex('Anchor_'..zonename, i, 'Name')
                end
                anchor_list[#anchor_list][2] = 'ID/'..npcid..'/NAME/'..npcname
                anchor_list[#anchor_list][3] = GetClassNumberByIndex('Anchor_'..zonename, i, 'PosX')
                anchor_list[#anchor_list][4] = GetClassNumberByIndex('Anchor_'..zonename, i, 'PosY')
                anchor_list[#anchor_list][5] = GetClassNumberByIndex('Anchor_'..zonename, i, 'PosZ')
            end
        end
    end
    
    return anchor_list
end

function npcmove_genlist(zonename, search_word, npc_list)
    local gen_index = GetClassCount('GenType_'..zonename)
    if gen_index ~= 0 and gen_index ~= nil then
        for i = 0, gen_index -1 do
            local classtype = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'ClassType'))
            local name = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'Name'))
            local gentype = GetClassNumberByIndex('GenType_'..zonename, i, 'GenType')
            local range = GetClassNumberByIndex('GenType_'..zonename, i, 'Range')
            local tactics = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'Tactics'))
            local dialog = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'Dialog'))
            local enter = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'Enter'))
            local leave = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'Leave'))
            local simpleai =  ''
            if GetPropType(GetClassByIndex('GenType_'..zonename, i), 'SimpleAI') ~= nil then
                simpleai = string.upper(GetClassStringByIndex('GenType_'..zonename, i, 'SimpleAI'))
            end
            
            if search_word == nil then
                npc_list[#npc_list+1] = {}
                if npc_list[#npc_list][1] ~= nil then
                    npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Class/'..classtype..'/'
                else
                    npc_list[#npc_list][1] = 'Class/'..classtype..'/'
                end
                if npc_list[#npc_list][1] ~= nil then
                    npc_list[#npc_list][1] = npc_list[#npc_list][1]..ScpArgMsg('Auto_iLeum/')..name..'/'
                else
                    npc_list[#npc_list][1] = ScpArgMsg('Auto_iLeum/')..name..'/'
                end
                npc_list[#npc_list][1] = zonename..' : '..npc_list[#npc_list][1]
                npc_list[#npc_list][2] = gentype
                npc_list[#npc_list][3] = range
                npc_list[#npc_list][4] = zonename
            else
                if search_allmatch == nil or search_allmatch == false then
                    if string.find(classtype, search_word) ~= nil or string.find(name, search_word) ~= nil or string.find(tactics, search_word) ~= nil or string.find(dialog, search_word) ~= nil or string.find(enter, search_word) ~= nil or string.find(leave, search_word) ~= nil or string.find(simpleai, search_word) ~= nil then
                        npc_list[#npc_list+1] = {}
                        if string.find(classtype, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Class/'..classtype..'/'
                            else
                                npc_list[#npc_list][1] = 'Class/'..classtype..'/'
                            end
                        end
                        if string.find(name, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..ScpArgMsg('Auto_iLeum/')..name..'/'
                            else
                                npc_list[#npc_list][1] = ScpArgMsg('Auto_iLeum/')..name..'/'
                            end
                        end
                        if string.find(tactics, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'AI/'..tactics..'/'
                            else
                                npc_list[#npc_list][1] = 'AI/'..tactics..'/'
                            end
                        end
                        if string.find(dialog, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Dlg/'..dialog..'/'
                            else
                                npc_list[#npc_list][1] = 'Dlg/'..dialog..'/'
                            end
                        end
                        if string.find(enter, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Ent/'..enter..'/'
                            else
                                npc_list[#npc_list][1] = 'Ent/'..enter..'/'
                            end
                        end
                        if string.find(leave, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Lev/'..leave..'/'
                            else
                                npc_list[#npc_list][1] = 'Lev/'..leave..'/'
                            end
                        end
                        if string.find(simpleai, search_word) ~= nil then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Simple/'..simpleai..'/'
                            else
                                npc_list[#npc_list][1] = 'Simple/'..simpleai..'/'
                            end
                        end
                        
                        npc_list[#npc_list][1] = zonename..' : '..npc_list[#npc_list][1]
                        npc_list[#npc_list][2] = gentype
                        npc_list[#npc_list][3] = range
                        npc_list[#npc_list][4] = zonename
                    end
                else
                    if classtype == search_word or name == search_word or tactics == search_word or dialog == search_word or enter == search_word or leave == search_word or simpleai == search_word then
                        npc_list[#npc_list+1] = {}
                        if classtype == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Class/'..classtype..'/'
                            else
                                npc_list[#npc_list][1] = 'Class/'..classtype..'/'
                            end
                        end
                        if name == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..ScpArgMsg('Auto_iLeum/')..name..'/'
                            else
                                npc_list[#npc_list][1] = ScpArgMsg('Auto_iLeum/')..name..'/'
                            end
                        end
                        if tactics == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'AI/'..tactics..'/'
                            else
                                npc_list[#npc_list][1] = 'AI/'..tactics..'/'
                            end
                        end
                        if dialog == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Dlg/'..dialog..'/'
                            else
                                npc_list[#npc_list][1] = 'Dlg/'..dialog..'/'
                            end
                        end
                        if enter == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Ent/'..enter..'/'
                            else
                                npc_list[#npc_list][1] = 'Ent/'..enter..'/'
                            end
                        end
                        if leave == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Lev/'..leave..'/'
                            else
                                npc_list[#npc_list][1] = 'Lev/'..leave..'/'
                            end
                        end
                        if simpleai == search_word then
                            if npc_list[#npc_list][1] ~= nil then
                                npc_list[#npc_list][1] = npc_list[#npc_list][1]..'Simple/'..simpleai..'/'
                            else
                                npc_list[#npc_list][1] = 'Simple/'..simpleai..'/'
                            end
                        end
                        npc_list[#npc_list][1] = zonename..' : '..npc_list[#npc_list][1]
                        npc_list[#npc_list][2] = gentype
                        npc_list[#npc_list][3] = range
                        npc_list[#npc_list][4] = zonename
                    end
                end
            end
        end
    end
    
    return npc_list
end

function uiopen(pc)
    local tx = TxBegin(pc);
    TxSetIESProp(tx, pc, 'inventory', 1);
    TxSetIESProp(tx, pc, 'status', 1);
    TxSetIESProp(tx, pc, 'skillvan', 1);
    TxSetIESProp(tx, pc, 'sysmenu', 1);
    TxSetIESProp(tx, pc, 'quest', 1);
    TxSetIESProp(tx, pc, 'quickslotnexpbar', 1);
    TxSetIESProp(tx, pc, 'map', 1);
    TxSetIESProp(tx, pc, 'minimap', 1);
    TxSetIESProp(tx, pc, 'targetinfo', 1);
    TxSetIESProp(tx, pc, 'targetbuff', 1);
    TxSetIESProp(tx, pc, 'monsterbaseinfo', 1);
    local ret = TxCommit(tx);
end
function SCR_ITEM_DELETE_ALL(pc)
    local item_list = {}
    local item_count_list = {}    
    local x = 1
    local sel_txt = {}
    local pcInvList = GetInvItemList(pc);
    if pcInvList ~= nil then
        for i = 1, #pcInvList do
            local invitem = pcInvList[i];
            if table.find(item_list, invitem.ClassName) == 0 then
                item_list[#item_list + 1] = invitem.ClassName
                item_count_list[#item_count_list + 1] = GetInvItemCount(pc,invitem.ClassName)
            end
        end
    end

    if item_list[1] == nil then
        return
    end
    local tx = TxBegin(pc);
    for i = 1, #item_list do
        TxTakeItem(tx, item_list[i], item_count_list[i], 'Cheat');
    end
    local ret = TxCommit(tx);
end
function SCR_ITEM_DELETE(pc)
    local item_list = {}    
    local x = 1
    local sel_txt = {}
    local pcInvList = GetInvItemList(pc);
    if pcInvList ~= nil then
        for i = 1, #pcInvList do
            local invitem = pcInvList[i];
            item_list[x] = {}
            item_list[x]['ClassID'] = invitem.ClassID
            item_list[x]['ClassName'] = invitem.ClassName
            item_list[x]['ItemName'] = invitem.Name
            item_list[x]['Count'] = GetInvItemCount(pc,invitem.ClassName)
            sel_txt[x] = item_list[x]['ItemName']

            x = x + 1
        end
    end

    if item_list[1] == nil then
        return
    end

    local y
    local text_sel
    local select
    
    for y = 0, math.floor(#item_list/5) do
        if y ~= math.floor(#item_list/5) then
            select = ShowSelDlg(pc, 0, 'ITEM_DELETE_select1', sel_txt[5*y+1], sel_txt[5*y+2], sel_txt[5*y+3], sel_txt[5*y+4], sel_txt[5*y+5],'NEXT PAGE','CANCEL')
        else
            select = ShowSelDlg(pc, 0, 'ITEM_DELETE_select1', sel_txt[5*y+1], sel_txt[5*y+2], sel_txt[5*y+3], sel_txt[5*y+4], sel_txt[5*y+5],'CANCEL')
        end

        if select == nil then
            return
        end

        if select < 6 and select ~= nil then
            select = select + 5*y
            break
        elseif (y == math.floor(#item_list/5) and select == 6) or select == 7 then
            return
        end
    end

--    local item_count = {}
--    local z
--    for z = 1, 10 do
--        if item_list[select]['Count'] >= z then
--            item_count[z] = z..ScpArgMsg("Piece")
--        end
--    end
--    local select_2 = ShowSelDlg(pc, 0, 'ITEM_DELETE_select2', item_count[1], item_count[2], item_count[3], item_count[4], item_count[5], item_count[6], item_count[7], item_count[8], item_count[9], item_count[10],'CANCEL')
    local select_2 = ShowTextInputDlg(pc, 0, 'ITEM_DELETE_select2')
    select_2 = tonumber(select_2)
    if select_2 == nil or select_2 > item_list[select]['Count'] then
        return
    else
        local tx = TxBegin(pc);
        TxTakeItem(tx, item_list[select]['ClassName'], select_2, 'Cheat');
        local ret = TxCommit(tx);
        if ret == 'SUCCESS' then
            Chat(pc,item_list[select]['ItemName']..' '..select_2..ScpArgMsg("Auto_Kae_SagJe."))
        end
    end
end

function SCR_SEARCH_CLASSIDIES(idspace, classid)
    local index_count = GetClassCount(idspace)
    local i
    for i = 0, index_count-1 do
        if GetClassNumberByIndex(idspace, i, 'ClassID') == classid then
            return GetClassStringByIndex(idspace, i, 'ClassName')
        end
    end
end

function SCR_GM_QUEST_UI_QUEST_CHEAT(pc, qusetClassID)
    if IsGM(pc) == 1 then
        local questIES = GetClassByType('QuestProgressCheck',qusetClassID)
        SCR_QUESTSTATE_MODIFY(pc, nil, questIES.ClassName, nil)
    end
end
function SCR_QUESTSTATE_MODIFY(pc, questlv, search_word, gm)
    if string.find(search_word, '/') ~= nil then
        search_word = string.gsub(search_word, '/', ' ')
    end
    search_word = string.upper(search_word)
    

    if tonumber(questlv) == nil or questlv == 'None' then
        questlv = -100
    end
    if tonumber(questlv) == nil and (search_word == nil or search_word == 'None') then
        Chat(pc, ScpArgMsg("Auto_KweSeuTeu_KwonJangLeBelDae_ipLyeogKapeul_SusJaLo_ipLyeogHaSipSiyo."))
        return
    end
    local quest_index = GetClassCount('QuestProgressCheck')
    local i
    local x = 1
    local quest_list = {}
    local sel_list = {}
    local level_interval = 5

    questlv = tonumber(questlv)

    questlv = math.floor(questlv/level_interval) * level_interval

    for i = 0, quest_index -1 do
        if questlv >= 0 and search_word ~= nil and type(search_word) ~= 'number' then
            if questlv <= GetClassNumberByIndex('QuestProgressCheck', i, 'Level') and GetClassNumberByIndex('QuestProgressCheck', i, 'Level') < questlv + level_interval and GetClassStringByIndex('QuestProgressCheck', i, 'ClassName') ~= 'None' and ( string.find(string.upper(GetClassStringByIndex('QuestProgressCheck', i, 'ClassName')), search_word) ~= nil or string.find(string.upper(GetClassStringByIndex('QuestProgressCheck', i, 'Name')), search_word) ~= nil)then
                quest_list[x] = {}
                quest_list[x][1] = GetClassStringByIndex('QuestProgressCheck', i, 'ClassName');
                quest_list[x][2] = GetClassStringByIndex('QuestProgressCheck', i, 'Name');
                quest_list[x][3] = SCR_QUEST_CHECK(pc,GetClassStringByIndex('QuestProgressCheck', i, 'ClassName'))
                sel_list[x] = quest_list[x][2]..'/'..quest_list[x][3]..'/'..GetClassNumberByIndex('QuestProgressCheck', i, 'Level')
                x = x + 1;
            end
        elseif questlv >= 0 then
            if questlv <= GetClassNumberByIndex('QuestProgressCheck', i, 'Level') and GetClassNumberByIndex('QuestProgressCheck', i, 'Level') < questlv + level_interval and GetClassStringByIndex('QuestProgressCheck', i, 'ClassName') ~= 'None' then
                quest_list[x] = {}
                quest_list[x][1] = GetClassStringByIndex('QuestProgressCheck', i, 'ClassName');
                quest_list[x][2] = GetClassStringByIndex('QuestProgressCheck', i, 'Name');
                quest_list[x][3] = SCR_QUEST_CHECK(pc,GetClassStringByIndex('QuestProgressCheck', i, 'ClassName'))
                sel_list[x] = quest_list[x][2]..'/'..quest_list[x][3]..'/'..GetClassNumberByIndex('QuestProgressCheck', i, 'Level')
                x = x + 1;
            end
        elseif search_word ~= nil then
        
            local tempclassname = GetClassStringByIndex('QuestProgressCheck', i, 'Name')
            tempclassname = dictionary.ReplaceDicIDInCompStr(tempclassname);
    
            if string.find(string.upper(GetClassStringByIndex('QuestProgressCheck', i, 'ClassName')), search_word) ~= nil or string.find(string.upper(tempclassname), search_word) ~= nil then
                quest_list[x] = {}
                quest_list[x][1] = GetClassStringByIndex('QuestProgressCheck', i, 'ClassName');
                quest_list[x][2] = GetClassStringByIndex('QuestProgressCheck', i, 'Name');
                quest_list[x][3] = SCR_QUEST_CHECK(pc,GetClassStringByIndex('QuestProgressCheck', i, 'ClassName'))
                sel_list[x] = quest_list[x][2]..'/'..quest_list[x][3]..'/'..GetClassNumberByIndex('QuestProgressCheck', i, 'Level')
                x = x + 1;
            end
        end
    end

    local select

    if #sel_list == 0 then
        Chat(pc,ScpArgMsg("Auto_HaeDang_LeBelDaeeNeun_KweSeuTeuKa_eopSeupNiDa."))
        return
    elseif #sel_list == 1 then
        select = 1
    else
    
        local y
        for y = 0, math.floor(#sel_list/10) do
            if y ~= math.floor(#sel_list/10) then
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    select = ShowSelDlg(gm, 0, 'Runscp_Quest_Select', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'NEXT PAGE')
                else
                    select = ShowSelDlg(pc, 0, 'Runscp_Quest_Select', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'NEXT PAGE')
                end
            else
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    select = ShowSelDlg(gm, 0, 'Runscp_Quest_Select', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'CANCEL')
                else
                    select = ShowSelDlg(pc, 0, 'Runscp_Quest_Select', sel_list[10*y+1], sel_list[10*y+2], sel_list[10*y+3], sel_list[10*y+4], sel_list[10*y+5], sel_list[10*y+6], sel_list[10*y+7], sel_list[10*y+8], sel_list[10*y+9], sel_list[10*y+10], 'CANCEL')
                end
            end
            
            if select < 11 and select ~= nil then
                select = select + 10*y
                break
            elseif y == math.floor(#sel_list/10) and select == 11 then
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                else
                    Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                end
                return
            end
        end
--            select = ShowSelDlg(pc, 0, 'Runscp_Quest_Select', sel_list[1], sel_list[2], sel_list[3], sel_list[4], sel_list[5], sel_list[6], sel_list[7], sel_list[8], sel_list[9], sel_list[10], 'CANCEL')

--            local function_script = "ShowSelDlg(pc, 0, 'Runscp_Quest_Select'"
--            local y
--
--            for y = 1, #quest_list do
----                function_script = function_script..", '"..quest_list[y][2]..quest_list[y][3]"'"
--                function_script = function_script..", quest_list["..y.."][2]..quest_list["..y.."][3]"
--            end
--
--            function_script = function_script..", 'CANCEL') "
--            print(function_script)
--            select = loadstring(function_script)()
    end
    if select == nil or select >= #sel_list + 1 then
        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
            Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        else
            Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        end
        return
    end
    
    local select2
    if gm ~= nil and gm ~= 0 and gm ~= 'None' then
        select2 = ShowSelDlg(gm, 0, 'Runscp_Quest_Select2',"{@stm2}"..quest_list[select][2]..ScpArgMsg("Auto_{/}_KweSeuTeu_SiJag"),ScpArgMsg("Auto_KweSeuTeu_JinHaeng_NPC_DaeHwa"),ScpArgMsg("Auto_KweSeuTeu_wanLyo"),ScpArgMsg("Auto_KweSeuTeu_JeongBo_ChulLyeog"), ScpArgMsg("Auto_KweSeuTeu_PoKi"),ScpArgMsg("Auto_SiJag_NPCLo_iDong"),ScpArgMsg("Auto_JinHaeng_NPCLo_iDong"),ScpArgMsg("Auto_wanLyo_NPCLo_iDong"), 'CANCEL')
    else
        select2 = ShowSelDlg(pc, 0, 'Runscp_Quest_Select2',"{@stm2}"..quest_list[select][2]..ScpArgMsg("Auto_{/}_KweSeuTeu_SiJag"),ScpArgMsg("Auto_KweSeuTeu_JinHaeng_NPC_DaeHwa"),ScpArgMsg("Auto_KweSeuTeu_wanLyo"),ScpArgMsg("Auto_KweSeuTeu_JeongBo_ChulLyeog"), ScpArgMsg("Auto_KweSeuTeu_PoKi"),ScpArgMsg("Auto_SiJag_NPCLo_iDong"),ScpArgMsg("Auto_JinHaeng_NPCLo_iDong"),ScpArgMsg("Auto_wanLyo_NPCLo_iDong"), 'CANCEL')
    end

    if select2 == nil or select2 == 9 then
        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
            Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        else
            Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
        end
        return
    elseif select2 == 1 then
        
        local questIES = GetClass('QuestProgressCheck', quest_list[select][1])
        local questautoIES = GetClass('QuestProgressCheck_Auto', quest_list[select][1])
        
        if quest_list[select][3] == 'IMPOSSIBLE' then
            local result_state, result_reason = SCR_QUEST_CHECK(pc,quest_list[select][1])
            if result_reason ~= nil then
                if #result_reason > 0 then
                    local x
                    local chat_string = ''
                    for x = 1, #result_reason do
                        chat_string = chat_string..result_reason[x]..' / '
                    end
                    if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                        Chat(gm, chat_string..ScpArgMsg("Auto__JoKeoneul_ManJogHaJi_MosHaesseum"))
                    else
                        Chat(pc, chat_string..ScpArgMsg("Auto__JoKeoneul_ManJogHaJi_MosHaesseum"))
                    end
                    
                    local select3
                    if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                        select3 = ShowSelDlg(gm, 0, 'Runscp_Quest_Select3',ScpArgMsg("Auto_KangJe_SiJag"),'CANCEL')
                    else
                        select3 = ShowSelDlg(pc, 0, 'Runscp_Quest_Select3',ScpArgMsg("Auto_KangJe_SiJag"),'CANCEL')
                    end
                    if select3 == nil or select3 == 2 then
                        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                            Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                        else
                            Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                        end
                        return
                    elseif select3 == 1 then
                        SCR_QUEST_MODIFY_QUEST_START_PREFUNC(pc, questautoIES, gm)
                        
                        SCR_QUEST_POSSIBLE(pc, quest_list[select][1])
                    end
                end
            end
        elseif quest_list[select][3] == 'PROGRESS' then
            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                Chat(gm,ScpArgMsg("Auto_KweSeuTeu_JinHaengJung_JaeSiJag_Pilyo_Si_KweSeuTeu_wanLyoLeul_MeonJeo_SilHaeng"))
            else
                Chat(pc,ScpArgMsg("Auto_KweSeuTeu_JinHaengJung_JaeSiJag_Pilyo_Si_KweSeuTeu_wanLyoLeul_MeonJeo_SilHaeng"))
            end
            return
        elseif quest_list[select][3] == 'SUCCESS' then
            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                Chat(gm,ScpArgMsg("Auto_KweSeuTeu_KweSeuTeu_wanLyoDaeKi_JaeSiJag_Pilyo_Si_KweSeuTeu_wanLyoLeul_MeonJeo_SilHaeng"))
            else
                Chat(pc,ScpArgMsg("Auto_KweSeuTeu_KweSeuTeu_wanLyoDaeKi_JaeSiJag_Pilyo_Si_KweSeuTeu_wanLyoLeul_MeonJeo_SilHaeng"))
            end
            return
        elseif quest_list[select][3] == 'COMPLETE' then
--            SCR_QUEST_ABANDONMENT(pc, questautoIES, questIES)

            local result_state, result_reason = SCR_QUEST_CHECK(pc,quest_list[select][1])
            if result_state == 'IMPOSSIBLE' then
                if result_reason ~= nil then
                    if #result_reason > 0 then
                        local x
                        local chat_string = ''
                        for x = 1, #result_reason do
                            chat_string = chat_string..result_reason[x]..' / '
                        end
                        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                            Chat(gm, chat_string..ScpArgMsg("Auto__JoKeoneul_ManJogHaJi_MosHaesseum"))
                        else
                            Chat(pc, chat_string..ScpArgMsg("Auto__JoKeoneul_ManJogHaJi_MosHaesseum"))
                        end
                        
                        local select3
                        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                            select3 = ShowSelDlg(gm, 0, 'Runscp_Quest_Select3',ScpArgMsg("Auto_KangJe_SiJag"),'CANCEL')
                        else
                            select3 = ShowSelDlg(pc, 0, 'Runscp_Quest_Select3',ScpArgMsg("Auto_KangJe_SiJag"),'CANCEL')
                        end
                        if select3 == nil or select3 == 2 then
                            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                                Chat(gm,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                            else
                                Chat(pc,ScpArgMsg("Auto_CANCEL_SeonTaeg_or_nil_Kap"))
                            end
                            return
                        elseif select3 == 1 then
                            SCR_QUEST_MODIFY_QUEST_START_PREFUNC(pc, questautoIES, gm)
                            
                            SCR_QUEST_POSSIBLE(pc, quest_list[select][1])
                        end
                    end
                end
            else
                SCR_QUEST_MODIFY_QUEST_START_PREFUNC(pc, questautoIES, gm)
                
                SCR_QUEST_POSSIBLE(pc, quest_list[select][1])
            end
        else
            SCR_QUEST_MODIFY_QUEST_START_PREFUNC(pc, questautoIES, gm)
            
            SCR_QUEST_POSSIBLE(pc, quest_list[select][1])
        end
    elseif select2 == 2 then
        local questIES = GetClass('QuestProgressCheck', quest_list[select][1])
        local questautoIES = GetClass('QuestProgressCheck_Auto', quest_list[select][1])
        
        if quest_list[select][3] == 'PROGRESS' then
            local take_list = {}
            local give_list = {}
            local txt = ''
            
            take_list = SCR_QUEST_PROG_TAKEITEM_LIST(questautoIES)
            
            if take_list ~= nil and #take_list > 0 then
                for i = 1, #take_list do
                    local takeitem_count = GetInvItemCount(pc, take_list[i][1])
                    if take_list[i][2] ~= -100 and( takeitem_count <= 0 or takeitem_count < take_list[i][2] )then
                        give_list[#give_list + 1] = {}
                        give_list[#give_list][1] = take_list[i][1]
                        give_list[#give_list][2] = take_list[i][2] - takeitem_count
                        txt = txt..take_list[i][1]..'/'
                    end
                end
            end
            
            if #give_list > 0 then
                local selyesno
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    selyesno = ShowSelDlg(gm, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
                else
                    selyesno = ShowSelDlg(pc, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
                end
                if selyesno == 2 or selyesno == nil then
                    return
                else
                    local tx = TxBegin(pc);
                    for i = 1, #give_list do
                        TxGiveItem(tx, give_list[i][1], give_list[i][2], 'QuestModify')
                    end
                    local ret = TxCommit(tx, 1);
                end
            end
            
            SCR_QUEST_PROGRESS(nil, pc, quest_list[select][1])
        else
            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                Chat(gm,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_SangTaeeoya_DongJag_KaNeung"))
            else
                Chat(pc,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_SangTaeeoya_DongJag_KaNeung"))
            end
            return
        end
    elseif select2 == 3 then
        if quest_list[select][3] == 'PROGRESS' or quest_list[select][3] == 'SUCCESS' then
            local questIES = GetClass('QuestProgressCheck', quest_list[select][1])
            local questautoIES = GetClass('QuestProgressCheck_Auto', quest_list[select][1])
            
            local take_list = {}
            local give_list = {}
            local txt = ''
            
            take_list = SCR_QUEST_SUCCESS_TAKEITEM_LIST(pc, questIES, questautoIES)
            
            if take_list ~= nil and #take_list > 0 then
                for i = 1, #take_list do
                    local takeitem_count = GetInvItemCount(pc, take_list[i][1])
                    if take_list[i][2] ~= -100 and( takeitem_count <= 0 or takeitem_count < take_list[i][2] )then
                        give_list[#give_list + 1] = {}
                        give_list[#give_list][1] = take_list[i][1]
                        give_list[#give_list][2] = take_list[i][2] - takeitem_count
                        txt = txt..take_list[i][1]..'/'
                    end
                end
            end
            
            if #give_list > 0 then
                local selyesno
                if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                    selyesno = ShowSelDlg(gm, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
                else
                    selyesno = ShowSelDlg(pc, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
                end
                if selyesno == 2 or selyesno == nil then
                    return
                else
                    local tx = TxBegin(pc);
                    for i = 1, #give_list do
                        TxGiveItem(tx, give_list[i][1], give_list[i][2], 'QuestModify')
                    end
                    local ret = TxCommit(tx, 1);
                end
            end
            
            
            local result_success = SCR_QUEST_SUCCESS(pc, quest_list[select][1])
            if result_success ~= nil then
                if #result_success > 0 then
                    local x
                    local chat_string = ''
                    for x = 1, #result_success do
                        chat_string = chat_string..result_success[x]..' / '
                    end
                    if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                        Chat(gm, chat_string..ScpArgMsg("Auto__TeuLenJegSyeon_oLyu"))
                    else
                        Chat(pc, chat_string..ScpArgMsg("Auto__TeuLenJegSyeon_oLyu"))
                    end
                end
            end
        else
            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                ChatLocal(gm, gm,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_or_wanLyoDaeKi_SangTaeeoya_DongJag_KaNeung_HyeonJae_:_")..quest_list[select][3])
            else
                ChatLocal(pc, pc,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_or_wanLyoDaeKi_SangTaeeoya_DongJag_KaNeung_HyeonJae_:_")..quest_list[select][3])
            end
            return
        end
    elseif select2 == 4 then
        SCR_QUESTDOCUMENT_XML (pc,quest_list[select][1])
    elseif select2 == 5 then
        if quest_list[select][3] == 'PROGRESS' or quest_list[select][3] == 'SUCCESS' then
            ABANDON_Q_BY_NAME(pc, quest_list[select][1], 'ABANDON')
        else
            if gm ~= nil and gm ~= 0 and gm ~= 'None' then
                ChatLocal(gm, gm,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_or_wanLyoDaeKi_SangTaeeoya_DongJag_KaNeung_HyeonJae_:_")..quest_list[select][3], 10)
            else
                ChatLocal(pc, pc,ScpArgMsg("Auto_KweSeuTeuKa_JinHaengJung_or_wanLyoDaeKi_SangTaeeoya_DongJag_KaNeung_HyeonJae_:_")..quest_list[select][3], 10)
            end
        end
    elseif select2 == 6 then
        SCR_QUEST_LOCATION_MOVE(pc, gm, quest_list[select][1], 'Start')
    elseif select2 == 7 then
        SCR_QUEST_LOCATION_MOVE(pc, gm, quest_list[select][1], 'Prog')
    elseif select2 == 8 then
        SCR_QUEST_LOCATION_MOVE(pc, gm, quest_list[select][1], 'End')
    end
end

function SCR_QUEST_LOCATION_MOVE(pc, gm, questClassName, qstate)
    local questIES = GetClass('QuestProgressCheck', questClassName)
    local moveList = {}
    if questIES[qstate..'Map'] ~= 'None' and questIES[qstate..'NPC'] ~= 'None' then
        moveList[#moveList + 1] = {1, questIES[qstate..'Map'], questIES[qstate..'NPC']}
    elseif questIES[qstate..'Map'] ~= 'None' then
        moveList[#moveList + 1] = {2, questIES[qstate..'Map']}
    elseif questIES[qstate..'NPC'] ~= 'None' then
        moveList[#moveList + 1] = {3, questIES[qstate..'NPC']}
    end
    if questIES[qstate..'MapListUI'] ~= 'None' then
        local strList = SCR_STRING_CUT(questIES[qstate..'MapListUI'])
        for i = 1, #strList do
            if GetClass('Map_Area', strList[i]) ~= nil then
                local areaIES = GetClass('Map_Area', strList[i])
                moveList[#moveList + 1] = {4, areaIES.ZoneClassName, areaIES.Pos1_X, areaIES.Pos1_Y, areaIES.Pos1_Z}
            elseif GetClass('Map', strList[i]) ~= nil then
                moveList[#moveList + 1] = {2, strList[i]}
            end
        end
    end
    
    if questIES[qstate..'Location'] ~= 'None' then
        local strList = SCR_STRING_CUT(questIES[qstate..'Location'],' ')
        local i = 1
        while i < #strList do
            if tonumber(strList[i + 1]) ~= nil then
                moveList[#moveList + 1] = {4, strList[i], strList[i + 1], strList[i + 2], strList[i + 3]}
                i = i + 5
            else
                moveList[#moveList + 1] = {1, strList[i], strList[i + 1]}
                i = i + 3
            end
        end
    end
    
    if qstate == 'Prog' and questIES.Quest_SSN ~= 'None' then
        local ssnIES = GetClass('SessionObject', questIES.Quest_SSN)
        for x = 1, 10 do
            if ssnIES['QuestMapPointGroup'..x] ~= 'None' then
                local strList = SCR_STRING_CUT(ssnIES['QuestMapPointGroup'..x],' ')
                local i = 1
                while i < #strList do
                    if tonumber(strList[i + 1]) ~= nil then
                        moveList[#moveList + 1] = {4, strList[i], strList[i + 1], strList[i + 2], strList[i + 3]}
                        i = i + 5
                    else
                        moveList[#moveList + 1] = {1, strList[i], strList[i + 1]}
                        i = i + 3
                    end
                end
            end
        end
    end
    
    if #moveList == 0 then
        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
            ChatLocal(gm, gm, questClassName..ScpArgMsg("MoveListNilMsg"), 10)
        else
            ChatLocal(pc, pc, questClassName..ScpArgMsg("MoveListNilMsg"), 10)
        end
    else
        local dupl = {}
        for i = 1, #moveList - 1 do
            for y = i + 1, #moveList do
                if i ~= y and table.concat(moveList[i], "/") == table.concat(moveList[y], "/") and table.find(dupl, y) == 0 then
                    dupl[#dupl + 1] = y
                end
            end
        end
        local moveList_ret = {}
        for i = 1, #moveList do
            if table.find(dupl, i) == 0 then
                moveList_ret[#moveList_ret + 1] = moveList[i]
            end
        end
        
        local select3
        if #moveList_ret > 1 then
            local selList = {}
            for i = 1, #moveList_ret do
                if moveList_ret[i][1] == 1 then
                    local zoneIES = GetClass('Map',moveList_ret[i][2])
                    if zoneIES == nil then
                        ErrorLog('Quest : '..questClassName..' Zone not find : '..moveList_ret[i][2])
                    else
                        selList[#selList + 1] = 'Zone : '..moveList_ret[i][2]..' '..zoneIES.Name..'/NPC : '..moveList_ret[i][3]
                    end
                elseif moveList_ret[i][1] == 2 then
                    local zoneIES = GetClass('Map',moveList_ret[i][2])
                    if zoneIES == nil then
                        ErrorLog('Quest : '..questClassName..' Zone not find : '..moveList_ret[i][2])
                    else
                        selList[#selList + 1] = 'Zone : '..moveList_ret[i][2]..' '..zoneIES.Name
                    end
                elseif moveList_ret[i][1] == 3 then
                    selList[#selList + 1] = 'NPC : '..moveList_ret[i][2]
                elseif moveList_ret[i][1] == 4 then
                    local zoneIES = GetClass('Map',moveList_ret[i][2])
                    if zoneIES == nil then
                        ErrorLog('Quest : '..questClassName..' Zone not find : '..moveList_ret[i][2])
                    else
                        selList[#selList + 1] = 'Zone : '..moveList_ret[i][2]..' '..zoneIES.Name..'/Pos : '..moveList_ret[i][3]..' '..moveList_ret[i][4]..' '..moveList_ret[i][5]
                    end
                end
            end
            select3 = SCR_SEL_LIST(pc, selList, 'SCR_SUITABLE_ITEM\\Move Position Select')
        end
        if select3 == nil or #moveList_ret >= select3 then
            if select3 == nil then
                select3 = 1
            elseif select3 == 0 then
                return
            end
            if moveList_ret[select3][1] == 1 then
                npcmove(pc, moveList_ret[select3][3], moveList_ret[select3][2], 1, true)
            elseif moveList_ret[select3][1] == 2 then
                MoveZone(pc,moveList_ret[select3][2])
            elseif moveList_ret[select3][1] == 3 then
                npcmove(pc, moveList_ret[select3][2], nil, 1, true)
            elseif moveList_ret[select3][1] == 4 then
                MoveZone(pc, moveList_ret[select3][2], tonumber(moveList_ret[select3][3]), tonumber(moveList_ret[select3][4]), tonumber(moveList_ret[select3][5]))
            end
        end
    end
end

function SCR_QUEST_MODIFY_QUEST_START_PREFUNC(pc, questautoIES, gm)
    local take_list = {}
    local give_list = {}
    local txt = ''
    local questIES = GetClass('QuestProgressCheck', questautoIES.ClassName);
    
    take_list = SCR_QUEST_POSS_TAKEITEM_LIST(questautoIES)
    
    if take_list ~= nil and #take_list > 0 then
        for i = 1, #take_list do
            local takeitem_count = GetInvItemCount(pc, take_list[i][1])
            if take_list[i][2] ~= -100 and( takeitem_count <= 0 or takeitem_count < take_list[i][2] )then
                give_list[#give_list + 1] = {}
                give_list[#give_list][1] = take_list[i][1]
                give_list[#give_list][2] = take_list[i][2] - takeitem_count
                txt = txt..take_list[i][1]..'/'
            end
        end
    end
    
    if #give_list > 0 then
        local selyesno
        if gm ~= nil and gm ~= 0 and gm ~= 'None' then
            selyesno = ShowSelDlg(gm, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
        else
            selyesno = ShowSelDlg(pc, 0, 'QuestModifyTakeItem1', string.sub(txt,1,#txt -1), ScpArgMsg('No'))
        end
        if selyesno == 2 or selyesno == nil then
            return
        else
            local tx = TxBegin(pc);
            for i = 1, #give_list do
                TxGiveItem(tx, give_list[i][1], give_list[i][2], 'QuestModify')
            end
            local ret = TxCommit(tx, 1);
        end
    end
    
    if questIES.Check_PartyPropCount > 0 then
        local partyPropCheckCount = questIES.Check_PartyPropCount
        local partyObj = GetPartyObj(pc)
        if partyObj ~= nil then
            local propList = {}
            local propValue = {}
            for i = 1, partyPropCheckCount do
                if GetPropType(partyObj, questIES['PartyPropName'..i]) ~= nil then
                    if questIES['PartyPropTerms'..i] == '>=' then
                        if partyObj[questIES['PartyPropName'..i]] < questIES['PartyPropCount'..i] then
                            propList[#propList +1] = questIES['PartyPropName'..i]
                            propValue[#propValue +1] = questIES['PartyPropCount'..i]
                        end
                    elseif questIES['PartyPropTerms'..i] == '==' then
                        if partyObj[questIES['PartyPropName'..i]] < questIES['PartyPropCount'..i] then
                            propList[#propList +1] = questIES['PartyPropName'..i]
                            propValue[#propValue +1] = questIES['PartyPropCount'..i]
                        end
                    elseif questIES['PartyPropTerms'..i] == '<=' then
                        if partyObj[questIES['PartyPropName'..i]] > questIES['PartyPropCount'..i] then
                            propList[#propList +1] = questIES['PartyPropName'..i]
                            propValue[#propValue +1] = questIES['PartyPropCount'..i]
                        end
                    end
                end
            end
            
            if #propList > 0 then
                for i = 1, #propList do
                    ChangePartyProp(pc, PARTY_NORMAL, propList[i], propValue[i])
                end
            end
        end
    end
end

function set_layer(pc, layer_num)
    local pc_layer = GetLayer(pc)
    Chat(pc,'before pc_layer = '..pc_layer)

    SetLayer(pc,layer_num)

    pc_layer = GetLayer(pc)
    Chat(pc,'after pc_layer = '..pc_layer)
end

function get_layer(pc)
    local pc_layer = GetLayer(pc)
    Chat(pc,'pc_layer = '..pc_layer)
end

function get_smain(pc,property_name)
    get_sessionmain(pc,property_name);
end
function get_sessionmain(pc,property_name)
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    if sObj ~= nil then
        
        Chat(pc,'Present '..property_name..' = '..sObj[property_name]);
    else
        Chat(pc,'Session nil');
    end
end

function get_sname(pc,session_name, property_name)
    getsession_name(pc,session_name, property_name);
end
function getsession_name(pc,session_name, property_name)
    local obj
    if string.upper(session_name) == 'ACCOUNT' then
        obj = GetAccountObj(pc);
    elseif string.upper(session_name) == 'PCETC' then
        obj = GetETCObject(pc)
    elseif string.upper(session_name) == 'ZONE' then
        local zoneID = GetZoneInstID(pc)
        local zoneObj = GetLayerObject(zoneID, 0)
        obj = zoneObj
    elseif string.upper(session_name) == 'INSTANCE' then
        local value = GetExProp(pc,property_name)
        Chat(pc,'Present '..session_name..' : '..property_name..' = '..value);
        return
    else
        obj = GetSessionObject(pc, session_name);
    end
    if obj ~= nil then
        Chat(pc,'Present '..session_name..' : '..property_name..' = '..obj[property_name]);
    else
        Chat(pc,'obj nil');
    end
end



function create_ssn(pc,property_name)
    CreateSessionObject(pc, property_name);
end

function set_smain(pc,property_name,property_value)
    set_sessionmain(pc,property_name,property_value);
end
function set_sessionmain(pc,property_name,property_value)
    local sObj = GetSessionObject(pc, 'ssn_klapeda');
    if sObj ~= nil then
        local tx = TxBegin(pc);
        if tonumber(property_value) ~= nil then
            property_value = tonumber(property_value)
        end
        TxSetIESProp(tx, sObj, property_name, property_value)
        local ret = TxCommit(tx);
        Chat(pc,property_name..' = '..sObj[property_name]);
    else
        Chat(pc,'Session nil');
    end
end

function set_sname(pc,session_name, property_name,property_value)
    setsession_name(pc,session_name, property_name,property_value);
end
function setsession_name(pc,session_name, property_name,property_value)
    local obj
    if string.upper(session_name) == 'ACCOUNT' then
        obj = GetAccountObj(pc);
    elseif string.upper(session_name) == 'PCETC' then
        obj = GetETCObject(pc)
    elseif string.upper(session_name) == 'ZONE' then
        local zoneID = GetZoneInstID(pc)
        local zoneObj = GetLayerObject(zoneID, 0)
        zoneObj[property_name] = property_value
        Chat(pc,session_name..' : '..property_name..' = '..zoneObj[property_name]);
        return
    elseif string.upper(session_name) == 'INSTANCE' then
        SetExProp(pc,property_name,property_value)
        local value = GetExProp(pc, property_name)
        Chat(pc,'Present '..session_name..' : '..property_name..' = '..value);
        return
    else
        obj = GetSessionObject(pc, session_name);
    end
    
    if obj ~= nil then
        local tx = TxBegin(pc);
        if tonumber(property_value) ~= nil then
            property_value = tonumber(property_value)
        end
        TxSetIESProp(tx, obj, property_name, property_value)
        local ret = TxCommit(tx);
        Chat(pc,session_name..' : '..property_name..' = '..obj[property_name]);
    else
        Chat(pc,'obj nil');
    end
end



function ShowRankUI(pc, uiName, showAllCategory)

    local cls = GetClass("AchievePoint", uiName);
    if cls == nil then
        return;
    end

    local sArg = "0";
    if showAllCategory == "YES" then
        sArg = "1";
    end

    SendAddOnMsg(pc, "RANK_UI", sArg, cls.ClassID);
    ShowCustomDlg(pc, 'halloffame', 5);

end

function CHANGE_MAP_STATE(pc, mapName, genType)

    local tx = TxBegin(pc)
    TxChangeGenTypeState(tx, mapName, genType, 1);
    local ret = TxCommit(tx);

end

function SCR_CORSAIR_PARTY_DEAD_EVENT(pc)
    --local deleteRate = IMCRandom(1, 100);
    --if deleteRate > 20 or IsBuffApplied(pc, 'JollyRoger_Buff') == 'NO' then
    if 1 == 1 then
        return;
    end

    local rateList = {};
    local partsNameList = {};
    partsNameList[#partsNameList+1] = 'SHIRT';  rateList[#rateList+1] = 20;
    partsNameList[#partsNameList+1] = 'GLOVES'; rateList[#rateList+1] = 20;
    partsNameList[#partsNameList+1] = 'NECK';   rateList[#rateList+1] = 20;
    partsNameList[#partsNameList+1] = 'PANTS';  rateList[#rateList+1] = 20;
    partsNameList[#partsNameList+1] = 'BOOTS';  rateList[#rateList+1] = 20;
    partsNameList[#partsNameList+1] = 'RH';     rateList[#rateList+1] = 10; 
    partsNameList[#partsNameList+1] = 'LH';     rateList[#rateList+1] = 10;     
    partsNameList[#partsNameList+1] = 'RING1';  rateList[#rateList+1] = 15;
    partsNameList[#partsNameList+1] = 'RING2';  rateList[#rateList+1] = 15;
    
    local noPartsName = {"NoHat", "NoShirt", "NoGloves", "NoBoots", "NoNeck", "NoRing", "NoWeapon"};

    local total = 0;
    for i = 1, 9 do
        total = total + rateList[i];
    end
    
    local partsNumber = IMCRandom(1, total);
    local partsName;
    total = 0;
    for i = 1, 9 do
        total = total + rateList[i];
        if partsNumber <= total then
            partsName = partsNameList[i];
            break;
        end
    end
    
    local equipItem = GetEquipItem(pc, partsName);

    local findString = nil;
    for i = 1, #noPartsName do
        findString = string.find(equipItem.ClassName, noPartsName[i])
    end

    --if equipItem ~= nil then
    if findString ~= nil then
        local itemClassName = equipItem.ClassName;
        local tx = TxBegin(pc);
        TxTakeItemByObject(tx, equipItem, 1, "CorsairPartyDead");
        local ret = TxCommit(tx);
        if ret == 'SUCCESS' then
            SendMsgDestroyEquipItem(pc, itemClassName);
        end
    end
end

function GM_QUEST_MODIFY(pc, questClassName)
    if IsGM(pc) == 1 then
        local objList, objCount = SelectObject(pc, 100, 'ALL', 1)
        local pcList = {}
        local pcNameList = {}
        
        if objCount > 0 then
            for i = 1, objCount do
                if objList[i].ClassName == 'PC' and IsSameActor(pc, objList[i]) == 'NO'  then
                    pcList[#pcList +1] = objList[i]
                    pcNameList[#pcNameList + 1] = objList[i].Name
                end
            end
        end
        
        if pcList ~= nil and #pcList > 0 then
            local select = SCR_SEL_LIST(pc,pcNameList, 'GM_QUEST_MODIFY_PC_SEL', 1)
            if select ~= nil and select > 0 and select <= #pcList then
                local user = pcList[select]
                SCR_QUESTSTATE_MODIFY(user, nil, questClassName, pc)
            end
        end
    end
end

function GM_NPC_HIDE_UNHIDE(pc, npcFuncName, hideValue)
    hideValue = tonumber(hideValue)
    if IsGM(pc) == 1 and npcFuncName ~= nil and (hideValue == 0 or hideValue == 1) then
        local objList, objCount = SelectObject(pc, 100, 'ALL', 1)
        local pcList = {}
        local pcNameList = {}
        
        if objCount > 0 then
            for i = 1, objCount do
                if objList[i].ClassName == 'PC' and IsSameActor(pc, objList[i]) == 'NO'  then
                    if hideValue == 0 and isHideNPC(objList[i], npcFuncName) == 'YES' then
                        pcList[#pcList +1] = objList[i]
                        pcNameList[#pcNameList + 1] = objList[i].Name
                    elseif hideValue == 1 and isHideNPC(objList[i], npcFuncName) == 'NO' then
                        pcList[#pcList +1] = objList[i]
                        pcNameList[#pcNameList + 1] = objList[i].Name
                    end
                end
            end
        end
        
        if pcList ~= nil and #pcList > 0 then
            local select = SCR_SEL_LIST(pc,pcNameList, 'GM_NPC_HIDE_UNHIDE', 1)
            if select ~= nil and select > 0 and select <= #pcList then
                local user = pcList[select]
                if hideValue == 0 and isHideNPC(user, npcFuncName) == 'YES' then
                    UnHideNPC(user, npcFuncName)
                elseif hideValue == 1 and isHideNPC(user, npcFuncName) == 'NO' then
                    HideNPC(user, npcFuncName, 0, 0, 0)
                end
            end
        end
    end
end


function SCR_ADD_ACHIEVE_MonKill_hanaming(mon, killer)
    if IS_PC(killer) == true then
        RunScript('SCR_ADD_ACHIEVE_MonKill_hanaming_tx', killer)
    end
end

function SCR_ADD_ACHIEVE_MonKill_hanaming_tx(killer)
        local tx = TxBegin(killer);
        TxAddAchievePoint(tx, "MonKill_hanaming", 1)
        local ret = TxCommit(tx);
    end

function SCR_SET_ACHIEVE_POINT(pc, className, point)
    if IS_PC(pc) == true then
        local cls = GetClass("Achieve", className)
        AddAchievePoint(pc, cls.NeedPoint, point);
    end
end

function SCR_RESET_LEVEL(pc)

    if IS_PC(pc) == true then
        LevelReset(pc);
        SendSysMsg(pc, "TryReconnection");
    end
end
function SCR_OBJ_REMOVE_EFFECT_SET(target, pc, playInfo)
    local playInfoList = SCR_STRING_CUT(playInfo)
    if #playInfoList > 0 then
        for i = 1, #playInfoList do
            if target ~= nil then
                local stepList = SCR_STRING_CUT(playInfoList[i], ':')
                if #stepList > 0 then
                    if stepList[1] == 'kill' then
                        Kill(target)
                    elseif stepList[1] == 'dead' then
                        Dead(target)
                    elseif stepList[1] == 'sleep' then
                        if tonumber(stepList[2]) ~= nil then
                            sleep(tonumber(stepList[2]))
                        end
                    elseif stepList[1] == 'effect' then
                        local size = 1
                        if stepList[3] ~= nil and tonumber(stepList[3]) ~= nil then
                            size = tonumber(stepList[3])
                        end
                        PlayEffect(target, stepList[2], size)
                    elseif stepList[1] == 'effectlocal' then
                        if pc ~= nil then
                            local size = 1
                            if stepList[3] ~= nil and tonumber(stepList[3]) ~= nil then
                                size = tonumber(stepList[3])
                            end
                            PlayEffectLocal(target, pc, stepList[2], size)
                        end
                    elseif stepList[1] == 'sound' then
                        if pc ~= nil then
                            PlaySound(pc, stepList[2])
                        end
                    elseif stepList[1] == 'anim' then
                        PlayAnim(target, stepList[2], 1, 1) 
                    elseif stepList[1] == 'animlocal' then
                        if pc ~= nil then
                            PlayAnimLocal(target, pc, stepList[2], 1, 1)
                        end
                    elseif stepList[1] == 'down' then
                        if pc ~= nil then
                            local angle = GetAngleTo(pc, target);
                            local power = tonumber(stepList[2])
                            KnockDown(target, pc, power, angle, 60, 1);
                        end
                    elseif stepList[1] == 'back' then
                        if pc ~= nil then
                            local angle = GetAngleTo(pc, target);
                            local power = tonumber(stepList[2])
                            KnockBack(target, pc, power, angle, 45, 1)
                        end
                    end
                end
            end
        end
    end
end

function IS_BASIC_FIELD_DUNGEON(self)
    if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 and (GetClassString('Map', GetZoneName(self), 'MapType') == 'Field' or GetClassString('Map', GetZoneName(self), 'MapType') == 'Dungeon') then
        return 'YES'
    end
    return 'NO'
end