
function REINFORCE_131014_ON_INIT(addon, frame)

	
end

function _CHECK_REINFORCE_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if item ~= nil then
		local obj = GetIES(item:GetObject());
		if REINFORCE_ABLE_131014(obj) == 1 or IS_MORU_ITEM(obj) == 1 then
			slot:GetIcon():SetGrayStyle(0);
		else
			slot:GetIcon():SetGrayStyle(1);
		end
	end
end

function REINFORCE_131014_ITEM_LOCK(guid)
	if nil == guid then
		guid = 'None'
	end

	local invframe = ui.GetFrame("inventory");
	invframe:SetUserValue("ITEM_GUID_IN_MORU", guid);
	INVENTORY_ON_MSG(invframe, 'UPDATE_ITEM_REPAIR');

	local rankresetFrame = ui.GetFrame("rankreset");
	if 1 == rankresetFrame:IsVisible() then
		RANKRESET_PC_TIMEACTION_STATE(rankresetFrame)
	end
end

function REINFORCE_131014_OPEN(frame)
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "_CHECK_REINFORCE_ITEM");
end

function REINFORCE_131014_CLOSE(frame)
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
end

function REINFORCE_131014_GET_ITEM(frame)
	local fromItemSlot = GET_CHILD(frame, "fromItemSlot", "ui::CSlot");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	local fromItem = GET_SLOT_ITEM(fromItemSlot);
	local fromMoru = GET_SLOT_ITEM(fromMoruSlot);
	
	return fromItem, fromMoru;
end

function REINFORCE_131014_UPDATE_MORU_COUNT(frame)
	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(frame);
	local hitCountDesc = frame:GetChild("hitCountDesc");
	local hitPriceDesc = GET_CHILD(frame, "hitPriceDesc", "ui::CRichText")
	if fromItem == nil or fromMoru == nil then
		hitCountDesc:ShowWindow(0);
		hitPriceDesc:ShowWindow(0);
		return;
	end

	hitCountDesc:ShowWindow(1);
	hitPriceDesc:ShowWindow(1);
	local fromItemObj = GetIES(fromItem:GetObject());
	local toItemObj = GetIES(fromMoru:GetObject());
	local hitCount = GET_REINFORCE_131014_HITCOUNT(fromItemObj, toItemObj);
	hitCountDesc:SetTextByKey("hitcount", hitCount);

	local moruObj = GetIES(fromMoru:GetObject());
	local price = GET_REINFORCE_131014_PRICE(fromItemObj, moruObj);
	hitPriceDesc:SetTextByKey("price", price);

end

function REINFORCE_131014_IS_ABLE(frame)
	
	local fromItem, fromMoru = UPGRADE2_GET_ITEM(frame);
	if fromItem == nil or fromMoru == nil then
		return false;
	end

	return true;
end

function REINFORCE_131014_MSGBOX(frame)
	
	local fromItem, fromMoru = UPGRADE2_GET_ITEM(frame);
	local fromItemObj = GetIES(fromItem:GetObject());
	local curReinforce = fromItemObj.Reinforce_2;

	local moruObj = GetIES(fromMoru:GetObject());
	local price = GET_REINFORCE_131014_PRICE(fromItemObj, moruObj)
	local hadmoney = GET_TOTAL_MONEY();

	if hadmoney < price then
		ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughMoney'));
		return;
	end
	
	local classType = TryGetProp(fromItemObj,"ClassType");
    
    if moruObj.ClassName ~= "Moru_Potential" and moruObj.ClassName ~= "Moru_Potential14d" then
    if fromItemObj.GroupName == 'Weapon' or (fromItemObj.GroupName == 'SubWeapon' and  classType ~='Shield') then
    	if curReinforce >= 5 then
               	if moruObj.ClassName == "Moru_Premium" or moruObj.ClassName == "Moru_Gold" or moruObj.ClassName == "Moru_Gold_14d" or moruObj.ClassName == "Moru_Gold_TA" then
                    ui.MsgBox(ScpArgMsg("GOLDMORUdontbrokenitemProcessReinforce?", "Auto_1", 3), "REINFORCE_131014_EXEC", "None");
                   	return;
               	else
    		ui.MsgBox(ScpArgMsg("WeaponWarningMSG", "Auto_1", 5), "REINFORCE_131014_EXEC", "None");
    		return;
    	end
        	end
    else
        if curReinforce >= 3 then
               	if moruObj.ClassName == "Moru_Premium" or moruObj.ClassName == "Moru_Gold" or moruObj.ClassName == "Moru_Gold_14d" or moruObj.ClassName == "Moru_Gold_TA" then
                    ui.MsgBox(ScpArgMsg("GOLDMORUdontbrokenitemProcessReinforce?", "Auto_1", 3), "REINFORCE_131014_EXEC", "None");
                   	return;
               	else
    		ui.MsgBox(ScpArgMsg("Over_+{Auto_1}_ReinforceItemCanBeBroken_ProcessReinforce?", "Auto_1", 3), "REINFORCE_131014_EXEC", "None");
    		return;
    	end
    end
	end
	end
	
	REINFORCE_131014_EXEC();
end

function REINFORCE_131014_EXEC()
	local frame = ui.GetFrame("reinforce_131014");
	local fromItem, fromMoru = REINFORCE_131014_GET_ITEM(frame);
	
	if fromItem ~= nil and fromMoru ~= nil then
		session.ResetItemList();
		session.AddItemID(fromItem:GetIESID());
		session.AddItemID(fromMoru:GetIESID());
		local resultlist = session.GetItemIDList();
		item.DialogTransaction("ITEM_REINFORCE_131014", resultlist);
		frame:ShowWindow(0);
	end
	
	local fromItemSlot = GET_CHILD(frame, "fromItemSlot", "ui::CSlot");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	CLEAR_SLOT_ITEM_INFO(fromItemSlot);
	CLEAR_SLOT_ITEM_INFO(fromMoruSlot);

	REINFORCE_131014_UPDATE_MORU_COUNT(frame);

end


function UPGRADE2_GET_ITEM(frame)
	local fromItemSlot = GET_CHILD(frame, "fromItemSlot", "ui::CSlot");
	local fromMoruSlot = GET_CHILD(frame, "fromMoruSlot", "ui::CSlot");
	local fromItem = GET_SLOT_ITEM(fromItemSlot);
	local fromMoru = GET_SLOT_ITEM(fromMoruSlot);
	return fromItem, fromMoru;
end
