--BRAKEN_42_1_MEDENA--
function SCR_BRAKEN_42_1_MEDENA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONECAVE_52_1_MEDENA--
function SCR_LIMESTONECAVE_52_1_MEDENA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONECAVE_52_1_MEDENA_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONECAVE_52_1_TRIA--
function SCR_LIMESTONECAVE_52_1_TRIA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONECAVE_52_1_MEDENA_AI--
function SCR_LIMESTONECAVE_52_1_MEDENA_AI_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONE_52_1_MQ_3_PROG--
function SCR_LIMESTONE_52_1_MQ_3_PROG_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONE_52_1_MAGIC--
function SCR_LIMESTONE_52_1_MAGIC_ENTER(self, pc)
end

function SCR_LIMESTONE_52_1_MAGIC_ON_ENTER(self, pc)
end

function SCR_LIMESTONE_52_1_ANTIEVIL_DIALOG(self, pc)
    local ht3_result1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_10')
    if ht3_result1 == "COMPLETE" then
        ShowBalloonText(pc, 'HT3_LIMESTONE_52_ANTIEVIL_BML0'..IMCRandom(1, 4), 6)
    else
    ShowBalloonText(pc, 'LIMESTONE_52_2_WARNING', 6)
    end
end

function LIMESTONECAVE_HIDE_FUNC_RUN(self)
    RunScript('LIMESTONECAVE_HIDE_FUNC', self)
end

function LIMESTONECAVE_HIDE_FUNC(self)
    UIOpenToPC(self,'fullblack',1)
    sleep(2000)
    UIOpenToPC(self,'fullblack',0)
end

function LIMESTONE_52_1_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    local result = {}
    local list = {}
    local i
    for i = 2, 10 do
        result[i] = SCR_QUEST_CHECK(self, 'LIMESTONE_52_1_MQ_'..i)
        if i == 2 then
            if result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_1_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_1_MQ_2_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        else
            if result[i] ~= 'COMPLETE' and result[i] == 'POSSIBLE' or result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_1_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_1_MQ_2_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        end
    end
end




function LIMESTONE_52_1_MQ_2_RUNNPC(self)
    local pc_zone = GetZoneName(self);
    if pc_zone == 'd_limestonecave_52_1' then
        local follower = GetScpObjectList(self, 'LIMESTONE_52_1_MQ_2')
        if #follower == 0 then
            local x, y, z = -761, 0, -603
            local mon = CREATE_MONSTER_EX(self, 'mon_kupole_4', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, LIMESTONE_52_1_MQ_2_SET);
            LookAt(mon, self)
            mon.RunMSPD = 100
            SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'LIMESTONE_52_1_MQ_2', 2);
            AddScpObjectList(self, 'LIMESTONE_52_1_MQ_2', mon)
            SetExArgObject(mon, 'PLAYER_01', self)
            EnableAIOutOfPC(mon)
        end
    end
end

function LIMESTONE_52_1_MQ_2_SET(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("LIMESTONECAVE_52_1_MEDENA_NAME");
	mon.SimpleAI = 'LIMESTONE_52_1_MQ_2_AI'
	mon.Dialog = 'LIMESTONECAVE_52_1_MEDENA_AI'
end


function LIMESTONE_52_1_MQ_2_RUN(self)
    local PC_Owner = GetOwner(self)
    if PC_Owner == nil then
        Kill(self)
    end
end

function SCR_LIMSTONE_52_1_CRYSTAL_PIECE_DIALOG(self, pc)
    local check_Q1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_MQ_4')
    if check_Q1 == 'PROGRESS' then
        local action_r = DOTIMEACTION_R(pc, ScpArgMsg('CORAL_35_2_SQ_2_TAKE_CRYSTAL'), 'SITGROPE_LOOP', 2)
        if action_r == 1 then
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_1_MQ_4', nil, nil, nil,'LIMESTONE_52_1_MQ_4_CRYSTAL/1')
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('LIMESTONE_52_1_MQ_4_CRYSTAL_GET'), 5)
            Kill(self)
        end
    end
end

