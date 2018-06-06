function LIMESTONE_52_5_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    local result = {}
    local list = {}
    local i
    for i = 1, 10  do
        result[i] = SCR_QUEST_CHECK(self, 'LIMESTONE_52_5_MQ_'..i)
        if i == 1 then
            if result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_5_MQ_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        else
            if result[i] ~= 'COMPLETE' and result[i] == 'POSSIBLE' or result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_5_MQ_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        end
    end
end




function LIMESTONE_52_5_MQ_RUNNPC(self)
    local pc_zone = GetZoneName(self);
    if pc_zone == 'd_limestonecave_52_5' then
        local follower = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_1')
        if #follower == 0 then
            local x, y, z = -1518, 0, -1247
            local mon = CREATE_MONSTER_EX(self, 'mon_kupole_4', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, LIMESTONE_52_5_MQ_NPC_SET);
            LookAt(mon, self)
            mon.RunMSPD = 100
            SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'LIMESTONE_52_5_MQ_1', 2);
            AddScpObjectList(self, 'LIMESTONE_52_5_MQ_1', mon)
            SetExArgObject(mon, 'PLAYER_01', self)
            EnableAIOutOfPC(mon)
        end
    end
end

function LIMESTONE_52_5_MQ_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("LIMESTONECAVE_52_1_MEDENA_NAME");
	mon.SimpleAI = 'LIMESTONE_52_5_MQ_NPC_AI'
	mon.Dialog = 'LIMESTONECAVE_52_5_MEDENA_AI'
end

function LIMESTONE_52_5_MQ_NPC_RUN(self)
    local PC_Owner = GetOwner(self)
    if PC_Owner == nil then
        Kill(self)
    end
end

--LIMESTONECAVE_52_5_MEDENA--
function SCR_LIMESTONECAVE_52_5_MEDENA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONECAVE_52_5_MEDENA_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONECAVE_52_5_MEDENA_AI--
function SCR_LIMESTONECAVE_52_5_MEDENA_AI_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, "LIMESTONE_52_5_MQ_3")
    if result == "PROGRESS" then
        ShowOkDlg(pc, 'LIMESTONE_52_5_MQ_3_PROG', 1)
        local select1 = ShowSelDlg(pc,0, 'LIMESTONE_52_5_MQ_3_SEL', ScpArgMsg("LIMESTONE_52_5_MQ_3_PC_SEL_1"), ScpArgMsg("Auto_JongLyo"))
        if select1 == 1 then
            local select2 = ShowSelDlg(pc,0, 'LIMESTONE_52_5_MQ_3_SEL_1', ScpArgMsg("LIMESTONE_52_5_MQ_3_PC_SEL_2"), ScpArgMsg("Auto_JongLyo"))
            if select2 == 1 then
                local select3 = ShowSelDlg(pc,0, 'LIMESTONE_52_5_MQ_3_SEL_2', ScpArgMsg("LIMESTONE_52_5_MQ_3_PC_SEL_3"), ScpArgMsg("Auto_JongLyo"))
                if select3 == 1 then
                    ShowOkDlg(pc, 'LIMESTONE_52_5_MQ_3_SEL_3', 1)
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_5_MQ_3', 'QuestInfoValue1', 1)
                elseif select3 == 2 then
                    return
                end
            elseif select2 == 2 then
                return
            end
        elseif select1 == 2 then
            return
        end
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

--LIMESTONECAVE_52_5_DALIA--
function SCR_LIMESTONECAVE_52_5_DALIA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONECAVE_52_5_DALIA_SOUL_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_SQ_1')
    if result == 'IMPOSSIBLE' or result == 'POSSIBLE' or result == 'PROGRESS' then
        ShowBalloonText(pc, 'LIMESTONE_52_5_SQ_1_SOUL', 6)
    end
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONE_52_5_GESTI--
function SCR_LIMESTONE_52_5_GESTI_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_5_GESTI_2_ENTER(self, pc)
end

