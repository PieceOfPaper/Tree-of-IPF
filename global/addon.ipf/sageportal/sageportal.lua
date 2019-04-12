-- sageportal.lua

function SAGEPORTAL_ON_INIT(addon, frame)

end

function SAGEPORTAL_OPEN_INIT(frame)

	local skillName = "Sage_Portal";
	SAGEPORTAL_UPDATE_LIST(frame, skillName)
end

function SAGE_PORTAL_SAVE_SUCCESS()
	local frame = ui.GetFrame("sageportal");

	local skillName = "Sage_Portal";
	SAGEPORTAL_UPDATE_LIST(frame, skillName);
end

function GET_SAGE_PORTAL_MAX_COUNT_C()
    local maxCnt = tonumber(SAGE_PORTAL_BASE_CNT);

    -- 특성
	local abil = session.GetAbilityByName("Sage1")
	if abil ~= nil then
	    local abilObj = GetIES(abil:GetObject());
	    maxCnt = maxCnt + abilObj.Level
	end

    return maxCnt;
end

function SAGEPORTAL_WRITE_PORTAL_CNT(frame, etcObj, skillName)
	local nowCnt = 0;
	local maxCnt = GET_SAGE_PORTAL_MAX_COUNT_C();

	for i = 1, maxCnt do
		local propName = skillName .. "_"..i;
		if etcObj[propName] ~= "None" then
			nowCnt = nowCnt + 1; 
		end
	end
	local warpCnt = frame:GetChild("warpCnt");
	warpCnt:SetTextByKey("value", nowCnt);
	warpCnt:SetTextByKey("value2", maxCnt);

	return nowCnt, maxCnt;
end

