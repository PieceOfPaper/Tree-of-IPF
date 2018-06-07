function INGAMEALERT_ON_INIT(addon, frame)
	addon:RegisterMsg("INGAME_PRIVATE_ALERT", "INGAMEALERT_SHOW");
	addon:RegisterMsg("INDUN_ASK_PARTY_MATCH", "ON_INDUN_ASK_PARTY_MATCH");
	addon:RegisterMsg("SOLD_ITEM_NOTICE", "ON_SOLD_ITEM_NOTICE");
	addon:RegisterMsg("RECEIVABLE_SILVER_NOTICE", "ON_RECEIVABLE_SILVER_NOTICE");
end

function INGAMEALERT_SHOW(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('ingamealert');
	local mainBox = frame:GetChild('mainGbox');
	local text = GET_CHILD(mainBox, 'text');
	text:SetText(argStr);

	local chatFrame = ui.GetFrame('chatframe');
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, chatFrame:GetHeight() + 20);
	end
	frame:ShowWindow(1);
end

function ON_INDUN_ASK_PARTY_MATCH(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('ingamealert');
	local mainBox = frame:GetChild('mainGbox');
	local text = GET_CHILD(mainBox, 'text');

	local argList = StringSplit(argStr, '/');
	if #argList ~= 2 then
		frame:ShowWindow(0);
		return;
	end
	local askMsg = ScpArgMsg("PartyMatching", "MEMBER", argList[1], "INDUN", argList[2]);
	text:SetText(askMsg);

	local chatFrame = ui.GetFrame('chatframe');
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, chatFrame:GetHeight() + 20);
	end

	mainBox:Resize(mainBox:GetWidth(), text:GetY() + text:GetHeight() + 10);
	frame:Resize(mainBox:GetWidth(), mainBox:GetHeight());
	frame:ShowWindow(1);
end

function ON_SOLD_ITEM_NOTICE(frame, msg, argStr, argNum)	
	local frame = ui.GetFrame('ingamealert');
	local mainBox = frame:GetChild('mainGbox');
	local text = GET_CHILD(mainBox, 'text');
	
	local argList = StringSplit(argStr, '/');
	if #argList ~= 3 then
		frame:ShowWindow(0);
		return;
	end
	local askMsg = ScpArgMsg("SoldItemNotice", "SELLER", argList[1], "ITEM", argList[2], "COUNT", argList[3]);
	text:SetText(askMsg);

	local chatFrame = ui.GetFrame('chatframe');
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, chatFrame:GetHeight() + 20);
	end

	mainBox:Resize(mainBox:GetWidth(), text:GetY() + text:GetHeight() + 10);
	frame:Resize(mainBox:GetWidth(), mainBox:GetHeight());
	frame:ShowWindow(1);
end

function ON_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('ingamealert');
	local mainBox = frame:GetChild('mainGbox');
	local text = GET_CHILD(mainBox, 'text');	
	
	local askMsg = ScpArgMsg("ReceivableSilverNotice");
	text:SetText(askMsg);

	local chatFrame = ui.GetFrame('chatframe');
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, chatFrame:GetHeight() + 20);
	end

	mainBox:Resize(mainBox:GetWidth(), text:GetY() + text:GetHeight() + 10);
	frame:Resize(mainBox:GetWidth(), mainBox:GetHeight());
	frame:ShowWindow(1);
end

function OPEN_INGAMEALERT(frame)
end