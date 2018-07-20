--- hardskill_sage.lua

function SCR_BLINK_MON(self, parent, skl)
    local objList, objCount = SelectObject(parent, 100, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        
        if obj ~= nil and IS_PC(obj) == false then
            local atkerHate = GetHate(obj, parent);
            InsertHate(obj, self, atkerHate * 1.5);
		end
    end
end

function CREATE_BLINK_IMAGE(self, skl, x,y,z, liftTime, propName, funcName)
	CLEAR_DUMMY_PC(self, propName);

	local abilLevel = GET_ABIL_LEVEL(self, "Sage5");
	liftTime = liftTime + abilLevel;

	local faction = GetCurrentFaction(self);
	
	local mon = CREATE_MONSTER_EX(self, "hidden_monster", x, y, z, 0, faction, self.Lv);
	SetOwner(mon, self, 1);
	SetLifeTime(mon, liftTime);
	SetShadowRender(mon, 0);
	local scp = _G[funcName];
	if nil ~= scp then
		scp(mon, self, skl);
	end

	local dpc = CREATE_DUMMYPC(self, x,y,z, GetDirectionByAngle(self), 0, 0, 0);
	if nil == dpc then
		return;
	end

	SetExProp(dpc, propName, 1);
	SetShadowRender(dpc, 0);
	SetCurrentFaction(dpc, faction);
	AddBuff(dpc, dpc, "Blink_ColorBlned", 0, 0, (liftTime * 1000) - 1000)
	SetOwner(dpc, self, 1);
	
	PlayAnim(dpc, 'ASTD');
	RunScript("SCR_BLINK_CHECK_EXIST", dpc, liftTime, mon);
end

function SCR_BLINK_CHECK_EXIST(self, lifeTime, mon)
	local deadTime = imcTime.GetAppTime();
	deadTime = deadTime + lifeTime;

	while 1 do
		local owner = GetOwner(self)
		if nil == owner then
			Kill(self);
			Kill(mon);
			return;
		end

		if IsZombie(owner) == 1 then
			Kill(self);
			Kill(mon);
			return;
		end

		local currentTime = imcTime.GetAppTime();
		if currentTime > deadTime then
			Kill(self);
			Kill(mon);
			return;
		end

		sleep(1000);
	end
end

function SCR_PC_SKL_SAGE_COMMAND(pc, cmd, arg1)
	if pc == nil then
		return 
	end

	if IsZombie(pc) == 1 then
		return;
	end

    if IsJoinColonyWarMap(pc) == 1 then
        return;
    end

	local skilName = "Sage_Portal";
	local skill = GetSkill(pc, skilName);
	if skill == nil then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	if cmd == "/sageSavePos" then
		SAGE_PORATL_SAVE_POINT(pc, etcObj, skill);
	elseif cmd == "/sageDelPos" then
		SAGE_PORATL_DELETE_POINT(pc, etcObj, skill, arg1);
	elseif cmd == "/sageOpenPortal" then
		SAGE_OPEN_TOTRAL_GATE(pc, etcObj,  skill, arg1);
	end
	
end

function SCR_UPDATE_SAGE_SKL_CHECK(pc)
	CreateSageCmd(pc);
end

function SAGE_PORATL_SAVE_POINT(pc, etcObj, skill)
	local etcPropName = 'None'
	local maxCnt = tonumber(SAGE_PORTAL_BASE_CNT); -- + 특성
	
	local abil = GetAbility(pc, "Sage1")
	if abil ~= nil then
	    maxCnt = maxCnt + abil.Level
	end
	
	for i = 1, maxCnt do
		local propName = skill.ClassName .. "_"..i;
		if etcObj[propName] == "None" then
			etcPropName = propName;
			break;
		end
	end

	if etcPropName == 'None' then
		SendSysMsg(pc, "SageMaxSaveCnt");
		return;
	end

	local zoneName = GetZoneName(pc);
	local mapCls = GetClass("Map", zoneName);
	if mapCls == nil or mapCls.MapType ~= "Field" then
		return;
	end

	local x, y, z = GetPos(pc);
	x = math.floor(x);
	y = math.floor(y);
	z = math.floor(z);

	if IsPointToPos(pc, x, y, z) == 0 then
		SendSysMsg(pc, "CantSaveThisPos");
		return;
	end
	
	local propValue = zoneName .. "#"..x.. "#"..y.. "#"..z;
	RunScript("TX_SAGE_PORTAL_SAVE_POINT", pc, etcPropName, propValue);
end

function SAGE_PORATL_DELETE_POINT(pc, etcObj, skill, arg1)
	local propName = skill.ClassName .. "_"..arg1;
	if "None" == etcObj[propName] then
		return;
	end

	local propValue = etcObj[propName];
	local sSave = StringSplit(propValue, "@");
	if #sSave > 1 then
		return;	
	end

	RunScript("TX_SAGE_PORTAL_SAVE_POINT", pc, propName, 'None');
end

function SAGE_OPEN_TOTRAL_GATE(pc, etcObj,  skill, arg1)
	local propName = skill.ClassName .. "_"..arg1;
	local propValue = etcObj[propName];
	if "None" == propValue then
		return;
	end

	local sysTime = GetDBTime();
	local addTime = SAGE_PORTAL_SKL_PORTAL_COOLTIME(skill);
	if 0 >= addTime then
		return;
	end
	sysTime = imcTime.AddSec(sysTime, addTime);	
	local strValue = imcTime.GetStringSysTime(sysTime);

	propValue = propValue.."@"..strValue
	RunScript("TX_SAGE_OPEN_TOTAL", pc, propName, propValue);
end

function TX_SAGE_PORTAL_SAVE_POINT(pc, etcPropName, propValue)	
	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, etcObj, etcPropName, propValue);
	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		return;
	end

	SendProperty(pc, etcObj);
	ExecClientScp(pc, "SAGE_PORTAL_SAVE_SUCCESS()");
