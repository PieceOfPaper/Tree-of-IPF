function SCR_ROKAS25_SWITCH3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
--    local sObj = GetSessionObject(pc, 'SSN_ROKAS25_REXIPHER4')
--    if sObj ~= nil then
--        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JagDong_Jung"), 'MAKING', 3)
--        if result == 1 then
--    	    if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
--    	        sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
--    	        
--    	        PlayTextEffect(self, "I_SYS_Text_Effect_Skill", ScpArgMsg("Auto_JagDong_Jung"))
--                PlayEffect(self, "F_ground012_light", 1.0, 0, "MID", 1)
--    	        
--    	    end
--        end
--    end
end


function SCR_ZACHA32_DEVICE02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_ZACHARIEL32_NPC_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_ROKAS25_SWITCH6_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_ROKAS25_SWITCH5_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_ROKAS25_SWITCH4_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, 'SSN_ROKAS25_REXIPHER5')
    if sObj ~= nil then
        if sObj.Step2 == 1 then
            local remainTime = GetSessionObjectTime(pc, sObj)
            if self.Dialog == 'ROKAS25_SWITCH4' then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JagDong_Jung"), 'MAKING', 2)
                if result == 1 then
                    sObj = GetSessionObject(pc, 'SSN_ROKAS25_REXIPHER5')
            	    sObj.Step2 = 0
            	    
            	    DetachEffect(self, 'F_lineup004')
            	    PlayEffect(self, 'I_ground002', 5, 1, 'BOT')
            	    local value = remainTime - 30
            	    if value < 2 then
            	        value = 2
            	    end
                    SetSessionObjectTime(pc, sObj, value)
                end
            end
        end
    end
end

function SCR_ROKAS25_SWITCH4_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_ROKAS25_REXIPHER2_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end


function SCR_ROKAS25_REXIPHER3_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end



function SCR_ROKAS25_REXIPHER5_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end


function SCR_ROKAS25_SWITCH1_DIALOG(self,pc)
    COMMON_QUEST_HANDLER(self,pc)
end





function SCR_ROKAS25_KEBIN_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_BINSENT_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_HILDA1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_HILDA2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_HILDA3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_ROKAS25_FIREWOOD_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_01')
    if result1 == 'PROGRESS' then
        
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET', 2.5)
        if result == 1 then
            local quest_ssn = GetSessionObject(pc, 'SSN_ROKAS25_SQ_01')
            if quest_ssn ~= nil then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_01', 'QuestInfoValue1', 1, nil, 'ROKAS25_Firewood_1/1')
--                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
--                    RunScript('GIVE_ITEM_TX', pc, 'ROKAS25_Firewood_1', 1, "Quest")
--                    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
--                    SaveSessionObject(pc, quest_ssn)
                    Kill(self)
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_JangJageul_HoegDeugHaessSeupNiDa"), 1)
--                end
            end
        end
    end
end

function SCR_ROKAS25_CALDRON1_DIALOG(self, pc)
    local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_04')
    if quest_sObj ~= nil then
        if quest_sObj.Step2 == 1 then
            if self.Dialog == 'ROKAS25_CALDRON1' then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_yag_JeosNeunJung"), '#SITGROPESET2', 2)
                if result == 1 then
                	quest_sObj.Step2 = 0
                	quest_sObj.Step4 = quest_sObj.Step4 + 1
                	DetachEffect(self, 'F_smoke130_blue_loop')
                	if quest_sObj ~= nil then
                        if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
--                            RunScript('GIVE_ITEM_TX', pc, 'ROKAS25_SQ_04_DRUG', 1, "Quest")
--                            quest_sObj.QuestInfoValue1 = quest_sObj.QuestInfoValue1+1
                            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_04', 'QuestInfoValue1', 1, nil, 'ROKAS25_SQ_04_DRUG/1')
                            PlayAnim(self, "OPEN", 0)
                            sleep(200)
                            PlayAnim(self, "CLOSE", 0)
                            
                        end
                    end
                end
            end
        end
    end
end

