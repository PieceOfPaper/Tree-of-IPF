function CHANGENAME_ITEM_ON_INIT(addon, frame)

end

function CHANGENAME_ITEM_NAME(frame, ctrl)
	frame:ShowWindow(0);
end

function OPEN_CHECK_USER_MIND_BEFOR_YES_BY_ITEM(inputframe, changedName, itemIES, itemType)
	local charName = nil;
	local title = nil;
	if itemType == "PcName" then
		charName = GETMYPCNAME(); 
		title = ClMsg("Change Name")
	elseif itemType == "TeamName" then
		charName = GETMYFAMILYNAME();
		title = ClMsg("Change FamilyName")
	elseif itemType == "GuildName" then
		local guild = session.party.GetPartyInfo(PARTY_GUILD);
		if guild == nil then
			inputframe:ShowWindow(0);
			return;
		end
		charName = guild.info.name;
		title = ClMsg("Change GuildName")
	elseif itemType == "Companionhire" then
		title = ClMsg("PetName");
	else
		return;
	end
		
	if changedName == charName then
		ui.SysMsg(ClMsg("SameName"));
		inputframe:ShowWindow(0);
		return;
	end
	if itemIES == nil or itemIES == 0 then
		return;	
	end

	local frame = ui.GetFrame("changeName_item");
	local changename_gb = GET_CHILD(frame, "changename_gb");
	local usename_gb = GET_CHILD(frame, "usename_gb");
	if itemType == "Companionhire" then
		local usename = GET_CHILD_RECURSIVELY(frame, "usename");
		usename:SetTextByKey("value", changedName)

		changename_gb:ShowWindow(0);
		usename_gb:ShowWindow(1);
	else	
		local myName = GET_CHILD_RECURSIVELY(frame, "myName");
		myName:SetTextByKey("value", charName)
	
		local ChangeName = GET_CHILD_RECURSIVELY(frame, "ChangeName");
		ChangeName:SetTextByKey("value", changedName)

		changename_gb:ShowWindow(1);
		usename_gb:ShowWindow(0);	
	end
	
	local prop = GET_CHILD(frame, "prop");
	prop:SetTextByKey("value", title)

	frame:ShowWindow(1);
	frame:SetUserValue("changeName", changedName);
	frame:SetUserValue("itemIES", itemIES);
	frame:SetUserValue("itemType", itemType);	
	frame:SetUserValue("inputframe", inputframe:GetName());
end

function CHANGE_NAME_BY_ITEM(frame, ctrl, itemIES)
	frame:ShowWindow(0);
	local inputframeName = frame:GetUserValue("inputframe");
	
	local itemIES = frame:GetUserValue("itemIES");
	local itemType = frame:GetUserValue("itemType")
	local changeName = frame:GetUserValue("changeName")
	local inputframe = ui.GetFrame(inputframeName)
	inputframe:ShowWindow(0);

	if ui.IsValidCharacterName(changeName) == true then
		pc.RequestChangeName(itemIES, changeName, itemType)
	end
end

function CHANGE_NAME_BY_ITEM_CLOSE(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	frame:ShowWindow(0);
end