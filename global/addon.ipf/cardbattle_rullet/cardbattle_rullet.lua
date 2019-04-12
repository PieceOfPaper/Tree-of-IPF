

function ANGLE_WHEN_TIME(speed, accel, time)
	return time * speed + 0.5 * accel * (time * time);
end

function START_RULLET()
	imcSound.PlaySoundEvent("sys_card_battle_roulette_turn");
	local frame = ui.GetFrame("cardbattle_rullet");
	frame:SetUserValue("LAST_PIC_ANGLE", 0);
	
	local winSide = frame:GetUserIValue("WINSIDE");
	local randomValue = frame:GetUserIValue("RANDOMVALUE");
	local factor = tonumber(frame:GetUserValue("FACTOR"));

	frame:SetUserValue("DEST_ANGLE", randomValue * 45 + IMCRandom(5, 40)); 

	local startSpeed, accel = GET_CARD_BATTLE_RULLET_SPEED(factor);
	local stopTime = startSpeed / accel;
	frame:SetUserValue("STOP_TIME", stopTime); 
	local angleByRotation  = ANGLE_WHEN_TIME(startSpeed, accel, stopTime);
	
	frame:SetUserValue("START_SPEED", startSpeed); 
	frame:SetUserValue("ACCEL", accel); 

	frame:RunUpdateScript("RUN_CARDBATTLE_RULLET", 0, 0, 0, 1);
	frame:SetDuration(stopTime + 1.5);

end

function CARDBATTLE_RULLET_INIT_POS(frame)

	local cardbattleFrame = ui.GetFrame("cardbattle");
	local x = cardbattleFrame:GetX() + cardbattleFrame:GetWidth() / 2;
	local y = cardbattleFrame:GetY();
	AUTO_CAST(frame);
	frame:MoveFrame(x - frame:GetWidth() * 0.5, y);
	frame:SetUserValue("LAST_CARD_FRAME_X", x);
	frame:SetUserValue("LAST_CARD_FRAME_Y", y);

	frame:RunUpdateScript("CARDBATTLE_RULLET_AUTOPOS", 0, 0, 0, 1);
end

function CARDBATTLE_RULLET_AUTOPOS(frame)

	local cardbattleFrame = ui.GetFrame("cardbattle");
	local x = cardbattleFrame:GetX() + cardbattleFrame:GetWidth() / 2;
	local y = cardbattleFrame:GetY();
	local lastX = frame:GetUserIValue("LAST_CARD_FRAME_X");
	local lastY = frame:GetUserIValue("LAST_CARD_FRAME_Y");
	if x ~= lastX or y ~= lastY then

		local dx = x - lastX;
		local dy = y - lastY;
		frame:Move(dx, dy);
		frame:SetUserValue("LAST_CARD_FRAME_X", x);
		frame:SetUserValue("LAST_CARD_FRAME_Y", y);
	end
	
	return 1;
end

function REEST_CARDBATTLE_RESULT()
	
	local frame = ui.GetFrame("cardbattle_rullet");
	frame:StopUpdateScript("RUN_CARDBATTLE_RULLET");
	frame:CancelReserveScript("OPEN_RULLET_FRAME");
	frame:CancelReserveScript("START_RULLET");

	local resultFrame = ui.GetFrame("cardbattle_result");
	resultFrame:CancelReserveScript("OPEN_RULLET_FRAME");	
	resultFrame:CancelReserveScript("PLAY_RESULT_EFFECT");	
	
end

function PLAY_RESULT_EFFECT(frame)
	local posX, posY = GET_SCREEN_XY(frame);
	movie.PlayUIEffect(frame:GetUserConfig("RESULT_EFT"), posX, posY, tonumber(frame:GetUserConfig("RESULT_EFT_SCALE")));
end

