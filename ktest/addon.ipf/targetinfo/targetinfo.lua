

TARGET_INFO_OFFSET_BOSS_X = 1200;
TARGET_INFO_OFFSET_X = 500;
TARGET_INFO_OFFSET_Y = 20;

function TARGETINFO_ON_INIT(addon, frame)
	addon:RegisterMsg('TARGET_SET', 'TGTINFO_TARGET_SET');
	addon:RegisterMsg('TARGET_BUFF_UPDATE', 'TGTINFO_BUFF_UPDATE');
	addon:RegisterMsg('TARGET_CLEAR', 'TARGETINFO_ON_MSG');
	addon:RegisterMsg('TARGET_UPDATE', 'TARGETINFO_ON_MSG');
	addon:RegisterMsg('UPDATE_SDR', 'TARGET_UPDATE_SDR');

	UPDATE_BOSS_SCORE_TIME(frame);
	frame:EnableHideProcess(1);
		
	TARGET_INFO_OFFSET_BOSS_X = 1200;
	TARGET_INFO_OFFSET_X = 500;
	TARGET_INFO_OFFSET_Y = 20;
 end

 function UPDATE_BOSS_SCORE_TIME(frame)

	local sObj = session.GetSessionObjectByName("ssn_mission");
	if sObj == nil then
		return;
	end

	local obj = GetIES(sObj:GetIESObject());
	local startTime = obj.Step25;
	local curTime = GetServerAppTime() - startTime;
	
	local m1time = frame:GetChild('m1time');
	local m2time = frame:GetChild('m2time');
	local s1time = frame:GetChild('s1time');
	local s2time = frame:GetChild('s2time');

	tolua.cast(m1time, "ui::CPicture");
	tolua.cast(m2time, "ui::CPicture");
	tolua.cast(s1time, "ui::CPicture");
	tolua.cast(s2time, "ui::CPicture");	
	
	local min, sec = GET_QUEST_MIN_SEC(curTime);
	
	SET_QUESTINFO_TIME_TO_PIC(min, sec, m1time, m2time, s1time, s2time);			
	frame:Invalidate();

end


function TARGET_UPDATE_SDR(frame, msg, argStr, SDR)
	local imagename = "dice_" .. SDR;
	local animpic = GET_CHILD(frame, "spl", "ui::CAnimPicture");
	animpic:SetFixImage(imagename);
	animpic:PlayAnimation();
end

function TGTINFO_BUFF_UPDATE(frame, msg, argStr, argNum)
	TGTINFO_TARGET_SET(frame);
end

function GET_BIRTH_BUFF_IMG_NAME(targetHandle)

	local targetActor = world.GetActor(targetHandle);

	if targetActor == nil then
		return
	end

	local clslist, cnt  = GetClassList("birthbufficon");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if targetActor:GetBuff():GetBuff(cls.ClassName) ~= nil then
			return cls.ImgName
		end
	end

	return "None";

end

function TGTINFO_TARGET_SET(frame, msg, argStr, argNum)
	if argStr == "None" then
		return;
	end

	if IS_IN_EVENT_MAP() == true then
		return;
	end
	
	local mypclevel = GETMYPCLEVEL();
	local levelcolor = ""
	local targetHandle = session.GetTargetHandle();
	local targetinfo = info.GetTargetInfo( targetHandle );
	if nil == targetinfo then
		return;
	end
    if targetinfo.TargetWindow == 0 then
		return;
	end
	if targetinfo.isBoss == 1 then
		return;
	end

    -- birth buff
    local mon_attribute_img = TARGETINFO_GET_ATTRIBUTE_SKIN_ANG_IMG(frame, targetinfo, targetHandle);
    local attribute = targetinfo.attribute
    local attributeImgName = "attribute_"..attribute
	if attributeImgName == "None" or attribute == "None" then
		mon_attribute_img:ShowWindow(0)
	else
		mon_attribute_img:ShowWindow(1)
		mon_attribute_img:SetImage(attributeImgName)
	end

	if mypclevel + 10 < targetinfo.level then
		levelcolor = frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_10");
	elseif mypclevel + 5 < targetinfo.level then
		levelcolor = frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_5");
	end
	
    -- gauge    
	local hpGauge = TARGETINFO_GET_HP_GAUGE(frame, targetinfo, targetHandle);
	frame:SetValue(session.GetTargetHandle());

	local stat = targetinfo.stat;

	if stat.HP ~= hpGauge:GetCurPoint() or stat.maxHP ~= hpGauge:GetMaxPoint() then    
		hpGauge:SetPoint(stat.HP, stat.maxHP);
		hpGauge:StopTimeProcess();
	else
		hpGauge:SetMaxPointWithTime(stat.HP, stat.maxHP, 0.2, 0.4);
	end

	if targetinfo.isInvincible ~= hpGauge:GetValue() then
		hpGauge:SetValue(targetinfo.isInvincible);
		if targetinfo.isInvincible == 1 then
			hpGauge:SetColorTone("FF111111");
		else
			hpGauge:SetColorTone("FFFFFFFF");
		end
	end
	local strHPValue = TARGETINFO_TRANS_HP_VALUE(targetHandle, stat.HP);
	local hpText = frame:GetChild('hpText');
    hpText:SetText(strHPValue);
    
    -- name	
	local targetSize = targetinfo.size;
	local eliteBuffMob = "";
	if targetSize ~= nil then		
		if targetinfo.isEliteBuff == 1 then
			eliteBuffMob = ClMsg("TargetNameElite") .. " ";
		end		
	end
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
    nametext:SetTextByKey('name', eliteBuffMob..targetinfo.name);
		
	-- race
    local monsterRaceSet = TARGETINFO_GET_RACE_CONTROL(frame, targetinfo, targetHandle);
    local racePic = monsterRaceSet:GetChild('racePic');
    local raceImg = TARGETINFO_GET_RACE_TYPE_IMAGE(monsterRaceSet, targetinfo.raceType);
    racePic = tolua.cast(racePic, 'ui::CPicture');
    racePic:SetImage(raceImg);	

	if ui.IsFrameVisible("targetinfotoboss") == 1 then
		frame:MoveFrame(TARGET_INFO_OFFSET_BOSS_X, TARGET_INFO_OFFSET_Y);
	else
		frame:MoveFrame(TARGET_INFO_OFFSET_X, TARGET_INFO_OFFSET_Y);
	end
	frame:ShowWindow(1);
	frame:Invalidate();	
