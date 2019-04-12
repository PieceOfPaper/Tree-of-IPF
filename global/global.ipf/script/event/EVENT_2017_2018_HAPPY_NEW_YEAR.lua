function SCR_HAPPY_NEW_YEAR_TREE_DIALOG(self, pc)
    
    if IsBuffApplied(pc, 'Event_Steam_Happy_New_Year') == 'YES' then
        return
    end

    local result = DOTIMEACTION_R(pc, ScpArgMsg("EVENT_STEAM_HAPPY_NEW_YEAR"), 'PRAY', 30)
    
    if result == 1 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Steam_Happy_New_Year', 1, 'Event_Happy_New_Year');
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            PlayEffect(pc, "F_buff_basic025_white_line", 1)
            AddBuff(self, pc, "Event_Steam_Happy_New_Year", 1, 0, 3600000, 1);
        end
    end

end