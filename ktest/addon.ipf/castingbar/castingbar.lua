function CASTINGBAR_ON_INIT(addon, frame)
 
	-- 기본 캐스팅바 (스킬시전하면 총 케스팅시간만큼 게이지가 풀로 차야 스킬시전. 조작불가)
	addon:RegisterMsg('CAST_BEGIN', 'CASTINGBAR_ON_MSG');
	addon:RegisterMsg('CAST_ADD', 'CASTINGBAR_ON_MSG');
	addon:RegisterMsg('CAST_END', 'CASTINGBAR_ON_MSG');

	-- 다이나믹 캐스팅바 (스킬키 누르고있는 상태에서만 게이지증가. 스킬키때면 스킬시전)
	addon:RegisterMsg('DYNAMIC_CAST_BEGIN', 'DYNAMIC_CASTINGBAR_ON_MSG');
	addon:RegisterMsg('DYNAMIC_CAST_END', 'DYNAMIC_CASTINGBAR_ON_MSG');

end 

function CASTINGBAR_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'CAST_BEGIN' then		-- 시전 시작
	 
		local castingObject = frame:GetChild('casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");		

		local time = argNum / 1000;   -- 이부분 필요한 값으로 변경
			
		castingGauge:SetTotalTime(time);	
		castingGauge:SetText(argStr, 'normal', 'center', 'bottom', 0, 0);

		local sklObj = GetSkill(GetMyPCObject(), argStr);
		if nil ~= sklObj then
			local sklName = argStr;
			local skillName = frame:GetChild("skillName");
			local translatedData = dictionary.ReplaceDicIDInCompStr(sklObj.Name);
			if sklObj.EngName == translatedData then
				sklName = sklObj.EngName;
			end
			skillName:SetTextByKey("name", sklName);
		end

		local animpic = GET_CHILD_RECURSIVELY(frame, "animpic");
		animpic:SetUserValue("LINKED_GAUGE", 0);
		LINK_OBJ_TO_GAUGE(frame, animpic, castingGauge, 1);
		
		frame:ShowWindow(1);
	end 

	if msg == 'CAST_ADD' then		-- 지연 및 단축 되는 시전 시간
	 
		local castingObject = frame:GetChild('casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		local time	= argNum / 1000;   -- 이부분 필요한 값으로 변경
			
		castingGauge:AddTotalTime(time);
	end 

	if msg == 'CAST_END' then		-- 시전이 끝난경우 메시지 처리
	    local animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		animpic:SetUserValue("LINKED_GAUGE", 0);
		frame:ShowWindow(0);
	end 

	-- 게이지가 2종류라 다른 1개는 끈다
	frame:GetChild('dynamic_casting'):ShowWindow(0);
end 

function DYNAMIC_CASTINGBAR_ON_MSG(frame, msg, argStr, maxTime, isVisivle)
	if msg == 'DYNAMIC_CAST_BEGIN' and maxTime > 0 then		-- 시전 시작
	 
		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		
		castingGauge:SetTotalTime(maxTime);
		frame:SetUserValue("MAX_CHARGE_TIME", maxTime);
		castingGauge:SetText("1", 'normal', 'center', 'bottom', 0, 0);
		
		local timer = frame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_CASTTIME");
		timer:SetValue( imcTime.GetDWTime() );
		timer:Start(1);
		if isVisivle == nil then
			isVisivle = 0;
		end
		
		local sList = StringSplit(argStr, "#");
		local sklName = argStr;
		if 1 < #sList then
			sklName = sList[1];
		end

		local sklObj = GetSkill(GetMyPCObject(), sklName);
		if nil ~= sklObj then
			local skillName = frame:GetChild("skillName");
			sklName = sklObj.Name;
			local translatedData = dictionary.ReplaceDicIDInCompStr(sklObj.Name);
			if sklObj.Name ~= translatedData then
				sklName = translatedData;
			end
			skillName:SetTextByKey("name", sklName);
		end

		frame:ShowWindow(isVisivle);

		frame:SetSkinName('skill-charge_gauge_bg');
		castingGauge:SetSkinName('skill-charge_gauge2');
		castingGauge:SetInverse(0);
		frame:Invalidate();
		frame:SetUserValue('LOOPING_CHARGE', 0);

		if 1 < #sList then
			frame:SetUserValue('LOOPING_CHARGE', 1);			
		end

		local dynamic_animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		LINK_OBJ_TO_GAUGE(frame, dynamic_animpic, castingGauge, 1);
	end 

	if msg == 'DYNAMIC_CAST_END' then		-- 시전이 끝난경우 메시지 처리

		local castingGauge = GET_CHILD(frame, 'dynamic_casting', "ui::CGauge");
		castingGauge:StopTimeProcess();	 
		local timer = frame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:Stop();
		frame:ShowWindow(0);
		frame:SetUserValue('LOOPING_CHARGE', 0);

		local dynamic_animpic = GET_CHILD_RECURSIVELY(frame, "dynamic_animpic");
		dynamic_animpic:SetUserValue("LINKED_GAUGE", 0);
	end 

	-- 게이지가 2종류라서 다른 1개는 끈다
	frame:GetChild('casting'):ShowWindow(0);
end 

function UPDATE_CASTTIME(frame)
	
	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");		
	local time = GetDynamicCastSkillChargedTime();
		
	local maxTime = tonumber( frame:GetUserValue("MAX_CHARGE_TIME") );
	

	local chargeType = tonumber( frame:GetUserValue('LOOPING_CHARGE') );

	if chargeType == 0 then

		if maxTime < time then
			-- uiEffect가 useExternal이 안먹어서 루핑UI이펙트를 끄는걸 못하겠음. 그래서 아래처럼 처리함.
			-- full charge 상태가되면 캐스팅시간 체크하는 함수는 종료하고 이펙트 실행할 함수로 다시 셋팅.
			timer:Stop();
			timer:SetUpdateScript("PLAY_FULL_CHARGING");		
			timer:Start(1);
			frame:Invalidate();
		end		

	elseif chargeType == 1 then
		
		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		castingGauge:SetPoint(time, maxTime);

		if maxTime < time then
			frame:SetUserValue('LOOPING_CHARGE', 2);

		end

	elseif chargeType == 2 then

		local castingObject = frame:GetChild('dynamic_casting');
		local castingGauge = tolua.cast(castingObject, "ui::CGauge");
		castingGauge:SetPoint(maxTime-time, maxTime);

		if maxTime < time then
			frame:SetUserValue('LOOPING_CHARGE', 1);

		end
	end

end

function PLAY_FULL_CHARGING(frame)

	local posX, posY = GET_SCREEN_XY(frame);
	movie.PlayUIEffect('I_sys_fullcharge', posX, posY, 6.2);
	imcSound.PlaySoundEvent("sys_alarm_fullcharge");
end