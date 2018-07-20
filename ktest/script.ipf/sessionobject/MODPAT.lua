function KILL_KUPOLE(self)
    local list, cnt =  SelectObject(self, 300, 'ALL')
    local i
    for i = 1, cnt do
        if list[i].ClassName == 'npc_kupole_1' or list[i].ClassName == 'npc_kupole_2' or list[i].ClassName == 'npc_kupole_3' or list[i].ClassName == 'npc_kupole_4' or list[i].ClassName == 'npc_kupole_5'  or list[i].ClassName == 'npc_kupole_6' then
            Kill(list[i])
        end
    end
end

function TSET_RUNPAD(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
    RunPad(mon, 'GT_STAGE_7', 'None', x+50, y+15, z, 0, 1)
    --CHAPLE77_MQ_06 I_force036_green1
    --GT_STAGE_7
end


function owenfonweofnoawenf(self)
    EARTH_TOWER_FLOOR_UI_OPEN(self, ScpArgMsg('SortByWeight'), 2)
end

function TEST_MGMAE_RUN_LAYER(self)
    SetLayer(self, GetNewLayer(self))
end

function TEST_MGAME_SET_1(self)
    SetPos(self, -5623, 249, 6571)
end





function TEST_GUILD_EVT(self)
    print("GG")
--        PlayDirection(self, 'GR_boss_SWORDBALISTA');
--        PlayDirection(self, 'GR_VELNIAS_1_S1_TRACK');
        PlayDirection(self, 'M_GTOWER_INIT');
end
--GR_FD_UNDER_1_S9_MINI
--GR_FD_UNDER_1_S1_MINI
--M_GTOWER_STAGE_2
--M_GTOWER_LOBBY_1
--M_GTOWER_INIT

function PC_PLAYDIR_RUN(self, direction)
    if direction == 0 then
        PlayDirection(self, 'DIR_GT_LOBBY_1');
    else
        PlayDirection(self, direction);
    end
end

function DEV_GT_TEST_DEAD(self)
    print("EEEEEEEEE")
end



function wngoweognweog(self)
    local list, cnt = SelectObject(self, 300, 'ALL')
    local i
    for i = 1, cnt do
        print(list[i].MHP, list[i].ClassName)
    end
end


function owaenfoawenfiubnweefewf(self)
    local missionID = OpenMissionRoom(self, 'MISSION_CHAPLE_01', "");
    ReqMoveToMission(self, missionID)
--    ChangePartyProp(self, PARTY_NORMAL, "FieldBossRaid_Ticket", 1)
--    ChangePartyProp(self, PARTY_NORMAL, "BattleField_Ticket", 1)
--    ChangePartyProp(self, PARTY_NORMAL, 'MissionAble', 1)

--    ChangePartyProp(self, PARTY_NORMAL, 'FieldBossSummon', 1)
end

function SCR_BLANK_NPC_DIALOG(self, pc)

end


function TEST_ANIMATION(pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("SOUL_SEARCHING"), 'MAKING', 2, 'SSN_HATE_AROUND')
    print(result)
end

function NORPAT_TSET_SERVER(self)
    print("GGGGGGGG")
    sleep(5000)
    RunScript('TEST_ANIMATION', self)
end


function MODPAT_OFFSET_CK(self)
    local list, cnt = SelectObject(self, 300, 'ALL')
    local i
    for i = 1 , cnt do 
        AddBuff(self, list[i], 'HPLock', 100, 0, 0, 1)
    end
end

function PC_EFF_RUN(self,efname)
    PlayEffectLocal(self, self, efname)
end

function PC_ANI_RUN(self, animName)
    PlayAnim(self, animName, 1)
end




function TEST_R_COLOR(self)
    local list, Cnt = SelectObject(self, 100, 'ALL')
    local i
    for i = 1 , Cnt do
        local Cobj = GetSessionObject(list[i], 'SSN_OBJ_COLORBLEND')
        if Cobj == nil then
            CreateSessionObject(list[i], 'SSN_OBJ_COLORBLEND', 1)
            local Cobj = GetSessionObject(list[i], 'SSN_OBJ_COLORBLEND')
        end
--        print(Cobj)
        SSN_OBJ_COLORBLEND_SET(Cobj, 108, 192, 255, 200, 255, 192, 255, 225, 0, 0, 0, -3, 3000)
        break;
    end
end

--function SSN_OBJ_COLORBLEND_SET(sObj, start_r, start_g, start_b, start_a, targer_r, targer_g, targer_b, targer_a, add_r, add_g, add_b, add_a, delay_time)
function TEST_PC_COLOR(self)
    local Cobj = GetSessionObject(self, 'SSN_OBJ_COLORBLEND')
    if Cobj == nil then
        CreateSessionObject(self, 'SSN_OBJ_COLORBLEND', 1)
        local Cobj = GetSessionObject(self, 'SSN_OBJ_COLORBLEND')
    end
--    print(Cobj.ClassName)
    SSN_OBJ_COLORBLEND_SET(Cobj, 108, 192, 255, 255, 255, 0, 0, 255, 0, 0, 0, -3, 3000)
end



function TEST_SSNS(self)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
end



function SOMENPC_ADD_EFFECT(self)

end





function NOX_SUMMON(self)
    local x,y,z = GetPos(self)
    local nox_mon = CREATE_MONSTER(self, 'Hiddennpc', x,y,z, -135, 'Neutral', GetLayer(self), 1, 'MON_DUMMY', 'FE', nil, nil, 1, nil, nil, 'Dummy')
end


function SCR_NOX_SUMM_TS_BORN_ENTER(self)
    PlayEffect(self, 'magic1', 2)
    self.NumArg1 = 140
    self.NumArg2 = 0
    self.NumArg3 = 1
end



function SCR_NOX_SUMM_TS_BORN_UPDATE(self)
    if self.NumArg1 <= 250 then
        ObjectColorBlend(self, self.NumArg2, self.NumArg2, self.NumArg2, self.NumArg1, 1);
        self.NumArg1 = self.NumArg1 + 2
        if self.NumArg2 <= 250 then
            self.NumArg2 = self.NumArg2 + 4
        end
    elseif self.NumArg1 > 250 and self.NumArg1 <= 260 then
--        print(self.NumArg3)
        ChangeScale(self, self.NumArg3, 0.05)
        self.NumArg1 = self.NumArg1 + 1
        self.NumArg3 = self.NumArg3 + 0.05
    else
        SetCurrentFaction(self, 'Monster')
        ChangeTactics(self, 'NOX_TACTICS_SEMPLE')
    end
    
    HOLD_MON_SCP(self, 100);

end


function SCR_NOX_SUMM_TS_BORN_LEAVE(self)
end

function SCR_NOX_SUMM_TS_DEAD_ENTER(self)
end

function SCR_NOX_SUMM_TS_DEAD_UPDATE(self)
end

function SCR_NOX_SUMM_TS_DEAD_LEAVE(self)
end



function SCR_NOX_TACTICS_SEMPLE_TS_BORN_ENTER(self)

end

function SCR_NOX_TACTICS_SEMPLE_TS_BORN_UPDATE(self)

        if IS_CHASING_SKILL(self) ~= 1 then
        
        local target = GetNearTopHateEnemy(self); 
        if target == nil then
            local list, Cnt = SelectObjectByClassName(self, 250, 'PC')
            local i 
            for i = 1 , Cnt do
                target = list[i]
                break;
            end
        end
        
        
            if target ~= nil then
                local selectedSkill = SelectMonsterSkillByRatio(self);
    			local skill = GetSkill(self, selectedSkill);
    			
    			
    			local splashType = skill.SplType;
    			local maxRange = skill.MaxR;
    			if splashType == 'Square' then
    				maxRange = skill.SklWaveLength;
    			elseif splashType == 'Fan' then
    				maxRange = skill.SklSplRange;
    			elseif splashType == 'Circle' then
    				maxRange = skill.SklSplRange;
    			end
    			
    			
    			local dist = GetDistance(self, target);
    			
    			if dist > maxRange then
    				MoveToTarget(self, target, maxRange - 5);
    			end
    			
    			local curHate = GetHate(self, target);
    			if curHate == 0 then
    				InsertHate(self, target, 1);
    				StopMove(self);
    				LookAt(self, target);
    			end

    
    			
    			if dist <= maxRange then
    				UseMonsterSkill(self, target, selectedSkill);
    			end
            end
        end
end

function SCR_NOX_TACTICS_SEMPLE_TS_BORN_LEAVE(self)
end

function SCR_NOX_TACTICS_SEMPLE_TS_DEAD_ENTER(self)
end

function SCR_NOX_TACTICS_SEMPLE_TS_DEAD_UPDATE(self)
end

function SCR_NOX_TACTICS_SEMPLE_TS_DEAD_LEAVE(self)
end







function SCR_TRAP_BOX_TS_BORN_ENTER(self)
    ObjectColorBlend(self, 0, 216, 255, 255, 1);
end



function SCR_TRAP_BOX_TS_BORN_UPDATE(self)

    HOLD_MON_SCP(self, 100);

end


function SCR_TRAP_BOX_TS_BORN_LEAVE(self)
end

function SCR_TRAP_BOX_TS_DEAD_ENTER(self)
end

function SCR_TRAP_BOX_TS_DEAD_UPDATE(self)
end

function SCR_TRAP_BOX_TS_DEAD_LEAVE(self)
end


function GOGOPOT(self)
    local tBox_ssn = GetSessionObject(self, 'SSN_TRAP_BOX')
    if tBox_ssn ~= nil then
        DestroySessionObject(self, tBox_ssn)
        print(ScpArgMsg("Auto_SeSyeon_PaKoe"))
    else
        print(ScpArgMsg("Auto_SeSyeoneopeum"))
    end
end

function SCR_TRAP_BOX_SAMPLE_DIALOG(self, pc)
    local tBox_ssn = GetSessionObject(pc, 'SSN_TRAP_BOX')
    if GetExArg(tBox_ssn,1) == nil and GetExArg(tBox_ssn,2) == nil and GetExArg(tBox_ssn,3) == nil and GetExArg(tBox_ssn,4) == nil then
        if tBox_ssn == nil then
--            if tBox_ssn.Goal1 == 0 then
                CreateSessionObject(pc, 'SSN_TRAP_BOX', 1)
                local tBox_ssn = GetSessionObject(pc, 'SSN_TRAP_BOX')
                local x,y,z = GetPos(self)
                local nox_mon1 = CREATE_MONSTER(pc, 'HighBube_Fighter', x+60,y,z+60, -45, 'Neutral', GetLayer(self), 22, 'NOX_SUMM', ScpArgMsg('Auto_NogSeuSwan'), nil, nil, 1, nil, nil, 'Dummy')
                local nox_mon2 = CREATE_MONSTER(pc, 'HighBube_Fighter', x-60,y,z+60, -45, 'Neutral', GetLayer(self), 22, 'NOX_SUMM', ScpArgMsg('Auto_NogSeuSwan'), nil, nil, 1, nil, nil, 'Dummy')
                local nox_mon3 = CREATE_MONSTER(pc, 'HighBube_Fighter', x+60,y,z-60, -45, 'Neutral', GetLayer(self), 22, 'NOX_SUMM', ScpArgMsg('Auto_NogSeuSwan'), nil, nil, 1, nil, nil, 'Dummy')
                local nox_mon4 = CREATE_MONSTER(pc, 'HighBube_Fighter', x-60,y,z-60, -45, 'Neutral', GetLayer(self), 22, 'NOX_SUMM', ScpArgMsg('Auto_NogSeuSwan'), nil, nil, 1, nil, nil, 'Dummy')
            
                SetExArgCount(tBox_ssn,8)
                SetExArg(tBox_ssn, 1, nox_mon1)
                SetExArg(tBox_ssn, 2, nox_mon1)
                SetExArg(tBox_ssn, 3, nox_mon1)
                SetExArg(tBox_ssn, 4, nox_mon1)
--            end
        end
    else 
        local result2 = DOTIMEACTION_B(pc, ScpArgMsg('Auto_KyeongBae_Jung'), 'WORSHIP', 2, 'SSN_ATTACH_EFF', 'F_pc_statue_wing')
        if result2 == 1 then
                self.NumArg1 = 0
        end
    end
end




function SCR_CREATE_SSN_TRAP_BOX(self, sObj)
	SetTimeSessionObject(self, sObj, 1, 500, "SCR_CREATE_SSN_TRAP_BOX_TIMER")
end

function SCR_REENTER_SSN_TRAP_BOX(self, sObj)
	SetTimeSessionObject(self, sObj, 1, 500, "SCR_CREATE_SSN_TRAP_BOX_TIMER")
end

function SCR_DESTROY_SSN_TRAP_BOX(self, sObj)
end

function SCR_CREATE_SSN_TRAP_BOX_TIMER(self, sObj)

end




function SCR_COUNT_NPC_START_DIALOG(self, pc)
        COMMON_QUEST_HANDLER(self, pc)
end

function SCR_COUNT_NPC_END_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end



function SCR_FALLEN_GOD(self)
    local fallen_god = CREATE_MONSTER(pc, 'fallen_statue', x+60,y,z+60, -45, 'Neutral', GetLayer(self), 22, 'NOX_SUMM', ScpArgMsg('Auto_NogSeuSwan'), nil, nil, 1, nil, nil, 'Dummy')
end







function SCR_ALPHAOBJ_TS_BORN_ENTER(self)
    PlayAnim(self, 'ASTD', 1)
    ObjectColorBlend(self, 255, 255, 255, 50, 1);
    self.NumArg1 = 50
    
end


function SCR_ALPHAOBJ_TS_BORN_UPDATE(self)
    if self.NumArg1 <= 250 then
        ObjectColorBlend(self, 255, 255, 255, self.NumArg1, 1);
        self.NumArg1 = self.NumArg1 + 10
    elseif self.NumArg1 > 250 then
        SetCurrentFaction(self, 'Monster')
        SetTendency(self, 'Attack')
        local tobt = CreateBTree('BasicMonster')
        SetBTree(self, tobt)
    end
    
    HOLD_MON_SCP(self, 50);

end


function SCR_ALPHAOBJ_TS_BORN_LEAVE(self)
end

function SCR_ALPHAOBJ_TS_DEAD_ENTER(self)
end

function SCR_ALPHAOBJ_TS_DEAD_UPDATE(self)
end

function SCR_ALPHAOBJ_TS_DEAD_LEAVE(self)
end


function jfowenfoiwfoijwf(self)
    MAKE_SUPPORT_NPC(self, 'Spion', 'SIAUL_WEST_MEET_NAGLIS')
end




function test_effffff(self)
    print("GGG")
    PlayEffect(self, 'bg_kepafire', 3)
end

function ADDHELP_TESTT(self)
    AddHelpByName(self, 'TUTO_CHANGE_JOB')
end


function oononwnonowno(self)
    Chat(self, ScpArgMsg("Auto_Haesseum")) 
    REMAKE_SUPPORT_NPC(self, 'SIAUL_WEST_ONION_BIG')
end

function fewefwefbnnbne(self)
    local list, cnt = SelectObjectByClassName(self, 300, 'chaple_gate_02')
    local i
    for i = 1, cnt do
        local npcState = GetNPCStateByGenType(self, GetZoneName(list[i]), GetGenType(list[i]))
            print(npcState)
        if npcState ~= 5 then
            AddNPCStateAnim(list[i], 1, "ASTD");
        end
    end
end
function wefwefwefgggger(self)

    print("GGGG")

end

function weeefwefew_end(self)
    local fllw_ssn = GetSessionObject(self, 'SSN_SIAU15_FRIENDS_01')
    DestroySessionObject(self, fllw_ssn)
end

function REMAKE_SUPPORT_NPC(self, quest_class)
    local share_set = GetSessionObject(self, 'SSN_TRACK_FRIENDLYNPC_KILLSHARE')
    local fllw_ssn = GetSessionObject(self, 'SSN_FOLLOWER_SET')
    if fllw_ssn ~= nil then
        DestroySessionObject(self, fllw_ssn)
        TRACK_FRIENDLYNPC_KILLSHARE(mon, self, 'SSN_'..quest_class)
    end
end

function MAKE_SUPPORT_NPC(self, mon_class, quest_class)
    local fllw_ssn = GetSessionObject(self, 'SSN_FOLLOWER_SET')
    if fllw_ssn == nil then
        CreateSessionObject(self, 'SSN_FOLLOWER_SET', 1)
        local fllw_ssn = GetSessionObject(self, 'SSN_FOLLOWER_SET')
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER(self, mon_class, x, y, z, 0, 'Neutral', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), 'MON_DUMMY', nil, 10, 'PC_OBJECT_SAVE', nil, 'BT_SUPPORT_FOLLOWER');
        SetArgObj1(fllw_ssn, mon)
        fllw_ssn.QuestName = mon_class
        fllw_ssn.HideNPC_Change = quest_class
        if quest_class ~= nil then
            TRACK_FRIENDLYNPC_KILLSHARE(mon, self, 'SSN_'..quest_class)
        end
        return
    end
    local mon = GetArgObj1(fllw_ssn)
    if mon == nil then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER(self, mon_class, x, y, z, 0, 'Neutral', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), 'MON_DUMMY', nil, 10, 'PC_OBJECT_SAVE', nil, 'BT_SUPPORT_FOLLOWER');
        SetArgObj1(fllw_ssn, mon)
        fllw_ssn.QuestName = mon_class
        fllw_ssn.HideNPC_Change = quest_class
        if quest_class ~= nil then
            TRACK_FRIENDLYNPC_KILLSHARE(mon, self, 'SSN_'..quest_class)
        end
    end
