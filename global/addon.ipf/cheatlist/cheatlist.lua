
max_runscp_factor_cnt = 4;

function CHEATLIST_ON_INIT(addon, frame)
	
end

function CHEATLIST_FIRST_OPEN(frame)

local tabObj		 = frame:GetChild('cheatlisttap');
	cheatlist_tab		 = tolua.cast(tabObj, "ui::CTabControl");

	local changeBtnObj			= frame:GetChild('UseBtn');
	cheatlist_changeBtnCtrl		= tolua.cast(changeBtnObj, 'ui::CButton');
	cheatlist_changeBtnCtrl:SetText(ScpArgMsg("Auto_{@st41b}SaengSeong{/}"));

	local ItemTreeObj		= frame:GetChild('itemtree');
	local MonsterTreeObj	= frame:GetChild('monstertree');
	local MapTreeObj	 	= frame:GetChild('maptree');
	local OthersTreeObj	= frame:GetChild('otherstree');

	CheatList_curtabIndex = 0;

	CheatList_tree_array = {};
	CheatList_tree_array[0] = tolua.cast(ItemTreeObj, "ui::CTreeControl");
	CheatList_tree_array[1] = tolua.cast(MonsterTreeObj, "ui::CTreeControl");
	CheatList_tree_array[2] = tolua.cast(MapTreeObj, "ui::CTreeControl");
	CheatList_tree_array[3] = tolua.cast(OthersTreeObj, "ui::CTreeControl");

	CheatList_tree = CheatList_tree_array[0];

	for i = 1, 3 do
		CheatList_tree_array[i]:ShowWindow(0);
	end

	local ItemUseGroupBox		= frame:GetChild('ItemUseGroup');
	local CreatMonGroupBox		= frame:GetChild('CreatMonGroup');
	local MzMapGroupBox		= frame:GetChild('MzMapGroup');
	local OthersGroupBox		= frame:GetChild('OthersGroup');
	CheatList_itemusegroup	= tolua.cast(ItemUseGroupBox, "ui::CGroupBox");
	CheatList_creatmongroup	= tolua.cast(CreatMonGroupBox, "ui::CGroupBox");
	CheatList_mzmapgroup	= tolua.cast(MzMapGroupBox, "ui::CGroupBox");
	CheatList_othersgroup	= tolua.cast(OthersGroupBox, "ui::CGroupBox");

	local cnEditObj		 = CheatList_itemusegroup:GetChild('itemcount');
	local MonLVObj		 = CheatList_creatmongroup:GetChild('MonLV');
	local MonCTObj		 = CheatList_creatmongroup:GetChild('MonCT');
    local ForkNameObj		 = CheatList_othersgroup:GetChild('ForkName');
	CheatList_cnEdit	  = tolua.cast(cnEditObj, "ui::CEditControl");
	CheatList_MonLV	  = tolua.cast(MonLVObj, "ui::CEditControl");
	CheatList_MonCT	  = tolua.cast(MonCTObj, "ui::CEditControl");
    CheatList_ForkName	  = tolua.cast(ForkNameObj, "ui::CEditControl");
	CheatList_cnEdit:SetText("1");
	CheatList_MonLV:SetText("1");
	CheatList_MonCT:SetText("1");

	local height = 40;
	local startOffset = 20;
    for i = 1 ,  max_runscp_factor_cnt do

		local objname = "Runscp_Name" .. i;
		local robj = CheatList_othersgroup:CreateOrGetControl('richtext', objname, 10, height * i + startOffset, 80 + height, height);
		robj:SetFontName("white_24_ol");
		robj:SetText(objname);
		robj:ShowWindow(0);
		robj:SetEventScript(ui.ENTERKEY, "CREATE_LIST_LBDBLCLICK");

		objname = "Runscp_Edit" .. i;
		local eobj = CheatList_othersgroup:CreateOrGetControl('edit', objname, 200, height * i + startOffset, 300, height);
		tolua.cast(eobj, "ui::CEditControl");
		eobj:SetEnableEditTag(1);
		eobj:SetFontName("white_24_ol");
		eobj:SetText(objname);
		eobj:ShowWindow(0);
		eobj:SetEventScript(ui.ENTERKEY, "CREATE_LIST_LBDBLCLICK");

    end


	CREATEITEM_UPDATE_ITEM(frame);
	CREATEMONSTER_UPDATE_MONSTER(frame);
	MZLIST_UPDATE_MAP(frame)
	CHEATOTHERS_UPDATE_OTHERS(frame);

	CheatList_itemusegroup:ShowWindow(1);
	CheatList_creatmongroup:ShowWindow(0);
	CheatList_mzmapgroup:ShowWindow(0);
	CheatList_othersgroup:ShowWindow(0);

