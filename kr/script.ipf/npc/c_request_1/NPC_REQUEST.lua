function SCR_QUEST_RANDOM_DROPITEM_REQUEST1_FUNC(pc,questname,subStrList)
    local result = IMCRandom(1, 10000);
    local itemClsName = "None";
    local itemCnt = 1;
    local pcLv = pc.Lv
    if pcLv > 185 then
        itemClsName = 'expCard10'
    elseif pcLv > 165 then
        itemClsName = 'expCard9'
    elseif pcLv > 135 then
        itemClsName = 'expCard8'
    else
        itemClsName = 'expCard7'
    end
    
    return itemClsName..':'..itemCnt
end

function SCR_DROPITEM_REQUEST1_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_REQUEST_MISSION')
    if result == 'PROGRESS' then
    local sObj = GetSessionObject(pc, 'SSN_TUTO_REQUEST_MISSION')
        if sObj.QuestInfoValue1 == 1 then
            if sObj.QuestInfoValue3 < 1 then
    	        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_TUTO_REQUEST_MISSION', 'QuestInfoValue3', 1)
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg03', 1)
            elseif sObj.QuestInfoValue3 == 1 then
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg03', 1)
        	end
        else
            ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg04', 1)
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_FEDIMIAN_BOARD_01_DIALOG(self, pc)
--    TreasureMarkByMap(pc, 'c_Klaipe',-576,240,704)
    ShowOkDlg(pc, 'RequestPosMoveDlg', 1)
end

function SCR_FEDIMIAN_BRANDON_01_DIALOG(self, pc)
    SCR_REQUEST_SELECT(self, pc)

end

function SCR_FEDIMIAN_ROTA_01_DIALOG(self, pc)
--    SCR_REQUEST_SELECT(self, pc)
    SCR_REQUEST_SELECT(self, pc)
end

