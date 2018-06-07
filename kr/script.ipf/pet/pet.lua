---- pet.lua

-- Companion Pet NeedJobID
PET_COMMON_JOBID = 0;
PET_HAWK_JOBID = 3014;

function SCR_USE_PREMIUM_EGG(pc, argObj, argStr, argnum1, argnum2, itemType, itemObj)

	local petCls = GetClass("Companion", argStr)
	if nil == petCls then
		return;
	end

    local jobCls = GetClassByType("Job", petCls.JobID);
	if petCls.JobID ~= 0 then 
		if 0 == GetJobGradeByName(pc, jobCls.ClassName) then
			return;
		end
	end
	
	if petCls.Premium ~= "YES" and itemObj.ClassName ~= "egg_014" then
		return;
	end

	local monCls = GetClass("Monster", petCls.ClassName);
	if nil == monCls then
		return;
	end

	local text = ScpArgMsg("InputCompanionName") .. "*@*" .. ScpArgMsg("InputCompanionName");
	local input = ShowTextInputDlg(pc, 0, text)
	if input == '' or nil == input then
		SysMsg(pc, 'Instant', ScpArgMsg('NameCannotIncludeSpace'))
		return
	end
  
	if string.find(input, ' ') ~= nil then
		SysMsg(pc, 'Instant', ScpArgMsg('NameCannotIncludeSpace'))
		return
	end
	
	local badword = IsBadString(input)
	if badword ~= nil then
		SysMsg(pc, 'Instant', ScpArgMsg('{Word}_FobiddenWord','Word',badword))
		return
	end

	if stringfunction.IsValidCharacterName(input) == false then
		SysMsg(pc, 'Instant', ScpArgMsg('WrongPartyName'))
		return;
	end

	local haveCompanion = GetSummonedPet(pc, petCls.JobID);
	RunScript("TX_SCR_USE_PREMIUM_EGG", pc, itemObj, input, monCls.ClassID, haveCompanion);
end

function TX_SCR_USE_EGG_COMPANION(pc, itemIES)
	local invItem = GetInvItemByGuid(pc, itemIES);
	if nil == invItem then
		return
	end

	SCR_USE_PREMIUM_EGG(pc, nil, invItem.StringArg, invItem.NumberArg1, invItem.NumberArg2, invItem.ClassID, invItem)
end

function TX_SCR_USE_PREMIUM_EGG(pc, itemObj, input, monID, haveCompanion)
	local tx = TxBegin(pc);
	TxTakeItemByObject(tx, itemObj, 1, "use");
	TxAdoptPet(tx, monID, input);
	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

	if haveCompanion == nil then
		if IsFullBarrackLayerSlot(pc) == 1 then
			ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
		else
			ExecClientScp(pc, "PET_ADOPT_SUC()");
		end
	else
		ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
	end
end

function SCR_CHANGE_PET_TYPE(pc, petType)
	local etc = GetETCObject(pc);
	etc.SelectedPet = petType;
end

function SCR_SUMMON_PET(pc, petType)

	local etc = GetETCObject(pc);
	local globalTime = geServerTime.GetGlobalAppTime();
	local elapsedTime = globalTime - etc.PetSummonTime;
	if elapsedTime >= 0 and elapsedTime + 1 < PET_COOLDOWN then
		return;
	end

	etc.PetSummonTime = globalTime;
	SendProperty(pc, etc);	
	SummonPet(pc, petType);
	SendAddOnMsg(pc, "PET_SELECT", "", 0);
end

function INIT_PET(pet)
	SetBroadcastOwner(pet);
	EnableAIOutOfPC(pet);
	local pc = GetOwner(pet);
	
	if pet.ClassName == "penguin" then
    	AddBuff(pet, pc, 'pet_penguin_buff');
	end
		if pet.ClassName == "parrotbill" then
    	AddBuff(pet, pc, 'pet_parrotbill_buff');
	end
    if pet.ClassName == "Lesser_panda" then
    	AddBuff(pet, pc, 'pet_Lesserpanda_buff');
	end
	
	if pet.ClassName == "Pet_Rocksodon" then
    	AddBuff(pet, pc, 'pet_rocksodon_buff');
	end
	
	if pet.ClassName == "Pet_Golddog" then
    	AddBuff(pet, pc, 'PET_GOLD_DOG_BUFF');
	end
	if pet.ClassName == "pet_weddingbird" then
    	AddBuff(pet, pc, 'PET_WEDDING_BIRD_BUFF');
	end

	if pet.ClassName == "Lesser_panda_gray" then
    	AddBuff(pet, pc, 'pet_Lesserpanda_gray_buff');
	end
	
	if pet.ClassName == "pet_goro_suit" then
    	AddBuff(pet, pc, 'PET_GORO_BUFF');
	end
	
	SetHookMsgOwner(pet, pc);
	SetCompanionInfo(pc, pet, pet.ClassName);
	
	InvalidateStates(pet)

	AddAlmostDeadScript(pet, "PET_ON_DEAD");
	AddAlmostDeadScript(pc, "PET_OWNR_ON_DEAD");
	-- ChangeMoveSpdType(pet, "RUN");

	-- pet summoning with run to pc not used anymore
	--[[
	pet.MSPD_BM = 0;
	
	local x, y, z = GetPos(pc);
	x, z = GetAroundPos(pc, IMCRandom(0, 360), 200);
	x, y, z = GetRandomPos(pc, x, y, z, 1);
	SetPos(pet, x, y, z);

	pet.FIXMSPD_BM = 120;
	InvalidateMSPD(pet);

	while 1 do
		pc = GetOwner(pet);
		x, y, z = GetPos(pc);
		MoveEx(pet, x, y, z, 1);
		local dist = GetDist2D(pc, pet);
		if dist <= 30 then
			break;
		end
		
		sleep(500);	
	end

	pet.FIXMSPD_BM = 0;
	InvalidateMSPD(pet);
	]]

	PET_SET_ACT_FLAG(pet);

	RunSimpleAI(pet, "companion_" .. pet.ClassName);
	UPDATE_PET_ACTIVATE(pet, pc);
	if pet.IsActivated == 1 then
		RunScript("UPDATE_PET_STAMINA", pet);
	end
	
	
	local companionClassName = TryGetProp(pet, 'ClassName');
	if companionClassName ~= nil then
		local companionClass = GetClass('Companion', companionClassName);
		local isRidingOnly = TryGetProp(companionClass, 'RidingOnly');
		if isRidingOnly == 'YES' then
			if GetVehicleState(pc) == 0 then
				AddBuff(pc, pet, 'System_Companion_VisibleTime', 1, 0, 30000, 1);
			end
		end
	end
end

function UPDATE_PET_STAMINA(pet)

	if pet == nil then
		print("UPDATE_PET_STAMINA - pet == nil")
		return;
	end

	local staminaConsumeSec = 60 * 1000;
	local CompMastery1_abil = GetAbility(GetOwner(pet), "CompMastery1")
	if CompMastery1_abil ~= nil then
	    staminaConsumeSec = staminaConsumeSec + (CompMastery1_abil.Level * 10000)
	end 

	local loopTime = 5000;
	
	while 1 do
		
		local curStamina = pet.Stamina;
		if curStamina > 0 then
			pet.Sta_ElapsedSec = pet.Sta_ElapsedSec + loopTime;
			if pet.Sta_ElapsedSec >= staminaConsumeSec then		
				local owner = GetOwner(pet);
				if owner == nil then
					return
				end

				local tx = TxBegin(owner);
				TxEnableInIntegrate(tx);

				if tx == 0 or tx == nil then
					print("UPDATE_PET_STAMINA - tx == nil")
					return;
				end

				curStamina = curStamina - 1;
				if curStamina < 0 then
					curStamina = 0;
				end
				TxSetIESProp(tx, pet, 'Stamina', curStamina, "Companion");
				local ret = TxCommit(tx);
				 
				if ret == "SUCCESS" and curStamina == 0 then
					InvalidateStates(pet);
					ON_PET_STAMINA_CHANGE(pet, owner);
				end

				pet.Sta_ElapsedSec = 0;
			end
		else
			while 1 do
				if pet.Stamina > 0 then
					nextStaminaConsumeTime = imcTime.GetAppTime() + staminaConsumeSec;
					break;
				end

				sleep(loopTime);
			end
		end

		sleep(loopTime);
	end

