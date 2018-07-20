

function TARGET_MOVE_END(self, target, range)
	local x, y, z = GetPos(target);
	if IsNearFrom(self, x, z, range)  == "YES" then
		StopMove(self);
		return 1;
	end

	return 0;
end

function MON_TACTICS(mon, tactics)

	mon.Tactics = tactics;

end

function EXEC_MOVE_TARGET(self, target, range)
	local x, y, z = GetPos(target);
	MoveEx(self, x, y, z, range, 'NORMAL');
end


function CRE_GROUP_MON(pc, name, posx, posy, posz, faction, layer, genRatio, monGroup, sleepSec, btName, cbFunc, maxCnt)

	local created = 0;

	local genList = geGroupGenTable.GetGen(name);
	local cnt = genList:Count();

	local addCnt = 0;
	if maxCnt ~= nil then
		if maxCnt <= cnt then
			cnt = maxCnt;
		else
			addCnt = maxCnt - cnt;
		end
	elseif genRatio ~= nil then
		cnt = math.ceil(cnt * genRatio);
	end

	local bt;
	if btName ~= nil and type(btName) ~= "string" then
		bt = btName;
	else
		bt = nil;
	end

	local i = 0;
	while 1 do
		if i == cnt then
			break;
		end

		local gen = genList:PtrAt(i);
		local x = gen.x;
		local y = posy;
		local z = gen.z;

		local dirX = gen.dirX;
		local dirZ = gen.dirZ;
		local angle = DirToAngle(dirX, dirZ);

  		x = x + posx;
  		z = z + posz;

		local mon = CREATE_MONSTER(pc, gen:Monster(), x, y, z, angle, faction, layer, gen.level, gen:Tactics(), gen:Name(), nil, gen.fixedLife, -1);
		if mon ~= nil then
		    EnableAIOutOfPC(mon)
			monx, mony, monz = GetPos(mon);
			if GetDist(monx, monz, x, z) >= 60 then
				Kill(mon);
			else
				created = created + 1;
			end

			local pattern = gen:Pattern();
			if pattern ~= "None" then
				REGISTER_MON_PATTERN(mon, pattern);
			end

			local groupID = EVENT_MON_GROUP;
			if monGroup ~= nil then
				groupID = monGroup;
			end

			SetGroup(mon, groupID);

			if sleepSec ~= nil then
				HOLD_MON_SCP(mon, sleepSec);
			end

			if cbFunc ~= nil then
				cbFunc(mon);
			end

			if bt ~= nil then
				SetBTree(mon, bt);
			elseif btName ~= nil then
				local pbt = CreateBTree(btName);
				SetBTree(mon, pbt);
			end

		end

		if addCnt > 0 and i == cnt - 1 then
			i = i - 1;
			addCnt = addCnt - 1;
		end

		i = i + 1;
	end

	return created;
end

function GetDist(x1, y1, x2, y2)

	return math.sqrt( math.pow(x2-x1, 2) + math.pow(y2-y1,2) );

end

function CREATE_CART(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, pcName)
	return CREATE_MONSTER(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, pcName, nil, nil, nil, 1);
end

function CREATE_TRACK_MON(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, dropList, fixedDefence, customDefence, simpleAI)
    if faction == 'Monster' and bTree == nil then
        bTree = 'TrackWaitMonster'
    end
    
    local mon = CREATE_MONSTER(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, dropList, fixedDefence, customDefence, simpleAI)
    if mon ~= nil then
    HoldMonScp(mon);
	SetExProp(mon, "IS_DIRECTION_OBJ", 1);
  end

  return mon;
end

function CREATE_SUMMON(pc, classname, x, y, z, angle, lv, tactics, faction, name, uniqueName, fixedLife, inputRange, pc_owner, isCart)

	local ret = CREATE_MONSTER(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart);
	if ret ~= nil then
		SetOwner(ret, pc, 1);
		SetBroadcastOwner(ret);
	end
	
	return ret;	
end