function SHOW_CARDBATTLE_RESULT(elapsedTime, handle, factor, winSide, randomValue)

	if 0 == ui.IsFrameVisible("cardbattle") then
		return;
	end
	
	local cardbattleFrame = ui.GetFrame("cardbattle");
	if cardbattleFrame:GetUserIValue("OWNER_HANDLE") ~= handle then
		return;
	end

	ui.CloseFrame("inventory");
		
	REEST_CARDBATTLE_RESULT();

	local frame = ui.GetFrame("cardbattle_rullet");
	CARDBATTLE_RULLET_INIT_POS(frame);
	local pic_rullet = frame:GetChild("pic_rullet");
	pic_rullet:SetAngle(0);

	cardbattleFrame:SetUserValue("WINSIDE", winSide);
	frame:SetUserValue("WINSIDE", winSide);
	frame:SetUserValue("RANDOMVALUE", randomValue);
	frame:SetUserValue("FACTOR", factor);
	frame:SetUserValue("OWNER_HANDLE", handle);
	cardbattleFrame:SetUserValue("OWNER_HANDLE", handle);
	frame:EnableHideProcess(1);
	frame:ReserveScript("OPEN_RULLET_FRAME", CARDBATTLE_RULLET_OPEN_DELAY(), 1);
	frame:ReserveScript("START_RULLET", CARDBATTLE_RULLET_OPEN_DELAY() + 1.8, 1);

	local txt_nowcondition = frame:GetChild("txt_nowcondition");
	txt_nowcondition:SetTextByKey("value", "");
	frame:SetUserValue("LASTRANDOM", -1);

	local score_1 = frame:GetChild("score_1");
	local score_2 = frame:GetChild("score_2");
	score_1:SetTextByKey("value", "");
	score_2:SetTextByKey("value", "");

	local resultFrame = ui.GetFrame("cardbattle_result");
	resultFrame:SetUserValue("WINSIDE", winSide);
	CARDBATTLE_RULLET_INIT_POS(resultFrame)
	local targetHandle = geClientCardBattle.GetTargetHandle(handle);
	local txt_condition = resultFrame:GetChild("txt_condition");

	local ownerName = info.GetFamilyName(handle);
	local targetName = info.GetFamilyName(targetHandle);
	local ownerItem, targetItem = GetCardBattleItems(handle);
		
	local team1Text = ScpArgMsg("CardOfUser{UserName}", "UserName", targetName);
	local team2Text = ScpArgMsg("CardOfUser{UserName}", "UserName", ownerName);

	local targetEngName = "";
	local ownerEngName = "";
	local cardCls = GetClass("CardBattle", targetItem.ClassName);
	targetEngName = cardCls.EngName;
	cardCls = GetClass("CardBattle", ownerItem.ClassName);
	ownerEngName = cardCls.EngName;

	team1Text = team1Text .. "{nl}" .. targetItem.Name .. "{nl}" .. targetEngName;
	team2Text = team2Text .. "{nl}" .. ownerItem.Name .. "{nl}" .. ownerEngName;

	local condDesc = ScpArgMsg(GET_CARDBATTLE_DECISION_DESC(randomValue));
	local winCond = ScpArgMsg("WinCondition:{Condition}", "Condition", condDesc);
	txt_condition:SetTextByKey("value",  winCond );
	local gbox_1 = resultFrame:GetChild("gbox_1");
	local gbox_2 = resultFrame:GetChild("gbox_2");
	gbox_1:GetChild("txt_card"):SetTextByKey("value", team1Text);
	gbox_2:GetChild("txt_card"):SetTextByKey("value", team2Text);

	local pic_1 = GET_CHILD(resultFrame, "pic_1");
	local pic_2 = GET_CHILD(resultFrame, "pic_2");

	local resultText;

	if winSide == 1 then
		gbox_1:SetSkinName("test_com_winbg");
		gbox_2:SetSkinName("test_com_losebg");
		pic_1:SetImage("test_result_win");
		pic_2:SetImage("test_result_lose");
		pic_1:ShowWindow(1);
		pic_2:ShowWindow(1);
		resultText = ScpArgMsg("User{UserName}HasWin", "UserName", targetName);

	elseif winSide == 2 then
		gbox_1:SetSkinName("test_com_losebg");
		gbox_2:SetSkinName("test_com_winbg");
		pic_1:SetImage("test_result_lose");
		pic_2:SetImage("test_result_win");
		pic_1:ShowWindow(1);
		pic_2:ShowWindow(1);
		resultText = ScpArgMsg("User{UserName}HasWin", "UserName", ownerName);
	
	else
		gbox_1:SetSkinName("test_com_losebg");
		gbox_2:SetSkinName("test_com_losebg");
		pic_1:ShowWindow(0);
		pic_2:ShowWindow(0);
		resultText = ScpArgMsg("Draw");

	end

	local txt_result = resultFrame:GetChild("txt_result");
	txt_result:SetTextByKey("value", resultText);

	local startSpeed, accel = GET_CARD_BATTLE_RULLET_SPEED(factor);
	local stopTime = startSpeed / accel;

	resultFrame:EnableHideProcess(1);
	local openResultSecond = CARDBATTLE_RULLET_OPEN_DELAY() + 1.8 + stopTime + 2.5;
	resultFrame:ReserveScript("OPEN_RULLET_FRAME", openResultSecond, 1);
	resultFrame:ReserveScript("PLAY_RESULT_EFFECT", openResultSecond + 0.5, 1);
	resultFrame:SetDuration(4.0);
	cardbattleFrame:ReserveScript("EMPHASIZE_WINNER", openResultSecond - 1, 1);
	
	if elapsedTime > 2.0 then
		resultFrame:ForceUpdateForTime(elapsedTime);
		frame:ForceUpdateForTime(elapsedTime);
	end
