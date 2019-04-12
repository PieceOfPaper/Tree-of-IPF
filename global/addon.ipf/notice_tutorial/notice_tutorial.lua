function NOTICE_TUTORIAL_ON_INIT(addon, frame)

	addon:RegisterMsg('KEYBOARD_TUTORIAL', 'ON_KEYBOARD_TUTORIAL');
	addon:RegisterMsg('DIALOG_SPACE_TUTORIAL', 'ON_DIALOG_SPACE_TUTORIAL');

	addon:RegisterMsg('L_KEY_TUTORIAL', 'ON_L_KEY_TUTORIAL');
	addon:RegisterMsg('RETURN_KEY_TUTORIAL', 'ON_RETURN_KEY_TUTORIAL');
	addon:RegisterMsg('EXPCARD_USE_TUTORIAL', 'ON_EXPCARD_USE_TUTORIAL');
	addon:RegisterMsg('EXPCARD_USE_TUTORIAL_END', 'ON_EXPCARD_USE_TUTORIAL_END');
end


function INIT_KEYBOARD_TUTORIAL(frame)
	
	END_KEYBOARD_TUTORIAL(frame);
	frame:GetChild('comment'):ShowWindow(0);
	frame:GetChild('SpaceKey'):ShowWindow(0);
	frame:GetChild('MoveKey'):ShowWindow(0);
	frame:GetChild('MoveKey2'):ShowWindow(0);
	frame:GetChild('AtkKey'):ShowWindow(0);
	frame:GetChild('JumpKey'):ShowWindow(0);
	frame:GetChild('LKey'):ShowWindow(0);
	frame:GetChild('BackSpace'):ShowWindow(0);
	frame:GetChild('ExpCard'):ShowWindow(0);
end

-- 경험치 카드
function ON_EXPCARD_USE_TUTORIAL(frame, msg, argStr, argNum)
	INIT_KEYBOARD_TUTORIAL(frame);
	local comment = frame:GetChild('comment');
	tolua.cast(comment, "ui::CRichText");
	comment:SetText( ScpArgMsg("TUTO_EXPCARD_USE") );
	comment:ShowWindow(1);
	local groupBox = frame:GetChild('ExpCard');
	groupBox:ShowWindow(1);

	local endTime = imcTime.GetAppTime() + 1;
	frame:SetUserValue("EXPCARD_END", endTime);

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_EXPCARD_USE_TUTORIAL");
	timer:Start(0.01);

	frame:SetOffset(0, 200);
	frame:ShowWindow(1);
end

function ON_EXPCARD_USE_TUTORIAL_END(frame, msg, argStr, argNum)

    local groupBox = frame:GetChild('ExpCard');

	local time = imcTime.GetAppTime() + 0.8;
	frame:SetUserValue("EXPCARD_END", time);	-- 그룹박스 닫히는시간 셋팅

	-- 그룹박스 닫기
		groupBox:ShowWindow(0);

	-- 그룹박스 꺼져있으면 frame 종료
	
		END_KEYBOARD_TUTORIAL(frame);

end

function UPDATE_EXPCARD_USE_TUTORIAL(frame)
	local groupBox = frame:GetChild('ExpCard');
	-- 백스페이스 키
--	if keyboard.IsKeyDown("EXPCARD_END") == 1 then
--		local key = groupBox:GetChild('expcard');
--		UI_PLAYFORCE(key, "gmsemf");
--
--		local time = imcTime.GetAppTime() + 0.8;
--		frame:SetUserValue("EXPCARD_END", time);	-- 그룹박스 닫히는시간 셋팅
--	end

	-- 그룹박스 닫기
	if tonumber(frame:GetUserValue("EXPCARD_END")) < imcTime.GetAppTime() then
		groupBox:ShowWindow(0);
	end

	-- 그룹박스 꺼져있으면 frame 종료
	if groupBox:IsVisible() == 0 then
		END_KEYBOARD_TUTORIAL(frame);
	end
end


