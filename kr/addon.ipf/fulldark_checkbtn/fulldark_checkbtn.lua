function FULLDARK_CHECKBTN_UI_CLOSE(frame)
    ui.FlushGachaDelayPacket();
    frame:ShowWindow(0);
end

---------------- EVENT_GODDESS_ROULETTE 시작 ------------------
function GODDESS_ROULETTE_RESULT_FULLDARK_UI_OPEN(grade, itemClassName, itemCount)
    local frame = ui.GetFrame("fulldark_checkbtn");
	frame:EnableHide(0);
    
	local imageName = "gacha_big_03";
	local posX = ui.GetSceneWidth() / 2;
	local posY = ui.GetSceneHeight() / 2;
	if grade == "SSS" or grade == "SS" or grade == "S" then
		imageName = "gacha_big_01";
		movie.PlayUIEffect(frame:GetUserConfig("GACHA_EFT_1"), posX, posY, tonumber(frame:GetUserConfig("GACHA_EFT_SCALE_1")));
	elseif grade == "A" then
		imageName = "gacha_big_02";
		movie.PlayUIEffect(frame:GetUserConfig("GACHA_EFT_2"), posX, posY, tonumber(frame:GetUserConfig("GACHA_EFT_SCALE_2")));
	else
		imageName = "gacha_big_03";
	end

    local itembgimg = GET_CHILD(frame, "itembgimg");
    itembgimg:SetImage(imageName);

    local itemCls = GetClass("Item", itemClassName);

    local itemimg = GET_CHILD(frame, "itemimg");
    itemimg:SetImage(itemCls.Icon);

    local itemname = GET_CHILD(frame, "itemname");
    if itemCount ~= nil then
        local getText = itemCls.Name.." "..itemCount..ClMsg("Piece");
        if GetServerNation() ~= "KOR" then
            getText = itemCls.Name.." "..itemCount;
        end
        itemname:SetTextByKey("value", getText);
    else
        itemname:SetTextByKey("value", itemCls.Name);
    end

    local checkBtn = GET_CHILD(frame, "checkBtn");
	checkBtn:SetEventScript(ui.LBUTTONUP, "GODDESS_ROULETTE_RESULT_FULLDARK_UI_CLOSE");

    frame:ShowWindow(1);
end

function GODDESS_ROULETTE_RESULT_FULLDARK_UI_CLOSE()
    ui.FlushGachaDelayPacket();
	GODDESS_ROULETTE_INIT();
    
    local frame = ui.GetFrame("fulldark_checkbtn");
    local checkBtn = GET_CHILD(frame, "checkBtn");
	checkBtn:SetEventScript(ui.LBUTTONUP, "FULLDARK_CHECKBTN_UI_CLOSE");

    frame:ShowWindow(0);
end
---------------- EVENT_GODDESS_ROULETTE 끝 ------------------


--------------------- FLEX_BOX 시작 ---------------------
function EVENT_FLEX_BOX_REWARD_FULLDARK_UI_OPEN(grade, itemClassName, itemCount)
    local frame = ui.GetFrame("fulldark_checkbtn");
	frame:EnableHide(0);

    local imageName = "gacha_big_03";
	local posX = ui.GetSceneWidth() / 2;
	local posY = ui.GetSceneHeight() / 2;
	if grade == "SSS" or grade == "SS" or grade == "S" then
		imageName = "gacha_big_01";
		movie.PlayUIEffect(frame:GetUserConfig("GACHA_EFT_1"), posX, posY, tonumber(frame:GetUserConfig("GACHA_EFT_SCALE_1")));
	elseif grade == "A" then
		imageName = "gacha_big_02";
		movie.PlayUIEffect(frame:GetUserConfig("GACHA_EFT_2"), posX, posY, tonumber(frame:GetUserConfig("GACHA_EFT_SCALE_2")));
	else
		imageName = "gacha_big_03";
	end

    local itembgimg = GET_CHILD(frame, "itembgimg");
    itembgimg:SetImage(imageName);

    local itemCls = GetClass("Item", itemClassName);
    if itemCls == nil then
        return;
    end

    local itemimg = GET_CHILD(frame, "itemimg");
    itemimg:SetImage(itemCls.Icon);

    local itemname = GET_CHILD(frame, "itemname");
    itemname:SetTextByKey("value", itemCls.Name.." "..itemCount..ClMsg("Piece"));

    frame:ShowWindow(1);
end

--------------------- FLEX_BOX 끝 ---------------------