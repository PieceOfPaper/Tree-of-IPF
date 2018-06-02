
--[[
function CREATECHAT_ON_INIT(addon)

end

function CREATECHAT_CREATE(addon, frame)

	MAKE_CHECKBOX_COLBOXES(frame);

end

function GET_CTRL_PROP_NAME(ctrl)

	local name = ctrl:GetName();
	local opName = string.sub(name, 5, string.len(name));
	return string.sub(name, 5, string.len(name));
end

function MAKE_CHECKBOX_COLBOXES(frame)

	local BOX_SIZE = 20;
	local childCnt = frame:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = frame:GetChildByIndex(i);
		local name = chld:GetName();
		
		if string.find(name, "sel_") ~= nil then
			
			local opName = GET_CTRL_PROP_NAME(chld);
			local picName = "col_" .. opName;
			if frame:GetChild(picName) == nil then
				local selPic = frame:CreateControl("picture", picName, -30, chld:GetY(), BOX_SIZE, BOX_SIZE);
				tolua.cast(selPic, "ui::CPicture");
				selPic:SetGravity(ui.RIGHT, ui.TOP);
				selPic:SetImage("fullwhite");
				selPic:ClonePicture();
				selPic:FillClonePicture("FFFFFFFF");
				selPic:ShowWindow(1);
				selPic:SetLBtnDownScp("SELECT_CHAT_COLOR");
				selPic:SetLBtnDownArgStr(opName);
			end
			
			local sizeName = "size_" .. opName;
			if frame:GetChild(sizeName) == nil then
				local selEdit = frame:CreateControl("numupdown", sizeName, -58, chld:GetY(), 80, 24);
				tolua.cast(selEdit, "ui::CNumUpDown");
				selEdit:SetGravity(ui.RIGHT, ui.TOP);
				selEdit:SetFontName("white_16_ol");
				selEdit:MakeButtons("btn_numdown", "btn_numup", "editbox_s");
				selEdit:SetMinValue(10);
				selEdit:SetMaxValue(32);
				selEdit:SetNumberValue(16);
				selEdit:ShowWindow(1);
				selEdit:SetIncrValue(2);
				
			
				local selEdit = frame:CreateControl("edit", sizeName, -58, chld:GetY(), 45, 24);
				tolua.cast(selEdit, "ui::CEditControl");
				selEdit:SetGravity(ui.RIGHT, ui.TOP);
				selEdit:SetOffsetXForDraw(10);
				selEdit:SetEnableEditTag(1);
				selEdit:SetFontName("white_16_ol");
				selEdit:SetNumberMode(1);
				selEdit:SetMaxNumber(32);
				selEdit:SetMinNumber(0);
				selEdit:ShowWindow(1);
				selEdit:SetText("16");
				
			end
			
		end
	
	end
	
end

function CHECK_ALL_CATEGORY_CHATPROP(frame, checkBox, argStr, strArg)

	local propName = GET_CTRL_PROP_NAME(checkBox);
	local cls = GetClass("ChatMsg", propName);
	--if cls.AllCategory == "YES" then
		UPDATE_ENABLE_BY_ALL_CATEGORY(frame);
	--end

end

function SET_OPTION_CTRL_ENABLE(ctrl, enable)
	ctrl:ShowWindow(enable);
	ENABLE_CTRL(ctrl, enable);
end

function UPDATE_ENABLE_BY_ALL_CATEGORY(frame)

	local childCnt = frame:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = frame:GetChildByIndex(i);
		local name = chld:GetName();
		
		if string.find(name, "sel_") ~= nil then
			tolua.cast(chld, "ui::CCheckBox");
			local opName = GET_CTRL_PROP_NAME(chld);
			local enable = chld:IsChecked();
			SET_OPTION_CTRL_ENABLE(frame:GetChild("col_" .. opName), enable);
			SET_OPTION_CTRL_ENABLE(frame:GetChild("size_" .. opName), enable);
		end
		
	end

	local clsList, cnt = GetClassList("ChatMsg");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.AllCategory == "YES" then
			local checkBox = frame:GetChild("sel_" .. cls.ClassName);
			if checkBox ~= nil then
				tolua.cast(checkBox, "ui::CCheckBox");
				SET_ENABLE_BY_CATEGORY(frame, cls.Category, checkBox:IsChecked());
			end
		end	
	end
	
	frame:Invalidate();
end

function SET_ENABLE_BY_CATEGORY(frame, category, isChecked)

	local enable = 1;
	if isChecked == 1 then
		enable = 0;
	end
	
	local clsList, cnt = GetClassList("ChatMsg");
	
	local childCnt = frame:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = frame:GetChildByIndex(i);
		local name = chld:GetName();
		
		if string.find(name, "sel_") ~= nil then
			local opName = GET_CTRL_PROP_NAME(chld);
			local cls = GetClassByNameFromList(clsList, opName);
			if cls.AllCategory == "NO" and cls.Category == category then
				ENABLE_CTRL(chld, enable);
				if isChecked == 1 then
					SET_OPTION_CTRL_ENABLE(frame:GetChild("col_" .. opName), 0);
					SET_OPTION_CTRL_ENABLE(frame:GetChild("size_" .. opName), 0);
				end
			end			
		end
	end

end

function EXEC_SET_COLOR(frameName, clsName)

	local selCol = GET_SELECTED_COL();
	local frame = ui.GetFrame(frameName);
	local chl = GET_CHILD(frame, "col_" .. clsName, "ui::CPicture");
	chl:FillClonePicture(selCol);

end

function SELECT_CHAT_COLOR(frame, pic, str, num)

	local strScp = string.format("EXEC_SET_COLOR(\"%s\", \"%s\" )", frame:GetName(), str);
	
	tolua.cast(pic, "ui::CPicture");
	local curColor = pic:GetPixelColor(1, 1);
	
	local x, y = GET_GLOBAL_XY(pic);
	OPEN_COLORSELECT_DLG(strScp, curColor, x + 50, y - 15);

end

function SET_CHAT_NEW(chatnew, frameName, isRename)

	local useBtn = chatnew:GetChild('makeChat');
	useBtn:SetLBtnUpArgStr(frameName);
	useBtn:SetLBtnUpArgNum(isRename);
	chatnew:ShowWindow(1);
	INIT_CREATE_CHAT(chatnew, isRename);
	
	local fromFrame = ui.GetFrame(frameName);
	local x, y, w, h = GETXYWH(fromFrame);
	
	chatnew:MoveIntoClientRegion(x + w + 10, y - h / 2);
	ui.SetTopMostFrame(chatnew);
	
end

function INIT_CREATE_CHAT(frame, isRename)

	UNCHECK_ALL_CHAT_MAKE(frame);
	
	local tabTitle = GET_CHILD(frame, "tabTitle", "ui::CEditControl");

	local useBtn = frame:GetChild('makeChat');
	local isRename = useBtn:GetLBtnUpArgNum();

	if isRename == 0 then
		tabTitle:SetTempText(ScpArgMsg("Auto_iLeum_ipLyeog"));
		return;
	end

	local targetFrame = ui.GetFrame(useBtn:GetLBtnUpArgStr());
	local chatbox = GET_CHILD(targetFrame, "chatbox", "ui::CTabControl");
	tabTitle:SetText( chatbox:GetSelectItemName() );

	local curIndex = chatbox:GetSelectItemIndex();	
	local list = ui.GetChatProps(targetFrame:GetName(), curIndex);
	
	local clsList = GetClassList("ChatMsg");
	
	local index = list:Head();
	while 1 do
		if index == list:InvalidIndex() then
			break;
		end
		
		local clsID = list:Key(index);
		local clsName = GetClassByTypeFromList(clsList, clsID).ClassName;
		
		local prop = list:PtrAt(index);
		local color = GetStringColor(prop.color);

		local chld = GET_CHILD(frame, "sel_" .. clsName, "ui::CCheckBox");
		chld:SetCheck(prop:IsUse());
		
		local colPic = GET_CHILD(frame, "col_" .. clsName, "ui::CPicture");
		colPic:FillClonePicture(color);
		
		local sizeCtrl = GET_CHILD(frame, "size_" .. clsName, "ui::CNumUpDown");
		sizeCtrl:SetNumberValue(prop:GetSize());

		index = list:Next(index);
	end
	
	UPDATE_ENABLE_BY_ALL_CATEGORY(frame);
	
end

function UNCHECK_ALL_CHAT_MAKE(frame)

	local childCnt = frame:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = frame:GetChildByIndex(i);
		local name = chld:GetName();
		
		if string.find(name, "sel_") ~= nil then
			tolua.cast(chld, "ui::CCheckBox");
			chld:SetCheck(0);
		end
		
		if string.find(name, "col_") ~= nil then
			tolua.cast(chld, "ui::CPicture");
			chld:FillClonePicture("FFFFFFFF");
		end
	
	end
	
end

function EXEC_MAKE_CHAT(frame, ctrl)

	local makeChat = GET_CHILD(frame, "makeChat", "ui::CButton");
	local targetFrameName = makeChat:GetLBtnUpArgStr();
	local isRename = makeChat:GetLBtnUpArgNum();

	local clsList = GetClassList("ChatMsg");

	local childCnt = frame:GetChildCount();
		
	local checkCnt = 0;
	local addStr = "";
	for i = 0 , childCnt - 1 do
		local chld = frame:GetChildByIndex(i);
		local name = chld:GetName();
		
		if string.find(name, "sel_") ~= nil then
			tolua.cast(chld, "ui::CCheckBox");
			local isUse = chld:IsChecked();
			checkCnt = checkCnt + isUse;

			local opName = string.sub(name, 5, string.len(name));
			local colPic = GET_CHILD(frame, "col_" .. opName, "ui::CPicture");
			local curColor = colPic:GetPixelColor(1, 1);
			local sizeCtrl = GET_CHILD(frame, "size_" .. opName, "ui::CNumUpDown");
			
			local colorTxt = "#" .. curColor;
			local selSize = math.max(10, sizeCtrl:GetNumber());
			local sizeTxt = isUse * 100 + selSize;
						
			addStr = addStr .. opName .. " " .. colorTxt .. " " .. sizeTxt .. " " ;
			
		end
	
	end
	
	if checkCnt == 0 then
		ui.MsgBox(ScpArgMsg("Auto_JeogeoDo_1KaeLeul_SeonTaegHaeJuSeyo"));
		return;
	end
	
	local tabTitle = GET_CHILD(frame, "tabTitle", "ui::CEditControl");
	local title = tabTitle:GetText();
	if title == "" then
		if isRename == 1 then
			ui.DeleteChat(targetFrameName);
			frame:ShowWindow(0);
		else
			ui.MsgBox(ScpArgMsg("InputTitlePlease"));
		end
		return;
	end
	
	--local targetFrame = ui.GetFrame(useBtn:GetLBtnUpArgStr());
	--local chatbox = GET_CHILD(targetFrame, "chatbox", "ui::CTabControl");
	--tabTitle:SetText( chatbox:GetSelectItemName() );
	
	ui.CreateNewChat(targetFrameName, title, addStr, isRename);
	frame:ShowWindow(0);

end

function CLOSE_CREATECHAT(frame)

	ui.CloseFrame("selectcolor");

end



]]