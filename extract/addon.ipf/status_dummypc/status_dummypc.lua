
function STATUS_DUMMYPC_ON_INIT(addon, frame)


end

function ON_STATUS_DUMMYPC_CREATE(frame)
	frame:MergeControlSet("itemslotset", 30, 400);
end

function STATUS_DUMMYPC_OPEN(frame)

end

function GET_DUMMYPC_ITEM(pcID, numarg1)

	local dpc = dummyPC.GetByCID(pcID);	
	return dpc:GetEquipBySpot(numarg1);

end

function _DPC_EQUIP_SET_ICON(slot, icon, equipItem, dpc)

--SET_ITEM_TOOLTIP_TYPE(icon, equipItem.ClassID, equipItem);
--icon:SetTooltipArg('dummyPC', equipItem.equipSpot, dpc:GetStrCID());
	
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, equipItem, equipItem.ClassName, 'dummyPC', equipItem.equipSpot, dpc:GetStrCID());

end

function STATUS_DPC_SHOW_INFO(handle)

	local frame = ui.GetFrame("status_dummypc");
	frame:ShowWindow(1);
	
	local targetInfo = info.GetTargetInfo(handle);
	frame:SetTextByKey("Name", targetInfo.name);
	frame:SetTextByKey("Level", targetInfo.level);

	local dpc = dummyPC.GetInfo(handle);
	local obj = GetIES(dpc:GetObject());
	local jobObj = GetClassByType("Job", obj.Job);
	local p_port = GET_CHILD(frame, "p_port", "ui::CPicture");
	p_port:SetImage(GET_PORTRAIT_IMG_NAME(jobObj.ClassName, obj.Gender));

	-- EQUIP UI SETTING
	local eqpList = dpc.equipList;
	SET_EQUIP_LIST(frame, eqpList, _DPC_EQUIP_SET_ICON, dpc);

	-- STAT UI SETTING
	local statusGbox = frame:GetChild("statusGbox");
	local cnt = statusGbox:GetChildCount();
	for i = 0 , cnt - 1 do
		local child = statusGbox:GetChildByIndex(i);
		local propType = GetPropType(obj, child:GetName());
		if propType ~= nil then
			child:SetText(frame:GetUserConfig("STAT_FONT") .. obj[child:GetName()]);
		end
	end

	-- SKILL UI SETTING
	local dpcSkillList = jobObj.DPC_DefHaveSkill;
	local sList = StringSplit(dpcSkillList, "#");
	
	local ypos = 120;
	DESTROY_CHILD_BY_USERVALUE(frame, "SKL_CTRLSET", "YES");
	for i = 1 , #sList do
		local sklName = sList[i];
		local sklCls = GetClass("Skill", sklName);

		local skillCtrl = frame:CreateOrGetControlSet('dummypc_skill', 'skillCtrl_', 160, ypos);
		local slot = GET_CHILD(skillCtrl, "slot", "ui::CSlot");
		local icon = CreateIcon(slot);
		icon:SetImage("icon_" .. sklCls.Icon);
				
		local name = skillCtrl:GetChild("name");
		name:SetText("{@st42}" .. sklCls.Name);
		local level = skillCtrl:GetChild("level");
		level:SetText("");
		skillCtrl:ShowWindow(1);
		skillCtrl:SetUserValue("SKL_CTRLSET", "YES");
		ypos = ypos + 40;
	end
	

end


