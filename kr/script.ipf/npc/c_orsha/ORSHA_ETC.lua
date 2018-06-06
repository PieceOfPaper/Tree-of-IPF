function SCR_ORSHA_KEDORLA_BOARD01_DIALOG(self, pc)
    ShowOkDlg(pc, 'ORSHA_KEDORLA_BOARD01_BASIC01', 1)
end

function SCR_ORSHA_BLACKSMITH_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ORSHA_BLACKSMITH_NORMAL_1(self,pc)
	FlushItemDurability(pc);
    SendAddOnMsg(pc, "OPEN_DLG_REPAIR", "", 0);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "repair140731")
end

function SCR_ORSHA_BLACKSMITH_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Recipe', 5);
end

function SCR_ORSHA_BLACKSMITH_NORMAL_3(self,pc)
    SendAddOnMsg(pc, "DO_OPEN_MANAGE_GEM_UI", "", 0);
end

function SCR_ORSHA_BLACKSMITH_NORMAL_4(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 0, self);
end

function SCR_ORSHA_BLACKSMITH_NORMAL_5(self,pc)
	local NpcHandle = GetHandle(self);
	SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
    ShowCustomDlg(pc, 'appraisal', 5);
    
    DelExProp(pc, "APPRAISER_HANDLE");
end

function SCR_ORSHA_BLACKSMITH_NORMAL_6(self,pc)
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_2_DLG1", 1)
    ShowBalloonText(pc, "CHAR119_MSTEP3_2_PC_DLG1", 5)
    if  sObj.Goal2 < 1 then
        sObj.Goal2 = 1
        SaveSessionObject(pc, sObj)
    end
end

function SCR_ORSHA_BLACKSMITH_NORMAL_7(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19');
    local item = GetInvItemCount(pc, "HIDDEN_MINERAL_CMINE661_ITEM1")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_2_1_DLG1", 1)
    if sObj.Step2 < 1 then
        sObj.Step2 = 1
        sObj.Goal2 = 2
        SaveSessionObject(pc, sObj)
    end
    local tx = TxBegin(pc)
    TxTakeItem(tx, "HIDDEN_MINERAL_CMINE661_ITEM1", item, "Quest_HIDDEN_MATADOR")
    local ret = TxCommit(tx);
    if sObj.Step1 >= 1 and sObj.Step2 >= 1 and sObj.Step3 >= 1 and sObj.Step4 >= 1 then
        --print("sObj.Step1 : "..sObj.Step1.."/ ".."sObj.Step2 : "..sObj.Step2.."/ ".."sObj.Step3 : "..sObj.Step3.."/ ".."sObj.Step4 : "..sObj.Step4)
        if hidden_prop == 20 then
            --print(hidden_prop)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 60)
        end
    end
end

function SCR_ORSHA_BLACKSMITH_NORMAL_6_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local item = GetInvItemCount(pc, "HIDDEN_MINERAL_CMINE661_ITEM1")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step2 < 1 then
                if item < 2 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_ORSHA_BLACKSMITH_NORMAL_7_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local item = GetInvItemCount(pc, "HIDDEN_MINERAL_CMINE661_ITEM1")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step2 < 1 then
                if item >= 2 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_ORSHA_BLACKSMITH_NORMAL_8(self,pc)
    UIOpenToPC(pc, 'itemdecompose', 1)
end

function SCR_ORSHA_BLACKSMITH_NORMAL_9(self,pc)
    UIOpenToPC(pc, 'itemrandomreset', 1)
end

function SCR_ORSHA_EQUIPMENT_DEALER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_EAST_PREPARE_SUCC(self,pc)
    local select = ShowSelDlg(self, 0, 'Akalabeth_TUTO1', ScpArgMsg('Auto_MuKiLyu'), ScpArgMsg('Auto_BangeoKuLyu'), ScpArgMsg('Auto_Repair'), ScpArgMsg('Auto_JongLyo'))
    if select == 1 then
       ShowTradeDlg(self, 'Klapeda_Weapon', 5);
    elseif select == 2 then
       ShowTradeDlg(self, 'Klapeda_Armor', 5);
    end
end

