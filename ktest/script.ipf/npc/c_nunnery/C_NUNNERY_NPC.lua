function SCR_REQUEST_MISSION_ABBEY_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_SAALUS_NUNNERY')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_TUTO_SAALUS_NUNNERY')
        if GetZoneName(pc) == 'c_nunnery' then
            sObj.QuestInfoValue1 = 1
            COMMON_QUEST_HANDLER(self,pc)
        end
    elseif result == 'SUCCESS' then
        COMMON_QUEST_HANDLER(self,pc)
    else
        local etcObj = GetETCObject(pc);
    	if etcObj == nil then
    		return;
    	end
    
        local mission1 = GetClass('Indun','Request_Mission7')
    	local indunCount1 = etcObj["InDunCountType_" .. mission1.PlayPerResetType];
    	
    	if indunCount1 == nil then
    	    return
    	end
    
    	local maxPlayCnt = mission1.PlayPerReset;
    	if IsPremiumState(pc, ITEM_TOKEN) == 1 then
		maxPlayCnt = maxPlayCnt + mission1.PlayPerReset_Token;
    	end
    	
    	if indunCount1 > maxPlayCnt then
    		INDUN_REENTER_DIALOG(pc, mission1, "REQUEST_MISSION_ABBEY_SELECT1", "REQUEST_MISSION_ABBEY_CANCLE1", 1);
    		return;
    	end
    	
    	local empoweringLv = 0;
    	local empoweringBuff = GetBuffByName(pc, "Empowering_Buff");
    	if empoweringBuff ~= nil then
    		empoweringLv = GetBuffArg(empoweringBuff);
    	end
    	
    	if pc.Lv + empoweringLv < mission1.Level then
    	    ShowOkDlg(pc, 'REQUEST_MISSION_ABBEY_CANCLE2', 1)
    	    return
    	end
    	
    	local classCount = GetClassCount("Indun")
    	local missionList = {}
        for i = 0 , classCount -1 do
            local indunIES = GetClassByIndex("Indun", i)
            if indunIES.PlayPerResetType == mission1.PlayPerResetType and pc.Lv + empoweringLv >= indunIES.Level  then
                if indunIES.ClassName ~= 'Nunnery_Dummy' then
                    missionList[#missionList + 1] = indunIES
                end
            end
        end
        
        if #missionList <= 0 then
    		return;
    	end
        
    	local rand = IMCRandom(1, #missionList)
    	local indunName = missionList[rand].ClassName;
    	AUTOMATCH_INDUN_DIALOG(pc, 'REQUEST_MISSION_ABBEY_SELECT1', indunName, 1);
    
    end
end

function SCR_BLACKSMITH_ABBEY_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'BLACKSMITH_ABBEY_SELECT1', ScpArgMsg('BLACKSMITH_ABBEY_AGREE1'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
		FlushItemDurability(pc);
        SendAddOnMsg(pc, "OPEN_DLG_REPAIR", "", 0);
		REGISTERR_LASTUIOPEN_POS_SERVER(pc, "repair140731")
    end
end

function SCR_C_NUNNERY_NPC1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_UPHILL_DEFENSE')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_TUTO_UPHILL_DEFENSE')
        if GetZoneName(pc) == 'c_nunnery' then
            sObj.QuestInfoValue1 = 1
            COMMON_QUEST_HANDLER(self,pc)
        end

    elseif result == 'SUCCESS' then
        COMMON_QUEST_HANDLER(self,pc)

    else
        local selectMenu = ShowSelDlg(pc, 0, 'C_NUNNERY_NPC1_DLG1', ScpArgMsg("MISSION_UPHILL_JOIN"), ScpArgMsg("UPHILL_STORE"), ScpArgMsg("Close"));
        if selectMenu == 1 then
            local etcObj = GetETCObject(pc);
            if etcObj == nil then
               return;
            end
            
            local mission1 = GetClass('Indun','Request_Mission10')
            
            local indunCount1 = etcObj["InDunCountType_" .. mission1.PlayPerResetType];
            if indunCount1 == nil then
               return
            end
            
            local maxPlayCnt = mission1.WeeklyEnterableCount;
            if IsPremiumState(pc, ITEM_TOKEN) == 1 then
                maxPlayCnt = maxPlayCnt + mission1.PlayPerReset_Token
            end
            
            if indunCount1 > maxPlayCnt then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('CannotJoinIndunYet'), 10)
                return
            end
            
            INDUN_ENTER_DIALOG_AND_UI(pc, nil, 'Request_Mission10', 0, 0)
            --           AUTOMATCH_INDUN_DIALOG(pc, nil, 'Request_Mission10')

        elseif selectMenu == 2 then
            ExecClientScp(pc, "PVP_OPEN_POINT_SHOP()");

        else
            return;
        end
    end
end

function SCR_ENCHANTER_MASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_TUTO_UPHILL_DEFENSE_CHECK_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_UPHILL_DEFENSE')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_TUTO_UPHILL_DEFENSE')
        if GetZoneName(pc) == 'c_nunnery' then
            sObj.QuestInfoValue1 = 1
        end
	end
end 

function SCR_TUTO_SAALUS_NUNNERY_CHECK_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'TUTO_SAALUS_NUNNERY')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_TUTO_SAALUS_NUNNERY')
        if GetZoneName(pc) == 'c_nunnery' then
            sObj.QuestInfoValue1 = 1
        end
	end
end 
