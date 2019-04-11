-- ui/uiscp/statistics/map.lua

function STATISTICS_MAP_VIEW(frame)
	local mapPicasa = frame:GetChild('map_picasa');
	tolua.cast(mapPicasa, 'ui::CPicasa');
	mapPicasa:ShowWindow(1);
	imc.client.statistics.api.lua.sync_statistics_map(frame:GetName(), 'STATISTICS_MAP_VIEW_DETAIL')

end

function STATISTICS_MAP_VIEW_DETAIL(frame)

	local mapPicasa = frame:GetChild('map_picasa');
	tolua.cast(mapPicasa, 'ui::CPicasa');
	mapPicasa:ShowWindow(1);

	
	local clslist = GetClassList("statistics_map");
	if clslist == nil then return end
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);
	while cls ~= nil do

		-- 카테고리 그린다.
		local picasa = (function(cls, mapPicasa)
			local map = imc.client.statistics.api.lua.is_exist('map', cls.ClassID)
			if map == false then return nil end
			local category = mapPicasa:AddCategoryWithHide(cls.CategoryName, cls.CategoryName);
			local picasa = category:AddCategory(cls.ClassName, cls.Name, 0, 1)
			return picasa

		end)(cls, mapPicasa)

		if picasa ~= nil then

			local totalpicasa = picasa:AddCategory('Total'..cls.ClassID, ScpArgMsg('Auto_JeonChe'), 1);
			local questpicasa = picasa:AddCategory('Quest'..cls.ClassID, ScpArgMsg('Auto_KweSeuTeu'), 1, 1);
			local monsterpicasa = picasa:AddCategory('Monster'..cls.ClassID, ScpArgMsg('Auto_MonSeuTeo'), 1, 1);
			local eventpicasa = picasa:AddCategory('Event'..cls.ClassID, ScpArgMsg('Auto_iBenTeu'), 1, 1);

			-- 카테고리 안에 몬스터 리스트를 그린다.
			--local picasaItemGroupBox = picasa:GetGroupBox()

			if picasa ~= nil then
				MAP_DRAW_TOTAL(totalpicasa, cls.ClassName)
				MAP_DRAW_QUEST(questpicasa, 'statistics_map_quest_'..cls.ClassID)
				MAP_DRAW_EVENT(eventpicasa, cls.ClassName)
				MAP_DRAW_MONSTER(monsterpicasa, 'statistics_map_monster_'..cls.ClassID, cls.ClassID)
			end
		end
		i = i + 1;
		cls = GetClassByIndexFromList(clslist, i);
		--cls = nil
	end
end

function MAP_DRAW_TOTAL(picasa, MapName) 
	local GroupBox = picasa:GetGroupBox()
	GroupBox:Resize(400, 160)
	GroupBox:SetSkinName("mypage_bar");

	local quest_ctrl = GroupBox:CreateOrGetControlSet('statistics_map_total_gauge', 'quest', 180, 10)
	local icon =  quest_ctrl:GetChild('icon');
	local banner =  quest_ctrl:GetChild('banner');
	local text =  quest_ctrl:GetChild('text');
	local progress =  quest_ctrl:GetChild('progress');
	local gauge =  quest_ctrl:GetChild('gauge');

	tolua.cast(text, 'ui::CRichText');
	text:SetText(ScpArgMsg('Auto_KweSeuTeu'))

	tolua.cast(gauge, 'ui::CGauge');
	gauge:SetPoint(60, 100)

	tolua.cast(progress, 'ui::CRichText');
	progress:SetText('60 / 100')
	

	local monster_ctrl = GroupBox:CreateOrGetControlSet('statistics_map_total_gauge', 'monster', 180, 55)
	icon =  monster_ctrl:GetChild('icon');
	banner =  monster_ctrl:GetChild('banner');
	text =  monster_ctrl:GetChild('text');
	progress =  monster_ctrl:GetChild('progress');
	gauge =  monster_ctrl:GetChild('gauge');

	tolua.cast(text, 'ui::CRichText');
	text:SetText(ScpArgMsg('Auto_MonSeuTeo'))

	tolua.cast(gauge, 'ui::CGauge');
	gauge:SetPoint(10, 100)

	tolua.cast(progress, 'ui::CRichText');
	progress:SetText('10 / 100')

	
	local event_ctrl = GroupBox:CreateOrGetControlSet('statistics_map_total_gauge', 'event', 180, 100)
	icon =  event_ctrl:GetChild('icon');
	banner =  event_ctrl:GetChild('banner');
	text =  event_ctrl:GetChild('text');
	progress =  event_ctrl:GetChild('progress');
	gauge =  event_ctrl:GetChild('gauge');

	tolua.cast(text, 'ui::CRichText');
	text:SetText(ScpArgMsg('Auto_iBenTeu'))

	tolua.cast(gauge, 'ui::CGauge');
	gauge:SetPoint(90, 100)

	tolua.cast(progress, 'ui::CRichText');
	progress:SetText('90 / 100')

end