end


function SCR_CREATE_SSN_FOLLOWER_SET(self, sObj)
    RegisterHookMsg(self, sObj, "SetLayer", "FOLLOWER_SET_LAYER", "NO");
    SetTimeSessionObject(self, sObj, 1, 1000, 'REMAKE_FOLLOWER_RUN')
end

function SCR_REENTER_SSN_FOLLOWER_SET(self, sObj)
    RegisterHookMsg(self, sObj, "SetLayer", "FOLLOWER_SET_LAYER", "NO");
    SetTimeSessionObject(self, sObj, 1, 1000, 'REMAKE_FOLLOWER_RUN')
end

function SCR_DESTROY_SSN_FOLLOWER_SET(self, sObj)
end

function FOLLOWER_SET_LAYER(self, sObj)
    local mon = GetArgObj1(sObj)
    if mon ~= nil then
        if GetLayer(self) ~= GetLayer(mon) then
            SetLayer(mon, GetLayer(self))
        end
    end
end


function REMAKE_FOLLOWER_RUN(self, sObj)
    local mon = GetArgObj1(sObj)
    if mon == nil then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER(self, sObj.QuestName, x, y, z, 0, 'Neutral', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), 'MON_DUMMY', nil, 10, 'PC_OBJECT_SAVE', nil, 'BT_SUPPORT_FOLLOWER');
        PlayAnim(mon, 'ASTD', 1)
        SetArgObj1(sObj, mon)
        if quest_class ~= nil then
            TRACK_FRIENDLYNPC_KILLSHARE(mon, self, 'SSN_'..sObj.HideNPC_Change)
        end
    end
end


function KEPABOOMBALL(self)
    local x, y, z = GetPos(self)
    local mon =  CREATE_NPC(self, 'Hanaming', x, y, z, 0, 'Monster', 0, ScpArgMsg('Auto_Kong'), 'KICK_MONSTER', nil, nil, 1, nil)
end


function SCR_KICK_MONSTER_DIALOG(self, pc)
    LookAt(self, pc)
    LookAt(pc, self)
    SCR_VIBE_COLOR_RUN(self)
    PlayAnim(pc, 'KICKBOX', 1)
--    sleep(300)
    local dic_angle = GetAngleTo(pc, self)
    KnockDown(self, pc, 500, dic_angle, 45, 1)
    
end

function mopowefwef123(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, 'Onion', x, y, z, 20, 'Neutral', GetLayer(self), 55, 'KATYN18_FENCE', ScpArgMsg('Auto_alPaoBeuJegTeu'), nil, nil, 1, nil, nil, 'Dummy');
end

function nnekfgmenneif(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, 'boss_Mushcaria_Q2', x, y, z, 20, 'Monster', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), nil, nil, 1, nil, nil);
end



function chanveeg_efef(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, 'boss_Gaigalas', x, y, z, 20, 'Neutral', GetLayer(self), 55, 'MON_DUMMY', ScpArgMsg('Auto_alPaoBeuJegTeu'), nil, nil, 1, nil, nil, 'Dummy');
    ChangeScale(mon, 0.5, 5)
--    DRT_CHANGESCALE_OBJ(mon, 0, 0.6, 30, 5)
end

function nononowefowenf(self)
    local list, Cnt = SelectObjectByClassName(self, '300', 'Onion')
    local i
    for i = 1, Cnt do
--        PlayAnim(list[i], 'lock_event',1)
        ObjectColorBlend(list[i], 205, 255, 205, 140, 1)
    end
end



function KARTNRT(self)
    local list, Cnt = SelectObject(self, 200, 'ALL')
    local i
    
    for i = 1, Cnt do
        if list[i].ClassName == 'Silvertransporter_m' then
            
            SetFixAnim(list[i], 'SIT')
        end
    end
    
end





function MODPAT_COUNT_HATE(self, sObj)
    if GetLayer(self) ~= 0 then
        local list, Cnt = SelectObjectByFaction(self, 150, 'Monster')
        local i
        for i = 1, Cnt do
            if GetHate(list[i], self) < 999 then
                InsertHate(list[i], self, 999)
                break
            end
        end
    end
end


function PC_FLY_RUN(self)
    FlyMath(self, 60, 1, 1);
--    Fly(self, 0)
end



function TAKEITEM_TUN(self, item_name)
    RunScript('TAKE_ITEM_TX', self, item_name, 1, "Quest")
end




function GETITEMINDEX(self)
    local blank_slot = GetEmptyItemSlotCount(self)
    local full_slot = GetFillItemSlotCount(self)
    local all_slot = GetTotalItemSlotCount(self)
    local get_item = GetInvItemList(self)
    local i
    for i=1 , 55 do
        if get_item[i] ~= nil then
            print(get_item[i].Name)
        end
    end
    print(' ')
    print(' ')
    print(' ')
    print(' ')
    print(' ')
    print('blank_slot : ', blank_slot)
    print('full_slot : ', full_slot)
    print('all_slot : ', all_slot)
end


function wejfnweofweofnwef(self)
    PlayAnim(self, 'SITGROPE', 1, 1, 0, 1)
end

function fnnnfgnowefwe(self)
    local list, Cnt = SelectObject(self, 200, 'ALL',1 )
    local i
    
    for i = 1, Cnt do
        print(list[i])
        Chat(list[i], ScpArgMsg("Auto_Hai"),  0.5)
    end
end

function PARTY_LAYER_RUN_QUEST(self, quest_name)
    local newlayer = GetNewLayer(self);
	local list, cnt = GET_PARTY_ACTOR(self, 0)
    local i
    if cnt ~= 0  then
        for i = 1, cnt do
            if IsSameActor(pc, list[i]) == "NO" then
                local myParty = GetPartyObj(pc);
            	if myParty ~= nil and myParty.IsQuestShare == 1 then
            	    local result = SCR_QUEST_CHECK(list[i], quest_name)
                    if result == 'PROGRESS'  then
                        SetLayer(list[i], newlayer)
                    end
            	end
            end
        end
    end
    return newlayer;
end

function MOFEF_AWEFWFEE(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, 'TreasureBox1', x+20, y, z+30, 0, 'Neutral', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), 'MON_DUMMY', nil, 10);
end




