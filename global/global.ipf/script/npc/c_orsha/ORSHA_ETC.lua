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
    
    local list = GetSummonedPetList(pc);
    if quest1 == "IMPOSSIBLE" and  #list >= 1 then
        local seldialog = { 'PETSHOP_ORSHA_basic1',
                            'PETSHOP_ORSHA_HQ1_BASICDLG1'
                          }
        local ran = IMCRandom(1, 2)
        local select = ShowSelDlg(pc, 0, seldialog[ran], vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], ScpArgMsg('Auto_DaeHwa_JongLyo'));
        
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
        end
    else
        local select = ShowSelDlg(pc, 0, 'PETSHOP_ORSHA_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], ScpArgMsg('Auto_DaeHwa_JongLyo'));
        
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
        end
    end
end