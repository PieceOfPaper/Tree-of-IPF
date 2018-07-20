function SCR_USE_ACHIEVE_BOX(self,argObj,argstr,arg1,arg2)
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, argstr, 1)
    local ret = TxCommit(tx);
end

function SCR_ITEM_CHECK(pc, itemList)
	local haveItemList = {};
	for i = 1, #itemList do
		local item = GetClass("Item", itemList[i])
		local invItem, count = GetInvItemByType(pc, item.ClassID)
		local EquipItem = GetEquipItemByType(pc, item.ClassID)
		if invItem ~= nil then
			haveItemList[#haveItemList + 1] = invItem;
		elseif EquipItem ~= nil then
			haveItemList[#haveItemList + 1] = EquipItem;	
		end
	end

	local itemText = "";
	local firstItem = true;
	for i = 1, #haveItemList do
		local allowDup = TryGetProp(haveItemList[i],'AllowDuplicate')
		if allowDup == "NO" then
			if firstItem == true then
				firstItem = false;
				itemText = itemText..haveItemList[i].Name
			else
				itemText = itemText..", "..haveItemList[i].Name
			end
		end
	end

	local text = ScpArgMsg("ItemCheck") .. "*@*" .. ScpArgMsg("HaveItemReallyUse").." : "..itemText;
	local select_1 = ShowSelDlg(pc, 0, text, ScpArgMsg('Yes'), ScpArgMsg('No'))

	if select_1 == 1 then
		return true;
	else
		return false;
	end

end

function SCR_USE_CLASSMAJORQUESTCOUNT_5ADD(self,argObj, StringArg, Numarg1, Numarg2)
    local propertyList = {}
    local questNameList = {}
    local list, cnt = GetClassList('ClassMajorQuest');  
    if cnt == 0 then
        return
    end
    local sObj = GetSessionObject(self, 'ssn_klapeda');
    for i=0, cnt-1 do
        local majorQuestIES = GetClassByIndexFromList(list, i);
        local questProperty = GetClassString('QuestProgressCheck',majorQuestIES.ClassName,'QuestPropertyName')
        local questJob = majorQuestIES.Job
        if sObj[questProperty..'_R'] >= 5 then
            local jobCircle, jobRank = GetJobGradeByName(self, questJob);
            if jobCircle >= 1 then
                propertyList[#propertyList + 1] = questProperty..'_R'
                questNameList[#questNameList + 1] = ScpArgMsg("CLASSMAJORQUESTCOUNT_5ADD_MSG3","QUEST",GetClassString('QuestProgressCheck',majorQuestIES.ClassName,'Name'),"BEFORE",sObj[questProperty..'_R'],"COUNT",sObj[questProperty..'_R'] - 5)
            end
        end
    end
    
    if #propertyList > 0 then
        local select = SCR_SEL_LIST(self,questNameList, 'CLASSMAJORQUESTCOUNT_5ADD_SEL',1)
        if select > 0 then
            local before = sObj[propertyList[select]]
            local tx = TxBegin(self);
    		TxSetIESProp(tx, sObj, propertyList[select], sObj[propertyList[select]]-5 );
    		local ret = TxCommit(tx);
    		if ret == 'SUCCESS' then
    		    PlayEffect(self, 'I_spread_out001_light_pink', 1, 1,'TOP')
                PlaySound(self, 'skl_eff_tinkly_force')
                SendAddOnMsg(self, "NOTICE_Dm_scroll", questNameList[select], 10);
            end
        end
    end
end


function SCR_USE_ITEM_ArmorPackage(self,argObj, StringArg, Numarg1, Numarg2)

	RunScript('GIVE_ITEM_SET_TX', self, Numarg1, "Package");

end

function SCR_SOULSTONE(self,argObj, BuffName, arg1, arg2)

	local hpup = arg1 / 100 * self.MHP;
	local spup = arg2 / 100 * self.MSP;
	AddHP(self, hpup);
	AddSP(self, spup);
	AddBuff(self, self, 'AfterEffect', 1, 0, 5000, 1);

end

-- CoolDownTimeReseter
function SCP_USE_ITEM_CoolDownTimeReseter(self,BuffName,arg1,arg2)

	ResetCoolDownTime(self);

end

-- AllPcCoolDownTimeReseter
function SCP_USE_ITEM_AllPcCoolDownTimeReseter(self,BuffName,arg1,arg2)

	ResetCoolDownTimeAllPC(self);

end

function SCR_USE_ITEM_ReturnScroll(self,argObj,BuffName,arg1,arg2)
    MoveToSaveLocation(self)
--	Warp(self, 'SIAUL_KLAPEDA');
end

function SCR_PRE_Escape(self, argObj, BuffName, arg1, arg2)
    local currentZone = GetZoneName(self);
    if currentZone == 'c_Klaipe' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CanNotEscapeInKlaipe"), 5);
        return 0;
    end

    return 1;
end

function SCR_PRE_Escape_Orsha(self, argObj, BuffName, arg1, arg2)
    local currentZone = GetZoneName(self);
    if currentZone == 'c_orsha' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CanNotEscapeInOrsha"), 5);
        return 0;
    end

    return 1;
end

function SCR_USE_ITEM_Escape(self, argObj, BuffName, arg1, arg2)
    if GetLayer(self) == 0 then
        local cls = GetClassList('Map');
        local zone = GetZoneName(self);
        local obj = GetClassByNameFromList(cls, zone);
    
        SetPos(self, obj.DefGenX, obj.DefGenY, obj.DefGenZ);
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("EscapeDisabled"), 5);
    end
end

function SCR_USE_ITEM_Escape_Orsha(self, argObj, BuffName, arg1, arg2)
    MoveZone(self, 'c_orsha', 147, 177, 277);
end

function SCR_GET_GEM_LEVEL(item) 

	local nowgemExp = item.Exp

	local clslist, cnt  = GetClassList("gemexptable");
	local rateBorder = {}
	local result = -1

	local tempborder = 0;
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		tempborder = tempborder + cls.Exp;
		rateBorder[i] = tempborder;
	end

	if nowgemExp >= tempborder then 
		return cnt;
	end

	for i = 0 , cnt - 1 do

		if i == 0 then
			if 0 <= nowgemExp and nowgemExp < rateBorder[0] then
				result = i;
				break;
			end
		elseif i == cnt - 1  then
			if rateBorder[i-1] <= nowgemExp and nowgemExp < tempborder then
				result = i;
				break;
			end
		else
			if rateBorder[i-1] <= nowgemExp and nowgemExp < rateBorder[i] then
				result = i;
				break;
			end
		end
		
	end

	return result; 
end


function SCR_GET_STA_COOLDOWN(item)
	--local pc = GetItemOwner(item);
  
  return item.ItemCoolDown;
	
end


function SCR_GET_HASTE_COOLDOWN(item)

  return item.ItemCoolDown;
	
end

function SCR_USE_ITEM_DETOXIFIY(self, argObj, BuffName, arg1, arg2)

	local debuff = GetBuffByProp(self, 'Keyword', 'Poison');

	if debuff ~= nil and debuff.Group1 == "Debuff" then
	    RemoveBuff(self, debuff.ClassName)
	end

end


function SCR_USE_ITEM_AddHP1(self,argObj,BuffName,arg1,arg2)

	local hpPoint = IMCRandom(arg1, arg2);
	
	if self.HPPotion_BM > 0 then
		hpPoint = math.floor( hpPoint * (1 + self.HPPotion_BM/100));
	end

		Heal(self, hpPoint, 0);
end

function SCR_USE_ITEM_AddSP1(self,argObj,BuffName,arg1,arg2)
	
	local spPoint = IMCRandom(arg1, arg2);

	if self.SPPotion_BM > 0 then
		spPoint = math.floor( spPoint * (1 + self.SPPotion_BM/100));
	end
	
	if GetBuffByProp(self, 'Keyword', 'Curse') ~= nil then
		spPoint = 0;
	end

	AddSP(self, spPoint);

end

function SCR_USE_ITEM_AddSTA1(self,argObj,BuffName,arg1,arg2)

	local staminaPoint = IMCRandom(arg1, arg2) * 1000;
	
	if self.STAPotion_BM > 0 then 
		staminaPoint = math.floor(staminaPoint * (1 + self.STAPotion_BM/100));
	end
	
	AddStamina(self, staminaPoint);
	
end

function SCR_USE_ITEM_AddHPSP1(self,argObj,BuffName,arg1,arg2)

	local hpPoint = IMCRandom(arg1, arg2);
	local spPoint = IMCRandom(arg1, arg2)/3; 
	
	if self.HPPotion_BM > 0 then
		hpPoint = math.floor( hpPoint * (1 + self.HPPotion_BM/100));
	end
	if self.SPPotion_BM > 0 then
		spPoint = math.floor( spPoint * (1 + self.SPPotion_BM/100));
	end

	AddHP(self, hpPoint);
	AddSP(self, spPoint);

end

function SCR_USE_ITEM_DotBuff(self,argObj,BuffName,arg1,arg2)

	ChangeActorStateToRest(self);

	AddBuff(self, self, BuffName, arg1, 0, 15000, 1);
	AddAchievePoint(self, "Potion", 1);

end

function SCR_USE_ITEM_DotBuff_Time(self,argObj,BuffName,arg1,arg2)

	ChangeActorStateToRest(self);

	AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	AddAchievePoint(self, "Potion", 1);

end

function SCR_USE_ITEM_AddBuff(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	AddAchievePoint(self, "Potion", 1);

end

function SCR_USE_ITEM_AddTeamBuff(self,argObj,BuffName,arg1,arg2)
   	AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	local range = 300;
	local list, cnt = GetPartyMemberList(self, PARTY_NORMAL, range);

	for i = 1, cnt do
	    AddBuff(self, list[i], BuffName, arg1, 0, arg2, 1);
	end

end

function SCR_USE_ITEM_RemoveBuff(self,argObj,BuffName,arg1,arg2)
	RemoveBuff(self, BuffName);
end

function SCR_ITEM_EnchantBomb(self, argObj, StringArg, Numarg1, Numarg2)
    local objList, objCount = SelectObject(self, 200, 'ENEMY');
    local target = objList[1]
    LookAt(self, target)
    PlayAnim(self, 'PUBLIC_THROW', 1)
    AddBuff(self, self, 'EnchantBomb', 1, 0, 1000, 1);
    
    local x, y, z = GetPos(target)
    local eftName = 'I_force015_white#Dummy_R_HAND';
    local eftScale = 1;
    local range = 30;
    local flyTime = 0.4;
    local delayTime = 0;
    local gravity = 600;
    local spd = 1;
    local endEftName = 'I_explosion008_violet';
    local endScale = 1;
    local eftMoveDelay = 0;
    local hitTime = 1000;
    local hitCount = 1;
    local dotEffect = 'None';
    local dotScale = 1;
    local kdPower = 0;
    local KnockType = 1;
    local innerRange = 0;
    
    RunScript('SCR_THROW_ENCHANTBOMB', self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay, hitTime, hitCount, dotEffect, dotScale, kdPower, KnockType, innerRange)
end

function SCR_THROW_ENCHANTBOMB(self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay, hitTime, hitCount, dotEffect, dotScale, kdPower, KnockType, innerRange)
	sleep(300)
	
	MslThrow(self, eftName, eftScale, x, y, z, range, flyTime, delayTime, gravity, spd, endEftName, endScale, eftMoveDelay);
	
	if eftMoveDelay > 0 then
		eftMoveDelay = eftMoveDelay * 1000;
		sleep(eftMoveDelay);
	end
	
	OP_DOT_DAMAGE(self, 'ENCHANTBOMB', x, y, z, flyTime + delayTime, range, hitTime, hitCount, dotEffect, dotScale, kdPower, KnockType, innerRange);
end

function SCR_ITEM_SmokeBomb(self,argObj, StringArg, Numarg1, Numarg2)
	if StringArg == 'General' then
		SCR_ITEM_General_SmokeBomb(self, Numarg1, Numarg2);
	elseif StringArg == 'Poison' then
		SCR_ITEM_Poison_SmokeBomb(self, Numarg1, Numarg2);
	elseif StringArg == 'Heal' then
		SCR_ITEM_Heal_SmokeBomb(self, Numarg1, Numarg2);
	elseif StringArg == 'Speed' then
		SCR_ITEM_Speed_SmokeBomb(self, Numarg1, Numarg2);
	end
end

function SCR_ITEM_General_SmokeBomb(self, Numarg1, Numarg2)
	PlayEffect(self, 'F_smoke071_gray1', 6.0, 1, "BOT", 1);

	local fndList, fndCount = SelectObject(self, 60, 'ENEMY');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
			if fndList[i].Faction == 'Monster' and fndList[i].TargetWindow ~= 0 then
				if fndList[i].Tactics ~= 'MON_RETURN' and  0 == IsItem(fndList[i]) then

					ResetHate(fndList[i]);
					SetTacticsArgObject(fndList[i], nil);

					CreateSessionObject(fndList[i], 'ssn_mon_return');

					local mon_sObj = GetSessionObject(fndList[i], 'ssn_mon_return');
					mon_sObj.BeforeTactics = fndList[i].Tactics;

					CancelMonsterSkill(fndList[i]);
					StopMove(fndList[i]);
					fndList[i].Tactics = 'MON_RETURN';
					ChangeTacticsMainState(fndList[i],'TM_BORN');
					PlayEffect(fndList[i], 'smokebombsize', 6.0, 1, "BOT", 1);
				end
			end
		end
	end
end

function SCR_ITEM_Poison_SmokeBomb(self, Numarg1, Numarg2)
	PlayEffect(self, 'poisionsmokebomb', 6.0, 1, "BOT", 1);

	local fndList, fndCount = SelectObject(self, 60, 'ENEMY');
	for i = 1, fndCount do
		if fndList[i].ClassName ~= 'PC' then
			if fndList[i].Faction == 'Monster' and fndList[i].TargetWindow ~= 0 then
				if fndList[i].Tactics ~= 'MON_RETURN' and 0 == IsItem(fndList[i]) then
					AddBuff(self, fndList[i], 'Poison', 1, 0, 10000, 1);
					PlayEffect(fndList[i], 'poisionsmokebombsize', 6.0, 1, "BOT", 1);
				end
			end
		end
	end
end

function SCR_ITEM_Heal_SmokeBomb(self, Numarg1, Numarg2)
	PlayEffect(self, 'healsmokebomb', 6.0, 1, "BOT", 1);

	local fndList, fndCount = SelectObject(self, 60, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName == 'PC' then
			AddBuff(self, fndList[i], 'Rejuvenation', 1, 0, 5000, 1);
			PlayEffect(fndList[i], 'healsmokebombsize', 6.0, 1, "BOT", 1);

		end
	end
end

function SCR_ITEM_Speed_SmokeBomb(self, Numarg1, Numarg2)
	PlayEffect(self, 'speedsmokebomb', 6.0, 1, "BOT", 1);

	local fndList, fndCount = SelectObject(self, 60, 'ALL');
	for i = 1, fndCount do
		if fndList[i].ClassName == 'PC' then
			AddBuff(self, fndList[i], 'MoveSpeed', 1, 0, 15000, 1);
			PlayEffect(fndList[i], 'speedsmokebombsize', 6.0, 1, "BOT", 1);
		end
	end
end

function SCR_MONGWANGGA(pc,argObj, item, x, y, z)

	--UsePcGroundSkill(pc, x, y, z, 'MongWangGa', 1);
	UsePcGroundSkillByItem(pc, item.ClassID, 1, x, y, z, 'MongWangGa');

end

function SCR_PICK_WIKI(pc, mon)
	return 1;
end

function SCR_PetScroll_Haming(self,argObj,argstring,arg1,arg2)
    local pet_sObj = GetSessionObject(self, argstring)
    
    if pet_sObj == nil then
        CreateSessionObject(self, argstring, 1)
    else
        DestroySessionObject(self, pet_sObj, 1)
    end
end

function SCR_USE_ITEM_HasteBuff(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, 'Drug_Haste', arg1, 0, arg2, 1);

end

function SCR_USE_ITEM_RedOxBuff(self,argObj,BuffName,arg1,arg2)

	AddBuff(self, self, 'Drug_RedOx');

end



function SCR_USE_ITEM_Warp(self)

   --ExecClientScp(self, "INTE_WARP_OPEN_FOR_QUICK_SLOT()");
end

function SCR_USE_ITEM_Infi_Warp(self,argObj,BuffName,arg1,arg2)

	sleep(1000)
    PlayAnim(self, 'WARP');
    MoveZone(self, 'infinite_map', 0, 50, 400);

end





function SCR_USE_ROKAS27_QB_6(self,argObj,BuffName,arg1,arg2)
    local quest_ssn = GetSessionObject(self, 'SSN_ROKAS27_QB_6')
    if quest_ssn ~= nil then
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
        local imc_random = IMCRandom(1, 10)
            if imc_random >= 7 then
                quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_KoKoHagJaui_JeungPyoLeul_BalKyeonHaessSeupNiDa!"), 3);
                local get_item = GetInvItemList(self);
	            if #get_item > 0 then
                    local itemType = {}
                    local item_cnt = {}
    	            for i = 1, #get_item do
                        itemType[i] = GetClass("Item", get_item[i].ClassName).ClassID;
                        item_cnt[i] = GetInvItemCountByType(self, itemType[i]);
                        if get_item[i].ClassName == 'ROKAS27_QB_6' then
                            RunScript('GIVE_TAKE_ITEM_TX', self, 'ROKAS27_QB_6_1/1', 'ROKAS27_QB_6/-100', "Quest")
                        end
                    end
                end
                --SCR_PARTY_QUESTPROP_ADD(self, 'SSN_ROKAS27_QB_6', 'QuestInfoValue1', 1, nil, 'ROKAS27_QB_6_1/1', 'ROKAS27_QB_6/-100')
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_aMuKeosDo_BalKyeonHaJi_Mos_HaessSeupNiDa."), 3);
            end

        end
    end
end

function SCR_USE_REMAIN38_STONESLATE2(self,argObj,BuffName,arg1,arg2)
    local itemType = GetClass("Item", 'REMAIN38_STONESLATE2').ClassID;
    local itemResult = GetInvItemCountByType(self, itemType)
    if itemResult >= 4 then
--        print(itemResult, "AAAAAAAAAAAAAAAAAAAAAAAAAAA")
        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_REMAIN38_MQ03', 'QuestInfoValue1', 1, nil, 'REMAIN38_GRAVESTONE/1')
        RunScript('TAKE_ITEM_TX', self, 'REMAIN38_STONESLATE2', 4, "Quest")
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("Auto_LiDia_SyaPenui_BiSeog_JoKagi_MajChwossSeupNiDa."), 3);
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_BiSeog_JoKagi_BuJogHapNiDa."), 3);
    end
end

function SET_MISSION_WARP_STONE(mon)
	mon.Enter = "None";
	mon.Dialog = "MISSION_WARP";
end

function SCR_LOBBY_WARP_DIALOG(self, tgt)
	local stoneGUID = GetExProp_Str(self, "STONE_ITEM_GUID");
	local stoneItem = GetPCItemByGuid(tgt, stoneGUID);
	if nil ~= stoneItem then
		SetExProp(stoneItem, "IsAwaken", 0);
	end

	local itemGuid = GetExProp_Str(self, "ITEM_GUID");
	local invItem = GetPCItemByGuid(tgt, itemGuid);
	if nil ~= invItem then
		ExecClientScp(tgt, "SET_LOCK_ITEM_AWEKING()");
	end

	SendAddOnMsg(tgt, "DUNGON_EXIT");
end

function SCR_MISSION_WARP_DIALOG(self, tgt)
	if 1 == IsZombie(self) then
		return;
	end

	local ownerCID = GetExProp_Str(self, "OwnerCID");
	local tgtCID = GetPcCIDStr(tgt);

	if ownerCID ~= tgtCID then
		local partyID = GetExProp_Str(self, "PARTY_ID");
		local tgtPartyID = GetPartyID(tgt);
		if "0" == partyID or "0" == tgtPartyID  then
			SendSysMsg(tgt, "NotBelongsToParty");
			return
		end

		if partyID ~= GetPartyID(tgt) then
			return;
		end
	end

	local etc = GetETCObject(tgt);
	local abilityLevl = GetExProp(self, "ABIL_LEVEL"); 
	if nil ~= etc and abilityLevl > 0 and abilityLevl ~= etc.Alchemist_Ability then
		local tx = TxBegin(tgt);
		TxSetIESProp(tx, etc, "Alchemist_Ability", abilityLevl);
		local ret = TxCommit(tx);
		if ret ~= "SUCCESS" then
			SendSysMsg(tgt, "DataError");
			return;
		end
	end

	local missionID = GetExProp(self, "MISSION_GUID");
	local targetCID = GetExProp_Str(self, "TargetCID");
	if ownerCID == tgtCID or (targetCID ~= 'None' and targetCID == tgtCID) then
		if IsRunningScript(tgt, 'MOVE_ITEM_AWAKENING') ~= 1 then
			ReqMoveToMission(tgt, missionID);
		end
		return;
	end

	local maxCount = GetExProp(self, "MISSION_MAX_COUNT");
	local currentEnterCount = GetExProp(self, "MISSION_ENTER_COUNT");

	if maxCount <= 0 then
		SetZombie(self);
		return;
	end
	if currentEnterCount >= maxCount then
		SendSysMsg(tgt, "MissionRoomFullCont");
		SetZombie(self);
		return;
	end 
	currentEnterCount = currentEnterCount + 1;
	SetExProp(self, "MISSION_ENTER_COUNT", currentEnterCount);
	ReqMoveToMission(tgt, missionID);
	if currentEnterCount >= maxCount then
		SetZombie(self);
		return;
	end
end

function SCR_USE_ITEM_MissionWarp(self, argObj, missionName, arg1, arg2)

	local missionID = OpenMissionRoom(self, missionName, "");
	if missionID == 0 then
		return;
	end

	local x, y, z = GetPos(self);
    local mon = CREATE_MONSTER_EX(self, 'npc_hiddennpc02', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, SET_MISSION_WARP_STONE);
	AttachEffect(mon, 'F_circle25', 1, 'TOP')
    SetLifeTime(mon, 60)

	SetExProp_Str(mon, "WARP_MISSION", missionName);
	SetExProp(mon, "MISSION_GUID", missionID);

end



function SCR_USE_ITEM_WARP_KLAIPE(self)
    MoveZone(self, 'c_Klaipe', -179, 150, 72);
end


function SCR_USE_ITEM_WARP_ORSHA(self)
    MoveZone(self, 'c_orsha', 145, 177, 278);
end


function SCR_USE_ITEM_WARP_FEDIMIAN(self)
    MoveZone(self, 'c_fedimian', -243, 161, -303);
end


function SCR_USE_ITEM_ADD_MEDAL(pc, argObj, argStr, arg1, arg2)
    PlayEffect(pc, 'F_sys_TPBOX_open', 2.5, 1, "BOT", 1);
    local tx = TxBegin(pc);
	local aobj = GetAccountObj(pc);
	TxAddIESProp(tx, aobj, "PremiumMedal", 1, "NxpBox");
	local ret = TxCommit(tx);

	if ret == 'SUCCESS' then
	end
end


function SCR_USE_ITEM_ADD_TP(pc, argObj, argStr, arg1, arg2)

    if arg1 < 31 then
        PlayEffect(pc, 'F_sys_TPBOX_normal_30', 2.5, 1, "BOT", 1);
    elseif arg1 < 101 then
        PlayEffect(pc, 'F_sys_TPBOX_normal_100', 2.5, 1, "BOT", 1);
    elseif arg1 < 201 then
        PlayEffect(pc, 'F_sys_TPBOX_great_200', 2.5, 1, "BOT", 1);
    else
        PlayEffect(pc, 'F_sys_TPBOX_great_300', 2.5, 1, "BOT", 1);
    end
    
    local tx = TxBegin(pc);
	local aobj = GetAccountObj(pc);
	TxAddIESProp(tx, aobj, "PremiumMedal", arg1, "NxpBox");
	local ret = TxCommit(tx);

	if ret == 'SUCCESS' then
	end
end


function SCR_USE_ITEM_ADD_GIFTTP(pc, argObj, argStr, arg1, arg2)

    if arg1 < 31 then
        PlayEffect(pc, 'F_sys_TPBOX_normal_30', 2.5, 1, "BOT", 1);
    elseif arg1 < 101 then
        PlayEffect(pc, 'F_sys_TPBOX_normal_100', 2.5, 1, "BOT", 1);
    elseif arg1 < 201 then
        PlayEffect(pc, 'F_sys_TPBOX_great_200', 2.5, 1, "BOT", 1);
    else
        PlayEffect(pc, 'F_sys_TPBOX_great_300', 2.5, 1, "BOT", 1);
    end
    
    local tx = TxBegin(pc);
	local aobj = GetAccountObj(pc);
	TxAddIESProp(tx, aobj, "GiftMedal", arg1, "NxpBox");
	local ret = TxCommit(tx);

	if ret == 'SUCCESS' then
	end
end

function SCR_USE_ITEM_EXPCARD(self, argObj, argStr, arg1, arg2)
--    local earningRate = GetEarningRate(self)
--    local exp = arg1 * earningRate;

    local exp = arg1;
    
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);

--	local seasonServer = IS_SEASON_SERVER(self)
--
--	if seasonServer == "YES" then
--		if self.Lv >= 280 then
--			SendSysMsg(self, "SeasonServerNotEatCardLv280");
--			return 0;
--		end	
--	end
    
    local tx = TxBegin(self);
	TxGiveExp(tx, exp, "ExpCard");
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		local jexp = math.floor(exp * 0.77);
		GiveJobExp(self, jexp, "ExpCard");
		UserExpCardMongoLog(self, exp, jexp, "ExpCard");
	end
end

function SCR_USE_ITEM_Drug_CooltimeDown(self,argObj,BuffName,arg1,arg2)

	AddBuff(self, self, BuffName, arg1, 0, 600000, 1);

end

function SCR_USE_ITEM_crystal_Poison(self)
    AddBuff(self, self, 'CMINE8_ANTIPOISON', 110, 0, 600000, 1)
end

function SCR_USE_ITEM_crystal_dust(self)
    local list, cnt = SelectObjectByFaction(self, 100, 'Neutral')
    PlayEffect(self, 'I_spread_out002_mint', 3)
    sleep(1000)
    for i = 1, cnt do
        if list[i].ClassName == 'FD_bubbe_chaser_hidden' then
            PlayEffect(list[i], 'I_light013_spark_blue', 2)
            ObjectColorBlend(list[i], 255, 255, 255, 255, 1)
        	RunSimpleAI(list[i], "ATK_COMMON")
            SetCurrentFaction(list[i], 'Monster')
        end
    end
end

function DRUG_REPAIR(pc)
    local tx = TxBegin(pc);
    local equipSlot = {'RH', 'LH', 'GLOVES', 'BOOTS', 'PANTS', 'SHIRT', 'NECK', 'RING1', 'RING2'};

    for i = 1, #equipSlot do
        local item = GetEquipItemIgnoreDur(pc, equipSlot[i]);
        if item ~= nil and item.Dur < item.MaxDur then
            local repairAmount = item.MaxDur;
            TxSetIESProp(tx, item, 'Dur', repairAmount);
        end
    end
    
    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" then
            if invItemList[i].Dur < invItemList[i].MaxDur then
                local repairAmount = invItemList[i].MaxDur;
                TxSetIESProp(tx, invItemList[i], 'Dur', repairAmount);
            end
        end
    end
    
    local ret = TxCommit(tx);
end

function GIVE_REWARD_PARTYQUEST(pc)
    local rank = 0;
    local list;
    if pc.Lv >= 170 then
        rank = 6;
        list = {'SWD02_127', 'TSW02_121', 'STF02_122', 'TSF02_123', 'TBW02_125', 'BOW02_120', 'MAC02_123', 'SPR02_117', 'TSP02_113', 'PST02_101'}
    elseif pc.Lv >= 120 then
        rank = 5;
        list = {"SWD02_125", "TSW02_119", "STF02_120", "TSF02_121", "TBW02_123", "BOW02_118", "MAC02_121", "SPR02_115", "TSP02_111"}
    elseif pc.Lv >= 75 then
        rank = 4;
        list = {"SWD02_123", "TSW02_117", "STF02_118", "TSF02_118", "TBW02_121", "BOW02_116", "MAC02_119", "SPR02_113", "TSP02_109"}
    elseif pc.Lv >= 40 then
        rank = 3;
        list = {"SWD02_121", "TSW02_115", "STF02_116", "TSF02_116", "TBW02_119", "BOW02_114", "MAC02_117", "SPR02_111"}
    else
        rank = 2;
        list = {"SWD02_120", "TSW02_114", "STF02_115", "TSF02_115", "TBW02_118", "BOW02_113", "MAC02_116"}
    end
    
    local result = IMCRandom(1, 100);
    local itemClsName = "None";
    local itemCnt = 1;
    if result < 0 then
        local cardNum = rank + 1;
        itemClsName = "expCard"..cardNum;
        itemCnt = 3;
    elseif result < 0 then
        local i = IMCRandom(1, #list);
        itemClsName = list[i];
    else
        itemClsName = "Vis"
        moneyMax = pc.Lv * rank * 25;
        moneyMin = moneyMax * 0.9;
        itemCnt = IMCRandom(moneyMin, moneyMax);
		SendSysMsg(pc, "{How}GetSilver", 0, "How", itemCnt);
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, itemClsName, itemCnt, "Quest");
    local ret = TxCommit(tx);

end

function ACHIEVE_CBT3_RANK6_1(pc)
   AddAchievePoint(pc, "PlayCBT3_RANK6_1", 1); 
end

function ACHIEVE_CBT3_RANK6_10(pc)
   AddAchievePoint(pc, "PlayCBT3_RANK6_10", 1); 
end


function ACHIEVE_PLAYCBT1(pc)
   AddAchievePoint(pc, "PlayCBT1", 1); 
end


function SCR_USE_ITEM_Scroll_SkillReset_CBT(self,argObj,BuffName,arg1,arg2)

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end
	
	TxResetSkill(tx, 0, 0)


	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

end

function SCR_USE_ITEM_Scroll_StatReset_CBT(self,argObj,BuffName,arg1,arg2)

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end
	
	TxResetStat(tx)

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end
	InvalidateStates(self);
	ReserveAddOnMsg(self, "RESET_STAT_UP", "", 0);
	local pcPoint = GET_STAT_POINT(self);
	StatPointMongoLog(self, "Init", pcPoint, "STR", 0, PRE_STR, self.STR);
	StatPointMongoLog(self, "Init", pcPoint, "CON", 0, PRE_CON, self.CON);
	StatPointMongoLog(self, "Init", pcPoint, "INT", 0, PRE_INT, self.INT);
	StatPointMongoLog(self, "Init", pcPoint, "MNA", 0, PRE_MNA, self.MNA);
	StatPointMongoLog(self, "Init", pcPoint, "DEX", 0, PRE_DEX, self.DEX);


end
function ACHIEVE_IAMDEVELOPER(pc)
   AddAchievePoint(pc, "IamDeveloper", 1); 
end

function ACHIEVE_IAMGOLDHAND01(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'GoldHand01', 1)
    local ret = TxCommit(tx);
end

function ACHIEVE_GEOGRAPHER(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'GeographerEvent', 1)
    local ret = TxCommit(tx);
end

function ACHIEVE_TEAMBATTLE_STEAM(self, argObj, BuffName, arg1, arg2)
    local battleAchi = {'TeamBattle_Swordman', 'TeamBattle_Wizard', 'TeamBattle_Archer', 'TeamBattle_Cleric'}
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, battleAchi[arg1], 1)
    local ret = TxCommit(tx);
end

function ACHIEVE_CREATIVESOUL(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'CreativeSoul_Ev', 1)
    local ret = TxCommit(tx);
end

function SCR_ITEM_PAPERBOX(self, argObj, BuffName, arg1, arg2)
	local buff = GetBuffByName(self, 'SitRest');

	if buff ~= nil then
		RemoveBuff(self, "SitRest")
	end

    PlaySharedAnim(self, 'POSE', 'BOX_IN');
end

function SCR_USE_SUMMONORB_FRIEND(self, argObj, monClsName, arg1, arg2)
	local iesObj = CreateGCIES('Monster', monClsName);
	if iesObj ~= nil then
	    iesObj.Lv = iesObj.Level;
	    iesObj.Faction = 'Summon';
		local x, y, z = GetPos(self);
		local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);

		SetOwner(iesObj, self, 0);
		SetHookMsgOwner(iesObj, self);
		SetLifeTime(mon, 180);
		RunSimpleAI(iesObj, 'alche_summon');
	end
end

function SCR_USE_SUMMONORB_ENEMY(self, argObj, monClsName, arg1, arg2)
	local iesObj = CreateGCIES('Monster', monClsName);
	if iesObj ~= nil then
	    iesObj.Lv = iesObj.Level;
		local x, y, z = GetPos(self);
		local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);

		SetLifeTime(mon, 180);
		RunSimpleAI(iesObj, 'alche_summon');
	end