end

function SEARCH_ITEM_CHEATLIST(frame, ctrl)

	CREATEITEM_UPDATE_ITEM(frame);
	
end

function SEARCH_MON_CHEATLIST(frame, ctrl)
	CREATEMONSTER_UPDATE_MONSTER(frame);
end



function SEARCH_MAP_CHEATLIST(frame, ctrl)

	MZLIST_UPDATE_MAP(frame);
end



function SEARCH_COMBAT_CHEATLIST(frame, ctrl)
	
	CHEATOTHERS_UPDATE_OTHERS(frame);
	
end




function CHEATLIST_TAB_CHANGE(frame, obj, argStr, argNum)
	CheatList_curtabIndex	= cheatlist_tab:GetSelectItemIndex();

	for i = 0, 3 do
		CheatList_tree_array[i]:ShowWindow(0);
	end

	CheatList_tree_array[CheatList_curtabIndex]:ShowWindow(1);
	CheatList_tree = CheatList_tree_array[CheatList_curtabIndex];
	CHEATLIST_ADD_GROUP(frame, obj, argStr, CheatList_curtabIndex)
end

function CHEATLIST_ADD_GROUP(frame, obj, argStr, argNum)
	if argNum == 0 then
		CheatList_creatmongroup:ShowWindow(0);
		CheatList_mzmapgroup:ShowWindow(0);
		CheatList_othersgroup:ShowWindow(0);
		CheatList_itemusegroup:ShowWindow(1);
		cheatlist_changeBtnCtrl:SetText(ScpArgMsg("Auto_{@st41}SaengSeong{/}"));
   elseif argNum == 1 then
   	CheatList_itemusegroup:ShowWindow(0);
   	CheatList_mzmapgroup:ShowWindow(0);
   	CheatList_othersgroup:ShowWindow(0);
		CheatList_creatmongroup:ShowWindow(1);
		cheatlist_changeBtnCtrl:SetText(ScpArgMsg("Auto_{@st41}SaengSeong{/}"));
	elseif argNum == 2 then
		CheatList_itemusegroup:ShowWindow(0);
   	CheatList_othersgroup:ShowWindow(0);
		CheatList_creatmongroup:ShowWindow(0);
		CheatList_mzmapgroup:ShowWindow(1);
		cheatlist_changeBtnCtrl:SetText(ScpArgMsg("Auto_{@st41}iDong{/}"));
   elseif argNum == 3 then
   	CheatList_itemusegroup:ShowWindow(0);
   	CheatList_mzmapgroup:ShowWindow(0);
		CheatList_creatmongroup:ShowWindow(0);
		CheatList_othersgroup:ShowWindow(1);
		cheatlist_changeBtnCtrl:SetText(ScpArgMsg("Auto_{@st41}Sayong{/}"));
	else
		ui.CloseFrame('cheatlist');
   end
end

