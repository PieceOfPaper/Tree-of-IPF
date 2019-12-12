-- warningmsgbox.lua
local local_item_grade = nil

function WARNINGMSGBOX_ON_INIT(addon, frame)
	addon:RegisterMsg("DO_OPEN_WARNINGMSGBOX_UI", "WARNINGMSGBOX_FRAME_OPEN");
end

function WARNINGMSGBOX_FRAME_OPEN(clmsg, yesScp, noScp, itemGuid)
	ui.OpenFrame("warningmsgbox")
	
	local frame = ui.GetFrame('warningmsgbox')
	frame:EnableHide(1);
	
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

	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton");

	yesBtn:ShowWindow(1);
	noBtn:ShowWindow(1);
	okBtn:ShowWindow(0);

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

function NOT_ROASTING_GEM_EQUIP_WARNINGMSGBOX_FRAME_OPEN(itemGuid, argNum)
	if itemGuid == 0 or itemGuid == nil or itemGuid == "None" then
		return;
	end

	if argNum == 0 or argNum == nil or argNum == "None" then
		return;
	end
	
	ui.OpenFrame("warningmsgbox");
	
	local frame = ui.GetFrame('warningmsgbox');
	frame:EnableHide(1);

	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext");
	warningText:SetText(ClMsg("NotRoastingGemEquip"));

    local input_frame = GET_CHILD_RECURSIVELY(frame, "input");
    input_frame:ShowWindow(1);
	input_frame:SetText('');

	local showTooltipCheck = GET_CHILD_RECURSIVELY(frame, "cbox_showTooltip");
	if itemGuid ~= nil then
		frame:SetUserValue("ITEM_GUID" , itemGuid);
		WARNINGMSGBOX_CREATE_TOOLTIP(frame);
		showTooltipCheck:ShowWindow(1);
	else
		showTooltipCheck:ShowWindow(0);
	end

	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes");
	tolua.cast(yesBtn, "ui::CButton");

	yesBtn:SetEventScript(ui.LBUTTONUP, '_NOT_ROASTING_GEM_EQUIP_WARNINGMSGBOX_FRAME_OPEN_YES');
	yesBtn:SetEventScriptArgNumber(ui.LBUTTONUP, argNum);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");

	noBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_NO');
	noBtn:SetEventScriptArgString(ui.LBUTTONUP, "None");

	local buttonMargin = noBtn:GetMargin();
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox');
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + showTooltipCheck:GetHeight() + noBtn:GetHeight() + 2 * buttonMargin.bottom + input_frame:GetHeight();
	
	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton");

	yesBtn:ShowWindow(1);
	noBtn:ShowWindow(1);
	okBtn:ShowWindow(0);

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg');
	warningbox:Resize(warningbox:GetWidth(), totalHeight);
	bg:Resize(bg:GetWidth(), totalHeight);
	frame:Resize(frame:GetWidth(), totalHeight);
end

function _NOT_ROASTING_GEM_EQUIP_WARNINGMSGBOX_FRAME_OPEN_YES(parent, ctrl, argStr, argNum)
    local input_frame = GET_CHILD_RECURSIVELY(parent, "input");
	if input_frame:GetText() ~= '0000' then
		-- 확인메시지 불일치
		ui.SysMsg(ClMsg('miss_match_confirm_text'));
		return;
	end

	IMC_LOG("INFO_NORMAL", "_NOT_ROASTING_GEM_EQUIP_WARNINGMSGBOX_FRAME_OPEN_YES" .. argStr);
	USE_ITEMTARGET_ICON_GEM(argNum);

	ui.CloseFrame("warningmsgbox");
	ui.CloseFrame("item_tooltip");
end

