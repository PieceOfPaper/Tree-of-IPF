
function INTE_WARP_SERVER(pc, nowmapName, mapName, warpcost, toPrevPos)
--    warpcost = 0      --EV161110
	if warpcost < 0 then
		warpcost = 0
	end

	local isFree = GetExProp(pc, "WarpFree");
	if isFree == 1 then
		warpcost = 0;
	end
	
	if nowmapName == 'c_Klaipe' or nowmapName == 'c_orsha' then
	    if nowmapName == 'c_Klaipe' then
	        if mapName == 'c_orsha' then
	            warpcost = 0
	        end
	    else
	        if mapName == 'c_Klaipe' then
	            warpcost = 0
	        end
	    end
	end

	local etc = GetETCObject(pc);

	local dest_mapName = mapName;
	local sObj_main = GetSessionObject(pc, 'ssn_klapeda');
	local result = SCR_GET_XML_IES('camp_warp', 'City', city)
	local campwarpclslist = SCR_GET_XML_IES('camp_warp', 'Zone', dest_mapName)
	if toPrevPos == 0 and campwarpclslist ~= nil and #campwarpclslist > 0 then
		local campwarpclsname = campwarpclslist[1].ClassName;

		local warppoint = SCR_GET_MONGEN_ANCHOR(dest_mapName, 'Dialog',campwarpclsname)                
		if warppoint ~= nil and sObj_main[campwarpclsname] == 300 then
      
			local zone_ClassName = dest_mapName;                    
			local posX = warppoint[1].PosX
			local posY = warppoint[1].PosY + 30
			local posZ = warppoint[1].PosZ
                    
            --[[        
			if IMCRandom(1,2) == 1 then
				posX = posX + IMCRandom(40,60)
			else
				posX = posX - IMCRandom(40,60)
			end
                    
			if IMCRandom(1,2) == 1 then
				posZ = posZ + IMCRandom(40,60)
			else
				posZ = posZ - IMCRandom(40,60)
			end
			]]

			--[[ ���̾� �Ҹ�
			local tx = TxBegin(pc);
			local aobj = GetAccountObj(pc);
			TxAddIESProp(tx, aobj, "Medal", -warpcost);
			local ret = TxCommit(tx);
			]]


			-- �̵������ֱ� ���� �ǹ� üũ�ϰ� MoveZone ���Ŀ� ���� ����!
			-- �ǹ� �Ҹ� �ٽ� ��Ȱ. 140911
			local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
			if pcMoney == nil then
			    pcMoney = 0
			end
			if pcMoney == nil or cnt < warpcost then
				SendSysMsg(pc, "NotEnoughMoney");	
				return;
			end

			local statue = GetExArgObject(pc, "VAKARINE_WARP_OBJ");
			--	SetExProp(pc, "VAKARINE_WARP", 1);
			if GetExProp(pc, "VAKARINE_WARP") == 1 then 
				local remainCount = GetExProp(statue, "REMAIN_WARP_COUNT");
				remainCount = remainCount - 1;
				SetExProp(statue, "REMAIN_WARP_COUNT", remainCount);

				if remainCount == 0 then
					DelExProp(statue, "REMAIN_WARP_COUNT")
					DelExProp(pc, "VAKARINE_WARP");
					Dead(statue);
				end

				local mapCls = GetClass('Map', zone_ClassName);
				etc.LastWarpMapID = mapCls.ClassID;

				MoveZone(pc, zone_ClassName, posX, posY, posZ, 'Vakarine');
			else
			    local ret
			    if warpcost > 0 then
    				local tx = TxBegin(pc);
    				TxTakeItem(tx, MONEY_NAME, warpcost, "Warp");
    				ret = TxCommit(tx);
    			elseif warpcost == 0 then
    			    ret = 'SUCCESS'
    			end
				
				if ret == 'SUCCESS' then
					local mapCls = GetClass('Map', zone_ClassName);
					etc.LastWarpMapID = mapCls.ClassID;
					MoveZone(pc, zone_ClassName, posX, posY, posZ, 'God');
				else
					local x, y, z = GetPos(pc);
					mapName = GetZoneName(pc);
					MoveZone(pc, mapName, x, y, z);
				end

			end
		end
	else
		-- ���� �����ۿ��� ��ġ�� �̵�
		local mapCls = GetClassByType('Map', etc.ItemWarpMapID);
		etc.ItemWarpMapID = 0;
		etc.LastWarpMapID = mapCls.ClassID;
		MoveZone(pc, mapCls.ClassName, etc.ItemWarpPosX, etc.ItemWarpPosY+30, etc.ItemWarpPosZ, 'GodRecall');		
	end
end


