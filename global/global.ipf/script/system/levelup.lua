function FIRSTPLAY(pc)
	
	local etc = GetETCObject(pc);

	if etc.FirstPlay == 1 then
		local hp = pc.MHP;
		local sp = pc.MSP;
		local sta = pc.MaxSta;
		AddHP(pc, hp);
		AddSP(pc, sp);
		AddStamina(pc, sta);

		TX_SET_LEVEL_UP_TIME(pc, etc);
		local tx = TxBegin(pc);
		if pc.HairType ~= GetHeadIndex(pc) then
			TxSetIESProp(tx, pc, 'HairType', GetHeadIndex(pc));
		end

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

			if 0 == SCR_TX_SKILL_UP(pc, arglist, 1, tx) then
				TxRollBack(tx);
				return;
			end
		
		end	
		TxAddSkillPts(tx, 1);
		local abilList = StringSplit(jobObj.DefHaveAbil, '#');
		for i = 1 , #abilList do
			if abilList[i] ~= 'None' then
				TxAddAbility(tx, abilList[i]);
			end
		end


		for i = 1, 7 do
			if GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i) ~= 'None' then

				TxGiveItem(tx, GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i), GetClassNumber('Job', pc.JobName, 'DefaultHaveItemCount' .. i), "DefaultItem");
			end
		end

	
		TxSetIESProp(tx, etc, 'FirstPlay', 2);
		TxSetIESProp(tx, etc, "HairUseTime", GetCurDateString());
		TxCreateSessionObject(tx, "ssn_klapeda", 1);
		TxCreateSessionObject(tx, "ssn_drop", 1);
		TxCreateSessionObject(tx, "SSN_MAPEVENTREWARD", 1);
		TxCreateSessionObject(tx, "ssn_smartgen", 1);
		TxCreateSessionObject(tx, "ssn_raid", 1);
		TxCreateSessionObject(tx, "SSN_DIALOGCOUNT", 1);
		TxCreateSessionObject(tx, "SSN_REQUEST", 1);
		TxCreateSessionObject(tx, "ssn_shop", 1);
		TxCreateSessionObject(tx, "SSN_EXPCARD_USE", 1);
	
--		-- 161215 ??? ĳ???? ?????? ???? ????
--		
--		TxGiveItem(tx, '161215Event_NewChar', 1, "161215Event_NewChar");

-- ??? ???? ?????? ???? ????
  local GroupID = GetServerGroupID()
	if ( GetServerNation() == 'KOR' and GetServerGroupID() == 9001 ) then
    TxGiveItem(tx, 'Kupole_TestServer_Pack', 1, 'Kupole_TestServer_Pack');
  end
-- ??? ???? ?????? ???? ????

		if aobj.Medal < tonumber(MAX_FREE_TP) and aobj.Medal_Get_Date == "None" then 
			local nextTime = GetAddDataFromCurrent(CHARGE_FREE_TP_TIME);
			TxSetIESProp(tx, aobj, 'Medal_Get_Date', nextTime);
		end
	
		local ret = TxCommit(tx);
    
		SaveLocation(pc);
		SendSharedMsg(pc, "MAIN_SOBJ_ADD");


		for i = 1, 6 do		
			if GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i) ~= 'None' then
				if GetClassNumber('Job', pc.JobName, 'DefaultHaveItemQuickSlot'..i) ~= 0 then
					RegisterQuickSlot(pc, "Item", GetClassString('Job', pc.JobName, 'DefaultHaveItem' .. i), GetClassNumber('Job', pc.JobName, 'DefaultHaveItemQuickSlot'..i));
				end
			end
		end

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
			RunScript('SCR_FIRSTPLAY_KEYBOARD_TUTORIAL',pc)
		end

		RunScript('SCR_FIRSTPLAY_SET_CHAT_MACRO_DEFAULT',pc)
	end


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
		TxSetIESProp(tx, etc, 'FirstPlay', 0);
	else
		TxRollBack(tx);
		return;
	end
	local ret = TxCommit(tx);

	if ret == 'SUCCESS' then
		--??????? ?????
		LogSessionObject(pc, sObj, "ChangeProp", "StartLineSet", "QSTARTZONETYPE", startzonevalue);
	end
--Steam Retention EVENT
	local year, month, day, hour, min = GetAccountCreateTime(pc)
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	if GetServerNation() ~= 'GLOBAL' then
        return
    end
	if (month >= 3 and day >= 28) or (month >= 4 and day >= 1) and year == 2017 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, "Event_Guide_Cube_1", 19, "RETENTION_EVENT")
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ12', sObj.EVENT_VALUE_SOBJ12 + 1)
        local ret = TxCommit(tx)
	end
--Steam Retention EVENT
end
