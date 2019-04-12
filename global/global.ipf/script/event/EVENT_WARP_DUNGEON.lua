function SCR_USE_ITEM_Dungeon_Lv50(self) --Indun_Chaple
    MoveZone(self, 'f_gele_57_4', 1180.28, -78.24, 1899.31);
end

function SCR_USE_ITEM_Dungeon_Lv80(self) --Indun_Remains
    MoveZone(self, 'f_rokas_31', 465.12, 107.20, -104.48);
end

function SCR_USE_ITEM_Dungeon_Lv100(self)
    MoveZone(self, 'c_request_1', -52.76, 0.35, -38.66);
end

function SCR_USE_ITEM_Dungeon_Lv100_2(self) --d_limestonecave_73_1
    MoveZone(self, 'f_orchard_32_4', -1669.46, 73.62, -863.73);
end

function SCR_USE_ITEM_Dungeon_Lv110(self) --Indun_Remains3
    MoveZone(self, 'f_remains_40', 3185.22, 645.84, 2686.16);
end

function SCR_USE_ITEM_Dungeon_Lv120(self) --c_nunnery
    MoveZone(self, 'c_nunnery', 160.35, -75.75, -89.13);
end

function SCR_USE_ITEM_Dungeon_Lv140(self) --Indun_startower
    MoveZone(self, 'f_pilgrimroad_51', 1272.88, 571.24, 2058.53);
end

function SCR_USE_ITEM_Dungeon_Lv150(self) --d_prison_75_1
    MoveZone(self, 'f_siauliai_50_1', -39.05, 0.31, -1825.53);
end

function SCR_USE_ITEM_Dungeon_Lv170(self) --Indun_thorn2
    MoveZone(self, 'f_pilgrimroad_51', 1204.79, 571.24, 1884.27);
end

function SCR_USE_ITEM_Dungeon_Lv170_2(self) --d_startower_76_1
    MoveZone(self, 'f_siauliai_46_4', 1188.81, 188.67, -294.57);
end

function SCR_USE_ITEM_Dungeon_Lv190(self) --d_velniasprison_77_1
    MoveZone(self, 'f_flash_61', -749.41, 449.08, 1332.78);
end

function SCR_USE_ITEM_Dungeon_Lv200(self) --Indun_FireTower
    MoveZone(self, 'f_remains_40', 3290.65, 645.84, 2923.09);
end

function SCR_USE_ITEM_Dungeon_Lv210_2(self) --d_cathedral_78_1
    MoveZone(self, 'f_tableland_28_2', -233.16, 37.83, -726.73);
end

function SCR_USE_ITEM_Dungeon_Lv230(self) --Indun_Catacom
    MoveZone(self, 'c_fedimian', -509.30, 170.50, -256.87);
end

function SCR_USE_ITEM_Dungeon_Lv230_2(self) --d_zachariel_79_1
    MoveZone(self, 'f_siauliai_15_re', -350.08, 1015.05, 2138.39);
end

function SCR_USE_ITEM_Dungeon_Lv240_2(self) --d_zachariel_79_2
    MoveZone(self, 'd_zachariel_79_1', 546.24, -62.25, 624.44);
end

function SCR_USE_ITEM_Dungeon_Lv260(self) --Indun_castle
    MoveZone(self, 'f_flash_64', -532.73, 885.49, 1469.33);
end

function SCR_USE_ITEM_Dungeon_Lv260_2(self) --M_GTOWER_1
    MoveZone(self, 'f_remains_37_3', -2661.98, 52.40, 2556.54);
end

function SCR_USE_ITEM_Dungeon_Lv290(self) --Indun_Castle2
    MoveZone(self, 'f_maple_25_2', 1206.53, 641.89, 771.63);
end

function SCR_USE_ITEM_Dungeon_Lv315(self) --f_whitetrees_56_1
    MoveZone(self, 'f_whitetrees_56_1', 303.26, 1.10, -73.88);
end

