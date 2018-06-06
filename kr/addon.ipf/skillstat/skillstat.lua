function SKILLSTAT_ON_INIT(addon, frame)

end

function BEFORE_APPLIED_SKILLSTAT_OPEN(invItem)
	local frame = ui.GetFrame("skillstat");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local itemobj = GetIES(invItem:GetObject());
	local richtext = frame:GetChild("richtext");
	richtext:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local str = frame:GetChild("str");
	str:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_SkillResetLng")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
end

function REQ_SKILLSTAT_ITEM(frame, ctrl)
	SKILLSTAT_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));

	pc.ReqExecuteTx_Item("SCR_USE_SKILL_STAT_RESET", itemIES, argList);
end


function SKILLSTAT_SELEC_CANCLE(frame, ctrl)
	frame:ShowWindow(0);
end