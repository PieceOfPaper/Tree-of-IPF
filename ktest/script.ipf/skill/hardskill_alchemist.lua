--- hardskill_alchemist.lua

function ALCHE_DPARTS_COUNT_CHECK(self, skl, dpartsName, dpartsCount)

	local ret = CheckDPartsCount(self, dpartsName, dpartsCount)
	if ret == 0 then
		SkillCancel(self);
	end
end

function ALCHE_DPARTS_ATTACK(self, skl, dpartsName, spd, easing, damRate)
	local tgtList = GetHardSkillTargetList(self);
	for i = 1 , #tgtList do
		local target = tgtList[i];
		local damage = SCR_LIB_ATKCALC_RH(self, skl);
		
		local syncKey = GenerateSyncKey(self);
		--StartSyncPacket(self, syncKey);
		DPartsAttack(self, target, dpartsName, spd, easing, syncKey)
		--damage = damage * dmgRate;
		--TakeDamage(self, target, skl.ClassName, damage);
		-- local monName = 

	end
end

function ALCHE_DPARTS_ATTACH(self, skl, monName, attachDelay, hoverRadius, hoverAngleSpd, attachSpd, attachEasing, nodeName, nodeRandom)
	local tgtList = GetHardSkillTargetList(self);
	for i = 1 , #tgtList do
		local target = tgtList[i];
		DPartsAttach(self, target, monName, attachDelay, hoverRadius, hoverAngleSpd, attachSpd, attachEasing, nodeName, nodeRandom);
	end
end


function ALCHE_DPARTS_HOVER_OWNER(self, skl, lifeTime, damRate, spd, easing)

	local tgtList = GetHardSkillTargetList(self);
	if #tgtList == 0 then
		return;
	end

	local tgt = tgtList[1];
	DPartsHoverOwner(self, tgt, lifeTime, damRate, spd, easing);
end


function SUMMON_KILL_SELF(self, ms)
	sleep(ms);
	Kill(self);
end

