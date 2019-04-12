function RESTART_ON_INIT(addon, frame)
 	addon:RegisterMsg('RESTART_HERE', 'RESTART_ON_MSG');
	addon:RegisterMsg('RESTARTSELECT_UP', 'RESTART_ON_MSG');
	addon:RegisterMsg('RESTARTSELECT_DOWN', 'RESTART_ON_MSG');
	addon:RegisterMsg('RESTARTSELECT_SELECT', 'RESTART_ON_MSG');
end

function RESTART_ON_RESSURECT_SAVE_POINT(frame)

	restart.SendRestartSavePointMsg();
end

function RESTART_ON_RESSURECT_HERE(frame)
	local cristal = GetClass("Item", "RestartCristal");
	local cristal_14d = GetClass("Item", "RestartCristal_14d");
	local item = session.GetInvItemByName(cristal.ClassName);

	local item_14d = nil
	if cristal_14d ~= nil then
		item_14d = session.GetInvItemByName(cristal_14d.ClassName);
	end

	if (item == nil) and (item_14d == nil) then
		ui.SysMsg(ScpArgMsg("NotEnough{ItemName}Item","ItemName", cristal.Name));
		return;

	end
	restart.SendRestartHereMsg();
end

function RESTART_ON_RESSURECT_MAINLAYER(frame)

	restart.SendRestartMainLayerMsg();

end

function RESTART_ON_RESSURECT_ABANDON(frame)

	restart.SendRestartRetry();
	frame:ShowWindow(0);

end

function RESTART_ON_RESSURECT_RETRY(frame)

	restart.Send(5);
	frame:ShowWindow(0);

end


function MOVE_TO_CAMP_WHEN_DED(frame, control, aid)
	restart.SendRestartCampMsg(aid);
end

function AUTORESIZE_RESTART(frame)

	local maxy = 0;
	local cnt = frame:GetChildCount();

	local ctrly = 100;
	local ctrlHight = 0;
	local ctrloffsetY = 0;

	local campGroup = frame:GetChild("campGroup");

	for i = 0 , cnt - 2 do

		local ctrl = frame:GetChildByIndex(i);
		local ctrlname = ctrl:GetName();
		if ctrl:IsVisible() == 1 and string.find(ctrlname, "btn") ~= nil then
			ctrl:SetOffset(ctrl:GetOffsetX(), ctrly);
			ctrly = ctrly + ctrl:GetHeight() + 5;

			if 0 == ctrlHight then
				ctrlHight = ctrl:GetHeight();
				ctrloffsetY = ctrl:GetOffsetY();
			end
			local y = ctrl:GetOffsetY() + ctrl:GetHeight();

			if y > maxy then
				maxy = y;
			end
		end
	end
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();

	local campGroup = frame:GetChild("campGroup");
	if nil == campGroup then
		return;
	end
	campGroup:RemoveAllChild();
	-- 파티원이 존재 할 때
	if 0 < count then
		local y = 0;
		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			if partyMemberInfo.campMapID ~= 0 then
				local map = GetClassByType("Map", partyMemberInfo.campMapID);
				if nil ~= map then
					local str = string.format("%s %s", map.Name,ClMsg("MoveToCamp"));
					local shareBtn = campGroup:CreateControl("button", "party"..i, 0, y, campGroup:GetWidth(), ctrlHight);
					y = y + ctrlHight;
					maxy = maxy + ctrlHight;
					shareBtn = tolua.cast(shareBtn, "ui::CButton");
					shareBtn:SetText("{@st66b}".. str);
					shareBtn:SetEventScript(ui.LBUTTONUP, "MOVE_TO_CAMP_WHEN_DED");
					shareBtn:SetEventScriptArgString(ui.LBUTTONUP, partyMemberInfo:GetAID());
					shareBtn:SetSkinName("test_pvp_btn");
				end
			end
		end
		frame:Resize(frame:GetWidth(), maxy + 40);
		return;
	end
	
	local mapID = session.loginInfo.GetSquireMapID();
	local map = GetClassByType("Map", mapID);
	if nil == map then
		frame:Resize(frame:GetWidth(), maxy + 40);
		return;
	end

	local str = string.format("%s %s", map.Name,ClMsg("MoveToCamp"));
	local shareBtn = campGroup:CreateControl("button", "myCamp", 0, 0, campGroup:GetWidth(), ctrlHight);
	shareBtn = tolua.cast(shareBtn, "ui::CButton");
	shareBtn:SetEventScript(ui.LBUTTONUP, "MOVE_TO_CAMP_WHEN_DED");
	shareBtn:SetText("{@st66b}".. str);
	shareBtn:SetEventScriptArgString(ui.LBUTTONUP, session.loginInfo.GetAID());
	shareBtn:SetSkinName("test_pvp_btn");

	maxy =maxy + ctrlHight;
	frame:Resize(frame:GetWidth(), maxy + 40);
end

function RESTART_MOVE_INDEX(frame, isDown)

	local restartSelect_index = frame:GetValue();

	while 1 do
		restartSelect_index = restartSelect_index + isDown;
		local btnName = "restart" .. restartSelect_index .. "btn";
		local child = frame:GetChild(btnName);
		if child == nil then
			return;
		end

		if child:IsVisible() == 1 then
			break;
		end
	end

	frame:SetValue(restartSelect_index);
end

function RESTART_ON_MSG(frame, msg, argStr, argNum)

	local minigameover = ui.GetFrame('minigameover');	
	if minigameover:IsVisible() == 1 then
		return;
	end;


	if msg == 'RESTART_HERE' then
		for i = 1 , 5 do
			local btnName = "restart" .. i .. "btn";
			local resButtonObj	= GET_CHILD(frame, btnName, 'ui::CButton');
			local isBit = BitGet(argNum, i);
			
			resButtonObj:ShowWindow(isBit);
		end

		AUTORESIZE_RESTART(frame);
		frame:ShowWindow(1);

	elseif msg == 'RESTARTSELECT_UP' then

		RESTART_MOVE_INDEX(frame, -1);
		RESTARTSELECT_ITEM_SELECT(frame)

	elseif msg == 'RESTARTSELECT_DOWN' then

		RESTART_MOVE_INDEX(frame, 1);
		RESTARTSELECT_ITEM_SELECT(frame)

	elseif msg == 'RESTARTSELECT_SELECT' then

		local childName = 'restart' .. frame:GetValue() .. 'btn'
		local ItemBtn = frame:GetChild(childName);
		local scp = ItemBtn:GetEventScript(ui.LBUTTONUP);
		scp = _G[scp];
		scp(frame, ItemBtn);
	end
end

function RESTARTSELECT_ITEM_SELECT(frame)

	local childName = 'restart' .. frame:GetValue() .. 'btn'
	local ItemBtn = frame:GetChild(childName);
	local x, y = GET_SCREEN_XY(ItemBtn);

	mouse.SetPos(x,y);
	mouse.SetHidable(0);
end
