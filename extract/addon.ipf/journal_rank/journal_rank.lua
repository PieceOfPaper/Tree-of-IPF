
function JOURNAL_RANK_ON_INIT(addon, frame)	

	--HIDE_CHILD_BYNAME(frame, 'rank_')

	--local rank_title = GET_CHILD(frame, 'rank_title', 'ui::CObject')
	--rank_title:ShowWindow(1)

	


end


function JOURNAL_RANK_OPEN(frame)	

end

function JOURNAL_DETAIL_ITEM_PREV_RANK(ctrl, ctrlset)
	
	local frame = ui.GetFrame('journal_rank')
	local name = frame:GetUserConfig('rank');

	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')
	local page = GET_CHILD(group, name, 'ui::CPage');
	page:PrevPage();

end

function JOURNAL_DETAIL_ITEM_NEXT_RANK(ctrl, ctrlset)
	
	local frame = ui.GetFrame('journal_rank')
	local name = frame:GetUserConfig('rank');

	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')
	local page = GET_CHILD(group, name, 'ui::CPage');

	page:NextPage();

end

function JOURNAL_DETAIL_ITEM_PREV_MONSTER(ctrl, ctrlset)
	
	local frame = ui.GetFrame('journal_rank')
	local name = frame:GetUserConfig('drop');
	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')
	local page = GET_CHILD(group, name, 'ui::CPage');
	page:PrevPage();

end

function JOURNAL_DETAIL_ITEM_NEXT_MONSTER(ctrl, ctrlset)
	
	local frame = ui.GetFrame('journal_rank')
	local name = frame:GetUserConfig('drop');
	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')
	local page = GET_CHILD(group, name, 'ui::CPage');
	page:NextPage();

end


function JOURNAL_RANK_EACH_ITEM(ctrl, ctrlSet, itemid, argNum)
	

	
	local frame = ui.GetFrame('journal_rank')
	frame:ShowWindow(1)

	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')


	local rankpage = group:CreateOrGetControl('page', 'rank_eachitem_'..itemid, 0, 400, ui.NONE_HORZ, ui.TOP, 0, 0, 0, 0)
	local droppage = group:CreateOrGetControl('page', 'drop_eachitem_'..itemid, 0, 410, ui.NONE_HORZ, ui.TOP, 0, 450, 0, 0)
	
	HIDE_CHILD_BYNAME(frame, 'detail_')
	HIDE_CHILD_BYNAME(group, 'rank_')
	HIDE_CHILD_BYNAME(group, 'drop_')

	

	
	group:ShowWindow(1);
	rankpage:ShowWindow(1);
	droppage:ShowWindow(1);


	tolua.cast(rankpage, 'ui::CPage')
	tolua.cast(droppage, 'ui::CPage')

	rankpage:SetSlotSize(300, 25)
	droppage:SetSlotSize(230, 50)
	
	rankpage:SetSlotSpace(10, 3)
	droppage:SetSlotSpace(10, 0)

	rankpage:SetBorder(5, 5, 5, 5)
	droppage:SetBorder(15, 5, 5, 5)
	

	frame:SetUserConfig('rank', 'rank_eachitem_'..itemid);
	frame:SetUserConfig('drop', 'drop_eachitem_'..itemid);

	JOURNAL_RANK_EACH_ITEM_SYNC(itemid)
	
end

function JOURNAL_RANK_EACH_ITEM_SYNC(itemid)
	
	imc.client.statistics.api.lua.sync_item_detail(itemid, 'JOURNAL_RANK_EACH_ITEM_SYNC_RESPONSE')
end

function JOURNAL_RANK_EACH_ITEM_SYNC_RESPONSE(itemid)
	JOURNAL_RANK_EACH_ITEM_DRAW(itemid)
end

function JOURNAL_RANK_EACH_ITEM_DRAW(itemid)
	
	
	local frame = ui.GetFrame('journal_rank')
	local group = GET_CHILD(frame, 'detail_item', 'ui::CGroupBox')
	local rankpage = GET_CHILD(group, 'rank_eachitem_'..itemid, 'ui::CPage')
	local droppage = GET_CHILD(group, 'drop_eachitem_'..itemid, 'ui::CPage')

	
	local ranklist = imc.client.statistics.api.lua.get_ranklist('item_get_'..itemid..'_total')
	local myrank = imc.client.statistics.api.lua.get_my_rank('item_get_'..itemid..'_total')
	local count = imc.client.statistics.api.lua.get_data('item', 'get', itemid, 'total')
	
	
	
	local text = rankpage:CreateOrGetControl('richtext', 'myrank', 300, 20, ui.LEFT, ui.TOP, 0, 0, 0, 0)
	tolua.cast(page, 'ui::CPage')

	local upanddown = ''
	local last_rank = 0
	
	

	if myrank ~= nil then

	
		last_rank = myrank.last - myrank.score

		if last_rank > 0 then
			upanddown = '+'
		else
			upanddown = '-'
		end

		

		if myrank.last == 0 then
			last_rank = 'New'
			upanddown = ''
			
		end

		text:SetText(ScpArgMsg('Auto_{s20}{#00f00F}Nae_Sunwi_:_')..myrank.score..ScpArgMsg('Auto_wi_').. '('..upanddown..last_rank..')'..ScpArgMsg('Auto_HoegDeug_')..count)
	else
		text:SetText(ScpArgMsg('Auto_Nae_Sunwi_eopeum'))
	end
	

	if ranklist ~= nil then

	local size = ranklist:size();
	local beforeScore = 0;
	local beforeRank = 1;

	for i = 0, size - 1 do
		local rank = ranklist:at(i)
		
		text = rankpage:CreateOrGetControl('richtext', i, 300, 20, ui.LEFT, ui.TOP, 0, 0, 0, 0)

		if beforeScore == rank.score then
			text:SetText('{s20}'..beforeRank..ScpArgMsg('Auto_wi__')..rank.name..ScpArgMsg('Auto__HoegDeug__')..rank.score);
		else
			text:SetText('{s20}'..(i + 1)..ScpArgMsg('Auto_wi__')..rank.name..ScpArgMsg('Auto__HoegDeug__')..rank.score);
			beforeRank = i + 1
		end

		beforeScore = rank.score;
	end

	end


	

	local clslist = GetClassList("statistics_item_monster_"..itemid);
	if clslist == nil then return end

	

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	while cls ~= nil do

		count = imc.client.statistics.api.lua.get_data('item', 'get', itemid, cls.ClassName)
		local ctrl = droppage:CreateOrGetControlSet('statistics_monster_drop_item', cls.ClassName, 0, 0)

		if count ~= nil and count ~= '0' then
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage('cepa');

			ctrl:SetTextByKey('name', '{@st42b}'..cls.Name);
			ctrl:SetTextByKey('count', '{@st50}x '..count);
			ctrl:SetOverSound("button_over");
		else
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage('icon_item_nothing');

			ctrl:SetTextByKey('name', '???????');
			ctrl:SetTextByKey('name', '{@st42b}'..cls.Name);
			ctrl:SetTextByKey('count', 'X 0');
			ctrl:SetOverSound("button_over");
		end

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

	frame:Invalidate()
end
