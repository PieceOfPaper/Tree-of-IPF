---- lib_ui.lua

function REGISTERR_LASTUIOPEN_POS(frame) --pc_command.lua�� �̸� ������ ����ص־� ��

	local text = string.format("/lastuiopenpos %s",frame:GetName());
	ui.Chat(text);
	frame:RunUpdateScript("LASTUIOPEN_CHECK_PC_POS", 1);

end

function UNREGISTERR_LASTUIOPEN_POS(frame)

	frame:StopUpdateScript("LASTUIOPEN_CHECK_PC_POS");

end

function RUN_CHECK_LASTUIOPEN_POS(frame)

	frame:RunUpdateScript("LASTUIOPEN_CHECK_PC_POS", 1);
end


function LASTUIOPEN_CHECK_PC_POS(frame, totalElapsedTime)

	local etc = GetMyEtcObject();
	
	if etc == nil then
		return
	end
	local mapname, x, y, z, uiname = GET_LAST_UI_OPEN_POS(etc)

	if mapname == nil then
		return 0;
	end

	local myActor = GetMyActor();	
	local nowpos = myActor:GetPos();

	if uiname ~= frame:GetName() or GET_2D_DIS(x,z,nowpos.x,nowpos.z) > 100 or session.GetMapName() ~= mapname then
		ui.CloseFrame(frame:GetName())
		return 0
	end

	return 1

end

function FUNC_TO_CHILD(frame, func, ...)
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		func(child, ...);
	end

end

function FUNC_TO_CHILD_RECURSIVE(frame, func, ...)
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		func(child, ...);
		FUNC_TO_CHILD_RECURSIVE(child, func, ...);
	end

end

function FUNC_TO_CHILD_BYNAME(frame, searchname, func, ...)
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		if string.find(child:GetName(), searchname) ~= nil then
			func(child, ...);
		end
	end

end

function SET_COLORTONE_RECURSIVE(ctrl, tone)
	FUNC_TO_CHILD_RECURSIVE(ctrl, SET_COLORTONE, tone);
end

function SET_COLORTONE(ctrl, val)
	ctrl:SetColorTone(val);
end

function SHOW_CHILD_LIST(frame, isVisible)
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		child:ShowWindow(isVisible);
	end

end

function SHOW_CHILD_BY_NAME(frame, name, isVisible)
	local c = frame:GetChild(name);
	if c ~= nil then
		c:ShowWindow(isVisible);
	end
end

function SET_CHILD_TEXT_BY_KEY(frame, childName, key, value)
	local child = frame:GetChild(childName);
	if child ~= nil then
		child:SetTextByKey(key, value);
	end
end

function GET_CHILD_CNT_BYNAME(frame, searchname)
	local searchCount = 0;
	local cnt = frame:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = frame:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, searchname) ~= nil then
			searchCount = searchCount + 1;
		end
	end
	return searchCount;
end

function SHOW_CHILD(frame, name, isVisible)

	local child = frame:GetChild(name);
	if child ~= nil then
		child:ShowWindow(isVisible);
	end

end

function SHOW_CHILD_BYNAME(frame, searchname, isVisible)
	local cnt = frame:GetChildCount();
	for  i = 0, cnt -1 do
		local slot = frame:GetChildByIndex(i);
		local name = slot:GetName();
		if string.find(name, searchname) ~= nil then
			slot:ShowWindow(isVisible);
		end
	end
end

function HIDE_CHILD_BYNAME(frame, searchname)
	if frame == nil then
		return;
	end

	SHOW_CHILD_BYNAME(frame, searchname, 0);
end


function HIDE_CHILD(frame, name)
	local chl = frame:GetChild(name);
	if chl ~= nil then
		chl:ShowWindow(0);
	end
end