-- ������ ����(���� �ֹ���, Scroll_WarpKlaipe)
function INTE_WARP_ITEM_SERVER(pc, nowmapName, mapName, warpcost, toPrevPos, useItemName)

	local warpscrolllistcls = GetClass("warpscrolllist", useItemName);
	if warpscrolllistcls == nil then
		return;
	end

	local item = nil;
	local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
		
        if invItemList[i].ClassName == useItemName then
			if invItemList[i].LifeTime == 0 or (invItemList[i].LifeTime > 0 and invItemList[i].ItemLifeTimeOver ~= 1) then
				item = invItemList[i];
				break;
			end
        end
    end

	if item == nil then
		return;
	end

	if warpcost < 0 then
		warpcost = 0
	end

	local dest_mapName = mapName;
	local sObj_main = GetSessionObject(pc, 'ssn_klapeda');
	local result = SCR_GET_XML_IES('camp_warp', 'City', city)

	local campwarpclslist = SCR_GET_XML_IES('camp_warp', 'Zone', dest_mapName)
	
	if toPrevPos == 0 and campwarpclslist ~= nil and #campwarpclslist > 0 then

		local campwarpclsname = campwarpclslist[1].ClassName;
		local warppoint = SCR_GET_MONGEN_ANCHOR(dest_mapName, 'Dialog',campwarpclsname)
                
		if warppoint ~= nil and sObj_main[campwarpclsname] == 300 then
			local zone_ClassName = dest_mapName;                    
			local posX = warppoint[1].PosX
			local posY = warppoint[1].PosY + 30
			local posZ = warppoint[1].PosZ                    
            
			--[[        
			if IMCRandom(1,2) == 1 then
				posX = posX + IMCRandom(40,60)
			else
				posX = posX - IMCRandom(40,60)
			end
                    
			if IMCRandom(1,2) == 1 then
				posZ = posZ + IMCRandom(40,60)
			else
				posZ = posZ - IMCRandom(40,60)
			end
			]]

			local mapCls = GetClass("Map", nowmapName);
			local etc = GetETCObject(pc);
			local x, y, z = GetPos(pc);

			local itemcount = GetInvItemCount(pc, useItemName)

			if itemcount < 1 then
				return
			end

			local tx = TxBegin(pc);
			TxEnableInIntegrateIndun(tx);
			TxTakeItemByObject(tx, item, 1, "Warp");

			if etc['ItemWarpMapID'] ~= mapCls.ClassID then
				TxSetIESProp(tx, etc, 'ItemWarpMapID', mapCls.ClassID);	
			end
			if etc['ItemWarpPosX'] ~= x then
				TxSetIESProp(tx, etc, 'ItemWarpPosX', x);	
			end

			if etc['ItemWarpPosY'] ~= y then
				TxSetIESProp(tx, etc, 'ItemWarpPosY', y);	
			end

			if etc['ItemWarpPosZ'] ~= z then
				TxSetIESProp(tx, etc, 'ItemWarpPosZ', z);	
			end

			local ret = TxCommit(tx);
			if ret == 'SUCCESS' then
				MoveZone(pc, zone_ClassName, posX, posY, posZ, 'ItemWarp');
			else				
				mapName = GetZoneName(pc);
				MoveZone(pc, mapName, x, y, z);
			end	
		end
	else

		-- ���� �����ۿ��� ��ġ�� �̵�
		local etc = GetETCObject(pc);
		local mapCls = GetClass("Map", nowmapName);
		local moveMap = GetClassByType("Map", etc.ItemWarpMapID);
		local mx, my, mz = etc.ItemWarpPosX, etc.ItemWarpPosY, etc.ItemWarpPosZ;		
		local x, y, z = GetPos(pc);

		local itemcount = GetInvItemCount(pc, useItemName)

		if itemcount < 1 then
			return
		end

		local tx = TxBegin(pc);
		TxTakeItemByObject(tx, item, 1, "Warp");
		
		if etc['ItemWarpMapID'] ~= mapCls.ClassID then
			TxSetIESProp(tx, etc, 'ItemWarpMapID', mapCls.ClassID);	
		end
		if etc['ItemWarpPosX'] ~= x then
			TxSetIESProp(tx, etc, 'ItemWarpPosX', x);	
		end
		if etc['ItemWarpPosY'] ~= y then
			TxSetIESProp(tx, etc, 'ItemWarpPosY', y);	
		end
		if etc['ItemWarpPosZ'] ~= z then
			TxSetIESProp(tx, etc, 'ItemWarpPosZ', z);	
		end
		local ret = TxCommit(tx);
		
		if ret == 'SUCCESS' then
			MoveZone(pc, moveMap.ClassName, mx, my, mz, 'ItemRecall');
		else				
			MoveZone(pc, moveMap.ClassName, mx, my, mz, 'ItemRecall');
		end	
	end
end