end

function TX_SAGE_OPEN_TOTAL(pc, etcPropName, propValue)	
	local sList = StringSplit(propValue, "#");
	if #sList < 4 then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	local tx = TxBegin(pc);
	TxSetIESProp(tx, etcObj, etcPropName, propValue);
	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		return;
	end
	
	local x, y, z = GetPos(pc);
	local mon = CREATE_MONSTER_EX(pc, "npc_hiddennpc02", x, y, z, GetDirectionByAngle(pc), "Neutral", 1, SET_SAGE_WARP_STONE);
	AttachEffect(mon, 'F_circle25', 1, 'TOP')
	local lifeTime = 15;
	SetLifeTime(mon, lifeTime);
	SetExProp_Str(mon, "PARTY_ID", GetPartyID(pc));
	SetExProp_Str(mon, "OwnerCID", GetPcCIDStr(pc));
	local sSave = StringSplit(propValue, "@")
	SetExProp_Str(mon, "SAVE_POINT", sSave[1]);
	ExecClientScp(pc, "SAGE_PORTAL_SAVE_SUCCESS()");
end

function SET_SAGE_WARP_STONE(mon)
	mon.Enter = "None";
	mon.Dialog = "SAGE_WARP";
end

function SCR_SAGE_WARP_DIALOG(self, tgt)	
	local ownerCID = GetExProp_Str(self, "OwnerCID");
	local tgtCID = GetPcCIDStr(tgt);
	if ownerCID ~= tgtCID then
		local partyID = GetExProp_Str(self, "PARTY_ID");
		local tgtPartyID = GetPartyID(tgt);
		if "0" == partyID or "0" == tgtPartyID  then
			SendSysMsg(tgt, "NotBelongsToParty");
			return
		end

		if partyID ~= tgtPartyID then
			SendSysMsg(tgt, "NotBelongsToParty");
			return;
		end
	end

	local savePoint = GetExProp_Str(self, "SAVE_POINT")
	
	local sList = StringSplit(savePoint, "#");
	if #sList < 4 then
		SetZombie(self);
		return;
	end

	local x = tonumber(sList[2]);
	local y = tonumber(sList[3]);
	local z = tonumber(sList[4]);

	MoveZone(tgt, sList[1], x, y, z);
end

