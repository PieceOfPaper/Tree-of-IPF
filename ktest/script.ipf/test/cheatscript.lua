function RESET_PARTY_MISSION(pc)

	local partyObj = GetPartyObj(pc);
	
	local clsList, cnt = GetClassList("PartyMission");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local propName = "M_" .. cls.ClassID;
		ChangePartyProp(pc, PARTY_NORMAL, propName, 0);
	end
	

end

function TEST_SERVPOS(pc, handle)

	local zoneInst = GetZoneInstID(pc);	

	while 1 do
	
		local mon = GetByHandle(zoneInst, handle);
		if mon == nil then
			break;
		end
		
		SendTestSPos(pc, mon);
		local x, y, z = GetPos(mon);
		local as = GetActionState(mon);
		local ms = GetMoveState(mon);
		Chat(mon, string.format("%d %d %d %s %s %s", x, y, z, as, ms, GetBodyState(mon)));
		
		sleep(50);
	end
	
end

function TEST_BTREE(pc, handle)

	local zoneInst = GetZoneInstID(pc);	

	while 1 do
	
		local mon = GetByHandle(zoneInst, handle);
		if mon == nil then
			break;
		end
		
		SendBTree(pc, mon);
		sleep(500);
	end
	
end

function IS_SUPER_DROP_MON(self)

	local buf = GetBuffByName(self, "SuperDrop");
	if buf == nil then
		return 0.0;
	end
	
	return 1;	

end

function FSD(pc)
	
	local mon = GetMonByScp(pc, "IS_SUPER_DROP_MON");
	if mon ~= nil then
		local x, y, z = GetPos(mon);
		SetPos(pc, x, y, z);
	end

end

function TEST_GET_IF_ITEM(pc)
   local itemList, cnt = GetClassList('Item')
   local getItemList = {};

   for i = 0, cnt - 1 do
       local itemCls = GetClassByIndexFromList(itemList, i);
       local legendGroup = TryGetProp(itemCls, 'LegendGroup')
       if  legendGroup == 'Velcoffer' then
           getItemList[#getItemList +1] = itemCls.ClassName
           print(getItemList[#getItemList])
           end
       end

    local tx = TxBegin(pc);
       for i = 1, #getItemList do
   	TxGiveItem(tx, getItemList[i] , 1, 'd');
   end
   local ret = TxCommit(tx);

end

function TEST_ALARM_MSG(pc)  
  ExecClientScp(pc, 'TEST_ALARM()');
end