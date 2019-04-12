-- inun.lua

function INDUN_ON_INIT(addon, frame)
	addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'ON_CHAT_INDUN_UI_OPEN');
	addon:RegisterMsg('INDUN_COUNT_RESET', 'ON_INDUN_COUNT_RESET');	
end

function ON_INDUN_COUNT_RESET(frame)
	--리셋관련 구현해야함.
end

function ON_CHAT_INDUN_UI_OPEN(frame, msg, argStr, argNum)
	if nil ~= frame then
		frame:ShowWindow(1);
	else
		ui.OpenFrame("indun");
	end
end

function INDUN_UI_OPEN(frame)
	INDUN_DRAW_CATEGORY(frame)
end

function INDUN_DRAW_CATEGORY(frame)
	frame:SetUserValue('SELECT', 'None');

	local categBox = GET_CHILD_RECURSIVELY(frame, "categBox", "ui::CGroupBox");
	local cateList = GET_CHILD_RECURSIVELY(categBox, "cateList", "ui::CGroupBox");
	cateList:RemoveAllChild();
	 
	local etcObj = GetMyEtcObject();
	if nil == etcObj then
		return;
	end

	local isPremiumState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
	local clslist, cnt = GetClassList("Indun");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local child = cateList:GetChild('CTRLSET_' .. cls.PlayPerResetType)
		if child == nil and cls.Category ~= 'None' then
			local ctrlSet = cateList:CreateControlSet("indun_cate_ctrl", "CTRLSET_" .. cls.PlayPerResetType, ui.LEFT, 0, 0, 0, 0, i*50);
			local name = ctrlSet:GetChild("name");
			name:SetTextByKey("value", cls.Category);

			local cnt = ctrlSet:GetChild("cnt");
			local etcType = "InDunCountType_"..tostring(cls.PlayPerResetType);
			cnt:SetTextByKey("cnt", TryGetProp(etcObj, etcType));
			local maxPlayCnt = cls.PlayPerReset;
			if true == isPremiumState then 
				maxPlayCnt = maxPlayCnt + cls.PlayPerReset_Token;
				if cls.PlayPerReset_Token > 0 then
					ctrlSet:SetUserValue("SHOW_INDUN_TEXT", "YES");
					ctrlSet:SetUserValue('TOKEN_BONUS', cls.PlayPerReset_Token);
				end
			end

			cnt:SetTextByKey("max", maxPlayCnt);
			ctrlSet:SetUserValue('RESET_TYPE', cls.PlayPerResetType)

			if i == 0 then
				local btn = ctrlSet:GetChild("button");
				INDUN_CATE_LBTN_CILK(ctrlSet, btn)
			end
		end
	end
	GBOX_AUTO_ALIGN(cateList, 0, -6, 0, true, false);
end

function INDUN_CATE_LBTN_CILK(frame, ctrl)
	local topFrame = frame:GetTopParentFrame();
	local preSeletType = topFrame:GetUserValue('SELECT');
	local preSelect = GET_CHILD_RECURSIVELY(topFrame, "CTRLSET_" .. preSeletType);
	if nil ~= preSelect then
		local button = preSelect:GetChild("button");
		button:SetSkinName("base_btn"); -- / baseyellow_btn
	end

	local nowType = frame:GetUserValue('RESET_TYPE');
	topFrame:SetUserValue('SELECT', nowType);
	ctrl:SetSkinName("baseyellow_btn");

	-- 추가 입장 관련된 애 눌렀을 때만 안내 메세지 나올 수 있도록
	local indunText = topFrame:GetChild('indunText');
	local cateCtrl = ctrl:GetParent();
	if cateCtrl:GetUserValue("SHOW_INDUN_TEXT") == "YES" then
		local msg = ScpArgMsg("IndunMore{COUNT}ForTOKEN", "COUNT", cateCtrl:GetUserValue('TOKEN_BONUS'));
		indunText:SetTextByKey("value", msg);
		indunText:ShowWindow(1);
	else
		indunText:ShowWindow(0);
	end
	INDUN_SHOW_INDUN_LIST(topFrame, tonumber(nowType))
end

