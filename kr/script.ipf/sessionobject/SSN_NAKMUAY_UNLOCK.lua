--sObj.Step1 is Step5_1 progress check / sObj.Step6 is Step5_1 Done check
--sObj.Step2 is Step5_2 progress check / sObj.Step7 is Step5_2 Done check
--sObj.Step3 is Step5_3 progress check / sObj.Step8 is Step5_3 Done check
--sObj.Step4 is Step5_4 progress check / sObj.Step9 is Step5_4 Done check
--sObj.Step5 is Step5_5 progress check / sObj.Step10 is Step5_5 Done check

function SCR_SSN_NAKMUAY_UNLOCK_BASIC_HOOK(self, sObj)
    RegisterHookMsg(self, sObj, "KillMonster", "SCR_NAKMUAY_UNLOCK_KillMonster", "YES");
    SetTimeSessionObject(self, sObj, 1, 1000, "SCR_NAKMUAY_DANDELION_GEN")
end

function SCR_CREATE_SSN_NAKMUAY_UNLOCK(self, sObj)
	SCR_SSN_NAKMUAY_UNLOCK_BASIC_HOOK(self, sObj)
	local dlg_Ran = IMCRandom(12, 25)
	sObj["Step"..dlg_Ran] = 1
	SaveSessionObject(self, sObj)
end

function SCR_REENTER_SSN_NAKMUAY_UNLOCK(self, sObj)
	SCR_SSN_NAKMUAY_UNLOCK_BASIC_HOOK(self, sObj)
	if sObj.Step2 == 3 then
	    if isHideNPC(self, "CHAR120_MSTEP5_2_NPC1") == "YES" then
	        UnHideNPC(self, "CHAR120_MSTEP5_2_NPC1")
	    end
	elseif sObj.Step1 == 2 and sObj.Step2 == 4 and sObj.Step3 == 2 and sObj.Step4 == 2 and sObj.Step5 == 3 then
	    if GetZoneName(self) == "f_katyn_13" then
	        --print(isHideNPC(self, "CHAR120_MSTEP5_2_NPC3"))
    	    if isHideNPC(self, "CHAR120_MSTEP5_2_NPC3") == "YES" then
    	        UnHideNPC(self, "CHAR120_MSTEP5_2_NPC3")
    	        UnHideNPC(self, "CHAR120_FEMALE_OBJECT")
    	        HideNPC(self, "CHAR120_MSTEP5_2_NPC1")
    	    end
	        CHAR120_MSTEP5_TRACK_ITEM_RETURN(self, sObj)
	    end
	end
end

function SCR_DESTROY_SSN_NAKMUAY_UNLOCK(self, sObj)
end

function SCR_NAKMUAY_UNLOCK_KillMonster(self, sObj, msg, argObj, argStr, argNum)
    local zone_Name = GetZoneName(self)
    if zone_Name == "f_katyn_7_2" then --NAKMUAY_MSTEP5_1
        if sObj.Step1 == 1 then
            if argObj.ClassName == "jellyfish_red" then
                local item = GetInvItemCount(self, "CHAR120_MSTEP5_1_ITEM")
                local ran = IMCRandom(1, 1000)
                if item < 100 then
                    sObj.Goal1 = sObj.Goal1 + 1
                    if sObj.Goal1 >= 15 then
                        local item_cnt = SCR_JELLYFISH_RED_GIVE(self)
                        RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_1_ITEM", item_cnt, "Quest_HIDDEN_NAKMUAY")
                        sObj.Goal1 = 0
                        return
                    end
                    if ran <= 90 then
                        local item_cnt = SCR_JELLYFISH_RED_GIVE(self)
                        RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_1_ITEM", item_cnt, "Quest_HIDDEN_NAKMUAY")
                        sObj.Goal1 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR120_MSTEP3_BALLOON_TEXT1", 5)
                end
            end
        end
    elseif zone_Name == "f_katyn_7" then --NAKMUAY_MSTEP5_3
        if sObj.Step3 == 1 then
            if argObj.ClassName == "ellom" then
                local ran = IMCRandom(1, 1000)
                local item = GetInvItemCount(self, "CHAR120_MSTEP5_3_ITEM1")
                if item < 100 then
                    sObj.Goal2 = sObj.Goal2 + 1
                    if sObj.Goal2 >= 72 then
                        RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_3_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
                        sObj.Goal2 = 0
                        return
                    end
                    if ran <= 13 then
                        RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_3_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
                        sObj.Goal2 = 0
                    end
                else
                    ShowBalloonText(self, "CHAR120_MSTEP3_BALLOON_TEXT2", 5)
                end
            end
        end
    elseif zone_Name == "f_flash_64" then --NAKMUAY_MSTEP5_4
        if sObj.Step4 == 1 then
            if GetInvItemCount(self, "CHAR120_MSTEP5_4_ITEM2") < 48 then
                if argObj.ClassName == "Repusbunny" or argObj.ClassName == "Lemuria" or argObj.ClassName == "Rubabos" then
                    local ran = IMCRandom(1, 1000)
                    local item = GetInvItemCount(self, "CHAR120_MSTEP5_4_ITEM3")
                    if item < 3 then
                        sObj.Goal3 = sObj.Goal3 + 1
                        if sObj.Goal3 >= 72 then
                            RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_4_ITEM3", 1, "Quest_HIDDEN_NAKMUAY")
                            sObj.Goal3 = 0
                            return
                        end
                        if ran <= 13 then
                            RunZombieScript("GIVE_ITEM_TX", self, "CHAR120_MSTEP5_4_ITEM3", 1, "Quest_HIDDEN_NAKMUAY")
                            sObj.Goal3 = 0
                        end
                    end
                end
            end
        end
    end
