--HIDDEN QUEST CONDITION (2014.7.23)

--KATYN_13_2_HQ_01
function SCR_KATYN_13_2_HQ_01_TRIGGER01_ENTER(self, pc) 

    local sObj_hq1 = GetSessionObject(pc, 'SSN_KATYN_13_2_HQ_05')
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')

    if main_ssn ~= nil then

        if main_ssn.KATYN_13_2_HQ_01 <= 0 and
           main_ssn.KATYN_13_2_HQ_02 <= 0 and
           main_ssn.KATYN_13_2_HQ_03 <= 0 and
           main_ssn.KATYN_13_2_HQ_04 <= 0 then
            if sObj_hq1 == nil then
                CreateSessionObject(pc, 'SSN_KATYN_13_2_HQ_05', 1)

            end
        end
    end
end

function DESTROY_SESSION(self, pc) 
--    local sObj_hq1 = GetSessionObject(pc, 'SSN_KATYN_13_2_HQ_05')
--    if sObj_hq1 ~= nil then
--        DestroySessionObject(pc, sObj_hq1, 1)
--    end
end



function SCR_KATYN_13_2_HQ_01_TRIGGER02_LEAVE(self, pc)
    local sObj_hq1 = GetSessionObject(pc, 'SSN_KATYN_13_2_HQ_05')
    
    if sObj_hq1 ~= nil then
    
        DestroySessionObject(pc, sObj_hq1, 1)
--        print("DestroySessionObject")
    end
end

function SCR_CREATE_SSN_KATYN_13_2_HQ_05(pc, sObj)
     RegisterHookMsg(pc, sObj, 'UseSkill', 'KATYN_13_2_HQ_01_SKILLCOUNT', 'NO')
--     print("RegisterHookMsg")
end

function SCR_REENTER_SSN_KATYN_13_2_HQ_05(pc, sObj)
    RegisterHookMsg(pc, sObj, 'UseSkill', 'KATYN_13_2_HQ_01_SKILLCOUNT', 'NO')

end

function SCR_DESTROY_SSN_KATYN_13_2_HQ_05(pc, sObj)

end

function KATYN_13_2_HQ_01_SKILLCOUNT(pc, sObj, msg, argObj, argStr, argNum)

    local sObj_hq1 = GetSessionObject(pc, 'SSN_KATYN_13_2_HQ_05')
--    print("1111111111111111111111111111111111")
    if sObj_hq1 ~= nil then
--    print("2222222222222222222222222222222222",sObj, msg, argObj, argStr, argNum )
                
        local list, Cnt = SelectObjectByFaction(pc, 150, 'Neutral')

        local i
        for i = 1, Cnt do
            if list[i].Dialog == 'KATYN_13_2_HQ_01' then

                if argObj.ClassName == "Swordman_Thrust"  then
            
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_KATYN_13_2_HQ_05', 'QuestInfoValue1', 1)

                        if sObj_hq1.QuestInfoValue1 == 3 then
                            
                            local sObj_hq_m = GetSessionObject(pc, 'ssn_klapeda')
                            if sObj_hq_m ~= nil then
                                    
                                sObj_hq_m.KATYN_13_2_HQ_05 = 300
                                UnHideNPC(pc, "KATYN_13_2_HQ_01_SMASTER")
                                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_13_2_HQ_01_MSG01"), 3)

                            end
                        end
                    
                elseif argObj.ClassName == "Wizard_EnergyBolt"  then
            
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_KATYN_13_2_HQ_05', 'QuestInfoValue2', 1)
                    
                        if sObj_hq1.QuestInfoValue2 == 3 then
                            
                            local sObj_hq_m = GetSessionObject(pc, 'ssn_klapeda')
                            if sObj_hq_m ~= nil then
                            
                                sObj_hq_m.KATYN_13_2_HQ_06 = 300
                                UnHideNPC(pc, "KATYN_13_2_HQ_01_WMASTER")
                                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_13_2_HQ_01_MSG02"), 3)

                            end
                        end
                    
                elseif argObj.ClassName == "Archer_Fulldraw"  then
            
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_KATYN_13_2_HQ_05', 'QuestInfoValue3', 1)
                        if sObj_hq1.QuestInfoValue3 == 3 then
                            
                            local sObj_hq_m = GetSessionObject(pc, 'ssn_klapeda')
                            if sObj_hq_m ~= nil then
                                
                                sObj_hq_m.KATYN_13_2_HQ_07 = 300
                                UnHideNPC(pc, "KATYN_13_2_HQ_01_AMASTER")
                                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_13_2_HQ_01_MSG03"), 3)
                                    
                            end
                        end
            
                elseif argObj.ClassName == "Cleric_SafetyZone"  then
            
                    SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_KATYN_13_2_HQ_05', 'QuestInfoValue4', 1)
                        if sObj_hq1.QuestInfoValue4 == 3 then
                            
                            local sObj_hq_m = GetSessionObject(pc, 'ssn_klapeda')
                            if sObj_hq_m ~= nil then
                                    
                                sObj_hq_m.KATYN_13_2_HQ_08 = 300
                                UnHideNPC(pc, "KATYN_13_2_HQ_01_CMASTER")
                                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("KATYN_13_2_HQ_01_MSG04"), 3)
                                    
                            end
                        end
                        
                end
            end  
        break
        end
    end
end




function SCR_KATYN_13_2_HQ_01_SMASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_KATYN_13_2_HQ_01_WMASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_KATYN_13_2_HQ_01_AMASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_KATYN_13_2_HQ_01_CMASTER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end



--ZACHARIEL_35_HQ_01 : quest condition

function SCR_ZACHARIEL_35_HQ_01_PREFUNC(pc, questname, scriptInfo)

    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil then
        if main_ssn.ZACHA4F_MQ_01 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_MQ_02 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_MQ_03 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_MQ_04 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_MQ_05 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_SQ_01 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_SQ_03 >= CON_QUESTPROPERTY_END and
           main_ssn.ZACHA4F_SQ_05 >= CON_QUESTPROPERTY_END then
           
                return "YES"
        end
    end
end


--ZACHARIEL_35_HQ_01 : random hour NPC regeneration function

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_BORN_ENTER(self)
    self.NumArg2 = math.floor(os.clock()/60)
    self.NumArg1 = IMCRandom(30, 60)
end

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_BORN_UPDATE(self)
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        --print("obj cre gentiem : "..self.NumArg1.." / now tiem : "..math.floor(os.clock() / 60).." / past tiem : "..self.NumArg2)
        if self.NumArg1 == 0 and self.NumArg2 == 0 then
            self.NumArg2 = math.floor(os.clock()/60)
            self.NumArg1 = IMCRandom(30, 60)
        elseif self.NumArg1 <=  math.floor(os.clock() / 60) - self.NumArg2 then
            local zoneInstID = GetZoneInstID(self);
            local x, y, z = GetPos(self)
            
            if IsValidPos(zoneInstID, x, y, z) == 'YES' then
                local mon = CREATE_NPC(self, 'npc_zacharial_desk', x, y, z, 0, 'Neutral', 0, ScpArgMsg("ZACHARIEL_35_HQ_01_MSG01"), 'ZACHARIEL_35_HQ_01_NPC', nil, 1, 1)
                --print("obj cre")
                if mon ~= nil then
                    self.NumArg1 = 0
                    self.NumArg2 = 0
                    SetLifeTime(mon, 3600)
                    SetTacticsArgObject(self, mon)
                    
                end
            end
        end
    end
end

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_BORN_LEAVE(self)
end

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_DEAD_ENTER(self)
end

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_DEAD_UPDATE(self)
end

function SCR_ZACHARIEL_35_HQ_01_BOOK_TS_DEAD_LEAVE(self)
end


function SCR_ZACHARIEL_35_HQ_01_NPC_DIALOG(self, pc)
	COMMON_QUEST_HANDLER(self, pc)
end




--REMAINS_40_HQ_01 : quest condition
function SCR_REMAINS_40_HQ_01_PREFUNC(pc, questname, scriptInfo)
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil then
        if main_ssn.REMAIN37_MQ02 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_MQ03 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_MQ05 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ01 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ02 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ03 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ04 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ05 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ06 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ07 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN37_SQ08 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_MQ06 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_MQ07 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_SQ02 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_SQ03 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_SQ04 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN38_SQ06 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN39_SQ04 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAIN39_SQ08 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAINS39_MQ07 >= CON_QUESTPROPERTY_END and
           main_ssn.REMAINS40_MQ_07 >= CON_QUESTPROPERTY_END 
           then
            return "YES"
        end
    end
end


--REMAINS_40_HQ_01 
function SCR_REMAINS_40_HQ_01_TB_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end



--FIRETOWER_45_HQ_01
function SCR_FIRETOWER_45_HQ_01_PREFUNC(pc, sObj)
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil then
        if main_ssn.FIRETOWER_45_HQ_01_1 == CON_QUESTPROPERTY_END and 
            main_ssn.FIRETOWER_45_HQ_01_2 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_3 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_4 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_5 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_6 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_7 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_8 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_9 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_10 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_11 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_12 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_13 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_14 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_15 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_16 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_17 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_18 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_19 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_20 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_21 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_22 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_23 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_24 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_25 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_26 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_27 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_28 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_29 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_30 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_31 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_32 == CON_QUESTPROPERTY_END and
            main_ssn.FIRETOWER_45_HQ_01_33 == CON_QUESTPROPERTY_END
--            main_ssn.FIRETOWER_45_HQ_01_34 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_35 == CON_QUESTPROPERTY_END and
--            main_ssn.FIRETOWER_45_HQ_01_36 == CON_QUESTPROPERTY_END 
            then
            
        return "YES"
        end
    end
end




--FEDIMIAN_HQ_01
function SCR_FED_EQUIP_HQ_REINFORCE_ENTER(self, pc)
    local sObj_hq = GetSessionObject(pc, 'SSN_FEDIMIAN_HQ_01_1')
    local result01 = SCR_QUEST_CHECK(pc, "FEDIMIAN_HQ_01")
    if result01 == "IMPOSSIBLE" then 
        if sObj_hq == nil then
            CreateSessionObject(pc, 'SSN_FEDIMIAN_HQ_01_1', 1)    
        end
    end
end

function SCR_CREATE_SSN_FEDIMIAN_HQ_01_1(pc, sObj)
     RegisterHookMsg(pc, sObj, 'Reinforce', 'FEDIMIAN_HQ_01_REINFORCECOUNT', 'NO')
--     print("SCR_CREATE_SSN_FEDIMIAN_HQ_01_1")
end

function SCR_REENTER_SSN_FEDIMIAN_HQ_01_1(pc, sObj)
    RegisterHookMsg(pc, sObj, 'Reinforce', 'FEDIMIAN_HQ_01_REINFORCECOUNT', 'NO')
--    print("SCR_REENTER_SSN_FEDIMIAN_HQ_01_1")
end

function SCR_DESTROY_SSN_FEDIMIAN_HQ_01_1(pc, sObj)
end


function REINFORCE_SESSION_DESTROY (self, pc) 
end


function SCR_FED_EQUIP_HQ_REINFORCE_LEAVE(self, pc)
    local sObj_hq = GetSessionObject(pc, 'SSN_FEDIMIAN_HQ_01_1')
    if sObj_hq ~= nil then
        DestroySessionObject(pc, sObj_hq, 1)    
    end
end

function FEDIMIAN_HQ_01_REINFORCECOUNT(pc, sObj, msg, argObj, argStr, argNum)
    local list1, Cnt1 = SelectObject(pc, 100, 'ALL', 1)
    for j = 1, Cnt1 do
        if list1[j].ClassName ~= 'PC' then
            if list1[j].Dialog == 'FED_EQUIP' then
                
                local sObj_hq_f = GetSessionObject(pc, 'SSN_FEDIMIAN_HQ_01_1')
                if argStr == "FAIL" and argNum == 8 then
                
                    local sObj_hq_m = GetSessionObject(pc, "ssn_klapeda")
                    if sObj_hq_m ~= nil then
                            sObj_hq_m.FEDIMIAN_HQ_01_1 = 300
                    end
                end
            end
        end
    end
end


function SCR_FEDIMIAN_HQ_02_PREFUNC(pc, sObj)
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil then
        if main_ssn.FEDIMIAN_HQ_02_1 == CON_QUESTPROPERTY_END then
            return "YES"
        end
    end
end

--SADU tactics
function SCR_FEDIMIAN_HQ_02_SADU_TS_BORN_ENTER(self)
    self.NumArg2 = math.floor(os.clock()/60)
    self.NumArg1 = IMCRandom(10, 20)

end