function SCR_FEDIMIAN_ROTA_02_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_REQUEST_MISSION')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_TUTO_REQUEST_MISSION')
        if sObj.QuestInfoValue1 < 1 then
    	    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_TUTO_REQUEST_MISSION', 'QuestInfoValue1', 1)
            ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg01', 1)
        elseif sObj.QuestInfoValue1 == 1 then 
            ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg02', 1)
    	end
	else
        COMMON_QUEST_HANDLER(self,pc)
        local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char3_18');
        if IS_KOR_TEST_SERVER() then
            return
        elseif is_unlock == 'NO' then
        	local prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char3_18")
        	if prop < 10 then
        	    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
        	    if sObj == nil then
        	        local sel1 = ShowSelDlg(pc, 1, "CHAR318_MSETP1_QDLG1", ScpArgMsg("CHAR318_MSETP1_TXT1"), ScpArgMsg("CHAR318_MSETP1_TXT2"))
        	        if sel1 == 1 then
            	        ShowOkDlg(pc, "CHAR318_MSETP1_DLG1", 1)
            	        CreateSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
            	        return
        	        end
        	    else
        	        sObj.Step1 = sObj.Step1 +  1 --200
        	        if sObj.Step1 <= 10 then
        	            local sel2 = ShowSelDlg(pc, 1, "CHAR318_MSETP1_QDLG1", ScpArgMsg("CHAR318_MSETP1_TXT1"), ScpArgMsg("CHAR318_MSETP1_TXT2"))
        	            if sel2 == 1 then
        	                ShowOkDlg(pc, "CHAR318_MSETP1_DLG1", 1)
        	            end
        	        elseif sObj.Step1 <= 15 then
        	            local sel3 = ShowSelDlg(pc, 1, "CHAR318_MSETP1_QDLG2", ScpArgMsg("CHAR318_MSETP1_TXT3"), ScpArgMsg("CHAR318_MSETP1_TXT2"))
        	            if sel3 == 1 then
        	                ShowOkDlg(pc, "CHAR318_MSETP1_DLG2", 1)
        	            end
                    elseif sObj.Step1 < 30 then
        	            local sel4 = ShowSelDlg(pc, 1, "CHAR318_MSETP1_QDLG3", ScpArgMsg("CHAR318_MSETP1_TXT4"), ScpArgMsg("CHAR318_MSETP1_TXT2"))
        	            if sel4 == 1 then
        	                ShowOkDlg(pc, "CHAR318_MSETP1_DLG3", 1)
        	            end
        	        elseif sObj.Step1 >= 30 then
        	            ShowOkDlg(pc, "CHAR318_MSETP1_DLG4", 1)
        	            SCR_SET_HIDDEN_JOB_PROP(pc, "Char3_18", 40)
        	            UnHideNPC(pc, "BULLETMARKER_MASTER")
        	        end
        	    end
        	elseif prop == 40 then
        	    ShowOkDlg(pc, "CHAR318_MSETP1_DLG4", 1)
        	elseif prop == 60 then
                local sel5 = ShowSelDlg(pc, 1, "CHAR318_MSETP2_1_QDLG1", ScpArgMsg("CHAR318_MSETP2_1_TXT1"), ScpArgMsg("CHAR318_MSETP2_1_TXT2"))
                if sel5 == 1 then
                    ShowOkDlg(pc, "CHAR318_MSETP2_1_DLG2", 1)
                    local tx1 = TxBegin(pc);
                    local bullet_item = {
                                            'HIDDEN_BULLET_MSTEP2_1_ITEM1',
                                            'HIDDEN_BULLET_MSTEP2_1_ITEM2',
                                            'R_HIDDEN_BULLETMARKER_ITEM1',
                                            'R_HIDDEN_BULLETMARKER_ITEM2',
                                            'R_HIDDEN_BULLETMARKER_ITEM3',
                                        }
                    for i = 1, #bullet_item do
                        if GetInvItemCount(pc, bullet_item[i]) < 1 then
                            TxGiveItem(tx1, bullet_item[i], 1, 'Quest_HIDDEN_BULLETMARKER');
                        end
                    end
                    for j = 1, 5 do
                        if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ"..j) == "YES" then
                            UnHideNPC(pc, "CHAR318_MSETP3_1_OBJ"..j)
                        end
                        if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE"..j) == "YES" then
                            UnHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE"..j)
                        end
                    end
                    UnHideNPC(pc, "MSETP3_1_EFF_TACTICS1")
                    UnHideNPC(pc, "MSETP3_1_EFF_TACTICS2")
                    UnHideNPC(pc, "MSETP3_1_EFF_TACTICS3")
                    local ret = TxCommit(tx1);
                    if ret == "SUCCESS" then
                        SCR_SET_HIDDEN_JOB_PROP(pc, "Char3_18", 100)
                    else
                        print("tx FAIL!")
                    end
                end
        	elseif prop == 200 then
        	    local sel6 = ShowSelDlg(pc, 1, "CHAR318_MSETP4_1_QDLG1", ScpArgMsg("CHAR318_MSETP4_1_TXT1"), ScpArgMsg("CHAR318_MSETP4_1_TXT2"))
                if sel6 == 1 then
                    local isLockState = 0
                    ShowOkDlg(pc, "CHAR318_MSETP4_1_DLG2", 1)
                    local tx1 = TxBegin(pc);
                    local bullet_item = {
                                    'HIDDEN_BULLET_MSTEP3_ITEM1',
                                    'BULLETMARKER_QUEST_SKILL1',
                                    'BULLETMARKER_QUEST_SKILL2',
                                    'BULLETMARKER_QUEST_SKILL3',
                                    'HIDDEN_BULLET_MSTEP3_1_ITEM1',
                                    'HIDDEN_BULLET_MSTEP2_1_ITEM1',
                                    'HIDDEN_BULLET_MSTEP2_1_ITEM2',
                                    'HIDDEN_BULLET_MSTEP3_ITEM2',
                                    'HIDDEN_BULLET_MSTEP3_3ITEM2',
                                    'HIDDEN_BULLET_MSTEP3_3_1ITEM1',
                                    'R_HIDDEN_BULLETMARKER_ITEM1',
                                    'R_HIDDEN_BULLETMARKER_ITEM2',
                                    'R_HIDDEN_BULLETMARKER_ITEM3',
                                }
                    for i = 1, #bullet_item do
                        if GetInvItemCount(pc, bullet_item[i]) > 0 then
                            local invItem, cnt = GetInvItemByName(pc, bullet_item[i])
        					if IsFixedItem(invItem) == 1 then
        						isLockState = 1
        					end
                            TxTakeItem(tx1, bullet_item[i], GetInvItemCount(pc, bullet_item[i]), 'Quest_HIDDEN_BULLETMARKER');
                        end
                    end
                    for j = 1, 5 do
                        if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ"..j) == "NO" then
                            HideNPC(pc, "CHAR318_MSETP3_1_OBJ"..j)
                        end
                        if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE"..j) == "NO" then
                            HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE"..j)
                        end
                    end
                    HideNPC(pc, "MSETP3_1_EFF_TACTICS1")
                    HideNPC(pc, "MSETP3_1_EFF_TACTICS2")
                    HideNPC(pc, "MSETP3_1_EFF_TACTICS3")
                    local ret = TxCommit(tx1);
                    if ret == "SUCCESS" then
                        SCR_SET_HIDDEN_JOB_PROP(pc, "Char3_18", 200)
                    else
        				if isLockState == 1 then
        					SendSysMsg(pc, 'QuestItemIsLocked');
        				end
                        print("tx FAIL!")
                    end
                end
        	end
        end
    end