end

function EMPHASIZE_WINNER(frame)

	--imcSound.PlaySoundEvent(frame:GetUserConfig("END_SOUND"));
	
	local winSide = frame:GetUserIValue("WINSIDE");
	local handle = frame:GetUserValue("OWNER_HANDLE");
	local targetHandle = geClientCardBattle.GetTargetHandle(handle);
	if winSide == 0 then
		local card_1 = GET_CHILD(frame, "card_1");
		local card_2 = GET_CHILD(frame, "card_2");

		local posX, posY = GET_SCREEN_XY(card_1);
		movie.PlayUIEffect(frame:GetUserConfig("DRAW_EFT"), posX, posY, tonumber(frame:GetUserConfig("DRAW_EFT_SCALE")));

		posX, posY = GET_SCREEN_XY(card_2);
		movie.PlayUIEffect(frame:GetUserConfig("DRAW_EFT"), posX, posY, tonumber(frame:GetUserConfig("DRAW_EFT_SCALE")));
		imcSound.PlaySoundEvent("quest_success_2")
	else
			
		local loseSide = 1;
		if winSide == 1 then
			geClientCardBattle.PlaySound(targetHandle, "quest_success_3");
			geClientCardBattle.PlaySound(handle, "quest_failure");
			loseSide = 2;
		else
			geClientCardBattle.PlaySound(targetHandle, "quest_failure");
			geClientCardBattle.PlaySound(handle, "quest_success_3");
		end			

		if winSide > 0 then
			local pic = GET_CHILD(frame, "card_" .. winSide);
			UI_PLAYFORCE(pic, "cardbattle_win");
			local bg = GET_CHILD(frame, "card_bg_" .. winSide);
			UI_PLAYFORCE(bg, "cardbattle_win");
			local posX, posY = GET_SCREEN_XY(pic);
			movie.PlayUIEffect(frame:GetUserConfig("WIN_EFT"), posX, posY, tonumber(frame:GetUserConfig("WIN_EFT_SCALE")));
		end

		if loseSide > 0 then
			local pic = GET_CHILD(frame, "card_" .. loseSide);
			local posX, posY = GET_SCREEN_XY(pic);
			movie.PlayUIEffect(frame:GetUserConfig("LOSE_EFT"), posX, posY, tonumber(frame:GetUserConfig("LOSE_EFT_SCALE")));
		end

	end
end

function OPEN_RULLET_FRAME(frame)
	frame:ShowWindow(1);
end

function TEST_CARDBATTLE_RULLET()

	local frame = ui.GetFrame("cardbattle_rullet");
	frame:ShowWindow(1);
	frame:SetUserValue("WINSIDE", 1);
	frame:SetUserValue("RANDOMVALUE", 1);
	frame:SetUserValue("FACTOR", 1);
	
	frame:EnableHideProcess(1);
	frame:ReserveScript("OPEN_RULLET_FRAME", 2, 1);
	frame:ReserveScript("START_RULLET", 3.8, 1);

end