end

function EXIT_PET(pet)
	SetMoveAniType(pet, "None");
	HoldMonScp(pet);
	local pc = GetOwner(pet);
	local x, y, z = GetPos(pc);
	x, z = GetAroundPos(pc, IMCRandom(0, 360), 400);
	
	pet.FIXMSPD_BM = 120;
	InvalidateMSPD(pet);
	MoveEx(pet, x, y, z, 1);
	local loopCnt = 0;
	while 1 do
		local dist = GetDistFromPos(pet, x, y, z);
		pc = GetOwner(pet);
		local distFromPC = GetDist2D(pc, pet);
		if dist <= 50 or distFromPC >= 300 or loopCnt >= 10 then
			Kill(pet);
			return;
		end

		MoveEx(pet, x, y, z, 1);
		sleep(500);
		loopCnt = loopCnt + 1;
	end
	
end

function PET_OWNR_ON_DEAD(pc)

	local list = GetSummonedPetList(pc);
	for i = 1 , #list do
		local pet = list[i];
		RideVehicle(pc, pet, 0);	
	end
end

function PET_ON_DEAD(pet, from, skl, damage, ret)

	pet.HP = 1;
	local deadTime = 5 * 1000;
	
	local owner = GetOwner(pet);
	RideVehicle(owner, pet, 0);
	
	AddBuff(pet, pet, "Pet_Dead", 1 , 0, deadTime, 1);
	InvalidateStates(pet);

	-- 죽어도 컴패니언의 스태미나를 초기화하지 말아달라는 요청
	-- RunScript("RESET_PET_STAMINA",pet);

end

function RESET_PET_STAMINA(pet)

	local owner = GetOwner(pet);
	local tx = TxBegin(owner);
	TxEnableInIntegrate(tx);
	if pet.Stamina ~= 0 then
		TxSetIESProp(tx, pet, 'Stamina', 0, "Companion");
	end

	local ret = TxCommit(tx);
	 	
	if ret == "SUCCESS" then
		InvalidateStates(pet);
		pet.HP = 1;
	end

end

function SCR_BUFF_ENTER_Pet_Dead(self, buff, arg1, arg2, over)
	SetSafe(self, 1);
	RemoveAllBuff(self)
	HoldMonScp(self);
end

function SCR_BUFF_LEAVE_Pet_Dead(self, buff, arg1, arg2, over)
	SetSafe(self, 0);
	UnHoldMonScp(self);
end

function SCR_BUFF_ENTER_Pet_Heal(self, buff, arg1, arg2, over)
    SetExProp(buff, "HEAL_HP", math.floor(self.MHP * 0.02))
end

function SCR_BUFF_UPDATE_Pet_Heal(self, buff, arg1, arg2, RemainTime, ret, over)
    local healValue = GetExProp(buff, "HEAL_HP")
    AddHP(self, healValue);
    return 1;
end

function SCR_BUFF_LEAVE_Pet_Heal(self, buff, arg1, arg2, over)
    AddBuff(self, self, "Pet_Heal_After", 1, 0, 600000, 1);
end


function SCR_COMPANION_STROKE(self, handle)
	local compa = GetCompanionByHandle(self, handle);
	if compa == nil then
		return;
	end
	
	local saniRet = PlaySumAni(self, compa, "pet", 80);
	WaitSumAniEnd(self);

	local friendPointTime = GetPetPCProperty(compa, "FriendPointTime", "None");
	if nil == friendPointTime then
		friendPointTime = "None";
	end

	local nextAbleTime = imcTime.GetSysTimeByStr(friendPointTime);
	local sysTime = GetDBTime();
	
	if imcTime.IsLaterThan(sysTime, nextAbleTime) == 1 then
		local nextSec = 20 * 60;
		nextAbleTime = imcTime.AddSec(sysTime, nextSec);
		local strNextTime = imcTime.GetStringSysTime(nextAbleTime);
		if nil == strNextTime then
			strNextTime = "None";
		end
		local friendPoint = tonumber(GetPetPCProperty(compa, "FriendPoint", "0"));
		local nextPoint = friendPoint + 10;
		local friendLevel = tonumber(GetPetPCProperty(compa, "FriendLevel", "1"));

		local xpInfo = gePetXP.GetXPInfo(gePetXP.EXP_FRIENDLY, nextPoint);
		local changeLv = nil;
		if xpInfo.level ~= friendLevel then
			changeLv = xpInfo.level;
		end

		AttachEffect(compa, "F_sys_heart", 2, "TOP");
		PET_SET_ACT_FLAG(compa);

		local tx = TxBegin(self);
		TxSetPetPCProp(tx, compa, 'FriendPointTime', strNextTime);
		TxSetPetPCProp(tx, compa, 'FriendPoint', nextPoint);
		if changeLv ~= nil then
			TxSetPetPCProp(tx, compa, 'FriendLevel', changeLv);
		end

		local ret = TxCommit(tx);
		
		if ret == "SUCCESS" then
			if changeLv ~= nil then
				-- AttachEffect(compa, 'F_pc_level_up', 3.0, 1, "MID", 1);
			end
		end

		sleep(2000);
		DetachEffect(compa, "F_sys_heart");
	end

end

function GET_PET_FOOD_ANIM_TYPE(self, compa)
	local type = "Normal";
	if GetFlyHeight(compa) > 0 and GetExProp_Str(compa, "REST_TYPE") == "IS_RESTING" then
		type = "Shoulder";
	end
	return type;
end

function GET_PET_FOOD_ANIM_CLASS(self, compa, type)
	local feedCls = GetCompanionAnimClass(compa.ClassName, type);

	if nil == feedCls then
		local feedCls = GetCompanionAnimClass(compa.ClassName, "Normal");	
	end

	if nil == feedCls then
		IMC_LOG("INFO_NORMAL", "CompanionFeedAnim data is nil className is " .. compa.ClassName);
		return;
	end

	return feedCls;
end

function PET_FOOD_SHOW_EMOTION(compa)
	AttachEffect(compa, "I_emo_exclamation", 3, "TOP");
	sleep(500);
	StopAnim(compa);
	sleep(500);
	DetachEffect(compa, "I_emo_exclamation");
end

