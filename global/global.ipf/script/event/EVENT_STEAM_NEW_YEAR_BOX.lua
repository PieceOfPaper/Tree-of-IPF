function SCR_STEAM_NEW_YEAR_BOX_DIALOG(self, pc)
    ShowOkDlg(pc, 'NPC_EVENT_180213GOLDEN_BOX_DLG1', 1)
    -- local kCount = GetInvItemCount(pc, 'Event_Steam_Happy_New_Year_Key')

    -- if kCount > 0 then
    --     local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaMulSoe_yeoNeun_Jung"), 'CUTVINE_LOOP', 3)
    --     if result == 1 then
    --         local tx = TxBegin(pc)
    --         TxTakeItem(tx, 'Event_Steam_Happy_New_Year_Key', kCount, 'Event_STEAM_NEW_YEAR_BOX');
    --         TxGiveItem(tx, 'Achieve_2018Happy_New_Year_Steam', 1, 'Event_STEAM_NEW_YEAR_BOX');
    --         TxGiveItem(tx, 'ChallengeModeReset_14d', 1, 'Event_STEAM_NEW_YEAR_BOX');
    --         local ret = TxCommit(tx)
    --     end
    -- else
    --     ShowOkDlg(pc, 'EVENT_STEAM_NEW_YEAR_BOX_1', 1)
    -- end
end