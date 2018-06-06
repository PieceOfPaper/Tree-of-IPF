-- step1 is EXORCIST test / It is a success if you match three or more problems

-- step2 is CHAR4_20_STEP3_2_1 selButton1 check value
-- step3 is CHAR4_20_STEP3_2_1 selButton2 check value
-- step4 is CHAR4_20_STEP3_2_1 selButton3 check value
-- step5 is CHAR4_20_STEP3_2_1 selButton4 check value

-- step6 is CHAR4_20_STEP3_2_2 NPC1 selButton1 check value
-- step7 is CHAR4_20_STEP3_2_2 NPC1 selButton2 check value
-- step8 is CHAR4_20_STEP3_2_2 NPC1 selButton3 check value
-- step9 is CHAR4_20_STEP3_2_2 NPC1 selButton4 check value

-- step10 is CHAR4_20_STEP3_2_2 NPC2 selButton1 check value
-- step11 is CHAR4_20_STEP3_2_2 NPC2 selButton2 check value
-- step12 is CHAR4_20_STEP3_2_2 NPC2 selButton3 check value

-- step13 is CHAR4_20_STEP3_2_2 HINT1 check value
-- step14 is CHAR4_20_STEP3_2_2 HINT2 check value
-- step15 is CHAR4_20_STEP3_2_2 HINT3 check value

-- step16 is CHAR420_STEP323 selButton1 check value
-- step17 is CHAR420_STEP323 selButton2 check value
-- step18 is CHAR420_STEP323 selButton3 check value
-- step19 is CHAR420_STEP323 selButton4 check value

-- step20 is Vesper kill count

-- Goal1 is CHAR420_MSTEP3_1_ITEM1_BOOK1 read check value
-- Goal2 is CHAR420_MSTEP3_1_ITEM1_BOOK2 read check value
-- Goal3 is CHAR420_MSTEP3_1_ITEM1_BOOK3 read check value
-- Goal4 is CHAR420_MSTEP3_1_ITEM1_BOOK4 read check value

-- Goal5 is CHAR420_MSTEP3_3 SETTING check value
-- Goal6 is CHAR420_MSTEP3_3 SETTING try cnt
-- Goal7 is CHAR420_MSTEP3_3 SETTING try cnt

-- Goal8 is x pos
-- Goal9 is y pos
-- Goal10 is z pos

-- Goal11 is EXORCIST_MSTEP321_ITEM1 use check
-- Goal12 is EXORCIST_MSTEP321_ITEM1 use check
-- Goal13 is EXORCIST_MSTEP321_ITEM1 use check
-- Goal14 is EXORCIST_MSTEP321_ITEM1 use check
-- Goal15 is EXORCIST_MSTEP321_ITEM1 use check

-- Goal16 is Hallowventor kill count

function SCR_SSN_EXORCIST_UNLOCK_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, "KillMonster", "SCR_EXORCIST_UNLOC_KillMonster", "YES")
    RegisterHookMsg(self, sObj, "Dead", "SCR_EXORCIST_UNLOCK_DIE_TIEM_FUNC", "YES")
end

function SCR_CREATE_SSN_EXORCIST_UNLOCK(self, sObj)
	SCR_SSN_EXORCIST_UNLOCK_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_EXORCIST_UNLOCK(self, sObj)
	SCR_SSN_EXORCIST_UNLOCK_BASIC_HOOK(self, sObj)
	if GetZoneName(self) == "f_remains_40" then
        sObj.Goal5 = 0
        sObj.Goal6 = 0
	end
end

function SCR_DESTROY_SSN_EXORCIST_UNLOCK(self, sObj)
end

function SCR_EXORCIST_UNLOC_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    if SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_20') == 132 then
        local zone_Name = GetZoneName(self)
        if zone_Name == "d_zachariel_33" then
            if argObj.ClassName == "Vesper" then
                local item = GetInvItemCount(self, "EXORCIST_MSTEP33_ITEM1")
                local ran = IMCRandom(1, 1000)
                if item < 12 then
                    sObj.Step20 = sObj.Step20 + 1
                    if sObj.Step20 >= 8 then
                        RunZombieScript("GIVE_ITEM_TX", self, "EXORCIST_MSTEP33_ITEM1", 1, "Quest_HIDDEN_EXORCIST")
                        sObj.Step20 = 0
                        return
                    elseif ran <= 150 then
                        RunZombieScript("GIVE_ITEM_TX", self, "EXORCIST_MSTEP33_ITEM1", 1, "Quest_HIDDEN_EXORCIST")
                        sObj.Step20 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR420_MSTEP33_BALLOON_TEXT1", 5)
                end
            end
        end
    elseif SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_20') == 134 then
        local zone_Name = GetZoneName(self)
        if zone_Name == "f_remains_40" then
            if GetLayer(self) >= 1 then
                if argObj.ClassName == "Hallowventor" then
                    if argObj.StrArg1 == "EXORCIST_TRACK_MON" then
                        sObj.Goal16 = sObj.Goal16 + 1
                        if sObj.Goal16 >= 4 then
                            SCR_SET_HIDDEN_JOB_PROP(self, 'Char4_20', 140)
                            ShowBalloonText(self, "EXORCIST_MSTEP33_TXT4", 5)
                            if isHideNPC(self, "EXORCIST_MASTER_STEP33_NPC1") == "NO" then
                                local tx = TxBegin(self)
                                TxHideNPC(tx, "EXORCIST_MASTER_STEP33_NPC1")
                                local ret = TxCommit(tx)
                            end
                            SetLayer(self, 0)
                        end
                    end
                end
            end
        end
    end
end

function SCR_EXORCIST_UNLOCK_DIE_TIEM_FUNC(pc, sObj, msg, argObj, argStr, argNum)
    local pc_layer = GetLayer(pc)
    local obj = GetLayerObject(GetZoneInstID(pc), pc_layer);
    if obj ~= nil then
    	if GetZoneName(pc) == "f_remains_40" then
        	if obj.EventName == "EXORCIST_UNLOCK_TRACK" then
                if pc_layer ~= 0 then
                    SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("EXORCIST_UNLOCK_DIE_MSG"), 7)
                    SetLayer(pc, 0)
                end
            end
        end
    end
end