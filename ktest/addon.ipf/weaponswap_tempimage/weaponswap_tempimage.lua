

function WEAPONSWAP_TEMPIMAGE_ON_INIT(addon, frame)

end 

function SHOW_WEAPON_SWAP_TEMP_IMAGE(weaponID_RH, weaponID_LH, curSwapIndex)
	frame = ui.GetFrame("weaponswap_tempimage");
	
	local bodyGbox = frame:GetChild("bodyGbox");
		
	local RHslot = bodyGbox:GetChild("slot0");
	local LHslot = bodyGbox:GetChild("slot1");
	if nil == RHslot then
		return;
	end
	
	if nil == LHslot then
		return;
	end

	RHslot = tolua.cast(RHslot, 'ui::CSlot');
	LHslot = tolua.cast(LHslot, 'ui::CSlot');
	
	local Rguid = session.GetWeaponQuicSlot(curSwapIndex + 0);
	local Lguid = session.GetWeaponQuicSlot(curSwapIndex + 1);

	if weaponID_RH ~= nil then
		if nil ~= Rguid then
			local item = GET_ITEM_BY_GUID(Rguid, 1);
			if item ~= nil then
				SET_SLOT_ITEM_IMAGE(RHslot, item);
			end
		else 
			RHslot:ClearIcon();
		end
	end

	if weaponID_LH ~= nil then
		if nil ~= Lguid then
			local item = GET_ITEM_BY_GUID(Lguid, 1);
			SET_SLOT_ITEM_IMAGE(LHslot, item);
		else
			if nil ~= Rguid then
				local rhItem = GET_ITEM_BY_GUID(Rguid, 1);
				local obj = GetIES(rhItem:GetObject());
				if obj.DBLHand == 'YES' then
					SET_SLOT_ITEM_IMAGE(LHslot, rhItem);
				else
					LHslot:ClearIcon();
				end
			else
				LHslot:ClearIcon();
			end
		end
	end

			
	frame:ShowWindow(1)
	frame:SetDuration(1.0)

end