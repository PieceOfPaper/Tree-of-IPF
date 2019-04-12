---- ui_effect_lib.lua --

UI_UPDATE_STOP = 0;
UI_UPDATE_CONTINUE = 1;
UI_UPDATE_DESTROY = 2;
TYPE_REINFORCEMENT = nil;

function UI_EFFECT_GET_NAME(frame, key)
	if key == nil then
		key = "_CTRL_";
	end

	local cnt = frame:GetUserIValue("_CNT");
	local name = key .. cnt;
	cnt = cnt + 1;
	frame:SetUserValue("_CNT", cnt);
	return name;
end

function UI_FORCE(forceName, fx, fy, tx, ty, delayTime, changeImage, imgSize, type)	
	if forceName == 'reinf_result_' then
		TYPE_REINFORCEMENT = type
	end
	
	if changeImage == nil then
		changeImage = "";
	end

	if tx == nil then
		tx = fx;
	end

	if ty == nil then
		ty = fy;
	end

	if imgSize == nil then
		imgSize = 1;
	end
	
	if delayTime ~= nil and delayTime > 0 then
		local funcStr = string.format("UI_FORCE(\"%s\", %f, %f, %f, %f, 0.0, \"%s\", %f)", forceName, fx, fy, tx, ty, changeImage, imgSize, type);
		ReserveScript(funcStr, delayTime);
		return;
	end

	if TYPE_REINFORCEMENT == "Certificate" and forceName == "reinf_finish" then		
		forceName = forceName .. "_certificate"
	end
	
	local force = ui.force.Get(forceName);
	if force == nil then
		return;
	end

	local frame = ui.GetFrame("uieffect");

	for i = 0 , force:GetLineCount() - 1 do

		local line = force:GetLine(i);
		if line.isText == true then
				local name = UI_EFFECT_GET_NAME(frame);
				local text = frame:CreateControl("richtext", name, fx, fy, 200, 20);
				text = tolua.cast(text, "ui::CRichText");
				text:ShowWindow(1);
				text:EnableResizeByText(1);
				text:SetTextFixWidth(0);
				text:SetText(line:GetImageName());
				text:PlayForce(force, i, tx, ty, 1);
		else
			local imgName = line:GetImageName();
			if changeImage ~= "" then
				imgName = changeImage;
			end

			if ui.IsImageExist(imgName) == true then
				local name = UI_EFFECT_GET_NAME(frame);
				local selPic = frame:CreateControl("picture", name, fx, fy, ui.GetImageWidth(imgName) * imgSize, ui.GetImageHeight(imgName) * imgSize);
				selPic = tolua.cast(selPic, "ui::CPicture");
				selPic:SetEnableStretch(1);
				selPic:ShowWindow(1);
				selPic:SetImage(imgName);
				
				selPic:PlayForce(force, i, tx, ty, 1);
			end
		end
	end
	if forceName == 'reinf_finish' or forceName == 'Certificate_reinf_finish' then
		TYPE_REINFORCEMENT = nil
	end
end

function GET_SCREENPOS_BY_OBJHANDLE(handle, offsettype)
	
	if handle ~= 0 then
		local point = info.GetPositionInUI(handle, offsettype);
		
		return point.x, point.y - 20
	end

	return 0, 0

end

function OBJ_FORCE_TO_OBJ(handle, forceName, imageName, imgSize, targetHandle, offsetx, offsety)

	if targetHandle == 0 then
		return;
	end

	local x;
	local y;
	if handle == 0 then
		x = ui.GetClientInitialWidth() / 2;
		y =  ui.GetClientInitialHeight() / 2;
	else
		local point = info.GetPositionInUI(handle, 2);
		x = point.x;
		y = point.y;
	end

	
	UI_FORCE(forceName, x, y, offsetx, offsety, 0.0, imageName, imgSize, targetHandle);

end

