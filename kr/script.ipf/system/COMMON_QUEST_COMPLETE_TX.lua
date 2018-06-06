function TX_LEGEND_CARD_LIFT_FUNC(pc, tx, questname)
    local pcEtc = GetETCObject(pc);
    local aObj = GetAccountObj(pc)
    if pcEtc ~= nil and aObj ~= nil then
    	local isLegendCardOpen = TryGetProp(pcEtc, 'IS_LEGEND_CARD_OPEN')
    	if isLegendCardOpen ~= 1 then
        	TxSetIESProp(tx, pcEtc, 'IS_LEGEND_CARD_OPEN', 1)
        	TxSetIESProp(tx, aObj, 'LEGEND_CARD_LIFT_TEAM_COMPLETE_COUNT', aObj.LEGEND_CARD_LIFT_TEAM_COMPLETE_COUNT + 1)
        end
    end
end

function LEGEND_CARD_LIFT_SUCC_FUNC(pc, questname, npc)
    local pcEtc = GetETCObject(pc);
    if pcEtc ~= nil then
    	local isLegendCardOpen = TryGetProp(pcEtc, 'IS_LEGEND_CARD_OPEN')
    	if isLegendCardOpen == 1 then
    	    SendAddOnMsg(pc, "MSG_PLAY_LEGENDCARD_OPEN_EFFECT", "", 0)
    	end
    end
end