--LIMESTONECAVE_52_5_SERIJA--
function SCR_LIMESTONECAVE_52_5_SERIJA_ENTER(self, pc)
end

--LIMESTONECAVE_52_5_TRIA--
function SCR_LIMESTONECAVE_52_5_TRIA_ENTER(self, pc)
end

--LIMESTONECAVE_52_5_ALENA--
function SCR_LIMESTONECAVE_52_5_ALENA_ENTER(self, pc)
end

--LIMESTONECAVE_52_5_SIUTE--
function SCR_LIMESTONECAVE_52_5_SIUTE_ENTER(self, pc)
end

function SCR_LIMESOTNE_52_5_WALL_ENTER(self, pc)
    if isHideNPC(pc, 'LIMESOTNE_52_5_WALL') == 'NO' then
        ShowBalloonText(pc, 'LIMESTONE_52_5_WALL_BALLOON', 6)
    end
end

function SCR_LIMESTONE_52_5_MQ_2_FAKE_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_2')
    if result == 'PROGRESS' then
        ShowBalloonText(pc, 'LIMESTONE_52_5_MQ_2_BALLOON', 6)
    end
end

function SCR_LIMESTONE_52_5_MQ_2_PROG_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_5_MQ_4_EVIL_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_4')
    if result == 'PROGRESS' then
        local list, cnt = SelectObject(self, 100, 'ALL')
        local i
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName == 'Onion' or list[i].ClassName == 'Pawndel' or list[i].ClassName == 'pawnd' then
                    InsertHate(list[i], pc, 100)
                end
            end
        end
        local action_r = DOTIMEACTION_R(pc, ScpArgMsg('LIMESTONE_52_5_MQ_4_ING'), 'ABSORB', 4)
        if action_r == 1 then
            local follower = GetScpObjectList(pc, 'LIMESTONE_52_5_MQ_1')
            local i 
            if #follower > 0 then
                for i = 1, #follower do
                    if follower[i].ClassName == 'mon_kupole_4' then
                        LookAt(follower[i], self)
                        PlayAnim(follower[i], 'atk')
                    end
                end
            end
            RunScript('LIMESTONE_52_5_MQ_4_EVIL_DEAD', self)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_5_MQ_4', 'QuestInfoValue1', 1)
            SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("LIMESTONE_52_5_MQ_4_SUCC_MSG"), 5)
        end
    end
end

function LIMESTONE_52_5_MQ_4_EVIL_DEAD(self)
    sleep(1000)
    DetachEffect(self, 'F_smoke019_dark_loop')
    PlayEffect(self, 'F_rize003', 1, nil, 'BOT')
    Dead(self)
end

function SCR_LIMESTONE_52_5_MQ_5_EVIL_DEVICE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_5_MQ_6_OBJ_1_DIALOG(self, pc)
    LIMESTONE_52_5_MQ_6_OBJ_RUN(self, pc, 1)
end

function SCR_LIMESTONE_52_5_MQ_6_OBJ_2_DIALOG(self, pc)
    LIMESTONE_52_5_MQ_6_OBJ_RUN(self, pc, 2)
end

function SCR_LIMESTONE_52_5_MQ_6_ANTIEVIL_1_DIALOG(self, pc)
    ShowBalloonText(pc, 'LIMESTONE_52_2_WARNING', 6)
end

function SCR_LIMESTONE_52_5_MQ_6_ANTIEVIL_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_5_SQ_1_NPC_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_SQ_1')
    if result == 'PROGRESS' then
        local action_r = DOTIMEACTION_R(pc, ScpArgMsg('LIMESTONE_52_5_SQ_1_ING'), 'ABSORB', 4)
        if action_r == 1 then
            local skill = GetNormalSkill(self)
            ForceDamage(self, skill, pc, self, 0, 'MOTION', 'BLOW', 'I_force080_violet', 0.5, 'arrow_cast', 'I_force080_violet', 0.5, 'arrow_blow', 'SLOW', 200, 1, 0, 0, 0, 1, 1)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_5_SQ_1', 'QuestInfoValue1', 1)
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_5_SQ_1_GET"), 6)
            Kill(self)
        end
    end
