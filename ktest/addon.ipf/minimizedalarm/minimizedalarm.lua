function MINIMIZEDALARM_ON_INIT(addon, frame)
	addon:RegisterMsg('PVP_PLAYING_UPDATE', 'ON_PVP_PLAYING_UPDATE'); 
	addon:RegisterMsg('PVP_MINE_STATE_UPDATE', 'ON_PVP_MINE_STATE_UPDATE'); 
	addon:RegisterMsg('GAME_START', 'ON_PVP_PLAYING_UPDATE'); 
end

function ON_PVP_PLAYING_UPDATE(frame, msg, argStr,argNum)
	local pvp_type = GET_PVP_TYPE()
	if pvp_type == "PVP_MINE" then
		local diff = PVP_MINE_GET_DIFF_TIME()
		local argStr = "None"
		if diff <= -900 then
			argStr = "HIDE"
		elseif diff <= -358 then
			argStr = "UNABLE"
		elseif diff <= 2 then
			argStr = "ENABLE"
		elseif diff <= 842 then
			argStr = "UNABLE"
		elseif diff <= 1202 then
			argStr = "ENABLE",1
		elseif diff <= 1800 then
			argStr = "SHOW",1
		end
		ON_PVP_MINE_STATE_UPDATE(frame,"",argStr,0)
	elseif pvp_type == "TEAM_BATTLE" then
		frame:ShowWindow(1);
		local pic = GET_CHILD_RECURSIVELY(frame,"pic")
		pic:SetEventScript(ui.LBUTTONUP,"OPEN_INDUNINFO_TAB_BY_ARG")
		pic:SetEventScriptArgString(ui.LBUTTONUP,"4")
		pic:SetEventScriptArgNumber(ui.LBUTTONUP,2)
	else
		frame:ShowWindow(0);
	end
end

function GET_PVP_TYPE()
	local diff = PVP_MINE_GET_DIFF_TIME()
	if diff > -900 and diff <= 1800 then
		return "PVP_MINE"
	end
	if true == IsHaveCommandLine("-NOPVP") then
		return nil
	end

	if session.IsMissionMap() == true then
		return nil
	end
	
	if IS_TEAM_BATTLE_ENABLE() == 1 then
		return "TEAM_BATTLE"
	end
	return nil
end

function IS_ON_PVP()
	if true == IsHaveCommandLine("-NOPVP") then
		return false
	end

	if session.IsMissionMap() == true then
		return false
	end
	local diff = PVP_MINE_GET_DIFF_TIME()
	if diff > -900 and diff <= 1800 then
		return true
	end
	local cnt = session.worldPVP.GetPlayTypeCount();
	if cnt == 0 then
		return false
	end
	return true;
end

function ON_PVP_MINE_STATE_UPDATE(frame,msg,argStr,argNum)
	local pic = GET_CHILD_RECURSIVELY(frame,"pic")
	if argStr == "SHOW" then
		pic:SetEnable(0)
		frame:ShowWindow(1)
		pic:SetEventScript(ui.LBUTTONUP,"OPEN_INDUNINFO_TAB_BY_ARG")
		pic:SetEventScriptArgString(ui.LBUTTONUP,"4")
		pic:SetEventScriptArgNumber(ui.LBUTTONUP,1)
	elseif argStr == "ENABLE" then
		frame:ShowWindow(1)
		pic:SetEnable(1)
		pic:SetEventScript(ui.LBUTTONUP,"OPEN_INDUNINFO_TAB_BY_ARG")
		pic:SetEventScriptArgString(ui.LBUTTONUP,"4")
		pic:SetEventScriptArgNumber(ui.LBUTTONUP,1)
	elseif argStr == "UNABLE" then
		frame:ShowWindow(1)
		pic:SetEnable(0)
	elseif argStr == "HIDE" then
		frame:ShowWindow(0)
	end
end

function OPEN_INDUNINFO_TAB_BY_ARG(parent,ctr,argStr,argNum)
	local indunInfoFrame = ui.GetFrame('induninfo')
	indunInfoFrame:ShowWindow(1)
	local tab = GET_CHILD_RECURSIVELY(indunInfoFrame,'tab')
	tab:SelectTab(tonumber(argStr))
	INDUNINFO_TAB_CHANGE(indunInfoFrame,indunInfoFrame)
	INDUNINFO_SELECT_CATEGORY(argNum)
end

function WORLDPVP_START_ICON_NOTICE(enable)
	if IS_IN_EVENT_MAP() == true then
		return;
	end

	local frame = ui.GetFrame("minimizedalarm");
	if enable == 1 then
		frame:ShowWindow(1);
		local pic = GET_CHILD_RECURSIVELY(frame,"pic")
		UI_PLAYFORCE(pic, "emphasize_pvp", 0, 0);
	else
		frame:ShowWindow(0);
	end
end

function PVP_MINE_INDUN_INFO_OPEN(frame)
	local frame = ui.GetFrame('induninfo')
	frame:ShowWindow(1)
	local tab = GET_CHILD_RECURSIVELY(frame,"tab")
	tab:SelectTab(4)
	PVP_INDUNINFO_UI_OPEN(frame)
end