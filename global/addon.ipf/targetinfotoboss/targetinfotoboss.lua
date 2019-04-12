function TARGETINFOTOBOSS_ON_INIT(addon, frame)

	addon:RegisterMsg('TARGET_SET_BOSS', 'TARGETINFOTOBOSS_TARGET_SET');
	addon:RegisterMsg('TARGET_BUFF_UPDATE', 'TARGETINFOTOBOSS_ON_MSG');
	addon:RegisterMsg('TARGET_CLEAR_BOSS', 'TARGETINFOTOBOSS_ON_MSG');
	addon:RegisterMsg('TARGET_UPDATE', 'TARGETINFOTOBOSS_ON_MSG');
	addon:RegisterMsg('UPDATE_SDR', 'TARGETINFOTOBOSS_UPDATE_SDR');

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_BOSS_DISTANCE");
	timer:Start(0.1);

 end
 
 function UPDATE_BOSS_DISTANCE(frame)
 	local handle = session.GetTargetBossHandle();
	local targetinfo = info.GetTargetInfo(handle);
	if nil == targetinfo then
		session.ResetTargetBossHandle();
		frame:ShowWindow(0);
		return;
	end
 end

function TARGETINFOTOBOSS_UPDATE_SDR(frame, msg, argStr, SDR)

	local imagename = "dice_" .. SDR;
	local animpic = GET_CHILD(frame, "spl", "ui::CAnimPicture");
	animpic:SetFixImage(imagename);
	animpic:PlayAnimation();

end

function TARGETINFOTOBOSS_BUFF_UPDATE(frame, msg, argStr, argNum)
	TARGETINFOTOBOSS_TARGET_SET(frame, msg, argStr, argNum);
end

function TARGETINFOTOBOSS_TARGET_SET(frame, msg, argStr, argNum)
	if argStr == "None" or argNum == nil then
		return;
	end
	
	local targetinfo = info.GetTargetInfo(argNum);
	if targetinfo == nil then
		session.ResetTargetBossHandle();
		frame:ShowWindow(0);
		return;
	end
	
	if 0 == targetinfo.TargetWindow or targetinfo.isBoss == 0 then
		session.ResetTargetBossHandle();
		frame:ShowWindow(0);
		return;
	end

	local birth_buff_skin = GET_CHILD_RECURSIVELY(frame, "birth_buff_skin");
	local birth_buff_img = GET_CHILD_RECURSIVELY(frame, "birth_buff_img");

	local birthBuffImgName = GET_BIRTH_BUFF_IMG_NAME(session.GetTargetBossHandle());
	if birthBuffImgName == "None" then
		birth_buff_skin:ShowWindow(0)
		birth_buff_img:ShowWindow(0)
	else
		birth_buff_skin:ShowWindow(1)
		birth_buff_img:ShowWindow(1)
		birth_buff_img:SetImage(birthBuffImgName)
	end

	-- name
	local nametext = GET_CHILD_RECURSIVELY(frame, "name", "ui::CRichText");
	local mypclevel = GETMYPCLEVEL();
    local levelColor = "";
    if mypclevel + 10 < targetinfo.level then
        nametext:SetTextByKey('color', frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_10"));
	elseif mypclevel + 5 < targetinfo.level then
        nametext:SetTextByKey('color', frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_5"));
    else
        nametext:SetTextByKey('color', frame:GetUserConfig("MON_NAME_COLOR_DEFAULT"));
	end
    nametext:SetTextByKey('lv', targetinfo.level);
    nametext:SetTextByKey('name', targetinfo.name);
	
	-- race
	local raceTypeSet = GET_CHILD(frame, "race");    
    local image = raceTypeSet:GetChild('racePic');    
    local imageStr = TARGETINFO_GET_RACE_TYPE_IMAGE(raceTypeSet, targetinfo.raceType);
    image = tolua.cast(image, 'ui::CPicture');    
    image:SetImage(imageStr);

	-- hp
	local stat = targetinfo.stat;
	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
    local hpText = frame:GetChild('hpText');
	hpGauge:SetPoint(stat.HP, stat.maxHP);
    hpText:SetText(GET_COMMAED_STRING(stat.HP));

	if targetinfo.isInvincible ~= hpGauge:GetValue() then
		hpGauge:SetValue(targetinfo.isInvincible);
		if targetinfo.isInvincible == 1 then
			hpGauge:SetColorTone("FF111111");
		else
			hpGauge:SetColorTone("FFFFFFFF");
		end
	end

	frame:ShowWindow(1);
	frame:Invalidate();
	frame:SetValue(argNum);	-- argNum 가 핸들임
end

function TARGETINFOTOBOSS_ON_MSG(frame, msg, argStr, argNum)

	if msg == 'TARGET_CLEAR_BOSS' then
		session.ResetTargetBossHandle();
		frame:SetVisible(0); -- visible값이 1이면 다른 몬스터 hp gauge offset이 옆으로 밀림.(targetinfo.lua 참조)
		frame:ShowWindow(0);
	end
	
	if msg == 'TARGET_UPDATE' or msg == 'TARGET_BUFF_UPDATE' then
		local target = session.GetTargetBossHandle();
		if target ~= 0 then
			if session.IsBoss( target ) == true then				
				TARGETINFOTOBOSS_TARGET_SET(frame, 'TARGET_SET_BOSS', "Enemy", target)
			end
		end
		
		local stat = info.GetStat(session.GetTargetBossHandle());	
		if stat ~= nil then
			local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
			hpGauge:SetPoint(stat.HP, stat.maxHP);

            local hpText = frame:GetChild('hpText');
            hpText:SetText(GET_COMMAED_STRING(stat.HP));
			if frame:IsVisible() == 0 then
				frame:ShowWindow(1)
			end
			frame:Invalidate();
		end
	end
 end

 function TARGETINFO_GET_RACE_TYPE_IMAGE(monsterRaceSet, raceType)
    local raceStr = '';
    if raceType == 'Klaida' then
	    raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_INSECT');
    elseif raceType == 'Widling' then
        raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_WILD');
    elseif raceType == 'Velnias' then
        raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_DEVIL');
    elseif raceType == 'Forester' then
        raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_PLANT');
    elseif raceType == 'Paramune' then
        raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_VARIATION');
    elseif raceType == 'None' then
        raceStr = monsterRaceSet:GetUserConfig('IMG_RACE_NONE');
    end
    return raceStr;
 end