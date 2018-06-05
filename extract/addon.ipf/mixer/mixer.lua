function MIXER_ON_INIT(addon, frame)
	addon:RegisterMsg('ITEM_MIX_END', 'REMOVE_ALL_MIX');
end

function REMOVE_ALL_MIX(frame, msg, argStr, argNum)
	local slotset = frame:GetChild("slotlist");
	tolua.cast(slotset, "ui::CSlotSet");

	local max_size = 8;
	for i = 0 , max_size do
		for j = 0 , max_size  do

			local name = string.format("_SLOT_%d_%d", i, j);
			local slot = slotset:GetSlot(name);
			if slot ~= nil then
				local icon = slot:GetIcon();
				icon:SetTooltipType('wholeitem');
				icon:SetTooltipArg('mixer', 0, nil);
				UPDATE_MIX_ICON(slot);
			end

		end
	end

	frame:ShowWindow(0);
	UPDATE_MIX_BTN();	
end

function DESTORY_SLOT_LIST(slotlist)
	while 1 do
		local slot  = slotlist:SearchChild("_SLOT_");
		if slot == nil then
			break;
		end
		slotlist:RemoveChild(slot:GetName());
	end
end

function CRE_SLOT_LIST(slotset, x, y, mixersize, iconsize)
	local iconIndex = 0;
	for i = 0 , mixersize - 1 do
		for j = 0 , mixersize - 1 do

			local name = string.format("_SLOT_%d_%d", i, j);
			local slot = slotset:AddSlot(name, iconsize * i + x,  iconsize * j + y, iconsize, iconsize);
			slot:ShowWindow(1);

			slot:SetLBtnDownArgNum(i * 10 + j);
			slot:SetDropScp("MIXER_DROP");

			local icon = CreateIcon(slot);
			icon:SetImage('locked_slot');
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('mixer', 0, nil);
			
			iconIndex = iconIndex + 1;
		end
	end
	slotset:CheckSize();
end

function MIXER_DROP(frame, control, argStr, argNum)
	local mixserframe = frame:GetTopParentFrame();
	local iesID = mixserframe:GetTooltipIESID();
	local mixerItem = session.GetInvItemByGuid(iesID);
	
	local slot 					= tolua.cast(control, 'ui::CSlot');
	local icon = slot:GetIcon();
	tolua.cast(icon, "ui::CIcon");
	
	local fromitem
	if argStr ~= "INVEN" then
		local liftIcon 				= ui.GetLiftIcon();	
		local frominfo				= liftIcon:GetInfo();
		local fromInvIndex = frominfo.ext;
		fromitem = session.GetInvItem(fromInvIndex);
	else
		fromitem = session.GetInvItem(argNum);	
	end	

	if fromitem == nil then
		return;
	end

	if fromitem == mixerItem then
		return;
	end

	local fromobj = GetIES(fromitem:GetObject());
	
	local newframe = ui.CreateNewFrame("inputstring", "inputstr");
	local edit = newframe:GetChild('input');
	tolua.cast(edit, "ui::CEditControl");
	edit:SetMaxNumber(fromitem.count);
	edit:SetText(fromitem.count);
	
	local PreviewType = icon:GetTooltipNumArg();
	local ItemCls = GetClassByType("Item", PreviewType);
	if ItemCls ~= nil then
		local NeedCnt = slot:GetTooltipNumArg();
		edit:SetText(NeedCnt);
	end
	
	local xy = slot:GetLBtnDownArgNum();
	local x = math.floor(xy / 10);
	local y = xy % 10;	
	local strscp = string.format( "TO_MIXER(\"%s\", %d, %d)", fromitem:GetIESID(), x, y);

	if USE_RECIPE_ITEM_CNT == 0 then
		local NeedCnt = slot:GetTooltipNumArg();	
		if fromitem.count < NeedCnt then
			ui.MsgBox(ScpArgMsg("Auto_SuLyangi_BuJogHapNiDa."));
		else
			RunStringScript(strscp);
		end
		
		return;
	end
		
	--if fromitem.count == 1 then
	if 1 == 1 then
		RunStringScript(strscp);
		return;
	end
	
	newframe:ShowWindow(1);
	newframe:SetEnable(1);
	newframe:SetEnterKeyScript(strscp);

	local title = newframe:GetChild("title");
	tolua.cast(title, "ui::CRichText");
	local txt = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 0, "Auto_2", fromitem.count);
	title:SetText(txt);
	ui.SetTopMostFrame(newframe);

	local confirm = newframe:GetChild("confirm");
	confirm:SetLBtnUpScp(strscp);

	edit:AcquireFocus();