end

function SCR_FEDIMIAN_ROTA_02_NORMAL_1(self,pc)
	local prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char3_18")
	if prop < 10 then
	    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
	    if sObj == nil then
	        ShowOkDlg(pc, "CHAR318_MSETP1_DLG1", 1)
	        CreateSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
	        return
	    else
	        sObj.Step1 = sObj.Step1 +  1
	        if sObj.Step1 <= 10 then
	            ShowOkDlg(pc, "CHAR318_MSETP1_DLG1", 1)
	        elseif sObj.Step1 <= 100 then
	            ShowOkDlg(pc, "CHAR318_MSETP1_DLG2", 1)
            elseif sObj.Step1 <= 200 then
	            ShowOkDlg(pc, "CHAR318_MSETP1_DLG3", 1)
	            SCR_SET_HIDDEN_JOB_PROP(pc, "Char3_18", 20)
	        end
	    end
	end
end

function SCR_FEDIMIAN_ROTA_02_NORMAL_1_PRECHECK(pc)
	local prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char3_18")
	if prop < 10 then
	    return "YES"
    end
end

--function SCR_FEDIMIAN_ROTA_02_NORMAL_1(self,pc)
--	EVENT_1705_SCHWARZEREITER_NPC(self,pc)
--end

function SCR_PARTYMISSION_PROP_CHANGE(party, pc, className)
	ChangePartyProp(pc, PARTY_NORMAL, 'MissionAble', 1)
end

