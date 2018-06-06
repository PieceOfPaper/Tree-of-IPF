
function JOURNAL_DETAIL_EACH_CRAFT(ctrl, ctrlSet, craft, argNum)
	

	local frame = ui.GetFrame('journal_rank')
	frame:ShowWindow(1)
	frame:SetUserConfig('craft', 'None');		
			
	local group = GET_CHILD(frame, 'detail_craft', 'ui::CGroupBox')

	
	local rankPage = group:CreateOrGetControl('page', 'rank_eachcraft_'..craft, 0, 400, ui.NONE_HORZ, ui.TOP, 0, 0, 0, 0)
	local craftPage = group:CreateOrGetControl('page', 'mat_eachcraft_'..craft, 0, 300, ui.NONE_HORZ, ui.TOP, 0, 460, 0, 0)
	
	HIDE_CHILD_BYNAME(frame, 'detail_')
	HIDE_CHILD_BYNAME(group, 'rank_')
	HIDE_CHILD_BYNAME(group, 'mat_')
	HIDE_CHILD_BYNAME(group, 'craft_gauge')

	group:ShowWindow(1)
	rankPage:ShowWindow(1)
	craftPage:ShowWindow(1)

	tolua.cast(rankPage, 'ui::CPage')
	tolua.cast(craftPage, 'ui::CPage')

	rankPage:SetSlotSize(300, 25)
	craftPage:SetSlotSize(230, 50)
	
	rankPage:SetSlotSpace(10, 3)
	craftPage:SetSlotSpace(10, 0)

	rankPage:SetBorder(5, 5, 5, 5)
	craftPage:SetBorder(15, 5, 5, 5)

	frame:SetUserConfig('rank', 'rank_eachcraft_'..craft);
	frame:SetUserConfig('mat', 'mat_eachcraft_'..craft);
	
	
	--imc.client.statistics.api.lua.sync_monster_detail(craft, 'JOURNAL_DETAIL_EACH_CRAFT_SYNC')
	JOURNAL_DETAIL_EACH_CRAFT_SYNC(craft)
	JOURNAL_DETAIL_EACH_CRAFT_MAT(craft)
	
end

function JOURNAL_DETAIL_EACH_CRAFT_MAT(craft)

	local frame = ui.GetFrame('journal_rank')
	local group = GET_CHILD(frame, 'detail_craft', 'ui::CGroupBox')
	local rankpage = GET_CHILD(group, 'rank_eachcraft_'..craft, 'ui::CPage')
	local matPage = GET_CHILD(group, 'mat_eachcraft_'..craft, 'ui::CPage')


	local recipecls = GetClass('Recipe', craft);
	local recipeType = recipecls.RecipeType;

	frame:SetUserConfig('craft', 'None');
	
	if recipeType ~= 'Drag' then
	--	return
	end

	
	
	
	local dragMakeItem = GetClass('Item', recipecls.TargetItem);
	if dragMakeItem == nil then
		return
	end
	
	
	
	local invItemList = {};
	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then

			local recipeItemCnt, invItemCnt, dragRecipeItem = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			local ctrl = matPage:CreateOrGetControlSet('statistics_monster_drop_item', dragRecipeItem.ClassID, 0, 0)

			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage(dragRecipeItem.Icon);

			
			ctrl:SetTextByKey('name', '{@st42b}'..dragRecipeItem.Name);

			
			if recipeItemCnt > invItemCnt then
				ctrl:SetTextByKey('count', '{@st50}{#f00000}'..invItemCnt..' / '..recipeItemCnt);
			else
				ctrl:SetTextByKey('count', '{@st50}{#00f00F}'..invItemCnt..' / '..recipeItemCnt);
			end
		end
	end

	frame:SetUserConfig('craft', craft);

end

function JOURNAL_DETAIL_EACH_CRAFT_SYNC(craft)


	

end


function JOURNAL_RANK_EACH_MONSTER_DRAW(craft)


	

end

function JOURNAL_DETAIL_CRAFT_EXEC(ctrl, ctrlSet)

	local frame = ui.GetFrame('journal_rank')
	local craft = frame:GetUserConfig('craft')

	local recipecls = GetClass('Recipe', craft);

	if recipecls == nil then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		return;
	end

	
	session.ResetItemList();

	local ItisOk = true;

	for i = 1 , 5 do
		if recipecls["Item_"..i.."_1"] ~= "None" then

			local recipeItemCnt, invItemCnt, dragRecipeItem, invItem = GET_RECIPE_MATERIAL_INFO(recipecls, i);
			if recipeItemCnt > invItemCnt then
				ItisOk = false;
				session.ResetItemList();
				break;
			else
				session.AddItemID(invItem:GetIESID());
			end
		end
	end
	
	if ItisOk == false then
		ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
		session.ResetItemList();
		return
	end

	local resultlist = session.GetItemIDList();
	local cntText = string.format("%d %d", recipecls.ClassID, 1);
	item.DialogTransaction("SCR_ITEM_MANUFACTURE", resultlist, cntText);


end
