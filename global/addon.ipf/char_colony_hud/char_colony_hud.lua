function COLONY_HUD_BUFFLIST(frame, actor)
	local actorHandle = actor:GetHandleVal();
	local buffCount = info.GetBuffCount(actorHandle);
	
	local slotCount = frame:GetSlotCount();
	for j = 0, slotCount - 1 do
		local slot = frame:GetSlotByIndex(j);
		slot:SetKeyboardSelectable(false);
		if slot == nil then
			break;
		end
		slot:ShowWindow(0);
	end

	local buffIndex = 0;
	for i = 1, buffCount do
		local buff = info.GetBuffIndexed(actorHandle, i - 1);
		if buff ~= nil then
			local simplify = GetClassByType("WorldPVP_Simplify_Buff_Effects", buff.buffID);
			if simplify ~= nil then
				local isShowIcon = TryGet_Str(simplify, "ShowIcon");
				if isShowIcon == "YES" then
					local buffCls = GetClassByType("Buff", buff.buffID);
					if buffCls ~= nil then
						local slot = frame:GetSlotByIndex(buffIndex);
						if slot ~= nil then
							local icon = slot:GetIcon();
							if icon == nil then
								icon = CreateIcon(slot);
							end

							local imageName = 'icon_' .. buffCls.Icon;
							icon:Set(imageName, 'BUFF', buff.buffID, 0);

							slot:ShowWindow(1);
						end

						buffIndex = buffIndex + 1;
					end
				end
			end
		end
	end
end