end

function SCR_USE_GACHA(self, argObj, rewardGroupClsName, arg1, arg2)
    GIVE_REWARD(self, rewardGroupClsName, 'SCR_USE_GACHA')
end


function SCR_USE_ADDDPARTS(self, argObj, argstring, arg1, arg2)

    local totalCount = 300;
    
	local abil = GetAbility(self, 'Necromancer21')
	if abil ~= nil then
	    totalCount = totalCount + abil.Level * 100
	end
	
	local etc = GetETCObject(self);
	if etc == nil then
		return 0;
	end

	local curPartsCnt = 0;
	local addParts = arg1;
	
	for i = 1, addParts do
	    curPartsCnt = etc.Necro_DeadPartsCnt;
	    
	    if curPartsCnt >= totalCount then
    		return 0;
    	end
    	
    	curPartsCnt = curPartsCnt + 1;
    
    	etc["NecroDParts_"..curPartsCnt] = 400981;
    	etc.Necro_DeadPartsCnt = etc.Necro_DeadPartsCnt + 1;
	end
	
	SendProperty(self, etc);
	SendAddOnMsg(self, "UPDATE_NECRONOMICON_UI");
end

function SCR_USE_ITEM_EXP_LV200(self, argObj, argStr, arg1, arg2)
    local exp = arg1;
    
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local tx = TxBegin(self);
	TxGiveExp(tx, exp);
	local ret = TxCommit(tx);
