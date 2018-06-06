-- quickslotnearbar_pet.lua


function ON_PET_SELECT(frame)

	local call_pet = GET_CHILD(frame, "call_pet", "ui::CSlot");
	local etcObj = GetMyEtcObject();

	local curTime = geTime.GetGlobalAppTime();
	local elapsedTime = curTime - etcObj.PetSummonTime;
	if elapsedTime < - PET_COOLDOWN or elapsedTime >= PET_COOLDOWN then
		elapsedTime = -1;
	end
	if etcObj.SelectedPet == 0 then
		call_pet:ShowWindow(0);
	else
		local pet = session.pet.GetPetByType(etcObj.SelectedPet);
		if nil == pet then
			call_pet:ShowWindow(0);
			return;
		end

		local pet_icon = CreateIcon(call_pet);
		pet_icon:EnableHitTest(0);
		local obj = GetIES(pet:GetObject());
		pet_icon:SetImage(obj.ClassName);
		call_pet:ShowWindow(1);
		if curTime >= 0 then
			ICON_SET_COOLDOWN(pet_icon, elapsedTime, PET_COOLDOWN);
		end
	end

end

function QUICKSLOT_SUMMON_PET(frame, slot)

	slot = tolua.cast(slot, "ui::CSlot");
	local icon = CreateIcon(slot);
	if icon:GetCoolTimeRate() < 1 then
		return;
	end
	
	local etcObj = GetMyEtcObject();
	local pet = session.pet.GetPetByType(etcObj.SelectedPet);
	if nil == pet then
		return;
	end
	
	local petType = pet:GetPetType();
	control.CustomCommand("SUMMON_PET", petType);

end


