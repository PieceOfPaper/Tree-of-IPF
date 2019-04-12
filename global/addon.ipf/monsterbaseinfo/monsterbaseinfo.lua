
function MONSTERBASEINFO_ON_INIT(addon, frame)	
	addon:RegisterMsg('PC_PROPERTY_UPDATE', 'MONSTERBASEINFO_ON_MSG');
	addon:RegisterMsg('TARGET_CLOSE', 'ON_TARGET_CLEAR');
	addon:RegisterMsg('TARGET_CLEAR', 'ON_TARGET_CLEAR');
	addon:RegisterMsg('TARGET_UPDATE', 'ON_MONB_TARGET_UPDATE');
	addon:RegisterMsg('SPC_TARGET_UPDATE', 'ON_MONB_SPC_TARGET_UPDATE');
	addon:RegisterMsg('TARGET_SET', 'ON_MONB_TARGET_SET');	
	addon:RegisterMsg('UPDATE_SDR', 'MONSTERBASEINFO_ON_MSG');
	addon:RegisterMsg('SHIELD_UPDATE', 'MONBASE_SHIELD_UPDATE');
	addon:RegisterMsg('SHOW_TARGET_UI', 'ON_SHOW_TARGET_UI');
	addon:RegisterMsg('MON_ENTER_SCENE', 'ON_MON_ENTER_SCENE');
	addon:RegisterMsg('TARGET_COLORSET', 'ON_TARGET_COLORSET');	
		
end

function SET_MONB_ALWAYS_VISIBLE(handle, enable)

	session.ui.SetAlwaysVisible(handle, enable);

end

function MONBASE_GAUGE_SET(frame, targetinfo)
	local nameRichText = GET_CHILD(frame, "name", "ui::CRichText");
	local stat = targetinfo.stat;
	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
	local shield = GET_CHILD(frame, "shield", "ui::CGauge");

	local gaugeWidth = targetinfo.radius * 6;
	local frameWidth = math.max(gaugeWidth, nameRichText:GetWidth()) + 10;

	frame:Resize(frameWidth, frame:GetHeight());
	hpGauge:Resize(gaugeWidth, 10);
	
	hpGauge:SetPoint(stat.HP, stat.maxHP);
	frame:SetDuration(10);
	if stat.shield == 0 then
		shield:ShowWindow(0);
	else
		shield:Resize(gaugeWidth, 10);
		shield:SetPoint(stat.shield, stat.maxHP);
		shield:ShowWindow(1);
	end		

end

function HIDE_MONBASE_INFO(frame)

	local nameRichText = GET_CHILD(frame, "name", "ui::CRichText");
	nameRichText:SetText("");
	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
	local shield = GET_CHILD(frame, "shield", "ui::CGauge");
	hpGauge:ShowWindow(0);
	shield:ShowWindow(0);
end

function ON_MON_ENTER_SCENE(frame, msg, str, handle)
	
	local visible = session.ui.IsAlwaysVisible(handle);
	if visible == true then
		SHOW_MONB_TARGET(handle, 0.0);
	end
end

function UPDATE_MONB(handle)
	local frame= ui.GetFrame("monb_"..handle);	
	if frame ~= nil then
		UPDATE_MONB_HP(frame, handle);
	end			
end

function SHOW_MONB_TARGET(handle, duration)

	local frameName = "monb_" .. handle;
	local cFrame = ui.GetFrame(frameName);
	if cFrame == nil then
		return nil;
	end
	OPEN_MONB_FRAME(cFrame, handle);
	UPDATE_MONB_HP(cFrame, handle);

	cFrame:SetDuration(1);
	return cFrame;

end

function ON_SHOW_TARGET_UI(frame, msg, argStr, handle)
	
	SHOW_MONB_TARGET(handle, 10.0);
	
end

function OPEN_MONB_FRAME(frame, handle)	
	if frame ~= nil and frame:IsVisible() == 0 then
		frame:ShowWindow(1);
		ui.UpdateCharBasePos(handle);
	end	