function RUN_CARDBATTLE_RULLET(frame, elapsedTime)

	local startSpeed = tonumber(frame:GetUserValue("START_SPEED"));
	local accel = tonumber(frame:GetUserValue("ACCEL"));
	local isEnd = false;
	local stopTime = tonumber(frame:GetUserValue("STOP_TIME"));
	if accel * elapsedTime >= startSpeed then
		isEnd = true;
		imcSound.PlaySoundEvent("sys_card_battle_roulette_turn_end");
		elapsedTime = stopTime;
	end

	local curSpeed = startSpeed - accel * elapsedTime;
	local angle = ANGLE_WHEN_TIME(startSpeed, -accel, elapsedTime);
	local lastAngle = ANGLE_WHEN_TIME(startSpeed, -accel, stopTime);
	lastAngle = lastAngle % 360;
	local destAngle = frame:GetUserIValue("DEST_ANGLE") - lastAngle;
	destAngle = destAngle * math.pow(elapsedTime / stopTime, 0.5);
	
	angle = angle + destAngle;
	angle = math.floor(angle);
	local beforeAngle = frame:GetUserIValue("BEFORE_ANGLE");
	
	local beforeAngleMod = beforeAngle % 45;
	local angleMod = angle % 45;
	local playPinEffect = 0;
	local lastAngle = frame:GetUserIValue("LAST_PIC_ANGLE");
	if angle > lastAngle + 35 then
		if curSpeed <= 100 then
			if beforeAngleMod >= 40 and angleMod <= 45 then
				playPinEffect = 1;
			end
		else
			if beforeAngleMod >= 30 and angleMod <= 45 then
				playPinEffect = 1;
			end
		end
	end

	if playPinEffect == 1 then
		frame:SetUserValue("LAST_PIC_ANGLE", angle);
		local pic_pin = frame:GetChild("pic_pin");
		local timeFactor  = curSpeed / 360 * 0.05;
		timeFactor  = CLAMP(timeFactor, 0.05, 2);
		UI_PLAYFORCE(pic_pin, "cardbattle_pin", 0, 0, timeFactor );

		AUTO_CAST(frame);
		imcSound.PlaySoundEvent("sys_card_battle_roulette_count");
	end

	frame:SetUserValue("BEFORE_ANGLE", angle);

	angle = angle % 360;
	local pic_rullet = frame:GetChild("pic_rullet");
	pic_rullet:SetAngle(angle);

	local last_Random_Section = frame:GetUserIValue("LASTRANDOM");
	local randomSection = math.floor(angle / 52);
	if randomSection ~= last_Random_Section then
		local txt_nowcondition = frame:GetChild("txt_nowcondition");
		local desc = GET_CARDBATTLE_DECISION_DESC(randomSection);
		txt_nowcondition:SetTextByKey("value", ScpArgMsg(desc));
		frame:SetUserValue("LASTRANDOM", randomSection);

		local handle = frame:GetUserIValue("OWNER_HANDLE");
		local ownerItemObj, targetItem = GetCardBattleItems(handle);
		local scoreValue1, smallerWin = GET_CARDBATTLE_SCORE(targetItem, randomSection);
		local scoreValue2 = GET_CARDBATTLE_SCORE(ownerItemObj, randomSection);
		if scoreValue1 ~= nil and scoreValue2 ~= nil then
			local score_1 = frame:GetChild("score_1");
			local score_2 = frame:GetChild("score_2");
			score_1:SetTextByKey("value", scoreValue1);
			score_2:SetTextByKey("value", scoreValue2);

			local winTeam = 0;
			if smallerWin == 0 then
				if scoreValue1 > scoreValue2 then
					winTeam = 1;
				elseif scoreValue1 < scoreValue2 then
					winTeam = 2;
				end
			else
				if scoreValue1 > scoreValue2 then
					winTeam = 2;
				elseif scoreValue1 < scoreValue2 then
					winTeam = 1;
				end
			end

			local cardbattleFrame = ui.GetFrame("cardbattle");
			local card_1 = GET_CHILD(cardbattleFrame, "card_1");
			local card_2 = GET_CHILD(cardbattleFrame, "card_2");

			if winTeam == 1 then
				score_1:SetTextByKey("color", "{#00FF00}");
				score_2:SetTextByKey("color", "{#FF0000}");
				card_1:SetColorTone("FFFFFFFF");
				card_2:SetColorTone("FF444444");
			elseif winTeam == 2 then
				score_1:SetTextByKey("color", "{#FF0000}");
				score_2:SetTextByKey("color", "{#00FF00}");
				card_2:SetColorTone("FFFFFFFF");
				card_1:SetColorTone("FF444444");
			else
				score_1:SetTextByKey("color", "{#FFFFFF}");
				score_2:SetTextByKey("color", "{#FFFFFF}");

				card_1:SetColorTone("FF444444");
				card_2:SetColorTone("FF444444");
			end

			score_1:ShowWindow(0);
			score_2:ShowWindow(0);
		end
	end

	if isEnd == true then
		local posX, posY = GET_SCREEN_XY(pic_rullet);
		movie.PlayUIEffect(frame:GetUserConfig("RULLET_END_EFT"), posX, posY, tonumber(frame:GetUserConfig("RULLET_END_EFT_SCALE")));
		local txt_nowcondition = frame:GetChild("txt_nowcondition");
		UI_PLAYFORCE(txt_nowcondition, "cardbattle_condition_text_emphasize");

		return 0;
	else
		return 1;
	end

end