function WARNINGMSGBOX_FRAME_OPEN_REBUILDPOPUP()
	ui.OpenFrame("warningmsgbox");
	
	local frame = ui.GetFrame('warningmsgbox');
	frame:EnableHide(0);

	local showTooltipCheck = GET_CHILD_RECURSIVELY(frame, "cbox_showTooltip");
	showTooltipCheck:ShowWindow(0);

	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext");
	warningText:SetText(ClMsg("EVENT_1812_CHARACTER_RESET_CLIENT_FLAG_MSG0")..ClMsg("EVENT_1812_CHARACTER_RESET_CLIENT_FLAG_MSG1").."{nl} {nl}"..ClMsg("EVENT_1812_CHARACTER_RESET_CLIENT_FLAG_MSG2").."{nl} {nl}"..ClMsg("Inputby0000"));	

    local input_frame = GET_CHILD_RECURSIVELY(frame, "input");
    input_frame:ShowWindow(1);
	input_frame:SetText('');

	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes");
	tolua.cast(yesBtn, "ui::CButton");
	
	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");
	
	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton");
	okBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_REBUILDPOPUP_YES');

	yesBtn:ShowWindow(0);
	noBtn:ShowWindow(0);
	okBtn:ShowWindow(1);

	local buttonMargin = okBtn:GetMargin();
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox');
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + okBtn:GetHeight() + 2 * buttonMargin.bottom + input_frame:GetHeight();
	local bg = GET_CHILD_RECURSIVELY(frame, 'bg');

	warningbox:Resize(warningbox:GetWidth(), totalHeight);
	bg:Resize(bg:GetWidth(), totalHeight);
	frame:Resize(frame:GetWidth(), totalHeight);
	
end

function _WARNINGMSGBOX_FRAME_OPEN_REBUILDPOPUP_YES(parent, ctrl, argStr, argNum)
    local input_frame = GET_CHILD_RECURSIVELY(parent, "input");
	if input_frame:GetText() ~= '0000' then
		-- 확인메시지 불일치
		ui.SysMsg(ClMsg('miss_match_confirm_text'));
		return;
	end

	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_REBUILDPOPUP_YES");

	ui.CloseFrame("warningmsgbox");
	ui.CloseFrame("item_tooltip");
end

-- 출력할 msg, esc 키로 UI 닫을 수 있는지
-- msgtype이 0일 경우는 '0000'입력후 확인 해야 UI 창 닫게
-- msgtype이 1일 경우는 '1111'입력시 yesScp, '0000'입력시 noScp 호출
function WARNINGMSGBOX_FRAME_OPEN_NONNESTED(clmsg, enablehide, type, yesScp, noScp)
	ui.OpenFrame("warningmsgbox");

	if enablehide == nil then 
		enablehide = 0;
	end

	local msgtype = 0; 

	if type == nil or type == 0 then
		msgtype = 0;
	end

	if type == 1 and yesScp ~= nil and noScp ~= nil then
		msgtype = 1;
	end
	
	local frame = ui.GetFrame('warningmsgbox');
	frame:EnableHide(enablehide);

	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext");
	warningText:SetText(clmsg);

	local showTooltipCheck = GET_CHILD_RECURSIVELY(frame, "cbox_showTooltip");
	showTooltipCheck:ShowWindow(0);

	local input_frame = GET_CHILD_RECURSIVELY(frame, "input");
    input_frame:ShowWindow(1);
	input_frame:SetText('');

	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes");
	tolua.cast(yesBtn, "ui::CButton");
	
	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");
	
	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton");
	okBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_NONNESTED_OK');
	okBtn:SetEventScriptArgNumber(ui.LBUTTONUP, msgtype);	
	if msgtype == 1 then
		okBtn:SetEventScriptArgString(ui.LBUTTONUP, yesScp.."/"..noScp);
	end
	
	yesBtn:ShowWindow(0);
	noBtn:ShowWindow(0);
	okBtn:ShowWindow(1);
	
	local buttonMargin = okBtn:GetMargin();
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox');
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + okBtn:GetHeight() + 2 * buttonMargin.bottom + input_frame:GetHeight();

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg');
	warningbox:Resize(warningbox:GetWidth(), totalHeight);
	bg:Resize(bg:GetWidth(), totalHeight);
	frame:Resize(frame:GetWidth(), totalHeight);