function SCR_ROKAS25_CALDRON2_DIALOG(self, pc)
    local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_04')
    if quest_sObj ~= nil then
        if quest_sObj.Step3 == 1 then
            if self.Dialog == 'ROKAS25_CALDRON2' then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_yag_JeosNeunJung"), '#SITGROPESET2', 2)
                if result == 1 then
                    quest_sObj.Step3 = 0
                    quest_sObj.Step5 = quest_sObj.Step5 + 1
                    DetachEffect(self, 'F_smoke130_blue_loop')
                    if quest_sObj ~= nil then
                        if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
--                            RunScript('GIVE_ITEM_TX', pc, 'ROKAS25_SQ_04_DRUG', 1, "Quest")
--                            quest_sObj.QuestInfoValue1 = quest_sObj.QuestInfoValue1+1
                            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_04', 'QuestInfoValue1', 1, nil, 'ROKAS25_SQ_04_DRUG/1')
                            PlayAnim(self, "OPEN", 0)
                            sleep(200)
                            PlayAnim(self, "CLOSE", 0)
                        end
                    end
                end
            end
        end
    end
end

function SCR_ROKAS25_HILDA_STRUCTURE_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result1 == 'PROGRESS' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JoSa_Jung"), 'LOOK', 2)
        if result == 1 then
            local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_06')
            if quest_sObj ~= nil then
--                if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Auto_BolPum_eopeo_BoipNiDa"), 5)
                    Dead(self)
--                end
            end
        end
    end
end


function SCR_ROKAS25_HILDA_STRUCTURE_TRUE1_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result1 == 'PROGRESS' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JoSa_Jung"), 'LOOK', 2)
        if result == 1 then
            local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_06')
            if quest_sObj ~= nil then
                if quest_sObj.QuestInfoValue1 < quest_sObj.QuestInfoMaxCount1 then
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_06', 'QuestInfoValue1', 1)
                    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("Auto_TeugiHan_JoKageul_ChajassSeupNiDa"), 5)
                else
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("ROKAS25_SQ_06_MSG01"), 5)
                end
            end
        end
    end
end

function SCR_ROKAS25_HILDA_STRUCTURE_TRUE2_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result1 == 'PROGRESS' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JoSa_Jung"), 'LOOK', 2)
        if result == 1 then
            local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_06')
            if quest_sObj ~= nil then
                if quest_sObj.QuestInfoValue2 < quest_sObj.QuestInfoMaxCount2 then
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_06', 'QuestInfoValue2', 1)
                    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("Auto_TeugiHan_JoKageul_ChajassSeupNiDa"), 5)
                else
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("ROKAS25_SQ_06_MSG01"), 5)
                end
            end
        end
    end
end

function SCR_ROKAS25_HILDA_STRUCTURE_TRUE3_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_SQ_06')
    if result1 == 'PROGRESS' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JoSa_Jung"), 'LOOK', 2)
        if result == 1 then
            local quest_sObj = GetSessionObject(pc, 'SSN_ROKAS25_SQ_06')
            if quest_sObj ~= nil then
                if quest_sObj.QuestInfoValue3 < quest_sObj.QuestInfoMaxCount3 then
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_SQ_06', 'QuestInfoValue3', 1)
                    SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("Auto_TeugiHan_JoKageul_ChajassSeupNiDa"), 5)
                else
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("ROKAS25_SQ_06_MSG01"), 5)
                end
            end
        end
    end
end


function SCR_SSN_ROKAS25_SQ_06_BASIC_HOOK(self, sObj)
	SCR_REGISTER_QUEST_PROP_HOOK(self, sObj)
end
function SCR_CREATE_SSN_ROKAS25_SQ_06(self, sObj)
	SCR_SSN_ROKAS25_SQ_06_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_ROKAS25_SQ_06(self, sObj)
	SCR_SSN_ROKAS25_SQ_06_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_ROKAS25_SQ_06(self, sObj)
end


function SCR_ROKAS25_EX2_STRUCTURE_DIALOG(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'ROKAS25_EX2')
    if result1 == 'PROGRESS' then
        
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_SuJip_Jung"), '#SITGROPESET2', 2.5)
        if result == 1 then
            local quest_ssn = GetSessionObject(pc, 'SSN_ROKAS25_EX2')
            if quest_ssn ~= nil then
                SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_ROKAS25_EX2', 'QuestInfoValue1', 1, nil, 'ROKAS25_EX2_STRUCTURE_ITEM/1')
