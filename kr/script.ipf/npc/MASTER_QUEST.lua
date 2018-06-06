-- MASTER_SAPPER


function SCR_MASTER_SAPPER1_2_ABANDON(self, tx)
    local itemCount1 = GetInvItemCount(self, "MASTER_SAPPER1_1_ITEM")
    
    if itemCount1 == 0 then
        TxGiveItem(tx, "MASTER_SAPPER1_1_ITEM", 1, "MASTER_SAPPER1_2")
    end
    
    SCR_PARTY_QUESTPROP_ADD(self,'SSN_MASTER_SAPPER1_2',nil, nil, "JOB_SAPPER2_1_ITEM1/6", "JOB_SAPPER2_1_ITEM1/6")
end


function SCR_MASTER_SAPPER1_3_ABANDON_CHECK(self)
    local itemCount1 = GetInvItemCount(self, "MASTER_SAPPER1_1_ITEM")

    if itemCount1 == 1 then
        return "YES"
    end

    return "NO"
end


-- MASTER_HUNTER


function SCR_MASTER_HUNTER1_1_ABANDON(self, tx)
    local itemCount = GetInvItemCount(self, "Book2")
    
    if itemCount == 1 then
        TxTakeItem(tx, "Book2", 1, "MASTER_HUNTER1_1")
    end
    
end


function SCR_MASTER_HUNTER1_3_ABANDON(self, tx)
    local itemCount = GetInvItemCount(self, "Book4")
    
    if itemCount == 0 then
        TxGiveItem(tx, "Book4", 1, "MASTER_HUNTER1_3")
    end
    
end


function SCR_MASTER_HUNTER1_4_ABANDON(self, tx)
    local itemCount1 = GetInvItemCount(self, "Book5")
    local itemCount2 = GetInvItemCount(self, "Book6")
    
    if itemCount1 == 0 then
        TxGiveItem(tx, "Book5", 1, "MASTER_HUNTER1_4")
    end
    
    if itemCount2 == 1 then
        TxTakeItem(tx, "Book6", 1, "MASTER_HUNTER1_4")
    end
end


function SCR_MASTER_HUNTER1_4_GIVE_BOOK(self)
    local itemCount1 = GetInvItemCount(self, "Book2")
    local itemCount2 = GetInvItemCount(self, "Book4")
    local itemCount3 = GetInvItemCount(self, "Book5")
    local itemCount4 = GetInvItemCount(self, "Book6")
    local tx = TxBegin(self)
    
    if itemCount1 == 0 then
        TxGiveItem(tx, "Book2", 1, "MASTER_HUNTER1_4")
    end
    
    if itemCount2 == 0 then
        TxGiveItem(tx, "Book4", 1, "MASTER_HUNTER1_4")
    end
    
    if itemCount3 == 0 then
        TxGiveItem(tx, "Book5", 1, "MASTER_HUNTER1_4")
    end
    
    if itemCount4 == 0 then
        TxGiveItem(tx, "Book6", 1, "MASTER_HUNTER1_4")
    end
    
    local ret = TxCommit(tx)
end




-- MASTER_HIGHLANDER


function SCR_MASTER_HIGHLANDER2_3_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


-- MASTER_PELTASTA


function SCR_MASTER_PELTASTA2_3_TRACK_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end



-- MASTER_FIREMAGE


function SCR_MASTER_FIREMAGE1_TRACK_BOCORS_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_MASTER_FIREMAGE1")
    
    if sObj.QuestInfoValue1 == 2 then
        ShowOkDlg(pc, "JOB_FIREMAGE_succ_prognpc1")
        sObj.QuestInfoValue2 = 1
        SaveSessionObject(pc, sObj)
        
    else
        ChatLocal(self, pc, ScpArgMsg("MASTER_FIREMAGE1_BOCORS_TALK"), 3)
    end
    
end


-- MASTER_ICEMAGE


