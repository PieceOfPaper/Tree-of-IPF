function SCR_USE_EVENT_1804_TRANSCEND_REINFORCE_CUBE(self,argObj,str1,arg1,arg2)
    local rewardList = {{'Moru_Silver',5},{'Moru_Gold_14d',3},{'Moru_Diamond_14d',1}}
    local tx = TxBegin(self)
    for i = 1, #rewardList do
        TxGiveItem(tx, rewardList[i][1], rewardList[i][2], 'EVENT_1804_TRANSCEND_REINFORCE')
    end
    local ret = TxCommit(tx)
    if ret == 'SUCCESS' then
        SCR_SEND_NOTIFY_REWARD_TABLE(self, GetClassString('Item', 'EVENT_1804_TRANSCEND_REINFORCE_CUBE','Name'), rewardList)
    end
end


function SCR_EVENT_1804_TRANSCEND_SHOP_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1804_TRANSCEND_SHOP_DLG1', ScpArgMsg('EVENT_1712_MORUKING_MSG2'), selmsg1_2, ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP_OPEN()")
    end
end

function SCR_PRE_EVENT_1804_TRANSCEND_SHOP_SILVER_BOX_14D(self, argStr, arg1, arg2)
    local count = GetInvItemCount(self, 'Vis')
    
    if count >= 900000000 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_TRANSCEND_MSG3"), 10);
        return 0
    end
    
    return 1
end

function SCR_USE_EVENT_1804_TRANSCEND_SHOP_SILVER_BOX_14D(self, argObj, argStr, arg1, arg2)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    
    local itemList = {{'Vis', 10000, 10},
                        {'Vis', 50000, 50},
                        {'Vis', 100000, 279},
                        {'Vis', 150000, 600},
                        {'Vis', 200000, 600},
                        {'Vis', 250000, 600},
                        {'Vis', 300000, 600},
                        {'Vis', 350000, 600},
                        {'Vis', 400000, 600},
                        {'Vis', 450000, 600},
                        {'Vis', 500000, 600},
                        {'Vis', 550000, 1000},
                        {'Vis', 600000, 1000},
                        {'Vis', 650000, 500},
                        {'Vis', 700000, 500},
                        {'Vis', 750000, 300},
                        {'Vis', 800000, 300},
                        {'Vis', 850000, 300},
                        {'Vis', 900000, 300},
                        {'Vis', 950000, 300},
                        {'Vis', 1000000, 200},
                        {'Vis', 5000000, 100},
                        {'Vis', 10000000, 50},
                        {'Vis', 50000000, 10},
                        {'Vis', 100000000, 1}
                        }
    local result = SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'EVENT_1804_TRANSCEND_SHOP_SILVER_BOX_14D', itemList, 'EVENT_1804_TRANSCEND_SHOP_SILVER_BOX_14D')
    
    if result ~= nil then
        if result[3] >= 5000000 then
	        ToAll(ScpArgMsg("EVENT_1804_TRANSCEND_MSG2","PC",GetTeamName(self),"COUNT", GET_COMMA_SEPARATED_STRING(result[3])))
	    end
    end
end

function SCR_EVENT_RANDOM_BOX_REWARD_FUNC(pc, itemClassName, itemList, giveway)
    local maxRate = 0
    for i = 1, #itemList do
        maxRate = maxRate + itemList[i][3]
    end
    
    local rand = IMCRandom(1, maxRate)
    local targetIndex = 0
    local accRate = 0
    
    for i = 1, #itemList do
        accRate = accRate + itemList[i][3]
        if rand <= accRate then
            targetIndex = i
            break
        end
    end
    local tx = TxBegin(pc);
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], giveway);
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    if 'Vis' == itemList[targetIndex][1] then
	        SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item',itemClassName,'Name'), ScpArgMsg('LVUP_REWARD_MSG2','COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
	    else
	        SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item',itemClassName,'Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
	    end
	    
	    return itemList[targetIndex]
	end
	
	return
end

function SCR_USE_EVENT_1804_TRANSCEND_SHOP_REINFORCE_BOX_14D(self, argObj, argStr, arg1, arg2)
    local itemList = {{'Moru_Event160929_14d',1,4000},
                        {'Moru_Silver',1,3000},
                        {'Moru_Gold_14d',1,2000},
                        {'EVENT_1804_TRANSCEND_SHOP_COSTUME_BOX_14D',1,1000}
                    }
    SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'EVENT_1804_TRANSCEND_SHOP_REINFORCE_BOX_14D', itemList, 'EVENT_1804_TRANSCEND_SHOP_REINFORCE_BOX_14D')
end


function SCR_USE_EVENT_1804_TRANSCEND_SHOP_COSTUME_BOX_14D(self, argObj, argStr, arg1, arg2)
    local itemList = {{'Hat_629503',1,2000},
                        {'Hat_628097',1,2000},
                        {'Hat_628198',1,2000},
                        {'costume_Com_21',1,500},
                        {'costume_Com_22',1,500},
                        {'costume_Com_54',1,500},
                        {'costume_Com_55',1,500},
                        {'costume_1709_NewField_m',1,500},
                        {'costume_1709_NewField_f',1,500},
                        {'costume_Com_34',1,500},
                        {'costume_Com_35',1,500}
                    }
    SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'EVENT_1804_TRANSCEND_SHOP_COSTUME_BOX_14D', itemList, 'EVENT_1804_TRANSCEND_SHOP_COSTUME_BOX_14D')
end
