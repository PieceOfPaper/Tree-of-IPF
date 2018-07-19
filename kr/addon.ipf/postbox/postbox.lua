

POSTBOX_LAST_GBOX_SCROLL_POS = 0
POSTBOX_LAST_GBOX_SCROLL_POS_NEW = 0

function POSTBOX_ON_INIT(addon, frame)

	addon:RegisterMsg('ADD_POSTBOX_MSG', 'UPDATE_POSTBOX_LETTERS');
	
end

function POSTBOX_OPEN(frame)
	
	local gbox_list = GET_CHILD_RECURSIVELY(frame,"gbox_list")
	if gbox_list ~= nil then
		gbox_list:SetScrollPos(0);
	end
	local gbox_new = GET_CHILD_RECURSIVELY(frame,"gbox_new")
	if gbox_new ~= nil then
		gbox_new:SetScrollPos(0);
	end
end


function POSTBOX_FIRST_OPEN(frame)

	POSTBOX_LAST_GBOX_SCROLL_POS = 0
	POSTBOX_LAST_GBOX_SCROLL_POS_NEW = 0
	
	UPDATE_POSTBOX_LETTERS(frame);
end

function GET_MSG_TITLE(msgInfo)

	if msgInfo:GetDBType() == POST_BOX_DB_ACCOUNT then
		local titleText = ScpArgMsg(msgInfo:GetTitle()) .. " (" ..  msgInfo:GetFromName().. ")";
		return titleText;
	end

	return msgInfo:GetTitle();
end

function UPDATE_POSTBOX_ITEM(ctrlSet, msgInfo)
	local slotHeight = 50;
	local itemcnt = msgInfo:GetItemVecSize();

	local slotx = 0
	local sloty = 0
	local labelline_2 = GET_CHILD_RECURSIVELY(ctrlSet, "labelline_2")
	labelline_2:ShowWindow(0)

	DESTROY_CHILD_BYNAME(ctrlSet, "SLOT_");

					

	for j = 0 , itemcnt - 1 do

		labelline_2:ShowWindow(1)
		local itemInfo = msgInfo:GetItemByIndex(j);

		slotx = slotHeight* (j%8) + 10
		sloty = slotHeight* math.floor(j/8) + 40

		local slot = ctrlSet:CreateControl("slot", "SLOT_" .. j, slotHeight, slotHeight, ui.LEFT, ui.TOP, slotx, sloty, 0, 0);
		slot = tolua.cast(slot, 'ui::CSlot');
		slot:EnableDrag(0);
		slot:ShowWindow(1);
		slot:SetSelectedImage('socket_slot_check')
		AUTO_CAST(slot);
		local itemCls = GetClassByType("Item", itemInfo.itemType);
		SET_SLOT_ITEM_INFO(slot, itemCls, itemInfo.itemCount);

		if itemInfo.isTaken == true then
			slot:GetIcon():SetGrayStyle(1);
		else
			slot:GetIcon():SetGrayStyle(0);
			slot:SetEventScript(ui.LBUTTONUP, "DO_SELECT_POSTBOX_ITEM");
			slot:SetUserValue("ITEM_INDEX", j);
						
		end
	end

	local addheight = sloty + 40
	ctrlSet:Resize(ctrlSet:GetOriginalWidth(),addheight + ctrlSet:GetOriginalHeight() )

end

function UPDATE_POSTBOX_LETTERS_LIST(gbox_list, onlyNewMessage, startindex)

	if startindex == nil then
		startindex = 0
	end

	if startindex == 0 then
		gbox_list:RemoveAllChild();
	end

	local x = 0;
	local y = 0;

	--for dbType = 0, 1 do
		local cnt = session.postBox.GetMessageCount();
		local drawindex = gbox_list:GetChildCount();

		for i = startindex , cnt - 1 do

			if i >= cnt then
				break;
			end

			local msgInfo = session.postBox.GetMessageByIndex(i);

			if onlyNewMessage == false or (msgInfo:GetItemCount() > 0 and msgInfo:GetItemTakeCount() == 0 ) then
				drawindex = drawindex + 1

				local beforectrl = GET_CHILD_RECURSIVELY(gbox_list,"ITEM_" ..(drawindex-1))

				if beforectrl == nil then
					y = 0
				else
					y = beforectrl:GetHeight() + beforectrl:GetY();
				end

				local ctrlSet = gbox_list:CreateOrGetControlSet("postbox_list2", "ITEM_" ..drawindex, x, y);
				if ctrlSet ~= nil then
				
					ctrlSet:SetUserValue("LETTER_ID", msgInfo:GetID());
					ctrlSet:SetUserValue("DB_TYPE", msgInfo:GetDBType());
					ctrlSet:ShowWindow(1);

					local title = ctrlSet:GetChild("title");
					local titleText = GET_MSG_TITLE(msgInfo);

					if msgInfo:GetItemCount() > 0 then

						if msgInfo:GetItemTakeCount() > 0 then
							titleText = "{img M_message_open 30 30 }" .. titleText
						else
							titleText = "{img M_message_Unopen 30 30 }" .. titleText
						end

					end

					title:SetTextByKey("value", titleText);

				
					UPDATE_POSTBOX_ITEM(ctrlSet, msgInfo);
					
					local timestring = imcTime.GetStringSysTimeYYMMDDHHMM(msgInfo:GetTime())
					local deleteTimeText = nil

					if  timestring == "900-01-01 00:00" or (msgInfo:GetDBType() == POST_BOX_DB_ACCOUNT and timestring == "900-01-01 00:00") then
						deleteTimeText = ScpArgMsg("AutoDeleteTime","Time",ScpArgMsg("InfiDeleteTime") );
					else
						deleteTimeText = ScpArgMsg("AutoDeleteTime","Time",imcTime.GetStringSysTimeYYMMDDHHMM(msgInfo:GetTime()) );
					end	
			
					ctrlSet:SetTextTooltip("{@st41}".. GET_MSG_TITLE(msgInfo).."{/}{nl} {nl}"..msgInfo:GetMessage().."{nl} {nl} {nl}{#666666}"..deleteTimeText);
			
					deleteTimeRText = GET_CHILD_RECURSIVELY(ctrlSet, "deleteTime")
					deleteTimeRText:SetTextByKey("time",deleteTimeText)

				end
			end
		end
	--end
	
	gbox_list:SetEventScript(ui.SCROLL, "SCROLL_POSTBOX_GBOX");

