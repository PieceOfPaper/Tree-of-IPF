function BARRACKSETTING_ON_INIT(addon, frame)    
	addon:RegisterMsg("BARRACK_NAME_CHANGE_RESULT", "ON_BARRACK_NAME_CHANGE_RESULT");
end

function BARRACK_SETTING_OPEN(frame, ctrl, argStr, argNum)

	local acc = session.barrack.GetMyAccount();
	local editCtrl = GET_CHILD(frame, "barrackNameEdit", "ui::CEditControl");
	editCtrl:SetText(acc:GetFamilyName());	
	frame:Invalidate();
end

function BARRACK_SETTING_SAVE(frame, btnCtrl, argStr, argNum)
	local editCtrl = GET_CHILD(frame, "barrackNameEdit", "ui::CEditControl");
	local barrackName = editCtrl:GetText();
	if barrackName ~= nil or barrackName == "" then
		barrack.ChangeBarrackName(barrackName);
		btnCtrl:SetEnable(0);
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
	else
		if result == 0 then
			ui.SysMsg(ClMsg("TeamNameChanged"));
		end
	end

	if result ~= 0 then
		if result == -1 then
			ui.SysMsg(ClMsg("TheTeamNameAlreadyExist"));
		else
			ui.SysMsg(ClMsg("TeamNameChangeFailed"));
		end			
	end

end