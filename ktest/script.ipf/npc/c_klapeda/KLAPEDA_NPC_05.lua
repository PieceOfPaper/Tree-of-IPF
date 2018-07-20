function SCR_COLLECTION_SHOP_DIALOG(self, pc)
--    local ev160929 = nil 
--    local check, seaStep, seaCount, seaItem, nexonPC, nowYday = SCR_EV160929_CHECK(pc)
--    local itemCount
--    if check == 'YES' then
--        itemCount = seaCount + 1
--        if nexonPC == 'YES' then
--            itemCount = itemCount * 2
--        end
--        ev160929 = ScpArgMsg('EV160929_MSG1','ITEM',GetClassString('Item',seaItem,'Name'),'DAYCOUNT',seaCount+1,'COUNT',itemCount,'SEA',seaStep)
--    end
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg("HANGEUL_EVENT_MSG2"),ScpArgMsg('CHUSEOK_EVENT_MSG1'), msgBig, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg("COLLECTION_SHOP_PLAYTIME"), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('CHUSEOK_EVENT_MSG1'), msgBig, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ev160929, ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    COMMON_QUEST_HANDLER(self,pc)
end


--    local select = ShowSelDlg(pc, 0, 'HENRIKA_BASIC01', ScpArgMsg('COLLECTION_SHOP_OPEN'), ScpArgMsg('COLLECTION_REWARD_ITEM'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    if select == 1 then
--        SendAddOnMsg(pc, "COLLECTION_UI_OPEN", "", 0);
--		REGISTERR_LASTUIOPEN_POS_SERVER(pc,"collection")
--	elseif select == 2 then

function SCR_COLLECTION_SHOP_NORMAL_1(self,pc)
    SendAddOnMsg(pc, "COLLECTION_UI_OPEN", "", 0);
	REGISTERR_LASTUIOPEN_POS_SERVER(pc,"collection")
end


function SCR_COLLECTION_SHOP_NORMAL_2(self,pc)
    local select2 = ShowSelDlg(pc, 0, 'COLLECT_REWARD_ITEM_HENRIKA', ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select2 == 1 then
        local col_List, col_Cnt = GetClassList("Collection")
        local aObj = GetAccountObj(pc)
        if col_Cnt ~= 0 then
            local i
            local list = {}
            local reward_List = {}
            local reward_Index = {}
            local collection_Name
            for i = 1, col_Cnt do
                list[i] = GetClassByIndexFromList(col_List, i-1) 
                if IsCollectionVitality(pc, list[i].ClassName) == 1 then
                    local rewardItem = TryGetProp(list[i], "AccGiveItemList");
                    if rewardItem ~= "None" then
                        local accList = SCR_STRING_CUT(rewardItem) -- acclist = AccGiveItemList
                        if aObj[accList[1]] ~= accList[2] then
                            reward_Index[#reward_Index +1] = list[i].Name -- add list in collect name
                            reward_List[#reward_List +1] = list[i].ClassName -- add list in collect name
                        end
                    end
                end
            end
            if #reward_Index == 0 then
                ShowOkDlg(pc, "COLLECT_REWARD_ITEM_NOTHING_HENRIKA")
            elseif #reward_Index ~= 0 then
                local j
                local sel
                for j = 0, math.floor(#reward_Index/10) do
                    if j ~= math.floor(#reward_Index/10) then
                        sel = ShowSelDlg(pc, 0, 'COLLECT_REWARD_CHOOSE_COLLECTION_HENRIKA', reward_Index[10*j+1], reward_Index[10*j+2], reward_Index[10*j+3], reward_Index[10*j+4], reward_Index[10*j+5], reward_Index[10*j+6], reward_Index[10*j+7], reward_Index[10*j+8], reward_Index[10*j+9], reward_Index[10*j+10], ScpArgMsg('COLLECT_REWARD_ITEM_NEXT_PAGE'))
                        if sel < 11 then
                            collection_Name = reward_List[10*j+sel]
                        elseif sel == nil then
                            return
                        end
                    else
                        sel = ShowSelDlg(pc, 0, 'COLLECT_REWARD_CHOOSE_COLLECTION_HENRIKA', reward_Index[10*j+1], reward_Index[10*j+2], reward_Index[10*j+3], reward_Index[10*j+4], reward_Index[10*j+5], reward_Index[10*j+6], reward_Index[10*j+7], reward_Index[10*j+8], reward_Index[10*j+9], reward_Index[10*j+10], ScpArgMsg('COLLECT_REWARD_END'))
                        if sel < 11 then
                            collection_Name = reward_List[10*j+sel]
                        elseif sel == nil then
                            return
                        end
                    end
                end
                if sel < 11 and sel ~= nil then
                    SCR_COLLECTION_REWARD_CHECK(self, pc, collection_Name)
                elseif j == math.floor(#reward_List/10) and sel2 == 11 then
                    return
                end
            end
        end
    end
end

function SCR_COLLECTION_SHOP_NORMAL_3(self,pc)
    ShowTradeDlg(pc, 'Magic_Society', 5);
end

function SCR_COLLECTION_REWARD_CHECK(self, pc, collection_Name)
    local aObj = GetAccountObj(pc)
    local col_Obj = GetClassByStrProp('Collection', 'ClassName', collection_Name)
    local rewardList = TryGetProp(col_Obj, "AccGiveItemList")
    local accList = SCR_STRING_CUT(rewardList)
    if aObj[accList[1]] == accList[2] then
        if self.Dialog == "COLLECTION_SHOP" then
            ShowOkDlg(pc, "COLLECT_REWARD_YOU_TAKE_ALREADY_HENRIKA")
        elseif self.Dialog == "ORSHA_COLLECTION_SHOP" then
            ShowOkDlg(pc, "COLLECT_REWARD_YOU_TAKE_ALREADY_FLOANA")
        end
    elseif aObj[accList[1]] ~= accList[2] then
        local itemList = {}
        local itemIndex = {}
        for i = 3, #accList do
            if i%2 ~= 0 then
                itemList[#itemList +1] = accList[i]
            elseif i%2 == 0 then
                itemIndex[#itemIndex +1] = accList[i]
            end
        end
        local col_Count = aObj[accList[1]]
        col_Count = col_Count +1
        local tx = TxBegin(pc);
        for j = 1, #itemList do
            TxGiveItem(tx, itemList[j], itemIndex[j], 'Collection')
        end
        TxSetIESProp(tx, aObj, accList[1], col_Count)
        local ret = TxCommit(tx);
    end
end

--	elseif select == 2 then
--	    SCR_EV161215_SEED_NPC_DIALOG(self, pc)
--	elseif select == 2 then
--	    local dlgTable = {'KLAPEDA_EV160929_SUCC'}
--	    SCR_EV160929_GIVE(pc, dlgTable)
--	elseif select == 2 then
--        -- PLAYTIME_EVENT
--	    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP_OPEN()")
--    end
--	elseif select == 2 then
--        -- ALPHABET_EVENT
--	    local dlgTable = {'HENRIKA_ALPHABET_EVENT_NONE','HENRIKA_ALPHABET_EVENT_SELECT1', 'HENRIKA_ALPHABET_EVENT_FULL'}
--	    SCR_GOLDKEY_EVENT_EXCHANGE(pc, dlgTable)
--	elseif select == 2 then
--        -- HANGEUL_EVENT
--	    local dlgTable = {'KLAPEDA_HANGEUL_EVENT_SELECT1','KLAPEDA_HANGEUL_EVENT_ERROR1'}
--	    SCR_HANGEUL_EVENT_EXCHANGE(pc, dlgTable)
--	elseif select == 2 then
--        -- CHUSEOK_EVENT
--	    local dlgTable = {'KLAPEDA_CHUSEOK_EVENT_SELECT1','KLAPEDA_CHUSEOK_EVENT_ERROR1','KLAPEDA_CHUSEOK_EVENT_ERROR2'}
--	    SCR_CHUSEOK_EVENT_EXCHANGE1(pc, dlgTable)
--	elseif select == 3 then
--        -- CHUSEOK_EVENT
--	    SCR_CHUSEOK_EVENT_EXCHANGE2(pc)
--    end
--end

--function SCR_EV160929_CHECK(pc)
--    local aobj = GetAccountObj(pc);
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    local nowYday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--    local periodList = {{{2016,9,29},{2016,10,9},'Event_160929_1'},{{2016,10,10},{2016,10,19},'Event_160929_2'},{{2016,10,20},{2016,10,27},'Event_160929_3'}}
--    
--    local check, seaStep, seaCount, seaItem, nexonPC
--    
--    if GetServerNation() ~= 'KOR' then
--        check = 'NO'
--        return check
--    end
--    
--    if aobj ~= nil then
--        if aobj.EV160929_DATE < nowYday then
--            for i = 1, #periodList do
--                local startYday = SCR_DATE_TO_YDAY_BASIC_2000(periodList[i][1][1], periodList[i][1][2], periodList[i][1][3])
--                local endYday = SCR_DATE_TO_YDAY_BASIC_2000(periodList[i][2][1], periodList[i][2][2], periodList[i][2][3])
--                if startYday <= nowYday and nowYday <= endYday then
--                    seaStep = i
--                    seaItem = periodList[i][3]
--                    break
--                end
--            end
--            
--            if seaStep ~= nil then
--                if aobj['EV160929_SEA'..seaStep..'_COUNT'] < 7 then
--                    seaCount = aobj['EV160929_SEA'..seaStep..'_COUNT']
--                    check = 'YES'
--                end
--            end
--        end
--    end
--    
--    if IsPremiumState(pc, NEXON_PC) == 1 then
--        nexonPC = 'YES'
--    end
--    
--    return check, seaStep, seaCount, seaItem, nexonPC, nowYday
--end
--
--function SCR_EV160929_GIVE(pc, dlgTable)
--    local check, seaStep, seaCount, seaItem, nexonPC, nowYday = SCR_EV160929_CHECK(pc)
--    local itemCount
--    if check == 'YES' then
--        local giveway = 'EV160929'
--        itemCount = seaCount + 1
--        if nexonPC == 'YES' then
--            itemCount = itemCount * 2
--            giveway = 'EV160929_NEXONPC'
--        end
--        
--        local sObjInfo_add = {{'ACCOUNT','EV160929_SEA'..seaStep..'_COUNT',1}}
--        local sObjInfo_set = {{'ACCOUNT','EV160929_DATE',nowYday}}
--        
--        local ret = GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, {{seaItem,itemCount}}, nil, sObjInfo_add, nil, giveway, sObjInfo_set)
--        if ret == 'SUCCESS' then
--            ShowOkDlg(pc,dlgTable[1], 1)
--            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("EV160929_MSG2","ITEM",GetClassString('Item',seaItem,'Name'),'COUNT',itemCount, 'SEA', seaStep, 'DAYCOUNT',seaCount+1), 10)
--        end
--    end
--end

--function SCR_HANGEUL_EVENT_EXCHANGE(pc, dlgTable)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    local infoList = {
--                        {nil,{{'Event_160818_1',1},{'Event_160818_2',1},{'Event_160818_3',1},{'Event_160818_4',1}},{{'Event_160818_9',1},{'Event_160818_13',5}}},
--                        {nil,{{'Event_160818_1',5},{'Event_160818_2',5},{'Event_160818_3',5},{'Event_160818_4',5}},{{'Event_160818_10',1},{'Event_160818_13',5}}},
--                        {nil,{{'Event_160818_5',1},{'Event_160818_6',1},{'Event_160818_7',1},{'Event_160818_8',1}},{{'Event_160818_11',1},{'Event_160818_13',5}}},
--                        {nil,{{'Event_160818_5',5},{'Event_160818_6',5},{'Event_160818_7',5},{'Event_160818_8',5}},{{'Event_160818_12',1},{'Event_160818_13',5}}},
--                        {{'ACCOUNT','HANGEUL_EVENT_BOX5',1,5},{{'Event_160818_1',1},{'Event_160818_2',1},{'Event_160818_3',1},{'Event_160818_4',1},{'Event_160818_5',1},{'Event_160818_6',1},{'Event_160818_7',1},{'Event_160818_8',1}},{{'gem_circle_1',1},{'gem_square_1',1},{'gem_diamond_1',1},{'gem_star_1',1},{'Event_160818_13',5}}}
--                        }
--    if month >= 9 then
--        infoList[5][3][1][1] = 'Premium_Enchantchip14'
--        infoList[5][3][1][2] = 1
--        table.remove(infoList[5][3],4)
--        table.remove(infoList[5][3],3)
--        table.remove(infoList[5][3],2)
--    end
--    
--    local dayCheckPorp = 'HANGEUL_EVENT_DAY'
--    if dayCheckPorp ~= '' then
--        local nowYday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--        local aObj = GetAccountObj(pc)
--        
--        if aObj[dayCheckPorp] < nowYday then
--            local reflashProp = {}
--            reflashProp[#reflashProp + 1] = {'ACCOUNT', dayCheckPorp, nowYday}
--            reflashProp[#reflashProp + 1] = {'ACCOUNT', 'HANGEUL_EVENT_BOX5', 0}
----            for i = 1, #infoList do
----                local obj
----                if infoList[i][1] ~= nil then
----                    if infoList[i][1][1] == 'ACCOUNT' then
----                        reflashProp[#reflashProp + 1] = {infoList[i][1][1], infoList[i][1][2], GetClassNumber('Account','Account',infoList[i][1][2])}
----                    else
----                        reflashProp[#reflashProp + 1] = {infoList[i][1][1], infoList[i][1][2], GetClassNumber('SessionObject',infoList[i][1][1],infoList[i][1][2])}
----                    end
----                end
----            end
--            GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, nil, nil, nil, nil, 'HANGEUL_EVENT_REFLASH', reflashProp)
--        end
--    end
--    
--    local selCount = 0
--    local selectList = {}
--    for i = 1, #infoList do
--        local obj
--        if infoList[i][1] ~= nil then
--            if infoList[i][1][1] == 'ACCOUNT' then
--                obj = GetAccountObj(pc)
--            else
--                obj = GetSessionObject(pc, infoList[i][1][1])
--            end
--            if obj == nil then
--                return
--            end
--        end
--        
--        if infoList[i][1] == nil or obj[infoList[i][1][2]] < infoList[i][1][4] then
--            local flag1 = 0
--            local itemText2 = ''
--            if #infoList[i][2] > 0 then
--                for i2 = 1, #infoList[i][2] do
--                    if GetInvItemCount(pc, infoList[i][2][i2][1]) < infoList[i][2][i2][2] then
--                        flag1 = 1
--                        break
--                    else
--                        itemText2 = itemText2..GetClassString('Item', infoList[i][2][i2][1], 'Name')
----                        itemText2 = itemText2..GetClassString('Item', infoList[i][2][i2][1], 'Name')..'x'..infoList[i][2][i2][2]
--                    end
--                end
--                    itemText2 = itemText2..'x'..infoList[i][2][1][2]
--            end
----            itemText2 = string.sub(itemText2,1,string.len(itemText2)-1)
--            
--            local itemText1 = ''
--            if #infoList[i][3] > 0 then
--                for i2 = 1, #infoList[i][3] do
--                    itemText1 = itemText1..GetClassString('Item', infoList[i][3][i2][1], 'Name')..'x'..infoList[i][3][i2][2]
--                end
--            end
----            itemText1 = string.sub(itemText1,1,string.len(itemText1)-1)
--            
--            local countText = ''
--            if infoList[i][1] ~= nil then
--                countText = '['..obj[infoList[i][1][2]]..'/'..infoList[i][1][4]..']'
--            end
--            if flag1 == 0 then
--                if countText == '' then
--                    selectList[#selectList + 1] = itemText2
--                else
--                    selectList[#selectList + 1] = ScpArgMsg('HANGEUL_EVENT_MSG3','ITEM2', itemText2,'COUNT1',countText,'COUNT2',obj['HANGEUL_EVENT_COUNT5'])
--                end
--                selCount = selCount + 1
--            else
--                selectList[#selectList + 1] = ''
--            end
--        end
--    end
--    
--    if selCount == 0 then
--        ShowOkDlg(pc,dlgTable[2], 1)
--        return
--    end
--    local sel = SCR_SEL_LIST(pc,selectList, dlgTable[1], 1)
--    if sel ~= nil and sel > 0 and sel <= #infoList then
--        local obj
--        if infoList[sel][1] ~= nil then
--            if infoList[sel][1][1] == 'ACCOUNT' then
--                obj = GetAccountObj(pc)
--            else
--                obj = GetSessionObject(pc, infoList[sel][1][1])
--            end
--            if obj == nil then
--                return
--            end
--        end
--        
--        if infoList[sel][1] == nil or obj[infoList[sel][1][2]] < infoList[sel][1][4] then
--            local flag1 = 0
--            if #infoList[sel][2] > 0 then
--                for i2 = 1, #infoList[sel][2] do
--                    if GetInvItemCount(pc, infoList[sel][2][i2][1]) < infoList[sel][2][i2][2] then
--                        flag1 = 1
--                        break
--                    end
--                end
--            end
--            if flag1 == 0 then
--                local sObjInfo_add = {infoList[sel][1]}
--                if sel == 5 then
--                    if obj.HANGEUL_EVENT_COUNT5 == 9 then
--                        infoList[sel][3][#infoList[sel][3] + 1] = {'Premium_boostToken02_event01',2}
--                    elseif obj.HANGEUL_EVENT_COUNT5 == 19 then
--                        infoList[sel][3][#infoList[sel][3] + 1] = {'Hat_628097',1}
--                    elseif obj.HANGEUL_EVENT_COUNT5 == 29 then
--                        infoList[sel][3][#infoList[sel][3] + 1] = {'Artefact_630005',1}
--                    end
--                    sObjInfo_add[#sObjInfo_add + 1] = {'ACCOUNT','HANGEUL_EVENT_COUNT5',1}
--                end
--                GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, infoList[sel][3], infoList[sel][2], sObjInfo_add, nil, 'HANGEUL_EVENT_EXCHANGE', nil)
--                if sel == 5 then
--                    SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("HANGEUL_EVENT_MSG4","COUNT",obj.HANGEUL_EVENT_COUNT5), 10);
--                end
--            end
--        end
--    end
--end

function SCR_CHUSEOK_EVENT_EXCHANGE1(pc, dlgTable)
    local input = ShowTextInputDlg(pc, 0, dlgTable[1])
    local price = 100
    input = tonumber(input)
    if input ~= nil then
        local count = GetInvItemCount(pc, 'Vis')
        local value = price * input
        if count >= value then
            GIVE_TAKE_ITEM_TX(pc, 'R_Event_160908_5/'..input, 'Vis/'..value, 'CHUSEOK_EVENT')
        else
            ShowOkDlg(pc,dlgTable[2], 1)
        end
    else
        ShowOkDlg(pc,dlgTable[3], 1)
    end
end

function SCR_CHUSEOK_EVENT_EXCHANGE2(pc)
    local aobj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowYday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
    if aobj ~= nil then
        if aobj.CHUSEOK_EVENT_DATE < nowYday or aobj.CHUSEOK_EVENT_DAY_COUNT < 3 then
            if aobj.CHUSEOK_EVENT_DATE ~= nowYday then
                local giveItem = 'R_Event_160908_6/3'
                if IsPremiumState(pc, NEXON_PC) == 1 then
                    giveItem = 'R_Event_160908_6/6'
                end
                GIVE_TAKE_SOBJ_ACHIEVE_TX(pc, giveItem, nil, nil, nil, 'CHUSEOK_EVENT', 'ACCOUNT/CHUSEOK_EVENT_DATE/'..nowYday..'/ACCOUNT/CHUSEOK_EVENT_DAY_COUNT/3')
            end
        end
    end
end

--function SCR_GOLDKEY_EVENT_EXCHANGE(pc, dlgTable)
--    local sObj = GetSessionObject(pc, 'ssn_klapeda')
--    if sObj == nil then
--        return
--    end
--    local aObj = GetAccountObj(pc);
--    if aObj == nil then
--        return
--    end
--    
--    local itemCount = GetInvItemCount(pc, 'Event_160609')
--    
--    local addPropName = {'GOLDKEY_EVENT_BOX1','GOLDKEY_EVENT_BOX2','GOLDKEY_EVENT_BOX3','GOLDKEY_EVENT_BOX4','GOLDKEY_EVENT_BOX5', 'GOLDKEY_EVENT_BOX_TP'}
--    local addPropType = {'ssn_klapeda','ssn_klapeda','ssn_klapeda','ssn_klapeda','ssn_klapeda','ACCOUNT'}
--    local addPropValue = {1,1,1,1,1,1}
--    local addPropMax = {0,0,0,2,0,1}
--    local takeCount = {1,3,5,9,15,4}
--    
--    local sel1, sel2, sel3, sel4, sel5, sel6
--    
--    if itemCount >= takeCount[1] and (addPropMax[1] == 0 or sObj[addPropName[1]] < addPropMax[1]) then
--        local txt = ''
--        if addPropMax[1] ~= 0 then
--            txt = '('..sObj[addPropName[1]]..'/'..addPropMax[1]..')'
--        end
--        sel1 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_1',"KEYCOUNT", takeCount[1],"TEXT",txt)
--    end
--    if itemCount >= takeCount[2] and (addPropMax[2] == 0 or sObj[addPropName[2]] < addPropMax[2]) then
--        local txt = ''
--        if addPropMax[2] ~= 0 then
--            txt = '('..sObj[addPropName[2]]..'/'..addPropMax[2]..')'
--        end
--        sel2 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_2',"KEYCOUNT", takeCount[2],"TEXT",txt)
--    end
--    if itemCount >= takeCount[3] and (addPropMax[3] == 0 or sObj[addPropName[3]] < addPropMax[3]) then
--        local txt = ''
--        if addPropMax[3] ~= 0 then
--            txt = '('..sObj[addPropName[3]]..'/'..addPropMax[3]..')'
--        end
--        sel3 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_4',"KEYCOUNT", takeCount[3],"TEXT",txt)
--    end
--    if itemCount >= takeCount[4] and (addPropMax[4] == 0 or sObj[addPropName[4]] < addPropMax[4]) then
--        local txt = ''
--        if addPropMax[4] ~= 0 then
--            txt = '('..sObj[addPropName[4]]..'/'..addPropMax[4]..')'
--        end
--        sel4 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_5',"KEYCOUNT", takeCount[4],"TEXT",txt)
--    end
--    if itemCount >= takeCount[5] and (addPropMax[5] == 0 or sObj[addPropName[5]] < addPropMax[5]) then
--        local txt = ''
--        if addPropMax[5] ~= 0 then
--            txt = '('..sObj[addPropName[5]]..'/'..addPropMax[5]..')'
--        end
--        sel5 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_6',"KEYCOUNT", takeCount[5],"TEXT",txt)
--    end
--    if itemCount >= takeCount[6] and (addPropMax[6] == 0 or aObj[addPropName[6]] < addPropMax[6]) then
--        local txt = ''
--        if addPropMax[6] ~= 0 then
--            txt = '('..aObj[addPropName[6]]..'/'..addPropMax[6]..')'
--        end
--        sel6 = ScpArgMsg('GOLDKEY_EVENT_EXCHANGE_3',"KEYCOUNT", takeCount[6],"TEXT",txt)
--    end
--    if sel1 == nil and sel2 == nil and sel3 == nil and sel4 == nil and sel5 == nil and sel6 == nil then
--        ShowOkDlg(pc, dlgTable[1], 1)
--    else
--        local select2 = ShowSelDlg(pc, 0, dlgTable[2], sel1, sel2, sel3, sel4, sel5, sel6, ScpArgMsg('Auto_DaeHwa_JongLyo'))	        
--	    itemCount = GetInvItemCount(pc, 'Event_160609')
--	    
--	    local seltype
--	    local takeItem = 'Event_160609'
--        if select2 == 1 then
--            if itemCount >= takeCount[1] and (addPropMax[1] == 0 or sObj[addPropName[1]] < addPropMax[1]) then
--                seltype = select2
--            end
--        elseif select2 == 2 then
--            if itemCount >= takeCount[2] and (addPropMax[2] == 0 or sObj[addPropName[2]] < addPropMax[2]) then
--                seltype = select2
--            end
--        elseif select2 == 3 then
--            if itemCount >= takeCount[3] and (addPropMax[3] == 0 or sObj[addPropName[3]] < addPropMax[3]) then
--                seltype = select2
--            end
--        elseif select2 == 4 then
--            if itemCount >= takeCount[4] and (addPropMax[4] == 0 or sObj[addPropName[4]] < addPropMax[4]) then
--                seltype = select2
--            end
--        elseif select2 == 5 then
--            if itemCount >= takeCount[5] and (addPropMax[5] == 0 or sObj[addPropName[5]] < addPropMax[5]) then
--                seltype = select2
--            end
--        elseif select2 == 6 then
--            if itemCount >= takeCount[6] and (addPropMax[6] == 0 or aObj[addPropName[6]] < addPropMax[6]) then
--                seltype = select2
--            end
--        end
--        
--        if seltype ~= nil then
--            takeItem = takeItem..'/'..takeCount[select2]
----            local giveItemList = {'GIMMICK_TRANSFORM_POPOLION/1', 'GIMMICK_TRANSFORM_FERRET/1', 'GIMMICK_TRANSFORM_TINY/1', 'GIMMICK_TRANSFORM_PHANTO/1', 'GIMMICK_TRANSFORM_HONEY/1', 'GIMMICK_TRANSFORM_ONION/1'}
--            local giveItemList = {'Event_160609_4/1','Event_160609_1/1','Event_160609_6/1','Event_160609_2/1','Event_160609_3/1','Event_160609_5/1'}
--            local achieve_list
--            GIVE_TAKE_SOBJ_ACHIEVE_TX(pc, giveItemList[seltype], takeItem, addPropType[seltype]..'/'..addPropName[seltype]..'/'..addPropValue[seltype], nil, 'GOLDKEYEVENT_EXCHANGE')
--        end
--    end
--end

--function SCR_ALPHABET_EVENT_EXCHANGE(pc, dlgTable)
--    local sObj = GetSessionObject(pc, 'ssn_klapeda')
--    if sObj == nil then
--        return
--    end
--    
--    local tCount = GetInvItemCount(pc, 'event_alphabet_T')
--    local rCount = GetInvItemCount(pc, 'event_alphabet_R')
--    local eCount = GetInvItemCount(pc, 'event_alphabet_E')
--    local oCount = GetInvItemCount(pc, 'event_alphabet_O')
--    local fCount = GetInvItemCount(pc, 'event_alphabet_F')
--    local sCount = GetInvItemCount(pc, 'event_alphabet_S')
--    local aCount = GetInvItemCount(pc, 'event_alphabet_A')
--    local vCount = GetInvItemCount(pc, 'event_alphabet_V')
--    local iCount = GetInvItemCount(pc, 'event_alphabet_I')
--    local addPropName = {'ALPHABET_EVENT_1_1','ALPHABET_EVENT_1_1','ALPHABET_EVENT_1_2','ALPHABET_EVENT_1_2','ALPHABET_EVENT_1_3'}
--    local addPropValue = {1,5,1,5,1}
--    
--    local sel1, sel2, sel3, sel4, sel5
--    
--    if tCount >= 1 and rCount >= 1 and eCount >= 2 and sObj[addPropName[1]] < 400 then
--        sel1 = ScpArgMsg('ALPHABET_EVENT_EXCHANGE_TREE1',"COUNT", sObj[addPropName[1]],"MAX", 400)
--    end
--    
--    if tCount >= 5 and rCount >= 5 and eCount >= 10 and sObj[addPropName[2]] < 396 then
--	    sel2 = ScpArgMsg('ALPHABET_EVENT_EXCHANGE_TREE5',"COUNT", sObj[addPropName[2]],"MAX", 400)
--	end
--    
--    if sCount >= 1 and aCount >= 1 and vCount >= 1 and iCount >= 1 and oCount >= 1 and rCount >= 1 and sObj[addPropName[3]] < 400  then
--	    sel3 = ScpArgMsg('ALPHABET_EVENT_EXCHANGE_SAVIOR1',"COUNT", sObj[addPropName[3]],"MAX", 400)
--	end
--    
--    if sCount >= 5 and aCount >= 5 and vCount >= 5 and iCount >= 5 and oCount >= 5 and rCount >= 5 and sObj[addPropName[4]] < 396  then
--	    sel4 = ScpArgMsg('ALPHABET_EVENT_EXCHANGE_SAVIOR5',"COUNT", sObj[addPropName[4]],"MAX", 400)
--	end
--    
--    if tCount >= 1 and rCount >= 2 and eCount >= 2 and oCount >= 2 and fCount >= 1 and sCount >= 1 and aCount >= 1 and vCount >= 1 and iCount >= 1 and sObj[addPropName[5]] < 50  then
--	    sel5 = ScpArgMsg('ALPHABET_EVENT_EXCHANGE_TREEOFSAVIOR1',"COUNT", sObj[addPropName[5]],"MAX", 50)
--	end
--    
--    if sel1 == nil and sel2 == nil and sel3 == nil and sel4 == nil and sel5 == nil then
--        if sObj[addPropName[1]] >= 400 and sObj[addPropName[3]] >= 400 and sObj[addPropName[5]] >= 50 then
--            ShowOkDlg(pc, dlgTable[3], 1)
--        else
--            ShowOkDlg(pc, dlgTable[1], 1)
--        end
--    else
--        local select2 = ShowSelDlg(pc, 0, dlgTable[2], sel1, sel2, sel3, sel4, sel5, ScpArgMsg('Auto_DaeHwa_JongLyo'))	        
--	    tCount = GetInvItemCount(pc, 'event_alphabet_T')
--	    rCount = GetInvItemCount(pc, 'event_alphabet_R')
--	    eCount = GetInvItemCount(pc, 'event_alphabet_E')
--	    oCount = GetInvItemCount(pc, 'event_alphabet_O')
--	    fCount = GetInvItemCount(pc, 'event_alphabet_F')
--	    sCount = GetInvItemCount(pc, 'event_alphabet_S')
--	    aCount = GetInvItemCount(pc, 'event_alphabet_A')
--	    vCount = GetInvItemCount(pc, 'event_alphabet_V')
--	    iCount = GetInvItemCount(pc, 'event_alphabet_I')
--	    
--	    local seltype
--	    local takeItem
--        if select2 == 1 then
--            if tCount >= 1 and rCount >= 1 and eCount >= 2 and sObj[addPropName[1]] < 400 then
--                seltype = select2
--                takeItem = 'event_alphabet_T/1/event_alphabet_R/1/event_alphabet_E/2'
--            end
--        elseif select2 == 2 then
--            if tCount >= 5 and rCount >= 5 and eCount >= 10 and sObj[addPropName[2]] < 396 then
--                seltype = select2
--                takeItem = 'event_alphabet_T/5/event_alphabet_R/5/event_alphabet_E/10'
--        	end
--        elseif select2 == 3 then
--            if sCount >= 1 and aCount >= 1 and vCount >= 1 and iCount >= 1 and oCount >= 1 and rCount >= 1 and sObj[addPropName[3]] < 400  then
--                seltype = select2
--                takeItem = 'event_alphabet_S/1/event_alphabet_A/1/event_alphabet_V/1/event_alphabet_I/1/event_alphabet_O/1/event_alphabet_R/1'
--        	end
--        elseif select2 == 4 then
--            if sCount >= 5 and aCount >= 5 and vCount >= 5 and iCount >= 5 and oCount >= 5 and rCount >= 5 and sObj[addPropName[4]] < 396  then
--                seltype = select2
--                takeItem = 'event_alphabet_S/5/event_alphabet_A/5/event_alphabet_V/5/event_alphabet_I/5/event_alphabet_O/5/event_alphabet_R/5'
--        	end
--        elseif select2 == 5 then
--            if tCount >= 1 and rCount >= 2 and eCount >= 2 and oCount >= 2 and fCount >= 1 and sCount >= 1 and aCount >= 1 and vCount >= 1 and iCount >= 1 and sObj[addPropName[5]] < 50  then
--                seltype = select2
--                takeItem = 'event_alphabet_T/1/event_alphabet_R/2/event_alphabet_E/2/event_alphabet_O/2/event_alphabet_F/1/event_alphabet_S/1/event_alphabet_A/1/event_alphabet_V/1/event_alphabet_I/1'
--        	end
--        end
--        
--        if seltype ~= nil then
--            local giveItemList = {'Gacha_E_008/1', 'Gacha_E_010/1', 'Gacha_E_009/1', 'Gacha_E_011/1', 'Gacha_E_012/1'}
--            local achieve_list
--            GIVE_TAKE_SOBJ_ACHIEVE_TX(pc, giveItemList[seltype], takeItem, 'ssn_klapeda/'..addPropName[seltype]..'/'..addPropValue[seltype], nil, 'ALPHABET_EVENT_REWARD')
--            local eventAchieveValue = GetAchievePoint(pc, 'AlphabetEvent1')
--            if eventAchieveValue < 1 and sObj[addPropName[1]] >= 300 and sObj[addPropName[3]] >= 300 and sObj[addPropName[5]] >= 2 then
--                local tx = TxBegin(pc);
--                TxAddAchievePoint(tx, 'AlphabetEvent1', 1)
--                local ret = TxCommit(tx);
--            end
--        end
--    end
--end



function SCR_JOURNEY_SHOP_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end
         
function SCR_JOURNEY_SHOP_NORMAL_1(self, pc)
    local tiem = GetDBTime()
    local db_Day =string.format("%02d", tiem.wDay);
    if tonumber(db_Day) >= 1 and tonumber(db_Day) <= 27 then
        local now_time = os.date('*t')
        local Rank_Count_Time = now_time['min']
        if db_Day == "01" and Rank_Count_Time < 15 then
            local sel = ShowSelDlg(pc, 0, "REAN_ADVENTUREBOOK_SEASON_COUNTING", ScpArgMsg("Yes"), ScpArgMsg("No"))
            if sel == 1 then
                REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
            else
                return
            end
        else
            local my_Rank, my_Point, ranker_cnt = GetLastAdventureBookRank(pc, "Initialization_point")
            local my_Item_Rank, my_Item_Point, item_ranker_cnt = GetLastAdventureBookRank(pc, "Item_Consume_point")
            --print("my_Point : "..my_Point)
            if my_Point <= 0 then
                REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                return
            end
            my_Rank = my_Rank + 1
            my_Item_Rank = my_Item_Rank + 1
            if my_Item_Rank == 1 and my_Item_Point > 0 then
                if 1 <= my_Rank and 300 >= my_Rank then
                    local sel = ShowSelDlg(pc, 0, "REAN_ADVENTUREBOOK_REWARD_CHECK1", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local rank, cnt = GetClassList("AdventureBookRankReward")
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            if 1 == my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FirstHighRank", my_Item_Rank)
                            elseif 2 <= my_Rank and 10 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"HighRank", my_Item_Rank)
                            elseif 11 <= my_Rank and 100 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"ThirdRank", my_Item_Rank)
                            elseif 101 <= my_Rank and 200 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FourthRank", my_Item_Rank)
                            elseif 201 <= my_Rank and 300 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FifthRank", my_Item_Rank)
                            end
                        else
                            ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD2", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                elseif 0 == my_Rank or 300 < my_Rank then
                    local sel = ShowSelDlg(pc, 0, "REAN_ADVENTUREBOOK_REWARD_CHECK2", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            local tx = TxBegin(pc);
                            TxAddAchievePoint(tx, "Journal_AP6", 10);
                            TxSetIESProp(tx, AccountObj, "AdventureBookRecvReward", 1)
                            local ret = TxCommit(tx);
                            if ret == 'FAIL' then
                                print("tx Fail")
                            elseif ret == 'SUCCESS' then
                                --AdventureBookRewardRankingMongoLog(pc, 'Journal_AP6', my_Item_Rank, itemClassNameList, itemCountList);
                            end
                        else
                            ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD3", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                end
            elseif my_Item_Rank > 1 or my_Item_Rank == 0 then
                if 1 <= my_Rank and 300 >= my_Rank then
                    local sel = ShowSelDlg(pc, 0, "REAN_ADVENTUREBOOK_REWARD_CHECK", ScpArgMsg("Yes"), ScpArgMsg("No"))
                    if sel == 1 then
                        local rank, cnt = GetClassList("AdventureBookRankReward")
                        local aObj = GetAccountObj(pc);
                        if aObj.AdventureBookRecvReward < 1 then
                            if 1 == my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FirstHighRank")
                            elseif 2 <= my_Rank and 10 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"HighRank")
                            elseif 11 <= my_Rank and 100 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"ThirdRank")
                            elseif 101 <= my_Rank and 200 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FourthRank")
                            elseif 201 <= my_Rank and 300 >= my_Rank then
                                ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD1\\"..ScpArgMsg('RENA_ADVENTUREBOOK_REWARD_RANK','RANK',my_Rank), 1)
                                ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, aObj, rank, cnt, my_Rank,"FifthRank")
                            end
                        else
                            ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD_TAKE", 1)
                        	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                            ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                        end
                    else
                        ShowOkDlg(pc, "RENA_ADVENTUREBOOK_REWARD2", 1)
                    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                    end
                else
                	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                    ExecClientScp(pc, "OPEN_DO_JOURNAL()")
                end
            else
            	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
                ExecClientScp(pc, "OPEN_DO_JOURNAL()")
            end
        end
    else
    	REGISTERR_LASTUIOPEN_POS_SERVER(pc, "adventure_book")
        ExecClientScp(pc, "OPEN_DO_JOURNAL()")
    end
end

function ADVENTURE_BOOK_RANK_REWARD_FUNC(pc, AccountObj, rank, cnt, pc_rank, adv_rank, my_Item_Rank)
    local itemClassNameList = {};
    local itemCountList = {};
    local tx = TxBegin(pc);
    for i = 0, cnt-1 do
        local cls = GetClassByIndexFromList(rank, i);
        if cls.ClassName == adv_rank then
            for j = 1, 6 do
            --print(adv_rank, cls["Reward"..j], cls["Reward"..j.."_Count"])
                if cls["Reward"..j] ~= "None" and cls["Reward"..j] ~= nil then
                    local reward = cls["Reward"..j]
                    local count = cls["Reward"..j.."_Count"]
                    --print(reward)
                    TxGiveItem(tx, reward, count, 'AdventureBook_'..cls.ClassName);
                    itemClassNameList[#itemClassNameList + 1] = cls["Reward"..j]
                    itemCountList[#itemCountList + 1] = cls["Reward"..j.."_Count"]
                end
            end
            if cls.AchiveName ~= nil and cls.AchiveName ~= "None" then
                TxAddAchievePoint(tx, cls.AchiveName, cls.AchivePoint);
                ADDBUFF(pc, pc, cls.AchiveName, 0, 0, 604740000);
            end
            if my_Item_Rank ~= nil then
                if my_Item_Rank == 1 then
                    TxAddAchievePoint(tx, "Journal_AP6", 10);
                    ADDBUFF(pc, pc, "Journal_AP6", 0, 0, 604740000);
                end
            end
            TxSetIESProp(tx, AccountObj, "AdventureBookRecvReward", 1)
            --print(AccountObj.AdventureBookRecvReward)
            break;
        end
    end
    local ret = TxCommit(tx);
    if ret == 'FAIL' then
        print("tx Fail")
    elseif ret == 'SUCCESS' then
        AdventureBookRewardRankingMongoLog(pc, 'Initialization_point', pc_rank, itemClassNameList, itemCountList);
    end
end

function SCR_JOURNEY_SHOP_NORMAL_2(self, pc)
    local mapList, mapSelList = SCR_JOURNAL_MAP_REWARD_CHECK(pc)
    if mapList ~= nil and #mapList > 0 then
        local select = SCR_SEL_LIST(pc, mapSelList, 'RENA_NORMAL3_SELECT1', 1)
        if select ~= nil and select >= 1 and select <= #mapList then
            SCR_JOURNAL_MAP_REWARD_GIVE(pc, mapList, select)
        end
    else
        ShowOkDlg(pc, 'RENA_NORMAL3_NULL1', 1)
    end
end

function SCR_JOURNEY_SHOP_NORMAL_3(self, pc)
    SCR_RANK8_EVENT(self,pc)
end
function SCR_RANK8_EVENT_PRECHECK(pc,funcInfo)
    local pcRank =  GetTotalJobCount(pc)
    if pcRank >= 8 then
        local achieveValue = GetAchievePoint(pc, 'Rank8AchievePoint')
        if achieveValue == 0 then
            return 'YES'
        end
    end
    return 'NO'
end
function SCR_RANK8_EVENT(self,pc)
    local pcRank =  GetTotalJobCount(pc)
    if pcRank >= 8 then
        local zoneName = GetZoneName(self)
        local achieveValue = GetAchievePoint(pc, 'Rank8AchievePoint')
        if achieveValue == 0 then
            GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, nil, nil, nil, {{'Rank8AchievePoint',1}}, 'RANK8_EVENT_REWARD', nil)
            if zoneName == 'c_Klaipe' then
                ShowOkDlg(pc, 'KLAPDEA_RANK8_EVENT_DLG1', 1)
            else
                ShowOkDlg(pc, 'ORSHA_RANK8_EVENT_DLG1', 1)
            end
        end
    end
end

function SCR_JOURNEY_SHOP_NORMAL_4(self, pc)
    SCR_GUILD_BATTLE_WEEKLYPLAYREWARD(self,pc)
end

function SCR_GUILD_BATTLE_WEEKLYPLAYREWARD(self, pc)
    if SCR_GUILD_BATTLE_WEEKLYPLAYREWARD_PRECHECK(pc) == 'YES' then
        local aobj = GetAccountObj(pc)
        if aobj ~= nil then
            local dlgMsg
            local zoneName = GetZoneName(self)
            if zoneName == 'c_Klaipe' then
                dlgMsg = 'KLAPDEA_GUILD_BATTLE_WEEKLYPLAYREWARD_SEL1'
            else
                dlgMsg = 'ORSHA_GUILD_BATTLE_WEEKLYPLAYREWARD_SEL1'
            end
            local itemList = {'BRC99_109','BRC99_110','BRC99_111'}
            
            local select = ShowSelDlg(pc, 0, dlgMsg, GetClassString('Item', itemList[1], 'Name'), GetClassString('Item', itemList[2], 'Name'), GetClassString('Item', itemList[3], 'Name') ,ScpArgMsg('Auto_DaeHwa_JongLyo'))
            if select >= 1 and select <= 3 then
--                local sObjInfo_add = {{'ACCOUNT','EV160929_SEA'..seaStep..'_COUNT',1}}
                local sObjInfo_set = {{'ACCOUNT','GuildBattleWeeklyPlayReward', 1}}
                
                local ret = GIVE_TAKE_SOBJ_ACHIEVE_TABLE_TX(pc, {{itemList[select],1}}, nil, nil, nil, 'GuildBattleWeeklyPlayReward', sObjInfo_set)
            end
        end
    end
end

function SCR_GUILD_BATTLE_WEEKLYPLAYREWARD_PRECHECK(pc,funcInfo)
--    local aobj = GetAccountObj(pc)
--    
--    if aobj ~= nil  and aobj.GuildBattleWeeklyPlayReward == 0 and aobj.GuildBattleWeeklyPlayCnt >= 3 then
--        return 'YES'
--    end
    
    return 'NO'
end


function SCR_JOURNEY_SHOP_NORMAL_5(self, pc)
    SCR_GUILD_BATTLE_MASTERREWARD(self,pc)
end

function SCR_GUILD_BATTLE_MASTERREWARD(self, pc)
    if SCR_GUILD_BATTLE_MASTERREWARD_PRECHECK(pc) == 'YES' then
        local guildObj = GetGuildObj(pc);
        if guildObj ~= nil then
            local dlgMsg
            local zoneName = GetZoneName(self)
            if zoneName == 'c_Klaipe' then
                dlgMsg = 'KLAPDEA_GUILD_BATTLE_MASTERREWARD_SEL1'
            else
                dlgMsg = 'ORSHA_GUILD_BATTLE_MASTERREWARD_SEL1'
            end
            
            ShowOkDlg(pc,dlgMsg, 1)
            
            ChangePartyProp(pc, PARTY_GUILD, "GuildBattleWeeklyJoinReward", 1)
            local tx = TxBegin(pc);
            _TxGiveItemToPartyWareHouse(tx, PARTY_GUILD, 'misc_silverbar', 10, 'GuildBattleMasterReward', 0, nil)
            local ret = TxCommit(tx);
        end
    end
end

function SCR_JOURNEY_SHOP_NORMAL_6(self, pc)
    local txt1 = 'RENA_ADVENTUREBOOK_REWARD_PRETRADE'
    local txt2 = 'RENA_ADVENTUREBOOK_REWARD_TRADE1'
    local txt3 = 'RENA_ADVENTUREBOOK_REWARD_YET\\'
    SCR_ADVENTURE_BOOK_COMPENIAN_TRADE(self, pc, txt1, txt2, txt3)
end

function SCR_JOURNEY_SHOP_NORMAL_6_PRE(self)
    local ticket_arr = {"Companion_Exchange_Ticket",
                        "Companion_Exchange_Ticket2",
                        "Companion_Exchange_Ticket3",
                        "Companion_Exchange_Ticket4",
                        "Companion_Exchange_Ticket5",
                        "Companion_Exchange_Ticket6",
                        "Companion_Exchange_Ticket7",
                        "Companion_Exchange_Ticket8",
                        "Companion_Exchange_Ticket9",
                       }
    for i = 1, #ticket_arr do
        if SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_PRE(self, ticket_arr[i]) == 1 then
        return 'YES'
    end
    end
end

function SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_PRE(self, itemCls)
    local trade_Item1 = GetInvItemCount(self, itemCls)
    if trade_Item1 >=1 then
        return 1
    end
end

function SCR_JOURNEY_SHOP_NORMAL_7(self, pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_prop < 100 then
        local sel = ShowSelDlg(pc, 0, 'CHAR120_MSTEP4_1_DLG1', ScpArgMsg("CHAR120_MSTEP4_1_MSG1"), ScpArgMsg("CHAR120_MSTEP4_1_MSG2"))
        if sel == 1 then
            ShowOkDlg(pc, 'CHAR120_MSTEP4_1_DLG2', 1)
                SCR_SET_HIDDEN_JOB_PROP(pc, 'Char1_20', 100)
                --print(isHideNPC(pc, "CHAR120_MSTEP5_NPC1"))
        end
        if isHideNPC(pc, "CHAR120_MSTEP5_NPC1") == "YES" then
            UnHideNPC(pc, "CHAR120_MSTEP5_NPC1")
        end
    elseif hidden_prop == 100 then
        ShowOkDlg(pc, 'CHAR120_MSTEP4_1_DLG3', 1)
        if isHideNPC(pc, "CHAR120_MSTEP5_NPC1") == "YES" then
            UnHideNPC(pc, "CHAR120_MSTEP5_NPC1")
        end
    end
end

function SCR_JOURNEY_SHOP_NORMAL_7_PRE(self)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(self, "Char1_20")
    if hidden_prop >= 60 or hidden_prop == 100 then
        return 'YES'
    else
        return 'NO'
    end
end

function SCR_ADVENTURE_BOOK_COMPENIAN_TRADE(self, pc, txt1, txt2, txt3)
    local ticket_arr = {"Companion_Exchange_Ticket",
                        "Companion_Exchange_Ticket2",
                        "Companion_Exchange_Ticket3",
                        "Companion_Exchange_Ticket4",
                        "Companion_Exchange_Ticket5",
                        "Companion_Exchange_Ticket6",
                        "Companion_Exchange_Ticket7",
                        "Companion_Exchange_Ticket8",
                        "Companion_Exchange_Ticket9"
                       }
    local trade_selDlg = {}
    local companion_arr = {}
    local msg
    --local trade_sel1, trade_sel2, trade_sel3, trade_sel4, trade_sel5, trade_sel6, trade_sel7, trade_sel8, trade_sel9 = nil
    for i = 1, #ticket_arr do
        local item_Cnt = GetInvItemCount(pc, ticket_arr[i])
        if item_Cnt >=1 then
            trade_selDlg[i] = ScpArgMsg("Companion_Exchange_Ticket"..i)
            companion_arr[i] = ScpArgMsg("Adventure_Companion"..i)
        else
            trade_selDlg[i] = nil
            companion_arr[i] = nil
        end
    end
    local sel = ShowSelDlg(pc, 0, txt1, trade_selDlg[1], trade_selDlg[2], trade_selDlg[3], trade_selDlg[4], trade_selDlg[5], trade_selDlg[6], trade_selDlg[7], trade_selDlg[8], trade_selDlg[9])
    if sel == 1 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[1])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[1])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket", "egg_003", "AdventureBook_egg_003_Give", "Companion_Trade_Take")
    elseif sel == 2 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[2])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[2])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket2", "egg_017", "AdventureBook_egg_012_Give", "Companion_Trade_Take")
    elseif sel == 3 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[3])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[3])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket3", nil, nil, "Companion_Trade_Take")
    elseif sel == 4 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[4])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[4])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket4", nil, nil, "Companion_Trade_Take")
    elseif sel == 5 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[5])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[5])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket5", nil, nil, "Companion_Trade_Take")
    elseif sel == 6 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[6])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[6])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket6", nil, nil, "Companion_Trade_Take")
    elseif sel == 7 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[7])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[7])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket7", nil, nil, "Companion_Trade_Take")
    elseif sel == 8 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[8])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[8])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket8", nil, nil, "Companion_Trade_Take")
    elseif sel == 9 then
        if self.ClassName == "npc_rena" then
            msg = ScpArgMsg("RENA_Adventure_Companion_YET", "COMPANION", companion_arr[9])
        elseif self.ClassName == "npc_racia" then
            msg = ScpArgMsg("RACIA_Adventure_Companion_YET", "COMPANION", companion_arr[9])
        end
        SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, "Companion_Exchange_Ticket9", nil, nil, "Companion_Trade_Take")
    end
