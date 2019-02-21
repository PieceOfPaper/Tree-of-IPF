
function CRAFTQUEUE_ON_INIT(addon, frame)



end

function ADD_CRAFT_QUEUE(frame, itemCls, recipeType, totalCount, is_stack_item)
    local childName = ''
    if is_stack_item == false then
        local index = frame:GetUserIValue("CTRL_INDEX");
	    childName = string.format("CTRL_%s_%d_%d", itemCls.ClassName, recipeType, totalCount);
	    index = index + 1;
	    frame:SetUserValue("CTRL_INDEX", index);
    else
        childName = string.format("CTRL_%s_%d_%d", itemCls.ClassName, recipeType, totalCount);
	    frame:SetUserValue("CTRL_INDEX", totalCount);    
    end
	
	local bg = frame:GetChild("bg");
	local slot = bg:CreateOrGetControl("slot", childName, 60, 60, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
	slot:ShowWindow(1);
	slot = tolua.cast(slot, "ui::CSlot");
	slot:SetSkinName("slot");
	slot:SetUserValue("RECIPE_TYPE", recipeType);
	slot:SetUserValue("TOTAL_COUNT", totalCount);
	SET_SLOT_ITEM_CLS(slot, itemCls);

	GBOX_AUTO_ALIGN_HORZ(bg, 10, -40, 0, true, false);	
	CRAFT_UPDATE_COUNT(frame);
	frame:Invalidate();
end


function CLEAR_CRAFT_QUEUE(frame)
	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();
    frame:SetUserValue('CTRL_INDEX', 0);
	CRAFT_UPDATE_COUNT(frame);
end

function REMOVE_CRAFT_QUEUE(frame)
	local bg = frame:GetChild("bg");
    local remainCount = frame:GetUserIValue('CTRL_INDEX');
	if remainCount == 0 then
        frame:ShowWindow(0);
		return;
	end

    remainCount = remainCount - 1;
    frame:SetUserValue('CTRL_INDEX', remainCount);

	CRAFT_UPDATE_COUNT(frame);    
	if remainCount == 0 then
		frame:ShowWindow(0);
	else
		firstChild = bg:GetChildByIndex(1);
		local recipeType = firstChild:GetUserIValue("RECIPE_TYPE");
		local totalCount = firstChild:GetUserValue("TOTAL_COUNT");
		return recipeType, totalCount;
	end

end

function CRAFT_UPDATE_COUNT(frame)
	local bg = frame:GetChild("bg");
	local count = frame:GetChild("count");
    local remainCount = frame:GetUserIValue('CTRL_INDEX');
    local resultItem = frame:GetUserValue("RECIPE_NAME");

    local recipeCls = GetClass("Recipe", resultItem)
    if recipeCls == nil then
        recipeCls = GetClass("Recipe_ItemCraft", resultItem)
    end

    local resultCraftCount = TryGetProp(recipeCls, "TargetItemCnt", 1)
	count:SetTextByKey("value", remainCount * resultCraftCount);
end

function GET_CRAFT_REMAIONCOUNT(frame)
	local bg = frame:GetChild("bg");
    local remainCount = frame:GetUserIValue('CTRL_INDEX');
	return remainCount;
end