-- damage_meter.lua

local damage_meter_info_total = {}

function DAMAGE_METER_ON_INIT(addon, frame)
    addon:RegisterMsg('GAME_START', 'DAMAGE_METER_OPEN_CHECK');
    addon:RegisterMsg('WEEKLY_BOSS_DPS_START', 'DAMAGE_METER_UI_OPEN');
    addon:RegisterMsg('WEEKLY_BOSS_DPS_END', 'WEEKLY_BOSS_DPS_END');
    addon:RegisterMsg('WEEKLY_BOSS_DPS_TIMER_UPDATE', 'WEEKLY_BOSS_DPS_TIMER_UPDATE_BY_SERVER');
end

function DAMAGE_METER_UI_OPEN(frame,msg,strArg,numArg)
    frame:ShowWindow(1)
    WEEKLYBOSS_DPS_INIT(frame,strArg,numArg)
end

function WEEKLYBOSS_DPS_INIT(frame,strArg,appTime)
    local stringList = StringSplit(strArg,'/');
    local handle = tonumber(stringList[1])
    local is_practice = stringList[2]

    local stageGiveUp = GET_CHILD_RECURSIVELY(frame,'stageGiveUp')
    stageGiveUp:SetEnable(BoolToNumber(is_practice == "PRACTICE"))

    DAMAGE_METER_SET_WEEKLY_BOSS(frame,handle);

    frame:SetUserValue("NOW_TIME",appTime)
    frame:SetUserValue("END_TIME",appTime + 60*7)
    DAMAGE_METER_UPDATE_TIMER(frame)

    frame:SetUserValue("DPSINFO_INDEX","0")
    frame:SetUserValue("TOTAL_DAMAGE","0")
    damage_meter_info_total = {}
    session.dps.ReqStartDpsPacket();
    frame:RunUpdateScript("WEEKLY_BOSS_UPDATE_DPS", 0.1);
    
    DAMAGE_METER_RESET_GAUGE(frame)
end

function DAMAGE_METER_RESET_GAUGE(frame)
    local damageRankGaugeBox = GET_CHILD_RECURSIVELY(frame,"damageRankGaugeBox")
    damageRankGaugeBox:RemoveAllChild()

    DAMAGE_METER_WEEKLY_BOSS_TOTAL_DAMAGE(frame,0)
end

function DAMAGE_METER_SET_WEEKLY_BOSS(frame,handle)
    frame:SetUserValue("WEEKLY_BOSS_HANDLE",handle)
end

function DAMAGE_METER_WEEKLY_BOSS_TOTAL_DAMAGE(frame,accDamage)
    accDamage = STR_KILO_CHANGE(accDamage)
    local font = frame:GetUserConfig('GAUGE_FONT');
    local damageAccGaugeBox = GET_CHILD_RECURSIVELY(frame,'damageAccGaugeBox')
    local ctrlSet = damageAccGaugeBox:CreateOrGetControlSet('gauge_with_two_text', 'GAUGE_ACC', 0, 0);

    DAMAGE_METER_GAUGE_SET(ctrlSet,'',100,font..accDamage,'gauge_damage_meter_accumulation')
end

function DAMAGE_METER_GAUGE_SET(ctrl,leftStr,point,rightStr,skin)
    local leftText = GET_CHILD_RECURSIVELY(ctrl,'leftText')
    leftText:SetTextByKey('value',leftStr)
    
    local rightText = GET_CHILD_RECURSIVELY(ctrl,'rightText')
    rightText:SetTextByKey('value',rightStr)
    
    local guage = GET_CHILD_RECURSIVELY(ctrl,'gauge')
    guage:SetPoint(point,100)
    guage:SetSkinName(skin)
end

