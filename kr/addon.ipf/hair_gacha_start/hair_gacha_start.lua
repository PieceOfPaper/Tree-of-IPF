-- hair_gacha_start.lua --

function HAIR_GACHA_START_ON_INIT(addon, frame)

end

function HAIR_GACHA_OK_BTN()

	local frame = ui.GetFrame("hair_gacha_start")
	
	local cnt = frame:GetUserValue("CNT");

	local scpString = string.format("/hairgacha %s",  cnt);
	ui.Chat(scpString);

	ui.CloseFrame("hair_gacha_start")
end

function HAIR_GACHA_START_1()
	
	HAIR_GACHA_START(1)
	
end

function HAIR_GACHA_START_10()
	
	HAIR_GACHA_START(10)
	
end

function HAIR_GACHA_START(cnt)

	if cnt ~= 1 and cnt ~= 10 then
		return;
	end

	local frame = ui.GetFrame("hair_gacha_start")
	frame:ShowWindow(0)
	frame:SetUserValue("CNT", cnt);

	local btn = GET_CHILD_RECURSIVELY(frame,"button_1")
	btn:SetTextByKey("value", cnt)
	
	frame:ShowWindow(1)
	
end