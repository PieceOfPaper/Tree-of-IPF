function AOSSpeedup1(pc)
	AddBuff(self,self,'MoveSpeed_Always',2,0,0)
end

function AOSSpeedup2(pc)
	SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_iDongSogDoKa_PpalLaJim"), 2);
end


function delAOSSpeedup1(pc)
	RemoveBuff(pc, 'MoveSpeed_Always');
end


function ImmortalSpirit1(pc)
	AddBuff(pc, pc, "ImmortalSpirit", 1, 0, 0, 1);
end

function ImmortalSpirit2(pc)
	SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_BangeoLyeogi_JeungKaHam"), 2);
end


function delImmortalSpirit1(pc)
	RemoveBuff(pc, 'ImmortalSpirit');

end

function BurstOut1(pc)
	AddBuff(pc, pc, "BurstOut", 5, 0, 0, 1);

end

function BurstOut2(pc)
	SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_KongKyeogLyeogi_KeuKe_olLaKam"), 2);
end


function delBurstOut1(pc)
	RemoveBuff(pc, 'BurstOut');

end


function EMPHASIZE_SKILLVAN(pc)

	UIEmphasize(pc, "focus_ui", "sysmenu", "skillvan", "skillvan", 0);
	-- sysmenu???????? skillvan ??????? ???????. - skillvan???????? ?????? ????

end

function PC_WIKI_KILLMON(pc, mon, checkOtherPc)
	if IsPVPServer(pc) == 1 then
		return;
	end
	if GetZoneName(pc) == 'mission_abbey_uphill' then
	    return
	end
	local monID = mon.ClassID;    
    local monJournal = TryGetProp(mon, 'Journal');    
    if monJournal ~= nil and monJournal ~= 'None' then    
        if IsExistMonsterInAdevntureBook(pc, monID) == 'NO' then    
            local journalCls = GetClass('Monster', monJournal);
            ALARM_ADVENTURE_BOOK_NEW(pc, journalCls.Name);    
        end    
        AddAdventureBookMonKillCount(pc, monID, 1);    
    end
	
	if true ~= checkOtherPc then
		return;
	end
	
	local pcList, cnt = GET_PARTY_ACTOR(pc, 500);
	-- ????????? ????????? (??????/?????)???¡?? ??????? ?????
	-- ???????(0?? ????? ???) ???? ???? ?????? ??? ???????? ????? ????? ????????.
	-- etc prop???? u?????? ?????.  ?????? ??????wiki???? ???? ?д?.
	if GetLayer(pc) ~= 0 and mon.MonRank == 'Boss' then
		pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc));
	end

	if nil == pcList or cnt <= 0 then
		return;
	end
	
	for i=1, cnt do
		local pcActor = pcList[i];
		if pcActor ~= nil then
			if IsSameActor(pcActor, pc) == "NO" then
				-- ???? ?????? monsternpc_fsm.cpp 112 ????
				PC_WIKI_KILLMON(pcActor, mon, false);
			end
		end
	end
end