function SCR_FFEDIMIAN_HQ_02_SADU_TS_BORN_UPDATE(self)
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 0 and self.NumArg2 == 0 then 
            self.NumArg2 = math.floor(os.clock()/60)
            self.NumArg1 = IMCRandom(10, 20)
        elseif self.NumArg1 <=  math.floor(os.clock() / 60) - self.NumArg2 then
            if self.NumArg1 + 5 <=  math.floor(os.clock() / 60) - self.NumArg2  then
                self.NumArg2 = math.floor(os.clock()/60)
                self.NumArg1 = IMCRandom(10, 20)
            else
                local list1, Cnt1 = SelectObject(self, 300, 'ALL', 1)
                for k = 1, Cnt1 do
                    if list1[k].ClassName == 'PC' then
                    local mss = GetSessionObject(list1[k], "ssn_klapeda")
                        if mss ~= nil and mss.FEDIMIAN_HQ_02_1 ~= 300 then
                            mss.FEDIMIAN_HQ_02_1 = 300
                        end
                    end
                end
                return
            end
        end
    end
    local list1, Cnt1 = SelectObject(self, 300, 'ALL', 1)
    for k = 1, Cnt1 do
        if list1[k].ClassName == 'PC' then
        local mss = GetSessionObject(list1[k], "ssn_klapeda")
            if mss ~= nil then
                mss.FEDIMIAN_HQ_02_1 = 0
                break
            end
        end
    end
end

function SCR_FEDIMIAN_HQ_02_SADU_TS_BORN_LEAVE(self)
end

function SCR_FEDIMIAN_HQ_02_SADU_TS_DEAD_ENTER(self)
end

function SCR_FEDIMIAN_HQ_02_SADU_TS_DEAD_UPDATE(self)
end

function SCR_FEDIMIAN_HQ_02_SADU_TS_DEAD_LEAVE(self)
end

--KATYN_14_HQ_01
function SCR_KATYN_14_HQ_01_PREFUNC1(pc)
    local cnt = GetNPCStateCount(pc);
--    print ("------------>>NPCCount:", cnt)
	if cnt > 300 then 
        return "YES"
    end
end

function SCR_KATYN_14_HQ_01_PREFUNC2(pc) 
	local clslist, cnt = GetClassList("Ability")
	local i
	local abil = {}
	for i = 0, cnt-1 do
	    local abilIdx = GetClassByIndexFromList(clslist, i);
        abil[i] = GET_ABIL_LEVEL(pc, abilIdx.ClassName)
        if abil[i] >= 1 then
            return "YES"
        end
    end
end
        
function SCR_KATYN_14_HQ_01_PREFUNC3(pc) 
	local clslist, cnt = GetClassList("Ability")
	local i
	local abil = {}
	for i = 0, cnt-1 do
	    local abilIdx = GetClassByIndexFromList(clslist, i);
        abil[i] = GET_ABIL_LEVEL(pc, abilIdx.ClassName)
        if abil[i] >= 1 then
            return "YES"
        end
    end
end



--KATYN_10_HQ_01
function SCR_KATYN_10_HQ_01_PREFUNC(pc, sObj)
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil then
        if main_ssn.KATYN_10_HQ_01_1 == CON_QUESTPROPERTY_END and 
            main_ssn.KATYN_10_HQ_01_2 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_3 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_4 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_5 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_6 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_7 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_8 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_9 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_10 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_11 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_12 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_13 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_14 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_15 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_16 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_17 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_18 == CON_QUESTPROPERTY_END and
--            main_ssn.KATYN_10_HQ_01_19 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_20 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_21 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_22 == CON_QUESTPROPERTY_END and
            main_ssn.KATYN_10_HQ_01_23 == CON_QUESTPROPERTY_END and 
            main_ssn.KATYN_10_HQ_01_24 == CON_QUESTPROPERTY_END then
            return "YES"
        end
    end	
end

function SCR_KATYN_10_HQ_01_OWL_NPC_DIALOG(self, pc)
    --for search KATYN_10_HQ_01
    local main_ssn = GetSessionObject(pc, 'ssn_klapeda')
    if main_ssn ~= nil and main_ssn.KATYN_10_HQ_01_24 ~= 300 then
        main_ssn.KATYN_10_HQ_01_24 = 300
    end
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KATYN_10_HQ_01_OWL_TS_BORN_ENTER(self)
    self.NumArg2 = math.floor(os.clock()/60)
    self.NumArg1 = IMCRandom(240, 300)
end

function SCR_KATYN_10_HQ_01_OWL_TS_BORN_UPDATE(self)
    
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 0 and self.NumArg2 == 0 then
            self.NumArg2 = math.floor(os.clock()/60)
            self.NumArg1 = IMCRandom(240, 300)
--            print(self.NumArg2, self.NumArg1)
        elseif self.NumArg1 <=  math.floor(os.clock() / 60) - self.NumArg2 then
            local zoneInstID = GetZoneInstID(self);
            local x, y, z = GetPos(self)
            
            if IsValidPos(zoneInstID, x, y, z) == 'YES' then
                local mon = CREATE_NPC(self, 'f_katyn_owl02', x, y, z, -68, 'Neutral', 0, ScpArgMsg("KATYN_10_HQ_01_OWL_MSG01"), 'KATYN_10_HQ_01_OWL_NPC', nil, 1, 1)
                if mon ~= nil then
                    self.NumArg1 = 0
                    self.NumArg2 = 0
                    SetLifeTime(mon, 300)
                end
            end
        end
    end
end

function SCR_KATYN_10_HQ_01_OWL_TS_BORN_LEAVE(self)
end

function SCR_KATYN_10_HQ_01_OWL_TS_DEAD_ENTER(self)
end

function SCR_KATYN_10_HQ_01_OWL_TS_DEAD_UPDATE(self)
end

function SCR_KATYN_10_HQ_01_OWL_TS_DEAD_LEAVE(self)
end





function MOON23(self)
    ReinForceHookMsg(self, itemReinCount, result)
    --print(itemReinCount, result)
end

function SCR_KLAIPE_HQ_01_NPC_E_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc, self.Enter)
end

function SCR_KLAIPE_HQ_01_NPC_D_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc, self.Dialog)
end



function SCR_KLAIPE_HQ_01_PREFUNC(pc, sObj)

    local sObj_hq = GetSessionObject(pc, "SSN_KLAIPE_HQ_01_1")
    if sObj_hq ~= nil then 
        local key_num1 = sObj_hq.QuestInfoMaxCount1
        local key_num2 = sObj_hq.QuestInfoValue2
        local key_num3 = sObj_hq.QuestInfoValue3
        local key_num4 = sObj_hq.QuestInfoValue4
        local key_num5 = sObj_hq.QuestInfoValue5
    
        if key_num1 ~= nil and key_num2 ~= nil and key_num3 ~= nil and key_num4 ~= nil and key_num5 ~= nil then
            return "YES"
        end
    end
end


function SCR_KLAIPE_HQ_02_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function KLAIPE_HQ_01_DESTROY(self, pc)
--    sObj_hq = GetSessionObject(pc, 'SSN_KLAIPE_HQ_01_1')
--    if sObj_hq ~= nil then 
--        DestroySessionObject(pc, 'SSN_KLAIPE_HQ_01_1')
--    else return
--    end
end

function SCR_WHITETREES56_1_SQ10_PREFUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_WHITETREES56_1_HIDDEN1")
--    print("sObj.Step1: "..sObj.Step1, "/ sObj.Step2: "..sObj.Step2, "/ sObj.Step3: "..sObj.Step3, "/ sObj.Step4: "..sObj.Step4, "/ sObj.Step5: "..sObj.Step5, "/ sObj.Step6: "..sObj.Step6, "/ sObj.Step7: "..sObj.Step7, "/ sObj.Step8: "..sObj.Step8, "/ sObj.Step9: "..sObj.Step9, "/ sObj.Step10: "..sObj.Step10, "/ sObj.Step11: "..sObj.Step11, "/ sObj.Step12: "..sObj.Step12, "/ sObj.Step13: "..sObj.Step13, "/ sObj.Step14: "..sObj.Step14, "/ sObj.Step15: "..sObj.Step15,"/ sObj.Step16: "..sObj.Step16,"/ sObj.Step17: "..sObj.Step17,"/ sObj.Step18: "..sObj.Step18, "/ sObj.Goal1: "..sObj.Goal1, "/ sObj.Goal2: "..sObj.Goal2, "/ sObj.Goal3: "..sObj.Goal3, "/ sObj.Goal4: "..sObj.Goal4, "/ sObj.Goal5: "..sObj.Goal5, "/ sObj.Goal6: "..sObj.Goal6, "/ sObj.Goal7: "..sObj.Goal7, "/ sObj.Goal8: "..sObj.Goal8, "/ sObj.Goal9: "..sObj.Goal9, "/ sObj.Goal10: "..sObj.Goal10, "/ sObj.Goal11: "..sObj.Goal11,"/ sObj.Goal12: "..sObj.Goal12, "/ sObj.Goal13: "..sObj.Goal13, "/ sObj.Goal14: "..sObj.Goal14, "/ sObj.Goal15: "..sObj.Goal15, "/ sObj.Goal16: "..sObj.Goal16, "/ sObj.Goal17: "..sObj.Goal17, "/ sObj.Goal18: "..sObj.Goal18)
    if sObj ~= nil then
        if sObj.Step1 == 1 and sObj.Goal1 == 1 and
           sObj.Step2 == 1 and sObj.Goal2 == 1 and
           sObj.Step3 == 1 and sObj.Goal3 == 1 and
           sObj.Step4 == 1 and sObj.Goal4 == 1 and
           sObj.Step5 == 1 and sObj.Goal5 == 1 and
           sObj.Step6 == 1 and sObj.Goal6 == 1 and
           sObj.Step7 == 1 and sObj.Goal7 == 1 and
           sObj.Step8 == 1 and sObj.Goal8 == 1 and
           sObj.Step9 == 1 and sObj.Goal9 == 1 and
           sObj.Step10 == 1 and sObj.Goal10 == 1 and
           sObj.Step11 == 1 and sObj.Goal11 == 1 and
           sObj.Step12 == 1 and sObj.Goal12 == 1 and
           sObj.Step13 == 1 and sObj.Goal13 == 1 and
           sObj.Step14 == 1 and sObj.Goal14 == 1 and
           sObj.Step15 == 1 and sObj.Goal15 == 1 and
           sObj.Step16 == 1 and sObj.Goal16 == 1 and
           sObj.Step17 == 1 and sObj.Goal17 == 1 and
           sObj.Step18 == 1 and sObj.Goal18 == 1 then
--           print("222222")
            return "YES"
        end
    end
end

--ORSHA_HQ1 condition check
function SCR_ORSHA_HQ1_CONDITION_ENTER(self, pc)
    local Quest = SCR_QUEST_CHECK(pc, "ORSHA_HQ1")
    local EquipItem1 = GetEquipItem(pc, GetClassString('Item', 'Hat_628093', 'DefaultEqpSlot'));
    if Quest == "IMPOSSIBLE" and Quest == "POSSIBLE" then
        if EquipItem1 ~= nil then
            if EquipItem1.ClassName == "Hat_628093" then
                ChatLocal(self, pc, ScpArgMsg("ORSHA_HIDDENQ1_MSG1"), 3)
            end 
        end
    end
end

--UNDERFORTRESS67_HQ1 condition check
function UNDERFORTRESS67_HIDDENQ1_PRE_CHECK_DLG(self,pc)
    local map_Search1 = GetMapFogSearchRate(pc, "d_underfortress_65")
    local map_Search2 = GetMapFogSearchRate(pc, "d_underfortress_66")
    local map_Search3 = GetMapFogSearchRate(pc, "d_underfortress_67")
    local map_Search4 = GetMapFogSearchRate(pc, "d_underfortress_68")
    local map_Search5 = GetMapFogSearchRate(pc, "d_underfortress_69")
    local quest = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    if quest == "IMPOSSIBLE" then
        if map_Search1 ~= nil and map_Search2 ~= nil and map_Search3 ~= nil and map_Search4 ~= nil and map_Search5 ~= nil then
            if map_Search1 < 100 or map_Search2 < 100 or map_Search3 < 100 or map_Search4 < 100 or map_Search5 < 100 then
                return "YES"
            elseif map_Search1 >= 100 and map_Search2 >= 100 and map_Search3 >= 100 and map_Search4 >= 100 and map_Search5 >= 100 then
                return "YES"
            end
        end
    end
end