function SAGEPORTAL_UPDATE_LIST(frame, skillName)
	local etcObj = GetMyEtcObject();
	if nil == etcObj then
		ui.SysMsg(ClMsg('Auto_SeuKil_eopeum'));
		return;
	end

	local nowCnt, maxCnt = SAGEPORTAL_WRITE_PORTAL_CNT(frame, etcObj, skillName)
	local bg_mid = frame:GetChild("bg_mid");
	local warplist = bg_mid:GetChild("warplist");
	warplist:RemoveAllChild();
	local picX, picY = 125, 125;
	for i = 1, maxCnt do
		local propName =  skillName.. "_"..i;
		local propValue = etcObj[propName];		
		if 'None' ~= propValue then
			local ctrlSet = warplist:CreateControlSet("sage_portal_warp_list", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			local sSave = StringSplit(etcObj[propName], "@");
			local sList = StringSplit(sSave[1], "#");
			
			local gBox = ctrlSet:GetChild("gBox");
			local coolGbox = ctrlSet:GetChild("coolGbox");
			coolGbox:ShowWindow(0);

			local pos = gBox:GetChild("pos");
			pos:SetTextByKey("x", sList[2]);
			pos:SetTextByKey("y", sList[3]);
			pos:SetTextByKey("z", sList[4]);

			if #sList >= 4 then
				local mapCls = GetClass("Map", sList[1]);
				if nil ~= mapCls then
					local mapName = gBox:GetChild("mapName");
					mapName:SetTextByKey("value", mapCls.Name);
				
					local picBox = gBox:GetChild("picBox");	
					local pic = GET_CHILD(picBox, "pic", "ui::CPicture");
					local mapName = sList[1]
					local mapimage = ui.GetImage(mapName);
					if mapimage == nil then
						world.PreloadMinimap(mapName, true, true);
					end

					pic:SetImage(mapName);
					local mapprop = geMapTable.GetMapProp(mapName);
					local mapPos = mapprop:WorldPosToMinimapPos(sList[2], sList[4], pic:GetWidth(), pic:GetHeight());
					local mark = GET_CHILD(picBox, "mark", "ui::CPicture");

					local XC = picBox:GetX() + mapPos.x - 30;	
					local YC = picBox:GetY() + mapPos.y - 40;
					mark:Move(XC, YC);
				end

				local deleteBtn = gBox:GetChild("deleteBtn");	
				deleteBtn:SetUserValue("PORTA_INDX", i);
				deleteBtn:SetUserValue("PORTA_NAME", sList[1]);
				
				local OpenBtn = gBox:GetChild("OpenBtn");	
				OpenBtn:SetUserValue("PORTA_INDX", i);
				OpenBtn:SetUserValue("PORTA_NAME", sList[1]);
			end
			
			if #sSave > 1 then
				coolGbox:ShowWindow(1);

				local coolDown = coolGbox:GetChild("coolDown");
				local sysTime = geTime.GetServerSystemTime();
				local endTime = imcTime.GetSysTimeByStr(sSave[2]);
				local difSec = imcTime.GetDifSec(endTime, sysTime);
				coolDown:SetUserValue("REMAINSEC", difSec);
				coolDown:SetUserValue("STARTSEC", imcTime.GetAppTime());
				SHOW_REMAIN_POTAL_COOLDOWN(coolDown);
				coolDown:RunUpdateScript("SHOW_REMAIN_POTAL_COOLDOWN", 0.1);
				local deleteBtn = gBox:GetChild("deleteBtn");	
				deleteBtn:ShowWindow(0);

				local gBox = ctrlSet:GetChild("gBox");
				local OpenBtn = gBox:GetChild("OpenBtn");	
				OpenBtn:ShowWindow(0);
			end
		end
		--gBox:SetUserValue("PORTA_INDX", i); 로 하면 버튼에서 계속 값이 0이다. 왤까?
	end


	GBOX_AUTO_ALIGN(warplist, 20, 3, 10, true, false);
end

function SHOW_REMAIN_POTAL_COOLDOWN(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	if 0 > startSec then
		ctrl:SetTextByKey("value", "{#004123}");
		ctrl:StopUpdateScript("SHOW_REMAIN_POTAL_COLTIME");
		return 0;
	end 
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "{@st42}" .. timeTxt);
	return 1;
end

function SAGEPORTAL_SAVE_BTN(frame, ctrl)
	local mapCls = GetClass("Map", session.GetMapName());
	if mapCls == nil or mapCls.MapType ~= "Field" then
		ui.SysMsg(ClMsg('CannotSaveThisZone'));
		return 
	end

	local mapName = "None"
	if nil ~= mapCls then
		mapName = mapCls.Name;
	end

	ui.MsgBox(ScpArgMsg("SageSavePos{MN}","MN", mapName), "ui.Chat('/sageSavePos')", "None");
	DISABLE_BUTTON_DOUBLECLICK("sageportal",ctrl:GetName())
end

function SAGE_OPEN_MSG_BOX(ctrl, type)
	local skl = session.GetSkillByName('Sage_Portal');
	if nil == skl then
		return;
	end

	local sklObj = GetIES(skl:GetObject())
	if nil == sklObj then
		return;
	end

	local saveName = ctrl:GetUserValue("PORTA_NAME");
	local mapCls = GetClass("Map", saveName);
	local mapName = "None"
	if nil ~= mapCls then
		mapName = mapCls.Name;
	end

	local index = ctrl:GetUserIValue("PORTA_INDX");

	local yesScp = "None"
	local noScp = "None"
	local msg = "None";
	if "delete" == type then
		yesScp = string.format("ui.Chat(\"/sageDelPos %d\")", index);
		noScp = string.format("DELETE_PORTAL_POS_CANCLE(%d, 1)", index);
		msg = ScpArgMsg("SageDeletePos{MN}","MN", mapName);
	elseif "open" == type then
		yesScp = string.format("ui.Chat(\"/sageOpenPortal %d\")", index);
		noScp = string.format("DELETE_PORTAL_POS_CANCLE(%d, 0)", index);
		local timeTxt = GET_TIME_TXT(SAGE_PORTAL_SKL_PORTAL_COOLTIME(sklObj));
		msg = ScpArgMsg("SageOpenPos{MN}{TIME}","MN", mapName, "TIME", timeTxt);
	else
		return;
	end

	ui.MsgBox(msg, yesScp, noScp);
	ctrl:SetEnable(0);
end

function DELETE_PORTAL_POS(frame, ctrl)
	SAGE_OPEN_MSG_BOX(ctrl, "delete");
end

function OPEN_SAVE_PORTAL_ENTER(frame, ctrl)
	SAGE_OPEN_MSG_BOX(ctrl, "open");
end

function DELETE_PORTAL_POS_CANCLE(index, delete)
	local frame = ui.GetFrame("sageportal");
	local bg_mid = frame:GetChild("bg_mid");
	local warplist = bg_mid:GetChild("warplist");
	local ctrlSet = warplist:GetChild("CTRLSET_"..index)
	local gBox = ctrlSet:GetChild("gBox");
	if 1 == delete then
		local deleteBtn = gBox:GetChild("deleteBtn");	
		deleteBtn:SetEnable(1);
	else
		local OpenBtn = gBox:GetChild("OpenBtn");	
		OpenBtn:SetEnable(1);
	end
end