--다른 유저 숙소 방문시에는 [캐릭 생성, 삭제, 숙소 이동, ▲, ▼, 로그아웃, 게임종료] 버튼 숨김
function SHOW_BTNS(frame, onoff)
	local createCharBtn = GET_CHILD_RECURSIVELY(frame, "button_new_char")
	local deleteCharBtn = GET_CHILD_RECURSIVELY(frame, "button_char_del")
	local barrackChangeBtn = GET_CHILD_RECURSIVELY(frame, "button_barrack_change")
	local upBtn = GET_CHILD_RECURSIVELY(frame, "button_up")
	local downBtn = GET_CHILD_RECURSIVELY(frame, "button_down")
	createCharBtn:ShowWindow(onoff);
	deleteCharBtn:ShowWindow(onoff);
	barrackChangeBtn:ShowWindow(onoff)
	upBtn:ShowWindow(onoff)
	downBtn:ShowWindow(onoff)


	local exitFrame = ui.GetFrame("barrack_exit")
	local logoutBtn = GET_CHILD_RECURSIVELY(exitFrame, "logout")
	local exitBtn = GET_CHILD_RECURSIVELY(exitFrame, "exit")
	logoutBtn:ShowWindow(onoff)
	exitBtn:ShowWindow(onoff)
end

function DESTROY_CHILD_BYNAME_EXCEPT(frame, searchname, exceptName)
	local index = 0;
	while 1 do
		if index >= frame:GetChildCount() then
			break;
		end

		local childObj = frame:GetChildByIndex(index);
		local name = childObj:GetName();

		if string.find(name, searchname) ~= nil and name ~= exceptName then
			frame:RemoveChildByIndex(index);
		else
			index = index + 1;
		end
	end

end

function ADDYPOS_CHILD_BYNAME(frame, searchname, addpos)
	local index = 0;
	while 1 do
		if index >= frame:GetChildCount() then
			break;
		end

		local childObj = frame:GetChildByIndex(index);
		local name = childObj:GetName();

		if string.find(name, searchname) ~= nil then
			childObj:SetOffset(childObj:GetX(),childObj:GetY() + addpos)
		end

		index = index + 1;
	end
end

function DESTROY_CHILD_BYNAME(frame, searchname)
	local index = 0;
	while 1 do
		if index >= frame:GetChildCount() then
			break;
		end

		local childObj = frame:GetChildByIndex(index);
		local name = childObj:GetName();
		if string.find(name, searchname) ~= nil then
			frame:RemoveChildByIndex(index);
		else
			index = index + 1;
		end
	end
end

function PRINT_CHILD(frame)
	local cnt = frame:GetChildCount();
	print(frame:GetName() .. " ChildCount : ".. cnt);
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		print(child:GetName() .. " " .. i);
	end

end

function GET_CHILD_MAX_Y(ctrl)
	local maxY = 0;
	local cnt = ctrl:GetChildCount();
	for i = 0, cnt - 1 do
		local child = ctrl:GetChildByIndex(i);
		local y = child:GetY() + child:GetHeight();
		if y > maxY then
			maxY = y;
		end
	end

	return maxY;
end

function SET_TEXT(parentCtrl, textCtrlName, key, value)
	local ctrl = GET_CHILD(parentCtrl, textCtrlName, "ui::CRichText");
	ctrl:SetTextByKey(key, value);
end
function GET_CHILD(frame, name, typeName)

	if frame == nil then
		return nil;
	end	
	
	local ctrl = frame:GetChild(name);
	if ctrl == nil then
		--[[
		DumpCallStack();
		local topframe = frame:GetTopParentFrame();
		print("Warning : Can not Found child ["..name.."] in ["..frame:GetName().."] object. (frame : ["..topframe:GetName().."])")
		]]
		return nil
	end
	if typeName == nil then
		tolua.cast(ctrl, ctrl:GetClassString());
	else
		tolua.cast(ctrl, typeName);
	end
	return ctrl;

end

function GET_CHILD_RECURSIVELY_AT_TOP(frame, name)
	local frame = frame:GetTopParentFrame();

	if frame == nil then
		DumpCallStack();
	end	

	local ctrl = frame:GetChildRecursively(name);
	tolua.cast(ctrl, ctrl:GetClassString());
	return ctrl;

end

function GET_CHILD_RECURSIVELY(frame, name)
	if frame == nil then
		DumpCallStack();
	end	

	local ctrl = frame:GetChildRecursively(name);

	if ctrl == nil then
		return nil;
	end
	
	tolua.cast(ctrl, ctrl:GetClassString());
	return ctrl;

