
function TEAMINFO_ON_INIT(addon, frame)
	
end

function TEAMINFO_OPEN(frame)
	
	local account = session.barrack.GetCurrentAccount();
	local charCount = account:GetTotalSlotCount();
	local petCount = account:GetTotalPetCount();
	
	local AddY = 0;
	
	local gbox_top = GET_CHILD_RECURSIVELY(frame,"gb_top");
	local btn_delete =gbox_top:GetChild("btn_teamDelete");
	btn_delete:ShowWindow(0);
	btn_delete:SetEnable(0);

	-- 내 계정인 경우에만.
	if session.barrack.GetCurrentAccount() ==  session.barrack.GetMyAccount() then
		-- 삭제 버튼 활성화.
		if charCount == 0 and petCount == 0 then
			btn_delete:ShowWindow(1);
			btn_delete:SetEnable(1);
			AddY = btn_delete:GetHeight();
		end
	end
	
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
	WARNINGMSGBOX_EX_FRAME_OPEN(frame, nil, 'TeamDeleteWarning;TeamDeleteWarningCompare/_EXEC_DELETE_TEAM', 0)
end

function _EXEC_DELETE_TEAM()
	barrack.RequestDeleteTeam();
end