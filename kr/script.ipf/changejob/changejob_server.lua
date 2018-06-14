function SCR_CLICK_CHANGEJOB_BUTTON(pc, jobid)
	
	if GetJobLv(pc) < 15 then	
		print("Error GetJobLv(pc) < 15")
		return;
	end

	if GetTotalJobCount(pc) >= JOB_CHANGE_MAX_RANK then
		print("TeamName : "..GetTeamName(pc).." jobRankOver, JOB_CHANGE_MAX_RANK : "..JOB_CHANGE_MAX_RANK)
		return;
	end

	local pcjobinfo = GetClassByType('Job', jobid)

	if pcjobinfo == nil then
		print('pcjobinfo == nil')
		return;
	end

	local myGender = TryGetProp(pc, 'Gender');
	local jobGender = TryGetProp(pcjobinfo, 'Gender');
	
	if myGender == nil then
		print('my gender == nil');
		return;
	end
	
	if jobGender == nil then
		print('job gender == nil');
		return;
	end
	
	if jobGender == 'Male' then
		if myGender ~= 1 then
			return;
		end
	elseif jobGender == 'Female' then
		if myGender ~= 2 then
			return;
		end
	end
	local jobObj = GetJobObject(pc);

	if jobObj == nil then
		return
	end

	if jobObj.CtrlType ~= pcjobinfo.CtrlType then
		return
	end

	if pcjobinfo.Rank > GetTotalJobCount(pc) + 1 then
		print("Error pcjobinfo.Rank > GetTotalJobCount(pc) + 1")
		return;
	end

	local jobCircle = GetJobGradeByName(pc, pcjobinfo.ClassName);
	if jobCircle > 3 then
		print('Error jobCircle > 3')
		return;

	end
	
	if pcjobinfo.MaxCircle <= jobCircle then
	    return
	end
	
    if pcjobinfo.HiddenJob == "YES" and jobCircle <= 0 then
    	local pcEtc = GetETCObject(pc);
    	if pcEtc["HiddenJob_"..pcjobinfo.ClassName] ~= 300 and IS_KOR_TEST_SERVER() == false then
    	    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("CHANGEJOB_SERVER_MSG1"), 5)
    	    return
    	end
    end
    
    local preFuncName = TryGetProp(pcjobinfo, 'PreFunction')
    if preFuncName ~= nil and preFuncName ~= 'None' then
        local preFunc = _G[preFuncName]
        if preFunc ~= nil then
            local result = preFunc(pc)
            if result == 'NO' then
                return
            end
        end
    end
	
	local nowjobName = pc.JobName;
	local nowjobID = GetClass("Job", nowjobName).ClassID;
	
	--전직 시 남은 포인트 있으면 전직 안되도록
	--local havepts = GetRemainSkillPts(pc, nowjobID);
	--if havepts > 0 then
		--print('ERROR! Still Remain SKill PTS : ', havepts);
		--return;
	--end

	local etc = GetETCObject(pc);

	if etc.JobChanging == jobid then
		print('ERROR! etc.JobChanging == jobid')
		return
	elseif etc.JobChanging ~= 0 then
		print('ERROR! etc.JobChanging ~= 0')
		return
	end

	local totaljobcount = GetTotalJobCount(pc)
	local stringtest = 'ChangeJobQuest'..totaljobcount

	if stringtest == 'None' then
		print(ScpArgMsg('Auto_job.xmlui_JeonJig_KweSeuTeuKa_SeolJeongDoeJi_aneum(None)'))
		return
	end

	if stringtest == nil then
		print('stringtest == nil')
		return
	end

	--시작점에 따라 전직 퀘스트가 달라지는 경우가 있어서 여기서 처리한다
	local ChangeJobQuestCircleText = "ChangeJobQuestCircle"..jobCircle+1

	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	--시작지점에 따라서 뒤에 ChangeJobQuestCircle_jobCircle+1_1 혹은 _2 컬럼에서 퀘스트 이름을 가져옴
	if sObj.QSTARTZONETYPE == "StartLine1" then
		ChangeJobQuestCircleText = ChangeJobQuestCircleText.."_1"	
	elseif sObj.QSTARTZONETYPE == "StartLine2" then
		ChangeJobQuestCircleText = ChangeJobQuestCircleText.."_2"
	else
		local infostr = "QSTARTZONETYPE is nil"
		if sObj.QSTARTZONETYPE ~= nil then
			infostr = "QSTARTZONETYPE is ".. sObj.QSTARTZONETYPE
		end

		IMC_LOG("INFO_NORMAL", infostr)
	end

