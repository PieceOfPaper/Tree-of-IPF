-- lib_ts.lua

function SCR_LIB_AI_BORN_ENTER(self)
    -- Initialize properties
    -- Remember created position
    MON_CREATEPOS_RESET(self);

end

function SCR_LIB_AI_BORN_UPDATE(self)

    local MonAI = GetAIClass(self);
    if MonAI.BornSummon ~= 'None' then
        ChangeTacticsState(self, 'TS_BORNSUMMON');
        return;
    else
        -- Play born animation
        if GetActionState(self) ~= 'AS_BORN' then
            ChangeTacticsState(self, 'TS_STANDBY');
            return;
        end
    end

end

function SCR_LIB_AI_BORN_LEAVE(self)
end

function SCR_LIB_AI_BORNSUMMON_ENTER(self)

    local MonAI = GetAIClass(self);
    local cnt = IMCRandom(MonAI.BornSummonMinCount, MonAI.BornSummonMinCount);
    local bSummonObj = {};
    local x, y, z = GetPos(self);
    for i =1, cnt do
        bSummonObj[i] = CreateGCIES('Monster', MonAI.BornSummon);
        bSummonObj[i].Tactics = 'MON_SMARTGEN_SUMMON';
        bSummonObj[i].Lv = self.Lv;
        CreateMonster(self, bSummonObj[i], x, y, z, 0, 20);
        SetOwner(bSummonObj[i], self, 0);
    end

end

function SCR_LIB_AI_BORNSUMMON_UPDATE(self)

-- Play born animation
    if GetActionState(self) ~= 'AS_BORN' then
        ChangeTacticsState(self, 'TS_STANDBY');
        return;
    end

end

-- STANDBY
function SCR_LIB_AI_STANDBY_ENTER(self)
    -- Initialize properties

end

function SCR_LIB_AI_STANDBY_UPDATE(self)

    local MonAI = GetAIClass(self);

    if MonAI.Aggressive > 0 then
        local target = GetEnemyTargetObject(self);
        if target ~= nil then
            SetTacticsArgObject(self, target);
            ChangeTacticsState(self, 'TS_TENSION');
            return;
        end
    end

    if MonAI.Aggressive == 0 and self.HP ~= self.MHP then
        local target = GetTopHatePointChar(self);
        if target ~= nil then
            SetTacticsArgObject(self, target);
            ChangeTacticsState(self, 'TS_BATTLE');
            return;
        end
    end

    if MonAI.Return == 'YES' and GetMyHomeDistance(self) > MonAI.SearchRange * 2 then
        ChangeTacticsState(self, 'TS_RETURN');
        return;
    end

    if MonAI.Roaming ~= 'NO' and IMCRandom(0, 9) < 1 then
        ChangeTacticsState(self, 'TS_MOVE');
        return;
    end

end

function SCR_LIB_AI_STANDBY_LEAVE(self)
end

-- TENSION
function SCR_LIB_AI_TENSION_UPDATE(self)

    local MonAI = GetAIClass(self);
    local target = GetEnemyTargetObject(self);

    if IsValidTarget(self, target) == 'YES' then
        if MonAI.SearchRange * MonAI.Aggressive / 10 > GetDistance(self, target) then
            InsertHate(self, target, 50);
            ChangeTacticsState(self, 'TS_BATTLE');
            return;
        elseif GetDistance(self, target) > MonAI.SearchRange * 2 then
            SetTacticsArgObject(self, nil);
            RemoveHate(self, target);
        else
            if math.abs(GetDirectionByAngle(self) - GetTargetDirectionByAngle(self, target)) > 5 then
                SetDirectionByAngle(self, GetTargetDirectionByAngle(self, target));
            end
        end
    else
        if GetEnemyTargetObject(self) == nil then
            ChangeTacticsState(self, 'TS_RETURN');
            return;
        end
    end

end

function GET_SUPERDROP(self)    
    local group = self.GroupName;
    
    if group == 'Monster' then
        if string.sub(self.ClassName, 1, 11) ~= "rootcrystal" then
            local buf = GetBuffByName(self, "SuperDrop");
            if buf == nil then
                return 1, -1.0;
            end
            
            local arg1, arg2 = GetBuffArg(buf);
            return arg1, arg2;
        end
    end
end

-- 보스 킬 순위 출력
function SCR_LIB_BOSSKILL_RANK(self, bossDropRatio, attackerRankList, listCnt, isFieldBoss)    

    if isFieldBoss == 1 or isFieldBoss == true then
        return;
    end

    -- 왕관이 3위까지만있다.
    bossDropRatio = 3;

    local rankCnt = math.min(listCnt, 7); -- 일단은 최대 7명까지만 출력되도록 셋팅
    for i=1, listCnt do
        -- 템먹은애들은 5초 + 순위별 2초씩 차등
        local attacker = attackerRankList[i];   
        if attacker ~= nil then         
            if i <= bossDropRatio then
                local rankEmoticon = 'I_emo_damagerank'..i..'_crown';
                ShowEmoticon(attacker, rankEmoticon, 5000 + ((rankCnt - i) * 2000));
            else
                -- 템못먹은애들은 떨거지니까 5초만 출력.
                local rankEmoticon = 'I_emo_damagerank'..i;
                ShowEmoticon(attacker, rankEmoticon, 5000);
            end
        end
    end
end

function IS_TOP_OWNER_PC(self)
    local topOwner = GetTopOwner(self);
    if topOwner ~= nil then
        if GetObjType(topOwner) == 2 then
            return true;
        end
    end

    return false;
end

