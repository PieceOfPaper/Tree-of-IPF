function SCR_EVENT_TODAY_TREEROOT_DROPITEM(self, sObj, msg, argObj, argStr, argNum)  

    if (argObj.ClassID >= 45132 and argObj.ClassID <= 45136) or (argObj.ClassID >= 45110 and argObj.ClassID <= 45111) then
        if IsBuffApplied(self, 'Event_Steam_Base_Buff') == 'NO' then 
            AddBuff(argObj, self, 'Event_Steam_Base_Buff', 1, 0, 1800000, 1);
        end
    end
end

-- function SCR_EVENT_COOPERRATION_DIALOG(self, pc)
--     local aObj = GetAccountObj(pc);
    
--     if GetTeamLevel(pc) < 5 then -- teamlv
--         ShowOkDlg(pc, 'EVENT_REWARD_5DAY_FAIL', 1)
--         return
--     end

--     -- if aObj.Event_Cooperation_Team == 'None' then -- team
--     --     local team_name = {
--     --         {'Klaipe', 'Event_Steam_Server_Material_1'},
--     --         {'Orsha',  'Event_Steam_Server_Material_2'}
--     --     }
--     --     local rand = IMCRandom(1, 2)
--     --     local itemname = GetClass('Item', team_name[rand][2])
--     --     local tx = TxBegin(pc)
--     --     TxSetIESProp(tx, aObj, 'Event_Cooperation_Team', team_name[rand][1] ) -- save day
--     --     local ret = TxCommit(tx)
--     --     if ret == 'SUCCESS' then
--     --         ShowOkDlg(pc, ScpArgMsg('EVENT_COOPERATION_DLG1', "TEAM", team_name[rand][1], "ITEM", itemname.Name), 1)
--     --     end
--     -- end

--     local select = ShowSelDlg(pc, 0, 'EVENT_SELECT_BOSSLV_05', ScpArgMsg('EventShop'), ScpArgMsg('EVENT_7DAY_EXP_SEL2'), ScpArgMsg('EVENT_COOPERATION_DLG2'), ScpArgMsg('Auto_DaeHwa_JongLyo'))

--     if select == 1 then -- event shop
--         ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP2_OPEN()")
--     elseif select == 2 then -- exp buff
--         local get_buff = ShowSelDlg(pc, 0, 'EVENT_1708_JURATE_DLG5', ScpArgMsg('No'), ScpArgMsg('Yes'))

--         if get_buff == 1 or get_buff == nil then
--             return;
--         elseif get_buff == 2 then
--             local qitem_1 = GetInvItemCount(pc, 'Event_Steam_Server_Material_1')
--             local qitem_2 = GetInvItemCount(pc, 'Event_Steam_Server_Material_2')

--             if qitem_1 >= 1 and qitem_2 >= 1 then
--                 local tx = TxBegin(pc)
--                 TxTakeItem(tx, 'Event_Steam_Server_Material_1', 1, 'EVENT_COOPERATION_BUFF')
--                 TxTakeItem(tx, 'Event_Steam_Server_Material_2', 1, 'EVENT_COOPERATION_BUFF')
--                 local ret = TxCommit(tx)
--                 if ret == 'SUCCESS' then
--                     if IsBuffApplied(pc, 'Event_Steam_Server_Buff') == "YES" then
--                         RemoveBuff(pc, 'Event_Steam_Server_Buff')
--                     end
--                     AddBuff(pc, pc, 'Event_Steam_Server_Buff', 1, 0, 1800000, 1);
--                 end
--             else
--                 ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--             end
--         end
--     elseif select == 3 then -- item exchange
--         local qitem_1 = GetInvItemCount(pc, 'Event_Steam_Server_Material_1')
--         local qitem_2 = GetInvItemCount(pc, 'Event_Steam_Server_Material_2')
--         local exchange_count_input = ShowTextInputDlg(pc, 0, 'EVENT_COOPERATION_DLG1')
--         local exchange_count = tonumber(exchange_count_input)

--         if exchange_count >= 1 then
--             if qitem_1 >= exchange_count and qitem_2 >= exchange_count then
--                 local tx = TxBegin(pc)
--                 TxTakeItem(tx, 'Event_Steam_Server_Material_1', exchange_count, 'EVENT_COOPERATION_EXCHANGE')
--                 TxTakeItem(tx, 'Event_Steam_Server_Material_2', exchange_count, 'EVENT_COOPERATION_EXCHANGE')
--                 TxGiveItem(tx, 'Event_Steam_Server_Material_3', exchange_count, 'EVENT_COOPERATION_EXCHANGE');
--                 local ret = TxCommit(tx)

--                 if ret == 'SUCCESS' then
--                     PlayEffect(pc, "F_buff_basic025_white_line", 1)
--                 end
--             else
--                 ShowOkDlg(pc, 'EVENT_SELECT_BOSSLV_04', 1)
--             end
--         end
--     end
-- end

-- function SCR_EVENT_COOPERRATION_DROP(self, sObj, msg, argObj, argStr, argNum)
--     local serverID = GetServerGroupID()
    
--     if serverID == 1001 or serverID == 1004 then

--         if GetTeamLevel(self) < 5 then -- teamlv
--             return
--         end

--         local rand = IMCRandom(1, 100)--350/0.28   200/0.5
--         local monIES = GetClass('Monster', argObj.ClassName)
--         local dropitem_team = 0;
--         local dropItem = {
--                 {1,'Event_Steam_Server_Material_1'},{2,'Event_Steam_Server_Material_2'}
--             }

--             if rand == 1 then    
--                 if argObj ~= nil and argObj.ClassName ~= 'PC' then
--                     local pcjobinfo = GetClass('Job', self.JobName)
--                     local pcCtrlType = pcjobinfo.CtrlType

--                     if pcCtrlType == 'Warrior' or pcCtrlType == 'Archer' then
--                         dropitem_team = 1
--                     elseif pcCtrlType == 'Wizard' or pcCtrlType == 'Cleric' then
--                         dropitem_team = 2
--                     else
--                         return;
--                     end


--                     if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 10 <= argObj.Lv then  
--                         local pcLayer = GetLayer(self)                
--                     if pcLayer > 0 then
--                         local obj = GetLayerObject(GetZoneInstID(self), pcLayer);
--                         local flag = 'NO'
--                         if obj ~= nil then
--                             if obj.EventName ~= nil and obj.EventName ~= "None" then
--                                 local etc = GetETCObject(self)
--                                 if GetPropType(etc, obj.EventName..'_TRACK') ~= nil then
--                                     local trackInitCount = etc[obj.EventName..'_TRACK']
--                                     if trackInitCount <= 1 then
--                                         flag = 'YES'
--                                     end
--                                 end
--                             end
--                         end
--                         if flag == 'NO' then
--                             return
--                         end
--                     end          
--                         local tx = TxBegin(self);
--                         TxGiveItem(tx, dropItem[dropitem_team][2], 1, "COOPERRATION_DROP");
--                         local ret = TxCommit(tx);      		
--                     end
--                 end
--             end
--     end
-- end