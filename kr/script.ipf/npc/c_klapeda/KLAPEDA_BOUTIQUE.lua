function SCR_BEAUTY_HAIRSHOP_MOVE_ENTER(self,pc)
    SetPos(pc, 29, 54, 106)
    FixCamera(pc, -7.83 , 4.81, 13.42, 240)
end

function SCR_BEAUTY_BOUTIQUE_MOVE_ENTER(self,pc)
    SetPos(pc, 88, 6, 1193)
    FixCamera(pc,34.79, 6.98, 1098.98, 240)
end

function SCR_BEAUTY_BOUTIQUE_MOVE_DIALOG(self,pc)
    SetPos(pc, 88, 6, 1193)
    FixCamera(pc,34.79, 6.98, 1098.98, 240)
end

function SCR_BEAUTY_HAIRSHOP_MOVE_DIALOG(self,pc)
    SetPos(pc, 29, 54, 106)
    FixCamera(pc, -7.83 , 4.81, 13.42, 240)
end


function SCR_BEAUTY_IN_MOVE_DIALOG(self,pc)
    local select = ShowSelDlg(pc, 0, "WARP_BEAUTY_SHOP_IN", ScpArgMsg('Beauty_Shop_IN'), ScpArgMsg('No'));
    if select == 1 then
        SCR_WS_SCRIPT(self, pc, 'KLAPEDA_TO_BEAUTYSHOP')
    end
end


function SCR_BEAUTY_IN_MOVE_ENTER(self,pc)
    AddHelpByName(pc, 'TUTO_BEAUTY_SHOP')
end


function SCR_BEAUTY_OUT_MOVE_DIALOG(self,pc)
    local select = ShowSelDlg(pc, 0, "WARP_BEAUTY_SHOP_OUT", ScpArgMsg('Beauty_Shop_OUT'), ScpArgMsg('No'));
    if select == 1 then
        SCR_WS_SCRIPT(self, pc, 'BEAUTYSHOP_TO_KLAPEDA')
    end
end

function SCR_BEAUTY_SHOP_HAIR_M_DIALOG(self,pc)
--    -- EVENT_1805_BEAUTY_NPC
--    EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, 3)

--    local aobj_pc = GetAccountObj(pc);
--    local buyCheck = aobj_pc.EVENT_BEAUTY_BUY_CHECK
--    local eventCheck = aobj_pc.EVENT_BEAUTY_POSE_GIVE_CHECK
--    
--    if buyCheck == "YES" then
--        if eventCheck == "None" then
--            local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_M1", ScpArgMsg('Beauty_Event_Reward'), ScpArgMsg('BEAUTY_SHOP_HAIR_M2'), ScpArgMsg('BEAUTY_SHOP_HAIR_M3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
--            if select == 1 then
--                if eventCheck == "None" then
--                    local tx = TxBegin(pc);
--                    TxSetIESProp(tx, aobj_pc, 'EVENT_BEAUTY_POSE_GIVE_CHECK', 'YES');
--                    TxGiveItem(tx, "EVENT_BEAUTY_CHAIR", 1, 'Beauty_Shop_Open_Event');
--                    local ret = TxCommit(tx);                        
--                end
--            elseif select == 2 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 1);
--            elseif select == 3 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 1);
--                
--            elseif select == 4 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
--            elseif select == 5 then
--                ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
--            end
--        elseif eventCheck == "YES" then
--            local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_M1", ScpArgMsg('BEAUTY_SHOP_HAIR_M2'), ScpArgMsg('BEAUTY_SHOP_HAIR_M3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
--            if select == 1 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 1);
--            elseif select == 2 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 1);
--            elseif select == 3 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
--            elseif select == 4 then
--                ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
--            end
--        end
--    elseif buyCheck == "None" then
--    --Event End--
        local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_M1", ScpArgMsg('BEAUTY_SHOP_HAIR_M2'), ScpArgMsg('BEAUTY_SHOP_HAIR_M3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
        if select == 1 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 1);
        elseif select == 2 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 1);
        elseif select == 3 then
            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
        elseif select == 4 then
            ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
        end
--    end
end

