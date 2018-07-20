function SCR_ev_1_BoardWrite_cond(pc, npc, argNum, evt)
    if GetMapNPCState(pc, evt.genType) == 0 then
        if GetInvItemCount(pc, 'BoardWriteChalk') > 0 then
            return 1;
        else
            local target_item = GetClass('Item', 'BoardWriteChalk')
            ChatLocal(npc, pc, target_item.Name..ScpArgMsg("Auto__BuJog"))
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_'NagSeoyong_BunPil'i_inBenToLie_isseuMyeon_Sayong_KaNeung!"), 5);
        end
    elseif GetMapNPCState(pc, evt.genType) == 1 then
        ChatLocal(npc, pc, ScpArgMsg("Auto_ChaeTingChange_NagSeo_Naeyong_JeogKi"))
    else
        SCR_EV_1_BOARDWRITE_DIALOG(npc,pc)
    end
    
    return 0;
    
--    local target_item_classid = 300139
--    local target_item = GetClassByNumProp('Item', 'ClassID',target_item_classid)
--	if GetMapNPCState(pc, evt.genType) == 0 then
--	    if target_item_classid == argNum then
--			return 1;
--		else
--    	    ChatLocal(npc, pc, target_item.Name..ScpArgMsg("Auto__DeuLap"))   
--		end
--	else
--	    ChatLocal(npc, pc, ScpArgMsg("Auto_NagSeoKeumJi"))   
--	end;
--
--	return 0;
end



function SCR_ev_1_BoardWrite_act(self, pc, argNum, evt)
    
--    local target_item_classid = 300139
--    local target_item = GetClassByNumProp('Item', 'ClassID', target_item_classid)
    local ssn_name = 'ssn_'..GET_EVENT_NAME(self)
    
--    if argNum == target_item_classid then
    local sObj = GetSessionObject(pc, ssn_name) 
    if sObj == nil then
        CreateSessionObject(pc, ssn_name, 1)
        TAKE_ITEM_TX(pc, 'BoardWriteChalk', 1, 'ev_1_BoardWrite')
        SCR_NPCSTATE_CHANGE(pc, self, 1)
        ChatLocal(self, pc, ScpArgMsg("Auto_ChaeTingChange_NagSeo_Naeyong_JeogKi"))
        
        local sObj_quest = GetSessionObject(pc, 'SSN_TUTO_BOARDWRITE')
        if sObj_quest ~= nil then
            if sObj_quest.QuestInfoValue1 == 1 and sObj_quest.QuestInfoValue2 == 0 then
                sObj_quest.QuestInfoValue2 = 1
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("Auto_3._ChaeTingChange_NamKil_Maleul_NeohNeunDa"), 5);
            end
        end
    else
        ChatLocal(self, pc, ScpArgMsg("Auto_DongJag_Jung,_NagSeo_Naeyong_JeogKi"))
    end
        
--    else
--        ChatLocal(self, pc, target_item.Name..ScpArgMsg("Auto__DeuLap"))   
--    end
end



function SCR_EV_1_BOARDWRITE_DIALOG(self,pc)
    if self.StrArg1 == 'None' or self.StrArg1 == "" then
--        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_'NagSeoyong_BunPil'i_inBenToLie_isseuMyeon_Sayong_KaNeung!"), 5);
        Chat(self,ScpArgMsg("Auto_BinKan"))
    else
        Chat(self, self.StrArg1)
    end
end



function SCR_ssn_ev_1_BoardWrite_Chat(self, sObj, msg, argObj, argStr, argNum, event_npc_nam, reward_item_ClassName)
    local fndList, fndCount = SelectObject(self, 40, 'ALL');
    local flag = 0
    
    if fndCount <= 0 then
        return
    end
    
	for index = 1, fndCount do
		if fndList[index].ClassName ~= 'PC' then
			if GET_EVENT_NAME(fndList[index]) == event_npc_nam then
			    local reward_item
                    
                if GetClass('Recipe', reward_item_ClassName) == nil then
                    reward_item = GetClass('Item', reward_item_ClassName)
                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', reward_item.Name..ScpArgMsg("Auto__HoegDeug"), 4)
                end
	            
                PlaySound(self, 'button_cursor_over_2')
                fndList[index].StrArg1 = GetName(self)..ScpArgMsg("Auto_ui_HanMaDi_:_")..argStr..' '
                Chat(fndList[index], fndList[index].StrArg1)
                RunScript('SCR_NPCSTATE_CHANGE', self, fndList[index], 2)
                RunScript('GIVE_EVENTEXPUP_ITEM_TX', fndList[index], self, reward_item_ClassName, 1, 'EVENT')
                DestroySessionObject(self, sObj)
                
                local sObj_quest = GetSessionObject(self, 'SSN_TUTO_BOARDWRITE')
                if sObj_quest ~= nil then
                    if sObj_quest.QuestInfoValue2 == 1 and sObj_quest.QuestInfoValue3 == 0 then
                        sObj_quest.QuestInfoValue3 = 1
                    end
                end
                
                flag = flag + 1
                break
            end
        end
    end
    
    if flag == 0 then
	    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("Auto_JuByeone_KeSiPan_eopeum"), 4)
	end
end
