function PORTAL_SHOP_REGISTER_ON_INIT(addon, frame)

end

function PORTAL_SHOP_REGISTER_OPEN(skillObj)
    local frame = ui.GetFrame('portal_shop_register');
    if frame ~= nil and frame:IsVisible() == 1 then
        ui.CloseFrame('portal_shop_register');
        return;
    end

    PORTAL_SHOP_REGISTER_INIT(frame, skillObj);
    frame:ShowWindow(1);
end

function PORTAL_SHOP_REGISTER_INIT(frame, skillObj)
    AUTOSELLER_REGISTER_FRAME_INIT(frame, skillObj);
    PORTAL_SHOP_REGISTER_INIT_INGREDIENT(frame, skillObj.ClassName);
    PORTAL_SHOP_REGISTER_INIT_PORTAL(frame, skillObj);
end

function PORTAL_SHOP_REGISTER_INIT_INGREDIENT(frame, skillName)
    local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. skillName];
	local ingredientItemName, cnt = checkFunc(invItemList);

	local ingredientItemCls = GetClass("Item", ingredientItemName);
	local itemImage = GET_ITEM_IMG_BY_CLS(ingredientItemCls, 60);

    local reqitemImage = GET_CHILD_RECURSIVELY(frame, 'reqitemImage');
    reqitemImage:SetTextByKey('txt', itemImage);

    local reqitemNameStr = GET_CHILD_RECURSIVELY(frame, 'reqitemNameStr');
    reqitemNameStr:SetTextByKey('txt', ingredientItemCls.Name);

    local reqitemCount = GET_CHILD_RECURSIVELY(frame, 'reqitemCount');
    reqitemCount:SetTextByKey('txt', cnt);
end

function PORTAL_SHOP_REGISTER_INIT_PORTAL(frame, skillObj)    
    local skillName = 'Sage_Portal';
    local etcObj = GetMyEtcObject();
    local pc = GetMyPCObject();
    local maxRegisterCnt = GET_MAX_ENABLE_REGISTER_PORTAL_CNT(pc, skillObj);

    local selectText = GET_CHILD_RECURSIVELY(frame, 'selectText');
    selectText:SetTextByKey('current', '0');
    selectText:SetTextByKey('max', maxRegisterCnt);

    local portalBox = GET_CHILD_RECURSIVELY(frame, 'portalBox');
    portalBox:RemoveAllChild();

    local maxPortalCnt = GET_SAGE_PORTAL_MAX_COUNT_C();
    for i = 1, maxPortalCnt do
        local propName =  skillName.. "_"..i;
		local propValue = etcObj[propName];		
		if 'None' ~= propValue then
            local ctrlSet = portalBox:CreateOrGetControlSet('sage_portal_warp_register', 'PORTAL_'..i, 0, 0);
            local portalInfoList = StringSplit(propValue, "@"); -- portalPos@openedTime
			local portalPosList = StringSplit(portalInfoList[1], "#"); -- zoneName#x#y#z

            -- name
            local mapName = portalPosList[1];
            local mapCls = GetClass('Map', mapName);
            local registerCheck = GET_CHILD_RECURSIVELY(ctrlSet, 'registerCheck');
            registerCheck:SetTextByKey('map', mapCls.Name);

            -- position
            local pos = GET_CHILD_RECURSIVELY(ctrlSet, 'pos');
            local x, y, z = portalPosList[2], portalPosList[3], portalPosList[4];
            pos:SetTextByKey('x', x);
            pos:SetTextByKey('y', y);
            pos:SetTextByKey('z', z);

            -- picture
            local mapimage = ui.GetImage(mapName);
		    if mapimage == nil then
			    world.PreloadMinimap(mapName, true, true);
		    end

            local pic = GET_CHILD_RECURSIVELY(ctrlSet, 'pic');
		    pic:SetImage(mapName);

		    local mapprop = geMapTable.GetMapProp(mapName);
		    local mapPos = mapprop:WorldPosToMinimapPos(x, z, pic:GetWidth(), pic:GetHeight());
		    local mark = GET_CHILD_RECURSIVELY(ctrlSet, 'mark');
            local picBox = GET_CHILD_RECURSIVELY(ctrlSet, 'picBox');
		    local XC = picBox:GetX() + mapPos.x - 30;	
		    local YC = picBox:GetY() + mapPos.y - 40;
		    mark:Move(XC, YC);
        end
    end
    GBOX_AUTO_ALIGN(portalBox, 0, 0, 0, true, false);
