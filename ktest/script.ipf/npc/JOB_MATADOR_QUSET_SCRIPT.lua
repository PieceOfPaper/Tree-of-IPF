--JOB_MATADOR_QUSET_SCRIPT
--JOB_MATADOR1_NPC
function SCR_JOB_MATADOR1_Q_OBJ_ENTER(self, pc)
end

function SCR_JOB_MATADOR1_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_MATADOR1_NPC1_DIALOG(self, pc)
    ShowOkDlg(pc, "JOB_MATADOR1_prog4", 1)
end

--JOB_MATADOR_MON_GOAL IN
function SCR_JOB_MATADOR_MON_GOAL_IN_ENTER(self, mon)
    if mon.ClassName ~= "PC" then
--        if mon.Faction == "Monster" then
            if mon.SimpleAI == "JOB_MATADOR1_MON_AI" then
                local pc_Obj, cnt = GetLayerPCList(self)
                StopMove(mon)
                ResetHated(mon)
                ResetHateAndAttack(mon);
                CancelMonsterSkill(mon);
                SetCurrentFaction(mon, "Neutral");
                --ClearSimpleAI(mon, "JOB_MATADOR1_MON_AI");
                if cnt > 0 then
                    local i
                    local point
                    for i = 1, cnt do
                        local sObj = GetSessionObject(pc_Obj[i], "SSN_JOB_MATADOR1")
                        if sObj ~= nil then
                            if mon.ClassName == "stub_tree" then
                                sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 3
                                point = 3
                                sObj.String1 = "ON"
                            end
                            if mon.ClassName == "TreeAmbulo" then
                                sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 2
                                point = 2
                                sObj.String1 = "ON"
                            end
                            if mon.ClassName == "Tama" then
                                sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                                point = 1
                                sObj.String1 = "ON"
                            end
                            if SCR_MATADOR1_SUCCESS3(pc_Obj[i]) == 'YES' and sObj.Step13 == 0 then
                                CustomMongoLog(pc_Obj[i], "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 3)
                                --print("3333333333333333")
                                sObj.Step13 = 1
                            elseif SCR_MATADOR1_SUCCESS2(pc_Obj[i]) == 'YES' and sObj.Step12 == 0 then
                                CustomMongoLog(pc_Obj[i], "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 2)
                                --print("2222222222222222")
                                sObj.Step12 = 1
                            elseif SCR_MATADOR1_SUCCESS1(pc_Obj[i]) == 'YES' and sObj.Step11 == 0 then
                                CustomMongoLog(pc_Obj[i], "SpecialtyQuestClearStep", "QuestName", sObj.QuestName, "ClearStep", 1)
                                --print("1111111111111111")
                                sObj.Step11 = 1
                            end
                            SaveSessionObject(pc_Obj[i], sObj)
                        end
                        --PlayTextEffect(self, 'I_SYS_Text_Effect_Skill', ScpArgMsg('JOB_MATADOR1_ITEM_MSG6','COUNT',point))
                        SendAddOnMsg(pc_Obj[i], "NOTICE_Dm_Clear",ScpArgMsg("JOB_MATADOR1_ITEM_MSG3").." "..sObj.QuestInfoValue1, 5);
                        break
                    end
                PlayEffect(mon, "F_light013", 3, "BOT")
                Kill(mon)
                end
            end
--        end
    end
end

--JOB_MATADOR1_MON_AI
function JOB_MATADOR_MON_BORN_FUNC(self)
    if self.ClassName == "stub_tree" then
        self.RunMSPD = 80
        self.WlkMSPD = 80
        AttachEffect(self, "F_haste_buff_green", 0.4, "BOT", 1)
    elseif self.ClassName == "TreeAmbulo" then
        self.RunMSPD = 50
        self.WlkMSPD = 50
    elseif self.ClassName == "Tama" then
        self.RunMSPD = 50
        self.WlkMSPD = 50
    end
    SetNoDamage(self)
end

function JOB_MATADOR_MON_FUNC(self)
    if IsBuffApplied(self, "JOB_MATADOR1_TRAP1_BUFF") == "YES" then
        StopMove(self)
        return 0;
    end
    if IsBuffApplied(self, "JOB_MATADOR1_ITEM_BUFF1") == "NO" then
        if self.StrArg1 == "JOB_MATADOR_QMONSTER" then
            ResetHated(self)
            ResetHateAndAttack(self);
            CancelMonsterSkill(self);
            SetCurrentFaction(self, "Neutral");
            local bt = CreateBTree("BasicMonster");
	        SetBTree(self, bt);
            self.StrArg1 = "NEUTRAL"
            return 0;
        end
    elseif IsBuffApplied(self, "JOB_MATADOR1_ITEM_BUFF1") == "YES" then
        local topHatePC = GetTopHatePointChar(self);
        if topHatePC == nil then
            local list, cnt = SelectObject(self, 500, "ALL")
            if cnt >= 1 then
                --ResetHate(self)
                local zoneName = GetZoneName(self);
                local classList = GetClassList('Map');
                if classList ~= nil then
                    local class = GetClassByNameFromList(classList, zoneName);
                    if class ~= nil then
                        local maxHatePC = 1;
                        if class.MaxHateCount ~= nil then
                            maxHatePC = class.MaxHateCount;
                        end
                        
                        for i = 1, cnt do
                            if list[i].ClassName == "PC" then
                                if GetHatedCount(list[i]) < maxHatePC then
                                    InsertHate(self, list[i], 1);
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        else
            --print(topHatePC)
            if IsDead(topHatePC) == 1 then
                ResetHated(self)
            else
                S_AI_ATTACK_NEAR(self, 500);
            end
        end
        return 1;
    end
    return 0;
end

--MATADOR_MON_TRAP1_AI_ENTER
function SCR_MATADOR_MON_TRAP1_AI_ENTER(self, mon)
    if mon.ClassName ~= "PC" then
        if mon.SimpleAI == "JOB_MATADOR1_MON_AI" then
            if IsBuffApplied(mon, "JOB_MATADOR1_TRAP1_BUFF") == "NO" then
                AddBuff(self, mon, "JOB_MATADOR1_TRAP1_BUFF", 1, 0, 5000, 1)
                if IsBuffApplied(mon, "JOB_MATADOR1_ITEM_BUFF1") == "YES" then
                    RemoveBuff(mon, "JOB_MATADOR1_ITEM_BUFF1")
                end
                local pc_Obj, cnt = GetLayerPCList(self)
                if cnt >= 1 then
                    for i = 1, cnt do
                        SendAddOnMsg(pc_Obj[i], 'NOTICE_Dm_!', ScpArgMsg("JOB_MATADOR1_ITEM_MSG7"), 5)
                        break;
                    end
                end
                Kill(self)
            end
        end
    end
end

--MATADOR_MON_TRAP1_1_AI
function MATADOR_MON_TRAP1_1_AI_UPDATE(self)
    local arr1 = {619, 1178, 422}
    local arr2 = {775, 1178, 514}
    local arr3 = {701, 1179, 371}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_1_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP1_2_AI
function MATADOR_MON_TRAP1_2_AI_UPDATE(self)
    local arr1 = {569, 1178, 674}
    local arr2 = {464, 1178, 645}
    local arr3 = {675, 1178, 666}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_2_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP1_3_AI
function MATADOR_MON_TRAP1_3_AI_UPDATE(self)
    local arr1 = {586, 1178, 553}
    local arr2 = {493, 1177, 495}
    local arr3 = {722, 1178, 587}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_3_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP1_4_AI
function MATADOR_MON_TRAP1_4_AI_UPDATE(self)
    local arr1 = {718, 1178, 512}
    local arr2 = {747, 1178, 682}
    local arr3 = {444, 1177, 497}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_4_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP1_5_AI
function MATADOR_MON_TRAP1_5_AI_UPDATE(self)
    local arr1 = {715, 1178, 656}
    local arr2 = {838, 1178, 535}
    local arr3 = {717, 1178, 453}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_5_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP1_6_AI
function MATADOR_MON_TRAP1_6_AI_UPDATE(self)
    local arr1 = {501, 1178, 573}
    local arr2 = {626, 1178, 705}
    local arr3 = {559, 1178, 551}
    MATADOR_MON_TRAP1_5_AI_SET(self, "TRAP1_6_MAIN_MON", "TRAP1_SUB_MON", arr1, arr2, arr3)
end

function MATADOR_MON_TRAP1_5_AI_SET(self, main_obj_name, sub_obj_name, arr1, arr2, arr3)
    local Trap1_1 = GetScpObjectList(self, main_obj_name)
    if #Trap1_1 == 0 then
        local x, y, z = GetPos(self)
        if self.StrArg1 ~= "START" then
            if self.StrArg2 == nil or self.StrArg2 == "None" then
                self.StrArg2 = '1'
            end
            local x, y, z = TRAP_POS_SET(1, 3, self.StrArg2, arr1, arr2, arr3, obj_name)
            local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_2', x, y, z, 0, 'Neutral', nil, MATADOR_MON_TRAP1_AI_SETTING);
            AddScpObjectList(self, main_obj_name, mon)
            AddScpObjectList(mon, sub_obj_name, self)
            AttachEffect(mon, "I_smoke009_green", 0.6, 1, "BOT",1)
            AttachEffect(mon, "I_circle001", 1.9, 1, "BOT",1)
            self.StrArg1 = "START"
--            print("MATADOR_MON_TRAP1_5_AI_SET CRE")
        elseif self.StrArg1 == "START" then
            self.NumArg1 = self.NumArg1 + 1
            if self.NumArg1 > 20 then
                local x, y, z = TRAP_POS_SET(1, 3, self.StrArg2, arr1, arr2, arr3, obj_name)
                local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_2', x, y, z, 0, 'Neutral', nil, MATADOR_MON_TRAP1_AI_SETTING);
                AddScpObjectList(self, main_obj_name, mon)
                AddScpObjectList(mon, sub_obj_name, self)
                AttachEffect(mon, "I_smoke009_green", 0.6, 1, "BOT",1)
                AttachEffect(mon, "I_circle001", 1.9, 1, "BOT",1)
                self.NumArg1 = 0
--                print("MATADOR_MON_TRAP1_5_AI_SET REGEN", self.NumArg1)
            end
        end
    end
end

function MATADOR_MON_TRAP1_AI_SETTING(mon)
    mon.Enter = "MATADOR_MON_TRAP1_AI"
    mon.Name = ScpArgMsg("JOB_MATADOR1_ITEM_MSG12")
    mon.OnlyPCCheck = "NO"
    mon.Range = 15
end

--MATADOR_MON_TRAP1_AI_ENTER
function SCR_MATADOR_MON_TRAP2_AI_ENTER(self, mon)

end

--MATADOR_MON_TRAP2_1_AI
function MATADOR_MON_TRAP2_1_AI_UPDATE(self)
    local arr1 = {799, 1178, 646}
    local arr2 = {559, 1178, 676}
    local arr3 = {796, 1178, 598}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_1_MON", "TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_2_AI
function MATADOR_MON_TRAP2_2_AI_UPDATE(self)
    local arr1 = {860, 1178, 553}
    local arr2 = {493, 1178, 590}
    local arr3 = {498, 1178, 649}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_2_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_3_AI
function MATADOR_MON_TRAP2_3_AI_UPDATE(self)
    local arr1 = {620, 1178, 658}
    local arr2 = {549, 1178, 522}
    local arr3 = {845, 1178, 551}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_2_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_4_AI
function MATADOR_MON_TRAP2_4_AI_UPDATE(self)
    local arr1 = {797, 1178, 522}
    local arr2 = {833, 1178, 576}
    local arr3 = {852, 1178, 591}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_4_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_5_AI
function MATADOR_MON_TRAP2_5_AI_UPDATE(self)
    local arr1 = {683, 1178, 406}
    local arr2 = {643, 1178, 446}
    local arr3 = {691, 1178, 514}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_5_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_6_AI
function MATADOR_MON_TRAP2_6_AI_UPDATE(self)
    local arr1 = {486, 1178, 637}
    local arr2 = {462, 1178, 791}
    local arr3 = {458, 1178, 791}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_6_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP2_7_AI
function MATADOR_MON_TRAP2_7_AI_UPDATE(self)
    local arr1 = {525, 1177, 476}
    local arr2 = {551, 1178, 470}
    local arr3 = {503, 1178, 535}
    MATADOR_MON_TRAP2_AI_SET(self, "TRAP2_7_MON","TRAP2_MON_SUB", arr1, arr2, arr3)
end

function MATADOR_MON_TRAP2_AI_SET(self, main_obj_name, sub_obj_name, arr1, arr2, arr3)
    local ADVANTAGE1_1 = GetScpObjectList(self, main_obj_name)
    if #ADVANTAGE1_1 == 0 then
        local x, y, z = GetPos(self)
        --print(self.StrArg1)
        if self.StrArg1 ~= "START" then
            if self.StrArg2 == nil or self.StrArg2 == "None" then
                self.StrArg2 = '1'
            end
            local x, y, z = TRAP_POS_SET(1, 3, self.StrArg2, arr1, arr2, arr3, obj_name)
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc', x, y, z, 0, 'Neutral', nil, MATADOR_MON_TRAP2_AI_SETTING);
            AddScpObjectList(self, main_obj_name, mon)
            AddScpObjectList(mon, sub_obj_name, self)
            AttachEffect(mon, "F_ground100_green", 0.7, 1, "BOT",1)
            self.StrArg1 = "START"
--            print("MATADOR_MON_TRAP2_AI_SET REGEN")
        end
    end
end

function MATADOR_MON_TRAP2_AI_SETTING(self, obj_name)
    self.SimpleAI = "TRAP2_MON_AI"
end

--TRAP2_MON_AI
function TRAP2_MON_AI_UPDATE(self)
    local obj_List, obj_Cnt = GetWorldObjectList(self, "PC", 20)
    if obj_Cnt >= 1 then
        for i = 1 ,obj_Cnt do
            if obj_List[i].ClassName == "PC" then
                if IsBuffApplied(self, "JOB_MATADOR1_TRAP2_BUFF") == "NO" then
                    AddBuff(self, obj_List[i], "JOB_MATADOR1_TRAP2_BUFF", 1, 0, 3000, 1)
                    SendAddOnMsg(obj_List[i], "NOTICE_Dm_scroll", ScpArgMsg("JOB_MATADOR1_ITEM_MSG9"), 5)
                end
            end
        end
    end
end

--MATADOR_MON_TRAP3_AI(CHANGE PATTERN TRAP)
function MATADOR_MON_TRAP3_AI_SET(self, main_obj_name, sub_obj_name, arr1, arr2, arr3)
    local Trap1_1 = GetScpObjectList(self, main_obj_name)
    --print(arr1, arr2, arr3)
    if #Trap1_1 == 0 then
        if self.StrArg1 ~= "START" then
            if self.StrArg2 == nil or self.StrArg2 == "None" then
                self.StrArg2 = '1'
            end
            local x, y, z = TRAP_POS_SET(1, 3, self.StrArg2, arr1, arr2, arr3, obj_name)
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc', x, y, z, 0, 'Neutral', nil, MATADOR_MON_TRAP3_AI_SETTING);
            AddScpObjectList(self, main_obj_name, mon)
            AddScpObjectList(mon, sub_obj_name, self)
--            print("MATADOR_MON_TRAP3_AI_SET CRE")
            self.StrArg1 = "START"
        end
    end
end

function MATADOR_MON_TRAP3_AI_SETTING(mon)
    mon.SimpleAI = "MATADOR_TRAPMON_CHANGE_PATTERN_AI"
    mon.Range = 30
end

--MATADOR_MON_TRAP1_AI_ENTER
function SCR_MATADOR_MON_TRAP2_AI_ENTER(self, mon)

end

--MATADOR_MON_TRAP3_1_AI
function MATADOR_MON_TRAP3_1_AI_UPDATE(self)
    local arr1 = {860, 1178, 553}
    local arr2 = {540, 1178, 802}
    local arr3 = {574, 1178, 661}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_1_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_2_AI
function MATADOR_MON_TRAP3_2_AI_UPDATE(self)
    local arr1 = {799, 1178, 593}
    local arr2 = {818, 1178, 610}
    local arr3 = {770, 1178, 519}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_2_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_3_AI
function MATADOR_MON_TRAP3_3_AI_UPDATE(self)
    local arr1 = {684, 1178, 587}
    local arr2 = {693, 1178, 532}
    local arr3 = {766, 1178, 672}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_3_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_4_AI
function MATADOR_MON_TRAP3_4_AI_UPDATE(self)
    local arr1 = {582, 1178, 376}
    local arr2 = {581, 1178, 393}
    local arr3 = {639, 1178, 428}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_4_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_5_AI
function MATADOR_MON_TRAP3_5_AI_UPDATE(self)
    local arr1 = {527, 1178, 577}
    local arr2 = {566, 1178, 599}
    local arr3 = {460, 1178, 591}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_5_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_6_AI
function MATADOR_MON_TRAP3_6_AI_UPDATE(self)
    local arr1 = {562, 1178, 800}
    local arr2 = {433, 1178, 568}
    local arr3 = {560, 1178, 803}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_6_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_7_AI
function MATADOR_MON_TRAP3_7_AI_UPDATE(self)
    local arr1 = {696, 1178, 471}
    local arr2 = {708, 1178, 422}
    local arr3 = {635, 1178, 575}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_7_MON", "TRAP3_SUB_MON", arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_8_AI
function MATADOR_MON_TRAP3_8_AI_UPDATE(self)
    local arr1 = {454, 1177, 476}
    local arr2 = {663, 1178, 631}
    local arr3 = {521, 1177, 457}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_8_MON", "TRAP3_SUB_MON",arr1, arr2, arr3)
end

--MATADOR_MON_TRAP3_9_AI
function MATADOR_MON_TRAP3_9_AI_UPDATE(self)
    local arr1 = {493, 1178, 744}
    local arr2 = {500, 1178, 717}
    local arr3 = {498, 1178, 722}
    MATADOR_MON_TRAP3_AI_SET(self, "TRAP3_9_MON", "TRAP3_SUB_MON",arr1, arr2, arr3)
end

--MATADOR_TRAPMON_CHANGE_PATTERN_AI
function MATADOR_TRAPMON_CHANGE_PATTERN_AI_UPDATE(self)
    --self.NumArg1 : time count
    --self.NumArg2 : ran value
    --self.NumArg3 : effect time count
    --self.StrArg1 : ran value check
    --self.StrArg2 : effect check
    if self.StrArg1 ~= "RANDOMCHECK" then
        local ran = IMCRandom(60, 70)
        self.StrArg1 = 'RANDOMCHECK'
        self.NumArg4 = ran
    elseif self.StrArg1 == "RANDOMCHECK" then
        if self.NumArg1 >= self.NumArg4+10 then
            self.NumArg1 = 0
            self.NumArg3 = 0
            self.StrArg1 = "None"
            self.StrArg2 = "None"
            DetachEffect(self, "F_spread_in032_rize_loop")
        elseif self.NumArg1 >= self.NumArg4 then
            if self.StrArg2 ~= "ON" then
                AttachEffect(self, "F_spread_in032_rize_loop", 1.9, 1, "BOT")
                self.StrArg2 = "ON"
            end
            local obj_List, obj_Cnt = SelectObject(self, 35, 'ALL')
            if obj_Cnt > 0 then
                for i = 1, obj_Cnt do
                    if obj_List[i].ClassName == "PC" or obj_List[i].ClassName == "stub_tree" or obj_List[i].ClassName == "TreeAmbulo" or obj_List[i].ClassName == "Tama" then
                        if IsBuffApplied(obj_List[i], "JOB_MATADOR1_ITEM_BUFF3") == "NO" then
                            AddBuff(self, obj_List[i], "JOB_MATADOR1_ITEM_BUFF3")
                        end
                    end
                end
            end
            self.NumArg1 = self.NumArg1 + 1
        elseif self.NumArg1 >= self.NumArg4 - 10 then
            if self.NumArg3 < 4 then
                self.NumArg3 = self.NumArg3 + 1
                self.NumArg1 = self.NumArg1 + 1
            elseif self.NumArg3 >= 4 then
                PlayEffect(self, "F_explosion050_fire_blue", 1)
                self.NumArg3 = 0
            end
        elseif self.NumArg1 < self.NumArg4 then
            self.NumArg1 = self.NumArg1 + 1
        end
    end
end

--MATADOR_MON_ADVANTAGE1_AI_ENTER
function SCR_MATADOR_MON_ADVANTAGE1_ENTER(self, mon)
    if mon.ClassName ~= "PC" then
        if mon.SimpleAI == "JOB_MATADOR1_MON_AI" then
            if IsBuffApplied(mon, "JOB_MATADOR1_ITEM_BUFF1") == "YES" then
                AddBuff(self, mon, "JOB_MATADOR1_ITEM_BUFF1", 1, 0, 10000, 1)
                local pc_Obj, cnt = GetLayerPCList(self)
                if cnt >= 1 then
                    for i = 1, cnt do
                        SendAddOnMsg(pc_Obj[i], 'NOTICE_Dm_scroll', ScpArgMsg("JOB_MATADOR1_ITEM_MSG8"), 5)
                        break;
                    end
                end
                Kill(self)
            end
        end
    end
end

--MATADOR_MON_ADVANTAGE1_AI
function MATADOR_MON_ADVANTAGE1_AI_UPDATE(self)
    MATADOR_MON_ADVANTAGE3_AI_SET(self, "ADVANTAGE1_1_MON")
end

--MATADOR_MON_ADVANTAGE2_AI
function MATADOR_MON_ADVANTAGE2_AI_UPDATE(self)
    MATADOR_MON_ADVANTAGE3_AI_SET(self, "ADVANTAGE1_2_MON")
end

--MATADOR_MON_ADVANTAGE3_AI
function MATADOR_MON_ADVANTAGE3_AI_UPDATE(self)
    MATADOR_MON_ADVANTAGE3_AI_SET(self, "ADVANTAGE1_3_MON")
end

function MATADOR_MON_ADVANTAGE3_AI_SET(self, obj_name)
    local ADVANTAGE1_1 = GetScpObjectList(self, obj_name)
    if #ADVANTAGE1_1 == 0 then
        local x, y, z = GetPos(self)
        if self.StrArg1 ~= "START" then
            local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_3', x, y, z, 0, 'Neutral', nil, MATADOR_MON_ADVANTAGE1_AI_SETTING);
            AddScpObjectList(self, obj_name, mon)
            AttachEffect(mon, "F_bg_butterfly001_red", 1, 1, "TOP",1)
            self.StrArg1 = "START"
        elseif self.StrArg1 == "START" then
            self.NumArg1 = self.NumArg1 + 1
            if self.NumArg1 > 32 then
                local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_3', x, y, z, 0, 'Neutral', nil, MATADOR_MON_ADVANTAGE1_AI_SETTING);
                AddScpObjectList(self, obj_name, mon)
                AttachEffect(mon, "F_bg_butterfly001_red", 1, 1, "TOP",1)
                self.NumArg1 = 0
            end
        end
    end
end


function MATADOR_MON_ADVANTAGE1_AI_SETTING(mon)
    mon.Enter = "MATADOR_MON_ADVANTAGE1"
    mon.Name = ScpArgMsg("JOB_MATADOR1_ITEM_MSG13")
    mon.OnlyPCCheck = "NO"
    mon.Range = 30
end

--MATADOR_MON_ADVANTAGE2_1_AI
function MATADOR_MON_ADVANTAGE2_1_CRE(self)
    local ADVANTAGE1_1 = GetScpObjectList(self, "ADVANTAGE2_1_HIDDENMON")
    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
    if #ADVANTAGE1_1 == 0 then
        local nowFailCounting = TryGetProp(sObj_main, 'JOB_MATADOR1_FC')
--        local questName = sObj.QuestName
--        local failCount = sObj_main[questName..'_FC']
--        print(nowFailCounting)
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger4', 427, 1178, 570, 0, 'Neutral', nil, MATADOR_MON_ADVANTAGE2_SETTING);
        AddScpObjectList(self, "ADVANTAGE2_1_HIDDENMON", mon)
        if nowFailCounting == nil then
            mon.NumArg2 = 3
        elseif nowFailCounting < 3 then
            mon.NumArg2 = 3
        else
            mon.NumArg2 = 3 + math.floor(nowFailCounting/3)
        end
--        AttachEffect(mon, "F_bg_butterfly001_red", 1, 1, "TOP",1)
    end
end

function MATADOR_MON_ADVANTAGE2_SETTING(mon)
    mon.Name = ScpArgMsg("JOB_MATADOR1_ADVANTAGE2_NAME")
    mon.Tactics = "MATADOR_MON_ADVANTAGE2_AI"
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_BORN_ENTER(self)
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_BORN_UPDATE(self)
    local adv = GetScpObjectList(self, "ADVANTAGE2_1_BAGMON")
    if #adv == 0 then
        local x, y, z = GetPos(self)
        if self.StrArg1 ~= "GET" then
            local mon = CREATE_MONSTER_EX(self, 'pedlar_lose_2', x, y, z, 0, 'Neutral', nil, MATADOR_BAG_AI_SETTING);
            AddScpObjectList(self, "ADVANTAGE2_1_BAGMON", mon)
            AttachEffect(mon, "F_ground158_light_yellow2", 0.6, 1, "BOT",1)
            self.StrArg1 = "GET"
        elseif self.StrArg1 == "GET" then
            self.NumArg1 = self.NumArg1 + 1
            local failcount = self.NumArg2
            --print(failcount, self.NumArg3)
            if failcount >= self.NumArg3 then
                if self.NumArg1 > 40 then
                    local mon = CREATE_MONSTER_EX(self, 'pedlar_lose_2', x, y, z, 0, 'Neutral', nil, MATADOR_BAG_AI_SETTING);
                    AddScpObjectList(self, "ADVANTAGE2_1_BAGMON", mon)
                    AttachEffect(mon, "F_ground158_light_yellow2", 0.6, 1, "BOT",1)
                    self.NumArg1 = 0
                    self.NumArg3 = self.NumArg3 + 1
                end
            end
        end
    end
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_BORN_LEAVE(self)
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_DEAD_ENTER(self)
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_DEAD_UPDATE(self)
end

function SCR_MATADOR_MON_ADVANTAGE2_AI_TS_DEAD_LEAVE(self)
end

function MATADOR_BAG_AI_SETTING(mon)
    mon.Dialog = "MATADOR_MON_ADVANTAGE2"
    mon.Name = ScpArgMsg("JOB_MATADOR1_ADVANTAGE2_NAME")
end

function SCR_MATADOR_MON_ADVANTAGE2_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_MATADOR1_ITEM_MSG6"), '#SITGROPESET', 0.5)
    if result == 1 then
        AddBuff(self, pc, "JOB_MATADOR1_ITEM_BUFF2", 1, 0, 10000, 1)
        SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("JOB_MATADOR1_ITEM_MSG10"), 5)
        Kill(self)
    end
end

function TRAP_POS_SET(min, max, num, loc1, loc2, loc3, main_obj_name)
    local pos = {}
        pos[1] = {loc1[1], loc1[2], loc1[3]}
        pos[2] = {loc2[1], loc2[2], loc2[3]}
        pos[3] = {loc3[1], loc3[2], loc3[3]}
    local x, y, z
    for i = 1, 3 do
        if i == tonumber(num) then
            x = pos[i][1]
            y = pos[i][2]
            z = pos[i][3]
        end
    end
    return x, y, z
end

--Trap_Setting Mon
function SCR_TRAP_SETTING_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_JOB_MATADOR1")
    if sObj.String1 == "ON" then
       sObj.String1 = "OFF"
       local mon, mon_cnt = GetWorldObjectList(self, "MON", 6000)
       if mon_cnt >= 1 then
            local ran = IMCRandom(1, 3)
            for i = 1, mon_cnt do
                if mon[i].ClassName == "Hiddennpc" or mon[i].ClassName == "siauliai_grass_2" then
                    if mon[i].Enter == "MATADOR_MON_TRAP1_AI" then
                        local sub_mon_obj = GetScpObjectList(mon[i], "TRAP1_SUB_MON")
                        if #sub_mon_obj >=1 then
                            for j = 1, #sub_mon_obj do
                                sub_mon_obj[j].StrArg1= "None"
                                sub_mon_obj[j].StrArg2 = tostring(ran)
                            end
                        end
--                        print(mon[i].SimpleAI, mon[i].StrArg1, mon[i].Enter, sub_mon_obj.StrArg2)
                        Kill(mon[i])
                    elseif mon[i].SimpleAI == "TRAP2_MON_AI" then
                        local sub_mon_obj = GetScpObjectList(mon[i], "TRAP2_MON_SUB")
                        if #sub_mon_obj >=1 then
                            for j = 1, #sub_mon_obj do
                                sub_mon_obj[j].StrArg1= "None"
                                sub_mon_obj[j].StrArg2 = tostring(ran)
                            end
                        end
--                        print(mon[i].SimpleAI, mon[i].StrArg1, mon[i].Enter, sub_mon_obj.StrArg2)
                        Kill(mon[i])
                    elseif mon[i].SimpleAI == "MATADOR_TRAPMON_CHANGE_PATTERN_AI" then
                        local sub_mon_obj = GetScpObjectList(mon[i], "TRAP3_SUB_MON")
                        if #sub_mon_obj >=1 then
                            for j = 1, #sub_mon_obj do
                                sub_mon_obj[j].StrArg1= "None"
                                sub_mon_obj[j].StrArg2 = tostring(ran)
                            end
                        end
--                        print(mon[i].SimpleAI, mon[i].StrArg1, mon[i].Enter, sub_mon_obj.StrArg2)
                        Kill(mon[i])
                    end
                end
--            print(ran)
            end
       end
    end
end