function SCR_UNDER67_HIDDENQ1_AREA1_ENTER(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    local sObj = GetSessionObject(pc, "SSN_UNDERFORTRESS67_HQ1")
    if quest_check == "PROGRESS" then
        if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
            ShowBalloonText(pc, "UNDER67_HIDDENQ1_LOCATION1", 5)
        end
    end
end

function SCR_UNDER67_HIDDENQ1_AREA2_ENTER(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    local sObj = GetSessionObject(pc, "SSN_UNDERFORTRESS67_HQ1")
    if quest_check == "PROGRESS" then
        if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
            ShowBalloonText(pc, "UNDER67_HIDDENQ1_LOCATION2", 5)
        end
    end
end

function SCR_UNDER67_HIDDENQ1_AREA3_ENTER(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    local sObj = GetSessionObject(pc, "SSN_UNDERFORTRESS67_HQ1")
    if quest_check == "PROGRESS" then
        if sObj.QuestInfoValue3 < sObj.QuestInfoMaxCount3 then
            ShowBalloonText(pc, "UNDER67_HIDDENQ1_LOCATION3", 5)
        end
    end
end

function SCR_UNDER67_HIDDENQ1_AREA4_ENTER(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    local sObj = GetSessionObject(pc, "SSN_UNDERFORTRESS67_HQ1")
    if quest_check == "PROGRESS" then
        if sObj.QuestInfoValue4 < sObj.QuestInfoMaxCount4 then
            ShowBalloonText(pc, "UNDER67_HIDDENQ1_LOCATION4", 5)
        end
    end
end

function SCR_UNDER67_HIDDENQ1_AREA5_ENTER(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "UNDERFORTRESS67_HQ1")
    local sObj = GetSessionObject(pc, "SSN_UNDERFORTRESS67_HQ1")
    if quest_check == "PROGRESS" then
        if sObj.QuestInfoValue5 < sObj.QuestInfoMaxCount5 then
            ShowBalloonText(pc, "UNDER67_HIDDENQ1_LOCATION5", 5)
        end
    end
end

function UNDER67_HIDDENQ1_COMP_FUNC(pc)
    local item1 = GetInvItemCount(pc, "UNDER67_HIDDENQ1_ITEM1")
    if item1 >=1 then
         RunZombieScript("TAKE_ITEM_TX", pc, "UNDER67_HIDDENQ1_ITEM1", item1, "Quest")
    else
        return
    end
end

--FLASH63_HQ1 condition check
function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_BORN_ENTER(self)
    self.NumArg1 = os.date('%H')
--    self.NumArg1 = os.date('%M')
end

function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_BORN_UPDATE(self)
--    self.NumArg1 = os.date('%S')
    self.NumArg1 = os.date('%H')
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 0 or self.NumArg1 == 10 or self.NumArg1 == 20 or self.NumArg1 == 23 then
--        if self.NumArg1 == 30 then
--            print(ScpArgMsg('Auto_Daeum_Jen_Taim_SeTing_HyeonJae_SiKan_:_'),math.floor(os.clock()/60))
            local mon = CREATE_NPC(self, 'npc_pilgrim_m_5', 754, 100, 39, nil, 'Neutral', 0, ScpArgMsg("FLASH63_HQ1_MSG1"), 'FLASH63_HQ1_NPC', 'FLASH63_HQ1_NPC_CHAT', 100, 1)
            AttachEffect(mon, "F_smoke072_sviolet", 1.3, "BOT")
            SetTacticsArgObject(self, mon)
            if mon ~= nil then
                self.NumArg1 = 0
                --print(self.NumArg1)
                CreateSessionObject(mon, 'SSN_SETTIME_KILL')
                SetTacticsArgObject(self, mon)
                local sObj_mon = GetSessionObject(mon, 'SSN_SETTIME_KILL')
                if sObj_mon ~= nil then
                    sObj_mon.Count = 3600
--                    print(ScpArgMsg('Auto_NPC_SaengSeong_120Cho_Dwi_SaLaJim_'),sObj_mon.Count)
                end
            end
        end
    end
end

function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_BORN_LEAVE(self)
end

function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_DEAD_ENTER(self)
end

function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_DEAD_UPDATE(self)
end

function SCR_MON_FLASH63_HQ1_NPC_TRIGGER_TS_DEAD_LEAVE(self)
end

function SCR_FLASH63_HQ1_NPC_CHAT_ENTER(self, pc)
    local quest_r = SCR_QUEST_CHECK(pc, "FLASH59_SQ_13")
    local Hquest_r = SCR_QUEST_CHECK(pc, "FLASH63_HQ1")
    if Hquest_r ~= "IMPOSSIBLE" then
        return
    elseif quest_r ~= "COMPLETE" then
        ChatLocal(self, pc, ScpArgMsg("FLASH63_HQ1_MSG2"), 5)
--        sleep(3000)
--        ChatLocal(self, pc, ScpArgMsg("FLASH63_HQ1_MSG3"), 3)
    elseif quest_r == "COMPLETE" then
        ChatLocal(self, pc, ScpArgMsg("FLASH63_HQ1_MSG3"), 5)
    end
end

function SCR_FLASH63_HQ1_NPC_DIALOG(self, pc)
    local quest_r = SCR_QUEST_CHECK(pc, "FLASH59_SQ_13")
    local Hquest_r = SCR_QUEST_CHECK(pc, "FLASH63_HQ1")
    local sObj = GetSessionObject(pc, "SSN_FLASH63_CONDI_CHECK") 
    if Hquest_r == "IMPOSSIBLE" and quest_r == "COMPLETE" then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_FLASH63_CONDI_CHECK")
        end
    end
    if Hquest_r ~= "IMPOSSIBLE" then
        COMMON_QUEST_HANDLER(self,pc)
    elseif quest_r == "COMPLETE" then
        local sel1 = ShowSelDlg(pc, 0, "FLASH63_HQ1_NPC_SEL_DLG1", ScpArgMsg("FLASH63_HQ1_MSG4"), ScpArgMsg("FLASH63_HQ1_MSG5"))
        if sel1 == 1 then
            local sel2 = ShowSelDlg(pc, 0, "FLASH63_HQ1_NPC_SEL_DLG2", ScpArgMsg("FLASH63_HQ1_MSG6"), ScpArgMsg("FLASH63_HQ1_MSG5"))
            if sel2 == 1 then
                ShowBalloonText(pc, "FLASH63_HQ1_NPC_DLG1", 1)
                local sObj = GetSessionObject(pc, "SSN_FLASH63_CONDI_CHECK") 
                if sObj ~= nil then
                   sObj.Goal1 = 1
                   return 0;
                end
            else
                return 0;
            end
        else
            return 0;
        end
        COMMON_QUEST_HANDLER(self,pc)
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function FLASH63_HQ1_AGREE_FUNC(self)
    local sObj = GetSessionObject(self, "SSN_FLASH63_CONDI_CHECK") 
    if sObj ~= nil then
        DestroySessionObject(self, sObj)
    end
end

--BRACKEN632_HQ1 condition check
function BRACKEN632_HQ1_UNLOCK_COUNT(self, quest_result, quest_check, _Step, _Goal, ssn, sObj)
    if quest_result == quest_check then
        if sObj == nil then
            CreateSessionObject(self, ssn)
            sObj = GetSessionObject(self, ssn)
        end
        if sObj ~= nil then
            if _Step ~= nil then
                sObj[_Step] = 1
                SaveSessionObject(self,sObj)
            elseif _Goal ~= nil then
                sObj[_Goal] = 1
                SaveSessionObject(self,sObj)
            end
        end
    end
end

--SIAULIAI16_HQ1 condition check
function SCR_SIAULIAI16_HQ1_SSN_CREATE_ENTER(self, pc)
    local result = SCR_QUEST_CHECK(pc, "SIAULIAI16_HQ1")
    if result == "IMPOSSIBLE" then
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI16_HQ1_UNLOCK1")
        if sObj == nil then
            CreateSessionObject(pc, "SSN_SIAULIAI16_HQ1_UNLOCK1")
        end
    end
end

function SCR_WOOD_CARVING_SESSION_DESTROY_LEAVE(self, pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI16_HQ1_UNLOCK1")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

function SIAUL16_HIDDENQ1_CARVING(self)
    if self.NumArg1 < 80 then
        local heal = math.floor(self.MHP/2)
        AddHP(self, heal)
        self.NumArg1 = self.NumArg1+ 1
    elseif self.NumArg1 >= 80 and self.NumArg1 < 120 then
        self.NumArg1 = self.NumArg1+ 1
    elseif self.NumArg1 >= 120 then
        self.NumArg1 = 0
    end
end

function SIAUL16_HIDDENQ1_CARVING_DEAD(self, pc)
    local Secret_Item = GetInvItemCount(pc, "SIAULIAI16_HIDDENQ1_ITEM1")
    local result = SCR_QUEST_CHECK(pc, "SIAULIAI16_HQ1")
    if result == "IMPOSSIBLE" then
        if Secret_Item < 1 then
            RunScript('GIVE_ITEM_TX', pc, 'SIAULIAI16_HIDDENQ1_ITEM1', 1, "Quest")
            local Ai_list, Ai_cnt = GetWorldObjectList(self, "MON", 200)
            if Ai_cnt > 0 then
                for i = 1, Ai_cnt do
                    if Ai_list[i].ClassName == "npc_HLD_sub_master" then
                        ChatLocal(Ai_list[i], pc, ScpArgMsg("SIAULIAI16_HIDDENQ1_MSG1"), 3)
                    end
                end
            end
        end
    end
end

function SIAULIAI16_HIDDENQ2_ABBANDON(self)
    local highlander_Item1 = GetInvItemCount(self, "SIAULIAI16_HIDDENQ1_ITEM3")
    --local highlander_Item2 = GetInvItemCount(self, "SIAULIAI16_HIDDENQ1_ITEM4")
    
    local highlander_temp1 = 0
--    local highlander_temp2 = 0
    
    if highlander_Item1 < 13 then
        highlander_temp1 = 13 - highlander_Item1
    end
    
--    if highlander_Item2 >= 1 then
--        highlander_temp2 = highlander_Item2
--    end
    
    if highlander_Item1 < 13 then --or highlander_Item2 >= 1
         RunZombieScript("GIVE_TAKE_ITEM_TX", self, "SIAULIAI16_HIDDENQ1_ITEM3/"..highlander_temp1, "Quest")
         --, "SIAULIAI16_HIDDENQ1_ITEM4/"..highlander_temp2
    else
        return
    end
end

--ORSHA_HQ2 condition check
function SCR_ORSHA_HIDDENQ2_IN_TRIGGER_ENTER(self,pc)
    local result = SCR_QUEST_CHECK(pc, "ORSHA_HQ2")
    if result == "IMPOSSIBLE" then
    local sObj = GetSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
        if sObj == nil then
            CreateSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
        end
    end
    
    local list = GetSummonedPetList(pc);
	for i = 1 , #list do
		local pet = list[i];
        if pet.Lv >= 300 then --300
            local sObj = GetSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
            sObj.Step1 = 1
            break;
        end
    end
end

function ORSHA_HIDDENQ3_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_ORSHA_HQ2_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

function ORSHA_HIDDENQ2_ABBANDON(self)
    local item1 = GetInvItemCount(self, "ORSHA_HIDDENQ2_ITEM2")
    local item2 = GetInvItemCount(self, "ORSHA_HIDDENQ2_ITEM3")
    
    RunZombieScript("GIVE_TAKE_ITEM_TX", self, nil, "ORSHA_HIDDENQ2_ITEM2/"..item1.."/ORSHA_HIDDENQ2_ITEM3/"..item2, "QUEST")
end

function ORSHA_HIDDENQ3_ABBANDON(self)
    local item1 = GetInvItemCount(self, "ORSHA_HIDDENQ3_ITEM1")
    if item1 < 1 then
        RunZombieScript("GIVE_TAKE_ITEM_TX", self, "ORSHA_HIDDENQ3_ITEM1/1", nil, "QUEST")
    end
end

--TABLELAND28_1_HQ1 condition check
function SCR_BRACKEN632_HIDDEN_OBJ1_IN_ENTER(self, pc)
    if isHideNPC(pc, "BRACKEN632_HIDDEN_OBJ1") == "NO" then
        ShowBalloonText(pc, "BRACKEN632_HIDDEN_OBJ_MSG", 5)
    end
end

function SCR_BRACKEN632_HIDDEN_OBJ1_DIALOG(self, pc)
    local Item = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM1")
    if Item < 1 then
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("TABLELAND281_HIDDENQ1_MSG8"), '#SITGROPESET', 2.5)
        if result1 == 1 then
            if Item < 1 then
                RunScript("GIVE_ITEM_TX", pc, "TABLELAND281_HIDDENQ1_ITEM1", 1, "HiddenQuest")
                HideNPC(pc, "BRACKEN632_HIDDEN_OBJ1")
            end
        end
    end
end

function TABLELAND281_HIDDENQ1_DOG_AI_UPDATE(self)
    local pc_owner = GetOwner(self)
    if GetLayer(self) == 0 then
        local result = SCR_QUEST_CHECK(pc_owner,'TABLELAND28_1_HQ1')
        if result == 'PROGRESS' then
            if GetZoneName(self) == "f_orchard_32_3" then
                if self.NumArg1 < 20 then
                    local x, y, z = GetPos(self)
                    local range = SCR_POINT_DISTANCE(x, z, -1552, 915)
                    if range <= 10 then
                        StopMove(self)
                        PlayAnim(self, "bark", 1)
                        self.NumArg1 = self.NumArg1 + 1
                        self.NumArg2 = 1
                    else
                        MoveEx(self, -1552, 0, 915, 1)
                        self.NumArg1 = self.NumArg1 + 1
                    end
                else
                    StopMove(self)
                    Dead(self)
                end
            elseif GetZoneName(self) == "f_pilgrimroad_51" then
                if self.NumArg1 < 20 then
                    local x, y, z = GetPos(self)
                    local range = SCR_POINT_DISTANCE(x, z, 1613, 732)
                    if range <= 10 then
                        StopMove(self)
                        PlayAnim(self, "bark", 1)
                        self.NumArg1 = self.NumArg1 + 1
                        self.NumArg2 = 1
                    else
                        MoveEx(self, 1613, 400, 732, 1)
                        self.NumArg1 = self.NumArg1 + 1
                    end
                else
                    StopMove(self)
                    Dead(self)
                end
            elseif GetZoneName(self) == "f_flash_58" then
                if self.NumArg1 < 20 then
                    local x, y, z = GetPos(self)
                    local range = SCR_POINT_DISTANCE(x, z, 2080, 6)
                    if range <= 10 then
                        StopMove(self)
                        PlayAnim(self, "bark", 1)
                        self.NumArg1 = self.NumArg1 + 1
                        self.NumArg2 = 1
                    else
                        MoveEx(self, 2080, 234, 6, 1)
                        self.NumArg1 = self.NumArg1 + 1
                    end
                else
                    StopMove(self)
                    Dead(self)
                end
            end
        end
    end
end

function TABLELAND281_HIDDENQ1_DOG_AI_DEAD(self)
    local pc_owner = GetOwner(self)
    if pc_owner ~= nil then
        local result = SCR_QUEST_CHECK(pc_owner, 'TABLELAND28_1_HQ1')
        if result == "IMPOSSIBLE" or result == "POSSIBLE" or result == "COMPLETE" then
            Kill(self)
        end
        return 0
    elseif pc_owner == nil then
        Kill(self)
    elseif GetZoneName(Pc_Owner) == 'f_orchard_32_3' and GetZoneName(self) == "f_pilgrimroad_51" and  GetZoneName(self) == "f_flash_58" then
       return 1
    else
        Kill(self)
    end
    return 1
end

function TABLE281_HIDDENQ1_MSG_ON(self)
    local owner_Pc = GetOwner(self)
    if self.NumArg2 == 1 then
        if self.NumArg3 < 1 then
            SendAddOnMsg(owner_Pc, "NOTICE_Dm_scroll", ScpArgMsg("TABLELAND281_HIDDENQ1_MSG4"), 5)
            self.NumArg3 = 1
        end
    end
end

function SCR_ORCHARD323_HIDDEN_OBJ2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "TABLELAND28_1_HQ1")
    local sObj = GetSessionObject(pc, "SSN_TABLELAND28_1_HQ1")
    if quest == "PROGRESS" then
        local Item = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM2")
        if Item < 1 then
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("TABLELAND281_HIDDENQ1_MSG2"), '#SITGROPESET', 2.5)
            if result1 == 1 then
                if Item < 1 then
                    if sObj ~= nil then
                        if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                            RunScript("GIVE_ITEM_TX", pc, "TABLELAND281_HIDDENQ1_ITEM2", 1, "HiddenQuest")
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                            SaveSessionObject(pc, sObj)
                    	    if isHideNPC(pc, "ORCHARD323_HIDDEN_OBJ2") == "NO" then
                    	        if IsBuffApplied(pc, "TABLE281_HIDDENQ1_BUFF1") == "NO" then
                    	            RemoveBuff(pc, "TABLE281_HIDDENQ1_BUFF1")
                    	        end
                    	    end
                            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("TABLELAND281_HIDDENQ1_MSG3"), 5)
                            HideNPC(pc, "ORCHARD323_HIDDEN_OBJ2")
                            UnHideNPC(pc, "PILGRIM51_HIDDEN_OBJ3")
                        end
                    end
                end
            end
        end
    end
end

function TABLE281_HIDDENQ1_COM(self)
    local Item1 = GetInvItemCount(self, "TABLELAND281_HIDDENQ1_ITEM1")
    local Item2 = GetInvItemCount(self, "TABLELAND281_HIDDENQ1_ITEM5")
    local Item3 = GetInvItemCount(self, "TABLELAND281_HIDDENQ1_ITEM6")
    if Item1 >= 1 or Item2 >= 1 or Item3 >= 1 then
        RunZombieScript("GIVE_TAKE_ITEM_TX", self, nil, "TABLELAND281_HIDDENQ1_ITEM1/"..Item1.."/TABLELAND281_HIDDENQ1_ITEM5/"..Item2.."/TABLELAND281_HIDDENQ1_ITEM6/"..Item3, "Quest")
    end
    local sObj = GetSessionObject(self, "SSN_TABLELAND28_1_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(self, sObj)
    end
end

function SCR_PILGRIM51_HIDDEN_OBJ3_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "TABLELAND28_1_HQ1")
    local sObj = GetSessionObject(pc, "SSN_TABLELAND28_1_HQ1")
    if quest == "PROGRESS" then
        local Item = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM3")
        if Item < 1 then
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("TABLELAND281_HIDDENQ1_MSG2"), '#SITGROPESET', 2.5)
            if result1 == 1 then
                if Item < 1 then
                    if sObj ~= nil then
                        if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                            RunScript("GIVE_ITEM_TX", pc, "TABLELAND281_HIDDENQ1_ITEM3", 1, "HiddenQuest")
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                            SaveSessionObject(pc, sObj)
                    	    if isHideNPC(pc, "PILGRIM51_HIDDEN_OBJ3") == "NO" then
                    	        if IsBuffApplied(pc, "TABLE281_HIDDENQ1_BUFF2") == "NO" then
                    	            RemoveBuff(pc, "TABLE281_HIDDENQ1_BUFF2")
                    	        end
                    	    end
                            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("TABLELAND281_HIDDENQ1_MSG3"), 5)
                            HideNPC(pc, "PILGRIM51_HIDDEN_OBJ3")
                            UnHideNPC(pc, "FLASH58_HIDDEN_OBJ4")
                        end
                    end
                end
            end
        end
    end
