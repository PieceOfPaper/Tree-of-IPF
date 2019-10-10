function SKILLSTAT_ON_INIT(addon, frame)

end

function BEFORE_APPLIED_SKILLSTAT_OPEN(invItem)

	local frame = ui.GetFrame("skillstat");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end
	
	local obj = GetIES(invItem:GetObject());
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
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
    endTxt2:SetTextByKey("msg", ClMsg("TransferBarrackSkillReset")); 

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_SkillResetLng")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	
	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
	SKILLSTAT_RESIZE(frame, frame:GetUserConfig("HEIGHT_SKILLRESET"))
	
	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	detail:ShowWindow(0);
end

local function IS_SKILLRESET_ITEM(itemClsName)
	if itemClsName == 'Premium_SkillReset' or itemClsName == 'Premium_SkillReset_14d' or itemClsName == 'Premium_SkillReset_1d' or itemClsName == 'Premium_SkillReset_60d' or itemClsName == 'Premium_SkillReset_Trade' or itemClsName == 'PC_Premium_SkillReset' or itemClsName == 'Premium_SkillReset_14d_Team' then
		return true;
	end
	if itemClsName == 'steam_Premium_SkillReset_1' or itemClsName == 'steam_Premium_SkillReset' then
		return true;
	end
	return false;
end

function REQ_SKILLSTAT_ITEM(frame, ctrl)
	SKILLSTAT_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));

	if IS_SKILLRESET_ITEM(argList) then
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
    endTxt2:SetTextByKey("msg", ""); 

    local prop = ctrlSet:GetChild("prop");
    prop:SetTextByKey("value", ClMsg("Premium_StatResetLng")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, true);
	SKILLSTAT_RESIZE(frame, frame:GetUserConfig("HEIGHT_STATRESET"))

	local usedStat = TryGetProp(GetMyPCObject(), "UsedStat")
	if usedStat == nil or usedStat <= 0 then
		ui.SysMsg(ScpArgMsg("NoStatusPointToReset"));
		frame:ShowWindow(0);
	end

	local statPoint = TryGetProp(GetMyPCObject(), "StatByBonus");
	if statPoint == nil then
		statPoint = 0;
	end
	local detail = GET_CHILD_RECURSIVELY(frame, "detail");
	local font = frame:GetUserConfig("FONT_STATCOUNT");
	detail:SetTextByKey("value", ScpArgMsg("UseItemToReset{value}StatusPoints", "value", font..statPoint.."{/}"));
	detail:ShowWindow(1);
end

function SKILLSTAT_RESIZE(frame, height)
	local bg2 = GET_CHILD(frame, "bg2");
	frame:Resize(frame:GetOriginalWidth(), height)
	bg2:Resize(bg2:GetOriginalWidth(), height)
end