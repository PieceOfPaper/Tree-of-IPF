
function callback_learn_guild_ability(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            LEARN_GUILD_ABILITY(pc, tonumber(argList[1]))
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function callback_guild_exp_up(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end    
    if ret_json == 'True' then
        if pc ~= nil then
            RunScript("GUILD_EXP_UP", pc, argList[1], tonumber(argList[2]));
        end        
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function SCR_PC_CMD(pc, cmd, arg1, arg2, arg3, arg4)

	if cmd == "/cp" then
		PartyCreate(pc, arg1);
		return 1;
	elseif cmd == '/changePVPObserveTarget' then
		SCR_MCY_CHANGE_SELECT_OBSERVER(pc, arg1);
		return 1;
	elseif cmd == "/sendMasterEnter" then
		local partyObj = GetGuildObj(pc);
		if nil == partyObj then
			return 0;
		end
		local isLeader = IsPartyLeaderPc(partyObj, pc);
		if 1 ~= isLeader then
			return 0;
		end
		local partyID = GetGuildID(pc);
		local msg = ScpArgMsg("MasterStartGuildBattle");
		BroadcastToPartyMember(PARTY_GUILD, partyID, msg, "{@st55_a}");
		return 1;
	elseif cmd == "/retquest" then
        if IsJoinColonyWarMap(pc) == 1 then
            return 0;
        end
        
		if IsPVPServer(pc) == 1 then
			SendSysMsg(pc, "CantUseThisInIntegrateServer");
			return 0;
		end
		local isSit = IsRest(pc);
		if 1 == isSit then
			return 0;
		end

		local questIES = GetClassByType("QuestProgressCheck", arg1);
		if questIES == nil then
			return 0;
		end
		
		local mapName, x, y, z = GET_QUEST_RET_POS(pc, questIES)
		if mapName == nil then
			return 0;
		end
		
		MoveZone(pc, mapName, x, y, z, 'QuestEnd');
		return 1;
	elseif cmd == "/reqpartyquest" then
		if IsPVPServer(pc) == 1 then
			SendSysMsg(pc, "CantUseThisInIntegrateServer");
			return 0;
		end

		local fid = arg1;
		local questIES = GetClassByType("QuestProgressCheck", arg2);
		if questIES == nil then
			return 0;
		end

		local partyObj = GetPartyObj(pc);
		if partyObj == nil or arg3 == nil then
			return 0;
		end
		local memberObj = GetMemberObj(partyObj, arg3);
		if memberObj == nil then
			return 0;
		end

		-- arg3에서 npc 스테이트를 보내는게 아니라, 멤버의 이름을 보내서 멤버의 퀘스트 상태를 대신 체크할 수 있게 변경했습니다.
		if questIES.ClassID ~= memberObj.Shared_Quest then
			return 0;
		end
		local result = GET_PROGRESS_STRING_BY_VALUE(memberObj.Shared_Progress);
		if result ~= 'POSSIBLE' and result ~= 'SUCCESS' and result ~= 'PROGRESS' then
			return 0;
		end
		local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
		local mapName, x, y, z = GET_QUEST_RET_POS(pc, questIES, questnpc_state);
		if mapName == nil then
			return 0
		end
		MoveZone(pc, mapName, x, y, z, 'QuestEnd');
		return 1;
	elseif cmd == "/intewarp" then

		local nowposx,nowposy,nowposz = Get3DPos(pc);
		local etc = GetETCObject(pc);
		local mapname, x, y, z, uiname = GET_LAST_UI_OPEN_POS(etc)

		if mapname == nil then
			return 0;
		end

		if uiname ~= 'worldmap' or GET_2D_DIS(x,z,nowposx,nowposz) > 100 or GetZoneName(pc) ~= mapname then
			IMC_LOG("INFO_NORMAL","[warp fail log] uiname:"..uiname.." distance:" .. GET_2D_DIS(x,z,nowposx,nowposz) .. " pczone:"..GetZoneName(pc).." mapname:"..mapname);
			return 0;
		end

		local movezoneClassID = arg1;
		doPortal(pc,movezoneClassID, 0, arg2, "None");

		return 1;

	elseif cmd == "/intewarpByItem" then		

		if arg1 == nil or arg2 == nil or arg3 == nil then
			return;
		end

		local movezoneClassID = arg1;
		local warpToItemUsedPos = arg2;
		local itemname = arg3;

		local warpscrolllistcls = GetClass("warpscrolllist", itemname);
		if warpscrolllistcls == nil then
			return;
		end

        if IsJoinColonyWarMap(pc) == 1 then
            return;
        end
		
		doPortal(pc, movezoneClassID, 1, warpToItemUsedPos, itemname);
		return 1;

	elseif cmd == "/pethire" then
		SCR_ADOPT_COMPANION(pc, arg1, arg2);
		return 1;
	elseif cmd == "/petstat" then
		PET_STAT_UP_SERV(pc, arg1, arg2, arg3);
		return 1;
	elseif cmd == "/pmp" then	
		local partyObj = GetPartyObj(pc, arg1);
		local my = GetMemberObj(partyObj, GetTeamName(pc));
		local to = GetMemberObj(partyObj, arg2);
		
		if my == nil or to == nil then
			return 0;
		end		
		
		if IsPartyLeaderPc(partyObj, pc) == 0 then
			return 0;
		end
		
		if StrNSame(arg3, "Auth_", 5) == 0 then
			return 0;
		end
		
		ChangePartyMemberProp(pc, partyObj, arg2, arg3, arg4);
		return 1;
	elseif cmd == "/pmyp" then	
		local partyObj = GetPartyObj(pc, arg1);
		local my = GetMemberObj(partyObj, GetTeamName(pc));
		
		if my == nil then
			return 0;
		end		
		
		if arg3 ~= "Shared_Quest" and arg3 ~= "Before_Quest" and arg3 ~= "Before_Quest_State" and arg3 ~= "Shared_Progress" then
			return 0;
		end

		ChangePartyMemberProp(pc, partyObj, arg2, arg3, arg4);
		return 1;
	elseif cmd == "/readcollection" then
		
		local etc = GetETCObject(pc);
		local tempprop = 'CollectionRead_'..arg1

		if etc[tempprop] == 1  then
			return 0 
		end

		etc[tempprop] = 1;
		InvalidateEtc(pc, tempprop);

		SendAddOnMsg(pc, "UPDATE_READ_COLLECTION_COUNT");

		return 1;
		
	elseif cmd == "/lastuiopenpos" then

		local lastUIOpenFrameList = {}
		lastUIOpenFrameList["buffseller_target"] = 1
		lastUIOpenFrameList["camp_ui"] = 1
		lastUIOpenFrameList["cardbattle"] = 1
		lastUIOpenFrameList["foodtable_ui"] = 1
		lastUIOpenFrameList["itembuffrepair"] = 1
		lastUIOpenFrameList["itembuffgemroasting"] = 1
		lastUIOpenFrameList["itembuffopen"] = 1
		lastUIOpenFrameList["propertyshop"] = 1
        lastUIOpenFrameList['adventure_book'] = 1;

		if lastUIOpenFrameList[arg1] ~= 1 then
			return 0
		end

		local regret = REGISTERR_LASTUIOPEN_POS_SERVER(pc, arg1)

		if regret == 0 then
			return 0
		end
		
		return 1;
	
	elseif cmd == "/learnpcabil" then
		RunScript("SCR_TX_ABIL_REQUEST", pc, arg1, tonumber(arg2));
		return 1;

    elseif cmd == '/buyabilpoint' then
        if IsRunningScript(pc, 'SCR_TX_BUY_ABILITY_POINT') == 1 then
            return 0;
        end
        RunScript('SCR_TX_BUY_ABILITY_POINT', pc, tonumber(arg1));
        return 1;

	elseif cmd == "/guildexpup" then
		
		local currentCount = math.floor(tonumber(arg2));
        if currentCount < 1 then
            return 0;
        end

		local item, cnt = GetInvItemByGuid(pc, arg1);
		if item == nil or cnt == nil then
			SendSysMsg(pc, "REQUEST_TAKE_ITEM");
			return 0;
		end
		
		if currentCount > cnt then
			SendSysMsg(pc, "REQUEST_TAKE_ITEM");
			return 0;
		end

        if IsRunningScript(pc, '_GUILD_EXP_UP') == 1 then
            return 0;
        end

        local argList = {};
        argList[1] = tostring(arg1)
        argList[2] = tostring(currentCount);
        _GUILD_EXP_UP(pc, argList, currentCount);
		return 1;
	elseif cmd == "/learnguildabil" then

        local argList = {}
        argList[1] = tostring(arg1)
        CheckClaim(pc, 'callback_learn_guild_ability', 13, argList) -- code:13 (길드특성설정)
		return 1;

	elseif cmd == "/learnguildskl" then
		LEARN_GUILD_SKL(pc, arg1);

		return 1;

	elseif cmd == "/requpdateequip" then

		if pc == nil then
			return 0
		end

		FlushItemDurability(pc)

		return 1;

	elseif cmd == '/hairgacha' then    
        if IsPlayingPairAnimation(pc) == 0 then
		    RunScript('SCR_USE_GHACHA_TPCUBE', pc, arg1)
        end
		return 1;        
    elseif cmd == '/leticia_gacha' then        
		RunScript('EXECUTE_LETICIA_GACHA', pc, arg1);
		return 1;
        
    elseif cmd == '/ingameuiopen' then
    
        if pc == nil then
			return 0
		end

        if arg1 ~= nil then
            CustomMongoLog(pc, "IngamePurchase", "Type", "UIOpen", "Info", arg1)
        else
            CustomMongoLog(pc, "IngamePurchase", "Type", "UIOpen")
        end        

		return 1;

    elseif cmd == '/ingameuilog' then

        if pc == nil then
			return 0
		end

        if arg1 ~= nil then
            CustomMongoLog(pc, "IngamePurchase", "Type", "UILog", "Info", arg1)
        end

		return 1;

	elseif cmd == "/marketreport" then

		if pc == nil or arg1 == nil then
			return 0
		end
		
		ReportMarketItem(pc, arg1)

		return 1;

	elseif cmd == '/hmunclusSkl' then
		SCR_HOUMCLUS_SKL_ACQUIRE(pc, arg1);

		return 1;
    elseif cmd == '/upgradeFishingItemBag' then
        if true then
            return; -- 일단 막아달라고 하심
        end

        if IsRunningScript(pc, 'TX_UPGRADE_FISHING_ITEM_BAG') == 0 then
		    RunScript('TX_UPGRADE_FISHING_ITEM_BAG', pc)
        end
		return 1;
	end

	if string.find(cmd, "sage") ~= nil then
		SCR_PC_SKL_SAGE_COMMAND(pc, cmd, arg1);

		return 1;
	end

	return 0;

end



function REGISTERR_LASTUIOPEN_POS_SERVER(pc, framename)

	if pc == nil then
		return 0
	end

	local x,y,z = Get3DPos(pc);
	local nowZoneName = GetZoneName(pc);

	local stringpos = nowZoneName .. '/' .. x .. '/' .. y .. '/' .. z .. '/' .. framename;

	local etc = GetETCObject(pc);
	if etc == nil then
		return 0
	end

	etc["LastUIOpenPos"] = stringpos;
	InvalidateEtc(pc, "LastUIOpenPos");

	return 1
end

function SCR_EVENT_BANNER_USERCOMMAND(pc, bannerClassID)
end

function SCR_UICALL_CHATALIAS(pc, typeStr)
    
	if typeStr == 'coin' then
--        RunScript('SCR_EV161124_EVENT_USER_LOG_1',pc)
    elseif typeStr == 'remain' then
--        RunScript('SCR_EV161124_EVENT_USER_LOG_2',pc)
    elseif typeStr == 'dice' then
--        if GetServerNation() ~= 'KOR' then
--            return
--        end
--        local aObj = GetAccountObj(pc);
--        if aObj == nil then
--            return
--        end
--        local now_time = os.date('*t')
--        local year = now_time['year']
--        local month = now_time['month']
--        local yday = now_time['yday']
--        local day = now_time['day']
--        local hour = now_time['hour']
--        local nowAddHour = SCR_DATE_TO_HOUR(year, yday, hour)
--        
--        if aObj.EV161229_DICE_PLAY_DAY == 'None' then
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("EV161229_DICE_MSG9"),10)
--            return
--        else
--            local msg = ScpArgMsg("EV161229_DICE_MSG6","DATE", aObj.EV161229_DICE_PLAY_DAY,"COUNT", aObj.EV161229_DICE_PLAY_COUNT)
--            local remainHour = 0
--            if nowAddHour > aObj.EV161229_DICE_PLAY_TIME + 2 then
--                remainHour = 0
--            else
--                remainHour = aObj.EV161229_DICE_PLAY_TIME + 3 - nowAddHour
--            end
--            msg = msg..'{nl}'..ScpArgMsg("EV161229_DICE_MSG8","HOUR", remainHour)
--            msg = msg..'{nl}'..ScpArgMsg("EV161229_DICE_MSG7","VALUE", aObj.EV161229_DICE_ADD_NUM)
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll",msg,10)
--            return
--        end
	elseif typeStr == 'test' then
--	elseif typeStr == 'ev170216' then
--        local aObj = GetAccountObj(pc);
--        if aObj == nil then
--            return
--        end
--	    if aObj.EV170216_REWARD_COUNT > 0 then
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV170216_EVENTCOUNTING", "MAXCOUNT", 14, "COUNT", aObj.EV170216_REWARD_COUNT), 10)
--        else
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("EV170119_NEWYEAR_MSG1"),10)
--        end
    elseif typeStr == 'newyearevent' then
        local aObj = GetAccountObj(pc);
        if aObj == nil then
            return
        end
        if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Fortune' then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("EV170119_NEWYEAR_MSG1"),10)
            return
        else
            local count = aObj.PlayTimeEventRewardCount
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("EV170119_NEWYEAR_MSG2","COUNT", count),10)
            return
        end
