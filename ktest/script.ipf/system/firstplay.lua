function FIRSTPLAY(pc)
    local etc = GetETCObject(pc);
	
	--etcObject의 FirstPlay는 캐릭터 생성 시, 1로 변경해준다.
    if etc.FirstPlay == 1 then
        local hp = pc.MHP;
        local sp = pc.MSP;
        local sta = pc.MaxSta;
        AddHP(pc, hp);
        AddSP(pc, sp);
        AddStamina(pc, sta);
		--레벨업 시간을 저장 (안에서 tx 돌린다.)
        TX_SET_LEVEL_UP_TIME(pc, etc);
		TX_CHANGE_FIRSTPLAY_VALUE(pc, etc, 2)
    end

	--헤어 정보 저장
	if etc.FirstPlay == 2 then
		if true ~= TX_HIAR_INFO(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 2")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 2");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 2");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 3 then
		if true ~= TX_DEFAUL_JOB_SKILL_INFO(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 3")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 3");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 3");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 4 then
		if true ~= TX_DEFAUL_HAVE_ITEM(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 4")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 4");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 4");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 5 then
		if true ~= TX_CREATE_SESSION_OBJECT(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 5")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 5");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 5");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 6 then
		if true ~= TX_FIRST_PLAY_EVENT_SCRIPT(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 6")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 6");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 6");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 7 then
		if true ~= TX_MEDAL_DATE(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 7")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 7");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 7");
			--로그아웃을 시킨다.
			return;
		end
	end

	if etc.FirstPlay == 8 then
		if true ~= TX_START_LOCATION(pc, etc) then
			TransferLogin(pc, "FIRSTPLAY 8")
			--IMC_NORMAL_INFO("FIRSTPLAY ERROR LOG - 8");
			IMC_LOG("INFO_NORMAL", "FIRSTPLAY ERROR LOG - 8");
			--로그아웃을 시킨다.
			return;
		end
	end

	TX_FIRST_PLAY_END(pc, etc)
	SaveLocation(pc);
	SendSharedMsg(pc, "MAIN_SOBJ_ADD");
	SCR_KEYBOARD_TUTORIAL(pc)
	RunScript('SCR_FIRSTPLAY_SET_CHAT_MACRO_DEFAULT', pc)

end

function SCR_FIRSTPLAY_KEYBOARD_TUTORIAL(pc)
    sleep(3000)
    SendAddOnMsg(pc, "KEYBOARD_TUTORIAL", "", 0);
end

function SCR_FIRSTPLAY_SET_CHAT_MACRO_DEFAULT(pc)
	SendAddOnMsg(pc, "SET_CHAT_MACRO_DEFAULT", "", 0);	
end

function TX_HIAR_INFO(pc, etcObject)
	local tx = TxBegin(pc);
	if pc.HairType ~= GetHeadIndex(pc) then
		TxSetIESProp(tx, pc, 'HairType', GetHeadIndex(pc));
	end

	TxSetIESProp(tx, etcObject, "HairUseTime", GetCurDateString());
	TxSetIESProp(tx, etcObject, 'FirstPlay', 3);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function TX_DEFAUL_JOB_SKILL_INFO(pc, etcObject)
	local tx = TxBegin(pc);
	local aobj = GetAccountObj(pc);
	local rh = GetEquipItem(pc, 'RH');
	local jobObj = GetClass("Job", pc.JobName);
	local defHaveVan = jobObj.DefHaveSkillVan;
	
	if defHaveVan ~= "None" then
		local jobName = pc.JobName;
		local list = GET_CLS_GROUP("SkillTree", jobName);
		local arglist = {};	
		arglist[1] = jobObj.ClassID
		for i = 1 , #list do
			local sklTreeCls = list[i];
			if sklTreeCls.ClassName == defHaveVan then
				arglist[i+1] = 1;	
			else
				arglist[i+1] = 0;
			end
		end
				
		if 1 ~= SCR_TX_SKILL_UP(pc, arglist, 1, tx) then
			TxRollBack(tx);
			return false;
		end
	end

	--스킬 포인트를 1개 준다.
	TxAddSkillPts(tx, 1);
	--기본으로 배우고 있어야 할 어빌리티 올려줌.
	local abilList = StringSplit(jobObj.DefHaveAbil, '#');
	for i = 1 , #abilList do
		if abilList[i] ~= 'None' then		
			local abil = GetAbility(pc, abilList[i])
			if nil == abil then
				TxAddAbility(tx, abilList[i]);
			end
		end
	end

	TxSetIESProp(tx, etcObject, 'FirstPlay', 4);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function TX_DEFAUL_HAVE_ITEM(pc, etcObject)
	local tx = TxBegin(pc);
	for i = 1, 7 do
		if GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i) ~= 'None' then
			TxGiveItem(tx, GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i), GetClassNumber('Job', pc.JobName, 'DefaultHaveItemCount' .. i), "DefaultItem");
		end
	end

	TxSetIESProp(tx, etcObject, 'FirstPlay', 5);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		for i = 1, 6 do		
			if GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i) ~= 'None' then
				if GetClassNumber('Job', pc.JobName, 'DefaultHaveItemQuickSlot'..i) ~= 0 then
					RegisterQuickSlot(pc, "Item", GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i), GetClassNumber('Job', pc.JobName, 'DefaultHaveItemQuickSlot'..i));
				end
			end
		end
		
		return true;
	else
		return false;
	end