end

function AUTO_CAST(ctrl)
	ctrl = tolua.cast(ctrl, ctrl:GetClassString());
	return ctrl;
end

function GET_PARENT(ctrl)

	local ctrl = ctrl:GetParent();
	tolua.cast(ctrl, ctrl:GetClassString());
	return ctrl;

end

function GETXYWH(ctrl)

	local x = ctrl:GetX();
	local y = ctrl:GetY();
	local w = ctrl:GetWidth();
	local h = ctrl:GetHeight();

	return x, y, w, h;

end

function GET_XYWH(ctrl)

	local x = ctrl:GetOffsetX();
	local y = ctrl:GetOffsetY();
	local w = ctrl:GetWidth();
	local h = ctrl:GetHeight();

	return x, y, w, h;

end

function GET_XY(ctrl)

	local x = ctrl:GetOffsetX();
	local y = ctrl:GetOffsetY();
	return x, y;

end

function GET_C_XY(ctrl)

	local x = ctrl:GetX();
	local y = ctrl:GetY();
	return x, y;

end

function GET_WH(ctrl)

	local w = ctrl:GetWidth();
	local h = ctrl:GetHeight();

	return w, h;

end

function IS_IN_RECT(x, y, tx, ty, tw, th)

	local tlx = tx + tw;
	local tly = ty + th;

	if x < tx or x > tlx or y < ty or y > tly then
		return 0;
	end

	return 1;
end


function GET_GLOBAL_XY(ctrl)

	if ctrl == nil then
		return 0, 0;
	end

	local x = ctrl:GetGlobalX();
	local y = ctrl:GetGlobalY();
	return x, y;
end

function GET_UI_FORCE_POS(slot)

	return slot:GetDrawX() + slot:GetWidth() / 2 , slot:GetDrawY() + slot:GetHeight() / 2;

end

function GET_SCREEN_XY(ctrl, xmargin, ymargin)
	local x, y = GET_GLOBAL_XY(ctrl);
	local frame = ctrl:GetTopParentFrame();
    if xmargin ~= nil then
    	x = x + xmargin
    end
    if ymargin ~= nil then
    	y = y + ymargin
    end

	x = x + (ctrl:GetWidth() / 2);
	y = y + (ctrl:GetHeight() / 2);
	local pos = frame:FramePosToScreenPos(x, y)

	return pos.x, pos.y;
end

function GET_LOCAL_MOUSE_POS(ctrl)

	local topFrame = ctrl:GetTopParentFrame();
	local pt = topFrame:ScreenPosToFramePos(mouse.GetX(), mouse.GetY());
	local x = pt.x - ctrl:GetGlobalX();
	local y = pt.y - ctrl:GetGlobalY();
	return x, y;

end

function SET_EVENT_SCRIPT_RECURSIVELY(frame, type, funcName)
    local byFullString = string.find(funcName, '%(') ~= nil;
	frame:SetEventScript(type, funcName, byFullString);
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local child = frame:GetChildByIndex(i);
		SET_EVENT_SCRIPT_RECURSIVELY(child, type, funcName);
	end
end

function CLOSE_UI(frame, ctrl, numsttr, numarg)

	frame:ShowWindow(0);

end

function CLOSE_AND_OPEN_UI(frame, ctrl, argStr, numarg)

	frame:ShowWindow(0);
	ui.OpenFrame(argStr);

end

function GET_WORLDMAP_POSITION(worldMapString)
	local sList = StringSplit(worldMapString, "/");
	local sListCnt = #sList;
	local firstStr = "None";
	local dir = 0;
	local x = 0;
	local y = 0;
	local index = 0;
	if sListCnt >= 4 then
		dir = sList[1];
		x = sList[2];
		y = sList[3];
		index = sList[4];
	else
				dir = 's';
				x = sList[1];
				y = sList[2];
				index = sList[3];
			end

			return x, y, dir, index;
end

function GET_REMAIN_LIFE_TIME(lifeTime)
    local sysTime = geTime.GetServerSystemTime();
	local endTime = imcTime.GetSysTimeByStr(lifeTime);
	local difSec = imcTime.GetDifSec(endTime, sysTime);

    return difSec;
