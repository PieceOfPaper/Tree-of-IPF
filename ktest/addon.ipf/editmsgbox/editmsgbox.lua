
function EDITMSGBOX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_EDITMSGBOX_UI", "EDITMSGBOX_FRAME_OPEN");
end


function EDITMSGBOX_FRAME_OPEN(clmsg, yesScp, noScp)
	ui.OpenFrame("editmsgbox")
	
	local frame = ui.GetFrame('editmsgbox')
	frame:EnableHide(1);
	
	local text = GET_CHILD_RECURSIVELY(frame, "text")
    text:SetText(clmsg)

	local edit = GET_CHILD_RECURSIVELY(frame, "edit")
    edit:SetText('')
    
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yesBtn", "ui::CButton")
	yesBtn:SetEventScript(ui.LBUTTONUP, '_EDITMSGBOX_FRAME_OPEN_YES');
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, yesScp);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "noBtn", "ui::CButton")
	noBtn:SetEventScript(ui.LBUTTONUP, '_EDITMSGBOX_FRAME_OPEN_NO');
	noBtn:SetEventScriptArgString(ui.LBUTTONUP, noScp)

	yesBtn:ShowWindow(1);
    noBtn:ShowWindow(1);
end

function _EDITMSGBOX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
    local edit = GET_CHILD_RECURSIVELY(parent, "edit")
    local text = edit:GetText();
	local scp = _G[argStr]
    if scp ~= nil then
		scp(text)
    end
    
	ui.CloseFrame("editmsgbox")
end

function _EDITMSGBOX_FRAME_OPEN_NO(parent, ctrl, argStr, argNum)
	local scp = _G[argStr]
	if scp ~= nil then
		scp()
    end
    
	ui.CloseFrame("editmsgbox")
end