function SCR_PARTYQUEST_NPC_01_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_REQUEST_MISSION')
    if result == 'PROGRESS' then
    local sObj = GetSessionObject(pc, 'SSN_TUTO_REQUEST_MISSION')
        if sObj.QuestInfoValue1 == 1 then
            if sObj.QuestInfoValue2 < 1 then
    	        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_TUTO_REQUEST_MISSION', 'QuestInfoValue2', 1)
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg05', 1)
            elseif sObj.QuestInfoValue2 == 1 then 
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg05', 1)
        	end
        else
            ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg06', 1)
        end
    else
        local partyObj = GetPartyObj(pc)
        if partyObj ~= nil then
            if IsPartyLeaderPc(partyObj, pc) == 1 then
                local select = ShowSelDlg(pc, 0, 'PARTYQUEST_NPC_01_SELECT1', ScpArgMsg('PARTYQUEST_NPC_01_SEL1'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
                if select == 1 then
                    local ret1, ret2 = SCR_PARTYQUEST_RANDOM_CHECK(partyObj, pc, 'PartyQuest1')
                    if ret1 == 'YES' then
                    elseif ret2 == 2 then
                        ShowOkDlg(pc, 'PARTYQUEST_NPC_01_CANCLE2', 1)
                    elseif ret2 == 3 then
                        ShowOkDlg(pc, 'PARTYQUEST_NPC_01_CANCLE3', 1)
                    end
                end
            else
                ShowOkDlg(pc, 'PARTYQUEST_NPC_01_CANCLE4', 1)
            end
        else
            ShowOkDlg(pc, 'PARTYQUEST_NPC_01_CANCLE1', 1)
        end
    end
end

function SCR_MISSIONSHOP_NPC_01_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_REQUEST_MISSION')
    if result == 'PROGRESS' then
    local sObj = GetSessionObject(pc, 'SSN_TUTO_REQUEST_MISSION')
        if sObj.QuestInfoValue1 == 1 then
            if sObj.QuestInfoValue4 < 1 then
    	        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_TUTO_REQUEST_MISSION', 'QuestInfoValue4', 1)
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg07', 1)
            elseif sObj.QuestInfoValue4 == 1 then
                ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg07', 1)
        	end
        else
            ShowOkDlg(pc, 'TUTO_REQUEST_MISSION_dlg08', 1)
        end
    else
    	local etcObj = GetETCObject(pc);
    	if etcObj ~= nil then
            local selText1 = ScpArgMsg('REQUEST_MISSION_SEL1')
    --        local selText2 = ScpArgMsg('REQUEST_MISSION_SEL2')
    --        local selText3 = ScpArgMsg('REQUEST_MISSION_SEL3')
            local selText4 = ScpArgMsg('REQUEST_MISSION_SEL4')
            local selText5 = ScpArgMsg('REQUEST_MISSION_SEL5')
            local selText6 = ScpArgMsg('REQUEST_MISSION_SEL6')
    --        local bonusItem = 'Premium_Clear_dungeon_01'
    --        local selTextBonus = GetClassString('Item', bonusItem, 'Name')..' '
            
            local mission1 = GetClass('Indun','Request_Mission1')
    		local mission1MaxCnt = mission1.PlayPerReset;
            local indunCount1 = etcObj["InDunCountType_" .. mission1.PlayPerResetType];
    
    --    	local mission2 = GetClass('Indun','Request_Mission2')
    --        local indunCount2 = etcObj["InDunCountType_" .. mission2.PlayPerResetType];
    --		local mission2MaxCnt = mission2.PlayPerReset;
    --
    --    	local mission3 = GetClass('Indun','Request_Mission3')
    --        local indunCount3 = etcObj["InDunCountType_" .. mission3.PlayPerResetType];
    --		local mission3MaxCnt = mission3.PlayPerReset;
    
        	local mission4 = GetClass('Indun','Request_Mission4')
            local indunCount4 = etcObj["InDunCountType_" .. mission4.PlayPerResetType];
    		local mission4MaxCnt = mission4.PlayPerReset;
    
        	local mission5 = GetClass('Indun','Request_Mission5')
            local indunCount5 = etcObj["InDunCountType_" .. mission5.PlayPerResetType];
    		local mission5MaxCnt = mission5.PlayPerReset;
    
        	local mission6 = GetClass('Indun','Request_Mission6')
            local indunCount6 = etcObj["InDunCountType_" .. mission6.PlayPerResetType];
    		local mission6MaxCnt = mission6.PlayPerReset;
            
    		if IsPremiumState(pc, ITEM_TOKEN) == 1 then
			mission1MaxCnt = mission1MaxCnt + mission1.PlayPerReset_Token;
--			mission2MaxCnt = mission2MaxCnt + mission2.PlayPerReset_Token;
--			mission3MaxCnt = mission3MaxCnt + mission3.PlayPerReset_Token;
			mission4MaxCnt = mission4MaxCnt + mission4.PlayPerReset_Token;
			mission5MaxCnt = mission5MaxCnt + mission5.PlayPerReset_Token;
			mission6MaxCnt = mission6MaxCnt + mission6.PlayPerReset_Token;
    		end
    		
    		local empoweringLv = 0;
    		local empoweringBuff = GetBuffByName(pc, "Empowering_Buff");
    		if empoweringBuff ~= nil then
    			empoweringLv = GetBuffArg(empoweringBuff);
    		end
    		
        	if indunCount1 == nil or indunCount1 > mission1MaxCnt or pc.Lv + empoweringLv < mission1.Level then
                selText1 = nil
            end
        
    --    	if indunCount2 == nil or indunCount2 > mission2MaxCnt or pc.Lv + empoweringLv < mission2.Level then
    --            selText2 = nil
    --        end
    --    
    --    	if indunCount3 == nil or indunCount3 > mission3MaxCnt or pc.Lv + empoweringLv < mission3.Level then
    --            selText3 = nil
    --        end

    	if indunCount4 == nil or indunCount4 > mission4MaxCnt or pc.Lv + empoweringLv < mission4.Level then
            selText4 = nil
        end
    
    	if indunCount5 == nil or indunCount5 > mission5MaxCnt or pc.Lv + empoweringLv < mission5.Level then
            selText5 = nil
        end
    
    	if indunCount6 == nil or indunCount6 > mission6MaxCnt or pc.Lv + empoweringLv < mission6.Level then
            selText6 = nil
        end
            
    --        local sObj = GetSessionObject(pc, 'ssn_klapeda')
    --        local bonusItemCount = 0
    --        local sObjPropSet = {}
    --        if sObj == nil then
    --            selTextBonus = nil
    --        else
    --            local cCount = 0
    --            for i = 1, 6 do
    --                if sObj['REQUESTMISSION_CLEAR'..i] > 0 then
    --                    sObjPropSet[#sObjPropSet + 1] = {'ssn_klapeda', 'REQUESTMISSION_CLEAR'..i, 0}
    --                    cCount = cCount + 1
    --                end
    --            end
    --            if cCount < 3 then
    --                selTextBonus = nil
    --            elseif cCount >= 5 then
    --                bonusItemCount = 4
    --                selTextBonus = selTextBonus..ScpArgMsg('MISSION_UPHILL_MSG11','COUNT',4)
    --            elseif cCount >= 4 then
    --                bonusItemCount = 3
    --                selTextBonus = selTextBonus..ScpArgMsg('MISSION_UPHILL_MSG11','COUNT',3)
    --            elseif cCount >= 3 then
    --                bonusItemCount = 2
    --                selTextBonus = selTextBonus..ScpArgMsg('MISSION_UPHILL_MSG11','COUNT',2)
    --            end
    --        end
        
    --        if selText1 == nil and selText2 == nil and selText3 == nil and selText4 == nil and selText5 == nil and selText6 == nil and selTextBonus == nil then
    --        if selText1 == nil and selText2 == nil and selText3 == nil and selText4 == nil and selText5 == nil and selText6 == nil then
            if selText1 == nil and selText4 == nil and selText5 == nil and selText6 == nil then
                if pc.Lv < mission1.Level then -- or pc.Lv < mission2.Level or pc.Lv < mission3.Level then -- mission2??mission3??모두 주석처리 ?�어 ?�음
                    ShowOkDlg(pc, 'MISSIONSHOP_NPC_01_CANCLE2', 1)
                else
             	    ShowOkDlg(pc, 'MISSIONSHOP_NPC_01_CANCLE1', 1)
             	end
                return
            end
            
            local select = ShowSelDlg(pc, 0, 'MISSIONSHOP_NPC_01_SELECT1', selText1, selText4, selText5, selText6, ScpArgMsg('Auto_DaeHwa_JongLyo'))
    --        local select = ShowSelDlg(pc, 0, 'MISSIONSHOP_NPC_01_SELECT1', selText1, selText2, selText3, selText4, selText5, selText6, selTextBonus, ScpArgMsg('Auto_DaeHwa_JongLyo'))
            if select ~= nil then
                if select >= 1 and select <= 4 then
                    local indunList = {'Request_Mission1','Request_Mission4','Request_Mission5','Request_Mission6'}
        			AUTOMATCH_INDUN_DIALOG(pc, "MISSIONSHOP_NPC_01_SELECT2", indunList[select]);   
    --    		elseif select == 7 then
    --                GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, {{bonusItem,bonusItemCount}}, nil, nil, nil, 'REQUESTMISSION_BONUS', sObjPropSet)
        		end
            end
        end
    end
end