function MODPAT_TEST_BT_FLLW(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER(self, 'Silvertransporter_m', x, y, z, 0, 'Neutral', GetLayer(self), 55, nil, ScpArgMsg('Auto_alPaoBeuJegTeu'), 'MON_DUMMY', nil, 10, 'PC_OBJECT_SAVE', nil, 'BT_FOLLOWER_RUN');
    UP_MOVESPEED(mon, 45)
end




function unhide_test(self)
    UnHideNPC(self, 'CASTLE653_MQ_01_1')
end

function hide_test(self)
    HideNPC(self, 'CHAPLE577_HOLY_1',0 ,0 ,0)
end


function ANI_MODPAT(self)
    PlayAnimLocal(self, self, 'WORSHIP', 1)
end



function MONDDOOOEEE(self)
    local mon = CREATE_SAI(self, 'Onion')
end


function KILL1(self, range)
	self.PATK_BM = self.PATK_BM + 999999;
	self.MATK_BM = self.MATK_BM + 999999;
	self.HR_BM = self.HR_BM + 999999;
    if range ~= 0 then
        local list, Cnt = SelectObjectByFaction(self, range, 'Monster')
        local i
        for i = 1 , Cnt do
--            PlayEffect(list[i], 'F_wizard_fireball_hit_explosion', 2)
            TakeDamage(self, list[i], "indunTheEnd", 9999999, "None", "None", "Magic", HIT_FIRE, HITRESULT_BLOW);
--            return
        end
    elseif range == 0 then
        local list, Cnt = SelectObjectByFaction(self, 500, 'Monster')
        local i
        for i = 1 , Cnt do
--            PlayEffect(list[i], 'F_wizard_fireball_hit_explosion', 2)
            TakeDamage(self, list[i], "indunTheEnd", 99999999, "None", "None", "Magic", HIT_FIRE, HITRESULT_BLOW);
--            return
        end
    end
	self.PATK_BM = self.PATK_BM - 999999;
	self.MATK_BM = self.MATK_BM - 999999;
	self.HR_BM = self.HR_BM - 999999;
end


function MON3DMOVE_TSET(self)
    local list, Cnt = SelectObjectByFaction(self, 600, 'Monster')
    local i
    local x, y, z = GetPos(self)
    for i = 1, Cnt do
        Move3D(list[i], x, y+10, z, 200, 2*i);
        break
        --ObjectColorBlend(list[i], 255, 255, 255, 255, 1, 1);
--      ObjectColorBlend(self, start_r, start_g, start_b, 255, 1, 0, 0, 0);

    end
end


function HIDENPC_3D(self)
    local list, Cnt = SelectObjectByFaction(self, 600, 'Monster')
    local i
    for i = 1, Cnt do
        Chat(list[i], "GGGG")
        ObjectColorBlend(list[i], 255, 255, 255, 255, 1);
    end
end


function weofwefwefwef(self)
    PlayEffect(self, 'statue_zemina_light1')
end






function AMUNA_SOHWAN(self)
    local x,y,z = GetPos(self)
--    local nox_mon = CREATE_MONSTER(self, 'npc_zachariel_cube', x,y,z, -45, 'Neutral', GetLayer(self), 1, 'MON_DUMMY', ScpArgMsg('Auto_DeoMi'), nil, nil, 20, nil, nil, 'Dummy')
    local nox_mon = CREATE_NPC(self, 'npc_zachariel_cube', x, y, z, -45, 'Neutral', GetLayer(self), '', nil, 'TAKE_DA_01', 10, 1, nil)
--    SPIN_MYCUBE(nox_mon)
end





function CALL_MONSTER(self)
    local list, Cnt = SelectObjectByClassName(self, 200, 'npc_zachariel_cube')
    local i
    for i = 1 , Cnt do
        local mon_ssn = GetSessionObject(list[i], 'SSN_ZACHA32_CUBE')
        if mon_ssn == nil then
            Chat(list[i], 'Load')
            PlayAnim(list[i], 'FLICKERING')
            CreateSessionObject(list[i], 'SSN_ZACHA32_CUBE', 1)
        else
            Chat(list[i], 'Change')
            PlayAnim(list[i], 'ON')
        end
        
        break
    end
end





function mmoefefefefewwe(self)
    local x,y,z = GetPos(self)
    local mon = {}
    local i
    for i= 1, 15 do
        mon[i] = CREATE_MONSTER(self, 'Onion', x,y+10,z, -45, 'Monster', GetLayer(self), 1, 'None', ScpArgMsg('Auto_DeoMi'), nil, nil, 100, nil, nil, 'Dummy')
    end
end



function STAKE_LINKER(self)
    local mon_ssn = GetSessionObject(self, 'SSN_STAKE_LINKER')
    if mon_ssn == nil then
        Chat(self, 'Load')
        CreateSessionObject(self, 'SSN_STAKE_LINKER', 1)
    end
end




function SCR_CREATE_SSN_STAKE_LINKER(self, sObj)
	SetTimeSessionObject(self, sObj, 1, 1000, "SSN_STAKE_LINKER_RUN")
end


function SCR_REENTER_SSN_STAKE_LINKER(self, sObj)
	SetTimeSessionObject(self, sObj, 1, 1000, "SSN_STAKE_LINKER_RUN")
end

function SCR_DESTROY_SSN_STAKE_LINKER(self, sObj)
end

function SSN_STAKE_LINKER_RUN(self, sObj)
    
end





function GRAEDDIEE(self)
--    local hoverDist = GetRadius(self)
--    print(hoverDist)
end



function AMUNA_MON_SET(monObj, enterFuncName)
    monObj.Range = 10
	monObj.Enter = enterFuncName;
	monObj.OnlyPCCheck = "NO";
end

function AMUNA_SOHWAN_2(self)
	local x,y,z = GetPos(self)
	local nox_mon = CREATE_NPC_EX(self, 'npc_zachariel_cube', x+30, y, z, -45, 'Neutral', '', 10, AMUNA_MON_SET, "TAKE_DA_01");
    SPIN_MYCUBE(nox_mon)
end


function SCR_TAKE_DA_01_ENTER(self, target)
    
    if target.Faction == 'Monster' then
        TakeDamage(self, target, "None", 20);
    end
end

function SPIN_FAU(self)
   
    local list, Cnt = SelectObjectByClassName(self, 200, 'boss_Achat')
    print(Cnt)
    local i
    for i = 1, Cnt do
        
        ClearBTree(list[i])
        SetFixAnim(list[i], 'KNOCKDOWN')
    end
end

function SUMMON_CUBE_COMON(self)
	local nox_mon = CREATE_NPC_EX(self, 'npc_zachariel_cube', 41.62, -21.90, -484.75, 0, 'Neutral', '', 10);
--    AttachEffect(nox_mon, 'I_smoke038_blue', 1.5)
end

function POTENTO(self)

    CameraShockWave(self, 2, 99999, 15,10,60,0)
end


function POTENDO_DIE(self)
    local list, Cnt = SelectObjectByClassName(self, 200, 'npc_zachariel_cube')
    local i
    for i = 1, Cnt do
        Kill(list[i])
    end
end

function SPIN_MYCUBE(self)
    local list, Cnt = SelectObject(self, 150, 'ALL')
    local i
    for i = 1, Cnt do
    	local skill = GetNormalSkill(self);
    	ForceDamage(self, skill, list[i], self, 0, 'MOTION', 'BLOW', 'sequoia_skl_force', 1, 'arrow_cast', 'skl_Berserk_light', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1, 0)
    end
end




function mayorking1(self)
	local x,y,z = GetPos(self)
	local nox_mon = CREATE_NPC_EX(self, 'npc_zachariel_gate', x+30, y, z, -90, 'Neutral', '', 10);
--    AttachEffect(nox_mon, 'I_smoke038_blue', 1.5)
end

function mayorking2(self)
	local x,y,z = GetPos(self)
	local nox_mon = CREATE_NPC_EX(self, 'npc_zachariel_cube', x+30, y, z, -45, 'Neutral', '', 10);
	--RunScript('MAYOYOYOYOYO', nox_mon)

end


function MAYOYOYOYOYO(self)

    AttachEffect(self, 'I_smoke038_blue', 1.5, 'MID', 100, 10, 10)

end




function KEEEEEEEEEEK3(self)
    local zoneID = GetZoneInstID(self);
	local list, cnt = GetLayerMonList(zoneID, 1);
end



function modpat_selecter(self)
    PlayAnim(self)
end

function oweofweofnoweinfweree(self)
    local list, Cnt = SelectObject(self, 200, 'ALL')
    local i
    local x,y,z = GetPos(self)
    for i = 1, Cnt do
        --Move3D(list[i], x, y+10, z, 250, 1);
        ChangeScale(list[i], 0.2, 10)
    end
end



function FLY_TO_THE_PANG(self)
    local list, Cnt = SelectObjectByClassName(self, 200, 'npc_zachariel_gate')
    local i
    for i = 1, Cnt do
        MZACHA_GATE_DOWN(list[i])
    end
end



function TEST_COCOCOCOCO(self)
    local result2 = DOTIMEACTION_R(self, ScpArgMsg("Auto_tack_bon_01"), 'MAKING', 2);
    if result2 == 1 then
    
    end
end



function TEST_LOLOLLOLOLO(self)
    if IsCollectionVitality(self, 'collection_00001') == 1 then
        print(ScpArgMsg("Auto_HwalSeong"))
    else
        print(ScpArgMsg("Auto_"))
    end
end




function  powenjjfwefwf(self)
    local zoneID = GetZoneInstID(self);
end






function awnefoweofnwoefnwnfwef(self)
    AddHelpByName(self, 'TUTO_COLLECTION')
end

function TEST_HPLOCK_TEST(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'ET_maggotegg_green', x, y, z, GetDirectionByAngle(self), 'Monster', 200, wejfoiwejfoiwef);
--    AddBuff(mon, mon, 'HPLock', 10, 0, 0, 1)
--    AddVisiblePC(mon, self, 0)
end

function wejfoiwejfoiwef(self)
    self.HPCount = 200
    self.BTree = 'None'
end


function JKJEJFEJFEOOOEE(self)
    local list, Cnt = SelectObjectByClassName(self, 150, 'Firetower_GateOpen')
    local i
    for i = 1, Cnt do
        AddVisiblePC(list[i], self, 1)
    end
end


function whefoweofowefoiwejf(self)
    local cnt_ssn = GetSessionObject(self, 'SSN_SIAU15_R_CNT')
    DestroySessionObject(self, cnt_ssn)
end 


function TOTOKASRIKA(self)
    local x, y, z = GetPos(self)
    
    local mon = CREATE_MONSTER_EX(self, 'ET_Silva_griffin_minimal', x, y, z, GetDirectionByAngle(self), 'Monster', self.Lv, DEV_TEST_AI);
end

function DEV_TEST_AI(mon)
    mon.SimpleAI = 'DEV_AI_MODPAT'
end



function ALPGELPGLEP(self)
    local list, Cnt = SelectObject(self, 150, 'ALL')
    local i
    for i = 1, Cnt do
        if list[i].ClassName == 'Galok' then
            if IsBuffApplied(list[i], 'HPLock') == 'YES' then
                Chat(list[i], "GGGGGGGGG")
            else
            AddBuff(self, list[i], 'HPLock', 100, 0, 0, 1)
            
            end
        end
--    ObjectColorBlend(list[i], 55, 55, 255, 255, 1, 10, 0, 1);
    end
end


function TEST_GUILD_STAGE(self)
    RunMGame(self, 'M_GTOWER_INIT')
end



function MINE_DIARY_01(pc)
    local get_item = GetInvItemList(pc);
    local itemType = {}
    local item_cnt = {}
    for i = 1, #get_item do
        itemType[i] = GetClass("Item", 'Book11').ClassID;
        item_cnt[i] = GetInvItemCountByType(pc, itemType[i]);
        if item_cnt[i] == 0 then
            RunScript('GIVE_ITEM_TX', pc, 'Book11', 1, "BOOK")
            break
        end
    end
end

function norpat(self)
    AddHelpByName(self, 'TUTO_DUNGEON')
end

function ALL_HELP_RUN(self)

    local list, cnt = GetClassList("Help")
    local i
	for i = 0 , cnt-1 do
        local cls = GetClassByIndexFromList(list, i);
        AddHelpByName(self, cls.ClassName)
	end


end


function CLEAR_INV_ITEM(self)
	local get_item = GetInvItemList(self);
	if #get_item > 0 then
        local itemType = {}
        local item_cnt = {}
    	for i = 1, #get_item do
            itemType[i] = GetClass("Item", get_item[i].ClassName).ClassID;
            item_cnt[i] = GetInvItemCountByType(self, itemType[i]);
            if get_item[i].ClassName ~= 'Vis' then
                RunScript('TAKE_ITEM_TX', self, get_item[i].ClassName, item_cnt[i], "Quest")
            end
        end
    end
end



function wofjweofjoweifjoiwemfoiwemnf(self)
    
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Altarcrystal_P1', x, y, z, GetDirectionByAngle(self), 'Our_Forces', self.Lv, SET_REMAINS40_MON);
    SpinObject(mon, 0, -1, 1, 0)
    SetLifeTime(mon, 60);
    AttachEffect(mon, 'F_light055_pink', 8, 'MID')
    AttachEffect(mon, 'F_circle009', 40, 'BOT')
end

function HOVER_EFFECT(self)
    local x, y, z = GetPos(self)
    local mon = {}
    local i
    for i = 1, 5 do
        if i == 1 then
            mon[i] = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv);
            AttachEffect(mon[i], 'F_light055_blue', 1, 'MID')
            HoverAround(mon[i], self, 25, 10, 0.5, 1);
        elseif i == 2 then
            mon[i] = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv);
            AttachEffect(mon[i], 'F_light055_green', 1.5, 'MID')
            HoverAround(mon[i], self, 40, 10, 0.8, 1);
        elseif i == 3 then
            mon[i] = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv);
            AttachEffect(mon[i], 'F_light054', 2, 'MID')
            HoverAround(mon[i], self, 60, 10, 1.5, 1);
        elseif i == 4 then
            mon[i] = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv);
            AttachEffect(mon[i], 'F_light055_red', 3, 'MID')
            HoverAround(mon[i], self, 80, 10, 2, 1);
        elseif i == 5 then
            mon[i] = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv);
            AttachEffect(mon[i], 'F_light055_violet', 4, 'MID')
            HoverAround(mon[i], self, 100, 10, 2.5, 1);
        end
    end
end



function foiuweofnwoeifjoiwefj(self)
    local list, cnt = SelectObject(self, 500, 'ALL', 1)
    local i
    for i = 1 , cnt do
        print(cnt)
        print(list[i].ClassName)
        print(GetOwner(list[i]))
    end
end






function MODPAT_GO_TO_MONMON(self)
    local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
	local list, cnt = GetLayerMonList(zoneID, layer);
	local i
	print(cnt)
--	for i = 1, cnt do
--	    if cnt > 0 then
--    	    if list[i].ClassName == 'Hiddennpc_Q3' then
--    	        local x, y, z = GetPos(list[i])
--    	        SetPos(self, x,y,z)
--    	        break
--    	    end
--    	end
--	end
end



function dksdyddgus(self)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(self);
	local i
	for i = 1, cnt do
	    print(list[i].Name)
--	    if list[i].Name == ScpArgMsg('Auto_anyongHyeon123') then
--	        local x, y, z = GetPos(self)
--	        SetPos(list[i], x,y,z)
--	        break
--	    end
	end
end



function ononqweoenfononowef(self, i)
    local ssn = GetSessionObject(self, 'SSN_FTOWER42_MQ')
    if ssn == nil then
        print(ScpArgMsg("Auto_Deuleoom"))
        CreateSessionObject(self, 'SSN_FTOWER42_MQ', 1)
        local ssn = GetSessionObject(self, 'SSN_FTOWER42_MQ')
        return
    end
    print(ScpArgMsg("Auto_NaKam"))
    
    if i ~= 0 then
        local ssn = GetSessionObject(self, 'SSN_FTOWER42_MQ')
        DestroySessionObject(self, ssn)
        print(ScpArgMsg("Auto_PaKoe"))
    end
end


function wejfpjweofjojojowefoiwejf(self)
    PlayEffect(self, 'F_explosion004_blue', 0.3, 1, 'MID')
    PlayEffect(self, 'F_ground095_circle', 5, 1, 'BOT', 1)
end


function TOTOKETKOT(self, msg)
--    local string_cut_list = SCR_STRING_CUT(msg)
--    print(string_cut_list[1], 'eeeeeeeeeee', string_cut_list[2])
    local quest_select = SCR_KEY_QUEST_USE_SELECT(self)
    print(quest_select)
end


function CK_NAVI_NPC(self)
    local x,y,z = GetPos(self)
	local navi_mon = CREATE_NPC_EX(self, 'Silvertransporter_m_Quest', x, y, z, 0, 'Neutral', 'CK_NAVI_MON', 99, CK_NAVI_NPC_RUN);
	SetOwner(navi_mon, self, 1)
end

function CK_NAVI_NPC_RUN(mon)
    mon.SimpleAI = 'CK_NAVI_NPC_RUN'
    mon.WlkMSPD = 120
    mon.Dialog = 'CK_NAVI_NPC'
end

function SCR_CK_NAVI_NPC_DIALOG(self, pc)
    Chat(self, 'DIALOG', 2)
end


function GETCOODCELL(self)
--    local follower = GetScpObjectList(self, 'GELE574_MQ_08')
    local i
    local x = 1
    local y = 2
    local z = 3
    for i = 1, 4 do
        local mon = {}
--        if #follower == 0 then
            local list = GetCellCoord(self, 'cardinal_far', 0)
            print(list[x], list[z])
            mon[i] = CREATE_MONSTER_EX(self, 'Goblin_Spear_red', list[x], list[y], list[z], 0, 'Neutral', 28, GELE574_MQ_08_AI_RUN, self);
            LookAt(mon[i], self)
--            AddScpObjectList(self, 'GELE574_MQ_08', mon[i])
            x = x + 3
            y = y + 3
            z = z + 3
--        end
    end
end





function faowefowefwef3er3(self)
    local val = GetMGameValue(self, 'JOB_ROGUE4_1')
    print(val)
end


function weofowefonweofowefoiwnfownef(self)
    local list, cnt = SelectObject(self, 100, 'ALL')
    local i
    local mon
    for i = 1, cnt do
        mon = list[i]
        break
    end
    
end