end

function EXIST_MIXER_ITEM(invitem)

	local frame = ui.GetFrame("mixer");
	local iesID = frame:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());

	local size = itemObj.NumberArg1;

	for i = 0 , size - 1 do
		for j = 0 , size - 1 do
			local item = GET_MIXER_ITEM(i, j);
			if item == invitem then
				return i, j;
			end
		end
	end

	return -1, -1;
end

function GET_MIXER_SLOT(x, y)

	local frame = ui.GetFrame("mixer");
	local slotset = frame:GetChild("slotlist");

	tolua.cast(slotset, "ui::CSlotSet");

	local name = string.format("_SLOT_%d_%d", x, y);
	local slot = slotset:GetChild(name);
	tolua.cast(slot, "ui::CSlot");
	return slot;

end


function GET_MIXER_ITEM(x, y)

	local slot = GET_MIXER_SLOT(x, y);
	if slot == nil then
		return nil;
	end

	return GET_ITEM_OF_ICON(slot:GetIcon());

end

function GET_ITEM_OF_ICON(icon)

	if icon == nil then
		return nil;
	end

	local iesID = icon:GetTooltipIESID();
	return GET_ITEM_BY_GUID(iesID, 1);
end

function TO_MIXER(iesID, x, y)

	local inputframe= ui.GetFrame("inputstr");
	local edit = inputframe:GetChild('input');
	tolua.cast(edit, "ui::CEditControl");
	local itemcnt = tonumber(edit:GetText());

	ui.CloseFrame("inputstr");
	
	local invItem = session.GetInvItemByGuid(iesID);
	if invItem == nil then
		return;
	end
	
	local frame = ui.GetFrame("mixer");
	local slotset = frame:GetChild("slotlist");
	tolua.cast(slotset, "ui::CSlotSet");

	local name = string.format("_SLOT_%d_%d", x, y);
	local slot = slotset:GetChild(name);
	local icon = slot:GetIcon();
	icon:SetTooltipIESID(invItem:GetIESID());
	slot:SetRBtnDownArgNum(itemcnt);
	UPDATE_MIX_ICON(slot);
	local scpstring = string.format("REMOVE_MIXER(%d, %d)", x, y);
	slot:SetRBtnDownScp(scpstring);

	UPDATE_MIX_BTN();
end

function UPDATE_MIX_ICON(slot)
	local icon = slot:GetIcon();
	local PreviewType = icon:GetTooltipNumArg();
	local ItemCls = GetClassByType("Item", PreviewType);
	local NeedCnt = slot:GetTooltipNumArg();

	local curcnt = slot:GetRBtnDownArgNum();
	local ImageSet = 0;
	local iesID = icon:GetTooltipIESID();
	local invItem = session.GetInvItemByGuid(iesID);
	if invItem ~= nil then
		local ItemObj = GetIES(invItem:GetObject());
		local imageName 		= ItemObj.Icon;
		icon:Set(imageName, 'Item', invItem.type, invItem.invIndex);
		icon:SetColorTone("FFFFFFFF");

		if USE_RECIPE_ITEM_CNT == 1 then
			if PreviewType == invItem.type then
				local Txt = string.format("%d/%d", curcnt, NeedCnt);
				slot:SetText('{s14}{ol}{b}'..Txt, 'count', 'right', 'bottom', -2, 1);
			else
				slot:SetText('{s14}{ol}{b}'..curcnt, 'count', 'right', 'bottom', -2, 1);
			end
		end

		ImageSet = 1;
	else

		if ItemCls ~= nil then
			local imageName 		= ItemCls.Icon;
			icon:SetImage(imageName);
			icon:SetColorTone("FFFF0000");
			local MyCnt = 0;
			if USE_RECIPE_ITEM_CNT == 1 then
				local Txt = string.format("%d/%d", MyCnt, NeedCnt);
				slot:SetText('{s14}{ol}{b}'..Txt, 'count', 'right', 'bottom', -2, 1);
			end
			ImageSet = 1;
		end
	end

	if ImageSet == 0 then		
		icon:SetImage('locked_slot');
		slot:SetText("");
	end
	slot:Invalidate();
