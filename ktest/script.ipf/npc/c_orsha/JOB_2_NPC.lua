function SCR_JOB_2_SWORDMAN_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_PELTASTA_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_HOPLITE_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_CLERIC_NPC_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST2')
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_2_PRIEST2')
        if quest_ssn.QuestInfoValue1 < quest_ssn.QuestInfoMaxCount1 then
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_5', 1)
            PlayEffect(pc, 'F_light080_blue', 0.5, 0, 'MID')
            quest_ssn.QuestInfoValue1 = quest_ssn.QuestInfoValue1 + 1
        else
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_8', 1)
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_KRIVIS_NPC_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST2')
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_2_PRIEST2')
        if quest_ssn.QuestInfoValue2 < quest_ssn.QuestInfoMaxCount2 then
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_6', 1)
            PlayEffect(pc, 'F_light080_blue', 0.5, 0, 'MID')
            quest_ssn.QuestInfoValue2 = quest_ssn.QuestInfoValue2 + 1
        else
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_9', 1)
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_PRIEST_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_BOKOR_NPC_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc, 'JOB_2_PRIEST2')
    if result == "PROGRESS" then
        local quest_ssn = GetSessionObject(pc, 'SSN_JOB_2_PRIEST2')
        if quest_ssn.QuestInfoValue3 < quest_ssn.QuestInfoMaxCount3 then
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_7', 1)
            PlayEffect(pc, 'F_light080_blue', 0.5, 0, 'MID')
            quest_ssn.QuestInfoValue3 = quest_ssn.QuestInfoValue3 + 1
        else
            ShowOkDlg(pc, 'JOB_2_PRIEST2_1_10', 1)
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_RODELERO_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_CATAPHRACT_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_SADHU_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_PALADIN_NPC_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_KRIVIS_FIRE_ENTER(self,pc)
end

function SCR_JOB_2_PELTASTA2_ABANDON(self, tx)
    if isHideNPC(self, 'JOB_2_PELTASTA2_WOOD') == 'NO' then
        HideNPC(self, 'JOB_2_PELTASTA2_WOOD')
    end
end

function SCR_JOB_2_CLERIC3_ABANDON(self, tx)
    if isHideNPC(self, 'JOB_2_CLERIC3_PATIENT') == 'NO' then
        HideNPC(self, 'JOB_2_CLERIC3_PATIENT')
    end
end

function SCR_JOB_2_PRIEST3_ABANDON(self, tx)
    if isHideNPC(self, 'JOB_2_PRIEST3_HERB1') == 'NO' then
        HideNPC(self, 'JOB_2_PRIEST3_HERB1')
    end
    if isHideNPC(self, 'JOB_2_PRIEST3_HERB2') == 'NO' then
        HideNPC(self, 'JOB_2_PRIEST3_HERB2')
    end
    if isHideNPC(self, 'JOB_2_PRIEST3_HERB3') == 'NO' then
        HideNPC(self, 'JOB_2_PRIEST3_HERB3')
    end
end

function SCR_JOB_2_HOPLITE5_ABANDON(self, tx)
    if isHideNPC(self, 'JOB_2_HOPLITE_ARMOR') == 'NO' then
        HideNPC(self, 'JOB_2_HOPLITE_ARMOR')
    end
end

--JOB_2_OPEN_ABILSHOP
function SCR_JOB_2_SWORDMAN_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Warrior")
end

function SCR_JOB_2_PELTASTA_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Peltasta")
end

function SCR_JOB_2_HIGHLANDER_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Highlander")
end

function SCR_JOB_2_HOPLITE_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Hoplite")
end

function SCR_JOB_2_BARBARIAN_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Barbarian")
end

function SCR_JOB_2_RODELERO_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Rodelero")
end

function SCR_JOB_2_CATAPHRACT_NPC_NORMAL_1(self, pc)
   SCR_OPEN_ABILSHOP(pc, "Ability_Cataphract")
end


function SCR_JOB_2_CLERIC_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Cleric")
end

function SCR_JOB_2_KRIVIS_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Kriwi")
end

function SCR_JOB_2_KRIVIS_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Kriwi', 5);
end

function SCR_JOB_2_PRIEST_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Priest")
end

function SCR_JOB_2_PRIEST_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Priest', 5)
end

function SCR_JOB_2_BOKOR_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Bokor")
end

function SCR_JOB_2_BOKOR_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Bokor', 5)
end

function SCR_JOB_2_DIEVDIRBYS_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Dievdirbys")
end

function SCR_JOB_2_DIEVDIRBYS_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Dievdirbys', 5)
end

function SCR_JOB_2_SADHU_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Sadhu")
end

function SCR_JOB_2_PALADIN_NPC_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Paladin")
end

function SCR_JOB_2_PALADIN_NPC_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Paladin', 5);
end

