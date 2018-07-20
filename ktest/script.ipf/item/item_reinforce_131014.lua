--- item_reinforce_131014.lua

function REINF_MORU_SETTING(mon, hitCount, pcName)
	mon.HitCount = hitCount;
	mon.Name = SofS(mon.Name, pcName);
end

function SCR_ITEM_REINFORCE_131014(pc)
    if IsJoinColonyWarMap(pc) == 1 then
        return;
    end
    


	if IsPVPServer(pc) == 1 then	
		return;
	end

	local itemList = GetDlgItemList(pc);
	if itemList == nil or #itemList ~= 2 then
		return;
	end

	if GetExProp(pc, "MoruInstall") == 1 then
		SendSysMsg(pc, "CannotCreateMoru");
		return;
	end

	local fromItem = itemList[1];
	local moruItem = itemList[2];
	if 0 == IS_MORU_ITEM(moruItem) then
		return;
	end

    if fromItem == nil then
        return
    end

    local itemClass = GetClass("Item",fromItem.ClassName);

    if itemClass == nil then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end

    local isNeedAppraisal = TryGetProp(itemClass, "NeedAppraisal");

    if isNeedAppraisal ~= nil and isNeedAppraisal == 1 and ENABLE_APPRAISAL_ITEM_MOVE ~= 1 then

        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("CHATHEDRAL53_MQ03_ITEM02"), 3);
        return;
    end


	if IsFixedItem(fromItem) == 1 or IsFixedItem(moruItem) == 1 then
		return;
	end

	if 0 == REINFORCE_ABLE_131014(fromItem) then
		return;
	end
	if fromItem.ItemStar == 0 then
		return;
	end

	if IS_NEED_APPRAISED_ITEM(fromItem) == true or IS_NEED_RANDOM_OPTION_ITEM(fromItem) == true  then 
		SendSysMsg(pc, "NeedAppraisd");
		return;
	end

	-- 특정 버프 사용 중에는 강화/초월 막아달라고 하셨음.
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND(pc);
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			SendSysMsg(pc, "CannotReinforceAndTranscendBy{BUFFNAME}", 0, "BUFFNAME", buffCls.Name);
		end
		return;
	end

	local moruName = moruItem.ClassName;
	
	if moruName == "Moru_Premium" or moruName == "Moru_Gold" or moruName == "Moru_Gold_14d" or moruName == "Moru_Gold_TA" or moruName == "Moru_Gold_TA_NR" or moruName == "Moru_Gold_Team_Trade" or moruName == "Moru_Gold_EVENT_1710_NEWCHARACTER" then
		if  fromItem.PR > 0 then
			return;
		end
	end
	local curReinf = fromItem.Reinforce_2;
	if moruName == "Moru_Event160609" or moruName == "Moru_Event160929_14d" then
		if  curReinf > 0 then
		    SendSysMsg(pc, "ItemIsNotEnchantable");
			return;
		end
	end
--    if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
--		local objPR = TryGetProp(fromItem, "PR");
--		if nil == objPR then
--			return;
--		end
--
--		local itemCls = GetClass("Item",fromItem.ClassName);
--		if nil ~= itemCls and tonumber(itemCls.PR) - 1 < fromItem.PR then
--			return;
--		end
--    end

	local totalPrice = GET_REINFORCE_131014_PRICE(fromItem, moruItem, pc)
	
	local retPrice, retCouponList = SCR_REINFORCE_COUPON_PRECHECK(pc, totalPrice)
	
	if retPrice > 0 then
		local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
		if pcMoney == nil or cnt < retPrice then
			SendSysMsg(pc, "NotEnoughMoney");	
			return;
		end
	end

	if GetExProp(fromItem, "REINF_ING") == 1 then
		return;
	end

	local successRate = GET_REINFORCE_131014_SUCCESS_RATE(fromItem, moruItem);

