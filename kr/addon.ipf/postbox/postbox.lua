
function POSTBOX_ON_INIT(addon, frame)

	
end

function POSTBOX_FIRST_OPEN(frame)

	local contents = frame:GetChild("contents");
	contents:ShowWindow(0);
	UPDATE_POSTBOX_LETTERS(frame);


end

function UPDATE_POSTBOX_LETTERS_LIST(gbox_list, onlyNewMessage)

	gbox_list:RemoveAllChild();

	local x = 0;
	local cnt = session.postBox.GetMessageCount();
	for i = 0 , cnt - 1 do
		local msgInfo = session.postBox.GetMessageByIndex(i);
		if onlyNewMessage == false or msgInfo:IsNewMessage() == true then
			local ctrlSet = gbox_list:CreateControlSet("postbox_list", "ITEM_" .. msgInfo:GetID(), x, 0);
			if ctrlSet ~= nil then
				ctrlSet:SetUserValue("LETTER_ID", msgInfo:GetID());
				ctrlSet:ShowWindow(1);
				local title = ctrlSet:GetChild("title");
				local titleText = msgInfo:GetTitle();
				if msgInfo:GetItemCount() > 0 then
					local remainCount = msgInfo:GetItemCount() - msgInfo:GetItemTakeCount();
					titleText = titleText .. " " .. string.format(" (%d/%d)", remainCount, msgInfo:GetItemCount());
				end

				title:SetTextByKey("value", titleText);

				local readflag = ctrlSet:GetChild("readflag");
				if msgInfo:IsNewMessage() == true then
					readflag:ShowWindow(0);
				else
					readflag:ShowWindow(1);
				end
				ctrlSet:SetEventScript(ui.LBUTTONUP, "REQ_READ_LETTER");
			end
		end
	end
	
	GBOX_AUTO_ALIGN(gbox_list, 0, 1, 0, true, false);

end

function UPDATE_POSTBOX_LETTERS(frame)

	local gbox_list = frame:GetChild("gbox_list");
	UPDATE_POSTBOX_LETTERS_LIST(gbox_list, false);
	local gbox_new = frame:GetChild("gbox_new");
	UPDATE_POSTBOX_LETTERS_LIST(gbox_new, true);
	
end

function REQ_READ_LETTER(parent, ctrl)

	local id = ctrl:GetUserValue("LETTER_ID");
	OPEN_LETTER(parent:GetTopParentFrame(), id);

end

function OPEN_LETTER(frame, id)

	local msgInfo = session.postBox.GetMessageByID(id);
	if msgInfo == nil then
		return;
	end

	frame:SetUserValue("LETTER_ID", id);
	local ctrlSet = frame:GetChild("contents");
	ctrlSet:ShowWindow(1);
	ctrlSet:SetUserValue("LETTER_ID", id);

	local title = ctrlSet:GetChild("title");
	title:SetTextByKey("value", msgInfo:GetTitle());

	local content = ctrlSet:GetChild("content");
	if msgInfo.isDetailLoaded == false then
		content:SetTextByKey("value", ClMsg("NowLoading..."));	
		barrack.ReqChangePostBoxState(id, POST_BOX_STATE_REQ_LOAD);
	else
		POSTBOX_SET_LETTER_DETAIL(msgInfo, ctrlSet)
	end

end

