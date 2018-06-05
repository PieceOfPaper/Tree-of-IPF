function CHANGEJOBBUTTON_ON_INIT(addon, frame)

	addon:RegisterMsg('GAME_START', 'ON_CHANGE_JOB_BUTTON');
	addon:RegisterMsg('JOB_CHANGE', 'ON_CHANGE_JOB_BUTTON');
	addon:RegisterMsg('JOB_EXP_ADD', 'ON_CHANGE_JOB_BUTTON');
	addon:RegisterMsg('QUEST_UPDATE', 'ON_CHANGE_JOB_BUTTON');
	addon:RegisterMsg('START_JOB_CHANGE', 'ON_CHANGE_JOB_BUTTON');

end

function ON_CHANGE_JOB_BUTTON(frame, msg, name, range)

	--랭크제한이 걸려있으면 해당 랭크일 떄, 전진 버튼 안나옴
	if session.GetPcTotalJobGrade() >=  JOB_CHANGE_MAX_RANK then
		frame:ShowWindow(0);
		return;
	end

	etcObj = GetMyEtcObject();
	
	local canChangeJob = session.CanChangeJob();

	if canChangeJob == true and etcObj.JobChanging ~= 1 then
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end

	local jobuiopenbutton = GET_CHILD(frame, "open_changejobui", "ui::CButton");
	jobuiopenbutton:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_CHANGEJOBBUI')

	frame:Invalidate();

end

function CJ_CLICK_CHANGEJOBBUI(frame, slot, argStr, argNum)

	ui.OpenFrame('changejob')

end