end

function SCR_USE_ITEM_JEXP_MAX(self, argObj, argStr, arg1, arg2)
--local exp = arg1;
--local jexp = math.floor(exp);
--GiveJobExp(self, jexp);
	while true do
		jlvup(self, 15)
		local lv, total = GetJobLevelByName(self, self.JobName);
		if lv == 15 then
			break;
		end
		sleep(100)
	end
end

function SCR_RESTORE_LAST_JOB_EXP(self, argObj, argStr, arg1, arg2)
    local etc = GetETCObject(self);
    local lastJobExpStr = TryGetProp(etc, 'LastJobExp');
    if lastJobExpStr == nil or lastJobExpStr == 'None' then
        return false;
    end

    local tx = TxBegin(self);
    TxSetIESProp(tx, etc, 'LastRank', 0); -- ??�쾲 ?????�㈃ ??�씤 ?뺣낫?? ?뱀????�슜??吏 紐⑤????�덇�?뷀�?�?��.
    TxSetIESProp(tx, etc, 'LastJobExp', 'None');
    if GiveHugeJobExp(self, lastJobExpStr, 'RankReset_Restore') == 0 then
        TxRollBack(tx);
        return false;
    end
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        return false;
    end

    return true;
end

function SCR_USE_ITEM_HAIRCOLOR(self, argObj, argStr, arg1, arg2, itemID)
	local etc = GetETCObject(self);
	local item = GetInvItemByType(self, itemID);
	local itemClassName = TryGetProp(item, 'ClassName');
	local etcColor = "HairColor_"..argStr;
	
	if etc[etcColor] == 1 then
		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("HairColorExist"), 2);
		return false;
	end
	
    local tx = TxBegin(self);
	SET_ALLOW_HAIRCOLOR(tx, etc, argStr);
	local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then
        SendAddOnMsg(self, 'HAIR_COLOR_CHANGE', itemClassName, 100);
	end
end

function GIVE_MIC_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Mic', 10, 'TPSHOP_MIC_50');
    local ret = TxCommit(tx);
end

function GIVE_MIC_50(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Mic', 50, 'TPSHOP_MIC_50');
    local ret = TxCommit(tx);
end

function GIVE_SOULCRISTAL_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'RestartCristal', 10, 'TPSHOP_SOULCRISTAL_10');
    local ret = TxCommit(tx);
end

function GIVE_WARPSCROLL_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_WarpScroll', 10, 'TPSHOP_WARPSCROLL_10');
    local ret = TxCommit(tx);
end

function PREMIUM_PACKAGEOBT_1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_600', 1, 'Premium_PackageOBT_1');
    TxGiveItem(tx, 'Drug_Premium_HP1', 50, 'Premium_PackageOBT_1');
    TxGiveItem(tx, 'Drug_Premium_SP1', 50, 'Premium_PackageOBT_1');
    TxGiveItem(tx, 'Premium_WarpScroll_bundle10', 1, 'Premium_PackageOBT_1');
    TxGiveItem(tx, 'Mic_bundle50', 1, 'Premium_PackageOBT_1');
    TxGiveItem(tx, 'Hat_629001', 1, 'Premium_PackageOBT_1');
    local ret = TxCommit(tx);
end

function PREMIUM_PACKAGEOBT_2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_1300', 1, 'Premium_PackageOBT_2');
    TxGiveItem(tx, 'Drug_Premium_HP1', 150, 'Premium_PackageOBT_2');
    TxGiveItem(tx, 'Drug_Premium_SP1', 150, 'Premium_PackageOBT_2');
    TxGiveItem(tx, 'Premium_WarpScroll_bundle10', 3, 'Premium_PackageOBT_2');
    TxGiveItem(tx, 'Mic_bundle50', 1, 'Premium_PackageOBT_2');
    TxGiveItem(tx, 'Hat_629002', 1, 'Premium_PackageOBT_2');
    local ret = TxCommit(tx);
end

function SCR_USE_GIMMICK_TRANSFORM_RANDOM(self, argObj, argstring, arg1, arg2)
    
    local list = {'Jukopus_Transfrom', 'Popolion_Blue_Transfrom', 'ferret_folk_Transfrom', 'Tiny_Transfrom', 'Npanto_baby_Transfrom', 'Honeybean_Transfrom', 'Onion_Transfrom', 'Jukopus_Transfrom'};
    local i = IMCRandom(1, 8);
    local mon = list[i];

    TransformToMonster(self, mon, 'GIMMICK_TRANFORM_BUFF')
	PlayEffect(self, 'F_smoke037', 0.5, 'MID')
	AddBuff(self, self, 'GIMMICK_TRANSFORM_BUFF', 1, 1, 3600000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GIMMICK_TRANSFORM_MSG"), 3)
end


function PREMIUM_REPAIR(pc, argObj, argstring, arg1, arg2)
    local tx = TxBegin(pc);
    local equipSlot = {'RH', 'LH', 'GLOVES', 'BOOTS', 'PANTS', 'SHIRT', 'NECK', 'RING1', 'RING2'};
    
    for i = 1, #equipSlot do
        local item = GetEquipItemIgnoreDur(pc, equipSlot[i]);
        if item ~= nil and item.Dur < item.MaxDur then
            local repairAmount = item.Dur + arg1;
            
            if repairAmount > item.MaxDur then
                repairAmount = item.MaxDur;
            end
            
            TxSetIESProp(tx, item, 'Dur', repairAmount);
        end
    end
    
    local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendAddOnMsg(pc, "UPDATE_ITEM_REPAIR");
	end
end


function SCR_USE_ITEM_ADD_CHAT_EMOTICON(pc, argObj, argStr, arg1, arg2)

	local emoCls = GetClass('chat_emoticons', argStr);
	if emoCls ~= ni then
		local tx = TxBegin(pc);
		local etc = GetETCObject(pc);
		TxAddIESProp(tx, etc, "HaveEmoticon_" .. emoCls.ClassID, 1);
		local ret = TxCommit(tx);
		
		if ret == 'SUCCESS' then
			SendAddOnMsg(pc, "ADD_CHAT_EMOTICON");
		end
	end
end

function SCR_USE_ITEM_ADD_CHAT_EMOTICON_PACK(pc, argObj, argStr, arg1, arg2)
    
    local emoCls = ''
    local etc = GetETCObject(pc);

	if etc == nil then
	    return
	end
	
	local tx = TxBegin(pc);
	
	if etc["HaveEmoticon_"..arg1] >= 1 then
	    SendAddOnMsg(pc, 'NOTICE_Dm_!',ScpArgMsg("Premium_Emoticon_Desc1"), 3);
	    return
	end
	
	for i = arg1, arg2 do
    	emoCls = GetClass('chat_emoticons', argStr..i);
        
        if emoCls ~= ni then
    	    TxAddIESProp(tx, etc, "HaveEmoticon_" .. emoCls.ClassID, 1);
    	end
	end
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
		SendAddOnMsg(pc, "ADD_CHAT_EMOTICON");
	end
end

function GIVE_ENCHANTSCROLL_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'TPSHOP_ENCHANTSCROLL_20');
    local ret = TxCommit(tx);
end

function GIVE_ENCHANTSCROLL_20(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip', 20, 'TPSHOP_ENCHANTSCROLL_20');
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_BREAD884(pc)
	local iesObj = CreateGCIES('Monster', 'HighBube_Archer_test');
	if iesObj ~= nil then
	    iesObj.Lv = iesObj.Level;
		local x, y, z = GetPos(pc);
		local mon = CreateMonster(pc, iesObj, x, y, z, 0, 0);

		SetHookMsgOwner(iesObj, pc);
		SetLifeTime(mon, 60);
	end
end

function SCR_USE_ITEM_STRANGEPOTION(pc)
	local iesObj = CreateGCIES('Monster', 'HighBube_Archer_ghost');
	if iesObj ~= nil then
	    iesObj.Lv = iesObj.Level;
		local x, y, z = GetPos(pc);
		local mon = CreateMonster(pc, iesObj, x, y, z, 0, 0);

		SetHookMsgOwner(iesObj, pc);
		SetLifeTime(mon, 60);
	end
end

function PREMIUM_PACKAGE_50DAY(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_tpBox_500', 1, 'Premium_eventTpBox_150');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'Premium_eventTpBox_150');
	    TxGiveItem(tx, 'Hat_629004', 1, 'Premium_eventTpBox_150');
	    TxGiveItem(tx, 'Premium_eventTpBox_150', 1, 'Premium_eventTpBox_150');
	    local ret = TxCommit(tx);
	end

function SCR_USE_EVENT_MONEYBOX(self, argObj, argStr, arg1, arg2)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local money = 1;
    local max = arg1;
    
    local result = IMCRandom(1, 100);
    
    if result < 2 then
        money = IMCRandom(max * 0.8, max);
    elseif result < 5 then
        money = IMCRandom(max * 0.6, max * 0.8);
    elseif result < 10 then
        money = IMCRandom(max * 0.4, max * 0.6);
    elseif result < 28 then
        money = IMCRandom(max * 0.2, max * 0.4);
    else
        money = IMCRandom(max * 0.1, max * 0.2);
    end
    
    local tx = TxBegin(self);
	TxGiveItem(tx, 'Vis', math.floor(money), 'EVENT_MONEYBOX');
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('EVENT_MONEYBOX_MSG1'), ScpArgMsg('REWARD_SILVER_GET','COUNT',math.floor(money)))
	end
end

function SCR_USE_EVENT_MONEYBOX02(self, argObj, argStr, arg1, arg2)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local money = 1;
    local moneyset = arg1;
    
    local result = IMCRandom(1, 10000);
    
    if result < 5 then
        money = moneyset * 1000;
    elseif result < 25 then
        money = moneyset * 500;
    elseif result < 600 then
        money = moneyset * 100;
    elseif result < 2100 then
        money = moneyset * 50;
    elseif result < 4500 then
        money = moneyset * 30;
    elseif result < 7000 then
        money = moneyset * 10;
    elseif result < 9000 then
        money = moneyset * 5;
    else
        money = moneyset * 1;
    end
    
    local tx = TxBegin(self);
	TxGiveItem(tx, 'Vis', math.floor(money), 'EVENT_MONEYBOX');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('EVENT_MONEYBOX_MSG1'), ScpArgMsg('REWARD_SILVER_GET','COUNT',math.floor(money)))
	    if money >= 5000000 then
	        ToAll(ScpArgMsg("DAYCHECK_EVENT_SILVER_GET_ALLMSG","PC",GetTeamName(self),"COUNT", money))
	    end
	end
end

function SCR_USE_EVENT_MONEYBOX03(self, argObj, argStr, arg1, arg2)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local money = 1;
    local moneyset = arg1;
    
    local result = IMCRandom(1, 10000);
    
    if result < 3 then
        money = moneyset * 1000;
    elseif result < 13 then
        money = moneyset * 500;
    elseif result < 88 then
        money = moneyset * 100;
    elseif result < 163 then
        money = moneyset * 50;
    elseif result < 450 then
        money = moneyset * 30;
    elseif result < 3500 then
        money = moneyset * 10;
    elseif result < 7000 then
        money = moneyset * 5;
    else
        money = moneyset * 1;
    end
    
    local tx = TxBegin(self);
	TxGiveItem(tx, 'Vis', math.floor(money), 'EVENT_MONEYBOX');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('EVENT_MONEYBOX_MSG1'), ScpArgMsg('REWARD_SILVER_GET','COUNT',math.floor(money)))
	    if money >= 5000000 then
	        ToAll(ScpArgMsg("DAYCHECK_EVENT_SILVER_GET_ALLMSG","PC",GetTeamName(self),"COUNT", money))
	    end
	end
end

