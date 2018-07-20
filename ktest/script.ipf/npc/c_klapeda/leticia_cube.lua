function SCR_LETICIA_CUBE_DIALOG(self, pc)
    SetExArgObject(pc, "CUBE_OBJET", self)
    ExecClientScp(pc, 'LETICIA_CUBE_OPEN()');
end

function EXECUTE_LETICIA_GACHA(pc, gachaClassName)
    local gachaDetailCls = GetClass('GachaDetail', gachaClassName);
    if pc == nil or gachaDetailCls == nil then
        return;
    end
    local consumeType = TryGetProp(gachaDetailCls, 'ConsumeType');
    if IS_ENABLE_LETICIA_GACHA(pc, gachaDetailCls, consumeType) == false then
        return;
    end
    
    	local cubeObj = GetExArgObject(pc, "CUBE_OBJET");
	PlayAnimSelfish(pc, cubeObj, "open", 0)

    if consumeType == 'TP' then
        if IsRunningScript(pc, 'EXECUTE_LETICIA_GACHA_BY_TP') ~= 1 then
            EXECUTE_LETICIA_GACHA_BY_TP(pc, gachaDetailCls);
        end
    elseif consumeType == 'CUBE' then
        if IsRunningScript(pc, 'EXECUTE_LETICIA_GACHA_BY_ITEM') ~= 1 then
            EXECUTE_LETICIA_GACHA_BY_ITEM(pc, gachaDetailCls);
        end
    end
end

function IS_ENABLE_LETICIA_GACHA(pc, gachaDetailCls, consumeType)

    if SCR_PRECHECK_LETICIA_Time() ~= 'YES' then 
        return;
    end

    
    local itemClassName = TryGetProp(gachaDetailCls, 'ItemClassName');
    local itemClass = GetClass('Item', itemClassName);
    if pc == nil or gachaDetailCls == nil or consumeType == nil or itemClassName == nil or itemClass == nil then
        return false;
    end

	if itemClassName == "Gacha_TP_100"then
		if haveCount < 100 then
			SendSysMsg(pc, "NeedItemCount",0,"Cnt","100");
			return false;
		end
	end

    local now = pc.NowWeight;
	if pc.MaxWeight <= now then
		SendSysMsg(pc, "MAXWEIGHTMSG");
	    return false;
	end

    if consumeType == 'ITEM' then
        local haveCount = GetInvItemCount(pc, itemClassName);
	    if haveCount == nil or haveCount < 1 then
	        return false;
	    end
    elseif consumeType == 'TP' then
        local price = TryGetProp(gachaDetailCls, 'Price');        
        local userTP = GetPCTotalTPCount(pc);
        if userTP < price then
            SendSysMsg(pc, 'REQUEST_TAKE_MEDAL');
            return false;
        end
    end

    return true;
end

function EXECUTE_LETICIA_GACHA_BY_TP(pc, gachaDetailCls)
    local itemClassName = TryGetProp(gachaDetailCls, 'ItemClassName');
    local itemClass = GetClass('Item', itemClassName);
    local price = TryGetProp(gachaDetailCls, 'Price');
    local rewardGroup = TryGetProp(gachaDetailCls, 'RewardGroup');
    local gachacnt = TryGetProp(gachaDetailCls, 'Count');
    local gachaLog = TryGetProp(gachaDetailCls, 'GachaLog');
    local accountObj = GetAccountObj(pc); 
    
    if SCR_PRECHECK_LETICIA_Time() ~= 'YES' then 
        return;
    end

    if price ==  nil or price < 1 then -- invalid price
        return;
    end
        
    local tx = TxBegin(pc);	
    if tx == nil then
        return;
    end
	TxEnableInIntegrateIndun(tx);
    TxAddIESProp(tx, accountObj, 'Medal', -price, 'NPCGachaShop:'..itemClass.ClassID);
    
    local sendrewardlist = {};
	local sendrewardcntlist = {};
	for i = 1, gachacnt do 
		local reward, rewardCount, rewardGroup = GET_HAIR_GACHA_REWARD(rewardGroup, 'reward_tp')
		if reward == nil then		
			TxRollBack(tx)
			return;
		end

		TxGiveItem(tx, reward, rewardCount, gachaLog, 0 ,  nil, 99999);
		
		sendrewardlist[#sendrewardlist+1] = reward;
		sendrewardcntlist[#sendrewardcntlist+1] = rewardCount;
	end

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        IMC_LOG('ERROR_TX_FAIL', 'EXECUTE_LETICIA_GACHA_BY_TP: item['..itemClassName..']');
        return;
    end

    if gachacnt == 1 then
        local cntandgrade = GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[1], rewardGroup)*1000 + sendrewardcntlist[1];
	    SendAddOnMsg(pc, "LETICIA_POPUP", sendrewardlist[1], cntandgrade);
    else
        local rewardstring = "";
		for i = 1, #sendrewardlist do			
			rewardstring = rewardstring .. sendrewardlist[i] .. "&" .. tostring( (GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[i], rewardGroup)*1000) + sendrewardcntlist[i] ) .. "&";
		end
		SendAddOnMsg(pc, "LETICIA_POPUP_10", rewardstring, 0);
    end
    
    local ALLMSG = {'Gold_Socket_Box'}

	for i = 1, table.getn(ALLMSG) do
	    for j = 1, #sendrewardlist do
    	    if ALLMSG[i] == sendrewardlist[j] then
    		    local itemName = GetClassString('Item', sendrewardlist[j], 'Name')
    			ToAll(ScpArgMsg("GACHA_SITEM_GET_ALLMSG","PC",GetTeamName(pc),"ITEMNAME", itemName))
    			break;
    		end
    	end
	end

    local scpStr = string.format("SET_BEFORE_GACHA_CLASS_NAME('%s', '%s')", gachaDetailCls.ClassName, itemClassName);    
    ExecClientScp(pc, scpStr); -- 연속 개봉을 위해서 세팅해줌
