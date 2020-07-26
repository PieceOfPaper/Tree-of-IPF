-- hotkey.lua

function HOTKEY_AUTO_MOVE()
	local isStart = convenience.IsAutoMove() == false;
	convenience.AutoMove(isStart);
end

function HOTKEY_ZOOM_IN()
	camera.HotkeyZoomIn();
end

function HOTKEY_ZOOM_OUT()
	camera.HotkeyZoomOut();
end

function HOTKEY_SUMMON_COMPANION(monClassID, petGuidStr)

   local petInfo = session.pet.GetPetByGUID(petGuidStr)
   if petInfo ~= nil then
	   -- 이미 소환되어 있는지 확인
	   local summonedPet = session.pet.GetSummonedPet();
	   if summonedPet ~= nil then
			ui.SysMsg(ClMsg("Pet_Aready_Summoned"));-- 펫이 이미 소환되어 있음.
			return;
	   end

	   -- cooltime 확인
	   local curTime = petInfo:GetCurrentCoolDownTime();
	   if curTime > 0 then
			ui.SysMsg(ClMsg("Can_Not_Summoned_Yet")); -- 아직 소환할 수 없음(쿨타임)
			return;
	   end

	   control.SummonPet(monClassID, petGuidStr, 0);
   end
end

function HOTKEY_UNSUMMON_COMPANION(type)
   control.SummonPet(0,0, type); 
end