function SCR_USE_EVENT_MONEYBOX04(self, argObj, argStr, arg1, arg2)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local money = 1;
    local moneyset = arg1;
    
    local result = IMCRandom(1, 10000);
    
    if result < 3 then
        money = moneyset * 1000;
    elseif result < 11 then
        money = moneyset * 500;
    elseif result < 161 then
        money = moneyset * 100;
    elseif result < 1660 then
        money = moneyset * 10;
    elseif result < 5000 then
        money = moneyset * 5;
    elseif result < 7500 then
        money = moneyset * 1;
    elseif result < 9000 then
        money = moneyset / 2;
    else
        money = moneyset / 10;
    end
    
    local tx = TxBegin(self);
	TxGiveItem(tx, 'Vis', math.floor(money), 'EV170427_DAYCHECK_TYPE1');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('EVENT_MONEYBOX_MSG1'), ScpArgMsg('REWARD_SILVER_GET','COUNT',math.floor(money)))
	    if money >= 5000000 then
	        ToAll(ScpArgMsg("DAYCHECK_EVENT_SILVER_GET_ALLMSG","PC",GetTeamName(self),"COUNT", money))
	    end
	end
end


function SCR_USE_EVENT_SUPPORTBOX1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'expCard3', 30, 'Event_160215_supportBox1');
    TxGiveItem(tx, 'RestartCristal', 5, 'Event_160215_supportBox1');
    TxGiveItem(tx, 'Event_drug_160218', 10, 'Event_160215_supportBox1');
    TxGiveItem(tx, 'Event_supportBox2', 1, 'Event_160215_supportBox1');
    local ret = TxCommit(tx);
	
	if ret == "SUCCESS" then	
		local sucScp = string.format("PLAY_SOUND_EVENT(\'%s\')", "sys_tp_box_2");
		ExecClientScp(pc, sucScp);
	end
end

function SCR_USE_EVENT_SUPPORTBOX2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'expCard5', 20, 'Event_160215_supportBox2');
    TxGiveItem(tx, 'Event_drug_160218', 10, 'Event_160215_supportBox2');
    TxGiveItem(tx, 'Premium_boostToken', 3, 'Event_160215_supportBox2');
    TxGiveItem(tx, 'Event_supportBox3', 1, 'Event_160215_supportBox2');
    local ret = TxCommit(tx);
	if ret == "SUCCESS" then	
		local sucScp = string.format("PLAY_SOUND_EVENT(\'%s\')", "sys_tp_box_2");
		ExecClientScp(pc, sucScp);
	end
end

function SCR_USE_EVENT_SUPPORTBOX3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'expCard5', 35, 'Event_160215_supportBox3');
    TxGiveItem(tx, 'Premium_indunReset', 5, 'Event_160215_supportBox3');
    TxGiveItem(tx, 'Event_drug_160218', 10, 'Event_160215_supportBox3');
    TxGiveItem(tx, 'Event_supportBox4', 1, 'Event_160215_supportBox3');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_SUPPORTBOX4(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'expCard7', 40, 'Event_160215_supportBox4');
    TxGiveItem(tx, 'Premium_Enchantchip', 5, 'Event_160215_supportBox4');
    TxGiveItem(tx, 'Premium_SkillReset', 1, 'Event_160215_supportBox4');
    TxGiveItem(tx, 'Event_supportBox5', 1, 'Event_160215_supportBox4');
    local ret = TxCommit(tx);
	if ret == "SUCCESS" then	
		local sucScp = string.format("PLAY_SOUND_EVENT(\'%s\')", "sys_tp_box_2");
		ExecClientScp(pc, sucScp);
	end
end

function SCR_USE_EVENT_SUPPORTBOX5(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'expCard7', 40, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'Premium_eventTpBox_50', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'Mic', 40, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'PremiumToken_15d', 1, 'Event_160215_supportBox5');
    
    TxGiveItem(tx, 'SWD02_141', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'TSW02_137', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'SPR02_133', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'TSP02_128', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'STF02_136', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'TSF02_136', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'TBW02_139', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'BOW02_135', 1, 'Event_160215_supportBox5');
    TxGiveItem(tx, 'MAC02_138', 1, 'Event_160215_supportBox5');
    local ret = TxCommit(tx);
	if ret == "SUCCESS" then	
		local sucScp = string.format("PLAY_SOUND_EVENT(\'%s\')", "sys_tp_box_2");
		ExecClientScp(pc, sucScp);
	end
end

function PREMIUM_PACKAGE_100DAY(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_tpBox_100', 1, 'Premium_Package_100day');
	    TxGiveItem(tx, 'Premium_tpBox_100', 1, 'Premium_Package_100day');
	    TxGiveItem(tx, 'Artefact_630018', 1, 'Premium_Package_100day');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PREMIUM_GoldPack(pc)
		local tx = TxBegin(pc);
		TxGiveItem(tx, 'steam_Premium_tpBox_198', 1, 'Premium_Package_GoldPack');
		TxGiveItem(tx, 'steam_Premium_boostToken', 10, 'Premium_Package_GoldPack');
		local ret = TxCommit(tx);
	end
function SCR_USE_PREMIUM_SilverPack(pc)
		local tx = TxBegin(pc);
	    TxGiveItem(tx, 'steam_Premium_tpBox_165', 1, 'Premium_Package_SilverPack');
	    TxGiveItem(tx, 'steam_Premium_boostToken', 5, 'Premium_Package_SilverPack');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PREMIUM_RAIMA(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'PremiumToken_1d', 1, 'Premium_Raima');
	    TxGiveItem(tx, 'Premium_boostToken', 3, 'Premium_Raima');
	    TxGiveItem(tx, 'Drug_Premium_HP1', 100, 'Premium_Raima');
	    TxGiveItem(tx, 'Drug_Premium_SP1', 100, 'Premium_Raima');
	    TxGiveItem(tx, 'Premium_repairPotion', 3, 'Premium_Raima');
	    TxGiveItem(tx, 'Premium_WarpScroll', 10, 'Premium_Raima');
	    TxGiveItem(tx, 'RestartCristal', 5, 'Premium_Raima');
	    TxGiveItem(tx, 'Premium_indunReset', 1, 'Premium_Raima');
	    TxGiveItem(tx, 'Mic', 10, 'Premium_Raima');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PREMIUM_PENGUIN(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'PremiumToken', 1, 'Premium_Penguin');
	    TxGiveItem(tx, 'egg_006', 1, 'Premium_Penguin');
	    TxGiveItem(tx, 'food_penguin', 15, 'Premium_Penguin');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PREMIUM_PENGUIN_FOOD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'food_penguin', 5, 'Premium_Penguin_Food');
    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_TRUMPWARM(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_m_007', 1, 'Package_Trumpwarm');
	    TxGiveItem(tx, 'Hat_628136', 1, 'Package_Trumpwarm');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpwarm');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPWARF(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_f_007', 1, 'Package_Trumpwarf');
	    TxGiveItem(tx, 'Hat_628136', 1, 'Package_Trumpwarf');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpwarf');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPWIZM(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_wiz_m_007', 1, 'Package_Trumpwizm');
	    TxGiveItem(tx, 'Hat_628137', 1, 'Package_Trumpwizm');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpwizm');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPWIZF(pc)
		local tx = TxBegin(pc);
		TxGiveItem(tx, 'costume_wiz_f_007', 1, 'Package_Trumpwizf');
		TxGiveItem(tx, 'Hat_628138', 1, 'Package_Trumpwizf');
		TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpwizf');
		local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPARCM(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_m_008', 1, 'Package_Trumparcm');
	    TxGiveItem(tx, 'Hat_628140', 1, 'Package_Trumparcm');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumparcm');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPARCF(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_f_008', 1, 'Package_Trumparcf');
	    TxGiveItem(tx, 'Hat_628140', 1, 'Package_Trumparcf');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumparcf');
	    local ret = TxCommit(tx);
	end

function SCR_USE_PACKAGE_TRUMPCLEM(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_m_007', 1, 'Package_Trumpclem');
	    TxGiveItem(tx, 'Hat_628139', 1, 'Package_Trumpclem');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpclem');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_TRUMPCLEF(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_f_007', 1, 'Package_Trumpclef');
	    TxGiveItem(tx, 'Hat_628139', 1, 'Package_Trumpclef');
	    TxGiveItem(tx, 'Premium_Enchantchip', 40, 'Package_Trumpclef');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_JEMINA(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'NECK99_101', 1, 'Package_Jemina');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTGEM1(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, 'Package_Eventgem1');
	    TxGiveItem(tx, 'gem_square_1', 1, 'Package_Eventgem1');
	    TxGiveItem(tx, 'gem_diamond_1', 1, 'Package_Eventgem1');
   	    TxGiveItem(tx, 'gem_star_1', 1, 'Package_Eventgem1');
   	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest1', 1, 'Package_Eventgem1');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTGEM2(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, 'Package_Eventgem2');
	    TxGiveItem(tx, 'gem_square_1', 1, 'Package_Eventgem2');
	    TxGiveItem(tx, 'gem_diamond_1', 1, 'Package_Eventgem2');
   	    TxGiveItem(tx, 'gem_star_1', 1, 'Package_Eventgem2');
   	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest2', 1, 'Package_Eventgem2');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTGEM3(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, 'Package_Eventgem3');
	    TxGiveItem(tx, 'gem_square_1', 1, 'Package_Eventgem3');
	    TxGiveItem(tx, 'gem_diamond_1', 1, 'Package_Eventgem3');
   	    TxGiveItem(tx, 'gem_star_1', 1, 'Package_Eventgem3');
   	    TxGiveItem(tx, 'misc_gemExpStone01', 1, 'Package_Eventgem3');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTGEM4(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, 'Package_Eventgem4');
	    TxGiveItem(tx, 'gem_square_1', 1, 'Package_Eventgem4');
	    TxGiveItem(tx, 'gem_diamond_1', 1, 'Package_Eventgem4');
   	    TxGiveItem(tx, 'gem_star_1', 1, 'Package_Eventgem4');
   	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, 'Package_Eventgem4');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTGEM5(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, 'Package_Eventgem5');
	    TxGiveItem(tx, 'gem_square_1', 1, 'Package_Eventgem5');
	    TxGiveItem(tx, 'gem_diamond_1', 1, 'Package_Eventgem5');
   	    TxGiveItem(tx, 'gem_star_1', 1, 'Package_Eventgem5');
   	    TxGiveItem(tx, 'misc_gemExpStone04', 1, 'Package_Eventgem5');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTPOTIONBOX1(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_HP1', 5, 'Package_EventPotionbox1');
	    TxGiveItem(tx, 'GIMMICK_Drug_SP1', 5, 'Package_EventPotionbox1');
	    TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 5, 'Package_EventPotionbox1');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTPOTIONBOX2(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_HP2', 5, 'Package_EventPotionbox2');
	    TxGiveItem(tx, 'GIMMICK_Drug_SP2', 5, 'Package_EventPotionbox2');
	    TxGiveItem(tx, 'GIMMICK_Drug_HPSP2', 5, 'Package_EventPotionbox2');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_EVENTPOTIONBOX3(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_HP3', 5, 'Package_EventPotionbox3');
	    TxGiveItem(tx, 'GIMMICK_Drug_SP3', 5, 'Package_EventPotionbox3');
	    TxGiveItem(tx, 'GIMMICK_Drug_HPSP3', 5, 'Package_EventPotionbox3');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_LORD(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'BRC99_101', 1, 'Package_Lord');
	    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_KNIGHT(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'BRC99_102', 1, 'Package_Knight');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT01(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event01');
	    TxGiveItem(tx, 'Drug_Premium_SP1', 100, '160714event01');
	    TxGiveItem(tx, 'Drug_Premium_HP1', 100, '160714event01');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT02(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event02');
	    TxGiveItem(tx, 'Premium_WarpScroll', 5, '160714event02');
	    TxGiveItem(tx, 'RestartCristal', 3, '160714event02');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT03(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event03');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 5, '160714event03');
	    TxGiveItem(tx, 'Premium_repairPotion', 5, '160714event03');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT04(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 2, '160714event04');
	    TxGiveItem(tx, 'Mic', 10, '160714event04');
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event04');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT05(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event05');
	    TxGiveItem(tx, 'Moru_Silver', 1, '160714event05');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT06(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_PMATK1', 30, '160714event06');
	    TxGiveItem(tx, 'GIMMICK_Drug_PMDEF1', 30, '160714event06');
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event06');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT07(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, '160714event07');
	    TxGiveItem(tx, 'gem_square_1', 1, '160714event07');
	    TxGiveItem(tx, 'gem_diamond_1', 1, '160714event07');
	    TxGiveItem(tx, 'gem_star_1', 1, '160714event07');
	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, '160714event07');
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event07');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT08(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event08');
	    TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 100, '160714event08');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT09(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event09');
	    TxGiveItem(tx, 'Premium_eventTpBox_30_2', 1, '160714event09');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT10(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_StatReset14', 1, '160714event10');
	    TxGiveItem(tx, 'Premium_Enchantchip', 3, '160714event10');
	    TxGiveItem(tx, 'Hat_628142', 1, '160714event10');
	    TxGiveItem(tx, '160714Event_box0', 1, '160714event10');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT11(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event11');
	    TxGiveItem(tx, 'Drug_Premium_SP1', 100, '160714event11');
	    TxGiveItem(tx, 'Drug_Premium_HP1', 100, '160714event11');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT12(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event12');
	    TxGiveItem(tx, 'Premium_WarpScroll', 5, '160714event12');
	    TxGiveItem(tx, 'RestartCristal', 3, '160714event12');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT13(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event13');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 5, '160714event13');
	    TxGiveItem(tx, 'Premium_repairPotion', 5, '160714event13');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT14(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 2, '160714event14');
	    TxGiveItem(tx, 'Mic', 10, '160714event14');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event14');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT15(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160714_2', 1, '160714event15');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event15');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT16(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_PMATK1', 30, '160714event16');
	    TxGiveItem(tx, 'GIMMICK_Drug_PMDEF1', 30, '160714event16');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event16');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT17(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, '160714event17');
	    TxGiveItem(tx, 'gem_square_1', 1, '160714event17');
	    TxGiveItem(tx, 'gem_diamond_1', 1, '160714event17');
	    TxGiveItem(tx, 'gem_star_1', 1, '160714event17');
	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, '160714event17');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event17');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT18(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_awakeningStone14', 2, '160714event18');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event18');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT19(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event19');
	    TxGiveItem(tx, 'Premium_eventTpBox_30_2', 1, '160714event19');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT20(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160714_poporion', 1, '160714event20');
	    TxGiveItem(tx, 'Premium_Enchantchip', 3, '160714event20');
	    TxGiveItem(tx, 'Hat_628096', 1, '160714event20');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event20');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT21(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event21');
	    TxGiveItem(tx, 'Drug_Premium_SP1', 100, '160714event21');
	    TxGiveItem(tx, 'Drug_Premium_HP1', 100, '160714event21');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT22(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event22');
	    TxGiveItem(tx, 'Premium_WarpScroll', 5, '160714event22');
	    TxGiveItem(tx, 'RestartCristal', 3, '160714event22');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT23(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event23');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 5, '160714event23');
	    TxGiveItem(tx, 'Premium_repairPotion', 5, '160714event23');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT24(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 2, '160714event24');
	    TxGiveItem(tx, 'Mic', 10, '160724event24');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event24');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT25(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160714_1', 1, '160714event25');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event25');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT26(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'GIMMICK_Drug_PMATK1', 30, '160714event26');
	    TxGiveItem(tx, 'GIMMICK_Drug_PMDEF1', 30, '160714event26');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event26');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT27(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'gem_circle_1', 1, '160714event27');
	    TxGiveItem(tx, 'gem_square_1', 1, '160714event27');
	    TxGiveItem(tx, 'gem_diamond_1', 1, '160714event27');
	    TxGiveItem(tx, 'gem_star_1', 1, '160714event27');
	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, '160714event27');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event27');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT28(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'NECK99_102', 1, '160714event28');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event28');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT29(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event29');
	    TxGiveItem(tx, 'Premium_eventTpBox_30_2', 1, '160714event29');
	    local ret = TxCommit(tx);
end

function SCR_USE_160714EVENT30(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160714_poporion', 1, '160714event30');
	    TxGiveItem(tx, 'Premium_Enchantchip', 3, '160714event30');
	    TxGiveItem(tx, 'Hat_628143', 1, '160714event30');
	    TxGiveItem(tx, '160714Event_box00', 1, '160714event30');
	    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_WEAPONBOX01(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'E_SWD01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_TSW01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_STF01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_TBW01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_MAC01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_BOW01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_TSF01_101', 1, 'event_weaponbox01');
	    TxGiveItem(tx, 'E_SPR01_101', 1, 'event_weaponbox01');
	    local ret = TxCommit(tx);
end

-- made up
function SCR_USE_PROMOTION_SET01_COMPANION(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'egg_009', 1, 'promotion_set01');
	    TxGiveItem(tx, 'food_cereal', 30, 'promotion_set01');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET02(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Hat_628132', 1, 'promotion_set02');
	    TxGiveItem(tx, 'Hat_628133', 1, 'promotion_set02');
	    TxGiveItem(tx, 'Hat_628013', 1, 'promotion_set02');
	    TxGiveItem(tx, 'Premium_Enchantchip', 5, 'promotion_set02');
	    TxGiveItem(tx, 'PremiumToken_1d', 1, 'promotion_set02');
	    TxGiveItem(tx, 'Premium_boostToken', 10, 'promotion_set02');
	    TxGiveItem(tx, 'Mic', 10, 'promotion_set02');
	    TxGiveItem(tx, 'Drug_Premium_HP1', 30, 'promotion_set02');
	    TxGiveItem(tx, 'Drug_Premium_SP1', 30, 'promotion_set02');
	    TxGiveItem(tx, 'RestartCristal', 3, 'promotion_set02');
	    TxGiveItem(tx, 'Premium_WarpScroll', 5, 'promotion_set02');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET03(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_m_010', 1, 'promotion_set03');
	    TxGiveItem(tx, 'Hat_628144', 1, 'promotion_set03');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set03');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET04(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_f_010', 1, 'promotion_set04');
	    TxGiveItem(tx, 'Hat_628145', 1, 'promotion_set04');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set04');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET05(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_wiz_m_010', 1, 'promotion_set05');
	    TxGiveItem(tx, 'Hat_628146', 1, 'promotion_set05');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set05');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET06(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_wiz_f_010', 1, 'promotion_set06');
	    TxGiveItem(tx, 'Hat_628147', 1, 'promotion_set06');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set06');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET07(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_m_011', 1, 'promotion_set07');
	    TxGiveItem(tx, 'Hat_628148', 1, 'promotion_set07');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set07');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET08(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_f_011', 1, 'promotion_set08');
	    TxGiveItem(tx, 'Hat_628149', 1, 'promotion_set08');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set08');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET09(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_m_011', 1, 'promotion_set09');
	    TxGiveItem(tx, 'Hat_628150', 1, 'promotion_set09');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set09');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET10(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_f_011', 1, 'promotion_set10');
	    TxGiveItem(tx, 'Hat_628151', 1, 'promotion_set10');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set10');
	    local ret = TxCommit(tx);