end

function REMOVE_MIXER(x, y)

	local frame = ui.GetFrame("mixer");
	local slotset = frame:GetChild("slotlist");

	tolua.cast(slotset, "ui::CSlotSet");

	local name = string.format("_SLOT_%d_%d", x, y);
	local slot = slotset:GetChild(name);
	tolua.cast(slot, "ui::CSlot");
	slot:SetText("");
	local icon = slot:GetIcon();
	icon:SetTooltipIESID(nil);
	slot:SetRBtnDownArgNum(-1);
	UPDATE_MIX_ICON(slot);

	UPDATE_MIX_BTN();
end

function MIXER_SETICON(frame, x, y, invindex)


end

function MIXER_TEST(frame, invitem)


	local itemobj = GetIES(invitem:GetObject());

	frame:SetTooltipArg('', 0, invitem:GetIESID());
	local mixersize = itemobj.NumberArg1;
	local slotset = frame:GetChild("slotlist");
	tolua.cast(slotset, "ui::CSlotSet");

	local name = frame:GetChild('name');
	tolua.cast(name, "ui::CRichText");
	local fullname = GET_FULL_NAME(itemobj);
	name:SetText("{ol}" .. fullname .. "{/}");


	DESTORY_SLOT_LIST(slotset);
	CRE_SLOT_LIST(slotset, 0, 0, mixersize, 42);

	--local height = slotset:GetY() + slotset:GetHeight() + 0;
	--local width = slotset:GetX() + slotset:GetWidth() + 0;
    local height= 500;
    local width = 270;
	frame:Resize(width, height);
	frame:ShowWindowToggle();

	MIXER_CRE_LIST(frame, itemobj);

	UPDATE_MIX_BTN();

end

function DESTROY_MIXER_LIST(mapframe)

	while 1 do

		local pNpcPic = mapframe:SearchChild("_MIX_");
		if pNpcPic == nil then
			break;
		end

		mapframe:RemoveChild(pNpcPic:GetName());

	end
end

function MIXER_CRE_LIST(frame, invitem)

	local list = frame:GetChild('list');
	local groupbox = tolua.cast(list, "ui::CGroupBox");
    groupbox:DeleteAllControl();

    local yoffset = 10;
	local yheight = 18;

	local RecipeProp = nil;
	local cnt = GetClassCount('Recipe');

	local idx = 0;
	local NoneItem = groupbox:CreateControlSet('richtxt', "NoneItem", 10, yoffset + yheight * idx);
	tolua.cast(NoneItem, "ui::CControlSet");
	SET_MIX_GROUP_OPTION(NoneItem, yheight);
	NoneItem:SetTextByKey("text", ScpArgMsg("UNSELECT"));
	NoneItem:SetLBtnUpArgStr("None");


	local pc = GetMyPCObject();

	idx = idx + 1;

	for i = 0, cnt -1 do
		RecipeProp = GetClassByIndex('Recipe', i);
		if RecipeProp.RecipeType ~= 'Drag' then
			if RecipeProp.FromItem == invitem.ClassName then

				local showrecipe = 1;
				if RecipeProp.EnableScp ~= "None" then
					local ScrPtr = _G[RecipeProp.EnableScp];
					showrecipe = ScrPtr(pc);
				end

				if showrecipe == 1 then
					local targetitem = GetClass("Item", RecipeProp.TargetItem);
					if targetitem ~= nil then						
						local Quest_Ctrl = groupbox:CreateControlSet('richtxt', RecipeProp.ClassName, 10, yoffset + yheight * idx);
						tolua.cast(Quest_Ctrl, "ui::CControlSet");

						SET_MIX_GROUP_OPTION(Quest_Ctrl, yheight);
						local imgtxt = string.format("{img %s %d %d}%s", targetitem.Icon, yheight, yheight, targetitem.Name);

						Quest_Ctrl:SetClickSound("anvil_list_select");
						Quest_Ctrl:SetTextByKey("text", imgtxt);
						Quest_Ctrl:SetTooltipType('wholeitem');
						Quest_Ctrl:SetTooltipArg('mixer', targetitem.ClassID, nil);
						Quest_Ctrl:SetLBtnUpArgStr(RecipeProp.ClassName);

						idx = idx + 1;
					end
				end

			end
		end
	end


	groupbox:UpdateData();