function GET_MICRO_ABIL_DUPLICATE_OBJECT()
	local retList = {};
	retList[#retList + 1] = "hidden_monster2";
	retList[#retList + 1] = "pcskill_icewall";
	retList[#retList + 1] = "pcskill_wood_owl2";
	retList[#retList + 1] = "pcskill_stake_stockades";
	retList[#retList + 1] = "skill_New_caltrops";
	retList[#retList + 1] = "attract_pillar";
	retList[#retList + 1] = "pcskill_summon_Familiar";
	retList[#retList + 1] = "russianblue";
	retList[#retList + 1] = "pcskill_dirtypole";
	retList[#retList + 1] = "pcskill_Warlock_DarkTheurge";
	retList[#retList + 1] = "pcskill_Warlock_DarkTheurge_red";
	retList[#retList + 1] = "pavise";
	retList[#retList + 1] = "skill_sapper_trap1";
	retList[#retList + 1] = "skill_sapper_trap4";
	retList[#retList + 1] = "pcskill_stake_stockades";
	retList[#retList + 1] = "pcskill_stake_stockades2";
	retList[#retList + 1] = "skill_Torchlight";
	retList[#retList + 1] = "pcskill_wood_owl2";
	retList[#retList + 1] = "pcskill_merkabah";
	retList[#retList + 1] = "pcskill_pear_of_anquish";
	retList[#retList + 1] = "pcskill_Breaking_wheel";
	
	local sklNameList = {};
	sklNameList[#sklNameList + 1] = "Pyromancer_FireBall";
	sklNameList[#sklNameList + 1] = "Cryomancer_IceWall";
	sklNameList[#sklNameList + 1] = "Dievdirbys_CarveOwl";
	sklNameList[#sklNameList + 1] = "Sapper_StakeStockades";
	sklNameList[#sklNameList + 1] = "QuarrelShooter_ScatterCaltrop";
	sklNameList[#sklNameList + 1] = "Cryomancer_FrostPillar";
	sklNameList[#sklNameList + 1] = "Sorcerer_SummonFamiliar";
	sklNameList[#sklNameList + 1] = "Sorcerer_SummonServant";
	sklNameList[#sklNameList + 1] = "Necromancer_DirtyPole";
	sklNameList[#sklNameList + 1] = "Warlock_Invocation";
	sklNameList[#sklNameList + 1] = "Warlock_Invocation";
	sklNameList[#sklNameList + 1] = "QuarrelShooter_DeployPavise";
	sklNameList[#sklNameList + 1] = "Sapper_PunjiStake";
	sklNameList[#sklNameList + 1] = "Sapper_Claymore";
	sklNameList[#sklNameList + 1] = "Sapper_StakeStockades";
	sklNameList[#sklNameList + 1] = "Sapper_SpikeShooter";
	sklNameList[#sklNameList + 1] = "Kriwi_Aukuras";
	sklNameList[#sklNameList + 1] = "Dievdirbys_CarveOwl";
	sklNameList[#sklNameList + 1] = "Kabbalist_Merkabah";
	sklNameList[#sklNameList + 1] = "Inquisitor_PearofAnguish";
	sklNameList[#sklNameList + 1] = "Inquisitor_BreakingWheel";
	
	local effList = {};
	for i = 1, #retList do 
		effList[i] = "I_wizard_MicroDimension_ground";
	end
	return retList, sklNameList, effList;
end

function TX_SAGE_PORTAL_SHOP(target, owner, skill, price, portalValue)
    if target == nil or owner == nil then
        return;
    end

     -- 세이지 본인은 상점으로 이동 ㄴㄴ함. 더미피씨 못남겨. 그냥 포탈 스킬 쓰세요
    if IsSameObject(target, owner) == 1 then
        SendSysMsg(target, 'CannotUseBecauseOwner');
        return;
    end

    local portalInfoList = StringSplit(portalValue, "@"); -- portalPos@openedTime
    local portalPosList = StringSplit(portalInfoList[1], "#"); -- zoneName#x#y#z
    if #portalPosList < 4 then
        return;
    end

    -- 판매자 재료 검사
    local itemName, needCnt = ITEMBUFF_NEEDITEM_Sage_PortalShop(target, portalPosList[1]);
    local needItem, sellerItemCnt = GetInvItemByName(owner, itemName);    
	if sellerItemCnt < needCnt or IsFixedItem(needItem) == 1 then
		SendSysMsg(target, "NotEnoughRecipe");
		return;
	end

    -- 구매자 돈 검사
    local totalPrice = needCnt * price;
    local pcMoney, moneyCnt  = GetInvItemByName(target, MONEY_NAME);
	if pcMoney == nil or moneyCnt < totalPrice or IsFixedItem(pcMoney) == 1 then
		SendSysMsg(target, "NotEnoughMoney");
		return;
	end
    
    -- Tx    
    local tx1, tx2 = TxBeginDouble(owner, target);
    if tx1 == nil or tx2 == nil then
        return;
    end
    TxTakeItem(tx1, itemName, needCnt, skill.ClassName);
    TxTakeItem(tx2, MONEY_NAME, totalPrice, skill.ClassName);
    local giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100);
    if giveMoney > 0 then
        TxGiveItem(tx1, MONEY_NAME, giveMoney, skill.ClassName);
    end
    local ret = TxCommit(tx1);
    if ret ~= 'SUCCESS' then
        SendSysMsg(target, 'DataError');
        return;
    end

    local destZoneName = portalPosList[1];
    AddAutoSellHistory(owner, AUTO_SELL_PORTAL, needItem.ClassID, needCnt, totalPrice, GetTeamName(target)..'#'..destZoneName);

    -- mongo log
    local destX = portalPosList[2];
    local destY = portalPosList[3];
    local destZ = portalPosList[4];
    local destPosStr = string.format('%d, %d, %d', destX, destY, destZ);
    PortalShopMongoLog(owner, target, skill.Level, destZoneName, destPosStr, totalPrice);

    -- adventure book
    if giveMoney > 0 then
        if IsExistAutoSellerInAdevntureBook(owner, skill.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(owner, skill.Name);
        end
        AddAdventureBookAutoSellerInfo(owner, skill.ClassID, giveMoney);
    end

    SendAddOnMsg(owner, 'UPDATE_PORTAL_STONE');

    MoveZone(target, destZoneName, destX, destY, destZ);
end