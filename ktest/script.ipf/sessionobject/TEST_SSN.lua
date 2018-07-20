function SCR_CREATE_SSN_QUESTITEM_BOOM(self, sObj)
    self.NumArg1 = 255
    self.NumArg2 = 10
    SetTimeSessionObject(self, sObj, 1, 100, 'QUESTITEM_BOOM_RUN')
    SetTimeSessionObject(self, sObj, 2, 1000, 'VIBRATE_BOOM_RUN')
--    SetTimeSessionObject(self, sObj, 3, 100, 'CAUTION_BOOM_RUN')
end

function SCR_REENTER_SSN_QUESTITEM_BOOM(self, sObj)
    SetTimeSessionObject(self, sObj, 1, 100, 'QUESTITEM_BOOM_RUN')
    SetTimeSessionObject(self, sObj, 2, 1000, 'VIBRATE_BOOM_RUN')
--    SetTimeSessionObject(self, sObj, 3, 100, 'CAUTION_BOOM_RUN')
end

function SCR_DESTROY_SSN_QUESTITEM_BOOM(self, sObj)
end

function CAUTION_BOOM_RUN(self, sObj)
    if self.NumArg3 == 0 then
        local list_pc, Cnt_pc = SelectObjectByClassName(self, 100, 'PC')
        local j
        for j = 1, Cnt_pc do
--            SendAddOnMsg(list_pc[j], "NOTICE_Dm_!", ScpArgMsg("Auto_SangJaKa_iSangHapNiDa._MeolLi_TteoleoJiSeyo!"), 5);
        end
        self.NumArg3 = 1
    end
end

function QUESTITEM_BOOM_RUN(self, sObj)
    if self.ClassName == 'PC' then
        DestroySessionObject(self, sObj)
        return
    end
    if self.NumArg1 > 15 then
        ObjectColorBlend(self, 255, self.NumArg1, self.NumArg1, 255, 1)
        self.NumArg1 = self.NumArg1 - 5
    end
end

function VIBRATE_BOOM_RUN(self, sObj)
    if self.NumArg2 < 200 then
        ActorVibrate(self, 1, 0.3, self.NumArg2, 0.1)
        self.NumArg2 = self.NumArg2*2.5
    elseif self.NumArg2 >= 200 and self.NumArg2 < 350 then
        ActorVibrate(self, 1, 1.8, 30, 0.1)
        self.NumArg2 = self.NumArg2*2.5
    else
        if self.ClassName == 'npc_drum_M' or self.ClassName == 'npc_drum_S' then
            PlayEffect(self, 'E_explosion_box', 1.0)
        else
            PlayEffect(self, 'F_explosion049_fire', 2.5)            
        end
        PlaySound(self, 'skl_eff_dead_boom_m');
        local list, Cnt = SelectObject(self, 70, 'ALL')
        local i
        local angle = {}
        for i = 1, Cnt do
    --??? ???? ????o?? ????? ?????--
            angle[i] = GetAngleTo(list[i], self);
            KnockDown(list[i], self, 100, angle[i]*2, 45, 0, 2, 3)
            if self.ClassName == "Bomb" then
                if GetZoneName(self) == "mission_whitetrees_56_1" then
                    if list[i].ClassName == "GM_Obelisk" then
                        TakeDamage(list[i], list[i], "None", 700000, "None", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
                    else
                        TakeDamage(list[i], list[i], "None", 10000, "None", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
                    end
                end
            end
        end
        Kill(self)
    end
end





function SCR_CREATE_SSN_VIBRATION_RUN(self, sObj)
    self.NumArg1 = 0
    self.NumArg2 = 0
    self.NumArg3 = 0
    SetTimeSessionObject(self, sObj, 1, sObj.Step25, 'DRT_VIBERATION_RUN')
end

function SCR_REENTER_SSN_VIBRATION_RUN(self, sObj)
    SetTimeSessionObject(self, sObj, 1, sObj.Step25, 'DRT_VIBERATION_RUN')
end

function SCR_DESTROY_SSN_VIBRATION_RUN(self, sObj)
end


function DRT_VIBERATION_RUN(self, sObj)
    if self.NumArg3 >= 0 and self.NumArg3 < sObj.Goal11 then
        --1�ܰ�--
        ActorVibrate(self, sObj.Step1, sObj.Step2, sObj.Step3)
        self.NumArg3 = self.NumArg3 + 1
        --2�ܰ� ����?--
        if sObj.Goal1 == 1 then
            if self.NumArg3 >= sObj.Goal11 and self.NumArg3 < sObj.Goal12 then
                --2�ܰ�--
                ActorVibrate(self, sObj.Step4, sObj.Step5, sObj.Step6)
                self.NumArg3 = self.NumArg3 + 1
                --3�ܰ� ����?--
                if sObj.Goal2 == 1 then
                    if self.NumArg3 >= sObj.Goal12 and self.NumArg3 < sObj.Goal13 then
                        --3�ܰ�--
                        ActorVibrate(self, sObj.Step7, sObj.Step8, sObj.Step9)
                        self.NumArg3 = self.NumArg3 + 1
                        --4�ܰ� ����?--
                        if sObj.Goal3 == 1 then
                            if self.NumArg3 >= sObj.Goal13 and self.NumArg3 < sObj.Goal14 then
                                --4�ܰ�--
                                ActorVibrate(self, sObj.Step10, sObj.Step11, sObj.Step12)
                                self.NumArg3 = self.NumArg3 + 1
                                --5�ܰ� ����?--
                                if sObj.Goal4 == 1 then
                                    if self.NumArg3 >= sObj.Goal14 and self.NumArg3 < sObj.Goal15 then
                                        --5�ܰ�--
                                        ActorVibrate(self, sObj.Step13, sObj.Step14, sObj.Step15)
                                        self.NumArg3 = self.NumArg3 + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if self.NumArg3 >= sObj.Goal25 then
        Kill(self)
    end
end