function SCR_USE_ITEM_Guide_Cube_1(pc) 
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local CheckList = {
        {5, "Premium_boostToken_14d", 2, "Premium_WarpScroll", 5, "RestartCristal", 5, "Event_drug_steam_1h", 10},
        {10, "Premium_boostToken_14d", 2, "Premium_WarpScroll", 5, "RestartCristal", 5, "Mic", 10, "NECK99_107", 1, "Scroll_Warp_Klaipe", 1, "JOB_VELHIDER_COUPON", 1, "E_SWD04_106", 1, "E_TSW04_106", 1, "E_MAC04_108", 1, "E_TSF04_106", 1, "E_STF04_107", 1, "E_SPR04_103", 1, "E_TSP04_107", 1, "E_BOW04_106", 1, "E_TBW04_106", 1, "E_SHD04_102", 1},
        {15, "Premium_boostToken_14d", 2, "PremiumToken_1d", 1, "Premium_WarpScroll", 5, "RestartCristal", 5, "Mic", 10, "Hat_628051", 1, "Event_drug_steam_1h", 10},
        {30, "Premium_boostToken02_event01", 2, "BRC99_103", 1, "BRC99_104", 1},
        {50, "Premium_boostToken02_event01", 2, "Premium_indunReset_14d", 1, "Mic", 10, "Event_Warp_Dungeon_Lv50", 1, "E_FOOT04_101", 1},
        {80, "Premium_boostToken02_event01", 4, "Premium_indunReset_14d", 2, "Premium_WarpScroll", 5, "RestartCristal", 5, "GIMMICK_Drug_HPSP1", 20, "Event_Warp_Dungeon_Lv80", 1, "E_costume_Com_4", 1, "E_HAIR_M_116", 1, "E_HAIR_F_117", 1},
        {100 ,"Premium_boostToken03_event01", 1, "RestartCristal", 5, "Mic", 10, "Scroll_Warp_Fedimian", 1, "Event_Warp_Dungeon_Lv100_2", 1, "Event_Warp_Dungeon_Lv100", 1, "Hat_628061", 1},
        {110 ,"Premium_boostToken03_event01", 2, "Premium_indunReset_14d", 1, "Event_Warp_Dungeon_Lv110", 1, "PremiumToken_1d", 1},
        {120 ,"Premium_boostToken03_event01", 2, "Premium_indunReset_14d", 1, "Event_Warp_Dungeon_Lv120", 1, "Mic", 10, "Premium_Enchantchip14", 2},
        {140 ,"Premium_boostToken03_event01", 2, "Event_Warp_Dungeon_Lv140", 1, "GIMMICK_Drug_HPSP2", 20, "ABAND01_118", 1},
        {150 ,"Premium_boostToken03_event01", 2, "Premium_WarpScroll", 5, "RestartCristal", 10, "Event_Warp_Dungeon_Lv150", 1, "E_BRC04_101", 1, "E_BRC02_109", 1},
        {170 ,"Premium_boostToken03_event01", 2, "Drug_Fortunecookie", 1, "Premium_indunReset_14d", 1, "Event_Warp_Dungeon_Lv170", 1, "Event_Warp_Dungeon_Lv170_2", 1}, 
        {190 ,"Premium_boostToken03_event01", 2, "Drug_Fortunecookie", 2, "Event_Warp_Dungeon_Lv190", 1, "GIMMICK_Drug_HPSP3", 20},
        {200 ,"Premium_boostToken03_event01", 2, "Drug_Fortunecookie", 3, "Premium_indunReset_14d", 1, "Event_Warp_Dungeon_Lv200", 1},
        {210 ,"Premium_boostToken03_event01", 2, "Drug_Fortunecookie", 4, "Premium_indunReset_14d", 1, "Event_Warp_Dungeon_Lv210_2", 1, "E_BRC03_108", 1, "E_BRC04_103", 1},
        {230 ,"Premium_boostToken03", 2, "Drug_Fortunecookie", 5, "Premium_indunReset", 1, "Event_Warp_Dungeon_Lv230", 1, "Event_Warp_Dungeon_Lv230_2",1 ,"E_BRC03_120", 1},
        {240 ,"Premium_boostToken03", 2, "Drug_Fortunecookie", 5, "Premium_indunReset", 2, "GIMMICK_Drug_HPSP3", 20, "Event_Warp_Dungeon_Lv240_2", 1},
        {260 ,"Premium_boostToken03", 2, "Event_Warp_Dungeon_Lv260", 1, "Event_Warp_Dungeon_Lv260_2", 1, "Hat_628133", 1},
        {290 ,"Premium_boostToken03", 2, "Premium_Enchantchip14", 4, "Event_Warp_Dungeon_Lv290", 1, "Gacha_G_013", 1}
    }
    for i = 0, table.getn(CheckList)-1 do
        if CheckList[i+1][1] <= pc.Lv and sObj.EVENT_VALUE_SOBJ11 == i then
            local result = i + 1
            --print(#CheckList[result])
            local tx = TxBegin(pc) 
            for j = 2, #CheckList[result], 2 do
                TxGiveItem(tx, CheckList[result][j] , CheckList[result][j+1], "Retention_Event")
                TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ11', sObj.EVENT_VALUE_SOBJ11 + 1)
            end
            local ret = TxCommit(tx)
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Retention_Select2", "LEVELCOUNT", CheckList[i+2][1]), 5)
            break 
        elseif CheckList[i+1][1] > pc.Lv and sObj.EVENT_VALUE_SOBJ11 == i then
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg("Retention_Select2", "LEVELCOUNT", CheckList[i+1][1]), 5)
        end
    end
end

function SCR_NPC_RETENTION_DIALOG(self, pc)
    local year, month, day, hour, min = GetAccountCreateTime(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	if GetServerNation() ~= 'GLOBAL' then
        return
    end
	if sObj.EVENT_VALUE_SOBJ12 >= 1 then
	    return
	end
	if (month >= 3 and day >= 28) or (month >= 4 and day >= 1) and year == 2017 then
	    ShowOkDlg(pc, 'NPC_EVENT_RETENTION_1', 1)
        local tx = TxBegin(pc)
        TxGiveItem(tx, "Event_Guide_Cube_1", 19, "RETENTION_EVENT")
        TxSetIESProp(tx, sObj, 'EVENT_VALUE_SOBJ12', sObj.EVENT_VALUE_SOBJ12 + 1)
        local ret = TxCommit(tx)
	else
	    ShowOkDlg(pc, 'NPC_EVENT_RETENTION_2', 1)
	end
end