end

function EXECUTE_LETICIA_GACHA_BY_ITEM(pc, gachaDetailCls)

    if SCR_PRECHECK_LETICIA_Time() ~= 'YES' then 
        return;
    end
    
    local itemClassName = TryGetProp(gachaDetailCls, 'ItemClassName');
    local rewardGroup = TryGetProp(gachaDetailCls, 'RewardGroup');
    local rewardCount = TryGetProp(gachaDetailCls, 'Count');  
    local gachaLog = TryGetProp(gachaDetailCls, 'GachaLog');
    if itemClassName == nil or pc == nil or rewardGroup == nil or rewardCount == nil then
        return;
    end

    local tx = TxBegin(pc);	
    if tx == nil then
        return;
    end
	TxEnableInIntegrateIndun(tx);
    TxTakeItem(tx, itemClassName, 1, gachaLog);
    
    local sendrewardlist = {};
	local sendrewardcntlist = {};
	for i = 1, gachacnt do 
		local reward, rewardCount, rewardGroup = GET_HAIR_GACHA_REWARD(rewardGroup, 'reward_tp')
		if reward == nil then		
			TxRollBack(tx)
			return;
		end
		TxGiveItem(tx, reward, rewardCount, gachaLog);
		
		sendrewardlist[#sendrewardlist+1] = reward;
		sendrewardcntlist[#sendrewardcntlist+1] = rewardCount;
	end

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        IMC_LOG('ERROR_TX_FAIL', 'EXECUTE_LETICIA_GACHA_BY_TP: item['..itemClassName..']');
        return;
    end

    if gachacnt == 1 then
        local cntandgrade = GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[1], rewardGroup)*1000 + sendrewardcntlist[1];
	    SendAddOnMsg(pc, "LETICIA_POPUP", sendrewardlist[1], cntandgrade);
    else
        local rewardstring = "";
		for i = 1, #sendrewardlist do			
			rewardstring = rewardstring .. sendrewardlist[i] .. "&" .. tostring( (GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[i], rewardGroup)*1000) + sendrewardcntlist[i] ) .. "&";
		end
		SendAddOnMsg(pc, "LETICIA_POPUP_10", rewardstring, 0);
    end

    local scpStr = string.format("SET_BEFORE_GACHA_CLASS_NAME('%s', '%s')", gachaDetailCls.ClassName, itemClassName);    
    ExecClientScp(pc, scpStr); -- 연속 개봉을 위해서 세팅해줌
end


function SCR_PRECHECK_LETICIA_Time()

    if GetServerNation() ~= "KOR" then
        return 'YES'
    end

    local sysTime = nil;
    sysTime = GetDBTime();
    
    if sysTime == nil then
        return "NO";
    end
    
    local nowTime = tonumber(string.format("%04d%02d%02d%02d", sysTime.wYear, sysTime.wMonth, sysTime.wDay, sysTime.wHour))
    
    
    if nowTime >= 2018040118 and nowTime < 2018040418 then
        return 'YES'
    end
    
    return "NO"
end


function SCR_LETICIA_CUBE_AI_BORN(self)
   local nowtime = SCR_PRECHECK_LETICIA_Time()
   if nowtime == "YES" then
       local zoneInstID = GetZoneInstID(self);
       local x, y, z = GetPos(self)
       if IsValidPos(zoneInstID, x, y, z) == 'YES' then
           local mon = CREATE_NPC(self, 'gacha_cube1', x, y, z, 0, 'Neutral', 0, ScpArgMsg("Leticia_Cube"), 'LETICIA_CUBE')
           if mon ~= nil then
               SetTacticsArgObject(self, mon)
               EnableAIOutOfPC(mon)
           end
       end
   end
end


function SCR_LETICIA_CUBE_AI_UPDATE(self)
   local creMon = GetTacticsArgObject(self)
   local nowtime = SCR_PRECHECK_LETICIA_Time()
   if creMon ~= nil then
       if nowtime == "YES" then
           return
       elseif nowtime == "NO" then
           Kill(creMon)
       end
   else
       if nowtime == "YES" then
           local zoneInstID = GetZoneInstID(self);
           local x, y, z = GetPos(self)
           if IsValidPos(zoneInstID, x, y, z) == 'YES' then
               local mon = CREATE_NPC(self, 'gacha_cube1', x, y, z, 0, 'Neutral', 0, ScpArgMsg("Leticia_Cube"), 'LETICIA_CUBE')
               if mon ~= nil then
                   SetTacticsArgObject(self, mon)
                   EnableAIOutOfPC(mon)
               end
           end
       end
   end
end

function SCR_LETICIA_CUBE_AI_AI_LEAVE(self)
end