function INDUN_SHOW_INDUN_LIST(frame, indunType)
	local lvUpCheckBox = GET_CHILD(frame, "levelUp", "ui::CCheckBox");
	local lvDownCheckBox = GET_CHILD(frame, "levelDown", "ui::CCheckBox");

	if lvUpCheckBox:IsChecked() == 0 and lvDownCheckBox:IsChecked() == 0 then		
		lvUpCheckBox:SetCheck(1) -- default option
	end

	local clslist, cnt = GetClassList("Indun");
	local indunTable = {};
	-- sort by level
	local indunTable = {}
	for i = 0, cnt - 1 do
		indunTable[i + 1] = GetClassByIndexFromList(clslist, i);
	end

	if lvUpCheckBox:IsChecked() == 1 then
		table.sort(indunTable, SORT_BY_LEVEL);
	else
		table.sort(indunTable, SORT_BY_LEVEL_REVERSE);
	end

	local listgBox = GET_CHILD_RECURSIVELY(frame, "listgBox", "ui::CGroupBox");
	local indunList = GET_CHILD_RECURSIVELY(listgBox, "indunList", "ui::CGroupBox");
	indunList:RemoveAllChild();

	local mylevel = info.GetLevel(session.GetMyHandle());

	for i = 1 , cnt do
		local cls = indunTable[i]
		if cls.PlayPerResetType == indunType and TryGetProp(cls, 'Category') ~= 'None' then
			local ctrlSet = indunList:CreateControlSet("indun_detail_ctrl", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, i*50);
			local name = ctrlSet:GetChild("name");
			name:SetTextByKey("value", cls.Name);

			local lv = ctrlSet:GetChild("lv");
			lv:SetTextByKey("value", cls.Level);

			local map = ctrlSet:GetChild("map");
			local sList = StringSplit(cls.StartMap, "/");
			if nil ~= sList then
				local mapName = ''
				for j = 1, #sList do
					local mapCls = GetClass('Map', sList[j])	
					if nil ~= mapCls then
						mapName = mapName .. string.format("{img %s %d %d} ", "link_map", 20, 20) .. mapCls.Name .. '{nl}'

						-- minimap tooltip
						map:SetTooltipType('indun_tooltip')
						map:SetTooltipStrArg(cls.StartMap)
						map:SetTooltipNumArg(cls.ClassID)
					end
				end
				map:SetTextByKey("value",mapName);
			else
				map:ShowWindow(0);
			end

			if #sList > 1 then
				ctrlSet:Resize(ctrlSet:GetWidth(), ctrlSet:GetHeight() + 30);
			end

			local starImg = '';
			local star = cls.Level/ 100 
			for i = 0, star do
				starImg = starImg .. string.format("{img %s %d %d}", "star_mark", 20, 20) 
			end

			local grade = ctrlSet:GetChild("grade");
			grade:SetTextByKey("value", starImg);

			local button = ctrlSet:GetChild("button");
			if tonumber(cls.Level) < mylevel then -- 연두라인
				button:SetColorTone("FFC4DFB8");	
			elseif tonumber(cls.Level) > mylevel then -- 빨간라인
				button:SetColorTone("FFFFCA91");
			else
				button:SetColorTone("FFFFFFFF");	
			end

			local offset = (#sList - 1) * 20
			ctrlSet:Resize(ctrlSet:GetWidth(), ctrlSet:GetOriginalHeight() + offset );
			button:Resize(ctrlSet:GetWidth(), ctrlSet:GetOriginalHeight() + offset );
		end
	end
	GBOX_AUTO_ALIGN(indunList, 0, -6, 0, false, false);
end

function INDUN_CANNOT_YET(msg)
	ui.SysMsg(ScpArgMsg(msg));
	ui.OpenFrame("indun");
end

function GID_CANTFIND_MGAME(msg)
	ui.SysMsg(ScpArgMsg(msg));
end

-- 레벨순정렬
function INDUN_SORT_OPTIN_CHECK(frame, ctrl)
	local lvUpCheckBox = GET_CHILD(frame, "levelUp", "ui::CCheckBox");
	local lvDownCheckBox = GET_CHILD(frame, "levelDown", "ui::CCheckBox");

	if lvUpCheckBox:GetName() == ctrl:GetName() then
		lvUpCheckBox:SetCheck(1)
		lvDownCheckBox:SetCheck(0)
	else
		lvUpCheckBox:SetCheck(0)
		lvDownCheckBox:SetCheck(1)
	end

	local topFrame = frame:GetTopParentFrame();
	local nowSelect = topFrame:GetUserValue('SELECT');
	INDUN_SHOW_INDUN_LIST(topFrame, tonumber(nowSelect));
end

function SORT_BY_LEVEL(a, b)	
	if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
		return false
	end
	return tonumber(a.Level) < tonumber(b.Level)
end

function SORT_BY_LEVEL_REVERSE(a, b)	
	if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
		return false
	end
	return tonumber(a.Level) > tonumber(b.Level)
end

function DRAW_NPC_ICON(frame, MonProp, mapprop, mapWidth, mapHeight, offsetX, offsetY)
	local GenList = MonProp.GenList;
	local GenCnt = GenList:Count();
	for j = 0 , GenCnt - 1 do
		local WorldPos = GenList:Element(j);
		local MapPos = mapprop:WorldPosToMinimapPos(WorldPos.x, WorldPos.z, mapWidth, mapHeight);
		local XC = offsetX + MapPos.x - 12;
		local YC = offsetY + MapPos.y - 12;

		local ctrlname = GET_GENNPC_NAME(frame, MonProp);
		local PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
		tolua.cast(PictureC, "ui::CPicture");

		local iconName = MonProp:GetMinimapIcon()
		if iconName == nil or iconName == 'None' then
			iconName = 'minimap_0' -- default icon
		end
		PictureC:SetImage(iconName)
		PictureC:SetEnableStretch(1)
		PictureC:ShowWindow(1)
	end
end

function MAKE_INDUN_ICON(frame, mapName, indunCls, mapWidth, mapHeight, offsetX, offsetY)
	-- param check
	if frame == nil or mapName == nil or indunCls == nil then
		return
	end	
	DESTORY_MAP_PIC(frame)

	-- get indun gate map property
	local mapprop = geMapTable.GetMapProp(mapName)
	if mapprop == nil then
		return
	end

	-- get generated npc
	local mongens = mapprop.mongens
	local monGenCnt = mongens:Count()
	local iconW = 24
	local iconH = 24

	for i = 0 , monGenCnt - 1 do
		local MonProp = mongens:Element(i);		
		if MonProp ~= nil then
			local startNPCDialog = TryGetProp(indunCls, 'StartNPCDialog')
			if startNPCDialog ~= nil and startNPCDialog ~= 'None' and startNPCDialog == MonProp:GetDialog() then
				DRAW_NPC_ICON(frame, MonProp, mapprop, mapWidth, mapHeight, offsetX, offsetY)
			end
		end
	end


end

function UPDATE_INDUN_TOOLTIP(frame, argStr, argNum)
	------------- param check ----------------
	if frame == nil or argStr == nil or argNum == nil then
		return
	end

	local argList = StringSplit(argStr, '/')
	if #argList < 1 then -- argStr must be "startmap1/startmap2/.../startmapN' (N >= 1)
		return
	end

	local drawList = {};
	for i = 1, #argList do
		local mapCls = GetClass('Map', argList[i])
		if mapCls == nil then -- not exist map
			return
		end

		local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
		drawList[#drawList + 1] = mapCls;
	end

	local indunCls = GetClassByType('Indun', argNum)
	if #drawList < 1 or indunCls == nil then -- some param error
		return
	end

	------------- draw tooltip ----------------
	frame:RemoveAllChild();
	frame:Resize(ui.GetClientInitialWidth(), 512);
	for i = 1 , #drawList do
		local drawCls = drawList[i];
		local ctrlSet = frame:CreateControlSet("worldmap_tooltip", "MAP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local mapNameFont = MAPNAME_FONT_CHECK(drawCls.QuestLevel)

		local ratestr = ""
		if 0 ~= MAP_USE_FOG(drawCls.ClassName) and session.GetMapFogRevealRate(drawCls.ClassName) >= 100 then
			ratestr = " {img minimap_complete 24 24}"
		end

		local mapnameCtrl = ctrlSet:GetChild("mapname");
		mapnameCtrl:SetTextByKey("text", mapNameFont..drawCls.Name..ratestr);
		
		local drawMapName = drawCls.ClassName;
		local pic = GET_CHILD(ctrlSet, "map", "ui::CPicture");
		local mapimage = ui.GetImage(drawMapName .. "_fog");
		if mapimage == nil then
			world.PreloadMinimap(drawMapName);
		end
		pic:SetImage(drawMapName .. "_fog");
		
		local worldMapWidth = ui.GetFrame("worldmap"):GetWidth()
		local worldMapHeight = ui.GetFrame("worldmap"):GetHeight()

		local iconGroup = ctrlSet:CreateControl("groupbox", "MapIconGroup", 0, 0, frame:GetWidth(), frame:GetHeight());
		iconGroup:SetSkinName("None");
		
		local nameGroup = ctrlSet:CreateControl("groupbox", "RegionNameGroup", 0, 0, frame:GetWidth(), frame:GetHeight());
		nameGroup:SetSkinName("None");

		local mapWidth = pic:GetWidth();
		local mapHeight = pic:GetHeight();

		local offsetX = 450;
		local offsetY = 210;

		-- 여기서 npc 세팅해줌
		MAKE_INDUN_ICON(iconGroup, drawMapName, indunCls, mapWidth, mapHeight, offsetX, offsetY)
		pic:EnableCopyOtherImage(nil);
		
		for i = 0, iconGroup:GetChildCount()-1 do
			local child = iconGroup:GetChildByIndex(i);
			
			child:Move( -1*worldMapWidth*(23/100), 0);
			child:Move( 0, -1*mapHeight*(40/100));
		end
		
		for i = 0, nameGroup:GetChildCount()-1 do
			local child = nameGroup:GetChildByIndex(i);	
			
			child:Move( -1*worldMapWidth*(23/100), 0);
			child:Move( 0, -1*mapHeight*(40/100));
		end

		ctrlSet:GetChild("monlv"):SetVisible(0)
	end
	GBOX_AUTO_ALIGN_HORZ(frame, 10, 5, 0, true, true, 512, true);	
end