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
	    -- if 'Vis' == itemList[targetIndex][1] then
	    --     SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item',itemClassName,'Name'), ScpArgMsg('LVUP_REWARD_MSG2','COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
	    -- else
	    --     SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item',itemClassName,'Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
	    -- end
	    
	    return itemList[targetIndex]
	end
	
	return
end