function UPDATE_PET_FOOD(self, compa, funcName)
	local startTime = imcTime.GetAppTime() + 1;

	local isRideState =  GetVehicleState(self);
	local aniType = GET_PET_FOOD_ANIM_TYPE(self, compa);
	local feedCls = GET_PET_FOOD_ANIM_CLASS(self, compa, aniType);
	if nil == feedCls then
		IMC_LOG("INFO_NORMAL", "CompanionFeedAnim data is nil className is " .. compa.ClassName);
		return;
	end
	
	PlayAnim(self, feedCls.PCAnim, 1, 0);

	local useEquipAni = PET_FOOD_USE_EQUIP_ANIM(feedCls);
	local feedMonster = PET_FOOD_CREATE_FEED_AS_MONSTER(self, feedCls);
		
	if useEquipAni == true then
		PlayEquipItem(self, "RH", feedCls.ClassName, 1);
	end

	while 1 do
		if IsMoving(self) == 1 or IsSkillUsing(self) == 1 then
			break;
		end

		if imcTime.GetAppTime() > startTime then
		
			if compa ~= nil and GetNearTopHateEnemy(compa) == nil then
				HoldMonScp(compa);
				if 0 == isRideState then
				
					LookAt(compa, self);
					
					PET_FOOD_SHOW_EMOTION(compa);
					
					UPDATE_PET_FOOD_FOLLOW_FEED(self, compa, startTime);
					
					sleep(1000);
					PlayAnim(compa, feedCls.ComAnim, 1, 0);
					if feedMonster ~= nil then
						local feedAnim = TryGetProp(feedCls, "FeedAnim");
						if feedAnim ~= nil or feedAnim ~= "None" then
							PlayAnim(feedMonster, feedAnim, 1, 0);
						end
					end

					sleep(500);

					if useEquipAni == true then
						PlayEquipItem(self, "RH", feedCls.ClassName, 0);
					end
					if feedMonster ~= nil then
						SetLifeTime(feedMonster, 2, 1);
						feedMonster = nil;
					end

					StopAnim(self);
				else
					StopAnim(compa);
					PlayAnim(compa, feedCls.ComAnim, 1, 0);
					if feedMonster ~= nil then
						local feedAnim = TryGetProp(feedCls, "FeedAnim");
						if feedAnim ~= nil or feedAnim ~= "None" then
							PlayAnim(feedMonster, feedAnim, 1, 0);
						end
					end
					sleep(400);
					if useEquipAni == true then
						PlayEquipItem(self, "RH", feedCls.ClassName, 0);
					end
					if feedMonster ~= nil then
						SetLifeTime(feedMonster, 2, 1);
						feedMonster = nil;
					end
					sleep(500);
				end

				if funcName ~= nil and funcName ~= "None" then
					sleep(3000);
					local func = _G[funcName];
					func(compa);
				end

				sleep(feedCls.Sleep);
				
				PET_SET_ACT_FLAG(compa);
				break;
			end
		end

		sleep(300);
	end
	CANCEL_PET_FOOD_ANIM(self, compa, useEquipAni, feedCls, feedMonster);
end

function CANCEL_PET_FOOD_ANIM(pc, pet, useEquipAni, feedCls, feedMonster)
	if pc ~= nil then
		StopAnim(pc);
		if useEquipAni == true and TryGetProp(feedCls, 'ClassName') ~= nil then
			PlayEquipItem(pc, "RH", feedCls.ClassName, 0);
		end
	end

	if pet ~= nil then
		StopAnim(pet);
		PlayAnim(pet, "STD", 1, 0);
		SetHoldMonScp(pet, 0);
	end
	
	if feedMonster ~= nil then
		SetLifeTime(feedMonster, 2, 1);
	end	
end

function CAL_DOT_PRODUCT(a0, a1, a2, b0, b1, b2)
	return a0 * b0 + a1 * b1 + a2 * b2;
end

function CAL_LENGTH(a0, a1, a2)
	return math.sqrt(a0 * a0 + a1 * a1 + a2 * a2);
end


--베지어 곡선을 통해 자연스러운 곡선을 연출한다.
function UPDATE_PET_FOOD_FOLLOW_FEED_FLYING(self, compa, startTime)
	local fromX, fromY, fromZ = GetPos(compa);
	local toX, toY, toZ = GetFrontPos(self, 25);

	local distX = fromX - toX;
	local distY = fromY - toY;
	local distZ = fromZ - toZ;

	--컴패니언과 먹이 사이 2/3 지점에 곡선을 위한 제어점을 찍는다.
	local a0 = fromX - (distX * 2 / 3);
	local a1 = fromY;
	local a2 = fromZ - (distZ * 2 / 3);

	local b0 = toX;
	local b1 = toY + (distY * 2 / 3);
	local b2 = toZ;

	--먹이보다 PC가 가까이 있을 경우, 겹치지 않도록 약간 돌아서 간다.
	local distFromOwner = GetDistance(compa, self);
	local distFromFeed = CAL_LENGTH(distX, distY, distZ);

	if distFromOwner < distFromFeed then
		--컴패니언으로부터 먹이와 PC 사이의 각도 계산
		--Companion to Feed
		local CFNormal = CAL_LENGTH(distX, 0, distZ);

		local CFVectorX = distX;
		local CFVectorZ = distZ;

		--Companion to PC
		local pcX, pcY, pcZ = GetPos(self);
		local CPDistX = fromX - pcX;
		local CPDistZ = fromZ - pcZ;

		local CPNormal = CAL_LENGTH(CPDistX, 0, CPDistZ);
		local CPVectorX = CPDistX;
		local CPVectorZ = CPDistZ;

		--각도 계산
		local angle = math.deg(math.acos(CAL_DOT_PRODUCT(CFVectorX, 0, CFVectorZ, CPVectorX, 0, CPVectorZ) / (CFNormal * CPNormal)));

		--각도의 부호 결정 (외적의 Y)
		local sign = 1;
		if (CFVectorX * CFVectorZ - CPVectorZ * CPVectorX > 0) then
			sign = -1;
		end

		local weight = 40 / angle; -- 각도가 작을수록 가중치를 크게 한다.

		weight = math.max(weight, 10);
		weight = math.min(weight, 40);

		--오른쪽을 구하기 위해 외적	up x look
		local rightX = distZ;
		local rightZ = -distX;

		-- 정규화
		local n = math.sqrt(rightX * rightX + rightZ * rightZ);
		rightX = rightX / n;
		rightZ = rightZ / n;

		-- 제어점에 더한다
		a0 = a0 + rightX * weight * sign;
		a2 = a2 + rightZ * weight * sign;

		b0 = b0 + rightX * weight * sign;
		b2 = b2 + rightZ * weight * sign;
	end

	--마지막 제어점은 먹이의 약간 뒤에 찍는다. 자연스럽게 회전하는 것을 연출하기 위함
	local c0, c1, c2 = GetFrontPos(self, 30);

	PlayAnim(compa, "DOWN", 1, 0);
	MoveBezier(compa, toX, toY, toZ,
				a0, a1, a2,
				b0, b1, b2,
				c0, c1, c2, 1.3);
	sleep(1300);
end

function UPDATE_PET_FOOD_FOLLOW_FEED(self, compa, startTime)
	ChangeMoveSpdType(compa, "RUN");
	local x, y, z = GetFrontPos(self, 25);
	local lastDist = 0;
	while 1 do
		if IsMoving(self) == 1 or IsSkillUsing(self) == 1 then
			break;
		end

		MoveEx(compa, x,y,z,1);
		local dist = GetDistFromPos(compa, x, y, z);
						
		if dist <= 10 then
			StopMove(self);
			sleep(200);
			LookAt(compa, self);
			break;
		else
			if imcTime.GetAppTime() > startTime + 3 and lastDist == dist then
				StopMove(self);
				sleep(200);
				LookAt(compa, self);
				break;
			end
			lastDist = dist;
		end
		sleep(200);
	end
end

function PET_FOOD_USE_EQUIP_ANIM(feedCls)
	local itemXac = TryGetProp(feedCls, "ItemXac");
	
	if itemXac == nil or itemXac == "None" then
		return false;
	end

	return true;
end