function SCR_MASTER_ICEMAGE1_FIREMAGE_BOX_DIALOG(self,pc)
    local layer = GetLayer(pc)
    if layer ~= 0 then
    
        local questCheck = SCR_QUEST_CHECK(pc, "MASTER_ICEMAGE1")
        if questCheck == "PROGRESS" then
        
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaMulSoe_yeoNeun_Jung"), 'UNLOCK', 1.5)
            if result == 1 then
            
                local sObj = GetSessionObject(pc, 'SSN_MASTER_ICEMAGE1')
                if sObj ~= nil then
                
                    if sObj.Goal1 == 5 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("Auto_Bin_SangJa"), 3)
                        
                    elseif sObj.Goal1 == 4 then
                        PlayAnim(self, 'SHAKEOPEN',1)
                        sleep(1000)
                        SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("MASTER_ICEMAGE1_GET_SCROLL"), 3)
                        SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_MASTER_ICEMAGE1', 'QuestInfoValue1', 1, nil, 'FireMage_old_Scroll/1')
                        local mon1 = CREATE_MONSTER_EX(self, 'Warp_arrow', 253, 2, 2, 1, 'Neutral', nil, SCR_MASTER_ICEMAGE1_WARP)
                        sObj.Goal1 = 5
                        
                    elseif (sObj.Goal1 < 4 and sObj.Goal1 >= 1) then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("MASTER_ICEMAGE1_KILL_MONSTER"), 3)
                        
                    elseif sObj.Goal1 < 1 then
                        SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("MASTER_ICEMAGE1_OPEN_FAIL"), 3)
                        local mon1 = CREATE_MONSTER_EX(self, 'spector_F_purple_J1', -162, 7, -17, 0, 'Monster', 15)
                        local mon2 = CREATE_MONSTER_EX(self, 'spector_F_purple_J1', -90, 7, -106, 0, 'Monster', 15)
                        local mon3 = CREATE_MONSTER_EX(self, 'spector_F_purple_J1', -24, 7, 91, 0, 'Monster', 15)
                        InsertHate(mon1, pc, 9999)
                        InsertHate(mon2, pc, 9999)
                        InsertHate(mon3, pc, 9999)
                        SetDeadScript(mon1, 'SCR_MASTER_ICEMAGE1_MON')
                        SetDeadScript(mon2, 'SCR_MASTER_ICEMAGE1_MON')
                        SetDeadScript(mon3, 'SCR_MASTER_ICEMAGE1_MON')
                        sObj.Goal1 = 1
                    end
                    
                SaveSessionObject(pc, sObj)
                end
            end
        end
    end
end
    
    
function SCR_MASTER_ICEMAGE1_WARP(mon)
    mon.Enter = "MASTER_ICEMAGE1_WARP"
    mon.Name = ScpArgMsg("Klapeda")
    mon.Range = 30
end

function SCR_MASTER_ICEMAGE1_WARP_ENTER(self, pc)
    SCR_WS_SCRIPT(self, pc, 'FIREMAGE_KLAPEDA');
end


function SCR_MASTER_ICEMAGE1_MON(self)
    local zoneName = GetZoneName(self)
    local layer = GetLayer(self)
    if zoneName == 'c_firemage' then
    
        if layer ~= 0 then
        
            local list, count = GetWorldObjectList(self, "PC", 1000)
            if count ~= 0 then
            
                for i = 1, count do
                
                    if GetLayer(list[i]) == GetLayer(self) then
                    
                        local sObj = GetSessionObject(list[i], "SSN_MASTER_ICEMAGE1")
                        if sObj ~= nil then
                        
                            if (sObj.Goal1 >= 1 and sObj.Goal1 < 4) then
                                sObj.Goal1 = sObj.Goal1 +1
                                SaveSessionObject(list[i], sObj)
                            end
                            
                        else
                            return
                        end
                        
                    end
                end
            end
        end
    end
    return
    
end


function SCR_MASTER_ICEMAGE2_2_ABANDON(self, tx)
    local itemCount = GetInvItemCount(self, "Book8")
    
    if itemCount == 1 then
        TxTakeItem(tx, "Book8", 1, "MASTER_ICEMAGE2_2")
    end
