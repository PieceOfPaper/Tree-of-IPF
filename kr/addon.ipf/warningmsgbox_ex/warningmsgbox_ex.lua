-- warningmsgbox_ex.lua
function WARNINGMSGBOX_EX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_WARNINGMSGBOX_EX_UI", "WARNINGMSGBOX_EX_FRAME_OPEN")
end

function WARNINGMSGBOX_EX_FRAME_OPEN(frame, msg, argStr, argNum, option)
	local arg_list = SCR_STRING_CUT(argStr, ';')
	if arg_list == nil or #arg_list <= 0 then
		return
	end

	local clmsg = ClMsg(arg_list[1])
	local yes_arg = ""
	if #arg_list > 1 then
		yes_arg = arg_list[2]
	end

	ui.OpenFrame("warningmsgbox_ex")
	
	local frame = ui.GetFrame('warningmsgbox_ex')
	
	-- 커스터마이징 옵션.
	local compare_msg_color = nil;
	local compare_msg_desc = nil;
	if option ~= nil then
		if option.ChangeTitle ~= nil then
			local warningTitle = GET_CHILD_RECURSIVELY(frame, "warningtitle")
			warningTitle:SetText(ClMsg(option.ChangeTitle));
		end
		if option.CompareTextColor ~= nil then
			compare_msg_color = option.CompareTextColor;
		end
		if option.CompareTextDesc ~= nil then
			compare_msg_desc = option.CompareTextDesc;
		end
	end

	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext")
	warningText:SetText(clmsg)

	local compareText = GET_CHILD_RECURSIVELY(frame, "comparetext")
	local compareHeight = 0

	local input_frame = GET_CHILD_RECURSIVELY(frame, "input")
	local input_height = 0

	local yes_list = SCR_STRING_CUT(yes_arg, '/')
	local compare_msg = ''
	if #yes_list > 0 then
		compare_msg = ClMsg(yes_list[1])
	end

	if compare_msg ~= '' then
		compareText:ShowWindow(1)

		if compare_msg_desc ~= nil then
			compareText:SetTextByKey('desc', compare_msg_desc)
		end

		if compare_msg_color ~= nil then
			compareText:SetTextByKey('value', compare_msg_color..compare_msg..'{/}')
		else
			compareText:SetTextByKey('value', compare_msg)
		end


		compareHeight = compareText:GetHeight()
		compareText:SetMargin(0, 0, 0, 130 + compareHeight)

		input_frame:ShowWindow(1)
		input_frame:SetText('')
		input_height = input_frame:GetHeight()
	else
		compareText:ShowWindow(0)
		input_frame:ShowWindow(0)
	end
	
    
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	tolua.cast(yesBtn, "ui::CButton")
	yesBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_EX_FRAME_OPEN_YES')
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, yes_arg)

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton")
	noBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_EX_FRAME_OPEN_NO')

	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton")
	if argNum == 0 then
		yesBtn:ShowWindow(1)
		noBtn:ShowWindow(1)
		okBtn:ShowWindow(0)
	elseif argNum == 1 then
		okBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_EX_FRAME_OPEN_YES')
		okBtn:SetEventScriptArgString(ui.LBUTTONUP, yes_arg)

		yesBtn:ShowWindow(0)
		noBtn:ShowWindow(0)
		okBtn:ShowWindow(1)
	end

	local buttonMargin = noBtn:GetMargin()
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox')
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + compareHeight + input_height + noBtn:GetHeight() + 2 * buttonMargin.bottom

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg')
	warningbox:Resize(warningbox:GetWidth(), totalHeight)
	bg:Resize(bg:GetWidth(), totalHeight)
	frame:Resize(frame:GetWidth(), totalHeight)
end

function _WARNINGMSGBOX_EX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
	local input_frame = GET_CHILD_RECURSIVELY(parent, "input")
	local arg_list = SCR_STRING_CUT(argStr, '/')
	local compare_msg = ''
	local yesScp = ''
	if arg_list ~= nil then
		if #arg_list > 0 then
			compare_msg = ClMsg(arg_list[1])
		end

		if #arg_list > 1 then
			yesScp = arg_list[2]
		end
	end
	compare_msg = dic.getTranslatedStr(compare_msg);
    if input_frame:GetText() ~= compare_msg then
        -- 확인메시지 불일치
		ui.SysMsg(ClMsg('miss_match_confirm_text'))
        return
    end

	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_EX_FRAME_OPEN_YES" .. yesScp)

	local scp = _G[yesScp]
	if scp ~= nil then
		scp()
	end

	ui.CloseFrame("warningmsgbox_ex")
	ui.CloseFrame("item_tooltip")
end

function _WARNINGMSGBOX_EX_FRAME_OPEN_NO(parent, ctrl, argStr, argNum)
	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_EX_FRAME_OPEN_NO")

	ui.CloseFrame("warningmsgbox_ex")
	ui.CloseFrame("item_tooltip")
end

function WARNINGMSGBOX_EX_FRAME_CLOSE(frame)
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	yesBtn:SetLBtnUpScp("")
end

function UPDATE_TYPING_SCRIPT_WARNINGMSGBOX_EX(frame, ctrl)

end