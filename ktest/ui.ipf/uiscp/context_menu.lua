---- context_menu.lua


function MONSTER_CONTEXT(handle, type)
	if 1 == IsMyPcGM() and keyboard.IsKeyPressed("LCTRL") == 1 then
		POPUP_MONSTER_CONTEXT(handle, type);
		return;
	end

	if session.IsFurniture(handle) == true then
		POPUP_FURNITURE_CONTEXT(handle, type)
	end
end

function POPUP_MONSTER_CONTEXT(handle, type)

	if 1 == session.IsGM() then
		local cls = GetClassByType("Monster", type);
		local viewName = string.format("%s (%d)", cls.Name, handle);
		local context = ui.CreateContextMenu("MONSTER_CONTEXT", viewName, 0, 0, 100, 100);
		local strscp = string.format("EXEC_IES_MANAGE(\"%s\", %d)", "Monster", type);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_yoSoKeomSa"), strscp);

		strscp = string.format("EXEC_MON_BASIC_EDIT(%d)", type);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_KiBonSogSeongKeomSa"), strscp);
	
		strscp = string.format("EXEC_MONSKL_MANAGER(%d, %d)", type, handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_SayongSeuKilKeomSa"), strscp);
	
		strscp = string.format("SHOW_ANI_LIST(%d, %d)", type, handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_aeNiLiSeuTeu"), strscp);
	
		strscp = string.format("ui.Chat(\"//runscp TEST_BTREE %d\")", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_BTREEBoKi"), strscp);
	
		strscp = string.format("ui.Chat(\"//runscp TEST_SERVPOS %d\")", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_SeoBeowiChiBoKi"), strscp);
	
		strscp = string.format("ui.Chat(\"//killmon %d\")", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_JeKeo"), strscp);
	
		strscp = string.format("debug.TestE(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_NodeBoKi"), strscp);

		strscp = string.format("debug.CheckModelFilePath(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_XACTegSeuChyeoKyeongLo"), strscp);

		strscp = string.format("ETC_TEST(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_KiTaTeSeuTeu"), strscp);

		strscp = string.format("debug.TestShowBoundingBox(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}BaunDingBagSeuBoKi{/}"), strscp);
		
		strscp = string.format("SCR_NPC_DIALOG_EDIT(%d, %d)", handle, type);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_{@st42b}NPCDaeSa_SuJeong{/}"), strscp);

		ui.OpenContextMenu(context);
	end
end

function POPUP_FURNITURE_CONTEXT(handle, type)
	if ui.IsCursorOnUI() == true then
		return;
	end

	if housing.IsEditMode() == false or housing.IsVisibleContextMenu() == false then
		return;
	end

	local monsterClass = GetClassByType("Monster", type);
	if monsterClass == nil then
		return;
	end

	local furnitureClass = GetClass("Housing_Furniture", monsterClass.ClassName);
	if furnitureClass == nil then
		return;
	end
	
	local viewName = string.format("%s", furnitureClass.Name);
	local context = ui.CreateContextMenu("Housing_Furniture_Context", viewName, 0, 0, 50, 50);

	local strscp = string.format("ON_HOUSING_EDITMODE_FURNITURE_MOVE(%d)", handle);
	ui.AddContextMenuItem(context, ScpArgMsg("Housing_Context_Furniture_Move"), strscp);
	
	local strscp = string.format("ON_HOUSING_EDITMODE_FURNITURE_REMOVE(%d)", handle);
	ui.AddContextMenuItem(context, ScpArgMsg("Housing_Context_Furniture_Remove"), strscp);
	
	ui.OpenContextMenu(context);
end

function ETC_TEST(handle)
	local info = info.GetDialogInfo(handle);
	print(info:GetDialog());
	print(info:GetEnter());
	print(info:GetLeave());
end

function SCR_NPC_DIALOG_EDIT(handle, type)
    local pc = GetMyPCObject();
    local gentype = world.GetActor(handle):GetNPCStateType()
    local genList = SCR_GET_XML_IES('GenType_'..GetZoneName(pc), 'GenType', gentype)
    local funcNameList = ""
    
    for i = 1, #genList do
        local className = GetClassByType('Monster', type).ClassName
        if genList[i].ClassType == className then
            if genList[i].Dialog ~= "" and genList[i].Dialog ~= "None" then
                funcNameList = genList[i].Dialog
            end
            
            if genList[i].Enter ~= "" and genList[i].Enter ~= "None" then
                funcNameList = funcNameList..'/'..genList[i].Enter
            end
            
            if genList[i].Leave ~= "" and genList[i].Leave ~= "None" then
                funcNameList = funcNameList..'/'..genList[i].Leave
            end
            
            break
        end
    end
    
--    local quest_ClassName = GetClassString('DialogText', cls.ClassID, 'ClassName')
    
    local npcdocument = io.open('..\\release\\questauto\\InGameEdit_NPCDialog.txt','w')
    npcdocument:write(funcNameList)
    io.close(npcdocument)

    local path = debug.GetR1Path();
    path = path .. "questauto\\QuestAutoTool_v1.exe";

	debug.ShellExecute(path);
end