function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    if pc.Lv < 50 then
        return
    end
    
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("GivingTree_title"), ScpArgMsg("Cancel"))
    
    if select == 1 then
        local aObj = GetAccountObj(pc);
        local now_time = os.date('*t')
        local year = now_time['year']
        local yday = now_time['yday']
        local hour = now_time['hour']
        local min = now_time['min']

        EVENT_PROPERTY_RESET(pc, aObj, sObj)
        
        if aObj.PlayTimeEventPlayMin ~= year.."/"..yday then
            local select1 = ShowSelDlg(pc, 0, 'EV_GIVINGTREE_REWARD01', 
            ScpArgMsg("GivingTree_Reward1"), ScpArgMsg("GivingTree_Reward2"), ScpArgMsg("GivingTree_Reward3"), ScpArgMsg("GivingTree_Reward4"), 
            ScpArgMsg("GivingTree_Reward5"), ScpArgMsg("GivingTree_Reward6"), ScpArgMsg("Cancel"))
            
            if select1 == nil or select1 == 7 then
                return
            elseif select1 >= 1 and select1 <= 6 then
                local reward = {
                    'indunReset_1add_14d_NoStack', 'misc_gemExpStone_randomQuest3_14d', 'Premium_eventTpBox_3',
                    'Premium_Enchantchip14_NoStack', 'Premium_boostToken_14d', 'Event_160908_6_14d'
                }
  
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'PlayTimeEventPlayMin', year.."/"..yday);
                TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', select1);
                TxGiveItem(tx, 'Premium_boostToken02_1d', 1, 'GivingTree');
                
                if aObj.PlayTimeEventRewardCount == 0 then
                    TxGiveItem(tx, 'NECK99_102', 1, 'GivingTree');
                else
                    TxGiveItem(tx, reward[aObj.PlayTimeEventRewardCount], 1, 'GivingTree');
                end
            	local ret = TxCommit(tx)
            end
            
            ShowOkDlg(pc, 'EV_GIVINGTREE_REWARD02')
        end
    end
end

function EVENT_PROPERTY_RESET(pc, aObj, sObj)
    if aObj.DAYCHECK_EVENT_LAST_DATE ~= 'GivingTree' then -- 현재 진행중인 이벤트
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', "GivingTree");
        TxSetIESProp(tx, aObj, 'PlayTimeEventPlayMin', 'None');
        TxSetIESProp(tx, aObj, 'PlayTimeEventRewardCount', 0);
    	local ret = TxCommit(tx)
    end
end