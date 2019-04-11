
function PCINVITE_ON_INIT(addon, frame)





end

function CLAER_INVITE(frame)
	if frame == nil then
		frame = ui.GetFrame("pcinvite");
	end

	local advBox = GET_CHILD(frame, "advBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	advBox:SetColWidth(0, frame:GetWidth() - 70);
	advBox:SetColWidth(1, 50);
end

function ADD_INVITE(name, cid, frame)
	if frame == nil then
		frame = ui.GetFrame("pcinvite");
	end

	local advBox = GET_CHILD(frame, "advBox", "ui::CAdvListBox");
	local key = name;
	local title = advBox:SetItem(key, 0, name, "white_16_ol");
	title:SetUserValue("CID", cid);
	local cbox = advBox:SetItemByType(key, 1, "checkbox", 24, 24, 10);
end

function SHOW_INVITE(funcName, frame, argStr)
	
	if frame == nil then
		frame = ui.GetFrame("pcinvite");
	end

	local advBox = GET_CHILD(frame, "advBox", "ui::CAdvListBox");
	advBox:UpdateAdvBox();
	frame:ShowWindow(1);
	frame:SetUserValue("EXEC_FUNC", funcName);
	frame:SetUserValue("ARG_STRING", argStr);
	
end

function SHOW_INVITE_PARTY(funcName, argStr)

	local frame = ui.GetFrame("pcinvite");
	CLAER_INVITE(frame);

	local listCnt = session.partyhistorylist.GetPartyHistoryListCount();

	local count = 0;
	for i=0, listCnt  - 1 do
		local info = session.partyhistorylist.GetPartyHistoryInfo(i);
		ADD_INVITE(info.charName, info:GetCID());
	end

	SHOW_INVITE(funcName, frame, argStr);
end

function PCINVITE_EXEC(frame)
	frame:ShowWindow(0);

	local fn = frame:GetUserValue("EXEC_FUNC");
	local ret = {};
	local retID = {};
	local advBox = GET_CHILD(frame, "advbox", "ui::CAdvListBox");
	local cnt = advBox:GetRowItemCnt();
	for i = advBox:GetStartRow()  , cnt - 1 do
		local key = advBox:GetKeyByRow(i);
		local title = advBox:GetObjectXY(i, 0);
		local cbox = advBox:GetObjectXY(i, 1);
		tolua.cast(cbox, "ui::CCheckBox");
		if cbox:IsChecked() == 1 then
			ret[#ret + 1] = key;
			retID[#retID + 1] = title:GetUserValue("CID");
		end
	end

	if #ret == 0 then
		local input = frame:GetChild("input");
		ret[#ret + 1] = input:GetText();
	end

	fn = _G[fn];

	local argStr = frame:GetUserValue("ARG_STRING");
	fn(ret, retID, argStr);
	
end