end

function SCR_USE_PREMIUM_PARROTBILL_FOOD(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'food_cereal', 5, 'Premium_parrotbill_Food');
    local ret = TxCommit(tx);
end

function ACHIEVE_STORYTELLER(pc)
   AddAchievePoint(pc, "100daysEvent", 1); 
end

function SCR_USE_BUNNYPACK_2016(pc)
    local costume = { 'costume_wiz_m_009', 'costume_wiz_f_009' }
    
    local job = GetClassString('Job', pc.JobName, 'CtrlType')
    local i = 0
    
    if job == 'Wizard' then
        local tx = TxBegin(pc);
        TxGiveItem(tx, costume[pc.Gender], 1, 'SWIMSUITPACK_2016');
        TxGiveItem(tx, 'Hat_628141', 1, 'SWIMSUITPACK_2016');
        TxGiveItem(tx, 'Premium_Enchantchip', 10, 'SWIMSUITPACK_2016');
        local ret = TxCommit(tx);
        if ret ~= "SUCCESS" then
            return;
        end
    else
        SendSysMsg(pc, "BUNNYPACK_FAIL");
    end
end

function SCR_USE_SWIMSUITPACK_2016(pc)
    local job = GetClassString('Job', pc.JobName, 'CtrlType')
    local jobList = { 'Warrior', 'Wizard', 'Archer', 'Cleric' }
    local i, j, jobNum = 0, 0, 0
    
    for j = 1, table.getn(jobList) do
        if job == jobList[j] then
            jobNum = j
            break
        end
    end
    
    local costume = {
        { 'costume_war_m_010', 'costume_war_f_010' },
        { 'costume_wiz_m_010', 'costume_wiz_f_010' },
        { 'costume_arc_m_011', 'costume_arc_f_011' },
        { 'costume_clr_m_011', 'costume_clr_f_011' }
    }
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, costume[jobNum][pc.Gender], 1, 'SWIMSUITPACK_2016');
    TxGiveItem(tx, 'SummerHair_2016', 1, 'SWIMSUITPACK_2016');
    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'SWIMSUITPACK_2016');
    local ret = TxCommit(tx);
    if ret ~= "SUCCESS" then
        SendSysMsg(pc, "DataError");
        return;
    end
end

function SCR_USE_PROMOTION_SET11(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_m_011', 1, 'promotion_set11');
	    TxGiveItem(tx, 'Hat_628152', 1, 'promotion_set11');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set11');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET12(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_war_f_011', 1, 'promotion_set12');
	    TxGiveItem(tx, 'Hat_628153', 1, 'promotion_set12');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set12');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET13(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_wiz_m_011', 1, 'promotion_set13');
	    TxGiveItem(tx, 'Hat_628154', 1, 'promotion_set13');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set13');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET14(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_wiz_f_011', 1, 'promotion_set14');
	    TxGiveItem(tx, 'Hat_628155', 1, 'promotion_set14');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set14');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET15(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_m_012', 1, 'promotion_set15');
	    TxGiveItem(tx, 'Hat_628156', 1, 'promotion_set15');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set15');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET16(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_arc_f_012', 1, 'promotion_set16');
	    TxGiveItem(tx, 'Hat_628157', 1, 'promotion_set16');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set16');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET17(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_m_012', 1, 'promotion_set17');
	    TxGiveItem(tx, 'Hat_628158', 1, 'promotion_set17');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set17');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_SET18(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_clr_f_012', 1, 'promotion_set18');
	    TxGiveItem(tx, 'Hat_628159', 1, 'promotion_set18');
	    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'promotion_set18');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_HANGAWUI1D(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160908_7', 2, 'promotion_hangawui1d');
	    TxGiveItem(tx, 'Premium_boostToken03', 1, 'promotion_hangawui1d');
	    TxGiveItem(tx, 'Premium_Enchantchip_CT', 1, 'promotion_hangawui1d');
	    TxGiveItem(tx, 'Premium_indunReset', 1, 'promotion_hangawui1d');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_HANGAWUI2D(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160908_7', 6, 'promotion_hangawui2d');
	    TxGiveItem(tx, 'Premium_boostToken03', 3, 'promotion_hangawui2d');
	    TxGiveItem(tx, 'Premium_Enchantchip_CT', 3, 'promotion_hangawui2d');
	    TxGiveItem(tx, 'Premium_indunReset', 3, 'promotion_hangawui2d');
	    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, 'promotion_hangawui2d');
	    local ret = TxCommit(tx);
end

function SCR_USE_PROMOTION_HANGAWUI3D(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Event_160908_7', 30, 'promotion_hangawui3d');
	    TxGiveItem(tx, 'Premium_boostToken03', 10, 'promotion_hangawui3d');
	    TxGiveItem(tx, 'Premium_Enchantchip_CT', 10, 'promotion_hangawui3d');
	    TxGiveItem(tx, 'Premium_indunReset', 10, 'promotion_hangawui3d');
	    TxGiveItem(tx, 'misc_gemExpStone09', 1, 'promotion_hangawui3d');
	    TxGiveItem(tx, 'Moru_Silver_NoDay', 3, 'promotion_hangawui3d');
	    local ret = TxCommit(tx);
end

function SCR_USE_MAINTERNANCEREWARD1(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 1, 'mainternancereward1');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'mainternancereward1');
	    local ret = TxCommit(tx);
end

function SCR_USE_MAINTERNANCEREWARD2(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 1, 'mainternancereward2');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 5, 'mainternancereward2');
	    TxGiveItem(tx, 'Premium_eventTpBox_1000', 1, 'mainternancereward2');
	    local ret = TxCommit(tx);
end

function SCR_USE_MAINTERNANCEREWARD3(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'Premium_indunReset_14d', 1, 'mainternancereward3');
	    TxGiveItem(tx, 'Premium_boostToken_14d', 3, 'mainternancereward3');
	    TxGiveItem(tx, 'Premium_eventTpBox_200', 1, 'mainternancereward3');
	    local ret = TxCommit(tx);
end

function SCR_USE_MAINTERNANCEREWARD4(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'PremiumToken_1d', 1, 'mainternancereward4');
	    TxGiveItem(tx, 'Premium_eventTpBox_300', 1, 'mainternancereward4');
	    local ret = TxCommit(tx);
end

function SCR_USE_MAINTERNANCEREWARD5(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'RestartCristal', 3, 'mainternancereward5');
	    TxGiveItem(tx, 'Premium_WarpScroll', 3, 'mainternancereward5');
	    TxGiveItem(tx, 'Premium_eventTpBox_20', 1, 'mainternancereward5');
	    local ret = TxCommit(tx);
end

function SCR_USE_MIRACLEBOX01(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_ore15', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP4', 20, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'misc_ore05', 20, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_MIRACLEBOX02(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Gacha_G_012', 1, 'Miracle_box_02');
    TxGiveItem(tx, 'misc_ore05', 1, 'Miracle_box_02');
    local ret = TxCommit(tx);
end

function SCR_USE_161027PUMPKINPROMOTION01(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_100', 1, 'PumpkinPromotion_01');
    TxGiveItem(tx, 'Premium_eventTpBox_5', 1, 'PumpkinPromotion_01');
    TxGiveItem(tx, 'Event_161025_poporion', 1, 'PumpkinPromotion_01');
    local ret = TxCommit(tx);
end

function SCR_USE_161027PUMPKINPROMOTION02(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_220', 1, 'PumpkinPromotion_02');
    TxGiveItem(tx, 'Premium_eventTpBox_20', 1, 'PumpkinPromotion_02');
    TxGiveItem(tx, 'Event_161025_poporion', 2, 'PumpkinPromotion_02');
    local ret = TxCommit(tx);
end

function SCR_USE_161027PUMPKINPROMOTION03(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_360', 1, 'PumpkinPromotion_03');
    TxGiveItem(tx, 'Premium_eventTpBox_60', 1, 'PumpkinPromotion_03');
    TxGiveItem(tx, 'Event_161025_poporion', 3, 'PumpkinPromotion_03');
    local ret = TxCommit(tx);
end

function SCR_USE_161027PUMPKINPROMOTION04(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_500', 1, 'PumpkinPromotion_04');
    TxGiveItem(tx, 'Premium_eventTpBox_150_2', 1, 'PumpkinPromotion_04');
    TxGiveItem(tx, 'Event_161025_poporion', 5, 'PumpkinPromotion_04');
    local ret = TxCommit(tx);
end



function SCR_USE_TESTPACK(pc)
    local tx = TxBegin(pc);
TxGiveItem(tx, 'Hat_628125', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628260', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628180', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628192', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628207', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628239', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628246', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628256', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628261', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628206', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628231', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628219', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628214', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628226', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628230', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628258', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628208', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628210', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628211', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628213', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628216', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628181', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628182', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628248', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628074', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628098', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628127', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628128', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628101', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628108', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628113', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628120', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628129', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628189', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628203', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628227', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628241', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628082', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628110', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628115', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628106', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628190', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628233', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628240', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628245', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628247', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628197', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628229', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628250', 1, 'TESTPACK1');
TxGiveItem(tx, 'Hat_628202', 1, 'TESTPACK1');
    local ret = TxCommit(tx);
end

function SCR_USE_SUMMERHAIR_2016(pc)
    local select = ShowSelDlg(pc, 0, 'SUMMERHAIR_2016_SEL', 
    ScpArgMsg("SUMMERHAIR1"), ScpArgMsg("SUMMERHAIR2"), ScpArgMsg("SUMMERHAIR3"), ScpArgMsg("SUMMERHAIR4"), ScpArgMsg("SUMMERHAIR5"), 
    ScpArgMsg("SUMMERHAIR6"), ScpArgMsg("SUMMERHAIR7"), ScpArgMsg("SUMMERHAIR8"), ScpArgMsg("Cancel"))
    local summerhair = { 
        'Hat_628144', 'Hat_628145', 'Hat_628146', 'Hat_628147', 'Hat_628148', 'Hat_628149', 'Hat_628150', 'Hat_628151'
    }
    
    if select == 9 or select == nil then
        return
    else
        local tx = TxBegin(pc);
        TxGiveItem(tx, summerhair[select], 1, 'SUMMERHAIR_2016');
        local ret = TxCommit(tx);
        if ret ~= "SUCCESS" then
            SendSysMsg(pc, "DataError");
            return;
        end
    end
end

function SCR_USE_EXPBOX(pc)
    local expcard = {
        'expCard2', 'expCard3', 'expCard5', 'expCard6', 'expCard7', 'expCard8', 'expCard9', 'expCard10', 'expCard11', 'expCard6', 'expCard7', 'expCard8', 'expCard9', 'expCard10', 'expCard11'
    }
    
    local tx = TxBegin(pc);
    for i = 1, 3 do
        local rand = IMCRandom(1, table.getn(expcard))
        TxGiveItem(tx, expcard[rand], 1, 'SCR_USE_EXPBOX');
    end
    local ret = TxCommit(tx);
end

function SCR_USE_RECIPE_WEP(pc)
    local r_weapon = {
        {'R_SWD03_110', 10},
        {'R_TSW03_111', 20},
        {'R_STF03_108', 25},
        {'R_TBW03_109', 30},
        {'R_BOW03_109', 35},
        {'R_BOW03_110', 45},
        {'R_MAC03_110', 55},
        {'R_SPR03_104', 60},
        {'R_TSP03_106', 70},
        {'R_TSP04_109', 80},
        {'R_TSF03_109', 85},
        {'R_RAP03_102', 95},
        {'R_MUS03_101',100},
    }
    
    local rand = IMCRandom(1, 100)
    local result = 0
    
    for i = 1, table.getn(r_weapon) do
        if r_weapon[i][2] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_weapon[result][1], 1, 'SCR_USE_RECIPE_WEP');
    local ret = TxCommit(tx);
end

function SCR_USE_RECIPE_ARM(pc)
    local r_armor = {
        'TOP04_104','TOP03_116','TOP03_115','TOP03_114','TOP03_113','TOP03_112','TOP03_111', -- ??¨몄밿        'LEG03_116','LEG03_115','LEG03_114','LEG03_113','LEG03_112','LEG03_111', -- ??륁벥
        'HAND03_116','HAND03_115','HAND03_114','HAND03_113','HAND03_112','HAND03_111', -- ?觀??
        'FOOT03_116','FOOT03_115','FOOT03_114','FOOT03_113','FOOT03_112','FOOT03_111', -- ??????   
        }
    
    local rand = IMCRandom(1, table.getn(r_armor))
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_armor[rand], 1, 'SCR_USE_RECIPE_ARM');
    local ret = TxCommit(tx);
end

function SCR_USE_RECIPE_ACC(pc)
    local r_acc = {
        {'R_NECK03_106', 15},
        {'R_NECK04_105', 60},
        {'R_BRC03_108',  80},
        {'R_BRC04_103', 100 },
    }
    
    local rand = IMCRandom(1, 100)
    local result = 0
    
    for i = 1, table.getn(r_acc) do
        if r_acc[i][2] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_acc[result][1], 1, 'SCR_USE_RECIPE_ACC');
    local ret = TxCommit(tx);
end

function SCR_USE_MONCARD_BOX(pc)
    local moncard = {
        {'card_honeypin',      5},
        {'card_Minotaurs',    16},
        {'card_NetherBovine', 27},
        {'card_Deathweaver',  38},
        {'card_Flammidus',    49},
        {'card_Moldyhorn',    60},
        {'card_poata',        70},
        {'card_mineloader',   80},
        {'card_necrovanter',  90},
        {'card_ShadowGaoler', 100},
    }
    
    local rand = IMCRandom(1, 100)
    local result = 0
    
    for i = 1, table.getn(moncard) do
        if moncard[i][2] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, moncard[result][1], 1, 'SCR_USE_MONCARD_BOX');
    local ret = TxCommit(tx);
end

function SCR_SEND_NOTIFY_REWARD(pc, eventName, rewardName)
	local msg = eventName .. ";" .. rewardName;
	SendAddOnMsg(pc, "EVENT_REWARD_NOTIFY_ITEM_GET", msg);
end

function SCR_SEND_NOTIFY_REWARD_TABLE(pc, titleName, itemTable)
	local msg =''
    for i = 1, #itemTable do
        if msg == '' then
            msg = ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemTable[i][1],'Name'),'COUNT', itemTable[i][2])
        else
            msg = msg..', '..ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemTable[i][1],'Name'),'COUNT', itemTable[i][2])
        end
    end
    SCR_SEND_NOTIFY_REWARD(pc, titleName, msg)