--    elseif typeStr == 'event1708jurate' then
--        local aObj = GetAccountObj(pc);
--        if aObj ~= nil then
--            if aObj.EVENT_1708_JURATE_COUNT > 0 then
--                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('EVENT_1708_JURATE_MSG9','COUNT', aObj.EVENT_1708_JURATE_COUNT), 7)
--            else
--                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg('EV170119_NEWYEAR_MSG1'), 7)
--            end
--        end
--	elseif typeStr == 'event1804transcend' then
--	    local aObj = GetAccountObj(pc);
--        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("EVENT_1804_TRANSCEND_MSG1","COUNT",aObj.EVENT_1804_TRANSCEND_SUCCESS_COUNT),10) 
	end
end

function SCR_EV161124_EVENT_USER_LOG_1(pc)
    if GetServerNation() ~= 'KOR' then
        return
    end
    
    local aObj = GetAccountObj(pc);
    local lastDate = aObj.EV161124_DAYCHECK_DATE
    
    if aObj ~= nil then
        if lastDate == 'None' then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG5"), 10)
        else
            local rewardIndex = aObj.EV161124_DAYCHECK_REWARDLIST
            local rewardList = SCR_STRING_CUT(rewardIndex)
            local itemList, itemCountList, itemPercentList = SCR_EV161124_DAYCHECK_REWARD_LIST()
            
            for index = 1, 3 do
                local itemMsg = ''
                local cutCount = 10
                local startIndex = (index-1)*cutCount + 1
                local endIndex = index*cutCount
                local endFlag = 0
                if endIndex > #rewardList then
                    endIndex = #rewardList
                    endFlag = 1
                end
                for i = startIndex, endIndex do
                    if itemMsg == '' then
                        itemMsg = ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',GetClassString('Item', itemList[rewardList[i]],'Name'),'COUNT',itemCountList[rewardList[i]])
                    else
                        itemMsg = itemMsg..', '..ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',GetClassString('Item', itemList[rewardList[i]],'Name'),'COUNT',itemCountList[rewardList[i]])
                    end
                end
                
                local selectNum = aObj.EV161124_DAYCHECK_SELECTLIST
                local selectList = SCR_STRING_CUT(selectNum)
                local msg = string.gsub(selectNum, '/',', ')
                if itemMsg ~= '' then
                    if index == 1 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG4","COUNT", #selectList, "NUMLIST",msg)..startIndex.."~"..endIndex.."){nl}"..itemMsg, 5)
                    else
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll","("..startIndex.."~"..endIndex.."){nl}"..itemMsg,5)
                    end
                end
                if endFlag == 1 then
                    break
                else
                    sleep(5000)
                end
            end
        end
    end