function PET_FOOD_CREATE_FEED_AS_MONSTER(self, feedCls)
	local feedMonsterName = TryGetProp(feedCls, "FeedClassName");
	local feedCreateTime = TryGetProp(feedCls, "FeedCreateTimeMS");
	local feedDist = TryGetProp(feedCls, "FeedDist");

	if feedMonsterName == nil or feedMonsterName == "None" then
		return nil;
	end

	if feedDist == nil then
		feedDist = 0;
	end

	if feedCreateTime ~= nil then
		sleep(feedCreateTime);
	end

	local x, y, z = GetFrontPos(self, feedDist)
	return CREATE_MONSTER_EX(self, feedMonsterName, x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
end


function ON_PET_STAMINA_CHANGE(pet, owner)
	if 1 ~= GetVehicleState(owner) then
		return;
	end

	RemoveBuff(owner, "RidingCompanion");
	AddBuff(pet, owner, "RidingCompanion", 0, 0, 0, 0);

end

function SCR_SET_PET_STAMINA_MAX(self, pet)
	local maxStamina = TryGetProp(pet, "MaxStamina");
	local curStamina = TryGetProp(pet, "Stamina");
	if self == nil or maxStamina == nil or curStamina == nil then
		return;
	end

	if curStamina >= maxStamina then
		return;
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end

	TxEnableInIntegrate(tx);
	TxSetIESProp(tx, pet, 'Stamina', maxStamina, "Companion");

	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then
		InvalidateStates(pet);
		ON_PET_STAMINA_CHANGE(pet, self);
	end
end

function SCR_SET_PET_STAMINA_AND_HP(self, pet, feedItem, num1)
	local beforeStamina = pet.Stamina;
	local curStamina = 0;
	if nil ~= feedItem then
		curStamina = beforeStamina + feedItem.NumberArg1;
	else
		curStamina = beforeStamina + num1;
	end

	curStamina = math.min(curStamina, pet.MaxStamina);

	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	TxEnableInIntegrate(tx);
	if pet.Stamina ~= curStamina then
		TxSetIESProp(tx, pet, 'Stamina', curStamina, "Companion");
	end

	if nil ~= feedItem then
		TxTakeItemByObject(tx, feedItem, 1, "PetFeed");
	end

	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" and beforeStamina == 0 then
		InvalidateStates(pet);
		ON_PET_STAMINA_CHANGE(pet, self);
	end

	Heal(pet, pet.MHP, 0);
	if nil ~= feedItem then
		SetCoolDown(self, 'PetFood', 6000);
	end
end

function SCR_PLAY_FOOD_ANIM(pc, pcPet, feedItem, StringArg, NumberArg1)
	RunScript("SCR_SET_PET_STAMINA_AND_HP", pc, pcPet, feedItem, NumberArg1);

	if pcPet.MoveType == "Fly" then --AI와 충돌 문제로 AI 로직 내에서 먹는 작동하도록
		SetExProp(pcPet, "NEED_TO_EAT", imcTime.GetAppTime()); 
	else
		RunScript("UPDATE_PET_FOOD", pc, pcPet); --비행형 아닐 경우에는 직접 호출. 위 로직이 검증되면 통일성을 위해 얘네도 AI쪽으로 옮기자.
	end
end

function SCR_COMPANION_GIVE_FEED(pc, handle, itemIndex, arg3)
	local pcPet = GetCompanionByHandle(pc, handle)
	if nil == pcPet then
		return;
	end

    local feedItem = GetInvItemIES(pc, itemIndex);	
	if nil == feedItem then
		return;
	end
	
	if 'Consume' ~= feedItem.ItemType then
		return;
	end

	local itemtype = feedItem.ItemType;
	local curTime = GetCoolDown(pc, feedItem.CoolDownGroup);

	if curTime ~= 0 then
		return;
	end

	local petCls = GetClassByStrProp("Companion", "ClassName", pcPet.ClassName)
	if nil == petCls then
		return;
	end

	local foodGroup = 0;
	if petCls.FoodGroup ~= "None" then
		foodGroup = tonumber(petCls.FoodGroup);
	end
	
	if foodGroup ~= feedItem.NumberArg2 then
		SendSysMsg(pc, "ThisCompanionDoesNotEatThisFood");
	    return;
	end

	SCR_PLAY_FOOD_ANIM(pc, pcPet, feedItem,feedItem.StringArg, feedItem.NumberArg1)
end

function PET_FOOD_USE(self, argObj, strArg, num1, num2, itemType)
	if 1 == IsGuildHouseWorld(self) then
		if GUILD_PET_FOOD_USE(self, itemType, strArg, num1, num2) == true then
			return;
		end
	end

	local pcPetList = GetSummonedPetList(self)
	if #pcPetList == 0 then
		return 0;
	end

	local itemCls = GetClassByType("Item", itemType );
	if itemCls == nil then
		return 0;
	end
	
	local pcPet = nil;
	for i=1, #pcPetList do
		local petObj = pcPetList[i];
		local petCls = GetClassByStrProp("Companion", "ClassName", petObj.ClassName)
		local foodGroup = 0;
		if petCls ~= nil and petCls.FoodGroup ~= "None" then
			foodGroup = tonumber(petCls.FoodGroup);
		end

		if petCls ~= nil and foodGroup == num2 then
			pcPet = petObj;
		end

		-- 지상형과 공중형 펫을 둘다 데리고 다니는 경우, 먹이 줄 때는 지상형이 무조건 우선시 되어야 함
		if pcPet ~= nil and #pcPetList > 1 and TryGetProp(petCls, "JobID") ~= PET_HAWK_JOBID then
			break;
		end
	end	

	if nil == pcPet then
		return 0;
	end

	SCR_PLAY_FOOD_ANIM(self, pcPet, nil, itemCls.StringArg, num1)
end

function SCR_PRECHECK_FOOD(self, strArg, num1, num2, itemType)

	if 1 == IsGuildHouseWorld(self) then
		if GET_GUILD_PET(self, itemType, num2) ~= nil then
			return 1;
		end
	end

	local pcPetList = GetSummonedPetList(self)
	if #pcPetList == 0 then
		SendSysMsg(self, "SummonedPetDoesNotExist");
		return 0;
	end

	local itemCls = GetClassByType("Item", itemType );
	if itemCls == nil then
		return 0;
	end
	
	local pcPet = nil;
	for i=1, #pcPetList do
		local petObj = pcPetList[i];
		local petCls = GetClassByStrProp("Companion", "ClassName", petObj.ClassName)
		local foodGroup = 0;

		if petCls ~= nil and petCls.FoodGroup ~= "None" then
			foodGroup = tonumber(petCls.FoodGroup);
		end

		if petCls ~= nil and foodGroup == num2 then
			pcPet = petObj;
		end
	end	

	if TryGetProp(pcPet, 'IsActivated') ~= 1 then
		SendSysMsg(self, "SummonedPetDoesNotExist");
		return;
	end
	
	if pcPet == nil then
		SendSysMsg(self, "ThisCompanionDoesNotEatThisFood");
	    return 0;
	end
	
	
	local ret = IsNodeMonsterAttached(self, "None");
	if ret == 0 then
		return 1;
	end

	return 0;
end

function GET_COMPANION_POS(self)
	local list , cnt  = GetFollowerList(self);
	for i = 1 , cnt do
		local fol = list[i];
		local cls = GetClass("Companion", fol.ClassName);
		if cls ~= nil then
			local posX, posY, posZ = GetPos(fol);
			return posZ, posY, posX;
		end
	end

	return 0, 0, 0
end

function GET_PET_ATK_POINT(self, target, dist)
	local owner = GetOwner(self);
	if owner == nil then
		return -1;
	end
	
	local totalPts = -1;
	local ownerTarget = GetNearTopHateEnemy(owner);
	if ownerTarget ~= nil and IsSameObject(ownerTarget, target) == 1 then
		totalPts = totalPts + 100;
	end
	
	local ownerhated = 0
	if IS_PC(target) == false then
	    ownerhated = GetHate(target, owner);
	end 
	if ownerhated > 0 then
	    totalPts = totalPts + 50
	end
	
	local hate = GetHate(self, target);
	totalPts = totalPts + hate;
	if totalPts > 0 and dist > 1 then
		totalPts = totalPts / dist;
	end
	
	return totalPts;
end

function UPDATE_PET_LAST_ACT_TIME(self)
	SetExProp(self, "LAST_PET_ACT", imcTime.GetAppTime());
end

function PET_SET_ACT_FLAG(self)
	UPDATE_PET_LAST_ACT_TIME(self)
	SetExProp(self, "IS_RESTING", 0);
end

function PET_REST_PROCESS(self)

	local isResting = GetExProp(self, "IS_RESTING");
	local owner = GetOwner(self);
	if owner ~= nil then
		if isResting == 0 then
			LookAt(self, owner);
		end
	end

	local lastPetActTime = GetExProp(self, "LAST_PET_ACT");
	local restTime = imcTime.GetAppTime() - lastPetActTime;
	if restTime > 10 then
		PET_SET_ACT_FLAG(self);
		if isResting == 1 then
			PlayAnim(self, "WAKEUP", 0, 0);
		else
			PlayAnim(self, "SIT_ENTER", 1, 0);
			ReserveAnim(self, "SIT_LOOP", 1, 0);
			SetExProp(self, "IS_RESTING", 1);
		end				
	end
end

function PET_PARENT_DIST_CHECK(self, range)

	if self == nil then
		return 0;
	end
	
	if IsMoving(self) == 1 or IsSkillUsing(self) == 1 then
	    return 0;
	end
	
	local owner = GetOwner(self);
	local dist = GetDistance(self, owner);

	if dist == nil then
		return 0;
	end

	if dist >= 300 then
		local x, y, z = GetPos(owner);
		y = GetHeightAtPos(owner, x, y, z);
		SetPos(self, x, y, z);
		return 0;
	end

	if dist <= range then
		return 0;
	end

	local isResting = GetExProp(self, "IS_RESTING");
	PET_SET_ACT_FLAG(self);
	if isResting == 1 then
		PlayAnim(self, "WAKEUP", 0, 0);
		sleep(300);
	end

	CancelMonsterSkill(self);
	ResetHate(self);
	ChangeMoveSpdType(self, "RUN");
	if owner == nil then
		return 0;
	end

	MoveToOwner(self, 50);
	return 1;

end

function PET_PARENT_CHASE_DIST(friendLevel)
	
	if friendLevel == nil then
		friendLevel = 1;
	end
	
	return math.max(20, 100 - friendLevel * 20);
end

function PET_FOLLOW_OWNER(self)
	local friendLevel = tonumber(GetPetPCProperty(self, "FriendLevel", "1"));
	local parentRange = PET_PARENT_CHASE_DIST(friendLevel);
	local ret = PET_PARENT_DIST_CHECK(self, parentRange)
	if ret == 1 then
		return 1;
	end

	return 0;
end

function PET_LOOP_AI(self)

	if self == nil then
		return 0;
	end

    local abil = GetAbility(GetOwner(self), "CompMastery2")
    if abil ~= nil then
        if IsDead(self) == 0 and self.MHP/2 > self.HP and IsBuffApplied(self, 'Pet_Heal_After') == 'NO' then
            AddBuff(self, self, "Pet_Heal", 1, 0, 1000 + abil.Level * 1000, 1);
        end
    end
    
	if 1 == PET_FOLLOW_OWNER(self) then
		PET_SET_ACT_FLAG(self);
		return 1;
	end	
	
	-- 자동공격 옵션 꺼져 있으면 자동 공격하지 않게 수정
	local etc = GetETCObject(GetOwner(self))
	if TryGetProp(etc, 'CompanionAutoAtk') ~= "NO" then
		ret = S_AI_ATTACK_POINT(self, 200, "GET_PET_ATK_POINT");
		if ret == 1 then
			PET_SET_ACT_FLAG(self);
			return 1;
		end
	end	
    
	PET_REST_PROCESS(self);
	
	return 1;
end


function SCR_ADOPT_COMPANION(pc, petType, petName)

	local cls = GetClassByType("Companion", petType);
	if nil == cls then
		return;
	end

	if cls.JobID ~= 0 then 
		local jobCls = GetClassByType("Job", cls.JobID);
		if 0 == GetJobGradeByName(pc, jobCls.ClassName) then
			return;
		end
	end

	if stringfunction.IsValidCharacterName(petName) == true then
		RunScript("TX_ADOPT_COMPANION", pc, cls, petName);
	end
end

function TEST_PET(pc)

	local clsList = GetClassList("Companion");
	local cls = GetClassByIndexFromList(clsList, 2);

	local monCls =	GetClass("Monster", cls.ClassName);
	local petName = "TEST_PET_" .. IMCRandom(1, 1000);
	local tx = TxBegin(pc);
    TxAdoptPet(tx, monCls.ClassID, petName);	
	local ret = TxCommit(tx);
      
	if ret == "SUCCESS" then
		if haveCompanion == nil then
			if IsFullBarrackLayerSlot(pc) == 1 then
				ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
			else
				ExecClientScp(pc, "PET_ADOPT_SUC()");
			end
		else
			ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
		end
	end

	TEST_ABIL(pc, "CompanionRide");
end

function TX_ADOPT_COMPANION(pc, petCls, petName)
	local monCls =	GetClass("Monster", petCls.ClassName);
	local sellPrice = _G[petCls.SellPrice];
	sellPrice = sellPrice(petCls, pc);

	local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
	if cnt < sellPrice then
		return;
	end

	
	local haveCompanion = GetSummonedPet(pc, petCls.JobID);
	local tx = TxBegin(pc);
	TxTakeItem(tx, MONEY_NAME, sellPrice, "Pet");
    TxAdoptPet(tx, monCls.ClassID, petName);	
	local ret = TxCommit(tx);
      
	if ret == "SUCCESS" then
		if haveCompanion == nil then
			if IsFullBarrackLayerSlot(pc) == 1 then
				ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
			else
				ExecClientScp(pc, "PET_ADOPT_SUC()");
			end
		else
			ExecClientScp(pc, "PET_ADOPT_SUC_BARRACK()");
		end
	end

end

function PET_BITE(pc, pet, target, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel, bringHP, bringAnim, bringSpd)        
	HoldMonScp(pet);
	StopBiteTarget(pet);
    
	ChangeMoveSpdType(pet, "RUN");
	while 1 do            
		if IsHide(pet) == 1 then
			CancelMonsterSkill(pet);
			UnHoldMonScp(pet);
			return;
		end        
		if target == nil or target.Size == "XL" then
			UnHoldMonScp(pet);
			return;
		end        
		local dist = GetDist2D(pet, target);
		if dist > chaseRange then
			UnHoldMonScp(pet);
			return;
		end        
		if dist < biteRange + 5 then            
			StopMove(pet);            

			sleep(100);
            local isImmune = false
			if IS_PC(target) == true then
                -- bite 시간 점감 -------------------------------------------------------
                local buff = GetClass("Buff", biteBuff)
                if buff ~= nil then
                    local buffID = buff.ClassID
                    local before = biteSec;
                    biteSec = GetDiminishingMSTime(target, pc, biteSec * 1000, buffID, 0, 0) / 1000                        
                    if biteSec == 0 then
                        isImmune = true
                        PlayTextEffect(target, "I_SYS_Text_Effect_Skill", ScpArgMsg("SHOW_GUNGHO"))
                    end
                end
                ------------------------------------------------------------------------
			    biteSec = math.min(9, biteSec/2)
			end
            
			RemoveBuff(pet, 'Hounding_Buff');            
            if isImmune == false then
			    BiteTarget(pet, target, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel, bringHP, bringAnim, bringSpd);
            end
			return;
		end
        
		local x, y, z = Get3DPos(target)
		local angle = GetAngleTo(target, pet);
		angle = DegToRad(angle);
		x = x + math.cos(angle) * biteRange;
		z = z + math.sin(angle) * biteRange;
		MoveEx(pet, x, y, z, biteRange);
		sleep(300);
	end
end

function TGT_COMPANION_BITE(self, skl, needJobID, biteRange, chaseRange, biteSec, biteAnim, biteBuff, buffLevel, bringHP, bringAnim, bringSpd)	
	local tgt = GetHardSkillFirstTarget(self);
	if tgt == nil then
		return;
	end

	local pet = GetSummonedPet(self, needJobID);
	if IsRunningScript(self, "PET_BITE") == 1 then
		StopRunScript(self, "PET_BITE");
	end

	if pet ~= nil then
		RunScript("PET_BITE", self, pet, tgt, biteRange, chaseRange, biteSec, biteAnim, biteBuff, buffLevel, bringHP, bringAnim, bringSpd);
	end

	--local list = GetSummonedPetList(self);
	--for i = 1 , #list do
	--	local pet = list[i];
	--	RunScript("PET_BITE", self, pet, tgt, biteRange, chaseRange, biteSec, biteAnim, biteBuff, buffLevel, bringHP, bringAnim, bringSpd);
	--end
end

function PET_HOWL(pc, pet, target, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel)

	HoldMonScp(pet);

	ChangeMoveSpdType(pet, "RUN");
	while 1 do
		if target == nil then
			UnHoldMonScp(pet);
			return;
		end

		local dist = GetDist2D(pet, target);
		if dist > chaseRange then
			UnHoldMonScp(pet);
			return;
		end

		if dist < biteRange + 5 then
			StopMove(pet);

			sleep(100);
			HowlAround(pet, target, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel);
			return;
		end


		local x, y, z = Get3DPos(target)
		local angle = GetAngleTo(target, pet);
		angle = DegToRad(angle);
		x = x + math.cos(angle) * biteRange;
		z = z + math.sin(angle) * biteRange;
		MoveEx(pet, x, y, z, 1);
		sleep(300);
	end
end


function TGT_COMPANION_HOWL(self, skl, needJobID, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel)
	local tgt = GetHardSkillFirstTarget(self);
	if tgt == nil then
		return;
	end

	local pet = GetSummonedPet(self, needJobID);
	if pet ~= nil then
		RunScript("PET_HOWL", self, pet, tgt, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel);
	end

	--local list = GetSummonedPetList(self);
	--for i = 1 , #list do
	--	local pet = list[i];
	--	RunScript("PET_HOWL", self, pet, tgt, biteRange, chaseRange, biteSec, biteAni, biteBuff, buffLevel);
	--end
end

function PET_POINTING_COMMON(pet, pointScript, arriveFunc)

	ChangeMoveSpdType(pet, "RUN");

	local chaseRange = 250;
	local biteRange = 20;

	local lastTarget = nil;
	while 1 do
		local x, y, z = GetPos(pet);
		local target = nil;
		if lastTarget == nil then
			target = SelectByPointPos(pet, x, y, z, chaseRange, pointScript, "ENEMY", 0, 1);
			if target == nil then
				PET_FOLLOW_OWNER(pet);
				return 1;
			end
		else
			target = lastTarget;
		end

		local dist = GetDist2D(pet, target);
		if dist > chaseRange then
			return 1;
		end

		if dist < biteRange + 5 then
			StopMove(pet);

			arriveFunc(pet, target);
			sleep(300);
			return 1;
		end
		
		local x, y, z = Get3DPos(target)
		local angle = GetAngleTo(target, pet);
		angle = DegToRad(angle);
		x = x + math.cos(angle) * biteRange;
		z = z + math.sin(angle) * biteRange;
		MoveEx(pet, x, y, z, 1);
		sleep(300);
		lastTarget = target;
	end

	return 1;

end

function TGT_COMPANION_SKILL(self, skl, needJobID, skillUseRange, chaseRange, skillName, skillLevel, speed)

	local tgt = GetHardSkillFirstTarget(self);
	if tgt == nil then
		return;
	end

	local pet = GetSummonedPet(self, needJobID);
	if pet ~= nil then
		RunScript("PET_USE_SKILL", self, pet, tgt, skillUseRange, chaseRange, skillName, skillLevel, speed);
	end

	--local list = GetSummonedPetList(self);
	--for i = 1 , #list do
	--	local pet = list[i];
	--	RunScript("PET_USE_SKILL", self, pet, tgt, skillUseRange, chaseRange, skillName, skillLevel, speed);
	--end
end

function PET_USE_SKILL(pc, pet, target, skillUseRange, chaseRange, skillName, skillLevel, speed)

    if IsBuffApplied(pet, 'Pet_Dead') == 'YES' then
        return ;
    end
	
	local createdSkill = GetSkill(pet, skillName);
	createdSkill.LevelByDB = skillLevel;
	InvalidateSkill(pet, skillName);
	HoldMonScp(pet);
	pet.MSPD_BM = pet.MSPD_BM + speed;
	InvalidateMSPD(pet);
	PET_CANCEL_SKILL(pet)
	while 1 do
		if target == nil then
			pet.MSPD_BM = pet.MSPD_BM - speed;
			InvalidateMSPD(pet);
			UnHoldMonScp(pet);
			return;
		end

		local dist = GetDist2D(pet, target);
		if dist > chaseRange then
			pet.MSPD_BM = pet.MSPD_BM - speed;
			InvalidateMSPD(pet);
			UnHoldMonScp(pet);
			return;
		end

		if dist < skillUseRange + 5 then
			StopMove(pet);
			UseMonsterSkill(pet, target, skillName);

			if skillName == 'Mon_Velhider_Skill_2' and GetOwner(pet) ~= nil then
				local abil = GetAbility(GetOwner(pet), "Hunter8");
				if abil ~= nil and IMCRandom(1,100) < abil.Level * 10 then
					AddBuff(pet, target, "Stun", 1 , 0, 6000, 1);
				end
			end

			while 1 do
				sleep(300);
				if 0 == IsUsingSkill(pet) then
					PlayAnim(pet, 'SKL_RUSHDOG_RUN');
					MoveToOwnerAndChangeAnim(pet, 'ASTD');
					pet.MSPD_BM = pet.MSPD_BM - speed;
					InvalidateMSPD(pet);
					UnHoldMonScp(pet);
					return;
				end
			end
		end

		sleep(300);
		local x, y, z = Get3DPos(target)
		local angle = GetAngleTo(target, pet);
		angle = DegToRad(angle);
		x = x + math.cos(angle) * skillUseRange;
		z = z + math.sin(angle) * skillUseRange;
		MoveEx(pet, x, y, z, 1);
		PlayAnim(pet, 'SKL_RUSHDOG_RUN');
	end
end


function PET_POINTING_ARRIVE(pet, target)
    PlayAnim(pet, "feed_loop");
	local owner = GetOwner(pet);
	local skl = GetSkill(owner, "Hunter_Pointing");
	AddBuff(pet, target, "Pointing_Debuff", skl.Level, 0, 3000, 1);
end

function PET_POINTING(pet)

	return PET_POINTING_COMMON(pet, "SCR_PET_SEARCH_TARGET", PET_POINTING_ARRIVE);

end

function SCR_PET_SEARCH_HIDMON(self, target, dist)
	
	if IsHideFromMon(target) == 1 then
		if GetBuffByProp(target, "HideMon", "YES") ~= nil then
			return 1;
		end

		return -1;
	end

	return -1;
end

function PET_HOUNDING_ARRIVE(pet, target)
	PlayAnim(pet, "feed_loop");

	local removedCount = RemoveBuffByProp(target, "HideMon", "YES");
	local remainCount = GetExProp(pet, "Hounding_Count");
	remainCount = remainCount - 1;
	SetExProp(pet, "Hounding_Count", remainCount);
	if remainCount <= 0 then
		RemoveBuff(pet, "Hounding_Buff");
		return;
	end
	
end

function PET_HOUNDING(pet)

	return PET_POINTING_COMMON(pet, "SCR_PET_SEARCH_HIDMON", PET_HOUNDING_ARRIVE);

end

function PET_GROWLING_DEBUFF(pet)
    
    local owner = GetOwner(pet);
    local objList, objCount = SelectObject(pet, 35, 'ENEMY');
    local skl = GetSkill(owner, "Hunter_Growling");
    
    for i = 1, objCount do
        local target = objList[i]
        if skl ~= nil and target ~= nil then
        
            --AddBuff(pet, target, "Growling_Return_Debuff", 1, 0, 3000, 1);
        
            local rand = IMCRandom(1,10000)
            if target.Size == "S" or target.Size == "M" then
                AddBuff(pet, target, "Growling_fear_Debuff", skl.Level, 0, 3000 + skl.Level * 1000, 1);
            else
                if 5000 < rand then
                    AddBuff(pet, target, "Growling_fear_Debuff", skl.Level, 0, 3000 + skl.Level * 1000, 1);
                end
            end
        end
    end
end

function PET_GROWLING(pet)

    local owner = GetOwner(pet);
    
    local dist = GetDistance(pet, owner);

	if dist >= 250 then
        RemoveBuff(pet, "Growling_Buff");
        return 0;
	end

    PET_GROWLING_DEBUFF(pet)
end

function SCR_PET_SEARCH_TARGET(self, target, dist)
	local hpPercent = GetHpPercent(target);
	return 1000 - hpPercent;
end

function MSPD_RATIO_BY_FRIENDLY_LEVEL(friendLevel)
	if friendLevel == nil then
		return 1.0;
	end

	return math.min(1.5, 0.9 + 0.1 * friendLevel);
end

function SCR_Get_PET_MSPD(self)
 
	local friendLevel = tonumber(GetPetPCProperty(self, "FriendLevel", "1"));
	local ratio = MSPD_RATIO_BY_FRIENDLY_LEVEL(friendLevel);
	local mspd = SCR_Get_MON_MSPD(self) * ratio;
	if self.Stamina == 0 then
		return mspd * 0.5;
	end

	return mspd;

end

function PET_STAT_UP_SERV(pc, guid, clsName, trainCnt)
	if GetExProp(pc, 'PET_TRAIN_SHOP') ~= 1 then
		return;
	end

	local pet = GetPetObjByGuid(pc, guid);
	local petStat = TryGetProp(pet, 'Stat_'..clsName);
	local pcMoney, moneyCnt = GetInvItemByName(pc, MONEY_NAME);
	local cls = GetClass("Pet_Ability", clsName);
	if cls == nil or petStat == nil or pcMoney == nil or moneyCnt < 0 then
		return;
	end

	local needSilver = 0;
	for i = 0, trainCnt - 1 do
		needSilver = needSilver + GET_PET_STAT_PRICE(pc, pet, clsName, petStat + i);
	end
	if needSilver <= 0 or moneyCnt < needSilver then
		SendAddonMsg(pc, "Auto_SilBeoKa_BuJogHapNiDa.");
		return;
	end

	RunScript("_PET_STAT_UP_SERV", pc, guid, clsName, trainCnt);
end

function _PET_STAT_UP_SERV(pc, guid, clsName, trainCnt)

	local pet = GetPetObjByGuid(pc, guid);
	local propName = "Stat_".. clsName;
	local curValue = TryGetProp(pet, propName);
	local pcMoney, moneyCnt = GetInvItemByName(pc, MONEY_NAME);
	if curValue == nil or pcMoney == nil or moneyCnt < 0 then
		return;
	end

	local needSilver = 0;
	for i = 0, trainCnt - 1 do
		needSilver = needSilver + GET_PET_STAT_PRICE(pc, pet, clsName, curValue + i);
	end
	if needSilver <= 0 or moneyCnt < needSilver then
		SendAddonMsg(pc, "Auto_SilBeoKa_BuJogHapNiDa.");
		return;
	end

	local tx = TxBegin(pc);
	TxTakeItem(tx, MONEY_NAME, needSilver, "PetStatUp");
	TxSetIESProp(tx, pet, propName, curValue + trainCnt, "Companion");
	local ret = TxCommit(tx);	

	if ret == "SUCCESS" then
		CompanionMongoLog(pc, pet, "StatUp", clsName, curValue + 1);
	end

	--[[ curStamina는 없는 변수인데 뭘까요..? 미구현인 걸까요?
	if ret == "SUCCESS" and curStamina == 0 then
		InvalidateStates(pet);
	end
	]]--
end

function SCR_BUFF_ENTER_RidingCompanion(self, buff, arg1, arg2, over)
	local pet = GetBuffCaster(buff);
	local addMSPD = 4;

    local Cloakingbuff = GetBuffByProp(self, 'Keyword', 'Cloaking')
    if Cloakingbuff ~= nil then
        RemoveBuff(self, Cloakingbuff.ClassName);
    end
    
	if pet.Stamina > 0 then
		AddPropByBuff(buff, "MHP_BM", pet.MountMHP);
		AddPropByBuff(buff, "DR_BM", pet.MountDR);
		AddPropByBuff(buff, "DEF_BM", pet.MountDEF);
		AddPropByBuff(buff, "PATK_BM", pet.MountPATK);	
		AddPropByBuff(buff, "MSPD_BM", pet.MountMSPD);
	end
	
	local petClassName = TryGetProp(pet, 'ClassName');
	if petClassName ~= nil then
		local compClass = GetClass('Companion', petClassName);
		local rideMSPD = TryGetProp(compClass, 'RideMSPD');
		if rideMSPD ~= nil then
			addMSPD = rideMSPD;
		end
	end
	
	
	
	SetExProp(buff, 'ADD_MSPD', addMSPD);
	self.MSPD_BM = self.MSPD_BM + addMSPD;
end

function SCR_BUFF_LEAVE_RidingCompanion(self, buff, arg1, arg2, over)
	local addMSPD = GetExProp(buff, 'ADD_MSPD');
	self.MSPD_BM = self.MSPD_BM - addMSPD;
	
	
	local pet = GetBuffCaster(buff);
	if pet == nil then
		return;
	end
	
	local companionClassName = TryGetProp(pet, 'ClassName');
	if companionClassName ~= nil then
		local companionClass = GetClass('Companion', companionClassName);
		local isRidingOnly = TryGetProp(companionClass, 'RidingOnly');
		if isRidingOnly == 'YES' then
		    local nextTime = GetAddDataFromCurrent(3);
		    SetExProp_Str(pet, "COMPANION_RIDINGONLY_COOLTIME", nextTime);
			
			AddBuff(self, pet, 'System_Companion_VisibleTime', 1, 0, 30000, 1);
		end
	end
end

function SCR_BUFF_ENTER_TakingOwner(self, buff, arg1, arg2, over)
	SetSafe(self, 1);
end

function SCR_BUFF_LEAVE_TakingOwner(self, buff, arg1, arg2, over)
	SetSafe(self, 0);
end

function SCR_SIT_MOVE(pc, pet)

	RandomMove(pet, 20)

end

function GET_PET_LIST(pc)
	local list = GetPetList(pc);
	if #list > 0 then
		return list;
	else
		return nil;
	end
end

function GET_PET_BY_INDEX(list, i)
	if list == nil or i == nil then
		return; 
	end

	if i < 1 or i > #list then 
		return;
	end

	local pet = list[i];
	if pet == nil then
		return;
	end

	pet = tolua.cast(pet, "gePet::PET_INFO");
	return pet:GetClassName(), pet:GetName(), pet:GetLevel();	
end

function PET_ABLE_TO_RIDE(self, pet)
	if 1 == IsRunningScript(pet, "UPDATE_PET_FOOD") then
		return 0;
	end
	
	if IsBuffApplied(pet, 'Growling_Buff') == 'YES' then
	    --RemoveBuff(pet, "Growling_Buff"); --It needs to be toggling for growling skill
	    return 0;
	end
	
	if IsBuffApplied(self, 'HangingShot') == 'YES' then
	    return 0;
	end
	
	if IsBuffApplied(self, 'Camouflage_Buff') == 'YES' then
	    return 0;
	end
	
	-- 탑승 전용 컴패니언 처리 --
	local companionClassName = TryGetProp(pet, 'ClassName');
	if companionClassName ~= nil then
		local companionClass = GetClass('Companion', companionClassName);
		local isRidingOnly = TryGetProp(companionClass, 'RidingOnly');
		if isRidingOnly == 'YES' then
		    local coolTime = GetExProp_Str(pet, "COMPANION_RIDINGONLY_COOLTIME");
		    if GetTimeDiff(coolTime) < 0 then
		    	SendSysMsg(self, 'YouCanNotRideCompanionCoolTime');
		        return 0;
		    end
			
	    	AddVisiblePC(pet, self, 0);
			
			RemoveBuff(pet, 'System_Companion_VisibleTime');
		end
	end
	
	return 1;
end

function WAIT_PAUSE_PET_SKILL(pet, ms)
	sleep(ms);
	local pauseCount = GetExProp(pet, "PAUSE_PET_SKILL");
	if pauseCount > 0 then
		SetExProp(pet, "PAUSE_PET_SKILL", pauseCount - 1);
	end
end

function UPDATE_PET_ACTIVATE(pet, pc, isFirstUpdate)

	if GetExProp(pet, "DEACTIVATED") ~= pet.IsActivated then
		return;
	end
	CancelMonsterSkill(pet);

	if pet.IsActivated == 1 then
		SetHide(pet, 0);
		SetSafe(pet, 0);
		UnHoldMonScp(pet);
		RunScript("UPDATE_PET_STAMINA", pet);
		SetExProp(pet, "DEACTIVATED", 0);
		local x, y, z = GetPos(pc);
		SetPos(pet, x, y, z);
		
		local pauseCount = GetExProp(pet, "PAUSE_PET_SKILL");
		SetExProp(pet, "PAUSE_PET_SKILL", pauseCount + 1);
		local waitMS = 1500;
		RunScript("WAIT_PAUSE_PET_SKILL", pet, waitMS);
	else
		SetHide(pet, 1);
		SetSafe(pet, 1);
		HoldMonScp(pet);
		RemoveAllBuff(pet);

		if 0 == StopRunScript(pet, "UPDATE_PET_STAMINA") then
			RunScript("STOP_PET_STAMINA", pet)	
		end
        
		SetExProp(pet, "DEACTIVATED", 1);
	end
end

function STOP_PET_STAMINA(pet)
	while 1 do
		if StopRunScript(pet, "STOP_PET_STAMINA") == 1 then
			return;
		end

		sleep(500);
	end
end

function SCR_PET_ACTIVATE(pc)

	local pet = GetSummonedPet(pc, PET_COMMON_JOBID);
	if pet == nil then
        pet = GetSummonedPet(pc, PET_HAWK_JOBID);
        if pet == nil then
		    return;
        end
	end
	
	local nextActivateSec = GetExProp(pet, "ACTIVATE_SEC");
	if imcTime.GetAppTime() < nextActivateSec then
		return;
	end

	local pcFaction = GetCurrentFaction(pc);
	if pcFaction == 'Peaceful' and IsInTeamBattlezone(pc) == 1 then
		local etc = GetETCObject(pc);
		if etc.Team_Mission == 0 then
			SetCurrentFaction(pet, "Peaceful");
			SetHideCheckScript(pet, "HIDE_FROM_PVP_PLAYERS");
			AddBuff(pet, pet, "GuildBattle_Observe")
		end
	end
	
	SetExProp(pet, "ACTIVATE_SEC", imcTime.GetAppTime() + PET_ACTIVATE_COOLDOWN - 1);
	
	if 1 == pet.IsActivated then
		if GetRidingCompanion(pc) ~= nil then
			SendSysMsg(pc, "DownFromPetFirst");
			return;
		end

		pet.IsActivated = 0;
	else
		pet.IsActivated = 1;
	end

	SendPropertyByName(pc, pet, "IsActivated");

	UPDATE_PET_ACTIVATE(pet, pc);

end

function CHECK_PET_LIFETIME(pet, petLifeMin, currentMin)

	local startTime = imcTime.GetAppTime();
	while 1 do

		local elapsedSec = imcTime.GetAppTime() - startTime;
		local overMinute = math.floor(currentMin + (elapsedSec / 60) - petLifeMin);
		if overMinute > 0 then
			local overDate = GET_PET_OVER_DATE(overMinute);
			local lastOverDate = pet.OverDate;
			if lastOverDate ~= overDate then
				pet.OverDate = overDate;
				local pc = GetOwner(pet);
				if pc ~= nil then
					SendProperty(pc, pet);
					InvalidateStates(pet);
				end

				if overDate >= 10 then
					local owner = GetOwner(pet);
					if owner ~= nil then
						local tx = TxBegin(owner);				
						TxSetIESProp(tx, pet, 'OverDate', 10, "Companion");
						TxSetPetPC(tx, pet, "0");
						local ret = TxCommit(tx);
						SendProperty(owner, pet);
					end

					Dead(pet);
					return;
				end
			end
		end

		sleep(1000);
	end

end


function PET_CANCEL_SKILL(self)
	if self == nil then
		return
	end

	-- bite / howl skill cancel
	CancelPetSkill(self)

	-- buff skill cancel
	if IsBuffApplied(self, 'Growling_Buff') == 'YES' then
	    RemoveBuff(self, "Growling_Buff");
	end
	if IsBuffApplied(self, 'Hounding_Buff') == 'YES' then
	    RemoveBuff(self, "Hounding_Buff");
	end
	if IsBuffApplied(self, 'Pointing_Buff') == 'YES' then
	    RemoveBuff(self, "Pointing_Buff");
	end
end

function PET_COME_ON(self)
	if self == nil then
		return
	end
	
	-- skill use 상태이면 cancel하고 따라갈 수 있도록
	PET_CANCEL_SKILL(self)
	
	local companionClass = GetClass('Companion', self.ClassName);
	if companionClass ~= nil then
		if TryGetProp(companionClass, 'RidingOnly') == 'YES' then
			return;
		end
	end
	
	local petOwner = GetOwner(self);
	if petOwner ~= nil then
		local x, y, z = GetPos(petOwner);
		if GetDistance(self, petOwner) >= 300 then
			SetPos(self, x, y, z);
			return;
		end
	end
	
	MoveToOwner(self, 0)
end

function SCR_BUFF_ENTER_System_Companion_VisibleTime(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_UPDATE_System_Companion_VisibleTime(self, buff, arg1, arg2, RemainTime, ret, over)
	local caster = GetBuffCaster(buff);
	if caster == nil then
		return 0;
	end
	
	if GetVehicleState(caster) == 1 then
		return 0;
	end
	
	return 1;
end

function SCR_BUFF_LEAVE_System_Companion_VisibleTime(self, buff, arg1, arg2, over)
	local remainTime = GetBuffRemainTime(buff)
	if remainTime == nil then
		remainTime = 0;
	end
	
	if remainTime <= 0 then
		local caster = GetBuffCaster(buff);
		if self ~= nil and caster ~= nil then
			AddVisiblePC(self, caster, 1);
			return;
		end
	end
	
--	AddVisiblePC(self, caster, 0);
end



--[[

GlobalServer_Release.exe -SGID 17500 -SID 17500 -DEV

Barrack_Release.exe -SGID 17500 -SID 17501 -DEV

Zone_Release.exe -SGID 17500 -SID 17502 -DEV

ChatServer_Release.exe -SGID 17500 -SID 17503 -DEV

RelationServer_Release.exe -SGID 17500 -SID 17504 -DEV

]]--