end

function SCR_USE_EVENT_THANKSGIVINGDAY(pc)
    local CurMapID = GetMapID(pc);
    local result = 0;
    local ymin = 0

    local mapID = {2300, 2301, 3730, 3750}
    
    for i = 0, table.getn(mapID) do
        if CurMapID == mapID[i] then
            result = 1
            break;
        end
    end
    
    if result == 1 then
        local x, y, z = GetFrontPos(pc, 30);
    	--CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog)
    	local grass = CREATE_NPC(pc, 'siauliai_grass_1_blue', x, y, z, 0, "Summon", GetLayer(pc), GetName(pc), 'MON_THANKSGIVINGDAY_EV', nil, nil, 1, nil, 'MON_THANKSGIVINGDAY_EV')
    	if grass == nil then
    		return 1;
    	else
    	    local now_time = os.date('*t')
            local yday = now_time['yday']
            local hour = now_time['hour']
            local min = now_time['min']
            
            ymin = (yday * 24 * 60) + hour * 60 + min
    	    grass.NumArg1 = ymin
    	    grass.StrArg1 = GetName(pc);
    	end
    else
        AddBuff(pc, pc, 'Event_ThanksgivingDay', 1, 0, 0, 1);
    end
end

function SCR_USE_PREMIUM_RAIMA_2017(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PremiumToken_1d', 1, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Drug_Premium_HP1', 100, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Drug_Premium_SP1', 100, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Premium_WarpScroll', 10, 'Premium_Raima_2017');
    TxGiveItem(tx, 'RestartCristal', 5, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Mic', 10, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Premium_indunReset_14d', 5, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Premium_boostToken02_event01', 1, 'Premium_Raima_2017');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'Premium_Raima_2017');
    local ret = TxCommit(tx);
end
function SCR_USE_CS_IndunReset_GTower_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_400 > 0 then
                local tx = TxBegin(self);
                TxSetIESProp(tx, pcetc, 'InDunCountType_400', pcetc.InDunCountType_400 - 1)
                local ret = TxCommit(tx);
                if ret == 'SUCCESS' then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_IndunReset_GTower_1_MSG1"), 10)
                end
            end
        end
    end
end


function SCR_USE_CS_IndunReset_Nunnery_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunRewardCountType_300 > 0 then
                local setValue = pcetc.InDunRewardCountType_300 - 1
                local tx = TxBegin(self);
                TxSetIESProp(tx, pcetc, 'InDunRewardCountType_300', setValue)
                TxSetIESProp(tx, pcetc, 'InDunCountType_300', setValue)
                local ret = TxCommit(tx);
                if ret == 'SUCCESS' then
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_IndunReset_Nunnery_1_MSG1"), 10)
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_IndunReset_GTower_1_MSG4"), 10)
            end
        end
    end
end

function SCR_USE_PREMIUM_ROCKSODON(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_tpBox_650', 1, 'PREMIUM_ROCKSODON');
    TxGiveItem(tx, 'egg_010', 1, 'PREMIUM_ROCKSODON');
    local ret = TxCommit(tx);
end

function ACHIEVE_GIFTEDARTIST(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'TheGiftedArtist', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_Surstromming(self)
    Heal(self, 5000, 0);
    AddBuff(self, self, 'Stun', 0, 0, 3000, 0)
end

function ACHIEVE_EV_LUCK(self,argObj,BuffName,arg1,arg2)
    local list = {'EV_Luck1', 'EV_Luck2', 'EV_Luck3', 'EV_Luck4'}
    
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, list[arg1], 1)
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_AddBuff_Item(self,argObj,BuffName,arg1,arg2)
--    local list = {
--        {10, 'PremiumToken_1d', 1},
--        {20, 'Event_drug_steam', 10},
--        {30, 'card_Xpupkit01_event', 1},
--        {40, 'misc_gemExpStone_randomQuest4_14d', 1},
--        {50, 'Moru_Silver', 1},
--        {60, 'Hat_628290', 1}
--    }
    
    local aObj = GetAccountObj(self);
    local result = 0;

    if IsBuffApplied(self, 'Premium_Fortunecookie_1') == 'YES' then
        BuffName = 'Premium_Fortunecookie_2'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_2') == 'YES' then
        BuffName = 'Premium_Fortunecookie_3'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_3') == 'YES' then
        BuffName = 'Premium_Fortunecookie_4'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_4') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_5') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    else
        BuffName = 'Premium_Fortunecookie_1'
    end

	AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	
	--EVENT_PROPERTY_RESET(self, aObj, sObj)

--	for i = 1, table.getn(list) do
--        if aObj.PlayTimeEventRewardCount + 1 == list[i][1] then
--            result = i
--            break;
--end
--end
--
--	local tx = TxBegin(self);
--    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Fortune' then
--        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 1);
--        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "Fortune");
--    else
--        TxAddIESProp(tx, aObj, 'PlayTimeEventRewardCount', 1);
--        end
--    if result ~= 0 then
--        TxGiveItem(tx, list[result][2], list[result][3], 'Fortune');
--    end
--    local ret = TxCommit(tx);
--    if ret == 'SUCCESS' then
--        AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
--        local msg = ScpArgMsg("Fortunecookie_Count","COUNT", aObj.PlayTimeEventRewardCount)
--        SendAddOnMsg(self, "NOTICE_Dm_scroll",msg, 10)
--    end
end


function SCR_USE_PACKAGE_Hanbok_M(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_Com_5', 1, 'Promotion_Set_Hanbok_M');
	    TxGiveItem(tx, 'Hat_628293', 1, 'Promotion_Set_Hanbok_M');
	    TxGiveItem(tx, 'Event_170119_2', 30, 'Promotion_Set_Hanbok_M');
	    local ret = TxCommit(tx);
end
function SCR_USE_PACKAGE_Hanbok_F(pc)
	    local tx = TxBegin(pc);
	    TxGiveItem(tx, 'costume_Com_6', 1, 'Promotion_Set_Hanbok_F');
	    TxGiveItem(tx, 'Hat_628294', 1, 'Promotion_Set_Hanbok_F');
	    TxGiveItem(tx, 'Event_170119_2', 30, 'Promotion_Set_Hanbok_F');
	    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_VALENTINE_2017(self,argObj,BuffName,arg1,arg2)
    local aObj = GetAccountObj(self);
    local result = 0;

    if IsBuffApplied(self, 'Premium_Fortunecookie_1') == 'YES' then
        BuffName = 'Premium_Fortunecookie_2'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_2') == 'YES' then
        BuffName = 'Premium_Fortunecookie_3'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_3') == 'YES' then
        BuffName = 'Premium_Fortunecookie_4'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_4') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_5') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    else
        BuffName = 'Premium_Fortunecookie_1'
    end
    
	local tx = TxBegin(self);
    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'Fortune' then
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 1);
        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "Fortune");
    else
        TxAddIESProp(tx, aObj, 'PlayTimeEventRewardCount', 1);
    end
--    if result ~= 0 then
--        TxGiveItem(tx, list[result][2], list[result][3], 'Fortune');
--    end
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
        local msg = ScpArgMsg("Fortunecookie_Count","COUNT", aObj.PlayTimeEventRewardCount)
        SendAddOnMsg(self, "NOTICE_Dm_scroll",msg, 10)
    end
end

function ACHIEVE_VALENTINE2017(pc,argObj,BuffName,arg1,arg2)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Valentine2017_'..arg1, 1)
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_EVENTCOSTUME7D(pc)
    local job = GetClassString('Job', pc.JobName, 'CtrlType')
    local jobList = { 'Warrior', 'Wizard', 'Archer', 'Cleric' }
    local i, j, jobNum = 0, 0, 0
    
    for j = 1, table.getn(jobList) do
        if job == jobList[j] then
            jobNum = j
            break
        end
    end
    
    local costume = {
        { 'costume_war_m_003', 'costume_war_f_003' },
        { 'costume_wiz_m_002', 'costume_wiz_f_002' },
        { 'costume_arc_m_003', 'costume_arc_f_003' },
        { 'costume_clr_m_003', 'costume_clr_f_003' }
    }
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, costume[jobNum][pc.Gender], 1, 'EVENTCOSTUME7D');
    local ret = TxCommit(tx);
    if ret ~= "SUCCESS" then
        SendSysMsg(pc, "DataError");
        return;
    end
end

function SCR_USE_ITEM_RANDOMNUMBER(pc)
    local rand = IMCRandom(1, 10)
    ShowEmoticon(pc, 'I_emo_damagerank'..rand, 5000);
end

function SCR_USE_SUMMONORB_ENEMY_EVENT(self)
	RunScript("SCR_MON_INFO_INPUT", self)
end

function SCR_MON_INFO_INPUT(self)
    local monClsID = ShowTextInputDlg(self, 0, 'EVENT_CREATEMON_DESC1')
    local MonLv = ShowTextInputDlg(self, 1, 'EVENT_CREATEMON_DESC2')
    local MonMHP = ShowTextInputDlg(self, 2, 'EVENT_CREATEMON_DESC3')
    local scale = 1
    monClsID = tonumber(monClsID)
    
    local monClsName = GetClassString('Monster', monClsID, 'ClassName')
    local iesObj = CreateGCIES('Monster', monClsName);

    MonLv = tonumber(MonLv)
    MonMHP = tonumber(MonMHP)

    if (MonLv < 1 or MonLv > 500) or (MonMHP < 1 or MonMHP > 100) then -- fail
        return
    end

    if iesObj ~= nil then
	    iesObj.Lv = MonLv;
		local x, y, z = GetPos(self);
		local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
		
		mon.MHP_BM =  mon.MHP_BM + ((mon.MHP * MonMHP) - mon.MHP)
		mon.DropItemList = 'None'
		
		if mon.MonRank == 'Normal' then
		    scale = 2
		elseif mon.MonRank == 'Elite' then
		    Elite = 1.5
		end
		
		ChangeScale(mon, 1.5, 0)
		InvalidateStates(mon);
		AddHP(mon, mon.MHP)
		SetLifeTime(mon, 600);
		RunSimpleAI(iesObj, 'RedOrb_Buff_Dead');
	end
end

function SCR_USE_MONSTERGEM_BOX(pc)
    local r_gem = {
        {'Gem_Swordman_GungHo', 40},--swordman
        {'Gem_Swordman_PainBarrier', 25},
        {'Gem_Swordman_Bash', 25},
        {'Gem_Swordman_Concentrate', 65},
        {'Gem_Swordman_Thrust', 20},
        {'Gem_Swordman_PommelBeat', 40},
        {'Gem_Swordman_Restrain', 30},
        {'Gem_Swordman_DoubleSlash', 20},
        {'Gem_Wizard_EnergyBolt', 35},--wizard
        {'Gem_Wizard_EarthQuake', 45},
        {'Gem_Wizard_Lethargy', 35},
        {'Gem_Wizard_ReflectShield', 40},
        {'Gem_Wizard_Sleep',55},
        {'Gem_Wizard_Surespell',30},
        {'Gem_Wizard_MagicMissile',5},
        {'Gem_Archer_Multishot',40},--archer
        {'Gem_Archer_ObliqueShot',45},
        {'Gem_Archer_SwiftStep',45},
        {'Gem_Archer_Fulldraw',65},
        {'Gem_Archer_HeavyShot',40},
        {'Gem_Archer_Kneelingshot',5},
        {'Gem_Archer_TwinArrows',5},
        {'Gem_Cleric_Cure',65},--cleric
        {'Gem_Cleric_DeprotectedZone',40},
        {'Gem_Cleric_Heal',40},
        {'Gem_Cleric_SafetyZone',50},
        {'Gem_Cleric_DivineMight',40},
        {'Gem_Cleric_Fade',5},
        {'Gem_Cleric_PatronSaint',5},
        }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_gem) do
        sum = sum + r_gem[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_gem) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[result][1], 1, 'SCR_USE_MONSTERGEM_BOX');
    local ret = TxCommit(tx);
end

function SCR_USE_BASEITEM_BOX(pc)
    local r_item = {
        {'misc_ore10', 20},
        {'misc_ore11', 30},
        {'misc_ore12', 40},
        {'misc_ore05', 40},
        {'misc_Rambear', 60},
        {'misc_mushroom_ent', 60},
        {'misc_0172', 60},
        {'misc_velffigy', 60},
        {'misc_0181', 60},
        {'misc_0157', 60},
        {'misc_glyquare', 60},
        {'misc_0179', 70},
        {'misc_Stoulet1',70},
        {'misc_0173',70},
        {'misc_0149',70},
        {'misc_Ticen',70},
        {'misc_Denden',100},
        }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'SCR_USE_BASEITEM_BOX');
    local ret = TxCommit(tx);
end

