function SCR_BLACKSMITH_DIALOG(self,pc,isQuest)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_TUTO_REPAIR_NPC_ENTER(self, pc)
	if 1 == IsDummyPC(pc) then
		return;
	end

    AddHelpByName(pc, "TUTO_NPC_REPAIR")
end

function SCR_BLACKSMITH_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Recipe', 5);
end

function SCR_BLACKSMITH_NORMAL_1(self,pc)
	FlushItemDurability(pc);
    SendAddOnMsg(pc, "OPEN_DLG_REPAIR", "", 0);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "repair140731")
end

function SCR_BLACKSMITH_NORMAL_3(self,pc)
    SendAddOnMsg(pc, "DO_OPEN_MANAGE_GEM_UI", "", 0);
end

function SCR_BLACKSMITH_NORMAL_4(self, pc)
    SHOW_ITEM_TRANCEND_UI(pc, 'itemtranscend', 5, 0, self);
end

function SCR_BLACKSMITH_NORMAL_5(self,pc)
	local NpcHandle = GetHandle(self);
	SetExProp(pc, "APPRAISER_HANDLE", NpcHandle);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"appraisal")
    ShowCustomDlg(pc, 'appraisal', 5);
    
    DelExProp(pc, "APPRAISER_HANDLE");
end

function SCR_BLACKSMITH_NORMAL_6(self,pc)    
    UIOpenToPC(pc, 'itemdecompose', 1)
end

function SCR_BLACKSMITH_NORMAL_7(self,pc)
    UIOpenToPC(pc, 'itemrandomreset', 1)
end

function SCR_BLACKSMITH_NORMAL_8(self,pc)
    UIOpenToPC(pc, 'briquetting', 1)
end

