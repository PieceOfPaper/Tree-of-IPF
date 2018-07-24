
function PCBANG_POPUP_PREVIEW_ON_INIT(addon, frame)
    addon:RegisterMsg("PCBANG_POPUP_PREVIEW_INIT", "ON_PCBANG_POPUP_PREVIEW_INIT");
end

function ON_PCBANG_POPUP_PREVIEW_INIT(frame, msg, argstr, itemID)
    PCBANG_POPUP_PREVIEW_OPEN(itemID);
end

function PCBANG_POPUP_PREVIEW_OPEN(itemID)
    local frame = ui.GetFrame("pcbang_popup_preview");
    
    local cls = GetClassByType("Item", itemID);
    if cls == nil then
        frame:ShowWindow(0);
        return;
    end
    
    local costumeCls = nil;
    if cls.ClassType == "Outer" then
        costumeCls = cls;
    else    
        local firstCostumeName = GET_FIRST_COSTUME_NAME_FROM_PACKAGE(cls.ClassName);
        if firstCostumeName ~= nil then
            costumeCls =  GetClass("Item", firstCostumeName);
        end
    end

    if costumeCls == nil then
        frame:ShowWindow(0);
        return;
    end

    local item_name = GET_CHILD(frame, "item_name");
    item_name:SetText(cls.Name);

    SET_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, costumeCls.ClassID, 99);
    frame:ShowWindow(1);
end

function ON_PCBANG_POPUP_PREVIEW_CLOSE(frame)
    frame:SetUserValue("ItemID", 0);
    frame:ShowWindow(0);
end

function ON_ROTATE_LEFT_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, btn)
    local itemID = frame:GetUserIValue("ItemID");
    SET_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, itemID, 2)
end

function ON_ROTATE_RIGHT_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, btn)
    local itemID = frame:GetUserIValue("ItemID");
    SET_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, itemID, 1)
end

function SET_PCBANG_POPUP_PREVIEW_SILHOUETTE(frame, itemID, rotDir)
    local cls = GetClassByType("Item", itemID);
    if cls == nil then
        frame:ShowWindow(0);
        return;
    end
    
    frame:SetUserValue("ItemID", itemID);

	local pcSession = session.GetMySession()
	if pcSession == nil then
		return;
	end
    
    local actor = GetMyActor();
    local apc = actor:GetPCApc();
    apc = pcSession:GetPCDummyApcFromApc(apc)
    
    local defaultEqpSlot = TryGetProp(cls, "DefaultEqpSlot")
    if defaultEqpSlot ~= nil  then
        apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), itemID);
    end
    apc:SetEquipItem(ES_HAIR, 0)

	local imgName_m = "None";
    apc:SetGender(1);
	if rotDir == 99 then
		imgName_m = ui.CaptureMyFullStdImageByAPC(apc, 1, 1);
		imgName_m = ui.CaptureMyFullStdImageByAPC(apc, 2, 1);
	else 
		imgName_m = ui.CaptureMyFullStdImageByAPC(apc, rotDir, 1);
    end
    
    local imgName_f = "None";
    apc:SetGender(2);
	if rotDir == 99 then
		imgName_f = ui.CaptureMyFullStdImageByAPC(apc, 1, 1);
		imgName_f = ui.CaptureMyFullStdImageByAPC(apc, 2, 1);
    else 
        local tmpDir = rotDir;
        if tmpDir == 1 then
            tmpDir = 2;
        elseif tmpDir == 2 then
            tmpDir = 1;
        end
		imgName_f = ui.CaptureMyFullStdImageByAPC(apc, tmpDir, 1);
		imgName_f = ui.CaptureMyFullStdImageByAPC(apc, rotDir, 1);
    end

    local shihouette_m = GET_CHILD_RECURSIVELY(frame, "silhouette_male_pic")
    local shihouette_f = GET_CHILD_RECURSIVELY(frame, "silhouette_female_pic")
	shihouette_m:SetImage(imgName_m);
	shihouette_f:SetImage(imgName_f);
	frame:Invalidate();
end