end

function SCR_FLASH58_HIDDEN_OBJ4_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "TABLELAND28_1_HQ1")
    local sObj = GetSessionObject(pc, "SSN_TABLELAND28_1_HQ1")
    if quest == "PROGRESS" then
        local Item = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM4")
        if Item < 1 then
            local result1 = DOTIMEACTION_R(pc, ScpArgMsg("TABLELAND281_HIDDENQ1_MSG2"), '#SITGROPESET', 2.5)
            if result1 == 1 then
                if Item < 1 then
                    if sObj ~= nil then
                        if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                            RunScript("GIVE_ITEM_TX", pc, "TABLELAND281_HIDDENQ1_ITEM4", 1, "HiddenQuest")
                            sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                            SaveSessionObject(pc, sObj)
                    	    if isHideNPC(pc, "FLASH58_HIDDEN_OBJ4") == "NO" then
                    	        if IsBuffApplied(pc, "TABLE281_HIDDENQ1_BUFF3") == "NO" then
                    	            RemoveBuff(pc, "TABLE281_HIDDENQ1_BUFF3")
                    	        end
                    	    end
                            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("TABLELAND281_HIDDENQ1_MSG3"), 5)
                            HideNPC(pc, "FLASH58_HIDDEN_OBJ4")
                        end
                    end
                end
            end
        end
    end
end

function TABLELAND28_1_HIDDENQ1_ABBANDON(pc)
--    local Item1 = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM2")
--    local Item2 = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM3")
--    local Item3 = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM4")
--    
--    if Item1 >= 1 or Item2 >= 1 or Item3 >= 1 then
--         RunZombieScript("GIVE_TAKE_ITEM_TX", pc, nil, "TABLELAND281_HIDDENQ1_ITEM2/"..Item1.."/TABLELAND281_HIDDENQ1_ITEM3/"..Item2.."/TABLELAND281_HIDDENQ1_ITEM4/"..Item3 , "Quest")
--    else
--        return
--    end

--    local Item1 = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM5")
--    local Item2 = GetInvItemCount(pc, "TABLELAND281_HIDDENQ1_ITEM6")
--    print(Item1, Item2)
--    if Item1 >= 1 or Item2 >= 1 then
--        RunScript("GIVE_TAKE_ITEM_TX", pc, nil, "TABLELAND281_HIDDENQ1_ITEM5/"..Item1.."/TABLELAND281_HIDDENQ1_ITEM6/"..Item2, "Quest")
--    end
    
    HideNPC(pc, "ORCHARD323_HIDDEN_OBJ2")
    HideNPC(pc, "PILGRIM51_HIDDEN_OBJ3")
    HideNPC(pc, "FLASH58_HIDDEN_OBJ4")
end

--FLASH64_HQ1 condition check
function MURMILO_MASTER_PRE_CHECK_DIALOG(self,pc)
    local sObj = GetSessionObject(pc, "SSN_FLASH64_HQ1_UNLOCK")
    local quest_check = SCR_QUEST_CHECK(pc, "FLASH64_HQ1")
    local ran = IMCRandom(1, 10)
    if sObj ~= nil then
        if quest_check == "IMPOSSIBLE" then
            if ran >= 8 then
                --ShowBalloonText(pc, "FLASH64_HIDDENQ1_DLG2", 3)
                return "YES"
            end
        end
    end
end

function FLASH64_HIDDENQ1_FUNC(self)
    local sObj = GetSessionObject(self, "SSN_FLASH64_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(self, sObj)
    end
end


--CASTLE65_3_HQ1 condition check
function CASTLE65_3_HIDDENQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_CASTLE65_3_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--UNDERFORTRESS69_HQ1 condition check
function UNDER69_HIDDENQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_UNDER69_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--SIAULIAI15_HQ1 condition check
function SIAULIAI17_HIDDENTQ1_DLG_CHECK(self, pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI15_HQ1_UNLOCK")
    local quest_check = SCR_QUEST_CHECK(pc, "SIAULIAI15_HQ1")
    local ran = IMCRandom(1, 10)
    if ran >= 7 then
        if quest_check == "IMPOSSIBLE" then
            if sObj == nil then
                CreateSessionObject(pc, "SSN_SIAULIAI15_HQ1_UNLOCK")
                return "YES"
            else
                return "YES"
            end
        end
    end
end

function SIAULIAI15_HIDDENTQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI15_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--KATYN12_HQ1 condition check
function KATYN12_HIDDENQ1_AI_DEAD(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "KATYN12_HQ1")
    if quest == "IMPOSSIBLE" then
        local item = GetInvItemCount(pc, "KATYN12_HIDDENQ1_ITEM")
        if item < 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "KATYN12_HIDDENQ1_ITEM", 1, "Quest")
        end
    end
end

function SCR_KATYN12_HQ1_NPC_DIALOG(self, pc)
    local item = GetInvItemCount(pc, "KATYN12_HIDDENQ1_ITEM")
    if item < 1 then
        ShowBalloonText(pc, "KATYN12_HIDDENQ1_MSG1")
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_KATYN12_HQ1_IN_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_KATYN12_HQ1_UNLOCK")
    local Quest1 = SCR_QUEST_CHECK(pc, "KATYN12_HQ1")
    local Quest2 = SCR_QUEST_CHECK(pc, "KATYN_12_MQ_10")
    if (Quest1 == "IMPOSSIBLE" or Quest1 == "POSSIBLE") and Quest2 == "COMPLETE" then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_KATYN12_HQ1_UNLOCK")
        end
    end
end

function SCR_KATYN12_HQ1_OUT_LEAVE(self, pc)
    local sObj = GetSessionObject(pc, "SSN_KATYN12_HQ1_UNLOCK")
    local Quest = SCR_QUEST_CHECK(pc, "KATYN12_HQ1")
    if Quest == "IMPOSSIBLE" then
        if sObj ~= nil then
            DestroySessionObject(pc, sObj)
        end
        if isHideNPC(pc, "KATYN12_HQ1_NPC") == "NO" then
            HideNPC(pc, "KATYN12_HQ1_NPC")
        end
    end
end

function KATYN12_HIDDENQ1_AI_CREATE(self)
    local follower = GetScpObjectList(self, 'KATYN12_HIDDENQ1_AI_OBJ')
    if #follower == 0 then
        sleep(1000)
        if IS_PC(self) == true then
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', 1845, 250, 387, GetDirectionByAngle(self), 'Neutral', 280, KATYN12_HIDDENQ1_AIFUNC);
            SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'BRACKEN431_NPC_AI_OBJ', 1);
            AddScpObjectList(self, 'KATYN12_HIDDENQ1_AI_OBJ', mon)
            AddBuff(mon, mon, "HPLock", 5, 0, 0, 1)
            SetOwner(mon, self, 0)
            EnableAIOutOfPC(mon)
            AddVisiblePC(mon, self, 1)
            AttachEffect(mon, "F_light055_orange", 1.3, "MID")
        end
    end
