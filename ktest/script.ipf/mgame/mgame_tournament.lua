--- mgame_tournament.lua

function MGAME_TOURNAMENT(cmd, pcCnt, observeGang, mGameName)
	cmd:MakeTournamentByElo(pcCnt, observeGang, mGameName);
end

function M_TOURNA_START(cmd, curStage, eventInst, obj)

	print("STAR TTOURNAM");
	cmd:StartTournamentMatch();
end

function M_TOURNA_RESULT(cmd, curStage, eventInst, obj, winTeam)
	cmd:TournamentResult(winTeam);
end

function M_TOURNA_SHOW_RESULT(cmd, curStage, eventInst, obj, winTeam)
	cmd:ShowTournamentResult(winTeam);
end

function TOURNAMENT_GET_ELO(pc)
	return 10;
end

function M_TOURNA_SET_INFO_UI(cmd, curStage, eventInst, obj, isOn)
	
	SetLayerEnterFunc(cmd:GetZoneInstID(), cmd:GetLayer(), "SEND_TOURNA_PC_UI", isOn);
	SetLayerLeaveFunc(cmd:GetZoneInstID(), cmd:GetLayer(), "CLOSE_TOURNA_PC_UI", isOn);		
		
	local list, cnt = GetLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer());
	for i = 1 , cnt do
		local pc = list[i];
		_SEND_TOURNA_PC_UI(pc, cmd:GetZoneInstID(), cmd:GetLayer(), isOn);
	end

end

function MGAME_PVP_PC_POS_ADJUST(cmd, curStage, eventInst, obj, area, x, y, z)

	local list, cnt = GetLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer());
	for i = 1 , cnt do
		local pc = list[i];
		local teamID = GetTeamID(pc);
		if teamID > 0 then
			local isOut = IsInBGEventArea(pc, area);
			if isOut == 0 then
				SetPos(pc, x ,y, z);
			end
		end
	end
end

function MGAME_PVP_POINT_GIVE(cmd, curStage, eventInst, obj, point)
	
	local list, cnt = GetLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer());
	for i = 1 , cnt do
		local pc = list[i];
		if pc ~= nil then
		    RunScript('TX_PVP_POINT_GIVE', pc, point)
		end
	end	
end

function TX_PVP_POINT_GIVE(pc, point)
		local tx = TxBegin(pc);
		TxAddWorldPVPProp(tx, "ShopPoint", point);
		local ret = TxCommit(tx);
end

function MGAME_PVP_POINT_GIVE_UPHILL(cmd, curStage, eventInst, obj)
	
	local list, cnt = GetLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer());
	for i = 1 , cnt do
		local pc = list[i];
		if pc ~= nil then
		    RunScript('TX_PVP_POINT_GIVE_UPHILL', pc)
		end
	end	
end

function TX_PVP_POINT_GIVE_UPHILL(pc)
	local cmd = GetMGameCmd(pc)
	if cmd ~= nil then
    	local step = cmd:GetUserValue("UphillStep") -1
    	local point
    	
    	if step ~= nil then
    	    if step == 30 then -- 30 stage all clear
    	        point = 90
    	    elseif (step <= 29 and step > 25) then -- 25~29 stage clear
    	        point = 75
    	    elseif (step <= 25 and step > 20) then -- 21~25 stage clear
    	        point = 60
    	    elseif (step <= 20 and step > 15) then -- 16~20 stage clear
    	        point = 45
    	    elseif (step <= 15 and step > 10) then -- 11~15 stage clear
    	        point = 30
    	    elseif (step <= 10 and step > 5) then -- 6~10 stage clear
    	        point = 15
    	    elseif step <= 5 then -- under 5 stage clears
    	        point = step * 2
    	    end

			local tx = TxBegin(pc);
			TxEnableInIntegrate(tx)
			TxAddWorldPVPProp(tx, "ShopPoint", point);
			local ret = TxCommit(tx);

			if ret == 'SUCCESS' then
			    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("MISSION_UPHILL_PVPPOINT","STEP",step,"POINT",point),10)
			end
        end
    end
end

