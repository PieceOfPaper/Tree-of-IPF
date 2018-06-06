
--function RANK_ON_INIT(addon, frame)
--end

function MONSTER_ON_INIT(addon, frame)

end

function MONSTER_DETAIL_OPEN(frame, ctrl, argStr, argNum)
end

function STATISTICS_MONSTER_TAB_CHANGE(frame)

	local tabCtrl = frame:GetChild('tab1');
	tolua.cast(tabCtrl, "ui::CTabControl");
	local selectName = tabCtrl:GetSelectItemName();

	frame:GetChild('totalkill'):ShowWindow(0)
	frame:GetChild('overkill'):ShowWindow(0)
	frame:GetChild('nomlkill'):ShowWindow(0)
	frame:GetChild('mapkill'):ShowWindow(0)

	local targetid = frame:GetUserConfig('targetid')
	local mapid = frame:GetUserConfig('mapid')

	DRAW_STATISTICS_MONSTER_DETAIL_CATEGORY(frame, targetid)

	if selectName == 'totalkilltab' then

		local ranklist = imc.client.statistics.api.lua.get_ranklist('monster_'..targetid..'_kill_total')
		local myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_kill_total')
		local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'kill', 'total')
		local rank = frame:GetChild('totalkill')
		STATISTICS_MONSTER_DETAIL_KILL_RANK(rank, ranklist, myrank, count)

	elseif selectName == 'overkilltab' then

		local ranklist = imc.client.statistics.api.lua.get_ranklist('monster_'..targetid..'_kill_over')
		local myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_kill_over')
		local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'kill', 'over')
		local rank = frame:GetChild('overkill')
		STATISTICS_MONSTER_DETAIL_KILL_RANK(rank, ranklist, myrank, count)

	elseif selectName == 'nomlkilltab' then

		local ranklist = imc.client.statistics.api.lua.get_ranklist('monster_'..targetid..'_kill_noml')
		local myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_kill_noml')
		local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'kill', 'noml')
		local rank = frame:GetChild('nomlkill')
		STATISTICS_MONSTER_DETAIL_KILL_RANK(rank, ranklist, myrank, count)

	elseif selectName == 'mapkilltab' then

		local ranklist = imc.client.statistics.api.lua.get_ranklist('map_'..mapid..'_kill_'..targetid)
		local myrank = imc.client.statistics.api.lua.get_my_rank('map_'..mapid..'_kill_'..targetid)
		local count = imc.client.statistics.api.lua.get_data('map', mapid, 'kill', targetid)
		local rank = frame:GetChild('mapkill')
		STATISTICS_MONSTER_DETAIL_KILL_RANK(rank, ranklist, myrank, count)

	end

	tabCtrl = frame:GetChild('tab2');
	tolua.cast(tabCtrl, "ui::CTabControl");
	selectName = tabCtrl:GetSelectItemName();

	frame:GetChild('item'):ShowWindow(0)
	frame:GetChild('achieve'):ShowWindow(0)

	if selectName == 'itembox' then
		frame:GetChild('item'):ShowWindow(1)
		STATISTICS_MONSTER_DETAIL_GET_ITEM(frame, targetid, mapid)
	elseif selectName == 'achievebox' then
		frame:GetChild('achieve'):ShowWindow(1)
	end

end

