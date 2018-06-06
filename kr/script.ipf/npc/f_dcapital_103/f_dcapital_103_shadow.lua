function SCR_JOB_SHADOWMANCER_TIME_CHECK(self) -- Using Shadowmancer's Gimmick 
  	local time = os.date('*t')
    local year = time['year']
    local month = time['month']
    local day = time['day']
    local hour = time['hour']
    local min = time['min']
    if month < 10 then
        month = tostring("0"..month)
    end
    if day < 10 then
        day = tostring("0"..day)
    end
    if hour < 10 then
        hour = tostring("0"..hour)
    end
    if min < 10 then
        min = tostring("0"..min)
    end
    local today = tostring(year..month..day)
    local nowtime = tostring((hour * 60) + min)
    return today, nowtime
end


function SCR_DCAPITAL_103_SHADOW_DIALOG(self,pc)
    if IS_KOR_TEST_SERVER() then
        Kill(self)
    else
        local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19'); -- 히든 프롭 가져옴
        if hidden_prop == nil or hidden_prop == 0 then
            SCR_SET_HIDDEN_JOB_PROP(pc, 'Char2_19', 1)
            PlayEffect(self,"I_smoke013_dark3_1", 1, 1, "BOT")
            HideNPC(pc, "DCAPITAL_103_SHADOW")
            ShowBalloonText(pc, "DCAPITAL_103_SHADOW", 5)
        end
    end
end


function SCR_JOB_SHADOWMANCER_MON_BORN_AI(self)
    ObjectColorBlend(self, 0, 0, 0, 230)
    SetFixAnim(self, 'std')
end


function SCR_JOB_SHADOWMANCER_MON_DEAD_AI(self)
    SetFixAnim(self, 'std')
end


function SCR_DCAPITAL_103_SHADOW_DEVICE_DIALOG(self,pc)
end


function SCR_DCAPITAL_103_SHADOW_DEVICE_ENTER(self,pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, 'Char2_19')
    if hidden_prop <= 1 then
        ShowBalloonText(pc, "DCAPITAL_103_SHADOW_DEVICE", 2)
    end
end


function SCR_DCAPITAL_103_SHADOW_DEVICE_AI(self)
    PlayEffect(self, "F_lineup022_dark_blue2", 1.5, 1, 'BOT', 1)
end


function SCR_JOB_SHADOWMANCER_UNLOCK_SHADOW_BORN_AI(self)
    for i = 1, 5 do
        PlayEffect(self,"F_burstup002_dark2", 1, 1, "BOT")
        ObjectColorBlend(self, 10, 10, 10, (255/5)*i)
        sleep(500)
    end
end