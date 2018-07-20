
function MINIGAMEEVENT_ON_INIT(addon, frame)

	addon:RegisterMsg('RAISE_MINIGAME_EVENT', 'ON_RAISE_MINIGAMEEVENT');   
	addon:RegisterMsg('MINIGAME_EVENT_PC_LIST', 'ON_MINIGAME_EVENT_LIST');
	addon:RegisterMsg('MINIGAMEEVENT_START', 'ON_MINIGAMEEVENT_START');
	addon:RegisterMsg('MINIGAMEEVENT_OUT', 'ON_MINIGAME_EVENT_OUT');
	addon:RegisterMsg('MINIGAMEEVENT_DESTROYED', 'ON_MINIGAMEEVENT_DESTROYED');
	
end

function CREATE_MINIGAMEEVENT_BTNS(frame)

end

function ON_MINIGAMEEVENT_TIMECHECK(frame, msg, str, num)	

end

function UPDATE_MINIGAMEEVENT_TIME(frame, timer, argStr, argNum, elapsedTime)

	local remainSec = math.floor(argNum - elapsedTime);
	local setText = remainSec; 
	if remainSec < 0 then 
		setText = 0; 
		frame:ShowWindow(0);
	end
	frame:SetTextByKey("remainSec", setText);

end

function TEST_MINIGAMEEVENT_FRAME(frame)

end

function MINIGAMEEVENT_SET_GAME_PROP(frame, clsID, remainSec)

end

function ON_RAISE_MINIGAMEEVENT(frame, msg, remainSec, joinCount)

	frame:SetTextByKey("remainSec", math.floor(remainSec));
	frame:SetTextByKey("CurPlayer", math.floor(0));
	frame:SetTextByKey("MaxPlayer", math.floor(joinCount));

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_MINIGAMEEVENT_TIME");
	timer:SetArgNum(remainSec);
	timer:Start(0.2);

	frame:ShowWindow(1);

end

function IS_REFUSE_TODAY()

end

function MINIGAMEEVENT_UPDATE_REFUSE(frame)

end

function TOGGLE_TODAY_REFUSE(frame)

end

function GET_PC_GROUPBOX(frame)

end

function ON_MINIGAMEEVENT_START(frame)

end

function ON_MINIGAME_EVENT_OUT(frame)
	
end

function ON_MINIGAMEEVENT_DESTROYED(frame)

end

function SET_EVENT_PC_CTRL_INFO(ctrl, info)
	
end

function ON_MINIGAME_EVENT_LIST(frame, msg, joinCount)

	frame:SetTextByKey("CurPlayer", math.floor(joinCount));

end

function MINIGAMEEVENT_UPDATE_PLAYER_MAXCNT(frame)

end

function MINIGAMEEVENT_UPDATE_PLAYER_CNT(frame)
	
end

function JOIN_MINIGAME_EVENT(frame, ctrl, str, num)
	local stat = info.GetStat(session.GetMyHandle());
	if stat.HP > 0 then
		packet.ReqJoinMiniGameEvent();		
	end
end

function CLOSE_MINIGAMEEVENT(frame)

end