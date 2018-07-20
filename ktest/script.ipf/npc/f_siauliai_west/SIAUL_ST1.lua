

function SCR_SIAUL_ST1_ST2_DIALOG(self,pc)
    local result = SCR_QUEST_CHECK(pc, 'SIAUL_WEST_WOOD_SPIRIT')
    if result == 'PROGRESS' then
        RunScript('SIAUL_WEST_WOOD_SPIRIT_TIME', self, pc)
    else
        COMMON_QUEST_HANDLER(self,pc);
    end
end

function SIAUL_WEST_WOOD_SPIRIT_TIME(self, pc)
    ShowOkDlg(pc, 'SIAUL_WEST_WOOD_SPIRIT_dlg2',1)
    COMMON_QUEST_HANDLER(self,pc);
end




function SCR_ACT_VILLAGERS_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc);
end

function SCR_ACT_SMOM_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc);
end

function SCR_ACT_SMOM_NORMAL_1(self,pc)
	local item1 = GetInvItemCount(pc, "CHAR120_MSTEP5_1_ITEM")
	local item2 = GetInvItemCount(pc, "food_029")
	if item1 >= 130 and item2 >= 100 then
	    local sel = ShowSelDlg(pc, 0, 'CHAR120_MSTEP5_1_DLG1', ScpArgMsg("HIDDEN_CHAR120_MSTEP5_1_COMP_MSG"))
	    if sel == 1 then
	        local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
	        ShowOkDlg(pc, 'CHAR120_MSTEP5_1_DLG2',1)
	        UIOpenToPC(pc, 'fullblack', 1)
	        sleep(1500)
            UIOpenToPC(pc, 'fullblack', 0)
            ShowOkDlg(pc, 'CHAR120_MSTEP5_1_DLG3',1)
            local tx1 = TxBegin(pc);
            local nakmuay_item = {
                                    'CHAR120_MSTEP5_1_ITEM',
                                    'food_029'
                                }
            for i = 1, #nakmuay_item do
                if GetInvItemCount(pc, nakmuay_item[i]) > 0 then
                    local invItem, cnt = GetInvItemByName(pc, nakmuay_item[i])
					if IsFixedItem(invItem) == 1 then
						isLockState = 1
					end
					if nakmuay_item[i] == "CHAR120_MSTEP5_1_ITEM" then
                        TxTakeItem(tx1, nakmuay_item[i], GetInvItemCount(pc, nakmuay_item[i]), 'Quest_HIDDEN_NAKMUAY');
                    elseif nakmuay_item[i] == "food_029" then
                        TxTakeItem(tx1, nakmuay_item[i], 100, 'Quest_HIDDEN_NAKMUAY');
                    end
                end
            end
            TxGiveItem(tx1, "CHAR120_MSTEP5_1_ITEM2", 1, 'Quest_HIDDEN_NAKMUAY');
            local ret = TxCommit(tx1);
            if ret == "SUCCESS" then
                print("tx Success")
                sObj.Step1 = 2
                SaveSessionObject(pc, sObj)
            else
				if isLockState == 1 then
					SendSysMsg(pc, 'QuestItemIsLocked');
				end
                print("tx FAIL!")
            end
	    end
	else
	    ShowOkDlg(pc, 'CHAR120_MSTEP5_1_DLG1',1)
	end
end

function SCR_ACT_SMOM_NORMAL_1_PRE(pc)
	local sObj = GetSessionObject(pc, "SSN_NAKMUAY_UNLOCK")
	local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char1_20');
	local item = GetInvItemCount(pc, "CHAR120_MSTEP5_1_ITEM2")
	--print(sObj.Step1, hidden_prop, item)
	if hidden_prop == 100 then
    	if sObj.Step1 == 1 then
            if item < 1 then
    	        return "YES"
    	    end
    	end
	end
	return 'NO'
end

function SCR_SIAUL1_BOARD2_DIALOG(self, pc)
  ShowOkDlg(pc, 'SIAUL1_BOARD2', 1)
end
function SCR_SIAUL1_BOARD3_DIALOG(self, pc)
  ShowOkDlg(pc, 'SIAUL1_BOARD3', 1)
end
function SCR_SIAUL1_BOARD4_DIALOG(self, pc)
  ShowOkDlg(pc, 'SIAUL1_BOARD4', 1)
end
function SCR_SIAUL1_BOARD5_DIALOG(self, pc)
  ShowOkDlg(pc, 'SIAUL1_BOARD5', 1)
end
function SCR_SIAUL1_BOARD6_DIALOG(self, pc)
  ShowOkDlg(pc, 'SIAUL1_BOARD6', 1)
end
function SCR_SIAUL1_BOARD7_DIALOG(self, pc)
    ShowOkDlg(pc, 'SIAUL1_BOARD7', 1)
    local main_sObj = GetSessionObject(pc, "ssn_klapeda")
    if main_sObj.SIAUL_WEST_HQ01_INFO1 >= 1 and main_sObj.SIAUL_WEST_HQ01_INFO2 >= 1 and main_sObj.SIAUL_WEST_HQ01_INFO3 >= 1 then
        main_sObj.SIAUL_WEST_HQ01_INFO4 = 1
    end
end