end

function _WARNINGMSGBOX_FRAME_OPEN_NONNESTED_OK(parent, ctrl, argStr, argNum)
	local input_frame = GET_CHILD_RECURSIVELY(parent, "input");
	local scpstr = "";

	if argNum == 0 then
		if input_frame:GetText() ~= '0000' then
			ui.SysMsg(ClMsg('miss_match_confirm_text'));
			return;
		end

		local scp = _G[scpstr];
		if scp ~= nil then			
			scp();
		end

	elseif argNum == 1 then
		local scpstrlist = StringSplit(argStr, '/');
		if input_frame:GetText() == '0000' then
			scpstr = scpstrlist[1];
		elseif input_frame:GetText() == '1111' then
			scpstr = scpstrlist[2];
		else
			ui.SysMsg(ClMsg('miss_match_confirm_text'));
		end

		local scp = _G[scpstr];
		if scp ~= nil then			
			scp();
		end

	end

	IMC_LOG("INFO_NORMAL", "_WARNINGMSGBOX_FRAME_OPEN_NONNESTED_OK");

	ui.CloseFrame("warningmsgbox");
	ui.CloseFrame("item_tooltip");
end

-- 아이템 등급으로 체크하는 로직을 제거하여, 무조건 0000 입력 체크하도록 함
function WARNINGMSGBOX_FRAME_OPEN_WITH_CHECK(clmsg, yesScp, noScp)
	ui.OpenFrame("warningmsgbox")
	
	local frame = ui.GetFrame('warningmsgbox')
	frame:EnableHide(1);
	
	local warningText = GET_CHILD_RECURSIVELY(frame, "warningtext")
	warningText:SetText(clmsg)

    local input_frame = GET_CHILD_RECURSIVELY(frame, "input")
    input_frame:ShowWindow(1)
    input_frame:SetText('')

	local showTooltipCheck = GET_CHILD_RECURSIVELY(frame, "cbox_showTooltip")
	
	showTooltipCheck:ShowWindow(0)

	local_item_grade = 99 -- 기존 스크립트 이용하기 위한 조치
    
	local yesBtn = GET_CHILD_RECURSIVELY(frame, "yes")
	tolua.cast(yesBtn, "ui::CButton");

	input_frame:ShowWindow(1)            

	yesBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_YES');
	yesBtn:SetEventScriptArgString(ui.LBUTTONUP, yesScp);

	local noBtn = GET_CHILD_RECURSIVELY(frame, "no")
	tolua.cast(noBtn, "ui::CButton");

	noBtn:SetEventScript(ui.LBUTTONUP, '_WARNINGMSGBOX_FRAME_OPEN_NO');
	noBtn:SetEventScriptArgString(ui.LBUTTONUP, noScp)

	local buttonMargin = noBtn:GetMargin()
	local warningbox = GET_CHILD_RECURSIVELY(frame, 'warningbox')
	local totalHeight = warningbox:GetY() + warningText:GetY() + warningText:GetHeight() + showTooltipCheck:GetHeight() + noBtn:GetHeight() + 2 * buttonMargin.bottom + input_frame:GetHeight()

	local okBtn = GET_CHILD_RECURSIVELY(frame, "ok")
	tolua.cast(okBtn, "ui::CButton");

	yesBtn:ShowWindow(1);
	noBtn:ShowWindow(1);
	okBtn:ShowWindow(0);

	local bg = GET_CHILD_RECURSIVELY(frame, 'bg')
	warningbox:Resize(warningbox:GetWidth(), totalHeight)
	bg:Resize(bg:GetWidth(), totalHeight)
	frame:Resize(frame:GetWidth(), totalHeight)
end
