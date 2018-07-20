--MON_STAGE1_BOSS_GEN_CHECK
function SCR_GM_WHITETREES_NPC1_DIALOG(self, pc)
    local dlg_check = self.NumArg1
    if dlg_check < 1 then
        local sel = ShowSelDlg(pc, 0, "GM_WHITETREES_NPC1_DLG1",ScpArgMsg("GM_WHITETREES_NPC1_SEL1"))
        if sel == 1 then
            ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG2", 1)
            self.NumArg1 = 1
        end
    elseif dlg_check == 1 then
        Chat(self, ScpArgMsg("GM_WHITETREES_NPC1_CHAT1"))
    elseif dlg_check == 2 then
        ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG3", 1)
        local pcList, pcCount = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
        if pcCount > 0 and pcList[1] ~= nil then
    		actor = pcList[1]
        	local cmd = GetMGameCmd(actor)
        	valName = "GM_WHITETREES_561_START_VAL1"
        	local curVal = cmd:GetUserValue(valName);
        	if curVal < 1 then
        	    self.NumArg1 = 3
            	curVal = 1;
    	        cmd:SetUserValue(valName, curVal);
	        end
        end
    elseif dlg_check >= 3 then
        local sel1 = ShowSelDlg(pc, 0,"GM_WHITETREES_NPC1_DLG8", ScpArgMsg("GM_WHITETREES_NPC1_SEL6"), ScpArgMsg("GM_WHITETREES_NPC1_SEL7"))
        if sel1 == 1 then
            ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG9", 1)
        elseif sel1 == 2 then
            ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG10", 1)
        end
    end
end


function SCR_GM_WHITETREES_DEBUFF_MON_HANDLE_SET(self)
    local casterHandle = GetHandle(self)
    SetMGameValue(self, 'casterHandle', casterHandle)
end

--GM_WHITETREES_NPC1_AI
function GM_WHITETREES_NPC1_AI_UPDATE(self)
    local dlg_check = self.NumArg1
    if dlg_check == 1 then
        local x, y, z = GetPos(self)
        --print(SCR_POINT_DISTANCE(x, z, -419, -176))
        if SCR_POINT_DISTANCE(x, z, -419, -176) > 20 then
            MoveEx(self, -419, -156, -176)
        elseif SCR_POINT_DISTANCE(x, z, -419, -176) <= 20 then
            self.NumArg1 = 2
        end
    end
end

function SCR_GM_WHITETREES_NPC2_DIALOG(self, pc)
    if GetInvItemCount(pc, "GM_WHITETREES_OBJ_ITEM1") >= 1 then
        local sel = ShowSelDlg(pc, 0, "GM_WHITETREES_NPC1_DLG4", ScpArgMsg("GM_WHITETREES_NPC1_SEL2"), ScpArgMsg("GM_WHITETREES_BASIC1"))
        if sel == 1 then
            RunScript("GIVE_TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM2/1","GM_WHITETREES_OBJ_ITEM1/1", "GM_WHITETREES_56_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_WHITETREES_NPC1_MSG4"), 3)
            ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG5", 1)
        end
    else
        ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG4", 1)
    end
end

function SCR_GM_WHITETREES_NPC3_DIALOG(self, pc)
    --알렉스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC1_DLG6", 1)
end

