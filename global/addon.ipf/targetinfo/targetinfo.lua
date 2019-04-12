

TARGET_INFO_OFFSET_BOSS_X = 1200;
TARGET_INFO_OFFSET_X = 785;
TARGET_INFO_OFFSET_Y = 20;

function TARGETINFO_ON_INIT(addon, frame)
	addon:RegisterMsg('TARGET_SET', 'TGTINFO_TARGET_SET');
	addon:RegisterMsg('TARGET_BUFF_UPDATE', 'TGTINFO_BUFF_UPDATE');
	addon:RegisterMsg('TARGET_CLEAR', 'TARGETINFO_ON_MSG');
	addon:RegisterMsg('TARGET_UPDATE', 'TARGETINFO_ON_MSG');
	addon:RegisterMsg('UPDATE_SDR', 'TARGET_UPDATE_SDR');

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_TGT_DISTANCE");
	timer:Start(0.1);
	UPDATE_BOSS_SCORE_TIME(frame);
	frame:EnableHideProcess(1);

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

function UPDATE_TGT_DISTANCE(frame)

	local tgtHandle = frame:GetValue();
	local targetinfo = info.GetTargetInfo(tgtHandle);
	if nil == targetinfo then
		return;
	end

	local dist = targetinfo.distance;
	local str = string.format("   %0.1fm", dist/25);

	local nameRichText = GET_CHILD(frame, "dist", "ui::CRichText");
	nameRichText:SetText("{s16}{ol}"..str);
	-- ..ScpArgMsg("Auto_KeoLi_")..'{@st43}'..targetinfo.name.."{/}{/}{/}"
end

function TGTINFO_TARGET_SET(frame, msg, argStr, argNum)

	if argStr == "None" then
		return;
	end
	
	local mypclevel = GETMYPCLEVEL();
	local levelcolor = ""
	local targetHandle = session.GetTargetHandle();
	
	local targetinfo = info.GetTargetInfo( targetHandle );
	if nil == targetinfo then
		return;
	end

	if mypclevel + 10 < targetinfo.level then
		levelcolor = frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_10");
	elseif mypclevel + 5 < targetinfo.level then
		levelcolor = frame:GetUserConfig("MON_NAME_COLOR_MORE_THAN_5");
	end


	if targetinfo.TargetWindow == 0 then
		return;
	end

	local hpGauge; 

	if targetinfo.isBoss == 1 then
		return;
	end
	
	local normalImage;
	local eliteImage;

	if targetinfo.isElite == 1 then
		hpGauge = GET_CHILD(frame, "elite", "ui::CGauge");
		local normal = GET_CHILD(frame, "normal", "ui::CGauge");
		local elite = GET_CHILD(frame, "elite", "ui::CGauge");
		normal:ShowWindow(0);
		elite:ShowWindow(1);

		normalImage = GET_CHILD(frame, "target_info_gauge_image", "ui::CPicture");
		eliteImage = GET_CHILD(frame, "elitetarget_info_gauge_image", "ui::CPicture");
		normalImage:ShowWindow(0);
		eliteImage:ShowWindow(1);

	else
		hpGauge = GET_CHILD(frame, "normal", "ui::CGauge");
		local normal = GET_CHILD(frame, "normal", "ui::CGauge");
		local elite = GET_CHILD(frame, "elite", "ui::CGauge");
		normal:ShowWindow(1);
		elite:ShowWindow(0);

		normalImage = GET_CHILD(frame, "target_info_gauge_image", "ui::CPicture");
		eliteImage = GET_CHILD(frame, "elitetarget_info_gauge_image", "ui::CPicture");
		normalImage:ShowWindow(1);
		eliteImage:ShowWindow(0);
	end
	
	local targetMonRank = info.GetMonRankbyHandle(targetHandle);
	if nil ~= targetMonRank then		
		if targetMonRank == 'Special' then
			normalImage:SetImage("expert_info_gauge_image");
			eliteImage:SetImage("expert_info_gauge_image");
		else
			normalImage:SetImage("target_info_gauge_image");
			eliteImage:SetImage("elitetarget_info_gauge_image");
		end;

	end;


	frame:SetValue(session.GetTargetHandle());

	local dist = targetinfo.distance;
	local str = string.format("%0.1fm", dist/25);

	local nameRichText = GET_CHILD(frame, "dist", "ui::CRichText");
	nameRichText:SetText("{s16}{ol}"..str);
	-- ..ScpArgMsg("Auto_KeoLi_")..'{@st43}'..targetinfo.name.."{/}{/}{/}"
	local levelRichText = GET_CHILD(frame, "level", "ui::CRichText");
	if targetinfo.raceType ~= 'Item' then	
		levelRichText:SetText('{@st41}'..levelcolor..'Lv. '..targetinfo.level);
		levelRichText:ShowWindow(1);
	else
		levelRichText:ShowWindow(0);
	end

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

	-- name size
	local nametext = GET_CHILD(frame, "name", "ui::CRichText");
	local targetSize = targetinfo.size;
	if targetSize ~= nil then
		
		if targetinfo.raceType ~= 'Item' then
			--nametext:SetText('{@st41}      {@st43}'.. targetinfo.name .. '{@st53} ' .. targetSize); -- 타겟사이즈 나중에 스킬로 뺀다고 함
			nametext:SetText('{@st41}'.. levelcolor..targetinfo.name .. "{/}");
		else
			--nametext:SetText('{@st43}'.. targetinfo.name .. '{@st53} ' .. targetSize);
			nametext:SetText('{@st43}'.. targetinfo.name .. '{@st53} ');
		end
	end
		
	-- race
	local image = GET_CHILD(frame, "race", "ui::CPicture");

	if targetinfo.raceType ~= nil and targetinfo.raceType ~= 'Item' then
		image:SetImage('Tribe_' .. targetinfo.raceType);
		image:SetOffset( nametext:GetX() , image:GetY());
		image:ShowWindow(1);
	else
		image:ShowWindow(0);
	end
	
	

	-- attr
	local imageattr = GET_CHILD(frame, "attr", "ui::CPicture");

	if targetinfo.attribute == nil or targetinfo.attribute == 'Melee' then
		imageattr:ShowWindow(0);
	else
		imageattr:ShowWindow(1);
		imageattr:SetImage('Attri_' .. targetinfo.attribute);
	end

	-- attr
	local imageArmor = GET_CHILD(frame, "armor", "ui::CPicture");

	if targetinfo.armorType == nil or targetinfo.armorType == 'Melee' or targetinfo.armorType == 'None' then
		imageArmor:ShowWindow(0);
	else
		imageArmor:ShowWindow(1);
		imageArmor:SetImage('Armor_' .. targetinfo.armorType);
	end
	

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

		local targetinfo = info.GetTargetInfo( session.GetTargetHandle() );

		local hpGauge

		if targetinfo.isElite == 1 then
			hpGauge = GET_CHILD(frame, "elite", "ui::CGauge");
		else
			hpGauge = GET_CHILD(frame, "normal", "ui::CGauge");
		end

		local beforeHP = hpGauge:GetCurPoint();
		if beforeHP > stat.HP then
			local damRate = (beforeHP - stat.HP) / stat.maxHP;
			if damRate >= 0.5 then
				UI_PLAYFORCE(frame, "gauge_damage");
			end
		end

		hpGauge:SetMaxPointWithTime(stat.HP, stat.maxHP, 0.2, 0.4);
		frame:Invalidate();
	 end
 end


