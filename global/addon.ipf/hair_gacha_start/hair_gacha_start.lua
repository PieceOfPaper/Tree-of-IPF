-- hair_gacha_start.lua --

function HAIR_GACHA_START_ON_INIT(addon, frame)

end

function HAIR_GACHA_OK_BTN()

	local darkframe = ui.GetFrame("fulldark")
	local popupframe = ui.GetFrame("hair_gacha_popup")

	if darkframe == nil or popupframe == nil then
		return
	end

	if darkframe:IsVisible() == true or popupframe:IsVisible() == true then
		ui.SysMsg(ScpArgMsg('TryLater'));
		return
	end


	local frame = ui.GetFrame("hair_gacha_start")
	
	local type = frame:GetUserValue("TYPE");

	local scpString = string.format("/hairgacha %s",  type);
	ui.Chat(scpString);

	ui.CloseFrame("hair_gacha_start")
end

function HAIR_GACHA_START_1()
	
	GACHA_START("hair1")
	
end

function HAIR_GACHA_START_11()
	
	GACHA_START("hair11")
	
end

function RBOX_START_1()
	
	GACHA_START("rbox1")
	
end

function RBOX_START_11()
	
	GACHA_START("rbox11")
	
end

function RBOX_START_100()
	
	GACHA_START("rbox100")
	
end

function GACHA_START(type)

	local cnt = 0;

	if type == "hair1" or type == "rbox1" or type == "rbox100" then
		cnt = 1
	elseif type == "hair11" or type == "rbox11" then
		cnt = 11
	else	
		return;
	end

	if cnt ~= 1 and cnt ~= 11 then
		return;
	end

	local frame = ui.GetFrame("hair_gacha_start")
	frame:ShowWindow(0)
	frame:SetUserValue("TYPE", type);

	if type == "hair1" or type == "hair11" then
		
		local hairbg = GET_CHILD_RECURSIVELY(frame,"bg_hair")
		local rboxbg = GET_CHILD_RECURSIVELY(frame,"bg_rbox")

		hairbg:SetVisible(1)
		rboxbg:SetVisible(0)
		
		local hairbtn = GET_CHILD_RECURSIVELY(frame,"button_hair")
		local rboxbtn = GET_CHILD_RECURSIVELY(frame,"button_rbox")
		local rbox100btn = GET_CHILD_RECURSIVELY(frame,"button_rbox_100")

		rboxbtn:SetVisible(0)
		rbox100btn:SetVisible(0)
		hairbtn:SetVisible(1)
		hairbtn:SetTextByKey("value", cnt)
	elseif type == "rbox1" or type == "rbox11" then

		local hairbg = GET_CHILD_RECURSIVELY(frame,"bg_hair")
		local rboxbg = GET_CHILD_RECURSIVELY(frame,"bg_rbox")

		hairbg:SetVisible(0)
		rboxbg:SetVisible(1)

		local hairbtn = GET_CHILD_RECURSIVELY(frame,"button_hair")
		local rboxbtn = GET_CHILD_RECURSIVELY(frame,"button_rbox")
		local rbox100btn = GET_CHILD_RECURSIVELY(frame,"button_rbox_100")

		rboxbtn:SetVisible(1)
		rboxbtn:SetTextByKey("value", cnt)
		hairbtn:SetVisible(0)
		rbox100btn:SetVisible(0)

	elseif type == "rbox100" then

		local hairbg = GET_CHILD_RECURSIVELY(frame,"bg_hair")
		local rboxbg = GET_CHILD_RECURSIVELY(frame,"bg_rbox")

		hairbg:SetVisible(0)
		rboxbg:SetVisible(1)

		local hairbtn = GET_CHILD_RECURSIVELY(frame,"button_hair")
		local rboxbtn = GET_CHILD_RECURSIVELY(frame,"button_rbox")
		local rbox100btn = GET_CHILD_RECURSIVELY(frame,"button_rbox_100")

		rboxbtn:SetVisible(0)
		hairbtn:SetVisible(0)
		rbox100btn:SetVisible(1)

	else
		return

	end
	
	frame:ShowWindow(1)
	
	
end