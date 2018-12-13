function LOGINUI_TITLE_ON_INIT(addon, frame)
	login.LoadServerList();

	TOGGLE_SINGLE_MODE_UI(frame);
		
	local view1 = GET_CHILD(frame, "login_img", "ui::CPicture")
	if view1 ~= nil then
        view1:ShowWindow(0)
    end
    
    local view2 = GET_CHILD(frame, "login_img2", "ui::CPicture")
    if view2 ~= nil then
        view2:ShowWindow(0)
    end

    local view3 = GET_CHILD(frame, "login_img3", "ui::CPicture")
    if view3 ~= nil then
        view3:ShowWindow(0)
    end
    
    local rand = IMCRandom(1,3)
    if rand == 0 then
        view1:ShowWindow(1)
    elseif rand == 0 then
        view2:ShowWindow(1)
    elseif rand >= 1 then
        view3:ShowWindow(1)
    end
--	ENABLE_ANIMATE_BACKGROUND_ILLUSTRATION();
end

function TOGGLE_SINGLE_MODE_UI(frame)

--[[
	frame = frame:GetTopParentFrame();
	local fr = frame:GetChild("loginserverlist");
	local ctrl = fr:GetChild("t_singleMaps");
	local swCmd = 1;
	if ctrl:IsVisible() == 1 then
		swCmd = 0;
	end

	ctrl:ShowWindow(swCmd);
	ctrl = fr:GetChild("l_singleMaps");
	ctrl:ShowWindow(swCmd);

	if swCmd == 1 then
		local mapList = GET_CHILD(fr, "l_singleMaps", "ui::CListBox");
		mapList:ClearItemAll();
		local clsList, cnt = GetClassList("Map");
		for i = 1 , cnt do 
			local mapCls = GetClassByIndexFromList(clsList, i - 1);
			mapList:AddItem(mapCls.Name, mapCls.ClassID);
		end
	end
	]]

	local pic = frame:GetChild('r1_logo');
	if nil ~= pic then
		pic:SetEventScript(ui.LBUTTONDOWN, 'LOGIN_TITLE_UIEFFECT_LBTNDOWN');
	end

	pic = frame:GetChild('mousemove_uieffect');
	if pic ~= nil then
		pic:SetEventScript(ui.MOUSEMOVE, 'LOGIN_TITLE_UIEFFECT_MOUESMOVE');
	end
end

function LOGIN_TITLE_UIEFFECT_LBTNDOWN()
end
function LOGIN_TITLE_UIEFFECT_MOUESMOVE()	
end


g_replayPerfRecordCheckBox = nil

function TOGGLE_REPLAY_BUTTON()
    local frame = ui.GetFrame('barrack_exit');
    local btn = frame:CreateOrGetControl("button", "REPLAY_BUTTON", 160, 55, ui.RIGHT, ui.CENTER_VERT, 0, 18, 390, 0);
    btn:SetSkinName("test_gray_button");
    btn:SetEventScript(ui.LBUTTONDOWN, 'TOGGLE_REPLAY')
    btn:EnableHitTest(1);
    btn:SetText("{@st41b}Replay{/}")
end

function TOGGLE_REPLAY(frame)
	local recordPerfCheck = GET_CHILD_RECURSIVELY(frame, "replayPerfRecord");
	g_replayPerfRecordCheckBox = recordPerfCheck;

	OPEN_FILE_FIND("replay", "EXEC_LOAD_REPLAY", 0);
end

function EXEC_LOAD_REPLAY(fileName)
	flagRecordPerf = 1;
	if g_replayPerfRecordCheckBox ~= nil then
		flagRecordPerf = g_replayPerfRecordCheckBox:IsChecked();
	end

	app.StartReplay(fileName, flagRecordPerf == 1);	

end

function GO_TO_SINGLEMODE(frame)
	frame = frame:GetTopParentFrame();
	local fr = frame:GetChild("loginserverlist");
	local mapList = GET_CHILD(fr, "l_singleMaps", "ui::CListBox");
	local mapID = mapList:GetSelItemValue();
	app.ClientSingleMode(mapID);
end

function TITLE_SHOW_SPINE_PIC(frame, name, isShow)
	local child = frame:GetChild(name);
	child:ShowWindow(isShow);
end

--function ENABLE_ANIMATE_BACKGROUND_ILLUSTRATION()
--	local frame = ui.GetFrame("loginui_title");
--
--	local isEnableSpine = config.GetXMLConfig("EnableAnimateBackgroundIllustration");
----	if isEnableSpine == 1 then
----		TITLE_SHOW_SPINE_PIC(frame, "Chuseok_Background", 1);
----		TITLE_SHOW_SPINE_PIC(frame, "Chuseok_NPC", 1);
----
----		
----		TITLE_SHOW_SPINE_PIC(frame, "login_img", 0);
----	else
--		TITLE_SHOW_SPINE_PIC(frame, "Chuseok_Background", 0);
--		TITLE_SHOW_SPINE_PIC(frame, "Chuseok_NPC", 0);
--
--
--		TITLE_SHOW_SPINE_PIC(frame, "login_img", 1);
----	end
--end