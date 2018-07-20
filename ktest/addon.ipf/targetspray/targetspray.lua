
function TARGETSPRAY_ON_INIT(addon, frame)


	addon:RegisterMsg("TARGET_SPRAY", "ON_TARGET_SPRAY");
	addon:RegisterMsg("UNTARGET_SPRAY", "ON_UNTARGET_SPRAY");
	addon:RegisterMsg("UPDATE_SPRAY", "ON_UPDATE_SPRAY");
	addon:RegisterMsg("LIKE_LIST", "ON_LIKE_LIST");
	
	
end
	
function TARGETSPRAY_CREATE(addon, frame)

	local set = CREATE_TIMER_CTRLS(frame, 20, -20);
	set:SetGravity(ui.LEFT, ui.BOTTOM);
	
	local timer = GET_CHILD(frame, "keychecker", "ui::CAddOnTimer");
	timer:SetUpdateScript("PROCESS_TARGETSP_KEY");
	timer:Start(0.01);
	
end

function PROCESS_TARGETSP_KEY(frame)

	if keyboard.IsKeyDown("1") == 1 then

		local obj = world.GetTarget();
		if obj == nil then
			return;
		end
		
		control.CustomCommand("LIKE_SPRAY", obj:GetHandleVal());
				
	elseif keyboard.IsKeyDown("2") == 1 then
		
	elseif keyboard.IsKeyDown("3") == 1 then
		
		local obj = world.GetTarget();
		if obj == nil then
			return;
		end
		
		control.CustomCommand("PRESERVE_SPRAY", obj:GetHandleVal());
		
	elseif keyboard.IsKeyDown("4") == 1 then
	
		local obj = world.GetTarget();
		if obj == nil then
			return;
		end
		
		local yesScp = string.format("EXEC_DELETE_COLSPRAY(%d)", obj:GetHandleVal());
		ui.MsgBox(ClientMsg(10232), yesScp, "None");
		
	end

end

function EXEC_DELETE_COLSPRAY(handle)

	control.CustomCommand("DELETE_SPRAY", handle);

end

function ON_UPDATE_SPRAY(frame)

	if frame:IsVisible() == 0 then
		return;
	end
	
	local obj = world.GetTarget();
	if obj == nil then
		return;
	end
	
	UPDATE_SPRAY_FRAME(frame, obj);
	
end

function ON_TARGET_SPRAY(frame, msg, str, num, pobj)

	pobj = tolua.cast(pobj, "CNormalObject");
	UPDATE_SPRAY_FRAME(frame, pobj);
	frame:ShowWindow(1);
	
end

function VIEW_LIKERS(handle)

	control.CustomCommand("VIEW_LIKE_LIST", handle, 1);

end

function UPDATE_SPRAY_FRAME(frame, pobj)

	local set = frame:GetChild("SET");
	
	TIMER_SET_EVENTTIMER(frame, pobj:GetMonsterLifeTime());
	local drawerName  = pobj:GetUniqueName();
	frame:GetChild("title"):SetTextByKey("ownername", drawerName); 
	
	local likeStr = "";
	if pobj:GetValue() > 0 then
		likeStr =  ScpArgMsg("Auto_{@s16}{ol}{Auto_1}oe_{a_VIEW_LIKERS_{Auto_2}}{ul}{#8888FF}{Auto_3}Myeong{/}{/}{/}i_JohaHapNiDa.{/}","Auto_1", pobj:GetSValue(), "Auto_2",pobj:GetHandleVal(),"Auto_3", pobj:GetValue() );
	end
	
	frame:GetChild("liker"):SetText(likeStr);
	
	if GetMyName() == drawerName then
		frame:GetChild("my_btns"):ShowWindow(1);
		
		if frame:GetValue() == 1 then
			frame:Resize(frame:GetWidth(), 320);
			frame:MoveFrame(frame:GetX(), frame:GetY() - 100);
			frame:SetValue(0);
		end
	else
		frame:GetChild("my_btns"):ShowWindow(0);
		
		if frame:GetValue() == 0 then
			frame:Resize(frame:GetWidth(), 220);
			frame:MoveFrame(frame:GetX(), frame:GetY() + 100);
			frame:SetValue(1);
		end
		
	end

end


function ON_UNTARGET_SPRAY(frame, msg, str, num, pobj)

	frame:ShowWindow(0);
	ui.CloseFrame("sprayliker");

end


function ON_LIKE_LIST(frame)

	local likeFrame = ui.GetFrame("sprayliker");
	VIEW_SPRAY_LIKER(likeFrame);
	
end






