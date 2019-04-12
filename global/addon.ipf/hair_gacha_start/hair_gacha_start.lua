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
	
	local type = frame:GetUserValue("ClassName");

	local scpString = string.format("/hairgacha %s",  type);
	ui.Chat(scpString);

	ui.CloseFrame("hair_gacha_start")
end

function CLIENT_GACHA_SCP(invItem)

	if invItem.isLockState == true then
		ui.SysMsg(ScpArgMsg("MaterialItemIsLock"))
		return
	end

	local itemobj = GetIES(invItem:GetObject());
	local gachaDetail = GetClass("GachaDetail", itemobj.ClassName);
--    local zoneCheck = GetZoneName(pc)
--    
--    if zoneCheck == "c_barber_dress" then
--        return 0;
--    end
    
	if gachaDetail.PreCheckScp ~= "None" then
		local scp = _G[gachaDetail.PreCheckScp];
		if scp() == "NO" then
			return;
		end
	end

	GACHA_START(gachaDetail)
end


function GACHA_START(gachaDetail)
	if gachaDetail == nil then
		return;
	end

	local cnt = gachaDetail.Count;
	if cnt ~= 1 and cnt ~= 11 then
		return;
	end

	local frame = ui.GetFrame("hair_gacha_start")
	frame:ShowWindow(0)
	frame:SetUserValue("ClassName", gachaDetail.ClassName);
	local item = GetClass("Item", gachaDetail.ClassName);

	--어떤 BG를 쓸 것인가
	--텍스트는 어떤걸?
	--버튼 어떤거?
	--카운트의 유무
	local hairbg = GET_CHILD_RECURSIVELY(frame,"bg_hair")
	local rboxbg = GET_CHILD_RECURSIVELY(frame,"bg_rbox")
    local hairText = GET_CHILD_RECURSIVELY(frame, 'richtext_2');
	local costumeText = GET_CHILD_RECURSIVELY(frame, 'richtext_3');
	local btn = GET_CHILD_RECURSIVELY(frame,"button")

	btn:SetVisible(1)
	local val = ScpArgMsg("GachaMsg", "Name", item.Name);
	btn:SetTextByKey("value", "{@st42b}"..val)

	if gachaDetail.GachaType == "hair" then
		hairbg:SetVisible(1);
		rboxbg:SetVisible(0);
		hairText:SetVisible(1);
		costumeText:SetVisible(0);
	elseif gachaDetail.GachaType == "rbox" then
		hairbg:SetVisible(0);
		rboxbg:SetVisible(1);
		hairText:SetVisible(1);
		costumeText:SetVisible(0);
	elseif gachaDetail.GachaType == "costume" then
		hairbg:SetVisible(1);
		rboxbg:SetVisible(0);
		hairText:SetVisible(0);
		costumeText:SetVisible(1);
	end

	frame:ShowWindow(1)
	
	
end