function CREATE_LIST_LBDBLCLICK(frame, obj, argStr, argNum)
	CheatList_curtabIndex	= cheatlist_tab:GetSelectItemIndex();
	if CheatList_curtabIndex == 0 then
		local itemCount = CheatList_cnEdit:GetText();
		local curItem	= CheatList_tree_array[CheatList_curtabIndex]:GetSelect(0);
		local caption = CheatList_tree_array[CheatList_curtabIndex]:GetItemCaption(curItem);

		if caption ~= nil then
			local classID	= CheatList_tree_array[CheatList_curtabIndex]:GetItemValue(curItem);
			local ItemlvEdit = frame:GetChild("ItemUseGroup"):GetChild("ItemlvEdit");
			ItemlvEdit = tolua.cast(ItemlvEdit, "ui::CEditControl");
			local lv = ItemlvEdit:GetText();

			local msg = '//item '..classID..' '..itemCount;
			if lv ~= "" then
				msg = msg .. " " .. lv;
			end

			ui.Chat(msg);
		end
	elseif CheatList_curtabIndex == 1 then
		local monLevel = CheatList_MonLV:GetText();
		local monCount = CheatList_MonCT:GetText();
		local curItem	= CheatList_tree_array[CheatList_curtabIndex]:GetSelect(0);
		local caption	= CheatList_tree_array[CheatList_curtabIndex]:GetItemCaption(curItem);

		if caption ~= nil then
			local classID	= CheatList_tree_array[CheatList_curtabIndex]:GetItemValue(curItem);
			local msg = '//mon '..classID..' '..monLevel..' '..monCount;
			ui.Chat(msg);
		end
	elseif CheatList_curtabIndex == 2 then
		local curItem	= CheatList_tree_array[CheatList_curtabIndex]:GetSelect(0);
		local caption = CheatList_tree_array[CheatList_curtabIndex]:GetItemCaption(curItem);

		if caption ~= nil then
			local classID	= CheatList_tree_array[CheatList_curtabIndex]:GetItemValue(curItem);
			local map = GetClassString('Map', classID, 'ClassName')
			local defGenX = GetClassNumber('Map', classID, 'DefGenX')
			local defGenY = GetClassNumber('Map', classID, 'DefGenY')
			local defGenZ = GetClassNumber('Map', classID, 'DefGenZ')

			local msg = '//mz ' .. map..' '..tostring(defGenX)..' '..tostring(defGenY)..' '..tostring(defGenZ);
			ui.Chat(msg);
		end


	elseif CheatList_curtabIndex == 3 then

		local isrunscp = IS_EDITING_RUNSCP(frame);
		if isrunscp == 1 then
			CHEATLIST_RUNSCRIPT(frame);
		else
			local ForkName = CheatList_ForkName:GetText();
				local curItem	= CheatList_tree_array[CheatList_curtabIndex]:GetSelect(0);
				local caption = CheatList_tree_array[CheatList_curtabIndex]:GetItemCaption(curItem);

				if caption ~= nil then
					local classID	= CheatList_tree_array[CheatList_curtabIndex]:GetItemValue(curItem);
					local cheat = GetClassString('Cheat', classID, 'Scp');
					if cheat == "None" then
						print("[Log] cheat is [None]! classID : "..classID);
					else
						loadstring(cheat)();
					end
				end
		end
	else
		ui.Chat(ScpArgMsg("Auto_SiSeuTemoLyuLo_inHayeo_ChiTeuLeul_SayongHal_Su_eopSeupNiDa."));
	end
	--ui.CloseFrame('cheatlist');
end

function IS_EDITING_RUNSCP(frame)

	local tnode = CheatList_tree_array[3]:GetLastSelectedNode();
	if tnode == nil then
		return 0;
	end

	local pnode = tnode.pParentNode;
	local runscpnode = CheatList_tree_array[3]:GetRootItem(1);

	if pnode == runscpnode then
		return 1;
	end

	return 0;
end

function CHEATLIST_RUNSCRIPT(frame)

	local tnode = CheatList_tree_array[3]:GetLastSelectedNode();
	local cls = GetClassByType("RunScript", tnode:GetValue());

	local cmd = "//runscp " .. cls.Script;
	for i = 1 ,  max_runscp_factor_cnt do
		local objname = "Runscp_Edit" .. i;
		local eobj = CheatList_othersgroup:GetChild(objname);

		local factorvalue = cls["Factor" .. i];
		if  factorvalue == "None" then
			break;
		else
			local argText = eobj:GetText();
			if argText == "" then
				argText = "None";
			end

			cmd = cmd .. " " .. argText;
		end
	end

	ui.Chat(cmd);

end

function PREVIEW_CHEATLIST_MAP(frame, classID)

	local checkBox = GET_CHILD(CheatList_mzmapgroup, "previewMinimap", "ui::CCheckBox");
	if checkBox:IsChecked() == 0 then
		return;
	end

	local cls = GetClassByType("Map", classID);
	if cls == nil then
		return;
	end

	world.PreloadMinimap(cls.ClassName);
	local mapFrame = ui.GetFrame('showminimap');
	local pic = GET_CHILD(mapFrame, "pic", "ui::CPicture");
	pic:SetImage(cls.ClassName);
	mapFrame:SetTitleName('{s18}{b}'..cls.ClassName);
	mapFrame:ShowWindow(1);
	mapFrame:Invalidate();
	UPDATE_MAP_BY_NAME(mapFrame, cls.ClassName, pic)
    MAKE_MAP_AREA_INFO(mapFrame, cls.ClassName, "{s15}")
