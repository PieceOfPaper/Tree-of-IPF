function ANCIENT_SOLO_DUNGEON_INFO_ON_INIT(addon, frame)
    addon:RegisterMsg('GAME_START', 'ANCIENT_SOLO_DUNGEON_INFO_OPEN_CHECK');
    addon:RegisterMsg('ANCIENT_SOLO_MONSTER_DEAD', 'ANCIENT_SOLO_DUNGEON_UPDATE_MONSTER');
end

function ANCIENT_SOLO_DUNGEON_UPDATE_MONSTER(frame,msg,strArg,numArg)
    local remainMonText = GET_CHILD_RECURSIVELY(frame,"remaintimeMon")
    local count = remainMonText:GetTextByKey('now') - 1
    remainMonText:SetTextByKey('now',count)
end

function ANCIENT_SOLO_SET_STAGE_NUM(frame,stage)
    local stageText = GET_CHILD_RECURSIVELY(frame,"stageText")
    stageText:SetTextByKey('stage',stage)
end

function ANCIENT_SOLO_SET_ZONE_BUFF(frame,zoneBuffName)
    local zoneBuffCls = GetClass('Buff',zoneBuffName)
    local slot = GET_CHILD_RECURSIVELY(frame,"stageZoneDebuffIcon")
    if zoneBuffCls == nil then
        slot:ClearIcon()
        return
    end
    local icon = CreateIcon(slot)
    icon:SetImage("icon_"..zoneBuffCls.Icon)
    icon:SetTooltipType('buff');
    icon:SetTooltipArg(session.GetMyHandle(), zoneBuffCls.ClassID,0);
end

function ANCIENT_SOLO_SET_CLEAR_REWARD(frame,item,cnt,alreadyGet)
    local itemCls = GetClass('Item',item)
    local slot = GET_CHILD_RECURSIVELY(frame,"stageFirstClearIcon")
    local icon = CreateIcon(slot)
    icon:SetImage(itemCls.Icon)
    icon:SetTooltipType('wholeitem');
    icon:SetTooltipNumArg(itemCls.ClassID);
    local checkboxSlot = GET_CHILD_RECURSIVELY(frame,"checkbox")
    if tonumber(alreadyGet) == 1 then
        checkboxSlot:SetVisible(1)
    else
        checkboxSlot:SetVisible(0)
    end

end

function ANCIENT_SOLO_SET_TOTAL_MON_COUNT(frame,count)
    local remainMonText = GET_CHILD_RECURSIVELY(frame,"remaintimeMon")
    remainMonText:SetTextByKey('now',count)
    remainMonText:SetTextByKey('total',count)
end

function ANCIENT_SOLO_SET_REMAIN_TIME(frame,time)
    local remaintimeValue = GET_CHILD_RECURSIVELY(frame,"remaintimeValue")
    if time < 0 then
        time = 0
    end
    local min = tostring(math.floor(time/60))
    local sec = tostring(time%60)
    if string.len(sec) == 1 then
        sec = '0' .. sec
    end
    if string.len(min) == 1 then
        min = '0' .. min
    end
    remaintimeValue:SetTextByKey('min',min)
    remaintimeValue:SetTextByKey('sec',sec)
    frame:SetUserValue('REMAIN_TIME',time)
    local total_time = frame:GetUserValue('TOTAL_TIME')
    local remaintimeGauge = GET_CHILD_RECURSIVELY(frame,"remaintimeGauge")
    remaintimeGauge:SetPoint(time, total_time);
end

function ANCIENT_SOLO_SET_PARAM_BY_SERVER(stage,zoneBuffName,firstClearItem,firstClearItemCnt,alreadyGet,TotalMonCount)
    local frame = ui.GetFrame('ancient_solo_dungeon_info')
    ANCIENT_SOLO_SET_STAGE_NUM(frame,stage)
    ANCIENT_SOLO_SET_ZONE_BUFF(frame,zoneBuffName)
    ANCIENT_SOLO_SET_CLEAR_REWARD(frame,firstClearItem,firstClearItemCnt,alreadyGet)
    ANCIENT_SOLO_SET_TOTAL_MON_COUNT(frame,TotalMonCount)
    frame:SetUserValue('TOTAL_TIME',180)
    ANCIENT_SOLO_SET_REMAIN_TIME(frame,180)
end

function ANCIENT_SOLO_UPDATE_REMAIN_TIME(actor)
    local frame = ui.GetFrame('ancient_solo_dungeon_info')
    local time = frame:GetUserValue('REMAIN_TIME')
    ANCIENT_SOLO_SET_REMAIN_TIME(frame,time-1)
end

function ANCIENT_SOLO_DUNGEON_INFO_OPEN_CHECK(frame)
    frame:ShowWindow(0)
end

function INIT_ANCIENT_SOLO_UI()
    local frame = ui.GetFrame('ancient_solo_dungeon_info')
    frame:ShowWindow(1)
end

--EVENT_1909_ANCIENT
function EVENT_1909_ANCIENT_EXIT_MGAME_MSG()
    
	local str = ScpArgMsg("AncientStageGiveUp")
    local yesScp = string.format("EVENT_1909_ANCIENT_EXIT_MGAME()");
	ui.MsgBox(str, yesScp, "None");
    
end

function EVENT_1909_ANCIENT_EXIT_MGAME()
    ReqAncientAllKill()
end