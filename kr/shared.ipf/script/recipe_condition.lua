function  RECIPABLE_Drug_PumpkinPotion(pc)
	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
	    print(' sObj nil');
		return 0;
	end

	if sObj.PUMPKIN_POTION > 0 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_Catacomb_CopyKey(pc)
	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
	    print(' sObj nil');
		return 0;
	end

	if sObj.CATACOMB_ENTER > 0 and sObj.CATACOMB_ENTER < 200 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_StinkyNecklace(pc)
	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
	    print(' sObj nil');
		return 0;
	end

	if sObj.KATYN_ENTER > 0 and sObj.KATYN_ENTER < 200 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_LV4(pc)
	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
	    print(' sObj nil');
		return 0;
	end

	if sObj.ITEM_MAKE_LV4 == 300 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_LV8(pc)

	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
		return 0;
	end

	if sObj.ITEM_MAKE_LV8 == 300 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_LV12(pc)

	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
		return 0;
	end

	if sObj.ITEM_MAKE_LV12 == 300 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_LV16(pc)

	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
		return 0;
	end

	if sObj.ITEM_MAKE_LV16 == 300 then
		return 1;
	else
	    return 0;
	end
end

function  RECIPABLE_LV20(pc)

	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
		return 0;
	end

	if sObj.ITEM_MAKE_LV20 == 300 then
		return 1;
	else
	    return 0;
	end
end





function  RECIPABLE_REINF33(pc)

	local sObj = GetSessionObject(pc, "ssn_klapeda");
	if sObj == nil then
		return 0;
	end

	print(sObj.SIAUL_BASIC);
	if sObj.SIAUL_BASIC == 0 then
		return 1;
	end

	return 1;

end