function POSTBOX_SET_LETTER_DETAIL(msgInfo, ctrlSet)

	local content = ctrlSet:GetChild("content");
	content:SetTextByKey("value", msgInfo:GetMessage());	

	local attachedItems = ctrlSet:GetChild("attachedItems");
	attachedItems:RemoveAllChild();

	local slotHeight = attachedItems:GetHeight() - 15;
	local cnt = msgInfo:GetItemVecSize();
	for i = 0 , cnt - 1 do
		local itemInfo = msgInfo:GetItemByIndex(i);
		local slot = attachedItems:CreateControl("slot", "SLOT_" .. i, slotHeight, slotHeight, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		slot:ShowWindow(1);
		AUTO_CAST(slot);
		local itemCls = GetClassByType("Item", itemInfo.itemType);
		SET_SLOT_ITEM_INFO(slot, itemCls, itemInfo.itemCount);
		slot:SetUserValue("ATTACH_ITEM_INDEX", i);

		if itemInfo.isTaken == true then
			slot:GetIcon():SetGrayStyle(1);
		else
			slot:GetIcon():SetGrayStyle(0);
			slot:SetEventScript(ui.RBUTTONUP, "REQ_GET_POSTBOX_ITEM");
			slot:SetUserValue("ITEM_INDEX", i);
			slot:SetUserValue("ITEM_TYPE", itemInfo.itemType);
		end
	end

	GBOX_AUTO_ALIGN_HORZ(attachedItems, 10, 10, 0, true, false);

end

function OPEN_BARRACK_SELECT_PC_FRAME(execScriptName, msgKey)
	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(1);
	selectFrame:SetUserValue("EXECSCRIPT", execScriptName);
	local txt = selectFrame:GetChild("txt");
	txt:SetTextByKey("value", ScpArgMsg(msgKey));
	
	local gbox_charlist = selectFrame:GetChild("gbox_charlist");
	gbox_charlist:RemoveAllChild();
	local accountInfo = session.barrack.GetMyAccount();

	local cnt = accountInfo:GetPCCount();
	for i = 0 , cnt - 1 do
		local pcInfo = accountInfo:GetPCByIndex(i);
		local ctrlSet = gbox_charlist:CreateControlSet("postbox_itemget", "PIC_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		ctrlSet:ShowWindow(1);	

		local pcApc = pcInfo:GetApc();
		local headIconName = ui.CaptureModelHeadImageByApperance(pcApc);		
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(headIconName);
		local name = ctrlSet:GetChild("name");
		local jobCls = GetClassByType("Job", pcApc:GetJob());
		local nameText = string.format("%s (%s)", pcApc:GetName(), jobCls.Name);
		ctrlSet:SetUserValue("PC_NAME", pcApc:GetName());
		name:SetTextByKey("value", nameText);

		ctrlSet:SetEventScript(ui.LBUTTONUP, "SELECT_POSTBOX_ITEM_PC");
	end	

	GBOX_AUTO_ALIGN(gbox_charlist, 0, 1, 0, true, false);
	return selectFrame;

end

function REQ_GET_POSTBOX_ITEM(parent, slot)

	local selectFrame = OPEN_BARRACK_SELECT_PC_FRAME("EXEC_SELECT_POSTBOX_ITEM_PC", "SelectCharacterToGetItem");
	local itemIndex = slot:GetUserIValue("ITEM_INDEX");
	selectFrame:SetUserValue("ITEM_INDEX", itemIndex);
	local itemType = slot:GetUserIValue("ITEM_TYPE");
	selectFrame:SetUserValue("ITEM_TYPE", itemType);
	
end

function SELECT_POSTBOX_ITEM_PC(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local pcName = ctrl:GetUserValue("PC_NAME");
	local msgBoxString = ScpArgMsg("ReallyGiveItemTo{PC}", "PC", pcName);


	local selectFrame = ui.GetFrame("postbox_itemget");
	local itemType = selectFrame:GetUserIValue("ITEM_TYPE");
	local itemCls = GetClassByType("Item", itemType);
	if itemCls ~= nil and itemCls.GroupName == 'Premium' then
		msgBoxString = ScpArgMsg("ReallyGivePremiumItemTo{PC}", "PC", pcName);
	end

	local execScript = frame:GetUserValue("EXECSCRIPT");
	local scpString = string.format("%s(\"%s\")", execScript, pcName);
	ui.MsgBox(msgBoxString, scpString, "None");

end

function EXEC_SELECT_POSTBOX_ITEM_PC(pcName)
	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(0);
	local itemIndex = selectFrame:GetUserIValue("ITEM_INDEX");

	local postBoxFrame = ui.GetFrame("postbox");
	local letterID = postBoxFrame:GetUserValue("LETTER_ID");
	
	local accountInfo = session.barrack.GetMyAccount();
	local pcInfo = accountInfo:GetByPCName(pcName);

	local msgInfo = session.postBox.GetMessageByID(letterID);
	if msgInfo == nil then
		return;
	end

	barrack.ReqGetPostBoxItem(letterID, pcInfo:GetCID(), itemIndex);	

end

function POSTBOX_STORE(parent, ctrl)
	
	local id = parent:GetUserValue("LETTER_ID");
	local msgInfo = session.postBox.GetMessageByID(id);
	if msgInfo == nil then
		return;
	end

	barrack.ReqChangePostBoxState(id, POST_BOX_STATE_STORE);
end

function POSTBOX_DELETE(parent, ctrl)

	local id = parent:GetUserValue("LETTER_ID");
	local itemCnt = session.postBox.GetMessageRemainItemCountByID(id);
	if 0 < itemCnt then
		ui.SysMsg(ClMsg("CanTakeItemFromPostBox"));
		return;
	end

	local msgInfo = session.postBox.GetMessageByID(id);
	if msgInfo == nil then
		return;
	end

	local yesScp = string.format("EXEC_DELETE_POSTBOX(%d, %d)", id, POST_BOX_STATE_DELETE);
	ui.MsgBox(ScpArgMsg("Auto_JeongMal_SagJeHaSiKessSeupNiKka?"), yesScp, "None");

end

function EXEC_DELETE_POSTBOX(id, state)
	barrack.ReqChangePostBoxState(id, state);	
end

function POST_BOX_DETAIL_RESULT(result, msgID)

	local frame = ui.GetFrame("postbox");
	local ctrlSet = frame:GetChild("contents");
	local content = ctrlSet:GetChild("content");
	if result == 0 then
		content:SetTextByKey("value", ClMsg("LoadFailed_TryLater"));		
	else
		local msgInfo = session.postBox.GetMessageByID(msgID);
		POSTBOX_SET_LETTER_DETAIL(msgInfo, ctrlSet);
		UPDATE_POSTBOX_MSG_READ(frame, msgID);
	end
end

function UPDATE_POSTBOX_MSG_READ(frame, msgID)

	local gbox_list = frame:GetChild("gbox_list");
	local ctrlSet = gbox_list:GetChild("ITEM_" .. msgID);
	if ctrlSet ~= nil then
		local readflag = ctrlSet:GetChild("readflag");
		readflag:ShowWindow(1);
	end
	
	local gbox_new = frame:GetChild("gbox_new");
	gbox_new:RemoveChild("ITEM_" ..msgID);
	--GBOX_AUTO_ALIGN(gbox_new, 0, 1, 0, true, false);

end

function POST_BOX_DELETE(msgID)

	local frame = ui.GetFrame("postbox");
	local ctrlSet = frame:GetChild("contents");
	if ctrlSet:GetUserValue("LETTER_ID") == msgID then
		ctrlSet:ShowWindow(0);
	end

	local gbox_list = frame:GetChild("gbox_list");
	gbox_list:RemoveChild("ITEM_" ..msgID);
	GBOX_AUTO_ALIGN(gbox_list, 0, 1, 0, true, false);

end

function POST_BOX_STATE_CHANGE(msgID)

end

function POST_BOX_ITEM_GET_RESULT(msgID, result)

	local frame = ui.GetFrame("postbox");
	OPEN_LETTER(frame, msgID);
	UPDATE_POSTBOX_LETTERS(frame);

	ui.SysMsg(ClMsg("ReceievedItem"));

end
	