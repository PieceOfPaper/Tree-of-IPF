function COLONY_ALARM_ON_INIT(addon, frame)
    addon:RegisterMsg('COLONY_ALARM_MSG', 'ON_COLONY_ALARM_MSG');
    addon:RegisterMsg('COLONY_BGM', 'ON_COLONY_BGM');
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
                if config.GetServiceNation() == 'KOR' then
                    imcSound.PlaySoundEvent('battle_start_before');
                else
                    imcSound.PlaySoundEvent('S1_battle_start_before_1');
                end
        elseif diffSec == 0 then
            clmsg = ClMsg('Guild_Colony_Start_Msg');
                if config.GetServiceNation() == 'KOR' then
                    imcSound.PlaySoundEvent('battle_start');
                else
                    imcSound.PlaySoundEvent('S1_battle_start');
                end
        end
    elseif argStr == 'END' then
        if diffSec == -1800 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_30min');
            if config.GetServiceNation() == 'KOR' then
                imcSound.PlaySoundEvent('battle_end_before_30min');
            else
                imcSound.PlaySoundEvent('S1_battle_end_before_30min');
            end
        elseif diffSec == -600 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_10min');
            if config.GetServiceNation() == 'KOR' then
                imcSound.PlaySoundEvent('battle_end_before_10min');
            else
                imcSound.PlaySoundEvent('S1_battle_end_before_10min');
            end
        elseif diffSec == -300 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_5min');
            if config.GetServiceNation() == 'KOR' then
                imcSound.PlaySoundEvent('battle_end_before_5min');
            else
                imcSound.PlaySoundEvent('S1_battle_end_before_5min');
            end
        elseif diffSec == -60 then
            clmsg = ClMsg('Guild_Colony_End_Msg_Before_1min');
            if config.GetServiceNation() == 'KOR' then
                imcSound.PlaySoundEvent('battle_end_before_1min');
            else
                imcSound.PlaySoundEvent('S1_battle_end_before_1min');
            end
        elseif diffSec >= -10 and diffSec < 0 then
            local countdownSec = -diffSec;
            clmsg = ScpArgMsg('Guild_Colony_End_Msg_Before{sec}', 'sec', countdownSec);
            if config.GetServiceNation() == 'KOR' then
                imcSound.PlaySoundEvent('countdown_'..countdownSec);
            else
                imcSound.PlaySoundEvent('S1_countdown_'..countdownSec);
            end
        elseif diffSec == 0 then
            clmsg = ClMsg('Guild_Colony_End_Msg');
                if config.GetServiceNation() == 'KOR' then
                    imcSound.PlaySoundEvent('battle_end');
                else
                    imcSound.PlaySoundEvent('S1_battle_end');
                end
        end
    end

    text:SetText(clmsg);
    frame:SetDuration(15);
    frame:ShowWindow(1);
end


function ON_COLONY_BGM(frame, msg, argStr, diffSec)

    if argStr == 'START' then
        if diffSec == -63 then
            imcSound.PlayMusicQueueLocal('battle_colony')
        end
    end

end