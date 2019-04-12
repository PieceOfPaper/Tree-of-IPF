
function TEAMINFO_ON_INIT(addon, frame)

	
end

function TEAMINFO_OPEN(frame)

	local gbox_buff = frame:GetChild("gbox_buff");
	local gbox_abil_list = gbox_buff:GetChild("gbox_abil_list");
	gbox_abil_list:RemoveAllChild();

	local account = session.barrack.GetCurrentAccount();
	local lv = account:GetTeamLevel();
	local curExp = account:GetTeamLevelCurExp();
	local maxExp = account:GetTeamLevelMaxExp();

	local gauge_exp = GET_CHILD(frame, "gauge_exp");
	gauge_exp:SetPoint(curExp, maxExp);
	local txt_percent = GET_CHILD(frame, "txt_percent");
	txt_percent:SetTextByKey("value", math.floor(curExp * 100 / maxExp));
    local txt_lv = frame:GetChild("txt_lv");
	txt_lv:SetTextByKey("value", lv);

	local cls = GetClassByType("XP_TeamLevel", lv);
	if cls == nil or lv <= 1 then
		return;
	end

	local ctrlSet = gbox_abil_list:CreateControlSet("teamlevel_buff", "CTRL_EXP",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local name = ctrlSet:GetChild("name");
	local value = ctrlSet:GetChild("value");
	name:SetTextByKey("value", ScpArgMsg("ExpGetAmount"));
	value:SetTextByKey("value", string.format("{img green_up_arrow 16 16}  %d %%", cls.ExpBonus));
	GBOX_AUTO_ALIGN(gbox_abil_list, 10, 10, 0, true, false);

end

