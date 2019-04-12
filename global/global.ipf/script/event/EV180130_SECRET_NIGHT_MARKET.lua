function SCR_SECRET_NIGHT_MARKET_FEDIMIAN_DIALOG(self, pc)
    if pc.Lv < 300 then
        ShowOkDlg(pc, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_6', 1)
        return
    end
    local select = ShowSelDlg(pc, 0, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_1', ScpArgMsg("EVENT_STEAM_SECRET_NIGHT_MARKET_SEL1"), ScpArgMsg("Cancel"))
    local qCount = GetInvItemCount(pc, 'misc_talt')

    if select == 1 then
        local select2 = ShowSelDlg(pc, 0, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_2', ScpArgMsg("EVENT_STEAM_SECRET_NIGHT_MARKET_SEL2"), ScpArgMsg("Cancel"))

        if select2 == 1 and qCount >= 10 then
            local select3 = ShowSelDlg(pc, 0, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_3', ScpArgMsg("EVENT_STEAM_SECRET_NIGHT_MARKET_SEL3"), ScpArgMsg("Cancel"))
            
            if select3 == 1 then

                if qCount >= 10 then
                    local tx = TxBegin(pc);
                    TxTakeItem(tx, 'misc_talt', 10, "EV_NIGHT_MARKET_TALT_TAKE");
                    local ret = TxCommit(tx);
                    
                    if ret == "SUCCESS" then 
                        local teamlv = GetTeamLevel(pc)
                        local teamName = GetTeamName(pc)

                        --AddBuff(self, pc, 'Event_Steam_Secter_Market', 1, 0, 600000, 1);
                        MoveZone(pc, 'c_request_1', 46.24, 0.35, -87.07);
                        IMCLOG_CONTENT('ENTER_EV_MARKET', 'ENTER_EV_MARKET  '..'..PC_LV : '..pc.Lv..'  '..'TEAM_LV : '..teamlv..'  '..'TEAM_NAME : '..teamName) -- Log --
                    end
                else
                    ShowOkDlg(pc, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_4', 1)
                end   
            end
        else
            ShowOkDlg(pc, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_4', 1)
        end
    end
end

function SCR_BUFF_ENTER_Event_Steam_Secret_Market(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Event_Steam_Secret_Market(self, buff, arg1, arg2, over)
    local ZoneClassName = GetZoneName(self)
    if ZoneClassName == 'c_request_1' then
        MoveZone(self, 'c_fedimian', -752.13, 208.32, -118.11);
    end
end

function SCR_SECRET_NIGHT_MARKET_EXIT_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_STEAM_SECRET_NIGHT_MARKET_DLG_5', ScpArgMsg("Cancel"), ScpArgMsg("EVENT_STEAM_SECRET_NIGHT_MARKET_SEL4"))

    if select == 2 then
        --RemoveBuff(pc, 'Event_Steam_Secret_Market')
        MoveZone(pc, 'c_fedimian', -752.13, 208.32, -118.11);
    end
end

function SCR_SECRET_NIGHT_MARKET_NPC1_DIALOG(self, pc)
    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP6_1_OPEN()")
end

function SCR_SECRET_NIGHT_MARKET_NPC2_DIALOG(self, pc)
    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP6_2_OPEN()")
end

function SCR_SECRET_NIGHT_MARKET_NPC3_DIALOG(self, pc)
    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP6_3_OPEN()")
end

function SCR_SECRET_NIGHT_MARKET_NPC4_DIALOG(self, pc)
    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP6_4_OPEN()")
end

function SCR_SECRET_NIGHT_MARKET_NPC5_DIALOG(self, pc)
    ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP6_5_OPEN()")
end

function SCR_EVENT_SECRET_MARKET_DROPITEM(self, sObj, msg, argObj, argStr, argNum)  
    local rand = IMCRandom(1, 100)
    local monIES = GetClass('Monster', argObj.ClassName)
    if self.Lv < 300 then
        return
    end
    if self.Lv >= 300 and rand <= 3 then    
        if argObj ~= nil and argObj.ClassName ~= 'PC' then       
            if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 25 <= argObj.Lv then
                local pcLayer = GetLayer(self)                
            if pcLayer > 0 then
                local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
                local flag = 'NO'
                if obj ~= nil then
                    if obj.EventName ~= nil and obj.EventName ~= "None" then
                        local etc = GetETCObject(self)
                        if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
                            local trackInitCount = etc[obj.EventName..'_TRACK']
                            if trackInitCount <= 1 then
                                flag = 'YES'
                            end
                        end
                    end
                end
                if flag == 'NO' then
                    return
                end
            end          
                local tx = TxBegin(self);
                TxGiveItem(tx, 'Event_Steam_Night_Market_Gold', 1, "EV_NIGHT_MARKET_Gold_Get");
                local ret = TxCommit(tx);      		
            end
        end
    end
end