function SCR_USE_ITEM_COMPANION_EXCHANGE(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	-- 펫 교환권으로 다른 펫을 받을수 있었음. 그래서 argList 안쓸거임. 바로 패치할 수 있도록 클라코드는 그대로두고 서버만 수정.

	local itemCls =	GetClass("Item", invItem.ClassName);
	if itemCls == nil then
		return;
	end

	local monCls =	GetClass("Monster", itemCls.StringArg);
	local petType = monCls.ClassID;

	-- 디폴트로 클라페다.
	local npcTexture= 'PetCouponExchange2';
	local mapCls = GetMapProperty(self);
	
	if mapCls ~= nil and 'c_orsha' == mapCls.ClassName then
		npcTexture = 'PetCouponExchange2_ORSHA';
	end
	
	 local input = ShowTextInputDlg(self, 0, npcTexture)
     if input == '' or nil == input then
         return
	  end
     
	 if string.find(input, ' ') ~= nil then
         SysMsg(self, 'Instant', ScpArgMsg('NameCannotIncludeSpace'))
         return
     end

     local badword = IsBadString(input)
     if badword ~= nil then
         SysMsg(self, 'Instant', ScpArgMsg('{Word}_FobiddenWord','Word',badword))
         return
     end
	 
	if stringfunction.IsValidCharacterName(input) == false then
		SysMsg(self, 'Instant', ScpArgMsg('CompanionNameIsInvalid'))
		return;
	end

    local tx = TxBegin(self);
	TxTakeItemByObject(tx, invItem, 1, "PetShop");
    TxAdoptPet(tx, petType, input);	
    local ret = TxCommit(tx);
       
    if ret == "SUCCESS" then
    	if haveCompanion == nil then
    		if IsFullBarrackLayerSlot(self) == 1 then
				ExecClientScp(self, "PET_ADOPT_SUC_BARRACK()");
			else
				ExecClientScp(self, "PET_ADOPT_SUC()");
			end
    	else
    		ExecClientScp(self, "PET_ADOPT_SUC_BARRACK()");
    	end
    end
end

function SCR_PETSHOP_KLAIPE_DIALOG(self,pc)
    AddHelpByName(pc, 'TUTO_PETSHOP')
    TUTO_PIP_CLOSE_QUEST(pc)
    local vel, hawk, hoglan;
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
    
    local select = ShowSelDlg(pc, 0, 'PETSHOP_KLAIPE_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), jobFreeCompanionMsg[1], jobFreeCompanionMsg[2], ScpArgMsg('Auto_DaeHwa_JongLyo'));
--    local select = ShowSelDlg(pc, 0, 'PETSHOP_KLAIPE_basic1', vel, hawk, hoglan, ScpArgMsg('shop_companion'), ScpArgMsg('shop_companion_learnabil'), ScpArgMsg('shop_companion_info'), ScpArgMsg('Auto_DaeHwa_JongLyo'));
    if select == 1 or select == 2 or select == 3 then
		local scp = string.format("TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(%d)", select);
		ExecClientScp(pc, scp);
	elseif select == 4 then -- 분양, 아이템 구입
        ShowTradeDlg(pc, 'Klapeda_Companion', 5);
    elseif select == 5 then -- 훈련
		SetExProp(pc, 'PET_TRAIN_SHOP', 1);
        SendAddOnMsg(pc, "COMPANION_UI_OPEN", "", 0);
    elseif select == 6 then -- 좋은 점에 대하여
        ShowOkDlg(pc, 'PETSHOP_KLAIPE_basic2', 1)
    elseif select == 7 then
        SCR_FREE_COMPANION_CREATE(pc, companionClassName[1])
    elseif select == 8 then
        SCR_FREE_COMPANION_CREATE(pc, companionClassName[2])
    end
    
end

function SCR_FREE_COMPANION_CHECK(self, pc)
    local jobClassName = {}
    local companionClassName = {}
    local jobList = {{'Char3_7','Velhider'},{'Char1_7','Velhider'},{'Char3_2','Velhider'},{'Char3_10','Velhider'},{'Char3_14','pet_hawk'}}
    local list = GET_PET_LIST(pc)
    local myPetList = {}
    if list ~= nil and #list > 0 then
    	for i=1, #list do
    		local clsName, name, level = GET_PET_BY_INDEX(list, i)
    		myPetList[#myPetList + 1] = clsName
    	end
    end
    for i = 1, #jobList do
        if GetJobGradeByName(pc, jobList[i][1]) > 0 then
            if table.find(myPetList, jobList[i][2]) == 0 then
                if table.find(companionClassName, jobList[i][2]) == 0 then
                    jobClassName[#jobClassName + 1] = jobList[i][1]
                    companionClassName[#companionClassName + 1] = jobList[i][2]
                end
            end
        end
    end
    return jobClassName, companionClassName
end

function SCR_FREE_COMPANION_CREATE(pc, companionClassName)
    local aObj = GetAccountObj(pc)
    local barrackMaxSlot = GetBarrackMaxExpandableSlotCount(pc) + GetClassNumber('BarrackMap', GetClassByType('Map', aObj.SelectedBarrack).ClassName , 'BaseSlot')
    local barrackCurrentSlot = GetCurrentBarrackBuySlotCount(pc) + GetClassNumber('BarrackMap', GetClassByType('Map', aObj.SelectedBarrack).ClassName , 'BaseSlot')
    local barrackCurrentObject = GetCurrentBarrackCharPetCount(pc)
    
    if barrackMaxSlot ==  barrackCurrentObject then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('SeasonServerMaxCharCount'), 10) 
        return
    elseif barrackCurrentSlot == barrackCurrentObject and barrackMaxSlot > barrackCurrentSlot then
        ExecClientScp(pc, 'TRY_CHECK_BARRACK_SLOT()')
        return
    end
    
    local petCls = GetClass("Companion", companionClassName)
	if nil == petCls then
		return;
	end

    local jobCls = GetClassByType("Job", petCls.JobID);
	if petCls.JobID ~= 0 then 
		if 0 == GetJobGradeByName(pc, jobCls.ClassName) then
			return;
		end
	end

	local monCls = GetClass("Monster", petCls.ClassName);

	if nil == monCls then
		return;
	end
	local text = ScpArgMsg("InputCompanionName") .. "*@*" .. ScpArgMsg("InputCompanionName");
	local input = ShowTextInputDlg(pc, 0, text)
	if input == '' or nil == input then
--		SysMsg(pc, 'Instant', ScpArgMsg('NameCannotIncludeSpace'))
		return
	end
  
	if string.find(input, ' ') ~= nil then
		SysMsg(pc, 'Instant', ScpArgMsg('NameCannotIncludeSpace'))
		return
	end
	
	local badword = IsBadString(input)
	if badword ~= nil then
		SysMsg(pc, 'Instant', ScpArgMsg('{Word}_FobiddenWord','Word',badword))
		return
	end

	if stringfunction.IsValidCharacterName(input) == false then
		SysMsg(pc, 'Instant', ScpArgMsg('WrongPartyName'))
		return;
	end

	local haveCompanion = GetSummonedPet(pc, petCls.JobID);
	
	local tx = TxBegin(pc);
	TxAdoptPet(tx, monCls.ClassID, input);
	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

	if haveCompanion == nil then
		if IsFullBarrackLayerSlot(pc) == 1 then
			ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
		else
			ExecClientScp(pc, "PET_ADOPT_SUC()");
		end
	else
		ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
	end
end

function SCR_PETSHOP_KLAIPE_PET_DIALOG(self,pc)
    local animList = {'pet','skl_Hakkapelle','skl_impaler_raise','skl_impaler_throw'}
    local rand = IMCRandom(1, #animList)
    PlayAnim(self, animList[rand])
    
end
