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