function _SEND_TOURNA_PC_UI(self, instID, layer, isOn)
	local list, cnt = GetLayerPCList(instID, layer);
	for i = 1 , cnt do
		local pc = list[i];
		if string.find(GetCurrentFaction(pc), "Team_") ~= nil then
			if isOn == 1 then
				SendPropertyInfo(self, pc, 0);
				RunTargetPCUIFunc(self, pc, "OPEN_TNMT_COMPARE", GetCurrentFaction(pc));
			else
				RunTargetPCUIFunc(self, pc, "CLOSE_TNMT_COMPARE", GetCurrentFaction(pc));
			end

		end
	end	

	UIOpenToPC(self, 'tournament_view', isOn);
end

function SEND_TOURNA_PC_UI(self, layer)

	if GetObjType(self) ~= OT_PC then
		return;
	end

	local instID = GetZoneInstID(self);
	_SEND_TOURNA_PC_UI(self, instID, layer, 1);
end

function CLOSE_TOURNA_PC_UI(self, layer)

	if GetObjType(self) ~= OT_PC then
		return;
	end

	local instID = GetZoneInstID(self);
	_SEND_TOURNA_PC_UI(self, instID, layer, 0);
end


function RUN_TOURNAMENT_GIFT(from, to, type, mGameName)
	
	local cls = GetClassByType("Tournament_Gift", type);
	if cls == nil then
		return;
	end

	local maxDist = 250;
	local dist = GetDistance(from, to);
	if dist >= maxDist then
		dist = maxDist;
	end

	local angle = GetAngleTo(from, to);
	angle = angle + IMCRandom(-20, 20);
	local x, y, z = GetPos(from);
	local ax, az = GetXZFromDistAngle(dist, angle);
	x = x + ax;
	z = z + az;
	x, y, z = GetRandomPos(from, x, y, z, 20);
		
	local itemClsName = cls.ClassName;
	if cls.RandomCnt > 0 then
		local randIndex = IMCRandom(1, cls.RandomCnt);
		if randIndex > 1 then
			itemClsName = itemClsName .. "_" .. randIndex;
		end
	end

	local itemCls = GetClass("Item", itemClsName);
	if itemCls == nil then
		return;
	end

	local tx = TxBegin(from);
	TxTakeItem(tx, 'Vis', itemCls.Price, "TournamentGift");
	TxAddAchievePoint(tx, "TournamentGift", 1);


	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		return;
	end

	--local name = ScpArgMsg("GiftFrom{Giver}To{Target}", "Giver", from.Name, "Target", to.Name);
	local name = "";
	local monType = geItemTable.GetItemMonster(itemCls.ClassID);
    local dropIES = CreateGCIESByID('Monster', monType);
	dropIES.Tactics = "None";
	dropIES.BTree = "None";
	dropIES.ItemCount = 0;
	dropIES.Name = name;
	local fx, fy, fz = GetPos(from);
	local itemObj = CREATE_ITEM(nil, dropIES, from, fx, fy, fz, 0, 1);

	ShootObjForce(itemObj, x, y, z, 200, 1800);
	SkillTextEffect(nil, to, from, "SHOW_TOURNA_GIFT", 1);
	ITEM_AUTO_ZOMBIE(itemObj, 60 * 1000);

	if mGameName == nil then
		return;
	end

	if cls.GiftPoint > 0 then
		local propName = "MG_Gift_" .. mGameName;
		local etc = GetETCObject(to);
		if GetPropType(etc, propName) == nil then
			return;
		end

		tx = TxBegin(to);
		TxAddIESProp(tx, etc, propName, cls.GiftPoint);
		local ret = TxCommit(tx);
	end

	SendAddOnMsg(from, 'GIVE_ITEM_COMPLETE', 'None', 0);
	
end

function ITEM_AUTO_ZOMBIE(itemObj, ms)
	sleep(ms);
	SetZombie(itemObj);
end

function GET_TOURNAMENT_REWARD(pc, name, gang, gameSec, reward)
	local expValue = 20000 + gameSec * 2 - (2000 * gang);
	local moneyCnt = 10000 + gameSec * 2 - (2000 * gang);
	
	if gang == 0 then -- winner
		expValue = expValue * 1.5;
		moneyCnt = moneyCnt * 1.5;
	end

	--reward.exp = expValue;
	reward.exp = 0;
	reward:AddItem(MONEY_NAME, moneyCnt);
end

