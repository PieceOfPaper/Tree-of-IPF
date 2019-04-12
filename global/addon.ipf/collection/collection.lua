
USE_COLLECTION_SHOW_ALL = 0;
REMOVE_ITEM_SKILL = 7

function COLLECTION_ON_INIT(addon, frame)


	addon:RegisterMsg("ADD_COLLECTION", "ON_ADD_COLLECTION");
	addon:RegisterMsg("COLLECTION_ITEM_CHANGE", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_ADD", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_IN", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_POST_REMOVE", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_CHANGE_COUNT", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterMsg("UPDATE_READ_COLLECTION_COUNT", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterMsg('COLLECTION_UI_OPEN', 'COLLECTION_DO_OPEN');
end

function COLLECTION_DO_OPEN(frame)
    ui.ToggleFrame('collection')
	ui.ToggleFrame('inventory')
	RUN_CHECK_LASTUIOPEN_POS(frame)
end

function UI_TOGGLE_COLLECTION()

	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('collection')
	ui.ToggleFrame('inventory')
end

function COLLECTION_ON_RELOAD(frame)
	COLLECTION_FIRST_OPEN(frame);
end

function COLLECTION_FIRST_OPEN(frame)
	local showoption = GET_CHILD(frame, "showoption", "ui::CDropList");
	showoption:ClearItems();
	showoption:AddItem("0",  ClMsg("HaveList"), 0);
	showoption:AddItem("1",  ClMsg("AllList"), 0);

	showoption:SelectItem(config.GetConfigInt("CollectionShowType", 0));

	if 0 == USE_COLLECTION_SHOW_ALL then
		showoption:ShowWindow(0);
	end

	UPDATE_COLLECTION_LIST(frame);
end

function ON_ADD_COLLECTION(frame, msg)

	UPDATE_COLLECTION_LIST(frame);
	local colls = session.GetMySession():GetCollection();
	if colls:Count() == 1 then
		SYSMENU_FORCE_ALARM("collection", "Collection");
	end
	imcSound.PlaySoundEvent('cllection_register');
	frame:Invalidate();

	end

function ON_COLLECTION_ITEM_CHANGE(frame, msg, str, type, removeType)
	UPDATE_COLLECTION_LIST(frame, str, removeType);
	UPDATE_COLLECTION_DETAIL(frame);
end

function COLLECTION_TYPE_CHANGE(frame, ctrl)

	local showoption = tolua.cast(ctrl, "ui::CDropList");
	config.SetConfig("CollectionShowType", showoption:GetSelItemIndex());

	local col = GET_CHILD(frame, "col", "ui::CCollection");
	col:HideDetailView();
	UPDATE_COLLECTION_LIST(frame);
end

function SET_COLLECTION_PIC(frame, pic, itemCls, coll, drawitemset)

	local colorTone = nil;
	local info = nil;
	
	if coll ~= nil then

		local collecount = coll:GetItemCountByType(itemCls.ClassID);
		local invcount = session.GetInvItemCountByType(itemCls.ClassID);
		local showedcount = 0

		if drawitemset[itemCls.ClassID] ~= nil then
			showedcount = drawitemset[itemCls.ClassID]
		end

		-- 1. 내가 이미 모은 것들
		if collecount > showedcount then
			
			if drawitemset[itemCls.ClassID] == nil then
				drawitemset[itemCls.ClassID] = 1
			else
				drawitemset[itemCls.ClassID] = drawitemset[itemCls.ClassID] + 1
			end

			return "Can Take", drawitemset[itemCls.ClassID]
		end

		-- 2. 꼽으면 되는 것들

		if invcount + collecount > showedcount then
			if drawitemset[itemCls.ClassID] == nil then
				drawitemset[itemCls.ClassID] = 1
			else
				drawitemset[itemCls.ClassID] = drawitemset[itemCls.ClassID] + 1
			end
			colorTone = frame:GetUserConfig("ITEM_EXIST_COLOR");
		else
			colorTone = frame:GetUserConfig("BLANK_ITEM_COLOR");
		end
		
	else
	--[[
		local invItem = session.GetInvItemByType(itemCls.ClassID)
		if invItem ~= nil then
			colorTone = frame:GetUserConfig("ITEM_EXIST_COLOR");
		else
			colorTone = frame:GetUserConfig("NOT_HAVE_COLOR");
		end
		]]
	end

	if colorTone ~= nil then
		pic:SetColorTone(colorTone);
	end

	return info;
end

function GET_COLLECTION_COUNT(type, coll)

	local curCount = 0;
	if coll ~= nil then
		curCount = coll:GetItemCount();
	end

	local info = geCollectionTable.Get(type);
	local maxCount = info:GetTotalItemCount();

	return curCount, maxCount;
end

function COLLECTION_OPEN(frame)
	UPDATE_COLLECTION_LIST(frame);
	
end

function COLLECTION_CLOSE(frame)

	local inventory = ui.GetFrame("inventory")
	inventory:ShowWindow(0)
	
	UNREGISTERR_LASTUIOPEN_POS(frame)
end

function SET_COLLECTION_SET(frame, ctrlSet, type, coll)

	ctrlSet:SetUserValue("COLLECTION_TYPE", type);
	local cls = GetClassByType("Collection", type);
	local collec_name = GET_CHILD(ctrlSet, "collec_name", "ui::CRichText");
	collec_name:SetTextByKey("name", cls.Name);

	local itemBox = GET_CHILD(ctrlSet, "items", "ui::CGroupBox");
	if coll == nil then
		itemBox:SetColorTone(frame:GetUserConfig("NOT_HAVE_COLOR"));
	end

	itemBox:RemoveAllChild();
	local itemBoxWidth = itemBox:GetWidth();
	local itemBoxHeight = itemBox:GetHeight();
	local marginX = 10;
	local marginY = 10;
	local picInBox = 3;
	local picWidth = math.floor((itemBoxWidth - marginX * 2) / picInBox);
	local picHeight = math.floor((itemBoxHeight - marginY * 2) / picInBox);

	local drawItemSet = {}

	for i = 1 , 9 do
		local itemName = cls["ItemName_" .. i];
		if itemName == "None" then
			break;
		end

		local itemCls = GetClass("Item", itemName);
		if itemCls == nil then
			break;
		end

		local row = math.floor((i - 1) / picInBox);
		local col = (i - 1)  % picInBox;
		local x = marginX + col * picWidth;
		local y = marginY + row * picHeight;

		local pic = itemBox:CreateOrGetControl('picture', "IMG_" .. i, x, y, picWidth, picHeight);
		pic:EnableHitTest(0);
		pic = tolua.cast(pic, "ui::CPicture");
		pic:SetEnableStretch(1);
		SET_COLLECTION_PIC(frame, pic, itemCls, coll, drawItemSet);
		pic:SetImage(itemCls.Icon);
	end

	local collec_name = ctrlSet:GetChild("collec_name");
	local collec_count = ctrlSet:GetChild("collec_count");
	collec_name:SetTextByKey("name", cls.Name);

	local curCount, maxCount = GET_COLLECTION_COUNT(type, coll);
	collec_count:SetTextByKey("curcount", curCount);
	collec_count:SetTextByKey("maxcount", maxCount);

	local outline_pic = GET_CHILD(ctrlSet, "outline", "ui::CPicture");
	local newicon_pic = GET_CHILD(ctrlSet, "newicon", "ui::CPicture");
	local compicon_pic = GET_CHILD(ctrlSet, "compicon", "ui::CPicture");

	etcObj = GetMyEtcObject();
	local isread = etcObj['CollectionRead_' .. cls.ClassID]
	
	local skinName;
	if curCount >= maxCount then
		skinName = frame:GetUserConfig("A_SKIN");
		outline_pic:ShowWindow(1);
		compicon_pic:ShowWindow(1);
	else
		skinName = frame:GetUserConfig("A_SKIN");
		outline_pic:ShowWindow(0);
		compicon_pic:ShowWindow(0);
	end

	if isread ~= 0 then
		newicon_pic:ShowWindow(0)
	else
		newicon_pic:ShowWindow(1)
	end

	itemBox:SetSkinName(skinName);

end

function UPDATE_COLLECTION_LIST(frame, addType, removeType)

	local showoption = GET_CHILD(frame, "showoption", "ui::CDropList");
	local showAll = showoption:GetSelItemIndex();

	if 0 == USE_COLLECTION_SHOW_ALL then
		showAll = 0;
	end

	local col = GET_CHILD(frame, "col", "ui::CCollection");
	DESTROY_CHILD_BYNAME(col, "DECK_");
	local width = ui.GetControlSetAttribute("deck", 'width');
	local height = ui.GetControlSetAttribute("deck", 'height');
	col:SetItemSize(width, height);

	local pc = session.GetMySession();
	local colls = pc:GetCollection();
	
	if showAll == 1 then
		local clsList, cnt = GetClassList("Collection");
		for i = 0 , cnt - 1 do
			local cls = GetClassByIndexFromList(clsList, i);
			local ctrlSet = col:CreateOrGetControlSet('deck', "DECK_" .. i, width, height);
			ctrlSet:ShowWindow(1);
			local coll = colls:Get(cls.ClassID);
			SET_COLLECTION_SET(frame, ctrlSet, cls.ClassID, coll);
		end
	else
		local cnt = colls:Count();
		for i = 0 , cnt - 1 do
			local coll = colls:GetByIndex(i);
			local ctrlSet = col:CreateOrGetControlSet('deck', "DECK_" .. i, width, height);
			ctrlSet:ShowWindow(1);
			SET_COLLECTION_SET(frame, ctrlSet, coll.type, coll);
		end
	end
	
	if 'UNEQUIP' ~= addType and REMOVE_ITEM_SKILL ~= 7 then
		imcSound.PlaySoundEvent("quest_ui_alarm_2");
	end

	col:UpdateItemList();
end

function OPEN_DECK_DETAIL(parent, ctrl)

	imcSound.PlaySoundEvent('cllection_inven_open');
	local col = parent:GetParent();
	col = tolua.cast(col, "ui::CCollection");
	col:DetailView(parent, "MAKE_DECK_DETAIL");
end

function ATTACH_TEXT_TO_OBJECT(ctrl, objName, text, x, y, width, height, alignX, alignY, enableFixWIdth, textAlignX, textAlignY, textOmitByWidth)

	local title = ctrl:CreateControl('richtext', objName, x, y, width, height);
	title = tolua.cast(title, "ui::CRichText");
	title:SetGravity(alignX, alignY);
	title:EnableResizeByText(1);
	if textOmitByWidth ~= nil then
		title:EnableTextOmitByWidth(textOmitByWidth);
	end

	if enableFixWIdth ~= nil then
		title:SetTextFixWidth(enableFixWIdth);
	end

	if textAlignX ~= nil then
		title:SetTextAlign(textAlignX, textAlignY);
	end

	title:SetText(text);
	return (y + title:GetHeight()), title;
end

function UPDATE_COLLECTION_DETAIL(frame)

	local col = GET_CHILD(frame, "col", "ui::CCollection");
	local detailView = col:GetDetailView();
	if detailView:IsVisible() == 1 then
		local type = frame:GetUserIValue("DETAIL_VIEW_TYPE");
		DETAIL_UPDATE(frame, detailView, type, 1)
	end
end

function MAKE_DECK_DETAIL(frame, collection, ctrlset, detailView)

	local type = ctrlset:GetUserIValue("COLLECTION_TYPE");
	frame:SetUserValue("DETAIL_VIEW_TYPE", type);
	DETAIL_UPDATE(frame, detailView, type)

end

function GET_COLLECTION_EFFECT_DESC(type)

	local info = geCollectionTable.Get(type);
	local ret = "";
	local propCnt = info:GetPropCount();
	local isAccountColl = false;
	if 0 == propCnt then
		 propCnt = info:GetAccPropCount();
		isAccountColl = true;
	end

	for i = 0 , propCnt - 1 do
		local prop = nil;
		if false == isAccountColl then
			prop = info:GetProp(i);
		else
			prop = info:GetAccProp(i);
		end

		if i >= 1 then
			ret = ret .. " ";
		end

		if nil ~= prop then
		if prop.value > 0 then
			ret = ret ..  string.format("%s +%d", ClMsg(prop:GetPropName()), prop.value);
		elseif prop.value == 0 then
			ret = ret ..  string.format("%s", ClMsg(prop:GetPropName()), prop.value);
		else
			ret = ret ..  string.format("%s %d", ClMsg(prop:GetPropName()), prop.value);
		end
	end
	end
	return ret;
end

function DETAIL_UPDATE(frame, detailView, type, playEffect)

	frame = tolua.cast(frame, "ui::CFrame");
	local cls = GetClassByType("Collection", type);
	detailView:SetUserValue("CURRENT_TYPE", type);
	detailView:RemoveAllChild();

	local detailMainGbox  = detailView:CreateOrGetControl('groupbox', "upbox", 0, 0, detailView:GetWidth(), 0);

	local isread = etcObj['CollectionRead_' .. type]

	if isread ~= 1 then -- 한번이라도 읽은 콜렉션은 new 표시 안생기도록.
		local scpString = string.format("/readcollection %d", type);
		ui.Chat(scpString);
	end

	local pc = session.GetMySession();
	local colls = pc:GetCollection();
	local coll = colls:Get(type);
	if coll == nil then
		detailMainGbox:SetColorTone(frame:GetUserConfig("NOT_HAVE_COLOR"));
	else
		detailMainGbox:SetColorTone("FFFFFFFF");
	end
	detailMainGbox:EnableHitTest(0);

	-- 맨 위에 RichText생성 --
	local nextY = 10;
	local testobj
	local curCount, maxCount = GET_COLLECTION_COUNT(type, coll);
	local titleText = string.format("%s%s {/}%s%d/%d{/}", frame:GetUserConfig("TITLE_FONT"), cls.Name, frame:GetUserConfig("TITLE_COUNT_FONT"), curCount, maxCount);
	nextY, titleCtrl = ATTACH_TEXT_TO_OBJECT(detailMainGbox, "title", titleText, 10, nextY, detailMainGbox:GetWidth(), 50, ui.CENTER_HORZ, ui.TOP);


	--- 9칸에 걸쳐서 아이콘과 이름 생성
	local itemBoxWidth = detailMainGbox:GetWidth();
	local marginX = 10;
	local space = 30;
	local marginY = 15;
	local picInBox = 3;
	local picWidth = math.floor((itemBoxWidth - space - marginX * 2) / picInBox) - space;
	local picHeight = picWidth;
	local textWidth = math.floor((itemBoxWidth - marginX * 2) / picInBox) - space;
	local textHeight = 40;
	local lastRow = 0;
	local picY = nextY + marginY;
	local textY = picY + picHeight;
	local maxTextHeight = 0;

	local drawItemSet = {}

	for i = 1 , 9 do
		local itemName = cls["ItemName_" .. i];
		if itemName == "None" then
			break;
		end

		local itemCls = GetClass("Item", itemName);
		local row = math.floor((i - 1) / picInBox);
		local col = (i - 1)  % picInBox;
		local x = space + marginX + col * (picWidth + space);
		local textX = x + (picWidth / 2) - (textWidth / 2);
		if row > lastRow then
			picY = textY + maxTextHeight + marginY;
			textY = picY + picHeight;
			maxTextHeight = 0;
			lastRow = row;
		end

		local slot  = detailView:CreateOrGetControl('slot', "IMG_" .. i, x, picY, picWidth, picHeight);
		slot = tolua.cast(slot, "ui::CSlot");
		slot:EnableDrag(0);
		slot:EnableHitTest(1);

		slot:SetOverSound('button_cursor_over_2')
		local icon = CreateIcon(slot);
		icon:SetImage(itemCls.Icon);	
icon:EnableHitTest(1);	
	
		local cantake, count = SET_COLLECTION_PIC(frame, icon, itemCls, coll,drawItemSet);
		slot:SetUserValue("COLLECTION_TYPE", type);

		local itemGuid = itemCls.ClassID;
		if cantake ~= nil then
			local strGuid = coll:GetByItemTypeWithIndex(itemCls.ClassID, count);

			if strGuid ~= nil then
				itemGuid = strGuid;
			end
		end
		
		-- 세션 콜렉션에 오브젝트 정보가 존재하고 이를 바탕으로 하면 item오브젝트의 옵션을 살린 툴팁도 생성 가능하다. 가령 박아넣은 젬의 경험치라던가.
		-- 허나 지금 슬롯 지정하여 꺼내는 기능이 없기 때문에 무의미. 정확한 툴팁을 넣으려면 COLLECTION_TAKE를 type이 아니라 guid 기반으로 바꿔야함
		SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, itemCls.ClassName, 'collection', type, itemGuid); 
		
		if cantake ~= nil then
			slot:SetEventScript(ui.RBUTTONUP, "COLLECTION_TAKE");
		else
			slot:SetEventScript(ui.DROP, "COLLECTION_DROP");
		end

		local text = string.format("%s%s {/}", frame:GetUserConfig("DETAIL_ITEM_FONT"), itemCls.Name);
		local dummyY, picText = ATTACH_TEXT_TO_OBJECT(detailMainGbox, "TITLE_" .. i, text, textX, textY, textWidth, textHeight, ui.LEFT, ui.TOP, 1, "center", "center");

		if picText:GetHeight() > maxTextHeight then
			maxTextHeight = picText:GetHeight();
		end
	end

	nextY = textY + maxTextHeight + 20;

	local font;
	local skinName = "";
	if curCount >= maxCount then
		font = frame:GetUserConfig("ENABLE_EFFECT_FONT");
	else
		font = frame:GetUserConfig("DISABLE_EFFECT_FONT");
	end

	detailMainGbox:Resize(detailMainGbox:GetWidth(), nextY);
	local detailAbilGbox  = detailView:CreateOrGetControl('groupbox', "downbox", 5, nextY, detailView:GetWidth() - 10, 50);
	detailAbilGbox:SetSkinName('rank_three_skin')
	detailAbilGbox:EnableHitTest(0);


	local abilText = string.format("%s %s : %s", font, ClMsg("CollectionEffect"), GET_COLLECTION_EFFECT_DESC(type));

	local abilTextObj;
	local newboxy = 13
	newboxy, abilTextObj = ATTACH_TEXT_TO_OBJECT(detailAbilGbox, "abil", abilText, 10, newboxy, detailMainGbox:GetWidth(), 20, ui.LEFT, ui.TOP);
	nextY = nextY + 65;

	if curCount >= maxCount and playEffect == 1 then
		local posX, posY = GET_SCREEN_XY(abilTextObj);
		movie.PlayUIEffect('SYS_quest_mark', posX, posY, 1.0);
		imcSound.PlaySoundEvent(frame:GetUserConfig("SOUND_COLLECTION"));
	
		--local titleCtrl = detailView:GetChild("title");
		UI_PLAYFORCE(titleCtrl, "text_eft_1", 0, 0);
		UI_PLAYFORCE(abilTextObj, "text_eft_1", 0, 0);
	end

	local skinName;
	if curCount >= maxCount then
		skinName = frame:GetUserConfig("ENABLE_SKIN");
	else
		skinName = frame:GetUserConfig("DISABLE_SKIN");
	end

	detailView:SetSkinName('None');
	detailMainGbox:SetSkinName(skinName);

	detailView:Resize(detailView:GetWidth(), nextY);

end

function COLLECTION_DROP(frame, slot)

	local type = slot:GetUserIValue("COLLECTION_TYPE");
	local liftIcon = ui.GetLiftIcon():GetInfo();
	local colls = session.GetMySession():GetCollection();
	local coll = colls:Get(type);
	local nowcnt = coll:GetItemCountByType(liftIcon.type)

	local colinfo = geCollectionTable.Get(type);
	local needcnt = colinfo:GetNeedItemCount(liftIcon.type)

	if nowcnt < needcnt then
		imcSound.PlaySoundEvent('sys_popup_open_1');
		local yesScp = string.format("EXEC_PUT_COLLECTION(\"%s\", %d)", liftIcon:GetIESID(), type);
		ui.MsgBox(ScpArgMsg("CollectionIsSharedToTeamAndCantTakeBackItem_Continue?"), yesScp, "None");
	end

	

end

function EXEC_PUT_COLLECTION(itemID, type)

	session.ResetItemList();
	session.AddItemID(itemID);
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("PUT_COLLECTION", resultlist, type);
	imcSound.PlaySoundEvent("cllection_weapon_epuip");

end

function COLLECTION_TAKE(frame, slot, str, num)

	local slot = tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	local itemType = icon:GetTooltipNumArg();
	local type = slot:GetUserIValue("COLLECTION_TYPE");
	local colls = session.GetMySession():GetCollection();
	local coll = colls:Get(type);
	local collItem = coll:Get(itemType);
	if collItem ~= nil then
		session.ResetItemList();
		local resultlist = session.GetItemIDList();
		local argStr = string.format("%d %d", type, itemType);
		pc.ReqExecuteTx_NumArgs("SCR_TAKE_COLLECTION", argStr);

		imcSound.PlaySoundEvent("cllection_weapon_unepuip");
	end
end



