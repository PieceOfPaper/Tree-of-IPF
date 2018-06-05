
--function RANK_ON_INIT(addon, frame)	
--end


function STATISTIICS_ITEM_DETAIL_OPEN(frame, ctrl, argStr, argNum)	
end

function STATISTICS_ITEM_TAB_CHANGE(frame)

	local tabCtrl = frame:GetChild('tab1');
	tolua.cast(tabCtrl, "ui::CTabControl");
	local selectName = tabCtrl:GetSelectItemName();

	frame:GetChild('itemtotal'):ShowWindow(0)
	frame:GetChild('itemparty'):ShowWindow(0)
	frame:GetChild('itemmap'):ShowWindow(0)

	local item_id = frame:GetUserConfig('item_id')

	--DRAW_STATISTICS_ITEM_DETAIL_CATEGORY(frame, targetid)
	
	if selectName == 'itemtotaltab' then

		local ranklist = imc.client.statistics.api.lua.get_ranklist('item_'..item_id..'_get_total')
		local myrank = imc.client.statistics.api.lua.get_my_rank('item_'..item_id..'_get_total')
		local count = imc.client.statistics.api.lua.get_data('item', item_id, 'get', 'total')
		local rank = frame:GetChild('itemtotal')
		STATISTICS_ITEM_DETAIL_GET_RANK(rank, ranklist, myrank, count)
		
	elseif selectName == 'itempartytab' then

		frame:GetChild('itemparty'):ShowWindow(1)

	elseif selectName == 'itemmaptab' then

		frame:GetChild('itemmap'):ShowWindow(1)

	end

	tabCtrl = frame:GetChild('tab2');
	tolua.cast(tabCtrl, "ui::CTabControl");
	selectName = tabCtrl:GetSelectItemName();

	frame:GetChild('monster'):ShowWindow(0)
	frame:GetChild('achieve'):ShowWindow(0)

	if selectName == 'monstertab' then
		frame:GetChild('monster'):ShowWindow(1)
		STATISTICS_ITEM_DETAIL_DROP_MONSTER(frame, item_id)

	elseif selectName == 'achievetab' then
		frame:GetChild('achieve'):ShowWindow(1)
	end

end

function STATISTICS_ITEM_DETAIL_GET_RANK(rank, ranklist, myrank, count)

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
		droplist:SetText(ScpArgMsg('Auto_{s20}{#00f00F}Nae_Sunwi_:_')..myrank.score..ScpArgMsg('Auto_wi_').. '('..upanddown..last_rank..')   '..count..ScpArgMsg('Auto__Kae_HoegDeug'))
	else

		if myrank == nil then
			droplist:SetText('{s20}{#FFFFFF}'..ScpArgMsg('Auto_DeiTeo_eopeum'))
		elseif myrank.last == 0 then
			droplist:SetText('{s20}{#FFFFFF}'..ScpArgMsg('Auto_DeiTeo_eopeum'))
		else
			droplist:SetText('{s20}{#FFFFFF}'..ScpArgMsg('Auto_Sunwi_eopeum___JiNanJu_')..myrank.last..ScpArgMsg('Auto_wi'))
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

		droplist:SetText('{s20}{#FFFFFF}'..(i + 1)..ScpArgMsg('Auto_wi_')..'('..upanddown..ranking_elapse..')    '..data.name..'    '..data.score..ScpArgMsg('Auto__Kae_HoegDeug'))


	end
	

	rank:UpdateData()

end


function STATISTICS_ITEM_DETAIL_DROP_MONSTER(frame, item_id)

	local monster = frame:GetChild('monster')
	tolua.cast(monster, 'ui::CGroupBox')

	local clslist = GetClassList('statistics_item_monster_'..item_id);
	monster:DeleteAllControl()
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);
	local ypos = 10	
	local xpos = 10
	local offset = 0;
	
	while cls ~= nil do

	
		local count = imc.client.statistics.api.lua.get_data('item', item_id, 'get', cls.ClassName)

		local newline = offset % 2;
		if newline == 1 then
			xpos = 260
		else
			xpos = 10
		end

		if newline == 0 and offset ~= 0 then
			ypos = ypos + 50
		end



		local ctrl = monster:CreateOrGetControlSet('statistics_monster_drop_item', 'monster'..offset, xpos, ypos)
		
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

	
		i = i + 1
		offset = offset + 1
		cls = GetClassByIndexFromList(clslist, i);

	end
	
	monster:UpdateData()

end
