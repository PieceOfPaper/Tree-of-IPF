
function SCR_DRAGOON_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_WARLOCK_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_FEATHERFOOT_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_CANNONEER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_MUSKETEER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_PLAGUEDOCTOR_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KABBALIST_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_SHINOBI_MASTER_DIALOG(self,pc)
    -- 시노비 해금 여부 확인 if문 필요 --
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_13');
    if is_unlock == 'YES' then
    	COMMON_QUEST_HANDLER(self,pc)
    elseif IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    else
        if GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_5') >= 1 then
			local isLockState = 0
            ShowOkDlg(pc, 'JOB_SHINOBI_HIDDEN_SHINOBI_MASTER_dlg1', 1)
            local tx1 = TxBegin(pc);
            local shinobi_item = {
                                    'R_JOB_SHINOBI_HIDDEN_1',
                                    'R_JOB_SHINOBI_HIDDEN_2',
                                    'JOB_SHINOBI_HIDDEN_ITEM_1',
                                    'JOB_SHINOBI_HIDDEN_ITEM_2',
                                    'JOB_SHINOBI_HIDDEN_ITEM_3',
                                    'JOB_SHINOBI_HIDDEN_ITEM_4',
                                    'JOB_SHINOBI_HIDDEN_ITEM_5',
                                    'JOB_SHINOBI_HIDDEN_ITEM_6'
                                    }
            for i = 1, #shinobi_item do
                if GetInvItemCount(pc, shinobi_item[i]) >= 1 then
					local invItem, cnt = GetInvItemByName(pc, shinobi_item[i])
					if IsFixedItem(invItem) == 1 then
						isLockState = 1
					end
                    TxTakeItem(tx1, shinobi_item[i], GetInvItemCount(pc, shinobi_item[i]), 'Q_JOB_SHINOBI_7_1');
                end
            end
            local ret = TxCommit(tx1);
            if ret == "SUCCESS" then
                local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char1_13')
                if ret2 == "FAIL" then
                    print("tx FAIL!")
                end
            else
				if isLockState == 1 then
					SendSysMsg(pc, 'QuestItemIsLocked');
				end
                print("tx FAIL!")
            end
        end
    end
end



function SCR_CHAPLAIN_MASTER_DIALOG(self,pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_12');
    if is_unlock == 'YES' then
    	COMMON_QUEST_HANDLER(self,pc)
    elseif IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    else
        local prs_rank = GetJobGradeByName(pc, 'Char4_2')
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_12');
        if (hidden_prop == 100 or hidden_prop == 200) and prs_rank >= 3 then
            ShowOkDlg(pc, 'CHAPLAIN_MASTER_Chaplain_YES', 1)
            local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_12')
            if ret1 == "FAIL" then
                print("tx FAIL! : Hidden Chaplain")
            end
        elseif hidden_prop == 100 and prs_rank < 3 then
            ShowOkDlg(pc, 'CHAPLAIN_MASTER_Chaplain_NO', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_12', 200)
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    end
    --THORN22_HQ1 unlock
    local quest = SCR_QUEST_CHECK(pc, "THORN22_HQ1")
    if quest == "IMPOSSIBLE" then
        local item = GetInvItemCount(pc, "Drug_powder")
        if item >= 1 then
            local sel = ShowSelDlg(pc, 1, "THORN22_HIDDEN_DLG1", ScpArgMsg("THORN22_HIDDENQ1_MSG2"),ScpArgMsg("THORN22_HIDDENQ1_MSG3"))
            if sel == 1 then
                RunZombieScript("TAKE_ITEM_TX", pc, "Drug_powder", 1, "THORN22_HIDDENQ1_PRE")
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('THORN22_HIDDENQ1_MSG4'), 5)
                local sObj = GetSessionObject(pc, "SSN_THORN22_HQ1_UNLOCK")
                if sObj == nil then
                    CreateSessionObject(pc, "SSN_THORN22_HQ1_UNLOCK")
                end
                ShowOkDlg(pc, "THORN22_HIDDEN_DLG2", 1)
            else
                ShowOkDlg(pc, "THORN22_HIDDEN_DLG3", 1)
            end
        end
    end
end



function SCR_RUNECASTER_MASTER_DIALOG(self,pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char2_17');
    if is_unlock == 'YES' then
    	COMMON_QUEST_HANDLER(self,pc)
    elseif IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    else
        local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
        if _hidden_prop == 258 then
            local select = ShowSelDlg(pc,0, 'HIDDEN_RUNECASTER_master_dlg1', ScpArgMsg("HIDDEN_RUNECASTER_master_msg1"), ScpArgMsg("HIDDEN_RUNECASTER_master_msg2"))
            if select == 1 then
                local _class = GetJobGradeByName(pc, 'Char2_1')
                if _class >= 1 then
                    ShowOkDlg(pc, 'HIDDEN_RUNECASTER_master_dlg2', 1)
                else
                    ShowOkDlg(pc, 'HIDDEN_RUNECASTER_master_dlg3', 1)
                end
                local runestone_item = {
                                        'HIDDEN_RUNECASTER_ITEM_1',
                                        'HIDDEN_RUNECASTER_ITEM_2',
                                        'HIDDEN_RUNECASTER_ITEM_3',
                                        'HIDDEN_RUNECASTER_ITEM_4',
                                        'HIDDEN_RUNECASTER_ITEM_5',
                                        'HIDDEN_RUNECASTER_ITEM_6'
                                        }
                
                local tx1 = TxBegin(pc);
                for i = 1, #runestone_item do
                    if GetInvItemCount(pc, runestone_item[i]) >= 1 then
                        TxTakeItem(tx1, runestone_item[i], GetInvItemCount(pc, runestone_item[i]), 'Quest_HIDDEN_RUNECASTER');
                    end
                end
                local ret = TxCommit(tx1);
                if ret == "SUCCESS" then
                    local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char2_17')
                    if ret2 == "FAIL" then
                        print("tx FAIL!")
                    end
                else
                    print("tx FAIL!")
                end
            end
        end
    end
end



function SCR_MIKO_MASTER_DIALOG(self,pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_18');
    if is_unlock == 'YES' then
        CATHEDRAL1_HIDDENQ1_CONDI_SET(self, pc)
    	COMMON_QUEST_HANDLER(self,pc)
    else
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_18');
        if hidden_prop == 101 or hidden_prop == 200 then
            -- 1 = M, 2 = F --
            local pcGender = pc.Gender
            local _is_cleric = GetJobGradeByName(pc, 'Char4_1')
            
            if hidden_prop == 101 then
--                ShowOkDlg(pc, 'HIDDEN_MIKO_MASTER_dlg1', 1)
                local select = ShowSelDlg(pc, 0, 'HIDDEN_MIKO_MASTER_dlg1', ScpArgMsg("HIDDEN_MIKO_MASTER_dlg1_YES"), ScpArgMsg("HIDDEN_MIKO_MASTER_dlg1_NO"))
                if select == 1 then
                    local item_cnt = GetInvItemCount(pc, 'HIDDEN_MIKO_ITEM_2')
                    if item_cnt >= 1 then
                        ShowOkDlg(pc, 'HIDDEN_MIKO_MASTER_dlg2', 1)
                        local tx1 = TxBegin(pc);
                        TxTakeItem(tx1, 'HIDDEN_MIKO_ITEM_2', item_cnt, 'Quest_MIKO');
                        local ret = TxCommit(tx1);
                        if ret ~= "SUCCESS" then
                            return;
                        end
                    end
                    
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_18', 200)
                    
                    if pcGender == 2 and _is_cleric >= 1 then
                        local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_18')
                        if ret1 == "FAIL" then
                            print("tx FAIL! : Hidden Miko")
                        end
                        ShowOkDlg(pc, 'MIKO_MASTER_Miko_YES', 1)
                        return;
                    elseif pcGender ~= 2 and _is_cleric >= 1 then
                        ShowOkDlg(pc, 'MIKO_MASTER_Miko_NO_1', 1)
                        return;
                    else
                        ShowOkDlg(pc, 'MIKO_MASTER_Miko_NO_2', 1)
                        return;
                    end
                else
                    return;
                end
            end
            
            if pcGender == 2 and _is_cleric >= 1 then
                local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_18')
                if ret1 == "FAIL" then
                    print("tx FAIL! : Hidden Miko")
                end
                ShowOkDlg(pc, 'MIKO_MASTER_Miko_YES', 1)
                return;
            else
                CATHEDRAL1_HIDDENQ1_CONDI_SET(self, pc)
                COMMON_QUEST_HANDLER(self,pc)
            end
        else
            COMMON_QUEST_HANDLER(self,pc)
        end
    end
end



function SCR_DRAGOON_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_15')
end

-- Templar --
function SCR_KLAPEDA_USKA_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_16')
end

function SCR_KLAPEDA_USKA_NORMAL_2_PRE(pc)
    if EnableGuildTask(pc) == 1 then
        return 'YES';
    end
    return 'NO';

end

function SCR_KLAPEDA_USKA_NORMAL_4_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 1 then
        local result = SCR_QUEST_CHECK(pc, "CMINE6_TO_KATYN7_2")
        if result == "COMPLETE" then
--    local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
--    if sObj.Step1 == 1 then
            return 'YES'
        end
    end
end

function SCR_WARLOCK_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_15')
end

function SCR_FEATHERFOOT_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_16')
end

function SCR_CANNONEER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_15')
end

function SCR_MUSKETEER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_16')
end

function SCR_PLAGUEDOCTOR_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_14')
end

function SCR_KABBALIST_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_15')
end

function SCR_MURMILO_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_12')
end

function SCR_LANCER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_17')
end

function SCR_MERGEN_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_17')
end

function SCR_HACKAPELL_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_7')
end

function SCR_SHINOBI_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char1_13')
end

function SCR_CHAPLAIN_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_12')
end

function SCR_RUNECASTER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_17')
end

function SCR_MIKO_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char4_18')
end



function SCR_DRAGOON_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Dragoon")
end

-- Templar --
function SCR_KLAPEDA_USKA_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Templar")
end

function SCR_KLAPEDA_USKA_NORMAL_2(self,pc)
    if EnableGuildTask(pc) ~= 1 then
        SendSysMsg(pc, 'MinLevelForGuildTaskIs{LEVEL}', 0, 'LEVEL', MIN_LEVEL_FOR_GUILD_TASK);
        return;
    end

	local guildObj = GetGuildObj(pc);
	if guildObj ~= nil then
		local teamName = GetTeamName(pc);
		SendSysMsg(pc, "{PC}AlreadyBelongsToGuild", 0, "PC", teamName);		
		return;
	end
	
	ExecClientScp(pc, "OPEN_GUILD_CREATE_UI()");

end

function SCR_KLAPEDA_USKA_NORMAL_3(self,pc)
    ShowTradeDlg(pc, 'Klapeda_Guild', 5);
end

function SCR_KLAPEDA_USKA_NORMAL_4(self, pc)
    ShowOkDlg(pc, "CHAR313_MSTEP2_1_DLG2", 1)
    ShowBalloonText(pc, "CHAR313_MSTEP2_1_MSG1", 5)
    UIOpenToPC(pc,'fullblack',1)
    sleep(1000)
    UIOpenToPC(pc,'fullblack',0)
    ShowOkDlg(pc, "CHAR313_MSTEP2_1_DLG3", 1)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char3_13');
    if hidden_prop == 1 then
        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 10);
        UnHideNPC(pc, "HIDDEN_APPRAISER_KLAIPE")
    end
end

function SCR_WARLOCK_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Warlock")
end

function SCR_FEATHERFOOT_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Featherfoot")
end

function SCR_CANNONEER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Cannoneer")
end

function SCR_MUSKETEER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Musketeer")
end

function SCR_PLAGUEDOCTOR_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_PlagueDoctor")
end

function SCR_KABBALIST_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Kabbalist")
end

function SCR_MURMILO_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Murmillo")
end

function SCR_LANCER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Lancer")
end

function SCR_MERGEN_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Mergen")
end

function SCR_HACKAPELL_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Hackapell")
end















--HIDDEN

function SCR_SHINOBI_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Shinobi")
end

function SCR_SHINOBI_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Shinobi', 5);
end

function SCR_CHAPLAIN_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Chaplain")
end

function SCR_CHAPLAIN_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_Chaplain', 5);
end

function SCR_RUNECASTER_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_RuneCaster")
end

function SCR_RUNECASTER_MASTER_NORMAL_2(self, pc)
    ShowTradeDlg(pc, 'Master_RuneCaster', 5);
end

function SCR_MIKO_MASTER_NORMAL_1(self, pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Miko")
end



























































function SCR_JOB_FENCER_7_1_WOOD_CARVING_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_FENCER_7_1_WOOD_CARVING_ENTER(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_FENCER_7_1_WOOD_CARVING_AI_RUN(self)
    if self.NumArg1 <= 0 then
        local buff = GetBuffByName(self, 'JOB_FENCER_7_1_BUFF')
        if buff == nil then
            PlayEffect(self, 'F_light019', 0.6, nil, 'MID')
            AddBuff(self, self, 'JOB_FENCER_7_1_BUFF', 1, 0, 1200, 1)
            self.NumArg1 = IMCRandom(2, 10);
        end
    else
        self.NumArg1 = self.NumArg1 - 1;
    end
end

--MUSKETEER_8_1
function SCR_JOB_MUSKETEER_8_1_WOOD_CARVING_ENTER(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_MUSKETEER_8_1_WOOD_CARVING_AI_RUN(self)
    if self.NumArg1 <= 0 then
        local buff = GetBuffByName(self, 'JOB_MUSKETEER_8_1_BUFF')
        if buff == nil then
            PlayEffect(self, 'F_light019', 0.6, nil, 'MID')
            AddBuff(self, self, 'JOB_MUSKETEER_8_1_BUFF', 1, 0, 1200, 1)
            self.NumArg1 = IMCRandom(2, 8);
        end
    else
        self.NumArg1 = self.NumArg1 - 1;
    end
end

--CANNONEER_8_1
function SCR_JOB_CANNONEER_8_1_ENTER(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

--HACKAPELL_8_1
function SCR_HACKAPELL_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_HACKAPELL_MASTER_IN_ENTER(self,pc)
    --REMAINS373_HQ1 condition check
    local result = SCR_QUEST_CHECK(pc, "REMAINS373_HQ1")
    if result == "IMPOSSIBLE" then
    local sObj = GetSessionObject(pc, "SSN_REMAINS373_HQ1_UNLOCK")
        if sObj == nil then
            --print("111111")
            CreateSessionObject(pc, "SSN_REMAINS373_HQ1_UNLOCK")
        end
    end
end


function SCR_JOB_HACKAPELL_8_1_OBJ_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_HACKAPELL_8_1')
    if result == 'PROGRESS' then
        local Timmer, sObj = SCR_DOCHARGE_ACTION(self, pc, IMCRandom(10, 25))
        AttachEffect(self, 'F_sys_trigger_point_blue', 3)
        AttachEffect(pc, 'F_sys_trigger_point_blue', 2)
        local result  = DOTIMEACTION_CHARGE(pc, self, ScpArgMsg("JOB_HACKAPELL_8_1_DTA"), 'SITABSORB', Timmer, 'SSN_JOB_HACKAPELL_8_1', 1, 'SSN_HATE_AROUND')
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("JOB_HACKAPELL_8_1_1"), 5);
            DetachEffect(pc, 'F_sys_trigger_point_blue')
            Kill(self)
        elseif result == 0 then
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("JOB_HACKAPELL_8_1_2"), 5);
            DetachEffect(self, 'F_sys_trigger_point_blue')
            DetachEffect(pc, 'F_sys_trigger_point_blue')
            PlayEffect(self, 'I_light013_spark_blue', 1, 'MID')
        else
            DetachEffect(self, 'F_sys_trigger_point_blue')
            PlayEffect(self, 'I_light013_spark_blue', 1, 'MID')
        end
    end
end

--MERGEN_8_1
function SCR_MERGEN_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

--FALCONER_8_1
function SCR_JOB_FALCONER_8_1_ENTER(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

--DRAGOON_8_1
function SCR_JOB_DRAGOON_8_1_KEY_DIALOG(self, pc)
end

function SCR_JOB_DRAGOON_8_1_RUN(self, x, y, z)
    local mon = CREATE_MONSTER_EX(self, 'Hiddennpc', x, y, z, 0, 'Neutral', 0, SCR_JOB_DRAGOON_8_1_MON)
    AddVisiblePC(mon, self, 1)
    AttachEffect(mon, 'F_light037_blue', 5, 'BOT');
    SetLifeTime(mon, 30)
    ShowBalloonText(self, 'JOB_DRAGOON_8_1_DLG', 5)
end

function SCR_JOB_DRAGOON_8_1_MON(mon)
	mon.BTree = "None"
    mon.Tactics = "None"
	mon.Name = 'UnvisibleName'
	mon.Dialog = "JOB_DRAGOON_8_1"
end

function SCR_JOB_DRAGOON_8_1_DIALOG(self, pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_DRAGOON_8_1')
    if result == 'PROGRESS' then
        local sObj = GetSessionObject(pc, 'SSN_JOB_DRAGOON_8_1')
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 1, 'JOB_DRAGOON_8_1')
        local result1 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_DRAGOON_8_1_TRAP"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result1, animTime, before_time, 'JOB_DRAGOON_8_1')
        if result1  == 1 then
            if sObj ~= nil then
                RunScript('GIVE_ITEM_TX',pc, 'JOB_DRAGOON_8_1_ITEM2', 1, 'Quest_JOB_DRAGOON_8_1')
                Kill(self)
            end
        end
    end
end

--JOB_LANCER_8_1
function SCR_JOB_LANCER_8_1_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_LANCER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

--JOB_MURMILO_8_1
function SCR_MURMILO_MASTER_DIALOG(self,pc)
	local quest_check = SCR_QUEST_CHECK(pc, "FLASH64_HQ1")
	if quest_check == "IMPOSSIBLE" then
	    CreateSessionObject(pc, "SSN_FLASH64_HQ1_UNLOCK")
	end
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_MURMILLO_8_1_ENTER(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

--JOB_ZEALOT
function SCR_ZEALOT_MASTER_DIALOG(self,pc)
    local jobCircle = GetJobGradeByName(pc, 'Char4_19')
    if jobCircle > 0 then
        COMMON_QUEST_HANDLER(self,pc)
        local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_19')
        if is_unlock == "YES" then
            return
        end
    end
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_19')
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local chk = math.floor(SCR_DATE_TO_YMIN_BASIC_2000(year, month, day, hour, min))
    local sObj_main = GetSessionObject(pc, 'ssn_klapeda')
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_19');

    if IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    elseif is_unlock == "YES" then
        COMMON_QUEST_HANDLER(self,pc)
    else
        if _hidden_prop == 0 then
            return;
        elseif _hidden_prop == 5 then
            print("C")
            local select1 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG3', ScpArgMsg('ZEALOT_MASTER_MSG1'), ScpArgMsg('ZEALOT_MASTER_MSG2'))
            if select1 == 1 then
                ShowOkDlg(pc, 'ZEALOT_MASTER_DLG4', 1)
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 10)
                local select2 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG3', ScpArgMsg('ZEALOT_MASTER_MSG3'), ScpArgMsg('ZEALOT_MASTER_MSG2'))
                if select2 == 1 then
                    ShowOkDlg(pc, 'ZEALOT_MASTER_DLG5', 1)
                    local select3 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG3', ScpArgMsg('ZEALOT_MASTER_MSG4'), ScpArgMsg('ZEALOT_MASTER_MSG2'))
                    if select3 == 1 then
                        ShowOkDlg(pc, 'ZEALOT_MASTER_DLG6', 1)
                        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 20)
                        local tx = TxBegin(pc)
                        TxGiveItem(tx, 'ZEALOT_BOOK1', 1, "JOB_ZEALOT_UNLOCK")
                        local ret = TxCommit(tx)
                    elseif select3 == 2 then
                        return;
                    end
                elseif select2 == 2 then
                    return;
                end
            elseif select1 == 2 then
                return;
            end
        elseif _hidden_prop == 10 then
            local select2 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG3', ScpArgMsg('ZEALOT_MASTER_MSG3'), ScpArgMsg('ZEALOT_MASTER_MSG2'))
            if select2 == 1 then
                ShowOkDlg(pc, 'ZEALOT_MASTER_DLG5', 1)
                local select3 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG3', ScpArgMsg('ZEALOT_MASTER_MSG4'), ScpArgMsg('ZEALOT_MASTER_MSG2'))
                if select3 == 1 then
                    ShowOkDlg(pc, 'ZEALOT_MASTER_DLG6', 1)
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 20)
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'ZEALOT_BOOK1', 1, "JOB_ZEALOT_UNLOCK")
                    local ret = TxCommit(tx)
                elseif select3 == 2 then
                    return;
                end
            elseif select2 == 2 then
                return;
            end
        elseif _hidden_prop == 20 then
            if sObj_main.JOB_ZEALOT_TIMER <= chk then
                local select4 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG7', ScpArgMsg('ZEALOT_MASTER_MSG5'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                if select4 == 1 then
                    ShowOkDlg(pc, 'ZEALOT_MASTER_DLG8', 1)
                    local zealot_q = IMCRandom(1, 3)
                    local select5 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_Q'..zealot_q, ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A1'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A2'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A3'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                    if select5 == 1 then
                        if zealot_q == 1 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC1', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 50)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select5 == 2 then
                        if zealot_q == 3 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC1', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 50)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select5 == 3 then
                        if zealot_q == 2 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC1', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 50)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select5 == 4 then
                        ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                    end
                elseif select4 == 2 then
                    return;
                end
            else
                ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP2', 1)
            end
        elseif _hidden_prop == 50 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG9', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 50+IMCRandom(1, 10))
        elseif _hidden_prop >= 51 and _hidden_prop <= 60 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG10', 1)
        elseif _hidden_prop == 100 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG11', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 110)
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'ZEALOT_BOOK2', 1, "JOB_ZEALOT_UNLOCK")
            local ret = TxCommit(tx)
        elseif _hidden_prop == 110 then
            if sObj_main.JOB_ZEALOT_TIMER <= chk then
                local select6 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG12', ScpArgMsg('ZEALOT_MASTER_MSG5'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                if select6 == 1 then
                    ShowOkDlg(pc, 'ZEALOT_MASTER_DLG13', 1)
                    local zealot_q = IMCRandom(4, 6)
                    local select7 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_Q'..zealot_q, ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A1'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A2'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A3'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                    if select7 == 1 then
                        if zealot_q == 6 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC2', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 120)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 2 then
                        if zealot_q == 5 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC2', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 120)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 3 then
                        if zealot_q == 4 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC2', 1)
                            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 120)
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 4 then
                        ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                    end
                elseif select4 == 2 then
                    return;
                end
            else
                ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP2', 1)
            end
        elseif _hidden_prop == 120 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG14', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 120+IMCRandom(1, 15))
        elseif _hidden_prop >= 121 and _hidden_prop <= 135 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG15', 1)
        elseif _hidden_prop == 200 then
            ShowOkDlg(pc, 'ZEALOT_MASTER_DLG16', 1)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char4_19', 250)
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'ZEALOT_BOOK3', 1, "JOB_ZEALOT_UNLOCK")
            local ret = TxCommit(tx)
        elseif _hidden_prop == 250 then
            if sObj_main.JOB_ZEALOT_TIMER <= chk then
                local select6 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_DLG17', ScpArgMsg('ZEALOT_MASTER_MSG5'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                if select6 == 1 then
                    ShowOkDlg(pc, 'ZEALOT_MASTER_DLG18', 1)
                    local zealot_q = 8 IMCRandom(7, 9)
                    local select7 = ShowSelDlg(pc, 0, 'ZEALOT_MASTER_Q'..zealot_q, ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A1'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A2'), ScpArgMsg('ZEALOT_MASTER_Q'..zealot_q..'_A3'), ScpArgMsg('ZEALOT_MASTER_MSG6'))
                    if select7 == 1 then
                        if zealot_q == 9 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC3', 1)
                            local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_19')
                            if ret1 == "FAIL" then
                                print("tx FAIL! : ZEALOT")
                            end
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 2 then
                        if zealot_q == 8 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC3', 1)
                            local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_19')
                            if ret1 == "FAIL" then
                                print("tx FAIL! : ZEALOT")
                            end
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 3 then
                        if zealot_q == 7 then
                            ShowOkDlg(pc, 'ZEALOT_MASTER_SUCC3', 1)
                            local ret1 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char4_19')
                            if ret1 == "FAIL" then
                                print("tx FAIL! : ZEALOT")
                            end
                        else
                            ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                            local tx = TxBegin(pc)
                            TxSetIESProp(tx, sObj_main, 'JOB_ZEALOT_TIMER', chk+10)
                            local ret = TxCommit(tx)
                        end
                    elseif select7 == 4 then
                        ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP', 1)
                    end
                elseif select4 == 2 then
                    return;
                end
            else
                ShowOkDlg(pc, 'ZEALOT_MASTER_GIVEUP2', 1)
            end
        end
    end
