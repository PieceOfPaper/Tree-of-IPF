-- -- Event Special Blue orb
-- function SCR_PRECHECK_CONSUME_EMISSION(self)
--     local curMap = GetZoneName(self);
--     local mapCls = GetClass("Map", curMap);
    
--     if mapCls.ClassName == 'c_firemage_event' then
--         return 1;
--     end
    
--     return 0;
-- end

-- function SCR_PRECHECK_CONSUME_EMISSION2(self)
--     local curMap = GetZoneName(self);
--     local mapCls = GetClass("Map", curMap);

--     if mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 then
--         return 1;
--     end
    
--     if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
--         return 1
--     end
    
--     return 0;
-- end

-- function SCR_USE_SPECIAL_BLUEORB(pc)
--     local moncls_info = {
--         {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
--         {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
--         {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
--     }
--     local aObj = GetAccountObj(pc)
    
--     for i = 1, table.getn(moncls_info) do
--         if aObj[moncls_info[i][1]] ~= 'None' then
--             local iesObj = CreateGCIES('Monster', aObj[moncls_info[i][1]]);
--         	if iesObj ~= nil then
--         	    iesObj.Lv = aObj[moncls_info[i][2]] + 1
--         	    iesObj.Faction = 'Summon';
--         		local x, y, z = GetPos(pc);
        		
--         		local mon = CreateMonster(pc, iesObj, x, y, z, 0, 10);
        
--         		SetOwner(iesObj, pc, 0);
--         		SetHookMsgOwner(iesObj, pc);
--         		SetLifeTime(mon, 600);
--         		RunSimpleAI(iesObj, 'alche_summon');
--         	end
--     	end
-- 	end
-- end

-- function SCR_USE_SPECIAL_TRAP(pc)
--     local x, y, z = GetPos(pc)
--     --CREATE_NPC(pc, classname, x, y, z, angle, faction, layer, name, dialog, enter, range, lv, leave, tactics, uniqueName, fixedLife, hpCount, simpleAI, maxDialog)
--     local STrap = CREATE_NPC(pc, "pilgrim_trap_01", x, y, z, 0, "Summon", GetLayer(pc), pc.Name, nil, nil, 60, 1, nil, "SPECIAL_TRAP");
--     SetLifeTime(STrap, 60);
-- 	SetOwner(STrap, pc, 0);
-- end

-- function SCR_SPECIAL_TRAP_TS_BORN_ENTER(self)
-- end
-- function SCR_SPECIAL_TRAP_TS_BORN_UPDATE(self)
-- 	local objList, objCount = SelectObjectNear(GetOwner(self), self, 15, "ENEMY");
	
-- 	for i = 1, objCount do
-- 		local obj = objList[i];

-- 		if obj.ClassName == 'PC' or GetOwner(obj) ~= nil then

-- 		elseif obj.ClassName ~= 'pilgrim_trap_01' and obj ~= nil and obj.MonRank == 'Normal' then
--             local HPper = GetHpPercent(obj)
--             local succ = 100 - math.floor(HPper * 100)
--             local owner = GetOwner(self)
            
--             if IMCRandom(1, 100) <= succ then
--                 RunScript("SCR_MONCLS_SAVE", self, owner, obj)
--             else
--                 Chat(owner, "Fail!")
--                 Kill(self)
--             end
-- 		end
-- 	end
-- end
-- function SCR_SPECIAL_TRAP_TS_BORN_LEAVE(self)
-- end
-- function SCR_SPECIAL_TRAP_TS_DEAD_ENTER(self)
-- end
-- function SCR_SPECIAL_TRAP_TS_DEAD_UPDATE(self)
-- end
-- function SCR_SPECIAL_TRAP_TS_DEAD_LEAVE(self)
-- end

-- function SCR_MONCLS_SAVE(self, owner, obj)
--     local moncls_name = {
--         'EVENT_MYMON01', 'EVENT_MYMON02', 'EVENT_MYMON03'
--     }
    
--     local aObj = GetAccountObj(owner)
--     for i = 1, table.getn(moncls_name) do
--         if aObj[moncls_name[i]] == 'None' then
--           local tx = TxBegin(owner)
--           TxSetIESProp(tx, aObj, moncls_name[i], obj.ClassName);
--           local ret = TxCommit(tx)

--           if ret == "SUCCESS" then
--             Chat(owner, "Success!")
--             PlayEffect(self, "F_buff_basic025_white_line", 1)
--             Kill(obj)
--             Kill(self)
--           end
--           break;
--         end
--     end
-- end

-- function INIT_PCDEBUFF_EVENT_STAT(pc)
--     if pc.ClassName == 'PC' then
--       if IsDummyPC(pc) == 1 then
--         return;
--       end
      
--       AddBuff(pc, pc, "Event_Penalty", 1, 0, 700000, 1);
--     elseif pc.ClassName == 'magicsquare_1_mini' then
    
--     else
--         local petlist = {
--           'Velhider',
--           'pet_dog',
--           'hoglan_Pet',
--           'pet_hawk',
--           'Piggy',
--           'Lesser_panda',
--           'Toucan',
--           'Guineapig',
--           'barn_owl',
--           'Piggy_baby',
--           'Lesser_panda_baby',
--           'guineapig_baby',
--           'penguin',
--           'parrotbill',
--           'parrotbill_dummy',
--           'Pet_Rocksodon',
--           'penguin_green',
--           'PetHanaming',
--           'penguin_marine',
--           'guineapig_white',
--           'Lesser_panda_gray',
--           'Zombie_Overwatcher',
--           'summons_zombie',
--           'Zombie_hoplite'
--         }
        
--         for i = 1, table.getn(petlist) do
--             if pc.ClassName == petlist[i] then
--                 AddBuff(pc, pc, "Event_Penalty", 1, 0, 700000, 1);
--                 break;
--             end
--         end
-- 	end
-- end

-- function GET_EVENT_STAGELV_RANDOM_BOSS(self, zoneObj, arg2, zone, layer)
-- end

-- function SCR_SELCT_BOSSLV_DIALOG(self, pc)
--     local boss_claname = {
--       'M_random_boss_MagBurk',
--       'M_random_boss_Pyroego',
--       'M_random_boss_salamander',
--       'M_random_boss_Kerberos',
--       'M_random_boss_Fireload'
--     }
    
--     local monCnt = 0
--     sleep(1000)
--     for i = 1, table.getn(boss_claname) do
--         monCnt = GetWorldMonsterCountByClsName(GetZoneInstID(self), boss_claname[i]);
        
--         if monCnt > 0 then
--             monCnt = monCnt + 1
--             break;
--         end
--     end
    
--     if monCnt >= 1 then
--         return;
--     end
    
--     local aObj = GetAccountObj(pc)
--     local bossLV_input = ShowTextInputDlg(pc, 0, 'EVENT_SELECT_BOSSLV_01')
--     local bossLV = tonumber(bossLV_input)

--     if aObj.EVENT_VSMON_STAGE + 10 < bossLV then
--         return
--     end
    
--     if bossLV ~= nil and bossLV > 1 then
--         local zoneObj = GetLayerObject(self);
--         local mon = CREATE_MONSTER(pc, boss_claname[IMCRandom(1, table.getn(boss_claname))], -63, 7, -19, 0, nil, 0, bossLV)
--         mon.StatType = 105
--         EnableAIOutOfPC(mon)
--         SetExProp(zoneObj, "bossLV", bossLV);
--         Kill(self)
--     end
-- end

-- function REQ_EVENT_ITEM_SHOP4_OPEN()
-- 	local frame = ui.GetFrame("earthtowershop");
-- 	frame:SetUserValue("SHOP_TYPE", 'EventShop4');
-- 	ui.OpenFrame('earthtowershop');
-- end

-- -- main dialog
-- function SCR_BLUEORB_MONLVUP_DIALOG(self,pc)
--     local moncls_info = {
--         {'EVENT_MYMON01', 'EVENT_MYMON01_LV'},
--         {'EVENT_MYMON02', 'EVENT_MYMON02_LV'},
--         {'EVENT_MYMON03', 'EVENT_MYMON03_LV'}
--     }
--     local mon_sel = 0;
--     local mon_name = { 'None', 'None', 'None' }
--     local aObj = GetAccountObj(pc)
    
--     if aObj.EVENT_VALUE_AOBJ01 ~= 170925 then -- basic item
--         local tx = TxBegin(pc)
--         TxSetIESProp(tx, aObj, 'EVENT_VALUE_AOBJ01', 170925);
--         TxSetIESProp(tx, aObj, 'EVENT_MYMON01_LV', 1);
--         TxSetIESProp(tx, aObj, 'EVENT_MYMON02_LV', 1);
--         TxSetIESProp(tx, aObj, 'EVENT_MYMON03_LV', 1);
--         TxGiveItem(tx, 'Event_Special_Blueorb', 1, "BLUEORB_REWARD");
--         TxGiveItem(tx, 'Event_Special_Trap', 1, "BLUEORB_REWARD");
--     	local ret = TxCommit(tx)
--     end

--     local now_time = os.date('*t')
--     local yday = now_time['yday']
    
--     if aObj.EVENT_VALUE_AOBJ02 ~= yday then -- event indun enter count reset
--         local tx = TxBegin(pc)
--         TxSetIESProp(tx, aObj, 'EVENT_VALUE_AOBJ02', yday);
--         TxSetIESProp(tx, aObj, 'BLUEORB_MISSION_COUNT', 0);
--     	local ret = TxCommit(tx)
--     end
    
--     local select = ShowSelDlg(pc, 0, 'EV_DAILYBOX_SEL', ScpArgMsg("Cancel"), ScpArgMsg("Event_Steam_Together_Master_1"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL1"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL4"), ScpArgMsg("EventShop"), ScpArgMsg("Event_Today_Number_3"))
    
--     if select == 1 or select == nil then
--         return;
--     elseif select == 2 then
--         local induncount = 2
        
--         if IsBuffApplied(pc, 'Premium_Token') == 'YES' then
--             induncount = 3
--         end
        
--         if aObj.BLUEORB_MISSION_COUNT >= induncount then
-- --            local reset_indun = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_07', ScpArgMsg("No"), ScpArgMsg("Yes") )
-- --            
-- --            if reset_indun == 1 or reset_indun == nil then
-- --                return
-- --            elseif reset_indun == 2 then
-- --                local tx = TxBegin(pc)
-- --                TxSetIESProp(tx, aObj, 'BLUEORB_MISSION_COUNT', aObj.BLUEORB_MISSION_COUNT - 1);
-- --                TxTakeItem(tx, 'Event_Special_Etcitem', 10, 'blueorb_indun_reset');
-- --            	local ret = TxCommit(tx)
-- --            	local ret = TxCommit(tx)
-- --            	if ret == 'SUCCESS' then
-- --            	    PlayEffect(pc, "F_buff_basic025_white_line", 1)
-- --            	end
-- --            end
--             ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_07', 1)
--         else
--             AUTOMATCH_INDUN_DIALOG(pc, nil, 'c_firemage_event')
--         end
--     elseif select == 3 then
        
--         local result = 0;
        
--         for i = 1, table.getn(moncls_info) do
--             if aObj[moncls_info[i][1]] ~= 'None' then
--                 result = result + 1;
--             end
--         end
        
--         if result == 0 then
--             ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_02', 1)
--         elseif result == 1 then
--             mon_name[1] = GetClassString('Monster', aObj.EVENT_MYMON01, 'Name');
--             mon_sel = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_03', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[1]))
--         elseif result == 2 then
--             mon_name[1] = GetClassString('Monster', aObj.EVENT_MYMON01, 'Name');
--             mon_name[2] = GetClassString('Monster', aObj.EVENT_MYMON02, 'Name');
--             mon_sel = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_03', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[1]), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[2]) )
--         elseif result == 3 then 
--             mon_name[1] = GetClassString('Monster', aObj.EVENT_MYMON01, 'Name');
--             mon_name[2] = GetClassString('Monster', aObj.EVENT_MYMON02, 'Name');
--             mon_name[3] = GetClassString('Monster', aObj.EVENT_MYMON03, 'Name');
--             mon_sel = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_03', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[1]), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[2]), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[3]) )
--         end
        
--         if mon_sel ~= 0 then
--             local lvup_input = ShowTextInputDlg(pc, 0, ScpArgMsg("EVENT_SELECT_BOSSLV_SEL3", "NAME", mon_name[mon_sel - 1], "LV", aObj[moncls_info[mon_sel-1][2]]))
--             local lvup = tonumber(lvup_input)
            
--             if lvup <= 0 then
--                 return;
--             end
            
--             if GetInvItemCount(pc, 'Event_Special_Etcitem') < lvup then
--                 ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--                 return;
--             end
            
--             local tx = TxBegin(pc)
--             TxSetIESProp(tx, aObj, moncls_info[mon_sel - 1][2], aObj[moncls_info[mon_sel - 1][2]] + lvup);
--             TxTakeItem(tx, 'Event_Special_Etcitem', lvup, 'blueorb_event');
--         	local ret = TxCommit(tx)
--         	if ret == 'SUCCESS' then
--         	    PlayEffect(pc, "F_buff_basic025_white_line", 1)
--         	end
--         end
--     elseif select == 4 then
--         if aObj[moncls_info[1][1]] ~= 'None' then
--             mon_name[1] = GetClassString('Monster', aObj.EVENT_MYMON01, 'Name');
--         end
--         if aObj[moncls_info[2][1]] ~= 'None' then
--             mon_name[2] = GetClassString('Monster', aObj.EVENT_MYMON02, 'Name');
--         end
--         if aObj[moncls_info[3][1]] ~= 'None' then
--             mon_name[3] = GetClassString('Monster', aObj.EVENT_MYMON03, 'Name');
--         end
            
--         local sel = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_05', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[1]), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[2]), ScpArgMsg("EVENT_SELECT_BOSSLV_SEL2", "NAME", mon_name[3]) )
        
--         if sel == 1 or sel == nil then
--             return;
--         else
--             if aObj[moncls_info[sel-1][1]] == 'None' then
--                 ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_02', 1)
--                 return;
--             end
            
--             if GetInvItemCount(pc, 'Event_Special_Etcitem') < 31 then
--                 ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--                 return;
--             end

--             local tx = TxBegin(pc)
--             TxSetIESProp(tx, aObj, moncls_info[sel - 1][1], 'None');
--             TxTakeItem(tx, 'Event_Special_Etcitem', 30, 'blueorb_event_reset');
--         	local ret = TxCommit(tx)
        	
--         	if ret == 'SUCCESS' then
--         	    ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_06', 1)
--         	    PlayEffect(pc, "F_buff_basic025_white_line", 1)
--         	end
--         end
--     elseif select == 5 then
--         ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP4_OPEN()")
--     elseif select == 6 then
--         ShowOkDlg(pc, ScpArgMsg('EVENT_SELECT_BOSSLV_SEL6', "LV1", aObj[moncls_info[1][2]], "NAME1", aObj[moncls_info[1][1]], "LV2", aObj[moncls_info[2][2]], "NAME2", aObj[moncls_info[2][1]], "LV3" ,aObj[moncls_info[3][2]], "NAME3", aObj[moncls_info[3][1]]), 1)
--         ShowOkDlg(pc, ScpArgMsg('EVENT_SELECT_BOSSLV_SEL7', "MAX", aObj.EVENT_VSMON_STAGE), 1)
--     end
-- end

-- function SCR_BLUEORB_REWARD(cmd, curStage, eventInst, obj)
-- 	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
-- 	for i = 1 , cnt do
-- 	    RunScript('SCR_BLUEORB_REWARD_PLAY', list[i])
-- 	end
-- end

-- function SCR_BLUEORB_REWARD_PLAY(pc)
--     local zoneObj = GetLayerObject(pc);
--     local aObj = GetAccountObj(pc)
--     local bossLV = GetExProp(zoneObj, "bossLV");
--     local reward_cube_list = {
--         {100, 'Event_BlueCube_Lv6'},
--         {80, 'Event_BlueCube_Lv5'},
--         {60, 'Event_BlueCube_Lv4'},
--         {40, 'Event_BlueCube_Lv3'},
--         {20, 'Event_BlueCube_Lv2'},
--         {0, 'Event_BlueCube_Lv1'}
--     }
--     local reward_cube_name = 'Event_BlueCube_Lv1'
--     local reward_blueorb_piece = math.floor(bossLV / 10)
    
--     if reward_blueorb_piece <= 0 then
--         reward_blueorb_piece = 1
--     end
    
--     for i = 1, table.getn(reward_cube_list) do
--         if bossLV > reward_cube_list[i][1] then
--             reward_cube_name = reward_cube_list[i][2]
--             break;
--         end
--     end
    
--     local tx = TxBegin(pc)
--     TxEnableInIntegrate(tx)
--     TxGiveItem(tx, reward_cube_name, 1, "BLUEORB_REWARD");
--     TxGiveItem(tx, 'Event_Special_Etcitem2', reward_blueorb_piece, "BLUEORB_REWARD");
--     if aObj.EVENT_VSMON_STAGE < bossLV then
--         TxSetIESProp(tx, aObj, 'EVENT_VSMON_STAGE', bossLV)
--     end
--     TxAddIESProp(tx, aObj, 'BLUEORB_MISSION_COUNT', 1)
-- 	local ret = TxCommit(tx)
-- 	if ret == 'SUCCESS' then
--         SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('JP_Event_Daily'), 5)
-- 	end
-- end

-- function SCR_BLUEORB_CLEAR_DIALOG(self,pc)
--     local boss_claname = {
--       'M_random_boss_MagBurk',
--       'M_random_boss_Pyroego',
--       'M_random_boss_salamander',
--       'M_random_boss_Kerberos',
--       'M_random_boss_Fireload'
--     }
    
--     local monCnt = 0
--     sleep(1000)
--     for i = 1, table.getn(boss_claname) do
--         monCnt = GetWorldMonsterCountByClsName(GetZoneInstID(self), boss_claname[i]);
        
--         if monCnt > 0 then
--             monCnt = monCnt + 1
--             break;
--         end
--     end
    
--     if monCnt == 0 then
--         Kill(self)
--     end
-- end

-- function SCR_EVENTITEM_DROP_BLUEORB(self, sObj, msg, argObj, argStr, argNum) 
--     if IMCRandom(1, 40) == 1 then
--         local curMap = GetZoneName(self);
--         local mapCls = GetClass("Map", curMap);
        
--         if self.Lv >= 10 and (mapCls.WorldMap ~= 'None' and mapCls.MapType ~= 'City') and argObj.MonRank == 'Normal' then
--             if self.Lv <= argObj.Lv + 20 then
--                 local x, y, z = GetPos(argObj);
--                 local itemObj = CreateGCIES('Monster', 'Event_Special_Etcitem');
--                 CreateItem(self, itemObj, x, y, z, 0, 5);
--             end
--         end
--     end
-- end