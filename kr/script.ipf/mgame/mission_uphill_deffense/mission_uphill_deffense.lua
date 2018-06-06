--function SCR_UPHILL_BOSS_GEN_CHECK(pc)
----    local cmd = GetMGameCmd(pc)
----    if cmd ~= nil then
----    	local rand = cmd:GetUserValue("UphillBossRandom1")
----    	if rand <= 100 then
----    	    local genStep = cmd:GetUserValue("UphillBossStep1")
----    	    local genLine = cmd:GetUserValue("UphillBossLine1")
----    	    ChatLocal(pc,pc, 'Boss Gen Setp : '..genStep..' Gen Line : '..genLine, 10)
----    	else
----    	    ChatLocal(pc,pc, 'Boss Gen : No! 100 >= '..rand..' : False', 10)
----    	end
----    end
--end

function SCR_MISSION_UPHILL_STEP_REWARD_DIALOG(self, pc)
    if self.StrArg1 == 'OPEN' then
        return
    end
    local rewardList = {
                        {{{'Drug_HP2',1}},{{'Drug_SP2',1}}},
                        {{{'Drug_HP2',2}},{{'Drug_SP2',2}}},
                        {{{'Drug_HP3',2},{'Drug_SP3',1}},{{'Drug_HP3',1},{'Drug_SP3',2}}},
                        {{{'Drug_HP4',1},{'Drug_SP4',1},{'Drug_HP3',1}},{{'Drug_HP4',1},{'Drug_SP4',1},{'Drug_SP3',1}}},
                        {{{'Drug_HP4',1},{'Drug_SP4',1},{'Drug_HP3',1}},{{'Drug_HP4',1},{'Drug_SP4',1},{'Drug_SP3',1}}},
                        {{{'expCard7',1}}},
                        {{{'card_Xpupkit01_100',1},{'Drug_HP3',3}},{{'card_Xpupkit01_100',1},{'Drug_SP3',3}}},
                        {{{'misc_gemExpStone_randomQuest1',1},{'Gacha_G_014',1}}},
                        {{{'Uphill_Store_Point_10', 1}}},
                        {{{'expCard7',2},{'Drug_HP5',1},{'Drug_SP5',1},{'Drug_HP4',1}},{{'expCard7',2},{'Drug_HP5',1},{'Drug_SP5',1},{'Drug_SP4',1}}},
                        {{{'Drug_HP5',1},{'Drug_SP5',1},{'Drug_HP4',1}},{{'Drug_HP5',1},{'Drug_SP5',1},{'Drug_SP4',1}}},
                        {{{'Drug_PvP_MSPD3',2},{'Drug_HP5',1}},{{'Drug_PvP_MSPD3',2},{'Drug_SP5',1}}},
                        {{{'Gacha_G_014',1},{'Drug_HP5',1}},{{'Gacha_G_014',1},{'Drug_SP5',1}}},
                        {{{'GIMMICK_Drug_HPSP1',2}}},
                        {{{'card_Xpupkit01_100',1},{'expCard8',1},{'expCard7',1}}},
                        {{{'misc_gemExpStone_randomQuest2',1}}},
                        {{{'Drug_Looting_Potion_100',1}}},
                        {{{'Uphill_Store_Point_10',1}}},
                        {{{'Gacha_G_014',1}}},
                        {{{'GIMMICK_Drug_HPSP1',3},{'expCard8',1},{'expCard7',1}}},
                        {{{'misc_gemExpStone_randomQuest3',1}}},
                        {{{'GIMMICK_Drug_HPSP2',2}}},
                        {{{'card_Xpupkit01_100',1}}},
                        {{{'GIMMICK_Drug_HPSP2',3},{'Gacha_G_014',1}}},
                        {{{'Drug_Looting_Potion_100',1},{'expCard8',2},{'expCard7',2}}},
                        {{{'GIMMICK_Drug_PMATK2',1},{'GIMMICK_Drug_HPSP3',1}},{{'GIMMICK_Drug_Restore01',1},{'GIMMICK_Drug_HPSP3',1}},{{'GIMMICK_Drug_PMDEF2',1},{'GIMMICK_Drug_HPSP3',1}}},
                        {{{'Uphill_Store_Point_10',1}}},
                        {{{'GIMMICK_Drug_HPSP3',2},{'Gacha_G_014',1}}},
                        {{{'misc_gemExpStone_randomQuest4',1}}},
                        {{{'expCard9',2},{'Gem_Gacha_gold_coin',1}}}
                        }
    local cmd = GetMGameCmd(self)
    if cmd ~= nil then
    	local step = cmd:GetUserValue("UphillStep") - 1
    	local zoneID = GetZoneInstID(self)
    	local list, cnt = GetLayerPCList(self)
    	if cnt > 0 then
    	    for i = 1, cnt do
    	        local text
    	        local give_list
    	        local rand = IMCRandom(1,#rewardList[step])
    	        for x = 1, #rewardList[step][rand] do
    	            local giveItemKOR = GetClassString('Item', rewardList[step][rand][x][1],'Name')
    	            if give_list == nil then
    	                give_list = rewardList[step][rand][x][1]..'/'..rewardList[step][rand][x][2]
    	                text = giveItemKOR..' '..ScpArgMsg('MISSION_UPHILL_MSG11','COUNT',rewardList[step][rand][x][2])
    	            else
    	                give_list = give_list..'/'..rewardList[step][rand][x][1]..'/'..rewardList[step][rand][x][2]
    	                text = text..'{nl}'..giveItemKOR..' '..ScpArgMsg('MISSION_UPHILL_MSG11','COUNT',rewardList[step][rand][x][2])
    	            end
    	        end
    	        
    	        if give_list ~= nil then
    	            PauseItemGetPacket(list[i])
        	        local ret = GIVE_TAKE_SOBJ_ACHIEVE_TX(list[i], give_list, nil, nil, nil, "MISSION_UPHILL_STEP_REWARD")
        	        if ret == 'SUCCESS' then
        	            self.StrArg1 = 'OPEN'
        	            SendAddOnMsg(list[i], 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_STEP_REWARD_ITEMLIST',"STEP",step,"TEXT",text), 10)
        	        end
        	    end
    	    end
    	    PlayAnim(self, 'OPEN', 1);
        	sleep(3000);
        	for i = 1, cnt do
        	    if list[i] ~= nil then
            	    ResumeItemGetPacket(list[i]);
            	end
        	end
    	end
    end
    Kill(self)
end

function SCR_MISSION_UPHILL_GIMMICKOBJ1_DIALOG(self,pc)
    local result = DOTIMEACTION_R_FAILTIME_SET(pc, 'MISSION_UPHILL_MSG1', ScpArgMsg('MISSION_UPHILL_MSG1'), 1.5, 'ABSORB', nil)
    if result == 1 then
        GIVE_ITEM_TX(pc,'MISSION_UPHILL_GIMMICK_ITEM1',1, 'MISSION_UPHILL')
        PlaySound(pc, 'mission_notice_1')
        PlayEffect(self, 'F_archer_ConcentratedFire_hit', 1, 1, 'MID')
        local count = GetInvItemCount(pc, 'MISSION_UPHILL_GIMMICK_ITEM1')
        SendAddOnMsg(pc, 'NOTICE_Dm_GetItem',ScpArgMsg('MISSION_UPHILL_MSG12',"COUNT",count), 10)
        sleep(100)
        Kill(self)
    end
end

function SCR_MISSION_UPHILL_DEFFENSEOBJ1_DIALOG(self,pc)
    local itemCount = GetInvItemCount(pc, 'MISSION_UPHILL_GIMMICK_ITEM1')
    local takeItemCount1 = 20
    local takeItemCount2 = 10
    local takeItemCount3 = 2
    local takeItemCount4 = 15
    local takeItemCount5 = 2
    if itemCount > 0 then
        local select = ShowSelDlg(pc, 0 , 'MISSION_UPHILL_DLG1' ,ScpArgMsg('MISSION_UPHILL_SEL1','COUNT',takeItemCount1), ScpArgMsg('MISSION_UPHILL_SEL2','COUNT',takeItemCount2), ScpArgMsg('MISSION_UPHILL_SEL3','COUNT',takeItemCount3), ScpArgMsg('MISSION_UPHILL_SEL4','COUNT',takeItemCount4), ScpArgMsg('MISSION_UPHILL_SEL5','COUNT',takeItemCount5), ScpArgMsg('Close'))
        if select == 1 then
            if itemCount < takeItemCount1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG2',"TAKE",takeItemCount1,"CURR",itemCount), 8)
                return
            end
            
            local monList, monCount = SelectObject(self, 300, 'ALL', 1)
            
            if monCount == nil or monCount < 1 then
                return
            end
            
            local deffenseObj
            for i = 1, monCount do
                if monList[i].ClassName == 'npc_zachariel_lantern_2' and GetCurrentFaction(monList[i]) == 'FreeForAll' then
                    deffenseObj = monList[i]
                end
            end
            
            if deffenseObj == nil then
                return
            end
            if deffenseObj.HP / deffenseObj.MHP >= 0.8 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG5'), 8)
                return
            end
            AddHP(deffenseObj, deffenseObj.MHP)
            TAKE_ITEM_TX(pc, 'MISSION_UPHILL_GIMMICK_ITEM1', takeItemCount1, 'MISSION_UPHILL_ADDHP')
            PlaySound(pc, 'mission_notice_1')
            SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG4'), 8)
        elseif select == 2 then
            if itemCount < takeItemCount2 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG2',"TAKE",takeItemCount2,"CURR",itemCount), 8)
                return
            end
            
            local webObj = {}
            local nilCount = 0
            for i = 1, 6 do
                webObj[i] = GetExArgObject(self, 'WEB'..i)
                if webObj[i] == nil then
                    nilCount = nilCount + 1
                end
            end
            
            if nilCount == 0 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG6'), 8)
                return 
            end
            
            
            local npc1_1 = CREATE_NPC(self, "HiddenTrigger5", -616, -127, -177, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc1_1 ~= nil then
                AttachEffect(npc1_1, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc1_1, 120)
                npc1_1.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc1_1)
                SetExArgObject(self, 'WEB1', npc1_1)
            end
            local npc1_2 = CREATE_NPC(self, "HiddenTrigger5", -218, -6, -108, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc1_2 ~= nil then
                AttachEffect(npc1_2, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc1_2, 120)
                npc1_2.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc1_2)
                SetExArgObject(self, 'WEB2', npc1_2)
            end
            
            local npc2_1 = CREATE_NPC(self, "HiddenTrigger5", -334, -91, 254, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc2_1 ~= nil then
                AttachEffect(npc2_1, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc2_1, 120)
                npc2_1.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc2_1)
                SetExArgObject(self, 'WEB3', npc2_1)
            end
            local npc2_2 = CREATE_NPC(self, "HiddenTrigger5", 62, 6, 304, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc2_2 ~= nil then
                AttachEffect(npc2_2, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc2_2, 120)
                npc2_2.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc2_2)
                SetExArgObject(self, 'WEB4', npc2_2)
            end
            
            local npc3_1 = CREATE_NPC(self, "HiddenTrigger5", 273, -95, 456, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc3_1 ~= nil then
                AttachEffect(npc3_1, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc3_1, 120)
                npc3_1.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc3_1)
                SetExArgObject(self, 'WEB5', npc3_1)
            end
            local npc3_2 = CREATE_NPC(self, "HiddenTrigger5", 213, 14, 214, 0, "Neutral", GetLayer(self), 'UnVisibleName', nil, 'MISSION_UPHILL_WEB', 60)
            if npc3_2 ~= nil then
                AttachEffect(npc3_2, 'F_pattern014_ground_red_loop', 8, 'BOT')
                SetLifeTime(npc3_2, 120)
                npc3_2.OnlyPCCheck = "NO"
                EnableAIOutOfPC(npc3_2)
                SetExArgObject(self, 'WEB6', npc3_2)
            end
            
            if npc1_1 ~= nil or npc1_2 ~= nil or npc2_1 ~= nil or npc2_2 ~= nil or npc3_1 ~= nil or npc3_2 ~= nil then
                TAKE_ITEM_TX(pc, 'MISSION_UPHILL_GIMMICK_ITEM1', takeItemCount2, 'MISSION_UPHILL_MSPD')
                PlaySound(pc, 'mission_notice_1')
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG3'), 10)
            end
        elseif select == 3 then
            if itemCount < takeItemCount3 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG2',"TAKE",takeItemCount3,"CURR",itemCount), 8)
                return
            end
            local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
            if cnt == nil or cnt <= 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG7'), 10)
                return
            end
            local selectList = {}
            local setPosPCList = {}
            for i = 1, cnt do
                if IsSameActor(pcList[i], pc) == 'NO' then
                    selectList[#selectList + 1] = pcList[i].Name
                    setPosPCList[#setPosPCList + 1] = pcList[i]
                end
            end
            local select2 = SCR_SEL_LIST(pc,selectList, 'MISSION_UPHILL_DLG2')
            if select2 ~= nil and select2 <= #selectList and setPosPCList[select2] ~= nil then
                TAKE_ITEM_TX(pc, 'MISSION_UPHILL_GIMMICK_ITEM1', takeItemCount3, 'MISSION_UPHILL_CALLPC')
                PlaySound(pc, 'mission_notice_1')
                SendAddOnMsg(setPosPCList[select2], 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG8','CALLPC',pc.Name), 10)
                sleep(4000)
                PlayAnim(setPosPCList[select2],'WARP')
                sleep(1000)
                local x,y,z = GetPos(self)
                SetPos(setPosPCList[select2], x,y+40,z+20)
                PlayAnim(setPosPCList[select2],'WARP_RIDE')
            end
        
        elseif select == 4 then
            if itemCount < takeItemCount4 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG2',"TAKE",takeItemCount4,"CURR",itemCount), 8)
                return
            end
            
            local monList, monCount = GetLayerMonList(GetZoneInstID(pc), GetLayer(pc))
            
            if monCount == nil or monCount < 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG9'), 10)
                return
            end
            TAKE_ITEM_TX(pc, 'MISSION_UPHILL_GIMMICK_ITEM1', takeItemCount4, 'MISSION_UPHILL_HOLD')
            PlaySound(pc, 'mission_notice_1')
            for i = 1, monCount do
                if monList[i].ClassName ~= 'PC' and GetCurrentFaction(monList[i]) == 'Monster' then
                    AddBuff(self, monList[i], 'MISSION_UPHILL_GIMMICK_BUFF2', 1, 0, 30000, 1)
                end
            end
        elseif select == 5 then
            if itemCount < takeItemCount5 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG2',"TAKE",takeItemCount3,"CURR",itemCount), 8)
                return
            end
            local pcList, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
            if cnt == nil or cnt <= 1 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('MISSION_UPHILL_MSG10'), 10)
                return
            end
            local selectList = {}
            local setPosPCList = {}
            for i = 1, cnt do
                if IsSameActor(pcList[i], pc) == 'NO' then
                    selectList[#selectList + 1] = pcList[i].Name
                    setPosPCList[#setPosPCList + 1] = pcList[i]
                end
            end
            local select2 = SCR_SEL_LIST(pc,selectList, 'MISSION_UPHILL_DLG3')
            if select2 ~= nil and select2 <= #selectList and setPosPCList[select2] ~= nil then
                TAKE_ITEM_TX(pc, 'MISSION_UPHILL_GIMMICK_ITEM1', takeItemCount5, 'MISSION_UPHILL_GOPC')
                PlaySound(pc, 'mission_notice_1')
                sleep(500)
                PlayAnim(pc,'WARP')
                sleep(1000)
                local x,y,z = GetPos(setPosPCList[select2])
                SetPos(pc, x,y+40,z)
                PlayAnim(pc,'WARP_RIDE')
            end
        
        end
    end
end

function SCR_MISSION_UPHILL_WEB_ENTER(self,mon)
    if mon.ClassName ~= 'PC' then
        local faction = GetCurrentFaction(mon)
        if faction == 'Monster' then
            AddBuff(self, mon, 'MISSION_UPHILL_GIMMICK_BUFF1', 1, 0, 60000, 1)
        end
    end
end


UPHILL_ELITE_LIST = {'arburn_pokubu_green',
                     'Beetle_Elite',
                     'Big_Cockatries',
                     'Big_Cockatries_green',
                     'Big_Cockatries_red',
                     'Big_Siaulamb',
                     'Cire_mage',
                     'Egnome',
                     'Egnome_yellow',
                     'FD_Bat_big',
                     'FD_Firent_yellow',
                     'FD_Glizardon',
                     'FD_spectra',
                     'Firent',
                     'Galok',
                     'Glizardon',
                     'GoblinWarrior',
                     'GoblinWarrior_blue',
                     'Gravegolem_blue',
                     'Harugal',
                     'Harugal_blue',
                     'Harugal_brown',
                     'Hohen_gulak',
                     'Hohen_gulak_blue',
                     'Hohen_orben',
                     'Hohen_orben_green',
                     'Hohen_orben_red',
                     'honeymeli',
                     'Mentiwood',
                     'minivern_Elite',
                     'mushroom_ent_blue',
                     'mushroom_ent_green',
                     'mushroom_ent_red',
                     'Onion_Red_elite',
                     'Onion_Red_elite',
                     'panto_javelin_elite',
                     'panto_javelin_Gele',
                     'Pendinmire',
                     'pendinmire_paviesa',
                     'pumpflap',
                     'Rubabos_red',
                     'schlesien_heavycavarly',
                     'Siaulogre',
                     'slime_elite_Big',
                     'Upent',
                     'warleader_hogma',
                     'wood_lwa',
                     'zinutekas_Elite'
                     }
UPHILL_SPECIAL_LIST = {'Burialer',
                     'Candlespider_blue',
                     'Candlespider_yellow',
                     'Colifly_black',
                     'Colifly_bow_black',
                     'colimen_blue',
                     'Cronewt',
                     'Cronewt_blue',
                     'Cronewt_bow_blue',
                     'Cronewt_mage_blue',
                     'Deadbornscab_red',
                     'defender_spider_red',
                     'dimmer',
                     'Dumaro_yellow',
                     'Elet_blue',
                     'ellogua',
                     'Elma_blue',
                     'Elma_red',
                     'FD_Fire_Dragon',
                     'FD_InfroRocktor_red',
                     'FD_Long_Arm',
                     'FD_NightMaiden',
                     'Fire_Dragon',
                     'Fisherman_blue',
                     'goblin2_hammer',
                     'goblin2_sword',
                     'goblin2_wand1',
                     'groll_white',
                     'hohen_barkle_blue',
                     'Hohen_mage_blue',
                     'Hohen_mane_purple',
                     'InfroRocktor_red',
                     'jellyfish_green',
                     'Kepari_purple',
                     'lapasape_blue',
                     'lapasape_bow',
                     'lapasape_mage_blue',
                     'Lapeman',
                     'Lizardman_mage',
                     'Lizardman_orange',
                     'Meleech',
                     'minos_bow_green',
                     'Minos_green',
                     'Minos_orange',
                     'NightMaiden_bow_red',
                     'NightMaiden_mage_red',
                     'Nuka_blue',
                     'Nuka_brown',
                     'nuo_purple',
                     'nuo_red',
                     'pappus_kepa_purple',
                     'Pawndel_blue',
                     'Prisonfighter',
                     'puragi_red',
                     'pyran_green',
                     'raider',
                     'Rambear_brown',
                     'Rambear_mage_brown',
                     'Repusbunny',
                     'Repusbunny_bow_purple',
                     'Repusbunny_red',
                     'Sakmoli_purple',
                     'saltisdaughter_bow',
                     'saltisdaughter_green',
                     'slime_elite',
                     'Socket_bow_purple',
                     'Socket_green',
                     'Socket_mage_green',
                     'Socket_mage_red',
                     'Socket_purple',
                     'Spion_bow_red',
                     'Spion_mage_white',
                     'Spion_red',
                     'Spion_white',
                     'Stoulet_blue',
                     'Stoulet_gray',
                     'Templeslave_blue',
                     'Templeslave_mage_blue',
                     'Templeslave_sword_blue',
                     'TerraNymph_blue',
                     'TerraNymph_mage_blue',
                     'ticen_blue',
                     'ticen_bow_red',
                     'ticen_mage',
                     'ticen_mage_blue',
                     'ticen_mage_red',
                     'ticen_red',
                     'Tiny_blue',
                     'Tiny_brown',
                     'tree_root_mole_pink',
                     'truffle_red',
                     'velffigy_green',
                     'Wendigo_archer',
                     'Wendigo_archer_blue',
                     'Wendigo_archer_gray',
                     'Wendigo_magician_blue'
                     }
UPHILL_NORMAL_LIST = {'Ammon',
                     'anchor',
                     'anchor_mage',
                     'arma',
                     'Armory',
                     'Ashrong',
                     'banshee',
                     'Bat',
                     'Bavon',
                     'beeterineas',
                     'Beeteros',
                     'beeteros_blue',
                     'beeteroxia',
                     'Beetle',
                     'beeto',
                     'Beetow',
                     'belegg',
                     'blindlem',
                     'Bokchoy',
                     'bubbe_mage_normal',
                     'bubbe_mage_priest',
                     'bushspider',
                     'Carcashu',
                     'Carcashu_green',
                     'Caro',
                     'Chafperor',
                     'Chafperor_mage',
                     'Chafperor_mage_purple',
                     'Chafperor_purple',
                     'charcoal_walker',
                     'charog',
                     'Chromadog',
                     'Chupacabra_Blue',
                     'chupacabra_desert',
                     'chupacabra_green',
                     'chupaluka',
                     'Chupaluka_pink',
                     'Cockatries',
                     'Colifly',
                     'Colifly_bow',
                     'Colifly_bow_purple',
                     'Colifly_mage_black',
                     'Colifly_yellow',
                     'colimen_brown',
                     'colimen_mage_brown',
                     'colitile',
                     'Conuts',
                     'Corylus',
                     'Crocoman',
                     'Cronewt_bow',
                     'Cronewt_bow_brown',
                     'Cronewt_mage',
                     'Dandel',
                     'dandel_orange',
                     'dandel_white',
                     'Deadbornscab_bow',
                     'Deadbornscab_bow_green',
                     'Deadbornscab_green',
                     'Deadbornscab_mage',
                     'Deadbornscab_mage_red',
                     'defender_spider',
                     'defender_spider_blue',
                     'Denden',
                     'digo',
                     'dog_of_king',
                     'Doyor',
                     'duckey',
                     'Dumaro',
                     'Dumaro_blue',
                     'Echad',
                     'Echad_bow',
                     'eldigo',
                     'eldigo_green',
                     'Elet',
                     'ellom',
                     'ellom_violet',
                     'ellomago',
                     'Elma',
                     'FD_blindlem',
                     'FD_blok_archer',
                     'FD_blok_wizard',
                     'FD_bubbe_chaser',
                     'FD_bubbe_fighter',
                     'FD_bubbe_mage_fire',
                     'FD_bubbe_mage_ice',
                     'FD_Bushspider_purple',
                     'FD_Candlespider',
                     'FD_Chromadog',
                     'FD_colimen',
                     'FD_colimen_mage',
                     'FD_Corylus',
                     'FD_Deadbornscab',
                     'FD_Fire_Dragon_purple',
                     'FD_Flak',
                     'FD_Flamag',
                     'FD_Flamil',
                     'FD_Flamme_archer',
                     'FD_Flamme_mage',
                     'FD_Flamme_priest',
                     'FD_Goblin_Archer_red',
                     'FD_Hallowventor',
                     'FD_Infrogalas_bow',
                     'FD_kenol',
                     'FD_Leaf_diving_purple',
                     'FD_maggot',
                     'FD_minos_mage',
                     'FD_Mushcarfung',
                     'FD_pappus_kepa_purple',
                     'FD_pawnd',
                     'FD_Pawndel',
                     'FD_pyran',
                     'FD_raffly_blue',
                     'FD_Shredded',
                     'FD_Spector_gh_purple',
                     'FD_Stoulet_mage',
                     'FD_Stoulet_mage_blue',
                     'FD_Stoulet_mage_green',
                     'FD_TerraNymph',
                     'FD_TerraNymph_bow',
                     'FD_tower_of_firepuppet',
                     'FD_tower_of_firepuppet_black',
                     'FD_woodgoblin_black',
                     'FD_Yognome',
                     'FD_Yognome_Sec',
                     'ferret_archer',
                     'ferret_bearer_elite',
                     'ferret_folk',
                     'ferret_loader',
                     'ferret_patter',
                     'ferret_searcher',
                     'ferret_slinger',
                     'ferret_vendor',
                     'Ferrot',
                     'Fire_Dragon_purple',
                     'Fisherman',
                     'Fisherman_green',
                     'Fisherman_red',
                     'flask',
                     'flask_blue',
                     'Flask_mage',
                     'flight_hope',
                     'Flying_Flog',
                     'Flying_Flog_green',
                     'Flying_Flog_white',
                     'Folibu',
                     'Gazing_Golem_yellow',
                     'Geppetto',
                     'geppetto_white',
                     'GlyphRing',
                     'Goblin_Archer',
                     'Goblin_Miners',
                     'Goblin_Miners_Blue',
                     'Goblin_Miners_Q1',
                     'Goblin_Spear',
                     'Goblin_Spear_blue',
                     'goblin2_wand3',
                     'Gosaru',
                     'Gravegolem',
                     'Greentoshell',
                     'groll',
                     'Grummer',
                     'Hallowventor',
                     'Hallowventor_bow',
                     'Hallowventor_mage',
                     'haming_orange',
                     'Hanaming',
                     'HighBube_Archer',
                     'HighBube_Spear',
                     'hogma_archer',
                     'Hogma_combat',
                     'Hogma_guard',
                     'hogma_sorcerer',
                     'hogma_warrior',
                     'hohen_barkle',
                     'hohen_barkle_green',
                     'Hohen_mage',
                     'Hohen_mage_red',
                     'Hohen_mane',
                     'Hohen_mane_brown',
                     'Hohen_ritter',
                     'Hohen_ritter_green',
                     'Hohen_ritter_purple',
                     'honey_bee',
                     'Honeybean',
                     'hook',
                     'hook_old',
                     'Humming_bud',
                     'humming_bud_purple',
                     'infro_Blud',
                     'Infro_blud_red',
                     'InfroBurk',
                     'Infrogalas_mage',
                     'InfroHoglan',
                     'InfroHoglan_red',
                     'Infroholder',
                     'Infroholder_bow',
                     'Infroholder_bow_red',
                     'Infroholder_green',
                     'Infroholder_mage',
                     'Infroholder_mage_green'
                     }
UPHILL_BOSS_LIST = {'M_boss_Gorgon',
                     'M_boss_Golem_gray',
                     'M_boss_Carapace',
                     'M_boss_Strongholder',
                     'M_boss_stone_whale',
                     'M_boss_salamander',
                     'M_boss_werewolf',
                     'M_boss_Sequoia_blue',
                     'M_boss_ShadowGaoler',
                     'M_boss_Devilglove',
                     'M_boss_Rocktortuga',
                     'M_boss_necrovanter',
                     'M_boss_NetherBovine',
                     'M_boss_yonazolem',
                     'M_boss_Throneweaver'
                     }


UPHILL_GIMMICK_MONSTER_LIST = {"Lapemiter_uphill", "Lapezard_uphill", "Lapflammer_uphill"}




--Gimmick Monster




function SCR_UPHILL_GIMMICK_MONSTER_AI(self)
    PlayEffect(self, "F_lineup022_blue", 3, 0, "BOT", 1)
    
    if self.NumArg2 ~= 2 then -- if that monster don't blink then
        ObjectBlinkEndlessly(self, "FFFFF400", "FFFFFFFF", 1) -- apply to blink that monster
        self.NumArg2 = 2
    end
    
    local gimmickSetting = self.ClassName
    if gimmickSetting == "Lapemiter_uphill" then -- if that monster is self-destruction type then
    
        local owner = GetOwner(self) -- find devine torches
        if owner ~= nil then -- if that monster find devine torches
            MoveToTarget(self, owner, 5) -- go to target
            local distance = GetActorDistance(self, owner) -- distance check
            if distance <= 5 then -- if distance is under 5
                local aiName = GetSimpleAIName(self)
                ClearSimpleAI(self, aiName)
                self.SimpleAI = "None"
                local objectDamage = owner.MHP_BM
                objectDamage = math.floor(objectDamage*0.1)
                TakeDamage(self, owner, "None", objectDamage, "Melee", "None", "AbsoluteDamage") -- damage devince torches
            	local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
            	if pcCount ~= nil and pcCount ~= 0 then
            	    for k = 1, pcCount do
            	        if IsDummyPC(pcList[k]) == 0 then
            	            SendAddOnMsg(pcList[k], "NOTICE_Dm_!", ScpArgMsg("UPHILL_DEFFENSE_SELF_DESTRUCTION_ACTIVE"), 3)
            	            CameraShockWave(pcList[k], 2, 99999, 2, 2, 100, 0)
            	        end
            	    end
            	end
            	PlayEffect(self, "F_archer_turret_hit_explosion", 1, 0, "BOT")
                Dead(self) -- and dead that monster
            end
            
        elseif owner == nil then -- if that monster don't find devine torches
            local objectList, objectCount = GetWorldObjectList(self, "MON", 200) -- search devine torches
            if objectCount ~= nil and objectCount ~= 0 then
                for i = 1, objectCount do
                    if objectList[i].ClassName == "npc_zachariel_lantern_2" then -- if that monster find devine torches
                        SetOwner(self, objectList[i], 0) -- target to self-destruction
                    end
                end
            end
        end
        
    elseif gimmickSetting == "Lapezard_uphill" then -- if that monster is healer type then
        self.NumArg1 = self.NumArg1 +1 -- check heal time
        if self.NumArg1 >= 8 then -- if 4 seconds over
            local objectList, objectCount = SelectObjectNear(self, self, 100, "Monster") -- check around monsters
            if objectCount ~= nil and objectCount ~= 0 then
                if objectCount >= 10 then -- a number of monster are over 10 that
                    objectCount = 10 -- healing limit 10 monster
                end
                
                local healList = {}
                local healListIndex = 0
                for i = 1, objectCount do
                    if objectList[i].ClassName ~= self.ClassName and objectList[i].ClassName ~= "PC" then -- if that monster is not self then 
                        if objectList[i].Faction == "Monster" then
                            local needHealCheck = objectList[i].MHP
                            if needHealCheck > objectList[i].HP then -- if that monster is damaged by user then
                                healListIndex = healListIndex +1
                                healList[healListIndex] = objectList[i] -- add heal List
                            end
                        end
                    end
                end
                
                if #healList ~= 0 then -- if a number of need heal monster isn't 0 then
                    PlayAnim(self, 'skl') -- doing skill animation
                    for j = 1, #healList do
                        local healAmount = healList[j].MHP
                        healAmount = math.floor(healAmount*0.1)
                        Heal(healList[j], healAmount, 0) -- heal that monster
                    end
                end
            end
            self.NumArg1 = 0 -- and time reset.
        end
        
    elseif gimmickSetting == "Lapflammer_uphill" then -- if that monster is long distance attack monster then

        if self.ATKRate == 100 then
            self.ATKRate = 300
        end
        
        local targetList, targetCount = GetWorldObjectList(self, "MON", 150) -- search devine torches
        if targetCount ~= nil and targetCount ~= 0 then
            for i = 1, targetCount do
                if targetList[i].ClassName == "npc_zachariel_lantern_2" then -- if that monster find devine torches
                    if self.NumArg4 ~= 2 then -- if that monster isn't have hate from devine torches
                        self.NumArg4 = 2
                        InsertHate(self, targetList[i], 9999) --insert hate target to that monster
                    end
                end
            end
        end
    end
    return
    
end


function SCR_UPHILL_DEFFENSE_SCRIPT_SETTING(self) -- Setting Boss and Monster's Stat
    local zoneObject = GetLayerObject(self)
    local difficultyLevel = math.floor(GetExProp(zoneObject, "MaxLv"))
    
    if self.StrArg1 == "UpHillBoss" then
        SetDeadScript(self, "SCR_UPHILL_BOSS_GIVE_ACHIEVE")
    	self.Journal = "None"
    	self.DropItemList = "None"
    	self.Boss_UseZone = "None"
    end
    
    if difficultyLevel <= 170 then
    	self.MHP = math.floor(self.MHP*0.925)
    	self.DEF = math.floor(self.DEF*0.70)
    	self.MDEF = math.floor(self.MDEF*0.70)
    elseif difficultyLevel <= 220 then
    	self.MHP = math.floor(self.MHP*0.95)
    	self.DEF = math.floor(self.DEF*0.80)
    	self.MDEF = math.floor(self.MDEF*0.80)
    elseif difficultyLevel <= 270 then
    	self.MHP = math.floor(self.MHP*0.975)
    	self.DEF = math.floor(self.DEF*0.90)
    	self.MDEF = math.floor(self.MDEF*0.90)
    elseif difficultyLevel >= 315 then
    	self.MHP = math.floor(self.MHP*1.00)
    	self.DEF = math.floor(self.DEF*1.00)
    	self.MDEF = math.floor(self.MDEF*1.00)
    elseif difficultyLevel <= 350 then
    	self.MHP = math.floor(self.MHP*1.05)
    	self.DEF = math.floor(self.DEF*1.10)
    	self.MDEF = math.floor(self.MDEF*1.10)
    elseif difficultyLevel > 350 then
    	self.MHP = math.floor(self.MHP*1.10)
    	self.DEF = math.floor(self.DEF*1.20)
    	self.MDEF = math.floor(self.MDEF*1.20)
    end
end



function SCR_UPHILL_BOSS_GIVE_ACHIEVE(self)
	local cmd = GetMGameCmd(self)

	if cmd ~= nil then
	    local bossKillBonus = cmd:GetUserValue("bossKillBonus")
	    bossKillBonus = bossKillBonus +10
	    cmd:SetUserValue("bossKillBonus", bossKillBonus)
	end

    local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
    if pcCount ~= nil then
        for i = 1, pcCount do
            if IsDummyPC(pcList[i]) == 0 then
                AddAchievePoint(pcList[i], 'UPHILL_DEFFENSE_BOSSKILL', 1)
            end
        end
    end
end


function SCR_UPHILL_END_GIVE_ACHIEVE(self)
    if IsDummyPC(self) == 0 then
        AddAchievePoint(self, 'UPHILL_DEFFENSE_PROGRESS', 1)
    end
end



function CHEAT_TIME_BONUS_CHECK(self)
    local timeBonusCheck = GetMGameValue(self, "RANKING_BONUS")
    local bossBonusCheck = GetMGameValue(self, "bossKillBonus")
    local totalBonusCheck = timeBonusCheck + bossBonusCheck
    SendAddOnMsg(self, 'NOTICE_Dm_Clear',"Time Attack Bonus : "..timeBonusCheck.." / ".."Boss Kill Bouns : "..bossBonusCheck.." / ".."Total Bonus : "..totalBonusCheck, 5)
end