end



























































--HIDDEN CLASS UNLOCK NPC SCRIPTS--
function SCR_SHINOBI_YELLOW_EYES_FLOWER_DIALOG(self,pc)
    if GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_3') == 0 then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 5, 'SHINOBI_YELLOW_EYES_FLOWER')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("SHINOBI_YELLOW_EYES_FLOWER_MSG1"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'SHINOBI_YELLOW_EYES_FLOWER')
        if result == 1 then
            local tx1 = TxBegin(pc);
            TxGiveItem(tx1, "JOB_SHINOBI_HIDDEN_ITEM_3", 1, "Quest_JOB_SHINOBI_HIDDEN");
            local ret = TxCommit(tx1);
            PlayEffect(self, 'F_pc_making_finish_orange', 2.0, nil, 'MID')
            HideNPC(pc, 'SHINOBI_YELLOW_EYES_FLOWER')
        end
    end
end

function SCR_SHINOBI_POTTER_DIALOG(self,pc)
    if IS_KOR_TEST_SERVER() then
        return
    end
    if GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_4') == 0 then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 3, 'SHINOBI_POTTER')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("SHINOBI_POTTER_MSG1"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'SHINOBI_POTTER')
        if result == 1 then
            local tx1 = TxBegin(pc);
            TxGiveItem(tx1, "JOB_SHINOBI_HIDDEN_ITEM_4", 1, "Quest_JOB_SHINOBI_HIDDEN");
            local ret = TxCommit(tx1);
            PlayEffect(self, 'F_pc_making_finish_orange', 1.0, nil, 'MID')
            HideNPC(pc, 'SHINOBI_POTTER')
        end
    end
end

function SCR_SHINOBI_POTTER_AI_BORN_RUN(self)
    SetLifeTime(self, 1800);
end

function SCR_SHINOBI_MASTER_UNHIDE_TRIGGER_ENTER(self,pc)
    if GetInvItemCount(pc, 'JOB_SHINOBI_HIDDEN_ITEM_5') >= 1 then
        if isHideNPC(pc, "SHINOBI_MASTER") == "YES" then
            UnHideNPC(pc, "SHINOBI_MASTER")
        end
    end
    --TABLELAND28_1_HQ1 UNLOCK
    local quest = SCR_QUEST_CHECK(pc, "TABLELAND28_1_HQ1")
    if quest == "IMPOSSIBLE" then
        local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_13');
        if is_unlock == 'YES' then
            CreateSessionObject(pc, "SSN_TABLELAND28_1_HQ1_UNLOCK")
        end
    end
end

function SCR_SHINOBI_FLOWER_TAC_TS_BORN_ENTER(self)
--    SetLifeTime(self, 300);
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _last_gen = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
    local _next_time = IMCRandom(120, 240)
    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
--    print('AAA', _last_gen, _next_time)
end

function SCR_SHINOBI_FLOWER_TAC_TS_BORN_UPDATE(self)
    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    if argstr1 ~= nil and argstr1 ~= 'None' and argstr2 ~= nil and argstr2 ~= 'None' then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        
        
        local _today = tonumber(year..month..day);
        local _time = tonumber(hour * 60) + tonumber(min);
        
        local string_cut_list = SCR_STRING_CUT(argstr1);
        local _next_time = tonumber(argstr2);
        if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
            local _last_day = tonumber(string_cut_list[1]);
            local _last_time = tonumber(string_cut_list[2]);
            
            if _last_day ~= _today then
                _last_time = _last_time - 1440;
            end
--            print('BBB', _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
            if _time == _last_time + _next_time then
                local _flower = GetScpObjectList(self, 'SHINOBI_FLOWER_CREAT')
                if #_flower == 0 then
                    local _last_gen = tostring(_today).."/"..tostring(_time);
                    _next_time = IMCRandom(120, 240);
                    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
                    
                    local pos1 = GetExProp(self, 'HIDDEN_SHINOBI_FLOWER1_POS_1')
                    local pos2 = GetExProp(self, 'HIDDEN_SHINOBI_FLOWER1_POS_2')
                    local pos3 = GetExProp(self, 'HIDDEN_SHINOBI_FLOWER1_POS_3')
                    local pos4 = GetExProp(self, 'HIDDEN_SHINOBI_FLOWER1_POS_4')
                    local pos_arr = {pos1, pos2, pos3, pos4}
                    
                    local loc = {}
                    loc[1] = {581, -1, 403}
                    loc[2] = {514, -1, 263}
                    loc[3] = {758, -1, 11}
                    loc[4] = {918, -1, 186}
                    
                    local x, y, z
                    local target_pos = SHINOBI_FLOWER_LOC_CK(self, pos_arr)
                    x = loc[target_pos][1]
                    y = loc[target_pos][2]
                    z = loc[target_pos][3]
                    
                    local mon = CREATE_MONSTER_EX(self, 'npc_orchard_flower', x, y, z, 0, 'Neutral', nil, SCR_SHINOBI_FLOWER_SET);
                    SetLifeTime(mon, 900); --900
                    AddScpObjectList(self, 'SHINOBI_FLOWER_CREAT', mon)
                    EnableAIOutOfPC(mon)
                    for i = 1, #pos_arr do
                        if pos_arr[i] > 0 then
                            SetExProp(self, tostring('HIDDEN_SHINOBI_FLOWER1_POS_'..i), 0)
                        end
                    end
                    SetExProp(self, tostring('HIDDEN_SHINOBI_FLOWER1_POS_'..target_pos), 1)
                    --print('CREAT!! '..x.." ", y.." ", z)
                elseif #_flower >= 2 then
                    local i
                    for i = 2, #_flower do
                        Kill(_flower[i])
                    end
                end
            end
        end
    end
end

function SCR_SHINOBI_FLOWER_TAC_TS_BORN_LEAVE(self)
end

function SCR_SHINOBI_FLOWER_TAC_TS_DEAD_ENTER(self)
end

function SCR_SHINOBI_FLOWER_TAC_TS_DEAD_UPDATE(self)
end

function SCR_SHINOBI_FLOWER_TAC_TS_DEAD_LEAVE(self)
end

function SCR_SHINOBI_FLOWER_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "SHINOBI_YELLOW_EYES_FLOWER"
	mon.MaxDialog = 1;
end

function SHINOBI_FLOWER_LOC_CK(self,  pos_arr)
    local i
    local j = 0
    local random = {}
    for i = 1, #pos_arr do
        if pos_arr[i] == 0 then
            random[j+1] = pos_arr[i] + i
            j = j + 1
        end
    end
    
    local rnd = select(IMCRandom(1,3), random[1], random[2], random[3])
    return rnd
end

--HIDDEN_RUNECASTER
function SCR_RUNECASTER_ZACHARIEL_TS_BORN_ENTER(self)
end

function SCR_RUNECASTER_ZACHARIEL_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    if min == 0 then
        local _zone = GetZoneName(self)
        local i
        local my_num = 0
        for i = 1, 5 do
            if _zone == 'd_zachariel_3'..1+i then
                my_num = i;
            end
        end

        if my_num ~= 0 then
            local rnd_gen = math.floor(((tonumber(year) + tonumber(month) + tonumber(day) + (tonumber(hour) * 13)) % 5) + 1);
            if tonumber(my_num) == rnd_gen then
                if self.NumArg1 == 0 then
                    local _stone = GetScpObjectList(self, 'RUNECASTER_ZACHARIEL_CREATE')
                    if #_stone == 0 then
                        self.NumArg1 = 1;
                        local x, y, z = GetPos(self)
                        local mon = CREATE_MONSTER_EX(self, 'pcskill_rune_stone', x, y, z, 0, 'Neutral', nil, SCR_RUNECASTER_ZACHARIEL_SET);
                        FlyMath(mon, 20, 0, 0)
                        SetLifeTime(mon, 600);
                        AddScpObjectList(self, 'RUNECASTER_ZACHARIEL_CREATE', mon)
                        EnableAIOutOfPC(mon)
                    elseif #_stone >= 2 then
                        for i = 2, #_stone do
                            Kill(_stone[i])
                        end
                    end
                end
            end
        end
    else
        if self.NumArg1 ~= 0 then
            self.NumArg1 = 0;
        end
    end
end

function SCR_RUNECASTER_ZACHARIEL_TS_BORN_LEAVE(self)
end

function SCR_RUNECASTER_ZACHARIEL_TS_DEAD_ENTER(self)
end

function SCR_RUNECASTER_ZACHARIEL_TS_DEAD_UPDATE(self)
end

function SCR_RUNECASTER_ZACHARIEL_TS_DEAD_LEAVE(self)
end

function SCR_RUNECASTER_ZACHARIEL_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "RUNECASTER_ZACHARIEL_STONE"
	mon.MaxDialog = 1;
end

function SCR_RUNECASTER_ZACHARIEL_STONE_DIALOG(self, pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop == 257 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_2') == 0 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("RUNECASTER_ZACHARIEL_STONE_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
            if result == 1 then
                local tx1 = TxBegin(pc);
                TxGiveItem(tx1, "HIDDEN_RUNECASTER_ITEM_2", 1, "Quest_HIDDEN_RUNECASTER");
                local ret = TxCommit(tx1);
                if ret == 'SUCCESS' then
                    HideNPC(pc, 'RUNECASTER_ZACHARIEL_STONE')
                    self.Dialog = 'None'
                    KILL_BLEND(self, 1, 1)
                end
            end
        end
    end
end





function SCR_RUNECASTER_CHRONO_TS_BORN_ENTER(self)
    local rnd = IMCRandom(1, 120)*60000;
    AddBuff(self, self, 'RUNECASTER_NPC_3_BUFF', 1, 0, 7200000+rnd, 1)
    SCR_MON_DUMMY_TS_BORN_ENTER(self)
end

function SCR_RUNECASTER_CHRONO_TS_BORN_UPDATE(self)
    SCR_MON_DUMMY_TS_BORN_UPDATE(self)
end

function SCR_RUNECASTER_CHRONO_TS_BORN_LEAVE(self)
    SCR_MON_DUMMY_TS_BORN_LEAVE(self)
end

function SCR_RUNECASTER_CHRONO_TS_DEAD_ENTER(self)
    SCR_MON_DUMMY_TS_DEAD_ENTER(self)
end

function SCR_RUNECASTER_CHRONO_TS_DEAD_UPDATE(self)
    SCR_MON_DUMMY_TS_DEAD_UPDATE(self)
end

function SCR_RUNECASTER_CHRONO_TS_DEAD_LEAVE(self)
    SCR_MON_DUMMY_TS_DEAD_LEAVE(self)
end



function SCR_RUNECASTER_SIAULIAI_WEST_STONE_DIALOG(self, pc)
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_17')
    if _hidden_prop < 258 then
        if GetInvItemCount(pc, 'HIDDEN_RUNECASTER_ITEM_4') == 0 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("RUNECASTER_SIAULIAI_WEST_STONE_MSG1"), 'SITGROPE', 2, 'SSN_HATE_AROUND')
            if result == 1 then
                local tx1 = TxBegin(pc);
                TxGiveItem(tx1, "HIDDEN_RUNECASTER_ITEM_4", 1, "Quest_HIDDEN_RUNECASTER");
                local ret = TxCommit(tx1);
                if ret == 'SUCCESS' then
                    HideNPC(pc, 'RUNECASTER_SIAULIAI_WEST_STONE')
--                    self.Dialog = 'None'
--                    KILL_BLEND(self, 1, 1)
                end
            end
        end
    end
end



function SCR_JOB_RUNECASTER_6_1_SUCC_RUN(pc, questname, npc)
    local x, y, z = GetPos(pc)
    local mon = CREATE_MONSTER_EX(pc, 'pcskill_rune_stone', x, y, z, 0, 'Neutral', 1, SCR_JOB_RUNECASTER_6_1_SUCC_SET);
    AddVisiblePC(mon, pc, 1);
    SetOwner(mon, pc, 1)
    SetNoDamage(mon, 1);
    
--    PlayEffect(mon, 'F_light094_blue', 3.5)
    AttachEffect(mon, 'F_spread_in022_blue', 1.0, 'BOT')
    
    HoverAround(mon, pc, 15, 20, 4, 1);
--    HoverAround(self, target, hoverRange, hoverHeight, hoverSpeed)
end



function SCR_JOB_RUNECASTER_6_1_SUCC_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "JOB_RUNECASTER_6_1_SUCC_AI";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "None"
	mon.FIXMSPD_BM = 100;
end

function JOB_RUNECASTER_6_1_SUCC_AI_RUN(self)
    if self.NumArg1 == nil then
        self.NumArg1 = 0;
    end
    
    local _pc = GetOwner(self);
    if _pc ~= nil then
        self.NumArg1 = self.NumArg1 + 1;
        
        if self.NumArg1 == 5 then
            PlayEffect(self, 'F_light058_blue', 0.8)
            PlayForceEffectSendPacket(_pc, self, _pc, 'I_force073_blue', 0.8, 'None', 'F_light028_blue', 1.5, 'None', 'SLOW', 50.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0.0)
            Kill(self)
        end
    else
        Kill(self)
    end
end



function SCR_MIKO_VINE_TAC_TS_BORN_ENTER(self)
    
end

function SCR_MIKO_VINE_TAC_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']
--    local sec = now_time['sec']
    
    local _time = tonumber(hour * 60) + tonumber(min);
    
    if tonumber(hour) % 4 == 0 and tonumber(min) == 0 then
        if self.NumArg1 ~= 1 then
            local _obj = GetScpObjectList(self, 'MIKO_VINE_CREAT')
            if #_obj == 0 then
                local x, y, z = GetPos(self)
                local mon = CREATE_MONSTER_EX(self, 'Warp_arrow', x, y, z, -80, 'Neutral', nil, SCR_MIKO_VINE_WARP_SET);
                SetLifeTime(mon, 300);
                AddScpObjectList(self, 'MIKO_VINE_CREAT', mon)
                self.NumArg1 = 1;
--                print('CREAT!!')
                Dead(self)
            elseif #_obj >= 2 then
                local i
                for i = 2, #_obj do
                    Kill(_obj[i])
                end
                Dead(self)
            end
        end
    end
end

function SCR_MIKO_VINE_TAC_TS_BORN_LEAVE(self)
end

function SCR_MIKO_VINE_TAC_TS_DEAD_ENTER(self)
end

function SCR_MIKO_VINE_TAC_TS_DEAD_UPDATE(self)
end

function SCR_MIKO_VINE_TAC_TS_DEAD_LEAVE(self)
end

function SCR_MIKO_VINE_WARP_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999;
	mon.Name = "UnvisibleName"
	mon.Enter = "MIKO_VINE_WARP"
	mon.Range = 20;
--	mon.MaxDialog = 1;
end

function SCR_MIKO_VINE_WARP_ENTER(self, pc)
    SCR_SETPOS_FADEOUT(pc, 'f_orchard_34_3', -914, 9, -2193, 10)
end


-- HIDDEN MIKO --
function SCR_HIDDEN_MIKO_CHECK(self, _min, _max, _prop)
    if _max == nil then
        _max = _min + 1;
    end
    
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(self, 'Char4_18')
    if _hidden_prop >= _min and _hidden_prop < _max then
        local sObj = GetSessionObject(self, 'SSN_HIDDEN_MIKO')
        if sObj == nil then
            CreateSessionObject(self, 'SSN_HIDDEN_MIKO')
            sObj = GetSessionObject(self, 'SSN_HIDDEN_MIKO')
        end
        
        if sObj ~= nil then
            if _prop == nil then
                return 'YES'
            else
                if sObj[_prop] == 0 then
                    return 'YES'
                end
            end
        end
    end
    return 'NO'
end

function SCR_SSN_HIDDEN_MIKO_PROP_RUN(self, _prop)
    local sObj = GetSessionObject(self, 'SSN_HIDDEN_MIKO')
    if sObj == nil then
        CreateSessionObject(self, 'SSN_HIDDEN_MIKO')
        sObj = GetSessionObject(self, 'SSN_HIDDEN_MIKO')
    end
    
    if sObj ~= nil then
        if sObj[_prop] == 0 then
            sObj[_prop] = 1;
            SaveSessionObject(self, sObj)
            return 'YES'
        end
    end
    return 'NO'
end

function SCR_SSN_HIDDEN_MIKO_7_END(self)
    local sObj = GetSessionObject(self, 'SSN_HIDDEN_MIKO')
    if sObj ~= nil then
        for i = 1, 7 do
            if sObj['Step'..i] == 0 then
                return;
            end
        end
        
        local tx1 = TxBegin(self);
        local item_cnt = GetInvItemCount(self, 'HIDDEN_MIKO_ITEM_1')
        if item_cnt >= 1 then
            TxTakeItem(tx1, 'HIDDEN_MIKO_ITEM_1', item_cnt, 'Quest_HIDDEN_MIKO');
        end
        TxGiveItem(tx1, "HIDDEN_MIKO_ITEM_2", 1, "Quest_HIDDEN_MIKO");
        local ret = TxCommit(tx1);
        if ret == 'SUCCESS' then
            SCR_SET_HIDDEN_JOB_PROP(self, 'Char4_18', 100)
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG3"), 5);
        end
    end
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_BORN_ENTER(self)
    AttachEffect(self, 'F_light078_holy_yellow_loop', 1.0, 'BOT')
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local sec = now_time['sec']
    
    if tonumber(sec) ~= tonumber(self.NumArg1) then
        self.NumArg1 = sec;
        
        local _pc_cnt = 0;
        local list, cnt = SelectObject(self, 150, 'ALL', 1)
        if cnt >= 1 then
            for i = 1, cnt do
                if list[i].ClassName == 'PC' then
                    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(list[i], 'Char4_18')
                    if _hidden_prop >= 1 and _hidden_prop < 100 then
                        local sObj = GetSessionObject(list[i], 'SSN_HIDDEN_MIKO')
                        if sObj == nil then
                            CreateSessionObject(list[i], 'SSN_HIDDEN_MIKO')
                            sObj = GetSessionObject(list[i], 'SSN_HIDDEN_MIKO')
                        end
                        
                        if sObj ~= nil then
                            if sObj.Step1 == 0 then
                                _pc_cnt = _pc_cnt + 1;
                            end
                        end
                    end
                end
            end
        end
        
        if _pc_cnt >= 1 then
            PlayEffect(self, 'F_spin021_green2', 0.8, 1, 'BOT')
            self.NumArg2 = self.NumArg2 + _pc_cnt;
        end
        
        if self.NumArg2 >= 900 then
            self.NumArg2 = 0;
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'noshadow_npc_16', x, y, z, -80, 'Neutral', nil, SCR_HIDDEN_MIKO_EBISU_SET);
            AttachEffect(mon, 'F_spread_in027_green_loop2', 1.0, 'MID')
            EnableAIOutOfPC(mon)
            SetLifeTime(mon, 10);
            Kill(self)
        end
    end
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_MIKO_3CMLAKE_83_TAC_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_MIKO_EBISU_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999;
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_MIKO_EBISU"
--	mon.Range = 20;
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_MIKO_EBISU_DIALOG(self, pc)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step1') == 'YES' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_SOUL_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
            PlayEffect(self, 'F_lineup003', 1.0, nil, 'BOT')
            HideNPC(pc, 'HIDDEN_MIKO_EBISU')
            SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step1')
            SCR_SSN_HIDDEN_MIKO_7_END(pc)
        end
    end
end



function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(60, 120);
end

function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    local sec = now_time['sec']
    
--    local _obj = GetScpObjectList(self, 'HIDDEN_MIKO_PILGRIM_48_SOUL')
    
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj = GetScpObjectList(self, 'HIDDEN_MIKO_PILGRIM_48_SOUL')
        if #_obj == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(60, 120);
                
                local _pos = {
                                { 354, 427, -1232 },
                                { 1710, 469, 150 },
                                { -830, 382, -1530 },
                                { -643, 382, 663 },
                                { -32, 546, 1524 }
                            };
                local rnd = IMCRandom(1, #_pos)
                
                local mon = CREATE_MONSTER_EX(self, 'noshadow_npc_16', _pos[rnd][1], _pos[rnd][2], _pos[rnd][3], 0, 'Neutral', nil, SCR_HIDDEN_MIKO_DAIKOKUTEN_SET);
                AddScpObjectList(self, 'HIDDEN_MIKO_PILGRIM_48_SOUL', mon)
                AttachEffect(mon, 'F_spread_in027_green_loop2', 1.0, 'TOP')
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 600); --7200
                AttachEffect(self, 'F_ground051_orange_loop2', 3.0, 'BOT')
            end
        elseif #_obj >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
    
    if sec % 30 == 0 then
        if self.NumArg4 ~= sec then
            self.NumArg4 = sec;
            
            local _obj = GetScpObjectList(self, 'HIDDEN_MIKO_PILGRIM_48_SOUL')
            if #_obj >= 1 then
                local x, y, z = GetPos(self)
                for i = 1, 5 do
                    local rnd_pos = { x+IMCRandom(-1000, 1000), 427, z+IMCRandom(-1000, 1000) }
                    if IsValidPos(GetZoneInstID(self), rnd_pos[1], rnd_pos[2], rnd_pos[3]) == 'YES' then
                        local _npc_check = 'YES';
                        local list, cnt = SelectObjectPos(self, rnd_pos[1], rnd_pos[2], rnd_pos[3], range, 'ALL')
                        if cnt >= 1 then
                            for j = 1, cnt do
                                if list[j].ClassName ~= 'PC' then
                                    if list[j].Faction == 'Neutral' then
                                        _npc_check = 'NO';
                                    end
                                end
                            end
                        end
                        
                        if _npc_check == 'YES' then
                            PlayEffect(_obj[1], 'F_spin022_blue', 0.5, nil, 'BOT')
                            SetPos(_obj[1], rnd_pos[1], rnd_pos[2], rnd_pos[3])
                            return;
                        end
                    end
                end
                
                local _pos = {
                                { 354, 427, -1232 },
                                { 1710, 469, 150 },
                                { -830, 382, -1530 },
                                { -643, 382, 663 },
                                { -32, 546, 1524 }
                            };
                local rnd = IMCRandom(1, #_pos)
                PlayEffect(_obj[1], 'F_spin022_blue', 0.5, nil, 'BOT')
                SetPos(_obj[1], _pos[rnd][1], _pos[rnd][2], _pos[rnd][3])
            else
                DetachEffect(self, 'F_ground051_orange_loop2')
            end
        end
    end
end

function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_MIKO_PILGRIM_48_TAC_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_MIKO_DAIKOKUTEN_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999;
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_MIKO_DAIKOKUTEN"
--	mon.Range = 20;
	mon.MaxDialog = 1;
end

function SCR_HIDDEN_MIKO_DAIKOKUTEN_DIALOG(self, pc)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step2') == 'YES' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_SOUL_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
            PlayEffect(self, 'F_lineup003', 1.0, nil, 'BOT')
            HideNPC(pc, 'HIDDEN_MIKO_DAIKOKUTEN')
            SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step2')
            SCR_SSN_HIDDEN_MIKO_7_END(pc)
--            Kill(self)
        end
    end
end

function SCR_HIDDEN_MIKO_VPRISON_SUN_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 1)
end

