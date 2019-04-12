function SCR_EVENT_CB_DIALOG(self, pc)
    local cbTicket = GetInvItemCount(pc, "Event_CB_Ticket")
    if cbTicket > 0 then
        local tx = TxBegin(pc) 
        TxGiveItem(tx, 'Event_Sol_BOX_1', 1, "EVENT_CB")
        TxTakeItem(tx, 'Event_CB_Ticket', 1, "EVENT_CB")
        local ret = TxCommit(tx)
    else
        ShowOkDlg(pc,'NPC_EVENT_CB_1', 1)
    end
end