end

function CHEATLIST_TREE_CHANGE(frame, obj, argStr, argNum)
	local curItem	= CheatList_tree:GetSelect(0);

	CheatList_curtabIndex	= cheatlist_tab:GetSelectItemIndex();
	if CheatList_curtabIndex == 2 then

		local curItem	= CheatList_tree_array[CheatList_curtabIndex]:GetSelect(0);
		local caption = CheatList_tree_array[CheatList_curtabIndex]:GetItemCaption(curItem);
		if caption ~= nil then
			local classID	= CheatList_tree_array[CheatList_curtabIndex]:GetItemValue(curItem);
			PREVIEW_CHEATLIST_MAP(frame, classID);
		end
	end

	if CheatList_curtabIndex == 3 then
		local isrunscp = IS_EDITING_RUNSCP(frame);

		local gb = frame:GetChild('OthersGroup');
		local forkname = gb:GetChild('ForkName');


		if isrunscp == 1 then

			local tnode = CheatList_tree_array[3]:GetLastSelectedNode();
			local cls = GetClassByType("RunScript", tnode:GetValue());

			for i = 1 ,  max_runscp_factor_cnt do

				local objname = "Runscp_Name" .. i;
				local robj = CheatList_othersgroup:GetChild(objname);
				objname = "Runscp_Edit" .. i;
				local eobj = CheatList_othersgroup:GetChild(objname);


				local factorvalue = cls["Factor" .. i];
				if  factorvalue == "None" then
					robj:ShowWindow(0);
					eobj:ShowWindow(0);
				else
					robj:SetText(factorvalue);
					robj:ShowWindow(1);
					eobj:ShowWindow(1);
					eobj:SetText("");
				end


			end


			--forkname:ShowWindow(0);
		else
			forkname:ShowWindow(1);
		end

		gb:Invalidate();

	end
end

function CREATEITEM_UPDATE_ITEM(frame)

	frame = frame:GetTopParentFrame();
	local itemUseGroup = frame:GetChild("ItemUseGroup");
	local edit = GET_CHILD(itemUseGroup, "ItemSearch", "ui::CEditControl");
	local cap = edit:GetText();
	local capUpper = string.upper(cap)

	local itemTree = CheatList_tree_array[0];
	itemTree:Clear();

	local groupCount = 0;
	local parentItemText = {};

	local clslist, cnt  = GetClassList("Item");
	for i = 0 , cnt - 1 do
		local itemCls = GetClassByIndexFromList(clslist, i);
		local name = dictionary.ReplaceDicIDInCompStr(itemCls.Name);		
		if cap == "" or nil ~= string.find(name, cap) or string.find(string.upper(itemCls.ClassName),capUpper) ~= nil or nil ~= string.find(itemCls.ClassID, cap) then
			local categoryName= itemCls.GroupName;
			local isExist = 0;
			local n = 1;

			for n = 1, groupCount do
				if parentItemText[n] == categoryName then
					isExist = 1;
					break;
				end
			end

			if isExist == 0 then
				groupCount = groupCount + 1;
				parentItemText[groupCount] = categoryName;
				itemTree:Add(categoryName);
			end

			local itemName	= itemCls.Name;
			local value		= itemCls.ClassID;
			local nodeName	= string.format("{@st43b}%s (%d)", itemName, value);
			--local nodeName = itemnam

			local parentItem	= itemTree:FindByCaption(categoryName);
			local curItem 	= itemTree:Add(parentItem, nodeName, value);
		end
	end

	if cap ~= "" then
		itemTree:OpenNodeAll();
		itemTree:SetScrollBarPos(0);
	end
end

