function QUIT_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('PC_MACRO_UPDATE', 'QUIT_UPDATE_MACROLIST');
 	
	addon:RegisterMsg("RULLET_LIST", "ON_RULLET_LIST");
	addon:RegisterMsg("OPEN_DLG_WAREHOUSE", "ON_OPEN_WAREHOUSE");
		
		
	addon:RegisterMsg("EVENT_TIMER", "ON_EVENT_TIMER");
	addon:RegisterMsg("FAIL_EVENT", "ON_FAIL_EVENT");
	addon:RegisterMsg("CLOSE_TIMER", "ON_CLOSE_TIMER");
	addon:RegisterMsg("TARGET_CART", "CREATE_TARGETCART");
	addon:RegisterMsg("TARGET_SPRAY", "CREATE_TARGETSPRAY");
	
	addon:RegisterMsg('GOLEM_REVIVE', 'ON_GOLEM_REVIVE');
	addon:RegisterMsg('MEDAL_RECEIVED', 'ON_MEDAL_RECEIVED');
	addon:RegisterMsg('MEDAL_PRESENTED', 'ON_MEDAL_PRESENTED');
end 

function ON_EVENT_TIMER(frame, msg, str, sec)

	START_EVENT_TIMER(sec, str);

end

function ON_FAIL_EVENT(frame)

	CLOSE_TIMER(frame);
	
end

function CLOSE_TIMER(frame)

	ui.CloseFrame("eventtimer");
	
end

function QUIT_FIRST_OPEN(frame)

	QUIT_UPDATE_MACROLIST(frame);
	
end

function QUIT_OPEN(frame)	
	ui.CloseFrame("pcmacro");
	ui.CloseUI(0);
	ui.OpenFrame("quitmask");
	local quitMaskFrame = ui.GetFrame("quitmask");
	quitMaskFrame:SetAlpha(1, 0, 80, -0.3, "QUIT_ALPHA_BLEND_END");
end

function QUIT_ALPHA_BLEND_END()

end

function CLOSE_QUIT_FRAME(frame)	
	ui.CloseFrame("quitmask");
	ui.CloseFrame("quit");
	ui.CloseFrame("config");
	ui.CloseUI(1);
end

function OPEN_CONFIG_FRAME(frame)
	--frame:ShowWindow(0);
	ui.CloseFrame("quitmask");
	--ui.OpenFrame("config");	
	ui.OpenFrame("systemoption");
end

function QUIT_UPDATE_MACROLIST(frame)

	--[[local condbox = frame:GetChild("AdvBox");
	tolua.cast(condbox, "ui::CAdvListBox");
	condbox:ClearUserItems();
	
	local list = session.GetEditSetList();
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
	
		local set = list:Element(i);
		local macroname = set.macroname;
		
		condbox:SetItem(macroname, 0, macroname, "white_16_ol");
		
		local editbtn = condbox:SetItemByType(macroname, 1, "button", 28, 22, 0);
		tolua.cast(editbtn, "ui::CButton");
		editbtn:SetImage("close_button");
		editbtn:SetLBtnUpScp("EDIT_MACRO_BY_NAME");
		editbtn:SetLBtnUpArgStr(macroname);
		
		local cbtn = condbox:SetItemByType(macroname, 2, "button", 28, 22, 0);
		tolua.cast(cbtn, "ui::CButton");
		cbtn:SetImage("close_button");
		cbtn:SetLBtnUpScp("REMOVE_MACRO_BY_NAME");
		cbtn:SetLBtnUpArgStr(macroname);
	
	end ]]--

end

function REMOVE_MACRO_BY_NAME(frame, ctrl, argstr, argnum)

	frame = frame:GetTopParentFrame();
	pcmacro.RemovePCMacroSet(argstr);
	QUIT_UPDATE_MACROLIST(frame);
	return 1;

end

function EDIT_MACRO_BY_NAME(frame, ctrl, argstr, argnum)

	ui.CloseFrame('quit');

	local pcmacro = ui.GetFrame('pcmacro');
	name = pcmacro:GetChild("input");
	tolua.cast(name, "ui::CEditControl");
	name:SetText(argstr);
	name:SetEnable(0);
	
	local macro = session.GetMacroByName(argstr);
	local editmacro = session.GetEditingPCMacro();
	macro:CopyTo(editmacro);
	local pcmacro = ui.GetFrame('pcmacro');
	REFRESH_PCMACRO(pcmacro);
	pcmacro:ShowWindow(1);
	

end

function NEW_PC_MACRO(frame)
	
	ui.CloseFrame('quit');
	
	local editmacro = session.GetEditingPCMacro();
	session.ResetMacro(editmacro);
	local pcmacro = ui.GetFrame('pcmacro');
	name = pcmacro:GetChild("input");
	tolua.cast(name, "ui::CEditControl");
	name:SetText("");
	name:SetEnable(1);
	pcmacro:ShowWindow(1);
	REFRESH_PCMACRO(pcmacro);

end


function DDDD1D(handle)

	local frame = ui.GetFrame("bossclear");
	local obj = world.GetObject(handle);
	UI_BOSS_CLEAR(frame, nil, handle, obj:GetType());

end

function CHANGE_SCALE(handle)

	local obj = world.GetObject(handle);
	obj:ChangeScale(3.0, 3.0);

end

function TEST_PLAYANIM(handle)

	movie.PlayAnim(handle, "DEAD", 1.0);

end

function TEST_THROW(handle)

	local mobj = GetMyActor();
	local pos = mobj:GetPos();
	
	debug.ForceMoveToJump(handle, pos);
	--print(handle);
	

end

function TEST_MOVE_COBJ(handle)

	local c = world.GetActor(handle);
	local vv = c:GetPos();	
	vv.z = vv.z + 50;
	c:SetPos(vv);

end

function EXEC_IES_MANAGE(idSpace, type)

	local obj = GetClassByType(idSpace, type);
	
	local frame = ui.GetFrame("iesmanager");
	frame:ShowWindow(1);
	IES_MANAGE_BY_TYPE(frame, idSpace, type);

end

function ON_OPEN_WAREHOUSE(frame)
	
	local warehouse = ui.GetFrame("warehouse");
	ON_WAREHOUSE_ITEM_LIST(warehouse);
	warehouse:ShowWindow(1);

end

function CREATE_TARGETCART(frame)

	local fr = ui.GetFrame("targetcart");

end

function CREATE_TARGETSPRAY(frame)

	local fr = ui.GetFrame("targetspray");

end

function ON_GOLEM_REVIVE(frame, msg, handle, time)

	direct.GolemMovie(tonumber(handle), time);

end

