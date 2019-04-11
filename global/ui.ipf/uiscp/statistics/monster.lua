-- ui/uiscp/statistics/monster.lua


function STATISTICS_MONSTER_VIEW(frame)
	local monsterPicasa = frame:GetChild('monster_picasa');
	tolua.cast(monsterPicasa, 'ui::CPicasa');
	monsterPicasa:ShowWindow(1);
	--imc.client.statistics.api.lua.sync_statistics_monster(frame:GetName(), 'STATISTICS_MONSTER_VIEW_DETAIL')
	imc.client.statistics.api.lua.sync_statistics_monster(frame:GetName(), 'STATISTICS_MONSTER_VIEW_DETAIL')
end

function STATISTICS_MONSTER_VIEW_DETAIL(frame)
	local monsterPicasa = frame:GetChild('monster_picasa');
	tolua.cast(monsterPicasa, 'ui::CPicasa');
	monsterPicasa:ShowWindow(1);


	local clslist = GetClassList("statistics_monster");
	if clslist == nil then return end

	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	-- 몬스터 카테고리.
	while cls ~= nil do
		
		local Name = 'None'
		if cls.ClassName == 'Forester' then
			Name = ScpArgMsg('Auto_PoLeSeuTeu')
		elseif cls.ClassName == 'Human' then
			Name = ScpArgMsg('Auto_inKan')
		elseif cls.ClassName == 'Paramune' then
			Name = ScpArgMsg('Auto_PeLeoMyun')
		elseif cls.ClassName == 'Velnias' then
			Name = ScpArgMsg('Auto_BelLiaSeu')
		elseif cls.ClassName == 'Widling' then
			Name = ScpArgMsg('Auto_waiDeulLing')
		end

		local picasa = monsterPicasa:AddCategoryWithHide(cls.ClassName, Name)

		--MONSTER_DRAW_CATEGORY(picasa, cls.ClassName)
		MONSTER_DRAW_CATEGORY_ITEM(picasa, cls.ClassName)

		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
	end

end

function MONSTER_DRAW_CATEGORY_ITEM(picasa, CategoryName)
	local idspace = 'statistics_monster_category_'..CategoryName
	local clslist = GetClassList(idspace);
	if clslist == nil then return end

	i = 0;
	local undef = 0
	local cls = GetClassByIndexFromList(clslist, i);
	while cls ~= nil do
	
		

		local exist = imc.client.statistics.api.lua.is_exist('monster', cls.ClassName)
		if exist == true then
			local item = picasa:AddItem(cls.ClassName, 'cepa', cls.Name, "Desc")
			item:SetLBtnUpScp('SYNC_MONSTER_CATEGORY', cls.ClassName..'/'..cls.Name, session.GetMapID())
			item:SetImage('cepa')	
		else
		--[[
			item:SetImage('icon_item_nothing')
			item:SetTitle('')
			item:SetDesc(ScpArgMsg('Auto_eoDiisseulKka??????'))
			]]
			undef = undef + 1
		end


		
		i = i + 1
		cls = GetClassByIndexFromList(clslist, i);
	end
	
	if undef > 0 then
		local item = picasa:AddItem('undef', 'icon_item_nothing', (i - undef)..'/'..i, "")
		item:SetTitle(ScpArgMsg('Auto_MiHwagin_')..undef)
	end

end

function SYNC_MONSTER_CATEGORY(argNum, argStr)
	local sList = StringSplit(argStr, "/");
	imc.client.statistics.api.lua.sync_map_monster_detail(argNum, sList[1], sList[2], 1, 'MAP_MONSTER_DETAIL')
end

function MONSTER_DRAW_CATEGORY(picasa, CategoryName)

	local idspace = 'statistics_monster_category_'..CategoryName
	
	local clslist = GetClassList(idspace);
	--local GroupBox = picasa:GetGroupBox()
	--if GroupBox == nil then return end
	--GroupBox:Resize(450, 250)
	--GroupBox:SetSkinName("mypage_bar");
	--GroupBox:SetLeftScroll(1)
	if clslist == nil then return end

	local Size = 64
	local Left = 40
	local PosX = 0
	local PosY = 0
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	while cls ~= nil do

		if i ~= 0 and i % 5 == 0 then
			PosY = PosY + Size + 5
			PosX = 0
		end
		
		--local ctrl = GroupBox:CreateOrGetControlSet('statistics_map_monster_kill', cls.ClassName, Left + PosX, PosY)
		
		--local icon_ctrl =  ctrl:GetChild('pic');
	
		
		

		-- 데이터 확인. 어떤 맵에서 어떤 몬스터를 잡은적이 있을까?
		local exist = imc.client.statistics.api.lua.is_exist('monster', cls.ClassName)
		
		--[[
		if exist == true then
			icon_ctrl:SetEventScript(ui.LBUTTONUP, "SYNC_MAP_MONSTER");	
			tolua.cast(icon_ctrl, "ui::CPicture");

			
			icon_ctrl:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassName..'/'..cls.Name)
			icon_ctrl:SetEventScriptArgNumber(ui.LBUTTONUP, 0)

			icon_ctrl:SetImage('cepa');
			
		else
			tolua.cast(icon_ctrl, "ui::CPicture");
			icon_ctrl:SetImage('icon_item_nothing');
		end
		]]


		picasa:AddItem(cls.ClassName, 'cepa', 'kkk', "Desc");

		PosX = PosX + Size + 10
		
		i = i + 1
		cls = GetClassByIndexFromList(clslist, i);

		
		
	end

	if PosY < 250 then
		--GroupBox:Resize(450, PosY + Size)
	end

	--GroupBox:UpdateData()
	--GroupBox:UpdateGroupBox(1)
	
end