function SCR_GM_WHITETREES_NPC4_DIALOG(self, pc)
    --아우랠스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC4_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC5_DIALOG(self, pc)
    --위킨스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC5_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC6_DIALOG(self, pc)
    --미유스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC6_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC7_DIALOG(self, pc)
    --네이글스--
    if GetInvItemCount(pc, "GM_WHITETREES_OBJ_ITEM1") >= 1 then
        local sel = ShowSelDlg(pc, 0, "GM_WHITETREES_NPC7", ScpArgMsg("GM_WHITETREES_NPC1_SEL3"), ScpArgMsg("GM_WHITETREES_NPC1_SEL4"), ScpArgMsg("GM_WHITETREES_NPC1_SEL5"), ScpArgMsg("GM_WHITETREES_BASIC1"))
        if sel == 1 then
            RunScript("GIVE_TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM3/1","GM_WHITETREES_OBJ_ITEM1/1",  "GM_WHITETREES_56_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_WHITETREES_NPC1_MSG5"), 3)
            ShowOkDlg(pc, "GM_WHITETREES_NPC7_1", 1)
        elseif sel == 2 then
            RunScript("GIVE_TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM4/1","GM_WHITETREES_OBJ_ITEM1/1", "GM_WHITETREES_56_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_WHITETREES_NPC1_MSG6"), 3)
            ShowOkDlg(pc, "GM_WHITETREES_NPC7_1", 1)
        elseif sel == 3 then
            RunScript("GIVE_TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM5/1","GM_WHITETREES_OBJ_ITEM1/1", "GM_WHITETREES_56_1")
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_WHITETREES_NPC1_MSG7"), 3)
            ShowOkDlg(pc, "GM_WHITETREES_NPC7_1", 1)
        end
    else
        ShowOkDlg(pc, "GM_WHITETREES_NPC7", 1)
    end
end

function SCR_GM_WHITETREES_NPC8_DIALOG(self, pc)
    --헤르스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC8_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC9_DIALOG(self, pc)
    --드레이스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC9_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC10_DIALOG(self, pc)
    --시타스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC10_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC11_DIALOG(self, pc)
    --루파스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC11_DLG1", 1)
end

function SCR_GM_WHITETREES_NPC12_DIALOG(self, pc)
    --다니엘스--
    ShowOkDlg(pc, "GM_WHITETREES_NPC12_DLG1", 1)
end

function SCR_GM_WHITETREES_DEF_OBJ_DIALOG(self, pc)
    local obj_Mhp = self.MHP
    if obj_Mhp > self.HP then
        if GetInvItemCount(pc, "GM_WHITETREES_OBJ_ITEM1") >= 1 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("GM_WHITETREES_NPC1_MSG1"), "SIT_HAMMERING",1)
            if result == 1 then
                RunScript("TAKE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM1",1, "GM_WHITETREES_56_1")
                AddHP(self, 1)
            end
        end
    end
end

function SCR_GM_WHITETREES_OBJ_ITEM1_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("GM_WHITETREES_NPC1_MSG2"), "#SITGROPESET",2)
    if result == 1 then
        RunScript("GIVE_ITEM_TX", pc, "GM_WHITETREES_OBJ_ITEM1", 1, "GM_WHITETREES_56_1")
        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("GM_WHITETREES_NPC1_MSG3"), 3)
        Kill(self)
    end
end

