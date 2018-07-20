--Step1 is traning stamina
--Step2 is traning Count

--Step5 is training step5 monster kill count

--Step6 is training step2 first goal point


--Step7 is training step2 second goal point
--Step8 is training step2 third goal point
--Step9 is training step2 fourth goal point



--Step10 is training step3 attack point / attack point 10 = - 1 traning stamina
--Step11 is training step3 attack point / attack point 10 = - 1 traning stamina

--sObj.Step12 is traning stamina start msg check value

--Goal1 is traning Goal Count(muscular strength) max count : 40
--Goal2 is traning Goal Count(endurande) max count : 15
--Goal3 is traning Goal Count(agility) max count : 40
--Goal4 is traning Goal Count(durability) max count : 50 --this property is no longer use it
--Goal5 is traning Goal Count(simulation) max count : 40

--Step20 is traning stamina not enough Msg Check value / 1 is msg start, 2 is msg tiem check, 2 is msg tiem off
--Step21 is traning stamina not enough Msg tiem Check value

--Step22 is traning stamina enough Msg Check value / 1 is msg start, 2 is msg tiem check, 2 is msg tiem off
--Step23 is traning stamina enough Msg tiem Check value

--Step24 is traning stamina prog Msg Check value / 1 is msg start, 2 is msg tiem check, 2 is msg tiem off
--Step25 is traning stamina prog Msg tiem Check value

function SCR_SSN_RETIARII_UNLOCK_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, "KillMonster", "SCR_RETIARII_UNLOCK_KillMonster", "YES");
    RegisterHookMsg(self, sObj, 'AttackMonster', 'SCR_RETIARII_UNLOCK_ATTACK_MON', 'YES')
    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_RETIARII_CHECK_RUN")
end
function SCR_CREATE_SSN_RETIARII_UNLOCK(self, sObj)
	SCR_SSN_RETIARII_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_RETIARII_UNLOCK(self, sObj)
	SCR_SSN_RETIARII_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_RETIARII_UNLOCK(self, sObj)
    SetTitle(self, "")
end

function SCR_RETIARII_UNLOCK_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    local lv = self.Lv - 10
    if lv < 1 then
        lv = 1
    end
    if argObj.Lv >= lv then
        local training_Stamina = sObj.Step1
        local training_Count = sObj.Step2
        local discount
        
        if training_Count == 1 then
            discount = 5
        elseif training_Count == 2 then
            discount = 4
        elseif training_Count == 3 then
            discount = 3
        elseif training_Count == 4 then
            discount = 2
        elseif training_Count >= 5 then
            discount = 1
        end
        local pcHp_Percent = math.floor(self.MHP / 3)
        if pcHp_Percent >= self.HP then
            if (training_Stamina == 0) or (training_Stamina < discount) then
                if GetInvItemCount(self, "CHAR118_MSTEP2_ITEM1") < 1 then
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH'), 5)
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH2'), 5)
                end
            else
                sObj.Step5 = sObj.Step5 + 1
                local monKill_Count = sObj.Step5
                SaveSessionObject(self, sObj)
                if monKill_Count < 3 then
                    local remain_cnt = 3 - monKill_Count 
                    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("RETIARII_TRAINING_5_MONKILL_CNT", 'Count', remain_cnt)..ScpArgMsg("RETIARII_TRAINING_5_MONKILL_SUCC_CNT", 'simulation', sObj.Goal5), 7)
                elseif monKill_Count >= 3 then
                    sObj.Step5 = 0
                    RETIARII_TRAINING_FUNC(self, "Step1", "Step2", "Goal5", 20)
                end
            end
        end
    end
end