function STATISTICS_MONSTER_DETAIL_KILL_RANK(rank, ranklist, myrank, count)
	tolua.cast(rank, "ui::CGroupBox");
	rank:ShowWindow(1)
	rank:EnableScrollBar(1)
	rank:DeleteAllControl()
	local droplist = rank:CreateOrGetControl('richtext', 'myrank', 15, 10, 400, 20)

	local last_rank = 0
	if myrank ~= nil then
		last_rank = myrank.last - myrank.score
	end

	local upanddown = ''
	if last_rank > 0 then
		upanddown = '+'
	end

	if myrank.last == 0 then
		last_rank = 'New'
	end



	if count ~= nil and count ~= '0' then
		droplist:SetText(ScpArgMsg('Auto_{s20}{ol}{#00f00F}Nae_Sunwi_:_')..myrank.score..ScpArgMsg('Auto_wi_').. '('..upanddown..last_rank..')   '..count..ScpArgMsg('Auto__Kil'))
	else

		if myrank == nil then
			droplist:SetText('{@st42b}'..ScpArgMsg('Auto_DeiTeo_eopeum'))
		elseif myrank.last == 0 then
			droplist:SetText('{@st42b}'..ScpArgMsg('Auto_DeiTeo_eopeum'))
		else
			droplist:SetText('{@st42b}'..ScpArgMsg('Auto_Sunwi_eopeum___JiNanJu_')..myrank.last..ScpArgMsg('Auto_wi'))
		end


	end

	local size = 0
	if ranklist ~= nil then
		size = ranklist:size()
	end



	for i = 0, size - 1 do

		local data = ranklist:at(i)

		local droplist = rank:CreateOrGetControl('richtext', 'rank'..i, 15, 40 + i * 22, 400, 20)
		tolua.cast(droplist, "ui::CRichText");

		local new_ranking = i + 1
		local ranking_elapse = data.last - new_ranking

		upanddown = ''
		if ranking_elapse > 0 then
			upanddown = '+'
		end

		if data.last == 0 then
			ranking_elapse = 'New'
		end

		droplist:SetText('{@st42b}'..(i + 1)..ScpArgMsg('Auto_wi_')..'('..upanddown..ranking_elapse..')    '..data.name..'    '..data.score..ScpArgMsg('Auto_Kil'))


	end


	rank:UpdateData()

end

function STATISTICS_MONSTER_DETAIL_GET_ITEM(frame, targetid, mapid)

	local item = frame:GetChild('item')
	tolua.cast(item, 'ui::CGroupBox')

	local clslist = GetClassList('statistics_monster_item_'..targetid);
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);
	local ypos = 10
	local xpos = 10
	local offset = 0;
	item:DeleteAllControl()
	while cls ~= nil do
		local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'item_get', cls.ClassID)

		local newline = offset % 1;
		if newline == 1 then
			xpos = 5
		end

		if newline == 0 and offset ~= 0 then
			ypos = ypos + 50
		end



		local ctrl = item:CreateOrGetControlSet('statistics_monster_drop_item', 'item'..offset, xpos, ypos)
		if count ~= nil and count ~= '0' then
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage(cls.Icon);

			ctrl:SetTextByKey('name', '{@st42b}'..cls.Name);
			ctrl:SetTextByKey('count', '{@st50}x '..count);
			ctrl:SetOverSound("button_over");
		else
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage('icon_item_nothing');

			ctrl:SetTextByKey('name', '???????');
			ctrl:SetTextByKey('count', '--');
			ctrl:SetOverSound("button_over");
		end



		i = i + 1
		offset = offset + 1
		cls = GetClassByIndexFromList(clslist, i);
	end


	i = 0
	clslist = GetClassList('statistics_map_item_'..mapid);
	local cls = GetClassByIndexFromList(clslist, i);
	while cls ~= nil do
		local newline = offset % 1;
		if newline == 1 then
			xpos = 5
		end

		if newline == 0 and offset ~= 0 then
			ypos = ypos + 50
		end

		local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'item_get', cls.ClassID)

		local ctrl = item:CreateOrGetControlSet('statistics_monster_drop_item', 'item'..offset, xpos, ypos)
		if count ~= nil and count ~= '0' then
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage(cls.Icon);
			ctrl:SetTextByKey('name', '{@st42b}'..cls.Name);
			ctrl:SetTextByKey('count', '{@st50}x '..count);
			ctrl:SetOverSound("button_over");
		else
			local icon =  ctrl:GetChild('icon');
			tolua.cast(icon, "ui::CPicture");
			icon:SetEnableStretch(1);
			icon:SetImage('icon_item_nothing');
			ctrl:SetTextByKey('name', '???????');
			ctrl:SetTextByKey('count', '--');
			ctrl:SetOverSound("button_over");
		end

		i = i + 1
		offset = offset + 1
		cls = GetClassByIndexFromList(clslist, i);
	end

	item:UpdateData()
