function SCR_EVENT_YOUR_CHOICE_CHECK(self, sObj, msg, argObj, argStr, argNum)
    local aObj = GetAccountObj(self)
    if GetServerNation() ~= 'GLOBAL' then
        return
    end
    if self.Lv < 50 then
        return
    end
    if aObj.EV170816_YOUR_CHOICE_1 == 0 then
        return
    end
    local monIES = GetClass('Monster', argObj.ClassName)
    local rand = IMCRandom(1, 100) --1% item drop
    local pcLayer = GetLayer(self)
    
    if GetCurrentFaction(argObj) == 'Monster' and monIES.Faction == 'Monster' and self.Lv - 20 <= argObj.Lv then                
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
        if rand == 4 then --all
            local tx = TxBegin(self);
        	TxGiveItem(tx, 'Event_Steam_YC_2', 1, "EV170816_STEAM_YC");
        	local ret = TxCommit(tx);
        end	
        if aObj.EV170816_YOUR_CHOICE_1 == 1 then --klaipeda
            if rand == 1 then      
                local tx = TxBegin(self);
        		TxGiveItem(tx, 'Event_Steam_YC_1', 1, "EV170816_STEAM_YC");
        		local ret = TxCommit(tx);
        	end
        elseif aObj.EV170816_YOUR_CHOICE_1 == 2 then --orsha
            if rand == 2 then
                local tx = TxBegin(self);
        		TxGiveItem(tx, 'Event_Steam_YC_3', 1, "EV170816_STEAM_YC");
        		local ret = TxCommit(tx);
        	end
        elseif aObj.EV170816_YOUR_CHOICE_1 == 3 then --fedimian
            if rand == 3 then
                local tx = TxBegin(self);
        		TxGiveItem(tx, 'Event_Steam_YC_4', 1, "EV170816_STEAM_YC");
        		local ret = TxCommit(tx);
        	end
        end
    end
end

function SCR_EV170816_YOUR_CHOICE(self, pc)
    if pc.Lv < 50 then
        return
    end
    
    local aObj = GetAccountObj(pc)
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_STEAM_YC_DLG1', ScpArgMsg("Auto_KeuMan_DunDa"), ScpArgMsg("Event_Steam_YC_5"), ScpArgMsg("Event_Steam_YC_7"))
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local yday2 = now_time['yday']
    local hour = now_time['hour']
    local min = now_time['min']
    local ymin = (yday * 24 * 60) + hour * 60 + min
    if select == 2 then
        local select2 = ShowSelDlg(pc, 0, 'NPC_EVENT_STEAM_YC_DLG2', ScpArgMsg("Auto_KeuMan_DunDa"), ScpArgMsg("Event_Steam_YC_2"), ScpArgMsg("Event_Steam_YC_3"), ScpArgMsg("Event_Steam_YC_4"))
        
        if select2 == 1 then
            return;
        else
            local nextday = {234, 241, 248, 255}
            local saveday = 0;

            for i = 1, 4 do
                if yday < nextday[i] then
                    saveday = nextday[i]
                    break;
                end
            end

            if ((aObj.EV170816_YOUR_CHOICE_2 <= yday) and (yday == 234 or yday == 241 or yday == 248)) or ( aObj.EV170816_YOUR_CHOICE_1 == 0 ) then
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_1', select2 - 1);
                TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_2', saveday);
                PlayEffect(pc, "F_buff_basic025_white_line", 1)
            	local ret = TxCommit(tx)
            else
                ShowOkDlg(pc, 'NPC_EVENT_STEAM_YC_DLG3', 1)
                return
            end
        end        
    elseif select == 3 then
        if aObj.EV170816_YOUR_CHOICE_5 ~= yday then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_3', 0);
            TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_5', yday);
            local ret = TxCommit(tx)    
        end
        if aObj.EV170816_YOUR_CHOICE_3 < 6 then
            if ymin - aObj.EV170816_YOUR_CHOICE_4 >= 60 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'R_Steam_YC_Event', 1, "EV170816_STEAM_YC");
                    TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_3', aObj.EV170816_YOUR_CHOICE_3 + 1);
                    TxSetIESProp(tx, aObj, 'EV170816_YOUR_CHOICE_4', ymin);
                    local ret = TxCommit(tx)                        
            else
                ShowOkDlg(pc, 'NPC_EVENT_STEAM_YC_DLG4', 1)    
            end
        else
            ShowOkDlg(pc, 'NPC_EVENT_TODAY_NUMBER_5', 1)    
        end
    end
end