end
function SCR_EV161124_EVENT_USER_LOG_2(pc)
    if GetServerNation() ~= 'KOR' then
        return
    end
    local aObj = GetAccountObj(pc);
    
    if aObj ~= nil then
        local rewardIndex = aObj.EV161124_DAYCHECK_REWARDLIST
        local rewardList = SCR_STRING_CUT(rewardIndex)
        local itemList, itemCountList, itemPercentList = SCR_EV161124_DAYCHECK_REWARD_LIST()
        
        local remainRewardList = {}
        for i = 1, 30 do
--            print('XXXXXXXXXX',table.find(rewardList,i))
            if table.find(rewardList,i) == 0 then
                remainRewardList[#remainRewardList+1]= {itemList[i],itemCountList[i]}
            end
        end
        
        
        for index = 1, 3 do
            local itemMsg = ''
            local cutCount = 10
            local startIndex = (index-1)*cutCount + 1
            local endIndex = index*cutCount
            local endFlag = 0
            if endIndex > #remainRewardList then
                endIndex = #remainRewardList
                endFlag = 1
            end
            for i = startIndex, endIndex do
                if itemMsg == '' then
                    itemMsg = ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',GetClassString('Item', remainRewardList[i][1],'Name'),'COUNT',remainRewardList[i][2])
                else
                    itemMsg = itemMsg..', '..ScpArgMsg('EV161124_DAYCHECK_MSG6','ITEM',GetClassString('Item', remainRewardList[i][1],'Name'),'COUNT',remainRewardList[i][2])
                end
--                 print('AAAAAAAAAAAAAAAAA',GetClassString('Item', remainRewardList[i][1],'Name'),remainRewardList[i][2])
            end
            if index == 1 and itemMsg == '' then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG8"), 10)
                break
            end
            if itemMsg ~= '' then
                if index == 1 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EV161124_DAYCHECK_MSG7")..startIndex.."~"..endIndex.."){nl}"..itemMsg, 5)
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll","("..startIndex.."~"..endIndex.."){nl}"..itemMsg,5)
                end
            end
            if endFlag == 1 then
                break
            else
                sleep(5000)
            end
        end
    end
end