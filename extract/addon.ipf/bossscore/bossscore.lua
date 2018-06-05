

function BOSSSCORE_ON_INIT(addon, frame)

	

end

function BOSSSCORE_CREATE(addon, frame) 	


end

function BOSS_SCORE_OPEN(frame)
	frame:SetValue(0);
	
	ui.CloseFrame('questinfoset_2');
	ui.ShowWindowByPIPType(frame:GetName(), ui.PT_RIGHT, 1);

	BOSS_TIMER_SET(frame);
end

function BOSS_SCORE_CLOSE(frame)
	ui.OpenFrame('questinfoset_2');	
end

function BOSS_TIMER_SET(frame)

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_BOSS_SCORE_TIME");
	timer:Start(0.2);
	UPDATE_BOSS_SCORE_TIME(frame);

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
