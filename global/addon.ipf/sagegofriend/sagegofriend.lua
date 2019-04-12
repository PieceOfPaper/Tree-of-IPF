--sagegofrend.lua

function SAGEGOFRIEND_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("FRIEND_SESSION_CHANGE", "SAGEGOFRIEND_UI_OPEN");
	
end

function SAGEGOFRIEND_UI_OPEN(frame)
	local cnt = session.friends.GetFriendCount(FRIEND_LIST_COMPLETE);
	local loginCnt = 0;

	local gbox_list = frame:GetChild("gbox_list");
	gbox_list:RemoveAllChild();
	for i = 0, cnt -1 do
		local f = session.friends.GetFriendByIndex(FRIEND_LIST_COMPLETE, i);
		local info = f:GetInfo();

		if f.mapID ~= 0 then
			loginCnt = loginCnt + 1;

			local ctrlSet = gbox_list:CreateControlSet("sage_go_friend_list", "MEMBER_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
			local txt_teamname = ctrlSet:GetChild("txt_teamname");
			txt_teamname:SetTextByKey("value", info:GetFamilyName());
			txt_teamname:SetTextTooltip(info:GetPCName());
			local mapCls = GetClassByType("Map", f.mapID);
			if mapCls ~= nil then
				locationText = string.format("[%d%s] %s", f.channel + 1,ScpArgMsg("Channel"), mapCls.Name);
			end

			local txt_location = ctrlSet:GetChild("txt_location");
			txt_location:SetTextByKey("value", locationText);
			txt_location:SetTextTooltip(locationText);
		end
	end

	GBOX_AUTO_ALIGN(gbox_list, 3, 0, 0, true, false);

	local cntText = frame:GetChild("cntText");
	cntText:SetTextByKey("value", loginCnt);
	cntText:SetTextByKey("value2", cnt);
end

function SAGEGOFRIEND_BTN_CIK(frame, ctrl)
	frame = frame:GetTopParentFrame();

	SAGEGOFRIEND_LIST_UPDATE(frame)

	ctrl:SetUserValue("IS_CHECK", 1);
	ctrl:SetSkinName("baseyellow_btn");

	local ctrlParent = ctrl:GetParent();
	local txt_teamname = ctrlParent:GetChild("txt_teamname");
	local name = txt_teamname:GetTextByKey("value");
	frame:SetUserValue("SELECT_NAME", name);
end

function SAGEGOFRIEND_LIST_UPDATE(frame)
	frame:SetUserValue("SELECT_NAME", 'None');
	local gbox_list = frame:GetChild("gbox_list");
	local childCnt = gbox_list:GetChildCount();

	for i = 1, childCnt - 1 do
		local ctrlSet = gbox_list:GetChildByIndex(i);
		local button = ctrlSet:GetChild("button");
		if button:GetUserIValue("IS_CHECK") == 1 then
			button:SetUserValue("IS_CHECK", 0);
			button:SetSkinName("base_btn");
		end
	end
end

function SAGEGOFRIEND_GO_FRIEND(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local name = frame:GetUserValue("SELECT_NAME");
	if name == 'None' or nil == name then
		return;
	end

	local fsmActor = GetMyActor();
	friends.SageSkillGoFindFriend(name);
	frame:ShowWindow(0);
end

function SAGEGOFRIEND_FIND_FRIEND(mapID, channelID, x, y, z)
	local frame = ui.GetFrame('sagegofriend');
	if nil == frame then
		return;
	end
	local name = frame:GetUserValue("SELECT_NAME");
	local fsmActor = GetMyActor();
	local scp = string.format("friends.SageSkillGoFriend(%s,%d,%d,%d,%d,%d)", name, mapID, channelID, x, y, z);
	movie.InteWarp(fsmActor:GetHandleVal(), scp);
	SAGEGOFRIEND_LIST_UPDATE(frame);
end