function DLC_BOX1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_650', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_PremiumToken_60d', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_JOB_HOGLAN_COUPON', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629003', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'Premium_SkillReset', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Premium_StatReset', 1, 'DLC_BOX1');
    local ret = TxCommit(tx);
end

function DLC_BOX2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_380', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX2');
    local ret = TxCommit(tx);
end

function DLC_BOX3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_160', 1, 'DLC_BOX3');
    local ret = TxCommit(tx);
end

function GIVE_MIC_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Mic', 10, 'TPSHOP_MIC_50');
    local ret = TxCommit(tx);
end

function GIVE_ENCHANTSCROLL_10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'TPSHOP_ENCHANTSCROLL_20');
    local ret = TxCommit(tx);
end

function DLC_BOX4(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_650', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_PremiumToken_60d', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_JOB_HOGLAN_COUPON', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Hat_629003', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'Premium_SkillReset', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'steam_Premium_StatReset', 1, 'DLC_BOX4');
    local ret = TxCommit(tx);
end

function DLC_BOX5(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_380', 1, 'DLC_BOX5');
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX5');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX5');
    local ret = TxCommit(tx);
end

function DLC_BOX6(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_190', 1, 'DLC_BOX6');
    TxGiveItem(tx, 'PremiumToken_15d', 1, 'DLC_BOX6');
    TxGiveItem(tx, 'RestartCristal', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Premium_boostToken', 5, 'DLC_BOX6');
    TxGiveItem(tx, 'Mic', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Premium_WarpScroll', 15, 'DLC_BOX6');
    TxGiveItem(tx, 'Drug_Premium_HP1', 20, 'DLC_BOX6');
    TxGiveItem(tx, 'Drug_Premium_SP1', 20, 'DLC_BOX6');
    local ret = TxCommit(tx);
end

function DLC_BOX7(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX7');
    TxGiveItem(tx, 'Premium_Enchantchip_10', 4, 'DLC_BOX7');
    TxGiveItem(tx, 'Premium_indunReset', 5, 'DLC_BOX7');
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_BUYPOINT(self, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(self);
	TxAddWorldPVPProp(tx, "ShopPoint", Numarg1);
	local ret = TxCommit(tx);
end

function SCR_USE_PENGUINPACK_2016(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_006', 1, 'PENGUINPACK_2016');
    TxGiveItem(tx, 'food_penguin', 50, 'PENGUINPACK_2016');
    local ret = TxCommit(tx);
end

function SCR_USE_ADVENTURERPACK_2016(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_indunReset', 1, 'ADVENTURERPACK_2016');
    TxGiveItem(tx, 'Premium_boostToken', 3, 'ADVENTURERPACK_2016');
    TxGiveItem(tx, 'Event_drug_steam_1h', 2, 'ADVENTURERPACK_2016');
    local ret = TxCommit(tx);
end

function DLC_BOX8(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PremiumToken_15d', 1, 'DLC_BOX8');
    TxGiveItem(tx, 'Premium_eventTpBox_65', 1, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Premium_HP1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Premium_SP1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'RestartCristal', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Mic', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Premium_WarpScroll', 10, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_STA1', 30, 'DLC_BOX8');
    TxGiveItem(tx, 'Drug_Haste2_DLC', 30, 'DLC_BOX8');
    local ret = TxCommit(tx);
end

function SCR_USE_SET01_COMPANION_STEAM(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_009', 1, 'EGG009_PACK');
    TxGiveItem(tx, 'food_cereal', 50, 'EGG009_PACK');
    local ret = TxCommit(tx);
end

function SCR_USE_ALICEPACK_2016(pc)
    local job = GetClassString('Job', pc.JobName, 'CtrlType')
    local jobList = { 'Warrior', 'Wizard', 'Archer', 'Cleric' }
    local i, j, jobNum = 0, 0, 0
    
    for j = 1, table.getn(jobList) do
        if job == jobList[j] then
            jobNum = j
            break
        end
    end
    
    local costume = {
        { 'costume_war_m_011', 'costume_war_f_011' },
        { 'costume_wiz_m_011', 'costume_wiz_f_011' },
        { 'costume_arc_m_012', 'costume_arc_f_012' },
        { 'costume_clr_m_012', 'costume_clr_f_012' }
    }
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, costume[jobNum][pc.Gender], 1, 'ALICEPACK_2016');
    TxGiveItem(tx, 'AliceHairBox_2016', 1, 'ALICEPACK_2016');
    TxGiveItem(tx, 'Premium_Enchantchip', 10, 'ALICEPACK_2016');
    local ret = TxCommit(tx);
    if ret ~= "SUCCESS" then
        SendSysMsg(pc, "DataError");
        return;
    end
end

function SCR_USE_ALICEHAIRBOX_2016(pc)
    local select = ShowSelDlg(pc, 0, 'SUMMERHAIR_2016_SEL', 
    ScpArgMsg("ALICEHAIRACC01"), ScpArgMsg("ALICEHAIRACC02"), ScpArgMsg("ALICEHAIRACC03"), ScpArgMsg("ALICEHAIRACC04"), ScpArgMsg("ALICEHAIRACC05"), 
    ScpArgMsg("ALICEHAIRACC06"), ScpArgMsg("ALICEHAIRACC07"), ScpArgMsg("ALICEHAIRACC08"), ScpArgMsg("Cancel"))
    local summerhair = { 
        'Hat_628152', 'Hat_628153', 'Hat_628154', 'Hat_628155', 'Hat_628156', 'Hat_628157', 'Hat_628158', 'Hat_628159'
    }
    
    if select == 9 or select == nil then
        return
    else
        local tx = TxBegin(pc);
        TxGiveItem(tx, summerhair[select], 1, 'ALICEHAIRBOX_2016');
        local ret = TxCommit(tx);
        if ret ~= "SUCCESS" then
            SendSysMsg(pc, "DataError");
            return;
        end
    end
end

function ACHIEVE_HAUNTEDARTIST(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'HauntedArtist', 1)
    local ret = TxCommit(tx);
end

function DLC_BOX9(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Drug_Premium_HP1', 100, 'DLC_BOX9');
    TxGiveItem(tx, 'Drug_Premium_SP1', 100, 'DLC_BOX9');  
    TxGiveItem(tx, 'Event_160908_7', 10, 'DLC_BOX9'); 
    TxGiveItem(tx, 'Event_drug_160218', 10, 'DLC_BOX9');  
    TxGiveItem(tx, 'Premium_Clear_dungeon_01', 5, 'DLC_BOX9'); 
    TxGiveItem(tx, 'steam_Premium_SkillReset_1', 1, 'DLC_BOX9');
    TxGiveItem(tx, 'steam_Premium_StatReset_1', 1, 'DLC_BOX9');
    local ret = TxCommit(tx);
end

-- 3
function SCR_BUFF_ENTER_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 3;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_3(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 3;
end

-- 4
function SCR_BUFF_ENTER_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 4;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_4(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 4;
end

-- 5
function SCR_BUFF_ENTER_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM + 5;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_5(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
	self.MSPD_BM = self.MSPD_BM - 5;
end
function DLC_BOX10(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'PremiumToken_7d_Steam', 1, 'DLC_BOX4');
    TxGiveItem(tx, 'Premium_Enchantchip14', 10, 'DLC_BOX10');
    TxGiveItem(tx, 'steam_emoticonItem_24_46', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'Event_ArborDay_Costume_Box', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'E_Artefact_630005', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'Hat_629501', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'Premium_hairColor_05', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'LENS01_003', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'DLC_BOX10');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP2', 20, 'DLC_BOX10');
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_AddBuff_Item(self,argObj,BuffName,arg1,arg2)
    local aObj = GetAccountObj(self);

    if IsBuffApplied(self, 'Premium_Fortunecookie_1') == 'YES' then
        BuffName = 'Premium_Fortunecookie_2'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_2') == 'YES' then
        BuffName = 'Premium_Fortunecookie_3'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_3') == 'YES' then
        BuffName = 'Premium_Fortunecookie_4'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_4') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    elseif IsBuffApplied(self, 'Premium_Fortunecookie_5') == 'YES' then
        BuffName = 'Premium_Fortunecookie_5'
    else
        BuffName = 'Premium_Fortunecookie_1'
    end

	AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
end

function SCR_USE_HiddenJobUnlock(self,argObj, StringArg, Numarg1, Numarg2)
    local jobNameKOR = GetClassString('Job', StringArg, 'EngName')
    local select_1 = ShowSelDlg(self, 0, 'HIDDEN_JOB_UNLOCK_ITEM_DLG1\\'..ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG6','JOBNAME', jobNameKOR), ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select_1 == 1 then
        if StringArg == 'Char4_18' then
            if self.Gender ~= 2 then
                local select_2 = ShowSelDlg(self, 0, 'HIDDEN_JOB_UNLOCK_ITEM_DLG2', ScpArgMsg('Yes'), ScpArgMsg('No')) 
                if select_2 ~= 1 then
                    return
                end
            end
        end
        local result = SCR_HIDDEN_JOB_UNLOCK(self, StringArg)
        if result == 'SUCCESS' then
            if StringArg == 'Char4_18' then
                if isHideNPC(self, 'MIKO_MASTER') == 'YES' then
                    UnHideNPC(self, 'MIKO_MASTER')
                end
                if isHideNPC(self, 'MIKO_SOUL_SPIRIT') == 'YES' then
                    UnHideNPC(self, 'MIKO_SOUL_SPIRIT')
                end
            elseif StringArg == 'Char3_13' then
                if isHideNPC(self, 'FEDIMIAN_APPRAISER') == 'NO' then
                    HideNPC(self, 'FEDIMIAN_APPRAISER')
                end
                if isHideNPC(self, 'FEDIMIAN_APPRAISER_NPC') == 'YES' then
                    UnHideNPC(self, 'FEDIMIAN_APPRAISER_NPC')
                end
            elseif StringArg == 'Char2_17' then
                if isHideNPC(self, 'RUNECASTER_MASTER') == 'YES' then
                    UnHideNPC(self, 'RUNECASTER_MASTER')
                end
            elseif StringArg == 'Char1_13' then
                if isHideNPC(self, 'SHINOBI_MASTER') == 'YES' then
                    UnHideNPC(self, 'SHINOBI_MASTER')
                end
            end
            SCR_SEND_NOTIFY_REWARD(self, ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG4','JOBNAME', jobNameKOR), ScpArgMsg('HIDDEN_JOB_UNLOCK_VIEW_MSG5','RANK', Numarg1,'JOBNAME', jobNameKOR))
        end
    end
end

function SCR_USE_LETICIA_MONSTERGEM_BOX03(pc)
    local r_gem = {
        {'Gem_Hoplite_Stabbing', 30},
        {'Gem_Hoplite_Pierce', 30},
        {'Gem_Hoplite_Finestra', 40},
        {'Gem_Hoplite_SynchroThrusting', 30},
        {'Gem_Hoplite_LongStride', 30},
        {'Gem_Hoplite_SpearLunge', 30},
        {'Gem_Hoplite_ThrouwingSpear', 30},
        {'Gem_Barbarian_Embowel', 20},
        {'Gem_Barbarian_StompingKick', 20},
        {'Gem_Barbarian_Cleave', 20},
        {'Gem_Barbarian_HelmChopper', 30},
        {'Gem_Barbarian_Warcry', 40},
        {'Gem_Barbarian_Frenzy', 40},
        {'Gem_Barbarian_Seism', 40},
        {'Gem_Barbarian_GiantSwing', 40},
        {'Gem_Barbarian_Pouncing', 30},
        {'Gem_Bokor_Hexing', 30},
        {'Gem_Bokor_Effigy', 30},
        {'Gem_Bokor_Zombify', 30},
        {'Gem_Bokor_Mackangdal', 30},
        {'Gem_Bokor_BwaKayiman', 30},
        {'Gem_Bokor_Samdiveve', 30},
        {'Gem_Bokor_Ogouveve', 30},
        {'Gem_Bokor_Damballa', 40},
        {'Gem_Dievdirbys_CarveVakarine', 40},
        {'Gem_Dievdirbys_CarveZemina', 40},
        {'Gem_Dievdirbys_CarveLaima', 40},
        {'Gem_Dievdirbys_Carve', 40},
        {'Gem_Dievdirbys_CarveOwl', 40},
        {'Gem_Dievdirbys_CarveAustrasKoks', 25},
        {'Gem_Dievdirbys_CarveAusirine', 25},
      }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_gem) do
        sum = sum + r_gem[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_gem) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[result][1], 1, 'SCR_USE_LETICIA_MONSTERGEM_BOX03');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_MONSTERGEM_BOX04(pc)
    local r_gem = {
        {'Gem_Psychokino_PsychicPressure', 40},
        {'Gem_Psychokino_Telekinesis', 40},
        {'Gem_Psychokino_Swap', 40},
        {'Gem_Psychokino_Teleportation', 40},
        {'Gem_Psychokino_MagneticForce', 40},
        {'Gem_Psychokino_Raise', 40},
        {'Gem_Psychokino_GravityPole', 40},
        {'Gem_Linker_Physicallink', 40},
        {'Gem_Linker_JointPenalty', 30},
        {'Gem_Linker_HangmansKnot', 30},
        {'Gem_Linker_SpiritualChain', 40},
        {'Gem_Linker_UmbilicalCord', 40},
        {'Gem_Sapper_StakeStockades', 30},
        {'Gem_Sapper_Cover', 30},
        {'Gem_Sapper_Claymore', 40},
        {'Gem_Sapper_PunjiStake', 30},
        {'Gem_Sapper_DetonateTraps', 30},
        {'Gem_Sapper_BroomTrap', 50},
        {'Gem_Sapper_CollarBomb', 20},
        {'Gem_Sapper_SpikeShooter', 20},
        {'Gem_Hunter_Coursing', 30},
        {'Gem_Hunter_Snatching', 30},
        {'Gem_Hunter_Pointing', 30},
        {'Gem_Hunter_RushDog', 40},
        {'Gem_Hunter_Retrieve', 40},
        {'Gem_Hunter_Hounding', 40},
        {'Gem_Hunter_Growling', 40}
      }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_gem) do
        sum = sum + r_gem[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_gem) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[result][1], 1, 'SCR_USE_LETICIA_MONSTERGEM_BOX04');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_BASEITEM_BOX04(pc)
    local r_item = {
        {'misc_0475', 50},
        {'misc_0483', 70},
        {'misc_0499', 30},
        {'misc_0480', 35},
        {'misc_0485', 35},
        {'misc_0506', 200},
        {'misc_0501', 40},
        {'misc_0487', 180},
        {'misc_0495', 60},
        {'misc_0489', 70},
        {'misc_0483', 70},
        {'misc_0503', 70},
        {'misc_0493', 100},
        {'misc_0491', 60}
    }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'SCR_USE_LETICIA_BASEITEM_BOX04');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_RECIPE_WEP315_01(pc)
    local r_item = {
        {'R_SWD04_109', 70},
        {'R_PST04_104', 70},
        {'R_TBW04_109', 70},
        {'R_CAN04_103', 70},
        {'R_DAG04_104', 70},
        {'R_MUS04_103', 70},
        {'R_SHD04_105', 70},
        {'R_STF04_110', 70},
        {'R_BOW04_109', 70},
        {'R_TSF04_109', 70},
        {'R_TSP04_111', 70},
        {'R_TSW04_109', 160},
        {'R_SPR04_110', 70}
    }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'SCR_USE_LETICIA_RECIPE_WEP315_01');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_MONCARD_BOX_02(pc)
    local r_item = {
        {'card_Glass_mole', 50},
        {'card_Chapparition', 100},
        {'card_TombLord', 100},
        {'card_Grinender', 50},
        {'card_Mandala', 50},
        {'card_Colimencia', 50},
        {'card_molich', 250},
        {'card_Kerberos', 50},
        {'card_Manticen', 50},
        {'card_Riteris', 250}
    }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'SCR_USE_LETICIA_MONCARD_BOX_02');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_2', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'BRC99_103', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'BRC99_104', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'NECK99_107', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_3', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'JOB_VELHIDER_COUPON', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    TxGiveItem(tx, 'Scroll_Warp_Klaipe', 3, 'EV170516_NRU');
    TxGiveItem(tx, 'Scroll_Warp_Orsha', 3, 'EV170516_NRU');
    local ret = TxCommit(tx);
end
 
function SCR_USE_EVENT_NRU_BOX_3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_4', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 2, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_drug_steam_1h', 10, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_4(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_5', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'expCard5', 10, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 2, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_5(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_6', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv50', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 3, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_Goddess_Statue', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'GIMMICK_Drug_HPSP1', 20, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    TxGiveItem(tx, 'E_SWD04_106', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_TSW04_106', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_MAC04_108', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_TSF04_106', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_STF04_107', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_SPR04_103', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_TSP04_107', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_BOW04_106', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_TBW04_106', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'E_SHD04_102', 1, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_6(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Event_Nru_Always_Box_7', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_boostToken03_event01', 4, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_indunReset_14d', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_Warp_Dungeon_Lv80', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_Goddess_Statue', 1, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_NRU_BOX_7(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Premium_boostToken03_event01', 5, 'EV170516_NRU');
    TxGiveItem(tx, 'Premium_indunReset_14d', 2, 'EV170516_NRU');
    TxGiveItem(tx, 'Drug_Fortunecookie', 5, 'EV170516_NRU');
    TxGiveItem(tx, 'Scroll_Warp_Fedimian', 1, 'EV170516_NRU');
    TxGiveItem(tx, 'Event_Goddess_Statue', 1, 'EV170516_NRU');
    local ret = TxCommit(tx);
end

function SCR_USE_RETURNQUEST_1705(pc)
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']

    if aObj.EVENT_RETURN_COUNT >= 10 then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("BLACK_HOLE_CLEAR_BOX_MSG2"), 5)
        return
    elseif aObj.EVENT_RETURN_DAY == yday then
        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Event_Returner_Desc01"), 5)
        return
    else
        local reward = {
            {'NoItem', 0},
            {'Premium_boostToken03_event01', 1},
            {'Premium_indunReset_14d', 2},
            {'Premium_dungeoncount_Event', 3},
            {'CS_IndunReset_GTower_14d', 1},
            {'CS_IndunReset_Nunnery_14d', 1}
        }
        local select = ShowSelDlg(pc, 0, 'NPC_EVENT_RETURNER_DLG1', ScpArgMsg('Auto_DaeHwa_JongLyo'), 
        ScpArgMsg('Premium_boostToken03_event01'), ScpArgMsg('Premium_indunReset_14d'), ScpArgMsg('Dungeoncount_14d_Name'), ScpArgMsg('CS_IndunReset_GTower_14d'), ScpArgMsg('CS_IndunReset_Nunnery_14d'))

        if select == 1 or select == nil then
            return
        else
            local tx = TxBegin(pc);
            TxGiveItem(tx, reward[select][1], reward[select][2], 'RETURNER_1705');
            TxGiveItem(tx, 'Event_drug_steam_1h', 3, 'RETURNER_1705');
            TxSetIESProp(tx, aObj, 'EVENT_RETURN_DAY', yday)
            TxSetIESProp(tx, aObj, 'EVENT_RETURN_COUNT', aObj.EVENT_RETURN_COUNT + 1)
            local ret = TxCommit(tx);
            if ret == 'SUCCESS' then
                SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("LevelUp_Event_Desc01", "REWARD", aObj.EVENT_RETURN_COUNT), 5)
            end
        end
    end
end

function SCR_PRE_Premium_IndunReset_All(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            local result = 0;
            local clsList, cnt = GetClassList('Indun');
            
            for i = 0, cnt - 1 do
                local pCls = GetClassByIndexFromList(clsList, i)
                local induncount = 'InDunCountType_'..pCls.PlayPerResetType
                if pcetc[induncount] > 0 then
                    result = 1
                    break
                end
            end
            
            if result == 1 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsApplied_indunReset"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("AllowedInTown"), 10);
    end
    
    return 0
end

function SCR_USE_Premium_IndunReset_All(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            local resetlist = {}
            local clsList, cnt = GetClassList('Indun');
    
            for i = 0, cnt - 1 do
                local pCls = GetClassByIndexFromList(clsList, i)
                local induncount = 'InDunCountType_'..pCls.PlayPerResetType
                if pcetc[induncount] > 0 then
                    local result = 0;
                    for j = 1, table.getn(resetlist) do
                        if resetlist[j] == induncount then
                            result = 1;
                            break;
                        end
end

                    if result == 0 then
                        table.insert(resetlist, induncount)
    end
        end
    end
    
            if table.getn(resetlist) > 0 then
                local tx = TxBegin(self);
                for k = 1, table.getn(resetlist) do
                    TxSetIESProp(tx, pcetc, resetlist[k], 0)
                end
    local ret = TxCommit(tx);
end        end
    end
end

function SCR_USE_LETICIA_ETC_WEP315(pc)
    local r_item = {
      {'misc_0485', 40},
      {'misc_0505', 35},
      {'misc_0475', 45},
      {'misc_0504', 30},
      {'misc_0480', 70},
      {'misc_0503', 70},
      {'misc_0491', 110},
      {'misc_0487', 100},
      {'misc_0483', 130},
      {'misc_0506', 130},
      {'misc_0493', 120},
      {'misc_0497', 120}
    }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'LETICIA_ETC_WEP315');
    local ret = TxCommit(tx);
end

function ACHIEVE_FINESTMOMENT(pc)
   AddAchievePoint(pc, "FinestMoment", 1); 
end

function SCR_USE_LETICIA_RECIPE_WEP315_STEAM(pc)
    local r_item = {
        {'R_SWD04_109', 10},
        {'R_PST04_104', 5},
        {'R_TBW04_109', 10},
        {'R_CAN04_103', 5},
        {'R_DAG04_104', 5},
        {'R_MUS04_103', 10},
        {'R_SHD04_105', 5},
        {'R_STF04_110', 10},
        {'R_BOW04_109', 10},
        {'R_TSF04_109', 10},
        {'R_TSP04_111', 10},
        {'R_SPR04_110', 10},
        {'R_RAP04_106', 10},
        {'R_MAC04_111', 10},
        {'R_TSW04_109', 10}
    }
    
    local result, sum = 0, 0
    local itemratio = {}
    
    for j = 1, table.getn(r_item) do
        sum = sum + r_item[j][2]
        table.insert(itemratio, sum)
    end
    
    local rand = IMCRandom(1, sum)
    
    for i = 1, table.getn(r_item) do
        if itemratio[i] >= rand then
            result = i;
            break;
        end
    end
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_item[result][1], 1, 'LETICIA_RECIPE_WEP315_STEAM');
    local ret = TxCommit(tx);
end

function SCR_USE_ROCKSODON_PACK(pc)
    local tx = TxBegin(pc) 
    TxGiveItem(tx, 'egg_010', 1, "ROCKSODON_PACK")
    TxGiveItem(tx, 'Premium_Enchantchip', 10, "ROCKSODON_PACK")
    TxGiveItem(tx, 'misc_gemExpStone_randomQuest4', 1, "ROCKSODON_PACK")
    TxGiveItem(tx, 'Ability_Point_Stone', 1, "ROCKSODON_PACK")
    TxGiveItem(tx, 'Moru_Silver_TA', 1, "ROCKSODON_PACK")
    TxGiveItem(tx, 'Premium_indunReset', 1, "ROCKSODON_PACK")
    local ret = TxCommit(tx)
end

function SCR_USE_COSTUMEBOX_170704(pc, argObj, argstring, arg1, arg2, itemID)
    local job = GetClassString('Job', pc.JobName, 'CtrlType')
    local jobList = { 'Warrior', 'Wizard', 'Archer', 'Cleric' }
    local i, j, jobNum = 0, 0, 0
    
    for j = 1, table.getn(jobList) do
        if job == jobList[j] then
            jobNum = j
            break
        end
    end
    
    local head = {
        { 'HAIR_M_128', 'HAIR_F_129' },
        { 'HAIR_M_127', 'HAIR_F_128' },
        { 'HAIR_M_126', 'HAIR_F_127' }
    }
    
    local costume = {
        'costume_Com_27', 'costume_Com_28', 'costume_Com_29'
    }
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, head[arg1][pc.Gender], 1, 'COSTUMEBOX_170704');
    TxGiveItem(tx, costume[arg1], 1, 'COSTUMEBOX_170704');
    local ret = TxCommit(tx);
    if ret ~= "SUCCESS" then
        SendSysMsg(pc, "DataError");
        return;
    end
end

function SCR_USE_LETICIA_MONSTERGEM_1RANK(pc)
    local r_gem = {
        'Gem_Swordman_Thrust',
        'Gem_Swordman_Bash',
        'Gem_Swordman_GungHo',
        'Gem_Swordman_Concentrate',
        'Gem_Swordman_PainBarrier',
        'Gem_Swordman_Restrain',
        'Gem_Swordman_PommelBeat',
        'Gem_Swordman_DoubleSlash',
        'Gem_Wizard_EnergyBolt',
        'Gem_Wizard_Lethargy',
        'Gem_Wizard_Sleep',
        'Gem_Wizard_ReflectShield',
        'Gem_Wizard_EarthQuake',
        'Gem_Wizard_Surespell',
        'Gem_Wizard_MagicMissile',
        'Gem_Archer_SwiftStep',
        'Gem_Archer_Multishot',
        'Gem_Archer_Fulldraw',
        'Gem_Archer_ObliqueShot',
        'Gem_Archer_Kneelingshot',
        'Gem_Archer_HeavyShot',
        'Gem_Archer_TwinArrows',
        'Gem_Cleric_Heal',
        'Gem_Cleric_Cure',
        'Gem_Cleric_SafetyZone',
        'Gem_Cleric_DeprotectedZone',
        'Gem_Cleric_DivineMight',
        'Gem_Cleric_Fade',
        'Gem_Cleric_PatronSaint'
    }
    
    local rand = IMCRandom(1, table.getn(r_gem))
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[rand], 1, 'LETICIA_MONSTERGEM_1RANK');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_MONSTERGEM_2RANK(pc)
    local r_gem = {
      'Gem_Highlander_WagonWheel',
      'Gem_Highlander_CartarStroke',
      'Gem_Highlander_Crown',
      'Gem_Highlander_CrossGuard',
      'Gem_Highlander_Moulinet',
      'Gem_Highlander_SkyLiner',
      'Gem_Highlander_CrossCut',
      'Gem_Highlander_ScullSwing',
      'Gem_Highlander_VerticalSlash',
      'Gem_Peltasta_UmboBlow',
      'Gem_Peltasta_RimBlow',
      'Gem_Peltasta_SwashBuckling',
      'Gem_Peltasta_Guardian',
      'Gem_Peltasta_ShieldLob',
      'Gem_Peltasta_HighGuard',
      'Gem_Peltasta_ButterFly',
      'Gem_Peltasta_UmboThrust',
      'Gem_Pyromancer_FireBall',
      'Gem_Pyromancer_FireWall',
      'Gem_Pyromancer_EnchantFire',
      'Gem_Pyromancer_Flare',
      'Gem_Pyromancer_FlameGround',
      'Gem_Pyromancer_FirePillar',
      'Gem_Pyromancer_HellBreath',
      'Gem_Cryomancer_IceBolt',
      'Gem_Cryomancer_IciclePike',
      'Gem_Cryomancer_IceWall',
      'Gem_Cryomancer_IceBlast',
      'Gem_Cryomancer_Gust',
      'Gem_Cryomancer_SnowRolling',
      'Gem_Cryomancer_FrostPillar',
      'Gem_QuarrelShooter_DeployPavise',
      'Gem_QuarrelShooter_ScatterCaltrop',
      'Gem_QuarrelShooter_StoneShot',
      'Gem_QuarrelShooter_RapidFire',
      'Gem_QuarrelShooter_Teardown',
      'Gem_QuarrelShooter_RunningShot',
      'Gem_Ranger_Barrage',
      'Gem_Ranger_HighAnchoring',
      'Gem_Ranger_CriticalShot',
      'Gem_Ranger_SteadyAim',
      'Gem_Ranger_TimeBombArrow',
      'Gem_Ranger_BounceShot',
      'Gem_Ranger_SpiralArrow',
      'Gem_Priest_Aspersion',
      'Gem_Priest_Monstrance',
      'Gem_Priest_Blessing',
      'Gem_Priest_Sacrament',
      'Gem_Priest_Revive',
      'Gem_Priest_MassHeal',
      'Gem_Priest_Exorcise',
      'Gem_Priest_StoneSkin',
      'Gem_Kriwi_Aukuras',
      'Gem_Kriwi_Zalciai',
      'Gem_Kriwi_Daino',
      'Gem_Kriwi_Zaibas',
      'Gem_Kriwi_DivineStigma',
      'Gem_Kriwi_Melstis'
    }
    
    local rand = IMCRandom(1, table.getn(r_gem))
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[rand], 1, 'LETICIA_MONSTERGEM_2RANK');
    local ret = TxCommit(tx);
end

function ACHIEVE_GIVINGSHADE(pc)
   AddAchievePoint(pc, "Event_170823_Fanart_Steam", 1); 
end

function ACHIEVE_STEAM2018HAPPYNEWYEAR(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, '2018Happy_New_Year_Steam', 1)
    local ret = TxCommit(tx);
end

function DLC_BOX12(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Hat_628254', 1, 'DLC_BOX12');
    TxGiveItem(tx, 'Moru_Diamond_DLC', 1, 'DLC_BOX12');
    TxGiveItem(tx, 'Moru_Gold_Team_Trade', 3, 'DLC_BOX12');
    TxGiveItem(tx, 'Moru_Silver_DLC', 3, 'DLC_BOX12');
    TxGiveItem(tx, 'Event_Reinforce_100000coupon', 10, 'DLC_BOX12');
    TxGiveItem(tx, 'Ability_Point_Stone', 1, 'DLC_BOX10');
    TxGiveItem(tx, 'Drug_Premium_HP1', 20, 'DLC_BOX10');
    TxGiveItem(tx, 'Drug_Premium_SP1', 20, 'DLC_BOX10');
    TxGiveItem(tx, 'Event_drug_steam_1h_DLC', 10, 'DLC_BOX10');
    TxGiveItem(tx, 'Event_Goddess_Statue_DLC', 5, 'DLC_BOX10');
    TxGiveItem(tx, 'Drug_Haste1_event_DLC', 5, 'DLC_BOX10');
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_MONSTERGEM_3RANK(pc)
    local r_gem = {
      'Gem_Hoplite_Stabbing',
      'Gem_Hoplite_Pierce',
      'Gem_Hoplite_Finestra',
      'Gem_Hoplite_SynchroThrusting',
      'Gem_Hoplite_LongStride',
      'Gem_Hoplite_SpearLunge',
      'Gem_Hoplite_ThrouwingSpear',
      'Gem_Barbarian_Embowel',
      'Gem_Barbarian_StompingKick',
      'Gem_Barbarian_Cleave',
      'Gem_Barbarian_HelmChopper',
      'Gem_Barbarian_Warcry',
      'Gem_Barbarian_Frenzy',
      'Gem_Barbarian_Seism',
      'Gem_Barbarian_GiantSwing',
      'Gem_Barbarian_Pouncing',
      'Gem_Psychokino_PsychicPressure',
      'Gem_Psychokino_Telekinesis',
      'Gem_Psychokino_Swap',
      'Gem_Psychokino_Teleportation',
      'Gem_Psychokino_MagneticForce',
      'Gem_Psychokino_Raise',
      'Gem_Psychokino_GravityPole',
      'Gem_Linker_Physicallink',
      'Gem_Linker_JointPenalty',
      'Gem_Linker_HangmansKnot',
      'Gem_Linker_SpiritualChain',
      'Gem_Linker_UmbilicalCord',
      'Gem_Hunter_Coursing',
      'Gem_Hunter_Snatching',
      'Gem_Hunter_Pointing',
      'Gem_Hunter_RushDog',
      'Gem_Hunter_Retrieve',
      'Gem_Hunter_Hounding',
      'Gem_Hunter_Growling',
      'Gem_Sapper_StakeStockades',
      'Gem_Sapper_Cover',
      'Gem_Sapper_Claymore',
      'Gem_Sapper_PunjiStake',
      'Gem_Sapper_DetonateTraps',
      'Gem_Sapper_BroomTrap',
      'Gem_Sapper_CollarBomb',
      'Gem_Sapper_SpikeShooter',
      'Gem_Bokor_Hexing',
      'Gem_Bokor_Effigy',
      'Gem_Bokor_Zombify',
      'Gem_Bokor_Mackangdal',
      'Gem_Bokor_BwaKayiman',
      'Gem_Bokor_Samdiveve',
      'Gem_Bokor_Ogouveve',
      'Gem_Bokor_Damballa',
      'Gem_Dievdirbys_CarveVakarine',
      'Gem_Dievdirbys_CarveZemina',
      'Gem_Dievdirbys_CarveLaima',
      'Gem_Dievdirbys_Carve',
      'Gem_Dievdirbys_CarveOwl',
      'Gem_Dievdirbys_CarveAustrasKoks',
      'Gem_Dievdirbys_CarveAusirine'
    }
    
    local rand = IMCRandom(1, table.getn(r_gem))
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[rand], 1, 'LETICIA_MONSTERGEM_3RANK');
    local ret = TxCommit(tx);
end

function ACHIEVE_MONSTERINKER(pc)
   AddAchievePoint(pc, "Event_MonsterInker_Steam", 1); 
end

function SCR_USE_GIVE_STUFF_BOX_C(pc)
    local tx = TxBegin(pc) 
    TxGiveItem(tx, 'Premium_WarpScroll', 5, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Premium_repairPotion', 2, "DRUNG_BOX_ELIXER_PREMIUM")
    TxGiveItem(tx, 'Drug_MSPD2_1h_NR', 2, 'DRUNG_BOX_ELIXER_PREMIUM');
    local ret = TxCommit(tx)
end

function ACHIEVE_COMPANIONFORLIFE(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Companions_forLife', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_LETICIA_MONSTERGEM_4RANK(pc)
    local r_gem = {
      'Gem_Cataphract_Impaler',
      'Gem_Cataphract_EarthWave',
      'Gem_Cataphract_Trot',
      'Gem_Cataphract_SteedCharge',
      'Gem_Cataphract_DoomSpike',
      'Gem_Cataphract_Rush',
      'Gem_Rodelero_ShieldCharge',
      'Gem_Rodelero_Montano',
      'Gem_Rodelero_TargeSmash',
      'Gem_Rodelero_ShieldPush',
      'Gem_Rodelero_ShieldShoving',
      'Gem_Rodelero_ShieldBash',
      'Gem_Rodelero_Slithering',
      'Gem_Rodelero_ShootingStar',
      'Gem_Thaumaturge_SwellLeftArm',
      'Gem_Thaumaturge_ShrinkBody',
      'Gem_Thaumaturge_SwellBody',
      'Gem_Thaumaturge_Transpose',
      'Gem_Thaumaturge_SwellRightArm',
      'Gem_Elementalist_Electrocute',
      'Gem_Elementalist_StoneCurse',
      'Gem_Elementalist_Hail',
      'Gem_Elementalist_Meteor',
      'Gem_Elementalist_FreezingSphere',
      'Gem_Elementalist_Rain',
      'Gem_Elementalist_FrostCloud',
      'Gem_Wugushi_Detoxify',
      'Gem_Wugushi_NeedleBlow',
      'Gem_Wugushi_Bewitch',
      'Gem_Wugushi_WugongGu',
      'Gem_Wugushi_Zhendu',
      'Gem_Wugushi_ThrowGuPot',
      'Gem_Wugushi_JincanGu',
      'Gem_Scout_FluFlu',
      'Gem_Scout_FlareShot',
      'Gem_Scout_Cloaking',
      'Gem_Scout_Undistance',
      'Gem_Sadhu_OutofBody',
      'Gem_Sadhu_AstralBodyExplosion',
      'Gem_Sadhu_VashitaSiddhi',
      'Gem_Sadhu_Possession',
      'Gem_Paladin_Smite',
      'Gem_Paladin_Restoration',
      'Gem_Paladin_ResistElements',
      'Gem_Paladin_TurnUndead',
      'Gem_Paladin_Conversion'
    }
    
    local rand = IMCRandom(1, table.getn(r_gem))
    
    local tx = TxBegin(pc);
    TxGiveItem(tx, r_gem[rand], 1, 'LETICIA_MONSTERGEM_4RANK');
    local ret = TxCommit(tx);
end

function HALOWEEN_2017_ACHIEVE1(pc)
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    TxAddAchievePoint(tx, '2017_Halloween2_AP', 1)
    local ret = TxCommit(tx);
end

function HALOWEEN_2017_ACHIEVE2(pc)
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx)
    TxAddAchievePoint(tx, '2017_Halloween1_AP', 1)
    local ret = TxCommit(tx);
end

function ACHIEVE_JOURNAL_AP1(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Journal_AP1', 1)
    local ret = TxCommit(tx);

    if ret == 'SUCCESS' then
        AddBuff(pc, pc, 'Journal_AP1', 1, 0, 1209600000, 1);
    end
end

function SCR_USE_ITEM_LVUPCARD(self, argObj, argstring, arg1, arg2, itemID)
    local level = self.Lv
    local cur_xp = GetExp(self) - GetClassNumber('Xp', level - 1,'TotalXp')

    if level > arg1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("PILGRIM_48_SQ_030_MSG03"), 3);
        return
    end
    
    local exp
    if level == 1 then
        exp = GetClassNumber('Xp', level,'TotalXp')
    else
        exp = GetClassNumber('Xp', level,'TotalXp') - GetClassNumber('Xp', level - 1,'TotalXp')
    end

    exp = exp - cur_xp
    
    local tx = TxBegin(self);
	TxGiveExp(tx, exp, "LVUPCARD");
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		local jexp = math.floor(exp * 0.77);
		GiveJobExp(self, jexp, "ExpCard");
		UserExpCardMongoLog(self, exp, jexp, "LVUPCARD");
	end
end

function ACHIEVE_THEGIFTEDARTIST2(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'TheGiftedArtist2', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_MONSTERCARDALBUM_TAIWAN(pc, target, string1, arg1, arg2, itemID)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Red_Card_Book', 1, 'MONSTERCARDALBUM_TAIWAN');
    TxGiveItem(tx, 'Blue_Card_Book', 1, 'MONSTERCARDALBUM_TAIWAN');
    TxGiveItem(tx, 'Green_Card_Book', 1, 'MONSTERCARDALBUM_TAIWAN');
    TxGiveItem(tx, 'Purple_Card_Book', 1, 'MONSTERCARDALBUM_TAIWAN');
    local ret = TxCommit(tx);
end

function ACHIEVE_NEWCLASSARTIST(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'NewClassArtist_Steam', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_Adventurebook_HighRank_Reward_1d(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Companion_Exchange_Ticket2', 12, 'Adventurebook_HighRank_Reward');
    TxGiveItem(tx, 'Vis', 500000, 'Adventurebook_HighRank_Reward');
    TxGiveItem(tx, 'Premium_boostToken02', 3, 'Adventurebook_HighRank_Reward');
    TxGiveItem(tx, 'Adventure_dungeoncount_01', 3, 'Adventurebook_HighRank_Reward');
    TxGiveItem(tx, 'Adventure_Point_Stone', 2, 'Adventurebook_HighRank_Reward');
    local ret = TxCommit(tx);
end

function SCR_USE_Adventurebook_ThirdRank_Reward_1d(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Companion_Exchange_Ticket2', 7, 'Adventurebook_ThirdRank_Reward');
    TxGiveItem(tx, 'Vis', 300000, 'Adventurebook_ThirdRank_Reward');
    TxGiveItem(tx, 'Premium_boostToken02', 3, 'Adventurebook_ThirdRank_Reward');
    TxGiveItem(tx, 'Adventure_dungeoncount_01', 3, 'Adventurebook_ThirdRank_Reward');
    TxGiveItem(tx, 'Adventure_Point_Stone', 1, 'Adventurebook_ThirdRank_Reward');
    local ret = TxCommit(tx);
end

function SCR_USE_Adventurebook_FourthRank_Reward_1d(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Companion_Exchange_Ticket2', 5, 'Adventurebook_FourthRank_Reward');
    TxGiveItem(tx, 'Vis', 200000, 'Adventurebook_FourthRank_Reward');
    TxGiveItem(tx, 'Premium_boostToken02', 2, 'Adventurebook_FourthRank_Reward');
    TxGiveItem(tx, 'Adventure_dungeoncount_01', 2, 'Adventurebook_FourthRank_Reward');
    TxGiveItem(tx, 'Adventure_Point_Stone3', 1, 'Adventurebook_FourthRank_Reward');
    local ret = TxCommit(tx);
end

function SCR_USE_Adventurebook_FifthRank_Reward_1d(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Companion_Exchange_Ticket2', 4, 'Adventurebook_FifthRank_Reward');
    TxGiveItem(tx, 'Premium_boostToken02', 1, 'Adventurebook_FifthRank_Reward');
    TxGiveItem(tx, 'Adventure_Point_Stone2', 3, 'Adventurebook_FifthRank_Reward');
    TxGiveItem(tx, 'Vis', 100000, 'Adventurebook_FifthRank_Reward');
    local ret = TxCommit(tx);
end

function SCR_USE_ITEM_Event_Steam_Night_Market_RedOxBuff(self,argObj,BuffName,arg1,arg2)
    AddBuff(self, self, 'Event_Steam_Drug_RedOx');
end

function ACHIEVE_TEAMBATTLE_ERROR(self, argObj, argstring, arg1, arg2pc)
    local achieveName = nil;
	local buffName = nil;

    if arg1 == 1 then
        achieveName = "TeamBattle_Gold";
        buffName = "TeamBattle_GoldRanker_Error";
    elseif arg1 == 2 then
        achieveName = "TeamBattle_Silver";
        buffName = "TeamBattle_SilverRanker_Error";
    elseif arg1 == 3 then
        achieveName = "TeamBattle_Bronze";
        buffName = "TeamBattle_BronzeRanker_Error";
    end
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, achieveName, 1);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        ADDBUFF(self, self, buffName, 1, 0, 604740000);
    end
end

function SCR_USE_VALENTINE_CHOCO_2018(pc)
    local aObj = GetAccountObj(pc);
    local mapclass = GetClass('Map', aObj.EV180206_VALENTINE_MAP)

    local choco_sel = ShowSelDlg(pc, 0, ScpArgMsg('EVENT_2018VALEN_SEL3', 'MAP', mapclass.Name), ScpArgMsg("No"), ScpArgMsg("Yes"))

    if choco_sel == 1 then
        return;
    elseif choco_sel == 2 then
        local tx = TxBegin(pc);
        TxSetIESProp(tx, aObj, 'EV180206_VALENTINE_MAP', 'None')
        local ret = TxCommit(tx);

        if ret == 'SUCCESS' then
            AddBuff(pc, pc, 'EVENT_1708_JURATE_1', arg1, 0, '3600000', 1);
            local teamlv = GetTeamLevel(pc)
            local teamName = GetTeamName(pc);
            IMCLOG_CONTENT("180206_VALENTINE_EVENT", "PClv:  ", pc.Lv, "TeamLv:  ", teamlv, "TeamName:   ", teamName)
        end
    end
end

function SCR_USE_ITEM_AddBuff(self,argObj,BuffName,arg1,arg2)
    if BuffName == 'EVENT_1708_JURATE_1' then
        local teamlv = GetTeamLevel(self)
        local teamName = GetTeamName(self);
        IMCLOG_CONTENT("180206_VALENTINE_EVENT", "PClv:  ", self.Lv, "TeamLv:  ", teamlv, "TeamName:   ", teamName)
    end
    AddBuff(self, self, BuffName, arg1, 0, arg2, 1);
	AddAchievePoint(self, "Potion", 1);

end

function SCR_USE_LEVELUP_REWARD_EV(pc)
	local nextLv = 0
	local nextlv_group = {330, 280, 235, 185, 135, 85, 45, 1}
	local sObj = GetSessionObject(pc, 'ssn_klapeda')

	-- if sObj.EVENT_VALUE_SOBJ01 >= 360 then
	--     SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("BLACK_HOLE_CLEAR_BOX_MSG2"), 5)
	--     return;
	-- end
	
    if sObj.EVENT_VALUE_SOBJ02 > 10 then
	    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("BLACK_HOLE_CLEAR_BOX_MSG2"), 5)
	    return;
	end

	if sObj.EVENT_VALUE_SOBJ01 <= pc.Lv or pc.Lv >= 360 then -- succ
	    local reward = {
	        {'Drug_Fortunecookie_14d', 5, 'Premium_indunReset_14d', 1},
	        {'Drug_Fortunecookie_14d', 5, 'Premium_indunReset_14d', 1},
            {'Drug_Fortunecookie_14d', 5, 'Premium_indunReset_14d', 2},
            {'Drug_Fortunecookie_14d', 5, 'Event_Goddess_Statue_3d', 2},
            {'Drug_Fortunecookie_14d', 5, 'Adventure_Reward_Seed_3d', 2}, -- 5
            {'Drug_Fortunecookie_14d', 5, 'Premium_dungeoncount_Event', 3},
            {'Drug_Fortunecookie_14d', 5, 'Premium_indunReset_14d', 2},
            {'Drug_Fortunecookie_14d', 5, 'Premium_dungeoncount_Event', 3},
            {'Drug_Fortunecookie_14d', 5, 'Moru_Silver', 1},
            {'Ability_Point_Stone', 2, 'Moru_Gold_14d', 1},
	    }
	    
	    for i = 1, table.getn(nextlv_group) do
    	    if pc.Lv >= nextlv_group[i] then
    	        nextLv = i + pc.Lv
    	        break
    	    end
    	end

    	local tx = TxBegin(pc)
    	for j = 1,4, 2 do
            TxGiveItem(tx, reward[sObj.EVENT_VALUE_SOBJ02 + 1][j], reward[sObj.EVENT_VALUE_SOBJ02 + 1][j + 1], 'LEVELUP_REWARD_EV')
        end
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ01', nextLv)
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ02', sObj.EVENT_VALUE_SOBJ02 + 1)
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            SendAddOnMsg(pc, 'NOTICE_Dm_Clear', ScpArgMsg("LevelUp_Event_Desc01", "REWARD", sObj.EVENT_VALUE_SOBJ02), 5)
        end
	else -- fail
	    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("LevelUp_Event_Desc02", "NEXTLV", sObj.EVENT_VALUE_SOBJ01), 5)
	end
end

function SCR_USE_DAYQUEST_RAND(pc)
  local sObj = GetSessionObject(pc, 'ssn_klapeda')
  local attribute = {'Dark', 'Poison', 'Fire', 'Lightning', 'Ice', 'Earth'} -- EVENT_VALUE_SOBJ07
  local RaceType = {'Forester', 'Klaida', 'Widling', 'Paramune', 'Velnias'} -- EVENT_VALUE_SOBJ08
  
  ShowOkDlg(pc, ScpArgMsg('DayQuest_Rand_Desc01', 'RACE', ScpArgMsg(sObj.EVENT_STRING_SOBJ02), 'LV', sObj.EVENT_VALUE_SOBJ09), 1)
end

-- event transform scroll
function SCR_USE_EVENT_TRANSFORM_SCROLL(self, argObj, argstring, arg1, arg2)
    RunScript("SCR_USE_EVENT_TRANSFORM_PLAY", self)
end

function SCR_USE_EVENT_TRANSFORM_PLAY(self)
    local monlist = {
        57991, 58402, 58102, 58702, 41448
    }

    local monClsID = monlist[IMCRandom(1, 5)]

    local monClsName = GetClassString('Monster', monClsID, 'ClassName')
    local iesObj = CreateGCIES('Monster', monClsName);
	
	if iesObj == nil then
	    return;
	end
	
    if 1 == TransformToMonster(self, monClsName, 'Event_Transform_NoSave') then
		AddBuff(self, self, 'Event_Transform_NoSave', 1, 0, 600000, 1)
	end
end

function ACHIEVE_HAPPY2YEAR_STEAM(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Event_Happy2Year_Steam', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_PENGUINPACK_2018(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_011', 1, 'PENGUINPACK_2018');
    TxGiveItem(tx, 'food_penguin', 50, 'PENGUINPACK_2018');
    local ret = TxCommit(tx);
end

function SCR_USE_CROW_2018(pc, argObj, StringArg, Numarg1, Numarg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'egg_021', 1, 'PENGUINPACK_2018');
    TxGiveItem(tx, 'food_cereal', 50, 'PENGUINPACK_2018');
    local ret = TxCommit(tx);
end

function DLC_BOX_2YEARS(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'ABAND01_130', 1, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'egg_012', 1, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Event_Reinforce_100000coupon', 10, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Ability_Point_Stone', 1, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Event_Steam_2Years_Master_DLC', 1, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Drug_Premium_HP1', 20, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Drug_Premium_SP1', 20, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Event_drug_steam_1h_DLC', 10, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Event_Fire_Songpyeon', 5, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Event_Goddess_Statue_DLC', 5, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'Drug_Haste1_event', 5, 'DLC_BOX_2YEARS');
    TxGiveItem(tx, 'PremiumToken_15d_Steam', 1, 'DLC_BOX_2YEARS');
    local ret = TxCommit(tx);
end

function SCR_USE_EVENT_STEAM_2YEARS_WARP(pc)
    local aObj = GetAccountObj(pc);
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_2YEARS_DLG6',  ScpArgMsg("Cancel"), ScpArgMsg("Yes")) 

    if select == 2 then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'STEAM_2YEARS_MASTER_DLC_CHECK', 1);
        local ret = TxCommit(tx)
        if ret =="SUCCESS" then
            MoveZone(pc, 'c_Klaipe', 71.70, 149.21, 321.89);
        end
    end
end

function ACHIEVE_Steam_Honorary(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Event_Steam_Honorary', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_2YEARS_BOX(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'Hat_628313', 1, '2YEARS_PACKAGE');
    TxGiveItem(tx, 'Hat_628314', 1, '2YEARS_PACKAGE');
    TxGiveItem(tx, 'Hat_628315', 1, '2YEARS_PACKAGE');
    local ret = TxCommit(tx);
end

function SCR_USE_CS_IndunReset_GTower_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
    local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            local tx = TxBegin(self);
                if pcetc.InDunCountType_400 > 0 then	
                    TxSetIESProp(tx, pcetc, 'InDunCountType_400', pcetc.InDunCountType_400 - 1);
                end
                if pcetc.IndunWeeklyEnteredCount_400 > 0 then
                    TxSetIESProp(tx, pcetc, 'IndunWeeklyEnteredCount_400', pcetc.IndunWeeklyEnteredCount_400 - 1);
                end
            local ret = TxCommit(tx);	
            if ret == 'SUCCESS' then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_IndunReset_GTower_1_MSG1"), 10)
            end
        end
    end
end

function ACHIEVE_Steam_Magazine_Num1(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'EVENT_Steam_Magazine_Num1', 1)
    local ret = TxCommit(tx);
end

function Achieve_Event_Grand_Contributor(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Achieve_Event_Grand_Contributor', 1)
    local ret = TxCommit(tx);
end

function Achieve_Event_Fashionista(pc)
    local tx = TxBegin(pc);
    TxAddAchievePoint(tx, 'Achieve_Event_Fashionista', 1)
    local ret = TxCommit(tx);
end

function SCR_USE_DIAMOND_MOUR_BOX_GIVE_ITEM(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, arg1, arg2, 'DIAMOND_MOUR_BOX_S_GIVE_COUNT'..arg2);
    local ret = TxCommit(tx);
end

function SCR_USE_ABILITY_POINT_BOX1_BOX_GIVE_ITEM(pc, string1, arg1, arg2)
    local tx = TxBegin(pc);
    TxGiveItem(tx, arg1, arg2, 'ABILITY_POINT_BOX1_BOX_S_GIVE_COUNT'..arg2);
    local ret = TxCommit(tx);
end