function SCR_LIMESTONE_52_1_MQ_6_CLEAR_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_MQ_6')
    if result == 'PROGRESS' then
        local itemCnt = GetInvItemCount(pc, 'LIMESTONE_52_1_MQ_5_EVILCORE')
        if itemCnt > 0 then
            PlayAnimLocal(self, pc, 'READY', 1)
            local itemCnt2 = GetInvItemCount(pc, 'LIMESTONE_52_1_MQ_6_CLEARCORE')
            if itemCnt2 < 5 then
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("LIMESTONE_52_1_MQ_6_MSG01"), 'MAKING', 2);
                if result2 == 1 then
                    RunScript('GIVE_TAKE_ITEM_TX', pc, 'LIMESTONE_52_1_MQ_6_CLEARCORE/1', 'LIMESTONE_52_1_MQ_5_EVILCORE/1', "Quest")
                    local skill = GetNormalSkill(self);
                    ForceDamage(self, skill, pc, self, 0, 'MOTION', 'BLOW', 'I_force036_green1', 1, 'arrow_cast', 'I_force071_light_green', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                    PlayEffectLocal(self, pc, 'I_force071_light_green', 4, 0, 'BOT')
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("LIMESTONE_52_1_MQ_6_CLEAN_GET"), 6)
                else
                    PlayAnimLocal(self, pc, 'OFF', 1)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_1_MQ_6_CLEAN_ENOUGH"), 6)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("LIMESTONE_52_1_MQ_6_CORE_NONE"), 6)
        end
        PlayAnimLocal(self, pc, 'OFF', 1)
    else
        local result2 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_1_SQ_2')
        if result2 == 'PROGRESS' then
            PlayAnimLocal(self, pc, 'READY', 1)
            local itemCnt = GetInvItemCount(pc, 'LIMESTONE_52_1_SQ_1_NECK')
            if itemCnt > 0 then
                local itemCnt2 = GetInvItemCount(pc, 'LIMESTONE_52_1_SQ_1_NECK_1')
                if itemCnt2 < 10 then
                    local result2 = DOTIMEACTION_R(pc, ScpArgMsg("LIMESTONE_52_1_SQ_2_MSG01"), 'MAKING', 2);
                    if result2 == 1 then
                        RunScript('GIVE_TAKE_ITEM_TX', pc, 'LIMESTONE_52_1_SQ_1_NECK_1/1', 'LIMESTONE_52_1_SQ_1_NECK/1', "Quest")
                        local skill = GetNormalSkill(self);
                        ForceDamage(self, skill, pc, self, 0, 'MOTION', 'BLOW', 'I_force036_green1', 1, 'arrow_cast', 'I_force071_light_green', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                        PlayEffectLocal(self, pc, 'I_force071_light_green', 4, 0, 'BOT')
                        SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("LIMESTONE_52_1_SQ_3_GET_NECK"), 6)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_1_SQ_2', 'QuestInfoValue1', 1)
                    else
                        PlayAnimLocal(self, pc, 'OFF', 1)
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_1_SQ_3_ENOUGH_NECK"), 6)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("LIMESTONE_52_1_SQ_3_NONE_NECK"), 6)
            end
            PlayAnimLocal(self, pc, 'OFF', 1)
        end
    end
end

function SCR_LIMSTONE_52_1_CRYSTAL_ENTER(self, pc)
end

function SCR_LIMSTONE_52_1_CART_ENTER(self, pc)
end

function SCR_LIMESTONE_52_1_MQ_8_PROG_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function LIMESTONE_52_1_MQ_10_RUN(self)
    sleep(1000)
    ActorVibrate(self, 1, 0.5, 100, 0)
    sleep(2000)
    PlayEffect(self, 'F_explosion019_rize', 1, nil, 'BOT')
    Dead(self)
end

function LIMESTONE_52_1_MQ_10_KUPOLE(self, mon)
    local follower = GetScpObjectList(self, 'LIMESTONE_52_1_MQ_2')
    local i
    if #follower > 0 then
        for i = 1, #follower do
            if follower[i].ClassName == 'mon_kupole_4' then
                LookAt(follower[i], mon)
                PlayAnim(follower[i], 'atk')
                sleep(2000)
                PlayEffect(mon, 'F_rize012_violet', 1, nil, 'BOT')
            end
        end
    end
end

function LIMESTONE_52_1_MQ_10_ABANDON(self)
    UnHideNPC(self, 'LIMSTONE_52_1_CART')
end

function SCR_LIMESTONE_52_1_SQ_1_MON_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc,'LIMESTONE_52_1_SQ_1')
    if result == 'PROGRESS' then
        LookAt(pc, self)
        
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("LIMESTONE_52_1_SQ_1_TAKE"), 'BURY', 2);
        if result2 == 1 then
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_LIMESTONE_52_1_SQ_1', nil, nil, nil, 'LIMESTONE_52_1_SQ_1_NECK/1')
            PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
            ObjectColorBlend(self, 255, 255, 255, 0, 1, 0)
            Kill(self)
        end
    end