end

function LIMESTONE_52_5_MQ_3_ATTACH(self)
    local follower = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_1')
    local i
    if #follower > 0 then
        for i = 1, #follower do
            if follower[i].ClassName == 'mon_kupole_4' then
                AttachEffect(follower[i], 'F_light055_blue', 4, 'MID')
            end
        end
    end
end

function LIMESTONE_52_5_MQ_3_DETACH(self)
    local follower = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_1')
    local i 
    if #follower > 0 then
        for i = 1, #follower do
            if follower[i].ClassName == 'mon_kupole_4' then
                DetachEffect(follower[i], 'F_light055_blue')
            end
        end
    end
end

function LIMESTONE_52_5_MQ_7_END(self)
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_5_MQ_7_END_MSG"), 6)
    HideNPC(self, 'LIMESTONE_52_5_MQ_5_EVIL_DEVICE')
    local mon = CREATE_MONSTER_EX(self, 'npc_figurine_device', 116, 756, 195, -90, 'Neutral', 1, LIMESTONE_52_5_MQ_7_NPC_SET)
    AddVisiblePC(mon, self, 1)
    ActorVibrate(mon, 2, 0.5, 100, 0)
    local follower = GetScpObjectList(self, 'LIMESTONE_52_5_MQ_1')
    local i 
    if #follower > 0 then
        for i = 1, #follower do
            if follower[i].ClassName == 'mon_kupole_4' then
                LookAt(follower[i], mon)
                PlayAnim(follower[i], 'atk')
            end
        end
    end
    sleep(2000)
    PlayEffectLocal(mon, self, 'F_rize003', 1)
    PlayEffectLocal(mon, self, 'F_burstup024_dark', 4)
    Dead(mon)
end

function LIMESTONE_52_5_MQ_7_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

function LIMESTONE_52_5_MQ_6_OBJ_RUN(self, pc, num)
    local result1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_6')
    if result1 == 'PROGRESS' then
        local scplist1 = GetScpObjectList(pc, 'LIMESTONE_52_5_MQ_6_SCPOBJ');
        if #scplist1 > 0 then
            local i;
            for i = 1, #scplist1 do
                if scplist1[i].NumArg1 == num then
                    SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("LIMESTONE_52_3_MQ_4_ALREDY"), 3);
                    return;
                end
            end
        end
        
        local result = DOTIMEACTION_R(pc, ScpArgMsg("LIMESTONE_52_5_MQ_6_ING"), 'ABSORB', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            local P_list, P_cnt = GET_PARTY_ACTOR(pc, 0)
            local p
            if P_cnt >= 1 then
                for p = 1, P_cnt do
                    local result2 = SCR_QUEST_CHECK(P_list[p], 'LIMESTONE_52_5_MQ_6')
                    if result2 == 'PROGRESS' then
                        local sObj = GetSessionObject(P_list[p], 'SSN_LIMESTONE_52_5_MQ_6');
                        if sObj ~= nil then
                            local scplist = GetScpObjectList(P_list[p], 'LIMESTONE_52_5_MQ_6_SCPOBJ');
                            if #scplist > 0 then
                                for i = 1, #scplist do
                                    if scplist[i].NumArg1 == num then
                                        return;
                                    end
                                end
                            end
                            
                            local list, Cnt = SelectObjectByFaction(self, 200, 'Monster');
                            if Cnt > 4 then
                                local i;
                                for i = 1, Cnt do
                                    InsertHate(list[i], pc, 1)
                                end
                            end
                            
                            if result == 1 then
                                local x, y, z = GetPos(self)
                                local mon1 = CREATE_MONSTER_EX(P_list[p], 'HiddenTrigger6', x, y, z, 0, 'Neutral', 1, LIMESTONE_52_5_MQ_6_OBJ_SET);
                                AddScpObjectList(P_list[p], 'LIMESTONE_52_5_MQ_6_SCPOBJ', mon1)
                                AddScpObjectList(mon1, 'LIMESTONE_52_5_MQ_6_SCPPC', pc)
                                AddVisiblePC(mon1, P_list[p], 1);
                                AttachEffect(mon1, 'F_light078_holy_yellow_loop', 4, 'MID')
                                SetTacticsArgStringID(mon1, 'LIMESTONE_52_5_MQ_6_SCPPC')
                                SetNoDamage(mon1, 1);
                                SetLifeTime(mon1, 60)
                                mon1.NumArg1 = num;
                                
                                scplist = GetScpObjectList(P_list[p], 'LIMESTONE_52_5_MQ_6_SCPOBJ');
                                
                                if #scplist >= 2 then
                                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1;
                                    SaveSessionObject(P_list[p], sObj)
                                    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg('LIMESTONE_52_5_MQ_6_CLEAR'), 6)
