function SCR_GOLD_FISH_STATUE_DIALOG(self, pc)
    local userLv = TryGetProp(pc, "Lv")
    local needSilver = 10000 + (userLv * 100)
    
    
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    if aObj == nil then
        return;
    end
    
    local serverBuffCount = 0;
    if aObj.GOLD_STATUE_FIRST_DATA == nowDate then
        serverBuffCount = 1;
    end
    -- 주인인 캐릭터와 다이얼로그 분할 하도록 --
    local select = ShowSelDlg(pc, 0, 'FISHING_STATUE_DLG1', ScpArgMsg('FISHING_STATUE_WORSHIP', "needSilver", GET_COMMAED_STRING(needSilver)),  ScpArgMsg('FISHING_STATUE_OWNER_WORSHIP','serverBuffCount',serverBuffCount) ,ScpArgMsg("Close"));
     
    if select == 1 then       
        local haveSilver = GetInvItemCount(pc, 'Vis')
        if haveSilver ~= nil and haveSilver >= needSilver then
            local tx = TxBegin(pc);
                TxTakeItem(tx, 'Vis', needSilver, "FISHING_STATUE_WORSHIP");
                AddBuff(self, pc, 'STATUE_LOOTINGCHANCE')
            local ret = TxCommit(tx);
            if ret ~= "SUCCESS" then
                return;
            end
        else
            SendSysMsg(pc, "Auto_SilBeoKa_BuJogHapNiDa.");
            return;
        end
    elseif select == 2 then --여기에 같은지 여부 체크하는 구문 추가--
            
            select = ShowSelDlg(pc, 0, 'FISHING_STATUE_DLG1', ScpArgMsg('FISHING_STATUE_OWNER_WORSHIP_1'),ScpArgMsg("FISHING_STATUE_OWNER_WORSHIP_2"),ScpArgMsg("FISHING_STATUE_OWNER_WORSHIP_3"),ScpArgMsg("Close"));
            
            local buffValue = 0;
            
            if select == 1 then
            
            elseif select == 2 then
            
            elseif select == 3 then
            
            end
            
            
    end
end