--	local questName = pcjobinfo[ChangeJobQuestCircleText]

	--퀘스트 이름을 가져왔는데 퀘스트 이름이 None이라면 그냥 _1의 퀘스트를 사용하자
--	if questName == "None" then
--		ChangeJobQuestCircleText = "ChangeJobQuestCircle"..jobCircle+1
--		questName = pcjobinfo[ChangeJobQuestCircleText.."_1"]
--	end
	
	--None이였을 때, _1 의 퀘스트 이름을 가져왔는데 또 None면 문제가 있는게 아닐까?
--	if questName == "None" then
--		print("ERROR!"..ChangeJobQuestCircleText.."_1".." None")
--		return;
--	end
	
    
    -- 랭초때 줬던 랭크 카드 없애준다
    local rank = GetTotalJobCount(pc); -- 현재 랭크
    local itemClassName = 'jexpCard_UpRank'..(rank + 1);
    local invItem = GetInvItemByName(pc, itemClassName);
    local tx = TxBegin(pc)
    TxChangeJob(tx, pcjobinfo.ClassName);
    if invItem ~= nil then
        TxTakeItem(tx, itemClassName, 1, 'ChangeJob');
    end
    if jobCircle == 0 then
        local defaultCostume = TryGetProp(pcjobinfo, 'DefaultCostume')
        if defaultCostume ~= nil and defaultCostume ~= 'None' then
            if GetClass('Item', defaultCostume) ~= nil then
                TxGiveItem(tx, defaultCostume, 1, 'ChangeJob')
            end
        end
        for i = 1, 3 do
            local defaultItem = TryGetProp(pcjobinfo, 'ChangeJobDefaultItem'..i)
            if defaultItem ~= nil and defaultItem ~= 'None' then
                TxGiveItem(tx, defaultItem, 1, 'ChangeJob')
            end
        end
    end
    
--    -- NEW CLASS ChangeJob EVENT
--    local now_time = os.date('*t')
--    local month = now_time['month']
--    local year = now_time['year']
--    local day = now_time['day']
--
--    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--    
--    local aObj = GetAccountObj(pc)
--    if aObj ~= nil then
--        if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 6, 14) then
--            if pcjobinfo.ClassName == 'Char3_12' then
--                if aObj.EVENT_1805_NEWCLASS_PDP_TEAM_COUNT == 0 and sObj.EVENT_1805_NEWCLASS_PDP_PC_COUNT == 0 then
--                    TxSetIESProp(tx, aObj, 'EVENT_1805_NEWCLASS_PDP_TEAM_COUNT', aObj.EVENT_1805_NEWCLASS_PDP_TEAM_COUNT + 1)
--                    TxSetIESProp(tx, sObj, 'EVENT_1805_NEWCLASS_PDP_PC_COUNT', sObj.EVENT_1805_NEWCLASS_PDP_PC_COUNT + 1)
--                    TxGiveItem(tx, 'EVENT_1805_NEWCLASS_BOX_PDP', 1, 'EVENT_1805_NEWCLASS_PDP')
--                end
--            end
--            if pcjobinfo.ClassName == 'Char4_20' then
--                if aObj.EVENT_1805_NEWCLASS_EXO_TEAM_COUNT == 0 and sObj.EVENT_1805_NEWCLASS_EXO_PC_COUNT == 0 then
--                    TxSetIESProp(tx, aObj, 'EVENT_1805_NEWCLASS_EXO_TEAM_COUNT', aObj.EVENT_1805_NEWCLASS_EXO_TEAM_COUNT + 1)
--                    TxSetIESProp(tx, sObj, 'EVENT_1805_NEWCLASS_EXO_PC_COUNT', sObj.EVENT_1805_NEWCLASS_EXO_PC_COUNT + 1)
--                    TxGiveItem(tx, 'EVENT_1805_NEWCLASS_BOX_EXO', 1, 'EVENT_1805_NEWCLASS_EXO')
--                end
--            end
--        end
--    end
    
