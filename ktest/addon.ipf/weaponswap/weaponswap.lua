-- weaponswap.lua

function WEAPONSWAP_ON_INIT(addon, frame)

	addon:RegisterMsg('WEAPONSWAP', 'WEAPONSWAP_SWAP_UPDATE');
	addon:RegisterMsg('WEAPONSWAP_FAIL', 'WEAPONSWAP_FAIL');
	addon:RegisterMsg('WEAPONSWAP_SUCCESS', 'WEAPONSWAP_SLOT_SUCCESS');
	addon:RegisterMsg('ABILITY_LIST_GET', 'WEAPONSWAP_SHOW_UI');
	addon:RegisterMsg('GAME_START', 'WEAPONSWAP_SHOW_UI');

--	WEAPONSWAP_SLOT_UPDATE();
end 

function TH_WEAPON_CHECK(obj, bodyGbox, slotIndex)

	if obj == nil then
		return;
	end
	
	-- 오른쪽이고, 양손무기라면
	-- 다음칸을 지워버리자
	if 0 == (slotIndex % 2) then	
		if obj.EquipGroup ~= 'THWeapon' then
			return;
		end
		
		local etcSlot = bodyGbox:GetChild("slot"..slotIndex+1);
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot')
		local icon = etcSlot:GetIcon();
		etcSlot:ClearIcon();
		session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
	else
		if 0 == slotIndex then
			slotIndex = slotIndex + 1;
		else
			slotIndex = slotIndex -1;
		end
		-- 그게아니라면 전칸이 양손인지 확인하고, 양손을 지우자
		local etcSlot = bodyGbox:GetChild("slot"..slotIndex);
		if nil == etcSlot then
			return;
		end
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot')
		local icon = etcSlot:GetIcon();
		if nil == icon then
		
			return
		end
		
		local iconInfo = icon:GetInfo();
		local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
		
		if nil == invItem then
			return;
		end

		local itemObj = GetIES(invItem:GetObject());
		if itemObj.EquipGroup ~= 'THWeapon' then
			return;
		end

		etcSlot:ClearIcon();
		session.SetWeaponQuicSlot(etcSlot:GetSlotIndex(), "");
	end

end

function WEAPONSWAP_ITEM_DROP(parent, ctrl, argStr, argNum)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();

	if liftIcon == nil then
		return;
	end

	local iconInfo			= liftIcon:GetInfo();
	if iconInfo == nil then
		return;
	end

	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());

	if invItem == nil then
		return;
	end
	
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	
	if nil == slot then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if	obj.DefaultEqpSlot == "RH" or  obj.DefaultEqpSlot == "LH" or obj.DefaultEqpSlot == "RH LH" then
		-- 슬롯은 좌우 두개므로
		local offset = 2;
		-- 일단 슬롯 위치가, 왼쪽오른쪽인지를 확인
		if slot:GetSlotIndex() % offset == 0 then
			
			if obj.DefaultEqpSlot ~= "RH" and obj.DefaultEqpSlot ~= "RH LH" then
				return;
			end
		end

		if slot:GetSlotIndex() % offset == 1 and obj.DefaultEqpSlot ~= "LH" then
			local pc = GetMyPCObject();
			if pc == nil then
				return;
			end

			local clsType = TryGetProp(obj, "ClassType2");
			if clsType ~= "Sword" then
				return;
			end

			local abil = GetAbility(pc, "SubSword");
			if abil == nil then
				return;
			end
		end
	
		local bodyGbox = frame:GetChild("bodyGbox");
		if nil == bodyGbox then
			return;
		end
	
		-- 양손무기를 체크하자
		TH_WEAPON_CHECK(obj, bodyGbox, slot:GetSlotIndex());
		session.SetWeaponQuicSlot(slot:GetSlotIndex(), invItem:GetIESID());
		SET_SLOT_ITEM_IMAGE(slot, invItem);
	end
end

function WEAPONSWAP_ITEM_POP(parent, ctrl)
	local slot 	= tolua.cast(ctrl, 'ui::CSlot');
	slot:ClearIcon();
	session.SetWeaponQuicSlot(slot:GetSlotIndex(), "");
end

function WEAPONSWAP_SWAP_EQUIP()

	--제작시에는 무기스왑 안되게 끔..
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	
	-- 단축키로 누르면 call은 nil,
	-- 클라에서 add온으로 부르면 frame이 들어감
	-- 즉, nil이 아님
