
function DRAGRECIPE_DIALOG_ON_INIT(addon, frame)



end

function DRAGRECIPE_MSGBOX(invItemList, makeInfo, recipeCls)

	local newFrame = ui.GetFrame("manufac_renew");
	newFrame:ShowWindow(1);
	MANU_SET_CLS(newFrame, recipeCls.ClassName);

	if 1 == 1 then
		return;
	end

	local frame = ui.GetFrame("dragrecipe_dialog");
	frame:ShowWindow(1);
	
	local minCnt = 10000;
	local listCount = #invItemList;		
	for i=1, listCount do
		local invItem = invItemList[i];
		local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipeCls, "Item_"..i .. "_1", GetMyPCObject());
		local invItemCount = GET_PC_ITEM_COUNT_BY_LEVEL(invItem.type, recipeItemLv);
		frame:SetUserValue("ITEMID_"..i, invItem:GetIESID());
		minCnt = math.min(minCnt, math.floor(invItemCount / recipeItemCnt));
	end
	
	frame:SetUserValue("MAKE_ITEMID", makeInfo.ClassID);
	frame:SetUserValue("RECIPE_ID", recipeCls.ClassID);
	
	local slot = GET_CHILD(frame, "item", "ui::CSlot");
	SET_SLOT_IMG(slot, makeInfo.Icon);
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', makeInfo.ClassID, 0);

	frame:GetChild("t_itemName"):SetTextByKey("name", makeInfo.Name);
	local cnt = GET_CHILD(frame, "cnt", "ui::CNumUpDown");
	cnt:SetMaxValue(minCnt);
	cnt:SetNumberValue(minCnt);
	ui.SetTopMostFrame(frame);
end

function START_DRAG_RECIPE_TIMER(frame)

	local scp = frame:GetSValue();
	
	local cnt = GET_CHILD(frame, "cnt", "ui::CNumUpDown");	
	local makeID  = frame:GetUserValue("MAKE_ITEMID");
	local recipeID = frame:GetUserValue("RECIPE_ID");
	local recipeCount = cnt:GetNumber();
	
	EXEC_DRAG_RECIPE(frame, makeID, recipeID, recipeCount);
	
	frame:ShowWindow(0);
end

function EXEC_DRAG_RECIPE(frame, makeID, recipeID, recipeCount)	
	local recipeFrame = ui.GetFrame("dragrecipe");
	START_DRAG_RECIPE(recipeFrame, frame, makeID, recipeID, recipeCount);
	
	for i=1, 5 do
		frame:SetUserValue("ITEMID_"..i, "None");
	end
end
