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
	if result == 1 then
		InvalidateStates(pc);
		invItem.Reinforce_2 = invItem.Reinforce_2 + 1;
		ShowItemBalloon(pc, "{@st43}", "SucessReinforce!!!", "", invItem, 5, delaySec, "enchant_itembox");
		invItem.Reinforce_2 = invItem.Reinforce_2 - 1;
        PlayAnim(monster, "success", 1, 1, 0, 1);
	else
    	if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
        ShowItemBalloon(pc, "{@st43}", "SucessReinforce!!!", "", invItem, 5, delaySec, "enchant_itembox");
        PlayAnim(monster, "success", 1, 1, 0, 1);
        else
		ShowItemBalloon(pc, "{@st43_red}", "SucessFail!!!", "", invItem, 5, delaySec, "enchant_itembox");
        PlayAnim(monster, "fail", 1, 1, 0, 1);
        end
	end

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
			elseif moruName == "Moru_Premium" or moruName == "Moru_Gold" or moruName == "Moru_Gold_14d" or moruName == "Moru_Gold_TA" then
				if  reinforce_2 > 10 then
					TxSetIESProp(tx, invItem, 'Reinforce_2', 10);
				else
					TxAddIESProp(tx, invItem, "Reinforce_2", -1);
				end
			elseif moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
    			TxAddIESProp(tx, invItem, "Reinforce_2", 0);
			else
				TxTakeItemByObject(tx, invItem, 1, 'Reinforce_2_Fail');
				isBreakItem = 1;
			end
    	end
	end
	
	TxAddAchievePoint(tx, "ReinforceWin", 1);
	
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		if moruName == "Moru_Potential" or moruName == "Moru_Potential14d" then
			ItemPotentialMoruMongoLog(pc, guid, invItem.PR);
		else
			if result == 1 then
				ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount+1, spentSilver);
			else
				if isBreakItem == 1 then
					ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount, spentSilver);
				else
					ItemEnchantMongoLog(pc, guid, itemName, result, isBreakItem, isWeapon, itemReinCount, spentSilver)
				end
			end
			
			if isEquipped == 1 then
				InvalidateStates(pc);
			end						

			if result == 1 then
			local wiki = GetItemWiki(pc, invItem.ClassID);
				if wiki ~= nil then
					local maxReinforce = GetWikiIntProp(wiki, "MaxReinforce");
					if invItem.Reinforce_2 > maxReinforce then
						SET_WIKI_INT_PROP(pc, wiki, "MaxReinforce", invItem.Reinforce_2);
					end
				end
			end
		end
	end

	BroadcastShape(pc);
end