end

function SCR_ADVENTURE_BOOK_COMPENIAN_TRADE_CHECK(pc, txt2, txt3, msg, ticket_item, compaion_item, givelog, takelog)
    local trade_Item1 = GetInvItemCount(pc, ticket_item)
    if trade_Item1 >= 20 then
        ShowOkDlg(pc, txt2, 1)
        local tx = TxBegin(pc);
        TxGiveItem(tx, compaion_item, 1, givelog);
        TxTakeItem(tx, ticket_item, 20, takelog);
        local ret = TxCommit(tx);
        if ret == 'FAIL' then
            print("Trade tx Fail")
        elseif ret == 'SUCCESS' then
            print("Trade tx Success")
        end
    else
        ShowOkDlg(pc, txt3..msg, 1)
    end
end


function SCR_GUILD_BATTLE_MASTERREWARD_PRECHECK(pc,funcInfo)
--    local guildObj = GetGuildObj(pc);
--    if guildObj ~= nil then
--        local isLeader = IsPartyLeaderPc(guildObj, pc);
--        if isLeader == 1 then
--            if guildObj.GuildBattleWeeklyJoinReward == 0 and guildObj.GuildBattleWeeklyJoinCnt >= 1 then
--                return 'YES'
--            end
--        end
--    end
    return 'NO'
