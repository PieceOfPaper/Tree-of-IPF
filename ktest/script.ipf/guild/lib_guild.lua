
AUTHORITY_GUILD_INVITE = 1
AUTHORITY_GUILD_BAN = 2

function callback_remove_guild_tower(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            RemoveGuildTower(pc)
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end


function callback_guild_declare_war(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            local tx = TxBegin(pc);
			TxDeclareWar(tx, argList[1]);
			local ret = TxCommit(tx);
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function callback_guild_declare_war_cancel(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            local tx = TxBegin(pc);
			TxCancelGuildWar(tx, PARTY_GUILD, argList[1]);
			local ret = TxCommit(tx);	
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end


function REQ_MOVE_TO_GUILDHOUSE(pc)

	local openedMission, alreadyJoin = OpenPartyMission(pc, pc, 0, "guildhouse", "", 1, PARTY_GUILD);  
	ReqMoveToMission(pc, openedMission);

end

function SCR_USE_ITEM_GUILDTOWER(self,argObj, argstring, argnum1, argnum2)
    if IsJoinColonyWarMap(self) == 1 then
        SendSysMsg(self, 'PopUpBook_MSG3');
        return;
    end
    
	local currentChannel = GetMyChannel(self);
	if currentChannel ~= 0 then
		SendSysMsg(self, "OnlyAbleInChannel1");
		return;
	end

	local mapCls = GetMapProperty(self);
	if 'City' == mapCls.MapType then
		SendSysMsg(self, "NotAllowedInTown");	
		return;
	end

	local isMission = IsMissionInst(self);
	if isMission == 1 or mapCls.ClassName == 'guild_agit_1' then
		SendSysMsg(self, "CannotUseThieInThisMap");	
		return;
	end

	local x, y, z = GetPos(self);
	if 0 == IsFarFromNPC(self, x, y, z, 100) then
		SendSysMsg(self, "TooNearFromNPC");	
		return;
	end

	local nowZoneName = GetZoneName(self);
	local towerType = GetClass("GuildTower", "GTower_1").ClassID;
    local tx = TxBegin(self);
	TxMakeGuildTower(tx, nowZoneName, towerType, x, y, z);
	local ret = TxCommit(tx);	
	
end

function GUILD_LEVEL_RELOAD(pc, partyObj)

	if pc == nil or partyObj == nil then
		return;
	end

	if partyObj.GuildLevelReload == 2 then
		return;
	end
			
	local curLevel = partyObj.Level;
	local nextLevel = GET_GUILD_LEVEL_BY_EXP(partyObj.Exp);

	if curLevel ~= nextLevel then
		local tx = TxBegin(pc);
		if tx ~= nil then
			TxSetPartyProp(tx, PARTY_GUILD, "Level", nextLevel);
			TxSetPartyProp(tx, PARTY_GUILD, "GuildLevelReload", partyObj.GuildLevelReload + 1);
			local ret = TxCommit(tx);
		end
	end
end

function CREATE_GUILD_COMMON_MENU(partyObj, menuList, isLeader, isEnemyParty, isSameGuild)
	local currentLevel = partyObj.TowerLevel;
	if isSameGuild == true then
		if currentLevel >= 1 then
			menuList[#menuList + 1] = "Warp";   
		end

		if currentLevel >= 2 then
			menuList[#menuList + 1] = "WareHouse";
		end

		if currentLevel >= 3 then
			menuList[#menuList + 1] = "GuildGrowth";
		end

		if currentLevel >= 4 then
			menuList[#menuList + 1] = "GuildEvent";
		end
	end

	if currentLevel >= 5 then
		if isEnemyParty == 0 then
			menuList[#menuList + 1] = "MoveToAgit";
		end
	end

    --[[
	if isLeader == 1 then
		menuList[#menuList + 1] = "DiscardTower";
	end
    --]]
    
    if isSameGuild == true then
        menuList[#menuList + 1] = "DiscardTower";
    end

end

function EXEC_GUILD_COMMON_MENU(tower, pc, menuCmd)
	
	if menuCmd == "GuildGrowth" then
		ShowCustomDlg(pc, "guildgrowth", 5);
		return 1;
	elseif menuCmd == "WareHouse" then
		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"warehouse")
		ShowCustomDlg(pc, 'warehouse', 5);		
		return 1;
	elseif menuCmd == "GuildEvent" then
	    GUILDEVENT_SELECT_TYPE(tower, pc)
		return 1;
	elseif menuCmd == "Warp" then
		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"worldmap")
		SetExProp(pc, "WarpFree", 1);
		ExecClientScp(pc, "INTE_WARP_OPEN_NORMAL()");
		return 1;
	end

	return 0;
end

function IS_GUILDTOWER_MEMBER(pc)
	local towerGuildID = GetGuildHouseIESID(pc);
	local pcGuildID = GetGuildID(pc);
	return towerGuildID == pcGuildID;		
end

function MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList)
	for i = 1 , #menuList do
		local menuCmd = menuList[i];
		if menuCmd ~= "GuildEvent" then
			clMsgList[i] = ScpArgMsg(menuList[i]);
		else
			local curDate = GetCurDateNumber();
			local remainTicketCount = GET_REMAIN_TICKET_COUNT(partyObj);
			clMsgList[i] = ScpArgMsg(menuList[i]) .. "  (" .. ScpArgMsg("RemainTicket:{Ticket}", "Ticket", remainTicketCount) .. ")";
		end
	end
end

function RESET_GUILD_TICKET(pc)

	local guildObj = GetGuildObj(pc);		
	local curDate = GetCurDateAndNextData();
	local nextRestTime = GetNextIndunWeeklyResetTime()

	if curDate < guildObj.LastEventTicketDay then
		return;
	end

	if guildObj.LastEventTicketDay == nextRestTime then
		return;
	end

	ChangePartyProp(pc, PARTY_GUILD, "LastEventTicketDay", nextRestTime)
	ChangePartyProp(pc, PARTY_GUILD, "UsedTicketCount", 0)

end

function SCR_GUILD_TOWER_DIALOG(tower, pc)
	local guildID = GetIESID(tower);
	local pcGuildID = GetGuildID(pc);

	local sameGuild = false;
	if pcGuildID == guildID then
		if pcGuildID ~= "0" then
			sameGuild = true;
		end
	end

	if sameGuild == true then
		RESET_GUILD_TICKET(pc)
	end
	
	local partyObj, partyName = GetPartyObjByIESID(PARTY_GUILD, guildID);
	
	local priority = 3;
	local guildTowerText = ScpArgMsg("GuildTower_{Name}", "Name", partyName);
	local text = guildTowerText.. "*@*" .. ScpArgMsg("SelectMenu");
	local isEnemyParty = 0;
	if sameGuild == false then
		if pcGuildID ~= "0" then
			isEnemyParty = IsEnemyParty(PARTY_GUILD, pcGuildID, guildID);
		end
	end

	if partyObj.GuildLevelReload ~= 2 then
		GUILD_LEVEL_RELOAD(pc, partyObj)
	end
	
	local menuList = {};
	local isLeader = IsPartyLeaderPc(partyObj, pc);
	CREATE_GUILD_COMMON_MENU(partyObj, menuList, isLeader, isEnemyParty, sameGuild);

	if sameGuild ~= true then
		if pcGuildID ~= "0" then
			if isEnemyParty == 0 then
				menuList[#menuList + 1] = "DeclareWar";
			else
				menuList[#menuList + 1] = "CancelGuildWar";
			end
		end
	end

	menuList[#menuList + 1] = "Close";

	local clMsgList = {};
	MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);
	
	local select = ShowSelDlg_List(pc, priority, text, clMsgList);
	if select == nil then
		return;
	end

	local menuCmd = menuList[select];

	if EXEC_GUILD_COMMON_MENU(tower, pc, menuCmd) == 0 then

		if menuCmd == "MoveToAgit" then
			if partyObj.GuildOnlyAgit == 1 and sameGuild == false then
				SendSysMsg(pc, "ConfigedToUseGuildMemberOnly");
				return;
			end
			
--			--EVENT_1805_GUILD
--			if sameGuild == true then
--			    EVENT_1805_GUILD_DAY_MIC_REWARD(pc)
--			end

			-- 길드아지트 미션타입
			--local openedMission, alreadyJoin = OpenPartyMission(pc, pc, 0, "guildhouse", "", 1, PARTY_GUILD, guildID);
			--ReqMoveToMission(pc, openedMission);

			-- 길드아지트 존타입
			ReqMoveToGuildAgit(pc, guildID);
			

		elseif menuCmd == "DeclareWar" then
			
			text = "".. "*@*" .. ClMsg("ReallyDeclareWar?");

			menuList = {};
			menuList[#menuList + 1] = "DeclareWar";	
			menuList[#menuList + 1] = "No";
			clMsgList = {};
			MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);
			
			local select = ShowSelDlg_List(pc, priority, text, clMsgList);
			if select == nil then
				return;
			end

			if select == 1 then
				local pcGuildObj = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);
				if pcGuildObj.HousePosition == "None" then
					SendSysMsg(pc, "NeedGuildTower");
					return;
				end

				if 1 == IsNeutralityStateGuild(guildID) then
					SendSysMsg(pc, "TargetGuildIsNeutralityState");
					return;
				end

				if 1 == IsNeutralityStateGuild(pcGuildID) then
					SendSysMsg(pc, "YourGuildIsNeutralityState");
					return;
				end
                local argList = {}
                argList[1] = tostring(guildID)
                CheckClaim(pc, 'callback_guild_declare_war', 301, argList)  -- code:301 (전쟁선포)
				--local tx = TxBegin(pc);
				--TxDeclareWar(tx, guildID);
				--local ret = TxCommit(tx);	
			end			

		elseif menuCmd == "CancelGuildWar" then

			text = "".. "*@*" .. ClMsg("ReallyCancelGuildWar?");

			menuList = {};
			menuList[#menuList + 1] = "CancelGuildWar";	
			menuList[#menuList + 1] = "No";
			clMsgList = {};
			MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);
			
			local select = ShowSelDlg_List(pc, priority, text, clMsgList);
			if select == nil then
				return;
			end

			if select == 1 then
                local argList = {}
                argList[1] = tostring(guildID)
                CheckClaim(pc, 'callback_guild_declare_war_cancel', 301, argList)  -- code:301 (전쟁선포)
				--local tx = TxBegin(pc);
				--TxCancelGuildWar(tx, PARTY_GUILD, guildID);
				--local ret = TxCommit(tx);	
			end
		

		elseif menuCmd == "DiscardTower" then

			menuList = {};
			menuList[#menuList + 1] = "Remove";	
			menuList[#menuList + 1] = "No";
			clMsgList = {};
			MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);
	
			text = ClMsg("ReallyRemove?") .. "*@*" .. ClMsg("ReallyRemove?");
			local select = ShowSelDlg_List(pc, priority, text, clMsgList);
			if select == nil then
				return;
			end

			if select == 1 then
                local argList = {}
                CheckClaim(pc, 'callback_remove_guild_tower', 14, argList)  -- code:14 (길드타워철거)
			end
		end
	end
	

end

function INIT_AGIT_HOUSE(tower)

	local guildID = GetGuildHouseIESID(tower);
	local partyObj, partyName = GetPartyObjByIESID(PARTY_GUILD, guildID);
	ChangeNameByScript(tower, "GET_GUILDTOWER_NAME", partyName);

end

function SCR_TOWER_IN_AGIT_DIALOG(tower, pc)

	local priority = 3;

	local guildID = GetGuildHouseIESID(pc);
	local partyObj, partyName = GetPartyObjByIESID(PARTY_GUILD, guildID);

	local guildTowerText = ScpArgMsg("GuildTower_{Name}", "Name", partyName);
	local text = guildTowerText.. "*@*" .. ScpArgMsg("SelectMenu");
	
	local sameGuild = true;
	local pcGuildID = GetGuildID(pc);
	if pcGuildID ~= guildID then
		sameGuild = false;
	end
	

	local menuList = {};
	CREATE_GUILD_COMMON_MENU(partyObj, menuList, nil, nil, sameGuild);

	menuList[#menuList + 1] = "MoveToOuterTower";
	menuList[#menuList + 1] = "Close";

	local clMsgList = {};
	MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

	local select = ShowSelDlg_List(pc, priority, text, clMsgList);
	if select == nil then
		return;
	end

	local menuCmd = menuList[select];

	if EXEC_GUILD_COMMON_MENU(tower, pc, menuCmd) == 0 then
		if menuCmd == "MoveToOuterTower" then
			MoveToLobbyZone(pc);
		end
	end

end

function SCR_AGIT_TO_HOUSE_ENTER(trigger, pc)

	UIOpenToPC(pc,'fullblack',1)
    sleep(500)
	SetPos(pc, 285, 1, 1342);
	UIOpenToPC(pc,'fullblack',0)

end

function SCR_AGIT_TO_YARD_ENTER(trigger, pc)

	UIOpenToPC(pc,'fullblack',1)
    sleep(500)
	SetPos(pc, -220, 53, 279);
	UIOpenToPC(pc,'fullblack',0)

end

function callback_use_agit_seed(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        local partyObj = GetGuildObj(pc);
	    SetExProp(partyObj, "NextPlantAbleTime", 0);
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                local tx = TxBegin(pc)                
                TxTakeItemByGuid(tx, argList[6], 1, "");
	            TxMakeGuildHouseObject(tx, argList[1], tonumber(argList[2]), tonumber(argList[3]), tonumber(argList[4]), argList[5], "");
	            local ret = TxCommit(tx)
	        end
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end

    local partyObj = GetGuildObj(pc);
	SetExProp(partyObj, "NextPlantAbleTime", 0);	
end

function SCR_USE_AGIT_SEED(pc, argObj, clsName, argnum1, argnum2)

	if 0 == IsGuildHouseWorld(pc) then
		return;
	end
    
	if IS_GUILDTOWER_MEMBER(pc) == false then
		SendSysMsg(pc, "CantPlantSeedBczNotOurGuild");
		return
	end

	local surfaceType = GetSurfaceType(pc);
	if surfaceType ~= "farm" then
		SendSysMsg(pc, "YouCantMakeObjectOnlyInFarmArea");
		return;
	end

	local partyObj = GetGuildObj(pc);
	local nextPlantAbleTime = GetExProp(partyObj, "NextPlantAbleTime");
	local currentTime = imcTime.GetAppTime();
	if currentTime < nextPlantAbleTime then
		SendSysMsg(pc, "DataError");
		return;
	end

	SetExProp(partyObj, "NextPlantAbleTime", currentTime + 30);

	local abilLevel = GET_GUILD_ABILITY_LEVEL(partyObj, "Farming")	;
	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ObjType", "Plant");
	if curPlantCount >= abilLevel * 3 then
		SendSysMsg(pc, "CantCreatePlantAnymore");
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	local x, y, z = GetFrontPos(pc, 10);
	local minDist = GetMinDistOfGuildHouseObjectByClassProp(pc, "ObjType", "Plant", x, y, z);
	if minDist >= 0 and minDist <= 20 then
		SendSysMsg(pc, "CantCreateObjectNearOtherObject");	
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	if GetClass("Seed", clsName) == nil then
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	DisableControlForTime(pc, 3);
	PlayAnim(pc, "STANDSPINKLE", 1, 0);
	sleep(1500);
	
	if curPlantCount >= abilLevel * 3 then
		SendSysMsg(pc, "CantCreatePlantAnymore");
		return;
	end

	local guid = GenerateGuid64();
	local value = clsName;
	
	local tx = TxBegin(pc);
	TxMakeGuildHouseObject(tx, guid, x, y, z, clsName, "");
	local ret = TxCommit(tx);	

	SetExProp(partyObj, "NextPlantAbleTime", 0);
	
end

function SCR_USE_AGIT_SEED_CALLBACK(pc, argObj, clsName, argnum1, argnum2, itemType, itemObj)
	if 0 == IsGuildHouseWorld(pc) then
		return;
	end
    
	if IS_GUILDTOWER_MEMBER(pc) == false then
		SendSysMsg(pc, "CantPlantSeedBczNotOurGuild");
		return
	end

	local surfaceType = GetSurfaceType(pc);
	if surfaceType ~= "farm" then
		SendSysMsg(pc, "YouCantMakeObjectOnlyInFarmArea");
		return;
	end

	local partyObj = GetGuildObj(pc);
	local nextPlantAbleTime = GetExProp(partyObj, "NextPlantAbleTime");
	local currentTime = imcTime.GetAppTime();
	if currentTime < nextPlantAbleTime then
		SendSysMsg(pc, "DataError");
		return;
	end

	SetExProp(partyObj, "NextPlantAbleTime", currentTime + 30);

	local abilLevel = GET_GUILD_ABILITY_LEVEL(partyObj, "Farming")	;
	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ObjType", "Plant");
	if curPlantCount >= abilLevel * 3 then
		SendSysMsg(pc, "CantCreatePlantAnymore");
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	local x, y, z = GetFrontPos(pc, 10);
	local minDist = GetMinDistOfGuildHouseObjectByClassProp(pc, "ObjType", "Plant", x, y, z);
	if minDist >= 0 and minDist <= 20 then
		SendSysMsg(pc, "CantCreateObjectNearOtherObject");	
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	if GetClass("Seed", clsName) == nil then
		SetExProp(partyObj, "NextPlantAbleTime", 0);
		return;
	end

	if curPlantCount >= abilLevel * 3 then
		SendSysMsg(pc, "CantCreatePlantAnymore");
		return;
	end
    
	local guid = GenerateGuid64();
	local value = clsName;
	
    DisableControlForTime(pc, 3);
	PlayAnim(pc, "STANDSPINKLE", 1, 0);
	sleep(1500);

    local argList = {}
    argList[1] = tostring(guid)
    argList[2] = tostring(x)
    argList[3] = tostring(y)
    argList[4] = tostring(z)
    argList[5] = tostring(clsName)
    argList[6] = tostring(itemObj)
    CheckClaim(pc, 'callback_use_agit_seed', 403, argList)
end

function callback_use_agit_egg(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음        
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                local tx = TxBegin(pc);
                TxTakeItemByGuid(tx, argList[7], 1, "");
	            TxMakeGuildHouseObject(tx, argList[1], tonumber(argList[2]), tonumber(argList[3]), tonumber(argList[4]), argList[5], argList[6]);
	            local ret = TxCommit(tx);
	        end
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function SCR_USE_AGIT_EGG(pc, argObj, clsName, argnum1, argnum2, itemType, itemObj)
	local surfaceType = GetSurfaceType(pc);
--	if surfaceType ~= "farm" then
--		SendSysMsg(pc, "YouCantMakeObjectOnlyInFarmArea");
--		return;
--	end

	if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		SendSysMsg(pc, "YouCanBuildInTheOtherGuildAgit");	
		return;
	end
	if 0 == IsGuildHouseWorld(pc) then
		return;
	end

	local partyObj = GetGuildObj(pc);
	local abilLevel = GET_GUILD_ABILITY_LEVEL(partyObj, "Taming");
	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ObjType", "Animal");
	local petCount = abilLevel * 3
	if curPlantCount >= petCount then
		SendSysMsg(pc, "CantCreateAnimalAnymore");	
		return;
	end

	if itemObj.KeyWord ~= "None" then
		local strList = StringSplit(itemObj.KeyWord, "#");
		for i = 1 , #strList / 2 do
			local propName = strList[2 * i - 1];
			local propValue = strList[2 * i];
			if propName == "ClsName" then
				clsName = propValue;
			end
		end
	end

	if GetClass("Seed", clsName) == nil then
		return;
	end

	DisableControlForTime(pc, 3);
	PlayAnim(pc, "SITGROPE", 1, 0);
	sleep(1500);
	local guid = GenerateGuid64();
		
	local x, y, z = GetFrontPos(pc, 10);
	local value = clsName;

	local propString = "Maker#" .. GetTeamName(pc);
	if itemObj.KeyWord ~= "None" then
		propString = propString .. "#";
		propString = propString .. itemObj.KeyWord;
	end
	
	local tx = TxBegin(pc);
	TxMakeGuildHouseObject(tx, guid, x, y, z, clsName, propString);
	local ret = TxCommit(tx);	
	
end

function SCR_USE_AGIT_EGG_CALLBACK(pc, argObj, clsName, argnum1, argnum2, itemType, itemObj)    
	local surfaceType = GetSurfaceType(pc);

	if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		SendSysMsg(pc, "YouCanBuildInTheOtherGuildAgit");	
		return;
	end
	if 0 == IsGuildHouseWorld(pc) then
		return;
	end
    
	local partyObj = GetGuildObj(pc);
	local abilLevel = GET_GUILD_ABILITY_LEVEL(partyObj, "Taming");
	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ObjType", "Animal");
	local petCount = abilLevel * 3
	if curPlantCount >= petCount then
		SendSysMsg(pc, "CantCreateAnimalAnymore");	
		return;
	end
    
	if type(itemObj) ~= type("") then
        if itemObj.KeyWord ~= "None" then
		    local strList = StringSplit(itemObj.KeyWord, "#");
		    for i = 1 , #strList / 2 do
			    local propName = strList[2 * i - 1];
			    local propValue = strList[2 * i];
			    if propName == "ClsName" then
				    clsName = propValue;
			    end
		    end
        end
	end
    
	if GetClass("Seed", clsName) == nil then
		return;
	end
    
	local guid = GenerateGuid64();
	
	local x, y, z = GetFrontPos(pc, 10);
	local value = clsName;
    
	local propString = "Maker#" .. GetTeamName(pc);
	if type(itemObj) ~= type("") and itemObj.KeyWord ~= "None" then
		propString = propString .. "#";
		propString = propString .. itemObj.KeyWord;
	end
	
    DisableControlForTime(pc, 3);
	PlayAnim(pc, "SITGROPE", 1, 0);
	sleep(1500);

    local argList = {}
    argList[1] = tostring(guid)
    argList[2] = tostring(x)
    argList[3] = tostring(y)
    argList[4] = tostring(z)
    argList[5] = tostring(clsName)
    argList[6] = tostring(propString)
    argList[7] = tostring(itemObj)
    CheckClaim(pc, 'callback_use_agit_egg', 404, argList)
end

function SCR_USE_AGIT_ACADEMY(pc, argObj, clsName, argnum1, argnum2)

	if 0 == IsGuildHouseWorld(pc) then
	    SendSysMsg(pc, "YouCanBuildInGuildAgit");	
		return;
	end

	if IS_GUILDTOWER_MEMBER(pc) == false then
		return
	end
	
	local guildObj = GetGuildObj(pc);
	local maxCnt = 0;
	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ClassName", clsName);
	if clsName == 'ShieldCharger' then
		maxCnt = TryGetProp(guildObj, 'Templer_BuildShieldCharger_Lv');
	elseif clsName == 'Forge' then
		maxCnt = TryGetProp(guildObj, 'Templer_BuildForge_Lv');
	end

	if nil == maxCnt then
		maxCnt = 0;
	end
	
	if maxCnt <= curPlantCount then
		SendSysMsg(pc, "YouCantBuildThatKindOfBuildingMoreThan{Count}", 0, "Count", maxCnt);
		return;
	end
	
	local x, y, z = GetFrontPos(pc, 10);
	local ssedCls = GetClass("Seed", clsName);
	if ssedCls == nil then
		return;
	end

	local curPlantCount = GetGuildHouseObjectCountByClassProp(pc, "ClassName", clsName);
	if maxCnt <= curPlantCount then
		SendSysMsg(pc, "YouCantBuildThatKindOfBuildingMoreThan{Count}", 0, "Count", maxCnt);
		return;
	end

	local guid = GenerateGuid64();		
	local lifeTimeInMinute = 10000 / ssedCls.ConsumeWaterPerMin;
    
    --위에 10000 / ssedCls.ConsumeWaterPerMin 가 무슨 의미인지 모르기 때문에 이런짓을 한다.
    --제대로 고치려면 과거의 신상협이 무슨 의도로 저런 코드를 짰는지 확인해야함.
    --저 로직을 고치면 기존에 잘 돌고 있던 애들이 망가질꺼임
    if ssedCls.ClassName == "Forge" then
        lifeTimeInMinute = 1440;
    end   
    	
	local index = curPlantCount + 1;

	-- 포지, 쉴드 차져는 비어있는 프로퍼티 번호에 넣어줘야함.
	if clsName == 'Forge' or clsName == 'ShieldCharger' then
		for i = 1, maxCnt do
			if guildObj["BuildingLife_"..clsName.. '_' .. i] == "None" then
				index = i;
				break;
			end
		end

		if guildObj["BuildingLife_" .. clsName .. '_' .. index] ~= 'None' then		
			SendSysMsg(pc, "DataError");
			return;
		end
	end

	local propName = "BuildingLife_" .. clsName .. '_' .. index;
	local palntProp = TryGetProp(guildObj, propName)
	if nil == palntProp then
		SendSysMsg(pc, "YouCantBuildThatKindOfBuildingMoreThan{Count}", 0, "Count", maxCnt);
		return;
	end

	DisableControlForTime(pc, 3);
	PlayAnim(pc, "SIT_HAMMERING", 1, 0);

	local tx = TxBegin(pc);
	TxMakeGuildHouseObject(tx, guid, x, y, z, clsName, "Index#"..index);
	local sysTime = GetDBTime();
	
	sysTime = imcTime.AddSec(sysTime, lifeTimeInMinute * 60);	
	--sysTime = imcTime.AddSec(sysTime, 1800);

	local strValue = imcTime.GetStringSysTime(sysTime);
	TxSetPartyProp(tx, PARTY_GUILD, propName, strValue);
	local ret = TxCommit(tx);	
	if ret ~= "SUCCESS" then
	    StopAnim(pc);
		return;
	end

	sleep(2500);
	StopAnim(pc);
end

function LOAD_GUILD_HOUSE(cmd)

	local instID = cmd:GetZoneInstID();
	local layer = cmd:GetLayer();
	LoadGuildHouse(instID, layer);
end

function WATERINGCAN_ITEM_USE(pc, skl)

	if 0 == IsGuildHouseWorld(pc) then
		return;
	end

	local x, y, z = GetFrontPos(pc, 10);
	local range = 20;
	local list, cnt = SelectObjectPos(pc, x, y, z, range, 7, 0, 0, 1);
	for i = 1 , cnt do
		local obj = list[i];
		if GetObjType(obj) == OT_MONSTERNPC then
			local seedCls = GET_MONSTER_GUILDHOUSE_CLS(obj);
			if seedCls ~= nil and seedCls.ObjType == "Plant" then
				AddGuildHouseObjectPropValue(obj, "WaterValue", 2000);
			end
		end
	end

end

function GET_MONSTER_GUILDHOUSE_CLS(mon)

	local guildHouseObj = GetGuildHouseObject(mon);
	if guildHouseObj == nil then 
		return nil;
	end

	local clsName = guildHouseObj:GetPropValue("ClassName");
	return GetClass("Seed", clsName);

end

function callback_guild_obj_remove(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then            
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                DisableControlForTime(pc, 2);
			    PlayAnim(pc, "SITGROPE", 1, 0);
			    sleep(1500);
			    local tx = TxBegin(pc);
			    TxRemoveGuildHouseObject(tx, argList[1])
			    local ret = TxCommit(tx);
            end
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function callback_guild_obj_harvest(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                DisableControlForTime(pc, 2);
		        PlayAnim(pc, "SITGROPE", 1, 0);
		        sleep(1200)
		        local tx = TxBegin(pc);
		        TxRemoveGuildHouseObject(tx, argList[1]);
--		        --EVENT_1805_GUILD
--		        TxGiveItem(tx, argList[2], tonumber(argList[3])*2, "Harvest")
		        
		        TxGiveItem(tx, argList[2], tonumber(argList[3]), "Harvest")
		        
		        local ret = TxCommit(tx)
            end
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function GUILDHOUSE_OBJ_DIALOG_PLANT(obj, pc, guildHouseObj, seedCls)
	local age = guildHouseObj:GetPropIValue("Age");
	local fullGrowMin = seedCls.FullGrowMin;
	local itemFunc = _G[seedCls.GetModelItemScript];
	local itemClsName = itemFunc(seedCls, guildHouseObj);
	local itemCls = GetClass("Item", itemClsName);
	local modelName = itemCls.Name;
	
	local menuList = {};
	local waterValue = guildHouseObj:GetPropIValue("WaterValue");
	if age >= fullGrowMin and waterValue > 0 then
		menuList[#menuList + 1] = "Harvest";	
	else
		menuList[#menuList + 1] = "Remove";	
	end

	menuList[#menuList + 1] = "Close";
	local clMsgList = {};
	MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

	local priority = 3;
	local text;
	if waterValue > 0 then
		text = modelName .. "*@*" .. modelName;
	else
		text = modelName .. "*@*" .. ScpArgMsg("DeadPlant_CannotHavestIt_RemoveIt");
	end

	local select = ShowSelDlg_List(pc, priority, text, clMsgList);
	if select == nil then
		return;
	end
	
	local menuCmd = menuList[select];
	if menuCmd == "Remove" then
		menuList = {};
		menuList[#menuList + 1] = "Remove";	
		menuList[#menuList + 1] = "No";
		clMsgList = {};
		MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

		text = modelName .. "*@*" .. ClMsg("ReallyRemove?");
		local select = ShowSelDlg_List(pc, priority, text, clMsgList);
		if select == nil then
			return;
		end

		local menuCmd = menuList[select];
		if menuCmd == "Remove" then			
            local objGuid = GetIESID(obj);
            local argList = {}
            argList[1] = tostring(objGuid)
            CheckClaim(pc, 'callback_guild_obj_remove', 403, argList)  -- code:403 (아지트 농장 사용 권한)
		end
	elseif menuCmd == "Harvest" then
        local objGuid = GetIESID(obj);
        local argList = {}
        argList[1] = tostring(objGuid)
        argList[2] = seedCls.GetItem
        argList[3] = tostring(seedCls.GetItemCount)
        CheckClaim(pc, 'callback_guild_obj_harvest', 403, argList)  -- code:403 (아지트 농장 사용 권한)
	end
		
end

function GET_USABLE_MAX_SHIELD(pc)
--[[
1랭	1000
2	5000
3	10000
4	50000
5	100000
6	500000
7랭	1000000
8랭	10000000
]]
	local jobCount = GetTotalJobCount(pc);
	if jobCount == 1 then
		return 1000;
	elseif jobCount == 2 then
		return 5000;
	elseif jobCount == 3 then
		return 10000;
	elseif jobCount == 4 then
		return 50000;
	elseif jobCount == 5 then
		return 100000;
	elseif jobCount == 6 then
		return 500000;
	elseif jobCount == 7 then
		return 1000000;
	elseif jobCount == 8 then
		return 10000000;
	end

	return 1000;
end

function GUILDHOUSE_OBJ_DIALOG_BUILDING(obj, pc, guildHouseObj, seedCls)

	local monCls = GetClass("Monster", seedCls.MonsterName);
	local modelName = monCls.Name;
	
	local menuList = {};
	if seedCls.ClassName == "ShieldCharger" then
		menuList[#menuList + 1] = "ChargeShield";	
	end

	menuList[#menuList + 1] = "Remove";	
	menuList[#menuList + 1] = "Close";
	local clMsgList = {};
	MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

	local priority = 3;
	local text = modelName .. "*@*" .. modelName;
	local select = ShowSelDlg_List(pc, priority, text, clMsgList);
	if select == nil then
		return;
	end
	
	
	local menuCmd = menuList[select];
	if menuCmd == "ChargeShield" then
		-- 길드원만 체크
		if IS_GUILDTOWER_MEMBER(pc) == false then
			SendSysMsg(pc, "ConfigedToUseGuildMemberOnly");
			return
		end
    
		local guildObj = GetGuildObj(pc);	
		if guildObj.Templer_BuildShieldCharger_Lv <= 0 then
			SendSysMsg(pc, "CannotDoAction");
			return;
		end

		local shieldValue = guildHouseObj:GetPropIValue("ShieldValue");
		if shieldValue > 0 then			
		
			-- 랭크별 최대치 체크
			local usableMaxShild = GET_USABLE_MAX_SHIELD(pc);			
			local curShiled = GetShield(pc);
			local addShiledValue = shieldValue;
			if curShiled + addShiledValue > usableMaxShild then
				addShiledValue = usableMaxShild - curShiled;
			end

			local objGuid = GetIESID(obj);
			local index = guildHouseObj:GetPropIValue("Index");
			local propName = "BuildingLife_" .. seedCls.ClassName .. '_' .. index;
			if guildObj[propName]  == 'None' then
				return;
			end

			if addShiledValue > 0 then
				local tx = TxBegin(pc);
				TxRemoveGuildHouseObject(tx, objGuid);
				TxSetPartyProp(tx, PARTY_GUILD, propName, 'None');
				local ret = TxCommit(tx);
				if ret == 'SUCCESS' then
					AddShield(pc, addShiledValue);
					SetGuildHouseObjectPropValue(obj, "ShieldValue", 0);
					AttachStringEffect(obj, "I_SYS_Text_Effect_NotMoving_LongTime", 0, 120);
				end
			else
				SendSysMsg(pc, "ChargeShieldIsFull");
			end

		else
			SendSysMsg(pc, "NotEnoughShield");
		end	

	elseif menuCmd == "Remove" then
		
		if IS_GUILDTOWER_MEMBER(pc) == false then
			SendSysMsg(pc, "ConfigedToUseGuildMemberOnly");
			return
		end

		menuList = {};
		menuList[#menuList + 1] = "Remove";	
		menuList[#menuList + 1] = "No";
		clMsgList = {};
		MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

		text = modelName .. "*@*" .. ClMsg("ReallyRemove?");
		local select = ShowSelDlg_List(pc, priority, text, clMsgList);
		if select == nil then
			return;
		end

		local menuCmd = menuList[select];
		if menuCmd == "Remove" then
			local objGuid = GetIESID(obj);
			local guildObj = GetGuildObj(pc);	

			local tx = TxBegin(pc);
			TxRemoveGuildHouseObject(tx, objGuid);
			local index = guildHouseObj:GetPropIValue("Index");
			local propName = "BuildingLife_" .. seedCls.ClassName .. '_' .. index;
			TxSetPartyProp(tx, PARTY_GUILD, propName, 'None');
			local ret = TxCommit(tx);	
		end
	end
end

function callback_return_to_nature(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                local obj = GetExArgObject(pc, argList[1])                
                Dead(obj)
                local tx = TxBegin(pc);
			    TxRemoveGuildHouseObject(tx, argList[1]);
			    local ret = TxCommit(tx)                
            end
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function callback_take_as_companion(pc, code, ret_json, argList)
    if code ~= 200 then        
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
        return
    end

    if ret_json == 'True' then
        if pc ~= nil then
            if GetGuildHouseIESID(pc) ~= GetGuildID(pc) then
		        SendSysMsg(pc, 'WebService_1') -- 권한 없음
		    else
                local obj = GetExArgObject(pc, argList[3])
                Dead(obj)
                local tx = TxBegin(pc);
			    TxAdoptPet(tx, tonumber(argList[1]), argList[2]);
			    TxRemoveGuildHouseObject(tx, argList[3]);
			    local ret = TxCommit(tx);
      
			    if ret == "SUCCESS" then                    
				    if argList[4] == "0" then
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
        end
    else
        SendSysMsg(pc, 'WebService_1') -- 권한 없음
    end
end

function GUILDHOUSE_OBJ_DIALOG_ANIMAL(obj, pc, guildHouseObj, seedCls)

	local age = guildHouseObj:GetPropIValue("Age");
	local waterValue = guildHouseObj:GetPropIValue("WaterValue");
	local fullGrowMin = seedCls.FullGrowMin;
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local modelName = monCls.Name;
	
	local menuList = {};
	if age >= fullGrowMin then
		menuList[#menuList + 1] = "TakeAsCompanion";	
	else
		if waterValue <= 0 then
			menuList[#menuList + 1] = "Remove";	
		else
			menuList[#menuList + 1] = "ReturnToNature";	
		end
	end

	menuList[#menuList + 1] = "Close";
	local clMsgList = {};
	MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

	local priority = 3;
	local text = modelName .. "*@*" .. modelName;
	local select = ShowSelDlg_List(pc, priority, text, clMsgList);
	if select == nil then
		return;
	end
	
	local menuCmd = menuList[select];
	if menuCmd == "ReturnToNature" or menuCmd == "Remove" then
		menuList = {};
		menuList[#menuList + 1] = menuCmd;	
		menuList[#menuList + 1] = "No";
		clMsgList = {};
		MAKE_MENU_VIEWMSG(partyObj, menuList, clMsgList);

		text = modelName .. "*@*" .. ClMsg("ReallyRemove?");
		local select = ShowSelDlg_List(pc, priority, text, clMsgList);
		if select == nil then
			return;
		end

		local nextMenuCmd = menuList[select];
		if nextMenuCmd == menuCmd then			
			local objGuid = GetIESID(obj);            
            local argList = {}
            argList[1] = tostring(objGuid)
            SetExArgObject(pc, argList[1], obj)
			CheckClaim(pc, 'callback_return_to_nature', 404, argList)
		end

	elseif menuCmd == "TakeAsCompanion" then

		local text = ScpArgMsg("InputCompanionName") .. "*@*" .. ScpArgMsg("InputCompanionName");
		local input = ShowTextInputDlg(pc, 0, text)

		if stringfunction.IsValidCharacterName(input) == true then
			local petCls = GetClass("Companion", seedCls.GetItem);
			local monCls = GetClass("Monster", petCls.ClassName);
			local petType = petCls.ClassID;
			local objGuid = GetIESID(obj);
			local haveCompanion = GetSummonedPet(pc, petCls.JobID);

            local argList = {}
            argList[1] = tostring(monCls.ClassID)
            argList[2] = tostring(input)
            argList[3] = tostring(objGuid)
            if haveCompanion == nil then
                argList[4] = "0"
            else
                argList[4] = "1"
            end
            SetExArgObject(pc, argList[3], obj)
            CheckClaim(pc, 'callback_take_as_companion', 404, argList)
		end
	end
end

function SCR_GUILD_HOUSE_OBJECT_DIALOG(obj, pc)

	local guildHouseObj = GetGuildHouseObject(obj);

	local clsName = guildHouseObj:GetPropValue("ClassName");
	local seedCls = GetClass("Seed", clsName);

	local objType = seedCls.ObjType;
	if objType == "Plant" then
		GUILDHOUSE_OBJ_DIALOG_PLANT(obj, pc, guildHouseObj, seedCls);
	elseif objType == "Animal" then
		GUILDHOUSE_OBJ_DIALOG_ANIMAL(obj, pc, guildHouseObj, seedCls);
	else
		GUILDHOUSE_OBJ_DIALOG_BUILDING(obj, pc, guildHouseObj, seedCls);
	end
	
end

function UPDATE_GUILD_BUILDING(pet, seedCls, pc)
	if nil ~= pc then
		local guildObj = GetGuildObj(pc);	
		UPDATE_GUILD_BUFF_BY_PROPERTY(pc, guildObj, 0)
	end

	local guildHouseObj = GetGuildHouseObject(pet);
	local waterValue = guildHouseObj:GetPropIValue("WaterValue");
	if waterValue == 0 then
		RemoveAndSaveGuildHouseObject(pet);
	end

end

function SHIELDCHARGER_UPDATE_DIGIT(pet, shieldValue)
	
	AttachStringEffect(pet, "I_SYS_Text_Effect_NotMoving_LongTime", shieldValue, 120);	

end

function UPDATE_GUILD_SHIELDCHARGER(pet, seedCls, pc)
	if nil ~= pc then
		sleep(2500);
	end

	local guildHouseObj = GetGuildHouseObject(pet);
	local waterValue = guildHouseObj:GetPropIValue("WaterValue");
	if waterValue == 0 then
		RemoveAndSaveGuildHouseObject(pet);
	else
		local shieldValue = guildHouseObj:GetPropIValue("ShieldValue");
		SHIELDCHARGER_UPDATE_DIGIT(pet, shieldValue);
	end

end

function SHIELDCHARGER_GROW_AGE(obj, elapsedMinute)

	local guildHouseObj = GetGuildHouseObject(obj);
	local shieldValue = guildHouseObj:GetPropIValue("ShieldValue");
	shieldValue = shieldValue + (elapsedMinute * 100);
	SetGuildHouseObjectProperty(obj, "ShieldValue", shieldValue);
	SHIELDCHARGER_UPDATE_DIGIT(obj, shieldValue);

end

function UPDATE_GUILD_PET(pet, seedCls)

	local guildHouseObj = GetGuildHouseObject(pet);
	local age = guildHouseObj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local ratio = CLAMP(age / maxGrowTime, 0, 1);
	local curScale = imc.GetBlend(0.8, 0.4, ratio);
	ChangeScale(pet, curScale, 1, 1, 1);

end

function GUILD_PET_FOOD_USE(self, itemType, monName, num1, num2) -- num2: foodGroup
	local pig = GET_GUILD_PET(self, itemType, num2);
	if pig == nil then
		return false;
	end
	
	DisableControlForTime(self, 6);
	local itemCls = GetClassByType("Item", itemType );
	RunScript("UPDATE_PET_FOOD", self, pig, "PET_ADD_WATER_VALUE");

	return true;
end

function GET_GUILD_PET(self, itemType, foodGroup)
	local x, y, z = GetFrontPos(self, 10);
	local range = 100;
	local pig = nil;
	local list, cnt = SelectObjectPos(self, x, y, z, range, 7, 0, 0, 1);
	for i = 1 , cnt do
		local obj = list[i];
		if GetObjType(obj) == OT_MONSTERNPC then
			local seedCls = GET_MONSTER_GUILDHOUSE_CLS(obj);
			if seedCls ~= nil and seedCls.ObjType == "Animal" then
				local guildHouseObj = GetGuildHouseObject(obj);
				local waterValue = guildHouseObj:GetPropIValue("WaterValue");
				if waterValue > 0 then
					pig = obj;
					break;
				end
			end
		end
	end
	-- item check
	if pig ~= nil then		
		local petCls = GetClassByStrProp("Companion", "ClassName", pig.ClassName)
		local clsFoodGroup = 0;
		if petCls ~= nil and petCls.FoodGroup ~= "None" then
			clsFoodGroup = tonumber(petCls.FoodGroup);
		end

		if petCls == nil or clsFoodGroup ~= foodGroup then
			pig = nil;
		end
	end

	return pig;
end

function PET_ADD_WATER_VALUE(pig)
	AddGuildHouseObjectPropValue(pig, "WaterValue", 2000);
end

function INIT_GUILD_FARM_PET(obj)

	obj.SimpleAI = "GuildFarmPet";


end

function GUILD_FARM_PET_AI(self, argNum)
	
	local guildHouseObj = GetGuildHouseObject(self);
	local waterValue = guildHouseObj:GetPropIValue("WaterValue");
	if waterValue <= 0 then
		PlayAnim(self, "KNOCKDOWN", 1, 1);
		-- HoldMonScp(self, 1);
		return 1;
	end
	if GetDistFromPos(self, self.CreateX, self.CreateY, self.CreateZ) > 10 then
        MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);
		return 1;
	end
	if IMCRandom(1, 2) == 1 then
		local angle = CalcRotateByAngle(self);
		SetDirectionByAngle(self, angle); --각도 돌리기
	else
	--RandomMove(self, 30);	
		local range = IMCRandom(20, 30);
		local x, y, z = GetFrontPos(self, range);
		MoveEx(self, x, y, z, 1);		
	end
	sleep(IMCRandom(5000, 10000));	
	return 1;
end

function TEST_GUILDOBJ(pc, propName, destValue)	

	local x, y, z = GetFrontPos(pc, 10);
	local range = 30;
	local list, cnt = SelectObjectPos(pc, x, y, z, range, 7, 0, 0, 1);
	for i = 1 , cnt do
		local obj = list[i];
		if GetObjType(obj) == OT_MONSTERNPC then
			local seedCls = GET_MONSTER_GUILDHOUSE_CLS(obj);
			if seedCls ~= nil then
				SetGuildHouseObjectPropValue(obj, propName, destValue);
				return;
			end
		end
	end

end

function GUILD_EXP_UP(pc, iesID, count)	
	
	local partyObj = GetGuildObj(pc);
	if partyObj == nil then
		return;
	end
    if partyObj.TowerLevel < 3 then
        return;
    end

--	local needItem, expPerItem = GET_GUILD_EXPUP_ITEM_INFO();
	local item, cnt = GetInvItemByGuid(pc, iesID);
	local itemGuildCheck = TryGetProp(item, "StringArg")
	if itemGuildCheck ~= "Guild_EXP" or count > cnt then
		SendSysMsg(pc, "REQUEST_TAKE_ITEM");
		return;
	end
	
	local expPerItem = TryGetProp(item, "NumberArg1")
	local curExp = partyObj.Exp;
	local addExp = count * expPerItem;
--	--EVENT_1805_GUILD
--	addExp =  math.floor(addExp * 1.2)
	
	local nextExp = curExp + addExp;
	local curLevel = partyObj.Level;
	local nextLevel = GET_GUILD_LEVEL_BY_EXP(nextExp);

	if curLevel >= GUILD_MAX_LEVEL then
		SendSysMsg(pc, "CantUseInMaxLv");
		return;
	end

	local teamName = GetTeamName(pc);
	local memberObj = GetMemberObjByPC(partyObj, pc);
	local currentContribution = memberObj.Contribution;
	currentContribution = currentContribution + addExp;

    local tx = TxBegin(pc);
	TxSetPartyMemberProp(tx, PARTY_GUILD, "Contribution", currentContribution)
	TxTakeItemByObject(tx, item, count, "GuildExpUp");
	TxSetPartyProp(tx, PARTY_GUILD, "Exp", nextExp);
	if curLevel ~= nextLevel then
		TxSetPartyProp(tx, PARTY_GUILD, "Level", nextLevel);
	end
   	local ret = TxCommit(tx);

	if ret == "SUCCESS" then
		SendSysMsg(pc, "GuildExpUpSuccessByItem");
	end

    --[[ 아래는 웹 전용 로직
    if curLevel ~= nextLevel then
		GuildExpUp(pc, currentContribution, item, count, nextExp, nextLevel);
    else
        GuildExpUp(pc, currentContribution, item, count, nextExp);
	end
    --]]
end

function LEARN_GUILD_ABILITY(pc, arg1)

	local partyObj = GetGuildObj(pc);
	if partyObj == nil then
		return;
	end    
    if partyObj.TowerLevel < 3 then
        return;
    end

	local abilCls = GetClassByType("Guild_Ability", arg1);
	if abilCls == nil then
		return;
	end

	local used = partyObj.UsedAbilStat;
	local current = GET_GUILD_ABILITY_POINT(partyObj);
	if current <= used then
		return;
	end

	if IsRunningScript(pc, "TX_LEARN_GUILD_ABILITY") == 1 then
		return;
	end
    RunScript("TX_LEARN_ABILITY", pc, arg1);
	--RunScript("TX_LEARN_ABILITY_BY_WEB", pc, arg1);

end

function LEARN_GUILD_SKL(pc, arg1)
	local guildObj = GetGuildObj(pc);
	if guildObj == nil then
		return;
	end
    local towerLevel = TryGetProp(guildObj, 'TowerLevel');
    if towerLevel == nil or towerLevel < 3 then
        return;
    end

	local isLeader = IsPartyLeaderPc(guildObj, pc);
	if isLeader == 0 then
		return;
	end

	local skl = GetSkill(pc, arg1)
	if nil == skl then
		return;
	end

	local level = TryGetProp(guildObj, arg1 .. '_Lv');
	if nil == level then
		level = 0;
	end
	
	if level > skl.Level then
		return;
	end

	if false == HAS_GUILDGROWTH_SKL_OBJ(guildObj, arg1, skl.Level) then
		return;
	end

	local level = math.min(skl.Level, 5);
	ChangePartyProp(pc, PARTY_GUILD, skl.ClassName .. '_Lv', tonumber(level));
end

function TX_LEARN_ABILITY(pc, arg1)        
	local abilCls = GetClassByType("Guild_Ability", arg1);
	if abilCls == nil then
		return;
	end

	local partyObj = GetGuildObj(pc);
	local used = partyObj.UsedAbilStat;
	used = used + 1;
	local curAbilityName = "AbilLevel_" .. abilCls.ClassName;
	local curAbilityLevel = partyObj[curAbilityName];
	curAbilityLevel = curAbilityLevel + 1;

	if curAbilityLevel > abilCls.MaxLevel then
		SendSysMsg(pc, "AbilityLevelMax");
		return
	end

	local tx = TxBegin(pc);	
	TxSetPartyProp(tx, PARTY_GUILD, "UsedAbilStat", used);
	TxSetPartyProp(tx, PARTY_GUILD, curAbilityName, curAbilityLevel);
   	local ret = TxCommit(tx);	
end

function TX_LEARN_ABILITY_BY_WEB(pc, arg1)
	local abilCls = GetClassByType("Guild_Ability", arg1);
	if abilCls == nil then
		return;
	end

	local partyObj = GetGuildObj(pc);
	local used = partyObj.UsedAbilStat;
	used = used + 1;
	local curAbilityName = "AbilLevel_" .. abilCls.ClassName;
	local curAbilityLevel = partyObj[curAbilityName];
	curAbilityLevel = curAbilityLevel + 1;

	if curAbilityLevel > abilCls.MaxLevel then
		SendSysMsg(pc, "AbilityLevelMax");
		return
	end

    -- 여기서 웹요청 bind function
    local abil_class_id = arg1
    GuildAbilityLevelUp(pc, tonumber(abil_class_id), "UsedAbilStat", used, curAbilityName, curAbilityLevel)
end


function SKL_CHECK_NEAR_GUILDTOWER(self, skl)   
	local partyObj = GetGuildObj(self);
	if partyObj == nil then	
		SendSysMsg(self, "GuildAvailable");
		return 0;
	end
	local isLeader = IsPartyLeaderPc(partyObj, self);
	if isLeader == 0 then
		SendSysMsg(self, "OnlyGuildLeader");
		return 0;
	end
	local pcGuildID = GetGuildID(self);
	local exist = 0;
	local list, cnt = SelectObjectByProp(self, 100, "Dialog", "GUILD_TOWER");
    for i = 1, cnt do
		local tower = list[i];
		local guildID = GetIESID(tower);
		if guildID == pcGuildID then
			exist = 1;
		end
	end
    
    local zoneName = GetZoneName(self)
    if zoneName ~= nil then
        if zoneName == "guild_agit_1" then
            return 1
        end
    end
    
	if exist == 0 and IsVillage(self) == "NO" then
		SendSysMsg(self, "CanUseGuildtower");
		return 0;
	end

	return 1;
end

function INIT_DECREASE_CRAFT_FLAG(self, owner, skl)
    AttachEffect(self, "F_warrior_ReduceCraftTime_ground", 5.0, "BOT")
	SetOwner(self, nil);
	local pcGuildID = GetGuildID(owner);
	SetExProp_Str(self, "GUILDID", pcGuildID);
	SetExProp(self, "SkillLevel", skl.Level);
	SetExProp(self, "DestroyTime", imcTime.GetAppTime() + 600);
	RunScript("SHOW_CRAFT_FLAG_REMAIN_TIME", self);

end

function SHOW_CRAFT_FLAG_REMAIN_TIME(self)

	while 1 do
		local destroyTime = GetExProp(self, "DestroyTime");
		local remainSec = math.floor(destroyTime - imcTime.GetAppTime());
		local min = math.floor(remainSec / 60);
		local sec = remainSec % 60;
		local remainSecStr = string.format("%02d:%02d", min, sec);
		BroadcastStringEffect(self, "I_SYS_Text_Effect_NotMoving", remainSecStr, 3);

		sleep(1000);

		if remainSec <= 0 then
			Dead(self);
			return;
		end
	end

end

function SCR_DECREASE_CRAFT_ENTER(self, pc)
    
	local guildID = GetExProp_Str(self, "GUILDID");
	local pcGuildID = GetGuildID(pc);
	if pcGuildID == guildID then
		local level = GetExProp(self, "SkillLevel");
		AddBuff(self, pc, "ReduceCraftTime_Buff", level, 0, 0, 0);
	end
	
end

function SCR_DECREASE_CRAFT_LEAVE(self, pc)

	RemoveBuff(pc, "ReduceCraftTime_Buff");
	
end

function GUILDEVENT_JOIN_TX(pc)
	local guildObj = GetGuildObj(pc);
    local eventID = GetGuildEventID(guildObj)

    local eventState = GetGuildEventState(guildObj);
    if eventState ~= "Recruiting" then
        return;
    end

    local isParticipated = IsGuildEventParticipant(pc)
    if isParticipated == true then
        return;
    end
    
    local ret = AddGuildEventParticipant(pc);
    if ret == 1 then
        SendAddOnMsg(pc, 'GUILD_EVENT_RECRUITING_IN');
        GuildEventMongoLog(pc, eventID, "Register")
    end
	
end


function SCR_GUILDEVENT_JOIN(pc)
    if IS_IN_EVENT_MAP(pc) == true then
        SendSysMsg(pc, 'ImpossibleInCurrentMap');
        return;
    end

	RunScript("GUILDEVENT_JOIN_TX", pc);
end

function GUILDEVENT_REFUSAL_TX(pc)
	local guildObj = GetGuildObj(pc);

    local eventState = GetGuildEventState(guildObj);
    if eventState ~= "Recruiting" then
        return;
    end

    local isParticipated = IsGuildEventParticipant(pc)
    if isParticipated == 1 then
        return;
    end

    RemoveGuildEventParticipant(pc);
    SendAddOnMsg(pc, 'GUILD_EVENT_RECRUITING_OUT');
end

function SCR_GUILDEVENT_REFUSAL(pc)
	RunScript("GUILDEVENT_REFUSAL_TX", pc);
end

function GUILDTOWER_TAKEDAMAGE(self, from, skl, damage, ret)

	if IS_PC(from) then
		if 1 == FOR_EACH_TIME(self, "_TOWER_MSG", 30) then
			local partyObj = GetGuildObj(from);
			if partyObj ~= nil then
				local partyName = GetPartyName(partyObj);
				local msg = ScpArgMsg("GuildTowerUnderAttackFrom{Name}Guild", "Name", partyName);
				local monPartyID = GetMonsterPartyID(self, PARTY_GUILD);
				BroadcastToPartyMember(PARTY_GUILD, monPartyID, msg, "");
			end	
		end
	end
end

function GUILDTOWER_DEAD(self)

	local partyName = "None";
	local from = GetKiller(self);
	if from == nil then
		from = GetLastAttacker(self);
	end

	if from ~= nil then
		local partyObj = GetGuildObj(from);
		if partyObj ~= nil then
			partyName = GetPartyName(partyObj);
			local objGuid = GetIESID(self);
			local partyObj, towerGuildName = GetPartyObjByIESID(PARTY_GUILD, objGuid);			
			if towerGuildName ~= nil then						
				local msg = ScpArgMsg("{Name1}GuildDestroyedGuildTowerOf{Name2}", "Name1", partyName, "Name2", towerGuildName);
				BroadcastToAllServerPC(1, msg, "");
			end
		end	
	end

	local monPartyID = GetMonsterPartyID(self, PARTY_GUILD);
	local sysTime = GetDBTime();
	local stringSysTime = imcTime.GetStringSysTime(sysTime);
	ChangePartyPropByPartyID(PARTY_GUILD, monPartyID, "HousePosition", "Destroyed#" .. partyName .. "#" .. stringSysTime);
	OnDestroyGuildTower(from, PARTY_GUILD, monPartyID);

end

function GUILD_MEMBER_DEAD(self)

	local from = GetKiller(self);
	if from == nil then
		from = GetLastAttacker(self);
	end

	if from == nil then
		return;
	end

	from = GetTopOwner(from);
	if IS_PC(from) == false then
		return;
	end

	local fromGuildID = GetGuildID(from);
	local guildID = GetGuildID(self);
	if fromGuildID == "0" or guildID == "0" then
		return;
	end

	local isEnemyParty = IsEnemyParty(PARTY_GUILD, guildID, fromGuildID);
	local guild = GetGuildObj(self);
	local fromGuild = GetGuildObj(from);
	local guildName = GetPartyName(guild);
	local fromGuildName = GetPartyName(fromGuild);

	local killMsg = ScpArgMsg("GuildMember{Name}Killed{Target}OfGuild{TargetGuild}", "Name", GetTeamName(from), "Target", GetTeamName(self), "TargetGuild", guildName);
	BroadcastToPartyMember(PARTY_GUILD, fromGuildID, killMsg, "{#FFFFFF}");

	local killedMsg = ScpArgMsg("GuildMember{Name}HasKilledBy{From}OfGuild{FromGuild}", "Name", GetTeamName(self), "From", GetTeamName(from), "FromGuild", fromGuildName);
	BroadcastToPartyMember(PARTY_GUILD, guildID, killedMsg, "");

	PVPMongoLogo(self, "War", "Killer", from, guildID, fromGuildID); 
	PVPMongoLogo(from, "War", "DeadPerson", self, fromGuildID, guildID); 
end


function PRE_CHECK_GUILD_AUTHORITY_STRING(pc)
	local guildObj = GetGuildObj(pc);

	if guildObj == nil then
		return;
	end
end

function GUILD_MEMBER_AUTHORITY_CHANGE(pc, aid, flag, checkValue)
	local guildObj = GetGuildObj(pc);
	
	--aid = GetPcAIDStr(pc);
	--flag = AUTHORITY_GUILD_INVITE
	--AUTHORITY_GUILD_BAN
	
	if guildObj == nil then
		return;
	end
	
	local isLeader = IsPartyLeaderPc(guildObj, pc);
	if isLeader == 0 then
		return;
	end
	
	--guildObj.GuildAuthority_1

	local aidPropName = "None";
	local bitFlagPropName = "None";
	local index = 1;

	for i = 1, 40 do
		propName = "GuildAuthority_"..i;
		bitFlagPropName = "GuildAuthorityBitFlag_"..i;
		local propValue = guildObj[propName];
		if propValue ~= "None" then
			local firstIndex, lastIndex = string.find(propValue, aid)
			if firstIndex ~= nil then
				--구버전을 신버전으로 만들기 위한 로직과 신버전 로직이 동시에 존재합니다.
				local findPipe = string.find(propValue, "|");
				--파이프가 발견되었다는건 구버전 로직으로 저장된 데이터가 있다는 것.
				--구버전 데이터를 신버전으로 넣어주자.
				if findPipe ~= nil then
					local sList = StringSplit(propValue, "|");
					if sList ~= nil then
						local aid = sList[1];
						local bitValue = sList[2];
						local setBitFlag = 0;
						if checkValue == 1 then 
							setBitFlag = OnBitFlag(bitValue, flag);
						else
							setBitFlag = OffBitFlag(bitValue, flag);
						end
						ChangePartyProp(pc, PARTY_GUILD, propName, aid);
						ChangePartyProp(pc, PARTY_GUILD, bitFlagPropName, setBitFlag);
						break;
					end
				else
				--신버전 데이터를 넣어주자.
				local setBitFlag = 0;
					local bitValue = guildObj[bitFlagPropName];
				if checkValue == 1 then 
						setBitFlag = OnBitFlag(bitValue, flag);
				else
						setBitFlag = OffBitFlag(bitValue, flag);
				end
					ChangePartyProp(pc, PARTY_GUILD, propName, aid);
					ChangePartyProp(pc, PARTY_GUILD, bitFlagPropName, setBitFlag);
				break;
			end
			end
		else
			local setBitFlag = 0;
			local bitValue = guildObj[bitFlagPropName];
			if checkValue == 1 then 
				setBitFlag = OnBitFlag(bitValue, flag);
			else
				setBitFlag = OffBitFlag(bitValue, flag);
			end
			ChangePartyProp(pc, PARTY_GUILD, propName, aid);
			ChangePartyProp(pc, PARTY_GUILD, bitFlagPropName, setBitFlag);
			break;
		end
	end
end

function IS_GUILD_AUTHORITY_SERVER(pc, flag)

	local guildObj = GetGuildObj(pc);
	local aid = GetPcAIDStr(pc);
	
	if guildObj == nil then
		return 0;
	end

	for i = 1, 40 do
		local propName = "GuildAuthority_"..i;
		local propValue = guildObj[propName];
	
		if propValue ~= "None" then
			local firstIndex, lastIndex = string.find(propValue, aid)
			if firstIndex ~= nil then
				local findPipe = string.find(propValue, "|");

				if findPipe ~= nil then
				local bitValue = string.sub(propValue, lastIndex + 2, string.len(propValue))
				return CheckBitFlag(bitValue, flag)
				else
					local bitFlagPropName = "GuildAuthorityBitFlag_"..i;
					local bitValue = guildObj[bitFlagPropName];
					return CheckBitFlag(bitValue, flag)
				end
			end
		end
	end

	return 0;
end


function IS_GUILD_AUTHORITY_RESET(pc, aid)

	local guildObj = GetGuildObj(pc);
	
	if guildObj == nil then
	end

	for i = 1, 40 do
		local propName = "GuildAuthority_"..i;
		local propValue = guildObj[propName];
	
		if propValue ~= "None" then
			local firstIndex, lastIndex = string.find(propValue, aid)
			if firstIndex ~= nil then
				local bitFlagPropName = "GuildAuthorityBitFlag_"..i;
				ChangePartyProp(pc, PARTY_GUILD, propName, "None");
				ChangePartyProp(pc, PARTY_GUILD, bitFlagPropName, 0);
			end
		end
	end
end

function TEST_SUBSUB(pc)
	local guildObj = GetGuildObj(pc);

	for i = 1, 40 do
		local propName = "GuildAuthority_"..i;
		local bitFlagPropName = "GuildAuthorityBitFlag_"..i;
		if guildObj[propName] ~= "None" then
		end
	end
end

function SCR_DEPOSIT_GUILD_ASSET(pc, money)
    if IsRunningScript(pc, 'TX_DEPOSIT_GUILD_ASSET_BY_WEB') == 1 then
        return;
    end
    TX_DEPOSIT_GUILD_ASSET_BY_WEB(pc, money);
end

function TX_DEPOSIT_GUILD_ASSET(pc, money)
    if money < 1 then
        return;
    end
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return;
    end
    local currentAsset = TryGetProp(guildObj, 'GuildAsset');
    if currentAsset == nil then
        IMC_LOG('ERROR_DATA_NULL', 'SCR_DEPOSIT_GUILD_ASSET: GuildAsset property is null! Plz check guild.xml');
        return;
    end
    if currentAsset == 'None' then -- 실버 관련 아주 큰 값이 입력될 가능성이 있어서 문자형으로 선언했음
        currentAsset = 0;
    end
    local pcMoney, cnt = GetInvItemByName(pc, MONEY_NAME);
    if pcMoney == nil or cnt < money then -- 돈없으면 ㄴㄴ해
        return;
    end

	--맥시멈값 못넣어요
    local sumStr = SumForBigNumber(money, currentAsset);
	if IsGreaterThanForBigNumber(sumStr, MAX_GUILD_ASSET_DEPOSIT_AMOUNT) == 1 then
		return;
	end

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxTakeItem(tx, MONEY_NAME, money, 'GuildAsset');    
    TxSetIESProp(tx, guildObj, 'GuildAsset', sumStr);
    TxGuildAssetDepositLog(tx, money, sumStr);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'UPDATE_GUILD_ASSET');
        SendPartyProp(pc, PARTY_GUILD, 'GuildAsset');
        return;
    end
    IMC_LOG('ERROR_TX_FAIL', 'SCR_DEPOSIT_GUILD_ASSET: cur['..currentAsset..'], add['..money..'], sum['..sumStr..']');
end

function TX_DEPOSIT_GUILD_ASSET_BY_WEB(pc, money)    
    if money < 1 then
        return;
    end
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return;
    end
    local currentAsset = TryGetProp(guildObj, 'GuildAsset');
    if currentAsset == nil then
        IMC_LOG('ERROR_DATA_NULL', 'SCR_DEPOSIT_GUILD_ASSET: GuildAsset property is null! Plz check guild.xml');
        return;
    end
    if currentAsset == 'None' then -- 실버 관련 아주 큰 값이 입력될 가능성이 있어서 문자형으로 선언했음
        currentAsset = 0;
    end
    local pcMoney, cnt = GetInvItemByName(pc, MONEY_NAME);
    if pcMoney == nil or cnt < money then -- 돈없으면 ㄴㄴ해    
        return;
    end

	--맥시멈값 못넣어요
    local sumStr = SumForBigNumber(money, currentAsset);
	if IsGreaterThanForBigNumber(sumStr, MAX_GUILD_ASSET_DEPOSIT_AMOUNT) == 1 then    
		return;
	end
    
    DepositGuildAsset(pc, MONEY_NAME, money, sumStr, guildObj)
end

function TX_GUILD_NEUTRALITY_ALARM(pc, isOn)
    if pc == nil then
        return;
    end
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return;
    end
    local beforeValue = TryGetProp(guildObj, 'GuildNeutralityAlarm');
    if beforeValue == nil then
        IMC_LOG('ERROR_DATA_NULL', 'SCR_DEPOSIT_GUILD_ASSET: GuildNeutralityAlarm property is null! Plz check guild.xml');
        return;
    end
    if beforeValue == isOn then -- 이미 같은 값임
        return;
    end

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxSetIESProp(tx, guildObj, 'GuildNeutralityAlarm', isOn);
    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        SendAddOnMsg(pc, 'GUILD_NEUTRALITY_ALARM_FAIL');
    end
end

function SCR_UPDATE_GUILD_TOWER_LEVEL(pc)
    if IsRunningScript(pc, 'TX_UPDATE_GUILD_TOWER_LEVEL') ~= 1 then
        _UPDATE_GUILD_TOWER_LEVEL(pc);
    end
end

function _UPDATE_GUILD_TOWER_LEVEL(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return;
    end

    local pcGuildID = GetGuildID(pc);
    local guild = GetPartyObjByIESID(PARTY_GUILD, pcGuildID);    
    if IsPartyLeaderPc(guild, pc) == 0 then    
        return;
    end

    local jobHistoryStr = GetJobHistoryString(pc);
    if string.find(jobHistoryStr, 'Char1_16') == nil then    
        return;
    end

    local guildTowerSkl = GetSkill(pc, 'Templer_BuildGuildTower');
    local currentTowerLevel = TryGetProp(guildTowerSkl, 'Level');
    if guildTowerSkl == nil or currentTowerLevel == nil then
        SendSysMsg(pc, 'NotExistGuildTowerSkill');
        return;
    end
    
    ChangePartyProp(pc, PARTY_GUILD, "TowerLevel", currentTowerLevel);
end

function TX_GIVE_GUILD_CONTRIBUTION(pc, addContribution)    
	local guildObj = GetGuildObj(pc);
	if guildObj == nil then
		return;
	end
	
	local memberObj = GetMemberObjByPC(guildObj, pc);
	local currentContribution = memberObj.Contribution;
	currentContribution = currentContribution + addContribution;
	local tx = TxBegin(pc);
	TxSetPartyMemberProp(tx, PARTY_GUILD, "Contribution", currentContribution);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then        
        return;
    end
    IMC_LOG('ERROR_TX_FAIL', 'TX_GIVE_GUILD_CONTRIBUTION: aid['..GetPcAIDStr(pc)..'], addValue['..addContribution..']');
end

function IS_UNIQUE_TEMPLER_GUILD_MASTER(pc)
    local guildObj = GetGuildObj(pc);
    if guildObj == nil then
        return false;
    end

    if IsPartyLeaderPc(guildObj, pc) == 1 then
        local templerCls = GetClass('Job', 'Char1_16');
        local jobHistoryStr = GetJobHistoryString(pc);
        if string.find(jobHistoryStr, 'Char1_16') == nil then    
            return false;
        end
                
        local myName = GetName(pc);
        local charList = GetCharacterNameList(pc);
        for i = 1, #charList do
            local charName = charList[i];
            if charName ~= myName then                
                local jobString = GetCharacterJobHistoryString(pc, charName);                    
                local jobList = StringSplit(jobString, ';');
                for j = 1, #jobList do                    
                    if jobList[j] == 'Char1_16' then                        
                        return false;
                    end
                end
            end
        end
        return true;
    end
    return false;
end

function _GUILD_EXP_UP(pc, argList, currentCount)
    CheckClaim(pc, 'callback_guild_exp_up', 12, argList) -- code:12 (길드성장)
	--RunScript("GUILD_EXP_UP", pc, argList[1], currentCount);    
end

-- plz nil check param(pc, guild_obj)
function CREATE_GUILD_SUCCESS_FOR_EVENT(pc, guild_obj)
--    if pc ~= nil and guild_obj ~= nil then
--       -- to do
--       local aObj = GetAccountObj(pc)
--       if aObj ~= nil then
--           if aObj.EVENT_1805_GUILD_CARD_COUNT == 0 then
--               local tx = TxBegin(pc)
--               TxSetIESProp(tx, aObj, 'EVENT_1805_GUILD_CARD_COUNT', 1)
--               TxGiveItem(tx, 'EVENT_1805_GUILD_CARD_LV4', 1, 'EVENT_1805_GUILD_CARD')               
--               local ret = TxCommit(tx)
--           end
--       end
--    end
end

-- 길드를 생성했지만, 길드를 생성한 pc의 정보를 얻어오지 못해, CREATE_GUILD_SUCCESS_FOR_EVENT 를 실행할 수 없을 경우,
-- 아래 function 이 실행됩니다. 이벤트 아이템 지급이 실패한 경우이기 때문에, 여기서 로그를 남겨서 운영팀에서 대응할 수 있게 해주세요.
function CREATE_GUILD_NOTICE_FAIL_FOR_EVENT(pc_aid)
end