end

function SET_MIX_GROUP_OPTION(Quest_Ctrl, yheight)

			Quest_Ctrl:Resize(160, yheight);
			Quest_Ctrl:EnableHitTest(1);
			Quest_Ctrl:SetImage("all_trans", "all_red", "all_red");
			Quest_Ctrl:SetStretch(1);
			Quest_Ctrl:SetEnableSelect(1);
			Quest_Ctrl:EnableToggle(1);
			Quest_Ctrl:SetSelectGroupName('MIX_GROUP');
			Quest_Ctrl:SetLBtnUpScp("PREVIEW_MIX");
end

function EXECUTE_MIX_MSGBOX(frame, ctrl, numsttr, numarg)

	local iesID = frame:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());

	local msg = ScpArgMsg("CONTINUE_MIXING_USING_S", "Auto_1", itemObj.Name);
	ui.MsgBox(msg, "EXECUTE_MIX", "None");
end

function EXECUTE_MIX()	
	local uiframe = ui.GetFrame('mixer');
	local iesID = uiframe:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());

	local cnt = GetClassCount('Recipe');

	for i = 0, cnt -1 do
		RecipeProp = GetClassByIndex('Recipe', i);

		if 1 == EXECUTE_MIX_RECP(itemObj, RecipeProp) then
			return;
		end
	end
	
	--imcSound.PlaySoundItem('button_click_big');
	ui.MsgBox(ScpArgMsg("IMPOSSIBLE_MIX"));	
end

function EXECUTE_MIX_NO()
	--imcSound.PlaySoundItem('button_click_big');
end

function EXECUTE_MIX_RECP(itemObj, RecipeProp)

	if RecipeProp.FromItem ~= itemObj.ClassName then
		return 0;
	end

	local uiframe = ui.GetFrame('mixer');
	local iesID = uiframe:GetTooltipIESID();

	session.ResetRecipeList();
	session.AddRecipeInfo(iesID, 0, -1, -1);

	local targetitem = GetClass("Item", RecipeProp.TargetItem);

	local size = itemObj.NumberArg1

	for i = 0 , size - 1 do
		for j = 0 , size - 1 do
			local propName = string.format("Item_%d_%d", i + 1, j + 1);
			local NeedItem = RecipeProp[propName];
			local slot = GET_MIXER_SLOT(i, j);
			local slotitem = nil;
			if slot ~= nil then
				slotitem = GET_ITEM_OF_ICON(slot:GetIcon());
			end

			local myCnt = slot:GetRBtnDownArgNum();

			if NeedItem == 'None' and slotitem == nil then

			elseif NeedItem == 'None' and slotitem ~= nil then
				return 0;
			elseif NeedItem ~= 'None' and slotitem == nil then
				return 0;
			else
				local NeedItemCls = GetClass("Item", NeedItem);
				local SlotItemobj = GetIES(slotitem:GetObject());
				propName = string.format("Item_%d_%d_Cnt", i + 1, j + 1);
				local NeedCnt = RecipeProp[propName];

				if NeedItemCls.ClassID ~= SlotItemobj.ClassID then
					return 0;
				end

				if myCnt ~= NeedCnt then
					return 0;
				end
				print('session.AddRecipeInfo', i, j);
				session.AddRecipeInfo(slotitem:GetIESID(), myCnt, i, j);

			end
		end
	end

	local reqlist = session.GetRecipeList();
	local RecipeClassID = RecipeProp.FromItem
	item.ReqRecipeItem(reqlist, RecipeProp.ClassID);

return 1;

end