-- 보스 아이템 드랍
function SCR_LIB_BOSS_DROP(self, waitMS, isFieldBoss)
    if IS_TOP_OWNER_PC(self) == true then
        return;
    end

    BT_DROP_ITEM(self); 

    -- 퀘스트 보스드랍은 따로 처리 (공헌도를 따지면 쩔 받을 때, 한대도 안때리면 쪼랩유저에게 드랍이 안됨)
    if GetLayer(self) ~= 0 then
        SCR_LIB_QEUST_BOSS_DROP(self, waitMS);
        return;
    end

    sleep(waitMS);  
    local prop = GetClass("ItemDropBoss", self.DropItemList);
    if nil == prop then
        return
    end
    
    local bossDropRatio = prop.DropRatio;       -- 드랍가능한 인원수

    -- 드랍종류는 순위와는 상관없음. 동일하게 랜덤드랍.
    local cnt, droptype = GET_SUPERDROP(self);
    if cnt > 1 then
        local random = IMCRandom(1,100);
        if random < 4 then
            cnt = 5;
        elseif random < 10 then
            cnt = 4;
        elseif random < 20 then
            cnt = 3;
        elseif random < 80 then
            cnt = 2;
        else
            cnt = 1;
        end
    end

    local funcBossItemDrop = _G["PLAY_BOSS_ITEM_DROP"];
    if funcBossItemDrop == nil then
        return;
    end

	if isFieldBoss == 1 then
		local isSingleBoss = TryGetProp(prop, "IsSingleBoss");
		if isSingleBoss == 1 then
			local attackerRankList, listCnt = GetBossDropActorInRank(self, bossDropRatio);
			for j = 1, cnt do
				for i = 1, listCnt do
					local attacker = attackerRankList[i];
					if attacker ~= nil and IS_PC(attacker) == true then
						if CAN_DROP_CONSIDERING_PENALTY(attacker) == true then                                
							local ret = funcBossItemDrop(self, attacker, i, droptype, isFieldBoss);
							if ret ~= 1 then
								CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "FailBossItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
							end
						end
					end
				end
			end

			BossKillMongoLog(self, bossDropRatio);
    
			local sleepTime = self.DeadTime + 1000;
			sleep(sleepTime);
			SCR_LIB_BOSSKILL_RANK(self, bossDropRatio, attackerRankList, listCnt, isFieldBoss);
		else
			local actorRankList, actorList, actorCount = GetBossDropPartyInRank(self, bossDropRatio);
			for j = 1, cnt do
				for i = 1, actorCount do
					local attacker = actorList[i];
					if attacker ~= nil and IS_PC(attacker) == true then
						if CAN_DROP_CONSIDERING_PENALTY(attacker) == true then
							local rewardGrade = "Normal";
							if actorRankList[i] == 0 then
								rewardGrade = "FirstParty";
							end

							local ret = funcBossItemDrop(self, attacker, actorRankList[i] + 1, droptype, isFieldBoss, rewardGrade);
							if ret ~= 1 then
								CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "FailBossItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
							end
						end
					end
				end
			end
			
			local firstAttacker = GetBossDropFirstBlowActor(self);
			local lastAttacker = GetLastAttacker(self);

			-- 보상을 시간차로 주고 있어서 그런지, 킬로그 남길때 남길 정보가 안남아있다. 로그를 먼저 남긴다.
			BossKillMongoLog(self, bossDropRatio);

			sleep(2000);
			if firstAttacker ~= nil and IS_PC(firstAttacker) == true then
				if CAN_DROP_CONSIDERING_PENALTY(firstAttacker) == true and IsBuffApplied(firstAttacker, "Firstblow_Buff") == "YES" then
					PlayEffect(firstAttacker, "F_pc_FirstBlow", 1.3, 'TOP');
					local ret = funcBossItemDrop(self, firstAttacker, 0, droptype, isFieldBoss, "FirstBlow");
					if ret ~= 1 then
						CustomMongoLog(firstAttacker, "RewardBossItemFailed", "Type", "FailBossFirstBlowItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
					end
					
					RemoveBuff(firstAttacker, "Firstblow_Buff");
				end
			end
			
			sleep(2000);
			if lastAttacker ~= nil and IS_PC(lastAttacker) == true then
				if CAN_DROP_CONSIDERING_PENALTY(lastAttacker) == true then
					PlayEffect(lastAttacker, "F_pc_LastBlow", 1.3, 'TOP');
					local ret = funcBossItemDrop(self, lastAttacker, 0, droptype, isFieldBoss, "LastBlow");
					if ret ~= 1 then
						CustomMongoLog(lastAttacker, "RewardBossItemFailed", "Type", "FailBossLastBlowItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
					end
				end
			end
		end
	else
		if bossDropRatio < 7 then
			bossDropRatio = bossDropRatio +  IMCRandom(0, ( 7 - bossDropRatio ));
		end

		local partySaver = {};
		local partySaverIndex = 0;
		local partyObj = nil;
		local partyPass = false;
		
		local attackerRankList, listCnt = GetBossDropActorInRank(self, bossDropRatio);
		for j = 1, cnt do
			for i= 1, listCnt do
				local attacker = attackerRankList[i];
				if attacker ~= nil and IS_PC(attacker) == true then
					local partyMemberList, memberCount = GetPartyMemberList(attacker, PARTY_NORMAL, 0);
					--파티에 속해있는 유저라면 파티 관련 로직을 돌려 줌.
					if partyMemberList ~= nil then
						partyPass = false;
						for k = 1, partySaverIndex do
							--이미 아이템을 먹은 파티는 또 아이템을 받으면 안됨.
							if IsSameObject(partySaver[k], GetPartyObj(attacker)) == 1 then
								partyPass = true;
								break;
							end
						end
						--아이템을 받기 전의 파티이면 아이템을 파티원 수 만큼 떨어트려주고, 파티오브젝트를 저장 순위에 다른 파티원이 있어도
						--아이템을 받지 못하게 끔..     
						if partyPass == false then                        
							for memberIndex = 1, memberCount do
								local partyMember = partyMemberList[memberIndex]
								if CAN_DROP_CONSIDERING_PENALTY(partyMember) == true then                                
									local ret = funcBossItemDrop(self, partyMember, i, droptype, isFieldBoss);
									if ret ~= 1 then
										CustomMongoLog(partyMember, "RewardBossItemFailed", "Type", "FailBossItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
									end
								end
							end
							partySaverIndex = partySaverIndex + 1;
							partySaver[partySaverIndex] = GetPartyObj(attacker);
						end
					else
						--파티가 없는 솔로 유저는 혼자만 아이템을 먹으면 된다.
						local ret = funcBossItemDrop(self, attacker, i, droptype, isFieldBoss);
						if ret ~= 1 then
							CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "FailBossItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
						end
					end
				end
			end
		end

				BossKillMongoLog(self, bossDropRatio);
    
		local sleepTime = self.DeadTime + 1000;
		sleep(sleepTime);
		SCR_LIB_BOSSKILL_RANK(self, bossDropRatio, attackerRankList, listCnt, isFieldBoss);
	end
end

function SCR_SET_BOSS_KILL_ETCPROP(pc, propName, monName, questName)

    local etc = GetETCObject(pc);
    local tx = TxBegin(pc);
    TxAddIESProp(tx, etc, propName, 1);
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        etc[propName] = etc[propName] + 1;
    end

    QuestStateMongoLog(pc, 'None', questName, "Kill_EtcProp", "MonName", monName, 'TX', ret);
end

-- 퀘스트 보스드랍
function SCR_LIB_QEUST_BOSS_DROP(mon, waitMS)    -- PLAY_BOSS_ITEM_DROP 에서 드랍 처리함
    local itemDropPcList = {};
    local index = 0;
        
    local pcList, cnt = GetLayerPCList(GetZoneInstID(mon), GetLayer(mon));
    local monLayer = GetLayer(mon)
    
    for i= 1, cnt do
        local pc = pcList[i];
        if pc ~= nil then
            -- 어뷰징 방지. 트랙내 보스는 처음잡을때만 드랍하기로함. etc prop에서 체크하도록 변경됨
            local pcetc = GetETCObject(pc);
            if pcetc['Kill_' .. mon.ClassName] == 0 then
                index = index + 1;
                itemDropPcList[index] = pc;

                local questName = 'TRACK_BOSS';
                if monLayer > 0 then
                    questName = GetExProp_Str(pc, "LayerEventName");
                end
				
				if IsBuffApplied(pc, "ChallengeMode_Player") == "NO" then
					RunScript("SCR_SET_BOSS_KILL_ETCPROP", pc, 'Kill_' .. mon.ClassName, mon.ClassName, questName);
				end
            end
		end
    end

    sleep(waitMS);

    local prop = GetClass("ItemDropBoss", mon.DropItemList);
    if prop ~= nil then
        for i= 1, index do
            local pc = itemDropPcList[i];
            if pc ~= nil then
                if 0 == IsDummyPC(pc) then
                    local questName = 'TRACK_BOSS';
                    if monLayer > 0 then
                        questName = GetExProp_Str(pc, "LayerEventName");
                    end
                    QuestStateMongoLog(pc, 'None', questName, "BossDrop", "MonName", mon.ClassName);
                    
                    local func = _G["PLAY_BOSS_ITEM_DROP"];
                    if func ~= nil then
                        local ret = func(mon, pc, i, -1, 0, "None");
                        if ret ~= 1 then
                            CustomMongoLog(attacker, "RewardItemOnmission", "Type", "FailQuestItemDrop", "MobID", self.ClassID, "MobName", self.ClassName);
                        end
                    end
                end
            end
        end
    end
    
end

-- DEAD
function SCR_LIB_AI_ITEM_DROP(self)
    if IS_TOP_OWNER_PC(self) == true then
        return;
    end
    
    DropCommon(self);
    --local topAttacker = GetTopAttacker(self); 
    -- 전투스크럼12일차에 의해 막타친놈에게 템드랍하도록 변경.
    local topAttacker = GetTopContributionAttacker(self);
    
    if topAttacker == nil or GetObjType(topAttacker) ~= 2 then  -- (2 == PC)
        return;
    end
    
    local prop = GetClass("ItemDropBoss", self.DropItemList);
    if prop ~= nil then
        return;
    end
    
    local cnt, droptype = GET_SUPERDROP(self);  
    --for i = 1 , 1 do
        SCR_LIB_ITEM_DROP(self, topAttacker, droptype);
    --end

    --SCR_LIB_ITEM_SUPER_DROP(self, topAttacker, droptype);

end

function SEL_ITEM_DROP(self, topAttacker, dropItemList, dropItemName, dropCount, drop, superDrop, isHasEliteBuff)
    local dropType = "";
    if drop ~= nil then
        dropType = drop.Type;
    end
    
    if dropType == 'Exp_Hi' then
            local party_list, party_cnt = GET_PARTY_ACTOR(topAttacker, 0)        
            local party_drop = {}

            if party_cnt > 0 then
                for index = 1, party_cnt do
                    party_drop[#party_drop + 1] = {}
                    party_drop[#party_drop][1] = party_list[index]
                    if IsSameActor(topAttacker,party_list[index]) == 'YES' then
                        party_drop[#party_drop][2] = dropCount
                    else
                        party_drop[#party_drop][2] = math.floor(dropCount * 0.5)
                    end
                end
            else
                party_drop[1] = {}
                party_drop[1][1] = topAttacker
                party_drop[1][2] = dropCount;
            end
        
            for index2 = 1, #party_drop do
            ownerExist = 1;        
            RunScript('MON_HITME_CREATE', self, party_drop[index2][1], dropItemName, party_drop[index2][2])
        end

        elseif dropType == 'Money_Hi' then                       -- 골드바 통으로 떨어져야 된다고 해서 수정        
            SCR_DROP_MONEY_HI(self, topAttacker, GetName(topAttacker), dropCount);
        elseif dropType == 'Dice' then        
            local exp = GetDistributeExp(self);
                        
            if exp > 0 then
                local x, y, z = GetDeadPos(self);
                ownerExist = 1;
                local value = IMCRandom(1,6);

                itemObj = CreateGCIES('Monster', dropItemName..value);                          
                local name = GetName(topAttacker);
                local item = CreateMonster(self, itemObj, x, y, z, 0, 5);

                if item ~= nil then
                    local self_layer = GetLayer(self);
                    if self_layer ~= nil and self_layer ~= 0 then
                        SetLayer(item, self_layer);
                    end

                    local nextDice;
                    local rand = IMCRandom(1,100);
                    if rand <= 30 then
                        nextDice = 1;
                    elseif 30 < rand and rand <= 50 then
                        nextDice = 2;
                    elseif 50 < rand and rand <= 65 then
                        nextDice = 3;
                    elseif 65 < rand and rand <= 78 then
                        nextDice = 4;
                    elseif 78 < rand and rand <= 90 then
                        nextDice = 5;
                    else
                        nextDice = 6;
                    end

                    if (nextDice-value < 1) then

                    else
                        exp = exp * (nextDice - value)
                    end                             

                    SetDiceNum(item, nextDice)
                    SetDiceExp(item, exp);  
                                                            
                else
                    ownerExist = 0;
                end
        end -- exp > 0
    else        
        local x, y, z = GetDeadPos(self);
		
		local eliteBonusSilverDropFactor = 1;
		local eliteBonusSilverDropCount = 1;
		local isMoney = false
		if string.find(dropType, 'Money') ~= nil and isHasEliteBuff == 1 then
			eliteBonusSilverDropCount = 10;
			eliteBonusSilverDropFactor = 0.5;
			isMoney = true
		end

		for i = 1, eliteBonusSilverDropCount do
			local itemObj = CreateGCIES('Monster', dropItemName);
			if itemObj == nil then
				return nil;
			end
        
			itemObj.ItemCount = dropCount;

			if isMoney == false then
				if CAN_DROP_CONSIDERING_PENALTY(topAttacker) == true then
					local name = GetName(topAttacker);
					local item = CREATE_ITEM(self, itemObj, topAttacker, x, y, z, 0, 5);                
					if item ~= nil then
						SetExProp(item, "SUPER_DROP", superDrop)
						if drop ~= nil then
							local itemObject = GetItemObjectOfMon(item);
							local prop = TryGetProp(drop, "ItemProperty");
							if prop ~= nil and prop ~= "None" then
								local tokenList = TokenizeByChar(prop, "#");
								for i = 1, #tokenList / 2 do
									local propName = tokenList[2 * i - 1];
									local propValue = tokenList[2 * i];
									itemObject[propName] = propValue;                   
								end
							end
						end
						ItemDropMongoLog(self, topAttacker, dropItemName, dropCount, superDrop, item.UniqueName, item);            

							if string.find(dropType, 'Money') ~= nil then -- Money_Mid                
								SetTacticsArgFloat(item, 0, 0, 10)
							end
							local self_layer = GetLayer(self);
							if self_layer ~= nil and self_layer ~= 0 then
								SetLayer(item, self_layer);
							end
						local power = 1;
						if dropCount > 10 then
							power = 2
						end
					end
				end
			else    -- Money 면 무조건 드랍, pickitem에서 감소시킨다.

				itemObj.ItemCount = itemObj.ItemCount * eliteBonusSilverDropFactor;
				if itemObj.ItemCount < 1 then
					itemObj.ItemCount = 1;
				end

				local name = GetName(topAttacker);
				local item = CREATE_ITEM(self, itemObj, topAttacker, x, y, z, 0, 5);                
				if item ~= nil then
					SetExProp(item, "SUPER_DROP", superDrop)
					if drop ~= nil then
						local itemObject = GetItemObjectOfMon(item);
						local prop = TryGetProp(drop, "ItemProperty");
						if prop ~= nil and prop ~= "None" then
							local tokenList = TokenizeByChar(prop, "#");
							for i = 1, #tokenList / 2 do
								local propName = tokenList[2 * i - 1];
								local propValue = tokenList[2 * i];
								itemObject[propName] = propValue;
                    
							end
						end
					end
					ItemDropMongoLog(self, topAttacker, dropItemName, dropCount, superDrop, item.UniqueName, item);            

						if string.find(dropType, 'Money') ~= nil then -- Money_Mid                
							SetTacticsArgFloat(item, 0, 0, 10)
						end
						local self_layer = GetLayer(self);
						if self_layer ~= nil and self_layer ~= 0 then
							SetLayer(item, self_layer);
						end
					local power = 1;
					if dropCount > 10 then
						power = 2
					end
				end
			end
		end
    end
end

function EPIK_SEL_ITEM_DROP(self, topAttacker, dropItemList, dropItemName, dropCount, clsID, epikMin, epikMax)    
    local setEpikValue = IMCRandom(epikMin, epikMax);
    setEpikValue = math.max(setEpikValue, epikMin);
    return SetEPIK(dropItemList, clsID, setEpikValue);
end

-- 몹죽을때 리스트 기반으로 아이템만 만들기
function SCR_REAL_DROP_ITEM(self)
    local topAttacker = GetTopContributionAttacker(self);
    if topAttacker == nil then
        return;
    end

    if IsBuffApplied(self, "EliteMonsterSummonBuff") == "YES" then
        return;
    end

    -- 해당 버프가 있으면 아이템 드랍을 X2 해줌
    local doublePay = GetBuffByName(topAttacker, "Double_pay_earn_Buff");
    local swellBody = GetBuffByName(self, "SwellBody_Debuff");
    local eliteMonsterBuff = GetBuffByName(self, "EliteMonsterBuff");
    local isDoubble = 0;
	local isHasEliteBuff = 0;
    if doublePay ~= nil or 1 == GetExProp(topAttacker, "DobbbleItem") 
    or nil ~= swellBody or eliteMonsterBuff ~= nil then
        isDoubble = isDoubble + 1;
        DelExProp(topAttacker, "DobbbleItem");
		
		if eliteMonsterBuff ~= nil then
			isHasEliteBuff = 1;
		end
    end

    RunScript("DROP_ITEM", self, topAttacker, isDoubble, isHasEliteBuff);

    ClearBTree(self);
end

function DROP_ITEM(self, topAttacker, isDoubleBuff, isHasEliteBuff)    
    sleep(500);
    
    local cnt = GetMonDropListCount(self, 1);
    for i=0, cnt-1 do
        local droplistName, dropClsName, itemCount, dropID, superDrop = GetMonDropListByIndex(self, i);
        
        local drop = GetClassByType("MonsterDropItemList_" .. droplistName, dropID);
        
        -- 존드롭 처리 --
        if drop == nil then
            local zoneName = GetZoneName(self)
            if zoneName ~= nil then
                drop = GetClassByType("ZoneDropItemList_" .. zoneName, dropID);
            end
        end
        

            for j = 0, isDoubleBuff do
                SEL_ITEM_DROP(self, topAttacker, dropItemList, dropClsName, itemCount, drop, superDrop, isHasEliteBuff);
            end

    end
end

----- 아이템이 뭘 드랍될지미리 보여주거나 하는 용도 때문에 계산식을 미리 돌려야 하는 경우가 있다.
-- 그럴때 아래 코드를 돌아주면된다. 
------------------------------ 미리 드랍하기 시작 --------------------------
function PRECREATE_DROP_LIST(self, attacker, isChangeItemSound)        
    local dropItemList = self.DropItemList;
    local list = GetMonsterDropItemList(self, dropItemList, attacker);
    local mapitem_list = GetMapDropItemList(self, dropItemList, attacker);
    if mapitem_list ~= nil and #mapitem_list > 0 then
        for i = 1, #mapitem_list do
            list[#list + 1] = mapitem_list[i];
        end
    end
    
    local zoneitem_list = GetZoneDropItemList(self, dropItemList, attacker);
    if zoneitem_list ~= nil and #zoneitem_list > 0 then
        for i = 1, #zoneitem_list do
            list[#list + 1] = zoneitem_list[i];
        end
    end
    
    if list ~= nil then
        POST_DROP_DETERMINED(self, dropItemList, attacker, -1.0, list);
                
        local cnt = 0;
        local isChangeDropItem = 0;
        for i = 1 , #list do
            local info = list[i];
            if info[1] ~= "None" then
                cnt = cnt + 1;

                if isChangeItemSound == 1 then
                    local beforeID = GetExProp(self, "PRE_ITEM_" .. cnt .. "_CLSID");                    
                    if info[3].ClassID ~= beforeID then
                        isChangeDropItem = 1;

                        -- 리셋팅 아이템변경 확인용 로그                        
                        if IS_PC(attacker) == true then
                            CustomMongoLog(attacker, 'Ressetting', 'MonName', self.ClassName, 'index', tostring(cnt), 'item', info[1]);
                        end
                    end
                end
            
                SetExProp_Str(self, "PRE_ITEM_" .. cnt .. "_NAME", info[1]);
                SetExProp(self, "PRE_ITEM_" .. cnt .. "_COUNT", info[2]);
                SetExProp_Str(self, "PRE_ITEM_" .. cnt .. "_IDSPC", GetIDSpace(info[3]));
                SetExProp(self, "PRE_ITEM_" .. cnt .. "_CLSID", info[3].ClassID);
            end
        end
    
        if isChangeItemSound == 1 then
            local beforeCount = GetExProp(self, "PRE_ITEM_COUNT");
            if beforeCount ~= cnt or isChangeDropItem == 1 then
                PlaySound(attacker, 'skl_eff_resetting_normal_2');  -- 변경사운드
            else
                PlaySound(attacker, 'skl_eff_resetting_normal_1');  -- 그대로
            end
        end

        SetExProp(self, "PRE_ITEM_COUNT", cnt);        
        SetExProp(self, "DROP_CREATED", 1);
    end
end

function GetPrecreatedDropList(self)    
    local list = {};
    local count = GetExProp(self, "PRE_ITEM_COUNT");
    for i = 1 , count do
        local newList = {};
        list[#list + 1] = newList;
        newList[1] = GetExProp_Str(self, "PRE_ITEM_" .. i .. "_NAME");
        newList[2] = GetExProp(self, "PRE_ITEM_" .. i .. "_COUNT");
        local idSpc = GetExProp_Str(self, "PRE_ITEM_" .. i .. "_IDSPC");
        local clsID = GetExProp(self, "PRE_ITEM_" .. i .. "_CLSID");
        local cls = GetClassByType(idSpc, clsID);
        newList[3] = cls;
    end

    SetExProp(self, "PRE_ITEM_COUNT", 0);       
    return list;    
end

function COPY_DROP_LIST(self, tgt)
    local count = GetExProp(self, "PRE_ITEM_COUNT");
    SetExProp(tgt, "PRE_ITEM_COUNT", count);
    for i = 1 , count do
        local itemName = GetExProp_Str(self, "PRE_ITEM_" .. i .. "_NAME");
        local itemCnt = GetExProp(self, "PRE_ITEM_" .. i .. "_COUNT");
        local idSpc = GetExProp_Str(self, "PRE_ITEM_" .. i .. "_IDSPC");
        local clsID = GetExProp(self, "PRE_ITEM_" .. i .. "_CLSID");
        SetExProp_Str(tgt, "PRE_ITEM_" .. i .. "_NAME", itemName);
        SetExProp(tgt, "PRE_ITEM_" .. i .. "_COUNT", itemCnt);
        SetExProp_Str(tgt, "PRE_ITEM_" .. i .. "_IDSPC", idSpc);
        SetExProp(tgt, "PRE_ITEM_" .. i .. "_CLSID", clsID);
    end

    SetExProp(tgt, "DROP_CREATED", 1);
end
------------------------------ 미리 드랍하기 끝 --------------------------

function POST_DROP_DETERMINED(self, dropItemList, topAttacker, mulDropRate, list)
    for i = 1, #list do
        local drop = list[i][3];
        local dpkMin = TryGet(drop, "DPK_Min");
        local epikMin = TryGet(drop, "EPIK_Min");
        if dpkMin > 0 then
            -- 현재 몬스터 잡힌 마리수
            local currentValue = GetCurrentDPK(dropItemList, drop.ClassID, dpkMin, drop.DPK_Max)

            -- Drop xml에 있는 DPK min + max
            local dpkValue = dpkMin + drop.DPK_Max
            
            if (GetServerNation() == "KOR" and GetServerGroupID() == 9001) then
                dpkValue = math.floor(dpkValue/2);
            end

            -- 현재 DPK 확률
            local finalValue = dpkValue - currentValue

            finalValue = math.ceil(finalValue / 1.5);

            
            if finalValue < 1 then
                finalValue = 1;
            end
            
            -- 현재 아이템을 받을 수 있는가?
            local dpkDropRate = IMCRandom(1, finalValue)

      			local overDPK = false;
      			if currentValue > dpkValue then
      				overDPK = true;
      			end
      
      			if overDPK == true then
      				ClearDPKCount(dropItemList, drop.ClassID)
      			end
            
            -- 아이템을 못받으면 드랍 테이블 셋팅 안함
            if dpkDropRate ~= 1 or overDPK == true then
                list[i][1] = "None";
            else
            -- 아이템을 받았으면 DPK 초기화
                ClearDPKCount(dropItemList, drop.ClassID)
            end
        elseif epikMin > 0 then
            local check = CheckEPIK(dropItemList, drop.ClassID);
            if check == 1 then                          
                local ret = EPIK_SEL_ITEM_DROP(self, topAttacker, dropItemList, list[i][1], list[i][2], drop.ClassID, dpkMin, drop.EPIK_Max);
                if ret <= 0 then
                    list[i][1] = "None";
                end
            else
                list[i][1] = "None";
            end
        end
    end
end

function SCR_LIB_ITEM_DROP(self, topAttacker, droptype)  -- droptype == -1 normal , 0 ,1 == superdrop            
    if droptype == 1 or droptype == 0 then
        GET_MONSTER_SUPER_DROP_ITEM_LIST(self, self.DropItemList, topAttacker)
        return;
    end
    
    local rdObj = nil;
    local rdOwnerExist = 0;
    
    local dropItemList = self.DropItemList; 
    if topAttacker ~= nil and dropItemList ~= 'None' then
        
        local list = nil;
        local dropListCreated = GetExProp(self, "DROP_CREATED");
        
        if dropListCreated == 0 then
            list = GetMonsterDropItemList(self, dropItemList, topAttacker);         
            local mapitem_list = GetMapDropItemList(self, dropItemList, topAttacker);
            if mapitem_list ~= nil and #mapitem_list > 0 then
                for i = 1, #mapitem_list do
                    list[#list + 1] = mapitem_list[i];
                end
            end
            
            local zoneitem_list = GetZoneDropItemList(self, dropItemList, topAttacker);
            if zoneitem_list ~= nil and #zoneitem_list > 0 then
                for i = 1, #zoneitem_list do
                    list[#list + 1] = zoneitem_list[i];
                end
            end
            
            SetExProp(self, "DROP_CREATED", 1);         
            
            if list ~= nil then
                POST_DROP_DETERMINED(self, dropItemList, topAttacker, droptype, list);
            end
        else
            list = GetPrecreatedDropList(self);
        end
        
        
        if IsBuffApplied(self, 'drop_inceaseMoney') == 'YES' then -- 실버 증가 버프 처리
            local buff = GetBuffByName(self, 'drop_inceaseMoney');
            local moneyCntMax = GetExProp(buff, "MoneyCount");
            for i = 1, #list do
                if list[i][3].ItemClassName == "Moneybag1" then
                    for moneyCnt = 1, moneyCntMax do -- moneyCntMax만큼 드랍되는 동전을 추가해준다
                        list[#list + 1] = list[i];
                    end
                    break;
                end
            end
        end
        
        if  list ~= nil and #list > 0 then
            local ownerExist = 0;
            local isEquipItemDrop = 0;
            if topAttacker.ClassName == 'PC' then
                for i = 1, #list do
                    local drop = list[i][3];
                    if list[i][1] ~= "None" then
                        if isEquipItemDrop == 0 then
                            isEquipItemDrop = IS_EQUIPITEM(list[i][1]);
                        end
                        AddMonDropList(self, dropItemList, list[i][1], list[i][2], drop.ClassID);
                    end
                end
            end

            if isEquipItemDrop == 1 then
                SetEquipDropEffect(self);
            end
        end   
        
    end
    
    
end

function CREATE_DROP_ITEM(self, itemName, topAttacker)      
    local x, y, z = GetDeadPos(self);

    if x==0 and y==0 and z==0 then
        x, y, z = GetPos(self);
    end

    local monType = geItemTable.GetItemMonsterByName(itemName);
    local dropIES = CreateGCIESByID('Monster', monType);

    local item = CREATE_ITEM(self, dropIES, topAttacker, x, y, z, 0, 5);
    
    return item
end

function CREATE_DROP_RECIPEITEM(self, itemName, topAttacker)    
    local x, y, z = GetDeadPos(self);
    local dropIES = CreateGCIES('Monster', itemName);
    local item = CREATE_ITEM(self, dropIES, topAttacker, x, y, z, 0, 5);
end

function SCR_LIB_AI_DEAD_UPDATE(self)

end


function SCR_LIB_AI_GUARD_ENTER(self)

    local target = GetTopHatePointChar(self);
    if target ~= nil then
        LookAt(self, target);
    end

    Guard(self);
    SetNextTimeBySec(self, 3);

end

function SCR_LIB_AI_GUARD_UPDATE(self)

    if GetRemainTimeInSec(self) <= 0 then
        ChangeTacticsState(self, 'TS_BATTLE');
    elseif GetRemainTimeInSec(self) <= 1 then
        local x, y, z = GetPos(self);
        local dirx, dirz = GetDirection(self);
        local skill = SelectMonsterSkillByRatio(self);
        UseMonsterSkillToGround(self, skill, x + dirx*5, y, z + dirz *5);
    end

end

function SCR_LIB_AI_GUARD_LEAVE(self)

    UnGuard(self);

end

function CHECK_DIST_FROM_OWNER(self)

    local owner = GetOwner(self);
    if owner == nil then
        return;
    end

    if GetDistance(self, owner) > 80 then
        ChangeTacticsState(self, 'TS_RETURN');
    end

end

function BOSS_ITEM_BALLOON(pc, itemObj)
    local rank = GetExProp(pc, "BOSS_KILL_RANK");
    ShowItemBalloon(pc, "{@st43}", "Rank_{Auto_1}", tostring(rank), itemObj, 4, 2, "reward_itembox");
end

-- 보스아이템드랍
function PLAY_BOSS_ITEM_DROP(self, attacker, rank, superDropArg, isFieldBoss, rewardGrade)
    if 1 == isFieldBoss then
        if IsZombie(attacker) == 1 then
            CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "ZombiePC", "MobID", self.ClassID, "MobName", self.ClassName);
            return 0;
        end
    end

	if rewardGrade == nil then
		rewardGrade = "None";
	end

    local cnt, dropType, goldCount, minMoney, maxMoney, itemList, dropItemList, getCnt, payItemList, cardName, cardRatio, reinforceCardDrop = CalcBossDropItem(self, rewardGrade);
    if cnt == 0 then
        IMC_LOG("INFO_NORMAL"," cnt is 0");
        CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "NoneBossReward", "MobID", self.ClassID, "MobName", self.ClassName);

        return 0;
    end

	if rewardGrade == "None" or rewardGrade == "FirstParty" or rewardGrade == "Normal" then
		SetExProp(attacker, "BOSS_KILL_RANK", rank);
		local x, y, z = GetPos(self);   -- 드랍위치

		-- 돈 드랍
		local gold = IMCRandom(minMoney, maxMoney);     -- 금액 설정 min~max사이에서 랜덤
		local drop_classname = 'Moneybag2'; -- 금액에따른 크기 설정
		local mon = GetClassByStrProp("Monster", "ClassName", drop_classname);
    
		if GetClassByType("Monster", mon.ClassID) ~= nil then
			local num = 0;
			for num = 0, goldCount-1 do
				local rdObj = CreateGCIESByID('Monster', mon.ClassID);
				rdObj.ItemCount = gold * JAEDDURY_GOLD_RATE;
				local item = CREATE_ITEM(self, rdObj, attacker, x, y, z, 0, 50);
				if item ~= nil then
					SetExProp(item, "KD_POWER_MAX", 270);
					SetExProp(item, "KD_POWER_MIN", 120);
				end
			end
		end
    
		-- pc에게 월급계념으로 무조건 고정으로 주는 아이템 드랍
		for i = 1 , #payItemList do
			local drop = payItemList[i];
			BOSS_SEL_ITEM_DROP(self, attacker, drop, true, false);
		end
		
		if cardName ~= nil then
			BOSS_CARD_DROP(self, attacker, cardName, cardRatio, reinforceCardDrop)
		end
	end
	
    -- 아이템 드랍
    local retList = {};
    local curCnt = 1;

    while 1 do
        if curCnt > getCnt then
            break;
        end
        
        local drop = PICK_DROP_CLS_INDEX(itemList);
        if drop == nil then
            break;
        end
		
        local pickCls = nil;
        local dpkMin = TryGet(drop, "DPK_Min");
        local epikMin = TryGet(drop, "EPIK_Min");
		
        if dpkMin > 0 then
            if GetExProp(self, "DPKSET") == 0 then
                SetExProp(self, "DPKSET", 1);
                if superDropArg > 0 then
                    local rate = IMCRandom(1,(dpkMin + drop.DPK_Max)/2)
                        if rate == 1 then
                        pickCls = drop
                        end
                    else
                        -- 현재 몬스터 잡힌 마리수
                        local currentValue = GetCurrentDPK(dropItemList, drop.ClassID, dpkMin, drop.DPK_Max)
                        -- Drop xml에 있는 DPK min + max
                        local dpkValue = dpkMin + drop.DPK_Max
                        
                        if (GetServerNation() == "KOR" and GetServerGroupID() == 9001) then
                            dpkValue = math.floor(dpkValue/2);
                        end
                        
                        -- 현재 DPK 확률
                        local finalValue = dpkValue - currentValue

                        if finalValue < 1 then
                            finalValue = 1;
                        end

                        -- 현재 아이템을 받을 수 있는가?
                        local dpkDropRate = IMCRandom(1, finalValue)

						local overDPK = false;
						if currentValue > dpkValue then
							overDPK = true;
						end

						if overDPK == true then
							ClearDPKCount(dropItemList, drop.ClassID)
						end
            
				        -- 아이템을 못받으면 드랍 테이블 셋팅 안함
					    
                        -- 아이템을 못받으면 드랍 테이블 셋팅 안함
                        if dpkDropRate ~= 1 or overDPK == true then
                            list[i][1] = "None";
                        else
                        -- 아이템을 받았으면 DPK 초기화
                            ClearDPKCount(dropItemList, drop.ClassID)
                        end
                    end
            end
        elseif epikMin > 0 then
            local check = CheckEPIK(dropItemList, drop.ClassID);
            if check == 1 then
                pickCls = drop;
            end
        else
            pickCls = drop;
        end

        if pickCls ~= nil then
            retList[#retList + 1] = pickCls;
            curCnt = curCnt + 1;
        end
    end

    if #retList == 0 then
        CustomMongoLog(attacker, "RewardBossItemFailed", "Type", "NoneDropItem", "MobID", self.ClassID, "MobName", self.ClassName);
    end

    local dropListCreated = GetExProp(self, "DROP_CREATED");
    
    if dropListCreated == 1 then    -- 미리 보기면 그 아이템만 드랍한다.
        local pre_droplist = GetPrecreatedDropList(self)
        for i = 1, #pre_droplist do            
            BOSS_SEL_ITEM_DROP(self, attacker, pre_droplist[i], false, isFieldBoss);
        end
    else
        for i = 1 , #retList do
            local drop = retList[i];            
            local dpkMin = TryGet(drop, "DPK_Min");
            local epikMin = TryGet(drop, "EPIK_Min");
            if dpkMin > 0 then            
                BOSS_SEL_ITEM_DROP(self, attacker, drop, false, isFieldBoss);
            elseif epikMin > 0 then
                RunZombieScript("EPIK_BOSS_SEL_ITEM_DROP", self, attacker, dropItemList, ldrop.ClassID, dpkMin, drop.EPIK_Max, isFieldBoss);
            else
                BOSS_SEL_ITEM_DROP(self, attacker, drop, false, isFieldBoss);                
            end
        end
    end
    return 1;
end

function BOSS_CARD_DROP(self, attacker, cardName, cardRatio, reinforceCardDrop)

    if CAN_DROP_CONSIDERING_PENALTY(attacker) == true then
        local randNum = IMCRandom(1, 10000);
        
        if reinforceCardDrop == 'YES' and randNum > 4000 then
            cardName = 'card_Xpupkit01_100'
        end

        if cardRatio >= randNum then
            local obj = CreateGCIES('Monster', cardName);  

            if obj == nil then
                return;
            end

            local x, y, z = GetPos(self);
            local item = CREATE_ITEM(self, obj, attacker, x, y, z, 0, 1, 0);

            if item == nil then
                return;
            end
        
            SetExProp(item, "IS_BOSS_DROP", 1);
            SetExProp_Str(item, "POST_PICK", "BOSS_ITEM_BALLOON");
        
            ItemDropMongoLog(self, attacker, cardName, obj.ItemCount, 0, item.UniqueName, item);
            AddBossDropInfo(attacker, self, cardName, obj.ItemCount);
        end
    end
end

function PICK_DROP_CLS_INDEX(itemList)
    local stackRatio = 0;
    for i = 1 , #itemList do
        local drop = itemList[i];
        stackRatio = stackRatio + drop.DropRatio;
    end
    
    local randIndex = IMCRandom(1, stackRatio);
    local dropRatio = 0;
    
    for i = 1 , #itemList do
        local drop = itemList[i];
        dropRatio = dropRatio + drop.DropRatio;
        
        if randIndex < dropRatio then
            return drop;
        end
    end
    

    return nil;
end

function BOSS_SEL_ITEM_DROP(self, attacker, itemCls, isPayItem, isFieldBoss)    
    --필드 보스 드랍
    if isFieldBoss == 1 or isFieldBoss == true then
        local item = FIELD_BOSS_ITEM_DROP(self, attacker, itemCls, isPayItem)
        return item;
    else
    --일반 보스 드랍
        local item = NORMAL_BOSS_ITEM_DROP(self, attacker, itemCls, isPayItem)
        return item;
    end
end

function NORMAL_BOSS_ITEM_DROP(self, attacker, itemCls, isPayItem)
    if CAN_DROP_CONSIDERING_PENALTY(attacker) == true then
        local itemName = itemCls.ItemClassName;
        if itemName == nil then
            itemName = itemCls[1]
        end
        local monID = geItemTable.GetItemMonsterByName(itemName);
        
        local useTX = {}
        local isGiveInv = 0

        if GetClassByType("Monster", monID) == nil then
            return nil;
        end
        
        local itemCount = 1
        if TryGetProp(itemCls, 'ItemCount') ~= nil then
            itemCount = TryGetProp(itemCls, 'ItemCount')
        end
        local tokenBonus = TryGetProp(itemCls, 'TokenBonus');
        if tokenBonus ~= nil then
            if IsPremiumState(attacker, ITEM_TOKEN) == 1 then
                itemCount = itemCount + TryGetProp(itemCls, 'TokenBonus')
            end
        elseif tokenBonus == nil then
            tokenBonus = 0;
        end

        local pcetc = GetETCObject(attacker);

        local multipleCnt = 0;
        --if IsIndunMultiple(attacker) == 1 then
            multipleCnt = pcetc.IndunMultipleRate;
        --end

        if TryGetProp(itemCls, 'PCEtcPropertyAdd') ~= nil then
            local pcetcProp = TryGetProp(itemCls, 'PCEtcPropertyAdd')
            if pcetc ~= nil and TryGetProp(pcetc, pcetcProp) ~= nil then
                local samsara = GetExProp(self, "CREATE_SAMSARA")
                if samsara == 1 then
                else
                    local addValue = pcetc[pcetcProp] + 1 + multipleCnt;
                    useTX[#useTX + 1] = {'property',pcetc, pcetcProp, addValue}
                    if string.find(pcetcProp,'InDunRewardCountType_') ~= nil then
                        local initProp = 'InDunCountType_'..string.gsub(pcetcProp, 'InDunRewardCountType_', '')
                        if pcetc[initProp] ~= addValue then
                            useTX[#useTX + 1] = {'property',pcetc, initProp, addValue}
                        end
                    end
                end
            end
        end

        local isAdmissionItemIndun = false;
        local admissionItemIndunClassName = TryGetProp(itemCls, 'AdmissionItemIndun');
        if admissionItemIndunClassName ~= nil and admissionItemIndunClassName ~= 'None' then
            local indunCls = GetClass('Indun', admissionItemIndunClassName);
            local admissionItemName = TryGetProp(indunCls, 'AdmissionItemName');
            if admissionItemName ~= nil and admissionItemName ~= 'None' then
                local takeCount = GET_ADMISSION_ITEM_TAKE_COUNT(attacker, indunCls);
                local pcetc = GetETCObject(attacker);
                local enterCountPropName = 'InDunCountType_'..indunCls.PlayPerResetType;
                if takeCount > 0 then
                    useTX[#useTX + 1] = {'admissionItem', admissionItemName, takeCount};                    
                    useTX[#useTX + 1] = {'admissionEnterCount', pcetc, enterCountPropName, pcetc[enterCountPropName] + 1};
                    isAdmissionItemIndun = true;
                end
            end
        end

        if TryGetProp(itemCls, 'GiveType') == 'INVENTORY' then
            itemCount = (multipleCnt + 1) * itemCount;
            if isAdmissionItemIndun == true and itemCount > 1 then
                IMC_LOG("ERROR_INVALID_VALUE", 'AdmissionIndun Error: itemCount['..itemCount..'], multipleRate['..multipleCnt..'], token['..tokenBonus..']');
            end

            if isAdmissionItemIndun == true then
                itemCount = 1; -- 유니크 던전 무조건 한 개만 해달라고 하셨음
            end

            useTX[#useTX + 1] = {'item', itemName, itemCount}
            isGiveInv = 1
        end
        
        if #useTX > 0 then
            local tx = TxBegin(attacker);
            TxEnableInIntegrate(tx)
            for i = 1, #useTX do
                if useTX[i][1] == 'property' then
                    TxSetIESProp(tx, useTX[i][2], useTX[i][3], useTX[i][4])
                elseif useTX[i][1] == 'item' then
                    TxGiveItem(tx, useTX[i][2], useTX[i][3], 'MonDead'..self.ClassID)
                elseif useTX[i][1] == 'admissionItem' then
                    TxTakeItem(tx, useTX[i][2], useTX[i][3], 'TAKE_ADMISSION_ITEM');
                elseif useTX[i][1] == 'admissionEnterCount' then
                    TxSetIESProp(tx, useTX[i][2], useTX[i][3], useTX[i][4]);
                end
            end
            local ret = TxCommit(tx);
            if ret ~= 'SUCCESS' then            
                return nil
            end            
        end
        
        if isGiveInv == 0 then
            local dropItemList = {}
            if itemCount > 0 then
                for i = 1, itemCount do
                    local obj = CreateGCIESByID('Monster', monID);
                    obj.ItemCount = 1;
                    local x, y, z = GetPos(self);
                    local item = CREATE_ITEM(self, obj, attacker, x, y, z, 0, 1, isPayItem);
                    if item ~= nil then
                        dropItemList[#dropItemList + 1] = item
                        SetExProp(item, "KD_POWER_MAX", 270);
                        SetExProp(item, "KD_POWER_MIN", 120);
                        SetExProp(item, "IS_BOSS_DROP", 1);
                        SetExProp_Str(item, "POST_PICK", "BOSS_ITEM_BALLOON");
                        ItemDropMongoLog(self, attacker, itemCls.ItemClassName, obj.ItemCount, 0, item.UniqueName, item);
                        AddBossDropInfo(attacker, self, itemCls.ItemClassName, obj.ItemCount);
                    else
                        print("ERROR : drop item create fail Monster("..self.Name..") Item("..itemName..")")
                    end
                end
            end
            if #dropItemList == 0 then
                return nil
            elseif #dropItemList == 1 then
                return dropItemList[1]
            else
                return dropItemList
            end
        end
    end

    return nil
end

function FIELD_BOSS_ITEM_DROP(self, attacker, itemCls, isPayItem)    
    if CAN_DROP_CONSIDERING_PENALTY(attacker) == true then
        local itemName = itemCls.ItemClassName;
        local itemCount = 1;

        local monID = geItemTable.GetItemMonsterByName(itemName);
        --180201 필보 보상 추가 이벤트 로직 --
        local evepropDropCheck = TryGetProp(self, "DropItemList");
        local bossDropList, cnt = GetClassList("MonsterDropItemList_"..evepropDropCheck);
        local evegiveItem = nil
        local everewardItem = nil
        
        for i = 0, cnt-1 do
            local cls = GetClassByIndexFromList(bossDropList,i)
            if cls == nil then
                return;
            end
            everewardItem = TryGetProp(cls , "RewardGrade")
            
            if everewardItem == nil then
                return;
            end
            
            if everewardItem == "Add" then
                local eveitemCheck = TryGetProp(cls, "ItemClassName")
                if eveitemCheck == nil then
                    return;
                end
                evegiveItem = eveitemCheck
            break;
            end
        end
        --180201 필보 이벤트 로직 종료 --

        if GetClassByType("Monster", monID) == nil then
            return nil;
        end

        local item = nil;
        local cmdIdx = -1;
        local resultGUID = 0;
        -- 레이드 보상 TX
        -- 이 함수를 호출하는 부분에서는 아이템 리스트를 가지고 루프를 돌기 때문에 내부에서 tx를 여러개 사용할 수 있다고 생각할 수 있음
        -- 하지만 우리 필드보스 드랍 시스템은 무조건 큐브를 1개 주고, 그 큐브를 까서 아이템이 나오는 시스템이기 때문에
        -- 위 룰이 잘 지켜진다면 tx는 무조건 1번으로 보장이 된다.
            
        local tx = TxBegin(attacker);
        cmdIdx = TxGiveItem(tx, itemCls.ItemClassName, 1, "FieldBossReward");
        TxGiveItem(tx, evegiveItem, 1, "FieldBossEventReward"); -- 필보 이벤트 보상 지급--
        resultGUID = TxGetGiveItemID(tx, cmdIdx);
        local ret = TxCommit(tx);
    
		if ret == "SUCCESS" then
            item = GetInvItemByGuid(attacker, resultGUID);

            SetExProp_Str(item, "POST_PICK", "BOSS_ITEM_BALLOON");
            AddBossDropInfo(attacker, self, itemName, itemCount);

            local rank = GetExProp(attacker, "BOSS_KILL_RANK");
            ShowItemBalloon(attacker, "{@st43}", "Rank_{Number}", tostring(rank), item, 4, 2, "reward_itembox");
            return item;
        else
            local name = GetTeamName(attacker)
            IMC_LOG("INFO_NORMAL", "[FIELD_BOSS_ITEM_DROP ERROR] UserTeamName : "..name.." ItemName : "..itemName)
            --혹시 모르니 남겨놓자
            CustomMongoLog(attacker, "RewardItemOnmission", "Type", "FieldBossReward", "ItemName", itemName, "itemCount", itemCount)
        end
    end
    return nil
end

function EPIK_BOSS_SEL_ITEM_DROP(self, topAttacker, dropItemList, clsID, epikMin, epikMax, isFieldBoss)    
    local setEpikValue = IMCRandom(epikMin, epikMax);
    setEpikValue = math.max(setEpikValue, epikMin);
    local ret = SetEPIK(dropItemList, clsID, setEpikValue);
    if ret == 0 then
        return ret;
    end

    local drop = GetClassByType("MonsterDropItemList_" .. dropItemList, clsID);
    BOSS_SEL_ITEM_DROP(self, topAttacker, drop, false, isFieldBoss);
    return ret;
end

function CalcBossDropItem(self, rewardGrade)
    local prop = GetClass("ItemDropBoss", self.DropItemList);
    if prop == nil then
        return 0;
    end
    
    -- 드랍카운트. 루프도는 횟수 & 돈아이템 개수    
    -- 드랍 타입  ScpArgMsg('Auto_Once_:_HanBeone_Ppang~'), ScpArgMsg('Auto_Separate_:_SeulLipJwoSeo_PpyoByoByong~')
    local type = prop.DropType;
    
    local dropItemListName;
    local statBase = GetClassByType("Stat_Monster", self.Lv);
    local baseMoney = statBase.MoneyOnCustom;
    local minMoney = math.floor(baseMoney * prop.MinMoneyRatio / 100);
    local maxMoney = math.floor(baseMoney * prop.MaxMoneyRatio / 100);
    
    if minMoney < 1 then
        minMoney = 1;
    end
    
    if maxMoney < 1 then
        maxMoney = 1;
    end
    
    local dropPerLevel = TryGetProp(prop, "DropItemList_Level");
    if dropPerLevel ~= nil then
        
        local lv = self.Lv;
        while 1 do
            dropItemListName = dropPerLevel .. "_" .. math.floor(lv);
            if GetClassList("MonsterDropItemList_" .. dropItemListName) ~= nil then
                break;
            end             

            lv = lv + 1;
            if lv >= 1000 then
                IMC_LOG("INFO_NORMAL", "Drop Error - "..lv.."  "..dropItemListName)
                return;
            end
        end

    else
        dropItemListName = prop.DropItemList;
    end

    -- 아이템 리스트 가져오는부분
    local itemList = {};
    local payItemList = {};
    local clsList, listCnt  = GetClassList("MonsterDropItemList_" .. dropItemListName);
    for i = 0 , listCnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        if cls ~= nil then
			if rewardGrade ~= "None" then
				local clsRewardGrade = TryGet_Str(cls, "RewardGrade");
				if clsRewardGrade ~= nil then
					if clsRewardGrade ~= "None" then
						if clsRewardGrade == rewardGrade then
							if cls.DropRatio > 0 then
								itemList[#itemList + 1] = cls;
							else
								payItemList[#payItemList + 1] = cls;
							end
						end
					end
				end
			else
				if cls.DropRatio > 0 then
					itemList[#itemList + 1] = cls;
				else
					payItemList[#payItemList + 1] = cls;
				end
			end
        end
    end

    -- 보스드랍개수
    local itemCnt = IMCRandom(prop.MinItem, prop.MaxItem);
    local dropCnt = 0;
    local DropCount = TryGetProp(prop, "DropCount");
    if nil ~= DropCount then
        dropCnt = tonumber(DropCount);
    end
    local ReinforceCardDrop = TryGetProp(prop, "ReinforceCardDrop")

    return listCnt, type, dropCnt, minMoney, maxMoney, itemList, dropItemListName, itemCnt, payItemList, TryGetProp(prop, "Cardlist"), TryGetProp(prop, "CardDropRatio"), ReinforceCardDrop;
end

-- 드랍 실버(Vis) 금액에따른 종류/크기 설정
function CalcVisSize(itemcount)

    local visType = 'Moneybag1';

    if itemcount <= 10 then
        visType = 'Moneybag3'   -- 소
    elseif itemcount <=25 then
        visType = 'Moneybag3'   -- 중
    else
        visType = 'Moneybag3'   -- 대
    end 
    return visType;
end

function SCR_RAID_REWARD_DROP(self, pc, dropList)    
    if CAN_DROP_CONSIDERING_PENALTY(pc) == true then
        local clsList, cnt = GetClassList(dropList);
        local dropList = {};
        local j = 1;
        local dropRecipe = {};
        local k = 1;
    
        for i = 0, cnt - 1 do
            local cls = GetClassByIndexFromList(clsList, i)
            local itemCls = GetClass("Item", cls.ItemClassName);
        
                if itemCls == nil then -- 레시피인지 확인한다
                    local recipeCls = GetClass("Recipe", cls.ItemClassName);
            
                    if recipeCls ~= nil then
                        dropRecipe[k] = recipeCls;
                        k = k + 1;
                end
                else
                    dropList[j] = itemCls;
                    j = j + 1;
            end
        end
    
        local choiceList = IMCRandom(1,2);
    
        if choiceList == 1 then
            local dropResult = IMCRandom(1, #dropRecipe);
            recipeCls = dropRecipe[dropResult];
        
            -- 레시피 생성
            local x, y, z = GetPos(pc);
                local dropIES = CreateGCIES('Monster', recipeCls.ClassName);
                local item = CREATE_ITEM(pc, dropIES, pc, x+5, y, z, 0, 5);
        else
            local dropResult = IMCRandom(1, #dropList);
            itemCls = dropList[dropResult];
        
            -- 레이드 보상 TX
            local tx = TxBegin(pc);
            TxGiveItem(tx, itemCls.ClassName, 1, "RaidReward");
            local ret = TxCommit(tx);

        end
    end
end

function SCR_LIB_ITEM_SUPER_DROP(self, topAttacker, droptype)    
    local rdObj = nil;
    local rdOwnerExist = 0;
    
    local dropItemList = self.DropItemList; 
    if topAttacker ~= nil and dropItemList ~= 'None' then
        
        local list = nil;
        local dropListCreated = GetExProp(self, "DROP_CREATED");
        
        if dropListCreated == 0 then
            list = GetMonsterDropItemList(self, dropItemList, topAttacker);         
            local mapitem_list = GetMapDropItemList(self, dropItemList, topAttacker);
            if mapitem_list ~= nil and #mapitem_list > 0 then
                for i = 1, #mapitem_list do
                    list[#list + 1] = mapitem_list[i];
                end
            end
            
            local zoneitem_list = GetZoneDropItemList(self, dropItemList, topAttacker);
            if zoneitem_list ~= nil and #zoneitem_list > 0 then
                for i = 1, #zoneitem_list do
                    list[#list + 1] = zoneitem_list[i];
                end
            end
            
            SetExProp(self, "DROP_CREATED", 1);
            
            if list ~= nil then
                POST_DROP_DETERMINED(self, dropItemList, topAttacker, droptype, list);
            end
        else
            list = GetPrecreatedDropList(self);
        end
        
        if  list ~= nil and #list > 0 then
            local ownerExist = 0;
            local isEquipItemDrop = 0;
            if topAttacker.ClassName == 'PC' then
                for i = 1, #list do
                    local drop = list[i][3];
                    if list[i][1] ~= "None" then
                        if isEquipItemDrop == 0 then
                            isEquipItemDrop = IS_EQUIPITEM(list[i][1]);
                        end
                        
                        AddMonDropList(self, dropItemList, list[i][1], list[i][2], drop.ClassID);
                    end
                end
            end
            if isEquipItemDrop == 1 then
                SetEquipDropEffect(self);
            end
       end
    end
end

function CAN_DROP_CONSIDERING_PENALTY(attacker)
    return true;
    
-- 중국 창유에서 사용하기 위한 국가별 스펙이었으나 통합 관리할 수 없어서 오버라이드로 빼기로 함 --
-- 여기서는 사용하지 않고, 무조건 return true로 작동하도록 한다 --
-- 원래 쓰고자 했던 기능은 과몰입 방지 기능으로 오래 플레이하면 경험치, 아이템 드롭 등에서 점점 확률이 나빠지는 시스템 --
--    if attacker ~= nil then
--        local earningRate = GetEarningRate(attacker) * 100
--        local randomNumber = IMCRandom(1, 100)
--        if randomNumber <= earningRate then
--            return true
--        else
--            return false
--        end
--    else -- attacker == true
--        return false
--    end
end