function MAP_DRAW_QUEST(picasa, idspace) 
	local clslist = GetClassList(idspace);
	local GroupBox = picasa:GetGroupBox()
	GroupBox:Resize(400, 10)
	GroupBox:SetSkinName("mypage_bar");

	if clslist == nil then 
	
	return 
	end

	local GroupBox = picasa:GetGroupBox()
	GroupBox:Resize(400, 55)
	GroupBox:SetSkinName("mypage_bar");

	local PosY = 0
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);

	if  cls == nil then return end

	local inner = GroupBox:CreateOrGetControl('groupbox', 'innergourp', 0, 0, 400, 150)
	inner:SetSkinName("mypage_bar");
	while cls ~= nil do
	
		local ctrl = inner:CreateOrGetControlSet('statistics_map_quest', cls.ClassName..i, 15, PosY)
		tolua.cast(inner, 'ui::CGroupBox');
		
		local icon_ctrl =  ctrl:GetChild('icon');
		tolua.cast(icon_ctrl, "ui::CPicture");
		icon_ctrl:SetEnableStretch(1);
		icon_ctrl:SetImage(cls.Illust);

		local dropItemNameCtrl = ctrl:GetChild('desc');
		tolua.cast(dropItemNameCtrl, 'ui::CRichText');
		dropItemNameCtrl:EnableResizeByText(1);
		dropItemNameCtrl:SetTextFixWidth(1);
		dropItemNameCtrl:SetLineMargin(-2);
		dropItemNameCtrl:SetTextAlign("left", "top");
		dropItemNameCtrl:SetText(cls.Name);

		PosY = PosY + 42
		i = i + 1
		cls = GetClassByIndexFromList(clslist, i);
	end

	inner:EnableScrollBar(1)
	inner:UpdateData()
	
	GroupBox:Resize(400, 180)
	GroupBox:UpdateData()
	
end


function MAP_DRAW_MONSTER(picasa, idspace, map_id)

	local clslist = GetClassList(idspace);
	local GroupBox = picasa:GetGroupBox()
	GroupBox:Resize(400, 10)
	GroupBox:SetSkinName("mypage_bar");

	if clslist == nil then return end

	local Size = 64
	local PosX = 0
	local PosY = 0
	local i = 0;
	local cls = GetClassByIndexFromList(clslist, i);
	GroupBox:EnableScrollBar(0)
	while cls ~= nil do

		if i ~= 0 and i % 5 == 0 then
			PosY = PosY + Size + 5
			PosX = 0
		end

		local ctrl = GroupBox:CreateOrGetControlSet('statistics_map_monster_kill', cls.ClassName, PosX, PosY)
		local icon_ctrl =  ctrl:GetChild('pic');
	
		

		-- 데이터 확인. 어떤 맵에서 어떤 몬스터를 잡은적이 있을까?
		local exist = imc.client.statistics.api.lua.is_exist('map', map_id, 'kill', cls.ClassName)
		
		if exist == true then
			icon_ctrl:SetEventScript(ui.LBUTTONUP, "SYNC_MAP_MONSTER");	
			tolua.cast(icon_ctrl, "ui::CPicture");
			icon_ctrl:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassName..'/'..cls.Name)
			icon_ctrl:SetEventScriptArgNumber(ui.LBUTTONUP, map_id)
			icon_ctrl:SetImage(cls.Illust);
		else
			tolua.cast(icon_ctrl, "ui::CPicture");
			icon_ctrl:SetImage('icon_item_nothing');
		end
	
		PosX = PosX + Size + 10
		i = i + 1
		cls = GetClassByIndexFromList(clslist, i);

		
		
	end
	GroupBox:Resize(400, PosY + 74)
	
	
end

function SYNC_MAP_MONSTER(frame, picCtrl, argStr, argNum)

	-- request monster data to server
	local sList = StringSplit(argStr, "/");
	imc.client.statistics.api.lua.sync_map_monster_detail(argNum, sList[1], sList[2], 1, 'MAP_MONSTER_DETAIL')
end


function MAP_MONSTER_DETAIL(mapid, targetid, targetname)	

	-- sync complete monster data from server
	local frame = ui.GetFrame('monster');
	frame:ShowWindow(1);

	frame:SetTitleName('{@st41}'..targetname)
	frame:SetUserConfig('targetid', targetid)
	frame:SetUserConfig('mapid', mapid)
	STATISTICS_MONSTER_TAB_CHANGE(frame)

	local text = frame:GetChild('desc');
	tolua.cast(text, 'ui::CRichText');

	text:EnableResizeByText(0);
	text:Resize(500, 20);
	text:SetTextAlign("left", "top");
	text:SetGravity(ui.CENTER_HORZ, ui.TOP);
		
end


function MAP_DRAW_EVENT(picasa, idspace) 
	--local clslist = GetClassList(idspace);
	local GroupBox = picasa:GetGroupBox()
	GroupBox:Resize(400, 10)
	GroupBox:SetSkinName("mypage_bar");
	local mapCls = GetClass("Map", idspace);
	if mapCls == nil then return end

	local mapEventCls = GetClass("Map_Event_Reward", mapCls.ClassName);
	if mapEventCls == nil then return end

	--MAP_EVENT_GBOX_ADD(400, GroupBox, mapCls, mapEventCls);
end