function SCR_HIDDEN_MIKO_VPRISON_MON_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 2)
end

function SCR_HIDDEN_MIKO_VPRISON_TUES_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 3)
end

function SCR_HIDDEN_MIKO_VPRISON_WEDNES_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 4)
end

function SCR_HIDDEN_MIKO_VPRISON_THURS_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 5)
end

function SCR_HIDDEN_MIKO_VPRISON_FRI_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 6)
end

function SCR_HIDDEN_MIKO_VPRISON_SATUR_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, 7)
end

function SCR_HIDDEN_MIKO_VPRISON_WEEK_RUN(self, pc, num)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step3') == 'YES' then
        local sObj = GetSessionObject(pc, 'SSN_HIDDEN_MIKO')
        if sObj ~= nil then
            if sObj.Goal3 >= 100 then
                for i = 1, 12 do
                    local item_cnt = GetInvItemCount(pc, 'HIDDEN_MIKO_BEAD_ITEM_'..i);
                    if item_cnt >= 1 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_WEEK_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
                            item_cnt = GetInvItemCount(pc, 'HIDDEN_MIKO_BEAD_ITEM_'..i);
                            if item_cnt >= 1 then
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, 'HIDDEN_MIKO_BEAD_ITEM_'..i, item_cnt, 'Quest_HIDDEN_MIKO');
                                local ret = TxCommit(tx1);
                                if ret == 'SUCCESS' then
                                    local now_time = os.date('*t')
                                    -- 1 = Sunday ~ 7 = Saturday
                                    local weekday = now_time['wday']
                                    if weekday == num then
                                        local hour = now_time['hour']
                                        if hour > 12 then
                                            hour = hour - 12;
                                        elseif hour == 0 then
                                            hour = 12;
                                        end
                                        
                                        if hour == i then
                                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
                                            PlayEffect(self, 'F_lineup003', 1.5, nil, 'BOT')
                                            SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step3')
                                            SCR_SSN_HIDDEN_MIKO_7_END(pc)
                                        else
                                            ShowBalloonText(pc, "HIDDEN_MIKO_VPRISON_WEEK_dlg2", 5)
                                        end
                                    else
                                        ShowBalloonText(pc, "HIDDEN_MIKO_VPRISON_WEEK_dlg2", 5)
                                    end
                                    Dead(self)
                                end
                                return;
                            end
                        end
                        return;
                    end
                end
            end
        end
    end
    
    ShowBalloonText(pc, "HIDDEN_MIKO_VPRISON_WEEK_dlg1", 5)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_1_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 1)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_2_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 2)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_3_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 3)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_4_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 4)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_5_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 5)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_6_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 6)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_7_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 7)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_8_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 8)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_9_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 9)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_10_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 10)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_11_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 11)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_12_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, 12)
end

function SCR_HIDDEN_MIKO_VPRISON_BEAD_RUN(self, pc, num)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step3') == 'YES' then
        local sObj = GetSessionObject(pc, 'SSN_HIDDEN_MIKO')
        if sObj ~= nil then
            if sObj.Goal3 >= 100 then
                for i = 1, 12 do
                    local item_cnt = GetInvItemCount(pc, 'HIDDEN_MIKO_BEAD_ITEM_'..i);
                    if item_cnt >= 1 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_BEAD_MSG1"), 5);
                        return;
                    end
                end
                
                local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_BEAD_MSG2"), 'ABSORB', 2, 'SSN_HATE_AROUND')
                if result == 1 then
                    local tx1 = TxBegin(pc);
                    TxGiveItem(tx1, "HIDDEN_MIKO_BEAD_ITEM_"..num, 1, "Quest_HIDDEN_MIKO");
                    local ret = TxCommit(tx1);
                    if ret == 'SUCCESS' then
                        PlayEffect(self, 'F_pc_making_finish_white', 1.5, nil, 'MID')
                        Kill(self)
                    end
                end
                return
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_BEAD_MSG3"), 5);
                return;
            end
        end
    end
    ShowBalloonText(pc, "HIDDEN_MIKO_VPRISON_WEEK_dlg1", 5)
end



function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(10, 30)
end

function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    if min ~= self.NumArg1 then
        self.NumArg1 = min;
        self.NumArg2 = self.NumArg2 + 1;
        if self.NumArg2 >= self.NumArg3 + self.NumArg4 then
            local buff1 = GetBuffByName(self, 'HIDDEN_MIKO_SIAULIAI_46_2_BUFF')
            if buff1 == nil then
                AddBuff(self, self, 'HIDDEN_MIKO_SIAULIAI_46_2_BUFF', 1, 0, 5000, 1)
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(10, 30);
            end
        end
    end
end

function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_MIKO_SIAULIAI_46_2_TAC_TS_DEAD_LEAVE(self)
end



function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(60, 720);
end

function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        
        local _obj = GetScpObjectList(self, 'HIDDEN_MIKO_KLAIPE_SOUL')
        if #_obj == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(720, 1440);
                
                local x, y, z = GetPos(self)
                local mon = CREATE_MONSTER_EX(self, 'noshadow_npc_16', x, y, z, 0, 'Neutral', nil, SCR_HIDDEN_MIKO_FUKUROKUSHU_SET);
                AddScpObjectList(self, 'HIDDEN_MIKO_KLAIPE_SOUL', mon)
                AttachEffect(mon, 'F_spread_in027_green_loop2', 1.0, 'TOP')
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 3600);
            end
        elseif #_obj >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_MIKO_KLAIPE_TAC_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_MIKO_FUKUROKUSHU_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_MIKO_FUKUROKUSHU"
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_MIKO_FUKUROKUSHU_DIALOG(self, pc)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step5') == 'YES' then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_SOUL_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
        if result == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
            PlayEffect(self, 'F_lineup003', 1.0, nil, 'BOT')
            HideNPC(pc, 'HIDDEN_MIKO_FUKUROKUSHU')
            SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step5')
            SCR_SSN_HIDDEN_MIKO_7_END(pc)
        end
    end
end



function SCR_HIDDEN_MIKO_JUROTA_DIALOG(self, pc)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step6') == 'YES' then
        local _arr = { ScpArgMsg('HIDDEN_MIKO_JUROTA_BUTTON2'), ScpArgMsg('HIDDEN_MIKO_JUROTA_BUTTON2') };
        local _ansNumber = IMCRandom(1, #_arr);
        _arr[_ansNumber] = ScpArgMsg('HIDDEN_MIKO_JUROTA_BUTTON1')
        
        txt = 'HIDDEN_MIKO_JUROTA_DLG1'
        
        if IsBuffApplied(pc, "MIKO_JUROTA_BUFF1") == "NO" then
        
            local sel = SCR_SEL_LIST(pc, _arr, txt, 1)
            if sel == _ansNumber then
            
                local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_JUROTA_MSG1"), 'PRAY', 5, 'SSN_HATE_AROUND')
                if result == 1 then
                    self.NumArg1 = self.NumArg1 + 1;
                    
                    if self.NumArg1 == 80 then
                        self.NumArg1 = 0;
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
                        PlayEffect(self, 'F_lineup003', 3.0, nil, 'BOT')
                        PlayEffectLocal(self, pc, 'F_burstup001_yellow', 0.5, nil, 'BOT')
                        HideNPC(pc, 'HIDDEN_MIKO_JUROTA')
                        SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step6')
                        SCR_SSN_HIDDEN_MIKO_7_END(pc)
                    elseif self.NumArg1 < 80 then
                        ShowBalloonText(pc, "HIDDEN_MIKO_JUROTA_dlg1", 5)
                    else
                        ShowBalloonText(pc, "HIDDEN_MIKO_JUROTA_dlg1", 5)
                        self.NumArg1 = 0;
                    end
                end
            elseif sel == nil or sel == 0 then
                --ShowBalloonText(pc, "HIDDEN_MIKO_JUROTA_dlg1", 5)
                return
            elseif sel ~= _ansNumber then
                AddBuff(pc, pc, "MIKO_JUROTA_BUFF1",1,0,60000,1)
                ShowBalloonText(pc, "HIDDEN_MIKO_JUROTA_DLG2", 5)
            end
        else
            ShowBalloonText(pc, "HIDDEN_MIKO_JUROTA_DLG2", 5)
        end
    end
end

function SCR_HIDDEN_MIKO_CMINE_6_1_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 1)
end

function SCR_HIDDEN_MIKO_CMINE_6_2_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 2)
end

function SCR_HIDDEN_MIKO_CMINE_6_3_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 3)
end

function SCR_HIDDEN_MIKO_CMINE_6_4_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 4)
end

function SCR_HIDDEN_MIKO_CMINE_6_5_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 5)
end

function SCR_HIDDEN_MIKO_CMINE_6_6_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 6)
end

function SCR_HIDDEN_MIKO_CMINE_6_7_DIALOG(self, pc)
    SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, 7)
end

function SCR_HIDDEN_MIKO_CMINE_6_RUN(self, pc, num)
    if SCR_HIDDEN_MIKO_CHECK(pc, 1, 100, 'Step7') == 'YES' then
        local sObj = GetSessionObject(pc, 'SSN_HIDDEN_MIKO')
        if sObj ~= nil then
            local now_time = os.date('*t')
            local year = now_time['year']
            local month = now_time['month']
            local day = now_time['day']
            local hour = now_time['hour']
            local min = now_time['min']
            
            local _today = tonumber(year..month..day);
            local _time = tonumber(hour * 60) + tonumber(min);
            
            if sObj.String1 ~= 'None' then
                local string_cut_list = SCR_STRING_CUT(sObj.String1);
                if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
                    local _last_day = tonumber(string_cut_list[1]);
                    local _last_time = tonumber(string_cut_list[2]);
                    
                    if _last_day ~= _today then
                        _last_time = _last_time - 1440;
                    end
                    
                    if _time < _last_time + 60 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_CMINE_6_MSG1"), 5);
                        return
                    end
                else
                    return;
                end
            end
            
            local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MIKO_SOUL_MSG1"), 'ABSORB', 2, 'SSN_HATE_AROUND')
            if result == 1 then
                if sObj.Goal7 == num then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("HIDDEN_MIKO_SOUL_MSG2"), 5);
                    PlayEffectLocal(self, pc, 'F_lineup003', 1.0, nil, 'BOT')
                    for i = 1, 7 do
                        HideNPC(pc, 'HIDDEN_MIKO_CMINE_6_'..i)
                    end
                    SCR_SSN_HIDDEN_MIKO_PROP_RUN(pc, 'Step7')
                    SCR_SSN_HIDDEN_MIKO_7_END(pc)
                else
                    PlayAnimLocal(self, pc, 'DEAD', 1)
                    HideNPC(pc, 'HIDDEN_MIKO_CMINE_6_'..num)
                    ShowBalloonText(pc, "HIDDEN_MIKO_CMINE_6_dlg1", 5)
                    sObj.String1 = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
                    SaveSessionObject(pc, sObj)
                end
            end
        end
    end
end


function SCR_MIKO_SOUL_SPIRIT_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_MIKO_SOUL_SPIRIT_NORMAL_1_PRE(pc)
--    return SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char4_18')
    local _hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char4_18')
    if _hidden_prop >= 200 then
        return 'YES'
    end
    return 'NO'
end

function SCR_MIKO_SOUL_SPIRIT_NORMAL_1(self, pc)
    ShowOkDlg(pc, 'MIKO_SPIRIT_dlg2', 1)
end

-- HIDDEN APPRAISER --
function CHAR313_MSTEP1_1(pc, dlg, _step)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char3_13")
	if hidden_prop < 1 then
	    local sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
	    if sObj == nil then
	        CreateSessionObject(pc, "SSN_APPRAISER_UNLOCK")
	        sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
	    end
	   ShowOkDlg(pc, dlg, 1)
        sObj = GetSessionObject(pc, "SSN_APPRAISER_UNLOCK")
	    if sObj ~= nil then
    	    if sObj[_step] < 1 then
    	        sObj[_step] = 1
    	        SaveSessionObject(pc, sObj)
	        end
	        if sObj.Step1 == 1 and sObj.Step2 == 1 then --and sObj.Step3 == 1
	            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 1)
	        end
	    end
	end
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(120, 240);
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    --print(self.NumArg2, self.NumArg3)
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj = GetScpObjectList(self, 'HIDDEN_KLAIPE_AGENT')
        if #_obj == 0 then
            self.NumArg2 = self.NumArg2  + 1;
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(120, 240);
                local x, y, z = GetPos(self)
                local mon = CREATE_MONSTER_EX(self, 'npc_rich_baron', -983, 241, 349, 0, 'Neutral', nil, SCR_HIDDEN_APPRAISER_KLAIPE_SET);
                AddScpObjectList(self, 'HIDDEN_KLAIPE_AGENT', mon)
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 600);
            end
        elseif #_obj >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_BORN_LEAVE(self)
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_DEAD_ENTER(self)
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_DEAD_UPDATE(self)
end

function SCR_KLAIPE_CHAR313_MSTEP3_1_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_APPRAISER_KLAIPE_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("HIDDEN_APPRAISER_KLAIPE_NAME")
	mon.Dialog = "HIDDEN_APPRAISER_KLAIPE"
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_APPRAISER_KLAIPE_DIALOG(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char3_13")
	if hidden_prop == 10 then
	    local sel = ShowSelDlg(pc, 0, "CHAR313_MSTEP3_1_DLG1", ScpArgMsg("CHAR313_MSTEP3_1_MSG1"), ScpArgMsg("CHAR313_MSTEP3_1_MSG2"))
        if sel == 1 then
            if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM1') == 0 then
                local tx1 = TxBegin(pc);
                TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM1", 1, "Quest_HIDDEN_APPRAISER");
                local ret = TxCommit(tx1);
                if ret == 'SUCCESS' then
                    SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 20)
                    ShowOkDlg(pc, "CHAR313_MSTEP3_1_DLG2", 1)
                    ShowBalloonText(pc, "CHAR313_MSTEP3_1_DLG3", 5)
                end
            end
        else
            ShowOkDlg(pc, "CHAR313_MSTEP3_1_DLG4", 1)
        end
	elseif hidden_prop == 20 then
	    ShowOkDlg(pc, "CHAR313_MSTEP3_1_DLG5", 1)
	elseif hidden_prop == 250 then
	    ShowOkDlg(pc, "CHAR313_MSTEP12_1_DLG1", 1)
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM8') == 0 then
            local tx1 = TxBegin(pc);
            TxTakeItem(tx1, "KLAIPE_CHAR313_ITEM9", 1, "Quest_HIDDEN_APPRAISER");
            TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM8", 1, "Quest_HIDDEN_APPRAISER");
            local ret = TxCommit(tx1);
            if ret == 'SUCCESS' then
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char3_13', 270)
                ShowBalloonText(pc, "CHAR313_MSTEP12_1_MSG1", 5)
                UIOpenToPC(pc,'fullblack',1)
                sleep(500)
                HideNPC(pc, "HIDDEN_APPRAISER_KLAIPE")
                UIOpenToPC(pc,'fullblack',0)
            end
        end
    elseif hidden_prop >= 270 then
        if isHideNPC(pc, "HIDDEN_APPRAISER_KLAIPE") == 'NO' then
            UIOpenToPC(pc,'fullblack',1)
            sleep(500)
            HideNPC(pc, "HIDDEN_APPRAISER_KLAIPE")
            UIOpenToPC(pc,'fullblack',0)
        end
	end
end


function SCR_SIAUL_CHAR313_MSTEP8_2_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(60, 120);
end

function SCR_SIAUL_CHAR313_MSTEP8_2_TS_BORN_UPDATE(self)
    local _obj = GetScpObjectList(self, 'HIDDEN_SIAUL_FLOWER1')
    local now_time = os.date('*t')
    local min = now_time['min']
    --print(self.NumArg2, self.NumArg3)
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        
        local _obj = GetScpObjectList(self, 'HIDDEN_SIAUL_FLOWER1')
        if #_obj == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(180, 240);
                
                local pos1 = GetExProp(self, 'HIDDEN_SIAUL_FLOWER1_POS_1')
                local pos2 = GetExProp(self, 'HIDDEN_SIAUL_FLOWER1_POS_2')
                local pos3 = GetExProp(self, 'HIDDEN_SIAUL_FLOWER1_POS_3')
                local pos4 = GetExProp(self, 'HIDDEN_SIAUL_FLOWER1_POS_4')
                local pos5 = GetExProp(self, 'HIDDEN_SIAUL_FLOWER1_POS_5')
                
                local pos_arr = {pos1, pos2, pos3, pos4, pos5}
                
                local loc = {}
                loc[1] = {213, -43, 1620}
                loc[2] = {-699, -43, 1552}
                loc[3] = {-1600, -209, 642}
                loc[4] = {1242, 22, 787}
                loc[5] = {1152, -43, 1377}
                
                local x, y, z
                local target_pos = SIAUL_FLOWER_LOC_CK(self, pos_arr)
                x = loc[target_pos][1]
                y = loc[target_pos][2]
                z = loc[target_pos][3]
                
                local mon = CREATE_MONSTER_EX(self, 'npc_orchard_flower', x, y, z, 0, 'Neutral', nil, SCR_HIDDEN_FLOWER_SIAUL_SET);
                AddScpObjectList(self, 'HIDDEN_SIAUL_FLOWER1', mon)
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 7200);
            end
        elseif #_obj >= 2 then
            for i = 2, #_obj do
               
                Kill(_obj[i])
            end
        end
    end
end

function SCR_SIAUL_CHAR313_MSTEP8_2_TS_BORN_LEAVE(self)
end

function SCR_SIAUL_CHAR313_MSTEP8_2_TS_DEAD_ENTER(self)
end

function SCR_SIAUL_CHAR313_MSTEP8_2_TS_DEAD_UPDATE(self)
end

function SCR_SIAUL_CHAR313_MSTEP8_2_TS_DEAD_LEAVE(self)
end

function SIAUL_FLOWER_LOC_CK(self, pos_arr)
    local i
    local j = 0
    local random = {}
    for i = 1, #pos_arr do
        if pos_arr[i] == 0 then
            random[j+1] = pos_arr[i] + i
            j = j + 1
        end
    end
    
    local rnd = select(IMCRandom(1,4), random[1], random[2], random[3], random[4])
    return rnd
end

function SCR_HIDDEN_FLOWER_SIAUL_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("HIDDEN_FLOWER_SIAUL_NAME")
	mon.Dialog = "HIDDEN_FLOWER_SIAUL"
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_FLOWER_SIAUL_DIALOG(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM3') == 0 then
        local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 5, 'SHINOBI_YELLOW_EYES_FLOWER')
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP8_2_MSG1"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
        DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'SHINOBI_YELLOW_EYES_FLOWER')
        if result == 1 then
            local tx1 = TxBegin(pc);
            TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM3", 1, "Quest_HIDDEN_APPRAISER");
            local ret = TxCommit(tx1);
            PlayEffect(self, 'F_pc_making_finish_orange', 2.0, nil, 'MID')
            Dead(self)
            HideNPC(pc, 'HIDDEN_FLOWER_SIAUL')
        end
    end
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = IMCRandom(120, 240);
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    --print(self.NumArg2, self.NumArg3)
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj1 = GetScpObjectList(self, 'HIDDEN_REMAINS_FLOWER2')
        if #_obj1 == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            --print(self.NumArg2)
            if self.NumArg2 >= self.NumArg3 then
                --print("222222")
                self.NumArg2 = 0;
                self.NumArg3 = IMCRandom(180, 240);
                
                local mon1 = CREATE_MONSTER_EX(self, 'farm49_sapling', 144, 244, -1340, 0, 'Neutral', nil, SCR_HIDDEN_FLOWER_REMAINS_SET);
                
                AddScpObjectList(self, 'HIDDEN_REMAINS_FLOWER2', mon1)
                EnableAIOutOfPC(mon1)
                SetLifeTime(mon1, 4800);
            end
        end
        if #_obj1 >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_BORN_LEAVE(self)
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_DEAD_ENTER(self)
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_DEAD_UPDATE(self)
end

function SCR_REMAINS_CHAR313_MSTEP8_3_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_FLOWER_REMAINS_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "HIDDEN_FLOWER_REMAINS_AI";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("HIDDEN_FLOWER_REMAINS_NAME")
	mon.Dialog = "HIDDEN_FLOWER_REMAINS"
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_WATER_REMAINS_DIALOG(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM4') == 0 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM5') == 1 then
            if IsBuffApplied(pc, "HIDDEN_APPRAISER_BUFF1") == "NO" then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP8_3_MSG5"), 'SITWATER_LOOP', 2, 'SSN_HATE_AROUND')
                if result == 1 then
                    AddBuff(self, pc, "HIDDEN_APPRAISER_BUFF1", 1, 0, 0, 10)
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG1"), 5);
                end
            else
                local buffCount= GetBuffOver(pc, "HIDDEN_APPRAISER_BUFF1")
                if buffCount < 10 then -- IsBuffApplied(pc, "HIDDEN_APPRAISER_BUFF1") == "NO" then
                    local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP8_3_MSG5"), 'SITWATER_LOOP', 2, 'SSN_HATE_AROUND')
                    if result == 1 then
                        if buffCount >= 0 then
                            AddBuff(self, pc, "HIDDEN_APPRAISER_BUFF1", 1, 0, 0, 10)
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG1"), 5);
                        else
                            local buffOver = 10 - buffCount
                            AddBuff(self, pc, "HIDDEN_APPRAISER_BUFF1", 1, 0, 0, buffOver)
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG1"), 5);
                        end
                    end
                else
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG2"), 5);
                end
            end
        end
    end
