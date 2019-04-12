

function REQ_SKILLSTAT_ITEM(frame, ctrl)
	SKILLSTAT_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));

	if argList == 'Premium_SkillReset' or argList == 'steam_Premium_SkillReset' then
		pc.ReqExecuteTx_Item("SCR_USE_SKILL_STAT_RESET", itemIES, argList);
	else
		pc.ReqExecuteTx_Item("SCR_USE_STAT_RESET", itemIES, argList);
	end
end
