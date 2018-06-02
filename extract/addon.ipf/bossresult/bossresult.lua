function BOSSRESULT_ON_INIT(addon, frame)
	
	addon:RegisterMsg("BOSS_CLEAR", "ON_BOSS_CLEAR");

end

--[[
Step1 데미지
	2 테크닉
	3 회피
]]

function SET_BOSS_TXT(frame, ctrlName, propValue)

	local ctrl = GET_CHILD(frame, ctrlName, "ui::CRichText");
	local txtValue = string.format("%d", propValue);
	ctrl:SetText(txtValue);

end

function ON_BOSS_CLEAR(frame, msg, argStr, argNum)

	local sObj = session.GetSessionObjectByName("ssn_mission");
	if sObj == nil then
		return;
	end

	frame:ShowWindow(1);

	local gBox = frame:GetChild("statusGbox");
	local obj = GetIES(sObj:GetIESObject());

	SET_BOSS_TXT(gBox, "v_damage", obj.Step1 * -1);
	SET_BOSS_TXT(gBox, "v_technic", obj.Step2);
	SET_BOSS_TXT(gBox, "v_flee", obj.Step3);

	local time = math.floor(obj.Step24);
	local timeTxt = GET_TIME_TXT(time);
	local timectrl = GET_CHILD(gBox, "v_time", "ui::CRichText");
	timectrl:SetText(timeTxt);

	SET_BOSS_TXT(gBox, "v_total", obj.Step23);

	ReserveScript("REGISTER_BOSS_RANK()", 3.0);

end

function REGISTER_BOSS_RANK()
	
	local sObj = session.GetSessionObjectByName("ssn_mission");
	if sObj == nil then
		return;
	end

	local obj = GetIES(sObj:GetIESObject());
	local monName = GetClassByType("Monster", obj.Step22).ClassName;
	local charName = GETMYPCNAME();
	debug.TestRankRegister(monName, charName, obj.Step23);

	if world.GetWorldName() == "boss_zone" then
		TEST_BOSS_LIST();
	end

end