end

function DO_SELECT_POSTBOX_ITEM(parent, slot)

	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(0);

	if slot:IsSelected() == 0 then
		slot:Select(1)
	else
		slot:Select(0)
	end
end

function POSTBOX_SELECT_ALL_ITEM(ctrlset)

	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(0);
	
	for i = 0 , 200 do

		local slot = GET_CHILD(ctrlset,"SLOT_" .. i)

		if slot ~= nil then
			if slot:GetIcon():IsGrayStyle() == 0 then
				if slot:IsSelected() == 0 then
					slot:Select(1)
				end
			end
		else
			break;
		end
	end

end

function POSTBOX_GET_SELECTED_ITEM(ctrlset)
	
	local indexlist = ""

	for i = 0 , 200 do

		local slot = GET_CHILD(ctrlset,"SLOT_" .. i)

		if slot ~= nil then
			if slot:GetIcon():IsGrayStyle() == 0 then
				if slot:IsSelected() == 1 then
					
					local eachindex = slot:GetUserValue("ITEM_INDEX");

					if eachindex ~= "None" then

						if indexlist == "" then
							indexlist = eachindex;
						else
							indexlist = indexlist .. "/" .. eachindex;
						end
						
					end

				end
			end
		else
			break;
		end
	end

	if indexlist == "" then
		return;
	end

	

	local letterid = ctrlset:GetUserValue("LETTER_ID");
	local dbType = ctrlset:GetUserValue("DB_TYPE");
	
	local postboxframe = ui.GetFrame("postbox");
	postboxframe:SetUserValue("LETTER_ID", letterid);
	postboxframe:SetUserValue("DB_TYPE", dbType);

	local selectFrame = OPEN_BARRACK_SELECT_PC_FRAME("EXEC_SELECT_POSTBOX_ITEM_PC", "SelectCharacterToGetItem", true);
	selectFrame:SetUserValue("ITEM_INDEX_LIST",indexlist)
end

function SCROLL_POSTBOX_GBOX(parent, ctrl, str, wheel)

	if wheel == ctrl:GetScrollBarMaxPos() and POSTBOX_LAST_GBOX_SCROLL_POS ~= ctrl:GetScrollBarMaxPos() then
	
	local cnt = session.postBox.GetMessageCount();
		barrack.ReqPostBoxNextPage(cnt)

		POSTBOX_LAST_GBOX_SCROLL_POS = ctrl:GetScrollBarMaxPos()

	end
	
end


function UPDATE_POSTBOX_LETTERS(frame, msg, argStr, argNum)

	local gbox_list = frame:GetChild("gbox_list");
	UPDATE_POSTBOX_LETTERS_LIST(gbox_list, false, argNum);
	local gbox_new = frame:GetChild("gbox_new");
	UPDATE_POSTBOX_LETTERS_LIST(gbox_new, true, argNum);

	frame:Invalidate()
	
end


