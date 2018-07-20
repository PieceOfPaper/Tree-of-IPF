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

	local dist = targetinfo.distance;
	local str = string.format("%0.1f m", dist / 25);

	local nameRichText = GET_CHILD(frame, "dist", "ui::CRichText");
	nameRichText:SetText("{s16}{ol}"..str);

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

	--dist
	local dist = targetinfo.distance;
	local str = string.format("%0.1f m", dist / 25);
	local nameRichText = GET_CHILD(frame, "dist", "ui::CRichText");
	nameRichText:SetText("{s16}{ol}"..str);

	-- lv
	local levelRichText = GET_CHILD(frame, "level", "ui::CRichText");
	levelRichText:SetText('{@st41}{#ffcc00}Lv. '..targetinfo.level);

	-- name size
	local nametext = GET_CHILD(frame, "name", "ui::CRichText");
	local bossSize = targetinfo.size;
	--nametext:SetText('{@st41}      {@st43}'.. targetinfo.name .. '{@st53} ' .. targetinfo.size);
	nametext:SetText('{@st41}{#ffcc00}'.. targetinfo.name);
	
	-- race
	local image = GET_CHILD(frame, "race", "ui::CPicture");
	image:SetImage('Tribe_' .. targetinfo.raceType);
	image:SetOffset( nametext:GetX() , image:GetY());

	-- hp

	local stat = targetinfo.stat;
	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
	hpGauge:SetPoint(stat.HP, stat.maxHP);

	if targetinfo.isInvincible ~= hpGauge:GetValue() then
		hpGauge:SetValue(targetinfo.isInvincible);
		if targetinfo.isInvincible == 1 then
			hpGauge:SetColorTone("FF111111");
		else
			hpGauge:SetColorTone("FFFFFFFF");
		end
	end

	-- attr
	local imageattr = GET_CHILD(frame, "attr", "ui::CPicture");

	if targetinfo.attribute == 'Melee' then
		imageattr:ShowWindow(0);
	else
		imageattr:ShowWindow(1);
		imageattr:SetImage('Attri_' .. targetinfo.attribute);
	end

	-- attr
	local imageArmor = GET_CHILD(frame, "armor", "ui::CPicture");

	if targetinfo.armorType == 'Melee' then
		imageArmor:ShowWindow(0);
	else
		imageArmor:ShowWindow(1);
		imageArmor:SetImage('Armor_' .. targetinfo.armorType .. '_B');
	end

	local targetFrame = ui.GetFrame("targetinfo");
	if targetFrame:IsVisible() == 1 then
		--targetFrame:SetOffset(230, 20);
		--targetFrame:SetEffect("targetinfo_left", ui.UI_TEMP0);
		--targetFrame:StartEffect(ui.UI_TEMP0);
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
			if frame:IsVisible() == 0 then
				frame:ShowWindow(1)
			end
			frame:Invalidate();
		end
	end
 end