function SCR_RETIARII_UNLOCK_ATTACK_MON(self, sObj, msg, argObj, argStr, argNum)
    if GetLayer(self) > 0 then
        local skl = GetSkill(self, argStr)
        if skl ~= nil then
            if sObj.Goal3 < 20 then
                local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_18")
                local attack_Point = GetExProp(pc, "CHAR118_AGILITY_ATTACK_POINT");
                if hidden_Prop == 100 then
                    if argObj.SimpleAI == 'RETIARII_WOOD_CARVING_AI' then
                        local buff = GetBuffByName(argObj, 'CHAR118_AGILITY_TRAINING_BUFF')
                        local training_Stamina = sObj.Step1
                        local training_Count = sObj.Step2
                        local discount
                        
                        if training_Count == 1 then
                            discount = 5
                        elseif training_Count == 2 then
                            discount = 4
                        elseif training_Count == 3 then
                            discount = 3
                        elseif training_Count == 4 then
                            discount = 2
                        elseif training_Count >= 5 then
                            discount = 1
                        end
                        if (training_Stamina == 0) or (training_Stamina < discount) then
                            if GetInvItemCount(self, "CHAR118_MSTEP2_ITEM1") < 1 then
                                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH'), 5)
                            else
                                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_NOT_ENOUGH2'), 5)
                            end
                        else
                            if buff ~= nil then
                                SetExProp(pc, "CHAR118_AGILITY_ATTACK_POINT", 1);
                                local attack_Point = GetExProp(self, "CHAR118_AGILITY_ATTACK_POINT");
                                attack_Point = attack_Point + 1
                                SetExProp(self, "CHAR118_AGILITY_ATTACK_POINT", attack_Point);
                                SetExProp(self, "CHAR118_AGILITY_ATTACK_FAIL", fail_Point)
                                SetTitle(argObj,attack_Point)
                                if attack_Point >= 3 then
                                    RETIARII_TRAINING_FUNC(self, "Step1", "Step2", "Goal3", 20)
                                    SetExProp(self, "CHAR118_AGILITY_ATTACK_POINT", 0);
                                    SetExProp(self, "CHAR118_AGILITY_ATTACK_FAIL", 0)
                                    SetTitle(argObj,"")
                                end
                            else
                                SetExProp(pc, "CHAR118_AGILITY_ATTACK_FAIL", 1)
                                local fail_Point = GetExProp(self, "CHAR118_AGILITY_ATTACK_FAIL");
                                fail_Point = fail_Point + 1
                                SetExProp(self, "CHAR118_AGILITY_ATTACK_FAIL", fail_Point)
                                if fail_Point >= 3 then
                                    local attack_Point = GetExProp(self, "CHAR118_AGILITY_ATTACK_POINT");
                                    if attack_Point >= 1 then
                                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("RETIARII_UNLOCK_ATTACK_MON_1"), 5);
                                        attack_Point = attack_Point - 1
                                    else
                                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("RETIARII_UNLOCK_ATTACK_MON_3"), 5);
                                    end
                                    SetExProp(self, "CHAR118_AGILITY_ATTACK_POINT", attack_Point)
                                    SetExProp(self, "CHAR118_AGILITY_ATTACK_FAIL", 0)
                                    SetTitle(argObj,attack_Point)
                                    SaveSessionObject(self, sObj)
                                else
                                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("RETIARII_UNLOCK_ATTACK_MON_2", 'count', fail_Point), 5);
                                end
                            end
                        end
                    end
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_Clear",ScpArgMsg('RETIARII_TRAINING_SUCC3'), 5)
            end
        end
    end
end


function SCR_RETIARII_CHECK_RUN(self, sObj, remainTime)
    if sObj.Step20 > 0 then --not enough
        --print("sObj.Step20 "..sObj.Step20)
        SCR_RETIARII_CHECK_MSG_RUN(self, sObj, "Step20", "Step21", "RETIARII_STAMINA_NOT_ENOUGH")
    end
    
    if sObj.Step22 > 0 then --full charge
        --print("sObj.Step22 "..sObj.Step22)
        SCR_RETIARII_CHECK_MSG_RUN(self, sObj, "Step22", "Step23", "RETIARII_STAMINA_FULL_CHARGE2")
    end
    if sObj.Step24 > 0 then --prog
        --print("sObj.Step24 "..sObj.Step24)
        SCR_RETIARII_CHECK_MSG_RUN(self, sObj, "Step24", "Step25")
    end
end

function SCR_RETIARII_CHECK_MSG_RUN(self, sObj, Step_number1, Step_number2, msg)
    if sObj[Step_number1] == 1 then
        sObj[Step_number1] = 2
        SetTitle(self, ScpArgMsg("CHAR118_MSTEP_STAMINA", "NUM", sObj.Step1))
        if Step_number1 == "Step20" then
            SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg(msg), 5)
        elseif  Step_number1 == "Step22" then 
            if sObj.Step12  == 1 then
                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg("RETIARII_STAMINA_CHARGE1"), 5)
                sObj.Step12 = 0
            elseif sObj.Step1 == 50 then
                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg(msg), 5)
            elseif sObj.Step1 == 60 then
                SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg("RETIARII_STAMINA_FULL_CHARGE3"), 5)
            end
        end
    elseif sObj[Step_number1] == 2 then
        sObj[Step_number2] = sObj[Step_number2] + 1
        if sObj[Step_number2] >= 5 then
            SetTitle(self, "")
            sObj[Step_number1] = 0
            sObj[Step_number2] = 0
        end
    end
end