function SCR_USE_PopUpBook(self, argObj, argStr, arg1, arg2)
    local pcx, pcy, pcz = GetPos(self)
    local centerx, centery, centerz
    local zoneID = GetZoneInstID(self)
    centerx = pcx -45
    centery = pcy
    centerz = pcz +45
    
    local dialogName
    if argStr == 'photowall_christmastree01' or argStr == 'Photowall_christmas_santa' then
        dialogName = 'photowall_orgel'
    end
    local npc = CREATE_NPC(self, argStr, centerx, centery, centerz, 315, "Peaceful", GetLayer(self), nil, dialogName, nil, 1, 1, nil, 'NPC_POPUPBOOK_AI')
    if npc ~= nil then
        SetLifeTime(npc, 600)
        SetExArgObject(self, 'POPUPBOOK_NPC', npc)
        SetExArgObject(npc, 'POPUPBOOK_PC', self)
    end
end

function SCR_NPC_POPUPBOOK_AI_TS_BORN_ENTER(self)
end

function SCR_NPC_POPUPBOOK_AI_TS_BORN_UPDATE(self)
    local pc = GetExArgObject(self, 'POPUPBOOK_PC')
    if pc == nil then
        Dead(self)
    end
end

function SCR_NPC_POPUPBOOK_AI_TS_BORN_LEAVE(self)
end

function SCR_NPC_POPUPBOOK_AI_TS_DEAD_ENTER(self)
    local pc = GetExArgObject(self, 'POPUPBOOK_PC')
    if pc ~= nil then
        SetExArgObject(pc, 'POPUPBOOK_NPC', nil)
    end
    SetExArgObject(self, 'POPUPBOOK_PC', nil)
end

function SCR_NPC_POPUPBOOK_AI_TS_DEAD_UPDATE(self)
end

function SCR_NPC_POPUPBOOK_AI_TS_DEAD_LEAVE(self)
end

function SCR_PHOTOWALL_ORGEL_DIALOG(self, pc)
    local orgelNPC = GetExArgObject(self, 'ORGEL_NPC')
    if orgelNPC ~= nil then
        SetExArgObject(self, 'ORGEL_NPC', nil)
        Dead(orgelNPC)
        PlayAnim(self, 'STD', 1)
    else
        local x,y,z = GetPos(self)
        local aiName
        if self.ClassName == 'photowall_christmastree01' then
            aiName = 'NPC_POPUPBOOK_AI1'
        elseif self.ClassName == 'Photowall_christmas_santa' then
            aiName = 'NPC_POPUPBOOK_AI2'
        end
        local npc = CREATE_NPC(self, 'HiddenTrigger2',  x,y,z, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, aiName)
        if npc ~= nil then
            SetExArgObject(self, 'ORGEL_NPC', npc)
            SetExArgObject(npc, 'ORGEL_POPUPBOOK', self)
            PlayAnim(self, 'EVENT', 0)
            sleep(2000)
            PlayAnim(self, 'STD', 1)
        end
    end
end

function SCR_NPC_POPUPBOOK_AI1_TS_BORN_ENTER(self)
end

function SCR_NPC_POPUPBOOK_AI1_TS_BORN_UPDATE(self)
    local popupbook = GetExArgObject(self, 'ORGEL_POPUPBOOK')
    if popupbook == nil then
        Kill(self)
    end
end

function SCR_NPC_POPUPBOOK_AI1_TS_BORN_LEAVE(self)
end

function SCR_NPC_POPUPBOOK_AI1_TS_DEAD_ENTER(self)
end

function SCR_NPC_POPUPBOOK_AI1_TS_DEAD_UPDATE(self)
end

function SCR_NPC_POPUPBOOK_AI1_TS_DEAD_LEAVE(self)
end

function SCR_NPC_POPUPBOOK_AI2_TS_BORN_ENTER(self)
end

function SCR_NPC_POPUPBOOK_AI2_TS_BORN_UPDATE(self)
    local popupbook = GetExArgObject(self, 'ORGEL_POPUPBOOK')
    if popupbook == nil then
        Kill(self)
    end
end

function SCR_NPC_POPUPBOOK_AI2_TS_BORN_LEAVE(self)
end

function SCR_NPC_POPUPBOOK_AI2_TS_DEAD_ENTER(self)
end

function SCR_NPC_POPUPBOOK_AI2_TS_DEAD_UPDATE(self)
end

function SCR_NPC_POPUPBOOK_AI2_TS_DEAD_LEAVE(self)
end

function SCR_USE_Event_ArborDay_Costume_Box(pc)
    local costumeList1 = {'costume_war_m_018','costume_war_f_018','costume_wiz_m_020','costume_wiz_f_020','costume_arc_m_021','costume_arc_f_021','costume_clr_m_019','costume_clr_f_019'}
    local targetCostume
    for i = 1, #costumeList1 do
        local itemIES = GetClass('Item', costumeList1[i])
        local myGender
        if pc.Gender == 1 then
            myGender = 'Male'
        else
            myGender = 'Female'
	end
        if itemIES.UseGender == myGender then
            local jobType = string.sub(pc.JobName, 1 , string.find(pc.JobName, '_') - 1)
            if string.find(itemIES.UseJob, jobType) ~= nil then
                targetCostume = costumeList1[i]
    	        break
    	    end
    	end
        end
    if targetCostume ~= nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, targetCostume, 1, "Event_ArborDay_Costume_Box");
        local ret = TxCommit(tx);
	end
end

function SCR_USE_Event_1709_NewField_Box(pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1709_NEWFIELD_SEL', ScpArgMsg("OnlyMale"), ScpArgMsg("OnlyFemale"), ScpArgMsg("Cancel"))
    local itemSel
    if select == 1 then
        itemSel = 'costume_1709_NewField_m'
    elseif select == 2 then
        itemSel = 'costume_1709_NewField_f'
    end
    if itemSel ~= nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, itemSel, 1, "Event_1709_NewField");
        local ret = TxCommit(tx);
    end
end

function PREMIUM_BADUNIFORM_M_1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'costume_Com_13', 1, 'PREMIUM_BADUNIFORM_1');
    TxGiveItem(tx, 'ABAND01_122', 1, 'PREMIUM_BADUNIFORM_1');
    local ret = TxCommit(tx);
end

function PREMIUM_BADUNIFORM_F_1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'costume_Com_14', 1, 'PREMIUM_BADUNIFORM_1');
    TxGiveItem(tx, 'ABAND01_122', 1, 'PREMIUM_BADUNIFORM_1');
    local ret = TxCommit(tx);
end

function PREMIUM_BADUNIFORM_M_2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'costume_Com_11', 1, 'PREMIUM_BADUNIFORM_2');
    TxGiveItem(tx, 'ABAND01_123', 1, 'PREMIUM_BADUNIFORM_2');
    local ret = TxCommit(tx);
end

function PREMIUM_BADUNIFORM_F_2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'costume_Com_12', 1, 'PREMIUM_BADUNIFORM_2');
    TxGiveItem(tx, 'ABAND01_123', 1, 'PREMIUM_BADUNIFORM_2');
    local ret = TxCommit(tx);
end

function SCR_USE_GM_TRANSFORM_GM(self, argObj, argstring, arg1, arg2)
    RunScript("SCR_TRANSFORM_MONINFO", self)
end

function SCR_TRANSFORM_MONINFO(self)
    local monClsID = ShowTextInputDlg(self, 0, 'EVENT_CREATEMON_DESC1')
    monClsID = tonumber(monClsID)
    
    local monClsName = GetClassString('Monster', monClsID, 'ClassName')
    local iesObj = CreateGCIES('Monster', monClsName);
	
	if iesObj == nil then
	    return;
	end
	
	local select = ShowSelDlg(self, 0, 'EVENT_TRANSFORM_GM', ScpArgMsg('WCL_Npc'), ScpArgMsg('WCL_Monster'))
	
	if select == nil then
	    return;
	end
	
    if 1 == TransformToMonster(self, monClsName, 'Event_Transform_GM') then
		AddBuff(self, self, 'Event_Transform_GM', select, 0, 3600000, 1)
		--AddBuff(self, self, 'GM_BUFF_ATK', 4000, 1, 0, 1)
		AddBuff(self, self, 'GM_BUFF_DEF', 5500, 1, 0, 1)
		AddBuff(self, self, 'GM_BUFF_MHP', 450000000, 1, 0, 1)
		Heal(self, 450000000, 0);
	end
end

function SCR_USE_Wedding_Costume_Box(pc)
    local costumeList1 = {'costume_Com_26','costume_Com_23'}
    local targetCostume
    for i = 1, #costumeList1 do
        local itemIES = GetClass('Item', costumeList1[i])
        local myGender
        if pc.Gender == 1 then
            myGender = 'Male'
        else
            myGender = 'Female'
        end
        if itemIES.UseGender == myGender then
            targetCostume = costumeList1[i]
            break
        end
    end
    if targetCostume ~= nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, targetCostume, 1, "Wedding_Costume_Box");
        local ret = TxCommit(tx);
    end
end

function SCR_USE_Wedding_Costume2_Box(pc)
    local costumeList1 = {'costume_Com_25','costume_Com_24'}
    local targetCostume
    for i = 1, #costumeList1 do
        local itemIES = GetClass('Item', costumeList1[i])
        local myGender
        if pc.Gender == 1 then
            myGender = 'Male'
        else
            myGender = 'Female'
        end
        if itemIES.UseGender == myGender then
            targetCostume = costumeList1[i]
            break
        end
    end
    if targetCostume ~= nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, targetCostume, 1, "Wedding_Costume_Box");
        local ret = TxCommit(tx);
    end
end

function SCR_USE_ABILITY_STONE(pc, argObj, argStr, arg1, arg2, itemID)
    
    local item = GetInvItemByType(pc, itemID);
    local effect = TryGetProp(item,'ParticleName')
    local point = TryGetProp(pc, 'AbilityPoint')
    
     if point == 'None' then
        point = '0';
    end
    
    local addPoint = 1000;
    point = point + addPoint;
    
    local tx = TxBegin(pc);
    TxSetIESProp(tx, pc, 'AbilityPoint', point);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        if effect ~= nil and effect ~= 'None' then
            PlayEffect(pc, effect, 3, 3,'BOT')
        end
       AbilityPointMongoLog(pc, addPoint, point, 0, 'Item'); 
    end    
end

function SCR_USE_HiddenJobUnlock(self,argObj, StringArg, Numarg1, Numarg2)
    local jobNameKOR = GetClassString('Job', StringArg, 'Name')
    local select_1 = ShowSelDlg(self, 0, 'HIDDEN_JOB_UNLOCK_ITEM_DLG1\\'..ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG6','JOBNAME', jobNameKOR), ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select_1 == 1 then
        if StringArg == 'Char4_18' then
            if self.Gender ~= 2 then
                local select_2 = ShowSelDlg(self, 0, 'HIDDEN_JOB_UNLOCK_ITEM_DLG2', ScpArgMsg('Yes'), ScpArgMsg('No')) 
                if select_2 ~= 1 then
                    return
                end
            end
        end
        local result = SCR_HIDDEN_JOB_UNLOCK(self, StringArg)
        if result == 'SUCCESS' then
            if StringArg == 'Char4_18' then
                if isHideNPC(self, 'MIKO_MASTER') == 'YES' then
                    UnHideNPC(self, 'MIKO_MASTER')
                end
                if isHideNPC(self, 'MIKO_SOUL_SPIRIT') == 'YES' then
                    UnHideNPC(self, 'MIKO_SOUL_SPIRIT')
                end
            elseif StringArg == 'Char3_13' then
                if isHideNPC(self, 'FEDIMIAN_APPRAISER') == 'NO' then
                    HideNPC(self, 'FEDIMIAN_APPRAISER')
                end
                if isHideNPC(self, 'FEDIMIAN_APPRAISER_NPC') == 'YES' then
                    UnHideNPC(self, 'FEDIMIAN_APPRAISER_NPC')
                end
            elseif StringArg == 'Char2_17' then
                if isHideNPC(self, 'RUNECASTER_MASTER') == 'YES' then
                    UnHideNPC(self, 'RUNECASTER_MASTER')
                end
            elseif StringArg == 'Char1_13' then
                if isHideNPC(self, 'SHINOBI_MASTER') == 'YES' then
                    UnHideNPC(self, 'SHINOBI_MASTER')
                end
            end
            SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG4','JOBNAME', jobNameKOR), ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG5','RANK', Numarg1,'JOBNAME', jobNameKOR))
        end
    end
end

function SCR_USE_Wedding_GACHA3_Box(pc)

    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Wedding_Costume_Box2', 1, "Gacha_TP_106");
    TxGiveItem(tx, 'Gacha_TP_105', 1, "Gacha_TP_106");
    local ret = TxCommit(tx);

end

function SCR_USE_Give_Item(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, arg1, arg2, 'AbilityPointBox_'..arg1..'_'..arg1);
    local ret = TxCommit(tx);
end

