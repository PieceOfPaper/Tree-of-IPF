function MINIMIZED_PERSONAL_HOUSING_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('ENTER_PERSONAL_HOUSE', 'MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE');
	addon:RegisterMsg('SET_PERSONAL_HOUSE_NAME', 'SCR_SET_PERSONAL_HOUSE_NAME');
	
	addon:RegisterMsg('PERSONAL_HOUSING_IS_REALLY_OUT', 'SCR_PERSONAL_HOUSING_IS_REALLY_OUT');
end

function MINIMIZED_PERSONAL_HOUSING_OPEN_EDIT_MODE(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);
	
	local btn_request_leave = GET_CHILD_RECURSIVELY(frame, "btn_request_leave");
	
	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		btn_request_leave:ShowWindow(0);
		frame:ShowWindow(0);
		return
	end

	local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
	if housingPlaceType ~= "Personal" then
		btn_request_leave:ShowWindow(0);
		frame:ShowWindow(0);
		return;
	end
	
	frame:ShowWindow(1);
	btn_request_leave:ShowWindow(1);
end

function SCR_SET_PERSONAL_HOUSE_NAME(frame, msg, argStr, argNum)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);

	local housingPlaceClass = GetClass("Housing_Place", mapCls.ClassName);
	if housingPlaceClass == nil then
		return
	end

	local housingPlaceType = TryGetProp(housingPlaceClass, "Type");
	if housingPlaceType ~= "Personal" then
		return;
	end
	
	local house_name = GET_CHILD_RECURSIVELY(frame, "house_name");
	
	local aidString = argStr;
	local myAID = session.loginInfo.GetAID();
	if aidString == myAID then
		local myHandle = session.GetMyHandle();
		house_name:SetTextByKey("value", info.GetFamilyName(myHandle));
	else
		local partyMemberList = session.party.GetPartyMemberList(PARTY_NORMAL);
		local memberCount = partyMemberList:Count();
		for i = 0, memberCount - 1 do
			local memberInfo = partyMemberList:Element(i);
			if memberInfo ~= nil then
				if memberInfo:GetAID() == aidString then
					house_name:SetTextByKey("value", memberInfo:GetName());
					break;
				end
			end
		end
	end
end

function SCR_PERSONAL_HOUSING_IS_REALLY_OUT(frame, msg, argstr, argnum)
    local clmsg = ScpArgMsg("ANSWER_OUT_PH_1");
	local yesscp = string.format("ON_PERSONAL_HOUSING_IS_REALLY_OUT(%d)", argnum);
	ui.MsgBox(clmsg, yesscp, 'None');
end

function ON_PERSONAL_HOUSING_IS_REALLY_OUT()
	local frame = ui.GetFrame("minimized_personal_housing");
	local btn_request_leave = GET_CHILD_RECURSIVELY(frame, "btn_request_leave");
	btn_request_leave:ShowWindow(0);
	
	housing.RequestLeavePersonalHouse();
end