--                                    local j;
--                                    for j = 1, #scplist do
--                                        Kill(scplist[j])
--                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function LIMESTONE_52_5_MQ_6_OBJ_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "NO_SCPLIST_DEAD_TAC";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "None"
end

function SCR_LIMESTONE_52_5_MQ_6_SUCC(self)
    local list, cnt = SelectObject(self, 300, 'ALL', 1)
    if cnt >= 1 then
        local j
        for j = 1, cnt do
            if list[j].Faction == 'Monster' then
                if SCR_QUEST_MONRANK_CHECK(list[j], 'Normal', 'Special', 'Elite', 'Material') == 'YES' then
                    PlayEffect(list[j], 'F_explosion024_rize', 0.8, nil, 'BOT')
                    Kill(list[j])
                end
	        end
        end
    end
end

function LIMESTONE_52_5_MQ_7_HP(self)
    local hp_lock = self.MHP*0.4
    AddBuff(self, self, 'HPLock', hp_lock, 0, 0, 1)
end

function LIMESTONE_52_5_MQ_7_LOCK(self, from)
    local from = GetLastAttacker(self)
    if GetHpPercent(self) < 0.5 then 
        self.BTree = 'BT_Dummy'
        PlayAnim(self, 'event_collapse', 1)
        if IS_PC(from) == true then
            SCR_PARTY_QUESTPROP_ADD(from, 'SSN_LIMESTONE_52_5_MQ_7', 'QuestInfoValue1', 1)
        else
            SCR_PARTY_QUESTPROP_ADD(GetOwner(from), 'SSN_LIMESTONE_52_5_MQ_7', 'QuestInfoValue1', 1)
        end
    end
end

function LIMESTONE_52_5_MQ_9_HP(self)
    local hp_lock = self.MHP*0.05
    AddBuff(self, self, 'HPLock', hp_lock, 0, 0, 1)
end

function LIMESTONE_52_5_MQ_9_LOCK(self, argObj)
    if GetHpPercent(self) < 0.1 then
        if self.NumArg4 == 0 then
            SkillCancel(self);
            local _target
            if IS_PC(argObj) == true then
                _target = argObj
            else
                _target = GetOwner(argObj)
            end
            
        	local list, cnt = GET_PARTY_ACTOR(_target, 0)
        	local monList, monCount = GetLayerMonList(GetZoneInstID(_target), GetLayer(_target))
            
            if monCount > 0 then
                for i = 1, monCount do
                    if monList[i].ClassName ~= 'PC' then
                        Kill(monList[i])
                    end
                end
            end
            
            local obj = GetLayerObject(GetZoneInstID(_target), GetLayer(_target))
            obj.EventNextTrack = 'LIMESTONE_52_5_MQ_9_LOCK'
            
            PlayDirection(_target, 'LIMESTONE_52_5_MQ_9_AFTER', 0, 1)
            local i
            for i = 1, cnt do
                if IsSameActor(list[i], _target) == 'NO' then
                    if GetLayer(self) == GetLayer(list[i]) then
                        AddDirectionPC(_target, list[i])
                        ReadyDirectionPC(_target, list[i]);
                    end
                end
            end
            StartDirection(_target)
            return 1
        else
            return 1
        end
    end
    return 0
end