end

function SCR_TUTO_JOURNAL_NPC_ENTER(self, pc)
	if 1 == IsDummyPC(pc) then
		return;
	end

    AddHelpByName(pc, "TUTO_JOURNAL")

    local journalMapFogRewardAll = GetExProp(pc, 'JourneyQusetRewardAll')
    if journalMapFogRewardAll ~= 300 then
        local list, cnt = SCR_JOURNEY_QUEST_REWARD_CHECK(pc)
        if list ~= nil and #list > 0 then
            SetExProp(pc,'JourneyQusetRewardAll',300)
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("JourneyQusetRewardAll"), 10);
        end
    end
    
end

--function SCR_JOURNAL_MON_REWARD_CHECK(pc)
--    local monList = {}
--    local monSelList = {}
--    local cnt = GetClassCount('Journal_monkill_reward')
--    local pcetc = GetETCObject(pc)
--	for i = 0, cnt - 1 do
--		local jIES = GetClassByIndex('Journal_monkill_reward', i);
--		if jIES ~= nil and jIES.Count1 > 0 then
--		    local monClassName = jIES.ClassName
--		    local property = 'Reward_'..monClassName
--		    if GetPropType(pcetc, property) ~= nil then
--		        if pcetc[property] == 0 then
--		            local wiki = GetWikiByName(pc, monClassName)
--                    if wiki ~= nil then