--    -- NEW CLASS ChangeJob EVENT
--    local now_time = os.date('*t')
--    local month = now_time['month']
--    local year = now_time['year']
--    local day = now_time['day']
--
--    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--    
--    local aObj = GetAccountObj(pc)
--    if aObj ~= nil then
--        if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 5) then
--            if pcjobinfo.ClassName == 'Char1_18' then
--                if aObj.EVENT_1803_NEWCLASS_RTA_TEAM_COUNT == 0 and sObj.EVENT_1803_NEWCLASS_RTA_PC_COUNT == 0 then
--                    TxSetIESProp(tx, aObj, 'EVENT_1803_NEWCLASS_RTA_TEAM_COUNT', aObj.EVENT_1803_NEWCLASS_RTA_TEAM_COUNT + 1)
--                    TxSetIESProp(tx, sObj, 'EVENT_1803_NEWCLASS_RTA_PC_COUNT', sObj.EVENT_1803_NEWCLASS_RTA_PC_COUNT + 1)
--                    TxGiveItem(tx, 'EVENT_1803_NEWCLASS_BOX_RTA', 1, 'EVENT_1803_NEWCLASS_RTA')
--                end
--            end
--            if pcjobinfo.ClassName == 'Char2_20' then
--                if aObj.EVENT_1803_NEWCLASS_OMJ_TEAM_COUNT == 0 and sObj.EVENT_1803_NEWCLASS_OMJ_PC_COUNT == 0 then
--                    TxSetIESProp(tx, aObj, 'EVENT_1803_NEWCLASS_OMJ_TEAM_COUNT', aObj.EVENT_1803_NEWCLASS_OMJ_TEAM_COUNT + 1)
--                    TxSetIESProp(tx, sObj, 'EVENT_1803_NEWCLASS_OMJ_PC_COUNT', sObj.EVENT_1803_NEWCLASS_OMJ_PC_COUNT + 1)
--                    TxGiveItem(tx, 'EVENT_1803_NEWCLASS_BOX_OMJ', 1, 'EVENT_1803_NEWCLASS_OMJ')
--                end
--            end
--        end
--    end
    
    
    
	local ret = TxCommit(tx);
    PlayEffect(pc, 'F_pc_class_change', 1)
    SendAddOnMsg(pc, "START_JOB_CHANGE", "", 0);
    
    if IS_IN_EVENT_MAP(pc) == true then
        return
    end
    
    local masterNPCInfo = {
                    	    {'None','Char1_11','c_fedimian','JOB_SQUIRE3_1_NPC'},
                            {'None','Char3_9','c_fedimian','MASTER_ROGUE'},
                            {'None','Char4_5','c_fedimian','JOB_DRUID3_1_NPC'},
                            {'None','Char1_9','c_fedimian','MASTER_DOPPELSOELDNER'},
                            {'None','Char3_13','c_fedimian','FEDIMIAN_APPRAISER_NPC'},
                            {'None','Char1_16','c_Klaipe','KLAPEDA_USKA'},
                            {'StartLine1','Char1_3','c_Klaipe','MASTER_PELTASTA'},
                            {'StartLine1','Char2_3','c_Klaipe','MASTER_ICEMAGE'},
                            {'StartLine1','Char3_3','c_Klaipe','MASTER_QU'},
                            {'StartLine1','Char3_4','c_Klaipe','MASTER_RANGER'},
                            {'StartLine1','Char1_1','c_Klaipe','MASTER_SWORDMAN'},
                            {'StartLine1','Char2_1','c_Klaipe','MASTER_WIZARD'},
                            {'StartLine1','Char3_1','c_Klaipe','MASTER_ARCHER'},
                            {'StartLine1','Char4_1','c_Klaipe','MASTER_CLERIC'},
                            {'StartLine1','Char4_2','c_Klaipe','MASTER_PRIEST'},
                            {'StartLine1','Char4_3','c_Klaipe','MASTER_KRIWI'},
                            {'None','Char4_8','c_Klaipe','MASTER_ORACLE'},
                            {'StartLine1','Char1_2','c_highlander','MASTER_HIGHLANDER'},
                            {'StartLine1','Char4_4','c_voodoo','MASTER_BOCORS'},
                            {'StartLine1','Char2_2','c_firemage','MASTER_FIREMAGE'},
                            {'StartLine2','Char1_1','c_orsha','JOB_2_SWORDMAN_NPC'},
                            {'StartLine2','Char1_3','c_orsha','JOB_2_PELTASTA_NPC'},
                            {'StartLine2','Char1_4','c_orsha','JOB_2_HOPLITE_NPC'},
                            {'StartLine2','Char4_1','c_orsha','JOB_2_CLERIC_NPC'},
                            {'StartLine2','Char4_3','c_orsha','JOB_2_KRIVIS_NPC'},
                            {'StartLine2','Char4_2','c_orsha','JOB_2_PRIEST_NPC'},
                            {'StartLine2','Char4_4','c_orsha','JOB_2_BOKOR_NPC'},
                            {'StartLine2','Char1_10','c_orsha','JOB_2_RODELERO_NPC'},
                            {'StartLine2','Char1_7','c_orsha','JOB_2_CATAPHRACT_NPC'},
                            {'StartLine2','Char4_6','c_orsha','JOB_2_SADHU_NPC'},
                            {'StartLine2','Char4_11','c_orsha','JOB_2_PALADIN_NPC'},
                            {'StartLine2','Char2_1','c_orsha','JOB_2_WIZARD_MASTER'},
                            {'StartLine2','Char2_2','c_orsha','JOB_2_PYROMANCER_MASTER'},
                            {'StartLine2','Char2_3','c_orsha','JOB_2_CRYOMANCER_MASTER'},
                            {'StartLine2','Char2_4','c_orsha','JOB_2_PSYCHOKINO_MASTER'},
                            {'StartLine2','Char2_7','c_orsha','JOB_2_LINKER_MASTER'},
                            {'StartLine2','Char2_10','c_orsha','JOB_2_THAUMATURGE_MASTER'},
                            {'StartLine2','Char2_11','c_orsha','JOB_2_ELEMENTALIST_MASTER'},
                            {'StartLine2','Char3_1','c_orsha','JOB_2_ARCHER_MASTER'},
                            {'StartLine2','Char3_4','c_orsha','JOB_2_RANGER_MASTER'},
                            {'StartLine2','Char3_3','c_orsha','JOB_2_QUARRELSHOOTER_MASTER'},
                            {'StartLine2','Char3_5','c_orsha','JOB_2_SAPPER_MASTER'},
                            {'StartLine2','Char3_2','c_orsha','JOB_2_HUNTER_MASTER'},
                            {'StartLine2','Char3_6','c_orsha','JOB_2_WUGUSHI_MASTER'},
                            {'StartLine2','Char3_8','c_orsha','JOB_2_SCOUT_MASTER'},
                            {'None','Char2_18','c_nunnery','ENCHANTER_MASTER'},
                            {'StartLine1','Char4_7','f_siauliai_west','JOB_DIEVDIRBYS2_NPC'},
                            {'StartLine1','Char1_4','f_siauliai_west','JOB_HOPLITE2_NPC'},
                            {'StartLine1','Char3_5','f_siauliai_2','JOB_SAPPER2_1_NPC'},
                            {'StartLine1','Char3_2','f_siauliai_2','JOB_HUNTER2_1_NPC'},
                            {'StartLine1','Char1_6','f_siauliai_2','JOB_BARBARIAN2_NPC'},
                            {'None','Char2_5','f_siauliai_out','SIAULIAIOUT_ALCHE_A'},
                            {'StartLine1','Char2_4','f_siauliai_out','JOB_PSYCHOKINESIST2_1_NPC'},
                            {'StartLine1','Char2_7','f_siauliai_out','JOB_LINKER2_1_NPC'},
                            {'StartLine1','Char4_11','f_gele_57_3','GELE573_MASTER'},
                            {'StartLine2','Char1_6','f_siauliai_11_re','JOB_2_BARBARIAN_NPC'},
                            {'StartLine2','Char4_7','f_siauliai_15_re','JOB_2_DIEVDIRBYS_NPC'},
                            {'StartLine2','Char1_2','f_siauliai_16','JOB_2_HIGHLANDER_NPC'},
                            {'None','Char4_17','f_siauliai_16','DAOSHI_MASTER'},
                            {'None','Char4_12','d_thorn_22','CHAPLAIN_MASTER'},
                            {'StartLine1','Char1_10','f_rokas_24','JOB_RODELERO3_1_NPC'},
                            {'StartLine1','Char1_7','f_rokas_24','MASTER_CATAPHRACT'},
                            {'StartLine1','Char2_10','f_rokas_24','JOB_THAUMATURGE3_1_NPC'},
                            {'StartLine1','Char3_8','f_rokas_24','JOB_SCOUT3_1_NPC'},
                            {'StartLine1','Char3_6','f_rokas_24','JOB_WUGU3_1_NPC'},
                            {'None','Char1_8','f_rokas_27','JOB_CORSAIR4_NPC'},
                            {'StartLine1','Char2_11','f_rokas_27','JOB_WARLOCK3_1_NPC'},
                            {'StartLine1','Char4_6','f_rokas_27','JOB_SADU3_1_NPC'},
                            {'None','Char4_10','f_rokas_27','JOB_PARDONER4_1'},
                            {'None','Char2_8','f_remains_37','MASTER_CHRONO'},
                            {'None','Char3_14','f_remains_37','MASTER_FALCONER'},
                            {'None','Char3_11','f_remains_38','MASTER_FLETCHER'},
                            {'None','Char4_9','f_remains_38','JOB_MONK4_1'},
                            {'None','Char2_17','f_remains_38','RUNECASTER_MASTER'},
                            {'','Char1_5','f_pilgrimroad_51','JOB_CENT4_NPC'},
                            {'None','Char2_6','f_pilgrimroad_51','JOB_SORCERER4_1'},
                            {'None','Char3_10','f_pilgrimroad_51','MASTER_SCHWARZEREITER'},
                            {'None','Char1_14','f_pilgrimroad_51','MASTER_FENCER'},
                            {'None','Char3_15','f_flash_64','CANNONEER_MASTER'},
                            {'None','Char3_16','f_flash_64','MUSKETEER_MASTER'},
                            {'None','Char1_12','f_flash_64','MURMILO_MASTER'},
                            {'None','Char1_17','f_flash_64','LANCER_MASTER'},
                            {'None','Char1_13','f_tableland_28_1','SHINOBI_MASTER'},
                            {'None','Char4_18','p_cathedral_1','MIKO_MASTER'},
                            {'None','Char2_9','p_catacomb_1','JOB_NECRO4_NPC'},
                            {'None','Char1_15','f_remains_37_3','DRAGOON_MASTER'},
                            {'None','Char4_15','f_remains_37_3','KABBALIST_MASTER'},
                            {'None','Char3_7','f_remains_37_3','HACKAPELL_MASTER'},
                            {'None','Char3_17','f_remains_37_3','MERGEN_MASTER'},
                            {'None','Char4_16','f_pilgrimroad_48','INQUISITOR_MASTER'},
                            {'None','Char2_15','id_catacomb_38_2','WARLOCK_MASTER'},
                            {'None','Char2_16','id_catacomb_38_2','FEATHERFOOT_MASTER'},
                            {'None','Char2_14','f_bracken_63_2','SAGE_MASTER'},
                            {'None','Char4_14','f_remains_37_3','PLAGUEDOCTOR_MASTER'},
                            {'None','Char1_19','c_fedimian','MATADOR_MASTER'},
                            {'None','Char2_19','f_pilgrimroad_41_3','JOB_SHADOWMANCER_MASTER'},
                            {'None','Char3_18','f_farm_49_1','BULLETMARKER_MASTER'},
                            {'None','Char4_19','f_flash_64','ZEALOT_MASTER'},
                            {'None','Char1_20','f_gele_57_4','CHAR120_MASTER'},
                            {'None','Char2_20','c_Klaipe','ONMYOJI_MASTER'},
                            {'None','Char1_18','f_farm_47_1','RETIARII_MASTER'},
                            {'None','Char3_12','f_pilgrimroad_51','PIED_PIPER_MASTER'},
                            {'None','Char4_20','c_fedimian','EXORCIST_MASTER'}
                        }
    if pcjobinfo ~= nil then
        local targetIndex = 0
        if pcjobinfo.Rank <= 4 then
            local lineName = "StartLine1"
            if sObj.QSTARTZONETYPE == "StartLine2" then
                lineName = "StartLine2"
            end
            for i = 1, #masterNPCInfo do
                if masterNPCInfo[i][1] == lineName and masterNPCInfo[i][2] == pcjobinfo.ClassName then
                    targetIndex = i
                    break
                end
            end
        else
            for i = 1, #masterNPCInfo do
                if masterNPCInfo[i][2] == pcjobinfo.ClassName then
                    targetIndex = i
                    break
                end
            end
        end
        
        if targetIndex > 0 then
            local x, y, z
            local genCount = GetClassCount('GenType_'..masterNPCInfo[targetIndex][3])
            for i = 0, genCount -1 do
                local dialg = GetClassStringByIndex('GenType_'..masterNPCInfo[targetIndex][3], i, 'Dialog')
                if dialg == masterNPCInfo[targetIndex][4] then
                    local gentypeID = GetClassNumberByIndex('GenType_'..masterNPCInfo[targetIndex][3], i, 'GenType')
                    local achCount = GetClassCount('Anchor_'..masterNPCInfo[targetIndex][3])
                    for i2 = 0 , achCount - 1 do
                        if gentypeID == GetClassNumberByIndex('Anchor_'..masterNPCInfo[targetIndex][3], i2, 'GenType') then
                            x = GetClassNumberByIndex('Anchor_'..masterNPCInfo[targetIndex][3], i2, 'PosX')
                            y = GetClassNumberByIndex('Anchor_'..masterNPCInfo[targetIndex][3], i2, 'PosY')
                            z = GetClassNumberByIndex('Anchor_'..masterNPCInfo[targetIndex][3], i2, 'PosZ')
                            break
                        end
                    end
                    break
                end
            end
            if x ~= nil and y ~= nil and z ~= nil then
                local select = ShowSelDlg(pc, 0, 'ChangeJobToMasterMove', ScpArgMsg('Yes'), ScpArgMsg('No'))
                if select == 1 then
                    if isHideNPC(pc, masterNPCInfo[targetIndex][4]) == 'YES' then
                        UnHideNPC(pc, masterNPCInfo[targetIndex][4])
                    end
                    MoveZone(pc, masterNPCInfo[targetIndex][3], x, y, z)
                end
            end
        end
    end

    
    return

--	local tx = TxBegin(pc)
--	TxSetIESProp(tx, etc, "JobChanging", jobid);
--	local ret = TxCommit(tx);
--	
--	--랭크 제한있는 전직은 이걸 살리면 되고
--	--local ret2, re = SCR_QUEST_CHECK(pc, pcjobinfo[stringtest])
--	--랭크 제한 없는 전직은 이걸 살리면 된다.
--	
--	local ret2, re = SCR_QUEST_CHECK(pc, questName)
--
--	if ret2 ~= 'POSSIBLE' then
--		local tx = TxBegin(pc)
--		TxSetIESProp(tx, etc, "JobChanging", 0);
--		local ret = TxCommit(tx);
--
--		--print('ERROR! SCR_QUESCK_CHECK ~= POSSILBE : ',pcjobinfo[stringtest])
--		print('ERROR! SCR_QUESCK_CHECK ~= POSSILBE : ',questName)
--	end
--
--	SendProperty(pc, etc);	
--
--	SendAddOnMsg(pc, "START_JOB_CHANGE", "", 0);

end
