function OPERATORMODE_ON_INIT(addon, frame)
end

function OPERATORMODE_ZONE_USER_NAME_AND_POS(nameStr)
	if 1 ~= session.IsGM() then
		return;
	end
	
	local frame = ui.GetFrame("operatormode");
	if nil == frame then
		return;
	end

	frame:ShowWindow(1);
	local bgBox = frame:GetChild("bg");
	if nil == bgBox then
		return;
	end
	
	bgBox:RemoveAllChild();
	local sList = StringSplit(nameStr, "#");
	for i = 1, #sList do
			local btn = bgBox:CreateControl('button', "TXT_" .. i, 20, 0, 450, 30);
			btn:SetText("{@st43}"..sList[i]);
			btn:SetEventScript(ui.LBUTTONUP, "OPERATORMODE_MENU");
			btn:SetEventScriptArgString(ui.LBUTTONUP, sList[i]);
		end
	GBOX_AUTO_ALIGN(bgBox, 0, 0, 0, true, false);
end

function OPERATORMODE_UI_CLOSE()
	ui.CloseFrame("operatermode");
end

function OPERATORMODE_MENU(frame, control, teamName)	
	if 1 ~= session.IsGM() then
		return;
	end
	
	local context = ui.CreateContextMenu("OPER_CONTEXT_MENU", "operatormode", 0, 0, 100, 100);
	ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Protected"), string.format("REQUEST_GM_ORDER_PROTECTED(\"%s\")", teamName));
	ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Kick"), string.format("REQUEST_GM_ORDER_KICK(\"%s\")", teamName));
	ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Move"), string.format("REQUEST_GM_ORDER_MOVE(\"%s\")", teamName));
	ui.OpenContextMenu(context);
end

function REQUEST_GM_ORDER_MOVE(teamName)
	packet.RequestGmOrderMsg(teamName, 'move');
end