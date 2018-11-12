
function CAMP_UI_ON_INIT(addon, frame)

	addon:RegisterMsg("OPEN_CAMP_UI", "ON_OPEN_CAMP_UI");
	addon:RegisterMsg("CAMP_HISTORY_UI", "ON_CAMP_HISTORY_UI");
	REGISTER_WAREHOUSE_MSG(addon, frame);		
	
end

function ON_CAMP_HISTORY_UI(frame, msg)
	local cnt = session.camp.GetCampHistoryCount();
	local gboxctrl = frame:GetChild("gbox_log");

	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();
	
	for i = cnt -1 , 0, -1 do
		local str = session.camp.GetCampHistoryByIndex(i);
		if nil ~= str then
			local ctrlSet = log_gbox:CreateControlSet("squire_camp_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			local sList = StringSplit(str, "#");			
			local userName = ctrlSet:GetChild("UserName");
			local str = sList[1];
			userName:SetTextByKey("value", str);
			local itemCls = GetClassByType("Item", sList[2]);
			if nil ~= itemCls then
				local slot = GET_CHILD(ctrlSet, "slot");
				SET_SLOT_ITEM_CLS(slot, itemCls);
				local prop = ctrlSet:GetChild("prop");
				local propStr = itemCls.Name .. " " .. sList[3];
				propStr = propStr .. ClMsg("Auto_Kae_SagJe.");
				prop:SetTextByKey("value", propStr);
			end
		end
	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end

function ON_OPEN_CAMP_UI(frame, msg, str, forceOpenUI, isOwner)
	if forceOpenUI == 1 then
		frame:ShowWindow(1);
	else
		if str == frame:GetUserValue("HANDLE") and frame:IsVisible() ~= 0  then
			frame:ShowWindow(0);
			return;
		end
		return;
	end

	frame:SetUserValue("HANDLE", str);
	REGISTERR_LASTUIOPEN_POS(frame);

	local campInfo = session.camp.GetCurrentCampInfo();

	local skillCls = GetClassByType("Skill", campInfo.skillType);
	local skillName = skillCls.ClassName;
	local sklLevel = campInfo.skillLevel;

	local campTime = CAMP_TIME(skillName, sklLevel);
	frame:SetUserValue("TOTAL_TIME", campTime);

	local gbox = GET_CHILD(frame, "gbox");	
	--local buffTime = CAMP_BUFF_TIME(sklLevel);
	--local effectTxt = ClMsg("BuffMaintainTime") .. " + " ..buffTime .. "%";
	--local effect_text = GET_CHILD(gbox, "effect_text");		
	--effect_text:SetTextByKey("value", effectTxt);

	CAMP_UI_UPDATE_TIME(frame);
	frame:RunUpdateScript("CAMP_UI_UPDATE_TIME", 1, 0.0, 0);

	packet.RequestItemList(IT_WAREHOUSE);

	ui.OpenFrame("inventory");

	local t_useprice = gbox:GetChild("t_useprice");
	t_useprice:SetTextByKey("value", WAREHOUSE_PRICE);

	local needSilver = CAMP_EXTEND_PRICE(campInfo.skillType, campInfo.skillLevel);

	local t_extendTime = gbox:GetChild("t_extendTime");
	t_extendTime:SetTextByKey("price", needSilver);

	local tab = frame:GetChild("itembox");
	if isOwner == 0 then
		tab:SetVisible(0);
	else
		tab:SetVisible(1);
	end
end

function CAMP_UI_CLOSE(frame)
	ui.CloseFrame("inventory");
end

function CAMP_UI_UPDATE_TIME(frame)
		
	local totalSec = frame:GetUserIValue("TOTAL_TIME");

	local campInfo = session.camp.GetCurrentCampInfo();
	local serverTime = geTime.GetServerFileTime();
	local difSec = imcTime.GetIntDifSecByTime(campInfo:GetEndTime(), serverTime);

	local gbox = GET_CHILD(frame, "gbox");	
	local time_text = GET_CHILD(gbox, "time_text");
	time_text:SetTextByKey("value", GET_TIME_TXT(difSec));

	local time_gauge = GET_CHILD(gbox, "time_gauge");
	time_gauge:SetPoint(difSec, totalSec);

	return 1;
end

function DESTROY_CAMP(parent, ctrl)
	control.CustomCommand("REMOVE_CAMP", 0);	
end

function CAMP_EXTEND_TIME(parent, ctrl)
	
	local campInfo = session.camp.GetCurrentCampInfo();
	local needSilver = CAMP_EXTEND_PRICE(campInfo.skillType, campInfo.skillLevel);
	if IsGreaterThanForBigNumber(needSilver, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg( ClMsg("NotEnoughMoney") );
		return;
	end

	local strScp = "EXEC_CAMP_EXTEND_TIME()";
	ui.MsgBox(ScpArgMsg("REALLY_DO"), strScp, "None");

end

function EXEC_CAMP_EXTEND_TIME()
	local campInfo = session.camp.GetCurrentCampInfo();
	control.CustomCommand("EXTEND_CAMP_TIME", campInfo:GetHandle());
end







