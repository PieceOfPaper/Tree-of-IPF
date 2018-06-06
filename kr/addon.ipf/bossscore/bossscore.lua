

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