function SCR_USE_Give_MagicScroll(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip', arg2, 'MagicScroll'..arg2..'_'..arg1);
    local ret = TxCommit(tx);
end

function SCR_USE_Give_BosstToken(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_boostToken', arg2, 'Premium_boostToken'..arg2..'_'..arg1);
    local ret = TxCommit(tx);
end

function SCR_USE_ABILITY_STONE_UP(pc, argObj, argStr, arg1, arg2, itemID)

    local point = TryGetProp(pc, 'AbilityPoint')
    local item = GetInvItemByType(pc, itemID);
    local effect = TryGetProp(item,'ParticleName')
     if point == 'None' then
        point = '0';
    end
    
    point = point + arg1
    
    local tx = TxBegin(pc);
    TxSetIESProp(tx, pc, 'AbilityPoint', point);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        if effect ~= nil and effect ~= 'None' then
            PlayEffect(pc, effect, 3, 3,'BOT')
        end
        AbilityPointMongoLog(pc, arg1, point, 0, 'Item');
    end    
end

function SCR_USE_RecycleMedal_Give_Item(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, arg1, arg2, 'Recycle_Box_'..arg2);
    local ret = TxCommit(tx);
end


function SCR_USE_Box_Ellixer_Give(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Drug_RedApple20', 30, 'Drung_Box_Ellixer');
    TxGiveItem(tx, 'Drug_BlueApple20', 30, 'Drung_Box_Ellixer');
    local ret = TxCommit(tx);
end

function SCR_USE_Box_BlessStone_Give(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_BlessedStone', arg2, 'BlessStone_Box_'..arg2);
    local ret = TxCommit(tx);
end

function SCR_USE_Box_TranscendStone_Give(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_item_transcendence_Stone', arg2, 'Transcendence_Stone_Box_'..arg2);
    local ret = TxCommit(tx);
end

function SCR_USE_Appraisal_Box_Piece(pc, target, string1, arg1, arg2, itemID)
--미감????�?조각 교환??�?????-- 
    local item = GetInvItemByType(pc, itemID);
    local countCheck = GetInvItemCount(pc, item.ClassName);

    local tx = TxBegin(pc);
    if countCheck >= 8 then

        TxTakeItem(tx, item.ClassName, 8, "Log_"..string1.."_8Piece_Take")
        TxGiveItem(tx, string1, 1, "Log_"..string1.."_Give");
    else

        TxTakeItem(tx, item.ClassName, 1, "Log_"..item.Name.."_1Piece_Take")
        TxGiveItem(tx, 'misc_ore22', 1, "Log_Newcle_Give");
    end

    local ret = TxCommit(tx);
end



function SCR_USE_ITEM_PLAY_SHARED_ANIM(self, argObj, argstring, arg1, arg2, itemID)
    local stance = GetCurrentStance(self);
    if stance ~= nil then
        local stanceAnim = TryGetProp(stance, "Animation");
        if stanceAnim ~= nil then
            PlaySharedAnim(self, stanceAnim, argstring);
        end
    end
end

function SCR_USE_GIVE_DUNGEONCOUNT_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_dungeoncount_01', arg1, 'Log_USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_DRUNG_BOX_ELIXER_PREMIUM(pc)
    local tx = TxBegin(pc) 
    TxGiveItem(tx, 'Premium_boostToken', 1, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'RestartCristal', 1, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Drug_RedApple20', 30, 'DRUNG_BOX_ELIXER_PREMIUM');
    TxGiveItem(tx, 'Drug_BlueApple20', 30, 'DRUNG_BOX_ELIXER_PREMIUM');
    local ret = TxCommit(tx)
end

function SCR_USE_ITEM_PLAY_SELECT_ANIM(self, argObj, argstring, arg1, arg2, itemID)
--argstring : anim_Stance;animName --
    local string_cut = SCR_STRING_CUT_SEMICOLON(argstring)
    
    local stance = GetCurrentStance(self);
    if stance ~= nil then
        local stanceAnim = TryGetProp(stance, "Animation");
        if stanceAnim ~= nil then
            PlaySharedAnim(self, string_cut[1], string_cut[2]);
        end
    end
end

function SCR_USE_GIVE_VACANCE_CUBE_SET(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc) 
       TxGiveItem(tx, string1 , 1, "LOG_USE"..item.ClassName)
       TxGiveItem(tx, 'Gacha_TP_111', 3, "LOG_USE"..item.ClassName)
    local ret = TxCommit(tx)
end

function DLC_BOX11(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_RankReset', 1, 'DLC_BOX11');
    TxGiveItem(tx, 'Premium_StatReset', 1, 'DLC_BOX11');
    TxGiveItem(tx, 'Event_Goddess_Statue_DLC', 5, 'DLC_BOX11');
    TxGiveItem(tx, 'Event_drug_steam_1h_DLC', 10, 'DLC_BOX11');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP2_DLC', 10, 'DLC_BOX11');
    TxGiveItem(tx, 'GIMMICK_Drug_PMATK2_DLC', 10, 'DLC_BOX11');
    TxGiveItem(tx, 'Hat_628075', 1, 'DLC_BOX11');
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_ITEM_WING_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
       TxGiveItem(tx, 'Wing_Heart' , 1, "LOG_USE"..item.ClassName)
       TxGiveItem(tx, 'Wing_Angel', 1, "LOG_USE"..item.ClassName)
       TxGiveItem(tx, 'Wing_Falcon', 1, "LOG_USE"..item.ClassName)
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_ITEM_COSTUME_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local string_cut = SCR_STRING_CUT_SEMICOLON(string1)
    
    local tx = TxBegin(pc);
       TxGiveItem(tx, string_cut[1] , 1, "LOG_USE"..item.ClassName)
       TxGiveItem(tx, string_cut[2], 1, "LOG_USE"..item.ClassName)
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_ITEM_TOKEN_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
       TxGiveItem(tx, 'PremiumToken' , arg1, "LOG_USE"..item.ClassName)
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_STUFF_BOX_C(pc)
    local tx = TxBegin(pc) 
    TxGiveItem(tx, 'Premium_WarpScroll', 5, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Premium_repairPotion', 2, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Drug_MSPD2_1h_NR', 2, 'DRUNG_BOX_ELIXER_PREMIUM');
    local ret = TxCommit(tx)
end

function SCR_USE_ChallengeModeReset(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local isHasBuff = IsBuffApplied(self, 'ChallengeMode_Completed')
        if isHasBuff == 'YES' then
            RemoveBuff(self, 'ChallengeMode_Completed')
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ChallengeModeReset_MSG2"), 10)
        end
    end
end
function SCR_USE_GIVE_CHUSEOK_COSTUME_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    
    local tx = TxBegin(pc);
       TxGiveItem(tx, string1 , 1, "LOG_USE_TX"..item.ClassName)
       TxGiveItem(tx, 'Premium_Enchantchip' , 5, "LOG_USE_TX"..item.ClassName)
       TxGiveItem(tx, 'Event_1710_Thanksgiving_Coin' , 1, "LOG_USE_TX"..item.ClassName)
       TxGiveItem(tx, 'Hat_628299', 1, "LOG_USE_TX"..item.ClassName)
       TxGiveItem(tx, 'Event_160908_7', 30, "LOG_USE_TX"..item.ClassName)
    local ret = TxCommit(tx);
end

function SCR_USE_GIVE_STUFF_BOX_C(pc)
    local tx = TxBegin(pc) 
    TxGiveItem(tx, 'Premium_WarpScroll', 5, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Premium_repairPotion', 2, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Drug_MSPD2_1h_NR', 2, 'DRUNG_BOX_ELIXER_PREMIUM');
    local ret = TxCommit(tx)
end

function SCR_USE_G9_BOX(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip14', 1, 'G9_BOX');
    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'G9_BOX');
    TxGiveItem(tx, 'PremiumToken_3d', 1, 'G9_BOX');
    TxGiveItem(tx, 'Gacha_HairAcc_001', 1, 'G9_BOX');
    TxGiveItem(tx, 'ABAND01_126', 1, 'G9_BOX');
    local ret = TxCommit(tx);
end
function SCR_USE_PACKAGE_VAMPIRE(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, string1, 1, 'USE_HALLOWEEN_2017_'..item.ClassName);
    TxGiveItem(tx, 'Gacha_HalloweenTOY', 3, 'USE_HALLOWEEN_2017_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_VAKARINE_BOX01(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PremiumToken_15d_vk', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_boostToken03', 1, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_VAKARINE_BOX02(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_boostToken', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_indunReset', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_eventTpBox_10', 1, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_VAKARINE_BOX03(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Gacha_HairAcc_001', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_Enchantchip14', 3, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_PACKAGE_VAKARINE_BOX04(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_boostToken', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_indunReset', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'Premium_eventTpBox_10', 1, 'USE_'..item.ClassName);
    TxGiveItem(tx, 'ABAND01_127', 1, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_MISC_ORE15_BOX(pc, target, string1, arg1, arg2, itemID)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_ore15', 5, 'USE_MISC_ORE15_BOX');
    local ret = TxCommit(tx);
end

function SCR_USE_Premium_repairPotion_Box(pc, target, string1, arg1, arg2, itemID)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_repairPotion_NR', 3, 'USE_Premium_repairPotion_Box');
    local ret = TxCommit(tx);
end

function HALOWEEN_2017_ACHIEVE1(pc)
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    TxAddAchievePoint(tx, '2017_Halloween2_AP', 1)
    local ret = TxCommit(tx);
end

function HALOWEEN_2017_ACHIEVE2(pc)
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    TxAddAchievePoint(tx, '2017_Halloween1_AP', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_REWARD_ERROR_COMPENSATION_1d(pc, target, string1, arg1, arg2, itemID)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Companion_Exchange_Ticket', 12, 'REWARD_ERROR_COMPENSATION_1d');
    TxGiveItem(tx, 'Vis', 500000, 'REWARD_ERROR_COMPENSATION_1d');
    TxGiveItem(tx, 'Premium_boostToken02', 3, 'REWARD_ERROR_COMPENSATION_1d');
    TxGiveItem(tx, 'Adventure_Point_Stone',2, 'REWARD_ERROR_COMPENSATION_1d');
    TxGiveItem(tx, 'Adventure_dungeoncount_01',3, 'REWARD_ERROR_COMPENSATION_1d');
    local ret = TxCommit(tx);
end

function SCR_USE_RAID_STONE_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Dungeon_Key01', arg1, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_CARD_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'card_Xpupkit10', arg1, 'USE_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_LOOTINGCHANCE_POTION(self,argObj,BuffName,arg1,arg2)
	AddBuff(self, self, 'DRUG_LOOTINGCHANCE', arg1, 0, arg2, 1);
end

function SCR_USE_PACKAGE_CHRISTMAS2017_COSTUME(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, string1, 1, 'USE_CHRISMAS2017_'..item.ClassName);
    TxGiveItem(tx, 'Gacha_Chrismas_2017', 2, 'USE_CHRISMAS2017_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_RUDOLPH_COSTUME_BOX(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'helmet_Rudolf01', 1, 'USE_CHRISMAS2017_'..item.ClassName);
    TxGiveItem(tx, 'costume_Com_77', 1, 'USE_CHRISMAS2017_'..item.ClassName);
    local ret = TxCommit(tx);
end

function SCR_USE_GOLD_MOUR_BOX_GIVE_ITEM(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, arg1, arg2, 'GOLD_MOUR_BOX_S_GIVE_COUNT'..arg2);
    local ret = TxCommit(tx);
end


function SCR_USE_SNOWFLOWER_COSTUME_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Hat_629008', 1, 'SNOWFLOWER_COSTUME_GIVE_ITEM_'..item.ClassName);
    TxGiveItem(tx, string1, 1, 'SNOWFLOWER_COSTUME_GIVE_ITEM_'..item.ClassName);    
    local ret = TxCommit(tx);
end

function SCR_USE_LOOTINC_POTION_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, string1, arg1, 'Fortune_Box_GIVE_ITEM_'..item.ClassName);    
    local ret = TxCommit(tx);
end

function SCR_USE_LOOTINC_POTION_A_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Drug_Looting_Potion_500', 1, 'Fortune_Box_A_GIVE_ITEM_'..item.ClassName);
    TxGiveItem(tx, 'Drug_Looting_Potion_300', 3, 'Fortune_Box_A_GIVE_ITEM_'..item.ClassName);   
    local ret = TxCommit(tx);
end

function SCR_USE_PREMIUM_SOCEKT_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, string1, arg1, 'PREMIUM_SOCEKT_GIVE_ITEM'..item.ClassName);    
    local ret = TxCommit(tx);
end


function SCR_USE_PREMIUM_GOLDARMOR_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
      TxGiveItem(tx, 'Gold_Armor', 1, 'GOLDARMOR_COSTUME_GIVE_ITEM_'..item.ClassName); 
    TxGiveItem(tx, string1, arg1, 'GOLDARMOR_COSTUME_GIVE_ITEM_'..item.ClassName);    
    TxGiveItem(tx, 'Gacha_golddog', 2, 'GOLDARMOR_COSTUME_GIVE_ITEM_'..item.ClassName);    
    local ret = TxCommit(tx);
end


function SCR_USE_PREMIUM_GOLDDOG_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
      TxGiveItem(tx, 'helmet_golddog01', 1, 'GOLDDOG_COSTUME_GIVE_ITEM_'..item.ClassName); 
    TxGiveItem(tx, string1, arg1, 'GOLDDOG_COSTUME_GIVE_ITEM_'..item.ClassName);    
    local ret = TxCommit(tx);
end


function SCR_USE_RequestEnterCount_1add(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_200 > 0 then
                local tx = TxBegin(self);
                TxSetIESProp(tx, pcetc, 'InDunCountType_200', pcetc.InDunCountType_200 - 1)
                local ret = TxCommit(tx);
                if ret == 'SUCCESS' then
                    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CS_RequestEnterCount_1add_MSG2"), 10);
                end
            end
        end
    end
end

function SCR_USE_GuildQuestEnterCount_1add(self, guildObj)
    local guildObj = GetGuildObj(self)
    local tx = TxBegin(self)
    TxSetPartyProp(tx, PARTY_GUILD, "UsedTicketCount", guildObj.UsedTicketCount - 1)
    local ret = TxCommit(tx);
    
    if ret == "SUCCESS" then
        SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("CS_Guild_Ticket_add1_MSG3"), 10);
		return;
	end
end

function SCR_USE_CHALLENGE_GIVE_ITEM(pc, target, string1, arg1, arg2, itemID)
    local item = GetInvItemByType(pc, itemID);
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PREMIUM_CHALLENG_PORTAL', arg1, 'CHALLENGE_GIVE_ITEM_'..item.ClassName);
    TxGiveItem(tx, 'Premium_ChallengeModeReset', arg1, 'CHALLENGE_GIVE_ITEM_'..item.ClassName);   
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_KOR_Fortunecookie(self,argObj,argstr,arg1,arg2)
    local list = {
        {10, 'PremiumToken_1d', 1},
        {20, 'Event_drug_steam', 10},
        {30, 'card_Xpupkit01_event', 1},
        {40, 'misc_gemExpStone_randomQuest4_14d', 1},
        {50, 'Moru_Silver', 1},
        {60, 'Hat_628290', 1}
    }
    
    local aObj = GetAccountObj(self);
    local result = 0;
    local BuffName

    if IsBuffApplied(self, 'Premium_Fortunecookie_1') == 'YES' then
        BuffName = 'Premium_Fortunecookie_2'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_2') == 'YES' then
        BuffName = 'Premium_Fortunecookie_3'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_3') == 'YES' then
        BuffName = 'Premium_Fortunecookie_4'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_4') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_5') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    else
        BuffName = 'Premium_Fortunecookie_1'
    end

	--EVENT_PROPERTY_RESET(self, aObj, sObj)

	for i = 1, table.getn(list) do
        if aObj.EVENT_KOR_Fortunecookie_COUNT + 1 == list[i][1] then
            result = i
            break;
        end
    end

	local tx = TxBegin(self);
    TxAddIESProp(tx, aObj, 'EVENT_KOR_Fortunecookie_COUNT', 1);
    if result ~= 0 then
        TxGiveItem(tx, list[result][2], list[result][3], 'EVENT_KOR_Fortunecookie');
    end
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        AddBuff(self, self, BuffName, 0, 0, 1800000, 1);
        local msg = ScpArgMsg("Fortunecookie_Count","COUNT", aObj.EVENT_KOR_Fortunecookie_COUNT)
        SendAddOnMsg(self, "NOTICE_Dm_scroll",msg, 10)
    end
end

function SCR_USE_VELCOFER_CURSE_DISPEL(pc, target, string1, arg1, arg2, itemID)
    if IsBuffApplied(pc, 'Raid_Velcofer_Cnt_Debuff') == 'YES' then
        RemoveBuff(pc, 'Raid_Velcofer_Cnt_Debuff')
    end
end

function SCR_USE_ITEM_AddBuff_ABILPOTION(self,argObj,BuffName,arg1,arg2)
    AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	AddAchievePoint(self, "Potion", 1);

end

function SCR_USE_GACHA_E_026(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'misc_BlessedStone', 2, 'Gacha_E_026');
    local ret = TxCommit(tx);
end

function ACHIEVE_Event_Steam_Colony_Tester(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Achieve_Event_Steam_Colony_Tester', 1)
    local ret = TxCommit(tx);
end


function SCR_FARMER_PLANT_STEP_01_AFTER_SUMMON(mon, pc, skill)
    SetDirectionByAngle(mon, -45);
end


function SCR_USE_GIVE_UPHILL_STORE_POINT(self, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(self);
    TxAddWorldPVPProp(tx, "ShopPoint", Numarg1);
    local ret = TxCommit(tx);
end

function SCR_USE_2018_WEDDING_GIVE_ITEM(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Gacha_TP_114_11', 2, '2018WEDDING_COSTUME_CUBE_22EA');
    TxGiveItem(tx, 'Select_2018wedding_costume_C', 1, '2018WEDDING_COSTUME_CUBE_22EA');
    local ret = TxCommit(tx);
end
