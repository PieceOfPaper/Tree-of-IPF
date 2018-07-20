function GUILD_MEMBER_CHANGE_LAYER(pc, pos, genType)
	
	
	SendAddOnMsg(pc, 'NOTICE_Dm_stage_ready', ScpArgMsg('waitBossSummon'), 5)

	sleep(3000)


	local list, cnt = GetPartyMemberList(pc, PARTY_GUILD);
	local guildObj = GetGuildObj(pc);
	
	local newlayer = GetNewLayer(pc);

	local cls = GetClassByType("GuildEvent", guildObj["GuildBossSummonSelectInfo"])

	for i = 1, cnt do
		local memberPc = list[i];
		local accObj = GetAccountObj(memberPc);
		if accObj.GuildEventSeq ==guildObj.GuildEventSeq then
			SetLayer(list[i], newlayer);
			GuildEventMongoLogo(pc, "Start", cls.EventType, cls.Name)
		end
	end

	ChangePartyProp(pc, PARTY_GUILD, "GuildEventEntered", 1)
	RunScript('CREATE_GUILD_BOSS_SUMMON', pc, pos, genType)
end

function CREATE_GUILD_BOSS_SUMMON(pc, pos, genType)
	sleep(3000)

	local guildObj = GetGuildObj(pc);
	local cls = GetClassByType("GuildEvent", guildObj["GuildBossSummonSelectInfo"])

    if cls == nil then
        return;
    end

    local monCls = GetClass("Monster", cls.BossName)

    local range = 50;
	local layer = GetLayer(pc);
	local x, y, z = GetPos(pc);

    

    local mon1 = CREATE_MONSTER_EX(pc, cls.BossName, x, y, z, GetDirectionByAngle(pc), monCls.Faction, monCls.Level);
	SetLifeTime(mon1, 60 * 60 * 1000);
    SetDeadScript(mon1, "GUILD_SUMMON_BOSS_DEAD");	
end



function GUILD_SUMMON_BOSS_DEAD(mon)
	
	local killer = GetKiller(mon)

	RunScript('GUILD_SUMMON_BOSS_DEAD_MON', killer)
	
end

function TEST_PAPA(pc)
		local zoneID = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	print(zoneID, layer)
	local pcList, pcCnt = GetLayerPCList(zoneID, layer);
	print(pcList, pcCnt)

end

function GUILD_SUMMON_BOSS_DEAD_MON(killer)
	local zoneID = GetZoneInstID(killer);
	local layer = GetLayer(killer);
	local pcList, pcCnt = GetLayerPCList(zoneID, layer);
	
	for i = 1, pcCnt do
		local pc = pcList[i];
		local guildObj = GetGuildObj(pc);
		if guildObj ~= nil then
			RunScript('TAKE_GUILD_EVENT_REWARD', pc)

			ChangePartyProp(pc, PARTY_GUILD, "GuildBossSummonFlag", 0)
			ChangePartyProp(pc, PARTY_GUILD, "GuildBossSummonSelectInfo", 0)
			ChangePartyProp(pc, PARTY_GUILD, "GuildBossSummonLocInfo", "None")
			break;
		end
	end

	sleep(5000)

	--[[
	local itemList, itemCount = GetLayerItemList(zoneID, layer)
    if itemCount > 0 then
		for i = 1, itemCount do
			if itemList[i].ClassName ~= 'PC' and ( 1 == IsItem(itemList[i]) or itemList[i].Tactics == 'MON_HITME') then
				SetLayer(itemList[i], 0)
			end
		end
    end
	--]]
	for i = 1, pcCnt do
		SetLayer(pcList[i], 0)
	end
end




function SCR_D_CMINE_02_GFB_NPC_1_DIALOG(self, pc)
    
end


function GUILD_RAID_START_MGAME(pc)
	--sleep(5000)

	local guildObj = GetGuildObj(pc)

	if guildObj == nil then
		return;
	end

	if guildObj["GuildRaidSelectInfo"] == 0 then
		return;
	end

	local cls = GetClassByType("GuildEvent", guildObj["GuildRaidSelectInfo"])

	if cls == nil then
		return;
	end

	local GuildRaidStage = guildObj["GuildRaidStage"]

	if GuildRaidStage == 0 then
		return;
	end

	local list, cnt = GetPartyMemberList(pc, PARTY_GUILD);
	
	
	local newlayer = GetNewLayer(pc);

	for i = 1, cnt do
		SetLayer(list[i], newlayer);
	end
	
	local layer_obj = GetLayerObject(GetZoneInstID(pc), newlayer);
	if layer_obj ~= nil then
	    layer_obj.GUILD_EVENT_LAYER = 'GUILD_EVENT_LAYER'
	end
	
	--sleep(5000)
	for i = 1, cnt do
		RunMGame(list[i], cls["StageTrack_"..GuildRaidStage])
	end
	ChangePartyProp(pc, PARTY_GUILD, "GuildEventEntered", 1)
end


function TEST_RAID_TEST(pc)
	local guildObj = GetGuildObj(pc)

	ChangePartyProp(pc, PARTY_GUILD, "GuildRaidSelectInfo", 2002);

	ChangePartyProp(pc, PARTY_GUILD, "GuildRaidStage", 8);

	ChangePartyProp(pc, PARTY_GUILD, "GuildRaidFlag", 1);

	--ChangePartyProp(pc, PARTY_GUILD, "GuildRaidSelectInfo", 2000);
end

function SCR_BRACKEN_42_1_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_THORN_39_2_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_SIAULIAI_11_RE_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_THORN_39_1_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_ROKAS_26_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_BRACKEN_42_2_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_ABBEY_35_3_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end


function SCR_GELE_57_4_TO_GUILD_FIELD_BOSS_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end

function SCR_FIRETOWER44_TO_GUILDMISSION_ENTER(self, pc)
    if isHideNPC(pc, 'FIRETOWER44_TO_GUILDMISSION') == 'NO' then
    	RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
    end
end

function SCR_GELE574_TO_GUILDMISSION_ENTER(self, pc)
    if isHideNPC(pc, 'GELE574_TO_GUILDMISSION') == 'NO' then
    	RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
    end
end

function SCR_FLASH61_TO_CASTLE_MISSION_RN_ENTER(self, pc)
    if isHideNPC(pc, 'FLASH61_TO_CASTLE_MISSION_RN') == 'NO' then
    	RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
    end
end


function SCR_WHITETREES_23_3_TO_GUILDMISSION_ENTER(self, pc)
    return;
end

function SCR_WHITETREES_23_3_TO_GUILDMISSION_DIALOG(self, pc)
    RunScript(SCR_GUILD_EVENT_ENTER_CHECK(self, pc));
end