function SCR_ALCHE_BRIQUET_EXCUTE(pc, itemList, preservePR)
	if pc == nil then
		return;
	end

    if itemList == nil or #itemList < 2 then -- 적어도 2개는 있어야 함(타겟, 외형 재료/목각 재료[, 외형 재료/목각 코어])
        return;
    end

    -- check target item
    local targetItem = GetInvItemByGuid(pc, itemList[1]);
    if targetItem == nil or IsFixedItem(targetItem) == 1 or targetItem.ItemLifeTimeOver > 0 or IS_VALID_BRIQUETTING_TARGET_ITEM(targetItem) == false then
		return;
	end

	-- check look item
	local lookItem = GetInvItemByGuid(pc, itemList[2]);
	if lookItem == nil or IsFixedItem(lookItem) == 1 or lookItem.ItemLifeTimeOver > 0 or lookItem.ClassType ~= targetItem.ClassType or lookItem.BriquettingIndex > 0 then
    	return;
    end

    -- check look material item
    local lookMatItemList = {};    
    for i = 3, #itemList do
    	lookMatItemList[#lookMatItemList + 1] = GetInvItemByGuid(pc, itemList[i]);    	
    end

    for i = 1, #lookMatItemList do
    	local lookMatItem = lookMatItemList[i];
		if IsFixedItem(lookMatItem) == 1 or lookMatItem.ItemLifeTimeOver > 0 then
	    	return;
	    end
    end

    local result, containDummyItem, containCoreItem = IS_VALID_LOOK_MATERIAL_ITEM(lookItem, lookMatItemList);    
    if result == false then
    	return;
    end

    local needLookItemCnt = GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(lookItem);
    if containDummyItem == true then
    	if #lookMatItemList ~= 0 then
    		return;
    	end
    else
    	if containCoreItem == true then
    		if #lookMatItemList ~= 1 then
    			return;
    		end
    	else
    		if #lookMatItemList ~= needLookItemCnt then
    			return;
    		end

			if preservePR ~= 1 and targetItem.PR < 1 then
				return;
			end
    	end
    end

    -- check money
    local price = 0;
    if containDummyItem == false and containCoreItem == false then
	    if preservePR == 1 then
		    price = GET_BRIQUETTING_PRICE(targetItem, lookItem, lookMatItemList);
		    local myMoneyItem, myMoney = GetInvItemByName(pc, MONEY_NAME);
		    if myMoneyItem == nil or IsFixedItem(myMoneyItem) == 1 or (price > 0 and myMoney < price) then
		    	return;
		    end
		end
	end

    -- log vars
    local briquettingIndex = lookItem.ClassID;
    local materialGuidList = {};
    local materialNameList = {};
    local materialIDList = {};
    local materialCntList = {};
    local visItem, visCount = GetInvItemByName(pc, MONEY_NAME);
    local visItemGuid = nil;
    if visItem ~= nil then
    	visItemGuid = GetItemGuid(visItem);
    end
    
	-- Tx	
	local tx = TxBegin(pc);
	if nil == tx then
		return;
	end

	materialGuidList[#materialGuidList + 1] = GetItemGuid(lookItem);
	materialNameList[#materialNameList + 1] = lookItem.ClassName;
	materialIDList[#materialIDList + 1] = lookItem.ClassID;
	materialCntList[#materialCntList + 1] = 1;
	TxTakeItemByObject(tx, lookItem, 1, 'Briquetting');

	for i = 1, #lookMatItemList do
		local lookMatItem = lookMatItemList[i];

		materialGuidList[#materialGuidList + 1] = GetItemGuid(lookMatItem);
		materialNameList[#materialNameList + 1] = lookMatItem.ClassName;
		materialIDList[#materialIDList + 1] = lookMatItem.ClassID;
		materialCntList[#materialCntList + 1] = 1;
		TxTakeItemByObject(tx, lookMatItem, 1, 'Briquetting');
	end

	if containDummyItem == false and containCoreItem == false then
		if price > 0 then
			TxTakeItemByObject(tx, visItem, price, 'Briquetting');
		else
			TxSetIESProp(tx, targetItem, 'PR', targetItem.PR - 1);
		end
	end

	TxSetIESProp(tx, targetItem, 'BriquettingIndex', briquettingIndex);

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then		
		SendAddOnMsg(pc, 'SUCCESS_BRIQUETTING', GetItemGuid(targetItem), briquettingIndex);		
		BriquettingLog(pc, targetItem, briquettingIndex, materialGuidList, materialIDList, materialNameList, materialCntList, price, visItemGuid, visCount - price);
	end
end

function ITEM_DESTRUCTION_VIS_ABIL(self, skl, eft, eftScale, hitRange, kdPower, useMoney)
    local tx = TxBegin(self);
    TxTakeItem(tx, 'Vis', useMoney, skl.ClassName);
    local angle = GetDirectionByAngle(self);
    local posx, posy, posz = GetPos(self);
    local ax, az = GetXZFromDistAngle(70, angle);
    PlayEffectToGround(self, eft,  posx+ax, posy, posz+az, eftScale, 0.0); 
    OP_DOT_DAMAGE(self, skl.ClassName, posx+ax, posy, posz+az, 0, hitRange, 0, 1, "None", 1.0, kdPower);
    local ret = TxCommit(tx);
end


function ITEM_DESTRUCTION(self, skl, x, y, z, itemCount, range, eft, eftScale, hitRange, damRate, kdPower)
	
	local itemList = {};
	local pcName = GetPcAIDStr(self);
	local count = 0
	local objList, objCount = GetLayerItemList(GetZoneInstID(self), GetLayer(self))
	
	for i = 1, objCount do
		local obj = objList[i];
		if obj.ClassName ~= 'PC' and ( 1 == IsItem(obj)) then
			if 1 == IsPickable(obj) and IsMyItem(obj, pcName) == 1 then
				itemList[#itemList + 1] = obj;

				if #itemList > itemCount-1 then
					break;
				end
			end
		end
	end

	count = #itemList;
	if count > 0 then
		for j = 1, count do
			local item = itemList[j];
		
			if 1 == KillFieldItem(item) then
				local posx, posy, posz = GetPos(item);
				PlayEffectToGround(self, eft, posx, posy, posz, eftScale, 0.0);  
				OP_DOT_DAMAGE(self, skl.ClassName, posx, posy, posz, 0, hitRange, 0, 1, "None", 1.0, kdPower);
			end
		end
	else
	    local abil = GetAbility(self, "Alchemist8")
	    if abil ~= nil then
	        local useMoney = 200
	        local myMoneyCount = GetInvItemCount(self, 'Vis');
	        if myMoneyCount >= useMoney then
	            RunScript("ITEM_DESTRUCTION_VIS_ABIL", self, skl, eft, eftScale, hitRange, kdPower, useMoney);
	        else
	            SendSysMsg(self, "NotEnoughMoney");
	        end
	    else
	        SendSysMsg(self, "NotEnoughDropItem");
	    end
	end

	-- ??? ??
	local monList, monCnt = SelectObjectByClassName(self, range, 'hidden_monster2');	-- hidden_monster2 : ???
	local handle = GetHandle(self);
	for i = 1, monCnt do
		local fireballMon = objList[i];
		if handle == GetExProp(fireballMon, 'CASTER_HANDLE') then
			local fireballSkl = GET_MON_SKILL(self, "Pyromancer_FireBall")
			if fireballSkl ~= nil then
			    local posx, posy, posz = GetPos(fireballMon);
				Kill(fireballMon)
			    PlayEffectToGround(self, "F_explosion097", posx, posy, posz, 0.9, 0.0);
				OP_DOT_DAMAGE(self, fireballSkl.ClassName, posx, posy, posz, 0, hitRange + 20, 0, 1, "None", 1.0, kdPower);
			end
		end
	end
	
end

function DIG_ITEM_DROP(self, skl)
    local item = GetMaterialItem(self);
    for i = 1, skl.Level do
        local digItem = CREATE_DROP_ITEM(self, item, self, skl);
		if nil ~= digItem then
			SetExProp(digItem, skl.ClassName,1);
		end
    end
end

function SCR_USE_HOMUNCULUS(pc, argObj, argStr, argnum1, argnum2, itemType, itemObj)
	local skl = GetSkill(pc, argStr);
	if nil == skl then
		SendSysMsg(pc, 'DonUseItemOnRIde');
		return;
	end

--if skl.LevelByDB < argnum1 then
--	SendSysMsg(pc, 'DonUseItemOnRIde');
--	return;
--end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end
	
	if GetTimeDiff(etcObj.alchemist_Homunculus) < 0 then
		SendSysMsg(pc, 'DonUseItemOnRIde');
		return;
	end

	local mon = SCR_ALCH_CRATE_HOMUNCLUS(pc);
	if nil == mon then
		return;
	end

	local dieData = GetAddDataFromCurrent(argnum2);
	
	TX_ALCH_HOMUNCLUS_TIME_SET(pc, mon, dieData);
	SetHomunClusCommander(mon);
end

function SCR_ALCH_CRATE_HOMUNCLUS(pc)
    if GetZoneName(pc) == 'd_castle_agario' or GetZoneName(pc) == 'f_playground' then
        return nil
    end
	local iesObj = CreateGCIES('Monster', 'pcskill_Homunculus');
	if nil == iesObj then
		SendSysMsg(pc, 'DonUseItemOnRIde');
		return nil;
	end

	local buff = GetBuffByName(pc, 'Homunculus_Skill_Buff')
	if nil ~= buff then
		local arg1, arg2 = GetBuffArg(buff);
		iesObj.Lv = arg1;
	else
		AddBuff(pc, pc, 'Homunculus_Skill_Buff', pc.Lv);
		iesObj.Lv = pc.Lv;
	end

	iesObj.Faction = GetCurrentFaction(pc);
	iesObj.Enter = "None";
	iesObj.Dialog = "HOMUNCLUS_UI";
	iesObj.Name = SofS(iesObj.Name, pc.Name)
	
	local x, y, z = GetFrontRandomPos(pc, 10);
	local mon = CreateMonster(pc, iesObj, x, y, z, 0, 0);
	if nil == mon then
		SendSysMsg(pc, 'DonUseItemOnRIde');
		RemoveBuff(pc, 'Homunculus_Skill_Buff');
		return nil;
	end

	SetOwner(mon, pc);
	AddAlmostDeadScript(mon, "HOMUNCLUS_ON_DEAD");
	RunSimpleAI(mon, 'alchmist_homunclus');
	SCR_HOMUNCLUS_SKl_UPDATE(pc, mon)
	return mon;
end

function HOMUNCLUS_ON_DEAD(mon)
	mon.HP = 1;
	local deadTime = 5 * 1000;
	AddBuff(pet, pet, "Pet_Dead", 1 , 0, deadTime, 1);
end

function SCR_HOMUNCLUS_UI_DIALOG(self, tgt)
	local owner = GetOwner(self)
	if owner == nil then
		SetZomibe(mon);
		return;
	end

	if GetHandle(tgt) ~= GetHandle(owner) then
		return;
	end

	if IsChasingSkill(self) == 1 or IsBattleState(tgt) == 1 then
		return;
	end

	local cnt = GetScpHoldCount(self);
	if cnt > 0 then
		return;
	end

	SendAddOnMsg(tgt, "OPEN_HOMUNCLUS_INFO", self.Name, GetHandle(self));
end

function SCR_HOUMCLUS_SKL_ACQUIRE(pc, sklName)
	local buff = GetBuffByName(pc, 'Homunculus_Skill_Buff')
	if nil == buff then
		return;
	end
	
	local skl = GetSkill(pc, sklName);
	if nil == skl then
		return;
	end

	local sklList = GET_HOMUNCULUS_SKILLS()
	local okSkl = false;
	for i = 1, #sklList do
		if skl.ClassName  == sklList[i] then
			okSkl = true;
			break;
		end
	end

	if false == okSkl then
		return;
	end

	local arg1, arg2 = GetBuffArg(buff);
	local arg3, arg4, arg5 = GetBuffArgs(buff);
	if arg2 == skl.ClassID or arg3 == skl.ClassID or  arg4 == skl.ClassID or  arg5 == skl.ClassID then
		return;
	end

	if 0 == arg2 then
		SetBuffArg(pc, buff, arg1, skl.ClassID, 0)
	elseif 0 == arg3 then
		SetBuffArgs(buff, skl.ClassID, arg4, arg5, pc)
	elseif 0 == arg4 then
		SetBuffArgs(buff, arg3, skl.ClassID, arg5, pc)
	elseif 0 == arg5 then
		SetBuffArgs(buff, arg3, arg4, skl.ClassID, pc)
	else
		return;
	end

	SCR_HOMUNCLUS_SKl_UPDATE(pc);
end

function SCR_HOMUNCLUS_SKl_UPDATE(pc, mon)	
	if mon == nil then
		local list, cnt = GetFollowerList(pc)
		for i = 1, cnt do 
			local obj = list[i];
			if obj.ClassName == 'pcskill_Homunculus'then
				mon = obj;
				break;
			end
		end

		if nil == mon then
			return;
		end
	end

	local buff = GetBuffByName(pc, 'Homunculus_Skill_Buff')
	if nil == buff then
		return;
	end
	
	local arg1, arg2 = GetBuffArg(buff);
	local arg3, arg4, arg5 = GetBuffArgs(buff);
	local argList = {arg2, arg3, arg4, arg5};
	for i = 1, #argList do
		local pCls = GetClassByType("Skill", argList[i])
		if nil ~= pCls then
			local skl = GetSkill(pc, pCls.ClassName);
			if nil ~= skl then
				SetExProp_Str(mon, 'SKL_NAME_'..i, pCls.ClassName);
			end
		end
	end
end

function TX_ALCH_HOMUNCLUS_TIME_SET(pc, mon, dieData)
	if IsZombie(pc) == 1 then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, etcObj, 'alchemist_Homunculus', dieData);

	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		SetZomibe(mon);
		return;
	end

	if dieData == 'None' then	
		Dead(mon);
		RemoveBuff(pc, 'Homunculus_Skill_Buff');
		return;
	end

	local buff = AddBuff(pc, pc, 'Homunculus_Skill_Buff');
	if buff == nil then
		return;
	end

	SetBuffArg(pc, buff, pc.Lv, 0, 0);
end