end

function GET_OFFSET_IN_SCREEN(x, y, width, height)
    return x, y;
end

function GET_CONFIG_HUD_OFFSET(frame, defaultX, defaultY)
    local name = frame:GetName();
    if config.IsExistHUDConfig(name) ~= 1 then
        return defaultX, defaultY;
    end
    local x = math.floor(config.GetHUDConfigXRatio(name) * ui.GetClientInitialWidth());
    local y = math.floor(config.GetHUDConfigYRatio(name) * ui.GetClientInitialHeight());

    -- clamping
    local width = option.GetClientWidth() - frame:GetWidth();
    local height = option.GetClientHeight() - frame:GetHeight();
    x = math.max(0, x);
    x = math.min(x, width);
    y = math.max(0, y);
    y = math.min(y, height);
    return x, y;
end

function SET_CONFIG_HUD_OFFSET(frame)
    local x = frame:GetX();
    local y = frame:GetY();
    local pos = frame:FramePosToScreenPos(x, y);
    x = pos.x;
    y = pos.y;
    
    local name = frame:GetName();
    local width = option.GetClientWidth();
    local height = option.GetClientHeight(); 

    config.SetHUDConfigRatio(name, x / width, y / height);
end

function SHOW_GUILD_HTTP_ERROR(code, msg, funcName)
	local errNamePrefix = 'WebService_';
	local errName = errNamePrefix;
	if code == '0' then
		 -- 클라<->웹서버가 아닌 클라<->존<->웹서버 경유해서 갔을때 웹서버가 다운된 상태인 경우, 
		 -- 존에서 RunClientScript사용해서 클라로 보내주고, 코드에는 문자열로 "0"을 전달해줌
		ShowErrorInfoMsg('CannotConnectWebServer');
		return
	end 
	if code == nil then
		local splitmsg = StringSplit(msg, " ");
		code = splitmsg[1];
		errName = errName .. code
		local errString = "code:" .. code .. ", msg:" .. msg .. ", funcName:" .. funcName .. " errName:" ..  ClMsg(errName);
		IMC_LOG("ERROR_WEBSERVICE_SCRIPT", errString)
		ShowErrorInfoMsg('CannotConnectWebServer');
		return
	end
	local splitStr = StringSplit(msg, " ");
	errName = errName .. splitStr[1];
	local errString = "code:" .. code .. ", msg:" .. msg .. ", funcName:" .. funcName .. " errName:" ..  ClMsg(errName);
	IMC_LOG("ERROR_WEBSERVICE_SCRIPT", errString)
	
	if errName == errNamePrefix then
		ShowErrorInfoMsg('CannotConnectWebServer');
	else
	ui.MsgBox(ClMsg(errName));
end
end

function GET_JOB_MAX_CIRCLE(jobcls)
	local maxCircle = TryGetProp(jobcls, "MaxCircle")	
	if maxCircle ~= nil then
		return maxCircle;
	end
	return 1;
end

function SET_FRAME_OFFSET_TO_RIGHT_TOP(frame, targetFrame)
    local x = targetFrame:GetGlobalX()+targetFrame:GetWidth();
    local y = targetFrame:GetGlobalY();

    if x > ui.GetClientInitialWidth()-frame:GetWidth() then
        x = ui.GetClientInitialWidth()-frame:GetWidth();
    end
    frame:SetOffset(x, y)
end

imcRichText = {
	SetColorBlend = function(self, richtext, isStart, blendTime, color1, color2)
		richtext:StopColorBlend();
		if isStart == false then
			return;
		end
		richtext:SetColorBlend(blendTime, color1, color2, true);
	end,
};

function QUICKSLOT_MAKE_GAUGE(slot)
	local x = 2;
	local y = slot:GetHeight() - 11;
	local width  = 45;
	local height = 10;
	local gauge = slot:MakeSlotGauge(x, y, width, height);
	gauge:SetDrawStyle(ui.GAUGE_DRAW_CELL);
	gauge:SetSkinName("dot_skillslot");
end