end

function ON_MONB_TARGET_SET(msgFrame, msg, argStr)

	local handle = session.GetTargetHandle();
	local frame= ui.GetFrame("monb_" .. handle);
	OPEN_MONB_FRAME(frame, handle);	
	UPDATE_MONB_HP(frame, handle);
	
end

function ON_TARGET_CLEAR(msgFrame, msg, argStr, handle)
	
	local frame= ui.GetFrame("monb_"..handle);
	if frame ~= nil and frame:GetDuration() == 0.0 then	
		local visible = session.ui.IsAlwaysVisible(handle);

		local targetInfo = info.GetTargetInfo(handle);
		if targetInfo.showHP == 1 then
			visible = false; -- Ÿ�������� �ƴ� ���� �̸�����
		end
		if visible == false then
			frame:ShowWindow(0);
		end
	end
end

function UPDATE_MONB_HP(frame, handle)
	if frame == nil then
		return;
	end

	-- ������ ����HP UI���� ���� ������. �̰Ŷ��� ����hp, name ����Ÿ�
	local targetInfo = info.GetTargetInfo(handle);
	if targetInfo ~= nil and targetInfo.isBoss == true and targetInfo.isSummonedBoss ~= 1 then
		frame:ShowWindow(0);
		return;
	end


	local stat = info.GetStat(handle);
	local hpObject = frame:GetChild('hp');
	local hpGauge = tolua.cast(hpObject,"ui::CGauge");
	
	if hpGauge:GetMaxPoint() ~= 0 then
		
		hpGauge:SetPoint(stat.HP, stat.maxHP);
		
		if stat.HP <= stat.maxHP/4 then
			hpGauge:SetBlink(20.0, 1.0, 0xffff3333);
			frame:SetDuration(20.0);
		else
			if hpGauge:IsBlinking() == 1 then
				hpGauge:ReleaseBlink();
				frame:SetDuration(10.0);
			end
		end

	elseif hpGauge:GetMaxPoint() == 0 then
		hpGauge:SetPoint(stat.HP, stat.maxHP);
	end

	if targetInfo.isSummonedBoss == 1 then
		hpGauge:ShowWindow(1)
	end
end

function ON_MONB_SPC_TARGET_UPDATE(msgFrame, msg, argStr, handle)
	UPDATE_MONB(handle);
end

function ON_MONB_TARGET_UPDATE(msgFrame, msg, argStr, argNum)

	local handle = session.GetTargetHandle();
	UPDATE_MONB(handle);
end

function MONSTERBASEINFO_ON_MSG(baseFrame, msg, argStr, argNum)

	local frame = ui.GetFrame("monb_"..session.GetTargetHandle());
	if frame == nil then
		return;
	end
	
	 if msg == 'PC_PROPERTY_UPDATE' then
		MONSTERBASEINFO_CHECK_OPENCONDITION(frame);
	 end
end

function MONBASE_SHIELD_UPDATE(msgFrame, msg, str, targetHandle)

	local frame= ui.GetFrame("monb_"..targetHandle);
	
	if frame ~= nil then
		local targetinfo = info.GetTargetInfo(targetHandle);
		MONBASE_GAUGE_SET(frame, targetinfo);
	end
end

function MONSTERBASEINFO_CHECK_OPENCONDITION(frame)
	MONSTERBASEINFO_CHECK_CTRL_OPENCONDITION(frame, "hp", "targetinfo");
end

function MONSTERBASEINFO_CHECK_CTRL_OPENCONDITION(frame, ctrlName, frameName)
	local hpGauge = GET_CHILD(frame, ctrlName, "ui::CGauge");
	local targetInfoOpen = ui.CanOpenFrame(frameName);
	local beforeVisible = hpGauge:IsVisible();
	if beforeVisible == targetInfoOpen then
		return;
	end
	
	hpGauge:ShowWindow(targetInfoOpen);
	frame:Invalidate();
end