function PC_WIKI_GETITEM(pc, itemType, giveWay, itemCnt)
    if geItemTable.IsMoney(itemType) == true then
        return;
    end

	local itemCls = GetClassByType("Item", itemType);
	if itemCls.Journal == "FALSE" then
		return;
	end
	
	local monsterID = tonumber(giveWay);
	if monsterID == nil and giveWay ~= "Auction" and giveWay ~= "Buy" and giveWay ~= "Cheat" 
		and giveWay ~= "Recipe" 
		and giveWay ~= "Manufacture" 
		and giveWay ~= "RaidAward" 
		and giveWay ~= "Exchange" 
		and giveWay ~= "GemRemove" 
		and giveWay ~= "GetCabinetItem"
		and giveWay ~= "PersonalShop"
		and giveWay ~= "GACHA_CUBE"
		and giveWay ~= "NpcShop"
		then
			return;
	end

    if monsterID ~= nil then    
        if IsExistItemInAdventureBook(pc, itemCls.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(pc, itemCls.Name);
        end
        AddAdventureBookItemObtainCount(pc, itemType, 'Drop', itemCnt);
        AddAdventureBookMonDropInfo(pc, monsterID, itemType, itemCnt);
    elseif giveWay == 'Recipe' or giveWay == 'Manufacture' then
        if IsExistItemInAdventureBook(pc, itemCls.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(pc, itemCls.Name);
        end
        AddAdventureBookItemObtainCount(pc, itemType, 'Craft', itemCnt);
    elseif giveWay == 'GACHA_CUBE' then
        if IsExistItemInAdventureBook(pc,itemCls.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(pc, itemCls.Name);
        end
        AddAdventureBookItemObtainCount(pc, itemType, 'Cube', itemCnt);
    end
end

function SCR_COMMON_SHOP_LIST(pc)
    if true then
        IMC_LOG('ERROR_LOGIC', 'SCR_COMMON_SHOP_LIST: Some Bad guy try to open PC_Shop! cid['..GetPcCIDStr(pc)..']');
        return;
    end
	  --ShowTradeDlg(pc, 'PC_Shop', 5);
--    local main_sObj = GetSessionObject(pc, 'ssn_klapeda')
--	if main_sObj.SHOP_Klapeda_Misc == 300 then		
--	    ShowTradeDlg(pc, 'Klapeda_Misc', 5);
--	else
--	    SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_DeungLogDoen_JeugSeogSangJeomi_eopSeupNiDa{nl}DoKuSangineKe_JeugSeogSangJeomeul_DeungLogHaSiMyeon_HwaMyeon_uCheug_'JeugSeogSangJeom(O)'Leul_TongHaeSeo_BaLo_SayongHaSil_Su_issSeupNiDa"), 10);
--	end
end 

function TX_CHANGE_PC_HAIRCOLOR(pc, hairColorName)
	
	local etc = GetETCObject(pc)
	local nowAllowedColor = etc['AllowedHairColor'];
	
	 -- AllowedHairColor가 이상하게 덮어씌워질 수 있으므로, HairColor 프로퍼티로도 검사
	if TryGetProp(etc, "HairColor_"..hairColorName) ~= 1 then
		return;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, etc, 'CurHairColorName', hairColorName);
	
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
        InvalidateStates(pc); -- CurHairColorName만 설정하고 이 함수를 부르면 가발 착용 유무에 따라 적용된다.
    end
end

function GET_HAIR_INDEX(gender, engHairName, hairColorName)
	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(gender);
	local Selectclasslist = Selectclass:GetSubClassList();
	local listCount = Selectclasslist:Count();
	
	for i=0, listCount do
		local cls = Selectclasslist:GetByIndex(i);
		if cls ~= nil then
			if engHairName == imcIES.GetString(cls, 'EngName') and hairColorName == imcIES.GetString(cls, 'ColorE') then
				return i + 1;
			end
		end
	end

	return 0;
end

-- ????? ????
function SCR_CHANGE_HAIRCOLOR_1(self) -- ??????
	RunScript("TX_CHANGE_PC_HAIRCOLOR", self, 'black')
end

function SCR_CHANGE_HAIRCOLOR_2(self) -- ?????
	RunScript("TX_CHANGE_PC_HAIRCOLOR", self, 'blue')
end

function SCR_CHANGE_HAIRCOLOR_3(self)	-- ?????
	RunScript("TX_CHANGE_PC_HAIRCOLOR", self, 'pink')
end

function SCR_CHANGE_HAIRCOLOR_4(self)	-- ???
	RunScript("TX_CHANGE_PC_HAIRCOLOR", self, 'white')
end

function SCR_ROLLBACK_HAIRCOLOR(self)	-- ??
	RunScript("TX_CHANGE_PC_HAIRCOLOR", self, 'default')
end

function TX_CHANGE_HAIRINDEX(pc, hairIndex, engHairName, colorName)
	local etc = GetETCObject(pc)
	if etc['FirstPlay'] ~= 0 or engHairName == 'None' or colorName == 'None' then
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end
	
	TxEnableInIntegrateIndun(tx);
	TxChangePcHead(tx, hairIndex);
	TxSetIESProp(tx, etc, 'CurHairName', engHairName);
	
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SCR_UPDATE_EQUIP_DUMMY(pc)
	end
end

function TX_SET_LEVEL_UP_TIME(pc, etc)
	local tx = TxBegin(pc);	
	TxEnableInIntegrateIndun(tx);
	if etc["LevelUPTime"] ~= GetCurDateString() then
		TxSetIESProp(tx, etc, "LevelUPTime", GetCurDateString());
	end
	local ret = TxCommit(tx);
end