end

function KATYN12_HIDDENQ1_AI_RECREATE(self, sObj, msg, argObj, argStr, argNum)
    local follower = GetScpObjectList(self, 'KATYN12_HIDDENQ1_AI_OBJ')
    if #follower == 0 then
        sleep(1000)
        if IS_PC(self) == true then
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', 1845, 250, 387, GetDirectionByAngle(self), 'Neutral', 280, KATYN12_HIDDENQ1_AIFUNC);
            SET_NPC_BELONGS_TO_PC_LOCAL(mon, self, 'BRACKEN431_NPC_AI_OBJ', 1);
            AddScpObjectList(self, 'KATYN12_HIDDENQ1_AI_OBJ', mon)
            AddBuff(mon, mon, "HPLock", 5, 0, 0, 1)
            SetOwner(mon, self, 0)
            EnableAIOutOfPC(mon)
            AddVisiblePC(mon, self, 1)
            AttachEffect(mon, "F_light055_orange", 1.3, "MID")
        end
    end
end

function KATYN12_HIDDENQ1_AIFUNC(mon)
    mon.Tactics = 'None'
    mon.BTree = 'None'
    mon.SimpleAI = 'KATYN12_HIDDENQ1_NPC'
    mon.Name = ScpArgMsg("KATYN12_HIDDENQ2_MSG1")
    mon.WlkMSPD = 80
end

function KATYN12_HIDDENQ1_NPC_KILLNPC(self)
    local pc_owner = GetOwner(self)
    if pc_owner ~= nil then
        local result = SCR_QUEST_CHECK(pc_owner, 'KATYN12_HQ1')
        if result == "IMPOSSIBLE" or result == "POSSIBLE" or result == "SUCCESS" or result == "COMPLETE" then
            StopMove(self)
            DetachEffect(self, "F_light055_orange")
            Kill(self)
        end
        return 0
    elseif GetZoneName(Pc_Owner) ~= 'f_katyn_12' then
        StopMove(self)
        DetachEffect(self, "F_light055_orange")
        Kill(self)
    elseif pc_owner == nil then
        StopMove(self)
        DetachEffect(self, "F_light055_orange")
        Kill(self)
    end
    return 1
end

function KATYN12_HIDDENQ1_NPC_UPDATE(self)
    local x, y, z = GetPos(self)
    local dist = SCR_POINT_DISTANCE(x, z, 1196, 736)
    if dist <= 35 then
        if self.NumArg1 < 1 then
            local Owner_pc = GetOwner(self)
            local quest_ssn = GetSessionObject(Owner_pc, 'SSN_KATYN12_HQ1', 1)
            if quest_ssn ~= nil then
                if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
                    self.NumArg1 = 1
                    quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoMaxCount1
                    SaveSessionObject(Owner_pc, quest_ssn)
                    SendAddOnMsg(Owner_pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_yeongHoneul_Bueongi_JoKagSangeKe_inDoHaessSeupNiDa!"), 5);
                end
            end
            RunScript('KATYN12_HQ1_NPC_CALL_DEAD', self)
        end
    end
end

function KATYN12_HQ1_NPC_CALL_DEAD(self)
    --Chat(self, ScpArgMsg('Auto_inDoHae_JuSyeoSeo_KamSaHapNiDa...'))
    sleep(1000)
    PlayEffect(self, 'F_buff_basic025_white_line', 1, "BOT")
    Dead(self)
end


function KATYN12_HIDDENQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_KATYN12_HQ1_UNLOCK") 
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--PRISON62_2_HQ1 condition check
function SCR_PRISON622_HIDDEN_OBJ1_IN_ENTER(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PRISON62_2_HQ1")
    if quest == "IMPOSSIBLE" then
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK") 
    if sObj == nil then
        CreateSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    end
--    elseif quest == "COMPLETE" then
--        local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK") 
--        if sObj ~= nil then
--            DestroySessionObject(pc, sObj)
--        end
    end
end

function SCR_PRISON622_HIDDEN_OBJ1_DIALOG(self, pc)
    ShowBookItem(pc, "PRISON622_HIDDEN_OBJ1");
    if isHideNPC(pc, "PRISON622_HIDDEN_OBJ2") == "YES" then
        UnHideNPC(pc, "PRISON622_HIDDEN_OBJ2")
    end
    SCR_BOOK_GET(self, pc, "PRISON622_HIDDENQ1_ITEM1", 1)
end

function SCR_PRISON622_HIDDEN_OBJ2_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward1 = sObj.Goal1
    ShowBookItem(pc, "PRISON622_HIDDEN_OBJ1_"..passward1);
    if isHideNPC(pc, "PRISON622_HIDDEN_OBJ3") == "YES" then
        UnHideNPC(pc, "PRISON622_HIDDEN_OBJ3")
    end
    SCR_BOOK_GET(self, pc, "PRISON622_HIDDENQ1_ITEM2", 1)
end

function SCR_PRISON622_HIDDEN_OBJ3_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward2 = sObj.Goal2
    ShowBookItem(pc, "PRISON622_HIDDEN_OBJ2_"..passward2);
    if isHideNPC(pc, "PRISON622_HIDDEN_OBJ4") == "YES" then
        UnHideNPC(pc, "PRISON622_HIDDEN_OBJ4")
    end
    SCR_BOOK_GET(self, pc, "PRISON622_HIDDENQ1_ITEM3", 1)
end

function SCR_PRISON622_HIDDEN_OBJ4_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward3 = sObj.Goal3
    ShowBookItem(pc, "PRISON622_HIDDEN_OBJ3_"..passward3);
    if isHideNPC(pc, "PRISON622_HIDDEN_OBJ5") == "YES" then
        UnHideNPC(pc, "PRISON622_HIDDEN_OBJ5")
    end
    SCR_BOOK_GET(self, pc, "PRISON622_HIDDENQ1_ITEM4", 1)
end

function SCR_PRISON622_HIDDEN_OBJ5_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PRISON62_2_HQ1_UNLOCK")
    local passward4 = sObj.Goal4
    ShowBookItem(pc, "PRISON622_HIDDEN_OBJ4_"..passward4);
    if isHideNPC(pc, "PRISON622_HIDDEN_OBJ6") == "YES" then
        UnHideNPC(pc, "PRISON622_HIDDEN_OBJ6")
    end
    sObj.Goal5 = 1
    SaveSessionObject(pc, sObj)
    SCR_BOOK_GET(self, pc, "PRISON622_HIDDENQ1_ITEM5", 1)
end

function SCR_PRISON622_HIDDEN_OBJ6_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PRISON622_HQ1_CHANGE_STATE(self)
    local sObj = GetSessionObject(self, "SSN_PRISON62_2_HQ1_UNLOCK")
    if sObj ~= nil then
        local item1 = GetInvItemCount(self, "PRISON622_HIDDENQ1_ITEM1")
        local item2 = GetInvItemCount(self, "PRISON622_HIDDENQ1_ITEM2")
        local item3 = GetInvItemCount(self, "PRISON622_HIDDENQ1_ITEM3")
        local item4 = GetInvItemCount(self, "PRISON622_HIDDENQ1_ITEM4")
        local item5 = GetInvItemCount(self, "PRISON622_HIDDENQ1_ITEM5")
        if item1 >= 1 and item2 >= 1 and item3 >= 1 and item4 >= 1 and item5 >= 1 then
            local quest = SCR_QUEST_CHECK(self, "PRISON62_2_HQ1")
            if quest == "IMPOSSIBLE" then
                if sObj.Goal5 < 1 then
                    sObj.Goal5 = 1
                    SaveSessionObject(self, sObj)
                    print("PRISON62_2_HQ1 is Able")
                end
                if isHideNPC(self, "PRISON622_HIDDEN_OBJ6") == "YES" then
                    UnHideNPC(self, "PRISON622_HIDDEN_OBJ6")
                    print("PRISON622_HIDDEN_OBJ6 is unhide")
                end
            end
        end
    end
end

--F3CMLAKE83_HQ1 condition check
function SCR_F3CMLAKE83_HIDDEN_PRECHECK_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM1")
    if quest == "IMPOSSIBLE" then
        if item < 1 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM1", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_PRECHECK")
            end
        end
    end
end

function SCR_F3CMLAKE83_HIDDEN_OBJ1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('F3CMLAKE83_HIDDENQ2_MSG2'), 3);
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_OBJ1")
            end
        end
    end
end

function SCR_F3CMLAKE83_HIDDEN_OBJ2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('F3CMLAKE83_HIDDENQ2_MSG2'), 3);
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_OBJ2")
            end
        end
    end
end

function SCR_F3CMLAKE83_HIDDEN_OBJ3_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('F3CMLAKE83_HIDDENQ2_MSG2'), 3);
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_OBJ3")
            end
        end
    end
end

function SCR_F3CMLAKE83_HIDDEN_OBJ4_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('F3CMLAKE83_HIDDENQ2_MSG2'), 3);
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_OBJ4")
            end
        end
    end
end

function SCR_F3CMLAKE83_HIDDEN_OBJ5_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "F3CMLAKE83_HQ1")
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("F3CMLAKE83_HIDDENQ2_MSG1"), '#SITGROPESET', 3)
            if result == 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg('F3CMLAKE83_HIDDENQ2_MSG2'), 3);
                RunZombieScript("GIVE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", 1, "QUEST")
                HideNPC(pc, "F3CMLAKE83_HIDDEN_OBJ5")
            end
        end
    end
end

function F3CMLAKE83_HIDDENQ1_ABBANDON(pc)
    local item = GetInvItemCount(pc, "F3CMLAKE83_HIDDENQ1_ITEM2")
    if item >= 1 then
        RunZombieScript("TAKE_ITEM_TX", pc, "F3CMLAKE83_HIDDENQ1_ITEM2", item, "QUEST")
    end
end

--CATACOMB33_2_HQ1 condition check
function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_BORN_ENTER(self)
    self.NumArg1 = os.date('%H')
--    self.NumArg1 = os.date('%M')
end

function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_BORN_UPDATE(self)
--    self.NumArg1 = os.date('%S')
    self.NumArg1 = os.date('%H')
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 7 or self.NumArg1 == 14 or self.NumArg1 == 21 then
        --if self.NumArg1 == 30 then
            --print(ScpArgMsg('Auto_Daeum_Jen_Taim_SeTing_HyeonJae_SiKan_:_'),math.floor(os.clock()/60))
            local pc_list, cnt = SelectObject(self, 80, "ALL")
            if cnt >= 1 then
                for i = 1, cnt do
                    if pc_list[i].ClassName == "PC" then
                        local quest1 = SCR_QUEST_CHECK(pc_list[i], "CATACOMB_33_2_SQ_09")
                        local quest2 = SCR_QUEST_CHECK(pc_list[i], "CATACOMB33_2_HQ1")
                        if quest1 == "COMPLETE" and quest2 == "POSSIBLE" then
                            local mon = CREATE_NPC(self, 'Hiddennpc_move', 732, 221, 1117, nil, 'Neutral', 0, ScpArgMsg("CATACOMB332_HQ1_NPC_NAME"), 'CATACOMB332_HQ1_NPC', nil, 100, 1, nil, "CATACOMB332_HQ1_NPC_AI")
                            PlayEffectLocal(mon, pc_list[i], "F_light018_yellow", 1.3, "MID")
                            SetTacticsArgObject(self, mon)
                            AddVisiblePC(mon, pc_list[i], 1);
                            if mon ~= nil then
                                self.NumArg1 = 0
                                --print(self.NumArg1)
                                CreateSessionObject(mon, 'SSN_SETTIME_KILL')
                                SetTacticsArgObject(self, mon)
                                local sObj_mon = GetSessionObject(mon, 'SSN_SETTIME_KILL')
                                if sObj_mon ~= nil then
                                    sObj_mon.Count = 3600
                                    --print(ScpArgMsg('Auto_NPC_SaengSeong_120Cho_Dwi_SaLaJim_'),sObj_mon.Count)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    HOLD_MON_SCP(self, 1000);
end

function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_BORN_LEAVE(self)
end

