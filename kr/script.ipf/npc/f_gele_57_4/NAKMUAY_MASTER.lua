--NAKMUAY_MASTER SCRIPT
function SCR_CHAR120_MASTER_DIALOG(self, pc)
    PlayMusicQueueLocal(pc, "master_nakmuay")
    local hidden_Prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    local is_unlock = SCR_HIDDEN_JOB_IS_UNLOCK(pc, 'Char1_20');
    if IS_KOR_TEST_SERVER() then
        COMMON_QUEST_HANDLER(self,pc)
    end
    if is_unlock == 'YES' then
        COMMON_QUEST_HANDLER(self,pc)
    elseif is_unlock == 'NO' then
        if hidden_Prop >= 250 and hidden_Prop < 300 then
            local sel1 = ShowSelDlg(pc, 0, "CHAR120_MSTEP7_DLG1", ScpArgMsg("CHAR120_MSTEP7_TXT1"), ScpArgMsg("CHAR120_MSTEP7_TXT2"))
            if sel1 == 1 then
                local sel2 = ShowSelDlg(pc, 0, "CHAR120_MSTEP7_DLG2", ScpArgMsg("CHAR120_MSTEP7_TXT3"), ScpArgMsg("CHAR120_MSTEP7_TXT4"))
                if sel2 == 1 then
                    ShowOkDlg(pc, "CHAR120_MSTEP7_DLG3", 1)
                    local tx1 = TxBegin(pc);
                    local nakmuay_item = {
                                            'CHAR120_MSTEP5_1_ITEM',
                                            'CHAR120_MSTEP5_1_ITEM2',
                                            'CHAR120_MSTEP5_3_ITEM1',
                                            'CHAR120_MSTEP5_3_ITEM2',
                                            'CHAR120_MSTEP5_4_ITEM1',
                                            'CHAR120_MSTEP5_4_ITEM2',
                                            'CHAR120_MSTEP5_4_ITEM3',
                                            'CHAR120_MSTEP5_5_ITEM1',
                                            'CHAR120_MSTEP5_5_ITEM2',
                                            'CHAR120_MSTEP5_5_ITEM3',
                                            'CHAR120_MSTEP5_5_ITEM4',
                                            'CHAR120_MSTEP5_5_ITEM5',
                                            'CHAR120_HOSHINBOO_ITEM'
                                        }
                    local mon = {}
                    for j = 1 , 3 do
                        mon[j] = GetScpObjectList(pc, "CHAR120_DANDELIONGoal"..j+4)
                        if #mon[j] >= 1 then
                            Kill(mon[j])
                        end
                    end
                    for i = 1, #nakmuay_item do
                        if GetInvItemCount(pc, nakmuay_item[i]) >= 1 then
                            TxTakeItem(tx1, nakmuay_item[i], GetInvItemCount(pc, nakmuay_item[i]), 'Quest_HIDDEN_NAKMUAY');
                        end
                    end
                    local ret = TxCommit(tx1);
                    if ret == "SUCCESS" then
                        local ret2 = SCR_HIDDEN_JOB_UNLOCK(pc, 'Char1_20')
                        if ret2 == "FAIL" then
                            print("tx FAIL!")
                        elseif ret2 == "SUCCESS" then
                            print("tx SUCCESS!")
                            local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
                            if sObj ~= nil then
                                DestroySessionObject(pc, sObj)
                            end
                        end
                    else
                        print("tx FAIL!")
                    end
                end
            end
        end
    end
end