--    if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
--        successRate = 0;
--    end

	local reinForceMode = GetExProp_Str(pc, "OPERATOR_REINFORCE_MODE");

	if reinForceMode == "YES" then
		successRate = 100;
	end

	local isSuccess = 1;
	
	if IMCRandom(1, 100) > successRate then
		isSuccess = 0;
	end

	local fromItemGuid = GetItemGuid(fromItem);

	local scp = string.format("REINFORCE_131014_ITEM_LOCK(\'%s\')", fromItemGuid);
	ExecClientScp(pc, scp);

	local hitCount = GET_REINFORCE_131014_HITCOUNT(fromItem, moruItem);
	local tx = TxBegin(pc);
	if 0 < retPrice then
		TxTakeItem(tx, MONEY_NAME, retPrice, "Reinforce_2");
	end
	TxTakeItemByObject(tx, moruItem, 1, "Reinforce_2");
	if totalPrice ~= retPrice then
	    if #retCouponList > 0 then
    	    for i = 1, #retCouponList do
            	TxTakeItem(tx, retCouponList[i][1], retCouponList[i][3], "Reinforce_2");
    	    end
    	end
	end
	local ret = TxCommit(tx);
	
	if ret ~= "SUCCESS" then
		return;
	end

	local x, y, z = GetValidFrontPos(pc, 20);
	local angle = GetDirectionByAngle(pc)
	local anvilName = "anvil_mon";
	if moruName == "Moru_Premium" or moruName == "Moru_Gold" or moruName == "Moru_Gold_14d" or moruName == "Moru_Gold_TA" or moruName == "Moru_Gold_TA_NR" or moruName == "Moru_Gold_Team_Trade" or moruName == "Moru_Gold_EVENT_1710_NEWCHARACTER" then
		anvilName = "anvil_gold_mon"
	end

	local mon1 = CREATE_MONSTER_EX(pc, anvilName, x, y, z, 0, "HitMe", 1, REINF_MORU_SETTING, hitCount, pc.Name);
	PlaySound(mon1, 'anvil_ground');
	
	if mon1 == nil then
		return;
	end

	SetExProp_Str(mon1, "OWNERAID", GetPcAIDStr(pc));
	SetExProp_Str(mon1, "ITEM_GUID", fromItemGuid);
	SetExProp_Str(mon1, "MORU_NAME", moruName);
	SetExProp(mon1, "RESULT", isSuccess);
    SetExProp(mon1, "SPENT_SILVER", retPrice);
	if totalPrice ~= retPrice then
	    if #retCouponList > 0 then
	        SetExProp(mon1, "SPENT_COUPON_ALL_COUNT", #retCouponList)
    	    for i = 1, #retCouponList do
                SetExProp(mon1, "SPENT_COUPON_NAME"..i, GetClassNumber('Item',retCouponList[i][1],'ClassID'));
                SetExProp(mon1, "SPENT_COUPON_COUNT"..i, retCouponList[i][3]);
    	    end
    	end
	end
	
	SetExProp(pc, "MoruInstall" , 1);
	SetExProp(fromItem, "REINF_ING", 1);

	SetLifeTime(mon1, 300);
	RunScript("ATTACH_MORU_TO_PC", mon1, pc);	
	AddHitScript(mon1, "MORU_MON_HIT");
	EnableTakeDamageScp(1);
	SetTakeDamageScp(mon1, "REINF_MORU_TAKEDAMAGE");

	UPDATE_MORU_DIGIT_EFT(mon1, 0);
	
	if 0 == isSuccess then
		local crashR = IMCRandom(0, 61);
		local crashHP = 1;
		if crashR < 25 then
			crashHP = 3;
		elseif crashR < 45 then
			crashHP = 2;
		end
		SetExProp(mon1, "CRASHHP", crashHP);
	end
end

function ATTACH_MORU_TO_PC(mon, pc)
	local distance = tonumber(MORU_DISTANCE);
	local artDistance = tonumber(MORU_DISTANCE_NEAR);
	local beforTime = 0;
	while 1 do
		if nil == mon or IsZombie(mon) == 1 or 1 == IsDead(mon) then
			break;
		end
		
		if nil == pc or IsZombie(pc) == 1 or 1 == IsDead(pc) then
			break;
		end

		if GetRemainLieftTime(mon) <= 0 then
			break;
		end

		
		local dist = GetDist2D(pc, mon);
		if artDistance <= dist then
			local currentTime = imcTime.GetAppTime();
			if currentTime > beforTime then
				SendSysMsg(pc, "FAR_FROM_MORU");
				beforTime = currentTime + 3000
			end

			if distance < dist then
				break;
			end
		end

		sleep(3000);
	end

	RemoveHitScript(mon, "MORU_MON_HIT");
	RemoveTakeDamageScp(mon, "REINF_MORU_TAKEDAMAGE")
    
	local moruName = GetExProp_Str(mon, "MORU_NAME");
	local spentSilver = GetExProp(mon, "SPENT_SILVER");
    
    local guid = GetExProp_Str(mon, "ITEM_GUID");
    local isPCZombie = IsZombie(pc);
    local isWeapon = 0;
    local reinforceValue = 0;
    local pr = 0;
	if isPCZombie ~= 1 then
		local invItem, count = GetPCItemByGuid(pc, guid);
		if invItem ~= nil then
            isWeapon = TryGetProp(invItem, "GroupName");
            reinforceValue = TryGetProp(invItem, "Reinforce_2");
            pr = TryGetProp(invItem, "PR");
			DelExProp(invItem, "REINF_ING")	
		end

		DelExProp(pc, "MoruInstall")
		local scp = string.format("REINFORCE_131014_ITEM_LOCK(\'%s\')", 'None');
		ExecClientScp(pc, scp);
	end
	Kill(mon);
    
    if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
        CanceledItemPotentialMoruMongoLog(pc, guid, isPCZombie, pr)
    else
        CanceledItemEnchantMongoLog(pc, guid, isPCZombie, isWeapon, reinforceValue, spentSilver);
    end
end

function GET_REINFORCE_131014_SUCCESS_RATE(fromItem, moru)

	local curReinf = fromItem.Reinforce_2;
	local successRatio = 0;
    local classType = TryGetProp(fromItem , "ClassType")
    
	if fromItem.GroupName == 'Weapon' or (fromItem.GroupName == 'SubWeapon' and  classType ~='Shield') then
    	if curReinf < 5 then
    		return 100;
    	else
    	    successRatio = 100 - (curReinf - 4) * 4;
    	    successRatio = (successRatio / 100) ^ 3;
    	    successRatio = successRatio * 100;
    	    
    	    if successRatio < 51.2 then
    	        return 51.2;
    	    else
    	        return successRatio;
    	    end
    	end
    else
        if curReinf < 5 then
    		return 100;
    	else
    	    successRatio = 100 - (curReinf - 2) * 4;
    	    successRatio = (successRatio / 100) ^ 3;
    	    successRatio = successRatio * 100;
    	    
    	    if successRatio < 51.2 then
    	        return 51.2;
    	    else
    	        return successRatio;
    	    end
    	end
    end
	return 51.2;
end

function MORU_MON_HIT(self, from, skl, dmg, ret)
	local ownerAid = GetExProp_Str(self, "OWNERAID");
	
	if ownerAid ~= GetPcAIDStr(from) then
		ret.Damage = 0;
		return;
	end

	-- 특정 버프 사용 중에는 강화/초월 막아달라고 하셨음.
	local buffState = IS_ENABLE_BUFF_STATE_TO_REINFORCE_OR_TRANSCEND(from);
	if buffState ~= 'YES' then
		local buffCls = GetClass('Buff', buffState);
		if buffCls ~= nil then
			SendSysMsg(from, "CannotReinforceAndTranscendBy{BUFFNAME}", 0, "BUFFNAME", buffCls.Name);
		end
		ret.Damage = 0;
		return;
	end

	if ret.Damage ~= 1 then
		ret.Damage = 1;
	end
end
	
function UPDATE_MORU_DIGIT_EFT(mon1, playEft)
	local lastEft = GetExProp_Str(mon1, "LAST_EFT");
	DetachEffect(mon1, lastEft);
	local curHP = mon1.HP;
	local eftName = "F_moru_" .. curHP;
	AttachEffect(mon1, eftName, 5, "TOP", 0, 10, 0);
	SetExProp_Str(mon1, "LAST_EFT", eftName);

	if playEft == 1 then
		DetachEffect(mon1, "F_light011");
		AttachEffect(mon1, "F_light011", 5, "TOP", 0, 10, 0);
	end
end

function REINF_MORU_DEAD(self, owner, ret)

	local savedowneraid = GetExProp_Str(self, "OWNERAID");
	if GetPcAIDStr(owner) ~= savedowneraid then
		return;
	end

	if GetExProp(self, "ITEM_GET") == 1 then
		return;
	end

	SetExProp(self, "ITEM_GET", 1);

	local guid = GetExProp_Str(self, "ITEM_GUID");
	local result = GetExProp(self, "RESULT");		
	local moruName = GetExProp_Str(self, "MORU_NAME");
	local morucls = GetClass('Item', moruName)
	local spentSilver = GetExProp(self, "SPENT_SILVER");		
	
	RunScript("REINF_131014_RESULT", owner, guid, result, self, ret, moruName, morucls.StringArg, spentSilver);

	SetZombieScript(self, "None");
end

function REINF_131014_RESULT(pc, guid, result, monster, ret, moruName, moruType, spentSilver)
	local invItem, count = GetPCItemByGuid(pc, guid);
	if invItem == nil then
		return;
	end
	
	if IsFixedItem(invItem) == 1 then
		return;
	end

	local isEquipped = 0;
	if GetEquipItemByGuid(pc, guid) ~= nil then
		isEquipped = 1;
	end

	local key = GetSkillSyncKey(pc, ret);
	StartSyncPacket(pc, key);
	local delaySec = 1.0;

	EndSyncPacket(pc, key);
	DelExProp(invItem, "REINF_ING")	
	DelExProp(pc, "MoruInstall")
	local scp = string.format("REINFORCE_131014_ITEM_LOCK(\'%s\')", 'None');
	ExecClientScp(pc, scp);

	local itemName = invItem.ClassName;
	local itemReinCount = invItem.Reinforce_2;
	local itemGrade = invItem.ItemGrade;
	local ItemStar = invItem.ItemStar;
	local isBreakItem = 0;
	local isWeapon = invItem.GroupName;
	
	StopRunScript(monster, "ATTACH_MORU_TO_PC");
	local tx = TxBegin(pc)
	if tx == nil then
		return;
	end

	ReinForceHookMsg(pc, itemName, itemReinCount, result);

	if result == 1 then
    	if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
			local potential = invItem.PR;
			TxSetIESProp(tx, invItem, 'PR', potential + 1);
        else
	    	TxAddIESProp(tx, invItem, "Reinforce_2", 1);
	    	if moruName == "Moru_Platinum_Premium" then
	    		local potential = invItem.PR;
	    		TxSetIESProp(tx, invItem, 'PR', potential - 1);
	    	end
	    end
	else
	    if invItem.PR > 0 then
       		if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
				local potential = invItem.PR;
    			TxSetIESProp(tx, invItem, 'PR', potential + 1);
			elseif moruName ~= "Moru_Platinum_Premium" then
				local potential = invItem.PR;
    			TxSetIESProp(tx, invItem, 'PR', potential - 1);
    			
    			if moruType ~= 'DIAMOND' then
    			    TxAddIESProp(tx, invItem, "Reinforce_2", -1);
    			end
			end
    	else
			local reinforce_2 = invItem.Reinforce_2;
       		if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
				local potential = invItem.PR;
    			TxSetIESProp(tx, invItem, 'PR', potential + 1);
			elseif moruName == "Moru_Premium" or moruName == "Moru_Gold" or moruName == "Moru_Gold_14d" or moruName == "Moru_Gold_TA" or moruName == "Moru_Gold_TA_NR" or moruName == "Moru_Gold_Team_Trade"  or moruName == "Moru_Gold_EVENT_1710_NEWCHARACTER"  then
				if  reinforce_2 > 10 then
					TxSetIESProp(tx, invItem, 'Reinforce_2', 10);
				else
					TxAddIESProp(tx, invItem, "Reinforce_2", -1);
				end
			elseif moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
    			TxAddIESProp(tx, invItem, "Reinforce_2", 0);
			else
			    if invItem.ClassID == 635122 then --171114_EVENT_STEAM      
--				    TxGiveItem(tx, 'Event_Goddess_Medal', 1, 'EV171114)_S')TEAM');
				    TxGiveItem(tx, 'Event_drug_steam_team', 3, 'MORU_KING_EVENT');
				end --171114_EVENT_STEAM
				TxTakeItemByObject(tx, invItem, 1, 'Reinforce_2_Fail');
				isBreakItem = 1;
			end
    	end
	end
	
	TxAddAchievePoint(tx, "ReinforceWin", 1);
	
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
    	if result == 1 then
    		InvalidateStates(pc);
    		ShowItemBalloon(pc, "{@st43}","SucessReinforce!!!", "", invItem, 5, delaySec, "enchant_itembox");
            PlayAnim(monster, "success", 1, 1, 0, 1);
            SendHistorySysMsg(pc, 'Reinforce{ISSUCCESS}{ITEM}{LEVEL}', 1, '', 'ISSUCCESS', ClMsg('SUCCESS'), 'ITEM', invItem.Name, 'LEVEL', '+'..tostring(itemReinCount + 1));
    	else
    		ShowItemBalloon(pc, "{@st43_red}", "SucessFail!!!", "", invItem, 5, delaySec, "enchant_itembox");
            PlayAnim(monster, "fail", 1, 1, 0, 1);

            local reinfStr = '';
            if itemReinCount > 0 then
            	reinfStr = '+'..tostring(itemReinCount);
            end
            SendHistorySysMsg(pc, 'Reinforce{ISSUCCESS}{ITEM}{LEVEL}', 1, 'FF00FF', 'ISSUCCESS', ClMsg('Fail'), 'ITEM', invItem.Name, 'LEVEL', reinfStr);
    	end
			if result == 1 then
				ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount+1, spentSilver, moruName);
			else
				if isBreakItem == 1 then
					ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount, spentSilver, moruName);
				else
					ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount, spentSilver, moruName)
				end
			end
			
			if isEquipped == 1 then
				InvalidateStates(pc);
			end						

			if result == 1 then
			    local journal = TryGetProp(invItem,'Journal')
			    if journal == 'TRUE' then
                    if IsExistItemInAdventureBook(pc, invItem.ClassID) == 'NO' then
                        ALARM_ADVENTURE_BOOK_NEW(pc, invItem.Name);
                    end
    			    AddAdventureBookItemPermanentInfo(pc, invItem.ClassID, 'Reinforce_2', itemReinCount + 1);
    			end
			end
		end