function SCR_JOB_2_WIZARD_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_PYROMANCER_MASTER_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'JOB_2_WIZARD_3_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc,'SSN_JOB_2_WIZARD_3_1')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue1 == 0 then
                LookAt(pc, self)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_2_WIZARD_3_1')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_WIZARD_3_1_MSG01"), 'TALK', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_2_WIZARD_3_1')
                
                if result2 == 1 then
                    ShowOkDlg(pc,"JOB_2_WIZARD_3_1_PYROMANCER_dlg",1)
                    quest_ssn.QuestInfoValue1 = 1;
                    quest_ssn.QuestMapPointView1 = 0
                    SaveSessionObject(pc, quest_ssn)
                end
            end
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_CRYOMANCER_MASTER_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'JOB_2_WIZARD_3_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc,'SSN_JOB_2_WIZARD_3_1')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue2 == 0 then
                LookAt(pc, self)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_2_WIZARD_3_1')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_WIZARD_3_1_MSG01"), 'TALK', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_2_WIZARD_3_1')
                
                if result2 == 1 then
                    ShowOkDlg(pc,"JOB_2_WIZARD_3_1_CRYOMANCER_dlg",1)
                    quest_ssn.QuestInfoValue2 = 1;
                    quest_ssn.QuestMapPointView2 = 0
                    SaveSessionObject(pc, quest_ssn)
                end
            end
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_PSYCHOKINO_MASTER_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'JOB_2_WIZARD_3_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc,'SSN_JOB_2_WIZARD_3_1')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue3 == 0 then
                LookAt(pc, self)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_2_WIZARD_3_1')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_WIZARD_3_1_MSG01"), 'TALK', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_2_WIZARD_3_1')
                
                if result2 == 1 then
                    ShowOkDlg(pc,"JOB_2_WIZARD_3_1_PSYCHOKINO_dlg",1)
                    quest_ssn.QuestInfoValue3 = 1;
                    quest_ssn.QuestMapPointView3 = 0
                    SaveSessionObject(pc, quest_ssn)
                end
            end
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_LINKER_MASTER_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc,'JOB_2_WIZARD_3_1')
    if result == 'PROGRESS' then
        local quest_ssn = GetSessionObject(pc,'SSN_JOB_2_WIZARD_3_1')
        if quest_ssn ~= nil then
            if quest_ssn.QuestInfoValue4 == 0 then
                LookAt(pc, self)
                local animTime, before_time = DOTIMEACTION_R_BEFORE_CHECK(pc, 2, 'JOB_2_WIZARD_3_1')
                local result2 = DOTIMEACTION_R(pc, ScpArgMsg("JOB_2_WIZARD_3_1_MSG01"), 'TALK', animTime, 'SSN_HATE_AROUND')
                DOTIMEACTION_R_AFTER(pc, result2, animTime, before_time, 'JOB_2_WIZARD_3_1')
                
                if result2 == 1 then
                    ShowOkDlg(pc,"JOB_2_WIZARD_3_1_LINKER_MASTER_dlg",1)
                    quest_ssn.QuestInfoValue4 = 1;
                    quest_ssn.QuestMapPointView4 = 0
                    SaveSessionObject(pc, quest_ssn)
                end
            end
        end
    else
    	COMMON_QUEST_HANDLER(self,pc)
    end
end

function SCR_JOB_2_THAUMATURGE_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_ELEMENTALIST_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_ARCHER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_RANGER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_QUARRELSHOOTER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_SAPPER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_HUNTER_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_WUGUSHI_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end

function SCR_JOB_2_SCOUT_MASTER_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end



function SCR_JOB_2_WIZARD_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_1')
end

function SCR_JOB_2_PYROMANCER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_2')
end

function SCR_JOB_2_CRYOMANCER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_3')
end

function SCR_JOB_2_PSYCHOKINO_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_4')
end

function SCR_JOB_2_LINKER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_7')
end

function SCR_JOB_2_THAUMATURGE_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_10')
end

function SCR_JOB_2_ELEMENTALIST_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char2_11')
end

function SCR_JOB_2_ARCHER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_1')
end

function SCR_JOB_2_RANGER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_4')
end

function SCR_JOB_2_QUARRELSHOOTER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_3')
end

function SCR_JOB_2_SAPPER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_5')
end

function SCR_JOB_2_HUNTER_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_2')
end

function SCR_JOB_2_WUGUSHI_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_6')
end

function SCR_JOB_2_SCOUT_MASTER_NORMAL_1_PRE(pc)
    return SCR_MASTER_PROPERTY_PRECHECK(pc, 'Char3_8')
end



function SCR_JOB_2_WIZARD_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Wizard")
end

function SCR_JOB_2_PYROMANCER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_FireMage")
end

function SCR_JOB_2_PYROMANCER_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_FireMage', 5);
end

function SCR_JOB_2_CRYOMANCER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_FrostMage")
end

function SCR_JOB_2_PSYCHOKINO_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Psychokino")
end

function SCR_JOB_2_LINKER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Linker")
end

function SCR_JOB_2_THAUMATURGE_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Thaumaturge")
end

function SCR_JOB_2_THAUMATURGE_MASTER_NORMAL_2(self,pc)
	ShowTradeDlg(pc, 'Master_Thaumaturge', 5);
end

function SCR_JOB_2_ELEMENTALIST_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Elementalist")
end

function SCR_JOB_2_ARCHER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Archer")
end

function SCR_JOB_2_RANGER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Ranger")
end

function SCR_JOB_2_QUARRELSHOOTER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_QuarrelShooter")
end

function SCR_JOB_2_QUARRELSHOOTER_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_QuarrelShooter', 5);
end

function SCR_JOB_2_SAPPER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Sapper")
end

function SCR_JOB_2_SAPPER_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Sapper', 5);
end

function SCR_JOB_2_HUNTER_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Hunter")
end

function SCR_JOB_2_WUGUSHI_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Wugushi")
end

function SCR_JOB_2_WUGUSHI_MASTER_NORMAL_2(self,pc)
    ShowTradeDlg(pc, 'Master_Wugushi', 5);
end

function SCR_JOB_2_SCOUT_MASTER_NORMAL_1(self,pc)
    SCR_OPEN_ABILSHOP(pc, "Ability_Scout")
end
