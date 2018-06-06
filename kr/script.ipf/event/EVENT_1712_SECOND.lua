function SCR_EVENT_1712_SECOND_DIALOG(self, pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    local nowDay = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    if aObj == nil then
        return
    end
    
    local selTex1 
    if aObj.EVENT_1712_SECOND_BUFF_DATE ~= nowDay then
        selTex1 = ScpArgMsg('EVENT_1712_SECOND_MSG2')
    end
    local select1 = ShowSelDlg(pc, 0, 'EVENT_1712_SECOND_DLG1', selTex1, ScpArgMsg('EVENT_1712_SECOND_MSG3'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select1 == 1 then
        if IsBuffApplied(pc, 'EVENT_1712_SECOND_BUFF') == 'YES' then
            ShowOkDlg(pc, 'EVENT_1712_SECOND_DLG2', 1)
            return
        else
            if aObj.EVENT_1712_SECOND_BUFF_DATE ~= nowDay then
                local tx = TxBegin(pc);
                TxSetIESProp(tx, aObj, "EVENT_1712_SECOND_BUFF_DATE", nowDay)
                local ret = TxCommit(tx);
                if ret == 'SUCCESS' then
                    AddBuff(pc, pc, 'EVENT_1712_SECOND_BUFF', 1, 0, 86400000,1)
                end
            end
        end
    elseif select1 == 2 then
        ExecClientScp(pc, "REQ_EVENT_ITEM_SHOP_OPEN()")
    end
    
end


function SCR_PRE_EVENT_1712_SECOND_CHALLENG(self, argstring, arg1, arg2)
    if IsIndun(self) == 1 or IsPVPServer(self) == 1 or IsMissionInst(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PopUpBook_MSG3"), 5);
        return 0
    end
    
    if GetLayer(self) ~= 0 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EV161215_SEED_MSG3"), 5);
        return 0
    end
    
    local zoneName = GetZoneName(self)
    local challengflag = GetClassString('Map',zoneName, 'ChallengeMode')
    
    if challengflag == 'YES' then
        return 1
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("DontUseItemThisArea"), 5);
        return 0
    end
    return 0
end
function SCR_USE_EVENT_1712_SECOND_CHALLENG(self, argstring, arg1, arg2)
	local zoneInst = GetZoneInstID(self);
	local layer = GetLayer(self);
    local layerObj = GetLayerObject(zoneInst, layer);
    
    CREATE_CHALLENGE_MODE_PORTAL(self, zoneInst, layerObj)
end