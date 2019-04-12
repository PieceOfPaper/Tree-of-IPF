function SCR_EVENT_CB_DIALOG(self, pc)
    local cbTicket = GetInvItemCount(pc, "Event_CB_Ticket")
    if cbTicket > 0 then
        local tx = TxBegin(pc)
        TxTakeItem(tx, 'Event_CB_Ticket', 1, "EVENT_CB") 
        TxGiveItem(tx, 'PremiumToken_5d_event', 1, "EVENT_CB")
        TxGiveItem(tx, 'Premium_boostToken03_event01', 5, "EVENT_CB")
        TxGiveItem(tx, 'Ability_Point_Stone', 1, "EVENT_CB")
        TxGiveItem(tx, 'Premium_indunReset_14d', 5, "EVENT_CB")
        TxGiveItem(tx, 'Premium_dungeoncount_Event', 10, "EVENT_CB")
        local ret = TxCommit(tx)
    else
        ShowOkDlg(pc,'NPC_EVENT_CB_1', 1)
    end
end