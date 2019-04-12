
function SCR_ORSHA_PETSHOP_DIALOG(self,pc)
    AddHelpByName(pc, 'TUTO_PETSHOP')
    TUTO_PIP_CLOSE_QUEST(pc)
    local vel, hawk, hoglan;
    if GetInvItemCount(pc, 'JOB_VELHIDER_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'JOB_VELHIDER_COUPON', 'Name')
        vel = itemLangName..ScpArgMsg('PetCouponExchange1')
    end
    if GetInvItemCount(pc, 'steam_JOB_HOGLAN_COUPON') > 0 then
        local itemLangName = GetClassString('Item', 'steam_JOB_HOGLAN_COUPON', 'Name')
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
    local select = ShowSelDlg(pc, 0, 'PETSHOP_ORSHA_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companionItem'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), ScpArgMsg('Auto_DaeHwa_JongLyo'));
    
    if select == 1 or select == 2 or select == 3 then
       local scp = string.format("TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(%d)", select);
		ExecClientScp(pc, scp);
	elseif select == 4 then
	    ShowCustomDlg(pc, "companionshop", 5, "Normal");
    elseif select == 5 then
        ShowTradeDlg(pc, 'Klapeda_Companion', 5);
    elseif select == 6 then
        SendAddOnMsg(pc, "COMPANION_UI_OPEN", "", 0);
    elseif select == 7 then
        ShowOkDlg(pc, 'PETSHOP_ORSHA_basic2', 1)
    elseif select == 8 then
        return 0
        
    end
    
end