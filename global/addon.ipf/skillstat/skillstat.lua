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

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local itemobj = GetIES(invItem:GetObject());
	local richtext = frame:GetChild("richtext");
	richtext:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local str = frame:GetChild("str");
	str:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("resetSkill_middle");

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", ClMsg("JustSkill").." "..ClMsg("POINT")); 

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_SkillResetLng")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
end

function REQ_SKILLSTAT_ITEM(frame, ctrl)
	SKILLSTAT_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));

	if argList == 'Premium_SkillReset' then
	pc.ReqExecuteTx_Item("SCR_USE_SKILL_STAT_RESET", itemIES, argList);
	else
		pc.ReqExecuteTx_Item("SCR_USE_STAT_RESET", itemIES, argList);
	end
end


function SKILLSTAT_SELEC_CANCLE(frame, ctrl)
	frame:ShowWindow(0);
end

-- Stat
function BEFORE_APPLIED_STATRESET_OPEN(invItem)
	local frame = ui.GetFrame("skillstat");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	local itemobj = GetIES(invItem:GetObject());

	if itemobj.ItemLifeTimeOver == 1 then
		ui.SysMsg(ClMsg("LessThanItemLifeTime"));
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return false;
	end

	local richtext = frame:GetChild("richtext");
	richtext:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local str = frame:GetChild("str");
	str:SetTextByKey("value", ClMsg(itemobj.ClassName));

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("resetStat_middle");

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", ClMsg("JustStat").." "..ClMsg("POINT")); 

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_StatResetLng")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
end