--                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
--                    RunScript('GIVE_ITEM_TX', pc, 'ROKAS25_EX2_STRUCTURE_ITEM', 1, "Quest")
--                    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
--                    SaveSessionObject(pc, quest_ssn)
                    AttachEffect(self, 'F_pc_making_finish_white', 1, 'MID');
                    Dead(self)
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_yuMuleul_HoegDeugHaessSeupNiDa"), 1)
--                end
            end
        end
    end
end

--ROKAS_25_HQ01_NPC01 HIDDEN QUEST PROVISO NPC01
function SCR_ROKAS_25_HQ01_NPC01_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.ROKAS_25_HQ01_COUNT >= 1 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD01", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD01), 3)
    elseif main_sObj.ROKAS_25_HQ01_COUNT < 1 then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_PASSWORD")
            sleep(1700)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD01", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD01), 3)
        end
    end
end

--ROKAS_25_HQ01_NPC02 HIDDEN QUEST PROVISO NPC02
function SCR_ROKAS_25_HQ01_NPC02_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.ROKAS_25_HQ01_COUNT >= 1 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD02", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD02), 3)
    elseif main_sObj.ROKAS_25_HQ01_COUNT < 1 then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_PASSWORD")
            sleep(1700)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD02", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD02), 3)
        end
    end
end

--ROKAS_25_HQ01_NPC03 HIDDEN QUEST PROVISO NPC03
function SCR_ROKAS_25_HQ01_NPC03_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.ROKAS_25_HQ01_COUNT >= 1 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD03", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD03), 3)
    elseif main_sObj.ROKAS_25_HQ01_COUNT < 1 then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_PASSWORD")
            sleep(1700)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD03", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD03), 3)
        end
    end
end

--ROKAS_25_HQ01_NPC04 HIDDEN QUEST PROVISO NPC04
function SCR_ROKAS_25_HQ01_NPC04_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.ROKAS_25_HQ01_COUNT >= 1 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD04", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD04), 3)
    elseif main_sObj.ROKAS_25_HQ01_COUNT < 1 == nil then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_PASSWORD")
            sleep(1700)
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ROKAS_25_HQ01_PASSWORD04", "NUM", main_sObj.ROKAS_25_HQ01_PASSWORD04), 3)
        end
    end
end

--ROKAS_25_HQ_01 HIDDEN QUEST NPC DIALOG
function SCR_ROKAS_25_HQ01_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

--ROKAS_25_HQ_01 HIDDEN QUEST NPC ENTER
function SCR_ROKAS_25_HQ01_NPCENTER_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    local result = SCR_QUEST_CHECK(pc, "ROKAS_25_HQ_01")
    --print(sObj, result)
    if result == "IMPOSSIBLE" then
        local sObj = GetSessionObject(pc, "SSN_PASSWORD")
        if sObj == nil then
            --print("aaaaa")
            CreateSessionObject(pc, "SSN_PASSWORD")
        elseif sObj ~= nil then
            --print(sObj)
            return;
        end
    end
end