function MIXER_INVEN_RBOTTUNDOWN(invItem, argNum)
	local frame = ui.GetFrame("mixer");
	
	local iesID = frame:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());
	local size = itemObj.NumberArg1

	for i = 0 , size - 1 do
		for j = 0 , size - 1 do			
			local slot = GET_MIXER_SLOT(i,j);
			if slot ~= nil then
				local icon = slot:GetIcon();
				local iconNumArg = icon:GetTooltipNumArg();
				
				if iconNumArg ~= 0 then					
					if iconNumArg == invItem.ClassID then
						local myCnt = slot:GetRBtnDownArgNum();
						print(ScpArgMsg("Auto_MoNi")..myCnt);
						if myCnt == -1 then
							MIXER_DROP(frame, slot, "INVEN", argNum);
							return;
						end
					end				
				end							
			end
		end
	end	
end

function PREVIEW_MIX(frame, ctrl, argStr, argNum)

	local frame = frame:GetTopParentFrame();
	local RecipeProp = GetClass("Recipe", argStr);

	local RemoveList = 0;
	if RecipeProp == nil then
		RemoveList = 1;
	end

	local iesID = frame:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());
	local size = itemObj.NumberArg1

	for i = 0 , size - 1 do
		for j = 0 , size - 1 do
			local propName = string.format("Item_%d_%d", i + 1, j + 1);
			local NeedItem;
			if RemoveList == 1 then
				NeedItem = "None"
			else
				NeedItem = RecipeProp[propName];
			end

			local slot = GET_MIXER_SLOT(i,j);
			if slot ~= nil then
				local icon = slot:GetIcon();
				if NeedItem == 'None' then
					icon:SetTooltipNumArg(0);
				else
					local itemCls = GetClass("Item", NeedItem);
					icon:SetTooltipNumArg(itemCls.ClassID);

					propName = string.format("Item_%d_%d_Cnt", i + 1, j + 1);
					local NeedCnt = RecipeProp[propName];
					slot:SetTooltipNumArg(NeedCnt);
				end

				UPDATE_MIX_ICON(slot);
			end

		end
	end

return 1;

end

function UPDATE_MIX_BTN()

	local uiframe = ui.GetFrame('mixer');
	local btn = uiframe:GetChild('execute');
	tolua.cast(btn, "ui::CButton");

	local iesID = uiframe:GetTooltipIESID();
	local curItem = session.GetInvItemByGuid(iesID);
	local itemObj = GetIES(curItem:GetObject());

	local cnt = GetClassCount('Recipe');

	for i = 0, cnt -1 do
		RecipeProp = GetClassByIndex('Recipe', i);

		if 1 == CAN_MIX_ITEM(itemObj, RecipeProp) then
			btn:SetEnable(1);
			btn:SetGrayStyle(0);
			return;
		end
	end

	btn:SetGrayStyle(1);
	btn:SetEnable(0);
end


function CAN_MIX_ITEM(itemObj, RecipeProp)

	if itemObj == nil or RecipeProp == nil then
		return 0;
	end
	
	if RecipeProp.RecipeType == "Drag" then
		return 0;
	end
	
	print(RecipeProp.ClassName);
	if RecipeProp.FromItem ~= itemObj.ClassName then
		return 0;
	end

	local uiframe = ui.GetFrame('mixer');
	local iesID = uiframe:GetTooltipIESID();

	local targetitem = GetClass("Item", RecipeProp.TargetItem);

	local size = itemObj.NumberArg1

	for i = 0 , size - 1 do
		for j = 0 , size - 1 do
			local propName = string.format("Item_%d_%d", i + 1, j + 1);
			local NeedItem = RecipeProp[propName];
			local slot = GET_MIXER_SLOT(i, j);
			local slotitem = nil;
			if slot ~= nil then
				slotitem = GET_ITEM_OF_ICON(slot:GetIcon());
			end

			local myCnt = slot:GetRBtnDownArgNum();

			if NeedItem == 'None' and slotitem == nil then

			elseif NeedItem == 'None' and slotitem ~= nil then
				return 0;
			elseif NeedItem ~= 'None' and slotitem == nil then
				return 0;
			else
				local NeedItemCls = GetClass("Item", NeedItem);
				local SlotItemobj = GetIES(slotitem:GetObject());
				propName = string.format("Item_%d_%d_Cnt", i + 1, j + 1);
				local NeedCnt = RecipeProp[propName];

				if NeedItemCls.ClassID ~= SlotItemobj.ClassID then
					return 0;
				end

				if myCnt ~= NeedCnt then
					return 0;
				end

			end
		end
	end

return 1;

end