function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_DEAD_ENTER(self)
end

function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_DEAD_UPDATE(self)
end

function SCR_CATACOMB332_HQ1_NPC_TRIGGER_TS_DEAD_LEAVE(self)
end


function SCR_CATACOMB332_HQ1_NPC_AI_TS_BORN_ENTER(self)
    AttachEffect(self, "F_light055_orange", 1.3, "MID")
end

function SCR_CATACOMB332_HQ1_NPC_AI_TS_BORN_UPDATE(self)
end

function SCR_CATACOMB332_HQ1_NPC_AI_TS_BORN_LEAVE(self)
end

function SCR_CATACOMB332_HQ1_NPC_AI_TS_DEAD_ENTER(self)
end

function SCR_CATACOMB332_HQ1_NPC_AI_TS_DEAD_UPDATE(self)
    DetachEffect(self, "F_light055_orange")
end

function SCR_CATACOMB332_HQ1_NPC_AI_TRIGGER_TS_DEAD_LEAVE(self)
end


function SCR_CATACOMB332_HQ1_NPC_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATACOMB33_2_HQ1")
    if quest == "PROGRESS" then
        ShowOkDlg(pc, "CATACOMB332_HQ1_NPC_DLG1", 1)
    else
        COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_CATACOMB332_HIDDENQ1_NPC1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATACOMB33_2_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CATACOMB332_HIDDENQ1_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "CATACOMB332_HIDDENQ1_ITEM1", 1, "QUEST")
            SendAddOnMsg(pc,"NOTICE_Dm_GetItem", ScpArgMsg("CATACOMB332_HIDDENQ1_MSG2"), 3)
        end
    end
end

function SCR_CATACOMB332_HIDDENQ1_NPC2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATACOMB33_2_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CATACOMB332_HIDDENQ1_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc,"NOTICE_Dm_scroll", ScpArgMsg("CATACOMB332_HIDDENQ1_MSG3"), 3)
        end
    end
end

function SCR_CATACOMB332_HIDDENQ1_NPC3_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATACOMB33_2_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CATACOMB332_HIDDENQ1_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc,"NOTICE_Dm_scroll", ScpArgMsg("CATACOMB332_HIDDENQ1_MSG3"), 3)
        end
    end
end

--ORCHARD32_3_HQ1 condition check
function ORCHARD323_HIDDENQ1_AI_DEAD(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "ORCHARD32_3_HQ1")
    if quest == "IMPOSSIBLE" then
        local item = GetInvItemCount(pc, "ORCHARD323_HIDDENQ1_ITEM")
        if item < 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "ORCHARD323_HIDDENQ1_ITEM", 1, "Quest")
        end
    end
end

function ORCHARD323_HIDDENQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_ORCHARD323_HQ1_UNLOCK") 
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--ABBEY64_2_HQ1 condition check
function SCR_ABBEY64_2_HIDDENQ2_OBJ1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "ABBEY64_2_HQ2")
    if quest == "PROGRESS" then
        COMMON_QUEST_HANDLER(self,pc)
    elseif quest == "SUCCESS" or quesr == "COMPLETE" then
        ShowOkDlg(pc, "ABBEY64_2_MEMORY", 1)
    end
end

function SCR_ABBEY64_2_HIDDENQ2_OBJ2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE1_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 1)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE2_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 2)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE3_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 3)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE4_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 4)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE5_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 5)
end

function SCR_ABBEY64_2_HIDDENQ2_STONE6_DIALOG(self, pc)
    SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, 6)
end

function SCR_ABBAY642_HIDDENQ1_STONE_SERCH(self, pc, num)
    local Quest= SCR_QUEST_CHECK(pc, "ABBEY64_2_HQ1")
    if Quest == "PROGRESS" then
        local result2 = DOTIMEACTION_R(pc, ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG5"), '#SITGROPESET', 3)
        if result2 == 1 then
            local sObj = GetSessionObject(pc, "SSN_ABBEY64_2_HQ1")
            if num == sObj['Step'..sObj.Step7+1] then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    RunZombieScript('GIVE_ITEM_TX', pc, 'ABBAY642_HIDDENQ1_ITEM', 1, "Quest")
                    sObj.QuestInfoValue1 = sObj.QuestInfoMaxCount1
                    SaveSessionObject(pc, sObj)
                    HideNPC(pc, 'ABBEY64_2_HIDDENQ2_STONE_'..num)
                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG8"), 5);
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("ABBEY64_2_HIDDENQ1_MSG7"), 5);
            end
        end
    end
end

function SCR_ABBAY642_HIDDENQ1_ABBANDON(self)
--    local Item = GetInvItemCount(self, "ABBAY642_HIDDENQ1_ITEM")
--    if Item >= 1 then
--        RunZombieScript('TAKE_ITEM_TX', pc, 'ABBAY642_HIDDENQ1_ITEM', 1, "Quest")
--    end
    for i = 1, 6 do
        if isHideNPC(self, 'ABBEY64_2_HIDDENQ2_STONE_'..i) == 'YES' then
            UnHideNPC(self, 'ABBEY64_2_HIDDENQ2_STONE_'..i)
        end
    end
end


--PILGRIM31_3_HQ1 condition check
function PILGRIM31_3_HIDDENQ1_PREDLG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM313_HQ1_UNLOCK")
    local quest_check1 = SCR_QUEST_CHECK(pc, "PILGRIM313_SQ_07")
    local quest_check2 = SCR_QUEST_CHECK(pc, "PILGRIM31_3_HQ1")
    local ran = IMCRandom(1, 10)
    if ran >= 10 then
        if quest_check1 == "COMPLETE" and quest_check2 == "IMPOSSIBLE" then
            if sObj == nil then
--            print(quest_check1, quest_check2)
                CreateSessionObject(pc, "SSN_PILGRIM313_HQ1_UNLOCK")
                return "YES"
            else
                return "YES"
            end
        end
    end
end

function PILGRIM31_3_HIDDENQ1_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM313_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end


--PILGRIMROAD362_HQ1 condition check
function SCR_PILGRIMROAD362_HIDDEN_TABLE_DIALOG(self, pc)
    local item = GetInvItemCount(pc, "misc_0158")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ1_UNLOCK")
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ1")
    if quest == "IMPOSSIBLE" then
        if sObj == nil then
            CreateSessionObject(pc, "SSN_PILGRIMROAD362_HQ1_UNLOCK")
            ShowBalloonText(pc, "PILGRIMROAD362_TABLE_MSG3", 5)
            return
        elseif sObj ~= nil then
            if sObj.Step1 < 5 then
                if item > 0 then
                    local sel = ShowSelDlg(pc, 1, "PILGRIMROAD362_TABLE_MSG1", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG1"), ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG2"))
                    if sel == 1 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG6"), 'BURY', 1.5)
                        if result == 1 then
                            RunScript("TAKE_ITEM_TX", pc, "misc_0158", 1, "PILGRIMROAD362_HQ1_PRE")
                            ShowBalloonText(pc, "PILGRIMROAD362_TABLE_MSG2", 5)
                            PlayEffectLocal(self, pc, "F_light013", 2, 1, "BOT")
                            local x, y, z = GetPos(self)
                            sObj.Step1 = sObj.Step1 + 1
                            --sObj.Step1 = 0 --TEST TYPE
                            if sObj.Step1 == 5 then
                                ShowBalloonText(pc, "PILGRIMROAD362_TABLE_MSG4", 5)
                                PlayEffectLocal(self, pc, "F_light069_red", 2, 1, "TOP")
                            end
                        end
                    else
                        return
                    end
                else
                    ShowBalloonText(pc, "PILGRIMROAD362_TABLE_MSG1", 5)
                end
            else
                local sel = ShowSelDlg(pc, 1, "PILGRIMROAD362_TABLE_MSG5", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG3"), ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG2"))
                if sel == 1 then
                    local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG5"), 'write', 3)
                    if result == 1 then
                        RunScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM1", 1, "PILGRIMROAD362_HQ1_PRE")
                        SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG4"), 5)
                        --print("PILGRIMROAD362_HIDDENQ1_OPEN")
                        sObj.Goal1 =  1
                        SaveSessionObject(pc, sObj)
                    end
                end
            end
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ1")
            sObj.Goal1 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ2")
            sObj.Goal2 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ3_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ3")
            sObj.Goal3 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ4_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ4")
            sObj.Goal4 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ5_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ5")
            sObj.Goal5 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIMROAD362_HIDDEN_OBJ6_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "PILGRIMROAD362_HQ3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ3")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG11"), '#SITGROPESET', 3)
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("PILGRIMROAD362_HIDDEN_MSG7"), 2)
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIMROAD362_HIDDENQ1_ITEM4",1 , "QUEST")
            HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ6")
            sObj.Goal6 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function PILGRIMROAD362_HIDDENQ1_ABBANDON(pc)
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ1")
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ2")
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ3")
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ4")
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ5")
    HideNPC(pc, "PILGRIMROAD362_HIDDEN_OBJ6")
end

function PILGRIM362_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIMROAD362_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--PILGRIM48_HQ1 condition check
function SCR_PILGRIM48_HIDDEN_OBJ1_DIALOG(self, pc)
    local item = GetInvItemCount(pc, "PILGRIM48_HIDDENQ1_PREITEM1")
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    if sObj == nil then
        CreateSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    end
    if item < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_PREITEM1", 1, "PILGRIMROAD48_HQ1_PRE")
            ShowBalloonText(pc, "PILGRIM48_GETITEM_MSG1", 5)
            HideNPC(pc, "PILGRIM48_HIDDEN_OBJ1")
        end
    end
end

function SCR_PILGRIM48_HIDDEN_OBJ2_DIALOG(self, pc)
    local item = GetInvItemCount(pc, "PILGRIM48_HIDDENQ1_PREITEM2")
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    if sObj == nil then
        CreateSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    end
    if item < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_PREITEM2", 1, "PILGRIMROAD48_HQ1_PRE")
            ShowBalloonText(pc, "PILGRIM48_GETITEM_MSG1", 5)
            HideNPC(pc, "PILGRIM48_HIDDEN_OBJ2")
        end
    end
end

function SCR_PILGRIM48_HIDDEN_OBJ3_DIALOG(self, pc)
    local item = GetInvItemCount(pc, "PILGRIM48_HIDDENQ1_PREITEM3")
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    if sObj == nil then
        CreateSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    end
    if item < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_PREITEM3", 1, "PILGRIMROAD48_HQ1_PRE")
            ShowBalloonText(pc, "PILGRIM48_GETITEM_MSG1", 5)
            HideNPC(pc, "PILGRIM48_HIDDEN_OBJ3")
        end
    end
end

function PILGRIM48_HIDDEN_DLG_PRECHECK(self, pc)
    local H_item = GetInvItemCount(pc, "PILGRIM48_HIDDENQ1_ITEM1")
    if H_item > 1 then
        return 'YES'
    end
end

function SCR_PILGRIM48_HIDDENQ1_OBJ1_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1")
    if sObj.Goal1 < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_ITEM2", 1, "QUEST")
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem',ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG4'), 5)
            HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ1")
            sObj.Goal1 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIM48_HIDDENQ1_OBJ2_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1")
    if sObj.Goal2 < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_ITEM2", 1, "QUEST")
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem',ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG4'), 5)
            HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ2")
            sObj.Goal2 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIM48_HIDDENQ1_OBJ3_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1")
    if sObj.Goal3 < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_ITEM2", 1, "QUEST")
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem',ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG4'), 5)
            HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ3")
            sObj.Goal3 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function SCR_PILGRIM48_HIDDENQ1_OBJ4_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1")
    if sObj.Goal4 < 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM48_HIDDEN_MSG1"), '#SITGROPESET', 3)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_ITEM2", 1, "QUEST")
            SendAddOnMsg(pc, 'NOTICE_Dm_GetItem',ScpArgMsg('PILGRIM48_HIDDENQ1_OBJ_MSG4'), 5)
            HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ4")
            sObj.Goal4 = 1
            SaveSessionObject(pc, sObj)
        end
    end
end

function PILGRIM48_HIDDENQ1_ABBANDON(pc)
    HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ1")
    HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ2")
    HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ3")
    HideNPC(pc, "PILGRIM48_HIDDENQ1_OBJ4")
    local item = GetInvItemCount(pc, "PILGRIM48_HIDDENQ1_ITEM1")
    if item <= 0 then
        RunZombieScript("GIVE_ITEM_TX", pc, "PILGRIM48_HIDDENQ1_ITEM1", 1, "HIDDENQUEST_PREITEM")
    end
end