end

function SAGE_PORTAL_WARP_REGISTER_CHECK_CLICK(parent, checkBox)
    local frame = parent:GetTopParentFrame();
    local selectText = GET_CHILD_RECURSIVELY(frame, 'selectText');
    local nowCnt = tonumber(selectText:GetTextByKey('current'));
    local maxCnt = tonumber(selectText:GetTextByKey('max'));
    if nowCnt >= maxCnt and checkBox:IsChecked() == 1 then
        checkBox:SetCheck(0);
        return;
    end

    PORTAL_SHOP_REGISTER_UPDATE_SELECTED_COUNT(frame);
end

function PORTAL_SHOP_REGISTER_UPDATE_SELECTED_COUNT(frame)
    local selectText = GET_CHILD_RECURSIVELY(frame, 'selectText');
    local maxCnt = GET_SAGE_PORTAL_MAX_COUNT_C();
    local selectedCnt = 0;
    for i = 1, maxCnt do
        local child = GET_CHILD_RECURSIVELY(frame, 'PORTAL_'..i);
        if child ~= nil then
            local registerCheck = GET_CHILD_RECURSIVELY(child, 'registerCheck');
            if registerCheck:IsChecked() == 1 then
                selectedCnt = selectedCnt + 1;
            end
        end
    end
    selectText:SetTextByKey('current', selectedCnt);
    return selectedCnt;
end

function PORTAL_SHOP_REGISTER_EXECUTE(parent, ctrl)
    local frame = parent:GetTopParentFrame();
	local repair = frame:GetChild('repair');
	local moneyGbox = repair:GetChild("moneyGbox");
	local moneyInput = GET_CHILD(moneyGbox, "MoneyInput");

	local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
	if price <= 0 then
		ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
		return;
	end

	local titleGbox = repair:GetChild("titleGbox");
	local titleInput = GET_CHILD(titleGbox, "titleInput");
	if string.len( titleInput:GetText() ) == 0 or "" == titleInput:GetText() then
		ui.MsgBox(ClMsg("InputTitlePlease"));
		return;
	end

    local selectedCnt = PORTAL_SHOP_REGISTER_UPDATE_SELECTED_COUNT(frame);
    if selectedCnt < 1 then
        ui.MsgBox(ClMsg('NotExistSelectePortal'));
        return;
    end

	local sklName = frame:GetUserValue("SKILLNAME");
	PORTAL_SHOP_REGISTER_CREATE_PORTAL_INFO(frame, sklName, price);	

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. sklName];
	local name, cnt = checkFunc(invItemList, frame);

	if 0 == cnt then
		ui.MsgBox(ClMsg("NotEnoughRecipe"));
		return;
	end

	local material = session.GetInvItemByName(name);
	if nil == material then
		return;
	end

	if true == material.isLockState then
		ui.MsgBox(ClMsg("MaterialItemIsLock"));
		return;
	end

	session.autoSeller.RequestRegister(sklName, 'Portal', titleInput:GetText(), sklName);    
end

function PORTAL_SHOP_REGISTER_CREATE_PORTAL_INFO(frame, sklName, price)
    session.autoSeller.ClearGroup(sklName);
    local maxCnt = GET_SAGE_PORTAL_MAX_COUNT_C();    
    for i = 1, maxCnt do
        local child = GET_CHILD_RECURSIVELY(frame, 'PORTAL_'..i);
        if child ~= nil then
            local registerCheck = GET_CHILD_RECURSIVELY(child, 'registerCheck');
            if registerCheck:IsChecked() == 1 then
                local info = session.autoSeller.CreateToGroup(sklName);
	            info.classID = i;
                info.price = price;
            end
        end
    end
end