end

--LIMESTONE_52_1_STUNMON--
function LIMESTONE_52_1_MON_HPLCOK(self)
    AddBuff(self, self, 'HPLock', 1, 0, 0, 1)
end

function LIMESTONE_52_1_SQ_3_AI(self, from)
    if from.ClassName == 'PC' then
        local result = SCR_QUEST_CHECK(from, "LIMESTONE_52_1_SQ_3")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'LIMESTONE_52_1_STUN') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'LIMESTONE_52_1_STUN', 1, 0, 0, 1)
                    RunScript('LIMESTONE_52_1_STUN_RUN', self)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    else
        local owner = GetOwner(from)
        local result = SCR_QUEST_CHECK(owner, "LIMESTONE_52_1_SQ_3")
        if result == "PROGRESS" then
            if IsBuffApplied(self, 'LIMESTONE_52_1_STUN') == 'NO' then
                if GetHpPercent(self) < 0.1 then
                    CancelMonsterSkill(self)
                    AddBuff(self, self, 'LIMESTONE_52_1_STUN', 1, 0, 0, 1)
                    RunScript('LIMESTONE_52_1_STUN_RUN', self)
                end
            end
        else
            if IsBuffApplied(self, 'HPLock') == 'YES' then
                RemoveBuff(self, 'HPLock')
            else
                return 0
            end
        end
    end
end

function LIMESTONE_52_1_STUN_RUN(self)
    PlayAnim(self, 'Dead')
    sleep(1000)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, "tala_sorcerer", x, y, z, GetDirectionByAngle(self), "Neutral", nil, LIMESTONE_52_1_SQ_3_MON_SET)
    AddBuff(mon, mon, "LIMESTONE_52_1_STUN", 1, 0 , 0, 1)
    SetLifeTime(mon, 12, 1)
    Kill(self)
end

function LIMESTONE_52_1_SQ_3_MON_SET(mon)
	mon.BTree = "None"
	mon.Tactics = "None"
	mon.Name = "UnvisibleName"
	mon.SimpleAI = 'LIMESTONE_52_1_STUNMON'
end

function LIMESTONE_52_1_STUNMON_DEAD(self, pc)
    ObjectColorBlend(self, 255, 255, 255, 0, 1, 0)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, "tala_sorcerer", x, y, z, GetDirectionByAngle(self), "Neutral", nil, LIMESTONE_52_1_SQ_3_STUN_SET)
--    DisableBornAni(mon)
    PlayEffect(self, 'F_pc_making_finish_white', 2, 1, 'BOT')
    LookAt(mon, pc)
    PlayAnim(mon, 'run')
    sleep(3000)
    ObjectColorBlend(mon, 255, 255, 255, 1, 1, 0)
    Kill(mon)
    Kill(self)
end

function LIMESTONE_52_1_SQ_3_STUN_SET(mon)
    mon.BTree = "None"
	mon.Tactics = "None"
	mon.Name = "UnvisibleName"
end

function LIMESTONE_52_1_MQ_7_AI_RUN(self)
    local list, cnt = SelectObject(self, 40, 'ALL')
    local i
    if cnt > 0 then
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].ClassName == 'Pawndel' or list[i].ClassName == 'pawnd' then
                    return
                end
            end
        end
        PlayAnim(self, 'event_loop2', 1)
    else
        PlayAnim(self, 'event_loop2', 1)
    end
end

function SCR_LIMESTONE_52_1_MQ_1_ST_01(self)
    ShowBalloonText(self, 'LIMESTONE_52_1_MQ_1_ST_01', 3)
end

function SCR_LIMESTONE_52_1_BOAT_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'LIMESTONE_52_1_BOAT_DLG1', ScpArgMsg('LIMESTONE_52_1_BOAT_MSG1'), ScpArgMsg('LIMESTONE_52_1_BOAT_MSG2'))

    if select == 1 then
        ALL_PET_GET_OFF(pc)
        PlayDirection(pc, 'D_LIMESTONECAVE_52_1_ELT', 1, 1, 1)
        local tx = TxBegin(pc);
        TxAddAchievePoint(tx, "Transport1", 1)
        local ret = TxCommit(tx);
    elseif select == 2 then
    end
end