-- 되돌아가기
function ON_RETURN_KEY_TUTORIAL(frame, msg, argStr, argNum)
	INIT_KEYBOARD_TUTORIAL(frame);

	local comment = frame:GetChild('comment');
	tolua.cast(comment, "ui::CRichText");
	comment:SetText( ScpArgMsg("TUTO_RETURN_INFO") );
	comment:ShowWindow(1);
	local groupBox = frame:GetChild('BackSpace');
	groupBox:ShowWindow(1);

	local endTime = imcTime.GetAppTime() + 120;
	frame:SetUserValue("BACKSPACE_END", endTime);

--	groupBox:GetChild("LText"):SetText(ScpArgMsg("Auto_{@st41}Quest_info{/}"));
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_DIALOG_RETURN_TUTORIAL");
	timer:Start(0.01);


	
	frame:SetOffset(0, 200);
	frame:ShowWindow(1);
end

function UPDATE_DIALOG_RETURN_TUTORIAL(frame)

	local groupBox = frame:GetChild('BackSpace');

	-- 백스페이스 키
	if keyboard.IsKeyDown("BACKSPACE") == 1 then
		local key = groupBox:GetChild('backspace');
		UI_PLAYFORCE(key, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("BACKSPACE_END", time);	-- 그룹박스 닫히는시간 셋팅
	end

	-- 그룹박스 닫기
	if tonumber(frame:GetUserValue("BACKSPACE_END")) < imcTime.GetAppTime() then
		groupBox:ShowWindow(0);
	end

	-- 그룹박스 꺼져있으면 frame 종료
	if groupBox:IsVisible() == 0 then
		END_KEYBOARD_TUTORIAL(frame);
	end
end


-- Lkey 누르기 튜토리얼
function ON_L_KEY_TUTORIAL(frame, msg, argStr, argNum)
	INIT_KEYBOARD_TUTORIAL(frame);

	local comment = frame:GetChild('comment');
	tolua.cast(comment, "ui::CRichText");
	comment:SetText( ScpArgMsg("TUTO_QUEST_INFO") );
	comment:ShowWindow(1);
	local groupBox = frame:GetChild('LKey');
	groupBox:ShowWindow(1);

	groupBox:GetChild("LText"):SetText(ScpArgMsg("Auto_{@st41}Quest_info{/}"));
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_DIALOG_LKEY_TUTORIAL");
	timer:Start(0.01);

	local endTime = imcTime.GetAppTime() + 3600;
	frame:SetUserValue("LKEY_END", endTime);
	
	frame:SetOffset(0, 200);
	frame:ShowWindow(1);
end

function UPDATE_DIALOG_LKEY_TUTORIAL(frame)

	local groupBox = frame:GetChild('LKey');

	-- 스페이스 키
	if keyboard.IsKeyDown("L") == 1 then
		local key = groupBox:GetChild('l_key');
		UI_PLAYFORCE(key, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("LKEY_END", time);	-- 그룹박스 닫히는시간 셋팅
	end

	-- 그룹박스 닫기
	if tonumber(frame:GetUserValue("LKEY_END")) < imcTime.GetAppTime() then
		groupBox:ShowWindow(0);
	end

	-- 그룹박스 꺼져있으면 frame 종료
	if groupBox:IsVisible() == 0 then
		END_KEYBOARD_TUTORIAL(frame);
	end
end

-- npc대화 space 튜토리얼
function ON_DIALOG_SPACE_TUTORIAL(frame, msg, argStr, argNum)

	INIT_KEYBOARD_TUTORIAL(frame);
	local comment = frame:GetChild('comment');
	comment:SetText( ScpArgMsg("HelloTitas") );
	comment:ShowWindow(1);
	local groupBox = frame:GetChild('SpaceKey');
	groupBox:ShowWindow(1);

	groupBox:GetChild("SpaceText"):SetText(ScpArgMsg("Auto_{@st41}DaeHwa_SinCheongKi{/}"));
	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	

	local endTime = imcTime.GetAppTime() + 3600;
	frame:SetUserValue("SPACE_END", endTime);
	
	frame:SetOffset(0, 200);
	frame:ShowWindow(1);

	timer:SetUpdateScript("UPDATE_DIALOG_SPACE_TUTORIAL");
	timer:Start(0.01);
end

function UPDATE_DIALOG_SPACE_TUTORIAL(frame)

	local groupBox = frame:GetChild('SpaceKey');

	-- 스페이스 키
	if keyboard.IsKeyDown("SPACE") == 1 then
		local space = groupBox:GetChild('space');
		UI_PLAYFORCE(space, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("SPACE_END", time);	-- 그룹박스 닫히는시간 셋팅
	end
	
	-- 그룹박스 닫기
	if tonumber(frame:GetUserValue("SPACE_END")) < imcTime.GetAppTime() then
		groupBox:ShowWindow(0);
	end

	-- 그룹박스 꺼져있으면 frame 종료
	if groupBox:IsVisible() == 0 then
		END_KEYBOARD_TUTORIAL(frame);
	end
end

-- 키보드 조작 튜토리얼 (방향키, 일반공격, 점프)
function ON_KEYBOARD_TUTORIAL(frame, msg, argStr, argNum)

	INIT_KEYBOARD_TUTORIAL(frame);
	session.SaveQuickSlot();
	local comment = frame:GetChild('comment');
	comment:SetText(ScpArgMsg('Auto_{@st64}Keimui_KiBon_JoJageul_TtaLaHae_BopNiDa!'));
	comment:ShowWindow(1);

	local moveGroupBox = GET_CHILD(frame, 'MoveKey', 'ui::CGroupBox');
	local atkGroupBox = GET_CHILD(frame, 'AtkKey', 'ui::CGroupBox');
	local jumpGroupBox = GET_CHILD(frame, 'JumpKey', 'ui::CGroupBox');

	local MoveText = GET_CHILD(moveGroupBox, 'MoveText', "ui::CRichText");
	MoveText:SetText(ScpArgMsg("Auto_{@st41}BangHyang_iDongKi{/}"));

	local AtkText = GET_CHILD(atkGroupBox, 'AtkText', "ui::CRichText");
	AtkText:SetText(ScpArgMsg("Auto_{@st41}KongKyeogKi{/}"));
	
	local JumpText = GET_CHILD(jumpGroupBox, 'JumpText', "ui::CRichText");
	JumpText:SetText(ScpArgMsg("Auto_{@st41}JeomPeuKi{/}"));

	moveGroupBox:ShowWindow(1);
	atkGroupBox:ShowWindow(1);
	jumpGroupBox:ShowWindow(1);
	
	-- 대각선이동 튜토리얼은 일단 꺼두기
	local moveGroupBox2 = frame:GetChild('MoveKey2');
	moveGroupBox2:ShowWindow(0);

	frame:SetOffset(0, 200);
	frame:ShowWindow(1);

	local endTime = imcTime.GetAppTime() + 3600;
	frame:SetUserValue("JUMP_END", endTime);
	frame:SetUserValue("ATK_END", endTime);
	frame:SetUserValue("MOVE_END", endTime);
	frame:SetUserValue("MOVE2_END", endTime);
	frame:SetUserValue("MOVE2_GROUPBOX_USING", 'on');
	frame:SetUserValue("MOVE_GROUPBOX_USING", 'on');

	frame:SetUserValue("move1", 'on');
	frame:SetUserValue("move2", 'on');
	frame:SetUserValue("move3", 'on');
	frame:SetUserValue("move4", 'on');

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_KEYBOARD_TUTORIAL");
	timer:Start(0.01);
end


function UPDATE_KEYBOARD_TUTORIAL(frame)	

	local moveGroupBox = frame:GetChild('MoveKey');
	local moveGroupBox2 = frame:GetChild('MoveKey2');
	local atkGroupBox = frame:GetChild('AtkKey');
	local jumpGroupBox = frame:GetChild('JumpKey');
	
	if world.GetLayer() ~= 0 then
        END_KEYBOARD_TUTORIAL(frame);
    end
	-- 방향키
	if keyboard.IsKeyDown("LEFT") == 1 then
		frame:SetUserValue("move1", 'off')
		local img = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_l');
		img:SetBlink(0, 1, '0xFF000000');
	end
	if keyboard.IsKeyDown("RIGHT") == 1 then
		frame:SetUserValue("move2", 'off')
		local img = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_r');
		img:SetBlink(0, 1, '0xFF000000');
	end
	if keyboard.IsKeyDown("UP") == 1 then
		frame:SetUserValue("move3", 'off')
		local img = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_u');
		img:SetBlink(0, 1, '0xFF000000');
	end
	if keyboard.IsKeyDown("DOWN") == 1 then
		frame:SetUserValue("move4", 'off')
		local img = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_d');
		img:SetBlink(0, 1, '0xFF000000');
	end

	local moveKeyDown = 0;
	for i = 1, 4 do
		if frame:GetUserValue("move"..i) == 'off' then
			moveKeyDown = moveKeyDown + 1;
		end
	end

	if moveKeyDown == 4 and frame:GetUserValue("MOVE_GROUPBOX_USING") == 'on' then
		local move1 = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_l');
		UI_PLAYFORCE(move1, "gmsemf");
		local move2 = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_r');
		UI_PLAYFORCE(move2, "gmsemf");
		local move3 = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_u');
		UI_PLAYFORCE(move3, "gmsemf");
		local move4 = GET_CHILD_RECURSIVELY(moveGroupBox, 'move_d');
		UI_PLAYFORCE(move4, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("MOVE_END", time);	-- 그룹박스 닫히는시간 셋팅
		frame:SetUserValue("MOVE_GROUPBOX_USING", 'off');
	end


	-- 대각선 이동키
	if moveGroupBox2:IsVisible() == 1 and keyboard.IsKeyPressed("RIGHT") == 1 and keyboard.IsKeyPressed("UP") == 1 and frame:GetUserValue("MOVE2_GROUPBOX_USING") == 'on' then

		local img1 = moveGroupBox2:GetChild('move_uu');
		local img2 = moveGroupBox2:GetChild('move_rr');

		UI_PLAYFORCE(img1, "gmsemf");
		UI_PLAYFORCE(img2, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("MOVE2_END", time);	-- 그룹박스 닫히는시간 셋팅
		frame:SetUserValue("MOVE2_GROUPBOX_USING", 'off');
	end


	-- 공격키
	if keyboard.IsKeyDown("Z") == 1 then
		local atk = atkGroupBox:GetChild('atk');
		UI_PLAYFORCE(atk, "gmsemf");
		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("ATK_END", time);	-- 그룹박스 닫히는시간 셋팅
	end

	-- 점프키
	if keyboard.IsKeyDown("X") == 1 then
		local jump = jumpGroupBox:GetChild('jump');
		UI_PLAYFORCE(jump, "gmsemf");

		local time = imcTime.GetAppTime() + 0.8;
		frame:SetUserValue("JUMP_END", time);	-- 그룹박스 닫히는시간 셋팅
	end


	-- 그룹박스 닫기
	if tonumber(frame:GetUserValue("MOVE_END")) < imcTime.GetAppTime() then
		moveGroupBox:ShowWindow(0);

		-- 기본이동관련 그룹박스가 꺼졌으면 대각선이동 그룹박스 켜기
		moveGroupBox2:GetChild("MoveText2"):SetText(ScpArgMsg("Auto_{@st41}DaeKagSeon_iDongKi_{/}"));
		moveGroupBox2:GetChild("MoveText3"):SetText("{@st41}+{/}");
		moveGroupBox2:GetChild("MoveText4"):SetText(ScpArgMsg("Auto_{@st41}DongSi_ipLyeog!{/}"));
		moveGroupBox2:ShowWindow(1);
	end
	if tonumber(frame:GetUserValue("MOVE2_END")) < imcTime.GetAppTime() then
		moveGroupBox2:ShowWindow(0);
	end
	if tonumber(frame:GetUserValue("JUMP_END")) < imcTime.GetAppTime() then
		jumpGroupBox:ShowWindow(0);
	end
	if tonumber(frame:GetUserValue("ATK_END")) < imcTime.GetAppTime() then
		atkGroupBox:ShowWindow(0);
	end
    



	-- 그룹박스 전부 꺼져있으면 frame 종료
	if atkGroupBox:IsVisible() == 0 and jumpGroupBox:IsVisible() == 0 and moveGroupBox:IsVisible() == 0 and moveGroupBox2:IsVisible() == 0 then
		END_KEYBOARD_TUTORIAL(frame);
	end
end

function END_KEYBOARD_TUTORIAL(frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();

	frame:ShowWindow(0);
end