end

function SCR_HIDDEN_WATER_REMAINS_IN_ENTER(self, pc)
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM4') == 0 then
        if IsBuffApplied(pc, "HIDDEN_APPRAISER_BUFF1") == "NO" then
            local list, cnt = GetWorldObjectList(pc, "mon", 800)
            if cnt >= 1 then
                for i = 1, cnt do
                    if list[i].ClassName == "farm49_sapling" and list[i].Dialog == "HIDDEN_FLOWER_REMAINS" then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG5"), 5)
                    end
                end
            end
        end
    end
end

function SCR_HIDDEN_FLOWER_REMAINS_DIALOG(self, pc)
    --self.NumArg1 : tiem count
    --self.NumArg2 : success count
    --self.NumArg3 : dead count
    if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM4') == 0 then
        if GetInvItemCount(pc, 'KLAIPE_CHAR313_ITEM5') >= 1 then
            if IsBuffApplied(pc, "HIDDEN_APPRAISER_BUFF1") == "YES" then
                if self.NumArg2 < 500 then
                    local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 1, 'SHINOBI_YELLOW_EYES_FLOWER')
                    local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP8_3_MSG3"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
                    DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'SHINOBI_YELLOW_EYES_FLOWER')
                    if result == 1 then
                        if self.NumArg1 > 10 and self.NumArg1 <= 20 then
                            self.NumArg2 = self.NumArg2 + 1
                            PlayEffect(self, "F_light029_yellow",0.7, 1, "MID")
                            if self.NumArg2 > 500 then
                                PlayEffect(self, "F_light089_mint", 1, "MID")
                            end
                        end
                        AddBuff(self, pc, "HIDDEN_APPRAISER_BUFF1", 1, 0, 0, -1)
                        --HideNPC(pc, 'HIDDEN_FLOWER_REMAINS')
                    end
                else
                    local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR313_MSTEP8_3_MSG4"), 'SITGROPE_LOOP', 1, 'SSN_HATE_AROUND')
                    if result == 1 then
                        local tx1 = TxBegin(pc);
                        TxGiveItem(tx1, "KLAIPE_CHAR313_ITEM4", 1, "Quest_HIDDEN_APPRAISER");
                        local ret = TxCommit(tx1);
                        if ret == 'SUCCESS' then
                            PlayEffect(self, 'F_pc_making_finish_orange', 1.0, nil, 'MID')
                            HideNPC(pc, "HIDDEN_FLOWER_REMAINS")
                            HideNPC(pc, "HIDDEN_WATER_REMAINS")
                            if IsBuffApplied(pc, "HIDDEN_APPRAISER_BUFF1") == "YES" then
                                RemoveBuff(pc, "HIDDEN_APPRAISER_BUFF1")
                            end
                        end
                    end
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REMAINS_CHAR313_MSTEP8_3_MSG6"), 5)
            end
        end
    end
end

function HIDDEN_FLOWER_REMAINS_AI_UPDATE(self)
    --self.NumArg1 : tiem count
    --self.NumArg2 : success count
    --self.NumArg3 : dead count
    if self.NumArg1 < 20 then
        self.NumArg1 = self.NumArg1 + 1
    else
        self.NumArg1 = 0
    end
    --print(self.NumArg1)
end



-- HIDDEN MATADOR --
function SCR_ORSHA_CHAR119_MSTEP1_DIALOG(self, pc)
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_19');
    if IS_KOR_TEST_SERVER() then
        ShowOkDlg(pc, "CHAR119_MSTEP1_DLG1", 1)
    elseif is_unlock == 'YES' then
        ShowOkDlg(pc, "CHAR119_MSTEP1_DLG1", 1)
    elseif is_unlock == 'NO' then
        ShowOkDlg(pc, "CHAR119_MSTEP1_DLG1", 1)
        local prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_19")
    	--print(SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_19"))
    	if prop < 10 then
        	UnHideNPC(pc, "CHAR119_MSTEP3_4_NPC")
        	SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 10)
    	    --print(SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_19"))
    	    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    	    if sObj == nil then
    	        CreateSessionObject(pc, "SSN_MATADOR_UNLOCK")
    	        sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    	    end
    	end
    end
end

function SCR_REMAINS39_CHAR119_MSTEP2_1_DIALOG(self, pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    if prop >= 10 and prop <= 13 then
        local sel = ShowSelDlg(pc, 0, "CHAR119_MSTEP2_1_QUESTION1", ScpArgMsg("CHAR119_MSTEP2_TXT1"), ScpArgMsg("CHAR119_MSTEP2_TXT2"))
        if sel == 1 then
            REMAINS39_CHAR119_FUNC(self, pc, "CHAR119_MSTEP2_1_DLG1", "CHAR119_MSTEP2_1_DLG2", "CHAR119_MSTEP2_1_DLG3", "REMAINS39_CHAR119_MSTEP2_1")
        else
            --COMMON_QUEST_HANDLER(self, pc)
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function SCR_REMAINS39_CHAR119_MSTEP2_2_DIALOG(self, pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    if prop >= 10 and prop <= 13 then
        local sel = ShowSelDlg(pc, 0, "CHAR119_MSTEP2_2_QUESTION1", ScpArgMsg("CHAR119_MSTEP2_TXT1"), ScpArgMsg("CHAR119_MSTEP2_TXT2"))
        if sel == 1 then
            REMAINS39_CHAR119_FUNC(self, pc, "CHAR119_MSTEP2_2_DLG1", "CHAR119_MSTEP2_2_DLG2", "CHAR119_MSTEP2_2_DLG3", "REMAINS39_CHAR119_MSTEP2_2")
        else
            --COMMON_QUEST_HANDLER(self, pc)
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function SCR_REMAINS39_CHAR119_MSTEP2_3_DIALOG(self, pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    if prop >= 10 and prop <= 13 then
        local sel = ShowSelDlg(pc, 0, "CHAR119_MSTEP2_3_QUESTION1", ScpArgMsg("CHAR119_MSTEP2_TXT1"), ScpArgMsg("CHAR119_MSTEP2_TXT2"))
        if sel == 1 then
            REMAINS39_CHAR119_FUNC(self, pc, "CHAR119_MSTEP2_3_DLG1", "CHAR119_MSTEP2_3_DLG2", "CHAR119_MSTEP2_3_DLG3", "REMAINS39_CHAR119_MSTEP2_3")
        else
            --COMMON_QUEST_HANDLER(self, pc)
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function REMAINS39_CHAR119_FUNC(self, pc, dlg1, dlg2, dlg3, dlgfunc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if dlgfunc == "REMAINS39_CHAR119_MSTEP2_1" then
        if prop == 10 then
            ShowOkDlg(pc, dlg1, 1)
            --print("11111", "REMAINS39_CHAR119_MSTEP2_1")
            if isHideNPC(pc, "MATADOR_MASTER") == "YES" then
                UnHideNPC(pc, "MATADOR_MASTER")
            end
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 11)
            sObj.Goal5 = 1
        elseif prop == 11 then
            if sObj.Goal5 == 1 then
                ShowOkDlg(pc, dlg1, 1)
                --print("22222", "REMAINS39_CHAR119_MSTEP2_1")
                return
            end
            ShowOkDlg(pc, dlg2, 1)
            --print("33333", "REMAINS39_CHAR119_MSTEP2_1")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 12)
            sObj.Goal5 = 1
        elseif prop == 12 then
            if sObj.Goal5 == 1 then
                ShowOkDlg(pc, dlg2, 1)
                --print("44444", "REMAINS39_CHAR119_MSTEP2_1")
                return
            end
            ShowOkDlg(pc, dlg3, 1)
            --print("55555", "REMAINS39_CHAR119_MSTEP2_1")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 13)
            sObj.Goal5 = 1
        else
            ShowOkDlg(pc, dlg3, 1)
        end
    elseif dlgfunc == "REMAINS39_CHAR119_MSTEP2_2" then
        if prop == 10 then
            ShowOkDlg(pc, dlg1, 1)
            --print("11111", "REMAINS39_CHAR119_MSTEP2_2")
            if isHideNPC(pc, "MATADOR_MASTER") == "YES" then
                UnHideNPC(pc, "MATADOR_MASTER")
            end
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 11)
            sObj.Goal6 = 1
        elseif prop == 11 then
            if sObj.Goal6 == 1 then
                --print("22222", "REMAINS39_CHAR119_MSTEP2_2")
                ShowOkDlg(pc, dlg1, 1)
                return
            end
            ShowOkDlg(pc, dlg2, 1)
            --print("33333", "REMAINS39_CHAR119_MSTEP2_2")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 12)
            sObj.Goal6 = 1
        elseif prop == 12 then
            if sObj.Goal6 == 1 then
                ShowOkDlg(pc, dlg2, 1)
                --print("44444", "REMAINS39_CHAR119_MSTEP2_2")
                return
            end
            ShowOkDlg(pc, dlg3, 1)
            --print("55555", "REMAINS39_CHAR119_MSTEP2_2")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 13)
            sObj.Goal6 = 1
        else
            ShowOkDlg(pc, dlg3, 1)
        end
    elseif dlgfunc == "REMAINS39_CHAR119_MSTEP2_3" then
        if prop == 10 then
            ShowOkDlg(pc, dlg1, 1)
            --print("11111", "REMAINS39_CHAR119_MSTEP2_3")
            if isHideNPC(pc, "MATADOR_MASTER") == "YES" then
                UnHideNPC(pc, "MATADOR_MASTER")
            end
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 11)
            sObj.Goal7 = 1
        elseif prop == 11 then
            if sObj.Goal7 == 1 then
                ShowOkDlg(pc, dlg1, 1)
                --print("22222", "REMAINS39_CHAR119_MSTEP2_3")
                return
            end
            ShowOkDlg(pc, dlg2, 1)
            --print("33333", "REMAINS39_CHAR119_MSTEP2_3")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 12)
            sObj.Goal7 = 1
        elseif prop == 12 then
            if sObj.Goal7 == 1 then
                ShowOkDlg(pc, dlg2, 1)
                --print("44444", "REMAINS39_CHAR119_MSTEP2_3")
                return
            end
            ShowOkDlg(pc, dlg3, 1)
            --print("55555", "REMAINS39_CHAR119_MSTEP2_3")
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 13)
            sObj.Goal7 = 1
        else
            ShowOkDlg(pc, dlg3, 1)
        end
    end

end

function SCR_CHAR119_MSTEP3_3_1_NPC_DIALOG(self, pc)
    if SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_19') == "NO" then
        local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
        local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
        if sObj.Goal3 >= 2 then
            local item1 = GetInvItemCount(pc, "HIDDEN_MATADOR_MSTEP3_3_ITEM1")
            local item2 = GetInvItemCount(pc, "HIDDEN_MATADOR_MSTEP3_3_ITEM2")
            local item3 = GetInvItemCount(pc, "HIDDEN_MATADOR_MSTEP3_3_ITEM3")
            local item4 = GetInvItemCount(pc, "HIDDEN_MATADOR_MSTEP3_3_ITEM4")
            if item1 >= 10 and item2 >= 12 and item3 >= 15 then
                ShowOkDlg(pc, "CHAR119_MSTEP3_3_2_DLG1", 1)
                sObj.Step3 = 1
--                print("sObj.Step1 : "..sObj.Step1.."/ ".."sObj.Step2 : "..sObj.Step2.."/ ".."sObj.Step3 : "..sObj.Step3.."/ ".."sObj.Step4 : "..sObj.Step4)
                SaveSessionObject(pc, sObj)
                local item = {
                                "HIDDEN_MATADOR_MSTEP3_3_ITEM1",
                                "HIDDEN_MATADOR_MSTEP3_3_ITEM2",
                                "HIDDEN_MATADOR_MSTEP3_3_ITEM3",
                                "HIDDEN_MATADOR_MSTEP3_3_ITEM4"
                             }
                local tx = TxBegin(pc)
                for i = 1, #item do
                    TxTakeItem(tx, item[i], GetInvItemCount(pc, item[i]), "Quest_HIDDEN_MATADOR")
                end
                local ret = TxCommit(tx);
                if sObj.Step1 >= 1 and sObj.Step2 >= 1 and sObj.Step3 >= 1 and sObj.Step4 >= 1 then
                    --print("sObj.Step1 : "..sObj.Step1.."/ ".."sObj.Step2 : "..sObj.Step2.."/ ".."sObj.Step3 : "..sObj.Step3.."/ ".."sObj.Step4 : "..sObj.Step4)
                    if prop == 20 then
                        --print(prop)
                        SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 60)
                    end
                end
            elseif sObj.Step3 >= 1 then
                ShowOkDlg(pc, "CHAR119_MSTEP3_3_2_DLG2", 1)
            else
                ShowOkDlg(pc, "CHAR119_MSTEP3_3_1_DLG4", 1)
            end
        elseif sObj.Goal3 >= 1 then
            local sel1 = ShowSelDlg(pc, 0, "CHAR119_MSTEP3_3_1_DLG1", ScpArgMsg("CHAR119_MSTEP3_TXT5"), ScpArgMsg("CHAR119_MSTEP3_TXT6"))
            if sel1 == 1 then
                local sel2 = ShowSelDlg(pc, 0, "CHAR119_MSTEP3_3_1_DLG2", ScpArgMsg("CHAR119_MSTEP3_TXT7"), ScpArgMsg("CHAR119_MSTEP3_TXT8"))
                if sel2 == 1 then
                    sObj.Goal3 = 2
                    ShowOkDlg(pc, "CHAR119_MSTEP3_3_1_DLG3", 1)
                    local book_item = GetInvItemCount(pc, "HIDDEN_MATADOR_MSTEP3_3_ITEM4")
                    if book_item < 1 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, "HIDDEN_MATADOR_MSTEP3_3_ITEM4", 1, "Quest_HIDDEN_MATADOR")
                    local ret = TxCommit(tx);
                end
            end
        end
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end


function SCR_CHAR119_MSTEP3_4_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CHAR119_MSTEP3_4_NPC_NORMAL_1(self, pc)
        --SCR_FED_ACCESSORY_NORMAL_3
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_4_DLG1", 1)
    ShowBalloonText(pc, "CHAR119_MSTEP3_4_PC_DLG1", 5)
    if  sObj.Goal4 < 1 then
        sObj.Goal4 = 1
        SaveSessionObject(pc, sObj)
    end
end