end

function TX_CREATE_SESSION_OBJECT(pc, etcObject)
	local tx = TxBegin(pc);

	TxCreateSessionObject(tx, "ssn_klapeda", 1);
	TxCreateSessionObject(tx, "ssn_drop", 1);
	TxCreateSessionObject(tx, "SSN_MAPEVENTREWARD", 1);
	TxCreateSessionObject(tx, "ssn_smartgen", 1);
	TxCreateSessionObject(tx, "ssn_raid", 1);
	TxCreateSessionObject(tx, "SSN_DIALOGCOUNT", 1);
	TxCreateSessionObject(tx, "SSN_REQUEST", 1);
	TxCreateSessionObject(tx, "ssn_shop", 1);
	TxCreateSessionObject(tx, "SSN_EXPCARD_USE", 1);

	TxSetIESProp(tx, etcObject, 'FirstPlay', 6);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function TX_START_LOCATION(pc, etcObject)
	local tx = TxBegin(pc);
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local startzonevalue = nil;
	if sObj ~= nil then
		startzonevalue = 'StartLine1'
		if GetZoneName(pc) == 'f_siauliai_16' then
			startzonevalue = 'StartLine2'
			TxSetIESProp(tx, sObj, 'WARP_F_SIAULIAI_16', 300)
		else
			TxSetIESProp(tx, sObj, 'WARP_F_SIAULIAI_WEST', 300)
		end
		TxSetIESProp(tx, sObj, 'QSTARTZONETYPE', startzonevalue)		
	else
		TxRollBack(tx);
		return false;
	end
	
	TxSetIESProp(tx, etcObject, 'FirstPlay', 7);
	
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		--시작도시 로깅용
		LogSessionObject(pc, sObj, "ChangeProp", "StartLineSet", "QSTARTZONETYPE", startzonevalue);
		return true;
	else
		return false;
	end
end

function TX_FIRST_PLAY_EVENT_SCRIPT(pc, etcObject)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local tx = TxBegin(pc);

	local GroupID = GetServerGroupID()
	if (GetServerNation() == 'KOR' and GetServerGroupID() == 9001) then
		TxGiveItem(tx, 'Kupole_TestServer_Pack', 1, 'Kupole_TestServer_Pack');
	end

	TxSetIESProp(tx, etcObject, 'FirstPlay', 7);
	
	TxSetIESProp(tx, sObj, 'EVENT_1706_FREE_RANKRESET_REWARD', 1);
	
	if GetServerNation() == 'KOR' then
    	TxSetIESProp(tx, sObj, 'EVENT_1803_NEWCHARACTER_CHECK', 1)
    end

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function TX_MEDAL_DATE(pc, etcObject)
	local tx = TxBegin(pc);
	
	local aobj = GetAccountObj(pc);
	if aobj.Medal < tonumber(MAX_FREE_TP) and aobj.Medal_Get_Date == "None" then 
		local nextTime = GetAddDataFromCurrent(CHARGE_FREE_TP_TIME);
		TxSetIESProp(tx, aobj, 'Medal_Get_Date', nextTime);
	end

	TxSetIESProp(tx, etcObject, 'FirstPlay', 8);
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function SCR_KEYBOARD_TUTORIAL(pc)
	local cnt = GetAccountPCCount(pc);
	local flag = 0
	for i = 0 , cnt - 1 do
		local job, level = GetAccountPCByIndex(pc, i);
		if level >= 2 then
			flag = 1
			break
		end
	end
    
	if flag == 0 then
		RunScript('SCR_FIRSTPLAY_KEYBOARD_TUTORIAL', pc)
	end
end

function TX_FIRST_PLAY_END(pc, ectObject)
	local tx = TxBegin(pc);

	TxSetIESProp(tx, ectObject, 'FirstPlay', 0);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end

function TX_CHANGE_FIRSTPLAY_VALUE(pc, ectObject, value)
	local tx = TxBegin(pc);

	TxSetIESProp(tx, ectObject, 'FirstPlay', value);

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		return true;
	else
		return false;
	end
end