end

function DRAW_STATISTICS_MONSTER_DETAIL_CATEGORY(frame, targetid)

	local group_box = frame:GetChild('category')

	local myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_kill_total')
	local count = imc.client.statistics.api.lua.get_data('monster', targetid, 'kill', 'total')

	tolua.cast(group_box, 'ui::CGroupBox')

	local battle = group_box:CreateOrGetControlSet('statistics_monster_detail_category_button', 'battle', 10, 10)
	group_box:ShowWindow(1)

	local rank = 0
	local score = 0

	if myrank ~= nil then
		rank = myrank.score
	end

	if count ~= nil then
		score = count
	end

	tolua.cast(battle, 'ui::CControlSet')
	local icon =  battle:GetChild('icon');
	tolua.cast(icon, "ui::CPicture");
	icon:SetEnableStretch(1);
	icon:SetImage('cepa');
	battle:SetTextByKey('title', '{@st42b}'..ScpArgMsg('Auto_SaNyang'));
	battle:SetTextByKey('count', '{@st50}'..score..ScpArgMsg('Auto_Kil'));
	battle:SetTextByKey('rank', '{@st50}'..rank..ScpArgMsg('Auto__wi'));
	battle:SetOverSound("button_over");
	battle:SetEnableSelect(1)

	battle:SetSelectGroupName('statistics_monster_category')

	local item_count = imc.client.statistics.api.lua.get_data('monster', targetid, 'item_get', 'total')
	myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_item_get_total')

	score = 0
	if item_count ~= nil then
		score = item_count
	end

	rank = 0;
	if myrank ~= nil then
		rank = myrank.score
	end

	local item = group_box:CreateOrGetControlSet('statistics_monster_detail_category_button', 'item', 10, 80)
	tolua.cast(item, 'ui::CControlSet')

	icon =  item:GetChild('icon');
	tolua.cast(icon, "ui::CPicture");
	icon:SetEnableStretch(1);
	icon:SetImage('icon_item_Quest_00017');
	item:SetTextByKey('title', '{@st42b}'..ScpArgMsg('Auto_aiTem'));
	item:SetTextByKey('count', '{@st50}'..score..ScpArgMsg('Piece'));
	item:SetTextByKey('rank', '{@st50}'..rank..ScpArgMsg('Auto__wi'));
	item:SetOverSound("button_over");
	item:SetEnableSelect(1)

	item:SetSelectGroupName('statistics_monster_category')

	local silver_count = imc.client.statistics.api.lua.get_data('monster', targetid, 'item_get', '900011')
	myrank = imc.client.statistics.api.lua.get_my_rank('monster_'..targetid..'_item_get_900011')

	score = 0
	if silver_count ~= nil then
		score = silver_count
	end
	rank = 0;
	if myrank ~= nil then
		rank = myrank.score
	end

	local silver = group_box:CreateOrGetControlSet('statistics_monster_detail_category_button', 'silver', 10, 160)
	tolua.cast(silver, 'ui::CControlSet')

	icon =  silver:GetChild('icon');
	tolua.cast(icon, "ui::CPicture");
	icon:SetEnableStretch(1);
	icon:SetImage('icon_item_silver');
	silver:SetTextByKey('title', '{@st42b}'..ScpArgMsg('Auto_SilBeo'));
	silver:SetTextByKey('count', '{@st50}'..score);
	silver:SetTextByKey('rank', '{@st50}'..rank..ScpArgMsg('Auto__wi'));
	silver:SetOverSound("button_over");
	silver:SetEnableSelect(1)
	silver:SetSelectGroupName('statistics_monster_category')
end

