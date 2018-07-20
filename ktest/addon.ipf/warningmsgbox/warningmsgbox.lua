-- warningmsgbox.lua


function WARNINGMSGBOX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_WARNINGMSGBOX_UI", "WARNINGMSGBOX_FRAME_OPEN");
end

function WARNINGMSGBOX_FRAME_OPEN(clmsg, yesScp, noScp)
	ui.OpenFrame("warningmsgbox")
	
	local frame = ui.GetFrame('warningmsgbox')
	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext")
	warningText:SetText(clmsg)

	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	tolua.cast(yesBtn, "ui::CButton");

	yesBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_YES');
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, yesScp);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");

	noBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_NO');
	noBtn:SetEventScriptArgString(ui.LBUTTONUP, noScp);
--	yesBtn:SetLBtnUpScp(yesScp)

end

function _WARNINGMSGBOX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_YES" .. argStr)
	local scp = _G[argStr]
	if scp ~= nil then
		scp()
	end
	--RunScript(argStr)
	ui.CloseFrame("warningmsgbox")
end


function _WARNINGMSGBOX_FRAME_OPEN_NO(parent, ctrl, argStr, argNum)
	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_NO" .. argStr)
	local scp = _G[argStr]
	if scp ~= nil then
		scp()
	end
	--RunScript(argStr)
	ui.CloseFrame("warningmsgbox")
end

function WARNINGMSGBOX_FRAME_CLOSE(frame)
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	yesBtn:SetLBtnUpScp("")
end