function GM_WHITETREES_MONSTER_GROUP_SELECT(self)
    local numList = {1,2,3,4,5,6,7}    

    local finalList = {}
    for j = 1, 3 do
        local num = IMCRandom(1, #numList)
        local realNum = numList[num];
        table.insert(finalList, 1, realNum)
        table.remove(numList, num)
    end 
    
    for k = 1, 3 do
        SetMGameValue(self, 'TotemMonGroup_'..k, finalList[k])
    end
    --print('TotemMonGroup_Setting')
end

--arg1 스테이지 값, arg2 타입 값
function GM_WHITETREES_MONSTER_GROUP_TABLE(rank, arg1, zone, layer)    
    local list, cnt = GetLayerPCList(zone, layer)
    local actor = nil
    
    for i = 1, #list do
        if IS_PC(list[i]) == true then
            actor = list[i]
            break;
        end
    end
    
    local group = GetMGameValueByMGameName(actor, 'GM_WHITETREES_56_1', 'TotemMonGroup_'..arg1)
    local arg2 = IMCRandom(1, 5)
    if rank == nil then
        return;
    end

    local mon_group = {
                        {"GM_rodevassal", "GM_rodenag", "GM_rodenarcorng", "GM_rodeyokel", "GM_rodetad"},
                        {"GM_siaria", "GM_bloom", "GM_budny", "GM_floron", "GM_florabbi"},
                        {"GM_kucarry_symbani", "GM_kucarry_Somy", "GM_kucarry_zabbi", "GM_kucarry_Zeffi", "GM_kucarry_Tot"},
                        {"GM_horn_golem", "GM_darong", "GM_dorong", "GM_nukarong", "GM_rompelnuka"},
                        {"GM_pumpkin_dog", "GM_ragged_bird", "GM_straw_walker", "GM_ragged_butcher", "GM_Scarecrow"},
                        {"GM_aklastyke", "GM_aklaschurl", "GM_aklasbairn", "GM_aklaspetal", "GM_aklascenser"},
                        {"GM_rocktanon", "GM_rockon", "GM_rockoff", "GM_Moving_trap", "GM_Zolem_blue"}
                      }
    local boss_group = { "GMB_boss_Escarot", 
                        "GMB_boss_flowertree", 
                        "GMB_boss_kucarry_balzermancer", 
                        "GMB_boss_Gosal", 
                        "GMB_boss_JackO_lantern", 
                        "GMB_boss_aklasprincess", 
                        "GMB_boss_molich" }
                        
    local changeMon = ''

    if rank == 'Boss' then
        changeMon = boss_group[group]
        return changeMon
    else
        changeMon = mon_group[group][arg2]
        return changeMon
    end
end

function GM_WHITETREES_MONSTER_STAGE_SET(self, num)
    local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
    local stage
    if pcCount > 0 and pcList[1] ~= nil then
		actor = pcList[1]
    	local cmd = GetMGameCmd(actor)
    	stage = cmd:GetUserValue('TotemMonGroup_'..num);
    end
    return stage;
end

function GM_WHITETREES_MONSTER_STAGE1_CHANGE(self, zoneObj, arg2, zone, layer)
    local stage = 1
    local rank = self.MonRank
    local mon = GM_WHITETREES_MONSTER_GROUP_TABLE(rank, stage, zone, layer)
    
    return mon
end

function GM_WHITETREES_MONSTER_STAGE2_CHANGE(self, zoneObj, arg2, zone, layer)
    local stage = 2
    local rank = self.MonRank
    local mon = GM_WHITETREES_MONSTER_GROUP_TABLE(rank, stage, zone, layer)
    
    return mon
end

function GM_WHITETREES_MONSTER_STAGE3_CHANGE(self, zoneObj, arg2, zone, layer)
    local stage = 3
    local rank = self.MonRank
    local mon = GM_WHITETREES_MONSTER_GROUP_TABLE(rank, stage, zone, layer)
    
    return mon
end


function GM_WHITETREES_ST2_GEN1_TIMECHECK(cmd, curStage, eventInst, obj)
    MGAME_ST_EVT_COND_RND_TIMECHECK(cmd, curStage, eventInst, obj, "GM_WHITETREES_ST2_GEN1_TIME")
end

function GM_WHITETREES_ST2_GEN2_TIMECHECK(cmd, curStage, eventInst, obj)
    MGAME_ST_EVT_COND_RND_TIMECHECK(cmd, curStage, eventInst, obj, "GM_WHITETREES_ST2_GEN2_TIME")
end

function MGAME_ST_EVT_COND_RND_TIMECHECK(cmd, curStage, eventInst, obj, valName)
	eventInst = tolua.cast(eventInst, "STAGE_EVENT_INST_INFO");
	local lastExecSec = eventInst:GetUserValue("TIME");
	if lastExecSec == 0.0 then
		eventInst:SetUserValue("TIME", imcTime.GetAppTime());
		return 0;
	end
    
    local tiem = cmd:GetUserValue(valName);
	local curTime = imcTime.GetAppTime();
	if curTime > lastExecSec + tiem then
		eventInst:SetUserValue("TIME", curTime);
		return 1;
	end

	return 0;
end


function GM_WHITETREES_ST2_GEN1(cmd, curStage, eventInst, obj, time)
    local ran_Tiem = IMCRandom(20, 30) --600, 3000
    cmd:SetUserValue("GM_WHITETREES_ST2_GEN_TIME", ran_Tiem);
    local tiem = cmd:GetUserValue("GM_WHITETREES_ST2_GEN1_TIME");
end

function GM_WHITETREES_ST2_GEN2(cmd, curStage, eventInst, obj, time)
    local ran_Tiem = IMCRandom(20, 30) --600, 3000
    cmd:SetUserValue("GM_WHITETREES_ST2_GEN_TIME", ran_Tiem);
    local tiem = cmd:GetUserValue("GM_WHITETREES_ST2_GEN2_TIME");
end

function SCR_GM_WHITETREES_DEF_SET_POINT1_DIALOG(self, pc)
    GM_WHITETREES_DEF_OBJ_SETTING(self, pc, "GM_stake_stockades", "GM_WHITETREES_OBJ_ITEM5")
end

function SCR_GM_WHITETREES_DEF_SET_POINT2_DIALOG(self, pc)
    GM_WHITETREES_DEF_OBJ_SETTING(self, pc, "Large_crossbow", "GM_WHITETREES_OBJ_ITEM3")
end

function SCR_GM_WHITETREES_DEF_SET_POINT3_DIALOG(self, pc)
    GM_WHITETREES_DEF_OBJ_SETTING(self, pc, "arrow_trap", "GM_WHITETREES_OBJ_ITEM4")
end

function GM_WHITETREES_DEF_OBJ_SETTING(self, pc, objName, itemName)
    if GetInvItemCount(pc, itemName) >= 1 then
        local x, y, z = GetPos(self)
        local anchor = 0
        if objName == "GM_stake_stockades" then
            if SCR_POINT_DISTANCE(x, z, -347, 71) > 5 or SCR_POINT_DISTANCE(x, z, -293, 30) > 5 or SCR_POINT_DISTANCE(x, z, -273, 119) > 5 or SCR_POINT_DISTANCE(x, z, -320, 52) > 5 or SCR_POINT_DISTANCE(x, z, -289, 136) > 5 then
                anchor = 45
            else
                anchor = -34
            end
        end
        local def_Obj = CREATE_NPC_EX(pc, objName, x, y, z, anchor, "Neutral", "UnvisibleName", 1, DEF_OBJ_SETTING)
        RunScript("TAKE_ITEM_TX", pc, itemName, 1, "GM_WHITETREES_56_1")
        Kill(self)
    end
end

function DEF_OBJ_SETTING(def_Obj)
    if def_Obj.ClassName == "GM_stake_stockades" then
        def_Obj.SimpleAI = "GM_WHITETREES_DEF_STAKE"
    elseif def_Obj.ClassName == "GM_Large_crossbow" then
        def_Obj.SimpleAI = "GM_WHITETREES_DEF_CROSSBOW"
    elseif def_Obj.ClassName == "GM_arrow_trap" then
        def_Obj.SimpleAI = "GM_WHITETREES_DEF_ARROW"
    end
end

--GM_WHITETREES_OBEL_OBJ_AI
function GM_WHITETREES_OBEL_OBJ_SETTING(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    
    local Prop_01 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL1')
    local Prop_02 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL2')
    local Prop_03 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL3')
    
    if self.NumArg1 == 1 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL1', 1)
    elseif self.NumArg1 == 2 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL2', 1)
    elseif self.NumArg1 == 3 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL3', 1)
    end
end

function GM_WHITETREES_OBEL_OBJ_DESTROY(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    
    local Prop_01 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL1')
    local Prop_02 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL2')
    local Prop_03 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL3')
    
    if self.NumArg1 == 1 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL1', 2)
    elseif self.NumArg1 == 2 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL2', 2)
    elseif self.NumArg1 == 3 then
        SetExProp(zon_Obj, 'GM_WHITETREES_OBEL3', 2)
    end
end

--GM_WHITETREES_MON_AI
function GM_WHITETREES_MON_BUFF_CHECK_AI(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    
    local Prop_01 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL1')
    local Prop_02 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL2')
    local Prop_03 = GetExProp(zon_Obj, 'GM_WHITETREES_OBEL3')
    
    if Prop_01 == 1 then
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF1") == "NO" then
            AddBuff(self, self, "GM_WHITETREES_MON_BUFF1", 1, 0, 0, 1)
        end
    else
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF1") == "YES" then
            RemoveBuff(self, "GM_WHITETREES_MON_BUFF1")
        end
    end
    
    if Prop_02 == 1 then
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF2") == "NO" then
            AddBuff(self, self, "GM_WHITETREES_MON_BUFF2", 1, 0, 0, 1)
        end
    else
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF2") == "YES" then
            RemoveBuff(self, "GM_WHITETREES_MON_BUFF2")
        end
    end
    
    if Prop_03 == 1 then
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF3") == "NO" then
            AddBuff(self, self, "GM_WHITETREES_MON_BUFF3", 1, 0, 0, 1)
        end
    else
        if IsBuffApplied(self, "GM_WHITETREES_MON_BUFF3") == "YES" then
            RemoveBuff(self, "GM_WHITETREES_MON_BUFF3")
        end
    end
end

--GM_WHITETREES_GIMMICK_MON1_AI
function GM_WHITETREES_GIMMICK_MON1_UPDATE(self)
    local pc_obj = GetWorldObjectList(self, "PC", 100)
    
    local pc_list = GetScpObjectList(self, "GM_WHITETREES_TAGET_PC")
    if pc_list[1] ~= nil and IsDead(pc_list[1]) == 1 then
        ClearScpObjectList(self, 'GM_WHITETREES_TAGET_PC')
    end
    
    if #pc_obj >= 1 then
        if #pc_list < 1 then
            for i = 1, #pc_obj do
                if pc_obj[i] ~= nil and IsDead(pc_obj[i]) == 0 then
                    AddScpObjectList(self, "GM_WHITETREES_TAGET_PC", pc_obj[i]);
                    return 0;
                end
            end
        elseif #pc_list >= 1 then
            if self.NumArg1 <= 2 then
                self.NumArg1 = self.NumArg1 + 1
            elseif self.NumArg1 >= 3 then
                local mon_x, mon_y, mon_z = GetPos(self)
                local pc_x, pc_y, pc_z = GetPos(pc_list[1])
                if SCR_POINT_DISTANCE(pc_x, pc_z, mon_x, mon_z) > 10 then
                    MoveEx(self, pc_x, pc_y, pc_z, 1)
                    return 0;
                end
            end
        end
    end
    
    if IsNearFrom(self, self.CreateX, self.CreateZ, 300) ~= "YES" then
        ClearScpObjectList(self, 'GM_WHITETREES_TAGET_PC')
        SetPos(self, self.CreateX, self.CreateY, self.CreateZ)
    end
        
    if #pc_obj < 1 then
        if self.NumArg1 > 1 then
            self.NumArg1 = self.NumArg1 - 1
            ClearScpObjectList(self, 'GM_WHITETREES_TAGET_PC')
            SetPos(self, self.CreateX, self.CreateY, self.CreateZ)
        end
    end
end

function SCR_GM_WHITETREES_GIMMICK_MON1_ENTER(self, obj)
    if obj.ClassName ~= "npc_Obelisk_broken" then
        if IsBuffApplied(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1") == "NO" then
            AddBuff(self, obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1", 1, 0, 0, 1)
        else
            local buff = GetBuffByName(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1");
            local buff_stack = GetOver(buff)
            if buff_stack >= 1 then
                AddBuff(self, obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1", 1, 0, 0, 1)
            end
        end
    end
end

function SCR_GM_WHITETREES_GIMMICK_MON1_IN_LEAVE(self, obj)
    if IsBuffApplied(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1") == "YES" then
        local buff = GetBuffByName(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1");
        local buff_stack = GetOver(buff)
        if buff_stack > 1 then
            AddBuff(self, obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1", 1, 0, 0, -1)
            local buff1 = GetBuffByName(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1");
            local buff_stack1 = GetOver(buff1)
        else
            RemoveBuff(obj, "GM_WHITETREES_GIMMICK_MON1_BUFF1")
        end
    end
end

function GM_WHITETREES_GIMMICK_MON1_SET(self)
    self.Enter = "GM_WHITETREES_GIMMICK_MON1"
    self.Leave = "GM_WHITETREES_GIMMICK_MON1_IN"
    self.OnlyPCCheck = "NO"
    self.SimpleAI = "GM_WHITETREES_GIMMICK_MON1"
    self.MoveType = "Normal"
    self.Range = 50
end


function GM_WHITETREES_GIMMICK_MON2_SET(mon)
    mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "GM_WHITETREES_GIMMICK_MON2";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
end

--GM_WHITETREES_GIMMICK_MON2
function GM_WHITETREES_GIMMICK_MON2_UPDATE(self)
--self.NumArg1 : hit count
--self.NumArg2 : hit count
--self.NumArg3 : life time
    if self.NumArg1 >= 1 then
        if self.NumArg3 > 0 then
            self.NumArg3 = self.NumArg3 - 1
            local alpha_num = 255-(2*(120-self.NumArg3))
            ObjectColorBlend(self, 255, alpha_num, alpha_num, 255, 1)
        elseif self.NumArg3 <= 0 then
            if IsDead(self) == 0 then
                DetachEffect(self, "F_circle005")
                DetachEffect(self, "I_force019_violet")
                PlayEffect(self, "F_explosion013", 1, 1, "MID")
                local obj, cnt = SelectObject(self, 100, "ALL")
                if cnt >= 1 then
                    for i = 1, cnt do
                        if obj[i] == "GM_Obelisk" then
                            TakeDamage(obj[i], obj[i], "None", 700000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                        else
                            TakeDamage(obj[i], obj[i], "None", 10000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                        end
                    end
                end
                Kill(self)
            end
        end
    end
end

function GM_WHITETREES_GIMMICK_MON2_HIT(self, from, skl, damage, ret)
    if self.NumArg1 < self.NumArg2 then
    	if ret ~= nil and skl ~= nil then --and true == IS_PC(from)
    	    ret.Damage = 0;
            if GetDistance(self, from) < 40  then
        	    local x, y, z = GetFrontPos(from, 80);
        		local key = GetSkillSyncKey(from, ret);
        		StartSyncPacket(from, key);
        		Move3D(self, x, y, z, 300, 0, 1, 1);
        		EndSyncPacket(from, key);
        		ret.HitDelay = 0;
            end
        end
    elseif self.NumArg1 >= self.NumArg2 then
        DetachEffect(self, "F_circle005")
        DetachEffect(self, "I_force019_violet")
        PlayEffect(self, "F_explosion013", 1, 1, "MID")
        local obj, cnt = SelectObject(self, 100, "ALL")
        if cnt >= 1 then
            for i = 1, cnt do
                if obj[i] == "GM_Obelisk" then
                    TakeDamage(obj[i], obj[i], "None", 700000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                else
                    TakeDamage(obj[i], obj[i], "None", 10000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                end
            end
        end
        Kill(self)
    end
    self.NumArg1 = self.NumArg1 + 1
end

function GM_WHITETREES_GIMMICK_MON2_DEAD(self)
    local obj, cnt = SelectObject(self, 100, "ALL")
    if cnt >= 1 then
        for i = 1, #cnt do
            TakeDamage(self, obj[i], "None", 1000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
        end
    end
end

function GM_WHITETREES_GIMMICK_MON2_TAKEDAMAGE(self, from, skl, damage, ret)
	damage = 0;
	if ret == nil then
		return;
	end
	ret.Damage = 0;
end

function MON_BORN_GM_WHITETREEES_STAKE_STOCKADES_PAD(self)
    local px, py, pz = GetPos(self)
    RunPad(self, "gm_stake_stockades_knokdown", nil, px, py, pz, 0, 1)
end

function SCR_GM_WHITETREES_HIDDN_NPC_ENTER(self, pc)
    if IsBuffApplied(pc, "GM_WHITETREES_BUFF1_1") == "NO" then
        AddBuff(self, pc, "GM_WHITETREES_BUFF1_1", 1, 0, 0, 1)
    end
end

function SCR_GM_WHITETREES_HIDDN_NPC_OUT_LEAVE(self, pc)
    if IsBuffApplied(pc, "GM_WHITETREES_BUFF1_1") == "YES" then
        RemoveBuff(pc, "GM_WHITETREES_BUFF1_1")
    end
end

function GM_WHITETREEES_STAKE_STOCKADES_DEAD(self)
    Dead(self)
end