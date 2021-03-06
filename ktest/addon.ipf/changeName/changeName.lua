function CHANGENAME_ON_INIT(addon, frame)

end

function CHANCLE_CHANGE_NAME(frame, ctrl)
	frame:ShowWindow(0);
end

function CHANGE_NAME_USE_TP(frame, ctrl)
	frame:ShowWindow(0);
	local inputframeName = frame:GetUserValue("inputframe");
	local inputframe = ui.GetFrame(inputframeName)
	inputframe:ShowWindow(0);

	local nameType = frame:GetUserValue("nameType")
	local changeName = frame:GetUserValue("changeName")
	local charGuid = frame:GetUserValue("charGuid")

	if nameType == "pcName" then
    	CHANGE_PC_NAME_SETTING_CHECK_TP(changeName);
	elseif nameType == "petName" then
		CHANGE_PET_NAME_SETTING_CHECK_TP(charGuid, changeName);
	end
end

local function _GET_MY_PET_COUPON()
	local petCouponCnt, petCouponList = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = 'StringArg', Value ='CompanionReNameCoupon'}}, true);
	if petCouponCnt < 1 then
		return nil;
	end
	return petCouponList[1];
end

function OPEN_CHECK_USER_MIND_BEFOR_YES(inputframe, nameType, changedName, charName, charGuid)
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
	frame:SetUserValue("charGuid", charGuid);

	local DEFAULT_CONSUME_IMG = frame:GetUserConfig('DEFAULT_CONSUME_IMG');
	local picture_1 = GET_CHILD_RECURSIVELY(frame, 'picture_1');
	picture_1:SetImage(DEFAULT_CONSUME_IMG);

	local prop = frame:GetChild("prop");
	local NeedTP = frame:GetChild("NeedTP");
	if nameType == "pcName" then
		prop:SetTextByKey("value", ClMsg("Change Name"))
		NeedTP:SetTextByKey("value", tostring(CHANGE_CAHR_NAME_TP))
	elseif nameType == "petName" then
		prop:SetTextByKey("value", ClMsg("ChangePetName"));
		local petCouponInvItem = _GET_MY_PET_COUPON();		
		if petCouponInvItem ~= nil then			
			local petCouponObj = GetIES(petCouponInvItem:GetObject());			
			picture_1:SetImage(petCouponObj.Icon);
			NeedTP:SetTextByKey("value", 1);
		else
			NeedTP:SetTextByKey("value", tostring(CHANGE_PET_NAME_TP));
		end
	else
		prop:SetTextByKey("value", "")
        NeedTP:SetTextByKey("value", "")
	end

	local myNameText = frame:GetChild("myName");
	myNameText:SetTextByKey("value", charName)

	local ChangeNameText = frame:GetChild("ChangeName");
	ChangeNameText:SetTextByKey("value", changedName)
end

function CHANGE_PC_NAME_SETTING_CHECK_TP(changedName)
	local accountObj = GetMyAccountObj();
	if 0 > GET_CASH_TOTAL_POINT_C() - CHANGE_CAHR_NAME_TP then
		ui.MsgBox(ClMsg("NotEnoughMedal"));
		return;
	end

	if ui.IsValidCharacterName(changedName) == true then
		local msg = string.format("/name %s", changedName);
		ui.Chat(msg);
	end
end

function CHANGE_PET_NAME_SETTING_CHECK_TP(petGuid, changedName)
	local petCouponInvItem = _GET_MY_PET_COUPON();		
	if petCouponInvItem == nil then
		local accountObj = GetMyAccountObj();
		if 0 > GET_CASH_TOTAL_POINT_C() - CHANGE_PET_NAME_TP then
			ui.MsgBox(ClMsg("NotEnoughMedal"));
			return;
		end
	end

	if ui.IsValidCharacterName(changedName) == true then
		pc.RequestChangePetName(petGuid, changedName);
	end
end