--                        if killcount >= jIES.Count1 then
--                            monList[#monList + 1] = {}
--                            monList[#monList][1] = monClassName
--                            monList[#monList][2] = killcount
--                            
--                            monSelList[#monSelList + 1] = GetClassString('Monster', monClassName, 'Name');
--                        end
--                    end
--		        end
--		    end
--		end
--	end
--	
--	if #monList > 2 then
--	    table.insert(monList, 1, {'ALL',0})
--	    table.insert(monSelList, 1, ScpArgMsg('MONKILLREWARDALL', "COUNT",#monList - 1))
--	end
--	
--	return monList, monSelList
--end

function SCR_JOURNAL_MON_REWARD_GIVE(pc, monList, select)
    local monClassName = monList[select][1]
    if monClassName == 'ALL' then
        local pcetc = GetETCObject(pc)
        local tx = TxBegin(pc);
        for i = 2, #monList do
            monClassName = monList[i][1]
            local monKillCount = monList[i][2]
            local property = 'Reward_'..monClassName
            local jIES = GetClass('Journal_monkill_reward', monClassName)
            if jIES.Count1 > 0 and monKillCount >= jIES.Count1 then
                if GetPropType(pcetc, property) ~= nil then
                    if pcetc[property] == 0 then
                        TxGiveItem(tx, jIES.ItemName1_1, jIES.ItemCount1_1, 'JMonKill_'..monClassName);
                        TxSetIESProp(tx, pcetc, property, 1);
                    end
                end
            end
        end
        local ret = TxCommit(tx);
    else
        local monKillCount = monList[select][2]
        local property = 'Reward_'..monClassName
        local jIES = GetClass('Journal_monkill_reward', monClassName)
        if jIES.Count1 > 0 and monKillCount >= jIES.Count1 then
            local pcetc = GetETCObject(pc)
            if GetPropType(pcetc, property) ~= nil then
                if pcetc[property] == 0 then
                    local tx = TxBegin(pc);
                    TxGiveItem(tx, jIES.ItemName1_1, jIES.ItemCount1_1, 'JMonKill_'..monClassName);
                    TxSetIESProp(tx, pcetc, property, 1);
                    local ret = TxCommit(tx);
                end
            end
        end
    end
end



function SCR_JOURNAL_MAP_REWARD_CHECK(pc)
    local mapList = {}
    local mapSelList = {}
    local cnt = GetClassCount('Map')
    local pcetc = GetETCObject(pc)
	for i = 0, cnt - 1 do
		local jIES = GetClassByIndex('Map', i);
		if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
		    local mapClassName = jIES.ClassName
		    local property = 'Reward_'..mapClassName
		    if GetPropType(pcetc, property) ~= nil then
		        if pcetc[property] == 0 then
                    local mapFog = GetMapFogSearchRate(pc, mapClassName)
                    if mapFog >= 100 then
                        mapList[#mapList + 1] = {}
                        mapList[#mapList][1] = mapClassName
                        
                        mapSelList[#mapSelList + 1] = jIES.Name
                    end
		        end
		    end
		end
	end
	
	if #mapList > 2 then
	    table.insert(mapList, 1, {'ALL'})
	    table.insert(mapSelList, 1, ScpArgMsg('MONKILLREWARDALL', "COUNT",#mapList - 1))
	end
	
	return mapList, mapSelList
end

function SCR_JOURNAL_MAP_REWARD_GIVE(pc, mapList, select)

	local ret = "FAIL";

    local mapClassName = mapList[select][1]
    if mapClassName == 'ALL' then
        local pcetc = GetETCObject(pc)
        local tx = TxBegin(pc);
        for i = 2, #mapList do
            mapClassName = mapList[i][1]
            local property = 'Reward_'..mapClassName
            local jIES = GetClass('Map', mapClassName)
            if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
                if GetPropType(pcetc, property) ~= nil then
                    if pcetc[property] == 0 then
                        TxGiveItem(tx, jIES.MapRatingRewardItem1, jIES.MapRatingRewardCount1, 'JMap_'..mapClassName);
                        TxSetIESProp(tx, pcetc, property, 1);
                    end
                end
            end
        end
        ret = TxCommit(tx);
    else
        local jIES = GetClass('Map', mapClassName)
        if jIES ~= nil and jIES.MapRatingRewardItem1 ~= 'None' and jIES.WorldMapPreOpen == 'YES' and jIES.UseMapFog ~= 0  then
            local pcetc = GetETCObject(pc)
            local property = 'Reward_'..mapClassName
            if GetPropType(pcetc, property) ~= nil then
                local mapFog = GetMapFogSearchRate(pc, mapClassName)
                if pcetc[property] == 0 and mapFog >= 100  then
                    local tx = TxBegin(pc);
                    TxGiveItem(tx, jIES.MapRatingRewardItem1, jIES.MapRatingRewardCount1, 'JMap_'..mapClassName);
                    TxSetIESProp(tx, pcetc, property, 1);
                    ret = TxCommit(tx);
                end
            end
        end
    end

	if ret ~= "SUCCESS" then
		return;
	end

	SendProperty(pc, pcetc);	
end


function SCR_JOURNEY_SHOP_NORMAL_8(self, pc)

    local list, cnt = SCR_JOURNEY_QUEST_REWARD_CHECK(pc)
    if list ~= nil and #list > 0 then
        local select = SCR_SEL_LIST(pc, cnt, 'RENA_NORMAL8_SELECT1', 1)
        if select ~= nil and select >= 1 and select <= #list then
            SCR_JOURNEY_QUEST_REWARD_GIVE(self, pc, list, select)
        end
    else
        ShowOkDlg(pc, 'RENA_NORMAL8_NULL1', 1)
    end
    
end

function SCR_JOURNEY_QUEST_REWARD_CHECK(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local questList = {}
    local questSelList = {}
    if sObj == nil and IsServerObj(pc) == 0 then
        local pc = GetMyPCObject()
        sObj = GetSessionObject(pc, 'ssn_klapeda')
    end

    if sObj ~= nil then
        local list, cnt = GetClassList("reward_property");
        for i = 0, cnt -1 do
            local cls = GetClassByIndexFromList(list, i);
            if cls ~= nil then
                local clsName = TryGetProp(cls, "ClassName")
                local check_word = "JS_Quest_Reward"
                if string.find(clsName, check_word) ~= nil then
                    if sObj[clsName] ~= 300 then
                        local sLength = string.len(clsName)
                        local sStart, sEnd = string.find(clsName, check_word.."_")
                        local questClassName = string.sub(clsName, sEnd+1, sLength)
                        local questIES = GetClass("QuestProgressCheck", questClassName)
                        if questIES ~= nil then
                            local questName = TryGetProp(questIES, "Name")
                            local result = SCR_QUEST_CHECK(pc, questClassName)
                            if result == 'COMPLETE' then
                                questList[#questList + 1] = {}
                                questList[#questList][1] = questClassName
                                questSelList[#questSelList + 1] = questName
                            end
                        end
                    end
                end
            end
        end
    end
    
	if #questList >= 2 then
	    table.insert(questList, 1, {'ALL'})
	    table.insert(questSelList, 1, ScpArgMsg('MONKILLREWARDALL', "COUNT",#questList - 1))
	end

    return questList, questSelList
end



function SCR_JOURNEY_QUEST_REWARD_GIVE(self, pc, questList, select)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local questClassName = questList[select][1]
    if sObj ~= nil then
        local check_word = "JS_Quest_Reward"
        if questClassName == 'ALL' then
            local tx = TxBegin(pc);
            for i = 2, #questList do
                questClassName = questList[i][1]
                local rewardIES = GetClass('reward_property', check_word.."_"..questClassName)
                if rewardIES ~= nil then
                    local clsName = TryGetProp(rewardIES, "ClassName")
                    local result = SCR_QUEST_CHECK(pc, questClassName)
                    if result == 'COMPLETE' and sObj[clsName] ~= 300 then
                        for j = 1, 5 do
                            local item = TryGetProp(rewardIES, 'RewardItem'..j)
                            local cnt = TryGetProp(rewardIES, 'RewardCount'..j)
                            if item ~= "None" and cnt ~= 0 then
                                TxGiveItem(tx, item, cnt, clsName);
                            end
                        end
                        TxSetIESProp(tx, sObj, clsName, 300)
                    end
                end
            end
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
                local npcName = TryGetProp(self, "ClassName")
                if npcName == 'npc_rena' then
                    ShowOkDlg(pc, 'RENA_NORMAL8_SUCCESS_ALL', 1)
                else
                    ShowOkDlg(pc, 'ORSHA_JOURNEY_SHOP_NORMAL7_SUCCESS_ALL', 1)
                end
            end
        else
            local tx = TxBegin(pc);
            local rewardIES = GetClass('reward_property', check_word.."_"..questClassName)
            if rewardIES ~= nil then
                local clsName = TryGetProp(rewardIES, "ClassName")
                local result = SCR_QUEST_CHECK(pc, questClassName)
                if result == 'COMPLETE' and sObj[clsName] ~= 300 then
                    for i = 1, 5 do
                        local item = TryGetProp(rewardIES, 'RewardItem'..i)
                        local cnt = TryGetProp(rewardIES, 'RewardCount'..i)
                        if item ~= "None" and cnt ~= 0 then
                            TxGiveItem(tx, item, cnt, clsName);
                        end
                    end
                    TxSetIESProp(tx, sObj, clsName, 300)
                end
            end
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
                local ran = IMCRandom(1,2)
                local npcName = TryGetProp(self, "ClassName")
                if npcName == 'npc_rena' then
                    ShowOkDlg(pc, 'RENA_NORMAL8_SUCCESS'..ran, 1)
                else
                    ShowOkDlg(pc, 'ORSHA_JOURNEY_SHOP_NORMAL7_SUCCESS'..ran, 1)
                end
            end
        end
    end
end
