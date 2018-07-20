--LIMESTONECAVE_52_2_MEDENA--
function SCR_LIMESTONECAVE_52_2_MEDENA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONECAVE_52_2_MEDENA_AI--
function SCR_LIMESTONECAVE_52_2_MEDENA_AI_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONE_52_2_ALLENA--
function SCR_LIMESTONE_52_2_ALLENA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--LIMESTONE_52_2_SERIJA--
function SCR_LIMESTONE_52_2_SERIJA_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_2_EVIL_1_DIALOG(self, pc)
    local checkQ1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_5')
    if checkQ1 == 'PROGRESS' then
        SCR_SCRIPT_PARTY("LIMESTONE_52_2_EVIL_1_RUN", 2, self, pc)
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function LIMESTONE_52_2_EVIL_1_RUN(self, pc)
    local checkQ1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_5')
    if checkQ1 == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_LIMESTONE_52_2_MQ_5')
        HideNPC(pc, 'LIMESTONE_52_2_EVIL_1')
        local x,y,z = GetPos(self)
        local mon = CREATE_MONSTER_EX(pc, 'soul_gathering_mchn_2', x, y, z, GetDirectionByAngle(self), 'Peaceful', 1, LIMESTONE_52_2_EVIL_SET)
        AddVisiblePC(mon, pc, 1)
        ActorVibrate(mon, 1, 0.5, 100, 0)
        sObj.QuestInfoValue1 = 1
        SaveSessionObject(pc, sObj)
        SCR_LIMESTONE_52_2_EVIL_DEAD(mon, pc)
        sleep(2000)
        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_2_MQ_5_SUCC"), 6)
    end
end

function LIMESTONE_52_2_EVIL_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

function SCR_LIMESTONE_52_2_EVIL_DEAD(self, pc)
    local follower = GetScpObjectList(pc, 'LIMESTONE_52_2_MQ_1')
    local i
    if #follower > 0 then
        for i = 1, #follower do
            if follower[i].ClassName == 'mon_kupole_4' then
                LookAt(follower[i], self)
                PlayAnim(follower[i], 'atk')
                sleep(1000)
                PlayEffect(self, 'F_rize012_violet', 1)
                sleep(1000)
                Dead(self)
            end
        end
    end
end

function LIMESTONE_52_2_MQ_5_ABANDON(self)
    UnHideNPC(self, 'LIMESTONE_52_2_EVIL_1')
end

function SCR_LIMESTONE_52_2_EVIL_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_2_EVIL_3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_2_ANTIEVIL_DIALOG(self, pc)
    local ht3_result1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_5_MQ_10')
    if ht3_result1 == "COMPLETE" then
        ShowBalloonText(pc, 'HT3_LIMESTONE_52_ANTIEVIL_BML0'..IMCRandom(1, 4), 6)
    else
    ShowBalloonText(pc, 'LIMESTONE_52_2_WARNING', 6)
    end
end

function SCR_LIMESTONE_52_2_MQ_1_PROG_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_2_MQ_3_PROG_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_LIMESTONE_52_2_MQ_3_FAKE_1_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_3')
    if result == 'PROGRESS' then
        ShowBalloonText(pc, 'LIMESTONE_52_2_MQ_3_FAKE_1', 6)
    end
end

function SCR_LIMESTONE_52_2_MQ_3_FAKE_2_ENTER(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_3')
    if result1 == 'PROGRESS' then
        ShowBalloonText(pc, 'LIMESTONE_52_2_MQ_3_FAKE_2', 8)
    end
end

function LIMESTONE_52_2_MQ_7_END(self)
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("LIMESTONE_52_2_MQ_7_SUCC_MSG"), 6)
    HideNPC(self, 'LIMESTONE_52_2_EVIL_3')
    local mon = CREATE_MONSTER_EX(self, 'soul_gathering_mchn_1', -1009, -948, 361, -45, 'Neutral', 1, LIMESTONE_52_2_MQ_7_NPC_SET)
    AddVisiblePC(mon, self, 1)
    ActorVibrate(mon, 2, 0.5, 100, 0)
    sleep(2000)
    PlayEffectLocal(mon, self, 'F_burstup024_dark', 4)
    Dead(mon)
end

function LIMESTONE_52_2_MQ_7_NPC_SET(mon)
    mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = 'UnvisibleName'
end

