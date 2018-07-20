function SCR_INSTANCE_GT_GROUNDTOWER_1_DIALOG(self, pc)

    local dialog_list ={}
    local dialog_ck = {}



    dialog_list[#dialog_list+1] = ScpArgMsg("GT_ENTRACE_SELECT_1")
    dialog_ck[#dialog_ck+1] = 'GT_ENTRACE_SELECT_1'

    local ishavetoll = GetInvItemCount(pc, 'misc_earthTower20_toll')
    if ishavetoll ~= nil and ishavetoll ~= 0 then
        dialog_list[#dialog_list+1] = ScpArgMsg("GT_ENTRACE_SELECT_2_TOLL")
        dialog_ck[#dialog_ck+1] = 'GT_ENTRACE_SELECT_2_TOLL'
    end
    
--    dialog_list[#dialog_list+1] = ScpArgMsg("INSTANCE_DUNGEON_MSG02")
--    dialog_ck[#dialog_ck+1] = 'INSTANCE_DUNGEON_MSG02'




    local select = SCR_SEL_LIST(pc, dialog_list, 'INSTANCE_GT_GROUNDTOWER_1')
    local sel_dialog = dialog_ck[select]
    
    if sel_dialog == 'GT_ENTRACE_SELECT_1' then
		INDUN_ENTER_DIALOG_AND_UI(pc, 'INSTANCE_GT_GROUNDTOWER_1', 'M_GTOWER_1', 0, 0);
		return;        
    elseif sel_dialog == 'GT_ENTRACE_SELECT_2_TOLL' then
		INDUN_ENTER_DIALOG_AND_UI(pc, 'INSTANCE_GT_GROUNDTOWER_2', 'M_GTOWER_2', 0, 0);
		return;  
        
--    elseif sel_dialog == 'INSTANCE_DUNGEON_MSG02' then
--        return
    end
end


function MOVE_TO_EARTH_TOWER(pc, m, select)

end

function GT_TOLLITEM_CK_PRE(self)
    local item_list = 
    {'misc_earthTower5_toll',
    'misc_earthTower10_toll',
    'misc_earthTower15_toll'}
--    'misc_earthTower20_toll'}
    
    
    --need item cnt
    local floor_5 = 1
    local floor_10 = 1
    local floor_15 = 1
--    local floor_20 = 1

    
    local i
    local floor_value = {}
    local classname = {}
    local item_name = {}
    local item_ies = {}
    for i = 1, #item_list do
        if GetInvItemCount(self, item_list[i]) ~= 0 then
	        local item_cls, item_cnt = GetInvItemByName(self, item_list[i]);
	        if item_list[i] == 'misc_earthTower5_toll' then
	            if item_cnt >= floor_5 then
	                floor_value[#floor_value+1] = floor_5
	                item_ies[#item_ies+1] = item_cls
                    classname[#classname+1] = item_list[i]
                    item_name[#item_name+1] = ScpArgMsg("GT_TEST_CAPTION_1")
                end
	        elseif item_list[i] == 'misc_earthTower10_toll' then
	            if item_cnt >= floor_10 then
	                floor_value[#floor_value+1] = floor_10
	                item_ies[#item_ies+1] = item_cls
                    classname[#classname+1] = item_list[i]
                    item_name[#item_name+1] = ScpArgMsg("GT_TEST_CAPTION_2")
                end
	        elseif item_list[i] == 'misc_earthTower15_toll' then
	            if item_cnt >= floor_15 then
	                floor_value[#floor_value+1] = floor_15
	                item_ies[#item_ies+1] = item_cls
                    classname[#classname+1] = item_list[i]
                    item_name[#item_name+1] = ScpArgMsg("GT_TEST_CAPTION_3")
                end
--	        elseif item_list[i] == 'misc_earthTower20_toll' then
--	            if item_cnt >= floor_20 then
--	                floor_value[#floor_value+1] = floor_20
--	                item_ies[#item_ies+1] = item_cls
--                    classname[#classname+1] = item_list[i]
--                    item_name[#item_name+1] = ScpArgMsg("GT_TEST_CAPTION_4")
--                end
	        else
	            return nil
	        end
        end
    end
    
    if #classname == 0 then
        return nil
    end
    return classname, item_name, floor_value, item_ies
end


function GT_TOLLITEM_CNT(self, lutha)

    if IS_GT_PARTYLEADER(self) ~= 1 then
        local init_flg = GetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'M_GTOWER_DIALOG')
        if init_flg ~= 0 then
            REQ_MOVE_TO_INDUN(self, "M_GTOWER_2", 1);
        end
--        print("Not Leader")
        return
    end
    local classname, item_name, floor_value, item_ies = GT_TOLLITEM_CK_PRE(self)
    local select = SCR_SEL_LIST(self, item_name, 'IS_GT_TOLLITEM_1', 1)
    local item_cls = item_ies[select]
    local sel_floor = classname[select]
    local sel_floor_value = floor_value[select]
    local istoll = GetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_USETOLL_1')
    local init_flg = GetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'M_GTOWER_DIALOG')
    if init_flg == 0 then
        if sel_floor == 'misc_earthTower5_toll' then
            if istoll == 0 then
                GT_TOLLITEM_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 6, 'GT1_TO_6', lutha)
--                print("Move To Floor 6th")
            end
        elseif sel_floor == 'misc_earthTower10_toll' then
            if istoll == 0 then
                GT_TOLLITEM_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 11, 'GT1_TO_11', lutha)
--                print("Move To Floor 11th")
            end
        elseif sel_floor == 'misc_earthTower15_toll' then
            if istoll == 0 then
                GT_TOLLITEM_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 16, 'GT1_TO_16', lutha)
--                print("Move To Floor 16th")
            end
        elseif sel_floor == 'misc_earthTower20_toll' then
            if istoll == 0 then
                GT_TOLLITEM_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 21, 'GT1_TO_GT2', lutha)
--                print("Move To Solmiki group")
            end
        end
    end
end

function GT_TOLLITEM_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, moveto, giveway, lutha)
    if moveto == 21 then
        moveto = ScpArgMsg("GT_TOLL_MANAGER_21_FLOOR")
        local select = ShowSelDlg(self, 0, 'GT_LUTHA_NPC_TOLL_MANAGER\\'..ScpArgMsg("GT_TOLL_MANAGER_2", "FLOOR", moveto, "ITEM", item_cls.Name, "VALUE", sel_floor_value), "["..item_cls.Name.."]"..ScpArgMsg("GT_TOLLITEM_USE_AGREE_1"), ScpArgMsg("Auto_KeuMan_DunDa"))
        if select == 1 then
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_USETOLL_1', 1)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_MOVE_2', 1)
--            GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway)
--            local pc_list, pc_cnt = GetLayerPCList(self)
--            if pc_cnt > 0 then
--                local i
--                for i = 1, pc_cnt do
--                    if IsSameActor(self, pc_list[i]) == 'NO' then
--                        SendAddOnMsg(pc_list[i], "NOTICE_Dm_move_to_point", ScpArgMsg("GT1_GT2_FOLLOW_LEADER"), 8);
--                    end
--                end
--            end
            REQ_MOVE_TO_INDUN(self, "M_GTOWER_2", select);
        else
            return
        end
        return
    end


    local select = ShowSelDlg(self, 0, 'GT_LUTHA_NPC_TOLL_MANAGER\\'..ScpArgMsg("GT_TOLL_MANAGER_1", "FLOOR", moveto, "ITEM", item_cls.Name, "VALUE", sel_floor_value), "["..item_cls.Name.."]"..ScpArgMsg("GT_TOLLITEM_USE_AGREE_1"), ScpArgMsg("Auto_KeuMan_DunDa"))
    if select == 1 then
        if moveto == 6 then
            local ret = GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway);
			if ret == 'SUCCESS' then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', 437, 150, -4930, 0, moveto, 5)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_USETOLL_1', 1)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'TOLL_FLOOR_KEEP', moveto)
			end
        elseif moveto == 11 then
            local ret = GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway);
			if ret == 'SUCCESS' then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', -2342, 147, -5097, 0, moveto, 5)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_USETOLL_1', 1)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'TOLL_FLOOR_KEEP', moveto)
			end
        elseif moveto == 16 then
            local ret = GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway);
			if ret == 'SUCCESS' then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', -4913, 147, -4887, 0, moveto, 5)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'GT_USETOLL_1', 1)
            SetMGameValueByMGameName(lutha, 'M_GTOWER_INIT', 'TOLL_FLOOR_KEEP', moveto)
        end
        end
    elseif select == 2 then
        return
    end
end

function IS_GT_PARTYLEADER(pc)
    local party_obj = GetPartyObj(pc)
    local party_leader = IsPartyLeaderPc(party_obj, pc)
    return party_leader
end


function SCR_GT_LUTHA_NPC_DIALOG(self, pc)
    local dialog_list ={}
    local dialog_classname = {
                            'GT_LUTHA_NPC_SELECT_1',
                            'GT_LUTHA_NPC_SELECT_2'
                            }
    local dialog_ck = {}
    local party_obj = GetPartyObj(pc)
    local party_leader = IsPartyLeaderPc(party_obj, pc)
    local init_flg = GetMGameValueByMGameName(self, 'M_GTOWER_INIT', 'M_GTOWER_DIALOG')
    local isToll = GetMGameValueByMGameName(self, 'M_GTOWER_INIT', 'GT_MOVE_2')
    local floorKeep = GetMGameValueByMGameName(self, 'M_GTOWER_INIT', 'TOLL_FLOOR_KEEP')
    
    if floorKeep ~= 0 then
        local select = ShowSelDlg(pc, 0, 'GT_LUTHA_NPC_TOLL_SAVE_1\\'.. ScpArgMsg("GT_LUTHA_NPC_TOLL_SAVE_1", "FLOOR", floorKeep), ScpArgMsg("GT_LUTHA_NPC_SEL_KEEP_FLOOR_1"), ScpArgMsg("GT_LUTHA_NPC_SEL_KEEP_FLOOR_2"))
        if select == 1 then
            GT1_LUTHA_FLOOR_KEEP(pc, floorKeep)
        else
            return
        end
        return
    end


--    if isToll ~= 0 then
--        if IS_GT_PARTYLEADER(pc) ~= 1 then
--            dialog_list[#dialog_list+1] = ScpArgMsg("GT_LUTHA_NPC_SEL_FOLLOW")
--            dialog_ck[#dialog_ck+1] = 'GT_LUTHA_NPC_SEL_FOLLOW'
--        end
--    end
    
    if init_flg ~= 0 then
        ShowOkDlg(pc, 'GT_LUTHA_NPC_SELECT_PROG', 1)
        return
    end

    dialog_list[#dialog_list+1] = ScpArgMsg("GT_LUTHA_NPC_SEL_1")
    dialog_ck[#dialog_ck+1] = 'GT_LUTHA_NPC_SEL_1'
    dialog_list[#dialog_list+1] = ScpArgMsg("GT_LUTHA_NPC_SEL_2")
    dialog_ck[#dialog_ck+1] = 'GT_LUTHA_NPC_SEL_2'
    if party_leader ~= nil then 
        if party_leader == 1 then
            if self.NumArg4 == 0 then
                local ishavetoll = GT_TOLLITEM_CK_PRE(pc)
                if ishavetoll ~= nil then
                    if #ishavetoll > 0 then
                        dialog_ck[#dialog_ck+1] = 'GT_TOLLITEM_USE_ISHAVE_1'
                        dialog_list[#dialog_list+1] = ScpArgMsg("GT_TOLLITEM_USE_ISHAVE_1")
                    end
                end
                dialog_list[#dialog_list+1] = ScpArgMsg("GT_LUTHA_NPC_SEL_3")
                dialog_ck[#dialog_ck+1] = 'GT_LUTHA_NPC_SEL_3'
            end
        end
    end
    local select = SCR_SEL_LIST(pc, dialog_list, dialog_classname[IMCRandom(1,#dialog_classname)])
    local sel_dialog = dialog_ck[select]
    if sel_dialog == 'GT_TOLLITEM_USE_ISHAVE_1' then
        if init_flg == 0 then
            GT_TOLLITEM_CNT(pc, self)
        end
    elseif sel_dialog == 'GT_LUTHA_NPC_SEL_1' then
        local select_1 = ShowSelDlg(pc, 0, 'GT_LUTHA_NPC_SELECT_1_TXT_1', ScpArgMsg('GT_LUTHA_NPC_SELECT_1_TXT_SEL_1_1'), ScpArgMsg('GT_LUTHA_NPC_SELECT_CLOSE'))
        if select_1 == 1 then
            ShowOkDlg(pc, 'GT_LUTHA_NPC_SELECT_1_TXT_3', 1)
        else
            return
        end
    elseif sel_dialog == 'GT_LUTHA_NPC_SEL_2' then
        local select_1 = ShowSelDlg(pc, 0, 'GT_LUTHA_NPC_SELECT_1_TXT_2', ScpArgMsg('GT_LUTHA_NPC_SELECT_1_TXT_SEL_2_1'), ScpArgMsg('GT_LUTHA_NPC_SELECT_CLOSE'))
        if select_1 == 1 then
            ShowOkDlg(pc, 'GT_LUTHA_NPC_SELECT_1_TXT_4', 1)
        else
            return
        end
    elseif sel_dialog == 'GT_LUTHA_NPC_SEL_3' then
        if init_flg == 0 then
            SetMGameValueByMGameName(self, 'M_GTOWER_INIT', 'M_GTOWER_DIALOG', 1)
            ShowOkDlg(pc, 'GT_LUTHA_NPC_SELECT_AGREE', 1)
        else
            return
        end

--    elseif sel_dialog == 'GT_LUTHA_NPC_SEL_FOLLOW' then
--        REQ_MOVE_TO_INDUN(pc, "M_GTOWER_2", 1);
    end
end


function SCR_GT_RELICSHOP_NPC_DIALOG(self, pc)
    local dialog_list ={}
    local dialog_classname = {
                            'GT_RELICSHOP_NPC_SEL_1',
                            }
    dialog_list[#dialog_list+1] = ScpArgMsg("GT_RELICSHOP_NPC_SEL_1")
    dialog_list[#dialog_list+1] = ScpArgMsg("GT_RELICSHOP_NPC_SEL_2")
    dialog_list[#dialog_list+1] = ScpArgMsg("GT_RELICSHOP_NPC_SEL_3")
    
    
--GroundTower Enter Event
--    local aobj = GetAccountObj(pc)
--    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
--    if main_ssn ~= nil then
--        if aobj ~= nil then
--            local isClear = main_ssn.EV_JOIN_GROUNDTOWER_1
--            if isClear == 300 then
--    --	    local isEvt = TryGetProp(aobj, "GroundTower_Enter_EVT");
--    --	    if isEvt ~= 0 then
--                local isGetItem = TryGetProp(aobj, "GroundTower_Enter_EVT_GetItem");
--                if isGetItem == 0 then
--    	            dialog_list[#dialog_list+1] = ScpArgMsg("GROUNDTOWER_ENTER_EVT_SEL_1")
--    	        end
--    	    end
--    --	    end
--        end
--    end

    local select = SCR_SEL_LIST(pc, dialog_list, dialog_classname[IMCRandom(1,#dialog_classname)])
    if select == 1 then
        ExecClientScp(pc, "REQ_EARTH_TOWER_SHOP_OPEN()");
    elseif select == 2 then
        ShowOkDlg(pc, 'GT_RELICSHOP_NPC_SEL_2_TXT_1', 1)
    elseif select == 3 then
        ShowOkDlg(pc, 'GT_RELICSHOP_NPC_SEL_3_TXT_1', 1)
--    elseif select == 4 then
--        SCR_GROUNDTOWER_ENTER_EVT_GIVE_ITEM(pc)
    end
	
end



function SCR_GT_RELICSHOP_NPC2_DIALOG(self, pc)
    local dialog_list ={}
    local dialog_classname = {
                            'GT2_RELICSHOP_NPC_SEL_1',
                            }
    dialog_list[#dialog_list+1] = ScpArgMsg("GT2_RELICSHOP_NPC_SEL_1")
    dialog_list[#dialog_list+1] = ScpArgMsg("GT2_RELICSHOP_NPC_SEL_2")
    dialog_list[#dialog_list+1] = ScpArgMsg("GT2_RELICSHOP_NPC_SEL_3")
    dialog_list[#dialog_list+1] = ScpArgMsg("GT2_RELICSHOP_NPC_SEL_4")

    local select = SCR_SEL_LIST(pc, dialog_list, dialog_classname[IMCRandom(1,#dialog_classname)])
    if select == 1 then
        ExecClientScp(pc, "REQ_EARTH_TOWER2_SHOP_OPEN()");
    elseif select == 2 then
        ShowOkDlg(pc, 'GT2_RELICSHOP_NPC_SEL_2_TXT_1', 1)
    elseif select == 3 then
        ShowOkDlg(pc, 'GT2_RELICSHOP_NPC_SEL_3_TXT_1', 1)
    elseif select == 4 then
        ShowOkDlg(pc, 'GT2_RELICSHOP_NPC_SEL_5_TXT_1', 1)
        UIOpenToPC(pc, 'exchangeantique', 1)
    end
	
end





function GT_GATE_OPEN_ANIM(self, mon)
    SetFixAnim(mon, 'OPEN')
end
--
--function G_TOWER_WARP_TO_SAVE_PC(self, pc, x, y, z, stage)
--    SetTacticsArgFloat(self, x, y, z, stage);
--    local pc_list = GetScpObjectList(self, 'GT_STAGE_PC_'..stage)
--    local i
--    for i = 1, #pc_list do
--        if IsSameObject(list[i], pc) == 0 then
--            GetScpObjectList(self, 'GT_STAGE_PC_'..stage, pc)
--            return
--        end
--    end
--end
--
--function GT_GET_PCLIST(self)
--    local x, y, z, stage = GetTacticsArgFloat(self)
--    local pc_list = GetScpObjectList(self, 'GT_STAGE_PC_'..stage)
--    local list, cnt = GetLayerPCList(self)
--
--    if cnt > 0 then
--        local i
--        for i = 1 , cnt do
--        a
--            local j
--            if #pc_list > 0 then
--                for j = 1, cnt do
--                    if IsSameObject(list[i], pc_list[j]) == 1 then
--                        break
--                    end
--                end
--            end
--            
--            
--            SCR_GT_SETPOS_FADEOUT(list[i], 'mission_groundtower_1', x, y, z, 0, stage, 4)
--        end
--    end
--end
--
--function GT_FORCE_SETPOS_PC(self, obj, stage)
--    local pc_list = GetScpObjectList(obj, 'GT_STAGE_PC_'..stage)
--    
--end 



function SCR_GT_SETPOS_FADEOUT(self, _zone, _x, _y, _z, _jump, floor, closeTime)
    RunScript('SCR_GT_SETPOS_FADEOUT_RUN', self, _zone, _x, _y, _z, _jump, floor, closeTime)
end

function SCR_GT_SETPOS_FADEOUT_RUN(self, _zone, _x, _y, _z, _jump, floor, closeTime)
    if self ~= nil then
        if _zone ~= nil then
            if _zone == GetZoneName(self) then
                if _jump == nil then
                    _jump = 0;
                end
                
                if floor == 41 then
                    PlaySoundLocal(self, "groundtower_stair");
                    UIOpenToPC(self, 'fullblack',1)
                    sleep(1200)
                    EARTH_TOWER_FLOOR_UI_OPEN_41(self, ScpArgMsg('GT_SETPOS_FADEOUT_41'), closeTime, 0)
                    sleep(1200)
                    if self ~= nil then
                        SetPos(self, _x, _y+_jump, _z)
                        sleep(1200)
                        UIOpenToPC(self,'fullblack',0)
                    end
                else
                    PlaySoundLocal(self, "groundtower_stair");
                    UIOpenToPC(self, 'fullblack',1)
                    sleep(1200)
                    EARTH_TOWER_FLOOR_UI_OPEN(self, floor, closeTime, 1)
                    sleep(1200)
                    if self ~= nil then
                        SetPos(self, _x, _y+_jump, _z)
                        sleep(1200)
                        UIOpenToPC(self,'fullblack',0)
                    end
                end
            end
        end
    end
end


function SCR_GT_SETPOS_FADEOUT_TOLL(self, _zone, _x, _y, _z, _jump, floor, closeTime)
    RunScript('SCR_GT_SETPOS_FADEOUT_TOLL_RUN', self, _zone, _x, _y, _z, _jump, floor, closeTime)
end

function SCR_GT_SETPOS_FADEOUT_TOLL_RUN(self, _zone, _x, _y, _z, _jump, floor, closeTime)
    if self ~= nil then
        if _zone ~= nil then
            local pc_list, pc_cnt = GetLayerPCList(self)
            local i
            if pc_cnt > 0 then
                for i = 1, pc_cnt do
                    if _zone == GetZoneName(pc_list[i]) then
                        if _jump == nil then
                            _jump = 0;
                        end
        --                PlaySoundLocal(self, "groundtower_stair");
                        UIOpenToPC(pc_list[i],'fullblack',1)
                        sleep(1200)
                        EARTH_TOWER_FLOOR_UI_OPEN(pc_list[i], floor, closeTime, 1)
--                        sleep(1200)
                        if pc_list[i] ~= nil then
                            SetPos(pc_list[i], _x, _y+_jump, _z)
                            UIOpenToPC(pc_list[i],'fullblack',0)
                        end
                    end
                end
                if self ~= nil then
                    RunMGame(self, 'M_GTOWER_STAGE_'..floor)
                end
            end
        end
    end
end

function SCR_GT2_FADEOUT_TOLL(self)
    sleep(5200)
    UIOpenToPC(self,'fullblack',1)
    sleep(2200)
    EARTH_TOWER_FLOOR_UI_OPEN(self, 21, 5, 1)
    sleep(1200)
    if self ~= nil then
        UIOpenToPC(self,'fullblack',0)
    end
end

function SCR_GT2_SETPOS_FADEOUT_TOLL_RUN(self, _zone, _x, _y, _z, _jump, floor, closeTime)
    if self ~= nil then
        if _zone ~= nil then
            local pc_list, pc_cnt = GetLayerPCList(self)
            local i
            if pc_cnt > 0 then
                for i = 1, pc_cnt do
--                    if _zone ~= GetZoneName(pc_list[i]) then
                        if _jump == nil then
                            _jump = 0;
                        end
        --                PlaySoundLocal(self, "groundtower_stair");
                        if self ~= nil then
                            MoveZone(pc_list[i], _zone, _x, _y+_jump, _z)
                        end
--                    end
                end
            end
        end
    end
end

function EARTH_TOWER_FLOOR_UI_OPEN_41(self, floor, closeTime, isShowFloorText)
    if floor == nil then
        return
    end
    if closeTime <= 1 then
        closeTime = 2
    end
	if isShowFloorText == nil then
		isShowFloorText = 1;
	end
	local scp = string.format("OPEN_EARTH_TOWER_OPEN(\'%s'\, %d, %d)", tostring(floor), 2, isShowFloorText);
	ExecClientScp(self, scp);
end

function EARTH_TOWER_FLOOR_UI_OPEN(self, floor, closeTime, isShowFloorText)
    if floor == nil then
        return
    end
    if closeTime <= 1 then
        closeTime = 2
    end
	if isShowFloorText == nil then
		isShowFloorText = 1;
	end
	local scp = string.format("OPEN_EARTH_TOWER_OPEN(\'%s'\, %d, %d)", tostring(floor), 2, isShowFloorText);
	ExecClientScp(self, scp);
end

function SCR_EARTH_TOWER_NEXT_FLOOR_CK(pc)
    local pc_list, pc_cnt = GetLayerPCList(pc)
    local max_pc = {}
    if pc_cnt > 0 then
        local cls = GetClass('Indun', 'M_GTOWER_2')
        local i
        for i = 1, pc_cnt do
            if pc_list[i].Lv >= cls.Level then
                max_pc[#max_pc + 1] = pc_list[i]
            end
        end
    end
    
    if #max_pc == pc_cnt then
        return 1
    else
        return 0
    end
end

function SCR_EARTH_TOWER_NEXT_FLOOR(pc, mgameValue)
	local mGameName = GetExProp_Str(pc, "NEXT_GT_MGAME_NAME");
	SetMGameValueByMGameName(pc, mGameName, mgameValue, 300)
end

function SCR_TX_EARTH_TOWER_STOP(pc, mgameValue)
	local mGameName = GetExProp_Str(pc, "NEXT_GT_MGAME_NAME");
	SetMGameValueByMGameName(pc, mGameName, mgameValue, 100)
end

function REWARD_EARTH_TOWER(cmd, curStage, eventInst, obj, MgameName)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	local pc = list[1];
	local partyObj = GetPartyObj(pc); 
	local sendRewardPacket = false;

	if partyObj == nil then
		IMC_LOG("INFO_NORMAL", "EARTH_TOWER_PARTY_OBJECT_NIL - What??????????");
	end

	local sendPartyLeader = false;
	if cnt > 0 then
		for i = 1, cnt do
			pc = list[i]

			if IsPartyLeaderPc(partyObj, pc) == 1 then
				--PROGRESS_REWARD
				sendPartyLeader = true;
				RunScript('TX_REWARD_EARTH_TOWER', pc, MgameName)
				sendRewardPacket = true;
				break;
			end
		end
	end

	if sendPartyLeader == false then
		if cnt > 0 then
			for i = 1, cnt do
				pc = list[i]

				if IsPartyLeaderPc(GetPartyObj(pc), pc) ~= 1 then
					RunScript('TX_REWARD_EARTH_TOWER', pc, MgameName)
					sendRewardPacket = true;
					break;
				end
			end
		end
	end

	if sendRewardPacket == false then
		local isParty = 0;
		if partyObj ~= nil then
			isParty = 1
		end
		IMC_LOG("INFO_NORMAL", "EARTH_TOWER_REWARD_NO_NO - isParty : "..isParty);
	end

end

function EARTH_TOWER_SAVE_PC_LIST(cmd)
	cmd:SaveNowPcList();
end

function TX_REWARD_EARTH_TOWER(pc, mGameName)

	local cls = GetClass("reward_earthtower", mGameName)
	if cls == nil then
		return;
	end

	local indunClassList, indunCount = GetClassList("Indun");

	local cmd = GetMGameCmd(pc)
	local list, cnt = GetPartyMemberList(pc, PARTY_NORMAL);
	local obj = nil;
	for i = 1, cnt do
		obj = list[i]
		local aid = GetPcAIDStr(obj);
		local cid = GetPcCIDStr(obj);
		local etcObj = GetETCObject(obj);

		local zoneName = GetZoneName(obj);
		
		local indunClass = nil;
		for i = 1, indunCount do
			local cls = GetClassByIndexFromList(indunClassList, i);
			local mapName = TryGetProp(cls, "MapName", "None");
			if mapName == zoneName then
				indunClass = cls;
				break;
			end
		end

		if indunClass ~= nil then
			local isEnableReceiveReward = false;
			local ticketItem = nil;
			if IS_ENABLE_ENTER_TO_INDUN_WEEKLY(obj, indunClass, true) == true then
				isEnableReceiveReward = true;
			else
				ticketItem = GET_AVAILABLE_GTOWER_ADMISSION_TICKET_ITEM(obj);
				if ticketItem ~= nil then
					isEnableReceiveReward = true;
				end
			end

			if isEnableReceiveReward == true then
				--if true == cmd:IsValidSavePC(aid, cid) then
					local tx = TxBegin(obj);
					TxGiveItem(tx, cls.ItemName, cls.Count, "Earth_Tower_Reward");
					if cls.ItemName2 ~= nil and cls.ItemName2 ~= 'None' and cls.Count2 > 0 then
						TxGiveItem(tx, cls.ItemName2, cls.Count2, "Earth_Tower_Reward");
					end
					local ishavetoll = GetInvItemCount(pc, 'misc_earthTower20_toll')

					if cls.ItemName3 == 'misc_earthTower20_toll' then
            			if cls.ItemName3 ~= nil and cls.ItemName3 ~= 'None' and cls.Count3 > 0 and ishavetoll == 0 then
            			    TxGiveItem(tx, cls.ItemName3, cls.Count3, "Earth_Tower_Reward");
            			end
        			elseif cls.ItemName3 ~= 'misc_earthTower20_toll' then
            			if cls.ItemName3 ~= nil and cls.ItemName3 ~= 'None' and cls.Count3 > 0  then
                			TxGiveItem(tx, cls.ItemName3, cls.Count3, "Earth_Tower_Reward");
                		end
            		end
					if ticketItem ~= nil then
						TxTakeItemByObject(tx, ticketItem, 1, "UseGTowerTicket");
					else
						TxAddIESProp(tx, etcObj, "IndunWeeklyEnteredCount_400", 1);
					end

					local ret = TxCommit(tx);
				--else
				--	SendSysMsg(obj, "NotClearChar");
				--end
			else
				CustomMongoLog(pc, "GTowerReward", "MGameName", mGameName);
			end
		end
	end
end

function GT1_LUTHA_FLOOR_KEEP(pc, floor_keep)
    if floor_keep == 6 then
        SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', 437, 150, -4930, 0, floor_keep, 5)
    elseif floor_keep == 11 then
        SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -2342, 147, -5097, 0, floor_keep, 5)
    elseif floor_keep == 16 then
        SCR_GT_SETPOS_FADEOUT(pc, 'mission_groundtower_1', -4913, 147, -4887, 0, floor_keep, 5)
    end
end

function GET_AVAILABLE_GTOWER_ADMISSION_TICKET_ITEM(pc)
	local invItemList, slotCountList = GetInvItemList(pc);
	for i = 1, #invItemList do
		local invItem = invItemList[i];

		if invItem.StringArg == "EarthTowerTicket" then
			if IsFixedItem(invItem) == 0 then
				return invItem;
			end
		end
	end

	return nil;
end

function IS_ENABLE_GTOWER_TICKET_LOCK(pc, item)
	if item.StringArg == "EarthTowerTicket" then
		local zoneName = GetZoneName(pc);
	
		if zoneName == "mission_groundtower_1" or 
			zoneName == "mission_groundtower_2" or 
			zoneName == "d_raidboss_velcoffer" then
			return false;
		end
	end

	return true;
end