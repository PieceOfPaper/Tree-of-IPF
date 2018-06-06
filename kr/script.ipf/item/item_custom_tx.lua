--item_custom_tx.lua


function GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(self, giveItem, takeItem, sObjInfo_add, achieveInfo, giveWay, sObjInfo_set, exp, jexp, dungeoncount, tokenBonus, mGameName)
    local ret
    local pcetc
    if dungeoncount == 'YES' then
        pcetc = GetETCObject(self)
    end
    if (giveItem ~= nil and #giveItem > 0) or (takeItem ~= nil and #takeItem > 0) or (sObjInfo_add ~= nil and #sObjInfo_add > 0) or (achieveInfo ~= nil and #achieveInfo > 0 ) or (sObjInfo_set ~= nil and #sObjInfo_set > 0) or (exp ~= nil and exp > 0) or (jexp ~= nil and jexp > 0) then
        local sObjList_add = {}
        local sObjList_set = {}
        
        if sObjInfo_add ~= nil and #sObjInfo_add > 0 then
            for i = 1, #sObjInfo_add do
                local sObjInput
                if string.upper(sObjInfo_add[i][1]) == 'ACCOUNT' then
                    sObjInput = GetAccountObj(self)
                elseif string.upper(sObjInfo_add[i][1]) == 'PCETC' then
                    sObjInput = GetETCObject(self)
                else
                    sObjInput = GetSessionObject(self, sObjInfo_add[i][1])
                end
                if sObjInput ~= nil then
                    sObjList_add[#sObjList_add+1] = sObjInput
                else
                    return
                end
            end
        end
        
        if sObjInfo_set ~= nil and #sObjInfo_set > 0 then
            for i = 1, #sObjInfo_set do
                local sObjInput
                if string.upper(sObjInfo_set[i][1]) == 'ACCOUNT' then
                    sObjInput = GetAccountObj(self)
                elseif string.upper(sObjInfo_set[i][1]) == 'PCETC' then
                    sObjInput = GetETCObject(self)
                else
                    sObjInput = GetSessionObject(self, sObjInfo_set[i][1])
                end
                if sObjInput ~= nil then
                    sObjList_set[#sObjList_set+1] = sObjInput
                else
                    return
                end
            end
        end
        
    	local i
    	local tx = TxBegin(self);
		TxEnableInIntegrateIndun(tx);
    	if takeItem ~= nil and #takeItem > 0 then
        	for i = 1,#takeItem do
        	    local count = tonumber(takeItem[i][2])
        	    if count == -100 then
        	        count = GetInvItemCount(self, takeItem[i][1])
        	    end
        	    if count > 0 then
            	    TxTakeItem(tx, takeItem[i][1], count, giveWay);
            	end
        	end
        end
        if giveItem ~= nil and #giveItem > 0 then
        	for i = 1,#giveItem do
        	    if giveItem[i][2] > 0 then
        	        local giveItemCount = giveItem[i][2]
        	        if tokenBonus ~= nil and tokenBonus > 0 then
        	            if IsPremiumState(self, ITEM_TOKEN) == 1 then
            	            giveItemCount = giveItemCount + tokenBonus
            	        end
        	        end
        	        if dungeoncount == 'YES' and pcetc ~= nil then
        	            giveItemCount = giveItemCount * (pcetc.IndunMultipleRate + 1)
        	        end
            	    TxGiveItem(tx, giveItem[i][1], giveItemCount, giveWay);
            	end
        	end
        end
        
        if sObjList_add ~= nil and #sObjList_add > 0 then
        	for i = 1,#sObjList_add do
        	    TxAddIESProp(tx, sObjList_add[i], sObjInfo_add[i][2], sObjInfo_add[i][3])
        	end
        end
        if sObjList_set ~= nil and #sObjList_set > 0 then
        	for i = 1,#sObjList_set do
        	    TxSetIESProp(tx, sObjList_set[i], sObjInfo_set[i][2], sObjInfo_set[i][3])
        	end
        end
        
        if achieveInfo ~= nil and #achieveInfo > 0 then
            for i = 1,#achieveInfo do
                TxAddAchievePoint(tx, achieveInfo[i][1], tonumber(achieveInfo[i][2]))
            end
        end
        
        if exp ~= nil and exp > 0 then
            TxGiveExp(tx, exp, giveWay)
        end
        
    	ret = TxCommit(tx);
    	
    	if ret == 'SUCCESS' then
    	    if jexp ~= nil and jexp > 0 then
    	        GiveJobExp(self, jexp, giveWay);
    	    end
    	    if mGameName ~= nil and mGameName ~= "None" then
    	        CustomMongoLog(self, "Raid", "MGAME_NAME", mGameName, "tx_Succ")
    	    end
    	elseif ret == 'FAIL' then
    	    if mGameName ~= nil and mGameName ~= "None" then
    	        CustomMongoLog(self, "Raid", "MGAME_NAME", mGameName, "tx_Fail")
    	    end
    	end
    end
    return ret
end

function GIVE_TAKE_SOBJ_ACHIEVE_TX(self, give_list, take_list, sobj_list_add, achieve_list, giveWay, sobj_list_set, exp, jexp, dungeoncount, tokenBonus)
    local giveItem_temp = SCR_STRING_CUT(give_list)
    local takeItem_temp = SCR_STRING_CUT(take_list)
    local sObjInfo_add_temp = SCR_STRING_CUT(sobj_list_add)
    local achieveInfo_temp = SCR_STRING_CUT(achieve_list)
    local sObjInfo_set_temp = SCR_STRING_CUT(sobj_list_set)
    
    local giveItem = {}
    local takeItem = {}
    local sObjInfo_add = {}
    local achieveInfo = {}
    local sObjInfo_set = {}
    if giveItem_temp ~= nil and  #giveItem_temp > 1 then
        for i = 1 , #giveItem_temp / 2 do
            giveItem[#giveItem + 1] = {}
            giveItem[#giveItem][1] = giveItem_temp[i*2 - 1]
            giveItem[#giveItem][2] = tonumber(giveItem_temp[i*2])
        end
    end
    if takeItem_temp ~= nil and  #takeItem_temp > 1 then
        for i = 1, #takeItem_temp/2 do
            takeItem[#takeItem + 1] = {}
            takeItem[#takeItem][1] = takeItem_temp[i*2 - 1]
            takeItem[#takeItem][2] = tonumber(takeItem_temp[i*2])
        end
    end
    if sObjInfo_add_temp ~= nil and  #sObjInfo_add_temp > 1 then
        for i = 1, #sObjInfo_add_temp/3 do
            sObjInfo_add[#sObjInfo_add + 1] = {}
            sObjInfo_add[#sObjInfo_add][1] = sObjInfo_add_temp[i*3 - 2]
            sObjInfo_add[#sObjInfo_add][2] = sObjInfo_add_temp[i*3 - 1]
            sObjInfo_add[#sObjInfo_add][3] = tonumber(sObjInfo_add_temp[i*3])
        end
    end
    if achieveInfo_temp ~= nil and  #achieveInfo_temp > 1 then
        for i = 1, #achieveInfo_temp/2 do
            achieveInfo[#achieveInfo + 1] = {}
            achieveInfo[#achieveInfo][1] = achieveInfo_temp[i*2 - 1]
            achieveInfo[#achieveInfo][2] = tonumber(achieveInfo_temp[i*2])
        end
    end
    if sObjInfo_set_temp ~= nil and  #sObjInfo_set_temp > 1 then
        for i = 1, #sObjInfo_set_temp/3 do
            sObjInfo_set[#sObjInfo_set + 1] = {}
            sObjInfo_set[#sObjInfo_set][1] = sObjInfo_set_temp[i*3 - 2]
            sObjInfo_set[#sObjInfo_set][2] = sObjInfo_set_temp[i*3 - 1]
            sObjInfo_set[#sObjInfo_set][3] = tonumber(sObjInfo_set_temp[i*3])
        end
    end
    
    return GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(self, giveItem, takeItem, sObjInfo_add, achieveInfo, giveWay, sObjInfo_set, exp, jexp, dungeoncount, tokenBonus)
end

function GIVE_TAKE_ITEMTABLE_TX(self, giveItem, takeItem, giveWay)
    if (giveItem ~= nil and #giveItem) > 0 or (takeItem ~= nil and #takeItem > 0) then
    	local i
    	local tx = TxBegin(self);
		TxEnableInIntegrateIndun(tx);
    	if #takeItem > 0 then
        	for i = 1,#takeItem do
        	    local count = tonumber(takeItem[i][2])
        	    if count == -100 then
        	        count = GetInvItemCount(self, takeItem[i][1])
        	    end
        	    if count > 0 then
            	    TxTakeItem(tx, takeItem[i][1], count, giveWay);
            	end
        	end
        end
        if #giveItem > 0 then
        	for i = 1,#giveItem do
        	    if giveItem[i][2] > 0 then
            	    TxGiveItem(tx, giveItem[i][1], giveItem[i][2], giveWay);
            	end
        	end
        end
    	local ret = TxCommit(tx);
    	return ret;
    end
	return 'FAIL';
end

function GIVE_TAKE_ITEM_TX(self, give_list, take_list, giveWay)
    local giveItem_temp = SCR_STRING_CUT(give_list)
    local takeItem_temp = SCR_STRING_CUT(take_list)
    
    	    
    local giveItem = {}
    local takeItem = {}
    if giveItem_temp ~= nil and  #giveItem_temp > 1 then
        for i = 1 , #giveItem_temp / 2 do
            giveItem[#giveItem + 1] = {}
            giveItem[#giveItem][1] = giveItem_temp[i*2 - 1]
            giveItem[#giveItem][2] = tonumber(giveItem_temp[i*2])
        end
    end
    if takeItem_temp ~= nil and  #takeItem_temp > 1 then
        for i = 1, #takeItem_temp/2 do
            takeItem[#takeItem + 1] = {}
            takeItem[#takeItem][1] = takeItem_temp[i*2 - 1]
            takeItem[#takeItem][2] = tonumber(takeItem_temp[i*2])
        end
    end
    
    return GIVE_TAKE_ITEMTABLE_TX(self, giveItem, takeItem, giveWay);
end

function GIVE_TAKE_ITEM_OBJECT_TX(self, give_list, take_list, giveWay)	
    local giveItem_temp = SCR_STRING_CUT(give_list)
    local takeItem_temp = SCR_STRING_CUT(take_list)
    
    	    
    local giveItem = {}
    local takeItem = {}
    if giveItem_temp ~= nil and  #giveItem_temp > 1 then
        for i = 1 , #giveItem_temp / 2 do
            giveItem[#giveItem + 1] = {}
            giveItem[#giveItem][1] = giveItem_temp[i*2 - 1]
            giveItem[#giveItem][2] = tonumber(giveItem_temp[i*2])
        end
    end
    if takeItem_temp ~= nil and  #takeItem_temp > 1 then
        for i = 1, #takeItem_temp/2 do
            takeItem[#takeItem + 1] = {}
            takeItem[#takeItem][1] = takeItem_temp[i*2 - 1]
            takeItem[#takeItem][2] = tonumber(takeItem_temp[i*2])
        end
    end
    
    GIVE_TAKE_ITEMTABLE_OBJECT_TX(self, giveItem, takeItem, giveWay)
end

function GIVE_TAKE_ITEMTABLE_OBJECT_TX(self, giveItem, takeItem, giveWay)	
    if (giveItem ~= nil and #giveItem) > 0 or (takeItem ~= nil and #takeItem > 0) then
    	local i
    	local tx = TxBegin(self);
		TxEnableInIntegrateIndun(tx);
    	if #takeItem > 0 then
			local targetItemList = {}
        	for i = 1,#takeItem do
        	    local count = tonumber(takeItem[i][2])
        	    if count == -100 then
        	        count = GetInvItemCount(self, takeItem[i][1])
        	    end				
        	    if count > 0 then					
					targetItemList = {}		
					local invItemList = GetInvItemList(self);
					if invItemList ~= nil then
						for j = 1, #invItemList do
							local item = invItemList[j]
							if item ~= nil then								
								if takeItem[i][1] == item.ClassName then
									local guid = GetIESID(item)									
									local invItem = GetInvItemByGuid(self, guid)
									if IsFixedItem(invItem) == 0 then	-- 안잠긴 아이템을 리스트에 넣는다.
										targetItemList[#targetItemList + 1] = invItem										
									end
								end
							end							
						end
					end					
            	end
				if #targetItemList >= count then  -- 없애야하는 아이템보다 후보자 아이템이 같거나 많은 경우에만 시도한다.
					for k = 1, count do
						TxTakeItemByObject(tx, targetItemList[k], 1, giveWay);
					end				
				else
					TxRollBack(tx)
					return
				end					
        	end
        end
        if #giveItem > 0 then			
        	for i = 1,#giveItem do
        	    if giveItem[i][2] > 0 then
            	    TxGiveItem(tx, giveItem[i][1], giveItem[i][2], giveWay);
            	end
        	end
        end
    	local ret = TxCommit(tx);    	
    end
end

function SCR_NPCSTATECHEANG(pc, npcGenID, Value)
    local tx = TxBegin(pc);
	TxEnableInIntegrateIndun(tx);
	TxChangeNPCState(tx, npcGenID, Value);
	local ret = TxCommit(tx);
end

function GIVE_TAKE_ITEM_NPCSTATE_STAT_TX(self, give_list, take_list, giveWay, npcState, stat, txfunc)
    local giveItem_temp = SCR_STRING_CUT(give_list)
    local takeItem_temp = SCR_STRING_CUT(take_list)
    local npcStateList = SCR_STRING_CUT(npcState)
    
    local giveItem = {}
    local takeItem = {}
    if giveItem_temp ~= nil then
        if string.find(giveItem_temp[1], ':') == nil then
            if  #giveItem_temp > 1 then
                for i = 1 , #giveItem_temp / 2 do
                    giveItem[#giveItem + 1] = {}
                    giveItem[#giveItem][1] = giveItem_temp[i*2 - 1]
                    giveItem[#giveItem][2] = tonumber(giveItem_temp[i*2])
                end
            end
        else
            if  #giveItem_temp > 0 then
                if string.find(giveItem_temp[1], ':') ~= nil then
                    for i = 1 , #giveItem_temp do
                        giveItem[#giveItem + 1] = SCR_STRING_CUT(giveItem_temp[i], ':')
                    end
                else
                    giveItem = giveItem_temp
                end
            end
        end
    end
    if takeItem_temp ~= nil then
        if string.find(takeItem_temp[1], ':') == nil then
            if #takeItem_temp > 1 then
                for i = 1, #takeItem_temp/2 do
                    takeItem[#takeItem + 1] = {}
                    takeItem[#takeItem][1] = takeItem_temp[i*2 - 1]
                    takeItem[#takeItem][2] = tonumber(takeItem_temp[i*2])
                end
            end
        else
            if #takeItem_temp > 0 then
                if string.find(takeItem_temp[1], ':') ~= nil then
                    for i = 1 , #takeItem_temp do
                        takeItem[#takeItem + 1] = SCR_STRING_CUT(takeItem_temp[i], ':')
                    end
                else
                    takeItem = takeItem_temp
                end
            end
        end
    end
    
                    
    if #giveItem > 0 or #takeItem > 0 or npcStateList ~= nil or (stat ~= nil and tonumber(stat) ~= nil) then
    	local i
    	local beforeValue = self.StatByBonus
    	local tx = TxBegin(self);
		TxEnableInIntegrateIndun(tx);
    	if #takeItem > 0 then
        	for i = 1,#takeItem do
        	    local count = tonumber(takeItem[i][2])
        	    if count == -100 then
        	        count = GetInvItemCount(self, takeItem[i][1])
        	    end
        	    if count > 0 then
            	    TxTakeItem(tx, takeItem[i][1], count, giveWay);
            	end
        	end
        end
        if #giveItem > 0 then
        	for i = 1,#giveItem do
        	    local count = tonumber(giveItem[i][2])
        	    if count > 0 then
            	    TxGiveItem(tx, giveItem[i][1], count, giveWay);
            	end
        	end
        end
        
        if npcStateList ~= nil then
            if string.find(npcStateList[1], ':') ~= nil then
                for i = 1, #npcStateList do
                    local npcInfo = SCR_STRING_CUT(npcStateList[i], ':')
                    if #npcInfo > 1 then
                        TxChangeNPCState(tx, tonumber(npcInfo[1]), tonumber(npcInfo[2]));
                    end
                end
            else
                for i = 1, #npcStateList -1 do
                    TxChangeNPCState(tx, tonumber(npcStateList[i]), tonumber(npcStateList[i + 1]));
                    i = i + 1
                end
            end
        end
        
        if stat ~= nil and tonumber(stat) ~= nil and tonumber(stat) > 0 then
            TxAddIESProp(tx, self, 'StatByBonus', stat)
        end
        
        if txfunc ~= nil and txfunc ~= 'None' then
            if type(txfunc) ~= 'table' then
                local funcInfo = SCR_STRING_CUT(txfunc)
                func = _G[funcInfo[1]]
                if func ~= nil then
                    func(self, tx, funcInfo)
                end
            else
                func = _G[txfunc[1]]
                if func ~= nil then
                    func(self, tx, txfunc)
                end
            end
        end
        
    	local ret = TxCommit(tx);
    	if stat ~= nil and tonumber(stat) ~= nil and tonumber(stat) > 0 then
        	local afterValue = self.StatByBonus
            CustomMongoLog(self, "StatByBonusADD", "Layer", GetLayer(self), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", stat, "Way", "GIVE_TAKE_ITEM_NPCSTATE_STAT_TX", "Type", "GIVE_TAKE_ITEM_NPCSTATE_STAT_TX")
        end
    end
end

function TAKE_ITEM_BY_ID(self, itemID)

	local item, cnt = GetInvItemByGuid(self, itemID)
	local tx = TxBegin(self);
	TxEnableInIntegrateIndun(tx);
	TxTakeItemByObject(tx, item, cnt);
	local ret = TxCommit(tx);
	

end

function GIVE_ITEM_TX(self, item, count, giveWay)

	local tx = TxBegin(self);
	TxEnableInIntegrateIndun(tx);
   	TxGiveItem(tx, item, count, giveWay);
	local ret = TxCommit(tx);
	
	return ret
end

function TAKE_ITEM_TX(self, item, count, takeway)
	local tx = TxBegin(self);
	TxEnableInIntegrateIndun(tx);
	TxTakeItem(tx, item, count, takeway);
	local ret = TxCommit(tx);
	
	return ret
end

function GIVE_ITEM_SET_TX(self, arg, giveWay)

	local armor = 20000 + arg;
	local belt = 30000 + arg;
	local gloves = 60000 + arg;
	local boots = 40000 + arg;
	local neck = 100000 + arg;

	local tx = TxBegin(self);
	TxEnableInIntegrateIndun(tx);
	TxGiveItem(tx, 'Body_' .. armor, 1, giveWay);
	TxGiveItem(tx, 'Belt_' .. belt, 1, giveWay);
	TxGiveItem(tx, 'Gloves_' .. gloves, 1, giveWay);
	TxGiveItem(tx, 'Boots_' .. boots, 1, giveWay);
	TxGiveItem(tx, 'Neck_' .. neck, 1, giveWay);
	local ret = TxCommit(tx);
	
end

-- 매직어뮬렛을을 소켓에 넣기
function SCR_MAGICAMULET_EQUIP_SERV(pc, item, gemRoastingLv, targetitem)

	local potential = targetitem.PR;
	if potential <= 0 then
		SendSysMsg(pc, "NoMorePotential");
		return;
	end
	
	local socketindex = -1;

	-- 소켓개수 알아내기	
	for i=0, targetitem.MaxSocket_MA - 1 do
		local temp = GetIESProp(targetitem, 'MagicAmulet_'..i);
		if temp == 0 then
			socketindex = i;
			break;
		end
	end
	
	-- 빈 소켓 없거나 장착템이아니면 return  
	if socketindex == -1 or targetitem.ItemType ~= 'Equip' then
		SendSysMsg(pc, 'NoMoreSocket');
		return;
	end

	local tx = TxBegin(pc);	
	if tx == nil then
		return;
	end
	TxEnableInIntegrateIndun(tx);
	--소켓에 쨈박기. 무슨 쨈 박았는지 저장
	if targetitem['MagicAmulet_' .. socketindex] ~= item.ClassID then
		TxSetIESProp(tx, targetitem, 'MagicAmulet_' .. socketindex, item.ClassID);	
	end

	-- 포텐셜 감소
	TxSetIESProp(tx, targetitem, 'PR', potential - 1);

	--박은 쨈 아이템 제거
	local tempclassname = item.ClassName
	TxTakeItemByObject(tx, item, 1, "MagicAmuletEquip");
	
	local ret = TxCommit(tx);
	

	if ret == 'SUCCESS' then		
		SocketMongoLog(pc, "MagicAmuletEquip", tempclassname, 0, 0, socketindex, targetitem.ClassName, targetitem);
	end

	InvalidateItem(targetitem);
	SendProperty(pc, targetitem);
	InvalidateStates(pc);
	SendAmuletPacket(pc, GetItemGuid(targetitem));
	
end

-- 젬을 소켓에 넣기
function SCR_GEM_EQUIP_SERV(pc, item, gemRoastingLv, targetitem)

	--박을 수 있는 아이템인지 검증을 해보자
	--[[
	if item.EnableEquipParts ~= "ALL" then
		if item.EnableEquipParts == "TopLeg" then
			if targetitem.EquipGroup == "PANTS" or targetitem.EquipGroup == "SHIRT" then
			end
		end
	end
	]]--
	local EnableEquipParts = StringSplit(item.EnableEquipParts, "/");
	local flag = 0;

	for i = 1, #EnableEquipParts do
		if  EnableEquipParts[i] ~= "ALL" then
			if EnableEquipParts[i] == "Weapon" and targetitem.DefaultEqpSlot == "RH" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "Weapon" and targetitem.DefaultEqpSlot == "RH LH" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "SubWeapon" and targetitem.DefaultEqpSlot == "LH" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "SubWeapon" and targetitem.DefaultEqpSlot == "RH LH" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "Hand" and targetitem.DefaultEqpSlot == "GLOVES" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "Foot" and targetitem.DefaultEqpSlot == "BOOTS" then
				flag = flag + 1
			elseif EnableEquipParts[i] == "TopLeg" and (true == (targetitem.DefaultEqpSlot == "SHIRT" or targetitem.DefaultEqpSlot == "PANTS")) then
				flag = flag + 1
			end
		else
			flag = flag + 1
		end
	end

	if flag <= 0 then
		SendSysMsg(pc, "GemNotEquip");
		return
	end




	local curCnt = -1;
	local maxCnt = 0;

	local lv, curExp= GET_ITEM_LEVEL_EXP(item, tempexp);
	local tempclassname = item.ClassName
	local itemName = item.Name;

	--[[
	젬 장착시에는 포텐을 감소하지 않도록 변경되어 주석처리
	local potential = targetitem.PR;

	if potential <= 0 then
		SysMsg(pc, "Item", ScpArgMsg("NotEnoughReinforcePotential"));
		return;
	end
	]]

	-- 소켓개수 알아내기
	for i=0, targetitem.MaxSocket-1 do
		local temp = GetIESProp(targetitem, 'Socket_'..i);
		if temp > 0 then
			maxCnt = maxCnt + 1;
		end
	end

	-- 끼우고자 하는 쩀타입
	local gemtype_number = GET_GEM_TYPE_NUMBER(item.GemType);

	if gemtype_number == -1 then -- 이거 뭐야 무서워
		return;
	end

	for i=0, maxCnt do
		local temp_equip = GetIESProp(targetitem, 'Socket_Equip_'..i);
		local temp_type = GetIESProp(targetitem, 'Socket_'..i);
		if temp_equip == 0 and temp_type == 5 then --프리타입을 먼저 체크
			curCnt = i;
			break;
		end
	end

	-- 소캣 없거나 전부 사용중이거나 장착템이아니면 return
	for i=0, maxCnt do
		local temp_equip = GetIESProp(targetitem, 'Socket_Equip_'..i);
		local temp_type = GetIESProp(targetitem, 'Socket_'..i);
		if temp_equip == 0 and temp_type == gemtype_number then
			curCnt = i;
			break;
		end
	end

	if curCnt == -1 or curCnt >= maxCnt or maxCnt == 0 or targetitem.ItemType ~= 'Equip' then
		print(ScpArgMsg('Auto_SoKaeseopKeoNa_JeonBu_SayongJungiDa'))
		return;
	end

	if IS_ENABLE_EQUIP_GEM(targetitem, item.ClassID) == false then
		SendSysMsg(pc, "ValidDupEquipGemBy{VALID_CNT}", 0, "VALID_CNT", VALID_DUP_GEM_CNT);
		return;
	end

	local tempexp = item.ItemExp;
    local belongingCount = TryGetProp(item, 'BelongingCount');
    if belongingCount == nil then
        belongingCount = 0;
    end 

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	--소켓에 쨈박기. 무슨 쨈 박았는지 저장
	if targetitem['Socket_Equip_' .. curCnt] ~= item.ClassID then
		TxSetIESProp(tx, targetitem, 'Socket_Equip_' .. curCnt, item.ClassID);	
	end

	-- 소켓에 레벨 저장, 아이디는 같지만 레벨이 달라질 수도 있으므로
	if targetitem['Socket_JamLv_' .. curCnt] ~= gemRoastingLv then
		TxSetIESProp(tx, targetitem, 'Socket_JamLv_' .. curCnt, gemRoastingLv);	
	end

	--현재 박는 쨈의 Exp를 아이템의 SocketItemExp_i_NT에 백업
	if targetitem['SocketItemExp_' .. curCnt] ~= tempexp then
		TxSetIESProp(tx, targetitem, 'SocketItemExp_' .. curCnt, tempexp);	
	end

    --현재 박는 쨈의 거래 불가 개수를 아이템의 Socket_GemBelongintCount_i_NT에 백업
	if targetitem['Socket_GemBelongingCount_' .. curCnt] ~= belongingCount then
		TxSetIESProp(tx, targetitem, 'Socket_GemBelongingCount_' .. curCnt, belongingCount);
	end
	
	-- 포텐셜 감소 : 장착은 포텐을 묻지 않게 변경
	--TxSetIESProp(tx, targetitem, 'PR', potential - 1);

	--박은 쨈 아이템 제거 
	
	
	TxTakeItemByObject(tx, item, 1,"TakeGemFromSocket");

	local ret = TxCommit(tx);
	
	
	if ret == 'SUCCESS' then
		InvalidateItem(targetitem);
		SendProperty(pc, targetitem);
		InvalidateStates(pc);
		SocketMongoLog(pc, "GemEquip", tempclassname, lv, tempexp, curCnt, targetitem.ClassName, targetitem);
	end
end

--(구)강화: 현재 사용되고 있지 않음(13.05.13)
function SCR_ITEM_REINFORCE_SERV(pc, itemindex, targetindex, targetspot) -- 타겟 시스템 안쓴다! pc, itemobj, targetobj로 변경함!
	
	local item = GetItemByInvIndex(pc, itemindex);
	local targetitem = GetPCItem(pc, targetindex, targetspot);
	
	if item == nil or targetitem == nil then
		return;
	end

	local potential = targetitem.PR;
	
	if potential <= 0 or targetitem.UseReinforce == 'NO' then
		SysMsg(pc, "Item", ScpArgMsg("NotEnoughReinforcePotential"));
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	TxTakeItem(tx, item.ClassName, 1, 'SCR_ITEM_REINFORCE_SERV');

	local success, itemdestroy = SCR_IS_SUCCESS_REINFORCE(targetitem);

	if success ~= 0 then

		local curreinforce = targetitem.Reinforce;
		TxSetIESProp(tx, targetitem, 'Reinforce', curreinforce + success);		
		--SysMsg(pc, "Item", ScpArgMsg("REINFORCE_SUCCESS"));
		SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_KangHwae_SeongKongHayeossSeupNiDa."), 5);
		PlayEffect(pc, 'hit_sheild', 0.3);

	else
		-- 강화실패시 초기화
		local curreinforce = targetitem.Reinforce;
		TxSetIESProp(tx, targetitem, 'Reinforce', 0);
		--SysMsg(pc, "Item", ScpArgMsg("REINFORCE_FAIL"));
		SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_KangHwae_SilPaeHayeo_ChoKiHwaDoeeossSeupNiDa.."), 5);
		PlayEffect(pc,'explosion_burst');
	end

	-- 강화시도시 성공/실패 상관없이 포텐셜 감소
	local curPR = targetitem.PR;
	TxSetIESProp(tx, targetitem, 'PR', curPR - 1);

	if itemdestroy == 1 then
		TxTakeItemByObject(tx, targetitem, 1);
	end

	local ret = TxCommit(tx);
	
	InvalidateStates(pc);
end

function SCR_IS_SUCCESS_REINFORCE(targetitem)

	local curvalue = targetitem.Reinforce;

	-- 5까지는 확률 100퍼
	if targetitem.GroupName == 'Weapon' then
    	if curvalue < 5 then
    		return 1, 0;
    	else
    		-- 5부터는 확률 50퍼
    		if IMCRandom(1,2) == 1 then
    			return 1, 0;
    		else
    			return 0, 0;
    		end
    	end
    else
        if curvalue < 3 then
    		return 1, 0;
    	else
			-- 5부터는 확률 50퍼
    		if IMCRandom(1,2) == 1 then
    			return 1, 0;
    		else
    			return 0, 0;
    		end
    	end
    end
end

-- 룬을 소켓에 넣기
function SCR_RUNE_EQUIP_SERV(pc, item, targetitem) -- 타겟 시스템 안쓴다! pc, itemobj, targetobj로 변경함!

	local item = GetItemByInvIndex(pc, itemindex);
	local targetitem = GetPCItem(pc, targetindex, targetspot);
		
	local curCnt = 0;
	local maxCnt = 0;

	-- 소켓개수 알아내기	
	for i=0, targetitem.MaxSocket-1 do
		local temp = GetIESProp(targetitem, 'Socket_'..i);
		if temp > 0 then
			maxCnt = maxCnt + 1;
		end
	end

	-- 장착가능한 소캣번호 알아내기
    for i=0, maxCnt do
		local temp = GetIESProp(targetitem, 'Socket_Equip_'..i);
		if temp == 0 then
			curCnt = i;
			break;
		end
	end

	-- 포텐셜 검사
	if targetitem.PR <= 0 then
	    return;
	end

		-- 소캣 없거나 전부 사용중이거나 장착템이아니면 return 
	if curCnt >= maxCnt or maxCnt == 0 or targetitem.ItemType ~= 'Equip' then
		print(ScpArgMsg('Auto_SoKaeseopKeoNa_JeonBu_SayongJungiDa'))
		return;
	end
	
	-- 아이템 렝크와 룬 랭크를 비교해서 넣기 가능한지 체크 (무기 랭크와 비교해서 룬 랭크가 같거나 낮은 룬만 장착 가능하도록)
	if targetitem.ItemStar < item.ItemStar then
		print(ScpArgMsg('Auto_LaengKeuBuJogHaDa.'))
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	local itemName = item.Name;
	TxSetIESProp(tx, targetitem, 'Socket_Equip_' .. curCnt, item.ClassID);	
	TxTakeItem(tx, item.ClassName, 1, "TakeGemFromSocket");
	local ret = TxCommit(tx);
	
	
	if ret == 'SUCCESS' then
		SocketMongoLog(pc, "RuneEquip", item.ClassName, 0, 0, curCnt, targetitem.ClassName, targetitem);
	end

	InvalidateItem(targetitem);
	SendProperty(pc, targetitem);
	InvalidateStates(pc);
end

-- 이미 들어가 있는 쨈 빼기
function SCR_ITEM_SOCKET_REMOVE_SERV(pc, itemindex, targetindex, targetspot) -- 타겟 시스템 안쓴다! pc, itemobj, targetobj로 변경함!

	   
	local item = GetItemByInvIndex(pc, itemindex);
	local targetitem = GetPCItem(pc, targetindex, targetspot);
	
	if item == nil or targetitem == nil or targetitem.ItemType ~= 'Equip' then
		return;
	end
	
	-- 일단 모두다 제거하자
	for i = 0 , SKT_COUNT - 1 do
		
		local val = GetIESProp(targetitem, "Socket_" .. i)	
		
		if val ~= 0 then
			
			-- 이전 정보 저장
			local oldgemtype = GetIESProp(targetitem, "Socket_Equip_" .. i)		
			local ExpOfOldgem = GetIESProp(targetitem, "SocketItemExp_" .. i)		

			local tx = TxBegin(pc);
			if tx == nil then
				return;
			end
			
			TxEnableInIntegrateIndun(tx);

			-- 소켓 초기화
			if targetitem['Socket_Equip_'..i] ~= 0 then
				TxSetIESProp(tx, targetitem, 'Socket_Equip_'..i, 0);
			end
			
			if targetitem['SocketItemExp_'..i] ~= 0 then
				TxSetIESProp(tx, targetitem, 'SocketItemExp_'..i, 0);
			end
			
			-- 포텐도 회복 해야됨
			if usePR == true then
				TxAddIESProp(tx, targetitem, 'PR', 1 );
			end
			
			--새 쨈 만듬
			local newGemitemName = GetClassString("Item", oldgemtype, "ClassName")
			local cmdIdx  = TxGiveItem(tx, newGemitemName, 1, "GemRemove");

			---Exp 복구
			ExpOfOldgem = ExpOfOldgem * 0.95 ; -- 경험치 5%씩 감소

			TxAppendProperty(tx, cmdIdx, "ItemExp", ExpOfOldgem);

			local ret = TxCommit(tx);
				

		end
	end

end

-- 소켓뚫기
function SCR_ITEM_SOCKET_SERV(pc, item, targetitem)
    
	if item == nil or targetitem == nil or targetitem.ItemType ~= 'Equip' then
		return;
	end

	local usePR = true;
	if usePR == true then
		if targetitem.PR <= 0 then
	        return;
	    end
	end

	local maxcnt = targetitem.MaxSocket;
	local curcnt = GET_SOCKET_CNT(targetitem);
	local curmatch = targetitem.Socket_Match;
	
	if curcnt >= maxcnt then
		SysMsg(pc, "Item", ScpArgMsg("ALREADY_MAX_SOCKET"));
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);
		
	if usePR == true then
		TxAddIESProp(tx, targetitem, 'PR', -1 );
	end

	TxTakeItem(tx, item.ClassName, 1, "TakeGemFromSocket");
	local randomsocket = DECIDE_SOCKET_TYPE();
	TxSetIESProp(tx, targetitem, 'Socket_'..curcnt, randomsocket); -- 소켓 모양 랜덤 결정
	if curmatch == 1 then
		TxSetIESProp(tx, targetitem, 'Socket_Match', 0);
	end
		
	local ret = TxCommit(tx);
		
end

function DECIDE_SOCKET_TYPE()

	return 5;
	--[[예전에는 랜덤이었으나 지금 고정이다
	local clslist, cnt  = GetClassList("gemtyperate");
	local rateBorder = {}
	local result = -1

	local tempborder = 0;
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		tempborder = tempborder + cls.Rate;
		rateBorder[i] = tempborder;
	end

	local ran_value = IMCRandom(1, tempborder);

	for i = 0 , cnt - 1 do

		if i == 0 then
			if 0 <= ran_value and ran_value < rateBorder[0] then
				result = i;
				break;
			end
		elseif i == cnt - 1  then
			if rateBorder[i-1] <= ran_value and ran_value < tempborder then
				result = i;
				break;
			end
		else
			if rateBorder[i-1] <= ran_value and ran_value < rateBorder[i] then
				result = i;
				break;
			end
		end
		
	end

	return result + 1; ]]--

end

function SCR_ITEM_LUMIN_SERV(pc, item, targetitem, userarg)
	
	if item == nil or targetitem == nil then
		return;
	end

	local curcnt = GET_SOCKET_CNT(targetitem);
	local maxcnt = targetitem.MaxSocket;
	
	if userarg >= curcnt then
		SysMsg(pc, "Item", ScpArgMsg("INVALUD_SOCKET_POSITION"));
		return;
	end

	local socketclsname = item.StringArg;
	local socketcls = GetClass('Socket', socketclsname);	
	if socketcls == nil then
		return;
	end
	
	local socketid = socketcls.ClassID;
	local CurValue = GetIESProp(targetitem, 'Socket_' .. userarg);
	
	if CurValue ~= socketid then
		SysMsg(pc, "Item", ScpArgMsg("SAME_LUMIN_TYPE"));
		return;
	end
	
	local curmatch =  targetitem.Socket_Match;

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	TxTakeItem(tx, item.ClassName, 1, "TakeGemFromSocket");

	local setsocket = socketid;
	TxSetIESProp(tx, targetitem, 'Socket_' .. userarg, setsocket);
	TxSetIESProp(tx, targetitem, 'Socket_Equip_' .. userarg, item.ClassID);
	TxSetIESProp(tx, targetitem, 'Socket_Match', 1);
	
	local ret = TxCommit(tx);
	
	InvalidateStates(pc);

end

function SCR_DRAG_RECIPE_MANUFACTURE(pc, argList)	
	local makeCount = argList[1];
	local recipeID = argList[2];
	if makeCount <= 0 or recipeID == nil or recipeID <= 0 then
		return;
	end
	
	local recipeProp = geItemTable.GetRecipe(idSpace, recipeID);
	if recipeProp == nil then
		return;
	end


	local recipeCls = GetIES(recipeProp:GetObject());
	
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);
	
	for i = 0, (recipeProp.reqItemSize - 1) do		
		local type = recipeProp:GetReqItem(i);
		local cnt = recipeProp:GetReqItemCount(i);
		local itemCls = GetClassByType("Item", type);
		TxTakeItem(tx, itemCls.ClassName, cnt, "Recipe");
	end	

	TxGiveItem(tx, recipeCls.TargetItem, makeCount, "Recipe");
	local ret = TxCommit(tx);
					

end

function SCR_RECIPE_ITEM(pc, recipeclassID)

	local FromItem = GetRecipeItem(pc, -1, -1);

	if FromItem == nil then
		return;
	end

	local RecipeProp = GetClassByType('Recipe', recipeclassID);
	if RecipeProp == nil then
		return;
	end

	if RecipeProp.EnableScp ~= "None" then
		local ScrPtr = _G[RecipeProp.EnableScp];
		if 0 == ScrPtr(pc) then
			return;
		end
	end

	local sizex = FromItem.NumberArg1;
	local sizey = FromItem.NumberArg1;

	local recipes = {};
	local recipescount = {};
	for i = 0 , sizex - 1 do
		recipes[i] = {};
		recipescount[i] = {};

		for j = 0 , sizey - 1 do
			recipes[i][j], recipescount[i][j] = GetRecipeItem(pc, i, j);
		end
	end

	if 1 == SCR_EXECUTE_RECIPE(pc, FromItem, RecipeProp, recipes, recipescount, sizex, sizey) then
		ReserveAddOnMsg(pc, "ITEM_MIX_END", "", 0);
		return;
	end

end

function SCR_EXECUTE_RECIPE(pc, FromItem, RecipeProp, recipes, recipescount, sizex, sizey)

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	local FromItemCls = GetClass("Item", RecipeProp.FromItem);
	if FromItemCls == nil then
		TxRollBack(tx);
		return 0;
	end

	if FromItemCls.ClassID ~= FromItem.ClassID then
		TxRollBack(tx);
		return 0;
	end

	local isTransaction = 0;
	if RecipeProp.Type == "TransAction" then
		isTransaction = 1;
	end

	TxTakeItemByObject(tx, FromItem, 1, "Recipe");

	local fromitem = nil;
	for i = 0 , sizex - 1 do
		for j = 0 , sizey - 1 do

			fromitem = recipes[i][j];

			local namestr = string.format("Item_%d_%d", i + 1, j + 1);
			local NeedName = RecipeProp[namestr];
			if NeedName ~= "None" then

				if fromitem == nil then
					TxRollBack(tx);
					return 0;
				end

				namestr = string.format("Item_%d_%d_Cnt", i + 1, j + 1);
				local NeedItemCnt = RecipeProp[namestr];

				if NeedItemCnt ~= recipescount[i][j] then
					TxRollBack(tx);
					return 0;
				end

				local CurCount = GetIESItemCount(fromitem);

				if CurCount < NeedItemCnt then
					TxRollBack(tx);
					return 0;
				end

				if isTransaction == 1 then
					TxTakeRecipeItem(tx, fromitem, NeedItemCnt);
				else
					TxTakeItemByObject(tx, fromitem, NeedItemCnt, "Recipe");
				end
			end
		end
	end

	if TxIsFail(tx) == 1 then
		TxRollBack(tx);
		SysMsg(pc, "Item", ScpArgMsg("Auto_JaeLyoKa_BuJogHapNiDa."));
		return 0;
	end

	local x, y, z= GetPos(pc);
	local layer = GetLayer(pc);
	local MonObj = CreateGCIES('Monster', RecipeProp.Monster);
	INIT_ITEM_OWNER(MonObj, pc);
	MonObj.Tactics = RecipeProp.MonsterTactics;
	MonObj.Dialog = RecipeProp.Dialog;
	MonObj.NumArg1 = RecipeProp.ClassID;
    local result = CreateMonster(pc, MonObj, x, y, z, 0, 5);
    local monHandle;
	local ret = "FAIL";
    if result ~= nil then
		SetLayer(result, layer);
        monHandle = GetHandle(MonObj);

		ret = TxCommit(tx);

		if isTransaction == 1 then
			local mon = SetRecipeItemList(tx, pc, monHandle);
			if mon ~= nil then
				RunScript("CHECK_RECIPE_OWNER", mon, pc);
			end
		end

	else
		TxRollBack(tx);
		monHandle = 0;
	end

	if ret == "FAIL" then
		local zoneInst = GetZoneInstID(pc);
		MonObj = GetByHandle(zoneInst, monHandle);
		Kill(MonObj);
	end

	return 1;

end

function CHECK_RECIPE_OWNER(mon, pc)

	while 1 do
		if 1 == IsZombie(pc) then
			Kill(mon);
			return;
		end

		sleep(500);
	end


end

function RECOVER_TX_RECIPE_ITEMS(pc)

	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end


	TxRecoverRecipeItem(tx);
	local ret = TxCommit(tx);
	

end

function STAT_UP_TX(tx, pc, statname, upvalue)

	if upvalue > 0 then
		local CurStat = pc[statname];
		TxSetIESProp(tx, pc, statname, CurStat + upvalue);
    end
    
end

function SCR_AUTO_STAT(pc)
	local bonusstat = GET_STAT_POINT(pc);
	local jobObj = GetJobObject(pc);
	local mainStat = jobObj.MainStat;
	local preStat = pc[mainStat];
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	local reqUseStat = bonusstat;
	local usedStat = pc.UsedStat;
	STAT_UP_TX(tx, pc, mainStat .. "_STAT", reqUseStat);
	TxSetIESProp(tx, pc, "UsedStat", usedStat + reqUseStat);
	
	local ret = TxCommit(tx);

	if ret == 'SUCCESS' then
		InvalidateStates(pc);
		StatPointMongoLog(pc, "AutoUse", bonusstat - reqUseStat, mainStat, ReqUseStat, preStat, pc[mainStat]);
	end
end

function SCR_TX_STAT_UP(pc, list)

	local table = {};

	ReserveAddOnMsg(pc, "RESET_STAT_UP", "", 0);

	for i = 1 , STAT_COUNT do
		table[GetStatTypeStr(i - 1)] = list[i];
		if list[i] > 9999 or list[i] < 0 then
			return;
		end
	end
	
	local tx = TxBegin(pc);
	if tx == nil then
		return;
	end

	TxEnableInIntegrateIndun(tx);

	local ReqUseStat = 0;
	for i = 1 , STAT_COUNT do
		ReqUseStat = ReqUseStat + list[i];
	end

	local bonusstat = GET_STAT_POINT(pc);
	local usedStat = pc.UsedStat;
	if bonusstat < ReqUseStat then
		TxRollBack(tx);
		return;
	end

	local preValue = {};
	for i = 1 , STAT_COUNT do
		local typeStr = GetStatTypeStr(i - 1);
		local value = list[i];
		if 0 < value then
			preValue[i] = pc[typeStr]
			STAT_UP_TX(tx, pc, typeStr .. "_STAT", value);
		end
	end
	
	TxSetIESProp(tx, pc, "UsedStat", usedStat + ReqUseStat);
	
	local ret = TxCommit(tx);
	
	
	if ret == 'SUCCESS' then
		InvalidateStates(pc);
		for i = 1 , STAT_COUNT do
			local typeStr = GetStatTypeStr(i - 1);
			local lowTypeStr = string.lower(typeStr);
			local value = list[i];
			if value > 0 then
				StatPointMongoLog(pc, "Use", bonusstat-ReqUseStat, typeStr, value, preValue[i], pc[typeStr]);
				PlayEffect(pc, 'F_pc_status_' .. lowTypeStr .. '_up', 6.0, 1, "BOT", 1);
				sleep(500);
			end
		end
	end
end

function SCR_GIFT_BUFF(pc,cls)

	if cls ~= nil and cls.Buff ~= "None" then
		local buffLevel = cls.BuffLevel;
		local buffTime = cls.BuffTime * 1000;
		AddBuff(pc, pc, cls.Buff, buffLevel, 0, buffTime);
	end

end

--[[
Step
1~4 -- 몬스터 종류
11~14 몬스터 개수
5~8 아이템 종류

21~ 피격 제한

24 Arg
25 ClassID

Goal
1~4 몬스터 횟수
21 피격 횟수


--]]

function SCR_UPDATE_GUILDQUEST_CONDITION(pc, sObj, resetCount)

	local cls = GetClassByType("GuildQuest", sObj.Step25);
	if cls == nil then
		return;
	end

	-- Step1 ~ Step 4 까지 몬스터 종류
	-- Step11~ Step 14 까지 몬스터 잡는 개수
	for j = 1 , GUILDQUEST_MAX_CNT do

		local monname = cls["MonName" .. j];
		if monname == "None" then
			sObj["Step".. j] = 0;
		else
			local moncls = GetClass("Monster", monname);
			if moncls ~= nil then
				sObj["Step".. j ] = moncls.ClassID;
			else
				sObj["Step".. j ] = -1;
			end

			sObj["Step".. j + 10 ] = cls["MonCount" .. j];

			if resetCount == 1 then
				sObj["Goal".. j ] = 0;
			end
		end

	end

	-- Step5 ~ Step8
	-- Step15 ~ Step18

	for j = 1 , GUILDQUEST_MAX_CNT do
		local temname = cls["ItemName" .. j];
		if temname == "None" then
			sObj["Step".. j + 4] = 0;
		else
			local temcls = GetClass("Item", temname);
			sObj["Step".. j + 4] = temcls.ClassID;
			sObj["Step".. j + 14 ] = cls["ItemCount" .. j];
		end
	end

	sObj.Step21 = cls.FailByDamage;
	if resetCount == 1 then
		sObj.Goal21 = 0;
	end

end

function GET_SKILLVAN_LIST(pc, cls, index, resultlist)
	
	local typeclasses = cls.SkillNames;
	local strList = SCR_STRING_CUT_SPACEBAR(typeclasses);
	local clsType = strList[2*index + 1];
	local clsName = strList[2*index + 2];
	
	local cnt = #resultlist;
	for i = 1 , cnt do

		local info = resultlist[i];
		local type = info["type"];
		local objname = info["name"];
		local level = info["level"];

		if clsType == type and objname == clsName then
			info["level"] = level + 1;
			return;
		end
	end

	resultlist[cnt + 1] = {};
	local info = resultlist[cnt + 1];

	local obj;
	local level = 0;
	
	if clsType == "Ability" then
		obj = GetAbility(pc, clsName);
		if obj ~= nil then
			level = obj.Level + 1;
		else
			level = 1;
		end
	elseif clsType == "Skill" then
		obj = GetSkill(pc, clsName)
		if obj ~= nil then
			level = obj.Level + 1;
		else
			level = 1;
		end
	end

	info["type"] = clsType;
	info["name"] = clsName;
	info["level"] = level;
	info["obj"] = obj;

	return;

end

function CREATE_FROM_LIST(list, keyName)

	local cnt = #list;
	for i = 1 , cnt do
		if list[i]["Key"] == keyName then
			return list[i];
		end	
	end
	
	list[cnt + 1] = {};
	local info = list[cnt + 1];
	info["Key"] = keyName;
	return info;

end

function SKILLVAN_TX_RESULTLIST(tx, resultlist)

	local resultCnt = #resultlist;

	for i = 1 , resultCnt do
		local info = resultlist[i];
		local type = info["type"];
		local clsname = info["name"];
		local level = info["level"];
		local obj = info["obj"];

		if type == "Ability" then
			if obj == nil then
				local idx = TxAddAbility(tx, clsname);
				TxAppendProperty(tx, idx, "Level", level);
			else
				TxSetIESProp(tx, obj, "Level", level);
			end
		elseif type == "Skill" then
			if obj == nil then
				local idx = TxAddSkill(tx, clsname);
				TxAppendProperty(tx, idx, "Level", level);
			else
				TxSetIESProp(tx, obj, "Level", level);
			end
		else
			return 0 ;
		end
	end

	return 1;
	
end

function SCR_TX_SKILLVAN(pc, arglist, ignorePts)
	local jobID = arglist[1];	
	local jobObj = GetClassByType("Job", jobID);
	if jobObj == nil then
		return;
	end
	
	--[[
	-- client hack prevent 
	if 0 == IsPCHaveJob(pc, jobID) then
		return;
	end
	]]
	
	local jobName = jobObj.ClassName;
	
	local havepts = GetRemainSkillPts(pc, jobID);
	if ignorePts ~= 1 and havepts <= 0 then
		return;
	end
	
	local usepoint = 0;
	local sklCnt = (#arglist - 1) / 2;			
	for i = 1 , sklCnt do
		local clsid = arglist[i * 2];
		if clsid == 0 then
			break;
		end

		usepoint = usepoint + 1;
	end

	if ignorePts ~= 1 and havepts < usepoint then
		return;
	end

	local resultlist = {};

	local clslist = GetClassList("SkillVan");
	
	for i = 1 , sklCnt  do
		local clsid = arglist[i * 2];
		local index = arglist[i * 2 + 1];
		if clsid == 0 then
			break;
		end

		local cls = GetClassByTypeFromList(clslist, clsid);
		if cls == nil or 0 == IsClassGroup(cls.ClassName, jobName) then
			break;
		end

		GET_SKILLVAN_LIST(pc, cls, index, resultlist)
	end


	local tx = TxBegin(pc);
	if ignorePts ~= 1 then
		TxConsumeSkillPts(tx, jobID, usepoint);
	end


	if 0 == SKILLVAN_TX_RESULTLIST(tx, resultlist) then
		TxRollBack(tx);
		return;
	end
	
	for i = 1 , sklCnt  do
		local clsid = arglist[i * 2];
		local index = arglist[i * 2 + 1];
		if clsid == 0 then
			break;
		end

		local cls = GetClassByTypeFromList(clslist, clsid);
		if cls == nil then
			break;
		end

		TxSetSkillMap(tx, cls.Row, cls.Col, index, cls.Group);
	end

	ReserveAddOnMsg(pc, "RESET_SKL_UP", "", 0);
	local ret = TxCommit(tx);
	
	InvalidateStates(pc);
end

function SCR_TX_SKILL_UP(pc, arglist, isCheat, inputTx)

	local jobID = arglist[1];
	local havepts = GetRemainSkillPts(pc, jobID);
	if havepts == 0 and isCheat ~= 1 then
		return 0;
	end

	ReserveAddOnMsg(pc, "RESET_SKL_UP", "", 0);

	local treename = GetClassByType("Job", jobID).ClassName;
	
	local treelist = {};
	GET_PC_TREE_INFO_LIST(pc, treename, arglist, treelist);

	local totalconsume = 0;
	local cnt = #treelist;
	for i = 1, 	cnt do
		local info = treelist[i];
		local cls = info["class"];
		local obj = info["obj"];
		local lv = info["lv"];
		local statlv = info["statlv"];
		local totallv = lv + statlv;
		
		totalconsume = totalconsume + statlv;
		
		local maxLV = GET_SKILLTREE_MAXLV(pc, treename, cls);
		if statlv > 0 and totallv > maxLV then		
			return 0;
		end

	end

	if isCheat ~= 1 and totalconsume > havepts then
		return 0;
	end

	local tx;
	if inputTx == nil then
		tx = TxBegin(pc);
	else
		tx = inputTx;
	end

	TxEnableInIntegrateIndun(tx);

	if isCheat ~= 1 then
		TxConsumeSkillPts(tx, jobID, totalconsume);
	end
	for i = 1, 	cnt do
		local info = treelist[i];
		local cls = info["class"];
		local obj = info["obj"];
		local lv = info["lv"];
		local statlv = info["statlv"];
		local totallv = lv + statlv;

		if statlv > 0  then
			if cls.Type == "Ability" then				
				if obj == nil then
					local idx = TxAddAbility(tx, cls.SkillName);
					TxAppendProperty(tx, idx, "Level", totallv);
				else
					TxSetIESProp(tx, obj, "Level", totallv);
				end

			elseif cls.Type == "Skill" then
				if obj == nil then
					local idx = TxAddSkill(tx, cls.SkillName);
					TxAppendProperty(tx, idx, "LevelByDB", totallv);
				else
					TxSetIESProp(tx, obj, "LevelByDB", totallv);
				end

				TxRunScript(tx, "UPDATE_SKILL_PASSIVE", cls.SkillName);

			else
				if inputTx == nil then
					TxRollBack(tx);
				end
				return 0;
			end
		end
	end

	if inputTx == nil then
		local ret = TxCommit(tx);
		InvalidateStates(pc); -- 먼저 스킬레벨을 갱신시키고
		RunEquipScpItem(pc); -- 아이템 스크립트 정보를 갱신시킨뒤
		InvalidateStates(pc); -- 다시 그 정보를 갱신시킨다.
	end

	local skill = GetSkill(pc, "Sage_Portal");
	if skill ~= nil and IsRunningScript(pc, "SCR_UPDATE_SAGE_SKL_CHECK") == 0 then
		RunScript("SCR_UPDATE_SAGE_SKL_CHECK", pc);
	end

	return 1;

end

function UPDATE_SKILL_PASSIVE(pc, skillName)
	
	UpdateSkillPassive(pc, skillName);
		
end

function GET_PC_TREE_INFO_LIST(pc, treename, arglist, treelist)

	local clslist, cnt  = GetClassList("SkillTree");

	local index = 1;
	while 1 do
		local name = treename .. "_" ..index;
		local cls = GetClassByNameFromList(clslist, name);

		if cls == nil then
			break;
		end
		
		if 0 < GET_SKILLTREE_MAXLV(pc, treename, cls) then

			treelist[index] = {};
			local info = treelist[index];
			info["class"] = cls;

			local lv = 0;

			local obj = nil;
			if cls.Type == "Ability" then
				obj = GetAbility(pc, cls.SkillName)
				if obj ~= nil then
					lv = obj.Level;
				end
			elseif cls.Type == "Skill" then
				obj = GetSkill(pc, cls.SkillName)
				if obj ~= nil then
					lv = obj.LevelByDB;
				end
			end

			info["obj"] = obj;
			info["lv"] = lv;
			info["statlv"] = arglist[index + 1];
		end

		index = index + 1;
	end

end


function SCR_TX_COLORSPRAY(pc, colorList)

	local tx = TxBegin(pc);
	if tx == 0 then
		return;
	end

	local ix = colorList[1];
	local iy = colorList[2];
	local iz = colorList[3];
	local angle = colorList[4];

	local cnt = #colorList;
	for i = 1 , cnt - 4 do
		local pixelCnt = colorList[i + 4];
		if pixelCnt > 0 then
			if 0 == TAKE_SPRAY_ITEM(pc, tx, i - 1, pixelCnt) then
				TxRollBack(tx);
				return;
			end
		end
	end

	local ret = TxCommit(tx);
	

	if ret == "FAIL" then
		return;
	end

	local mon = CREATE_MONSTER(pc, "SprayDummy", ix, iy, iz, angle, "Neutral", 0, 12, "MON_SPRAY", nil, GetName(pc), nil, -1);
	if mon == nil then
		mon = CREATE_MONSTER(pc, "SprayDummy", ix, iy, iz, angle, "Neutral", 0, 12, "MON_SPRAY", nil, GetName(pc), nil, 40);
	end

	if mon == nil then
		local cx, cy, cz = GetPos(pc);
		CREATE_MONSTER(pc, "SprayDummy", cx, cy, cz, angle, "Neutral", 0, 12, "MON_SPRAY", nil, GetName(pc), nil, 40);
	end

	if mon ~= nil then
		SetLifeTime(mon, SPRAY_LIFE_TIME());
		SetColorSpray(pc, mon);
		SendAddOnMsg(pc, "SPRAY_CREATED");
	end

end

function TAKE_SPRAY_ITEM(pc, tx, colIndex, pixelCnt)

	local itemName = "ColorSpray_" .. colIndex;
	local item, itemCnt  = GetInvItemByName(pc, itemName);
	if item == nil then
		return 0;
	end

	local totalSprayCnt = GET_TOTAL_SPRAY_PIXEL(itemCnt, item);
	if pixelCnt > totalSprayCnt then
		return 0;
	end

	local pixelCnt = pixelCnt + GET_ADD_SPRAY_USE(pixelCnt, item);

	local useAmount = pixelCnt % MAX_COLSPRAY_PIXEL();
	local usedAmount = item.RemainAmount;
	local setUsedAmount = (usedAmount + useAmount) % MAX_COLSPRAY_PIXEL();

	local useItemCnt = math.floor( (pixelCnt + useAmount) / MAX_COLSPRAY_PIXEL() );

	if useItemCnt >= itemCnt then
		return 0;-- TxTakeItemByObject(tx, item, itemCnt);
	else
		if useItemCnt > 0 then
			TxTakeItemByObject(tx, item, useItemCnt);
		end

		TxSetIESProp(tx, item, 'RemainAmount', setUsedAmount);
	end

	return 1;

end

function SCR_MAP_EVENT_REWARD_ITEM(pc, itemID, type)	
	local itemName = GetClassString("Item", itemID, "ClassName")		
	local eventType  = type[1];
	local eventClsId = type[2];
	local eventNum	 = type[3];
	local itemCount	 = type[4];
	
	if eventType == -1 or itemCount <= 0 then
		return;
	end
	
	local eventCls = GetClassByType("Map_Event_Reward", eventClsId);	
	if eventCls == nil then
		return;
	end
	
	local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");
	if sObj == nil then
		return;
	end
	
	local eventTypeStr = "None";
	if eventType == 0 then
		eventTypeStr = "Questor";
	elseif eventType == 1 then
		eventTypeStr = "Unexpected";	
	elseif eventType == 2 then
		eventTypeStr = "OneShot";		
	end
	
	local propReward = eventCls[eventTypeStr.."PropReward"];	
	if sObj[propReward] >= eventNum then
		return;
	end
	--[[
	local tx = TxBegin(pc);
	TxGiveItem(tx, itemName, itemCount, "MAP_EVENT_REWARD");
	local ret = TxCommit(tx);
		
	if ret == "SUCCESS" then
		local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");
		sObj[propReward] = sObj[propReward] + 1;
		local txt = ScpArgMsg("Auto_BoSang_").. itemName .. ScpArgMsg("Auto_eul_HoeDeugHaSyeossSeupNiDa.");
		SendAddOnMsg(pc, "NOTICE_New_Item", txt, 3);
	end
	]]
end

function SCR_TX_MAP_EVENT_STAT_UP(pc, argList)
	local eventType  = argList[1];
	local eventClsId = argList[2];
	local eventNum	 = argList[3];
	local statCount	 = argList[4];
	
	if eventType == -1 or statCount <= 0 then
		return;
	end
	
	local eventCls = GetClassByType("Map_Event_Reward", eventClsId);	
	if eventCls == nil then
		return;
	end
	
	local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");
	if sObj == nil then
		return;
	end
	
	local eventTypeStr = "None";
	if eventType == 0 then
		eventTypeStr = "Questor";
	elseif eventType == 1 then
		eventTypeStr = "Unexpected";	
	elseif eventType == 2 then
		eventTypeStr = "OneShot";		
	end
	
	local propReward = eventCls[eventTypeStr.."PropReward"];	
	if sObj[propReward] >= eventNum then
		return;
	end
	
	
	-- 여기서 스탯무한핵이 발생됨
	--[[
	local tx = TxBegin(pc);
	local beforeValue = pc.StatByBonus
	TxAddIESProp(tx, pc, 'StatByBonus', statCount);
	local ret = TxCommit(tx);
	local afterValue = pc.StatByBonus
    CustomMongoLog(pc, "StatByBonusADD", "Layer", GetLayer(pc), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", statCount, "Way", "SCR_TX_MAP_EVENT_STAT_UP", "Type", "MAP_EVENT")
	if ret == "SUCCESS" then
		local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");		
		sObj[propReward] = sObj[propReward] + 1;
	end
	]]
end

function SCR_TX_MAP_EVENT_EXP_UP(pc, argList)
	local eventType  = argList[1];
	local eventClsId = argList[2];
	local eventNum	 = argList[3];
	local expCount	 = argList[4];
	
	if eventType == -1 or expCount <= 0 then
		return;
	end
	
	local eventCls = GetClassByType("Map_Event_Reward", eventClsId);	
	if eventCls == nil then
		return;
	end
	
	local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");
	if sObj == nil then
		return;
	end
	
	local eventTypeStr = "None";
	if eventType == 0 then
		eventTypeStr = "Questor";
	elseif eventType == 1 then
		eventTypeStr = "Unexpected";	
	elseif eventType == 2 then
		eventTypeStr = "OneShot";		
	end
	
	local propReward = eventCls[eventTypeStr.."PropReward"];	
	if sObj[propReward] >= eventNum then
		return;
	end
		
		--[[
	local tx = TxBegin(pc);
	TxGiveExp(tx, expCount, "MapEvent");
	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then
		local sObj = GetSessionObject(pc, "SSN_MAPEVENTREWARD");		
		sObj[propReward] = sObj[propReward] + 1;
	end	
	]]
end

function GET_S_REINF_REMAINSEC(pc, item)

	local startTime = GetItemTime(item);
	local sysTime = GetDBTime();
	return GET_ITEM_REINF_REMAIN_TIME(pc, item, startTime, sysTime);
	
end

function SCR_COMPLETE_REINF(pc, itemID)
	local reinfItem = GetReinfItemByGuid(pc, itemID);
	if reinfItem == nil then
		return;
	end
	
	
	local tempObj = CreateIESByID("Item", reinfItem.ClassID);
	CopyChangedProperty(reinfItem, tempObj);
	tempObj.Reinforce = tempObj.Reinforce + 1;
	local refreshScp = reinfItem.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
	end
	
	refreshScp(tempObj);
		
	local remainSec = GET_S_REINF_REMAINSEC(pc, reinfItem);
	local tx = TxBegin(pc);
	local idx = TxGetReinforce(tx, reinfItem);
	TxAppendDifProperty(tx, idx, tempObj, reinfItem);
	DestroyIES(tempObj);
	
	local cpr = GET_REINFORCE_PR(reinfItem);
	local cmpr = GET_REINFORCE_PR(reinfItem);
	TxAppendProperty(tx, idx, "PR", reinfItem.PR - cpr);
	
	local ret = TxCommit(tx);
		

end

function SCR_CANCEL_REINF(pc, itemID)

	local reinfItem = GetReinfItemByGuid(pc, itemID);
	if reinfItem == nil then
		return;
	end
	
	local remainSec, progPrec = GET_S_REINF_REMAINSEC(pc, reinfItem);	
	local refund = GET_REINFORCE_REFUND_PRICE(reinfItem, progPrec);
	local tx = TxBegin(pc);
	TxGetReinforce(tx, reinfItem);
	if refund > 0 then
    	TxGiveItem(tx, MONEY_NAME, refund, 'SCR_CANCEL_REINF');
    end
    
	local ret = TxCommit(tx);
	
	
end

function SCR_ADD_REINFTIME(pc, itemID)

	local item = GetReinfItemByGuid(pc, itemID);
		
	if item == nil then
		return;
	end
		
	local tx = TxBegin(pc);
	TxAddReinforceTime(tx, item, -3600);
	local ret = TxCommit(tx);
	
		
	SendAddOnMsg(pc, "REINF_SUCCESS", "", 0);
end

function GET_PROP_REPAIR_PRICE(item, propName, maxName, fillValue, funcName)

	if fillValue <= 0 then	
		return fillValue;
	end
	
	local curRemainValue = item[maxName] - item[propName];
	if curRemainValue <= 0 then
		return -1;
	end
	
	if fillValue > curRemainValue then
		fillValue = curRemainValue;
	end
	
	return _G[funcName](item, fillValue);	

end

function SCR_TX_REPAIR(pc)

	if IS_VALID_POS_OPEN_UI(pc, "repair140731") ~= 1 then
		return;
	end

	local itemList = GetDlgItemList(pc);
	if itemList == nil then
		return;
	end

	for i = 1, #itemList do
		local item = itemList[i]

		if item == nil then
			return;
		end

		local repairAmount = item.MaxDur - item.Dur

		local totalPrice = 0;
	
		local addPrice = 0;

		addPrice = GET_PROP_REPAIR_PRICE(item, "Dur", "MaxDur", repairAmount, "GET_REPAIR_PRICE");
	
		if addPrice < 0 then
			return;
		end
		totalPrice = totalPrice + addPrice;
	
		if totalPrice <= 0 then
			return;
		end
	
	
		local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
		if pcMoney == nil or cnt < totalPrice then
			SendSysMsg(pc, "NotEnoughMoney");	
			return;
		end
	
	
		local oldDur = item.Dur;
		local newDur = item.Dur + repairAmount;
		local tx = TxBegin(pc);
		TxTakeItem(tx, MONEY_NAME, totalPrice, "Repair");
		if repairAmount > 0 then
			TxSetIESProp(tx, item, 'Dur', newDur);
		end
		
		local ret = TxCommit(tx);
		
		if ret == 'SUCCESS' then
			RepairMongoLog(pc, item, totalPrice, oldDur, newDur, 'NPC');
		end
	end

	PlayTextEffect(pc, "I_SYS_Text_Effect_Skill", ScpArgMsg("RepairComplete"))
	SendAddOnMsg(pc, "UPDATE_DLG_REPAIR", "", 0);
	SendAddOnMsg(pc, "UPDATE_ITEM_REPAIR", "", 0);
	InvalidateStates(pc);

end


function SCR_CREATE_VIRTUAL_SKILL(pc, itemID)	
	local reinfItem = GetPCItemByGuid(pc, itemID);
	if reinfItem == nil then
		return;
	end	
end

function SCR_ITEM_EXP_UP(pc)
    if IsJoinColonyWarMap(pc) == 1 then
        return;
    end

  if IsIndun(pc) == 1 or IsMissionInst(pc) == 1 then
    SendSysMsg(pc, "CannotCraftInIndun");
    return
  end
	if IsRest(pc) ~= 1 then
		SendSysMsg(pc, "AvailableOnlyWhileResting");
		return;
	end

	local invList, itemCntList = GetDlgItemList(pc);
	local tgtItem, tgtGroup, tgtEquipXpGroup = nil, nil, nil

	if invList ~= nil and #invList > 0 then 
		tgtItem = invList[1];
		if tgtItem == nil then
			return;
		end

		tgtGroup = TryGetProp(tgtItem, 'GroupName');
		tgtEquipXpGroup = TryGetProp(tgtItem, 'EquipXpGroup');
		if tgtGroup == nil then
			return;
		end	
	end
	
	for i = 1 , #invList do
		if invList[i].ItemLifeTimeOver == 1 then
    		SendSysMsg(pc, "CannotUseLifeTimeOverItem");
--            SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
            return;
		end
	end
	
	
	
	local makingTime = 5;
	SendAddOnMsg(pc, "ITEM_EXP_START", "", makingTime);
	local result2 = DOTIMEACTION_R(pc, ScpArgMsg("ItemCraftProcess"), 'UPGRADEGEM', makingTime);
	if result2 ~= 1 then
		if IS_KEY_ITEM(tgtItem) then 
			SendAddOnMsg(pc, "ITEM_EXP_STOP_CERTIFICATE", "", 0);
		else
		SendAddOnMsg(pc, "ITEM_EXP_STOP", "", 0);
		end
		return;
	end

	if invList == nil or #invList < 2 then
		if IS_KEY_ITEM(tgtItem) then 
			SendAddOnMsg(pc, "ITEM_EXP_STOP_CERTIFICATE", "", 0);
		else
		SendAddOnMsg(pc, "ITEM_EXP_STOP", "", 0);
	end
		return;
	end

	if 1 == IsFixedItem(tgtItem) then
		if IS_KEY_ITEM(tgtItem) then 
			SendAddOnMsg(pc, "ITEM_EXP_STOP_CERTIFICATE", "", 0);
		else
		SendAddOnMsg(pc, "ITEM_EXP_STOP", "", 0);
		end
		return;
	end
	--local totalPrice = 0;

	local meterialGuidList = {};
	local meterialIDList = {};
	local meterialNameList = {};
	local meterialCntList = {};
	local meterialExpList = {};
	local beforeItemExp = tgtItem.ItemExp;

	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(tgtItem);	
	local tx = TxBegin(pc);
	local totalPoint = 0;

	for i = 2 , #invList do
		local materialItem = invList[i];
		local materialItemcount = itemCntList[i];
		if IsSameObject(tgtItem, materialItem) == 1 or 1 == IsFixedItem(materialItem) then
			TxRollBack(tx);
			return;
		end
		if tgtItem.ItemLifeTimeOver == 1 or materialItem.ItemLifeTimeOver == 1 then
		    TxRollBack(tx);
			return;
		end
		
		if IS_KEY_ITEM(tgtItem) then		-- 합성할 대상이 증표아이템이면
			if IS_KEY_ITEM(materialItem) == false and IS_KEY_MATERIAL(materialItem) == false then -- 재료도 증표아이템이어야한다. 아니라면 안한다.			
				TxRollBack(tx);
				return;
			end
		else								-- 대상이 증표아이템이 아니라면 (젬, 카드)
			if IS_KEY_MATERIAL(materialItem) or IS_KEY_ITEM(materialItem) then	-- 재료는 증표아이템이면 안된다. 								
				TxRollBack(tx);
				return;
			end
		end		
		local exp = GET_MIX_MATERIAL_EXP(materialItem);
		local price = materialItemcount * GET_MATERIAL_PRICE(materialItem);
		--totalPrice = totalPrice + price;
		totalPoint = totalPoint + (materialItemcount * exp);

		meterialGuidList[#meterialGuidList +1] = GetItemGuid(materialItem);
		meterialIDList[#meterialIDList +1] = materialItem.ClassID;
		meterialNameList[#meterialNameList +1] = materialItem.ClassName;
		meterialCntList[#meterialCntList +1] = materialItemcount;
		meterialExpList[#meterialExpList +1] = exp;

		TxTakeItemByObject(tx, materialItem, materialItemcount, "ItemExp");
	end

--	TxTakeItem(tx, MONEY_NAME, totalPrice);
	
	local randValue = IMCRandom(1, 100);
	local multiPlyValue = 1;
	--if randValue <= 25 then
		--multiPlyValue = 3; -- 특정 확률로 경험치 3배 증가 기능 없엠. 김평직 요청 141028
   -- end
   local totalExp = totalPoint * multiPlyValue;
    local totalLevel, cur, max = GET_ITEM_LEVEL_EXP_BYCLASSID(tgtItem.ClassID, beforeItemExp + totalExp);

	-- 마켓 시세 분리를 위한 젬/카드의 레벨 프로퍼티 추가
	if tgtGroup == 'Card' then
		TxSetIESProp(tx, tgtItem, 'CardLevel', totalLevel);
	elseif tgtGroup == 'Gem' then
		TxSetIESProp(tx, tgtItem, 'GemLevel', totalLevel);
	end
	
	local new_item = nil	
	local remain_exp = 0;	
	local cmdIdx = nil
	local new_item_list = {}
	local new_item_exp = {}
	if IS_KEY_ITEM(tgtItem) then -- 증표 아이템이면 렙업시에 새로운 아이템을 생성하는 로직을 돌아야한다.		
		totalLevel = StringSplit(tgtItem.ClassName, 'KQ_token_hethran_')
		totalLevel = totalLevel[2]
		
		while cur >= max do
			local makeItem = 'KQ_token_hethran_'
			totalLevel = totalLevel + 1
			if totalLevel > 2 then
				remain_exp = max - 1
				break
			end
			makeItem = makeItem .. totalLevel
			new_item_list[#new_item_list + 1] = makeItem	
			remain_exp = cur - max
			new_item_exp[#new_item_exp + 1] = remain_exp
			new_item = GetClass("Item", makeItem);
			local lv = 0
			lv, cur, max = GET_ITEM_LEVEL_EXP_BYCLASSID(new_item.ClassID, 0);
			cur = remain_exp			
		end
		
		if new_item ~= nil then				
			cmdIdx  = TxGiveItem(tx, new_item.ClassName, 1, 'ItemExp');			
			TxAppendProperty(tx, cmdIdx, "ItemExp", remain_exp);
			local obj = CloneIES(tgtItem);
			TxTakeItemByObject(tx, tgtItem, 1, 'ItemExp')
			tgtItem = obj
		else
			TxAddIESProp(tx, tgtItem, "ItemExp", totalExp);
		end
	else
		TxAddIESProp(tx, tgtItem, "ItemExp", totalExp);	
	end
	local resultGUID = nil
	if cmdIdx ~= nil then
		resultGUID = TxGetGiveItemID(tx, cmdIdx);
	end
	local ret = TxCommit(tx);	
	if ret ~= "FAIL" then
		if IS_KEY_ITEM(tgtItem) then
			if resultGUID ~= nil then				
				SendAddOnMsg(pc, "ITEM_EXPUP_END_NEW_ITEM", '', totalPoint);				
				for i = 1, #new_item_list do
					if i ~= #new_item_list then
						--print('send : ' .. ('className:' .. new_item_list[i]) .. ' ' .. tostring(new_item_exp[i]))
						--SendAddOnMsg(pc, "ITEM_EXPUP_END_NEW_ITEM", tostring('className:' .. new_item_list[i]), new_item_exp[i]);
					else						
						SendAddOnMsg(pc, "ITEM_EXPUP_END_NEW_ITEM", tostring('guid:' .. tostring(resultGUID)), new_item_exp[i]);
					end
				end				
			else 
				SendAddOnMsg(pc, "ITEM_EXPUP_END_CERTIFICATE", tostring(multiPlyValue), totalPoint);
			end
		else
			SendAddOnMsg(pc, "ITEM_EXPUP_END", tostring(multiPlyValue), totalPoint);	
		end

		if resultGUID ~= nil then
			local invItem = GetInvItemByGuid(pc, resultGUID);
			ItemExpMongoLog(pc, 'ExpUp', invItem, totalPoint, beforeItemExp, invItem.ItemExp, meterialGuidList, meterialIDList, meterialNameList, meterialCntList, meterialExpList);
			tgtItem = invItem
		else
		ItemExpMongoLog(pc, 'ExpUp', tgtItem, totalPoint, beforeItemExp, tgtItem.ItemExp, meterialGuidList, meterialIDList, meterialNameList, meterialCntList, meterialExpList);
		end
		
		InvalidateStates(pc);
		
        if tgtGroup == 'Card' then
            if IsExistItemInAdventureBook(pc, tgtItem.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(pc, tgtItem.Name);
            end
            AddAdventureBookItemPermanentInfo(pc, tgtItem.ClassID, 'CardLevel', totalLevel);
        elseif tgtGroup == 'Gem' then
            if IsExistItemInAdventureBook(pc, tgtItem.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(pc, tgtItem.Name);
            end
            AddAdventureBookItemPermanentInfo(pc, tgtItem.ClassID, 'GemLevel', totalLevel);
        end
	end
	
end

function GIVE_QUEST_COSTUME_TX(pc, tx, QuestName)

    local questIES = GetClass('QuestProgressCheck_Auto', QuestName);
    
    if questIES.Success_ChangeJob ~= 'None' then
        local jobCircle, changeJobCnt = GetJobGradeByName(pc, questIES.Success_ChangeJob);
        
        if jobCircle == 0 then
            local gender;
            local currentCicle = jobCircle + 1;
            
            if pc.Gender == 1 then
                gender = 'm';
            elseif pc.Gender == 2 then
                gender = 'f';
            end
            
            TxGiveItem(tx, "costume_"..questIES.Success_ChangeJob..'_'..gender..currentCicle, 1, 'Quest');
        end
    end
end


-- 아이템 만들때 걸리는 시간 : 5초
function REQ_TX_CREATE_ARROW_CRAFT(self, itemID)

	for i=1, 5 do
		sleep(1000);
		local id = GetArrowCraftItemID(self);
		if id <= 0 or itemID ~= id then
			SendAddOnMsg(self, "FAIL_CREATE_ARROW_ITEM", 'None', itemID);
			return;
		end
	end
		
	local itemCls = GetClassByType('Item', itemID);
	if itemCls == nil then
		SendAddOnMsg(self, "FAIL_CREATE_ARROW_ITEM", 'None', itemID);
		return;
	end

	local recipeCls = GetClass('Recipe', 'R_' .. itemCls.ClassName);
	if recipeCls == nil then
		SendAddOnMsg(self, "FAIL_CREATE_ARROW_ITEM", 'None', itemID);
		return;
	end
		
	local tx = TxBegin(self);
	for i=1, 5 do
		local needItem = recipeCls['Item_' .. i .. '_1'];
		local needCount = recipeCls['Item_' .. i .. '_1_Cnt'];
		if needItem ~= 'None' and needCount > 0 then
			TxTakeItem(tx, needItem, needCount, 'ARROW_CRAFT');
		end
	end
   	TxGiveItem(tx, recipeCls.TargetItem, recipeCls.TargetItemCnt, 'ARROW_CRAFT');
	local ret = TxCommit(tx);
	
	SetArrowCraftItemID(self, 0);

	if ret == 'SUCCESS' then
		SendAddOnMsg(self, "CREATED_ARROW_ITEM", recipeCls.TargetItem, recipeCls.TargetItemCnt);
	else
		SendAddOnMsg(self, "FAIL_CREATE_ARROW_ITEM", 'None', itemID);
	end
end

--프리던전에서 반복 보상을 줄 때 이용
function GIVE_REWARD(self, group, giveway, tx)
	-- Group을 입력하면 reward_freedungeon.xml에 입력된 보상을 가져옴
    local rewardList ={};
    local rewardCnt = {};
    local ratioList = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;
    local clslist, cnt = GetClassList("reward_freedungeon");
    for i = 0, cnt do
        local rewardcls = GetClassByIndexFromList(clslist, i)
        
        if TryGetProp(rewardcls, "Group") == group then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;
        end
    end
    
    local result = IMCRandom(1, totalRatio)

    for i = 0, #ratioList do
        if result <= ratioList[i] then
            if giveway == "Drop" then
				for j = 1, rewardCnt[i] do
            	    local item = CREATE_DROP_ITEM(self, rewardList[i], self);
					SetOwner(item, self);
            	end
            	break;
            else
				if giveway == "Gimmick" then
					GimmickClearMongoLog(self, group, rewardList[i], rewardCnt[i], 1);
				end

                if tx == nil then
                    local tx_new = TxBegin(self);
					TxEnableInIntegrateIndun(tx_new);
                   	TxGiveItem(tx_new, rewardList[i], rewardCnt[i], giveway);
					if rewardList[i] == "Vis" then
					   SysMsg(self, 'Instant', ScpArgMsg("REWARD_SILVER_GET","COUNT", rewardCnt[i]));
					end

                	local ret = TxCommit(tx_new);
                	break;
                else
                   	TxGiveItem(tx, rewardList[i], rewardCnt[i], giveway);
                	break;
                end
            end
        else
            ratioList[i+1] = ratioList[i+1] + ratioList[i];
        end
    end
end

-- 보물상자 열기와 같은 상황에서 돈이 드랍되어서 나오게 하고 싶을 때 사용
function GIVE_REWARD_MONEY(self, owner, amount, count, range)
	local x, y, z = GetPos(self);
	local gold = amount;
    local drop_classname = 'Moneybag2'; -- 금액에따른 크기 설정
	local mon = GetClassByStrProp("Monster", "ClassName", drop_classname);
	local dropRange = range;
	
	if GetClassByType("Monster", mon.ClassID) ~= nil then
		local num = 0;
		for num = 0, count-1 do
			local rdObj = CreateGCIESByID('Monster', mon.ClassID);
			rdObj.ItemCount = gold;
			if dropRange == nil or dropRange < 1 then
			    dropRange = 50;
			end
			local item = CREATE_ITEM(owner, rdObj, owner, x, y, z, 0, dropRange);
			if item ~= nil then
				SetExProp(item, "KD_POWER_MAX", 270);
				SetExProp(item, "KD_POWER_MIN", 120);
			end
		end
	end

end

function TAKE_GUILD_EVENT_REWARD(pc)
	local guildObj = GetGuildObj(pc);
	if guildObj == nil then
	    IMC_LOG("ERROR_GUILD_EVENT", "GuildObj")
		SendSysMsg(pc, "DataErrorWithErrorCode{ErrorCode}", 0, "ErrorCode", 'GuildObj');
		return;
	end

    local isExistEvent = IsExistGuildEvent(guildObj) 
    if isExistEvent == nil or isExistEvent == 0 then
        IMC_LOG("ERROR_GUILD_EVENT", "isExistEvent")
        local guildState = GetGuildEventState(guildObj)
        GuildEventMongoLog(pc, eventID, "IsExistEvent", "State", guildState, 'isExistEvent', isExistEvent)
        return;
    end
    
    if GetGuildEventState(guildObj) ~= "Started" then
        IMC_LOG("ERROR_GUILD_EVENT", "GetGuildEventState")
        return;
    end

    local eventID = GetGuildEventID(guildObj)
    if eventID == nil then
        IMC_LOG("ERROR_GUILD_EVENT", "eventID == nil")
		SendSysMsg(pc, "DataErrorWithErrorCode{ErrorCode}", 0, "ErrorCode", 'GuildEventID');
        return;
    end
    
    local eventCls = GetClassByType("GuildEvent", eventID);
    if eventCls == nil then
        IMC_LOG("ERROR_GUILD_EVENT", "eventCls == nil")
        SendSysMsg(pc, "DataErrorWithErrorCode{ErrorCode}", 0, "ErrorCode", 'List');
        return;
    end
      
    local eventName = TryGetProp(eventCls, "ClassName");
    if  eventName == nil then
        IMC_LOG("ERROR_GUILD_EVENT", "eventName == nil")
        SendSysMsg(pc, "DataErrorWithErrorCode{ErrorCode}", 0, "ErrorCode", 'ClassName');
        return;        
    end

    local addExp = 0;
    local clslist, cnt = GetClassList("reward_guildevent");
    for i = 0, cnt-1 do
        local rewardcls = GetClassByIndexFromList(clslist, i)
        if TryGetProp(rewardcls, "ClassName") == eventCls.ClassName then
            addExp = TryGetProp(rewardcls, "GiveGuildExp")
        end
    end

    if addExp == nil then
        addExp = 0;
    end
    
    local curLevel = guildObj.Level;
    if curLevel >= GUILD_MAX_LEVEL then
        addExp = 0;
	end
    
    local curExp = guildObj.Exp;
    local nextExp = curExp + addExp;
	local nextLevel = GET_GUILD_LEVEL_BY_EXP(nextExp);

    local itemlist, itemcount = SCR_GUILD_EVENT_GIVE_ITEM_LIST(pc, eventCls)
    
    local itemListStr = ""
    local itemCountStr = ""
    
    for l = 1, #itemlist do
        itemListStr = itemListStr..itemlist[l].."/"
        itemCountStr = itemCountStr..itemcount[l].."/"
    end

    GuildEventMongoLog(pc, eventID, "ItemList", "itemListStr", itemListStr, "itemCountStr", itemCountStr)
    
    local tx = TxBegin(pc);

	TxSetPartyProp(tx, PARTY_GUILD, "Exp", nextExp);
	if curLevel ~= nextLevel then
		TxSetPartyProp(tx, PARTY_GUILD, "Level", nextLevel);
	end

    for l = 1, #itemlist do
        _TxGiveItemToPartyWareHouse(tx, PARTY_GUILD, itemlist[l], itemcount[l], "GuildEventReward", 0, nil);
    end
    
    TxSetPartyProp(tx, PARTY_GUILD, "UsedTicketCount", guildObj.UsedTicketCount + 1);
    
	local ret = TxCommit(tx);
	
	if ret ~= "SUCCESS" then
	    IMC_LOG("ERROR_GUILD_EVENT", "ret ~= SUCCESS")
		return;
	end
    
    local guildID = GetGuildID(pc)
    local GuildEventTicketCount = guildObj.GuildEventTicketCount;
    local UsedTicketCount = guildObj.UsedTicketCount;
    
    SuccessGuildEvent(guildObj)
    GuildEventMongoLog(pc, eventID, "Success", "GuildEventTicket", GuildEventTicketCount, "UsedTicketCount", UsedTicketCount)
    GuildEventRewardMongoLog(pc, eventID, itemlist, itemcount)
end

function SCR_REQUEST_CHANGE_NAME_BY_ITEM_BY_WEB(self, itemIES, changeName, itemType)	
	if itemType ~= "GuildName" then	
		return;
	end 
	
	if stringfunction.IsValidCharacterName(changeName) == false then
		return;
	end
	
	local invItem = GetInvItemByGuid(self, itemIES);
	if nil == invItem then
		return
	end
    
	local itemClientScp = TryGetProp(invItem, "ClientScp")
	
	if itemClientScp ~= "CHANGE_GUILD_NAME_BY_ITEM" then
	        return;
	    end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local guildID = nil;	

	local isAlreadyExist = IsPartyNameAlreadyExist(PARTY_GUILD, changeName)
	if isAlreadyExist == 1 then
		SendSysMsg(self, "NameAlreadyExist");
		return;
	end

	guildID = GetGuildID(self);
	if guildID == 0 then
		return;
	end
	
	local partyObj = GetGuildObj(self);
	local isLeader = IsPartyLeaderPc(partyObj, self);
	if isLeader == 0 then
		SendSysMsg(self, "OnlyGuildLeader");
		return;
	end
    
	ChangeGuildName(self, invItem, 1, "use", changeName)	
end


function SCR_REQUEST_CHANGE_NAME_BY_ITEM(self, itemIES, changeName, itemType)
	
	if itemType == "PcName" or itemType == "TeamName" or itemType == "GuildName" then
	else
		return;
	end 
	
	if stringfunction.IsValidCharacterName(changeName) == false then
		return;
	end
	
	local invItem = GetInvItemByGuid(self, itemIES);
	if nil == invItem then
		return
	end
    
	local itemClientScp = TryGetProp(invItem, "ClientScp")
	if itemType == "PcName" then
		if itemClientScp ~= "CHANGE_MYPC_NAME_BY_ITEM" then
	            return;
	        end
	elseif itemType == "TeamName" then
		if itemClientScp ~= "CHANGE_TEAM_NAME_BY_ITEM" then
	            return;
	        end
	elseif itemType == "GuildName" then
		if itemClientScp ~= "CHANGE_GUILD_NAME_BY_ITEM" then
	            return;
	        end
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local guildID = nil;
	local guildName = nil;

	if itemType == "PcName" then
	elseif itemType == "TeamName" then
	elseif itemType == "GuildName" then

		local isAlreadyExist = IsPartyNameAlreadyExist(PARTY_GUILD, changeName)

		if isAlreadyExist == 1 then
			SendSysMsg(self, "NameAlreadyExist");
			return;
		end

		guildID = GetGuildID(self);
		if guildID == 0 then
			return;
		end
		guildName = GetPartyName(guild);

		
		local partyObj = GetGuildObj(self);
		local isLeader = IsPartyLeaderPc(partyObj, self);
		if isLeader == 0 then
			SendSysMsg(self, "OnlyGuildLeader");
			return;
		end
	else
	end



	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	
	TxEnableInIntegrate(tx);
	TxTakeItemByObject(tx, invItem, 1, "use");
	
	if itemType == "PcName" then
		TxChangePcName(tx, GetName(self), changeName)
	elseif itemType == "TeamName" then
		TxChangeFamilyNameFromZone(tx, GetTeamName(self), changeName)
	elseif itemType == "GuildName" then
		TxChangeGuildNameFromZone(tx, guildName, changeName)
	else
	end

	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		return;
	end
end

-- 버튼을 눌렀을때랑 OK 버튼을 눌렀을때랑 리스트가 다르면?
function DELETE_EXPIRED_ITEMS(pc, criteriaTime)
    if pc == nil then
        SendSysMsg(pc, "FailedRemoveTimeExpiredItems");
        return;
    end
    if criteriaTime == nil then
        SendSysMsg(pc, "FailedRemoveTimeExpiredItems");
        return;
    end    

    local overList = GET_EXPIRED_ITEMS(pc, criteriaTime);
    if overList == nil or #overList <= 0 then
        SendSysMsg(pc, "NoTimeExpiredItem");
        return;
    end
    local count = #overList;
    
    local tx = TxBegin(pc);
    for i=1, #overList do
        local item = overList[i];
        TxTakeItemByObject(tx, item, 1, "ExpiredItems");
    end

    local ret = TxCommit(tx);
    if ret == "SUCCESS" then
        SendSysMsg(pc, "SuccessRemoveTimeExpiredItems");
    else
        SendSysMsg(pc, "FailedRemoveTimeExpiredItems");
    end
end

function TX_NEXON_INGAME_SHOP_ITEM_GIVE(pc, itemID, itemCount, orderID, productNO, strOrderNo)

    if pc == nil then
        return;
    end

    local itemCls = GetClassByType("Item", itemID)

    if itemCls == nil then
        return;
    end

    local tx = TxBegin(pc);
	if nil == tx then
		return;
	end

    TxEnableInIntegrate(tx);

    TxGiveItem(tx, itemCls.ClassName, itemCount, "NISMS");
	local ret = TxCommit(tx);
	
    if ret == "SUCCESS" then
        AfterNexonInGameShopItemGive(pc, 1, orderID, productNO, itemCount, strOrderNo)
    else
        AfterNexonInGameShopItemGive(pc, 2, orderID, productNO, itemCount, strOrderNo)
    end


end

function TX_NXA_INGAME_SHOP_GIVE_ITEM(pc, itid, itemID)
    if pc == nil then
        return;
    end
	if itid == nil then
		SendSysMsg(pc, "NXABillingNeedInquiry");
        return;
    end
	if itemID == nil then
		SendSysMsg(pc, "NXABillingNeedInquiry");
        return;
    end

    local itemCls = GetClassByType("Item", itemID)
    if itemCls == nil or TryGetProp(itemCls, "ClassName") == nil or TryGetProp(itemCls, "Name") == nil then
		SendSysMsg(pc, "NXABillingNeedInquiry");
        return;
    end

    local tx = TxBegin(pc);
	if tx == nil then
		SendSysMsg(pc, "NXABillingNeedInquiry");
		return;
	end
	
    TxEnableInIntegrate(tx);

    TxGiveItem(tx, itemCls.ClassName, 1, "NXA");
	local ret = TxCommit(tx);
	
    if ret == "SUCCESS" then
        AfterNexonInGameShopItemGive_NXA(pc, 1, itid, itemID, itemCls.ClassName)
		SendSysMsg(pc, "NXABillingPickUpSuccess{Item}", 0, "Item", itemCls.Name);
    else
        AfterNexonInGameShopItemGive_NXA(pc, 2, itid, itemID, itemCls.ClassName)
		SendSysMsg(pc, "NXABillingNeedInquiry");
    end
end

function TX_NXA_INGAME_SHOP_GIVE_ITEM_LIST(pc, itidList, itemIDList)
    if pc == nil then
        return
    end

	if #itidList ~= #itemIDList then
		SendSysMsg(pc, "NXABillingNeedInquiry");
		return
	end

	local count = #itidList
	for i = 1, count do
		local itid = itidList[i]
		local itemID = itemIDList[i]
		TX_NXA_INGAME_SHOP_GIVE_ITEM(pc, itid, itemID)
	end
end

function IS_EXPIRED_ITEM(itemObj, criteriaTime)
    local itemLifeTimeOver = TryGetProp(itemObj, "ItemLifeTimeOver");
    local itemLifeTime = TryGetProp(itemObj, "ItemLifeTime");
    if itemLifeTimeOver == nil then
        return false;
    end
    if itemLifeTime == nil then
        return false;
    end
    if criteriaTime == nil then
        return false;
    end
    
    local criteriaSysTime = imcTime.GetSysTimeByStr(criteriaTime);
    local expirationSysTime = imcTime.GetSysTimeByStr(itemLifeTime);
    if itemLifeTimeOver == 1 then
        if imcTime.IsLaterThan(criteriaSysTime, expirationSysTime) == 1 then
            return true;
        elseif imcTime.IsEqual(criteriaSysTime, expirationSysTime) == 1 then
            return true;
        end
    end

    return false;
end

function GET_EXPIRED_ITEMS(pc, criteriaTime)
    if pc == nil then
        return;
    end
    if criteriaTime == nil then
        return;
    end

    local itemList = GetInvItemList(pc);
    if itemList == nil then
        return;
    end
    if #itemList <= 0 then
        return;
    end

    local overList = {};
    for i=1, #itemList do
        local itemObj = itemList[i];
        if IS_EXPIRED_ITEM(itemObj, criteriaTime) == true then
            overList[#overList + 1] = itemObj;
        end
    end
    return overList;
end

function SCR_TX_TRADE_SELECT_ITEM(pc, argStr)
	
	local argList = StringSplit(argStr, '#');
	local itemGuid = argList[1];
	local selected = argList[2];

	local item, count = GetInvItemByGuid(pc, itemGuid);
	if item == nil then
		return;
	end
	
	if item.ItemLifeTimeOver == 1 then
		SendSysMsg(pc, "CannotUseLifeTimeOverItem");
		return
	end

	local cls = GetClass("TradeSelectItem", item.ClassName);

	if cls == nil then
		return;
	end

	local giveItemName = TryGetProp(cls, "SelectItemName_"..selected);
	local giveItemCount = TryGetProp(cls, "SelectItemCount_"..selected);

	if giveItemName == nil or giveItemCount == nil then
		return;
	end

	local tx = TxBegin(pc);
	TxEnableInIntegrate(tx);
	TxTakeItemByObject(tx, item, 1, "TradeSelectItem");
	TxGiveItem(tx, giveItemName, giveItemCount, "TradeSelectItem");
	local ret = TxCommit(tx);
end

function SCR_IS_ENABLE_ITEM_LOCK(pc, item, isIndunPlaying)
	if isIndunPlaying == 1 and item ~= nil then
		if IS_INDUN_MULTIPLE_ITEM(item.ClassName) == 1 then
			return 0;
		end
	end

    if (IsIndun(pc) == 1 or IsPVPServer(pc) == 1) and item ~= nil then
        return 0;
    end
	
	if IS_ENABLE_GTOWER_TICKET_LOCK(pc, item) == false then
		return 0;
	end

	return 1;
end

function TX_SAVE_EXP_ORB(pc, invItem, fillingExp, maxExp, changeExpOrbAfterSaved, nextGuid)
	local groupName = TryGetProp(invItem, "GroupName");
	if groupName ~= "ExpOrb" then
		return;
	end

	local curExp = TryGetProp(invItem, "ItemExpString", 'None');
	if curExp == "None" then
		curExp = 0;
	else
		curExp = tonumber(curExp);
	end

	if curExp == nil then
		return;
	end
	
	if curExp > maxExp then
		return;
	end

	if fillingExp > maxExp then
		return;
	end

	local guid = GetItemGuid(invItem);
	local obj, cnt = GetInvItemByGuid(pc, guid);
	if obj == nil then
		return;
	end
	
	local tx = TxBegin(pc);
	TxEnableInIntegrate(tx);
	TxSetIESProp(tx, invItem, "ItemExpString", fillingExp);
	local ret = TxCommit(tx);

	if changeExpOrbAfterSaved == 1 then
		if nextGuid ~= nil and nextGuid ~= "0" then
			SetExpOrbItem(pc, nextGuid);
		else
			ResetExpOrbItem(pc);
		end
	end
end
