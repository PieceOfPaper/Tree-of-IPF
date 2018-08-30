function BARRACK_PETLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("BARRACK_CREATE_PET_BTN", "ON_BARRACK_CREATE_PET_BTN");
	addon:RegisterMsg("DELETE_PET", "ON_DELETE_PET");
	

end

function ON_DELETE_PET(frame, msg, guid)

	local companionframe = ui.GetFrame("selectcompanioninfo");
	local petGuid = companionframe:GetUserValue("PET_GUID");
	if petGuid == guid then
		companionframe:ShowWindow(0);
	end
		
	local myaccount = session.barrack.GetMyAccount();
	local barrackName = ui.GetFrame("barrack_charlist");
	local pccount = barrackName:GetChild("pccount");
	local buySlot = session.loginInfo.GetBuySlotCount();
	local myCharCont = myaccount:GetPCCount() + myaccount:GetPetCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	pccount:SetTextByKey("maxpc", tostring(barrackCls.BaseSlot + buySlot));

	ON_BARRACK_CREATE_PET_BTN(frame);
end

function ON_BARRACK_CREATE_PET_BTN(frame)

	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();	
	local width = 300;
	local height = 85;
	local acc = session.barrack.GetMyAccount();
	local petVec = acc:GetPetVec();
	if petVec:size() == 0 then
		frame:ShowWindow(0);
		return;
	end

	frame:ShowWindow(1);
	for i = 0 , petVec:size() -  1 do
		local pet = petVec:at(i);
		local pcID = tonumber(pet:GetPCID())
		local actor = barrack.GetPet(pet:GetStrGuid());
		if actor ~= nil and pcID == 0 then
			local petCtrl = bg:CreateOrGetControlSet('barrack_pet', 'attached_pet'..pet:GetStrGuid(), 0, 0);
			UPDATE_PET_BTN(petCtrl, pet, false);
			petCtrl:SetOverSound("button_over")
			petCtrl:SetClickSound("button_click_2")
		end
	end

	GBOX_AUTO_ALIGN(bg, 30, 10, 10, true, false);
	
end

function UPDATE_PET_LIST(barrackMode)
	local frame = ui.GetFrame("barrack_petlist");
	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();	

	local acc = session.barrack.GetMyAccount();
	if barrackMode == "Visit" then
		acc = session.barrack.GetCurrentAccount();
	end
	local petVec = acc:GetPetVec();

	if petVec:size() == 0 then
		frame:ShowWindow(0);
		return;
	end

	frame:ShowWindow(1);
	for i = 0 , petVec:size() -  1 do
		local pet = petVec:at(i);
		local pcID = tonumber(pet:GetPCID())
		local actor = barrack.GetPet(pet:GetStrGuid());
		if actor ~= nil and pcID == 0 then
			local petCtrl = bg:CreateOrGetControlSet('barrack_pet', 'attached_pet'..pet:GetStrGuid(), 0, 0);
			UPDATE_PET_BTN(petCtrl, pet, false);
			petCtrl:SetOverSound("button_over")
			petCtrl:SetClickSound("button_click_2")
		end
	end

	GBOX_AUTO_ALIGN(bg, 30, 10, 10, true, false);
	

end

