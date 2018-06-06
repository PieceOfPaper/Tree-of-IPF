function CHANGENAME_ON_INIT(addon, frame)

end

function CHANCLE_CHANGE_NAME(frame, ctrl)
	frame:ShowWindow(0);
end

function CHANGE_NAME_USE_TP(frame, ctrl)
	local itemIES = frame:GetUserValue("itemIES");
	frame:ShowWindow(0);
	local inputframeName = frame:GetUserValue("inputframe");
	local inputframe = ui.GetFrame(inputframeName)
	inputframe:ShowWindow(0);

	local nameType = frame:GetUserValue("nameType")
	local changeName = frame:GetUserValue("changeName")
	CHANGE_NAME_SETTING_CHECK_TP(nameType, changeName);
end

function OPEN_CHECK_USER_MIND_BEFOR_YES(inputframe, nameType, changedName, charName)
	if charName == nil then
        return;
    end
		
	if changedName == charName then
		ui.SysMsg(ClMsg("SameName"));
		inputframe:ShowWindow(0);
		return;
	end

	local frame = ui.GetFrame("changeName");
	frame:ShowWindow(1);
	frame:SetUserValue("changeName", changedName);
	frame:SetUserValue("nameType", nameType);
	frame:SetUserValue("inputframe", inputframe:GetName());
	local prop = frame:GetChild("prop");
	if nameType == "pcName" then
		prop:SetTextByKey("value", ClMsg("Change Name"))
	elseif nameType == "petName" then
		prop:SetTextByKey("value", ClMsg("ChangePetName"))
	else
		prop:SetTextByKey("value", "")
	end

	local myName = frame:GetChild("myName");
	myName:SetTextByKey("value", charName)

	local ChangeName = frame:GetChild("ChangeName");
	ChangeName:SetTextByKey("value", changedName)

	local price = tostring(CHANGE_PET_NAME_TP);
	local NeedTP = frame:GetChild("NeedTP");
	NeedTP:SetTextByKey("value", price)
end

function CHANGE_NAME_SETTING_CHECK_TP(nameType, changedName)
	local accountObj = GetMyAccountObj();
	if 0 > GET_CASH_TOTAL_POINT_C() - CHANGE_CAHR_NAME_TP then
		ui.MsgBox(ClMsg("NotEnoughMedal"));
		return;
	end

	if nameType == "pcName" then
		if ui.IsValidCharacterName(changedName) == true then
			local msg = string.format("/name %s", changedName);
			ui.Chat(msg);
		end
	elseif nameType == "petName" then
		if ui.IsValidCharacterName(changedName) == true then
			pc.RequestChangePetName(changedName);
		end
	end
end