--	if nil == update then
		-- 줄이 바뀌엇다고 알리자
		session.SetWeaponSwap(1);
--	else
		-- 사이즈는 변경해줘야함
--		WEAPONSWAP_SLOT_UPDATE();
--	end

end

function WEAPONSWAP_RBTN_DOWN(frame, object)
	--local invitem = GET_SLOT_ITEM(object);
	--
    --if invitem == nil then
	--	return;
	--end
	--print(invitem:GetIESID());
	--ITEM_EQUIP_MSG(session.GetInvItemByGuid(invitem:GetIESID()));
end

function WEAPONSWAP_UI_UPDATE()
	local frame = ui.GetFrame("weaponswap");
	local bodyGbox = frame:GetChild("bodyGbox");
	for i=0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil== etcSlot then
			return;
		end

		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				SET_SLOT_ITEM_IMAGE(etcSlot, item);
			else
				etcSlot:ClearIcon();
			end
		else
			etcSlot:ClearIcon();
		end;
	end
end

function WEAPONSWAP_SWAP_UPDATE(frame)
	local bodyGbox = frame:GetChild("bodyGbox");
	for i=0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil== etcSlot then
			return;
		end

		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				SET_SLOT_ITEM_IMAGE(etcSlot, item);
			else
				etcSlot:ClearIcon();
			end
		else
			etcSlot:ClearIcon();
		end;
	end


	WEAPONSWAP_SWAP_EQUIP(frame);
end

function WEAPONSWAP_FAIL()

	local lowDur = 0;
	for i=0, 3 do
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then 
			local item = GET_ITEM_BY_GUID(guid, 1);
			if nil ~= item then
				local itemobj = GetIES(item:GetObject());
				if nil ~= itemobj then 
					if itemobj.Dur <= 0 then
						ui.MsgBox(ScpArgMsg("YouCantEquipDur0Item"));
						lowDur = 1;
						break;
					end;
				end;
			end
		end;
	end;
	
	session.SetWeaponSwap(0);
	if 0 == lowDur then
		ui.SysMsg(ClMsg("TryLater"));
	--	WEAPONSWAP_SLOT_UPDATE();
	end;
end

function WEAPONSWAP_SLOT_SUCCESS()
	imcSound.PlaySoundEvent("sys_weapon_swap");
--	WEAPONSWAP_SLOT_UPDATE()
end

function WEAPONSWAP_SLOT_UPDATE()

	local frame = ui.GetFrame("weaponswap");
	if frame == nil then
		return;
	end

	local bodyGbox = frame:GetChild("bodyGbox");
	if nil == bodyGbox then
		return;
	end
	
	-- 크기를 어떻게 바꿀까?
	local slotLine = bodyGbox:GetChild("readyWeapon");
	local smailLine = bodyGbox:GetChild("currWeapon");
	
	if nil == slotLine or nil == smailLine then
		return;
	end
	
	slotLine 	= tolua.cast(slotLine, 'ui::CGroupBox');
	smailLine 	= tolua.cast(smailLine, 'ui::CGroupBox');
	
		--세션에서 현재 등록된 슬롯 라인을 알아오고,
	local start = session.GetWeaponCurrentSlotLine();
	-- 두번째줄
	if 1 == start then
		start = 2;
	end
			
	local cposX = 0;
	local sposX = 0;
	
	for i =0, 3 do
		local etcSlot = bodyGbox:GetChild("slot"..i);
		if nil == etcSlot then
			return;
		end
	
		etcSlot 	= tolua.cast(etcSlot, 'ui::CSlot');
		
		if i == start or i == start+1 then
			etcSlot:SetMargin( ((slotLine:GetWidth()/2) * cposX) + 15, slotLine:GetY(), 0, 0);
			etcSlot:Resize(slotLine:GetWidth()/2, slotLine:GetHeight());
			cposX = cposX + 1;
	
		else
			etcSlot:SetMargin( ((smailLine:GetWidth()/2) * sposX), smailLine:GetY() + 5, 0, 0);
			etcSlot:Resize(smailLine:GetWidth()/2, smailLine:GetHeight());
			sposX = sposX + 1;
		end
	end
end


function WEAPONSWAP_SHOW_UI(frame)

--	local pc = GetMyPCObject();
--	if pc == nil then
--		return;
--	end
--	local abil = GetAbility(pc, "SwapWeapon");
	
--	if abil ~= nil then
--		frame:ShowWindow(1)
--	else
		frame:ShowWindow(0)
--	end
end