function BARRACKNAMECHANGE_ON_INIT(addon, frame)

end

function BARRACK_CHANCLE_CHANGE_NAME(frame, ctrl)
	frame:ShowWindow(0);
	if frame:GetName() == "barrackthema" then
		barrack.ToMyBarrack();
	end
end

function BARRACK_CHANGE_NAME_USE_TP(frame, ctrl)
	frame:ShowWindow(0);
	
	local changeName = frame:GetUserValue("changeName")
	BARRACk_SETTING_CHECK_TP(changeName);
end

function BARRACK_CHECK_USER_MIND_BEFOR_YES(inputframe, changedName)
	local acc = session.barrack.GetMyAccount();
	local charName = acc:GetFamilyName();
	
	if changedName == charName then
		ui.SysMsg(ClMsg("SameName"));

		return;
	end

	local frame = ui.GetFrame("barracknamechange");
	frame:ShowWindow(1);
	frame:SetUserValue("changeName", changedName);

	frame:SetUserValue("inputframe", inputframe:GetName());
	local prop = frame:GetChild("prop");
	prop:SetTextByKey("value", ClMsg("Family Name"))

	local myName = frame:GetChild("myName");
	myName:SetTextByKey("value", charName)

	local ChangeName = frame:GetChild("ChangeName");
	ChangeName:SetTextByKey("value", changedName)

	local price = tostring(CHANGE_FAMILY_NAME_TP);
	local NeedTP = frame:GetChild("NeedTP");
	NeedTP:SetTextByKey("value", price)
end

function BARRACKNAMECHANGE_CLOSE(frame, ctrl, argStr, argNum)
	frame:ShowWindow(0);
end