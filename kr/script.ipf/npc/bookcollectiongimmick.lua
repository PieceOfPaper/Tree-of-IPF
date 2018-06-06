function SCR_BOOKCOLLECTIONGIMMICK(self)
    local collectionclasslist, collectionclasscount = GetClassList("bookcollectiongimmick");
    local now_time = os.date('*t')
    local wday = now_time['wday']
    
    local i
    local j = 0
    local list = {}
    for i = 1, collectionclasscount do
        list[i] = GetClassByIndexFromList(collectionclasslist, i-1);
        if list[i].DropRate >= 1 and list[i].DropRate <= 7 then
            if list[i].DropRate == wday then
                j = j + 1
                list[collectionclasscount+j] = list[i]
            end
        end
    end
    
    local rnd = IMCRandom(1, collectionclasscount+j)
    
    return list[rnd].ClassName;
end

function SCR_BOOKCOLLECTIONGIMMICK_SAGE_DIALOG(self, pc)
    local select1 = ShowSelDlg(pc, 0, 'BOOKCOLLECT_PRIVIOUS_DLG', ScpArgMsg("BOOKCOLLECT_CHECK_MSG"), ScpArgMsg("BOOKCOLLECT_EXPLAIN_MSG"), ScpArgMsg("EXPLORER_ANASTAZIJA_BACK"))
    if select1 == 1 then
        local select2 = ShowSelDlg(pc, 0, 'BOOKCOLLECT_CHECK_DLG', ScpArgMsg("BOOKCOLLECT_GIVE_PAPER_MSG"), ScpArgMsg("EXPLORER_ANASTAZIJA_BACK"))
        if select2 == 1 then
            local itemcheck = GetInvItemCount(pc, 'misc_shredded_paper')
            if itemcheck >= 8 then
                local book = SCR_BOOKCOLLECTIONGIMMICK(self)
                local tx = TxBegin(pc)
                TxGiveItem(tx, book, 1, 'BOOKCOLLECTIONGIMMICK');
                TxTakeItem(tx, 'misc_shredded_paper', 8, 'BOOKCOLLECTIONGIMMICK');
                TxAddAchievePoint(tx, 'BOOKCOLLECTIONAP', 1)
                TxAddAchievePoint(tx, "GimmickPoint1", 1)
                ShowOkDlg(pc,'BOOKCOLLECT_THANKS_DLG', 1)
                local point = GetAchievePoint(pc, 'BOOKCOLLECTIONAP')
                local pointtable = {2, 5, 8, 11, 14, 17, 20}
                local itemtable = {'misc_collect_gimk_001', 'misc_collect_gimk_002', 'misc_collect_gimk_003', 'misc_collect_gimk_004', 'misc_collect_gimk_005', 'misc_collect_gimk_006', 'misc_collect_gimk_007'}
                for i = 1, #pointtable do
                    if point == pointtable[1] then
                        ShowOkDlg(pc, "BOOKCOLLECT_1ST_BONUS_DLG1")
                        local check = HaveCollection(pc, 'COLLECT_313')
                        if check == 0 then
                            TxGiveItem(tx, 'COLLECT_313', 1, 'BOOKCOLLECTIONGIMMICK');
                        end
                        TxGiveItem(tx, itemtable[1], 1, 'BOOKCOLLECTIONGIMMICK');
                        ShowOkDlg(pc, "BOOKCOLLECT_1ST_BONUS_DLG2")
                        break
                    elseif point == pointtable[i] then
                        ShowOkDlg(pc,'BOOKCOLLECT_NEXT_BONUS_DLG', 1)
                        TxGiveItem(tx, itemtable[i], 1, 'BOOKCOLLECTIONGIMMICK');
                        break
                    end
                end
                local ret = TxCommit(tx)
            else
                ShowOkDlg(pc,'BOOKCOLLECT_LACK_DLG', 1)
            end
        else
            return
        end
    elseif select1 == 2 then
        ShowOkDlg(pc,'BOOKCOLLECT_EXPLAIN_DLG', 1)
    elseif select1 == 3 then
        return;
    end
end


-- Book Collection Gimmick CHEAT


function SCR_ACHIEVE_POINT_BOOKCOLLECTION(self)
     AddAchievePoint(self, 'BOOKCOLLECTIONAP', 10)
end