function OBJ_FORCE_TO_ADDON(handle, forceName, imageName, imgSize, targetUI, targetChild)

	local x;
	local y;
	if handle == 0 then
		x = ui.GetClientInitialWidth() / 2;
		y =  ui.GetClientInitialHeight() / 2;
	else
		local point = info.GetPositionInUI(handle, 1);
		x = point.x;
		y = point.y;
	end

	local tgtFrame = ui.GetFrame(targetUI);
	local btn = tgtFrame:GetChild(targetChild);
	local ix, iy = GET_UI_FORCE_POS(btn);
	UI_FORCE(forceName, x, y, ix, iy, 0.0, imageName, imgSize);

end

function UI_PLAYFORCE(obj, forceName, tx, ty, timeFactor)
	local force = ui.force.Get(forceName);
	if force == nil then
		return;
	end

	if tx == nil then
		tx = 0;
	end
	if ty == nil then
		ty = 0;
	end

	if timeFactor == nil then
		timeFactor = 1.0;
	end

	obj:PlayForce(force, 0, tx, ty, timeFactor);
end

function UI_Force_AddSpeed(obj, cmd, tx, ty, dx, dxa, dy, dya)
	cmd:AddSpeed(dx, dxa, dy, dya);
	return 1;
end

function UI_Force_AddPosition(obj, cmd, tx, ty, x, y)
	cmd:AddPos(x, y);
	return 1;
end

function UI_Force_SetSpeed(obj, cmd, tx, ty, dx, dxa, dy, dya)
	cmd:SetSpeed(dx, dxa, dy, dya);
	return 1;
end

function UI_Force_AddForce(obj, cmd, tx, ty, forceName, cnt)
	local x = obj:GetGlobalX() + obj:GetWidth() / 4;
	local y = obj:GetGlobalY() + obj:GetHeight() / 4;
	for i = 1 , cnt do		
		UI_FORCE(forceName, x, y, tx, ty);
	end

	return 1;
end

function UI_ShootForce(obj, cmd, tx, ty, posRandom, spd, accel, angle, angleSpd, endAction, endActionCnt, changeForce)
	obj:PlayTargetForce(tx, ty, posRandom, spd, accel, DegToRad(angle), angleSpd, endAction, endActionCnt, changeForce);
	return 1;
end

function UI_ShootForce_Time(obj ,cmd, tx, ty, posRandom, time, easing, endAction, endActionCnt, changeForce)
	obj:PlayTargetForce_Time(tx, ty, posRandom, time, easing, endAction, endActionCnt, changeForce);
	return 1;
end

function UI_Force_ShowWindow(obj, cmd, tx, ty, isShow)
	obj:ShowWindow(isShow);
	return 1;
end

function UI_PlaySound(obj ,cmd, tx, ty, soundName)
	ui.PlaySound(soundName);
	return 1;
end

function UI_Force_RemoveSlot(obj, cmd, tx, ty)
	if obj:GetClassName() ~= "slot" then
		return 1;
	end

	local slot = tolua.cast(obj, "ui::CSlot");
	slot:ClearIcon();
	return 1;
end

function UI_Force_RunFunction(obj, cmd, tx, ty, funcName)
	local _func = _G[funcName];
	if _func ~= nil then
		_func(obj);
	end

	return 1;
end

function UI_Force_Destroy(obj, cmd, tx, ty)
	return -1;
end

function EFT_FRAME_CREATE_CTRL(eftFrame, typeName, x, y, width, height)
	-- _CNT값을 늘려가면서 새로운 Name을 할당해서 생성해준다.
	local cnt = eftFrame:GetUserIValue("_CNT");
	cnt = cnt + 1;
	eftFrame:SetUserValue("_CNT", cnt);
	return eftFrame:CreateControl("richtext", "_CTRL_" .. cnt, x, y, width, height);	
end

function UI_ANIM(frame, name)
	local force = ui.force.Get(name);
	if force == nil then
		return;
	end
	frame:PlayForce(force, 0, 0, 0);
end