function SCR_ORSHA_EQUIPMENT_DEALER_NORMAL_1(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Weapon', 5);
end

function SCR_ORSHA_EQUIPMENT_DEALER_NORMAL_2(self,pc)
	ShowTradeDlg(pc, 'Klapeda_Armor', 5);
end

function SCR_ORSHA_KEDORLA_MEMBER01_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LOWLV_GREEN_SQ_10')
    if result == "PROGRESS" then
        local select2 = ShowSelDlg(pc,0, 'LOWLV_GREEN_SQ_10_NPC3_1', ScpArgMsg("LOWLV_GREEN_SQ_10_MSG"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select2 == 1 then
            local sObj = GetSessionObject(pc, 'SSN_LOWLV_GREEN_SQ_10')
            ShowOkDlg(pc, 'LOWLV_GREEN_SQ_10_NPC3_2', 1)
            sObj.QuestInfoValue3 = 1
        end
    else
        local select = ShowSelDlg(pc,0, 'ORSHA_KEDORLA_MEMBER01_BASIC01', ScpArgMsg("ORSHA_STORY_SEL01"), ScpArgMsg("ORSHA_STORY_SEL02"))
        if select == 1 then
            ShowOkDlg(pc, 'ORSHA_KEDORLA_MEMBER01_BASIC02', 1)
        end
    end
end

function SCR_ORSHA_TOOL_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_EAST_PREPARE_SUCC(self)
    local select = ShowSelDlg(self, 0, 'Emilia_Select_1', ScpArgMsg('Auto_MiscShop'), ScpArgMsg('Auto_CashShop'), ScpArgMsg('Auto_JongLyo'))
     if select == 1 then
       ShowTradeDlg(self, 'Klapeda_Misc', 5);
    elseif select == 2 then
	   SendAddOnMsg(pc, "TP_SHOP_UI_OPEN", "", 0);
    end
    
    ShowOkDlg(self, 'EAST_PREPARE_COMP')
end

function SCR_ORSHA_TOOL_NPC_NORMAL_1(self,pc)
	ShowTradeDlg(pc, 'Orsha_Misc', 5);
end

function SCR_ORSHA_ACCESSARY_NPC_DIALOG(self, pc)
    if GetServerNation() == 'KOR' and GetServerGroupID() == 9001 then
        COMMON_QUEST_HANDLER(self, pc)
    else
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
        if hidden_prop == nil or hidden_prop == 0 then
            local rnd = IMCRandom(1, 20);
            if rnd < 3 then
    	        CHAR313_MSTEP1_1(pc, "CHAR313_MSTEP1_1_DLG2", "Step2")
            else
    	        COMMON_QUEST_HANDLER(self, pc)
    	    end
    	else
    	    COMMON_QUEST_HANDLER(self, pc)
    	end
    end
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_1(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Accessory', 1);
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_4(self,pc)
    ShowTradeDlg(pc, 'Klapeda_SilverCostume', 1);
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_2_PRE(pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_1")
    if quest == "PROGRESS" then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_3_PRE(pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_2")
    if quest == "PROGRESS" then
        return 'YES'
    end
    return 'NO'
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_2(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_1")
    if quest == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_APPRAISER5_1")
        local item_cnt = GetInvItemCount(pc, "JOB_APPRAISER5_1_ITEM2")
        if item_cnt < 1 then
            ShowOkDlg(pc, "JOB_APPRAISER5_1_NPC1", 1)
            RunScript('GIVE_ITEM_TX', pc, 'JOB_APPRAISER5_1_ITEM2', 1, "Quest_JOB_APPRAISER5_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("JOB_APPRAISER5_1_MSG3"), 4);
            sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
            SaveSessionObject(pc, sObj)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_1_MSG4"), 4);
        end
    end
end

function SCR_ORSHA_ACCESSARY_NPC_NORMAL_3(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "JOB_APPRAISER5_2")
    if quest == "PROGRESS" then
        local sObj = GetSessionObject(pc, "SSN_JOB_APPRAISER5_2")
        ShowOkDlg(pc, "JOB_APPRAISER5_1_NPC2", 1)
        local item_cnt1 = GetInvItemCount(pc, "JOB_APPRAISER5_1_ITEM2")
        local item_cnt2 = GetInvItemCount(pc, "JOB_APPRAISER5_2_ITEM2")
        if item_cnt2 >= 1 then
            RunScript('GIVE_TAKE_ITEM_TX', pc, nil, "JOB_APPRAISER5_1_ITEM2/1/JOB_APPRAISER5_2_ITEM2/1", "Quest_JOB_APPRAISER5_1")
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_2_MSG3"), 4);
            sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1;
            SaveSessionObject(pc, sObj)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_APPRAISER5_2_MSG4"), 4);
        end
    end
end


function SCR_ORSHA_PETSHOP_DIALOG(self,pc)
    AddHelpByName(pc, 'TUTO_PETSHOP')
    TUTO_PIP_CLOSE_QUEST(pc)
    local vel, hawk, hoglan;
    local quest1 = SCR_QUEST_CHECK(pc, "ORSHA_HQ2")
    local quest2 = SCR_QUEST_CHECK(pc, "ORSHA_HQ3")
    if quest1 == "POSSIBLE" or quest2 == "SUCCESS" then 
        COMMON_QUEST_HANDLER(self, pc)
    end
    if GetInvItemCount(pc, 'JOB_VELHIDER_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'JOB_VELHIDER_COUPON', 'Name')
        vel = itemLangName..ScpArgMsg('PetCouponExchange1')
    end
    if GetInvItemCount(pc, 'JOB_HOGLAN_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'JOB_HOGLAN_COUPON', 'Name')
        hoglan = itemLangName..ScpArgMsg('PetCouponExchange1')
    end
    if GetInvItemCount(pc, 'JOB_HAWK_COUPON') > 0 then
        local itemIES = GetClass('Item', 'JOB_HAWK_COUPON')
        if itemIES ~= nil then
            local cls = GetClass("Companion", itemIES.StringArg);
        	if nil == cls then
        		return;
        	end
        
        	if cls.JobID ~= 0 then 
        		local jobCls = GetClassByType("Job", cls.JobID);
        		if 0 < GetJobGradeByName(pc, jobCls.ClassName) then
        		    local itemLangName = GetClassString('Item', 'JOB_HAWK_COUPON', 'Name')
                    hawk = itemLangName..ScpArgMsg('PetCouponExchange1')
        		end
        	end
        end
    end
    
    local jobClassName, companionClassName = SCR_FREE_COMPANION_CHECK(self, pc)
    local jobFreeCompanionMsg = {}
    for i = 1, #jobClassName do
        jobFreeCompanionMsg[#jobFreeCompanionMsg + 1] = ScpArgMsg('FREE_COMPANION_MSG1','JOB', GetClassString('Job',jobClassName[i], 'Name'),'COMPANION',GetClassString('Monster',companionClassName[i], 'Name'))
    end
    
    local sObj = nil
    local hidden_Matador = nil
    if SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_19') == "NO" then
        local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
        if prop >= 20 then
            sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
            if sObj.Step3 < 1 or sObj.Goal3 < 1 then
                hidden_Matador = ScpArgMsg("CHAR119_MSTEP3_TXT9")
            end
        end
    end
    
    local list = GetSummonedPetList(pc);
    if quest1 == "IMPOSSIBLE" and  #list >= 1 then
        local seldialog = { 'PETSHOP_ORSHA_basic1',
                            'PETSHOP_ORSHA_HQ1_BASICDLG1'
                          }
        local ran = IMCRandom(1, 2)
        local select = ShowSelDlg(pc, 0, seldialog[ran], vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], hidden_Matador, ScpArgMsg('Auto_DaeHwa_JongLyo'));
        
        if select == 1 or select == 2 or select == 3 then
           local scp = string.format("TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(%d)", select);
    		ExecClientScp(pc, scp);
        elseif select == 4 then
            ShowTradeDlg(pc, 'Klapeda_Companion', 5);
        elseif select == 5 then			
			SetExProp(pc, 'PET_TRAIN_SHOP', 1);
            SendAddOnMsg(pc, "COMPANION_UI_OPEN", "", 0);
        elseif select == 6 then
            ShowOkDlg(pc, 'PETSHOP_ORSHA_basic2', 1)
        elseif select == 7 then
            SCR_FREE_COMPANION_CREATE(pc, companionClassName[1])
        elseif select == 8 then
            SCR_FREE_COMPANION_CREATE(pc, companionClassName[2])
        elseif select == 9 then
            ShowOkDlg(pc, "CHAR119_MSTEP3_3_DLG1", 1)
            ShowBalloonText(pc, "CHAR119_MSTEP3_3_PC_DLG1", 5)
            if  sObj.Goal3 < 1 then
                sObj.Goal3 = 1
                SaveSessionObject(pc, sObj)
                UnHideNPC(pc, "CHAR119_MSTEP3_3_1_NPC")
            end
        end
    else
        local select = ShowSelDlg(pc, 0, 'PETSHOP_ORSHA_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], hidden_Matador, ScpArgMsg('Auto_DaeHwa_JongLyo'));
        
        if select == 1 or select == 2 or select == 3 then
           local scp = string.format("TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(%d)", select);
    		ExecClientScp(pc, scp);
        elseif select == 4 then
            ShowTradeDlg(pc, 'Klapeda_Companion', 5);
        elseif select == 5 then
			SetExProp(pc, 'PET_TRAIN_SHOP', 1);
            SendAddOnMsg(pc, "COMPANION_UI_OPEN", "", 0);
        elseif select == 6 then
            ShowOkDlg(pc, 'PETSHOP_ORSHA_basic2', 1)
        elseif select == 7 then
            SCR_FREE_COMPANION_CREATE(pc, companionClassName[1])
        elseif select == 8 then
            SCR_FREE_COMPANION_CREATE(pc, companionClassName[2])
        elseif select == 9 then
            ShowOkDlg(pc, "CHAR119_MSTEP3_3_DLG1", 1)
            ShowBalloonText(pc, "CHAR119_MSTEP3_3_PC_DLG1", 5)
            if  sObj.Goal3 < 1 then
                sObj.Goal3 = 1
                SaveSessionObject(pc, sObj)
                UnHideNPC(pc, "CHAR119_MSTEP3_3_1_NPC")
            end
        end
    end
end

function SCR_ORSHA_MARKET_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'ORSHA_MARKET_SEL', ScpArgMsg('KLAPEDA_MARKET_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        ShowCustomDlg(pc, "market", 5);
		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"market")
    end
end

function SCR_ORSHA_WAREHOUSE_DIALOG(self, pc)
	WAREHOUSE_DIALOG_COMMON(self, pc, "ORSHA_WAREHOUSE_DLG");
end

function SCR_ORSHA_COLLECTION_SHOP_DIALOG(self, pc)
--    local ev160929 = nil 
--    local check, seaStep, seaCount, seaItem, nexonPC, nowYday = SCR_EV160929_CHECK(pc)
--    local itemCount
--    if check == 'YES' then
--        itemCount = seaCount + 1
--        if nexonPC == 'YES' then
--            itemCount = itemCount * 2
--        end
--        ev160929 = ScpArgMsg('EV160929_MSG1','ITEM',GetClassString('Item',seaItem,'Name'),'DAYCOUNT',seaCount+1,'COUNT',itemCount,'SEA',seaStep)
--    end
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg("HANGEUL_EVENT_MSG2"),ScpArgMsg('CHUSEOK_EVENT_MSG1'), msgBig, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg("COLLECTION_SHOP_PLAYTIME"), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('CHUSEOK_EVENT_MSG1'), msgBig, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ev160929, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'ORSHA_COLLECTION_SHOP_basic01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    if select == 1 then
--        SendAddOnMsg(pc, "COLLECTION_UI_OPEN", "", 0);
--		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"collection")
--	else select == 2 then
--	    local select2 = ShowSelDlg(pc, 0, 'COLLECT_REWARD_ITEM_CHECK', ScpArgMsg('YES'), ScpArgMsg('NO'))
--	    if select2 == 1 then
--	        
--	end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_ORSHA_COLLECTION_SHOP_NORMAL_1(self,pc)
    SendAddOnMsg(pc, "COLLECTION_UI_OPEN", "", 0);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"collection")
end


function SCR_ORSHA_COLLECTION_SHOP_NORMAL_2(self,pc)
    local select2 = ShowSelDlg(pc, 0, 'COLLECT_REWARD_ITEM_FLOANA', ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select2 == 1 then
        local col_List, col_Cnt = GetClassList("Collection")
        local aObj = GetAccountObj(pc)
        if col_Cnt ~= 0 then
            local i
            local list = {} -- Column l
            local reward_List = {}
            local reward_Index = {}
            local collection_Name
            for i = 1, col_Cnt do
                list[i] = GetClassByIndexFromList(col_List, i-1) 
                if IsCollectionVitality(pc, list[i].ClassName) == 1 then
                    local rewardItem = TryGetProp(list[i], "AccGiveItemList");
                    if rewardItem ~= "None" then
                        local accList = SCR_STRING_CUT(rewardItem) -- acclist = AccGiveItemList
                        if aObj[accList[1]] ~= accList[2] then
                            reward_Index[#reward_Index +1] = list[i].Name -- add list in collect name
                            reward_List[#reward_List +1] = list[i].ClassName -- add list in collect name
                        end
                    end
                end
            end
            if #reward_Index == 0 then
                ShowOkDlg(pc, "COLLECT_REWARD_ITEM_NOTHING_FLOANA")
            elseif #reward_Index ~= 0 then
                local j
                local sel
                for j = 0, math.floor(#reward_Index/10) do
                    if j ~= math.floor(#reward_Index/10) then
                        sel = ShowSelDlg(pc, 0, 'COLLECT_REWARD_CHOOSE_COLLECTION_FLOANA', reward_Index[10*j+1], reward_Index[10*j+2], reward_Index[10*j+3], reward_Index[10*j+4], reward_Index[10*j+5], reward_Index[10*j+6], reward_Index[10*j+7], reward_Index[10*j+8], reward_Index[10*j+9], reward_Index[10*j+10], ScpArgMsg('COLLECT_REWARD_ITEM_NEXT_PAGE'))
                        if sel < 11 then
                            collection_Name = reward_List[10*j+sel]
                        elseif sel == nil then
                            return
                        end
                    else
                        sel = ShowSelDlg(pc, 0, 'COLLECT_REWARD_CHOOSE_COLLECTION_FLOANA', reward_Index[10*j+1], reward_Index[10*j+2], reward_Index[10*j+3], reward_Index[10*j+4], reward_Index[10*j+5], reward_Index[10*j+6], reward_Index[10*j+7], reward_Index[10*j+8], reward_Index[10*j+9], reward_Index[10*j+10], ScpArgMsg('COLLECT_REWARD_END'))
                        if sel < 11 then
                            collection_Name = reward_List[10*j+sel]
                        elseif sel == nil then
                            return
                        end
                    end
                end
                if sel < 11 and sel ~= nil then
                    SCR_COLLECTION_REWARD_CHECK(self, pc, collection_Name)
                elseif j == math.floor(#reward_List/10) and sel2 == 11 then
                    return
                end
            end
        end
    end
end

--	elseif select == 2 then
--	    SCR_EV161215_SEED_NPC_DIALOG(self, pc)
--	elseif select == 2 then
--	    local dlgTable = {'ORSHA_EV160929_SUCC'}
--	    SCR_EV160929_GIVE(pc, dlgTable)
--	elseif select == 2 then
--        -- PLAYTIME_EVENT
--	    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP_OPEN()")
--    end
--	elseif select == 2 then
---- ALPHABET_EVENT
--	    local dlgTable = {'ORSHA_ALPHABET_EVENT_NONE','ORSHA_ALPHABET_EVENT_SELECT1', 'ORSHA_ALPHABET_EVENT_FULL'}
--	    SCR_GOLDKEY_EVENT_EXCHANGE(pc, dlgTable)
--	elseif select == 2 then
--        -- HANGEUL_EVENT
--	    local dlgTable = {'ORSHA_HANGEUL_EVENT_SELECT1','ORSHA_HANGEUL_EVENT_ERROR1'}
--	    SCR_HANGEUL_EVENT_EXCHANGE(pc, dlgTable)
--	elseif select == 2 then
--        -- CHUSEOK_EVENT
--	    local dlgTable = {'ORSHA_CHUSEOK_EVENT_SELECT1','ORSHA_CHUSEOK_EVENT_ERROR1','ORSHA_CHUSEOK_EVENT_ERROR2'}
--	    SCR_CHUSEOK_EVENT_EXCHANGE1(pc, dlgTable)
--	elseif select == 3 then
--        -- CHUSEOK_EVENT
--	    SCR_CHUSEOK_EVENT_EXCHANGE2(pc)
--    end
--end

function SCR_ORSHA_COLLECTION_SHOP_NORMAL_3(self,pc)
    ShowTradeDlg(pc, 'Magic_Society', 5);
end

function SCR_ORSHA_JOURNEY_SHOP_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_1(self, pc)
    local tiem = GetDBTime()
    local db_Day =string.format("%02d", tiem.wDay);
    if tonumber(db_Day) >= 1 and tonumber(db_Day) <= 10 then
        local now_time = os.date('*t')
        local Rank_Count_Time = now_time['min']
        if db_Day == "01" and Rank_Count_Time < 15 then
            local sel = ShowSelDlg(pc, 0, "RACIA_ADVENTUREBOOK_SEASON_COUNTING", ScpArgMsg("Yes"), ScpArgMsg("No"))
            if sel == 1 then
                REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
            else
                return
            end
        else
            local my_Rank, my_Point, ranker_cnt = GetLastAdventureBookRank(pc, "Initialization_point")
            local my_Item_Rank, my_Item_Point, item_ranker_cnt = GetLastAdventureBookRank(pc, "Item_Consume_point")
            --print("my_Point : "..my_Point)
            if my_Point <= 0 then
                REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                return
            end
            my_Rank = my_Rank + 1
            my_Item_Rank = my_Item_Rank + 1
            if my_Item_Rank == 1 and my_Item_Point > 0 then
                if 1 <= my_Rank and 300 >= my_Rank then
                    local sel = ShowSelDlg(pc, 0, "RACIA_ADVENTUREBOOK_REWARD_CHECK1", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local rank, cnt = GetClassList("AdventureBookRankReward")
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            if 1 == my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FirstHighRank", my_Item_Rank)
                            elseif 2 <= my_Rank and 10 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"HighRank", my_Item_Rank)
                            elseif 11 <= my_Rank and 100 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"ThirdRank", my_Item_Rank)
                            elseif 101 <= my_Rank and 200 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FourthRank", my_Item_Rank)
                            elseif 201 <= my_Rank and 300 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FifthRank", my_Item_Rank)
                            end
                        else
                            ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD2", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                elseif 0 == my_Rank or 300 < my_Rank then
                    local sel = ShowSelDlg(pc, 0, "RACIA_ADVENTUREBOOK_REWARD_CHECK2", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            local tx = TxBegin(pc);
                            TxAddAchievePoint(tx, "Journal_AP6", 10);
                            TxSetIESProp(tx, AccountObj, "AdventureBookRecvReward", 1)
                            local ret = TxCommit(tx);
                            if ret == 'FAIL' then
                                print("tx Fail")
                            elseif ret == 'SUCCESS' then
                                --AdventureBookRewardRankingMongoLog(pc, 'Journal_AP6', my_Item_Rank, itemClassNameList, itemCountList);
                            end
                        else
                            ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD3", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                end
            elseif my_Item_Rank > 1 or my_Item_Rank == 0 then
                if 1 <= my_Rank and 300 >= my_Rank then
                    local sel = ShowSelDlg(pc, 0, "RACIA_ADVENTUREBOOK_REWARD_CHECK", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local rank, cnt = GetClassList("AdventureBookRankReward")
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            if 1 == my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FirstHighRank")
                            elseif 2 <= my_Rank and 10 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"HighRank")
                            elseif 11 <= my_Rank and 100 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"ThirdRank")
                            elseif 101 <= my_Rank and 200 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FourthRank")
                            elseif 201 <= my_Rank and 300 >= my_Rank then
                                ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RACIA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FifthRank")
                            end
                        else
                            ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RACIA_ADVENTUREBOOK_REWARD2", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                else
                	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                    ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                end
            else
            	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
            end
        end
    else
    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
    end
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_2(self, pc)
    local mapList, mapSelList = SCR_JOURNAL_MAP_REWARD_CHECK(pc)
    if mapList ~= nil and  #mapList > 0 then
        local select = SCR_SEL_LIST(pc, mapSelList, 'ORSHA_JOURNEY_SHOP_NORMAL3_SELECT1', 1)
        if select ~= nil and select >= 1 and select <= #mapList then
            SCR_JOURNAL_MAP_REWARD_GIVE(pc, mapList, select)
        end
    else
        ShowOkDlg(pc, 'ORSHA_JOURNEY_SHOP_NORMAL3_NULL1', 1)
    end
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_3(self, pc)
    SCR_RANK8_EVENT(self,pc)
end


function SCR_ORSHA_JOURNEY_SHOP_NORMAL_4(self, pc)
    SCR_GUILD_BATTLE_WEEKLYPLAYREWARD(self,pc)
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_5(self, pc)
    SCR_GUILD_BATTLE_MASTERREWARD(self,pc)
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_6(self, pc)
    local txt1 = 'RACIA_ADVENTUREBOOK_REWARD_PRETRADE'
    local txt2 = 'RACIA_ADVENTUREBOOK_REWARD_TRADE1'
    local txt3 = 'RACIA_ADVENTUREBOOK_REWARD_YET\\'
    SCR_ADVENTURE_BOOK_COMPENIAN_TRADE(self, pc, txt1, txt2, txt3)
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_6_PRE(self)
    local ticket_arr = {"Companion_Exchange_Ticket",
                        "Companion_Exchange_Ticket2",
                        "Companion_Exchange_Ticket3",
                        "Companion_Exchange_Ticket4",
                        "Companion_Exchange_Ticket5",
                        "Companion_Exchange_Ticket6",
                        "Companion_Exchange_Ticket7",
                        "Companion_Exchange_Ticket8",
                        "Companion_Exchange_Ticket9"
                       }
    for i = 1, #ticket_arr do
        if SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_PRE(self, ticket_arr[i]) == 1 then
            return 'YES'
        end
    end
end

function SCR_ORSHA_NPC01_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ORSHA_MQ3_01')
    local result2 = SCR_QUEST_CHECK(pc, 'LOWLV_GREEN_SQ_10')
    if result2 == "PROGRESS" then
        local select2 = ShowSelDlg(pc,0, 'LOWLV_GREEN_SQ_10_NPC1_1', ScpArgMsg("LOWLV_GREEN_SQ_10_MSG"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select2 == 1 then
            local sObj = GetSessionObject(pc, 'SSN_LOWLV_GREEN_SQ_10')
            ShowOkDlg(pc, 'LOWLV_GREEN_SQ_10_NPC1_2', 1)
            sObj.QuestInfoValue1 = 1
        end
    elseif result1 == "COMPLETE" then
        local select1 = ShowSelDlg(pc,0, 'HT_ORSHA_NPC01_BASIC01', ScpArgMsg("HT_ORSHA_NPC01_SEL01"), ScpArgMsg("ORSHA_NPC01_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select1 == 1 then
            ShowOkDlg(pc, 'HT_ORSHA_NPC01_BASIC05', 1)
        elseif select1 == 2 then
            local select = ShowSelDlg(pc,0, 'ORSHA_NPC01_basic02', ScpArgMsg("Auto_KLAPEDA_NPC_04_S2"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S4"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S5"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S6"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S3"), ScpArgMsg("Auto_TteoNanDa"))
            if select == 1 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic03', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 2 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic04', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 3 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic05', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 4 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic06', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 5 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic07', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 6 then
                return
            end
        end
    else
        local select1 = ShowSelDlg(pc,0, 'ORSHA_NPC01_basic01', ScpArgMsg("ORSHA_NPC01_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select1 == 1 then
            local select = ShowSelDlg(pc,0, 'ORSHA_NPC01_basic02', ScpArgMsg("Auto_KLAPEDA_NPC_04_S2"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S4"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S5"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S6"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S3"), ScpArgMsg("Auto_TteoNanDa"))
            if select == 1 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic03', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 2 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic04', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 3 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic05', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 4 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic06', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 5 then
                ShowOkDlg(pc, 'ORSHA_NPC01_basic07', 1)
                ORSHA_NPC01_RUN(self, pc)
            elseif select == 6 then
                return
            end
        end
    end
end

function ORSHA_NPC01_RUN(self, pc)
    local select = ShowSelDlg(pc,0, 'ORSHA_NPC01_basic02', ScpArgMsg("Auto_KLAPEDA_NPC_04_S2"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S4"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S5"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S6"), ScpArgMsg("Auto_KLAPEDA_NPC_04_S3"), ScpArgMsg("Auto_TteoNanDa"))
    if select == 1 then
        ShowOkDlg(pc, 'ORSHA_NPC01_basic03', 1)
        ORSHA_NPC01_RUN(self, pc)
    elseif select == 2 then
        ShowOkDlg(pc, 'ORSHA_NPC01_basic04', 1)
        ORSHA_NPC01_RUN(self, pc)
    elseif select == 3 then
        ShowOkDlg(pc, 'ORSHA_NPC01_basic05', 1)
        ORSHA_NPC01_RUN(self, pc)
    elseif select == 4 then
        ShowOkDlg(pc, 'ORSHA_NPC01_basic06', 1)
        ORSHA_NPC01_RUN(self, pc)
    elseif select == 5 then
        ShowOkDlg(pc, 'ORSHA_NPC01_basic07', 1)
        ORSHA_NPC01_RUN(self, pc)
    elseif select == 6 then
    end
end



function SCR_ORSHA_NPC02_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ORSHA_MQ3_01')
    local result2 = SCR_QUEST_CHECK(pc, 'LOWLV_GREEN_SQ_10')
    if result2 == "PROGRESS" then
        local select2 = ShowSelDlg(pc,0, 'LOWLV_GREEN_SQ_10_NPC2_1', ScpArgMsg("LOWLV_GREEN_SQ_10_MSG"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select2 == 1 then
            local sObj = GetSessionObject(pc, 'SSN_LOWLV_GREEN_SQ_10')
            ShowOkDlg(pc, 'LOWLV_GREEN_SQ_10_NPC2_2', 1)
            sObj.QuestInfoValue2 = 1
        end
    elseif result1 == "COMPLETE" then
        local sel1 = ShowSelDlg(pc,0, 'HT_ORSHA_NPC02_BASIC01', ScpArgMsg("HT_ORSHA_NPC02_SEL01"), ScpArgMsg("ORSHA_NPC02_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if sel1 == 1 then        
            local sel2 = ShowSelDlg(pc,0, 'HT_ORSHA_NPC02_BASIC02', ScpArgMsg("HT_ORSHA_NPC02_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
            if sel2 == 1 then
                ShowOkDlg(pc, 'HT_ORSHA_NPC02_BASIC03', 1)
            end
        elseif sel1 == 2 then
            ShowOkDlg(pc, 'ORSHA_NPC02_basic03', 1)
        end
    else
        local select1 = ShowSelDlg(pc,0, 'ORSHA_NPC02_basic01', ScpArgMsg("ORSHA_NPC02_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
        if select1 == 1 then
            local select = ShowSelDlg(pc,0, 'ORSHA_NPC02_basic02', ScpArgMsg("ORSHA_NPC02_SEL02"), ScpArgMsg("Auto_SinKyeongSseuJi_anNeunDa"))
            if select == 1 then
                ShowOkDlg(pc, 'ORSHA_NPC02_basic03', 1)
            end
        end
    end
end



function SCR_ORSHA_NPC03_DIALOG (self, pc)
    ShowOkDlg(pc, 'ORSHA_NPC03_basic01', 1) 
end


function SCR_ORSHA_BOOK01_DIALOG (self, pc)
    local select = ShowSelDlg(pc,0, 'ORSHA_BOOK01_basic01', 
    ScpArgMsg("ORSHA_NPC03_SEL01"), 
    ScpArgMsg("ORSHA_NPC03_SEL02"), 
    ScpArgMsg("ORSHA_NPC03_SEL03"), 
    ScpArgMsg("ORSHA_NPC03_SEL04"), 
    ScpArgMsg("Auto_KeuMan_DunDa"))
    if select == 1 then
         ShowBookItem(pc, 'ORSHA_BOOK_evil');      
    elseif select == 2 then
         ShowBookItem(pc, 'ORSHA_BOOK_dadan');      
    elseif select == 3 then
         ShowBookItem(pc, 'ORSHA_BOOK_ashak');     
    elseif select == 4 then
         ShowBookItem(pc, 'ORSHA_BOOK_raima');      
    elseif select == 5 then
        return
    end
end



function SCR_ORSHA_BOOK02_DIALOG (self, pc)
    local select = ShowSelDlg(pc,0, 'ORSHA_BOOK02_basic01', 
    ScpArgMsg("ORSHA_NPC03_SEL05"), 
    ScpArgMsg("ORSHA_NPC03_SEL06"), 
    ScpArgMsg("ORSHA_NPC03_SEL07"), 
    ScpArgMsg("ORSHA_NPC03_SEL08"), 
    ScpArgMsg("ORSHA_NPC03_SEL09"), 
    ScpArgMsg("Auto_KeuMan_DunDa"))
    if select == 1 then
         ShowBookItem(pc, 'ORSHA_BOOK_monster');      
    elseif select == 2 then
         ShowBookItem(pc, 'ORSHA_BOOK_alchemist');      
    elseif select == 3 then
         ShowBookItem(pc, 'ORSHA_BOOK_hydra');     
    elseif select == 4 then
         ShowBookItem(pc, 'ORSHA_BOOK_orsha');     
    elseif select == 5 then
         ShowBookItem(pc, 'Hayravern_book01'); 
    elseif select == 6 then
        return
    end
end

function SCR_ORSHA_TOOL_NPC_NORMAL_2_PRE(pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop == 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step5 == 1 then
                if sObj.Goal5 >= 1 and sObj.Goal5 <= 5 then
                    return 'YES'
                end
            end
        end
    end
end

function SCR_ORSHA_TOOL_NPC_NORMAL_2(self,pc)
    --ONMYOJI_HIDDEN
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_20')
    if prop >= 10 then
        local sObj = GetSessionObject(pc, "SSN_JOB_ONMYOJI_MISSION_LIST")
        if sObj ~= nil then
            if sObj.Step5 == 1 then
                if sObj.Goal5 == 1 then
                    local sel = ShowSelDlg(pc, 1, "CHAR220_MSETP2_3_DLG3", ScpArgMsg("CHAR220_MSETP2_QUEST_OK_MSG"), ScpArgMsg("CHAR220_MSETP2_QUEST_NO_MSG"))
                    if sel == 1 then
                        sObj.Goal5 = 2
                        SaveSessionObject(pc, sObj)
                        ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG3_1", 1)
                        return
                    end
                elseif sObj.Goal5 == 2 then
                    local max_cnt = 50
                    local cnt = GetInvItemCount(pc, "CHAR220_MSTEP2_3_ITEM2")
                    if cnt >= max_cnt then
                        sObj.Goal5 = 5
                        SaveSessionObject(pc, sObj)
                        local cnt_else = GetInvItemCount(pc, "CHAR220_MSTEP2_3_ITEM1")
                        if cnt_else > 0 then
                            RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_3_ITEM1", cnt_else, "CHAR220_MSTEP2_3");
                        end
                        RunScript('TAKE_ITEM_TX', pc, "CHAR220_MSTEP2_3_ITEM2", cnt, "CHAR220_MSTEP2_3");
                        ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG5", 1)
                    else
                        ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG4", 1)
                    end
                else
                    ShowOkDlg(pc, "CHAR220_MSETP2_3_DLG6", 1)
                end
            end
        end
    end
end

function SCR_ORSHA_JOURNEY_SHOP_NORMAL_7(self, pc)

    local list, cnt = SCR_JOURNEY_QUEST_REWARD_CHECK(pc)
    if list ~= nil and #list > 0 then
        local select = SCR_SEL_LIST(pc, cnt, 'ORSHA_JOURNEY_SHOP_NORMAL7_SELECT1', 1)
        if select ~= nil and select >= 1 and select <= #list then
            SCR_JOURNEY_QUEST_REWARD_GIVE(self, pc, list, select)
        end
    else
        ShowOkDlg(pc, 'ORSHA_JOURNEY_SHOP_NORMAL7_NULL1', 1)
    end
    
end