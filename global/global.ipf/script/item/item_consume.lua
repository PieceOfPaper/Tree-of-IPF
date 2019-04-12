function TX_SCR_USE_SKILL_STAT_RESET(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= "Premium_SkillReset" and invItem.ClassName ~= "steam_Premium_SkillReset" and invItem.ClassName ~= "steam_Premium_SkillReset_1" then
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local teamName = GetTeamName(self);
	local guildObj = GetGuildObj(self);
	local templar = false;
	if guildObj ~= nil and IsPartyLeader(guildObj, teamName) == 1 then
		local jobHistory = GetJobHistoryString(self)
		local sList = StringSplit(jobHistory, ";");
		for i = 1, #sList do
			local jobCls = GetClass("Job", sList[i])
			if jobCls ~= nil and jobCls.EngName == 'Templar' then
				templar = true;
				break;
			end
		end
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end
	
	TxResetSkill(tx, 0, 0)
	TxTakeItemByObject(tx, invItem, 1, "use");

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

	if true == templar then
		ChangePartyProp(self, PARTY_GUILD, 'Templer_BuildForge_Lv', 0);
		ChangePartyProp(self, PARTY_GUILD, 'Templer_BuildShieldCharger_Lv', 0);
end
end


function TX_SCR_USE_STAT_RESET(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= "Premium_StatReset" and invItem.ClassName ~= "steam_Premium_StatReset" and invItem.ClassName ~= "Premium_StatReset14" and invItem.ClassName ~= "steam_Premium_StatReset_1" and invItem.ClassName ~= "Premium_StatReset_TA" then
		return;
	end

	if invItem.ItemLifeTimeOver == 1 then
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local PRE_STR = self.STR
	local PRE_CON = self.CON
	local PRE_INT = self.INT
	local PRE_MNA = self.MNA
	local PRE_DEX = self.DEX

	local tx = TxBegin(self);
	if tx == 0 then
		return;
	end
	
	TxResetStat(tx, 0, 0)
	TxTakeItemByObject(tx, invItem, 1, "use");

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