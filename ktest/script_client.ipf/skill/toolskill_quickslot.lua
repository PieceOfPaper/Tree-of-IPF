-- toolskill_quickslot.lua

function SKL_QUICKSLOT_LIGHTCELL(actor, obj, slot, minValue, maxValue)

	slot = tolua.cast(slot, "ui::CObject");

	local pos = actor:GetPos();
	local lightValue = geCell.GetCellByteValue(pos, CELL_BYTE_LIGHT, minValue, maxValue);
	
	
	-- 파이어필라 주변에 있으면 개당 + 10.  최대 5개까지만.   내맘데로 넣음. 돋보기스킬 조립할때 불러주셈.
	local firePillarCount = SelectPadCount_C(actor, 'Wizard_New_FirePillar', pos.x, pos.y, pos.z, 50, 'ALL');
	if firePillarCount > 5 then
		firePillarCount = 5;
	end
	lightValue = lightValue + firePillarCount * 10;

	local centerText = slot:GetChild("CENTER_TEXT");
	centerText:SetText("{@st57}" .. lightValue);

end

function SKL_CAPTURE_PAD(actor, obj, slot)

	slot = tolua.cast(slot, "ui::CObject");
	local cnt = session.bindFunc.GetPadCaptureStackCount();
	local centerText = slot:GetChild("CENTER_TEXT");
	if cnt == 0 then
		centerText:SetText("");
	else
		local val = ScpArgMsg("ChargeValue:{Value}", "Value", cnt);
		centerText:SetText("{@st50}" .. val);
	end

end

