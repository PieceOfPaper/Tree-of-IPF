-- buff
function SCR_BUFF_ENTER_Event_Penalty_2(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Event_Penalty_2(self, buff, arg1, arg2, over)
end

-- init
function INIT_CURSEDOOR_EVENT_STAT(pc)
    if pc.ClassName == 'PC' then
      if IsDummyPC(pc) == 1 then
        return;
      end
      
      AddBuff(pc, pc, "Event_Penalty", 1, 0, 700000, 1);

    else
        local petlist = {
          'Velhider',
          'pet_dog',
          'hoglan_Pet',
          'pet_hawk',
          'Piggy',
          'Lesser_panda',
          'Toucan',
          'Guineapig',
          'barn_owl',
          'Piggy_baby',
          'Lesser_panda_baby',
          'guineapig_baby',
          'penguin',
          'parrotbill',
          'parrotbill_dummy',
          'Pet_Rocksodon',
          'penguin_green',
          'PetHanaming',
          'penguin_marine',
          'guineapig_white',
          'Lesser_panda_gray',
          'Zombie_Overwatcher',
          'summons_zombie',
          'Zombie_hoplite'
        }
        
        for i = 1, table.getn(petlist) do
            if pc.ClassName == petlist[i] then
                AddBuff(pc, pc, "Event_Penalty", 1, 0, 700000, 1);
                break;
            end
        end
	end
end

-- door ai
function SCR_CURSE_DOOR_EV(self)
	local objList, objCount = SelectObjectNear(self, self, 150, "ENEMY");
	-- Mon_tower_of_firepuppet_Skill_2
	if objCount > 0 then
		for i = 1, objCount do
			if objList[i].ClassName == 'PC' then
				local result = math.floor(GetLookAngle(self, objList[i]) - GetLookAngle(objList[i],self))
				local dis = GetActorDistance(self, objList[i])

				if dis <= 20 then
					TakeDamage(self, objList[i], "None", 10000);
				end

				if self.ClassName == 'tower_of_firepuppet_black' and dis <= 60 then
					if IsBuffApplied(objList[i], 'Cold') == 'NO' then
						AddBuff(self,objList[i], 'Cold')
					end
				end

				if result <= -9 then
					MoveToTarget(self, objList[i], 1)
				else
					StopMove(self)
				end
			end
		end
	else
		RandomMove(self, 50)
	end
end

-- reward box
function SCR_CURSEDOOR_REWARD_DIALOG(self,pc)
	local aObj = GetAccountObj(pc);
	local zoneObj = GetLayerObject(pc);
	local GOAL_COUNT = GetExProp(zoneObj, 'GOAL_COUNT')

	if IsBuffApplied(pc, 'Event_Penalty_2') == 'YES' then
		local tx = TxBegin(pc)
		TxAddIESProp(tx, aObj, 'SURVIVAL2_COUNT', 1);
		TxGiveItem(tx, 'Event_CurseDoor_Cube', 1, 'Curse_Door_Cube');
		local ret = TxCommit(tx)

		if ret == 'SUCCESS' then
			SetExProp(zoneObj, "GOAL_COUNT", GOAL_COUNT + 1);
			RemoveBuff(pc, 'Event_Penalty_2')
			GOAL_COUNT = GetExProp(zoneObj, 'GOAL_COUNT')
		end
	end

	if GOAL_COUNT >= 5 then
		local zoneID = GetZoneInstID(self)
		local layer = GetLayer(pc);
		local list, cnt = GetLayerPCList(zoneID, layer);

		for i = 1 , cnt do
			RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', list[i], 'Event_CurseDoor_Cube/1', nil, nil, nil,'CurseDoor_Add', nil)
		end

		Kill(self)
		return;
	end
end

-- create box
function SCR_CREATE_RBOX_DIALOG(self,pc)
	local result = DOTIMEACTION_R(pc, ScpArgMsg("ROKAS30_MQ5_MSG01"), 'WORSHIP', 10)
	if result == 1 then
		local rand = IMCRandom(1, 2)
		local rbox_pos = {
			{ 2370, 308, 1078},
			{-2239, 368, -436}
		}

		--CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog)
		local npc = CREATE_NPC(pc, 'treasure_box5', rbox_pos[rand][1], rbox_pos[rand][2], rbox_pos[rand][3], 0, "Neutral", 0, ScpArgMsg("CITYATTACK_BOSS_BOX"), 'CURSEDOOR_REWARD', nil, nil, 1, nil, nil, nil, nil, nil, nil, 1)
		if npc ~= nil then
			EnableMonMinimap(npc)
			local zoneID = GetZoneInstID(self)
			local layer = GetLayer(pc);
			local list, cnt = GetLayerPCList(zoneID, layer);

			for i = 1 , cnt do
				AddBuff(self,pc, 'Event_Penalty_2')
			end
			Kill(self);
		end
	end
end

-- dialog, reward, indun enter
function SCR_CURSE_DOOR_DIALOG(self,pc)
	Heal(pc, pc.MHP, 0)

    local aObj = GetAccountObj(pc);
    local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Kepa_Event_Enter"), ScpArgMsg("Prison_Select2", "COUNT", aObj.SURVIVAL2_COUNT), ScpArgMsg("Cancel"))

	if select == 1 then
		AUTOMATCH_INDUN_DIALOG(pc, nil, 'Indun_catacomb_04_event')
	elseif select == 2 then
		local rewardCount = aObj.SURVIVAL2_REWARD + 1

		if rewardCount >= 5 then
			return;
		end

		local clearReward = {
			{ 5, 'Premium_boostToken02_event01'},
			{10, 'Premium_boostToken03_event01'},
			{15, 'Moru_Gold_14d'},
			{20, 'Moru_Diamond_14d'}
		}

		for i = 1, table.getn(clearReward) do
			if aObj.SURVIVAL2_COUNT >= clearReward[rewardCount][1] then
				local tx = TxBegin(pc)
				TxAddIESProp(tx, aObj, 'SURVIVAL2_REWARD', 1);
				TxGiveItem(tx, clearReward[rewardCount][2], 1, 'Curse_Door_Event');
				local ret = TxCommit(tx)
				if ret == 'SUCCESS' then
					ShowOkDlg(pc,'JP_Event_Daily', 1)
				end
				break;
			end
		end
	else
		return;
	end
end