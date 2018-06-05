
--[[
function REINFORCE_POP_ON_INIT(addon, frame)

end

function REINFORCE_POP_CREATE(addon, frame)
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_REINF_TIME");
	timer:Start(1);
end

function REINFORCE_POP(frame, ctrl, argStr, argNum)
	REINF_UI_CLEAR(frame);
end

function REINFORCE_POP_OK_BTN_CHANGE(frame, argStr)
	local ok = GET_CHILD(frame, "OK", "ui::CButton");
	ok:ShowWindow(1);
	ok:SetText(string.format("{@sti7}{s24}%s{/}", argStr));
end



]]