function SCR_CHAR119_MSTEP3_4_NPC_NORMAL_1_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    local item = GetInvItemCount(pc, "HIDDEN_GRASS_WHITETREES231")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step4 < 1 then
                if item < 1 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_CHAR119_MSTEP3_4_NPC_NORMAL_2(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19');
    local item = GetInvItemCount(pc, "HIDDEN_GRASS_WHITETREES231")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    ShowOkDlg(pc, "CHAR119_MSTEP3_4_1_DLG1", 1)
    if sObj.Step4 < 1 then
        sObj.Step4 = 1
--        print("sObj.Step1 : "..sObj.Step1.."/ ".."sObj.Step2 : "..sObj.Step2.."/ ".."sObj.Step3 : "..sObj.Step3.."/ ".."sObj.Step4 : "..sObj.Step4)
        SaveSessionObject(pc, sObj)
    end
    local tx = TxBegin(pc)
    TxTakeItem(tx, "HIDDEN_GRASS_WHITETREES231", item, "Quest_HIDDEN_MATADOR")
    local ret = TxCommit(tx);
    if sObj.Step1 >= 1 and sObj.Step2 >= 1 and sObj.Step3 >= 1 and sObj.Step4 >= 1 then
--        print("sObj.Step1 : "..sObj.Step1.."/ ".."sObj.Step2 : "..sObj.Step2.."/ ".."sObj.Step3 : "..sObj.Step3.."/ ".."sObj.Step4 : "..sObj.Step4)
        if hidden_prop == 20 then
--            print(hidden_prop)
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_19', 60)
        end
    end
end

function SCR_CHAR119_MSTEP3_4_NPC_NORMAL_2_PRECHECK(pc)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    local item = GetInvItemCount(pc, "HIDDEN_GRASS_WHITETREES231")
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if prop >= 20 then
        if sObj ~= nil then
            if sObj.Step4 < 1 then
                if item >= 1 then
                    return "YES"
                end
            end
        else
            return "NO"
        end
    end
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = 1;
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_BORN_UPDATE(self)
    local _obj = GetScpObjectList(self, 'HIDDEN_WHITETREES_GRASS1')
    local now_time = os.date('*t')
    local min = now_time['min']
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj = GetScpObjectList(self, 'HIDDEN_WHITETREES_GRASS1')
        if #_obj == 0 then
            self.NumArg2 = self.NumArg2 + 1; --120
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = 1;
                
                local pos1 = GetExProp(self, 'HIDDEN_WHITETREES_GRASS1_POS_1')
                local pos2 = GetExProp(self, 'HIDDEN_WHITETREES_GRASS2_POS_2')
                local pos3 = GetExProp(self, 'HIDDEN_WHITETREES_GRASS3_POS_3')
                local pos4 = GetExProp(self, 'HIDDEN_WHITETREES_GRASS4_POS_4')
                local pos5 = GetExProp(self, 'HIDDEN_WHITETREES_GRASS5_POS_5')
                
                local pos_arr = {pos1, pos2, pos3, pos4, pos5}
                
                local loc = {}
                loc[1] = {687, -124, -1289}
                loc[2] = {-420, 52, -1264}
                loc[3] = {618, 147, -445}
                loc[4] = {-884, 53, -1069}
                loc[5] = {119, 53, -1014}
                
                local x, y, z
                local target_pos = WHITETREES_GRASS_LOC_CK(self, pos_arr)
                x = loc[target_pos][1]
                y = loc[target_pos][2]
                z = loc[target_pos][3]
                
                local mon = CREATE_MONSTER_EX(self, 'siauliai_grass_3', x, y, z, 0, 'Neutral', nil, SCR_HIDDEN_GRASS_WHITETREES231_SET);
                --print(x, y, z)
                AddScpObjectList(self, 'HIDDEN_WHITETREES_GRASS1', mon)
                EnableAIOutOfPC(mon)
                SetLifeTime(mon, 3600);
            end
        elseif #_obj >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_BORN_LEAVE(self)
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_DEAD_ENTER(self)
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_DEAD_UPDATE(self)
end

function SCR_WHITETREES231_CHAR119_MSTEP3_4_TS_DEAD_LEAVE(self)
end

function WHITETREES_GRASS_LOC_CK(self, pos_arr)
    local i
    local j = 0
    local random = {}
    for i = 1, #pos_arr do
        if pos_arr[i] == 0 then
            random[j+1] = pos_arr[i] + i
            j = j + 1
        end
    end
    
    local rnd = select(IMCRandom(1,4), random[1], random[2], random[3], random[4])
    return rnd
end

function SCR_HIDDEN_GRASS_WHITETREES231_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_GRASS_WHITETREES231"
--	mon.MaxDialog = 1;
end

function SCR_HIDDEN_GRASS_WHITETREES231_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
    if sObj ~= nil then
        if GetInvItemCount(pc, 'HIDDEN_GRASS_WHITETREES231') < 1 then
            if sObj.Step6 < 1 then
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 5, 'MATADOR_GLASS')
                local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR119_MSTEP3_4_MSG1"), 'SITGROPE_LOOP', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result, animTime, before_time, 'MATADOR_GLASS')
                if result == 1 then
                    local tx1 = TxBegin(pc);
                    TxGiveItem(tx1, "HIDDEN_GRASS_WHITETREES231", 1, "Quest_HIDDEN_MATADOR");
                    local ret = TxCommit(tx1);
                    PlayEffect(self, 'F_pc_making_finish_orange', 2.0, nil, 'MID')
                    sObj.Step6 = 1
                    local now_time = os.date('*t')
                    local year = now_time['year']
                    local month = now_time['month']
                    local day = now_time['day']
                    local hour = now_time['hour']
                    local min = now_time['min']
                    
                    local _last_tiem = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
                    --local _next_time = 30
                    sObj.String1 = _last_tiem
                    --sObj.String2 = tostring(_next_time)
                    SaveSessionObject(pc, sObj)
                end
            else
                ShowBalloonText(pc, "CHAR119_MSTEP3_4_TXT1", 5)
            end
        else
            ShowBalloonText(pc, "CHAR119_MSTEP3_4_TXT2", 5)
        end
    end
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg1 = min;
    self.NumArg3 = 1;
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _stone = GetScpObjectList(self, 'HIDDEN_MINERAL_CMINE661_CREATE')
        --print(self.NumArg2, self.NumArg3, #_stone)
        if #_stone == 0 then
            self.NumArg2 = self.NumArg2 + 1; --120
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = 1;
                local _stone = GetScpObjectList(self, 'HIDDEN_MINERAL_CMINE661_CREATE')
                if #_stone == 0 then
                    local x, y, z = GetPos(self)
                    local mon
                    local ran = IMCRandom(1, 5)
                    local ran_pos = {}
                    if GetZoneName(self) == "d_cmine_66_1" then
                        ran_pos[1] = {-558, 414, -1484}
                        ran_pos[2] = {246, 414, -1233}
                        ran_pos[3] = {389, 414, -225}
                        ran_pos[4] = {-685, 414, -569}
                        ran_pos[5] = {376, 414, -836}
                        mon = CREATE_MONSTER_EX(self, 'remains37_stones', ran_pos[ran][1], ran_pos[ran][2], ran_pos[ran][3], 0, 'Neutral', nil, SCR_HIDDEN_MINERAL_CMINE661_SET);
                        --print(GetZoneName(self), ran_pos[ran][1], ran_pos[ran][2], ran_pos[ran][3])
                        AddScpObjectList(self, 'HIDDEN_MINERAL_CMINE661_CREATE', mon)
                    elseif GetZoneName(self) == "d_cmine_66_2" then
                        ran_pos[1] = {2183, 510, 1064}
                        ran_pos[2] = {2188, 510, 253}
                        ran_pos[3] = {1489, 510, -185}
                        ran_pos[4] = {2174, 510, -644}
                        ran_pos[5] = {1900, 510,-1190}
                        mon = CREATE_MONSTER_EX(self, 'remains37_stones', ran_pos[ran][1], ran_pos[ran][2], ran_pos[ran][3], 0, 'Neutral', nil, SCR_HIDDEN_MINERAL_CMINE662_SET);
                        --print(GetZoneName(self), ran_pos[ran][1], ran_pos[ran][2], ran_pos[ran][3])
                        AddScpObjectList(self, 'HIDDEN_MINERAL_CMINE661_CREATE', mon)
                    end
                    if mon ~= nil then
                        EnableAIOutOfPC(mon)
                        SetLifeTime(mon, 3600);
                    end
                end
            end
        elseif #_stone >= 2 then
            for i = 3, #_stone do
                Kill(_stone[i])
            end
        end
    end
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_MINERAL_CMINE661_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_MINERAL_CMINE661_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_MINERAL_CMINE661"
end

function SCR_HIDDEN_MINERAL_CMINE662_SET(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
    mon.SimpleAI = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Dialog = "HIDDEN_MINERAL_CMINE662"
end

function SCR_HIDDEN_MINERAL_CMINE661_DIALOG(self, pc)
    MINERAL_CMINE66_OBJECT_DLG(pc, "Step5", "Step9", "String2")
end

function SCR_HIDDEN_MINERAL_CMINE662_DIALOG(self, pc)
    MINERAL_CMINE66_OBJECT_DLG(pc, "Step7", "Step10", "String3")
end

function MINERAL_CMINE66_OBJECT_DLG(pc, _step1, _step2, _string)
    local prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_19')
    if prop == 20 then
        if GetInvItemCount(pc, 'HIDDEN_MINERAL_CMINE661_ITEM1') < 2 then
            local sObj = GetSessionObject(pc, "SSN_MATADOR_UNLOCK")
            if sObj[_step1] < 1 then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("HIDDEN_MINERAL_CMINE661_MSG1"), 'SKL_ASSISTATTACK_MINING', 2, 'SSN_HATE_AROUND')
                if result == 1 then
                    local tx1 = TxBegin(pc);
                    TxGiveItem(tx1, "HIDDEN_MINERAL_CMINE661_ITEM1", 1, "Quest_HIDDEN_MATADOR");
                    local ret = TxCommit(tx1);
                    if ret == 'SUCCESS' then
                        sObj[_step1] = 1
                        local now_time = os.date('*t')
                        local year = now_time['year']
                        local month = now_time['month']
                        local day = now_time['day']
                        local hour = now_time['hour']
                        local min = now_time['min']
                        
                        local _last_tiem = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
                        sObj[_string] = _last_tiem
                        sObj[_step2] = min
                        SaveSessionObject(pc, sObj)
                    end
                end
            else
                ShowBalloonText(pc, "CHAR119_MSTEP3_2_TXT1", 5)
            end
        else
            ShowBalloonText(pc, "CHAR119_MSTEP3_2_TXT2", 5)
        end
    end
end

-- HIDDEN BULLETMARKER --
function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    
    self.NumArg2 = min;
    self.NumArg4 = 10 --30
    
    self.NumArg1 = IMCRandom(1, 5)
end

function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_BORN_UPDATE(self)
    if self.StrArg1 ~= "setting_comp" then
        local obj = {}
        local loc = {}
        loc[1] = {-4, 245, -495}
        loc[2] = {-345, 263, -236}
        loc[3] = {739, 293, 464}
        loc[4] = {1503, 293, 12}
        loc[5] = {924, 245, -714}
        local func_Name = {
                            SCR_CHAR318_MSETP3_1_OBJ_SET1,
                            SCR_CHAR318_MSETP3_1_OBJ_SET2,
                            SCR_CHAR318_MSETP3_1_OBJ_SET3,
                            SCR_CHAR318_MSETP3_1_OBJ_SET4,
                            SCR_CHAR318_MSETP3_1_OBJ_SET5
                          }
        local func_Name2 = {
                            SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET1,
                            SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET2,
                            SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET3,
                            SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET4,
                            SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET5
                          }
        for i = 1, 5 do
            obj[i] = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ'..i)
            
            if #obj[i] == 0 then
                local mon1 = CREATE_MONSTER_EX(self, 'npc_rokas_6', loc[i][1], loc[i][2], loc[i][3], 0, 'Neutral', nil, func_Name[i]);
                local mon2 = CREATE_MONSTER_EX(self, 'HiddenTrigger6', loc[i][1], loc[i][2], loc[i][3], 0, 'Neutral', nil, func_Name2[i]);
                AddScpObjectList(self, 'CHAR318_MSETP3_1_OBJ'..i, mon1)
                AddScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE'..i, mon2)
                AddScpObjectList(mon1, 'CHAR318_MSETP3_1_OBJ'..i..'CTR', self)
                EnableAIOutOfPC(mon1)
            end
            if #obj[i] >= 2 then
                for i = 2, #obj[i] do
                    Kill(obj[i])
                end
            end
            --print(self.NumArg1)
            self.StrArg1 = "setting_comp"
        end
        
        local obj_1 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ1')
        local obj_2 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ2')
        local obj_3 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ3')
        local obj_4 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ4')
        local obj_5 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ5')
        
        local hide_1 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE1')
        local hide_2 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE2')
        local hide_3 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE3')
        local hide_4 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE4')
        local hide_5 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE5')
        
        if #obj_1 >= 1 then
            for i = 1,  #obj_1 do
                if self.NumArg1 == 1 then
                    if obj_1[i].Dialog == "CHAR318_MSETP3_1_OBJ1" then
                        obj_1[i].StrArg1 = "ON"
                        if #hide_1 >= 1 then
                            for j = 1,  #hide_1 do
                                if hide_1[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE1" then
                                    if IsBuffApplied(hide_1[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                        AddBuff(self, hide_1[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if #obj_2 >= 1 then
            for i = 1,  #obj_2 do
                if self.NumArg1 == 2 then
                    if obj_2[i].Dialog == "CHAR318_MSETP3_1_OBJ2" then
                        obj_2[i].StrArg1 = "ON"
                        if #hide_2 >= 1 then
                            for j = 1,  #hide_2 do
                                if hide_2[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE2" then
                                    if IsBuffApplied(hide_2[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                        AddBuff(self, hide_2[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if #obj_3 >= 1 then
            for i = 1,  #obj_3 do
                if self.NumArg1 == 3 then
                    if obj_3[i].Dialog == "CHAR318_MSETP3_1_OBJ3" then
                        obj_3[i].StrArg1 = "ON"
                        if #hide_3 >= 1 then
                            for j = 1,  #hide_3 do
                                if hide_3[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE3" then
                                    if IsBuffApplied(hide_3[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                        AddBuff(self, hide_3[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if #obj_4 >= 1 then
            for i = 1,  #obj_4 do
                if self.NumArg1 == 4 then
                    if obj_4[i].Dialog == "CHAR318_MSETP3_1_OBJ4" then
                        obj_4[i].StrArg1 = "ON"
                        if #hide_4 >= 1 then
                            for j = 1,  #hide_4 do
                                if hide_4[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE4" then
                                    if IsBuffApplied(hide_4[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                        AddBuff(self, hide_4[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if #obj_5 >= 1 then
            for i = 1,  #obj_5 do
                if self.NumArg1 == 5 then
                    if obj_5[i].Dialog == "CHAR318_MSETP3_1_OBJ5" then
                        obj_5[i].StrArg1 = "ON"
                        if #hide_5 >= 1 then
                            for j = 1,  #hide_5 do
                                if hide_5[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE5" then
                                    if IsBuffApplied(hide_5[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                        AddBuff(self, hide_5[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif self.StrArg1 == "setting_comp" then
        local obj_1 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ1')
        local obj_2 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ2')
        local obj_3 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ3')
        local obj_4 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ4')
        local obj_5 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ5')
        
        local hide_1 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE1')
        local hide_2 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE2')
        local hide_3 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE3')
        local hide_4 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE4')
        local hide_5 = GetScpObjectList(self, 'CHAR318_MSETP3_1_OBJ_HIDE5')
--        print("self.NumArg1 : "..self.NumArg1)
        if self.NumArg1 == 1 then
            if #obj_1 >= 1 then
                for i = 1,  #obj_1 do
                    if obj_1[i].Dialog == "CHAR318_MSETP3_1_OBJ1" then
                        if obj_1[i].StrArg1 ~= "ON" then
                            obj_1[i].StrArg1 = "ON"
                            if #hide_1 >= 1 then
                                for j = 1,  #obj_1 do
                                    if hide_1[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE1" then
                                        if IsBuffApplied(hide_1[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                            AddBuff(self, hide_1[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                            --print("111111")
                                        end
                                    end
                                end
                            end
                        else
                            local now_time = os.date('*t')
                            local min = now_time['min']
                            if tonumber(min) ~= tonumber(self.NumArg2) then
                                self.NumArg2 = min;
                                --print("hhhhhh")
                                self.NumArg3 = self.NumArg3  + 1;
                                if self.NumArg3 >= self.NumArg4 then
                                    self.NumArg3 = 0;
                                    self.NumArg4 = 10 --10
                                    obj_1[i].StrArg1 = "OFF"
                                    --print(obj_2[i].StrArg1)
                                    self.NumArg1 = 2
                                end
                            end
                        end
                    end
                end
            end
        end
        if self.NumArg1 == 2 then
            if #obj_2 >= 1 then
                for i = 1,  #obj_2 do
                    if obj_2[i].Dialog == "CHAR318_MSETP3_1_OBJ2" then
                        if obj_2[i].StrArg1 ~= "ON" then
                            obj_2[i].StrArg1 = "ON"
                            if #hide_2 >= 1 then
                                for j = 1,  #obj_2 do
                                    if hide_2[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE2" then
                                        if IsBuffApplied(hide_2[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                            AddBuff(self, hide_2[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                            --print("222222")
                                        end
                                    end
                                end
                            end
                        else
                            local now_time = os.date('*t')
                            local min = now_time['min']
                            if tonumber(min) ~= tonumber(self.NumArg2) then
                                self.NumArg2 = min;
                                self.NumArg3 = self.NumArg3  + 1;
                                if self.NumArg3 >= self.NumArg4 then
                                    self.NumArg3 = 0;
                                    self.NumArg4 = 10 --10
                                    obj_2[i].StrArg1 = "OFF"
                                    --print(obj_2[i].StrArg1)
                                    self.NumArg1 = 3
                                end
                            end
                        end
                    end
                end
            end
        end
        if self.NumArg1 == 3 then
            if #obj_3 >= 1 then
                for i = 1,  #obj_3 do
                    if obj_3[i].Dialog == "CHAR318_MSETP3_1_OBJ3" then
                        if obj_3[i].StrArg1 ~= "ON" then
                            obj_3[i].StrArg1 = "ON"
                            if #hide_3 >= 1 then
                                for j = 1,  #obj_3 do
                                    if hide_3[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE3" then
                                        if IsBuffApplied(hide_3[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                            AddBuff(self, hide_3[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                            --print("333333")
                                        end
                                    end
                                end
                            end
                        else
                            local now_time = os.date('*t')
                            local min = now_time['min']
                            if tonumber(min) ~= tonumber(self.NumArg2) then
                                self.NumArg2 = min;
                                self.NumArg3 = self.NumArg3  + 1;
                                if self.NumArg3 >= self.NumArg4 then
                                    self.NumArg3 = 0;
                                    self.NumArg4 = 10 --10
                                    obj_3[i].StrArg1 = "OFF"
                                    --print(obj_2[i].StrArg1)
                                    self.NumArg1 = 4
                                end
                            end
                        end
                    end
                end
            end
        end
        if self.NumArg1 == 4 then
            if #obj_4 >= 1 then
                for i = 1,  #obj_4 do
                    if obj_4[i].Dialog == "CHAR318_MSETP3_1_OBJ4" then
                        if obj_4[i].StrArg1 ~= "ON" then
                            obj_4[i].StrArg1 = "ON"
                            if #hide_4 >= 1 then
                                for j = 1,  #obj_4 do
                                    if hide_4[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE4" then
                                        if IsBuffApplied(hide_4[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                            AddBuff(self, hide_4[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                            --print("444444")
                                        end
                                    end
                                end
                            end
                        else
                            local now_time = os.date('*t')
                            local min = now_time['min']
                            if tonumber(min) ~= tonumber(self.NumArg2) then
                                self.NumArg2 = min;
                                self.NumArg3 = self.NumArg3  + 1;
                                if self.NumArg3 >= self.NumArg4 then
                                    self.NumArg3 = 0;
                                    self.NumArg4 = 10 --10
                                    obj_4[i].StrArg1 = "OFF"
                                    --print(obj_2[i].StrArg1)
                                    self.NumArg1 = 5
                                end
                            end
                        end
                    end
                end
            end
        end
        if self.NumArg1 == 5 then
            if #obj_5 >= 1 then
                for i = 1,  #obj_5 do
                    if obj_5[i].Dialog == "CHAR318_MSETP3_1_OBJ5" then
                        if obj_5[i].StrArg1 ~= "ON" then
                            obj_5[i].StrArg1 = "ON"
                            if #hide_5 >= 1 then
                                for j = 1,  #obj_5 do
                                    if hide_5[j].Enter == "CHAR318_MSETP3_1_OBJ_HIDE5" then
                                        if IsBuffApplied(hide_5[j], "CHAR318_MSETP3_1_EFFECT_BUFF1") == "NO" then
                                            AddBuff(self, hide_5[j], "CHAR318_MSETP3_1_EFFECT_BUFF1",1 ,0, 600000,1)
                                            --print("555555")
                                        end
                                    end
                                end
                            end
                        else
                            local now_time = os.date('*t')
                            local min = now_time['min']
                            if tonumber(min) ~= tonumber(self.NumArg2) then
                                self.NumArg2 = min;
                                self.NumArg3 = self.NumArg3  + 1;
                                if self.NumArg3 >= self.NumArg4 then
                                    self.NumArg3 = 0;
                                    self.NumArg4 = 10 --10
                                    obj_5[i].StrArg1 = "OFF"
                                    --print(obj_2[i].StrArg1)
                                    self.NumArg1 = 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_BORN_LEAVE(self)
end

function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_DEAD_ENTER(self)
end

function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_DEAD_UPDATE(self)
end

function SCR_CHAR318_MSETP3_1_CTROBJ1_TS_DEAD_LEAVE(self)
end

function SCR_CHAR318_MSETP3_1_OBJ_SET1(mon)
	mon.BTree = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHAR318_MSETP3_1_OBJ_NAME")
	mon.Dialog = "CHAR318_MSETP3_1_OBJ1"
end

function SCR_CHAR318_MSETP3_1_OBJ_SET2(mon)
	mon.BTree = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHAR318_MSETP3_1_OBJ_NAME")
	mon.Dialog = "CHAR318_MSETP3_1_OBJ2"
end

function SCR_CHAR318_MSETP3_1_OBJ_SET3(mon)
	mon.BTree = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHAR318_MSETP3_1_OBJ_NAME")
	mon.Dialog = "CHAR318_MSETP3_1_OBJ3"
end

function SCR_CHAR318_MSETP3_1_OBJ_SET4(mon)
	mon.BTree = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHAR318_MSETP3_1_OBJ_NAME")
	mon.Dialog = "CHAR318_MSETP3_1_OBJ4"
end

function SCR_CHAR318_MSETP3_1_OBJ_SET5(mon)
	mon.BTree = "None";
	mon.KDArmor = 999
	mon.Name = ScpArgMsg("CHAR318_MSETP3_1_OBJ_NAME")
	mon.Dialog = "CHAR318_MSETP3_1_OBJ5"
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET1(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CHAR318_MSETP3_1_OBJ_HIDE1"
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET2(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CHAR318_MSETP3_1_OBJ_HIDE2"
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET3(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CHAR318_MSETP3_1_OBJ_HIDE3"
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET4(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CHAR318_MSETP3_1_OBJ_HIDE4"
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE_SET5(mon)
	mon.BTree = "None";
    mon.Tactics = "None";
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.Enter = "CHAR318_MSETP3_1_OBJ_HIDE5"
end

function SCR_CHAR318_MSETP3_1_OBJ1_DIALOG(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
--    if sObj ~= nil then
--        if sObj.Step11 < 30 then
            if self.StrArg1 == "ON" then
                local item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local key_Item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if key_Item < 150 then
                    if item > 0 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_1_ACTION1"), 'SITREAD', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
    --                        if sObj.Step11 < 30 then
    --                            sObj.Step11 = sObj.Step11 + 1
    --                            SaveSessionObject(pc, sObj)
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM2", item, "Quest_HIDDEN_BULLET");
                                if (key_Item + item) <= 150 then
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", item, "Quest_HIDDEN_BULLET");
                                elseif (key_Item + item) > 150 then
                                    local discnt_item = item - ((key_Item + item) - 150)
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", discnt_item, "Quest_HIDDEN_BULLET");
                                end
                                local ret = TxCommit(tx1);
                                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG1", 5)
    --                            if sObj.Step11 >= 30 then
    --                                if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE1") == "NO" then
    --                                    HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE1")
    --                                end
    --                            end
    --                        elseif sObj.Step11 >= 30 then
    --                            ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
    --                        end
                        end
                    else
                        ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG4",3)
                    end
                else
                    ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
                end
            else
                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG2",3)
            end
--        else
--            ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG3",3)
--        end
--    end
end

function SCR_CHAR318_MSETP3_1_OBJ2_DIALOG(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
--    if sObj ~= nil then
--        if sObj.Step12 < 30 then
            if self.StrArg1 == "ON" then
                local item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local key_Item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if key_Item < 150 then
                    if item > 0 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_1_ACTION1"), 'SITREAD', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
    --                        if sObj.Step12 < 30 then
    --                            sObj.Step12 = sObj.Step12 + 1
    --                            SaveSessionObject(pc, sObj)
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM2", item, "Quest_HIDDEN_BULLET");
                                if (key_Item + item) <= 150 then
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", item, "Quest_HIDDEN_BULLET");
                                elseif (key_Item + item) > 150 then
                                    local discnt_item = item - ((key_Item + item) - 150)
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", discnt_item, "Quest_HIDDEN_BULLET");
                                end
                                local ret = TxCommit(tx1);
                                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG1", 5)
    --                            if sObj.Step12 >= 30 then
    --                                if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE2") == "NO" then
    --                                    HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE2")
    --                                end
    --                            end
    --                        elseif sObj.Step12 >= 30 then
    --                            ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
    --                        end
                        end
                    else
                        ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG4",3)
                    end
                else
                    ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
                end
            else
                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG2",3)
            end
--        else
--            ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG3",3)
--        end
--    end
end

function SCR_CHAR318_MSETP3_1_OBJ3_DIALOG(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
--    if sObj ~= nil then
--        if sObj.Step13 < 30 then
            if self.StrArg1 == "ON" then
                local item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local key_Item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if key_Item < 150 then
                    if item > 0 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_1_ACTION1"), 'SITREAD', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
    --                        if sObj.Step13 < 30 then
    --                            sObj.Step13 = sObj.Step13 + 1
    --                            SaveSessionObject(pc, sObj)
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM2", item, "Quest_HIDDEN_BULLET");
                                if (key_Item + item) <= 150 then
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", item, "Quest_HIDDEN_BULLET");
                                elseif (key_Item + item) > 150 then
                                    local discnt_item = item - ((key_Item + item) - 150)
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", discnt_item, "Quest_HIDDEN_BULLET");
                                end
                                local ret = TxCommit(tx1);
                                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG1", 5)
    --                            if sObj.Step13 >= 30 then
    --                                if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE3") == "NO" then
    --                                    HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE3")
    --                                end
    --                            end
    --                        elseif sObj.Step13 >= 30 then
    --                            ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
    --                        end
                        end
                    else
                        ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG4",3)
                    end
                else
                    ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
                end
            else
                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG2",3)
            end
--        else
--            ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG3",3)
--        end
--    end
end

function SCR_CHAR318_MSETP3_1_OBJ4_DIALOG(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
--    if sObj ~= nil then
--        if sObj.Step14 < 30 then
            if self.StrArg1 == "ON" then
                local item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local key_Item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if key_Item < 150 then
                    if item > 0 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_1_ACTION1"), 'SITREAD', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
    --                        if sObj.Step14 < 30 then
    --                            sObj.Step14 = sObj.Step14 + 1
    --                            SaveSessionObject(pc, sObj)
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM2", item, "Quest_HIDDEN_BULLET");
                                if (key_Item + item) <= 150 then
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", item, "Quest_HIDDEN_BULLET");
                                elseif (key_Item + item) > 150 then
                                    local discnt_item = item - ((key_Item + item) - 150)
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", discnt_item, "Quest_HIDDEN_BULLET");
                                end
                                local ret = TxCommit(tx1);
                                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG1", 5)
    --                            if sObj.Step14 >= 30 then
    --                                if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE4") == "NO" then
    --                                    HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE4")
    --                                end
    --                            end
    --                        elseif sObj.Step14 >= 30 then
    --                            ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
    --                        end
                        end
                    else
                        ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG4",3)
                    end
                else
                    ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
                end
            else
                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG2",3)
            end
--        else
--            ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG3",3)
--        end
--    end
end

function SCR_CHAR318_MSETP3_1_OBJ5_DIALOG(self, pc)
--    local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
--    if sObj ~= nil then
--        if sObj.Step15 < 30 then
            if self.StrArg1 == "ON" then
                local item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM2")
                local key_Item = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_ITEM1")
                if key_Item < 150 then
                    if item > 0 then
                        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_1_ACTION1"), 'SITREAD', 2, 'SSN_HATE_AROUND')
                        if result == 1 then
    --                        if sObj.Step15 < 30 then
    --                            sObj.Step15 = sObj.Step15 + 1
    --                            SaveSessionObject(pc, sObj)
                                local tx1 = TxBegin(pc);
                                TxTakeItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM2", item, "Quest_HIDDEN_BULLET");
                                if (key_Item + item) <= 150 then
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", item, "Quest_HIDDEN_BULLET");
                                elseif (key_Item + item) > 150 then
                                    local discnt_item = item - ((key_Item + item) - 150)
                                    TxGiveItem(tx1, "HIDDEN_BULLET_MSTEP3_ITEM1", discnt_item, "Quest_HIDDEN_BULLET");
                                end
                                local ret = TxCommit(tx1);
                                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG1", 5)
    --                            if sObj.Step15 >= 30 then
    --                                if isHideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE5") == "NO" then
    --                                    HideNPC(pc, "CHAR318_MSETP3_1_OBJ_HIDE5")
    --                                end
    --                            end
    --                        elseif sObj.Step15 >= 30 then
    --                            ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
    --                        end
                        end
                    else
                        ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG4",3)
                    end
                else
                    ShowBalloonText(pc,"CHAR318_MSETP3_1_MSG3",3)
                end
            else
                ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG2",3)
            end
--        else
--            ShowBalloonText(pc, "CHAR318_MSETP3_1_MSG3",3)
--        end
--    end
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE1_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE2_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE3_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE4_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_1_OBJ_HIDE5_ENTER(self, pc)
    
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    self.NumArg1 = min;
    self.NumArg3 = 1
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj1 = GetScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_1_OBJ')
        if #_obj1 == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            --print(self.NumArg2)
            if self.NumArg2 >= self.NumArg3 then
                self.NumArg2 = 0;
                self.NumArg3 = 1
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'Spion_red', x, y, z, 0, 'HitMe', nil, HIDDEN_CHAR318_MSETP3_1_OBJ_SET);
                local mon2 = CREATE_MONSTER_EX(self, "Hiddennpc_move",x, y, z, 0, 'Neutral', nil, HIDDEN_CHAR318_MSETP3_1_EFF_SET);
                AttachEffect(mon2, "I_spread_out003_light", 2.5, 1, "BOT",1)
                SetNoDamage(mon1, 1)
                AddScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_1_OBJ', mon1)
                --AddScpObjectList(mon1, 'HIDDEN_CHAR318_MSETP3_1_OBJ_EFF1', mon2)
                --AddScpObjectList(mon2, 'SUB_CHAR318_MSETP3_1_OBJ_EFF1', mon1)
                AttachToObject(mon2, mon1, 'None', 'None', 1)
                EnableAIOutOfPC(mon1)
            end
        end
        if #_obj1 >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_1_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR318_MSETP3_1_OBJ_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Enter = "HIDDEN_CHAR318_MSETP3_1_MON"
	self.Name = ScpArgMsg("CHAR318_MON_NAME1")
	self.KDArmor = 999
end


function HIDDEN_CHAR318_MSETP3_1_EFF_SET(mon)
	mon.BTree = 'None';
--	mon.Tactics = 'CHAR318_MSETP3_1_EFF1_TACTICS';
	mon.Enter = "MSETP3_1_EFF_TACTICS1"
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.TargetMark = 0;
	mon.TargetWindow = 0;
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_BORN_ENTER(self)
    SCR_MON_DUMMY_TS_BORN_ENTER(self)
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_BORN_UPDATE(self)
--    local _obj = GetScpObjectList(self, 'SUB_CHAR318_MSETP3_1_OBJ_EFF1')
--    if #_obj == 0 then
--        Kill(self);
--    else
--        local x, y, z = GetFrontPos(_obj[1], 30)
--        SetDirectionToPos(self, x, z)
--        local angle = GetAngleFromPos(_pc[1], x, z)
--        SetDirectionByAngle(self, angle)
--    end
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_BORN_LEAVE(self)
    SCR_MON_DUMMY_TS_BORN_LEAVE(self)
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_DEAD_ENTER(self)
    SCR_MON_DUMMY_TS_DEAD_ENTER(self)
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_DEAD_UPDATE(self)
    SCR_MON_DUMMY_TS_DEAD_UPDATE(self)
end

function SCR_CHAR318_MSETP3_1_EFF1_TACTICS_TS_DEAD_LEAVE(self)
    SCR_MON_DUMMY_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_2_MON_ENTER(self, pc)
    
end

function SCR_MSETP3_1_EFF_TACTICS1_ENTER(self, pc)
    
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    self.NumArg1 = min;
    self.NumArg3 = 1
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
--    print("SCR_HIDDEN_CHAR318_MSETP3_1_TS_BORN_UPDATE")
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj1 = GetScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_2_OBJ')
        if #_obj1 == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            --print(self.NumArg2)
            if self.NumArg2 >= self.NumArg3 then
                --print("222222")
                self.NumArg2 = 0;
                self.NumArg3 = 1
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'Firent', x, y, z, 0, 'HitMe', nil, HIDDEN_CHAR318_MSETP3_2_OBJ_SET);
                local mon2 = CREATE_MONSTER_EX(self, "Hiddennpc_move",x, y, z, 0, 'Neutral', nil, HIDDEN_CHAR318_MSETP3_2_EFF_SET);
                AttachEffect(mon2, "I_spread_out003_light", 3, 1, "BOT",1)
                SetNoDamage(mon1, 1)
                AddScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_2_OBJ', mon1)
                --AddScpObjectList(mon1, 'HIDDEN_CHAR318_MSETP3_1_OBJ_EFF1', mon2)
                --AddScpObjectList(mon2, 'SUB_CHAR318_MSETP3_1_OBJ_EFF1', mon1)
                AttachToObject(mon2, mon1, 'None', 'None', 1)
                EnableAIOutOfPC(mon1)
            end
        end
        if #_obj1 >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_2_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR318_MSETP3_2_OBJ_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Enter = "HIDDEN_CHAR318_MSETP3_2_MON"
	self.Name = ScpArgMsg("CHAR318_MON_NAME2")
	self.KDArmor = 999
end

function SCR_HIDDEN_CHAR318_MSETP3_2_MON_ENTER(self, pc)
    
end

function HIDDEN_CHAR318_MSETP3_2_EFF_SET(mon)
	mon.BTree = 'None';
--	mon.Tactics = 'CHAR318_MSETP3_1_EFF1_TACTICS';
	mon.Enter = "MSETP3_1_EFF_TACTICS2"
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.TargetMark = 0;
	mon.TargetWindow = 0;
end

function SCR_MSETP3_1_EFF_TACTICS2_ENTER(self, pc)
    
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    self.NumArg1 = min;
    self.NumArg3 = 1
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_BORN_UPDATE(self)
    local now_time = os.date('*t')
    local min = now_time['min']
    if tonumber(min) ~= tonumber(self.NumArg1) then
        self.NumArg1 = min;
        local _obj1 = GetScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_3_OBJ')
        if #_obj1 == 0 then
            self.NumArg2 = self.NumArg2 + 1;
            --print(self.NumArg2)
            if self.NumArg2 >= self.NumArg3 then
                --print("222222")
                self.NumArg2 = 0;
                self.NumArg3 = 1
                local x, y, z = GetPos(self)
                local mon1 = CREATE_MONSTER_EX(self, 'Repusbunny_purple', x, y, z, 0, 'HitMe', nil, HIDDEN_CHAR318_MSETP3_3_OBJ_SET);
                local mon2 = CREATE_MONSTER_EX(self, "Hiddennpc_move",x, y, z, 0, 'Neutral', nil, HIDDEN_CHAR318_MSETP3_3_EFF_SET);
                --print(x, y, z)
                AttachEffect(mon2, "I_spread_out003_light", 2.5, 1, "BOT",1)
                SetNoDamage(mon1, 1)
                AddScpObjectList(self, 'HIDDEN_CHAR318_MSETP3_3_OBJ', mon1)
                --AddScpObjectList(mon1, 'HIDDEN_CHAR318_MSETP3_1_OBJ_EFF1', mon2)
                --AddScpObjectList(mon2, 'SUB_CHAR318_MSETP3_1_OBJ_EFF1', mon1)
                AttachToObject(mon2, mon1, 'None', 'None', 1)
                EnableAIOutOfPC(mon1)
            end
        end
        if #_obj1 >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_BORN_LEAVE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_DEAD_ENTER(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_DEAD_UPDATE(self)
end

function SCR_HIDDEN_CHAR318_MSETP3_3_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR318_MSETP3_3_OBJ_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Enter = "HIDDEN_CHAR318_MSETP3_3_MON"
	self.Name = ScpArgMsg("CHAR318_MON_NAME3")
	self.KDArmor = 999
end

function SCR_HIDDEN_CHAR318_MSETP3_3_MON_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_3_STONE_TS_BORN_ENTER(self)
end

function HIDDEN_CHAR318_MSETP3_3_EFF_SET(mon)
	mon.BTree = 'None';
--	mon.Tactics = 'CHAR318_MSETP3_1_EFF1_TACTICS';
	mon.Enter = "MSETP3_1_EFF_TACTICS3"
    mon.SimpleAI = 'None';
	mon.KDArmor = 999
	mon.Name = "UnvisibleName"
	mon.TargetMark = 0;
	mon.TargetWindow = 0;
end

function SCR_MSETP3_1_EFF_TACTICS3_ENTER(self, pc)
    
end

function SCR_CHAR318_MSETP3_3_STONE_TS_BORN_UPDATE(self)
--    print("SCR_HIDDEN_CHAR318_MSETP3_1_TS_BORN_UPDATE")
    local _obj = {}
    local loc = {}
    loc[1] = {142, 128, -1151}
    loc[2] = {638, 80, -993}
    loc[3] = {-389, 127, -1378}
    loc[4] = {745, 80, -591}
    loc[5] = {383, 123, -435}
    loc[6] = {136, 243, -367}
    loc[7] = {1032, 29, -86}
    loc[8] = {770, 80, 272}
    loc[9] = {297, 80, 307}
    loc[10] = {621, 160, 654}
    loc[11] = {391, 80, -123}
    loc[12] = {1195, 80, 628}
    loc[13] = {325, 200, 910}
    loc[14] = {-153, 176, -951}
    loc[15] = {914, 29, -629}
    loc[16] = {148, 80, 468}
    loc[17] = {250, 123, -713}
    loc[18] = {-133, 184, -609}
    loc[19] = {427, 127, -915}
    loc[20] = {1057, 80, 909}
    
    for i = 1, 20 do
        _obj[i] = GetScpObjectList(self, 'HIDDEN_KATYN_STONE'..i)
        if #_obj[i] == 0 then
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_Q5', loc[i][1], loc[i][2], loc[i][3], 0, 'Neutral', nil, SCR_HIDDEN_STONE_KATYN451_SET, i);
            AddScpObjectList(self, 'HIDDEN_KATYN_STONE'..i, mon)
        end
        if #_obj[i] >= 2 then
            for i = 2, #_obj do
                Kill(_obj[i])
            end
        end
    end
    HOLD_MON_SCP(self, 1000)
end

function SCR_CHAR318_MSETP3_3_STONE_TS_BORN_LEAVE(self)
end

function SCR_CHAR318_MSETP3_3_STONE_TS_DEAD_ENTER(self)
end

function SCR_CHAR318_MSETP3_3_STONE_TS_DEAD_UPDATE(self)
end

function SCR_CHAR318_MSETP3_3_STONE_TS_DEAD_LEAVE(self)
end

function SCR_HIDDEN_STONE_KATYN451_SET(self, i)
	self.BTree = "None";
    self.Tactics = "None";
    if i == 1 then
	    self.Dialog = "HIDDEN_STONE_KATYN451_1"
	elseif i == 2 then
        self.Dialog = "HIDDEN_STONE_KATYN451_2"
	elseif i == 3 then
        self.Dialog = "HIDDEN_STONE_KATYN451_3"
	elseif i == 4 then
        self.Dialog = "HIDDEN_STONE_KATYN451_4"
	elseif i == 5 then
        self.Dialog = "HIDDEN_STONE_KATYN451_5"
	elseif i == 6 then
        self.Dialog = "HIDDEN_STONE_KATYN451_6"
	elseif i == 7 then
        self.Dialog = "HIDDEN_STONE_KATYN451_7"
	elseif i == 8 then
        self.Dialog = "HIDDEN_STONE_KATYN451_8"
	elseif i == 9 then
        self.Dialog = "HIDDEN_STONE_KATYN451_9"
	elseif i == 10 then
        self.Dialog = "HIDDEN_STONE_KATYN451_10"
	elseif i == 11 then
        self.Dialog = "HIDDEN_STONE_KATYN451_11"
	elseif i == 12 then
        self.Dialog = "HIDDEN_STONE_KATYN451_12"
	elseif i == 13 then
        self.Dialog = "HIDDEN_STONE_KATYN451_13"
	elseif i == 14 then
        self.Dialog = "HIDDEN_STONE_KATYN451_14"
	elseif i == 15 then
        self.Dialog = "HIDDEN_STONE_KATYN451_15"
	elseif i == 16 then
        self.Dialog = "HIDDEN_STONE_KATYN451_16"
	elseif i == 17 then
        self.Dialog = "HIDDEN_STONE_KATYN451_17"
	elseif i == 18 then
        self.Dialog = "HIDDEN_STONE_KATYN451_18"
	elseif i == 19 then
        self.Dialog = "HIDDEN_STONE_KATYN451_19"
	elseif i == 20 then
        self.Dialog = "HIDDEN_STONE_KATYN451_20"
    end
	self.KDArmor = 999
end

function SCR_HIDDEN_STONE_KATYN451_1_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 1)
end

function SCR_HIDDEN_STONE_KATYN451_2_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 2)
end

function SCR_HIDDEN_STONE_KATYN451_3_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 3)
end

function SCR_HIDDEN_STONE_KATYN451_4_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 4)
end

function SCR_HIDDEN_STONE_KATYN451_5_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 5)
end

function SCR_HIDDEN_STONE_KATYN451_6_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 6)
end

function SCR_HIDDEN_STONE_KATYN451_7_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 7)
end

function SCR_HIDDEN_STONE_KATYN451_8_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 8)
end

function SCR_HIDDEN_STONE_KATYN451_9_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 9)
end

function SCR_HIDDEN_STONE_KATYN451_10_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 10)
end

function SCR_HIDDEN_STONE_KATYN451_11_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 11)
end

function SCR_HIDDEN_STONE_KATYN451_12_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 12)
end

function SCR_HIDDEN_STONE_KATYN451_13_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 13)
end

function SCR_HIDDEN_STONE_KATYN451_14_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 14)
end

function SCR_HIDDEN_STONE_KATYN451_15_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 15)
end

function SCR_HIDDEN_STONE_KATYN451_16_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 16)
end

function SCR_HIDDEN_STONE_KATYN451_17_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 17)
end

function SCR_HIDDEN_STONE_KATYN451_18_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 18)
end

function SCR_HIDDEN_STONE_KATYN451_19_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 19)
end

function SCR_HIDDEN_STONE_KATYN451_20_DIALOG(self, pc)
    HIDDEN_STONE_KATYN451_RUN(self, pc, 20)
end

function HIDDEN_STONE_KATYN451_RUN(self, pc, num)
    if IsBuffApplied(pc, "CHAR318_MSETP3_3_EFFECT_BUFF1") == "YES" then
        local sObj = GetSessionObject(pc, "SSN_BULLETMARKER_UNLOCK")
        if sObj ~= nil then
            local itemCnt = GetInvItemCount(pc, "HIDDEN_BULLET_MSTEP3_3_1ITEM1") 
            if itemCnt < 2 then
            if sObj['Goal'..num] == 1 then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR318_MSETP3_3_ACTION1"), '#SITGROPESET', 2, 'SSN_HATE_AROUND')
                if result == 1 then
                    sObj['Goal'..num] = 0
--                    print("sObj.Goal"..num.." : "..sObj['Goal'..num])
--                    print("-------------------------------")
--                    for i = 1, 20 do
--                        print("sObj.Goal"..i.." : "..sObj["Goal"..i])
--                    end
--                    print("-------------------------------")
                    if sObj.String3 == nil or sObj.String3 == "None" then
                        sObj.String3 = "FIND"
                    end
                    RunScript("GIVE_ITEM_TX", pc, "HIDDEN_BULLET_MSTEP3_3_1ITEM1", 1, "Quest_HIDDEN_BULLET")
                    SendAddOnMsg(pc, 'NOTICE_Dm_GetItem', ScpArgMsg("CHAR318_MSETP3_3_GETITEM"),5)
                    SaveSessionObject(pc, sObj)
                end
            end
            else
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll', ScpArgMsg("CHAR318_MSETP3_3_GETITEM1"),5)
            end
        end
    end
end


--HIDDEN NAKMUAY
function SCR_CHAR120_MSTEP5_NPC1_IN_ENTER(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_prop == 100 then
        ShowBalloonText(pc, "CHAR120_MSTEP5_NPC_DLG1", 5)
    end
end

function SCR_CHAR120_MSTEP5_NPC1_DIALOG(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
--    print(hidden_prop)
    if hidden_prop == 100 then
        local sel = ShowSelDlg(pc, 0, "CHAR120_MSTEP5_NPC_DLG2", ScpArgMsg("CHAR120_MSTEP5_SEL1"), ScpArgMsg("CHAR120_MSTEP5_SEL2"))
        if sel == 1 then
            SetEmoticon(pc, "I_emo_sleep")
            PlayAnim(pc, "STUN", 1)
            ShowBalloonText(pc, "CHAR120_MSTEP5_NPC_DLG3", 3)
            sleep(1500)
            UIOpenToPC(pc, 'fullblack', 1)
            PlayDirection(pc, "CHAR120_NAKMUAY_TRACK")
            sleep(1500)
            SetEmoticon(pc, "I_emo_exclamation")
            UIOpenToPC(pc, 'fullblack', 0)
        end
    end
end

function SCR_CHAR120_MSTEP5_NPC2_DIALOG(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_prop == 250 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("CHAR120_MSETP5_CHAT1"), 'TALK', 2)
        if result == 1 then
            ShowOkDlg(pc, "CHAR120_MSTEP5_NPC2_DLG1", 1)
            local item_Cnt = GetInvItemCount(pc, "CHAR120_HOSHINBOO_ITEM")
            if item_Cnt < 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_HOSHINBOO_ITEM", 1, "Quest_HIDDEN_BULLET")
                SCR_SET_HIDDEN_JOB_PROP(pc, "Char1_20", 260)
            end
        end
    else
        ShowOkDlg(pc, "CHAR120_MSTEP5_NPC2_DLG2", 1)
    end
end

function SCR_CHAR120_MSTEP5_TRACK_NPC1_DIALOG(self, pc)
    local sel = ShowSelDlg(pc, 0, "CHAR120_MSETP5_SEL1", ScpArgMsg("CHAR120_MSETP5_SELMSG1"), ScpArgMsg("CHAR120_MSETP5_SELMSG2"))
    if sel == 1 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_NPC_DLG5", 1)
    elseif sel == 2 then
            ShowOkDlg(pc, "CHAR120_MSTEP5_NPC_DLG8", 1)
        end
end

function SCR_CHAR120_MSTEP5_TRACK_NPC2_ENTER(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local sel = ShowSelDlg(pc, 0, "CHAR120_MSTEP5_NPC_DLG6", ScpArgMsg("CHAR120_MSTEP5_SEL3"), ScpArgMsg("CHAR120_MSTEP5_SEL4"))
    if sel == 1 then
        CHAR120_MSTEP5_TRACK_ITEM_RETURN(pc, sObj)
        ShowBalloonText(pc, "CHAR120_MSTEP5_NPC_DLG7", 3)
        UIOpenToPC(pc, 'fullblack', 1)
        sleep(1500)
        UIOpenToPC(pc, 'fullblack', 0)
        SetLayer(pc, 0)
    end
end

function CHAR120_MSTEP5_TRACK_ITEM_RETURN(pc, sObj)
	    if GetInvItemCount(pc, "CHAR120_MSTEP5_1_ITEM2") < 1 then
        if sObj.Step1 >= 2 and sObj.Step6 < 1 then
	            RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_1_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
	        end
	    elseif  GetInvItemCount(pc, "CHAR120_MSTEP5_3_ITEM2") < 1 then
        if sObj.Step3 >= 2 and sObj.Step8 < 1 then
	            RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_3_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
	        end
	    elseif  GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM1") < 1 then
        if sObj.Step4 >= 2 and sObj.Step9 < 1 then
	            RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_4_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
	        end
	    elseif  GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM5") < 1 then
        if sObj.Step5 >= 3 and sObj.Step10 < 1 then
	            RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM5", 1, "Quest_HIDDEN_NAKMUAY")
	        end
	    end
end

function CHAR120_MSTEP5_TRACK_FUNC(self)
    local mon = {}
    local obj = CREATE_NPC(self, 'Huevillage_Altar', 2114, 239, -381, -43, 'Neutral', GetLayer(self), "UnvisibleName", "CHAR120_OBJECT", nil, nil, 1, nil, nil, nil, nil, nil, nil, nil)
    local npc_Obj = CREATE_NPC(self, 'npc_wife_1', 2014, 238, -226, -43, 'Neutral', GetLayer(self), ScpArgMsg('HIDDEN_CHAR120_MSTEP5_FEMALE'), "CHAR120_FEMALE_OBJECT", nil, nil, 1, nil, nil, nil, nil, nil, nil, nil)
    
    AddScpObjectList(self, 'CHAR120_FEMALE_OBJ', npc_Obj)
    AddScpObjectList(self, 'CHAR120_ALTAR_PROP', obj)
    local graveStone_arr = {}
    local pos = { {2050, 238, -320},
                  {2098, 238, -272},
                  {2145, 238, -225}, 
                  {2004, 238, -373},
                  {1957, 238, -424}
                }
    
    local i
    for i = 1, 5 do
        local graveStone = CREATE_NPC_EX(self, 'npc_zachariel_head_02', pos[i][1], pos[i][2], pos[i][3], -43, 'Neutral', "UnvisibleName", 1, CHAR120_MSTEP5_CUBE_SET)
        AddScpObjectList(graveStone, 'CHAR120_ALTAR', obj)
        AddScpObjectList(obj, 'CHAR120_CUBE'..i, graveStone)
        SetOwner(graveStone, obj)
        graveStone.NumArg1 = 0
        graveStone_arr[i] = graveStone
    end
    
    local temp_mon
    local j
    for j = 1, #graveStone_arr-1 do
        local rnd = IMCRandom(j+1, #graveStone_arr)
        temp_mon = graveStone_arr[j]
        graveStone_arr[j] = graveStone_arr[rnd]
        graveStone_arr[rnd] = temp_mon 
    end
    
    local num = {1, 2, 3, 4, 5}
    local k
    for k = 1, #graveStone_arr do
        graveStone_arr[k].NumArg1 = num[k]
    end
    ShowBalloonText(self, "CHAR120_MSTEP5_NPC_DLG4", 3)
    
    Chat(npc_Obj, ScpArgMsg('HIDDEN_CHAR120_MSTEP5_FEMALE_CHAT'), 3)
end

function SCR_CHAR120_FEMALE_OBJECT_DIALOG(self, pc)
    local sel = ShowSelDlg(pc, 0, "CHAR120_MSTEP5_2_FEMALE_DLG1", ScpArgMsg("CHAR120_MSTEP5_2_FEMALE_SEL1"), ScpArgMsg("CHAR120_MSTEP5_2_FEMALE_SEL2"))
    if sel == 1 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_2_FEMALE_DLG2", 1)
    end
end

function CHAR120_FEMALE_AI_UPDATE(self)
    local x, y, z = GetPos(self)
    if self.NumArg2 < 1 then
        if self.NumArg1 < 1 then
            if SCR_POINT_DISTANCE(x, z, 2161, -387) > 10 then
                MoveEx(self, 2161, 238, -387, 1)
                self.NumArg1 = 1
                SetDirectionByAngle(self, -190)
            end
        end
--    elseif self.NumArg2 > 1 then
--        print(SCR_POINT_DISTANCE(x, z, 2185, -402))
--        if SCR_POINT_DISTANCE(x, z, 2185, -402) > 5 then
--            MoveEx(self, 2185, 238, -402, 1)
--        end
    end
end

function CHAR120_MSTEP5_CUBE_SET(mon)
    mon.Dialog = "NAKMUAY_MONUMENT"
    mon.Name = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_1")
end

function SCR_NAKMUAY_MONUMENT_DIALOG(self,pc)
    if SCR_4WAY_SIDE_CHECK(pc, self, 0) == 'BACK' then
        if self.NumArg1 == 1 then
            NAKMUAY_MONUMENT_BACK(pc, "CHAR120_MSTEP5_1_HINT1", "Step1")
        elseif self.NumArg1 == 2 then
            NAKMUAY_MONUMENT_BACK(pc, "CHAR120_MSTEP5_2_HINT1", "Step2")
        elseif self.NumArg1 == 3 then
            NAKMUAY_MONUMENT_BACK(pc, "CHAR120_MSTEP5_3_HINT1", "Step3")
        elseif self.NumArg1 == 4 then
            NAKMUAY_MONUMENT_BACK(pc, "CHAR120_MSTEP5_4_HINT1", "Step4")
        elseif self.NumArg1 == 5 then
            NAKMUAY_MONUMENT_BACK(pc, "CHAR120_MSTEP5_5_HINT1", "Step5")
            if GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM1") < 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
            end
        end
        return
    end
    local owner = GetOwner(self)
    --local taker = GetOwner(owner)
    local count = GetScpObjectList(self, 'CHAR120_GHOST_MONSTER')
    if #count < 1 then
        local x, y, z = GetPos(self)
        local result = DOTIMEACTION_R(pc,  ScpArgMsg('HIDDEN_CHAR120_MSTEP5_MONUMENT_CHK'), 'ABSORB', 0.5)
        local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
        if result == 1 then
            local mon_Altar = GetScpObjectList(self, 'CHAR120_ALTAR')
            PlayEffect(self, 'F_smoke046', 0.3)
            if self.NumArg1 == 1 then
                if sObj.Step6 < 1 then
                    for i = 1, #mon_Altar do
                        if mon_Altar[i].ClassName == "Huevillage_Altar" then
                            if mon_Altar[i].NumArg1 == self.NumArg1 then
                                --print("11111111111111111 NAKMUAY_GIMMICK_TRACK")
                                NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
                            else
                                --print("11111111111111111 Normal")
                    SCR_GHOST_CREATE_GEN(self, pc, "npc_village_uncle_7", "CHAR120_MSTEP5_1_ITEM2", "Step1", "Step6")
                end
                        end
                    end
                else
                    ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
                end
            elseif self. NumArg1 == 2 then
                if sObj.Step7 < 1 then
                    for i = 1, #mon_Altar do
                        if mon_Altar[i].ClassName == "Huevillage_Altar" then
                            if mon_Altar[i].NumArg1 == self.NumArg1 then
                                --print("22222222222222222 NAKMUAY_GIMMICK_TRACK")
                                NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
                            else
                                --print("22222222222222222 Normal")
                                SCR_GHOST_CREATE_GEN(self, pc, "npc_matron6", nil, "Step2", "Step7")
                            end
                        end
                    end
                else
                    ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
                end
            elseif self. NumArg1 == 3 then
                if sObj.Step8 < 1 then
                    for i = 1, #mon_Altar do
                        if mon_Altar[i].ClassName == "Huevillage_Altar" then
                            if mon_Altar[i].NumArg1 == self.NumArg1 then
                                --print("33333333333333333 NAKMUAY_GIMMICK_TRACK")
                                NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
                            else
                                --print("33333333333333333 Normal")
                                SCR_GHOST_CREATE_GEN(self, pc, "orsha_m_4", "CHAR120_MSTEP5_3_ITEM2", "Step3", "Step8")
                            end
                        end
                    end
                else
                    ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
                end
            elseif self. NumArg1 == 4 then
                if sObj.Step9 < 1 then
                    for i = 1, #mon_Altar do
                        if mon_Altar[i].ClassName == "Huevillage_Altar" then
                            if mon_Altar[i].NumArg1 == self.NumArg1 then
                                --print("44444444444444444 NAKMUAY_GIMMICK_TRACK")
                                NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
                            else
                                --print("44444444444444444 Normal")
                                SCR_GHOST_CREATE_GEN(self, pc, "npc_Agatas", "CHAR120_MSTEP5_4_ITEM1", "Step4", "Step9")
                            end
                        end
                    end
                else
                    ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
                end
            elseif self. NumArg1 == 5 then
                if sObj.Step10 < 1 then
                    for i = 1, #mon_Altar do
                        if mon_Altar[i].ClassName == "Huevillage_Altar" then
                            if mon_Altar[i].NumArg1 == self.NumArg1 then
                                --print("55555555555555555 NAKMUAY_GIMMICK_TRACK")
                                NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
                            else
                                --print("55555555555555555 Normal")
                                SCR_GHOST_CREATE_GEN(self, pc, "npc_young_rich", "CHAR120_MSTEP5_5_ITEM5", "Step5", "Step10")
                            end
                        end
                    end
                else
                    ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
                end
            end
        end
    end
end

function NAKMUAY_GIMMICK_TRACK(pc, self, sObj)
	local curzoneID = GetZoneInstID(pc);
    local obj_List, obj_Count = SelectObject(pc, 2000, "ALL", 1)
    
    local Obj = GetScpObjectList(pc, "CHAR120_FEMALE_OBJ");
    local female_Obj
    if #Obj >= 1 then
        for i = 1, #Obj do
            if Obj[i].ClassName == "npc_wife_1" then
                female_Obj = Obj[i]
            end
        end
    end
    
    local altar  = GetScpObjectList(pc, "CHAR120_ALTAR_PROP");
    local altar_Obj
    if #altar >= 1 then
        for i = 1, #altar do
            if altar[i].ClassName == "Huevillage_Altar" then
                altar_Obj = altar[i]
            end
        end
    end
    
    local graveStone01
    local graveStone02
    local graveStone03
    local graveStone04
    local graveStone05
    local ghost_obj1
    local ghost_obj2
    local ghost_obj3
    local ghost_obj4
    local ghost_obj5
    for i = 1 , obj_Count do
        if obj_List[i].ClassName == "npc_zachariel_head_02" then
            if obj_List[i].NumArg1 == 1 then
                graveStone01 = obj_List[i]
                local x, y, z = GetPos(graveStone01)
                ghost_obj1 = CREATE_NPC(pc, "npc_village_uncle_7", x, y, z, 0, "Neutral", GetLayer(pc), "UnvisibleName")
                SetOwner(ghost_obj1, self)
                ghost_obj1.Name = "UnvisibleName"
                PlayEffect(ghost_obj1, 'F_circle022_rotate', 1)
                ObjectColorBlend(ghost_obj1, 10, 255, 130, 200, 1, 0)
                FlyMath(ghost_obj1, 0, 0.5, 10)
                break
            elseif obj_List[i].NumArg1 == 2 then
                graveStone02 = obj_List[i]
                local x, y, z = GetPos(graveStone02)
                ghost_obj2 = CREATE_NPC(pc, "npc_matron6", x, y, z, 0, "Neutral", GetLayer(pc), "UnvisibleName")
                SetOwner(ghost_obj2, self)
                ghost_obj2.Name = "UnvisibleName"
                PlayEffect(ghost_obj2, 'F_circle022_rotate', 1)
                ObjectColorBlend(ghost_obj2, 10, 255, 130, 200, 1, 0)
                FlyMath(ghost_obj2, 0, 0.5, 10)
                break
            elseif obj_List[i].NumArg1 == 3 then
                graveStone03 = obj_List[i]
                local x, y, z = GetPos(graveStone03)
                ghost_obj3 = CREATE_NPC(pc, "orsha_m_4", x, y, z, 0, "Neutral", GetLayer(pc), "UnvisibleName")
                SetOwner(ghost_obj3, self)
                ghost_obj3.Name = "UnvisibleName"
                PlayEffect(ghost_obj3, 'F_circle022_rotate', 1)
                ObjectColorBlend(ghost_obj3, 10, 255, 130, 200, 1, 0)
                FlyMath(ghost_obj3, 0, 0.5, 10)
                break
            elseif obj_List[i].NumArg1 == 4 then
                graveStone04 = obj_List[i]
                local x, y, z = GetPos(graveStone04)
                ghost_obj4 = CREATE_NPC(pc, "npc_Agatas", x, y, z, 0, "Neutral", GetLayer(pc), "UnvisibleName")
                SetOwner(ghost_obj4, self)
                ghost_obj4.Name = "UnvisibleName"
                PlayEffect(ghost_obj4, 'F_circle022_rotate', 1)
                ObjectColorBlend(ghost_obj4, 10, 255, 130, 200, 1, 0)
                FlyMath(ghost_obj4, 0, 0.5, 10)
                break
            elseif obj_List[i].NumArg1 == 5 then
                graveStone05 = obj_List[i]
                local x, y, z = GetPos(graveStone05)
                ghost_obj5 = CREATE_NPC(pc, "npc_young_rich", x, y, z, 0, "Neutral", GetLayer(pc), "UnvisibleName")
                SetOwner(ghost_obj5, self)
                ghost_obj5.Name = "UnvisibleName"
                PlayEffect(ghost_obj5, 'F_circle022_rotate', 1)
                ObjectColorBlend(ghost_obj5, 10, 255, 130, 200, 1, 0)
                FlyMath(ghost_obj5, 0, 0.5, 10)
                break
            end
        end
    end
    if graveStone01 ~= nil then
        if graveStone01.NumArg1 == self.NumArg1 then
        	self.StrArg1 = "SUCCESS"
            sObj.Step6 = 1
            SaveSessionObject(pc, sObj)
            altar_Obj.StrArg1 = "None"
        	_TRACK(curzoneID, "PLAYER",
        	{
        		{"RUNSCRIPT", pc, "DIRECT_START"},
        
        		{"SLEEP", 300},
        		{"RUNSCRIPT", pc, "TargetCamera", graveStone01, 40, 0},
        		{"SLEEP", 700},
        		{"RUNSCRIPT", ghost_obj1, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_1_COMP")},
        		{"SLEEP", 1500},
        		{"RUNSCRIPT", ghost_obj1, "PlayEffect", "F_circle022_rotate", 1},
        		{"SLEEP", 500},        		
        		{"RUNSCRIPT", ghost_obj1, "Kill"},
        		{"SLEEP", 500},
        		{"RUNSCRIPT", pc, "CAMERA_RESET"},
        		{"SLEEP", 500},
        		{"RUNSCRIPT", pc, "DRT_FUNC_ACT", "NAKMUAY_FINAL_FUNC"},
        		{"SLEEP", 500},
        		
        		{"RUNSCRIPT", pc, "DIRECT_END_EDIT"},
        		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
        	}
            );
        end
    elseif graveStone02 ~= nil then
        if graveStone02.NumArg1 == self.NumArg1 then
        	self.StrArg1 = "SUCCESS"
            sObj.Step7 = 1
            SaveSessionObject(pc, sObj)
            altar_Obj.StrArg1 = "None"
        	_TRACK(curzoneID, "PLAYER",
        	{
            		{"RUNSCRIPT", pc, "DIRECT_START"},
            
            		{"SLEEP", 300},
            		{"RUNSCRIPT", pc, "TargetCamera", graveStone02, 40, 0},
            		{"SLEEP", 700},
            		{"RUNSCRIPT", ghost_obj2, "LookAt", female_Obj},
            		{"SLEEP", 300},
            		{"RUNSCRIPT", female_Obj, "LookAt", ghost_obj2},
            		{"SLEEP", 300},
            		{"RUNSCRIPT", ghost_obj2, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_2_COMP")},
            		{"SLEEP", 3000},            		
            		{"RUNSCRIPT", female_Obj, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_2_COMP2")},
            		{"SLEEP", 3000}, 
            		{"RUNSCRIPT", ghost_obj2, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_2_COMP3")},
            		{"SLEEP", 3000}, 
            		{"RUNSCRIPT", female_Obj, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_2_COMP4")},
            		{"SLEEP", 3000}, 
            		{"RUNSCRIPT", ghost_obj2, "PlayEffect", "F_circle022_rotate", 1},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", ghost_obj2, "Kill"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "CAMERA_RESET"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "DRT_FUNC_ACT", "NAKMUAY_FINAL_FUNC"},
            		{"SLEEP", 500},
            		
            		{"RUNSCRIPT", pc, "DIRECT_END_EDIT"},
            		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
        	}
        	);
	    end
    elseif graveStone03 ~= nil then
        if graveStone03.NumArg1 == self.NumArg1 then
        	self.StrArg1 = "SUCCESS"
            sObj.Step8 = 1
            SaveSessionObject(pc, sObj)
            altar_Obj.StrArg1 = "None"
        	_TRACK(curzoneID, "PLAYER",
        	{
            		{"RUNSCRIPT", pc, "DIRECT_START"},
            
            		{"SLEEP", 300},
            		{"RUNSCRIPT", pc, "TargetCamera", graveStone03, 40, 0},
            		{"SLEEP", 700},
            		{"RUNSCRIPT", ghost_obj3, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_3_COMP")},
            		{"SLEEP", 1500},
            		{"RUNSCRIPT", ghost_obj3, "PlayEffect", "F_circle022_rotate", 1},
            		{"SLEEP", 500},        		
            		{"RUNSCRIPT", ghost_obj3, "Kill"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "CAMERA_RESET"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "DRT_FUNC_ACT", "NAKMUAY_FINAL_FUNC"},
            		{"SLEEP", 500},
            		
            		{"RUNSCRIPT", pc, "DIRECT_END_EDIT"},
            		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
        	}
        	);
    	end
    elseif graveStone04 ~= nil then
        if graveStone04.NumArg1 == self.NumArg1 then
        	self.StrArg1 = "SUCCESS"
            sObj.Step9 = 1
            SaveSessionObject(pc, sObj)
            altar_Obj.StrArg1 = "None"
        	_TRACK(curzoneID, "PLAYER",
        	{
            		{"RUNSCRIPT", pc, "DIRECT_START"},
            
            		{"SLEEP", 300},
            		{"RUNSCRIPT", pc, "TargetCamera", graveStone04, 40, 0},
            		{"SLEEP", 700},
            		{"RUNSCRIPT", ghost_obj4, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_4_COMP")},
            		{"SLEEP", 1500},
            		{"RUNSCRIPT", ghost_obj4, "PlayEffect", "F_circle022_rotate", 1},
            		{"SLEEP", 500},        		
            		{"RUNSCRIPT", ghost_obj4, "Kill"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "CAMERA_RESET"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "DRT_FUNC_ACT", "NAKMUAY_FINAL_FUNC"},
            		{"SLEEP", 500},
            		
            		{"RUNSCRIPT", pc, "DIRECT_END_EDIT"},
            		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
        	}
        	);
    	end
    elseif graveStone05 ~= nil then
        if graveStone05.NumArg1 == self.NumArg1 then
        	self.StrArg1 = "SUCCESS"
            sObj.Step10 = 1
            SaveSessionObject(pc, sObj)
            altar_Obj.StrArg1 = "None"
        	_TRACK(curzoneID, "PLAYER",
        	{
            		{"RUNSCRIPT", pc, "DIRECT_START"},
            
            		{"SLEEP", 300},
            		{"RUNSCRIPT", pc, "TargetCamera", graveStone05, 40, 0},
            		{"SLEEP", 700},
            		{"RUNSCRIPT", ghost_obj5, "Chat", ScpArgMsg("HIDDEN_CHAR120_MSTEP5_5_COMP")},
            		{"SLEEP", 1500},
            		{"RUNSCRIPT", ghost_obj5, "PlayEffect", "F_circle022_rotate", 1},
            		{"SLEEP", 500},        	
            		{"RUNSCRIPT", ghost_obj5, "Kill"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "CAMERA_RESET"},
            		{"SLEEP", 500},
            		{"RUNSCRIPT", pc, "DRT_FUNC_ACT", "NAKMUAY_FINAL_FUNC"},
            		{"SLEEP", 500},
            		
            		{"RUNSCRIPT", pc, "DIRECT_END_EDIT"},
            		{"RUNSCRIPT", pc, "RestartSuspendedThread"},
        	}
        	);
    	end
    end
end

function NAKMUAY_FINAL_FUNC(pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if sObj ~= nil then
        if sObj.Step6 > 0 and sObj.Step7 > 0 and sObj.Step8 > 0 and sObj.Step9 > 0 and sObj.Step10 > 0 then 
            local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
            if hidden_Prop < 200 then
                for i = 1, 3 do
                    if isHideNPC(pc, "CHAR120_MSTEP6_1_NPC"..i) == "YES" then
                        UnHideNPC(pc, "CHAR120_MSTEP6_1_NPC"..i)
                    end
                end
                if isHideNPC(pc, "CHAR120_MSTEP5_NPC1") == "NO" then
                    HideNPC(pc, "CHAR120_MSTEP5_NPC1")
                    UnHideNPC(pc, "CHAR120_MSTEP5_NPC2")
                end
                SCR_SET_HIDDEN_JOB_PROP(pc, "Char1_20", 200)
                
                PlayAnim(pc, "WARP")
                PlayEffect(pc, "F_light081_ground_orange_loop")
                ShowBalloonText(pc, "NAKMUAY_GIMMICK1_DONE", 4)
                sleep(500)
                UIOpenToPC(pc, 'fullblack', 1)
                SetLayer(pc, 0)
                sleep(1500)
                UIOpenToPC(pc, 'fullblack', 0)
                PlayAnim(pc, "ASTD")
            end
        end
    end
end


function NAKMUAY_MONUMENT_BACK(pc, txt, step_value1)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if sObj ~= nil then
        ShowOkDlg(pc, txt, 1)
        if sObj[step_value1] < 1 then
            sObj[step_value1] = 1
        end
    end
end

function SCR_GHOST_CREATE_GEN(self, pc, obj_Class, item_Class, step_value1, step_value2)
    --step_value1 : progress check
    --step_value2 : success check
    self.StrArg1 = "None"
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if self.StrArg1 ~= "SUCCESS" then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, obj_Class, x, y, z, 0, 'Neutral', 1, CHAR120_GHOST_SET)
        local mon_Altar = GetScpObjectList(self, 'CHAR120_ALTAR')
        PlayAnim(mon, "soul_std")
        SetOwner(mon, self)
        DisableBornAni(mon)
        PlayEffect(mon, 'F_circle022_rotate', 1)
        ObjectColorBlend(mon, 10, 255, 130, 200, 1, 0)
        if sObj[step_value1] < 1 then
            sObj[step_value1] = 1
            --print(sObj[step_value1])
            SaveSessionObject(pc, sObj)
        end
        FlyMath(mon, 0, 0.5, 10)
        if #mon_Altar >= 1 then
            for i = 1, #mon_Altar do
                if mon_Altar[i].ClassName == "Huevillage_Altar" then
                    if mon_Altar[i].NumArg1 ~= self.NumArg1 then
                        PlayAnim(mon, "soul_scare")
                        PlayEffect(self, 'F_smoke046', 0.3)
                        --print("mon_Altar[i].NumArg1 : "..mon_Altar[i].NumArg1, "self.StrArg1 : "..self.StrArg1)
                        if mon_Altar[i].StrArg1 ~= nil and mon_Altar[i].StrArg1 ~= "None" and mon_Altar[i].StrArg1 ~= "CHAR120_FEMALE_AI" then
                            local item = GetInvItemCount(pc, mon_Altar[i].StrArg1)
                            if item < 1 then
                                RunScript("GIVE_ITEM_TX", pc, mon_Altar[i].StrArg1, 1, "Quest_HIDDEN_NAKMUAY")
                            end
                        end
                        mon_Altar[i].NumArg1 = 0
                        local Obj = GetScpObjectList(pc, "CHAR120_FEMALE_OBJ");
                        local female_Obj
                        if #Obj >= 1 then
                            for i = 1, #Obj do
                                if Obj[i].ClassName == "npc_wife_1" then
                                    female_Obj = Obj[i]
                                end
                            end
                        end
                        if sObj.Step7 < 1 then
                            female_Obj.NumArg1 = 0
                        end
                        mon_Altar[i].StrArg1 = "None"
                    end
                end
            end
        end
    elseif self.StrArg1 == "SUCCESS" then
        ShowBalloonText(pc, "CHAR120_MSTEP5_GRAVESTONE_COMP", 1)
    end
end

function CHAR120_GHOST_SET(mon)
	mon.BTree = "BT_DUMMY"
    mon.Tactics = "None"
    mon.Name = "UnvisibleName"
    mon.SimpleAI = "CHAR120_GHOST_AI"
end

--function NAKMUAY_FINAL_FUNC(pc)
--
--end


--CHAR120_GHOST_AI
function CHAR120_GHOST_AI_UPDATE(self)
    self.NumArg1 = self.NumArg1 + 1
    local mon_count = self.NumArg1
    local owner_obj = GetOwner(self)
    if owner_obj.ClassName == "npc_zachariel_head_02" then
        if self.NumArg2 < 1 then
            if owner_obj.StrArg1 ~= "SUCCESS" then
                if self.ClassName == "npc_village_uncle_7" then
                    Chat(self, ScpArgMsg("HIDDEN_CHAR120_MSTEP5_FAIL1"), 5)
                elseif self.ClassName == "npc_matron6" then
                    Chat(self, ScpArgMsg("HIDDEN_CHAR120_MSTEP5_FAIL2"), 5)
                elseif self.ClassName == "orsha_m_4" then
                    Chat(self, ScpArgMsg("HIDDEN_CHAR120_MSTEP5_FAIL3"), 5)
                elseif self.ClassName == "npc_Agatas" then
                    Chat(self, ScpArgMsg("HIDDEN_CHAR120_MSTEP5_FAIL4"), 5)
                elseif self.ClassName == "npc_young_rich" then
                    Chat(self, ScpArgMsg("HIDDEN_CHAR120_MSTEP5_FAIL5"), 5)
                end
                PlayAnim(self, "soul_scare", 1)
            end
            self.NumArg2 = 1 
        end
    end
    if mon_count >= 9 then
        if owner_obj.StrArg1 == "SUCCESS" then
            PlayEffect(self, "F_buff_basic025_white_line_2", 1)
        else
            PlayEffect(self, "F_buff_basic025_white_line_2", 1)
        end
        Kill(self)
    end
end

function SCR_CHAR120_OBJECT_DIALOG(self, pc)
    local mStep1 = GetInvItemCount(pc, "CHAR120_MSTEP5_1_ITEM2")
    local mStep3 = GetInvItemCount(pc, "CHAR120_MSTEP5_3_ITEM2")
    local mStep4 = GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM1")
    local mStep5 = GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM5")
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local dlg1, dlg2, dlg3, dlg4, dlg5 = nil
    local female_Obj = GetScpObjectList(pc, "CHAR120_FEMALE_OBJ")
    local female_Npc
    
    --Hidden job step5_1 select button text
    if mStep1 > 0 then
        dlg1 = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_SEL1")
    end
    
    --Hidden job step5_2 select button text
    if isHideNPC(pc, "CHAR120_FEMALE_OBJECT") == "NO" then
        if sObj.Step7 < 1 then
        if #female_Obj >= 1 then
            for z = 1, #female_Obj do
                female_Npc = female_Obj[z]
                    --print(female_Obj[z].NumArg1) 
                if female_Obj[z].NumArg1 < 1 then
                        --print(female_Obj[z].NumArg1, female_Obj[z].ClassName)
                    dlg2 = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_SEL2")
                end
            end
        end
    end
    end
    
    --Hidden job step5_3 select button text
    if mStep3 > 0 then 
        dlg3 = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_SEL3")
    end
    
    --Hidden job step5_4 select button text
    if mStep4 > 0 then 
        dlg4 = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_SEL4")
    end
    
    --Hidden job step5_5 select button text
    if mStep5 > 0 then
        dlg5 = ScpArgMsg("HIDDEN_CHAR120_MSTEP5_SEL5")
    end
    
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    
    if dlg1 == nil and dlg2 == nil and dlg3 == nil and dlg4 == nil and dlg5 == nil then
        ShowOkDlg(pc, 'CHAR120_MSTEP5_TXT', 1)
    else
        local pos_x, pos_y, pos_z = GetPos(self)
        local sel = ShowSelDlg(pc, 1, 'CHAR120_MSTEP5_TXT', dlg1, dlg2, dlg3, dlg4, dlg5)
        
        if sel == 1 then --Hidden job step5_1 select func
            RunScript("TAKE_ITEM_TX", pc, "CHAR120_MSTEP5_1_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
            if self.NumArg1 ~= 1 then
                NAKMUAY_ITEM_RETURN(pc, self, "CHAR120_MSTEP5_1_ITEM2", nil)
            end
            self.NumArg1 = 1
            self.StrArg1 = "CHAR120_MSTEP5_1_ITEM2"
            ShowBalloonText(pc, "CHAR120_MSTEP5_1_ITEM_SET", 1)
        elseif sel == 2 then --Hidden job step5_2 select func
            self.NumArg1 = 2
            if #female_Obj >= 1 then
                for i = 1, #female_Obj do
                    if female_Obj[i].ClassName == "npc_wife_1" then
                        RunSimpleAIOnly(female_Obj[i], "CHAR120_FEMALE_AI")
                        if self.NumArg1 ~= 1 then
                            NAKMUAY_ITEM_RETURN(pc, self, nil, nil)
                        end
                        self.StrArg1 = "CHAR120_FEMALE_AI"
                        ShowBalloonText(pc, "CHAR120_MSTEP5_2_ITEM_SET", 1)
                        break
                    end
                end
            end
        elseif sel == 3 then --Hidden job step5_3 select func
            self.NumArg1 = 3
            NAKMUAY_ITEM_RETURN(pc, self,"CHAR120_MSTEP5_3_ITEM2", female_Npc)
            RunScript("TAKE_ITEM_TX", pc, "CHAR120_MSTEP5_3_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
            self.StrArg1 = "CHAR120_MSTEP5_3_ITEM2"
            ShowBalloonText(pc, "CHAR120_MSTEP5_3_ITEM_SET", 1)
        elseif sel == 4 then --Hidden job step5_4 select func
            self.NumArg1 = 4
            NAKMUAY_ITEM_RETURN(pc, self,"CHAR120_MSTEP5_4_ITEM1", female_Npc)
            RunScript("TAKE_ITEM_TX", pc, "CHAR120_MSTEP5_4_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
            self.StrArg1 = "CHAR120_MSTEP5_4_ITEM1"
            ShowBalloonText(pc, "CHAR120_MSTEP5_4_ITEM_SET", 1)
        elseif sel == 5 then --Hidden job step5_5 select func
            self.NumArg1 = 5
            NAKMUAY_ITEM_RETURN(pc, self,"CHAR120_MSTEP5_5_ITEM5", female_Npc)
            RunScript("TAKE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM5", 1, "Quest_HIDDEN_NAKMUAY")
            self.StrArg1 = "CHAR120_MSTEP5_5_ITEM5"
            ShowBalloonText(pc, "CHAR120_MSTEP5_5_ITEM_SET", 1)
        end
    end
end

function NAKMUAY_ITEM_RETURN(pc, self, item, obj)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local graveStone1
    local graveStone2
    local graveStone3
    local graveStone4
    local graveStone5
    
    local graveStone_obj1 = GetScpObjectList(self, 'CHAR120_CUBE1')
    if #graveStone_obj1 > 0 then
        for j = 1, #graveStone_obj1 do
            graveStone1 = graveStone_obj1[j]
        end
    end
    
    local graveStone_obj2 = GetScpObjectList(self, 'CHAR120_CUBE2')
    if #graveStone_obj2 > 0 then
        for j = 1, #graveStone_obj2 do
            graveStone2 = graveStone_obj2[j]
        end
    end
    
    local graveStone_obj3 = GetScpObjectList(self, 'CHAR120_CUBE3')
    if #graveStone_obj3 > 0 then
        for j = 1, #graveStone_obj3 do
            graveStone3 = graveStone_obj3[j]
        end
    end
    
    local graveStone_obj4 = GetScpObjectList(self, 'CHAR120_CUBE4')
    if #graveStone_obj4 > 0 then
        for j = 1, #graveStone_obj4 do
            graveStone4 = graveStone_obj4[j]
        end
    end
    
    local graveStone_obj5 = GetScpObjectList(self, 'CHAR120_CUBE5')
    if #graveStone_obj5 > 0 then
        for j = 1, #graveStone_obj5 do
            graveStone5 = graveStone_obj5[j]
        end
    end
    if item ~= "CHAR120_MSTEP5_1_ITEM2" then
            if GetInvItemCount(pc, "CHAR120_MSTEP5_1_ITEM2") < 1 then
            if graveStone1.StrArg1 ~= "SUCCESS" then
                if sObj.Step1 >= 2 and sObj.Step6 < 1 then
                    RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_1_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
                end
            end
        end
    end
    if obj ~= nil then
        if graveStone2.StrArg1 ~= "SUCCESS" then
        if sObj.Step2 >= 4 and sObj.Step7 < 1 then
            if obj.NumArg1 >= 1 then
                obj.NumArg1 = 0
            end
        end
    end
    end
    if item ~= "CHAR120_MSTEP5_3_ITEM2" then
            if GetInvItemCount(pc, "CHAR120_MSTEP5_3_ITEM2") < 1 then
            if graveStone3.StrArg1 ~= "SUCCESS" then
                if sObj.Step3 >= 2 and sObj.Step8 < 1 then
                    RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_3_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
                end
            end
        end
    end
    if item ~= "CHAR120_MSTEP5_4_ITEM1" then
            if GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM1") < 1 then
            if graveStone4.StrArg1 ~= "SUCCESS" then
                if sObj.Step4 >= 2 and sObj.Step9 < 1 then
                    RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_4_ITEM1", 1, "Quest_HIDDEN_NAKMUAY")
                end
            end
            end
    end
    if item ~= "CHAR120_MSTEP5_5_ITEM5" then
        if GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM5") < 1 then
            if graveStone5.StrArg1 ~= "SUCCESS" then
            if sObj.Step5 >= 3 and sObj.Step10 < 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM5", 1, "Quest_HIDDEN_NAKMUAY")
            end
        end
    end
    end
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _last_gen = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
    local _next_time = 10
    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
--    print('AAA', _last_gen, _next_time)
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_BORN_UPDATE(self)
    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    if argstr1 ~= nil and argstr1 ~= 'None' and argstr2 ~= nil and argstr2 ~= 'None' then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        
        local _today = tonumber(year..month..day);
        local _time = tonumber(hour * 60) + tonumber(min);
        
        local string_cut_list = SCR_STRING_CUT(argstr1);
        local _next_time = tonumber(argstr2);
        if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
            local _last_day = tonumber(string_cut_list[1]);
            local _last_time = tonumber(string_cut_list[2]);
            
            if _last_day ~= _today then
                _last_time = _last_time - 1440;
            end
            --print('BBB', _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
            if _time == _last_time + _next_time then
                local _flower = GetScpObjectList(self, 'CHAR120_MSTEP5_4_FLOWER')
                if #_flower == 0 then
                    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
                    local mon1 = CREATE_MONSTER_EX(self, 'farm47_dandelion_01', 218 ,531, 528, 0, 'Neutral', nil, HIDDEN_CHAR120_MSETP5_4_OBJ1_SET);
                    --print("111111111111")
                    SetNoDamage(mon1, 1)
                    AddScpObjectList(self, 'CHAR120_MSTEP5_4_FLOWER', mon1)
                    AddScpObjectList(mon1, 'CHAR120_MSTEP5_4_FLOWER_CONTROLL', self)
                end
            end
        end
    end
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_BORN_LEAVE(self)
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_DEAD_ENTER(self)
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_DEAD_UPDATE(self)
end

function SCR_CHAR120_MSTEP5_4_FLOWER_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR120_MSETP5_4_OBJ1_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Dialog = "CHAR120_MSTEP5_4_FLOWER"
	self.Name = "UnvisibleName"
	self.KDArmor = 999
end

function SCR_CHAR120_MSTEP5_4_FLOWER_DIALOG(self, pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_Prop == 100 then
        local item = GetInvItemCount(pc, "CHAR120_MSTEP5_4_ITEM2")
        if item < 48 then
            local result = DOTIMEACTION_R(pc,  ScpArgMsg('CHAR120_MSTEP5_4_ITEM3_GET'), 'sitgrope', 0.5)
            if result == 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_4_ITEM2", 1, "Quest_HIDDEN_NAKMUAY")
                local now_time = os.date('*t')
                local year = now_time['year']
                local month = now_time['month']
                local day = now_time['day']
                local hour = now_time['hour']
                local min = now_time['min']
                
                local _today = tonumber(year..month..day);
                local _time = tonumber(hour * 60) + tonumber(min);
                
                local _last_gen = tostring(_today).."/"..tostring(_time);
                _next_time = 10
                local _controll = GetScpObjectList(self, 'CHAR120_MSTEP5_4_FLOWER_CONTROLL')
                if #_controll >= 1 then
                    for i = 1, #_controll do
                        SetTacticsArgStringID(_controll[i], tostring(_last_gen), tostring(_next_time))
                        --print("222222222")
                        break
                    end
                end
                Kill(self)
            end
        end
    end
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _last_gen = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
    local _next_time = IMCRandom(10, 20)
    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
--    print('AAA', _last_gen, _next_time)
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_BORN_UPDATE(self)
    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    if argstr1 ~= nil and argstr1 ~= 'None' and argstr2 ~= nil and argstr2 ~= 'None' then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        
        
        local _today = tonumber(year..month..day);
        local _time = tonumber(hour * 60) + tonumber(min);
        
        local string_cut_list = SCR_STRING_CUT(argstr1);
        local _next_time = tonumber(argstr2);
        if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
            local _last_day = tonumber(string_cut_list[1]);
            local _last_time = tonumber(string_cut_list[2]);
            
            if _last_day ~= _today then
                _last_time = _last_time - 1440;
            end
            --print(GetZoneName(self), _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
            if _time == _last_time + _next_time then
                local _flower = GetScpObjectList(self, 'CHAR120_MSTEP5_5_FLOWER')
                if #_flower == 0 then
                    --print("1111111111111111")
                    local _last_gen = tostring(_today).."/"..tostring(_time);
                    _next_time = 20
                    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
                    local pos = { {111, 1196, -2467},
                                  {360, 1196, -2080},
                                  {608, 1242, -250}, 
                                  {-154, 1294, -1443},
                                  {-119, 1196, -3183}}
                    for i = 1,5 do
                        local mon1 = CREATE_MONSTER_EX(self, 'siauliai_grass_1', pos[i][1], pos[i][2], pos[i][3], 0, 'Neutral', nil, HIDDEN_CHAR120_MSETP5_5_OBJ1_SET);
                        SetNoDamage(mon1, 1)
                        AddScpObjectList(self, 'CHAR120_MSTEP5_5_FLOWER', mon1)
                        EnableAIOutOfPC(mon1)
                        SetLifeTime(mon1, 600);
                    end
                    --print(GetZoneName(self),"2222222222222")
                end
            end
        end
    end
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_BORN_LEAVE(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_DEAD_ENTER(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_DEAD_UPDATE(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR120_MSETP5_5_OBJ1_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Dialog = "CHAR120_MSTEP5_5_FLOWER"
	self.Name = ScpArgMsg("CHAR120_MSTEP5_5_FLOWER_NAME")
	self.KDArmor = 999
	self.MaxDialog = 1
end

function SCR_CHAR120_MSTEP5_5_FLOWER_DIALOG(self, pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_Prop == 100 then
        local item = GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM3")
        if item < 60 then
            local result = DOTIMEACTION_R(pc,  ScpArgMsg('CHAR120_MSTEP5_5_FLOWER_GET'), 'sitgrope', 1.5)
            if result == 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM3", 1, "Quest_HIDDEN_NAKMUAY")
                PlayEffect(pc, "F_pc_making_finish_white", 2, 0, "BOT")
                Kill(self)
            end
        else
            ShowBalloonText(pc, "CHAR120_MSTEP5_5_ITEM3_MSG", 1)
        end
    end
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_BORN_ENTER(self)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    
    local _last_gen = tostring(year..month..day).."/"..tostring(hour * 60) + tostring(min)
    local _next_time = IMCRandom(10, 20)
    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
--    print('AAA', _last_gen, _next_time)
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_BORN_UPDATE(self)
    local argstr1, argstr2, argstr3 = GetTacticsArgStringID(self)
    if argstr1 ~= nil and argstr1 ~= 'None' and argstr2 ~= nil and argstr2 ~= 'None' then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        
        
        local _today = tonumber(year..month..day);
        local _time = tonumber(hour * 60) + tonumber(min);
        
        local string_cut_list = SCR_STRING_CUT(argstr1);
        local _next_time = tonumber(argstr2);
        if string_cut_list[1] ~= nil and string_cut_list[2] ~= nil then
            local _last_day = tonumber(string_cut_list[1]);
            local _last_time = tonumber(string_cut_list[2]);
            
            if _last_day ~= _today then
                _last_time = _last_time - 1440;
            end
            --print(GetZoneName(self), _time.." ".._last_time + _next_time, _last_time.." ".._next_time)
            if _time == _last_time + _next_time then
                local _flower = GetScpObjectList(self, 'CHAR120_MSTEP5_5_FLOWER2')
                if #_flower == 0 then
                    local _last_gen = tostring(_today).."/"..tostring(_time);
                    _next_time = 20
                    SetTacticsArgStringID(self, tostring(_last_gen), tostring(_next_time))
                    local pos = { {567, 172, -1148},
                                  {-375, 222, -397},
                                  {672, 226, -129}, 
                                  {-69, 226, 845},
                                  {945, 226, 1176}, 
                                  {1197, 163, -332},
                                  {1172, 163, -166},
                                  {394, 236, -627} }
                    for i = 1,8 do
                        local mon1 = CREATE_MONSTER_EX(self, 'siauliai_grass_2', pos[i][1], pos[i][2], pos[i][3], 0, 'Neutral', nil, HIDDEN_CHAR120_MSETP5_5_OBJ2_SET);
                        SetNoDamage(mon1, 1)
                        AddScpObjectList(self, 'CHAR120_MSTEP5_5_FLOWER2', mon1)
                        EnableAIOutOfPC(mon1)
                        SetLifeTime(mon1, 600);
                    end
                    --print(GetZoneName(self), "11111111111")
                end
            end
        end
    end
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_BORN_LEAVE(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_DEAD_ENTER(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_DEAD_UPDATE(self)
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_TS_DEAD_LEAVE(self)
end

function HIDDEN_CHAR120_MSETP5_5_OBJ2_SET(self)
	self.BTree = "BasicMonster";
    self.Tactics = "None";
	self.Dialog = "CHAR120_MSTEP5_5_FLOWER2"
	self.Name = ScpArgMsg("CHAR120_MSTEP5_5_FLOWER2_NAME")
	self.KDArmor = 999
	self.MaxDialog = 1
end

function SCR_CHAR120_MSTEP5_5_FLOWER2_DIALOG(self, pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_Prop == 100 then
        local item = GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM4")
        if item < 84 then
            local result = DOTIMEACTION_R(pc,  ScpArgMsg('CHAR120_MSTEP5_5_FLOWER2_GET'), 'sitgrope', 1.5)
            if result == 1 then
                RunScript("GIVE_ITEM_TX", pc, "CHAR120_MSTEP5_5_ITEM4", 1, "Quest_HIDDEN_NAKMUAY")
                PlayEffect(self, "F_pc_making_finish_white", 2, 0, "BOT")
                Kill(self)
            end
        else
            ShowBalloonText(pc, "CHAR120_MSTEP5_5_ITEM4_MSG", 1)
        end
    end
end

function SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if hidden_Prop == 100 then
        if sObj~= nil then
            if sObj.Step2 >= 1 then
                return 'YES'
            end
        end
    end
    return 'NO'
end

function SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, num, txt1, txt2)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if sObj ~= nil then
        if sObj["Step"..num] == 1 then
            ShowOkDlg(pc, txt1, 1)
            --print("find")
            if isHideNPC(pc, "CHAR120_MSTEP5_2_NPC2") == "YES" then
                UnHideNPC(pc, "CHAR120_MSTEP5_2_NPC2")
            end
            sObj.Step2 = 2
        else
            ShowOkDlg(pc, txt2, 1)
        end
    end
end

function SCR_CHAR120_MSTEP5_2_NPC1_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if sObj ~= nil then
        if hidden_Prop == 100 then
            if sObj.Step2 == 3 then
                sObj.Step2 = 4
                SaveSessionObject(pc, sObj)
            end
            ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC1_DLG1", 1)
        end
    else
        COMMON_QUEST_HANDLER(self, pc)
    end
end

function SCR_CHAR120_MSTEP5_2_NPC2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CHAR120_MSTEP5_2_NPC2_NORMAL_1(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if sObj ~= nil then
        if isHideNPC(pc, "CHAR120_MSTEP5_2_NPC1") == "YES" then
            if sObj.Step2 < 3 then
                local sel = ShowSelDlg(pc, 0, "CHAR120_MSTEP5_2_NPC2_DLG1", ScpArgMsg("CHAR120_MSTEP5_2_NPC2_MSG1"), ScpArgMsg("CHAR120_MSTEP5_2_NPC2_MSG2"))
                if sel == 1 then
                    ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC2_DLG2", 1)
                    if sObj.Step2 < 3 then
                        sObj.Step2 = 3
                    end
                end
                SaveSessionObject(pc, sObj)
            else
                ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC2_DLG3", 1)
            end
        elseif isHideNPC(pc, "CHAR120_MSTEP5_2_NPC1") == "NO" then
            ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC2_DLG4", 1)
        end
    end
end

function SCR_CHAR120_MSTEP5_2_NPC2_NORMAL_1_PRE(self)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if sObj ~= nil then
        if hidden_Prop == 100 then
            if sObj.Step2 <= 3 and sObj.Step2 >= 2 then
                return "YES"
            end
        end
    end
    return "NO"
end

function SCR_CHAR120_MSTEP5_2_NPC3_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_Prop == 100 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC3_DLG1", 1)
    elseif hidden_Prop > 100 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_2_NPC3_DLG2", 1)
    end
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_1(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local sel = ShowSelDlg(pc, 0, "CHAR120_MSTEP5_5_NPC1_SELLIST", ScpArgMsg("CHAR120_MSTEP5_5_LST1"), ScpArgMsg("CHAR120_MSTEP5_5_LST2"))
    if sel == 1 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_5_NPC1_DLG1", 1)
        ShowBalloonText(pc, "CHAR120_MSTEP5_5_ITEM1_LETTER_AFTER", 4)
        UIOpenToPC(pc, 'fullblack', 1)
        sleep(1500)
        UIOpenToPC(pc, 'fullblack', 0)
        ShowOkDlg(pc, "CHAR120_MSTEP5_5_NPC1_DLG2", 1)
        sObj.Step5 = 2
        SaveSessionObject(pc, sObj)
    end
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_1_PRE(self)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if sObj ~= nil then
        if hidden_Prop == 100 then
            if sObj.Step5 == 1 then
                return "YES"
            end
        end
    end
    return "NO"
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_2(self, pc)
    ShowOkDlg(pc, "CHAR120_MSTEP5_5_NPC1_DLG3", 1)
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_2_PRE(self)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if GetInvItemCount(self, "CHAR120_MSTEP5_5_ITEM3") < 60 or GetInvItemCount(self, "CHAR120_MSTEP5_5_ITEM4") < 84 then
        if sObj ~= nil then
            --print(hidden_Prop, sObj.Step5)
            if hidden_Prop == 100 then
                if sObj.Step5 == 2 then
                    return "YES"
                end
            end
        end
    end
    return "NO"
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_3(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    if GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM3") >= 60 and GetInvItemCount(pc, "CHAR120_MSTEP5_5_ITEM4") >= 84 then
        ShowOkDlg(pc, "CHAR120_MSTEP5_5_NPC1_DLG4", 1)
        UIOpenToPC(pc, 'fullblack', 1)
        sleep(1500)
        UIOpenToPC(pc, 'fullblack', 0)
        ShowOkDlg(pc, 'CHAR120_MSTEP5_5_NPC1_DLG5',1)
        local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
        local tx1 = TxBegin(pc);
        local nakmuay_item = {
                                'CHAR120_MSTEP5_5_ITEM3',
                                'CHAR120_MSTEP5_5_ITEM4'
                            }
        for i = 1, #nakmuay_item do
            if GetInvItemCount(pc, nakmuay_item[i]) > 0 then
                local invItem, cnt = GetInvItemByName(pc, nakmuay_item[i])
				if IsFixedItem(invItem) == 1 then
					isLockState = 1
				end
                TxTakeItem(tx1, nakmuay_item[i], GetInvItemCount(pc, nakmuay_item[i]), 'Quest_HIDDEN_NAKMUAY');
            end
        end
        TxGiveItem(tx1, "CHAR120_MSTEP5_5_ITEM5", 1, 'Quest_HIDDEN_NAKMUAY');
        local ret = TxCommit(tx1);
        sObj.Step5 = 3
        SaveSessionObject(pc, sObj)
        if isHideNPC(pc, "CHAR120_MSTEP5_5_FLOWER") == "NO" then
            HideNPC(pc, "CHAR120_MSTEP5_5_FLOWER")
        end
        if isHideNPC(pc, "CHAR120_MSTEP5_5_FLOWER2") == "NO" then
            HideNPC(pc, "CHAR120_MSTEP5_5_FLOWER2")
        end
        if ret == "SUCCESS" then
            print("tx Success")
        else
			if isLockState == 1 then
				SendSysMsg(pc, 'QuestItemIsLocked');
			end
            print("tx FAIL!")
        end
    else
        ShowOkDlg(pc, "CHAR120_MSTEP5_5_NPC1_DLG4", 1)
    end
end

function SCR_CHAR120_MSTEP5_5_NPC1_NORMAL_3_PRE(self)
    local sObj = GetSessionObject(self, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if GetInvItemCount(self, "CHAR120_MSTEP5_5_ITEM3") >= 60 and GetInvItemCount(self, "CHAR120_MSTEP5_5_ITEM4") >= 84 then
        if sObj ~= nil then
            if hidden_Prop == 100 then
                if sObj.Step5 == 2 then
                    return "YES"
                end
            end
        end
    end
    return "NO"
end

function SCR_CHAR120_MSTEP5_5_NPC1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CHAR120_MSTEP6_1_NPC1_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if sObj ~= nil then
        if hidden_Prop == 200 then
            SCR_SET_HIDDEN_JOB_PROP(pc, "Char1_20", 250)
            ShowOkDlg(pc, "CHAR120_MSTEP6_1_NPC1_DLG1", 1)
            HideNPC(pc, "CHAR120_MSTEP6_1_NPC1")
            HideNPC(pc, "CHAR120_MSTEP6_1_NPC2")
            HideNPC(pc, "CHAR120_MSTEP6_1_NPC3")
            if isHideNPC(pc, "CHAR120_MASTER") == "YES" then
                UnHideNPC(pc, "CHAR120_MASTER")
            end
            PlayEffectToGround(pc, "F_buff_basic025_white_line", 1954.3163, 238.9895, -233.17386, 1.2)
            PlayEffectToGround(pc, "F_buff_basic025_white_line", 1933.2786, 238.9895, -244.75281, 1.2)
            PlayEffectToGround(pc, "F_buff_basic025_white_line", 1943.9382, 238.9895, -208.25696, 1.2)
        end
    end
end

function SCR_CHAR120_MSTEP6_1_NPC2_DIALOG(self, pc)
    ShowOkDlg(pc, "CHAR120_MSTEP6_1_NPC1_DLG2", 1)
end

function SCR_CHAR120_MSTEP6_1_NPC3_DIALOG(self, pc)
    ShowOkDlg(pc, "CHAR120_MSTEP6_1_NPC1_DLG3", 1)
end

--TEST FUNCTION
function BULLETMARKER_EFFECT_TEST(self)
     AttachEffect(self, "I_circle001", 11, 1, "BOT",1)
     PlayEffectLocal(self, self, "I_rize010_orange", 2, 1, "TOP", 1)
end
