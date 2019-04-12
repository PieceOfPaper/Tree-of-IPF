function DLC_BOX1(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_650', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_PremiumToken_60d', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_JOB_HOGLAN_COUPON', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629003', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Premium_SkillReset', 1, 'DLC_BOX1');
    TxGiveItem(tx, 'steam_Premium_StatReset', 1, 'DLC_BOX1');
    local ret = TxCommit(tx);
end

function DLC_BOX2(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_380', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_PremiumToken_30day', 1, 'DLC_BOX2');
    TxGiveItem(tx, 'steam_Hat_629004', 1, 'DLC_BOX2');
    local ret = TxCommit(tx);
end

function DLC_BOX3(pc)
    local tx = TxBegin(pc);
    TxGiveItem(tx, 'steam_Premium_tpBox_160', 1, 'DLC_BOX3');
    local ret = TxCommit(tx);
end