end

function SCR_NAKMUAY_DANDELION_GEN(self, sObj)
    if sObj.Goal5 >= 1 then
        NAKMUAY_DANDELION_TIME_CHECK(self, sObj, "String1", "String4", "Goal5")
    end
    
    if sObj.Goal6 >= 1 then
        NAKMUAY_DANDELION_TIME_CHECK(self, sObj, "String2", "String5", "Goal6")
    end
    
    if sObj.Goal7 >= 1 then
        NAKMUAY_DANDELION_TIME_CHECK(self, sObj, "String3", "String6", "Goal7")
    end
    
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if hidden_Prop == 200 then
        
    end
end

function NAKMUAY_DANDELION_TIME_CHECK(self, sObj, _String1, _String2, _Goal)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _today = tonumber(year..month..day);
    local _time = tonumber(hour * 60 + min);
    
    local string_cut_list1 = SCR_STRING_CUT(sObj[_String1]);
    local _next_time = 10
    
    if string_cut_list1[2] == nil then
        string_cut_list1[2] = "0"
    end
    
    if string_cut_list1[1] ~= nil and string_cut_list1[2] ~= nil then
        local _last_day = tonumber(string_cut_list1[1]);
        local _last_time = tonumber(string_cut_list1[2]);
        
        if _last_day ~= _today then
            _last_time = _last_time - 1440;
        end
        
        --print('BBB', _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
        if sObj[_String1] ~= nil or sObj[_String1] ~= "None" then
            if _time >= _last_time + _next_time then
                 if GetZoneName(self) == "f_flash_64" then
                    local flower = GetScpObjectList(self, 'CHAR120_DANDELION'.._Goal)
                    if #flower < 1 then
                        local string_cut_list2 = SCR_STRING_CUT(sObj[_String2]);
                        local mon = CREATE_MONSTER_EX(self, 'farm47_dandelion_01', string_cut_list2[1], string_cut_list2[2], string_cut_list2[3], 0, 'Neutral', 0, SCR_NAKMUAY_DANDELION_SET)
                        AddVisiblePC(mon, self, 1)
                        mon.StrArg1 = "sObj.".._Goal
                        AddScpObjectList(self, "CHAR120_DANDELION".._Goal, mon);
                    end
                    if #flower >= 2 then
                        for i = 2, #_obj do
                            Kill(_obj[i])
                        end
                    end
                end
            end
        end
    end
end

function SCR_NAKMUAY_DANDELION_SET(mon)
    mon.Dialog = "NAKMUAY_DANDEL_DLG"
    mon.Name = "UnvisibleName"
end

function SCR_NAKMUAY_DANDEL_DLG_DIALOG(self, pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if hidden_Prop == 100 then
        if sObj ~= nil then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR120_MSTEP5_4_ITEM3_GET"), 'sitgrope', 1)
            if result == 1 then
                if self.StrArg1 == "sObj.Goal5" then
                    sObj.Goal5 = 0
                    sObj.String1 = "None"
                    sObj.String4 = "None"
                elseif self.StrArg1 == "sObj.Goal6" then
                    sObj.Goal6 = 0
                    sObj.String2 = "None"
                    sObj.String5 = "None"
                elseif self.StrArg1 == "sObj.Goal7" then
                    sObj.Goal7 = 0
                    sObj.String3 = "None"
                    sObj.String6 = "None"
                else
                    return
                end
                SaveSessionObject(pc, sObj)
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_4_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
                PlayEffectLocal(self, pc, "F_pc_making_finish_white", 2, 0, "BOT")
                Kill(self)
            end
        end
    end
end

function SCR_JELLYFISH_RED_GIVE(pc)
    local ran2 = IMCRandom(1, 100)
    local itemcnt = 1
    if ran2 <= 8 then
        itemcnt = 3
    end
    return itemcnt
end