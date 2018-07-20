-- ui/uiscp/statistics/item.lua

function STATISTICS_ITEM_DETAIL_ON_INIT(addon, frame)

end

function STATISTICS_ITEM_VIEW(frame)
	local itemPicasa = frame:GetChild('item_picasa');
	tolua.cast(itemPicasa, 'ui::CPicasa');
	itemPicasa:ShowWindow(1);
	imc.client.statistics.api.lua.sync_statistics_item(frame:GetName(), 'STATISTICS_ITEM_VIEW_DETAIL')
end

function STATISTICS_ITEM_VIEW_DETAIL(frame)
	local itemPicasa = frame:GetChild('item_picasa');
	tolua.cast(itemPicasa, 'ui::CPicasa');
	itemPicasa:ShowWindow(1);
	
	local clslist = GetClassList("statistics_item");
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	-- 몬스터 카테고리.
	while cls ~= nil do
		
		local picasa = itemPicasa:AddCategoryWithHide(cls.Category, cls.Category)
		local subPicasa = picasa:AddCategory(cls.SubCategory, cls.SubCategory, 0, 1)
		
		STATISTICS_ITEM_DRAW_CATEGORY(subPicasa, cls.Category, cls.SubCategory)

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

end

function STATISTICS_ITEM_DRAW_CATEGORY(picasa, category, sub_category)
	
	local idspace = "statistics_item_category_"..category.."_"..sub_category;
	local clslist = GetClassList(idspace);

	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	-- 아이템 카테고리.
	while cls ~= nil do

		local item = picasa:AddItem(cls.ClassName, 'cepa', cls.Name, "Desc")
		item:SetLBtnUpScp('SYNC_ITEM_DETAIL', idspace, cls.ClassID)

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

end

function SYNC_ITEM_DETAIL(ClassID, idspace)

	local frame = ui.GetFrame('statistics_item_detail');
	frame:ShowWindow(1);
	imc.client.statistics.api.lua.sync_item_detail(ClassID, 'DRAW_ITEM_DETAIL');

end

function DRAW_ITEM_DETAIL(ClassID)

	local frame = ui.GetFrame('statistics_item_detail');
	frame:ShowWindow(1);

	frame:SetUserConfig('item_id', ClassID)
	STATISTICS_ITEM_TAB_CHANGE(frame, ClassID)


end