--ROKAS_25_HQ_01 HIDDEN QUEST NPC LEAVE
function SCR_ROKAS_25_HQ01_NPCLEAVE_LEAVE(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PASSWORD")
    --print(sObj)
    if sObj ~= nil then
        --print("aaaaa")
        DestroySessionObject(pc, sObj)
    end
end

--ROKAS_25_HQ_01 HIDDEN QUEST NPC CREATE TACTIC
function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_BORN_ENTER(self)
    self.NumArg1 = os.date('%H')
--    self.NumArg1 = os.date('%M')
end

function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_BORN_UPDATE(self)
--    self.NumArg1 = os.date('%S')
    self.NumArg1 = os.date('%H')
    local creMon = GetTacticsArgObject(self)
    local pcList, pcCnt = SelectObject(self, 300, "ALL", 1)
--    print(pcCnt)
    for i = 1, pcCnt do
        if pcList[i].ClassName == "PC" then
            local result = SCR_QUEST_CHECK(pcList[i], "ROKAS_25_HQ_01")
            if result == "COMPLETE" then
                return
            end
        end
    end
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 7 then
--        if self.NumArg1 == 30 then
--            print(ScpArgMsg('Auto_Daeum_Jen_Taim_SeTing_HyeonJae_SiKan_:_'),math.floor(os.clock()/60))
            local mon = CREATE_NPC(self, 'npc_miner', 3208, 60, -363, nil, 'Neutral', 0, ScpArgMsg("ROKAS_25_HQ01_NPCNAME"), 'ROKAS_25_HQ01_NPC', "ROKAS_25_HQ01_NPCENTER", 70, 1, "ROKAS_25_HQ01_NPCLEAVE")
            SetTacticsArgObject(self, mon)
            if mon ~= nil then
                self.NumArg1 = 0
                CreateSessionObject(mon, 'SSN_SETTIME_KILL')
                SetTacticsArgObject(self, mon)
                local sObj_mon = GetSessionObject(mon, 'SSN_SETTIME_KILL')
                if sObj_mon ~= nil then
                    sObj_mon.Count = 1800
--                    print(ScpArgMsg('Auto_NPC_SaengSeong_120Cho_Dwi_SaLaJim_'),sObj_mon.Count)
                end
            end
        end
    end
end

function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_BORN_LEAVE(self)
end

function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_DEAD_ENTER(self)
end

function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_DEAD_UPDATE(self)
end

function SCR_MON_F_ROKAS_25_PEAPLE_TRIGGER_TS_DEAD_LEAVE(self)
end

--ROKAS_25_HQ_01_QUEST CHECK FUNCTION
function ROKAS_25_HQ01_PASSWORD_OPEN(pc, questname, scriptInfo)
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.ROKAS_25_HQ01_CHAT < 1 then
        return 'NO'
    elseif main_sObj.ROKAS_25_HQ01_CHAT >= 1 then
        return 'YES'
    end
end

function SCR_ROKAS25_REXIPHER2_BOSS_STONE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_ROKAS25_REXIPHER4_SEAL1_TEXT_PLAY(self, pc)
	local list, cnt = SelectObject(self, 200, "ALL", 1);
	for i = 1, cnt do
	    if list[i].ClassName ~= "PC" then --Dialog Search
    	    if list[i].Dialog == 'ROKAS25_SWITCH1' then
                PlayTextEffect(list[i], "I_SYS_Text_Effect_Skill", ScpArgMsg("ROKAS25_REXIPHER4_MSG01"))
    		end
    	end
	end
end

function SCR_ROKAS25_REXIPHER1_SEAL1_FAIL_NOTICE(self)
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ROKAS25_REXIPHER4_MSG01"))
end

function SCR_ROKAS25_REXIPHER1_SEAL1_BEAT(self)
    PlayEffect(self "F_archer_bodkinpoint_hit_explosion", 0.5, 1, 'TOP');
end

function SCR_ROKAS25_SWITCH1_ENTER(self, pc)
end
function SCR_ROKAS25_SWITCH3_ENTER(self, pc)
end


function ROKAS25_REXIPHER4_SEAL1_SETPOS(self)
    local x, y, z = 1030, 164, -100
    local PosX, PosY, PosZ = GetPos(self)
    local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
    if range ~= 0 then
        SetPos(self, x, y, z)
    end
end

function ROKAS25_REXIPHER4_SEAL2_SETPOS(self)
    local x, y, z = 1032, 164, -301
    local PosX, PosY, PosZ = GetPos(self)
    local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
    if range ~= 0 then
        SetPos(self, x, y, z)
    end
end

function ROKAS25_REXIPHER4_SEAL3_SETPOS(self)
    local x, y, z = 1199, 164, -195
    local PosX, PosY, PosZ = GetPos(self)
    local range = SCR_POINT_DISTANCE(x, z, PosX, PosZ)
    if range ~= 0 then
        SetPos(self, x, y, z)
    end
end