function SCR_BEAUTY_SHOP_HAIR_F_DIALOG(self,pc)
--    -- EVENT_1805_BEAUTY_NPC
--    EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, 2)
--
--    local aobj_pc = GetAccountObj(pc);
--    local buyCheck = aobj_pc.EVENT_BEAUTY_BUY_CHECK
--    local eventCheck = aobj_pc.EVENT_BEAUTY_POSE_GIVE_CHECK
--    
--    if buyCheck == "YES" then
--        if eventCheck == "None" then
--            local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_F1", ScpArgMsg('Beauty_Event_Reward'), ScpArgMsg('BEAUTY_SHOP_HAIR_F2'), ScpArgMsg('BEAUTY_SHOP_HAIR_F3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
--            if select == 1 then
--                if eventCheck == "None" then
--                    local tx = TxBegin(pc);
--                    TxSetIESProp(tx, aobj_pc, 'EVENT_BEAUTY_POSE_GIVE_CHECK', 'YES');
--                    TxGiveItem(tx, "EVENT_BEAUTY_CHAIR", 1, 'Beauty_Shop_Open_Event');
--                    local ret = TxCommit(tx);                        
--                end
--            elseif select == 2 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 2);
--            elseif select == 3 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 2);
--            elseif select == 4 then
--                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
--            elseif select == 5 then
--                ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
--            end
--        elseif eventCheck == "YES" then
            local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_F1", ScpArgMsg('BEAUTY_SHOP_HAIR_F2'), ScpArgMsg('BEAUTY_SHOP_HAIR_F3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
            if select == 1 then        
                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 2);
            elseif select == 2 then
                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 2);
            elseif select == 3 then
                SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
            elseif select == 4 then
                ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
            end
--        end
--    elseif buyCheck == "None" then
--        local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_HAIR_F1", ScpArgMsg('BEAUTY_SHOP_HAIR_F2'), ScpArgMsg('BEAUTY_SHOP_HAIR_F3'), ScpArgMsg('BEAUTY_SHOP_HAIR_ETC'), ScpArgMsg('BEAUTY_SHOP_HAIR_COUPON'), ScpArgMsg('Close'));
--        if select == 1 then        
--            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "HAIR", 2);
--        elseif select == 2 then
--            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "WIG", 2);
--        elseif select == 3 then
--            SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "ETC", 0);
--        elseif select == 4 then
--            ExecClientScp(pc, 'BEAUTY_COUPON_OPEN()');
--        end
--    end
end

---- EVENT_1805_BEAUTY_NPC
--function EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, target)
--    local value = GetAchievePoint(pc, 'EVENT_1805_BEAUTY_NPC_ACHIEVE')
--    if value < 1 then
--        local sObj = GetSessionObject(pc, 'ssn_klapeda')
--        if sObj ~= nil then
--            local propertyList = {'EVENT_1805_BEAUTY_NPC_1','EVENT_1805_BEAUTY_NPC_2','EVENT_1805_BEAUTY_NPC_3'}
--            if sObj[propertyList[target]] == 0 then
--                local checkFlag = 0
--                for i= 1, #propertyList do
--                    if i ~= target and sObj[propertyList[i]] == 1 then
--                        checkFlag = checkFlag + 1
--                    end
--                end
--                
--                local txType = 0
--                if checkFlag == 2 then
--                    txType = 1
--                end
--                
--                local tx = TxBegin(pc);
--                TxSetIESProp(tx, sObj, propertyList[target], 1)
--                if txType == 1 then
--                    TxAddAchievePoint(tx, 'EVENT_1805_BEAUTY_NPC_ACHIEVE', 1)
--                end
--                local ret = TxCommit(tx);
--            end
--        end
--    end
--end
function SCR_BEAUTY_SHOP_FASHION_DIALOG(self,pc)
--    -- EVENT_1805_BEAUTY_NPC
--    EVENT_1805_BEAUTY_NPC_PROPERTY_CHECK(pc, 1)
    
    local select = ShowSelDlg(pc, 0, "BEAUTY_SHOP_FASHION", ScpArgMsg('BEAUTY_SHOP_FASHION_1'), ScpArgMsg('BEAUTY_SHOP_FASHION_2'), ScpArgMsg('BEAUTY_SHOP_FASHION_3'), ScpArgMsg('Close'));
    if select == 1 then        
        SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 1);
    elseif select == 2 then
        SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "COSTUME", 2);
    elseif select == 3 then
        SendAddOnMsg(pc, "BEAUTYSHOP_UI_OPEN", "PACKAGE", 0);
    end
end