end

function TARGETINFO_ON_MSG(frame, msg, argStr, argNum)

	if msg == 'TARGET_CLEAR' then
		frame:ShowWindow(0);
	end

	if msg == 'TARGET_UPDATE' then
		local stat = info.GetStat(session.GetTargetHandle());
		if stat == nil then
			return;
		end

        local targetHandle = session.GetTargetHandle();
		local targetinfo = info.GetTargetInfo(targetHandle);
		local hpGauge = TARGETINFO_GET_HP_GAUGE(frame, targetinfo, targetHandle);
		local beforeHP = hpGauge:GetCurPoint();
		if beforeHP > stat.HP then
			local damRate = (beforeHP - stat.HP) / stat.maxHP;
			if damRate >= 0.5 then
				UI_PLAYFORCE(frame, "gauge_damage");
			end
		end
		hpGauge:SetMaxPointWithTime(stat.HP, stat.maxHP, 0.2, 0.4);
		local strHPValue = TARGETINFO_TRANS_HP_VALUE(targetHandle, stat.HP);
		local hpText = frame:GetChild('hpText');
        hpText:SetText(strHPValue);
		frame:Invalidate();
	 end
 end

 function TARGETINFO_GET_HP_GAUGE(frame, targetinfo, targetHandle)
    local hpGauge = nil;
    local targetMonRank = info.GetMonRankbyHandle(targetHandle);
    local normalGaugeBox = frame:GetChild('normalGaugeBox');
    local specialGaugeBox = frame:GetChild('specialGaugeBox');
    local eliteGaugeBox = frame:GetChild('eliteGaugeBox');
        
	if targetinfo.isElite == 1 or targetinfo.isEliteBuff == 1 then
		hpGauge = GET_CHILD(eliteGaugeBox, "elite", "ui::CGauge");
        normalGaugeBox:ShowWindow(0);
        specialGaugeBox:ShowWindow(0);
        eliteGaugeBox:ShowWindow(1);
	elseif targetMonRank == 'Special' then
		hpGauge = GET_CHILD(specialGaugeBox, "special", "ui::CGauge");
        normalGaugeBox:ShowWindow(0);
        specialGaugeBox:ShowWindow(1);
        eliteGaugeBox:ShowWindow(0);
    else
        hpGauge = GET_CHILD(normalGaugeBox, "normal", "ui::CGauge");
        normalGaugeBox:ShowWindow(1);
        specialGaugeBox:ShowWindow(0);
        eliteGaugeBox:ShowWindow(0);
	end	
    return hpGauge;
 end

 function TARGETINFO_GET_RACE_CONTROL(frame, targetinfo, targetHandle)
    local raceCtrl = nil;
    local targetMonRank = info.GetMonRankbyHandle(targetHandle);
    local normalGaugeBox = frame:GetChild('normalGaugeBox');
    local specialGaugeBox = frame:GetChild('specialGaugeBox');
    local eliteGaugeBox = frame:GetChild('eliteGaugeBox');
        
	if targetinfo.isElite == 1 or targetinfo.isEliteBuff == 1 then
		raceCtrl = GET_CHILD(eliteGaugeBox, "eliteRace");
	elseif targetMonRank == 'Special' then
		raceCtrl = GET_CHILD(specialGaugeBox, "specialRace");
    else
        raceCtrl = GET_CHILD(normalGaugeBox, "normalRace");
	end	
    return raceCtrl;
 end

  function TARGETINFO_GET_ATTRIBUTE_SKIN_ANG_IMG(frame, targetinfo, targetHandle)
    local attributeSkin;
    local targetMonRank = info.GetMonRankbyHandle(targetHandle);
    local normalGaugeBox = frame:GetChild('normalGaugeBox');
    local specialGaugeBox = frame:GetChild('specialGaugeBox');
    local eliteGaugeBox = frame:GetChild('eliteGaugeBox');
        
	if targetinfo.isElite == 1 or targetinfo.isEliteBuff == 1 then
		attributeSkin = GET_CHILD(eliteGaugeBox, "elite_attribute_img");
	elseif targetMonRank == 'Special' then
		attributeSkin = GET_CHILD(specialGaugeBox, "special_attribute_img");
    else
        attributeSkin = GET_CHILD(normalGaugeBox, "normal_attribute_img");
	end	
    return attributeSkin;
 end

 function TARGETINFO_TRANS_HP_VALUE(handle, hp, fontStyle)
	-- 일반 HP의 경우 3자리마다 콤마를찍어준다.
	local strHPValue = tostring(math.floor(hp)):reverse():gsub("(%d%d%d)","%1,"):gsub(",(%-?)$","%1"):reverse();
	if info.IsPercentageHP(handle) == true then
		if fontStyle == nil or fontStyle == "None" then
			fontStyle = "";
		end
		
		if hp >= 10000 then 
			-- 100% 일때 계산필요 없이 100%
			strHPValue = fontStyle.."100%";	
		else
			
			strHPValue = string.format("%s%3.2f%%",fontStyle, hp/100.0);
		end
	end
	return strHPValue;
 end