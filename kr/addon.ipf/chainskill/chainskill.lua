
function CHAINSKILL_ON_INIT(addon, frame)

	addon:RegisterMsg("CHAIN_SKILL_SET", "ON_CHAIN_SKILL_SET");

end

function CHAINSKILL_CREATE(addon, frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("PROCESS_CHAIN_SKILL");
	timer:Start(0.01);
	frame:ShowWindow(1);

end

function CHAINSKILL_CLEAR(frame)

	DESTROY_CHILD_BY_USERVALUE(frame, "IS_INST_ICON", "YES");

end

function ON_CHAIN_SKILL_SET(frame, msg, str, arg, info)

	if nil == info or info:GetCount() == 0 then
		frame:ShowWindow(0);
		return;
	end

	CHAINSKILL_CLEAR(frame); 
	frame:ShowWindow(1);
	local cnt = info:GetCount();
	for i = 0 , cnt - 1 do
		local nextSkl = info:GetChildByIndex(i);
		CHAINSKILL_ADD_ICON(frame, nextSkl:GetSkillName(), nextSkl.limitTime * 0.001)
	end

	CHAINSKILL_ALIGN(frame);

end

function CHAINSKILL_ADD_ICON(frame, skillName, time)

	local skillInfo = session.GetSkillByName(skillName);
	if skillInfo == nil then
		return;
	end

	local iconSize = tonumber(frame:GetUserConfig("IconSize"));
	
	local curCnt = GET_CHILD_COUNT_BY_USERVALUE(frame, "IS_INST_ICON", "YES");
	local slot = frame:CreateOrGetControl('slot', 'itemslot_' .. curCnt, 0, 0, iconSize, iconSize);
	slot:SetUserValue("IS_INST_ICON", "YES");
	slot:ShowWindow(1);
	slot = tolua.cast(slot, "ui::CSlot");
	slot:SetSkinName("slot_type01");

	local sklCls = GetClass("Skill", skillName);
	SET_SLOT_SKILL(slot, sklCls);
	local icon = slot:GetIcon();
	icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_CHAIN_TIME');
	ICON_SET_COOLDOWN(icon, 0, time);

	local hotKey = GET_HOTKEY("Skill", sklCls.ClassID);
	if hotKey ~= nil then
		slot:SetText('{s20}{b}{ol}'..hotKey, 'default', 'right', 'top', -8, 1);
	else
		slot:ClearText();
	end

	slot:SetBlink(600000, 0.8, "AAFFFFFF", 1);

end

function CHAINSKILL_ALIGN(frame)

	local iconSize = tonumber(frame:GetUserConfig("IconSize"));
	local margin = 5;

	local curCnt = GET_CHILD_COUNT_BY_USERVALUE(frame, "IS_INST_ICON", "YES");
	local startX = (frame:GetWidth() / 2) - curCnt * (iconSize / 2 + margin);
	local curIndex = 0;

	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue("IS_INST_ICON") == "YES" then
			slot:SetOffset(startX , slot:GetOffsetY());
			startX = startX + iconSize + margin;
		end
	end

	frame:Invalidate();
end

function PROCESS_CHAIN_SKILL(frame)

	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local slot = frame:GetChildByIndex(i);
		if slot:GetUserValue("IS_INST_ICON") == "YES" then
			slot = tolua.cast(slot, "ui::CSlot");
			local icon = slot:GetIcon();
			if icon:GetCoolTimeRate() >= 1.0 then
				frame:RemoveChildByIndex(i);
				frame:Invalidate();

				local curCnt = GET_CHILD_COUNT_BY_USERVALUE(frame, "IS_INST_ICON", "YES");
				if curCnt == 0 then
					frame:ShowWindow(0);
				end

				return;
			end
		end
	end

end
