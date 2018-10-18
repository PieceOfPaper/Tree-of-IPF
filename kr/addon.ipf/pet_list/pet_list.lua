
function PET_LIST_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('PET_LIST', 'ON_PET_LIST');
	addon:RegisterOpenOnlyMsg("GAME_START", "ON_PET_LIST");

end

function DO_OPEN_PET_LIST()



end

function GET_SUMMONED_PET()

	local needJobID = 0;

	local summonedPet = session.pet.GetSummonedPet(needJobID);
	if summonedPet == nil then
		needJobID = 3014;
		summonedPet = session.pet.GetSummonedPet(needJobID);
	end

	return summonedPet;
end

function GET_SUMMONED_PET_HAWK()
	local needJobID = 3014;
	local summonedPet = session.pet.GetSummonedPet(needJobID);
	return summonedPet;
end

function UI_TOGGLE_PETLIST()
	if app.IsBarrackMode() == true then
		return;
	end

	if ui.CheckHoldedUI() == true then
		return;
	end	

	local frame = ui.GetFrame("pet_info");
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);
		return;
	end
	
	local summonedPet = GET_SUMMONED_PET();
	if summonedPet == nil then
		ui.SysMsg(ClMsg("SummonedPetDoesNotExist"));
		return;		
	end

	PET_INFO_SHOW(summonedPet:GetStrGuid());

end

function OPEN_PET_INFO(ctrl, btn, argStr, argNum)
	PET_INFO_SHOW(argStr);
end

function ON_PET_LIST(frame, msg, str, num)
	local etcObj = GetMyEtcObject();
	local petType = etcObj.SelectedPet;
	DESTROY_CHILD_BYNAME(frame, "_CTRLSET_");
	local petList = session.pet.GetPetInfoVec();
	local x = 15;
	local y = 110;
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	for i = 0 , petList:size() - 1 do
		local info = petList:at(i);
		local obj = GetIES(info:GetObject());

		local setName = "_CTRLSET_" .. i;
		local set = frame:CreateControlSet('pet', setName, x, y);
		y = y + ui.GetControlSetAttribute("pet", "height");
		local nameStr = info:GetName();
		if info:GetPCID()  == cid then
			nameStr = nameStr .. "{#0099ff}(" .. ClMsg("NowTogether")..")";
		end
		set:GetChild("petname"):SetTextByKey("petname", nameStr);
		local pic = GET_CHILD(set, "pic", "ui::CPicture");
		pic:SetImage(obj.Icon);
		
		set:SetEventScript(ui.LBUTTONUP, "OPEN_PET_INFO");
		set:SetEventScriptArgString(ui.LBUTTONUP, info:GetStrGuid());
		set:SetUserValue("PET_TYPE", obj.ClassID);
	end

end

function DEFAULT_PET(ctrlset, ctrl, str, type)

	local etcObj = GetMyEtcObject();
	if ctrlset:GetUserIValue("PET_TYPE") == type then
		ctrl = tolua.cast(ctrl, "ui::CCheckBox");
		if ctrl:IsChecked() == 0 then
			control.CustomCommand("CHANGE_PET_TYPE", 0);
			etcObj.SelectedPet = 0;
			addon.BroadMsg("PET_SELECT", "", 0);
			return;
		end
	end

	etcObj.SelectedPet = type;
	addon.BroadMsg("PET_SELECT", "", 0);
	control.CustomCommand("CHANGE_PET_TYPE", type);

	local frame = ctrlset:GetTopParentFrame();
	for i = 0 , frame:GetChildCount() - 1 do
		local set = frame:GetChildByIndex(i);
		if string.find(set:GetName(), "_CTRLSET_") ~= nil then
			local petType = set:GetUserIValue("PET_TYPE");
			local defaultPet = GET_CHILD(set, "defaultPet", "ui::CCheckBox");
			if petType == type then
				defaultPet:SetCheck(1);
			else
				defaultPet:SetCheck(0);
			end
		end
	end

end