function CREATEMONSTER_UPDATE_MONSTER(frame)

	frame = frame:GetTopParentFrame();
	local creatMonGroup = frame:GetChild("CreatMonGroup");
	local edit = GET_CHILD(creatMonGroup, "MonSearch", "ui::CEditControl");
	local cap = edit:GetText();
	local capUpper = string.upper(cap)
	
	local monTree = CheatList_tree_array[1];
	monTree:Clear();

	local parentItemText = {};

	local groupCount = 0;
	local clslist, cnt  = GetClassList("Monster");
	for i = 0 , cnt - 1 do
		local monCls = GetClassByIndexFromList(clslist, i);
		local name = dictionary.ReplaceDicIDInCompStr(monCls.Name);		
		if cap == "" or nil ~= string.find(name, cap) or string.find(string.upper(monCls.ClassName),capUpper) ~= nil or nil ~= string.find(monCls.ClassID, cap) then
			local groupName = monCls.GroupName;
			local isExist = 0;
			for n = 1, groupCount do
				if parentItemText[n] == groupName then
					isExist = 1;
					break;
				end
			end

			if isExist == 0 then
				groupCount = groupCount + 1;
				parentItemText[groupCount] = groupName;
				monTree:Add(groupName);
			end

			local value			= monCls.ClassID;
			local monName		= "{@st43b}" .. monCls.Name .. "(" .. value ..")";
			local parentItem	= monTree:FindByCaption(groupName);
			local curItem		= monTree:Add(parentItem, monName, value);
		end
	end

	if cap ~= "" then
		monTree:OpenNodeAll();
		monTree:SetScrollBarPos(0);
	end

end

function MZLIST_UPDATE_MAP(frame)

	frame = frame:GetTopParentFrame();
	local mzMapGroup = frame:GetChild("MzMapGroup");
	local edit = GET_CHILD(mzMapGroup, "MapSearch", "ui::CEditControl");
	local cap = edit:GetText();
	local capUpper = string.upper(cap)

	CheatList_tree_array[2]:Clear();

	local groupCount = 0;
	local parentItemText = nil;

	local clslist, cnt  = GetClassList("Map");
	for i = 0 , cnt - 1 do
		local mapCls  = GetClassByIndexFromList(clslist, i);
		local type		= mapCls.Type;
		if type ~= 'None' then
			local mapname = dictionary.ReplaceDicIDInCompStr(mapCls.Name);		
			if cap == "" or nil ~= string.find(mapname, cap) or string.find(string.upper(mapCls.ClassName),capUpper) ~= nil or nil ~= string.find(mapCls.ClassID, cap) then
				local itemName	= "{@st43b}" .. mapCls.Name.." : "..mapCls.ClassName;
				local value		= mapCls.ClassID;
				local curItem 	= CheatList_tree_array[2]:Add(itemName, value);
			end
		end
	end

	CheatList_tree_array[2]:OpenNodeAll();
	CheatList_tree_array[2]:SetScrollBarPos(0);
end

function CHEATOTHERS_UPDATE_OTHERS(frame)

	frame = frame:GetTopParentFrame();
	local othersGroup = frame:GetChild("OthersGroup");
	local edit = GET_CHILD(othersGroup, "ForkName", "ui::CEditControl");
	local cap = string.upper(edit:GetText());

	local cheatTree = CheatList_tree_array[3];
	cheatTree:Clear();


	local groupCount = 0;
	local parentItemText = {};

	local cheatname = "~CheatList~"
	groupCount = groupCount + 1;
	parentItemText[groupCount] = cheatname;
	cheatTree:Add(cheatname);

	local parentItem	= cheatTree:FindByCaption(cheatname);


	local clslist, cnt  = GetClassList("Cheat");

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local name = string.upper(dictionary.ReplaceDicIDInCompStr(cls.Name));		
		if cap == "" or nil ~= string.find(name, cap) then
			local curItem 	= cheatTree:Add(parentItem, "{@st43b}" .. cls.Name, cls.ClassID);
		end
	end

	local runscpname = "~RunScript~"
	groupCount = groupCount + 1;
	parentItemText[groupCount] = runscpname;
	cheatTree:Add(runscpname);

	local parentItem	= cheatTree:FindByCaption(runscpname);


	local clslist, cnt  = GetClassList("RunScript");

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local name = string.upper(dictionary.ReplaceDicIDInCompStr(cls.Name));		
		if cap == "" or nil ~= string.find(name, cap) then
			local curItem 	= cheatTree:Add(parentItem, "{@st43b}" .. cls.Name, cls.ClassID);
		end
	end

	if cap ~= "" then
		cheatTree:OpenNodeAll();
		cheatTree:SetScrollBarPos(0);
	end
end

function CHEATLIST_UI_CLOSE(frame, obj, argStr, argNum)
	ui.CloseFrame('cheatlist');
	USECHEAT_ListSortType		= 'Cheat_Open';
end

