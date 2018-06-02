function SCR_EVENT_AROUND_MONGEN(self, pc, evt, mon_count)
    if mon_count > 0 then
        local pos = evt:Pos()
        local mon_list = SCR_GET_AROUND_MONGEN_MONLIST(pc, GetZoneName(self), GetCurrentFaction(self), 100, pos.x, pos.y, pos.z)
        local gen_list = {}
        if mon_list ~= nil and #mon_list > 0 then
            for i = 1, mon_count do
                local pos_list = GetCellCoord(self, 'Front1',  360/mon_count * i)
                local index = IMCRandom(1, #mon_list)
                local mon = CREATE_MONSTER(pc, mon_list[index][1], pos_list[1], pos_list[2], pos_list[3], nil, mon_list[index][6], layer, mon_list[index][5], mon_list[index][3], mon_list[index][2], nil, nil, 1, nil, nil, mon_list[index][4])
                if mon ~= nil then
                    LookAt(mon, pc)
                    InsertHate(mon, pc, 1)
                    gen_list[#gen_list + 1] = mon
                end
            end
            
            if gen_list ~= nil and #gen_list > 0 then
                local hidden_IES = CreateGCIES('Monster', 'HiddenTrigger4')
                
                local hidden_obj = CreateMonster(pc, hidden_IES, pos.x, pos.y, pos.z, 0, 1);
                
                if hidden_obj ~= nil then
                    --가이드 퀘스트 체크
--                    local sObj_quest = GetSessionObject(pc, 'SSN_TUTO_SKRIK')
                    
--                    if sObj_quest ~= nil then
--                        if sObj_quest.QuestInfoValue1 == 0 then
--                            sObj_quest.QuestInfoValue1 = 1
--                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("Auto_2._MolLyeoDeuNeun_MonSeuTeo_CheoChi"), 4);
--                        end
--                    end
                    
                    hidden_obj.Lv = gen_list[1].Lv
                    SetOwner(hidden_obj, pc)
                    CreateSessionObject(hidden_obj, 'SSN_EVSKRIK_MON')
                    SetExArgCount(hidden_obj, #gen_list)
                    local list, cnt = GetExArgList(hidden_obj)
                    
                    for i = 1, cnt do
                        SetExArg(hidden_obj, i, gen_list[i])
                    end
                end
            end
        end
    end
end