function PILGRIM48_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_PILGRIM48_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--REMAINS38_HQ1 condition check
function SCR_REMAINS38_HIDDEN_RUNE_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "REMAINS38_HQ1")
    local sObj = GetSessionObject(pc, "SSN_REMAINS38_HQ1_UNLOCK")
    SetDirectionByAngle(pc, 3)
    if sObj == nil then
        CreateSessionObject(pc, "SSN_REMAINS38_HQ1_UNLOCK")
    end
    if SCR_HIDDEN_JOB_IS_UNLOCK(pc, "Char2_17") == "YES" then
        if quest == "COMPLETE" then
            ShowOkDlg(pc, "REMAINS38_HIDDEN_RUNE_MSG3")
        elseif quest == "PROGRESS" then
            COMMON_QUEST_HANDLER(self,pc)
        else
            ShowBalloonText(pc, "REMAINS38_HIDDEN_RUNE_MSG1", 5)
            sObj.Goal1 = 1
            SaveSessionObject(pc, sObj)
        end
    else
        ShowBalloonText(pc, "REMAINS38_HIDDEN_RUNE_MSG2", 5)
    end
end

function REMAINS38_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_REMAINS38_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--THORN22_HQ1 condition check
function SCR_THORN22_HIDDEN_CHAPLAIN_IN_ENTER(self, pc)
    if isHideNPC(pc, "CHAPLAIN_MASTER") == "NO" then
        local quest = SCR_QUEST_CHECK(pc, "THORN22_HQ1")
        if quest == "IMPOSSIBLE" then
            Chat(self, ScpArgMsg("THORN22_HIDDENQ1_MSG1"), 5)
        end
    end
end

function SCR_THORN22_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_THORN22_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--CHATHEDRAL54_HQ1 condition check
function CHATHEDRAL54_HIDDENQ1_PREDLG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_CHATHEDRAL54_HQ1_UNLOCK")
    local ran = IMCRandom(1, 10)
    local quest_check1 = SCR_QUEST_CHECK(pc, "CHATHEDRAL54_HQ1")
	local quest_check2 = SCR_QUEST_CHECK(pc, "CHATHEDRAL54_SQ03_PART1")
	local quest_check3 = SCR_QUEST_CHECK(pc, "CHATHEDRAL54_SQ04_PART2")
	--print("ran value : "..ran..", quest_check : "..quest_check)
	if quest_check1 == "IMPOSSIBLE" and quest_check2 == "COMPLETE" and quest_check3 == "COMPLETE" then
        if ran <= 3 then
            if sObj == nil then
	            CreateSessionObject(pc, "SSN_CHATHEDRAL54_HQ1_UNLOCK")
	        end
            return "YES"
        end
    end
end

function CHATHEDRAL54_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_CHATHEDRAL54_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--SIAULIAI462_HQ1 condition check
function SCR_SIAULIAI462_HIDDENQ1_IN_ENTER(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ1")
    if quest == "IMPOSSIBLE" then
        local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ1_UNLOCK")
        if sObj == nil then
            CreateSessionObject(pc, "SSN_SIAULIAI462_HQ1_UNLOCK")
        end
    end
end

function SCR_SIAULIAI462_HIDDENQ1_PLANT1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ1")
    if quest == "PROGRESS" then
        local item = GetInvItemCount(pc, "SIAULIAI462_HIDDENQ1_ITEM1")
        if item < 10 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG7"), '#SITGROPESET', 1.5)
            if result == 1 then
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG5"), 3)
                RunZombieScript("GIVE_ITEM_TX", pc, "SIAULIAI462_HIDDENQ1_ITEM1", 1, "QUEST")
                PlayEffect(self, "F_pc_making_finish_white", 1, 0, "MID")
                Kill(self)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG9"), 3)
        end
    end
end

function SCR_SIAULIAI462_HIDDENQ1_PLANT2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ1")
    if quest == "PROGRESS" then
        local item = GetInvItemCount(pc, "SIAULIAI462_HIDDENQ1_ITEM2")
        if item < 6 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG8"), '#SITGROPESET', 1.5)
            if result == 1 then
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG6"), 3)
                RunZombieScript("GIVE_ITEM_TX", pc, "SIAULIAI462_HIDDENQ1_ITEM2", 1, "QUEST")
                PlayEffect(self, "F_pc_making_finish_white", 1, 0, "MID")
                Kill(self)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SIAULIAI462_HIDDENQ1_MSG10"), 3)
        end
    end
end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE1_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ2")
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ2")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG1"), '#SITGROPESET', 1.5)
        if result == 1 then
            if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
    	        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                SaveSessionObject(pc, sObj)
            end
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG2"), 3)
            PlayEffectLocal(self, pc, "F_pc_making_finish_white", 1, 0, "MID")
            HideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE1")
            UnHideNPC(pc, "SIAULIAI462_CANDLE1")
        end
    end
end

function SCR_SIAULIAI462_CANDLE1_ENTER(self, pc)

end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE2_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ2")
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ2")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG1"), '#SITGROPESET', 1.5)
        if result == 1 then
            if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
    	        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                SaveSessionObject(pc, sObj)
            end
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG2"), 3)
            PlayEffectLocal(self, pc, "F_pc_making_finish_white", 1, 0, "MID")
            HideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE2")
            UnHideNPC(pc, "SIAULIAI462_CANDLE2")
        end
    end
end

function SCR_SIAULIAI462_CANDLE2_ENTER(self, pc)

end

function SCR_SIAULIAI462_HIDDENQ2_CANDLE3_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ2")
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI462_HQ2")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG1"), '#SITGROPESET', 1.5)
        if result == 1 then
            if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
    	        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                SaveSessionObject(pc, sObj)
            end
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("SIAULIAI462_HIDDENQ2_MSG2"), 3)
            PlayEffectLocal(self, pc, "F_pc_making_finish_white", 1, 0, "MID")
            HideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE3")
            UnHideNPC(pc, "SIAULIAI462_CANDLE3")
        end
    end
end

function SCR_SIAULIAI462_CANDLE3_ENTER(self, pc)

end

function SIAULIAI462_HIDDENQ1_ABBANDON(pc)
    UnHideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE1")
    UnHideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE2")
    UnHideNPC(pc, "SIAULIAI462_HIDDENQ2_CANDLE3")
    HideNPC(pc, "SIAULIAI462_CANDLE1")
    HideNPC(pc, "SIAULIAI462_CANDLE2")
    HideNPC(pc, "SIAULIAI462_CANDLE3")
end

function SIAULIAI462_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_SIAULIAI462_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--REMAINS373_HQ1 condition check
function REMAINS373_HIDDENQ1_PREDLG(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "REMAINS373_HQ1")
	--print("ran value : "..ran..", quest_check : "..quest_check)
	if quest_check == "IMPOSSIBLE" then
	    local ran = IMCRandom(1, 10)
        if ran >= 3 then
            local list = GetSummonedPetList(pc);
            if #list >= 1 then
            return "YES"
        end
    end
    end
end

function REMAINS373_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_REMAINS373_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end

--CATHEDRAL1_HQ1 condition check
function SCR_CATHEDRAL1_HIDDEN_NPC_ENTER(self, pc)
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_BORN_ENTER(self)
    self.NumArg1 = os.date('%H')
--    self.NumArg1 = os.date('%M')
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_BORN_UPDATE(self)
--    self.NumArg1 = os.date('%S')
    self.NumArg1 = os.date('%H')
    local creMon = GetTacticsArgObject(self)
    if creMon ~= nil then
        return
    else
        if self.NumArg1 == 1 or self.NumArg1 == 7 or self.NumArg1 == 13 or self.NumArg1 == 19 or self.NumArg1 == 23 then
--        if self.NumArg1 == 30 then
--            print(ScpArgMsg('Auto_Daeum_Jen_Taim_SeTing_HyeonJae_SiKan_:_'),math.floor(os.clock()/60))
            local mon = CREATE_NPC(self, 'noshadow_npc_8', 749, 167, -529, nil, 'Neutral', 0, "UnvisibleName", 'CATHEDRAL1_HIDDEN_NPC_CHAT', 'CATHEDRAL1_HIDDEN_NPC_IN', 70, 1, nil,nil, nil, nil, nil, 'CATHEDRAL1_HIDDEN_NPC_AI')
            AttachEffect(mon, "F_bg_light003_blue", 0.8, "TOP")
            SetTacticsArgObject(self, mon)
            if mon ~= nil then
                self.NumArg1 = 0
                --print(self.NumArg1)
                CreateSessionObject(mon, 'SSN_SETTIME_KILL')
                SetTacticsArgObject(self, mon)
                local sObj_mon = GetSessionObject(mon, 'SSN_SETTIME_KILL')
                if sObj_mon ~= nil then
                    sObj_mon.Count = 3600
--                    print(ScpArgMsg('Auto_NPC_SaengSeong_120Cho_Dwi_SaLaJim_'),sObj_mon.Count)
                end
            end
        end
    end
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_BORN_LEAVE(self)
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_DEAD_ENTER(self)
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_DEAD_UPDATE(self)
end

function SCR_CATHEDRAL1_HIDDEN_NPC_TRIGGER_TS_DEAD_LEAVE(self)
end

function CATHEDRAL1_HIDDEN_NPC_AI_UPDATE(self)
    local pc_obj, cnt = GetWorldObjectList(self, "PC", 200)
    if cnt >= 1 then
        for i = 1, cnt do
            local pc_quest = SCR_QUEST_CHECK(pc_obj[i], "CATHEDRAL1_HQ1")
            if pc_quest == "COMPLETE" then
                PlayEffectLocal(self, pc_obj[i], "F_light119_music", 2, 1, "TOP")
            end
        end
    end
end

function SCR_CATHEDRAL1_HIDDEN_NPC_IN_ENTER(self, pc)
    local Hquest_r = SCR_QUEST_CHECK(pc, "CATHEDRAL1_HQ1")
    if Hquest_r == "IMPOSSIBLE" or Hquest_r == "POSSIBLE" then
        ShowBalloonText(pc, "CATHEDRAL1_HIDDEN_NPC_DLG1", 5)
    end
end

function SCR_CATHEDRAL1_HIDDEN_NPC_CHAT_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATHEDRAL1_HQ1")
    local job_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_18')
--    print(job_prop)
    local sObj = GetSessionObject(pc, "SSN_CATHEDRAL1_HQ1_UNLOCK")
    if quest == "IMPOSSIBLE" or quest == "POSSIBLE" then
        if job_prop < 200 then
            PlayEffectLocal(self, pc, "F_explosion004_blue", 0.3, 1, "BOT")
            ShowBalloonText(pc, "CATHEDRAL1_HIDDEN_NPC_DLG2", 5)
        elseif job_prop >= 200 then
            if sObj == nil then
                CreateSessionObject(pc, "SSN_CATHEDRAL1_HQ1_UNLOCK")
            end
            local chat = {
                            ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG1"),
                            ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG2")
                         }
            PlayEffectLocal(self, pc, "F_explosion004_blue", 0.3, 1, "BOT")
            Chat(self, chat[IMCRandom(1, 2)], 3)
            ShowBalloonText(pc, "CATHEDRAL1_HIDDEN_NPC_DLG3", 5)
        end
        KnockDown(pc, self, 50, GetAngleTo(self, pc), 45, 1)
    elseif quest == "SUCCESS" or quest == "COMPLETE" then
        PlayEffectLocal(self, pc, "F_light119_music", 1, 1, "TOP")
        ShowBalloonText(pc, "CATHEDRAL1_HIDDEN_NPC_DLG6", 5)
    end
end

function CATHEDRAL1_HIDDENQ1_CONDI_SET(self, pc)
    local sObj = GetSessionObject(pc, "SSN_CATHEDRAL1_HQ1_UNLOCK")
    if sObj ~= nil then
        local Hquest_r = SCR_QUEST_CHECK(pc, "CATHEDRAL1_HQ1")
        if Hquest_r == "IMPOSSIBLE" then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG3"), 'TALK', 3)
            if result == 1 then
                local sel1 = ShowSelDlg(pc, 0, "CATHEDRAL1_HIDDEN_NPC_DLG4", ScpArgMsg("CATHEDRAL1_HIDDEN_NPC_MSG4"))
                if sel1 == 1 then
                    ShowOkDlg(pc, "CATHEDRAL1_HIDDEN_NPC_DLG5", 1)
                    local sObj = GetSessionObject(pc, "SSN_CATHEDRAL1_HQ1_UNLOCK") 
                    if sObj ~= nil then
                        sObj.Goal1 = 1
                        SaveSessionObject(pc, sObj)
                    end
                else
                    return 0;
                end
            end
        else
            return 0;
        end
    else
        return 0;
    end
end

function CATHEDRAL1_HIDDENQ1_COMP(self)
    local sObj = GetSessionObject(self, "SSN_CATHEDRAL1_HQ1_UNLOCK") 
    if sObj ~= nil then
        DestroySessionObject(self, sObj)
    end
end

