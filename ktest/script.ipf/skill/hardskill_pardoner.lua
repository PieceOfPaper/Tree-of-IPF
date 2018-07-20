--- hardskill_pardoner.lua

function AUTOSELL_BUFF_COMMON(self, target, skillType)

	LookAt(self, target);
	local skillCls = GetClassByType("Skill", skillType);
	PlayAnim(self, skillCls.FileName, 0, 0, 0.7);
end

function AUTOSELL_PAD_BUFF(self, skl, target, skillType, x, y, z, angle, padName)
	if 100 < GetDist2D(self, target) then
		return;
	end

	AUTOSELL_BUFF_COMMON(self, target, skillType)
	x, y, z= GetPos(target);
	RunPad(self, padName, skl, x, y, z, angle, 1, GetHandle(target));

	local buffName = GetPadEnterBuffName(padName)
end

function AUTOSELL_BUFF(self, skl, target, skillType, buffName, lv, arg2, time, over)
	if 100 < GetDist2D(self, target) then
		return;
	end

	AUTOSELL_BUFF_COMMON(self, target, skillType)
	
	local addtime = 0
	
	local spellshopSkl = GetSkill(self, "Pardoner_SpellShop")
	if spellshopSkl ~= nil then
	    addtime = addtime + (time * (1 + (spellshopSkl.Level * 0.8)));
	end
	
	local abil = GetAbility(self, "Pardoner4")
	if abil ~= nil then
	    addtime = addtime + (time * (abil.Level * 0.4));
	end
	
	local buff = ADDBUFF(self, target, buffName, lv, arg2, time + addtime, over, nil, 0, BUFF_FROM_AUTO_SELLER);
end

function SCR_SKILLITEM_MAKE(pc, itemID, argList)
	local skillType = argList[1];
	local level = argList[2];
	local count = argList[3];
	
	local sklCls = GetClassByType("Simony", skillType);
	if sklCls == nil or 'YES' ~= sklCls.CanMake then
		return;
	end
	
	local skillCls = GetClassByType("Skill", skillType);
	local skill = GetSkill(pc, skillCls.ClassName);
	if skill == nil then
		return;
	end

	local myskl = nil;
	if 40000 < skillType and 50000 > skillType then
		myskl = GetSkill(pc, "Pardoner_Simony");
	elseif 20000 < skillType and 30000 > skillType then
		myskl = GetSkill(pc, "Enchanter_CraftMagicScrolls");
	else
		return;
	end

	if nil == myskl then
		return;
	end

	local maxLevel = math.min(skill.Level, myskl.Level);
	if level > maxLevel then
		return
	end
	
	local price = GET_SKILL_MAT_PRICE(skill, level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(myskl.ClassName, skill, level);
	local totalPrice = price * count;
	local totalBottle = bottleCnt * count;
	local myMoney, myMoneyCount = GetInvItemByName(pc, "Vis");
	local myBottle, myBottleCount = GetInvItemByName(pc, bottle);
	if myMoneyCount < totalPrice or myBottleCount < totalBottle or 1 == IsFixedItem(myBottle) then
		return;
	end
	
	RunScript("TX_SCR_SKILLITEM_MAKE", pc, count, skillType, level, myskl.ClassName);

end

function TX_SCR_SKILLITEM_MAKE(pc, count, skillType, level, mySklName)
	
	local skillCls = GetClassByType("Skill", skillType);
	local skill = GetSkill(pc, skillCls.ClassName);
	if skill == nil then
		return;
	end
	
	local makeSec = GET_SKILL_ITEM_MAKE_TIME(skill, count);
	local buff = GetBuffByName(pc, 'ReduceCraftTime_Buff');	    
	if buff ~= nil then
		local buffLevel = GetBuffArg(buff);
		makeSec = makeSec * (1 - buffLevel * 0.05);
	end
	
	local script = string.format("SKILLITEM_MAKE_START(%d)", makeSec);
	ExecClientScp(pc, script);
	PlaySound(pc, 'system_craft_bargauge')
	local anim = 'MAKING_SIMONY'
	if mySklName == 'Enchanter_CraftMagicScrolls' then
		anim = 'MAKING'
	end
	local result2 = DOTIMEACTION_R(pc, ScpArgMsg("ItemCraftProcess"), anim, makeSec);
	if result2 ~= 1 then
	    StopSound(pc, 'system_craft_bargauge')
		PlaySound(pc, 'system_craft_potion_fail')
		return;
	end
	--StopSound(pc, 'system_craft_bargauge')
	PlaySound(pc, 'system_craft_potion_succes')

	local price = GET_SKILL_MAT_PRICE(skill, level);
	local bottle, bottleCnt = GET_SKILL_MAT_ITEM(mySklName, skill, level);
	
	local myBottle, myBottleCount = GetInvItemByName(pc, bottle);
	local myMoney, myMoneyCount = GetInvItemByName(pc, "Vis");
	if nil == myBottle or nil == myMoney then
		return;
	end
	local bottleObj = CloneIES(myBottle);
	local moneyObj = CloneIES(myMoney);
	local totalPrice = price * count;
	local totalBottle = bottleCnt * count;

	local tx = TxBegin(pc);
	local idx = -1;
	TxTakeItem(tx, bottle, totalBottle, skillCls.ClassName);
	TxTakeItem(tx, "Vis", totalPrice, skillCls.ClassName);

	local itemObj = CreateGCIES("Item", "Scroll_SkillItem");
	itemObj.SkillType = skillType;
	itemObj.SkillLevel = level;
	idx = TxGiveItem(tx, itemObj.ClassName, count, "Simony", 0, itemObj);
	local resultGUID = TxGetGiveItemID(tx, idx);
	DestroyIES(itemObj);
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		PardonerSimonyMongoLog(pc, "Simony", count, bottleObj, bottleCnt, moneyObj, price, resultGUID, "Scroll_SkillItem");
	end

	DestroyIES(bottleObj);
	DestroyIES(moneyObj);
end

function OBLATION_INSTALL_CHECK(self)
	local fndList, fndCount = SelectObject(self, 120, 'Neutral');
	for i = 1, fndCount do
		local name = fndList[i].ClassName;
		if name == "statue_raima" or name == "statue_zemina" or name == "statue_vakarine" or name == "statue_ausrine" then
			return 1
		end
	end

	SendSysMsg(self, "AutoSeller_Oblation_Not_Install");
	return 0;
end

function IS_ENABLE_USE_SKILL_SCROLL(self, skillClassName)
    -- 배리어는 콜로니전 타워 범위 내에서는 사용 못하게 해달라고 하셨다
    if skillClassName == 'Paladin_Barrier' and IsJoinColonyWarMap(self) == 1 then
        if IsInColonyTowerRange(self) == 1 then
            SendSysMsg(self, 'CannotUseNearColonyTower');
            return 0;
        end
    end

    return 1;
end