function CREATE_MONSTER_CELLGEN(pc, classname, cellList, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree)
    local cellgenList = SCR_STRING_CUT(cellList)
    local x, y, z
    if #cellgenList > 0 then
        local cellgenListIndex = IMCRandom(1, #cellgenList)
        local pos_list = SCR_CELLGENPOS_LIST(pc, cellgenList[cellgenListIndex], 0)
        
        if #pos_list > 0 then
            local pos_list_index = 0
            
            if sObj.NumArg3 < #pos_list then
                pos_list_index = sObj.NumArg3 + 1
            else
                pos_list_index = (sObj.NumArg3 % #pos_list) + 1
            end
            
            x = pos_list[pos_list_index][1]
            y = pos_list[pos_list_index][2]
            z = pos_list[pos_list_index][3]
        end
    end
    
    
    if x ~= nil then
        local mon = CREATE_MONSTER(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree)
        if mon ~= nil then
            LookAt(mon, pc)
            
            return mon
        end
    end
end

function CREATE_MONSTER(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, customLife, fixedAttack, customAttack, moveSpeed, shield, scale, kdArmor, surroundRate, dropList, fixedDefence, customDefence, simpleAI, hpCount)
 	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
	    ErrorLog(ScpArgMsg("Auto_DeungLog_an_Doen_MonSeuTeoLeul_SayongHaLyeo_HapNiDa._ClassName_:_")..classname)
	    --DumpCallStack()
		return nil;
	end
    
    if hpCount ~= nil then
	    if hpCount ~= 0 then
    		mon1obj.HPCount = hpCount;
    	end
    end
    
	if tactics ~= nil and tactics ~= "None" then
	    if tactics == "Dummy" then
	        mon1obj.Tactics = "None"
	    else
    		mon1obj.Tactics = tactics;
    	end
	end
	
--	if tactics == nil or tactics == "None" then
--		mon1obj.Tactics = "MON_TRACK";
--	else
--		mon1obj.Tactics = tactics;
--	end
	
	if bTree ~= nil and bTree ~= 'None' then
	    if bTree == "Dummy" then
	        mon1obj.BTree = "None"
	    else
    	    mon1obj.BTree = bTree;
    	end
	end
	
	if name ~= nil and name ~= mon1obj.Name then
		mon1obj.Name = name;
	end

	if uniqueName ~= nil then
		mon1obj.UniqueName = uniqueName;
	end
	
	if lv ~= nil then
		local lvNum = tonumber(lv);
	    if lvNum == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_LeBeli_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
        
	    if lvNum > 0 then
        	mon1obj.Lv = lvNum;
        else
            mon1obj.Lv = mon1obj.Level
        end
    else
        mon1obj.Lv = mon1obj.Level
    end

	if fixedLife ~= nil then
	    if tonumber(fixedLife) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_fixedLife_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
        
	    if fixedLife ~= 0 then
    		mon1obj.FixedLife = fixedLife;
    	end
	end
	
	if customLife ~= nil then
	    if tonumber(customLife) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_customLife_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.MHP_BM = mon1obj.MHP_BM + customLife
	end
	
	if fixedAttack ~= nil then
	    if tonumber(fixedAttack) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_fixedAttack_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.FixedAttack = fixedAttack
	end
	if customAttack ~= nil then
	    mon1obj.ATK_BM = mon1obj.ATK_BM + customAttack
	end
	
	
	if moveSpeed ~= nil then
	    if tonumber(moveSpeed) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_moveSpeed_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.MSPD_BM = mon1obj.MSPD_BM + moveSpeed
	end
	
	if shield ~= nil then
	    if tonumber(shield) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_shield_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.ShieldRate = mon1obj.ShieldRate + shield
	end
	
	
	if kdArmor ~= nil then
	    if tonumber(kdArmor) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_kdArmor_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.KDArmor = kdArmor
	end
	
	if surroundRate ~= nil then
	    if tonumber(surroundRate) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_surroundRate_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
		if TryGetProp(mon1obj, "SurroundRate") ~= nil then
			mon1obj.SurroundRate = surroundRate
		end
	end
	
	if dropList ~= nil then
	    mon1obj.DropItemList = dropList
	end
	

	local range = 1;
	if inputRange ~= nil then
	    if tonumber(inputRange) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_inputRange_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    if inputRange > 0 then
    		range = inputRange;
    	end
	end
    
    
    if scale ~= nil and tonumber(scale) == nil then
	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_scale_MunJaKapeuLo_Neomeo_opNiDa."), classname)
        DumpCallStack()
        return
    end
    
    if fixedDefence ~= nil then
	    if tonumber(fixedDefence) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_fixedDefence_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.FixedDefence = fixedDefence
	end
	if customDefence ~= nil then
	    if tonumber(customDefence) == nil then
    	    print(ScpArgMsg("Auto_MonSeuTeo_SoHwan_Si_customDefence_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
	    mon1obj.DEF_BM = mon1obj.DEF_BM + customDefence
	end
	
    if simpleAI ~= nil and simpleAI ~= 'None' then
	    mon1obj.SimpleAI = simpleAI;
	end
	
	local mon1;
	if isCart == nil then
		mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, range, 0, layer);
	else
		mon1 = CreateCart(pc, mon1obj, x, y, z, angle, range, 0, layer);
	end

	if mon1 == nil then
		return nil;
	else
	    InvalidateStates(mon1)
	    if pc_owner == 'PC_OBJECT_SAVE' then
	        CreateSessionObject(mon1, 'SSN_OBJECT_STORAGE', 1)
	        local sObj_storage = GetSessionObject(mon1, 'SSN_OBJECT_STORAGE')
	        if sObj_storage ~= nil then
	            SetArgObj1(sObj_storage, pc)
	        end
	    end
	    if scale ~= nil then
    	    ChangeScale(mon1, scale,0.01)
    	end
    	
	    
	end
	
	if faction ~= nil and faction ~= 'None' then
		SetCurrentFaction(mon1, faction);
		mon1.Faction = faction
	end
	
	return mon1;
end

function CREATE_MONSTER_EX(pc, classname, x, y, z, angle, faction, lv, funcPtr, ...)
 	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
		return nil;
	end
    
	if lv ~= nil then
	    if lv > 0 then
        	mon1obj.Lv = lv;
        else
            mon1obj.Lv = mon1obj.Level
        end
    else
        mon1obj.Lv = mon1obj.Level
    end

	if funcPtr ~= nil then
		funcPtr(mon1obj, ...);
	end

	local range = 1;
	if inputRange ~= nil and inputRange > 0 then
		range = inputRange;
	end

	local layer=  GetWorldLayer(pc);
	local mon1;
	if isCart == nil then
		mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, range, 0, layer);
	else
		mon1 = CreateCart(pc, mon1obj, x, y, z, angle, range, 0, layer);
	end

	if mon1 == nil then
		return nil;
	end
	
	if faction ~= nil and faction ~= 'None' then
		SetCurrentFaction(mon1, faction);
		mon1.Faction = faction
	end
	
	return mon1;
end


function CREATE_MONSTER_MOD(pc, classname, x, y, z, angle, inputRange, faction, lv, funcPtr, ...)
 	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
		return nil;
	end
    
	if lv ~= nil then
	    if lv > 0 then
        	mon1obj.Lv = lv;
        else
            mon1obj.Lv = mon1obj.Level
        end
    else
        mon1obj.Lv = mon1obj.Level
    end

	if funcPtr ~= nil then
		funcPtr(mon1obj, ...);
	end

	local range = 1;
	if inputRange ~= nil and inputRange > 0 then
		range = inputRange;
	end

	local layer=  GetLayer(pc);
	local mon1;
	if isCart == nil then
		mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, range, 0, layer);
--		ObjectColorBlend(mon1, 255, 255, 255, 50, 1, 0, 1)
--		PlayEffect(mon1, 'STD')
	else
		mon1 = CreateCart(pc, mon1obj, x, y, z, angle, range, 0, layer);
--		ObjectColorBlend(mon1, 255, 255, 255, 50, 1, 0, 1)
--		PlayEffect(mon1, 'STD')
	end

	if mon1 == nil then
		return nil;
	end
	
	if faction ~= nil and faction ~= 'None' then
		SetCurrentFaction(mon1, faction);
		mon1.Faction = faction
	end
	--
	return mon1;
end



function SET_DUMMY_MON(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
end

--use array
function CREATE_MONSTER_CELL(self, classname, target, cellgen, moncount, range, faction, funcPtr, ...)

	if range == nil and range <= 0 then
		range = 1
	end

    if cellgen == nil or cellgen == 'None' then
        cellgen = 'Siege1'
    end

    if range <= 0 then
        range = 0
    end

    local pos_list = GetCellCoord(self, cellgen, 0)

    if moncount <= (#pos_list/3) then
        if moncount <= 0 then
            moncount = 1
        elseif moncount == -10 then
            moncount = IMCRandom(1, #pos_list)
        end
    else
        
        moncount = (#pos_list/3)
    end
    if moncount > 0 then
        local zoneID = GetZoneInstID(self)
        local x = 1
        local y = 2
        local z = 3
    	local mon = {}
    	local mon_list = {}
    	local i
    	local layer=  GetLayer(self);
        local mon1obj = {}
        for i = 1, moncount do
            if IsValidPos(zoneID, pos_list[x], pos_list[y], pos_list[z]) == 'YES' then
                mon1obj[i] = CreateGCIES('Monster', classname);
            
            	if mon1obj[i] == nil then
            		return nil;
            	end
            	if funcPtr ~= nil then
            		funcPtr(mon1obj[i], ...);
            	end
            
                mon[i] = CreateMonster(self, mon1obj[i], pos_list[x], pos_list[y], pos_list[z], 0, range, 0, layer);
                if mon[i] == nil then
                    return nil
                end
                
            	if faction ~= nil and faction ~= 'None' then
            		SetCurrentFaction(mon[i], faction);
            		mon[i].Faction = faction
            	end

            end
            x = x + 3
            y = y + 3
            z = z + 3
            
            mon_list[#mon_list+1] = mon[i]
        end
    	return mon_list, #mon_list
    end
    return nil
end



function SCR_CREATE_SSN_OBJECT_STORAGE(self, sObj)
end

function SCR_REENTER_SSN_OBJECT_STORAGE(self, sObj)
end

function SCR_DESTROY_SSN_OBJECT_STORAGE(self, sObj)
end

function CREATE_NPC_EX(pc, classname, x, y, z, angle, faction, name, lv, func, ...)
	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
		return nil;
	end

   if name ~= nil and name ~= "None" then
		mon1obj.Name = name;
	end

	if lv ~= nil then
    	mon1obj.Lv = lv;
    end
    
    if func == nil then
    
    else
    	func(mon1obj, ...);
	end

	local mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, -1);
	if mon1 == nil then
		return nil;
	end

	if faction ~= nil then
		SetCurrentFaction(mon1, faction);
	end

	SetLayer(mon1, GetLayer(pc));

	return mon1;
end

function CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog, genrange)

	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
		return nil;
	end

    if uniqueName ~= nil then
		mon1obj.UniqueName = uniqueName;
	end

    if tactics == nil then
    	mon1obj.Tactics = "MON_TRACK";
    else
        mon1obj.Tactics = tactics
    end

	if dialog ~= nil then
		mon1obj.Dialog = dialog
	end

	if leave ~= nil then
	    mon1obj.Leave = leave
	end

	if name ~= nil and name ~= "None" then
		mon1obj.Name = name;
	end

	if enter ~= nil then
		mon1obj.Enter = enter;
	end

	if range ~= nil then
		mon1obj.Range = range;
	end

	if lv ~= nil then
    	mon1obj.Lv = lv;
    end
    
    if fixedLife ~= nil then
	    if tonumber(fixedLife) == nil then
    	    print(ScpArgMsg("Auto_NPC_SoHwan_Si_fixedLife_MunJaKapeuLo_Neomeo_opNiDa."), classname)
            DumpCallStack()
            return
        end
        
	    if fixedLife ~= 0 then
    		mon1obj.FixedLife = fixedLife;
    	end
	end
	
	if hpCount ~= nil then
	    if hpCount ~= 0 then
    		mon1obj.HPCount = hpCount;
    	end
    end
    
    if simpleAI ~= nil and simpleAI ~= 'None' then
        mon1obj.SimpleAI = simpleAI
    end
    
    if maxDialog ~= nil and tonumber(maxDialog) ~= nil then
        mon1obj.MaxDialog = maxDialog
    end
    
    if genrange == nil or genrange == 0 then
        genrange = -1
    end
    
	local mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, genrange);
	if mon1 == nil then
		return nil;
	end

	if faction ~= nil then
		SetCurrentFaction(mon1, faction);
	end

	if layer ~= nil then
		SetLayer(mon1, layer);
	end

	return mon1;
end

function CAMERA_RESET(pc)

	ChangeCamera(pc, 0);

end

function CAMERA_MOVE(pc, x, z, time, motion)

	ChangeCamera(pc,1,  x, -1, z, time, motion);

end

function SCR_OPEN_UI(self, uiname)

	local curzoneID = GetZoneInstID(self);
	UIOpenToZone(curzoneID, uiname, 1);
end

function SCR_CLOSE_UI(self, uiname)

	local curzoneID = GetZoneInstID(self);
	UIOpenToZone(curzoneID, uiname, 0);


end

function TRACK_SLEEP(pc, sleepcnt)
    sleep(sleepcnt);
end

function DIRECT_START(pc)

	SendSharedMsg(pc, "MSG_DIRECT_START");

end

function DIRECT_END(pc)

	pc.FIXMSPD_BM = 0;
	InvalidateMSPD(pc);

	SendSharedMsg(pc, "MSG_DIRECT_END");
	-- L°a¿??°¡V¶? ?μ?????¶ ?μ?��? ?·�?¸???¸ ?μ?°?¹???°??
	UNHOLD_DIRECTION_MON(pc);
	
end

function TUTORIAL_DIRECT_START(pc)

	EnableControl(pc, 0, "TUTORIAL_DIRECT");
end

function TUTORIAL_DIRECT_END(pc)

	EnableControl(pc, 1, "TUTORIAL_DIRECT");
	local curzoneID = GetZoneInstID(pc);

end

function LOCK_CONTROL(pc)
	EnableControl(pc, 0, "LOCK_CONTROL");
end

function UNLOCK_CONTROL(pc)
	EnableControl(pc, 1, "LOCK_CONTROL");
end


function PC_CLICK_TRIGGER(pc, clsname, dialog)

local fndList, fndCount = SelectObjectByClassName(pc, 300, clsname);
	for i = 1, fndCount do
		local obj = fndList[i];
		if obj ~= nil and obj.Dialog == dialog then
			InvokeTrigger(pc, obj);
			return;
		end
	end

end

function UP_MOVESPEED_CHILD(pc, value)

 	local flwList, cnt = GetFollowerList(pc);
	for i = 1, cnt do
		UP_MOVESPEED_CHILD(flwList[i], value);
	end

  UP_MOVESPEED(pc, value);

end

function UP_MOVESPEED(pc, value)

	pc.MSPD_BM = pc.MSPD_BM + value;
	InvalidateStates(pc);

end

function UNHOLD_DIRECTION_MON(pc)

	local zoneID = GetZoneInstID(pc);
	local layer = GetLayer(pc);
	local list, cnt = GetLayerMonList(zoneID, layer);
	for i = 1 , cnt do
		local mon = list[i];
		if GetExProp(mon, "IS_DIRECTION_OBJ") == 1 then
			UnHoldMonScp(mon);
		end
	end

end

function CREATE_CART_TAILES(self, head, cartName, cartList, cartCnt, x, y, z, layer)

	local fixedMspd = head.FIXMSPD_BM;
	local cartDist = 30;
	local owner = head;
	for i = 1 , cartCnt do
		local cart1 = CREATE_CART_TAIL_NORMAL(self, owner, cartName, x, y, z, layer, 0, 0, 0, cartDist, i);
		cart1.FIXMSPD_BM = fixedMspd;
		owner = cart1;
		cartList[i] = cart1;
	end

end

function CREATE_CART_TAIL_NORMAL(pc, owner, monClsName, x, y, z, layer, angle, dirX, dirZ, cartDist, idx)

  if monClsName == nil then
      monClsName = "NPC_Cart1";
  end

	x = x - dirX * cartDist * idx;
	z = z - dirZ * cartDist * idx;

	local mon = CREATE_CART(pc, monClsName, x, y, z, angle, GetCurrentFaction(owner), layer, 12, "MON_CART");
	SetOwner(mon, owner, 1);
	return mon;

end

function CREATE_SELFPOS_MONSTER(self, monName, tactics)

	local x, y, z = Get3DPos(self);
	local dir = GetDirectionByAngle(self);
	local range = 1;
	local mon = CREATE_MONSTER(self, monName, x, y, z, dir, GetCurrentFaction(self), GetLayer(self), self.Lv, tactics);
	return mon;

end

function CREATE_MON_CART(self, x, y, z, layer, tacticsName, faction, cartName, cartCnt, leader_dialog)
    if cartCnt == nil then
        cartCnt = 1
    end

    local leader

    if leader_dialog == nil then
        leader = CREATE_MONSTER(self, "Silvertransporter_m", x, y, z, 0, faction, layer, 30, tacticsName);
    else
    	leader = CREATE_NPC(self, "Silvertransporter_m", x, y, z, 0, faction, layer, nil, leader_dialog, nil, nil, 30, nil, tacticsName);
    end

	local head = CREATE_MONSTER(self, "NPC_Blowfish1", x, y, z, 0, faction, layer, 30, "MON_CART");
	SetOwner(head, leader, 1);
	local cartList = {};
	CREATE_CART_TAILES(self, head, cartName, cartList, cartCnt, x, y, z, layer);
	return leader, cartList;

end

function FADE_OUT(pc, isFadeOut)

	UIOpenToPC(pc, "fullblack", isFadeOut);

end




function CREATE_MONSTER_DIRECTION(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, scale, fixspd)

	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
		return nil;
	end
	
	if scale ~= nil and scale ~= "None" then
	    if scale > 0 then
	        mon1obj.Scale = scale
	    else
	        mon1obj.Scale = mon1obj.Scale
	    end
	end
	
	if fixspd ~= nil and fixspd ~= "None" then
	    if fixspd > 0 then
	        mon1obj.FIXMSPD_BM = fixspd
	    else
	        mon1obj.FIXMSPD_BM = mon1obj.FIXMSPD_BM
	    end
	end
--	, )

	if tactics ~= nil and tactics ~= "None" then
	    if tactics == "Dummy" then
	        mon1obj.Tactics = "None"
	    else
    		mon1obj.Tactics = tactics;
    	end
	end
	
--	if tactics == nil or tactics == "None" then
--		mon1obj.Tactics = "MON_TRACK";
--	else
--		mon1obj.Tactics = tactics;
--	end
	
	if bTree ~= nil and bTree ~= 'None' then
	    if bTree == "Dummy" then
	        mon1obj.BTree = "None"
	    else
    	    mon1obj.BTree = bTree;
    	end
	end
	
	if name ~= nil and name ~= mon1obj.Name then
		mon1obj.Name = name;
	end

	if uniqueName ~= nil then
		mon1obj.UniqueName = uniqueName;
	end

	if lv ~= nil then
	    if lv > 0 then
        	mon1obj.Lv = lv;
        else
            mon1obj.Lv = mon1obj.Level
        end
    else
        mon1obj.Lv = mon1obj.Level
    end

	if fixedLife ~= nil then
	    if fixedLife ~= 0 then
    		mon1obj.FixedLife = fixedLife;
    	end
	end

	local range = 1;
	if inputRange ~= nil and inputRange > 0 then
		range = inputRange;
	end

	local mon1;
	if isCart == nil then
		mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, range, 0, layer);
	else
		mon1 = CreateCart(pc, mon1obj, x, y, z, angle, range, 0, layer);
	end

	if mon1 == nil then
		return nil;
	else
	    if pc_owner == 'PC_OBJECT_SAVE' then
	        CreateSessionObject(mon1, 'SSN_OBJECT_STORAGE')
	        local sObj_storage = GetSessionObject(mon1, 'SSN_OBJECT_STORAGE')
	        if sObj_storage ~= nil then
	            SetArgObj1(sObj_storage, pc)
	        end
	    end
	end
	
	if faction ~= nil and faction ~= 'None' then
		SetCurrentFaction(mon1, faction);
		mon1.Faction = faction
	end
	
	return mon1;
end

function CREATE_TRACK_MON_DIR(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, scale, fixspd)
    local mon = CREATE_MONSTER_DIRECTION(pc, classname, x, y, z, angle, faction, layer, lv, tactics, name, uniqueName, fixedLife, inputRange, pc_owner, isCart, bTree, scale, fixspd)
    if mon ~= nil then
    HoldMonScp(mon);
	SetExProp(mon, "IS_DIRECTION_OBJ", 1);
  end

  return mon;
end


function SET_POSITION(self, x, y, z)
    SetPos(self, x, y, z)
    self.CreateX = x
    self.CreateY = y
    self.CreateZ = z
end




function SET_POSITION_BORN(self, x, y, z)
    SetPos(self, x, y, z)
    self.CreateX = x
    self.CreateY = y
    self.CreateZ = z
    PlayAnim(self, 'BORN')
end




function CREATE_SAI(pc, classname, simple_ai, faction, x, y, z, angle, name, dialog, enter, leave, lv, range, layer)

 	local mon1obj = CreateGCIES('Monster', classname);
	if mon1obj == nil then
	    print(ScpArgMsg("Auto_DeungLog_an_Doen_MonSeuTeoLeul_SayongHaLyeo_HapNiDa._ClassName_:_"), classname)
	    DumpCallStack()
		return nil;
	end



	if dialog ~= nil then
		mon1obj.Dialog = dialog
	end
	
	if enter ~= nil then
		mon1obj.Enter = enter;
	end

	if leave ~= nil then
	    mon1obj.Leave = leave
	end

	if name ~= nil and name ~= "None" then
		mon1obj.Name = name;
	else
	    mon1obj.Name = mon1obj.Name
	end

	if range ~= nil then
		mon1obj.Range = range;
	else
	    mon1obj.Range = 1
	end

	if lv ~= nil then
    	mon1obj.Lv = lv;
    else
        mon1obj.Lv = pc.Lv
    end


    if x == nil or y == nil or z == nil then
        local x1, y1, z1 = GetPos(pc)
        x = x1
        y = y1
        z = z1
    end
    
    if  angle == nil then
        local angle1 = GetDirectionByAngle(pc)
        angle = angle1
    end

    if simple_ai ~= nil and simple_ai ~= 'None' then
        mon1obj.BTree = 'None'
        mon1obj.SimpleAI = simple_ai
    else
        mon1obj.BTree = 'None'
        print(ScpArgMsg('Auto_Simple_AIKa_JeogyongDoeJi_anassSeupNiDa!!'))
        mon1obj.SimpleAI = 'NONE_SIMPLE_AI'
    end

	local mon1 = CreateMonster(pc, mon1obj, x, y, z, angle, -1);
	if mon1 == nil then
		return nil;
	end
	if faction ~= nil then
		SetCurrentFaction(mon1, faction);
	else
	    SetCurrentFaction(mon1, 'Neutral');
	end
    
	if layer ~= nil then
		SetLayer(mon1, layer);
	else
	    SetLayer(mon1, GetLayer(pc));
	end

	return mon1;
end