function OPEN_BARRACK_SELECT_PC_FRAME(execScriptName, msgKey, selectMyPC)

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
		local addControlSet = true;
		if selectMyPC == false then
			local mySession = session.GetMySession();
			if pcInfo:GetCID() == mySession:GetCID() then
				addControlSet = false;
			end
		end

		if addControlSet == true then
			local ctrlSet = gbox_charlist:CreateControlSet("postbox_itemget", "PIC_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
			ctrlSet:SetOverSound('button_cursor_over_3');
			ctrlSet:SetClickSound('button_click_big');
			ctrlSet:ShowWindow(1);	

			local pcApc = pcInfo:GetApc();
			local headIconName = ui.CaptureModelHeadImageByApperance(pcApc);		
			local pic = GET_CHILD(ctrlSet, "pic");
			pic:SetImage(headIconName);
			local name = ctrlSet:GetChild("name");
			local jobCls = GetClassByType("Job", pcApc:GetJob());
			local nameText = string.format("%s{nl}{@st66}%s", pcApc:GetName(), GET_JOB_NAME(jobCls, pcApc:GetGender()));
			ctrlSet:SetUserValue("PC_NAME", pcApc:GetName());
			name:SetTextByKey("value", nameText);

			ctrlSet:SetEventScript(ui.LBUTTONUP, "SELECT_POSTBOX_ITEM_PC");
		end
	end	

	GBOX_AUTO_ALIGN(gbox_charlist, 0, 1, 0, true, false);
	return selectFrame;

end

function SELECT_POSTBOX_ITEM_PC(parent, ctrl)

	imcSound.PlaySoundEvent("sys_popup_open_1");

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

	local itemIndexs = selectFrame:GetUserValue("ITEM_INDEX_LIST");

	local postBoxFrame = ui.GetFrame("postbox");
	local letterID = postBoxFrame:GetUserValue("LETTER_ID");
	local dbType = postBoxFrame:GetUserValue("DB_TYPE");
	
	local accountInfo = session.barrack.GetMyAccount();
	local pcInfo = accountInfo:GetByPCName(pcName);

	local msgInfo = session.postBox.GetMessageByID(letterID);
	if msgInfo == nil then
		return;
	end
	
	local indexList = SCR_STRING_CUT(itemIndexs, "/");
	if indexList == nil or #indexList == 0 then
		return;
	end
	
	local noTeamTradeItem = 0;
	for i = 1, #indexList do
		local selectedIndex = indexList[i];
		local itemInfo = msgInfo:GetItemByIndex(selectedIndex);
		local itemCls = GetClassByType("Item", itemInfo.itemType);
		
		local teamTradeProp = TryGetProp(itemCls, 'TeamTrade');
		local lifeTimeProp = TryGetProp(itemCls, 'LifeTime', 0);
		if teamTradeProp ~= 'YES' or lifeTimeProp ~= 0 then
			noTeamTradeItem = noTeamTradeItem + 1;
		end
	end
	
	if noTeamTradeItem > 0 then
		local yesScp = string.format("EXEC_SELECT_POSTBOX_ITEM_PC_AFTER_TEAM_TRADE_CHECK(\"%s\", \"%s\", \"%s\", \"%s\")", dbType, letterID, pcInfo:GetCID(), itemIndexs);
		ui.MsgBox(ScpArgMsg("ReallyGiveItemTo{PC}NoTeamTradeItem", "PC", pcName, "ItemCount", noTeamTradeItem), yesScp, "None");
		return;
	end
	
	barrack.ReqGetPostBoxItem(dbType, letterID, pcInfo:GetCID(), itemIndexs);
end

function EXEC_SELECT_POSTBOX_ITEM_PC_AFTER_TEAM_TRADE_CHECK(dbType, letterID, pcCID, itemIndexs)
	barrack.ReqGetPostBoxItem(dbType, letterID, pcCID, itemIndexs);
end

function POSTBOX_DELETE(parent, ctrl)

	imcSound.PlaySoundEvent("sys_popup_open_1");

	local id = parent:GetUserValue("LETTER_ID");
	local dbType = parent:GetUserValue("DB_TYPE");
	local itemCnt = session.postBox.GetMessageRemainItemCountByID(id);
	if 0 < itemCnt then
		ui.SysMsg(ClMsg("CanTakeItemFromPostBox"));
		return;
	end

	local msgInfo = session.postBox.GetMessageByID(id);
	if msgInfo == nil then
		return;
	end

	local yesScp = string.format("EXEC_DELETE_POSTBOX(\"%s\", %d, %d)", id, POST_BOX_STATE_DELETE, dbType);
	ui.MsgBox(ScpArgMsg("Auto_JeongMal_SagJeHaSiKessSeupNiKka?"), yesScp, "None");

end

function EXEC_DELETE_POSTBOX(id, state, dbType)
	
	imcSound.PlaySoundEvent("system_latter_delete");

	barrack.ReqChangePostBoxState(dbType, id, state);	
end


function POSTBOX_UPDATE_LIST(msgID, result)

	local frame = ui.GetFrame("postbox");
	UPDATE_POSTBOX_LETTERS(frame);

	if result == 1 then
		ui.SysMsg(ClMsg("ReceievedItem"));
	end

end

function POST_BOX_STATE_CHANGE(msgID)

end

	
function POST_BOX_DETAIL_RESULT()

end