function WEEKLY_BOSS_UPDATE_DPS(frame,totalTime,elapsedTime)
    local now_time = frame:GetUserValue("NOW_TIME")
    frame:SetUserValue("NOW_TIME",now_time + elapsedTime)
    DAMAGE_METER_UPDATE_TIMER(frame)

    local idx = frame:GetUserValue("DPSINFO_INDEX")
    if idx == nil then
        return 1;
    end
    local cnt = session.dps.Get_allDpsInfoSize()
    if idx == cnt then
        return 1;
    end
    
    AUTO_CAST(frame)
    local totalDamage = frame:GetUserValue("TOTAL_DAMAGE");

    local damageRankGaugeBox = GET_CHILD_RECURSIVELY(frame,"damageRankGaugeBox")
    local gaugeCnt = damageRankGaugeBox:GetChildCount()
    local maxGaugeCount = 5

    local handle = tonumber(frame:GetUserValue("WEEKLY_BOSS_HANDLE"))
    for i = idx, cnt - 1 do
        local info = session.dps.Get_alldpsInfoByIndex(i)
        if info:GetHandle() == handle then
            local damage = info:GetStrDamage();
            if damage ~= '0' then
                local sklID = info:GetSkillID();
                local sklCls = GetClassByType("Skill",sklID)
                local keyword = TryGetProp(sklCls,"Keyword","None")
                keyword = StringSplit(keyword,';')
                for i = 1,#keyword do
                    if keyword[i] == 'NormalSkill' then
                        sklID = 1
                        break;
                    end
                end
                if table.find(keyword, "pcSummonSkill") > 0 then
                    sklID = 163915
                end
                if table.find(keyword, "Ancient") > 0 then
                    sklID = 179999
                end
                --update gauge damage info
                local function getIndex(table, val)
                    for i=1,#table do
                    if table[i][1] == val then 
                        return i
                    end
                    end
                    return #table+1
                end

                --add damage info
                local info_idx = getIndex(damage_meter_info_total,sklID)
                if damage_meter_info_total[info_idx] == nil then
                    damage_meter_info_total[info_idx] = {sklID,damage}
                else
                    damage_meter_info_total[info_idx][2] = SumForBigNumberInt64(damage,damage_meter_info_total[info_idx][2])
                end

                totalDamage = SumForBigNumberInt64(damage,totalDamage)
            end
        end
    end
    table.sort(damage_meter_info_total,function(a,b) return IsGreaterThanForBigNumber(a[2],b[2])==1 end)
    frame:SetUserValue("DPSINFO_INDEX",cnt)
    UPDATE_DAMAGE_METER_GUAGE(frame,damageRankGaugeBox)
    DAMAGE_METER_WEEKLY_BOSS_TOTAL_DAMAGE(frame,totalDamage)
    frame:SetUserValue("TOTAL_DAMAGE",totalDamage)
    return 1;
end

function DAMAGE_METER_UPDATE_TIMER(frame)
    local now_time = tonumber(frame:GetUserValue('NOW_TIME'))
    local end_time = tonumber(frame:GetUserValue('END_TIME'))
    local remain_time = math.floor(end_time - now_time)
    
    if remain_time < 0 then
        return;
    end

    local remaintimeValue = GET_CHILD_RECURSIVELY(frame,"remaintimeValue")
    local remaintimeGauge = GET_CHILD_RECURSIVELY(frame,"remaintimeGauge")
    
    remaintimeValue:SetTextByKey("min",math.floor(remain_time/60))
    remaintimeValue:SetTextByKey("sec",remain_time%60)
    remaintimeGauge:SetPoint(remain_time,60*7)
end

function WEEKLY_BOSS_DPS_TIMER_UPDATE_BY_SERVER(frame,msg,strArg,numArg)
    frame:SetUserValue('NOW_TIME',numArg)
end

function UPDATE_DAMAGE_METER_GUAGE(frame,groupbox)
    if #damage_meter_info_total == 0 then
        return
    end
    local maxDamage = damage_meter_info_total[1][2]
    local font = frame:GetUserConfig('GAUGE_FONT');
    local cnt = math.min(10,#damage_meter_info_total)
    for i = 1, cnt do
        local sklID = damage_meter_info_total[i][1]
        local damage = damage_meter_info_total[i][2]
        local skl = GetClassByType("Skill",sklID)

        if skl ~= nil then
            local ctrlSet = groupbox:GetControlSet('gauge_with_two_text', 'GAUGE_'..i)
            if ctrlSet == nil then
                ctrlSet = DAMAGE_METER_GAUGE_APPEND(frame,groupbox,i)
            end
            local point = MultForBigNumberInt64(damage,"100")
            point = DivForBigNumberInt64(point,maxDamage)
            local skin = 'gauge_damage_meter_0'..math.min(i,4)
            damage = font..STR_KILO_CHANGE(damage)
            DAMAGE_METER_GAUGE_SET(ctrlSet,font..skl.Name,point,font..damage,skin);
        end
    end
end

function DAMAGE_METER_GAUGE_APPEND(frame,groupbox, index)
    local height = 17
    local ctrlSet = groupbox:CreateControlSet('gauge_with_two_text', 'GAUGE_'..index, 0, (index-1)*height);
    if index <= 10 then
        frame:Resize(frame:GetWidth(),frame:GetHeight()+height)
        groupbox:Resize(groupbox:GetWidth(),groupbox:GetHeight()+height)
    end
    return ctrlSet
end

function DAMAGE_METER_OPEN_CHECK(frame)
    frame:ShowWindow(0)
end

function WEEKLY_BOSS_DPS_END(frame,msg,argStr,argNum)
    frame:StopUpdateScript("WEEKLY_BOSS_UPDATE_DPS");
    session.dps.ReqStopDps();

    local button = GET_CHILD_RECURSIVELY(frame,"stageGiveUp")
    button:SetEnable(0)
end

function DAMAGE_METER_REQ_RETURN()
    local yesscp = 'DAMAGE_METER_REQ_RETURN_YSE()';
	ui.MsgBox(ClMsg('WeeklyBoss_GiveUp_MSG'), yesscp, 'None');
end

function DAMAGE_METER_REQ_RETURN_YSE()
    RUN_GAMEEXIT_TIMER("RaidReturn")
end