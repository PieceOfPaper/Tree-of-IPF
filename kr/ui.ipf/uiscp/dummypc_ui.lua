-- dummypc_ui.lua


function POPUP_DUMMY(handle, targetInfo)    
	local context = ui.CreateContextMenu("DPC_CONTEXT", targetInfo.name, 0, 0, 100, 100);
	
	local ownerHandle = info.GetOwner(handle);
	local myHandle 		= session.GetMyHandle();

	local strscp = string.format("PROPERTY_COMPARE(%d)", handle);
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_SalPyeoBoKi"), strscp);


--  매입의뢰상점후 핼퍼 고용 메시지 제거	
--	if ownerHandle == 0 then
--		strscp = string.format("DUMMYPC_HIRE(%d)", handle);
--		ui.AddContextMenuItem(context, ScpArgMsg("Auto_yongByeongKoyong"), strscp);
--
--	elseif ownerHandle == myHandle then
--		strscp = string.format("dummyPC.Fire(%d)", handle);
--		ui.AddContextMenuItem(context, ScpArgMsg("Auto_yongByeongHaeKo"), strscp);
--	end

	if 1 == session.IsGM() then        
		strscp = string.format("debug.TestE(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}NodeBoKi{/}"), strscp);
		strscp = string.format("ui.Chat(\"//killmon %d\")", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_JeKeo"), strscp)
        ui.AddContextMenuItem(context, ScpArgMsg("GM_Order_Kick"), string.format("REQUEST_ORDER_DUMMY_KICK(\"%s\")", handle))
	end

	if session.world.IsIntegrateServer() == false then
		strscp = string.format("barrackNormal.Visit(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("VisitBarrack"), strscp);
	end

	ui.AddContextMenuItem(context, ScpArgMsg("Auto_DatKi"),  "")	
	ui.OpenContextMenu(context)
end

function REQUEST_ORDER_DUMMY_KICK(handle)
    packet.RequestGmOrderDummyKick(tonumber(handle))
end

function DUMMYPC_SHOWINFO(handle)

	local execString = string.format("_DUMMYPC_SHOWINFO(%d)", handle);
	if 0 == dummyPC.CheckHaveInfo(handle, execString) then
		return;
	end

	_DUMMYPC_SHOWINFO(handle);
end

function _DUMMYPC_SHOWINFO(handle)
	STATUS_DPC_SHOW_INFO(handle);
end

function DUMMYPC_HIRE(handle)

	local execString = string.format("_DUMMPC_HIRE(%d)", handle);
	if 0 == dummyPC.CheckHaveInfo(handle, execString) then
		return;
	end

	_DUMMPC_HIRE(handle);

end

function _DUMMPC_HIRE(handle)

	local dpcInfo = dummyPC.GetInfo(handle);
	if dpcInfo == nil then
		return;
	end

	local dpc = GetIES(dpcInfo:GetObject());
	local pc = GetCommanderPC();

	local yesScp = string.format("dummyPC.Hire(%d)", handle);
	local targetinfo = info.GetTargetInfo(handle);

	local price = math.floor(GET_DPC_HIRE_PRICE(pc, dpc));
	ui.MsgBox(ScpArgMsg("Auto_yongByeongeul_KoyongHaKessSeupNiKka?{nl}1BunDang_SoBi_MeDal{nl}_{img_medal_32_32}_") .. price..ScpArgMsg("Auto__SoBi"), yesScp, "None");
	
end



