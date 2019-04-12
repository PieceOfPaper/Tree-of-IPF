function TARGETSPACE_ON_INIT(addon, frame)

	addon:RegisterMsg('TARGET_SET', 'TARGETSPACE_ON_MSG');	
	addon:RegisterMsg('TARGET_CLEAR', 'TARGETSPACE_ON_MSG');	
end

function TARGETSPACE_ON_MSG(frame, msg, argStr, argNum)
	if msg == "TARGET_SET" then
		local type = tonumber(config.GetXMLConfig("ControlMode"));
		TARGETSPACE_SET(frame, type);
	elseif msg == "TARGET_CLEAR" then
		TARGETSPACE_CLEAR(frame);
	end
end

function TARGETSPACE_SET(frame, type)		
	if type == nil then
		type = 0;
	end

	local handle = session.GetTargetHandle();
	local targetinfo = info.GetTargetInfo(handle);
	if targetinfo == nil or targetinfo.isDialog == 0 then
		return;
	end

	if TARGETSPACE_PRECHECK(handle) == 0 and (COMPANION_SPACE_PRECHECK(handle, targetinfo.companionName) == 0 or targetinfo.isMyCompanion == false) then 
		frame:ShowWindow(0);
		return;
	end

	local frame = ui.GetFrame("targetSpace_"..handle);
	if frame == nil then
		ui.CreateTargetSpace(handle);
		frame = ui.GetFrame("targetSpace_"..handle);
	end

	if frame:IsVisible() == 0 then
		frame:ShowWindow(1);
		ui.UpdateCharBasePos(handle);

		local spaceObj = GET_CHILD(frame, "space", "ui::CAnimPicture");
		local LbtnObj  = GET_CHILD(frame, 'mouseLbtn', 'ui::CPicture');
		local joyBbtn  = GET_CHILD(frame, 'joyBbtn', 'ui::CPicture');
	
		if type == 1 then
			spaceObj:ShowWindow(0);
			LbtnObj:ShowWindow(0);
			joyBbtn:ShowWindow(1);
		elseif type == 2 then
			spaceObj:PlayAnimation();
			spaceObj:ShowWindow(1);
			LbtnObj:ShowWindow(0);
			joyBbtn:ShowWindow(0);

		elseif type == 3 then
			spaceObj:ShowWindow(0);
			LbtnObj:ShowWindow(1);
			joyBbtn:ShowWindow(0);
		elseif type == 0 then -- 자동모드
			if IsJoyStickMode() == 1 then
				spaceObj:ShowWindow(0);
				LbtnObj:ShowWindow(0);
				joyBbtn:ShowWindow(1);
			else
				spaceObj:PlayAnimation();
				spaceObj:ShowWindow(1);
				LbtnObj:ShowWindow(0);
				joyBbtn:ShowWindow(0);
			end
		end
		
	end	
end

function TARGETSPACE_CLEAR(frame)
	local handle = session.GetTargetHandle();
	local frame= ui.GetFrame("targetSpace_"..handle);
	
	if frame ~= nil and frame:GetDuration() == 0.0 then	
		frame:ShowWindow(0);
	end
end

function COMPANION_SPACE_PRECHECK(handle, className)	
	local cls = GetClass("Companion", className);
	if nil == cls then
		return 0;
	end

	local dlgInfo = info.GetDialogInfo(handle)
	local dialog = dlgInfo:GetDialog()
	local customDialog = dlgInfo:GetCustomScript();

	if customDialog == 'DIALOG_COMPANION' then
		return 1;
	end;

	return 0;
end

function TARGETSPACE_PRECHECK(handle)	
	local pc = GetMyPCObject();
	local dlgInfo = info.GetDialogInfo(handle)
	local dialog = dlgInfo:GetDialog()
	local customDialog = dlgInfo:GetCustomScript();
	local actor = world.GetActor(handle);
    local classId = actor:GetType()
    if dialog == nil then
		return 0;
	end
	
	if classId ~= nil then
	    local statueGoddess = { GetClassNumber('Monster', 'statue_vakarine', 'ClassID'), GetClassNumber('Monster', 'statue_zemina', 'ClassID')}
	    if statueGoddess ~= nil and table.find(statueGoddess, classId) > 0 then
	        return 1
	    end
	end
	
	if customDialog ~= "None" then
		local checkScp = _G[customDialog .. "_CHECK"];
		if checkScp ~= nil and checkScp(handle) == true then
			return 1;
		end
	end

	if dialog == 'None' then
        return 0
    else
        local npcselectIES = GetClass('NPCSelectDialog',dialog)
        local ret = 0
        local questNPCFlag = false
        if npcselectIES ~= nil then
            ret = QUEST_LIB_DIALOGPRECHECK(pc, dialog, handle)
            questNPCFlag = true
            if ret == 1 then
                return ret
            end
        end
        
        ret = QUEST_SUB_NPC_DIALOGPRECHECK(pc, dialog)
        if ret == 1 then
            return ret
        end
        
        local func = _G['SCR_'..dialog..'_PRE_DIALOG']
        if func ~= nil then
            local result = func(pc, dialog, handle)
            
            if result == 'YES' then
                return 1
            else
                return 0
            end
        else
            if questNPCFlag == false then
                return 1
            end
        end
    end
    
	return 0
end