function SCR_GOLD_FISH_STATUE_DIALOG(self, pc)
    local userLv = TryGetProp(pc, "Lv")
    local needSilver = 10000 + (userLv * 100)    

    
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    if aObj == nil then
        return;
    end
    
    local serverBuffCount = 0;
    if IsRequiredIndunDailyReset(aObj.GOLD_STATUE_FIRST_DATA) == 0 then
		serverBuffCount = 1;
	end

    -- 주인인 캐릭터와 다이얼로그 분할 하도록 --
    local firstRankerAID = GetExProp_Str(self, 'STATUE_AID');    
    local isFirstRanker = false;
    local select = 0;
    if GetPcAIDStr(pc) == firstRankerAID then -- 1등이 말 걸었을 때
        isFirstRanker = true;
        select = ShowSelDlg(pc, 0, 'FISHING_STATUE_DLG1', ScpArgMsg('FISHING_STATUE_WORSHIP', "needSilver", GET_COMMAED_STRING(needSilver)),  ScpArgMsg('FISHING_STATUE_OWNER_WORSHIP','serverBuffCount',serverBuffCount) ,ScpArgMsg("Close"));
    else -- 1등도 아닌 것들
        select = ShowSelDlg(pc, 0, 'FISHING_STATUE_DLG1', ScpArgMsg('FISHING_STATUE_WORSHIP', "needSilver", GET_COMMAED_STRING(needSilver)), ScpArgMsg("Close"));
    end
     
    if select == 1 then       
        local haveSilver = GetInvItemCount(pc, 'Vis')
        if haveSilver ~= nil and haveSilver >= needSilver then
            local tx = TxBegin(pc);
                TxTakeItem(tx, 'Vis', needSilver, "FISHING_STATUE_WORSHIP");
                AddBuff(self, pc, 'STATUE_LOOTINGCHANCE')
            local ret = TxCommit(tx);
            if ret ~= "SUCCESS" then
                return;
            end
        else
            SendSysMsg(pc, "Auto_SilBeoKa_BuJogHapNiDa.");
            return;
        end
    elseif select == 2 then
        if isFirstRanker == true then
            
			if IsRequiredIndunDailyReset(aObj.GOLD_STATUE_FIRST_DATA) == 0 then
				SendSysMsg(pc, "YouAlreadyUseStatueBuff");
				return;
			end
		
			select = ShowSelDlg(pc, 0, 'FISHING_STATUE_DLG2', ScpArgMsg('FISHING_STATUE_OWNER_WORSHIP_1'),ScpArgMsg("FISHING_STATUE_OWNER_WORSHIP_2"),ScpArgMsg("FISHING_STATUE_OWNER_WORSHIP_3"),ScpArgMsg("Close"));
            
			if select == 4 then
				return;
			end

            local buffValue = 0;

			local tx = TxBegin(pc);      
			local nextResetTime = GetNextIndunDailyResetTime();
		    TxSetIESProp(tx, aObj, "GOLD_STATUE_FIRST_DATA", nextResetTime);
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
				if select == 1 then
					RunFishRubbingBuff(pc, 7200, "None", 1)
		        elseif select == 2 then
					RunFishRubbingBuff(pc, 2400, "None", 2)
				elseif select == 3 then
					RunFishRubbingBuff(pc, 1200, "None", 3)
	            end
            end
        end
    end
end

function TEST_STATUE_LEAVE_SCP(mon, killer)
    testStatueLeaveLog()
end