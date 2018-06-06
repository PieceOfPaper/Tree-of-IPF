function COLONY_ALARM_ON_INIT(addon, frame)
    addon:RegisterMsg('COLONY_ALARM_MSG', 'ON_COLONY_ALARM_MSG');
end

function ON_COLONY_ALARM_MSG(frame, msg, argStr, diffSec)
    local text = frame:GetChild('text');
    local clmsg = '';
    if argStr == 'START' then
        if diffSec == -1800 then
            clmsg = ClMsg('Guild_Colony_Start_Msg_Before_30min');
        elseif diffSec == -600 then
            clmsg = ClMsg('Guild_Colony_Start_Msg_Before_10min');
        elseif diffSec == -300 then
            clmsg = ClMsg('Guild_Colony_Start_Msg_Before_5min');
        elseif diffSec == -60 then
            clmsg = ClMsg('Guild_Colony_Start_Msg_Before_1min');
            imcSound.PlaySoundEvent('battle_start_before');
        elseif diffSec == 0 then
            clmsg = ClMsg('Guild_Colony_Start_Msg');
            imcSound.PlaySoundEvent('battle_start');
        end
    elseif argStr == 'END' then
        if diffSec == -1800 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_30min');
            imcSound.PlaySoundEvent('battle_end_before_30min');
        elseif diffSec == -600 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_10min');
            imcSound.PlaySoundEvent('battle_end_before_10min');
        elseif diffSec == -300 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_5min');
            imcSound.PlaySoundEvent('battle_end_before_5min');
        elseif diffSec == -60 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_1min');
            imcSound.PlaySoundEvent('battle_end_before_1min');
        elseif diffSec >= -10 and diffSec < 0 then
            local countdownSec = -diffSec;
            clmsg = ScpArgMsg('Guild_Colony_End_Msg_Before{sec}', 'sec', countdownSec);
            imcSound.PlaySoundEvent('countdown_'..countdownSec);
        elseif diffSec == 0 then
            clmsg = ClMsg('Guild_Colony_End_Msg');
        end
    end
    text:SetText(clmsg);
    frame:SetDuration(15);
    frame:ShowWindow(1);
end