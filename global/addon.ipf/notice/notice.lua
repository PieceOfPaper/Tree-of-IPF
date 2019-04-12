function NOTICE_ON_INIT(addon, frame)
    addon:RegisterMsg('NOTICE_Dm_timestart', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_5Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_3Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_2Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_1Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_30Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_20Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_10Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_5Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_3Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_2Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_1Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefStart5Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefStart4Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefStart3Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefStart2Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefStart1Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefExplan', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft1Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft30Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft5Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft4Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft3Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft2Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefLeft1Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefSucces', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_DefFail', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Boss5Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Boss4Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Boss3Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Boss2Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Boss1Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_BossKill', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Trap', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_TrapPlus', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Clear', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_GetItem', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_UsePotion', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Dead', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_ResBuff', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_scroll', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Bell', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_Bomb', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_!', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_SpaceBar', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffStart5Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffStart4Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffStart3Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffStart2Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffStart1Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffLeft2Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffLeft1Min', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffLeft30Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffLeft10Sec', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_OffLeft5Sec', 'NOTICE_ON_MSG');

    addon:RegisterMsg('NOTICE_Dm_raid_fail', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_reward_box', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_raid_clear', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_stage_clear', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_stage_start', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_stage_ready', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_move_to_point', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_guildevent_join_complete', 'NOTICE_ON_MSG');

    addon:RegisterMsg('NOTICE_Dm_invenfull', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_levelup_base', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_LevelUP_Auto', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_levelup_skill', 'NOTICE_ON_MSG');

    addon:RegisterMsg('NOTICE_Dm_GuildQuestSuccess', 'NOTICE_ON_MSG');
    addon:RegisterMsg('NOTICE_Dm_GuildQuestFail', 'NOTICE_ON_MSG');
    
    addon:RegisterMsg('NOTICE_Dm_Shoptutorial', 'NOTICE_ON_MSG');
    
    addon:RegisterMsg('NOTICE_Dm_quest_complete', 'NOTICE_ON_MSG');
    
    addon:RegisterMsg('NOTICE_Dm_Fishing', 'NOTICE_ON_MSG');
    
    
end

function NOTICE_CLOSE(frame)
    local statusUpControlSet = frame:GetChild('autolevup');
    
    if statusUpControlSet ~= nil then
        statusUpControlSet:ShowWindow(0);
    end 
end

function NOTICE_SKILL_USE(skillType, hotkey, slot)

    local frame = ui.GetFrame("notice");    
    if slot ~= nil then
        local tx, ty = GET_UI_FORCE_POS(slot);
        frame:SetUserValue("FORCE_X", tx);
        frame:SetUserValue("FORCE_Y", ty);
    else
        frame:SetUserValue("FORCE_X", "0");
        frame:SetUserValue("FORCE_Y", "0");
    end
    
    if frame:IsVisible() == 0 then      
        EXEC_NOTICE_SKILL(frame, hotkey, skillType);
    else
        local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
        timer:SetUpdateScript("NOTICE_CHECK_SKILL");
        timer:Start(0.1, 0);
        timer:SetArgString(hotkey);
        timer:SetArgNum(skillType);     
    end 
end

function NOTICE_CHECK_SKILL(frame, timer, str, num, totalTime)      
    if totalTime > 3.0 then
        timer:Stop();
        EXEC_NOTICE_SKILL(frame, str, num);
    end
end

function EXEC_NOTICE_SKILL(frame, hotkey, skillType)

    local skillCls = GetClassByType("Skill", skillType);
    local textObj = GET_CHILD(frame, "text", "ui::CRichText");
    textObj:SetText('{@st41}'.. hotkey..ScpArgMsg("Auto_Ki_SayongHayeo_")..skillCls.Name..ScpArgMsg("Auto__SeuKileul_SayongHal_Su_issSeupNiDa"));       
    local pictureObj = GET_CHILD(frame, "dungeon_msg", "ui::CPicture");
    pictureObj:SetImage('icon_'..skillCls.Icon);
        
    frame:ShowWindow(1);
    frame:SetDuration(3.0);

    local pic = GET_CHILD(frame, "dungeon_msg", "ui::CPicture");
    local fx, fy = GET_UI_FORCE_POS(pic);
    local tx, ty = frame:GetUserIValue("FORCE_X"), frame:GetUserIValue("FORCE_Y");
    UI_FORCE("skill_quickslot", fx, fy, tx, ty, 3.0, 'icon_'..skillCls.Icon);

end

function NOTICE_CUSTOM(msg, icon)
    local frame = ui.GetFrame("notice");
    local textObj = GET_CHILD(frame, "text", "ui::CRichText");
    textObj:SetText('{@st41}'.. msg);       
    local pictureObj = GET_CHILD(frame, "dungeon_msg", "ui::CPicture");
    pictureObj:SetImage(icon);      
    frame:ShowWindow(1);
    frame:SetDuration(3.0);
    return GET_UI_FORCE_POS(pictureObj);
end

function NOTICE_ON_MSG(frame, msg, argStr, argNum)  
    
    frame:Invalidate(); 
    local pFrame   = tolua.cast(frame, "ui::CFrame");
    local textObj = frame:GetChild('text');
    tolua.cast(textObj, "ui::CRichText");
    local pictureObj = frame:GetChild('dungeon_msg');
    if pictureObj ~= nil then
        tolua.cast(pictureObj, "ui::CPicture");
        pictureObj:ShowWindow(1);
        pictureObj:SetOffset(0, 0);
    end
    local noticeText = argStr;
    local exeText;
    
    textObj:SetOffset(0, 0);
    
    local addHeight = 0;
    
    
    if msg == 'NOTICE_Dm_Shoptutorial' then
        frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight() + 200)
        pictureObj:SetOffset(-250, 0);
        textObj:SetOffset(50, 150);
        textObj:Resize(textObj:GetOriginalWidth() - 50, 400)
        textObj:SetTextAlign("left", "bootom")
        pictureObj:Resize(45,160)
        exeText = noticeText
        pictureObj:ShowWindow(1);
    end
    
    if msg == 'NOTICE_Dm_levelup_base' or msg == 'NOTICE_Dm_levelup_skill' then     
        pFrame:ShowFrame(1);
        pFrame:SetImage('notice_levup');
        pictureObj:SetOffset(0, 0);
        textObj:SetOffset(0, 0);        
        if msg == 'NOTICE_Dm_levelup_base' then
            imcSound.PlaySoundEvent('sys_confirm'); -- levelup
        else
            if argStr == ScpArgMsg("Auto_KeulLeSeu_LeBeli_SangSeungHayeossSeupNiDa") then
                imcSound.PlaySoundEvent('statsup');
            end
        end

        exeText = '{@st41}'..noticeText;
    end
    
    if msg == 'NOTICE_Dm_LevelUP_Auto' then     
        pFrame:ShowFrame(1);
        pFrame:SetImage('notice_levup');
        pictureObj:ShowWindow(0);       
        --imcSound.PlaySoundItem('sys_levelup');
        
        local statusUpControlSet = pFrame:CreateOrGetControlSet('statusinfo', 'autolevup', 0, 0);
        tolua.cast(statusUpControlSet, "ui::CControlSet");
        statusUpControlSet:ShowWindow(1);
        statusUpControlSet:SetGravity(ui.CENTER_HORZ, ui.TOP);
        
        local bgPic = GET_CHILD(statusUpControlSet, "bgPic", "ui::CPicture");
        local underBarStart, underBarEnd = string.find(noticeText, '_');
        local statName = string.sub(noticeText, 1, underBarStart - 1);
        bgPic:SetImage(statName..'_slot');
        
        local name = GET_CHILD(statusUpControlSet, "name", "ui::CRichText");
        name:SetText('{@st42}{b}'..ClMsg(statName));

        local onepic = GET_CHILD(statusUpControlSet, "one", "ui::CPicture");
        local tenpic = GET_CHILD(statusUpControlSet, "ten", "ui::CPicture");
        onepic:ShowWindow(0);
        tenpic:ShowWindow(0);
        
        local pc = GetMyPCObject();
        local total = pc[statName];

        local statupValue = total;
        if statupValue >= 10 then
            local one = statupValue % 10;
            local ten = math.floor(statupValue / 10);

            onepic:SetImage(tostring(one));
            onepic:ShowWindow(1);
            onepic:SetOffset(15, 20);
            tenpic:SetImage(tostring(ten));
            tenpic:ShowWindow(1);
            tenpic:SetOffset(-12, 20);
        else
            onepic:SetImage(tostring(statupValue));
            onepic:ShowWindow(1);
            onepic:SetOffset(0, 20);
        end
        
        local btnUp = GET_CHILD(statusUpControlSet, "upbtn", "ui::CPicture");
        btnUp:ShowWindow(0);
        
        exeText = ClMsg('LevelUp');     
        addHeight = statusUpControlSet:GetHeight();
    end

    if msg == 'NOTICE_Dm_GuildQuestSuccess' then
        pFrame:ShowFrame(1);
        pFrame:SetImage('notice_guildquestsuccess');
        pictureObj:SetOffset(0, 0);
        textObj:SetOffset(0, 0);
        exeText = '{#FFFFFF}{s20}{ol}{gr gradation1}{/}'..noticeText ;
        imcSound.PlaySoundEvent('quest_success_3')
    end

    if msg == 'NOTICE_Dm_GuildQuestFail' then
        pFrame:ShowFrame(1);
        pFrame:SetImage('notice_guildquestfail');
        pictureObj:SetOffset(0, 0);
        textObj:SetOffset(0, 0);
        --imcSound.PlaySoundItem('sys_levelup'); -- levelup

        exeText = '{#FFFFFF}{s20}{ol}{gr gradation1}{/}'..noticeText ;
    end

    if msg == 'NOTICE_Dm_Global_Shout' then 
        pFrame:ShowFrame(1);

        textObj:SetOffset(0, 0);

        exeText = '{@st55_a}'..noticeText;
    end

    if msg == 'NOTICE_Dm_timestart' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_5Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_3Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_2Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_1Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_30Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_20Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_10Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_5Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_3Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_2Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_1Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefStart5Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefStart4Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefStart3Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefStart2Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefStart1Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefExplan' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft1Min' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft30Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft5Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft4Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft3Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft2Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefLeft1Sec' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefSucces' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_DefFail' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Boss5Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Boss4Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Boss3Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Boss2Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Boss1Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_BossKill' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Trap' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_TrapPlus' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Clear' then
--      imcSound.PlaySoundItem('sys_confirm');
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_GetItem' then
        imcSound.PlaySoundEvent("sys_quest_item_get")
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_UsePotion' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Dead' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_ResBuff' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_scroll' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Bell' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Bomb' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_!' then
        imcSound.PlaySoundEvent("sys_quest_message")
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_SpaceBar' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffStart5Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffStart4Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffStart3Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffStart2Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffStart1Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffLeft2Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffLeft1Min' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffLeft30Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffLeft10Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_OffLeft5Sec' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_invenfull' then
        exeText = '{@st41_red}'..noticeText ;
    elseif msg == 'NOTICE_Dm_quest_complete' then
        exeText = '{@st41}'..noticeText ;
        
    elseif msg == 'NOTICE_Dm_raid_fail' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_reward_box' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_raid_clear' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_stage_clear' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_stage_start' then
        exeText = '{@st41}'..noticeText ;
        imcSound.PlaySoundEvent('quest_event_start')
    elseif msg == 'NOTICE_Dm_stage_ready' then
        exeText = '{@st41}'..noticeText ;
        imcSound.PlaySoundEvent('quest_success_2')
    elseif msg == 'NOTICE_Dm_move_to_point' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_guildevent_join_complete' then
        exeText = '{@st41}'..noticeText ;
    elseif msg == 'NOTICE_Dm_Fishing' then
        exeText = '{@st41}'..noticeText ;
    end

    textObj:SetText(exeText);
    if pictureObj ~= nil then
        pictureObj:SetImage(msg);
    end

    frame:ShowWindow(1);
    
    if msg == 'NOTICE_Dm_Shoptutorial' then
    elseif addHeight == 0 and pictureObj ~= nil then
        frame:Resize(frame:GetWidth(), textObj:GetHeight() + pictureObj:GetHeight());
    else
        frame:Resize(frame:GetWidth(), textObj:GetHeight() + addHeight);
    end
    frame:SetDuration(argNum);

    if pictureObj == nil then
        return;
    end

    local effectOffset = (frame:GetY() + pictureObj:GetOffsetY()) * 2;

    if msg ~= 'NOTICE_Dm_levelup_base' and msg ~= NOTICE_Dm_GuildQuestSuccess and msg ~= NOTICE_Dm_GuildQuestFail then
        frame:ShowFrame(0);
        --movie.PlayUIEffect('uitest1', ui.GetClientInitialWidth() / 2 - 10, effectOffset, 1.0);
    end
end

function NOTICE_ITEM(itemCls, text, duration)

    local frame = ui.GetFrame("notice");
    frame:EnableHitTest(1);
    local pic = GET_CHILD(frame, "dungeon_msg", "ui::CPicture");
    pic:EnableHitTest(1);
    pic:ShowWindow(1);
    pic:SetImage(itemCls.Icon);
    SET_ITEM_TOOLTIP_TYPE(pic, itemCls.ClassID, itemCls);
    pic:SetTooltipArg('', itemCls.ClassID, 0);
    local textObj = GET_CHILD(frame, "text", "ui::CRichText");
    textObj:SetText(text);
    frame:ShowWindow(1);
    frame:SetDuration(duration);

end
