
function FIELDEVENT_ON_INIT(addon, frame)

	addon:RegisterMsg('RAISE_FIELD_EVENT', 'ON_RAISE_FIELDEVENT');   
	addon:RegisterMsg('FIELD_EVENT_PC_LIST', 'ON_FIELD_EVENT_LIST');
	addon:RegisterMsg('FIELDEVENT_START', 'ON_FIELDEVENT_START');
	addon:RegisterMsg('FIELDEVENT_OUT', 'ON_FIELD_EVENT_OUT');
	addon:RegisterMsg('FIELDEVENT_DESTROYED', 'ON_FIELDEVENT_DESTROYED');
	
end

function CREATE_FIELDEVENT_BTNS(frame)


end

function ON_FIELDEVENT_TIMECHECK(frame, msg, str, num)	
	frame:SetTextByKey("remainSec", math.floor(num / 1000));
end

function UPDATE_FIELDEVENT_TIME(frame, timer, argStr, argNum, elapsedTime)

	local remainSec = math.floor(  (argNum / 1000) - elapsedTime );
	local setText = remainSec; 
	if remainSec < 0 then 
		setText = 0; 
		frame:ShowWindow(0);
	end
	frame:SetTextByKey("remainSec", setText);
	
end

function TEST_FIELDEVENT_FRAME(frame)

	ON_RAISE_FIELDEVENT(frame, 1, 1, 1);
	ON_FIELD_EVENT_LIST(frame);
end

function FIELDEVENT_SET_GAME_PROP(frame, clsID, remainSec)
	
	frame:SetValue(clsID);	
	local cls = GetClassByType("FieldEvent", clsID);
	local gametitle = frame:GetChild("gametitle");
	
	if cls == nil then
		gametitle:SetText("");
	else
		gametitle:SetTextByKey("Title", cls.Name);
	end	
	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_FIELDEVENT_TIME");
	timer:SetArgNum(remainSec);
	timer:Start(0.2);
	
	frame:SetTextByKey("remainSec", math.floor(remainSec / 1000));
	
	local people = frame:GetChild("people");
	people:SetTextByKey("CurPlayer", 0);
	
	FIELDEVENT_UPDATE_PLAYER_CNT(frame);
	FIELDEVENT_UPDATE_REFUSE(frame);
	
	frame:ShowWindow(1);

end

function ON_RAISE_FIELDEVENT(frame, msg, type, remainSec)

	FIELDEVENT_SET_GAME_PROP(frame, type, remainSec);
	
end

function IS_REFUSE_TODAY()

	local pc = GetMyPCObject();
	local checked = 0;
	if pc.FEventRefuse == imcTime.GetCurdateNumber() then
		checked = 1;
	end
	
	return checked;

end

function FIELDEVENT_UPDATE_REFUSE(frame)

	local checked = IS_REFUSE_TODAY();
	local today_refuse = GET_CHILD(frame, "today_refuse", "ui::CCheckBox");
	today_refuse:SetCheck(checked);
	
end

function TOGGLE_TODAY_REFUSE(frame)

	local today_refuse = GET_CHILD(frame, "today_refuse", "ui::CCheckBox");
	local cur_cheked = today_refuse:IsChecked();
	control.CustomCommand("TOGGLE_REFUSE_FE", cur_cheked);
	
end

--[[
class FIELD_EVENT_PC
{
	CID		cid;
	const char	* name;
	int		job;
	int		level;
	int		slotNum;
};
]]

function GET_PC_GROUPBOX(frame)

	local listBox = frame:GetChild("list");
	tolua.cast(listBox, "ui::CGroupBox");
	return listBox;
	
end

function ON_FIELDEVENT_START(frame)

	local listBox = GET_PC_GROUPBOX(frame);
	listBox:DeleteAllControl();
	
	frame:ShowWindow(0);

end

function ON_FIELD_EVENT_OUT(frame)

	local listBox = GET_PC_GROUPBOX(frame);
	listBox:DeleteAllControl();
	FIELDEVENT_UPDATE_PLAYER_CNT(frame);
	
end

function ON_FIELDEVENT_DESTROYED(frame)

	local listBox = GET_PC_GROUPBOX(frame);
	listBox:DeleteAllControl();
	
	FIELDEVENT_UPDATE_PLAYER_CNT(frame);
end

function SET_EVENT_PC_CTRL_INFO(ctrl, info)

	tolua.cast(ctrl, "ui::CPicture");
	ctrl:ShowWindow(1);
	local portrait = GET_PORTRAIT_NAME(info.job, info.gender);
	ctrl:SetImage(portrait);
	ctrl:EnableHitTest(1);
	local jobCls = GetClassByType("Job", info.job);
	local tooltip = ScpArgMsg("Auto_{Auto_1}_:_LeBel_{Auto_2}_{Auto_3}","Auto_1", info.name, "Auto_2",info.level,"Auto_3", GET_JOB_NAME(jobCls, info.gender))
	ctrl:SetTextTooltip(tooltip);
	
end

function ON_FIELD_EVENT_LIST(frame)

	local list = session.GetFieldEventList();
	local cnt = list:Count();

	local listBox = GET_PC_GROUPBOX(frame);
	listBox:DeleteAllControl();
			
	local height = 40;
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		local ctrl = listBox:CreateControl("picture", "btn_" .. i, 10, (height + 5) * i ,200, height);
		SET_EVENT_PC_CTRL_INFO(ctrl, info);
	end
	
	listBox:UpdateData();
	FIELDEVENT_UPDATE_PLAYER_CNT(frame);

end

function FIELDEVENT_UPDATE_PLAYER_MAXCNT(frame)

	local people = frame:GetChild("people");
	local id = frame:GetValue();
	local cls = GetClassByType("FieldEvent", id);
	if cls ~= nil then
		people:SetTextByKey("MaxPlayer", cls.Player);
	end

end

function FIELDEVENT_UPDATE_PLAYER_CNT(frame)
	
	local list = session.GetFieldEventList();
	local cnt = list:Count();
	local people = frame:GetChild("people");
	people:SetTextByKey("CurPlayer", cnt);
	
	FIELDEVENT_UPDATE_PLAYER_MAXCNT(frame);
	
end

function JOIN_FIELD_EVENT(frame, ctrl, str, num)
	FIELD_EVENT_JOIN(frame);
end

function CLOSE_FIELDEVENT(frame)

	local list = session.GetFieldEventList();
	local cnt = list:Count();
	if cnt > 0 then
		packet.ReqOutFieldEvent();
	end
	
end