function CK_SIMPLEAI_NPC(self)
    local x,y,z = GetPos(self)
	local navi_mon = CREATE_NPC_EX(self, 'blank_npc', x, y, z, 0, 'Neutral', 'CK_NAVI_MON', 99, CK_SIMPLEAI_NPC_RUN);
	SetOwner(navi_mon, self, 1)
end

function CK_SIMPLEAI_NPC_RUN(mon)
    print("GGGGG")
    mon.SimpleAI = 'JOB_SCOUT4_1'
end


function CK_SKLL_HAVE(self)
    UsePcSkill(self, self, 'Warrior_Provoke', 1, 1)
end

function GET_GET_GET_HATE(self)

    local list = {}
    
    local cnt = GetHatedCount(self)
    for i = 0 , cnt-1 do
        local actor, hatepoint = GetHatedChar(self, i)
        list[#list + 1] = actor;
    end
    
    
    for i = 1 , #list do
        ResetHateAndAttack(list[i], self)
        CancelMonsterSkill(list[i])
    end

end

function CK_CLASS_MOVE(self)
    local result = SCR_QUEST_CHECK(self, 'JOB_SCOUT4_1')
    if result == 'PROGRESS' then
        if GetLayer(self) == 0  then
    	    if GetZoneName(self) == 'f_pilgrimroad_52' then
                local quest_ssn = GetSessionObject(self, 'SSN_JOB_SCOUT4_1')
                
                if quest_ssn ~= nil then
                    if quest_ssn.Goal == 1 then
                        
                    end
                end
            end
        end
    end
    return 0
end



function GET_ZERO_LAYER_PC(self)
    print(GetLayer(self))
end

function SET_NEW_LAYER_PC(self, ch)
    SetLayer(self, ch)
end

function modpat(self, msg)
    local msg_list = SCR_STRING_CUT(msg)
    local tb  = {}
    local group = {}
    local cnt = {}
    local table_name = {}
    local ies_sel = {}
    local class_count = GetClassCount('Map')
    local y, z
    for y = 0, class_count -1 do
        tb[#tb + 1] = GetClassByIndex('Map', y)
        group = SCR_STRING_CUT_SPACEBAR(tb[#tb].Theme)
        if group[1] == msg_list[1] then
            cnt[#cnt+1] = tb[#tb].Name
            table_name[#table_name+1] = tb[#tb].ClassName
            ies_sel[#ies_sel+1] = tb[#tb]
        end
    end

    local warp_select = SCR_SEL_LIST(self, cnt, 'MODPAT_ZONEMOVE',table_name )
    MoveZone(self, ies_sel[warp_select].ClassName, ies_sel[warp_select].DefGenX, ies_sel[warp_select].DefGenY, ies_sel[warp_select].DefGenZ)
end



function ENABLEAIOUTOFPC_RUN(self)
    EnableAIOutOfPC(self)
end






function HATE_TEST_MON_GROUP(self)
    local a, b, c = GetPos(self)
	local navi_mon = CREATE_NPC_EX(self, 'holly_sphere_gele', a, b+15, c, 0, 'Our_Forces', 'HIT ME', 99, NAVI_MON_GELE);
    local attacker = GetScpObjectList(self, 'HATE_TEST_MON_GROUP')
    local i
    local x = 1
    local y = 2
    local z = 3
    if #attacker == 0 then
        for i = 1, 4 do
            local mon = {}
            local list = GetCellCoord(self, 'cardinal_far', 0)
            mon[i] = CREATE_MONSTER_EX(self, 'Onion', list[x], list[y], list[z], -45, 'Monster', 88, HATE_TEST_MON_GROUP_RUN);
            AddScpObjectList(self, 'HATE_TEST_MON_GROUP', mon[i])
            local skillName = GetMonsterSkillName(mon[i], 0)
            UseMonsterSkill(mon[i], navi_mon, skillName);
            InsertHate(mon[i], navi_mon, 999)
            x = x + 3
            y = y + 3
            z = z + 3
        end
    end

end

function HATE_TEST_MON_GROUP_RUN(mon)
    mon.SimpleAI = 'DEV_TEST'
end

function HATE_TEST_MON_GROUP_HATE(self)
    local cnt = GetHatedCount(self)
    print(cnt)
end 

function NAVI_MON_GELE(mon)
    mon.SimpleAI = 'DEV_TEST_2'
end



function NAVI_MON_GELE_RUN(self)
    local list, cnt = SelectObjectByFaction(self, 300, 'Monster')
    local i 
    for i = 1, cnt do
        TakeDamage(self, list[i], "None", 1);
    end
--    print("RUN!")
end 


function GET_LAYER_PCPC(self)
    local list, cnt = GetLayerPCList(self);
    print(list[1].Name)
end






function nfoowejfoiewroifgweoifjweoifj(self)
    local now_time = os.date('*t')
    local now_time_min = now_time['yday'] * 60 * 24 + now_time['hour'] * 60 + now_time['min']
    local now_month
    local now_day
    if now_time['month'] < 10 then
        now_month = "0"..now_time['month']
    else
        now_month = now_time['month']
    end
    
    if now_time['day'] < 10 then
        now_day = "0"..now_time['day']
    else
        now_day = now_time['day']
    end
    
    local total_time = now_time['year']..now_month..now_day
    print(tonumber(total_time))
end

function RESET_PROPERTY_9482(self)
    local req_ssn = GetSessionObject(self, 'SSN_REQUEST')
--    req_ssn.REQ_SEMPLE_06_TRADE = 'None'
--	local aobj = GetAccountObj(self);
--	local curMedal = GetIESProp(aobj, "Medal");


    SetMGameValue(self, 'REQ_SEMPLE_06_MINI', 0)
    
    print(req_ssn.REQ_SEMPLE_01)
    print(req_ssn.REQ_SEMPLE_02)
    print(req_ssn.REQ_SEMPLE_03)
    print(req_ssn.REQ_SEMPLE_04)
    print(req_ssn.REQ_SEMPLE_05)
    print(req_ssn.REQ_SEMPLE_06)

    local list, cnt = SelectObjectByClassName(self, 200, 'Firetower_GateOpen')
    local i
    for i = 1 , cnt do
        print(GetCurrentFaction(list[i]))
        break
    end

--    req_ssn.REQ_SEMPLE_01 = 1
--    req_ssn.REQ_SEMPLE_02 = 100
--    req_ssn.REQ_SEMPLE_03 = 100
--    req_ssn.REQ_SEMPLE_04 = 100
--    req_ssn.REQ_SEMPLE_05 = 100
--    req_ssn.REQ_SEMPLE_06 = 100
--
--    req_ssn.REQ_SEMPLE_01_TIME = 'None'
--    req_ssn.REQ_SEMPLE_02_TIME = 'None'
--    req_ssn.REQ_SEMPLE_03_TIME = 'None'
--    req_ssn.REQ_SEMPLE_04_TIME = 'None'
--    req_ssn.REQ_SEMPLE_05_TIME = 'None'
    req_ssn.REQ_SEMPLE_06_TRADE = 'None'
--    
--    req_ssn.REQ_SEMPLE_06_TRADE = 'None'
--    for i = 1 , 60 do
--        print(math.floor(tonumber(i/60*100)))
--    end
end



function RETETETETETET(self)
    local list, cnt = SelectObjectByClassName(self, 200, 'Silvertransporter_m_Quest')
    local i
    for i = 1 , cnt do
        local req_ssn = GetSessionObject(list[i], 'SSN_REQ_DEFENSE')
        if req_ssn == nil then
            CreateSessionObject(list[i], 'SSN_REQ_DEFENSE', 1)
        end
        print(req_ssn.ReqArg)
        break
    end

--    local list, cnt = SelectObjectByClassName(self, 200, 'shrine_bot',1)
--    print(cnt)

--    local list, cnt = SelectObject(self, 200, 'ALL')
--    local i
--    for i = 1 , cnt do
--        if list[i].ClassName == 'Firetower_GateOpen' then
--            print(GetCurrentFaction(list[i]))
--            local req_ssn = GetSessionObject(list[i], 'SSN_REQ_DEFENSE')
--            if req_ssn ~= nil then
--                print(req_ssn.ClassName)
--            end
--
--        end
--    end
    

end






function RETETETETETETefefe(self)
    local list, cnt = SelectObjectByClassName(self, 200, 'Silvertransporter_m_Quest')
    local i
    for i = 1 , cnt do
        print(list[i].ClassName)
        SetFixAnim(list[i], 'WLK')
        
        break
    end

end


--IsSessionObject()?
function MODPAT_GET_SOBJ_LIST(self)
    local list, cnt = GetClassList('SessionObject')
    local i
    local ssn = {}
    local basic_ssn = {}
--    print(ScpArgMsg('GET_SOBJ_LIST_03'))
    for i = 0, cnt-1 do
        local getssn = GetClassByIndexFromList(list, i);
        local allssn = GetSessionObject(self, getssn.ClassName)
        if allssn ~= nil then
            
            ssn[#ssn+1] = allssn
            if allssn.ClassName == 'ssn_klapeda' or allssn.ClassName == 'ssn_drop' or allssn.ClassName == 'SSN_MAPEVENTREWARD' or allssn.ClassName == 'ssn_smartgen' or allssn.ClassName == 'ssn_raid' or allssn.ClassName == 'SSN_DIALOGCOUNT' or allssn.ClassName == 'SSN_REQUEST' or allssn.ClassName == 'ssn_shop' then
                basic_ssn[#basic_ssn+1] = allssn
            else
                print(allssn.ClassName)
            end
        end
    end
    print('GET_SOBJ_LIST_01    '..#basic_ssn)
    print('GET_SOBJ_LIST_02    '..#ssn - #basic_ssn)
end



function MODPAT_WLK_TEST(self)
    
    local list, cnt = SelectObject(self, 300, 'ALL')
    local i
    for i = 1 , cnt do
        MoveToTarget(list[i], self, 15)
    end
    
end



function MODPAT_SEND_MSG(pc)
    SendAddOnMsg(pc, "NOTICE_Dm_stage_start", 'EarthTower_TEST', 30);
end

function MODPAT_SEND_MSG1(pc)

    SendAddOnMsg(pc, "EXPCARD_USE_TUTORIAL_END")
end

function oojojweojfowejfoiwejf(self)
    PlayDirection(self, 'd_underfortress_59_3_TRACK')
end


function MODPAT_AI_GROUP_RUN(self, pc)
    InsertHate(self, pc, 10)
    local list, cnt = SelectObjectByClassName(self, 200, 'Onion')
    local i
    local last_pc = GetLastAttacker(self)
    for i = 1, cnt do
        InsertHate(list[i], pc, 10)
    end
    
end


function MODPAT_AI_GROUP_RUN_UPDATE(self)
    local list, cnt = SelectObjectByClassName(self, 200, 'PC')
    local i
    if cnt ~= 0 then
        for i = 1, cnt do
            local hate = GetHate(self, list[i])
            Chat(self, tostring(hate))
        end
    end
    
end


function modpat_etetetet(self)
    PlayDirection(self, 'DEV_AI_MINI');
end

function DEV_AI_MODPAT(self)
    MoveZone(self, 'mission_groundtower_1', 2903, 239, 3731)
end

function DEV_AI_SETTING(self)
    self.BTree = 'None'
end

function DEV_AI_GROUP_UPDATE(self, from)

	local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    if argstr2 ~= nil and argstr2 ~= 'None' then

        if string.find(argstr2, 'MODPAT/') ~= nil then

            local my_cut_list = SCR_STRING_CUT(argstr2)
            local list, Cnt = SelectObject(self, 150, 'ALL', 1)
            local i
            
            for i = 1, Cnt do
                if list[i].ClassName ~= 'PC' then
                    local f1, f2, f3 = GetTacticsArgStringID(list[i])
                    local frient_cut_list = SCR_STRING_CUT(f2)
                    if my_cut_list[2] == frient_cut_list[2] then
                        InsertHate(list[i], from, 1)
                    end
                end
            end
        end 
    end
end



function MODPAT_WARP_TO_PC(self, pc_name)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local i
	for i = 1, cnt do
	    if list[i].Name == pc_name then
	        local x, y, z = GetPos(list[i])
	        SetPos(self, x,y+10,z)
	        break
	    end
	end
end

function MODPAT_WARP_TO_USER(self, pc_name)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local i
	for i = 1, cnt do
	    if list[i].Name == pc_name then
	        local x, y, z = GetPos(self)
	        SetPos(list[i], x,y+10,z)
	        break
	    end
	end
end


function MODPAT_QUEST_CK(self, pc_name, quest_pro)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local i
	for i = 1, cnt do
	    if list[i].Name == pc_name then
	        local result = SCR_QUEST_CHECK(list[i], quest_pro)
	        ChatLocal(self, self, result, 10)
	        local main_ssn = GetSessionObject(list[i], 'ssn_klapeda')
            local quest_ssn = GetClass('QuestProgressCheck', quest_pro).Quest_SSN
	        if main_ssn ~= nil then
    	        local select = ShowSelDlg(self, 0, 'MODPAT_QUEST_CTRL', ScpArgMsg('MODPAT_QCTRL_1'), ScpArgMsg('MODPAT_QCTRL_2'), ScpArgMsg('MODPAT_QCTRL_3'), ScpArgMsg('MODPAT_QCTRL_4'))
                if select == 1 then
                    main_ssn[quest_pro] = 0
                elseif select == 2 then
                    main_ssn[quest_pro] = 1
                    local pro_ssn = GetSessionObject(list[i], quest_ssn)
                    if pro_ssn == nil then
                        CreateSessionObject(list[i], quest_ssn, 1)
                    end
                elseif select == 3 then
                    main_ssn[quest_pro] = 300
                    local pro_ssn = GetSessionObject(list[i], pro_ssn)
                    if pro_ssn ~= nil then
                        DestroySessionObject(list[i], quest_ssn)
                    end
                elseif select == 4 then
                    return
                end
    	        break
    	    end
	    end
	end
end

function MODPAT_GIVE_ITEM(self, pc_name, item, item_cnt)
    if item_cnt == nil or item_cnt == 0 then
        item_cnt = 1
    end
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local i
	for i = 1, cnt do
	    if list[i].Name == pc_name then
        	RunScript('GIVE_ITEM_TX', list[i], item, item_cnt, "Quest")
        	break
	    end
	end
end

function MODPAT_TAKE_ITEM(self, pc_name, item, item_cnt)
    if item_cnt == 0 then
    	local zoneID = GetZoneInstID(self);
    	local layer = GetLayer(self);
        local list, cnt = GetLayerPCList(zoneID, layer);
    	local i
    	for i = 1, cnt do
    	    if list[i].Name == pc_name then
            	local get_item = GetInvItemList(list[i]);
            	if #get_item > 0 then
                    local itemType = {}
                    local item_cnt = {}
                	for i = 1, #get_item do
                        itemType[i] = GetClass("Item", get_item[i].ClassName).ClassID;
                        item_cnt[i] = GetInvItemCountByType(list[i], itemType[i]);
                        if get_item[i].ClassName == item then
                            RunScript('TAKE_ITEM_TX', list[i], get_item[i].ClassName, item_cnt[i], "Quest")
                            break
                        end
                        ChatLocal(self, self, 'No More Item', 2)
                    end
                end
            end
        end
    else
    	local zoneID = GetZoneInstID(self);
    	local layer = GetLayer(self);
        local list, cnt = GetLayerPCList(zoneID, layer);
    	local i
    	for i = 1, cnt do
    	    if list[i].Name == pc_name then
            	local get_item = GetInvItemList(list[i]);
            	if #get_item > 0 then
                	for i = 1, #get_item do
                        if get_item[i].ClassName == item then
                            RunScript('TAKE_ITEM_TX', list[i], get_item[i].ClassName, item_cnt, "Quest")
                            break
                        end
                        ChatLocal(self, self, 'No More Item', 2)
                    end
                end
            end
        end
    end
end




function MODPAT_NPCHIDE(self, pc_name, hidenpc)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local i
	for i = 1, cnt do
	    if list[i].Name == pc_name then
	        local ishide = isHideNPC(list[i], hidenpc)
	        if ishide == 'YES' then
    	        ChatLocal(self, self, 'HIDE', 10)
    	    else
    	        ChatLocal(self, self, 'UNHIDE', 10)
    	    end
    	    
            local select = ShowSelDlg(self, 0, 'MODPAT_HIDE_CTRL', ScpArgMsg('MODPAT_HCTRL_1'), ScpArgMsg('MODPAT_HCTRL_2'), ScpArgMsg('MODPAT_HCTRL_3'))
            if select == 1 then
                HideNPC(list[i], hidenpc, 0, 0, 0)
            elseif select == 2 then
                UnHideNPC(list[i], hidenpc)
            elseif select == 3 then
                return
            end
	        break
	    end
	end
end

function MODPAT_DESTROY_SSN(self, pc_name, all)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
	local j
	local player_name
	
	for j = 1, cnt do
	    if list[j].Name == pc_name then
    	    player_name = list[j]
    	    break
    	end
	end
    local list, cnt = GetClassList('SessionObject')
    local i
    local ssn = {}
    local basic_ssn = {}
    local ssn_cnt = {}
    for i = 0, cnt-1 do
        local getssn = GetClassByIndexFromList(list, i);
        local allssn = GetSessionObject(player_name, getssn.ClassName)
        if allssn ~= nil then
            ssn[#ssn+1] = allssn
            if allssn.ClassName == 'ssn_klapeda' or allssn.ClassName == 'ssn_drop' or allssn.ClassName == 'SSN_MAPEVENTREWARD' or allssn.ClassName == 'ssn_smartgen' or allssn.ClassName == 'ssn_raid' or allssn.ClassName == 'SSN_DIALOGCOUNT' or allssn.ClassName == 'SSN_REQUEST' or allssn.ClassName == 'ssn_shop' then

            else
                basic_ssn[#basic_ssn+1] = allssn
                ssn_cnt[#ssn_cnt +1] = allssn.ClassName
            end
        end
    end
    if all ~= 'ALL' then
        local ssn_select = SCR_SEL_LIST(self, ssn_cnt, 'MODPAT_ZONEMOVE', basic_ssn)
        if ssn_select ~= nil then
            ChatLocal(self, self, ssn_cnt[ssn_select], 10)
            local q_ssn = GetSessionObject(player_name, ssn_cnt[ssn_select])
            if q_ssn ~= nil then
                DestroySessionObject(player_name, q_ssn)
            end
        end
    else
        local k
        for k = 1, #basic_ssn do
            local q_ssn = GetSessionObject(player_name, ssn_cnt[k])
            if q_ssn ~= nil then
                DestroySessionObject(player_name, q_ssn)
            end
        end
    end
end

function BACK_TO_HELL(self)
    local list, cnt = SelectObjectByFaction(self, 222, 'Monster')
    local i
    local x, y, z = GetPos(self)
    for i = 1 , cnt do
--        HoverAround(list[i], self, 25, 1, 5, 1); 
        SpinObject(list[i], 0, -1, 0.3, 1)
--        SetCurrentFaction(list[i])
        SetLifeTime(list[i], 3)
        Move3DByTime(list[i], x, y+5, z, 0.5, 0, 0)
--        SkillCancel(list[i]);
        ClearBTree(list[i])
        ActorVibrate(list[i], 999, 2, 50, -10);
        if i == 5 then
            break
        end
        
    end
end

function MODPAT_ROAMING_TEST_MON(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Onion', x, y, z, 0, 'Monster', 5, MODPAT_ROAMING_TEST_MON_AI);
    SetLifeTime(mon, 60)
    AddBuff(self, mon, 'CHAPLE575_MQ_07', 1, 0, 0, 1)
end

function MODPAT_ROAMING_TEST_MON_AI(mon)
--    mon.BTree = 'None'
--    mon.SimpleAI = 'CHAPLE575_MQ_06'
    mon.Lv = 40
end



function SAI_FIND_CLOSE_POS(self)
    local sai_ssn = GetSessionObject(self, 'SSN_SAI_ROAMING')
    if sai_ssn ~= nil then
        local x, y, z = GetPos(self)
        local xi = {1047, -114, -59, -831}
        local zi = {433, 401, -774, -782}
        local tb = {SCR_POINT_DISTANCE(x, z, xi[1], zi[1]), SCR_POINT_DISTANCE(x, z, xi[2], zi[2]), SCR_POINT_DISTANCE(x, z, xi[3], zi[3]), SCR_POINT_DISTANCE(x, z, xi[4], zi[4])}
        local go_pos = math.min(SCR_POINT_DISTANCE(x, z, xi[1], zi[1]), SCR_POINT_DISTANCE(x, z, xi[2], zi[2]), SCR_POINT_DISTANCE(x, z, xi[3], zi[3]), SCR_POINT_DISTANCE(x, z, xi[4], zi[4]))
        local i
        local _func = _G['SAI_MODPAT_MOVE']
        for i = 1, #tb do
            if go_pos == SCR_POINT_DISTANCE(x, z, xi[i], zi[i]) then
                return _func(self, x, y, xi[i], zi[i], sai_ssn, xi, zi)
            end
        end
    else
        Kill(self)
    end
end


function SAI_MODPAT_MOVE(self, x, z, xi, zi, sai_ssn, tb_x, tb_z)
    if sai_ssn ~= nil then
    	local IsArrive = false;
    	if IsMoving(self) == 1 then
    		local dx, dz = GetMoveToPos(self);
    		local destDist  = math.dist(x, z, dx, dz);
    		if destDist <= 10 then
    			IsArrive = true;
    			
    		end
    	end
    
    	if IsArrive == false then
    		local cx, cy, cz = GetPos(self);
    		local distToDest = math.dist(x, z, xi, zi);
    		if distToDest <= 5 then
    		    sai_ssn = 1
    			return 0;
    		end
    		MoveEx(self, xi, zi, 1);
    		return 1;
    	end
    	
    	if IsArrive == true then
    		local dist = GetDistFromMoveDest(self);
    		if dist <= 10 then
    			sai_ssn = 1
    			return 0;
    		else
    			return 1;
    		end
    	end
    else
        Kill(self)
    end
    return 0;
end



function MODPAT_POLY(self)
	if 1 == TransformToMonster(self, 'Pawndel', 'CHAPLE576_MQ_06_1') then
		AddBuff(self, self, 'CHAPLE576_MQ_06_1', 1, 1, 100000);
	end
end



function MODPAT_ITEM(pc, Lv)
--    local lv = pc.Lv
--    
--    if option2 ~= nil and option2 ~= 'None' and tonumber(option2)~= nil and tonumber(option2) > 0 then
--        lv = tonumber(option2)
--    end
--    
--    local itemlv1 = 0
--    local itemlv2 = 0
--    local class_count = GetClassCount('Item')
--    local return_list = {}
--    if GetPropType(GetClassByIndex('Item', 0),'UseLv') == nil then
--        return
--    end
--    
--    for y = 0, class_count -1 do
--        local classIES = GetClassByIndex('Item', y)
--        if classIES.ItemType == 'Equip' and classIES.UseLv <= lv and classIES.UseLv > itemlv1 then
--            itemlv2 = itemlv1
--            itemlv1 = classIES.UseLv
--        end
--    end
--    
--    if itemlv1 > 0 then
--        local itemListIES = SCR_GET_XML_IES('Item', 'UseLv', itemlv1)
--        if option1 ~= nil and option1 ~= 0 and option1 ~= 'None' and option1 ~= '0' then
--            local itemListIES2 = SCR_GET_XML_IES('Item', 'UseLv', itemlv2)
--            local itemListIES = SCR_IES_ADD_IES(itemListIES, itemListIES2)
--        end
--        
--        local itemList = {}
--        for i = 1, #itemListIES do
--            itemList[#itemList + 1] = itemListIES[i].Name..' : '..itemListIES[i].UseLv..' : '..itemListIES[i].ItemStar..' : '..itemListIES[i].ReqToolTip
--        end
--        local select = SCR_SEL_LIST(pc,itemList, 'SCR_SUITABLE_ITEM', 1, 'DLG_NO_WAIT')
--        if select ~= nil and select > 0 then
--            local tx = TxBegin(pc);
--            TxGiveEquipItem(tx, itemListIES[select].DefaultEqpSlot, itemListIES[select].ClassName)
--            local ret = TxCommit(tx);
--        end
--    end
end




function DIE_DESTY_TEST(pc)
    local take_hp
    if pc.HP < (pc.MHP*0.5) then
        take_hp = 1
    else
        take_hp = (pc.HP - pc.MHP*0.5)
    end
    print(take_hp, (pc.MHP - pc.MHP*0.5))
end


function LEFFLEWFSEF(self)
    PlayEffect(self, 'F_smoke011_blue', 1)
end

--F_wizard_icebolt_cast_spread_in

function monGetGenAngle(self)
    local dir = GetGenAngle(self)
    Chat(self, dir, 1)
end





function KILL_BLEND_TEST(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Onion', x, y, z, 0, 'Neutral', 5);
    KILL_BLEND(mon, 1, 1)
end



function MODPAT_DEV_AI_LASTATTACKER(mon, caster)
    AddBuff(mon, mon, 'RUNAWAY_MONSTER', 1, 0, 0, 1)
end


function MODPAT_DEV_AI_RUNAWAY(self)
    local _pc = GetTopHatePointChar(self)
    if _pc ~= nil then
        local list, cnt = SelectObjectByClassName(self, 50, 'Warp_arrow')
        if cnt < 1 then
            local _far
            local x, y, z = GetPos(self)
            local pc_dic = GetAngleFromPos(_pc, x, z)-180
            local dist = GetDistance(self, _pc)
            if dist > 100 then
                _far = 5
                self.NumArg4 = self.NumArg4 + 1
                if self.NumArg4 >= 10 then
                    ResetHate(self)
                    StopMove(self)
                    RemoveBuff(self, 'RUNAWAY_MONSTER')
                    self.NumArg4 = 0
                    return 1
                end
            else
                _far = dist
            end
            local angle_to = GetAngleTo(self, _pc)
            local x1, y1, z1 = GetFrontPosByAngle(self, pc_dic, _far, 1, x, y, z, 1);
            MoveEx(self, x1, y1, z1, 1)
        else
            StopMove(self)
            KILL_BLEND(self, 3, 1)
        end
        return 1
    else
        return 0
    end
end

function MODPAT_DEV_AI_RUNAWAY_1(self)
    local list, cnt = SelectObjectByClassName(self, 50, 'Warp_arrow')
    if cnt > 0 then
        StopMove(self)
        KILL_BLEND(self, 3, 1)
        return 1
    else
        return 0
    end
end



function wefnowenfijnwefnweoif(self)
    local main_ssn = GetSessionObject(self, 'ssn_klapeda')
    if main_ssn ~= nil then
        print("GGG")
        main_ssn.REMAIN37_MQ02 = 300
        main_ssn.REMAIN37_MQ03 = 300
        main_ssn.REMAIN37_MQ05 = 300
        main_ssn.REMAIN37_SQ01 = 300
        main_ssn.REMAIN37_SQ02 = 300
        main_ssn.REMAIN37_SQ03 = 300
        main_ssn.REMAIN37_SQ04 = 300
        main_ssn.REMAIN37_SQ05 = 300
        main_ssn.REMAIN37_SQ06 = 300
        main_ssn.REMAIN37_SQ07 = 300
        main_ssn.REMAIN37_SQ08 = 300
        main_ssn.REMAIN38_MQ06 = 300
        main_ssn.REMAIN38_MQ07 = 300
        main_ssn.REMAIN38_SQ02 = 300
        main_ssn.REMAIN38_SQ03 = 300
        main_ssn.REMAIN38_SQ04 = 300
        main_ssn.REMAIN38_SQ06 = 300
        main_ssn.REMAIN39_SQ04 = 300
        main_ssn.REMAIN39_SQ08 = 300
        main_ssn.REMAINS39_MQ07 = 300
        main_ssn.REMAINS40_MQ_07 = 300
    end
end



function wejfoweofweee(self)
    print(GetSessionObject(self, 'SSN_UNDERF592_TYPEB'))
end




function MODPAT_FOLLOWER_NPC_AI(mon)
    mon.BTree = 'None'
    mon.SimpleAI = 'None'
    mon.Tactics = 'None'
    mon.WlkMSPD = 120
end


function MODPAT_FOLLOWER_NPC_AI_1(self)
    local _pc = GetOwner(self)
    if _pc ~= nil then
        local x, y, z = GetPos(_pc)
        local opt, x1, y1, z1 = GetTacticsArgFloat(self)
        if opt == 1 then
            if IsNearFrom(_pc, x1, z1, 10) == 'YES' then
                return 1
            else
                MoveEx(self, x1, z1, 1)
                local x2, y2, z2 = GetPos(_pc)
                SetTacticsArgFloat(self, 1, x2, y2, z2)
                return 1
            end
        else
            SetTacticsArgFloat(self, 1, x, y, z)
            return 1
        end
    end
end


function ISVALIDPOS_TEST(self)
    local x, y, z = GetPos(self)
    print(x, y, z)
    local zinstID = GetZoneInstID(self);
    if IsValidPos(zinstID,-30.979492, 49.9174, -166.35728) == 'YES' then
        print("GGGGGGGGG")
    end
end



function MODPAT_FOLLOWER_NPC(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Galok', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, MODPAT_CHAT_FLOW_AI);
--    FlyMath(mon, 60, 1, 1);
--    SetOwner(mon, self, 1)
--    PlayEffect(mon, 'F_light055_violet', 1, 'TOP')
end

--
--function MODPAT_CHAT_FLOW(self)
--    local msg = {
--                ScpArgMsg('MODPAT_HCTRL_1'),
--                ScpArgMsg('MODPAT_HCTRL_1'),
--                ScpArgMsg('MODPAT_HCTRL_1'),
--                ScpArgMsg('MODPAT_HCTRL_1'),
--                ScpArgMsg('MODPAT_HCTRL_1'),
--                }
--    Chat(
--end

function MODPAT_CHAT_FLOW_AI(mon)
    mon.BTree = 'None'
    mon.SimpleAI = 'MODPAT_CHAT_FLOW_AI'
    mon.Tactics = 'None'
    mon.WlkMSPD = 0
end




function CHAT_FLOW(self, time, msg, script)
    
end


function weofwoenfoawenofnaweofw(self)
    RemoveBuff(self, 'Premium_Token')
end


function CK_UNDERF591_TYPED_ZOBJ(self)
    local zoneID = GetZoneInstID(self)
    local zon_Obj = GetLayerObject(zoneID, 0);
    if zon_Obj ~= nil then
        local TypeD_01 = GetExProp(zon_Obj, 'UNDER591_TYPE_D')
        Chat(self, TypeD_01)
    end
end


--MODPAT_SCRIPT_CK_BUFF
function SCR_BUFF_ENTER_MODPAT_SCRIPT_CK_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_MODPAT_SCRIPT_CK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_MODPAT_SCRIPT_CK_BUFF(self, buff, arg1, arg2, over)

end



function MODPAT_GET_ZONEOBJ_RESET(self)
    local zoneObj = GetLayerObject(self);
--    zoneObj.UNDERF593_TYPED_1 = 5
--    zoneObj.UNDERF593_TYPED_2=	2
--    zoneObj.UNDERF593_TYPED_3=	1
    print(zoneObj.UNDERF593_TYPED_1)
    print(zoneObj.UNDERF593_TYPED_2)
    print(zoneObj.UNDERF593_TYPED_3)


end

function GET_LIST_ZONE_MON(self)
    local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
	local list, cnt = GetLayerMonList(zoneID, layer);
    local i
    for i = 1, cnt do
        if list[i].ClassName == 'Altar1' then
            local x, y, z = GetPos(list[i])
	        SetPos(self, x, y + 5, z)
	        break
	    end
	end

end





function MODPAT_SET_ZOBJ_RUN(self)

        local zone_Obj = GetLayerObject(self);
    
        zone_Obj.FD_FIRETOWER612_T01_GATE_SOUTH = 20
        zone_Obj.FD_FIRETOWER612_T01_GATE_SOUTH_CK = 0
        zone_Obj.FD_FIRETOWER612_T01_GATE_SOUTH_CK_GEN = 0
--
        print(zone_Obj.FD_FIRETOWER612_T01_GATE_SOUTH_CK_GEN)
--        print(zone_Obj.FD_FIRETOWER612_T01_GATE_NORTH_CK)
--        print(zone_Obj.FD_FIRETOWER612_T01_GATE_NORTH_CK_GEN)
end



function MODPAT_CREATE_MON_SETPOS_RUN(self, x, y, z)
	local list, Cnt = GetLayerPCList(self);
	local i
	for i = 1, Cnt do
        SetPos(list[i], x, y + 5, z)
        return
	end
end

function wj3f3faeff33fafwef(self)
    print("GGG")
    PlayMusicQueueLocal(self, 'd_cathedral_1')
end


function fwnoawnfwenfwef(self)
    local ssn = GetSessionObject(self, 'SSN_GELE572_MQ_08_1')
    if ssn == nil then
        print("AAA")
--        CreateSessionObject(self, 'SSN_GELE572_MQ_08_1')
    else
        print("BBB")
--        DestroySessionObject(self, ssn)
    end
end



function HIDDEN_NPC_CHECKER(self)

    local zone_Obj = GetLayerObject(self);
    --SetExProp(zone_Obj, 'DEV_TEST_TEST', 0)
    local mon = {
                    'Hidden_Mon_01',
                    'Hidden_pillar',
                    'Hidden_target',
                    'HiddenControl',
                    'Hiddennpc',
                    'Hiddennpc_Godness',
                    'Hiddennpc_move',
                    'Hiddennpc_move02',
                    'Hiddennpc_move03',
                    'HiddenTrigger',
                    'HiddenTrigger2',
                    'HiddenTrigger3',
                    'HiddenTrigger4',
                    'HiddenTrigger5',
                    'HiddenTrigger6',
                    'HiddenWarp',
                    'npc_hiddennpc02'
                    }
    local cnt = GetExProp(zone_Obj, 'DEV_TEST_TEST')
    print(cnt, mon[cnt])
    local x, y, z = GetPos(self)
    local npc = CREATE_MONSTER_EX(self, mon[cnt], x, y, z, 0, 'Neutral', 5, HIDDEN_NPC_CHECKER_1);
    AddBuff(npc, npc, 'FD_FIRETOWER611_T02_ROMER_CK', 1, 0, 0, 1)
    SetExProp(zone_Obj, 'DEV_TEST_TEST', cnt + 1)
end


function HIDDEN_NPC_CHECKER_1(mon)
  mon.SimpleAI = 'DEV_TEST_2'
end


function MODPAT_COLOR_TEST(self)
    local list, cnt = SelectObject(self, 100, 'ALL')
    local i
    Chat(self, cnt, 1)
    for i = 1, cnt do
        print(list[i].ClassName)
        ObjectColorBlend(list[i], 255, 255, 255, 255, 1, 1)
    end
end


function MODPAT_DRCT_TEST_11(self)
    PlayDirection(self, 'MODPAT_ALPHA_TEST')
end

function TEST_CELLMON(self)
    local list, cnt = CREATE_MONSTER_CELL(self, 'Onion', self, 'Hexa', 999, 1, 'Monster', hweofowenfownef)
    local i
    for i = 1, cnt do
        InsertHate(list[i], self, 1)
    end
end

function hweofowenfownef(pc)
    GUILDEVENT_SELECT_TYPE(self, pc)
end


function MODPAT_RND_POS_TEST(self)

	local cnt = 1;

	while 1 do
	    print(cnt)
	    if cnt < 10 then
    		local x, y, z = GetRandomPos(self, 0, 0, 0, 1)
    		local zoneID = GetZoneInstID(self);
    		if IsValidPos(zoneID, x, y, z) == 'YES' then
    		    SetPos(self, x, y, z)
    		    return
    		else
    		    cnt = cnt + 1
    		end
    	else
    	    print("MISS")
    	    return
    	end
        
		sleep(2000);
	end

end


--GUILD_RAID_FOLLOWER
function SCR_BUFF_ENTER_GUILD_RAID_FOLLOWER(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_GUILD_RAID_FOLLOWER(self, buff, arg1, arg2, RemainTime, ret, over)

	self.PATK_BM = self.PATK_BM + 999999;
	self.MATK_BM = self.MATK_BM + 999999;
	self.HR_BM = self.HR_BM + 999999;
	local range = 0
    if range ~= 0 then
        local list, Cnt = SelectObjectByFaction(self, range, 'Monster')
        local i
        for i = 1 , Cnt do
            if IsDead(list[i]) == 0 then
--            PlayEffect(list[i], 'F_wizard_fireball_hit_explosion', 2)
            TakeDamage(self, list[i], "indunTheEnd", 999999, "Melee", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
            end
        end
    elseif range == 0 then
        local list, Cnt = SelectObjectByFaction(self, 500, 'Monster')
        local i
        for i = 1 , Cnt do
            if IsDead(list[i]) == 0 then
--            PlayEffect(list[i], 'F_wizard_fireball_hit_explosion', 2)
            TakeDamage(self, list[i], "indunTheEnd", 99999, "Melee", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
            end
        end
    end
	self.PATK_BM = self.PATK_BM - 999999;
	self.MATK_BM = self.MATK_BM - 999999;
	self.HR_BM = self.HR_BM - 999999;
    return 1
end

function SCR_BUFF_LEAVE_GUILD_RAID_FOLLOWER(self, buff, arg1, arg2, RemainTime, ret, over)
end

--GUILD_RAID_FOLLOWER_RE
function SCR_BUFF_ENTER_GUILD_RAID_FOLLOWER_RE(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_GUILD_RAID_FOLLOWER_RE(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, 'GUILD_RAID_FOLLOWER') == 'NO' then
        AddBuff(self, self, 'GUILD_RAID_FOLLOWER', 1, 0, 60000, 1)
    end
    return 1
end

function SCR_BUFF_LEAVE_GUILD_RAID_FOLLOWER_RE(self, buff, arg1, arg2, RemainTime, ret, over)
end


--TEST_CALL_PARTYLIST
function SCR_BUFF_ENTER_TEST_CALL_PARTYLIST(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_TEST_CALL_PARTYLIST(self, buff, arg1, arg2, RemainTime, ret, over)

    local list, cnt = GetLayerPCList(self);
    if cnt > 0 then
        local i
        local x, y, z = GetPos(self)
        for i = 1, cnt do
            if IsSameActor(self, list[i]) == 'NO' then
                if GetDistance(self, list[i]) > 80 then
                    SetPos(list[i], x, y, z)
                end
            end
        end
    end
	
    return 1
end

function SCR_BUFF_LEAVE_TEST_CALL_PARTYLIST(self, buff, arg1, arg2, RemainTime, ret, over)
end

function TEST_GR_SKILL(self)
    local x, y, z = GetPos(self)
    local mon = {}
    local i
    local angle
    for i = 1, 16 do
        angle = i*20
--        if angle >= 180 then
--            angle = angle*-1
--        end
        mon[i] = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, angle, 'Neutral', self.Lv, TEST_GR_SKILL_OBJ_RUN);
    end
--    SetOwner(mon, self)
--    AddBuff(self, mon, 'GUILD_BOSS_EDGE_SKL', 1, 0, 0, 1)
----    local x, y, z = GetActorByDirAnglePos(self, -90, 10)
----    print(x, y, z)
end

function TEST_GR_SKILL_OBJ_RUN(mon)
    mon.SimpleAI = 'TEST_GR_SKILL_OBJ'
    mon.Name = 'TEST'
    mon.FIXMSPD_BM = 25
end

function TEST_GR_SKILL_OBJ(self)
--    local _pc = GetOwner(self)
--    if _pc ~= nil then
--        LookAt(self, _pc)
--    end
    local zoneID = GetZoneInstID(self)
                local x1, y1, z1 = GetPos(self)
    local x, y, z = GetActorByDirAnglePos(self, 0, 10)
    local list, cnt = SelectObjectByFaction(self, 20, 'Monster')
    if cnt == 0 then
        if IsValidPos(zoneID, x, y, z) == 'YES' then
            if y > y1 then
                DetachEffect(self, 'F_fire023_loop')
                Kill(self)
            else
                MoveEx(self, x, y, z, 1)
            end
        else
            DetachEffect(self, 'F_fire023_loop')
            Kill(self)
        end
    else
        local i
        for i = 1 , cnt do
            Dead(list[i])
            
            PlayEffect(self, 'F_buff_explosion_burst', 1)
            DetachEffect(self, 'F_fire023_loop')
            if i == cnt then
                Kill(self)
            end
        end
    end
end





--GUILD_BOSS_EDGE_SKL
function SCR_BUFF_ENTER_GUILD_BOSS_EDGE_SKL(self, buff, arg1, arg2, RemainTime, ret, over)
    print("IN")
end

function SCR_BUFF_UPDATE_GUILD_BOSS_EDGE_SKL(self, buff, arg1, arg2, RemainTime, ret, over)
    local angle = GetDirectionByAngle(self)
    SetTacticsArgFloat(self, angle)
    if self.NumArg4 < 8 then
        self.NumArg4 = self.NumArg4 + 1
        local x, y, z = GetPos(self)
        
        local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, angle, 'Neutral', self.Lv, GUILD_BOSS_EDGE_SKL_RUN);
        AddScpObjectList(mon, "test_angle", self)
        AddScpObjectList(self, "test_angle", mon)
        
    end
    
    return 1
end

function SCR_BUFF_LEAVE_GUILD_BOSS_EDGE_SKL(self, buff, arg1, arg2, RemainTime, ret, over)
end


function GUILD_BOSS_EDGE_SKL_RUN(mon)
    mon.SimpleAI = 'GUILD_BOSS_EDGE_SKL'
    mon.FIXMSPD_BM = 60
end

function GUILD_BOSS_EDGE_SKL(self)
    local owner = GetScpObjectList(self, 'test_angle')
    if #owner ~= 0 then
        local angle = GetTacticsArgFloat(owner[1])
        print(angle)
        local zoneID = GetZoneInstID(self)
        local x, y, z = GetActorByDirAnglePos(self, angle, 50)
        local list, cnt = SelectObjectByFaction(self, 20, 'Monster')
        if cnt == 0 then
            if IsValidPos(zoneID, x, y, z) == 'YES' then
                MoveEx(self, x, y, z, 1)
            else
                DetachEffect(self, 'F_fire023_loop')
                Kill(self)
            end
        else
            local i
            for i = 1 , cnt do
                Dead(list[i])
                PlayEffect(self, 'F_buff_explosion_burst', 1)
                DetachEffect(self, 'F_fire023_loop')
                if i == cnt then
                    Kill(self)
                end
            end
        end
    end
end



function CHANGE_GUILD_CHECKER(self)
    local ssn = GetSessionObject(self, 'SSN_CHANGE_GUILD')
    if ssn == nil then
        CreateSessionObject(self, 'SSN_CHANGE_GUILD', 1)
        print("CREATE")
    else
        DestroySessionObject(self, ssn)
        print("Destroy")
    end
end

function SCR_CREATE_SSN_CHANGE_GUILD(self, sObj)
--	SetTimeSessionObject(self, sObj, 1, 1000, "SSN_CHANGE_GUILD_RIN")
	RegisterHookMsg(self, sObj, "SetLayer", "SSN_CHANGE_GUILD_LAYER", "NO");
end

function SCR_REENTER_SSN_CHANGE_GUILD(self, sObj)
--	SetTimeSessionObject(self, sObj, 1, 1000, "SSN_CHANGE_GUILD_RIN")
	RegisterHookMsg(self, sObj, "SetLayer", "SSN_CHANGE_GUILD_LAYER", "NO");
end

function SCR_DESTROY_SSN_CHANGE_GUILD(self, sObj)
end


function SSN_CHANGE_GUILD_LAYER(self, sObj, msg, argObj, argStr, argNum)
    Chat(self, 'Layer Change', 5)
end

function SSN_CHANGE_GUILD_RIN(self, sObj)
--    print("INNNNN")
end

--function TEST_BUFF_TEST(self)
--    local get_item = GetInvItemList(pc);
--    local itemType = {}
--    local item_cnt = {}
--    for i = 1, #get_item do
--        itemType[i] = GetClassList("Buff").ClassID;
--        item_cnt[i] = GetInvItemCountByType(pc, itemType[i]);
--        if item_cnt[i] == 0 then
--            RunScript('GIVE_ITEM_TX', pc, 'Book11', 1, "BOOK")
--            break
--        end
--    end
--end





function MODPAT_GTOWER_TEST(pc)
--    REQ_MOVE_TO_INDUN(pc, "Indun_Remains2", 1);
    REQ_MOVE_TO_INDUN(pc, "M_GTOWER_1", 1);
end

function RESET_EARTH_TOWER_COUNT(pc)
	local etc = GetETCObject(pc);
    local tx = TxBegin(pc);	
	TxSetIESProp(tx, etc, "InDunCountType_400", 0);
	local ret = TxCommit(tx);
end




function TEST_G_TOWER_GO1(self)
    MoveZone(self, 'mission_groundtower_1', 3175, 270, -5998)
end


function TEST_GT_CALL_MEMBER(self)
    local list, cnt = GetLayerPCList(self)
    local x, y, z = GetPos(self)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if IsSameActor(self, list[i]) == 'NO' then
                SetPos(list[i], x, y+5, z)
            end
        end
    end
    
end


function TEST_WARP_GT_1(self, stage)
    stage = tonumber(stage)
    if stage == nil or stage == 0 then
        stage = 3
    end
    if stage == 1 then
        RunScript("TEST_WARP_GT_START_1", self, 3121, 146, -4792, 1)
    elseif stage == 2 then
        RunScript("TEST_WARP_GT_START_1",self, 3278, 146, -2520, 2)
    elseif stage == 3 then
        RunScript("TEST_WARP_GT_START_1",self, 3195, 147, -277, 3)
    elseif stage == 4 then
        RunScript("TEST_WARP_GT_START_1",self,  3182, 146, 1733, 4) 
    elseif stage == 5 then
        RunScript("TEST_WARP_GT_START_1",self, 3069, 146, 3573, 5)
    elseif stage == 6 then
        RunScript("TEST_WARP_GT_START_1",self, 437, 150, -4930, 6)
    elseif stage == 7 then
        RunScript("TEST_WARP_GT_START_1",self, 380, 146, -2655, 7)
    elseif stage == 8 then
        RunScript("TEST_WARP_GT_START_1",self, 377, 146, -349, 8)
    elseif stage == 9 then
        RunScript("TEST_WARP_GT_START_1",self, 495, 146, 1662, 9)
    elseif stage == 10 then
        RunScript("TEST_WARP_GT_START_1",self, 466, 146, 3611, 10)
    elseif stage == 11 then
        RunScript("TEST_WARP_GT_START_1",self, -2342, 147, -5097, 11)
    elseif stage == 12 then
        RunScript("TEST_WARP_GT_START_1",self, -2345, 147, -2594, 12)
    elseif stage == 13 then
        RunScript("TEST_WARP_GT_START_1",self, -2474, 147, -371, 13)
    elseif stage == 14 then
        RunScript("TEST_WARP_GT_START_1",self, -2299, 147, 1615, 14)
    elseif stage == 15 then
        RunScript("TEST_WARP_GT_START_1",self, -2111, 147, 3579, 15)
    elseif stage == 16 then
        RunScript("TEST_WARP_GT_START_1",self, -4913, 147, -4887, 16)
    elseif stage == 17 then
        RunScript("TEST_WARP_GT_START_1",self, -4990, 147, -2641, 17)
    elseif stage == 18 then
        RunScript("TEST_WARP_GT_START_1",self, -4567, 147, -384, 18)
    elseif stage == 19 then
        RunScript("TEST_WARP_GT_START_1",self, -4656, 147, 1606, 19)
    elseif stage == 20 then
        RunScript("TEST_WARP_GT_START_1", self, -4536, 147, 3603, 20)
    end
end

function TEST_WARP_GT_START_1(self, x, y, z, stage)
    local list, cnt = GetLayerPCList(self)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            SetPos(list[i], x, y, z)
        end
    end
    sleep(2000)
    if stage == 41 then
        PlayDirection(self, 'DIR_GT2_ZEMINA_1');
    else
        RunMGame(self, 'M_GTOWER_STAGE_'..stage)
    end
    
end



function TEST_G_TOWER_GO2(self)
    MoveZone(self, 'mission_groundtower_2', 5459, 239, -6387)
end

function TEST_GT2_INIT_RUN(self, name)
    RunMGame(self, 'M_GT2_INIT')
end

function anwojefninoiwaenf(self)
    local val = GetMGameValueByMGameName(self, 'M_GTOWER2_STAGE_36', 'MGTSTAGE36')
    print(val)
end

function TEST_WARP_GT_2(self, stage)
    
    stage = tonumber(stage)
    if stage == nil or stage == 0 then
        stage = 41
    end
    print(stage)
    if stage == 21 then
        RunScript("TEST_WARP_GT_START_2", self, 5639, 145, -4444, stage)
    elseif stage == 22 then
        RunScript("TEST_WARP_GT_START_2",self, 5547, 146, -2374, stage)
    elseif stage == 23 then
        RunScript("TEST_WARP_GT_START_2",self, 5546, 147, -207, stage)
    elseif stage == 24 then
        RunScript("TEST_WARP_GT_START_2",self, 5460, 147, 2074, stage) 
    elseif stage == 25 then
        RunScript("TEST_WARP_GT_START_2",self, 5191, 146, 4325, stage)
    elseif stage == 26 then
        RunScript("TEST_WARP_GT_START_2",self, 3076, 150, -4652, stage)
    elseif stage == 27 then
        RunScript("TEST_WARP_GT_START_2",self, 2816, 146, -2385, stage)
    elseif stage == 28 then
        RunScript("TEST_WARP_GT_START_2", self, 2807, 146, -300, stage)
    elseif stage == 29 then
        RunScript("TEST_WARP_GT_START_2",self, 2709, 146, 1858, stage)
    elseif stage == 30 then
        RunScript("TEST_WARP_GT_START_2",self, 2585, 146, 4200, stage)
    elseif stage == 31 then
        RunScript("TEST_WARP_GT_START_2",self, 345, 147, -4985, stage)
    elseif stage == 32 then
        RunScript("TEST_WARP_GT_START_2",self, 318, 147, -2692, stage)
    elseif stage == 33 then
        RunScript("TEST_WARP_GT_START_2",self, 116, 147, -398, stage)
    elseif stage == 34 then
        RunScript("TEST_WARP_GT_START_2",self, 177, 147, 1984, stage)
    elseif stage == 35 then
        RunScript("TEST_WARP_GT_START_2",self, 154, 147, 4107, stage)
    elseif stage == 36 then
        RunScript("TEST_WARP_GT_START_2",self, -2449, 147, -4991, stage)
    elseif stage == 37 then
        RunScript("TEST_WARP_GT_START_2",self, -2495, 147, -2697, stage)
    elseif stage == 38 then
        RunScript("TEST_WARP_GT_START_2",self, -2602, 147, -626, stage)
    elseif stage == 39 then
        RunScript("TEST_WARP_GT_START_2",self, -2633, 147, 1692, stage)
    elseif stage == 40 then
        RunScript("TEST_WARP_GT_START_2", self, -2753, 147, 3907, stage)
    elseif stage == 41 then
        RunScript("TEST_WARP_GT_START_2", self, -5370, 147, 6533, stage)
    end
end



function TEST_WARP_GT_START_2(self, x, y, z, stage)
    local list, cnt = GetLayerPCList(self)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            SetPos(list[i], x, y, z)
        end
    end
    sleep(2000)
    if stage == 41 then
        RunMGame(self, 'M_GTOWER2_ZEMINA_ROOM')
    else
        RunMGame(self, 'M_GTOWER2_STAGE_'..stage)
    end
    
end




function TEST_GT_ITEM_CK_PRE(self)
    local item_list = 
    {'misc_earthTower5_toll',
    'misc_earthTower10_toll',
    'misc_earthTower15_toll',
    'misc_earthTower20_toll'}
    
    local sel_list = 
    {
    
    }
    
    --need item cnt
    local floor_5 = 10
    local floor_10 = 10
    local floor_15 = 10
    local floor_20 = 10

    
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
	        elseif item_list[i] == 'misc_earthTower20_toll' then
	            if item_cnt >= floor_20 then
	                floor_value[#floor_value+1] = floor_20
	                item_ies[#item_ies+1] = item_cls
                    classname[#classname+1] = item_list[i]
                    item_name[#item_name+1] = ScpArgMsg("GT_TEST_CAPTION_4")
                end
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


function TEST_GT_ITEM_CNT_TEST(self)
    
    if IS_GT_PARTYLEADER(self) ~= 1 then
        print("Not Leader")
        return
    end
    local classname, item_name, floor_value, item_ies = TEST_GT_ITEM_CK_PRE(self)
    local select = SCR_SEL_LIST(self, item_name, 'MODPAT_ZONEMOVE', 1)
    local item_cls = item_ies[select]
    local sel_floor = classname[select]
    local sel_floor_value = floor_value[select]
    if sel_floor == 'misc_earthTower5_toll' then
        TEST_GT_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 6, 'GT1_TO_6')
        print("Move To Floor 6th")
    elseif sel_floor == 'misc_earthTower10_toll' then
        TEST_GT_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 11, 'GT1_TO_11')
        print("Move To Floor 11th")
    elseif sel_floor == 'misc_earthTower15_toll' then
        TEST_GT_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 16, 'GT1_TO_16')
        print("Move To Floor 16th")
    elseif sel_floor == 'misc_earthTower20_toll' then
        TEST_GT_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, 21, 'GT1_TO_GT2')
        print("Move To Solmiki group")
    end
end

function TEST_GT_TAKE_ITEM(self, sel_floor, sel_floor_value, item_cls, moveto, giveway)
    local select = ShowSelDlg(self, 0, 'GT_LUTHA_NPC_TOLL_MANAGER\\'..ScpArgMsg("GT_TOLL_MANAGER_1", "FLOOR", moveto, "ITEM", item_cls.Name, "VALUE", sel_floor_value), ScpArgMsg("CHATHEDRAL54_book_list_04"), ScpArgMsg("Auto_KeuMan_DunDa"))
    if select == 1 then
        if moveto == 6 then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', 437, 150, -4930, 0, moveto, 5)
            GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway)
        elseif moveto == 11 then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', -2342, 147, -5097, 0, moveto, 5)
            GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway)
        elseif moveto == 16 then
            SCR_GT_SETPOS_FADEOUT_TOLL(self, 'mission_groundtower_1', -4913, 147, -4887, 0, moveto, 5)
            GIVE_TAKE_ITEM_TX(self, nil, sel_floor.."/"..sel_floor_value, giveway)
        elseif moveto == 21 then
            SCR_GT2_SETPOS_FADEOUT_TOLL_RUN(self, 'mission_groundtower_2', 5770, 147, -6478, 0, moveto, 5)
        end
    elseif select == 2 then
        return
    end
end


function TEST_MGMAE_RUN(self, name)
--    if name ~= nil then
--        print("GG")
--        RunMGame(self, 'M_GTOWER_INIT')
--    end
    RunMGame(self, 'TEST_STAGE_CRASH')
end



function MAKE_TESTNPC_GT_LUTHA_NPC(self)
    local x, y, z = GetPos(self)
    local npc = CREATE_MONSTER_EX(self, 'npc_kupole_3', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, MAKE_TESTNPC_GT_LUTHA_NPC_RUN);
end


function MAKE_TESTNPC_GT_LUTHA_NPC_RUN(mon)
    mon.Name = 'Kupole Lutha'
    mon.Dialog = 'GT_LUTHA_NPC'
end

function TEST_GT34_FROSTBITE_DEBUFF(self)
    if IsBuffApplied(self, 'GT34_CRYSTALLIZATION_DEBUFF') == 'NO' then
        AddBuff(self, self, 'GT34_CRYSTALLIZATION_DEBUFF', 100, 0, 30000, 1)
    else
        RemoveBuff(self, 'GT34_CRYSTALLIZATION_DEBUFF')
    end
end


function TEST_GT34_FROSTBITE_DEBUFF2(self)
    if IsBuffApplied(self, 'GT34_FROSTBITE_DEBUFF') == 'YES' then
        local _over = GetBuffOver(self, 'GT34_FROSTBITE_DEBUFF')
        if _over > 0 then
            AddBuff(self, self, 'GT34_FROSTBITE_DEBUFF', 100, 0, 30000, -1)
        end
    end

end


function TEST_UI_GT2_TEST(self)
--    ObjectColorBlend(self, 155, 255, 155, 255, 1, 1)
    EARTH_TOWER_FLOOR_UI_OPEN_41(self, ScpArgMsg('GT_SETPOS_FADEOUT_41'), 5, 0)
end





function nne38nfoan9fwfwefwef(self)
    AddBuff(self, self, 'GT24_POISON_DEBUFF', 1, 0, 10000, 1)
end



function TEST_GT_ZOBJ_RUN_1(self)
--    AddMGameListObj(ud, objList[i]);
--    local zoneID = GetZoneInstID(self)
--    local zobj = GetLayerObject(zoneID, GetLayer(self))
--    SetExProp(zobj, "TEST", 1);
----    SetExArgObject(zobj, 'TEST', self)
--    local propList = GetExPropList(zobj);


    print(GetPcAIDStr(self), GetPcCIDStr(self), GetTeamID(self), GetZoneInstID(self))
end


function TEST_GT_ZOBJ_RUN_2(self)
    local zoneID = GetZoneInstID(self)
    local zobj = GetLayerObject(zoneID, GetLayer(self))
    SetExProp(zone_Obj, 'FTOWER611_TYPE_AW_01_CK', 0)
end


function TKQB1(self)
    FlyMath(self, 0, 1, 1);
    print("QQQ")
    local fly = 80
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Onion', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, TEST_KQ_GIMMICK_FLYING_BOX_1_RUN);
    local mon1 = CREATE_MONSTER_EX(self, 'Hidden_pillar', x, y, z+50, 0, 'Neutral', 1, FE_UNDERF591_TYPEA_PILLAR_AI_RUN)
    local mon2 = CREATE_MONSTER_EX(self, 'Hidden_pillar', x, y, z-50, 0, 'Neutral', 1, FE_UNDERF591_TYPEA_PILLAR_AI_RUN)
    FlyMath(mon, fly, 1, 1);
    FlyMath(mon2, fly+10, 1, 1);
    SetTacticsArgFloat(mon, y+fly);
end

function TEST_KQ_GIMMICK_FLYING_BOX_1_RUN(mon)
    mon.BTree = 'None'
    mon.Tactics = 'None'
    mon.Dialog = 'TEST_KQ_GIMMICK'
end


function SCR_TEST_KQ_GIMMICK_DIALOG(self, pc)
    local y = GetTacticsArgFloat(self)
    local x1, y1, z1 = GetPos(pc)

    local final = y-y1
    
    if final <= 0 then
        final = final*-1
    end
    print(y, y1)
    if final > 10 then
        print("NO")
    else
        print("YES")
    end
end

function TEST_HOVERAROUND_TEST(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, TEST_HOVERAROUND_TAC_RUN)
    AddScpObjectList(self, 'TEST_HOVERAROUND_TEST', mon)
    print("GGG")
--    AttachEffect(mon, 'F_light055_blue', 5, 'MID')
--    HoverPosition(mon, x, y, z, 50, 0.5, "HOVERING_LOOP"); 
--    HoverAround(mon, self, 25, 10, 10, 2);
end

function TEST_HOVERAROUND_TAC_RUN(mon)
    mon.Tactics = 'TEST_HOVERAROUND_TAC'
end

function TEST_HOVERAROUND_TEST_1(self)
    local list_mon = GetScpObjectList(self, 'TEST_HOVERAROUND_TEST')
    if #list_mon > 0 then
        local list, cnt = SelectObject(list_mon[1], 200, 'ALL')
        print(cnt)
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if IsSameActor(self, list[i]) == "NO" then
                    HoverAround(list_mon[1], list[i], 25, 10, 10, 2);
                    break
                end
            end
        end
    end
end




function SCR_TEST_HOVERAROUND_TAC_TS_BORN_ENTER(self)
    AttachEffect(self, 'F_light055_blue', 5, 'MID')
end

function SCR_TEST_HOVERAROUND_TAC_TS_BORN_UPDATE(self)

    local mon = GetExArgObject(self, 'HOVERAROUND_TAC')

    if mon == nil then
    local list, cnt = SelectObject(self, 10, 'ALL')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    if IsSameActor(mon, list[i]) == 'NO' then
                        SetExArgObject(self, "HOVERAROUND_TAC", list[i])
                        HoverAround(self, list[i], 15, 10, 10, 2);
                    end
                    break
                end
            end
        end
    else
        local list, cnt = SelectObject(self, 100, 'ALL')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if list[i].ClassName ~= 'PC' then
                    print(list[i])
                    SetExArgObject(self, "HOVERAROUND_TAC", list[i])
                    HoverAround(self, list[i], 15, 10, 10, 2);
                    break
                end
            end
        end
    end
    HOLD_MON_SCP(self, 500);
end


function SCR_TEST_HOVERAROUND_TAC_TS_BORN_LEAVE(self)
end

function SCR_TEST_HOVERAROUND_TAC_TS_DEAD_ENTER(self)
end

function SCR_TEST_HOVERAROUND_TAC_TS_DEAD_UPDATE(self)
end

function SCR_TEST_HOVERAROUND_TAC_TS_DEAD_LEAVE(self)
end




function wfiawnfiaweifwaifwienf(self)
    local list, cnt = SelectObjectByFaction(self, 100, 'Monster')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                
                local mob = self.MHP - 1
                print(mob, list[i].ClassName)
                Heal(list[i], -mob, 0)
            end
        end
    end
end


function TEST_GT39_TEST_1(self)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x+15, y, z, GetDirectionByAngle(self), 'Monster', 1, GT39_MAKE_ZOMBIE_RUN);
    AddScpObjectList(mon, 'GT39_MAKE_ZOMBIE_ARG', self)
end

function BYPAD_CHECK_TEST(self)
local mon_list = {
                'crystal_vakarine ',
                'ET_banshee_purple',
                'ET_Big_Cockatries',
                'ET_boss_Gosarius',
                'ET_boss_Pinscher',
                'ET_boss_Pyroego',
                'ET_boss_Turtai',
                'ET_Canceril_minimal',
                'ET_Elet',
                'ET_Fire_Dragon',
                'ET_Flak',
                'ET_Flamag',
                'ET_Flamil',
                'ET_Flamme_archer',
                'ET_Flamme_mage',
                'ET_Flamme_priest',
                'ET_Foculus_minimal',
                'ET_Glackuman_minimal',
                'ET_Harugal',
                'ET_hogma_sorcerer',
                'ET_hogma_warrior',
                'ET_hohen_barkle',
                'ET_Hohen_gulak',
                'ET_Hohen_mage',
                'ET_Hohen_orben',
                'ET_Hohen_ritter',
                'ET_Kowak_orange',
                'ET_LapeArcher',
                'ET_Lapeman',
                'ET_Lapemiter',
                'ET_Lapezard',
                'ET_Lapfighter',
                'ET_Lapflammer',
                'ET_Link_stone',
                'ET_maggotegg_green',
                'ET_Malstatue',
                'ET_merog_wizzard_orange',
                'ET_merog_wogu_orange',
                'ET_mon_goat_totem',
                'ET_Mouse',
                'ET_necrovanter_minimal',
                'ET_NetherBovine_minlmal',
                'ET_NightMaiden_bow',
                'ET_Npanto_sword',
                'ET_Pagclamper',
                'ET_PagDoper',
                'ET_PagNanny',
                'ET_PagNurse',
                'ET_PagSawyer',
                'ET_Pagshearer',
                'ET_Pandroceum',
                'ET_Prisoncutter_minimal',
                'ET_Prisonfighter',
                'ET_PrisonOfficer',
                'ET_Rambandgad_red_minimal',
                'ET_Rocksodon_minimal',
                'ET_Silva_griffin_minimal',
                'ET_Slave',
                'ET_Spector_Gh',
                'ET_Spector_gh_red',
                'ET_Spector_m_minimal',
                'ET_spell_suppressors',
                'ET_velffigy',
                'ET_Velniamonkey_minimal',
                'ET_WatchDog',
                'ET_Wolf_statue',
                'ET_wolf_statue_mage',
                'gid_star_stone_01',
                'star_sphere_01'
                }

    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x+15, y, z, GetDirectionByAngle(self), 'Monster', 1, GT39_MAKE_ZOMBIE_RUN);
    AddScpObjectList(mon, 'GT39_MAKE_ZOMBIE_ARG', self)

end


function TEST_GEVT_MOVE_RUN(self, classname)
    if classname == 0 or classname == nil then
        classname = 'GR_CHAPEL_1'
    end

    local cls = GetClass('GuildEvent', classname)
    local mapcls = cls.StartMap
    local pos = GetClass('Map', mapcls)
    print("Move to "..pos.Name.." // Guild Event")
    MoveZone(self, mapcls, pos.DefGenX, pos.DefGenY, pos.DefGenZ)
end

function TEST_GEVT_RAID_TEST(self)
    RunScript('TEST_GEVT_RAID_RUN', self)
end

function TEST_GEVT_RAID_RUN(self)
    SetLayer(self, GetNewLayer(self))
    sleep(1000)
    RunMGame(self, 'GR_CHAPEL_1_S7_RN_MINI')
end

function TEST_SPIN_GIMMICK(self)
--    AttachEffect(self, 'I_smoke011_loop', 2)
    DetachEffect(self, 'I_smoke011_loop')
    PlayAnim(self, 'HIT', 1)
    SpinObject(self, 0, 01, 0.1, 1)
end



function TEST_GUILD_M_CASTLE_RUN(self)
    RunMGame(self, 'GR_CHAPEL_1_S7_RN_MINI')
end


function TEST_MODPAT_CK_INDUN_CNT(self)
    local cls = GetClass('Indun', 'M_GTOWER_1')
    local indun_cnt = cls.PlayPerReset
    
    local list, cnt = GetLayerPCList(self)
    if cnt > 0 then
        local _pc = list[1]
        
--        local P_list, P_cnt = GET_PARTY_ACTOR(_pc, 0)
--        if P_cnt > 0 then
--            local i
--            for i = 1, 
--        end

    end
    print(cnt)
    
    if IsPremiumState(self, ITEM_TOKEN) == 1 then
        indun_cnt = indun_cnt + cls.PlayPerReset_Token
    end
    if IsPremiumState(self, NEXON_PC) == 1 then
        indun_cnt = indun_cnt  + cls.PlayPerReset_NexonPC
    end
	local etcObj = GetETCObject(self);
	local propname = 'InDunCountType_400'
	local stack_cnt = etcObj[propname]
    
    print(indun_cnt..' / '..stack_cnt)
end



function TEST_G_EVENT_TICKET_RESET(pc)
	local guildID = GetGuildID(pc);
	local partyObj, partyName = GetPartyObjByIESID(PARTY_GUILD, guildID);
    RESET_GUILD_TICKET(pc, partyObj)
end


function TEST_SETPOS_GELE_MISSION(self)
    MoveZone(self, 'f_gele_57_4', 36, 0, -565)
end



function TEST_SEQUAWEO_EEFAEF(self)
	local target = GetNearTopHateEnemy(self);
	if target == nil then
		return 0;
	end
	if GetDistance(self, target) > 200 then
	    local xt, yt, zt = GetPos(target)
	    local xm, ym, zm = GetPos(self)
	    local height = math.abs(ym - yt)
	    print(height)
	end

end



function TEST_GET_RNDBOX_1(self)
--    SCR_KEY_QUEST_PRECHECK(self, 1)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
	local list, cnt = GetLayerMonList(zoneID, layer);
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'TreasureBox_KQ1' then
                local x, y, z = GetPos(list[i])
                SetPos(self, x, y, z)
            end
        end
    end
end


function MY_TEST_FUNC_RUN(self)
    local pc_layer = GetLayer(self)
    local obj = GetLayerObjectggg(GetZoneInstID(self), pc_layer);
    print(obj.EventName)
end


function TEST_CASTLE_01_CLEAR_RUN(self)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerMonList(zoneID, layer)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'GMB_boss_werewolf' or list[i].ClassName == 'GMB_boss_glutton' or list[i].ClassName == 'GMB_boss_Mothstem' then
                local x, y, z = GetPos(list[i])
                SetPos(self, x, y, z)
                return
            else
                SetPos(self, 67, 187, -467)
            end
        end
    end
end



function TEST_GUILD_LVUP_RUN(pc, guildLv)
    if guildLv > 20 then
        guildLv = 20
    end
    if guildLv == nil then
        guildLv = 20
    end

	local tx = TxBegin(pc);
	TxSetPartyProp(tx, PARTY_GUILD, "Level", guildLv);
   	local ret = TxCommit(tx);

	if ret == "SUCCESS" then
		SendSysMsg(pc, "GuildExpUpSuccessByItem");
	end
	
	
end


function TEST_GUILD_EVENT_ERROR_FIX_RUN(pc)
    ChangePartyProp(pc, PARTY_GUILD, "RewardBidState", 0)
end




function GET_GT3_CK_BUFF(self)
    local list, cnt = SelectObjectByClassName(self, 100, 'ET_mon_goat_totem')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            local buff = GetBuffByName(list[i], 'SoulDuel_DEF')
            if buff ~= nil then
                print(buff.Lv)
            else
                print("NO")
            end
            return
        end
    end
end


function TEST_MOVETO_TGT_TEST_RUN(self)
	local zoneID = GetZoneInstID(self);
	local layer = GetLayer(self);
    local list, cnt = GetLayerMonList(zoneID, layer)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if list[i].ClassName == 'KQ_poison_crystal_01' then
                local x, y, z = GetPos(list[i])
                SetPos(self, x, y, z)
                return
            end
        end
    end
end



function EFF_TIME_TEST_RUN(self)
    PlayEffect(self, 'I_light013_spark_blue', 10, 1, 'TOP', 1)
end