--CATACOMB38_2_HQ1 condition check
function SCR_CATACOMB382_HIDDEN_GHOST_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "CATACOMB38_2_HQ1")
    if quest == "IMPOSSIBLE" then
        if isHideNPC(pc, "CATACOMB382_HIDDEN_GHOST") == "NO" then
            if IsBuffApplied(pc, "CATACOMB382_HIDDEN_BUFF") == "NO" then
                local sel1 = ShowSelDlg(pc, 0, "CATHEDRAL1_HIDDEN_NPC_DLG8", ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG9"), ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG10"))
                if sel1 == 1 then
                    AttachEffect(self, "I_smoke063_ball_dark_red_loop_mesh", 3, "TOP")
                AddBuff(self, pc, "CATACOMB382_HIDDEN_BUFF",1 , 0, 1800000, 1)
                PlayEffectLocal(pc, pc, "F_light069_red", 1, nil, "BOT")
                ShowBalloonText(pc, "CATACOMB38_2_HIDDENQ1_DLG1", 5)
                local sObj = GetSessionObject(pc, "SSN_CATACOMB382_HQ1_UNLOCK")
                if sObj == nil then
                    CreateSessionObject(pc, "SSN_CATACOMB382_HQ1_UNLOCK")
                end
                --HideNPC(pc, "CATACOMB382_HIDDEN_GHOST")
                    sleep(2000)
                    DetachEffect(self, "I_smoke063_ball_dark_red_loop_mesh")
            else
                    return 0;
                end
            else
                AttachEffect(self, "I_smoke063_ball_dark_red_loop_mesh", 3, "TOP")
                ShowBalloonText(pc, "CATACOMB38_2_HIDDENQ1_DLG2", 5)
                sleep(2000)
                DetachEffect(self, "I_smoke063_ball_dark_red_loop_mesh")
            end
        end
    end
end

function CATACOMB382_HIDDEN_CONDI_SET(self, pc)
    local sObj = GetSessionObject(pc, "SSN_CATACOMB382_HQ1_UNLOCK")
    if sObj ~= nil then
        local Hquest_r = SCR_QUEST_CHECK(pc, "CATACOMB38_2_HQ1")
        if Hquest_r == "IMPOSSIBLE" then
            if IsBuffApplied(pc, "CATACOMB382_HIDDEN_BUFF") == "YES" then
                local sel1 = ShowSelDlg(pc, 0, "CATACOMB38_2_HIDDENQ1_DLG3", ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG1"), ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG2"))
                if sel1 == 1 then
                    ShowOkDlg(pc, "CATACOMB38_2_HIDDENQ1_DLG4", 1)
                    LookAt(self, pc)
                    PlayAnimLocal(self, pc, "TALK1", 1)
                    sleep(1500)
                    PlayEffectLocal(pc, pc, "F_levitation029_violet", 1, nil, "BOT")
                    RemoveBuff(pc, "CATACOMB382_HIDDEN_BUFF")
                    local sel2 = ShowSelDlg(pc, 0, "CATACOMB38_2_HIDDENQ1_DLG5", ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG3"), ScpArgMsg("CATACOMB38_2_HIDDENQ1_MSG4"))
                    if sel2 == 1 then
                        ShowOkDlg(pc, "CATACOMB38_2_HIDDENQ1_DLG6", 1)
                    	sObj.Goal1 = 1
                    	SaveSessionObject(pc, sObj)
                    	HideNPC(pc, "CATACOMB382_HIDDEN_GHOST")
                    else
                        return 0;
                    end
                else
                    return 0;
                end
            end
        elseif Hquest_r == "POSSIBLE" then
            ShowOkDlg(pc, "CATACOMB38_2_HIDDENQ1_DLG7", 1)
            return 0;
        else
            return 0;
        end
    else
        return 0;
    end
end

function SCR_CATACOMB382_HIDDENQ1_SPIRIT_DIALOG(self, pc)
end

function CATACOMB382_HIDDENQ1_COMP(self)
    local sObj = GetSessionObject(self, "SSN_CATACOMB382_HQ1_UNLOCK") 
    if sObj ~= nil then
        DestroySessionObject(self, sObj)
    end
end

--FLASH29_1_HQ1 condition check
function SCR_FLASH29_1_HIDDENQ1_OBJ1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "FLASH29_1_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("FLASH29_1_HIDDENQ1_MSG4"), 'ABSORB', 1.5)
        if result == 1 then
            local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1")
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                    SaveSessionObject(pc, sObj)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FLASH29_1_HIDDENQ1_MSG3"), 5)
                    HideNPC(pc, "FLASH29_1_HIDDENQ1_OBJ1")
                    UnHideNPC(pc, "FLASH29_1_HIDDENQ1_ORB1")
                end
            end
        end
    end
end

function SCR_FLASH29_1_HIDDENQ1_ORB1_ENTER(self, pc)
end

function SCR_FLASH29_1_HIDDENQ1_OBJ2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "FLASH29_1_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("FLASH29_1_HIDDENQ1_MSG4"), 'ABSORB', 1.5)
        if result == 1 then
            local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1")
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                    SaveSessionObject(pc, sObj)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FLASH29_1_HIDDENQ1_MSG3"), 5)
                    HideNPC(pc, "FLASH29_1_HIDDENQ1_OBJ2")
                    UnHideNPC(pc, "FLASH29_1_HIDDENQ1_ORB2")
                end
            end
        end
    end
end

function SCR_FLASH29_1_HIDDENQ1_ORB2_ENTER(self, pc)
end

function SCR_FLASH29_1_HIDDENQ1_OBJ3_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "FLASH29_1_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("FLASH29_1_HIDDENQ1_MSG4"), 'ABSORB', 1.5)
        if result == 1 then
            local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1")
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                    SaveSessionObject(pc, sObj)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FLASH29_1_HIDDENQ1_MSG3"), 5)
                    HideNPC(pc, "FLASH29_1_HIDDENQ1_OBJ3")
                    UnHideNPC(pc, "FLASH29_1_HIDDENQ1_ORB3")
                end
            end
        end
    end
end

function SCR_FLASH29_1_HIDDENQ1_ORB3_ENTER(self, pc)
end

function SCR_FLASH29_1_HIDDENQ1_OBJ4_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "FLASH29_1_HQ1")
    if quest == "PROGRESS" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("FLASH29_1_HIDDENQ1_MSG4"), 'ABSORB', 1.5)
        if result == 1 then
            local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1")
            if sObj ~= nil then
                if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                    SaveSessionObject(pc, sObj)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("FLASH29_1_HIDDENQ1_MSG3"), 5)
                    HideNPC(pc, "FLASH29_1_HIDDENQ1_OBJ4")
                    UnHideNPC(pc, "FLASH29_1_HIDDENQ1_ORB4")
                end
            end
        end
    end
end

function SCR_FLASH29_1_HIDDENQ1_ORB4_ENTER(self, pc)
end

function FLASH29_1_HIDDENQ1_ABBANDON(pc)
    HideNPC(pc, "FLASH29_1_HIDDENQ1_ORB1")
    HideNPC(pc, "FLASH29_1_HIDDENQ1_ORB2")
    HideNPC(pc, "FLASH29_1_HIDDENQ1_ORB3")
    HideNPC(pc, "FLASH29_1_HIDDENQ1_ORB4")
end

function FLASH29_1_HIDDENQ1_COMP(pc)
    local sObj = GetSessionObject(pc, "SSN_FLASH29_1_HQ1_UNLOCK")
    if sObj ~= nil then
        DestroySessionObject(pc, sObj)
    end
end
--SIAULIAI_351_HQ1 condition check
function SCR_SIAULIAI351_HIDDENQ1_PREDLG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI_35_1_SQ_10")
    local H_quest = SCR_QUEST_CHECK(pc, "SIAULIAI_351_HQ1")
    local ran = IMCRandom(1, 100)
    if ran <= 30 then
        if quest == "COMPLETE" and H_quest == "IMPOSSIBLE" then
            return 'YES'
        end
    end
end

function SCR_SIAULIAI351_HIDDENQ1_PREITEM_DIALOG(self, pc)
    local quest1 = SCR_QUEST_CHECK(pc, "SIAULIAI_351_HQ1")
    local quest2 = SCR_QUEST_CHECK(pc, "SIAULIAI_35_1_SQ_10")
    local item = GetInvItemCount(pc, "SIAULIAI_351_HIDDENQ1_ITEM3")
    if quest1 == "IMPOSSIBLE" and quest2 == "COMPLETE" then
        if item < 1 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG1"), '#SITGROPESET', 1.5)
            if result == 1 then
                RunZombieScript("GIVE_ITEM_TX", pc, "SIAULIAI_351_HIDDENQ1_ITEM3", 1, "QUEST")
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG4"), 5)
            end
        end
    end
end

function SCR_SIAULIAI_351_HIDDENQ1_ITEM1_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI_351_HQ1")
    local item = GetInvItemCount(pc, "SIAULIAI_351_HIDDENQ1_ITEM1")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG1"), '#SITGROPESET', 1.5)
            if result == 1 then
                RunZombieScript("GIVE_ITEM_TX", pc, "SIAULIAI_351_HIDDENQ1_ITEM1", 1, "QUEST")
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG2"), 5)
                Kill(self)
            end
        end
    end
end

function SCR_SIAULIAI_351_HIDDENQ1_ITEM2_DIALOG(self, pc)
    local quest = SCR_QUEST_CHECK(pc, "SIAULIAI_351_HQ1")
    local item = GetInvItemCount(pc, "SIAULIAI_351_HIDDENQ1_ITEM2")
    if quest == "PROGRESS" then
        if item <= 5 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG1"), '#SITGROPESET', 1.5)
            if result == 1 then
                RunZombieScript("GIVE_ITEM_TX", pc, "SIAULIAI_351_HIDDENQ1_ITEM2", 1, "QUEST")
                SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("SIAULIAI351_HIDDENQ1_MSG3"), 5)
                Kill(self)
            end
        end
    end
end

--ABBEY353_HQ1 condition check
function ABBEY353_HIDDENQ1_PREDLG(self, pc)
    local quest_check1 = SCR_QUEST_CHECK(pc, "ABBEY353_HQ1")
    local quest_check2 = SCR_QUEST_CHECK(pc, "ABBEY_35_3_SQ_11")
    local quest_check3 = SCR_QUEST_CHECK(pc, "ABBEY_35_3_SQ_10")
    local quest_check4 = SCR_QUEST_CHECK(pc, "ABBEY_35_4_SQ_8")
	if quest_check1 == "IMPOSSIBLE" and quest_check2 == "COMPLETE" and quest_check3 == "COMPLETE" and quest_check4 == "COMPLETE" then
	    local ran = IMCRandom(1, 100)
        if ran <= 15 then
            if isHideNPC(pc, "ABBEY353_HIDDENQ1_PREOBJ") == "YES" then
                UnHideNPC(pc, "ABBEY353_HIDDENQ1_PREOBJ")
                --ShowOkDlg(pc, "ABBEY_35_3_MONK_basic_03", 1)
            end
            return "YES"
        end
    end
end

function SCR_ABBEY353_HIDDENQ1_PREOBJ_DIALOG(self, pc)
    local quest_check = SCR_QUEST_CHECK(pc, "ABBEY353_HQ1")
    if quest_check == "IMPOSSIBLE" then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("ABBEY353_HIDDENQ1_MSG1"), '#SITGROPESET', 1.5)
        if result == 1 then
            RunZombieScript("GIVE_ITEM_TX", pc, "ABBEY353_HIDDENQ1_ITEM1", 1, "QUEST")
            ShowBalloonText(pc, "ABBEY353_HIDDENQ1_DLG1", 5)
            HideNPC(pc, "ABBEY353_HIDDENQ1_PREOBJ")
            local objList, objCnt = GetWorldObjectList(self, "MON", 350)
            if objCnt >= 1 then
                for i = 1, objCnt do
                    if objList[i].ClassName == "npc_friar_04_2" then
                        if objList[i].Dialog == "ABBEY_35_3_MONK" then
                            Chat(objList[i], ScpArgMsg("ABBEY353_HIDDENQ1_MSG2"), 5)
                            break
                        end
                    end
                end
            end
        end
    end
end

--ORCHARD343_HQ1 condition check
function ORCHARD343_HIDDENQ1_PREDLG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_ORCHARD343_HQ1_UNLOCK")
    local ran = IMCRandom(1, 10)
    local quest_check = SCR_QUEST_CHECK(pc, "ORCHARD343_HQ1")
	--print("ran value : "..ran..", quest_check : "..quest_check)
	if quest_check == "IMPOSSIBLE" then
        if ran <= 2 then
            if sObj == nil then
	            CreateSessionObject(pc, "SSN_ORCHARD343_HQ1_UNLOCK")
	        end
            return "YES"
        end
    end
end
