function INIT_PET(pet)
	SetBroadcastOwner(pet);
	EnableAIOutOfPC(pet);
	local pc = GetOwner(pet);
	
	if pet.ClassName == "penguin" then
    	AddBuff(pet, pc, 'pet_penguin_buff');
	end
		if pet.ClassName == "parrotbill" then
    	AddBuff(pet, pc, 'pet_parrotbill_buff');
	end
    if pet.ClassName == "Lesser_panda" then
    	AddBuff(pet, pc, 'pet_Lesserpanda_buff');
	end
	
	if pet.ClassName == "Pet_Rocksodon" then
    	AddBuff(pet, pc, 'pet_rocksodon_buff');
	end
	
	if pet.ClassName == "PetHanaming" then
    	AddBuff(pet, pc, 'pet_PetHanaming_buff');
	end
	
	if pet.ClassName == "Lesser_panda_gray" then
    	AddBuff(pet, pc, 'pet_Lesserpanda_gray_buff');
	end
	
	if pet.ClassName == "pet_goro_suit" then
    	AddBuff(pet, pc, 'PET_GORO_BUFF');
	end
	if pet.ClassName == "Pet_Golddog" then
    	AddBuff(pet, pc, 'PET_GOLD_DOG_BUFF');
	end
	if pet.ClassName == "pet_weddingbird" then
    	AddBuff(pet, pc, 'PET_WEDDING_BIRD_BUFF');
	end
	
	SetHookMsgOwner(pet, pc);
	SetCompanionInfo(pc, pet, pet.ClassName);
	
	InvalidateStates(pet)

	AddAlmostDeadScript(pet, "PET_ON_DEAD");
	AddAlmostDeadScript(pc, "PET_OWNR_ON_DEAD");
	-- ChangeMoveSpdType(pet, "RUN");

	-- pet summoning with run to pc not used anymore
	--[[
	pet.MSPD_BM = 0;
	
	local x, y, z = GetPos(pc);
	x, z = GetAroundPos(pc, IMCRandom(0, 360), 200);
	x, y, z = GetRandomPos(pc, x, y, z, 1);
	SetPos(pet, x, y, z);

	pet.FIXMSPD_BM = 120;
	InvalidateMSPD(pet);

	while 1 do
		pc = GetOwner(pet);
		x, y, z = GetPos(pc);
		MoveEx(pet, x, y, z, 1);
		local dist = GetDist2D(pc, pet);
		if dist <= 30 then
			break;
		end
		
		sleep(500);	
	end

	pet.FIXMSPD_BM = 0;
	InvalidateMSPD(pet);
	]]

	PET_SET_ACT_FLAG(pet);

	RunSimpleAI(pet, "companion_" .. pet.ClassName);
	UPDATE_PET_ACTIVATE(pet, pc);
	if pet.IsActivated == 1 then
		RunScript("UPDATE_PET_STAMINA", pet);
	end
	
	
	local companionClassName = TryGetProp(pet, 'ClassName');
	if companionClassName ~= nil then
		local companionClass = GetClass('Companion', companionClassName);
		local isRidingOnly = TryGetProp(companionClass, 'RidingOnly');
		if isRidingOnly == 'YES' then
			if GetVehicleState(pc) == 0 then
				AddBuff(pc, pet, 'System_Companion_VisibleTime', 1, 0, 30000, 1);
			end
		end
	end
end

