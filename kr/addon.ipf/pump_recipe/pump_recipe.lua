

function PUMP_RECIPE_ON_INIT(addon, frame)
	
			
end

function _PUMP_RECIPE_OPEN(frame, recipeType, itemName)
	local recipeCls = GetClassByType("Recipe", recipeType);
	if recipeCls == nil then
		return;
	end
	
	if recipeCls.NeedWiki == 1 and GetWikiByName(recipeCls.ClassName) == nil then
		return;
	end

	frame = tolua.cast(frame, "ui::CFrame");

	
	-- 콜렉션 알람 UI 검사 (콜렉션 알람 UI랑 겹쳐서 여기서 검사한다)
	local isOpenCollectionUI = false;
	local frame_collection = ui.GetFrame("pump_collection");
	if frame_collection ~= nil then
		if frame_collection:IsVisible() == 1 then
			isOpenCollectionUI = true;
		end
	end

	--- 레시피알람 UI검사 
	local beforeRecipeType = frame:GetUserIValue("RECIPETYPE");
	if frame:IsVisible() == 1 and beforeRecipeType ~= recipeType or isOpenCollectionUI == true then
		local duration = frame:GetDuration();
		frame:ReserveScript("_PUMP_RECIPE_OPEN", duration + 1, recipeType, itemName);
		frame:EnableHideProcess(1);
		return;
	end
	-- 이 함수가 위쪽에 있었는데 연속으로 알람 나올때 리사이즈로 인해 아래가짤려서 여기로 내림
	frame:Resize(frame:GetOriginalWidth(),frame:GetOriginalHeight()) 
	frame:SetUserValue("RECIPETYPE", recipeType);
	local tgtItem = GetClass("Item", recipeCls.TargetItem);
	local itemname = GET_CHILD(frame, "itemname", "ui::CRichText");
	local nameText = GET_FULL_GRADE_NAME(tgtItem, 20);
	itemname:SetTextByKey("value", nameText);
	local slot = GET_CHILD(frame, "slot", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, tgtItem);

	local duration = 3.0;
	frame:ShowWindow(1);
	frame:SetDuration(duration);
	DESTROY_CHILD_BYNAME(frame, "MAT_");
	local x = 180;
	local y = 112;

	local checkItemCnt = 0;
	local deductItemCnt = 0;
	local checkItemCls = nil;
	for i = 1 , 5 do
		local recipeItemCnt, invItemCnt, itemCls = GET_RECIPE_MATERIAL_INFO(recipeCls, i);
		if recipeItemCnt == nil then
			break;
		end
		
		if checkItemCls == nil then		
			checkItemCls = itemCls;
		else
			if checkItemCls.ClassName ~= itemCls.ClassName then 
				checkItemCnt = 0;
				deductItemCnt = 0;
				checkItemCls = itemCls;
			end
		end	
		
		if (invItemCnt - deductItemCnt) > recipeItemCnt then
			checkItemCnt = recipeItemCnt;
		else
			checkItemCnt = invItemCnt - deductItemCnt;
		end			
		deductItemCnt = deductItemCnt + checkItemCnt;


		local ctrlSet = frame:CreateOrGetControlSet("pump_recipe_mat", "MAT_" .. i, x, y);
		local matSlot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
		SET_SLOT_ITEM_CLS(matSlot, itemCls);
		local gauge = GET_CHILD(ctrlSet, "gauge", "ui::CGauge");
		gauge:SetPoint(checkItemCnt, recipeItemCnt);
		local countText = GET_CHILD(ctrlSet, "countText", "ui::CRichText");
		countText:SetTextByKey("invItemCnt", tostring(checkItemCnt));
		countText:SetTextByKey("recipeItemCnt", tostring(recipeItemCnt));
		local recipeName = GET_CHILD(ctrlSet, "recipeName", "ui::CRichText");
		recipeName:SetTextByKey("name", itemCls.Name);

		if itemName == itemCls.ClassName and checkItemCnt >= recipeItemCnt then
			PLAY_SLOT_EFT(matSlot, "I_sys_item_slot", 1);
		end
		y = y + ctrlSet:GetHeight() + 6;
	end

	if frame:GetHeight() < y then
		frame:Resize(frame:GetOriginalWidth(),y + 30)
	else
		frame:Resize(frame:GetOriginalWidth(),frame:GetOriginalHeight())
	end
	
	frame:Invalidate();
end

function PUMP_RECIPE_OPEN(recipeType, itemName, addType)
    if addType == 4 then -- ADD_ITEM_UNEQUIP = 4: 장비 해제로 인벤에 들어올 때에는 안해줌
        return;
    end
	local frame = ui.GetFrame("pump_recipe");
	_PUMP_RECIPE_OPEN(frame, recipeType, itemName);

end