function SCR_LIMESTONE_52_2_HEALING_DIALOG(self, pc)
    local checkQ1 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_MQ_8')
    if checkQ1 == 'PROGRESS' then
        if GetInvItemCount(pc, 'LIMESTONE_52_2_MQ_8_HEALSTONE') == 0 then
            local follower = GetScpObjectList(pc, 'LIMESTONE_52_2_MQ_1')
            local i
            for i = 1, #follower do
                LookAt(pc, self)
                LookAt(follower[i], self)
                PlayAnim(follower[i], 'event_loop2')
                AttachEffect(self, 'F_light078_holy_yellow_loop', 1, nil, 'BOT')
                local action_r = DOTIMEACTION_R(pc, ScpArgMsg('LIMESTONE_52_2_MQ_8_ING'), 'ABSORB', 6)
                if action_r == 1 then
                    local skill = GetNormalSkill(self)
                    ForceDamage(self, skill, pc, self, 0, 'MOTION', 'BLOW', 'I_force036_green1', 1, 'arrow_cast', 'I_explosion004_yellow', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                    RunScript('GIVE_ITEM_TX', pc, 'LIMESTONE_52_2_MQ_8_HEALSTONE', 1, "Q_LIMESTONE_52_2_MQ_8")
                    PlayAnim(follower[i], 'std')
                    DetachEffect(self, 'F_light078_holy_yellow_loop')
                    return
                end
                PlayAnim(follower[i], 'std')
                DetachEffect(self, 'F_light078_holy_yellow_loop')
            end
        end
    else
        local checkQ2 = SCR_QUEST_CHECK(pc, 'LIMESTONE_52_2_SQ_2')
        if checkQ2 == 'PROGRESS' then
            if GetInvItemCount(pc, 'LIMESTONE_52_2_MQ_8_HEALSTONE_F') == 0 then
                LookAt(pc, self)
                PlayEffectLocal(self, pc, 'F_spread_in002_yellow', 1, nil, 'BOT')
                local action_r = DOTIMEACTION_R(pc, ScpArgMsg('LIMESTONE_52_2_MQ_8_ING'), 'ABSORB', 4)
                if action_r == 1 then
                    local skill = GetNormalSkill(self)
                    ForceDamage(self, skill, pc, self, 0, 'MOTION', 'BLOW', 'I_force036_green1', 1, 'arrow_cast', 'I_explosion004_yellow', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                    RunScript('GIVE_ITEM_TX', pc, 'LIMESTONE_52_2_MQ_8_HEALSTONE_F', 1, "Q_LIMESTONE_52_2_SQ_2")
                end
            end
        end
    end
end

function LIMESTONE_52_2_REENTER_RUN(self, sObj, msg, argObj, argStr, argNum)
    local result = {}
    local list = {}
    local i
    for i = 1, 9 do
        result[i] = SCR_QUEST_CHECK(self, 'LIMESTONE_52_2_MQ_'..i)
        if i == 1 then
            if result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_2_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_2_MQ_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        else
            if result[i] ~= 'COMPLETE' and result[i] == 'POSSIBLE' or result[i] == 'PROGRESS' or result[i] == 'SUCCESS' then
                list[i] = GetScpObjectList(self, 'LIMESTONE_52_2_MQ_'..i)
                if #list[i] == 0 then
                    local func = _G['LIMESTONE_52_2_MQ_RUNNPC'];
                    if func ~= nil then
                		func(self);
                	end
            	end
            end
        end
    end
end




function LIMESTONE_52_2_MQ_RUNNPC(self)
    local pc_zone = GetZoneName(self);
    if pc_zone == 'd_limestonecave_52_2' then
        local follower = GetScpObjectList(self, 'LIMESTONE_52_2_MQ_1')
        if #follower == 0 then
            local x, y, z = -1599, -115, -1643
            local mon = CREATE_MONSTER_EX(self, 'mon_kupole_4', x, y, z, GetDirectionByAngle(self), 'Neutral', self.Lv, LIMESTONE_52_2_MQ_1_SET);
            LookAt(mon, self)
            mon.RunMSPD = 100
            SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'LIMESTONE_52_2_MQ_1', 2);
            AddScpObjectList(self, 'LIMESTONE_52_2_MQ_1', mon)
            SetExArgObject(mon, 'PLAYER_01', self)
            EnableAIOutOfPC(mon)
        end
    end
end

function LIMESTONE_52_2_MQ_1_SET(mon)
	mon.BTree = "None";
	mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("LIMESTONECAVE_52_1_MEDENA_NAME");
	mon.SimpleAI = 'LIMESTONE_52_2_MQ_1_AI'
	mon.Dialog = 'LIMESTONECAVE_52_2_MEDENA_AI'
end

function LIMESTONE_52_2_MQ_1_RUN(self)
    local PC_Owner = GetOwner(self)
    if PC_Owner == nil then
        Kill(self)
    elseif PC_Owner ~= nil then
        local deadCheck = IsDead(PC_Owner)
        if deadCheck == 1 then
            ABANDON_Q_BY_NAME(PC_Owner, "LIMESTONE_52_2_MQ_1", abandon_or_fail)
            Kill(self)
        end
        
    end
end

function LIMESTONE_52_2_EVIL_TRACK_BUFF(self)
    AddBuff(self, self, 'SoulDuel_DEF', 1, 0, 0, 1)
end

function LIMESTONE_52_2_EVIL_TRACK_HIT(self, from)
    if from.ClassName == 'PC' then
        if IsBuffApplied(self, 'SoulDuel_DEF')== 'YES' then
            SendAddOnMsg(from, 'NOTICE_Dm_!', ScpArgMsg('LIMESTONE_52_2_EVIL_HIT'), 3)
        end
    end
end

function LIMESTONE_52_2_EVIL_TRACK_RUN(self)
    local list, cnt = SelectObject(self, 100, 'ALL')
    local i
    if cnt > 0 then
        for i = 1, cnt do
            if list[i].ClassName ~= 'PC' then
                if list[i].ClassName == 'Pawndel' or list[i].ClassName == 'pawnd' then
                    AddBuff(self, self, 'SoulDuel_DEF', 1, 0, 0, 1)
                    PlayEffect(self, 'I_smoke001_dark_2', 2, nil, 'MID')
                    return
                end
            end
        end
        RemoveBuff(self, 'SoulDuel_DEF')
    end
end

function SCR_LIMESTONE_52_2_DARKWALL_ENTER(self, pc)
end

function SCR_LIMESTONE_52_2_DARKWALL_2_ENTER(self, pc)
end