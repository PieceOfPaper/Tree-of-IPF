
function TEAMINFO_ON_INIT(addon, frame)
	
end

function TEAMINFO_OPEN(frame)
	
	local account = session.barrack.GetCurrentAccount();
	local charCount = account:GetTotalSlotCount();
	local petCount = account:GetTotalPetCount();
	
	local AddY = 0;
	
	-- 팀 정보 표시
	local gbox_mid =  GET_CHILD_RECURSIVELY(frame,"gb_mid");
	if gbox_mid ~= nil then
		gbox_mid:SetOffset(gbox_mid:GetOriginalX(), gbox_mid:GetOriginalY() + AddY)	
	end

	local gbox_buff = GET_CHILD_RECURSIVELY(frame,"gbox_buff");
	local gbox_abil_list = gbox_buff:GetChild("gbox_abil_list");
	gbox_abil_list:RemoveAllChild();

	
	local lv = account:GetTeamLevel();
	local curExp = account:GetTeamLevelCurExp();
	local maxExp = account:GetTeamLevelMaxExp();

	local gauge_exp = GET_CHILD_RECURSIVELY(frame, "gauge_exp");
	gauge_exp:SetPoint(curExp, maxExp);
	local txt_percent = GET_CHILD_RECURSIVELY(frame, "txt_percent");
	txt_percent:SetTextByKey("value", math.floor(curExp * 100 / maxExp));
    local txt_lv = GET_CHILD_RECURSIVELY(frame,"txt_lv");
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

function TEAM_DELETE(frame, ctrl, arg1, arg2)
	
end

function _EXEC_DELETE_TEAM()
	
end