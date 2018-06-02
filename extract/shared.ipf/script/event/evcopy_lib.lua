

function SCR_evcopy_cond(pc, npc, argNum, evt)
    

--    print('SSSSSSSSSSSSSSSS444444')
    if GetMapNPCState(pc, evt.genType) == 0 then
    
        return 1;
    end

    Chat(npc, ScpArgMsg('Auto_Deo_iSang_JinHaengHal_Su_eopeoyo...!'))

        return 0;

end



function SCR_evcopy_act(self, pc, argNum, evt, npctxt)
    local ssn_name = 'ssn_'..GET_EVENT_NAME(self)
	local sObj = GetSessionObject(pc, ssn_name, 1)
    if sObj == nil then
        CreateSessionObject(pc, ssn_name)
        print(ssn_name)
        ShowOkDlg(pc, 'example_zone2_dlg_1',1)
        sObj = GetSessionObject(pc, ssn_name, 1)
        sObj.QuestInfoName1 = npctxt
    end
    Chat(self, ScpArgMsg('Auto_TtaLaHae_JuSeyo_:_')..npctxt)

end


function SCR_evcopy_Chat(self, sObj, msg, argObj, argStr, argNum, event_name, reward_itemname,reward_itemcount)
    local fndList, fndCount = SelectObject(self, 40, 'ALL');
    local flag = 0
    
    if fndCount <= 0 then
        return
    end
    
	for index = 1, fndCount do
		if fndList[index].ClassName ~= 'PC' then
			if GET_EVENT_NAME(fndList[index]) == event_name then
                if sObj.QuestInfoName1 == argStr then
                    local reward_item
                    
                    if GetClass('Recipe', reward_itemname) == nil then
	                    reward_item = GetClass('Item', reward_itemname)
	                    SendAddOnMsg(self, 'NOTICE_Dm_GetItem', reward_item.Name..ScpArgMsg("Auto__HoegDeug"), 4)
	                end
	                
                    RunScript('SCR_NPCSTATE_CHANGE', self, fndList[index], 1)
                    RunScript('GIVE_EVENTEXPUP_ITEM_TX', fndList[index], self, reward_itemname, reward_itemcount, 'EVENT')
                    DestroySessionObject(self, sObj)
                else
                    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('Auto_JeongHwagHi_ipLyeogHaeJuSeyo_:_')..sObj.QuestInfoName1, 4)
                    
                end
            end
        end
    end
    
end