end


function SCR_MASTER_ICEMAGE2_2_GIVE_BOOK(self)
    local itemCount = GetInvItemCount(self, "Book8")

    if itemCount == 0 then
        local tx = TxBegin(self)
        TxGiveItem(tx, "Book8", 1, "MASTER_ICEMAGE2_2")
        local ret = TxCommit(tx)
    end

end


function SCR_MASTER_CRYOMANCER2_2_TRIGGER_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end


function SCR_MASTER_CRYOMANCER2_2_BOOK_DIALOG(self, pc)
    local sObj = GetSessionObject(pc, "SSN_MASTER_CRYOMANCER2_2")
    if sObj ~= nil then
        if sObj.QuestInfoValue1 == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear",ScpArgMsg("MASTER_CRYOMANCER2_2_GET_BOOK"), 3)
            SCR_PARTY_QUESTPROP_ADD(pc, 'SSN_MASTER_CRYOMANCER2_2', 'QuestInfoValue2', 1, nil, 'Book8/1')
            Kill(self)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll",ScpArgMsg("MASTER_CRYOMANCER2_2_NOT_YET"), 3)
        end
    end
end


function SCR_MASTER_CRYOMANCER2_2_BOSS_DEAD(self)
    SetDeadScript(self, "SCR_MASTER_CRYOMANCER2_2_YETI_DEAD")
end


function SCR_MASTER_CRYOMANCER2_2_YETI_DEAD(self)
    local list, cnt = GetWorldObjectList(self, "PC", 1000)
    local yeti_Layer = GetLayer(self)
    if cnt ~= nil then
        for i = 1, cnt do
            local pc_Layer = GetLayer(list[i])
            if yeti_Layer == pc_Layer then
                local sObj = GetSessionObject(list[i], "SSN_MASTER_CRYOMANCER2_2")
                if sObj ~= nil then
                    if sObj.QuestInfoValue1 == 0 then
                        SCR_PARTY_QUESTPROP_ADD(list[i], 'SSN_MASTER_CRYOMANCER2_2', 'QuestInfoValue1', 1)
                    end
                end
            end
        end
    end
end

--SUBMASTER_LINKER


function SCR_SUBMASTER_LINKER1_2_ABANDON(self, tx)
    ObjectColorBlend(self, 255,255,255,255, 0)
    local itemCount = GetInvItemCount(self, "Book7")
    
    if itemCount == 1 then
        TxTakeItem(tx, "Book7", 1, "SUBMASTER_LINKER1_2")
    end
    
end


function SCR_SUBMASTER_LINKER1_2_GIVE_BOOK(self)
    local itemCount = GetInvItemCount(self, "Book7")
    
    if itemCount == 0 then
        local tx = TxBegin(self)
        TxGiveItem(tx, "Book7", 1, "SUBMASTER_LINKER1_2")
        local ret = TxCommit(tx)
    end
    
end


--MASTER_SAGE

function SCR_MASTER_SAGE1_GIVE_BOOK(self)
    local itemCount1 = GetInvItemCount(self, "JOB_1_SAGE_ITEM1")
    local itemCount2 = GetInvItemCount(self, "JOB_1_SAGE_ITEM2")
    local itemCount3 = GetInvItemCount(self, "JOB_1_SAGE_ITEM3")
    local tx = TxBegin(self)
    
    if itemCount1 == 0 then
        TxGiveItem(tx, "JOB_1_SAGE_ITEM1", 1, "MASTER_SAGE1")
    end
    
    if itemCount2 == 0 then
        TxGiveItem(tx, "JOB_1_SAGE_ITEM2", 1, "MASTER_SAGE1")
    end
    
    if itemCount3 == 0 then
        TxGiveItem(tx, "JOB_1_SAGE_ITEM3", 1, "MASTER_SAGE1")
    end
    
    local ret = TxCommit(tx)
end