--    end
	BroadcastShape(pc); 
end

function REINF_MORU_TAKEDAMAGE(self, from, skl, damage, ret)
	
	local ownerAid = GetExProp_Str(self, "OWNERAID");
	
	if ownerAid ~= GetPcAIDStr(from) then
		--ret.Damage = 0;
		NO_HIT_RESULT(ret);
		return;
	end

	local guid = GetExProp_Str(self, "ITEM_GUID");
	local invItem, count = GetPCItemByGuid(from, guid);
	if invItem == nil then
		Kill(self);
		return;
	end

	ret.ResultType = HITRESULT_BLOW;

	local isSuccess = GetExProp(self, "RESULT");
	if isSuccess == 0 then
		local curHP = self.HP;

		local key = GetSkillSyncKey(self, ret);
		StartSyncPacket(self, key);
		UPDATE_MORU_DIGIT_EFT(self, 1);
		PlayAnim(self, "hit", 1, 1, 0, 1);
		EndSyncPacket(self, key, 0);

		if curHP <= 1 or curHP == damage or GetExProp(self, "CRASHHP") == curHP then
			REINF_MORU_DEAD(self, from, ret);
			self.HP = 0;
		end
		
		return;
	end

	local key = GetSkillSyncKey(self, ret);
	StartSyncPacket(self, key);
	UPDATE_MORU_DIGIT_EFT(self, 1);
	PlayAnim(self, "hit", 1, 1, 0, 1);
	EndSyncPacket(self, key, 0);

	if self.HP <= 1 or self.HP == damage or self.HP <= 0 then
		REINF_MORU_DEAD(self, from, ret);
	end
end