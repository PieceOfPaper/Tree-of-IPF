-- warningmsgbox.lua
local local_item_grade = nil

function WARNINGMSGBOX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_WARNINGMSGBOX_UI", "WARNINGMSGBOX_FRAME_OPEN");
end

function WARNINGMSGBOX_FRAME_OPEN(clmsg, yesScp, noScp, itemGuid)        
	ui.OpenFrame("warningmsgbox")
	
	local frame = ui.GetFrame('warningmsgbox')
	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext")
	warningText:SetText(clmsg)

    local input_frame = GET_CHILD_RECURSIVELY(frame, "input")
    input_frame:ShowWindow(1)
    input_frame:SetText('')

	local showTooltipCheck = GET_CHILD_RECURSIVELY(frame, "cbox_showTooltip")
	if itemGuid ~= nil then
		frame:SetUserValue("ITEM_GUID" , itemGuid)
		WARNINGMSGBOX_CREATE_TOOLTIP(frame);
		showTooltipCheck:ShowWindow(1)
	else
		showTooltipCheck:ShowWindow(0)
	end
    
    if itemGuid ~= nil then
        local item = session.GetInvItemByGuid(itemGuid)
        if item ~= nil then
            local_item_grade = GetIES(item:GetObject()).ItemGrade
        else
            local_item_grade = 0
        end
    else
        local_item_grade = 0
    end
    
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	tolua.cast(yesBtn, "ui::CButton");

    if local_item_grade < 3 then
        input_frame:ShowWindow(0)            
    end

	yesBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_YES');
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, yesScp);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");

	noBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_NO');
	noBtn:SetEventScriptArgString(ui.LBUTTONUP, noScp)

	local buttonMargin = noBtn:GetMargin()
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox')
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + showTooltipCheck:GetHeight() + noBtn:GetHeight() + 2 * buttonMargin.bottom + input_frame:GetHeight()
    if itemGuid == nil or local_item_grade < 3 then
        totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + showTooltipCheck:GetHeight() + noBtn:GetHeight() + 2 * buttonMargin.bottom
    end

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg')
	warningbox:Resize(warningbox:GetWidth(), totalHeight)
	bg:Resize(bg:GetWidth(), totalHeight)
	frame:Resize(frame:GetWidth(), totalHeight)
end

function _WARNINGMSGBOX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
    local input_frame = GET_CHILD_RECURSIVELY(parent, "input")    
    if local_item_grade >= 3 and input_frame:GetText() ~= '0000' then
        -- 확인메시지 불일치
        ui.SysMsg(ClMsg('miss_match_confirm_text'))
        return
    end

	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_YES" .. argStr)
	local scp = _G[argStr]
	if scp ~= nil then
		scp()
	end
	ui.CloseFrame("warningmsgbox")
	ui.CloseFrame("item_tooltip")
end

function _WARNINGMSGBOX_FRAME_OPEN_NO(parent, ctrl, argStr, argNum)
	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_NO" .. argStr)
	local scp = _G[argStr]
	if scp ~= nil then
		scp()
	end
	--RunScript(argStr)
	ui.CloseFrame("warningmsgbox")
	ui.CloseFrame("item_tooltip")
end

function WARNINGMSGBOX_FRAME_CLOSE(frame)
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	yesBtn:SetLBtnUpScp("")

end

function WARNINGMSGBOX_CREATE_TOOLTIP(frame)
	local warningboxFrame = ui.GetFrame("warningmsgbox")
	if warningboxFrame == nil then
		return
	end

	local itemGuid = warningboxFrame:GetUserValue("ITEM_GUID")
	if itemGuid == nil or itemGuid == 0 or itemGuid == "" then
		return
	end

	local invItem = session.GetInvItemByGuid(itemGuid)
	if invItem == nil then
		return
	end

	local tooltipFrame = ui.GetFrame("item_tooltip");
	if tooltipFrame == nil then
		tooltipFrame = ui.GetNewToolTip("wholeitem_link", "item_tooltip")
	end

	tooltipFrame = tolua.cast(tooltipFrame, 'ui::CTooltipFrame');

	local invObj = invItem:GetObject()
	if invObj == nil then
		return
	end
    local obj = GetIES(invObj)

    tooltipFrame:SetTooltipType('wholeitem');
	if obj == nil then
		return
	end

	tooltipFrame:SetTooltipStrArg('inven');
	tooltipFrame:SetTooltipIESID(itemGuid);
	tooltipFrame:RefreshTooltip();

	-- 툴팁 출력위치 조정
	local OffsetRatioM = frame:GetUserConfig("TOOLTIP_OFFSET_M");
	local OffsetRatioS = frame:GetUserConfig("TOOLTIP_OFFSET_S");
	local OffsetX = warningboxFrame:GetX() + warningboxFrame:GetWidth() - ( tooltipFrame:GetWidth() / OffsetRatioM );
	local OffsetY = warningboxFrame:GetY() - ( tooltipFrame:GetHeight() / OffsetRatioS );
	tooltipFrame:SetOffset(OffsetX, OffsetY)

	local isShowTooltip = config.GetXMLConfig("ShowTooltipInWarningBox")
	if isShowTooltip == 1 then
		tooltipFrame:ShowWindow(1)
	else
		tooltipFrame:ShowWindow(0)
	end
end

function WARNINGMSGBOX_SHOW_TOOLTIP(frame)
	local tooltipFrame = ui.GetFrame("item_tooltip")	
	if tooltipFrame == nil then
		tooltipFrame = ui.GetFrame("wholeitem_link")
	end

	if tooltipFrame == nil then
		return
	end

	tooltipFrame = tolua.cast(tooltipFrame, 'ui::CTooltipFrame');

	local isShowTooltip = config.GetXMLConfig("ShowTooltipInWarningBox")
	if isShowTooltip == 1 then
		tooltipFrame:ShowWindow(1)
	else
		tooltipFrame:ShowWindow(0)
	end
end

function UPDATE_TYPING_SCRIPT_WARNINGMSGBOX(frame, ctrl)	
end