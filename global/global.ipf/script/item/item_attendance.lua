function SCR_USE_Steam_NewRankDLC(pc) --VakarinePackege --
    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxStartAttendance(tx, 'SteamNewRank');
    local ret = TxCommit(tx);
end