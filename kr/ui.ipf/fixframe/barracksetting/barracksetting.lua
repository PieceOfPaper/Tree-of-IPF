function BARRACKSETTING_ON_INIT(addon, frame)    
	addon:RegisterMsg("BARRACK_NAME_CHANGE_RESULT", "ON_BARRACK_NAME_CHANGE_RESULT");
end

function BARRACK_SETTING_OPEN(frame, ctrl, argStr, argNum)

	local acc = session.barrack.GetMyAccount();
	local editCtrl = GET_CHILD(frame, "barrackNameEdit", "ui::CEditControl");
	editCtrl:SetText(acc:GetFamilyName());	
	frame:Invalidate();
end

function BARRACK_SETTING_CANCLE(frame, ctrl, argStr, argNum)
	frame:ShowWindow(0);
end

function BARRACK_SETTING_SAVE(inputframe, ctrl)
	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end

	local changedName = GET_INPUT_STRING_TXT(inputframe);
	BARRACK_CHECK_USER_MIND_BEFOR_YES(inputframe, changedName);
end

function BARRACk_SETTING_CHECK_TP(barrackName)
	if 0 > GET_CASH_TOTAL_POINT_C() - tonumber(CHANGE_FAMILY_NAME_TP) then
		ui.MsgBox(ClMsg("NotEnoughMedal"));
		return;
	end
	if barrackName ~= nil or barrackName == "" then
		barrack.ChangeBarrackName(barrackName);
	end	
end

function ON_BARRACK_NAME_CHANGE_RESULT(frame, addon, str, result)
	local save = frame:GetChild("save");
	save:SetEnable(1);
	frame:ShowWindow(0);

	if 1 == ui.IsFrameVisible("inputteamname") then
		local inputTeamNameFrame = ui.GetFrame("inputteamname");
		local bg = inputTeamNameFrame:GetChild("bg");
		local btn = bg:GetChild("btn");
		btn:SetEnable(1);
		return;
	end
		if result == 0 then
			ui.SysMsg(ClMsg("TeamNameChanged"));
		return;
	end

		if result == -1 then
			ui.SysMsg(ClMsg("TheTeamNameAlreadyExist"));
	elseif result == -1 then
		ui.SysMsg(ClMsg("HadFobbidenWord"));
		else
			ui.SysMsg(ClMsg("TeamNameChangeFailed"));
		end			
	end
